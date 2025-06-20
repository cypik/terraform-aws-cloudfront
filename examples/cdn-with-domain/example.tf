provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  name        = "cloudfront"
  environment = "test"
}

module "acm" {
  source                 = "cypik/acm/aws"
  version                = "1.0.2"
  name                   = "${local.name}-certificate"
  environment            = local.environment
  domain_name            = "cypik.com"
  validation_method      = "EMAIL"
  validate_certificate   = true
  enable_aws_certificate = true
}

module "cdn" {
  source = "./../../"

  name                   = "${local.name}-domain"
  environment            = local.environment
  custom_domain          = true
  compress               = false
  aliases                = ["Cypik.com"]
  domain_name            = "ec2-34-232-63-2.compute-1.amazonaws.com"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}


