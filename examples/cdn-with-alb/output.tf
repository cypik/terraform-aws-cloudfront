# Output the CloudFront distribution domain name
output "cloudfront_domain" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cdn.domain_name
}

# Output the ALB DNS name
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}

# Output the EC2 instance public IP
output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Output the public subnet IDs
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.public_subnets.public_subnet_id
}

# Output the EC2 instance ID
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id[0]
}

output "domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cdn.domain_name

}

output "hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  value       = module.cdn.hosted_zone_id
}
