

variable "app_key" {
  description = "OpenStack API app key"
  sensitive = true
}
variable "app_secret" {
  description = "OpenStack API app secret key"
  sensitive = true
}
variable "cons_key" {
  description = "OpenStack API app consumer key"
  sensitive = true
}

variable "instance_flavour" {
  description = "Hostname for the instance"
}

variable "instance_hostname" {
  description = "Instance hostname"
}

variable "ssh_port" {
  description = "Change this value if you want SSH default port (22) to be changed to uncommon one"
  default     = 22
}