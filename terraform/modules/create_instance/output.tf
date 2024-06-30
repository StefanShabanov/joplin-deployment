output "keypair_name" {
  value       = openstack_compute_keypair_v2.ssh_keypair.name
  sensitive   = true
  description = "Outputs the name of the SSH keypair"
}

output "private_key" {
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
  description = "Outputs the private key from the SSH keypair"
}

output "vm_ipv4_address" {
  value       = openstack_compute_instance_v2.www_workload_instance.access_ip_v4
  description = "Outputs the Public IPv4 of each instance"
}

output "ssh_port" {
  value = var.ssh_port
}

output "ssh_key_name" {
  value = local_file.private_ssh_key.filename
}
