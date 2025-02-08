resource "aws_wafv2_web_acl" "default" {
  name        = "${var.general_config["project"]}-${var.general_config["env"]}-acl"
  description = "${var.general_config["project"]}-${var.general_config["env"]}-acl"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Rate-based rule
  rule {
    name     = "AWSRateBasedRule"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit                 = var.rate_based_limit
        aggregate_key_type    = "IP"
        evaluation_window_sec = 60

        scope_down_statement {
          or_statement {
            statement {
              regex_match_statement {
                field_to_match {
                  uri_path {}
                }
                regex_string = "/login*"
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/"
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  # Managed rule groups
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-acl"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "TerraformWebACLMetric"
    sampled_requests_enabled   = true
  }
}

## Associate WAF and ALB
resource "aws_wafv2_web_acl_association" "default" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}
