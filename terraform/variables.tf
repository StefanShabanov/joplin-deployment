variable "a_instance_hostname" {
  description = "Instance hostname"
}

variable "b_instance_flavour" {
  description = "Enter the desired instance flavour:"
}

variable "app_key" {
  description = "OpenStack API app key"
  sensitive   = true
}
variable "app_secret" {
  description = "OpenStack API app secret key"
  sensitive   = true
}
variable "cons_key" {
  description = "OpenStack API app consumer key"
  sensitive   = true
}

