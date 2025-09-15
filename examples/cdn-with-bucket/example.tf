provider "aws" {
  region = local.region
}


locals {
  region      = "ap-south-1"
  name        = "cloudfront"
  environment = "test"
}

module "s3_bucket" {
  source                  = "cypik/s3/aws"
  version                 = "1.0.2"
  name                    = "${local.name}-basic-bucket-cdn"
  environment             = local.environment
  versioning              = false
  acl                     = "private"
  bucket_policy           = true
  aws_iam_policy_document = data.aws_iam_policy_document.s3_policy.json
}

# 🔹 Get AWS Account ID automatically
data "aws_caller_identity" "current" {}

data "aws_cloudfront_distribution" "distribution" {
  id = module.cdn.bucket_distribution_id[0]
}

data "aws_iam_policy_document" "s3_policy" {
  version = "2008-10-17"

  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${module.s3_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${data.aws_cloudfront_distribution.distribution.id}"
      ]
    }
  }
}




module "cdn" {
  source = "./../../"

  name                   = "${local.name}-basic"
  environment            = local.environment
  enabled_bucket         = true
  compress               = false
  aliases                = ["Cypik.com"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
}
