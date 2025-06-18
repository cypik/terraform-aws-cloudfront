# Terraform-aws-cloudfront_distribution

# Terraform Aws_cloudfront_distribution Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Example](#Example)
- [Author](#Author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform module creates an AWS cloudfront_distribution Service (cloudfront_distribution) along with additional configuration options.
## Usage
To use this module, you can include it in your Terraform configuration. Here's an example of how to use it:

## Example

```hcl
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
  acm_certificate_arn    = module.acm.arn
}
```

```hcl
module "cdn" {
  source = "./../../"

  name                   = "${local.name}-secure"
  environment            = local.environment
  enabled_bucket         = true
  compress               = false
  aliases                = ["Cypik.com"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
  trusted_signers        = ["self"]
  public_key_enable      = true
  public_key             = "./cdn.pem"
}
```

```hcl
module "cdn" {
  source = "./../../"

  name                   = "${local.name}-domain"
  environment            = local.environment
  custom_domain          = true
  compress               = false
  aliases                = ["cypik.com"]
  domain_name            = "cypik.com"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}
```

## Example
For detailed examples on how to use this module, please refer to the Examples directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the LICENSE file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/aws | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_distribution.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.s3_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_public_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | Existing ACM Certificate ARN. | `string` | `""` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront. | `list(string)` | `[]` | no |
| <a name="input_allowed_methods"></a> [allowed\_methods](#input\_allowed\_methods) | List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront. | `list(string)` | <pre>[<br>  "DELETE",<br>  "GET",<br>  "HEAD",<br>  "OPTIONS",<br>  "PATCH",<br>  "POST",<br>  "PUT"<br>]</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | A unique identifier for the origin. | `string` | `""` | no |
| <a name="input_cached_methods"></a> [cached\_methods](#input\_cached\_methods) | List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD). | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_cdn_enabled"></a> [cdn\_enabled](#input\_cdn\_enabled) | Select Enabled if you want to created CloudFront. | `bool` | `true` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Comment for the origin access identity. | `string` | `"Managed by Cypik"` | no |
| <a name="input_compress"></a> [compress](#input\_compress) | Compress content for web requests that include Accept-Encoding: gzip in the request header. | `bool` | `false` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | If cdn create with custom Domain. | `bool` | `false` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Object that CloudFront return when requests the root URL. | `string` | `"index.html"` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `60` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The DNS domain name of your custom origin (e.g. Cypik.com). | `string` | `""` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Select Enabled if you want CloudFront to begin processing requests as soon as the distribution is created, or select Disabled if you do not want CloudFront to begin processing requests after the distribution is created. | `bool` | `true` | no |
| <a name="input_enabled_bucket"></a> [enabled\_bucket](#input\_enabled\_bucket) | If cdn create with s3 bucket. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_error_caching_min_ttl"></a> [error\_caching\_min\_ttl](#input\_error\_caching\_min\_ttl) | the value of errro caching min ttl | `string` | `"10"` | no |
| <a name="input_error_code"></a> [error\_code](#input\_error\_code) | List of forwarded cookie names. | `string` | `"403"` | no |
| <a name="input_forward_cookies"></a> [forward\_cookies](#input\_forward\_cookies) | Time in seconds that browser can cache the response for S3 bucket. | `string` | `"none"` | no |
| <a name="input_forward_cookies_whitelisted_names"></a> [forward\_cookies\_whitelisted\_names](#input\_forward\_cookies\_whitelisted\_names) | List of forwarded cookie names. | `list(any)` | `[]` | no |
| <a name="input_forward_header_values"></a> [forward\_header\_values](#input\_forward\_header\_values) | A list of whitelisted header values to forward to the origin. | `list(string)` | <pre>[<br>  "Access-Control-Request-Headers",<br>  "Access-Control-Request-Method",<br>  "Origin"<br>]</pre> | no |
| <a name="input_forward_query_string"></a> [forward\_query\_string](#input\_forward\_query\_string) | Forward query strings to the origin that is associated with this cache behavior. | `bool` | `false` | no |
| <a name="input_geo_restriction_locations"></a> [geo\_restriction\_locations](#input\_geo\_restriction\_locations) | List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist). | `list(string)` | `[]` | no |
| <a name="input_geo_restriction_type"></a> [geo\_restriction\_type](#input\_geo\_restriction\_type) | Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`. | `string` | `"none"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | State of CloudFront IPv6. | `bool` | `true` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com'. | `string` | `"info@cypik.com"` | no |
| <a name="input_max_ttl"></a> [max\_ttl](#input\_max\_ttl) | Maximum amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `31536000` | no |
| <a name="input_min_ttl"></a> [min\_ttl](#input\_min\_ttl) | Minimum amount of time that you want objects to stay in CloudFront caches. | `number` | `0` | no |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | Cloudfront TLS minimum protocol version. | `string` | `"TLSv1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_origin_http_port"></a> [origin\_http\_port](#input\_origin\_http\_port) | The HTTP port the custom origin listens on. | `number` | `80` | no |
| <a name="input_origin_https_port"></a> [origin\_https\_port](#input\_origin\_https\_port) | The HTTPS port the custom origin listens on. | `number` | `443` | no |
| <a name="input_origin_keepalive_timeout"></a> [origin\_keepalive\_timeout](#input\_origin\_keepalive\_timeout) | The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase. | `number` | `60` | no |
| <a name="input_origin_path"></a> [origin\_path](#input\_origin\_path) | An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path. | `string` | `""` | no |
| <a name="input_origin_protocol_policy"></a> [origin\_protocol\_policy](#input\_origin\_protocol\_policy) | The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer. | `string` | `"match-viewer"` | no |
| <a name="input_origin_read_timeout"></a> [origin\_read\_timeout](#input\_origin\_read\_timeout) | The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase. | `number` | `60` | no |
| <a name="input_origin_ssl_protocols"></a> [origin\_ssl\_protocols](#input\_origin\_ssl\_protocols) | The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. | `list(string)` | <pre>[<br>  "TLSv1",<br>  "TLSv1.1",<br>  "TLSv1.2"<br>]</pre> | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. | `string` | `"PriceClass_100"` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | It encoded public key that you want to add to CloudFront to use with features like field-level encryption. | `string` | `""` | no |
| <a name="input_public_key_enable"></a> [public\_key\_enable](#input\_public\_key\_enable) | Public key enable or disable. | `bool` | `false` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/Cypik/terraform-aws-cloudfront-cdn"` | no |
| <a name="input_response_code"></a> [response\_code](#input\_response\_code) | page not found code | `string` | `"404"` | no |
| <a name="input_response_page_path"></a> [response\_page\_path](#input\_response\_page\_path) | The path of the custom error page (for example, /custom\_404.html). | `string` | `"/index.html"` | no |
| <a name="input_smooth_streaming"></a> [smooth\_streaming](#input\_smooth\_streaming) | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. | `bool` | `false` | no |
| <a name="input_ssl_support_method"></a> [ssl\_support\_method](#input\_ssl\_support\_method) | Specifies how you want CloudFront to serve HTTPS requests. One of `vip` or `sni-only`. | `string` | `"sni-only"` | no |
| <a name="input_trusted_signers"></a> [trusted\_signers](#input\_trusted\_signers) | The AWS accounts, if any, that you want to allow to create signed URLs for private content. | `list(string)` | `[]` | no |
| <a name="input_viewer_protocol_policy"></a> [viewer\_protocol\_policy](#input\_viewer\_protocol\_policy) | Allow-all, redirect-to-https. | `string` | `""` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | Web ACL ID that can be attached to the Cloudfront distribution. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN (Amazon Resource Name) for the distribution. |
| <a name="output_bucket_distribution_id"></a> [bucket\_distribution\_id](#output\_bucket\_distribution\_id) | n/a |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The domain name corresponding to the distribution. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the distribution's information. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| <a name="output_id"></a> [id](#output\_id) | The identifier for the distribution. |
| <a name="output_pubkey_etag"></a> [pubkey\_etag](#output\_pubkey\_etag) | The current version of the public key. |
| <a name="output_pubkey_id"></a> [pubkey\_id](#output\_pubkey\_id) | The identifier for the public key. |
| <a name="output_status"></a> [status](#output\_status) | The current status of the distribution. |
| <a name="output_tags"></a> [tags](#output\_tags) | A mapping of tags to assign to the resource. |
<!-- END_TF_DOCS -->