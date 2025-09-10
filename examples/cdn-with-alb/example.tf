provider "aws" {
  region = local.region
}

locals {
  region      = "ap-south-1"
  name        = "cloudfront"
  environment = "test"
}

module "vpc" {
  source      = "cypik/vpc/aws"
  version     = "1.0.3"
  name        = "${local.name}-vpc"
  environment = local.environment
  cidr_block  = "10.0.0.0/16"
}

module "public_subnets" {
  source             = "cypik/subnet/aws"
  version            = "1.0.5"
  name               = "${local.name}-public-subnet"
  environment        = local.environment
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
}

module "iam-role" {
  source             = "cypik/iam-role/aws"
  version            = "1.0.3"
  name               = "${local.name}-ec2-role"
  environment        = local.environment
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  policy_enabled     = true
  policy             = data.aws_iam_policy_document.ec2_policy.json
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "ec2" {
  source            = "cypik/ec2/aws"
  version           = "1.0.5"
  name              = "${local.name}-backend"
  environment       = local.environment
  vpc_id            = module.vpc.vpc_id
  ssh_allowed_ip    = ["0.0.0.0/0"]
  ssh_allowed_ports = [22]

  # Allow ingress ports for web traffic
  allow_ingress_port_ip = {
    "80"  = "0.0.0.0/0"
    "443" = "0.0.0.0/0"
  }

  # Instance configuration
  instance_count = 1
  ami            = "ami-0f5ee92e2d63afc18"
  instance_type  = "t3.micro"

  # Networking
  subnet_ids = tolist(module.public_subnets.public_subnet_id)

  # IAM
  iam_instance_profile = module.iam-role.name

  # Root Volume
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 20
      delete_on_termination = true
    }
  ]

  # EBS Volume
  ebs_volume_enabled = true
  ebs_volume_type    = "gp2"
  ebs_volume_size    = 30

  # Public IP
  associate_public_ip_address = true


}

module "alb" {
  source                     = "cypik/lb/aws"
  version                    = "1.0.5"
  name                       = "${local.name}-alb"
  environment                = local.environment
  enable                     = true
  internal                   = false
  load_balancer_type         = "application"
  instance_count             = 1
  subnets                    = module.public_subnets.public_subnet_id
  target_id                  = [module.ec2.instance_id[0]]
  vpc_id                     = module.vpc.vpc_id
  allowed_ip                 = ["0.0.0.0/0"] # Allow from anywhere (CloudFront will access it)
  allowed_ports              = [80, 443]     # Allow HTTP and HTTPS
  enable_deletion_protection = false
  with_target_group          = true
  https_enabled              = false
  http_enabled               = true
  https_port                 = 443
  listener_type              = "forward"
  target_group_port          = 80
  http_listener_type         = "forward"

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]
}


module "cdn" {
  source = "./../../"

  name                   = "${local.name}-distribution"
  environment            = local.environment
  cdn_enabled            = true
  custom_domain          = true
  enabled_bucket         = false
  compress               = true
  aliases                = ["taj9339.xyz", "www.taj9339.xyz"]
  acm_certificate_arn    = ""
  domain_name            = module.alb.dns_name
  origin_http_port       = 80
  origin_https_port      = 443
  origin_protocol_policy = "http-only" # Change to http-only since ALB uses HTTP
  origin_ssl_protocols   = ["TLSv1.2"]
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  cached_methods         = ["GET", "HEAD"]
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400
}

