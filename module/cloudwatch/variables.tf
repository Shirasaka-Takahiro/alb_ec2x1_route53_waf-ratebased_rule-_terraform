variable "general_config" {
  type = map(any)
}
variable "cloudwatch_alarms" {
  type = map(object({
    project                 = string
    env                     = string
    cwa_metric_name         = string
    cwa_statistic           = string
    cwa_period              = number
    cwa_threshold           = number
    cwa_comparison_operator = string
    cwa_evaluation_periods  = number
    cwa_actions             = bool
    sns_topic_arn           = string
    identifier = string
  }))
}