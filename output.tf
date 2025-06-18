# Module      : CLOUDFRONT DISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
output "id" {
  value = var.cdn_enabled ? concat(
    aws_cloudfront_distribution.bucket[*].id,
    aws_cloudfront_distribution.domain[*].id
  )[0] : ""
  description = "The identifier for the distribution."
}

output "arn" {
  value = var.cdn_enabled ? concat(
    aws_cloudfront_distribution.bucket[*].arn,
    aws_cloudfront_distribution.domain[*].arn
  )[0] : ""
  description = "The ARN (Amazon Resource Name) for the distribution."
}

output "status" {
  value = var.cdn_enabled ? concat(
    aws_cloudfront_distribution.bucket[*].status,
    aws_cloudfront_distribution.domain[*].status
  )[0] : ""
  description = "The current status of the distribution."
}

output "domain_name" {
  value = var.cdn_enabled ? concat(
    aws_cloudfront_distribution.bucket[*].domain_name,
    aws_cloudfront_distribution.domain[*].domain_name
  )[0] : ""
  description = "The domain name corresponding to the distribution."
}

output "etag" {
  value = var.cdn_enabled ? concat(
    aws_cloudfront_distribution.bucket[*].etag,
    aws_cloudfront_distribution.domain[*].etag
  )[0] : ""
  description = "The current version of the distribution's information."
}
output "hosted_zone_id" {
  value = var.cdn_enabled ? concat(
    aws_cloudfront_distribution.bucket[*].hosted_zone_id,
    aws_cloudfront_distribution.domain[*].hosted_zone_id
  )[0] : ""
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
}

output "pubkey_id" {
  value = concat(
    aws_cloudfront_public_key.default[*].id
  )
  description = "The identifier for the public key."
}

output "pubkey_etag" {
  value = concat(
    aws_cloudfront_public_key.default[*].etag
  )
  description = "The current version of the public key."
}


output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}



output "bucket_distribution_id" {
  value = aws_cloudfront_distribution.bucket[*].id
}
