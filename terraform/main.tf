module "create_instance" {
  source = "./modules/create_instance"

  app_key           = var.app_key
  app_secret        = var.app_secret
  cons_key          = var.cons_key
  instance_hostname = var.a_instance_hostname
  instance_flavour  = var.b_instance_flavour
}

module "remote_exec" {
  source            = "./modules/remote_exec"
  instance_hostname = var.a_instance_hostname
  vm_ip             = module.create_instance.vm_ipv4_address
  private_key       = module.create_instance.private_key
  ssh_port          = module.create_instance.ssh_port
}



output "instance_ip" {
  value       = "IP ${module.create_instance.vm_ipv4_address}, SSH port is ${module.create_instance.ssh_port} and SSH Private key name is ${module.create_instance.ssh_key_name}"
  description = "Use this IP for SSH access"
}

