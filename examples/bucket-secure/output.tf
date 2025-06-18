output "arn" {
  value       = module.cdn[*].arn
  description = "ARN of AWS CloudFront distribution."
}

output "tags" {
  value       = module.cdn.tags
  description = "A mapping of tags to assign to the CDN."
}


#output "oai_iam_arn" {
#  value = module.cdn.oai_iam_arn
#}

output "bucket_distribution_id" {
  value = module.cdn.bucket_distribution_id
}