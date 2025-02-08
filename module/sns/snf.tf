##SNS Topic
resource "aws_sns_topic" "default_topic" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-${var.topic_name}"
}

##SNS Subscription
resource "aws_sns_topic_subscription" "default_topic_subscription" {
  for_each  = { for endpoint in var.sns_email : endpoint => endpoint }
  topic_arn = aws_sns_topic.default_topic.arn
  protocol  = "email"
  endpoint  = each.value
}