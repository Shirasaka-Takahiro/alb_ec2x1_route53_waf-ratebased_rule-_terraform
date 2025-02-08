variable "general_config" {
  type = map(any)
}
variable "topic_name" {}
variable "sns_email" {
  type = list(string)
}