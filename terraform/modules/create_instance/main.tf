data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "openstack_compute_keypair_v2" "ssh_keypair" {
  name       = "ssh_key_${replace(var.instance_hostname, ".", "_")}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

##Save the SSH to a file
resource "local_file" "private_ssh_key" {
  filename = "ssh_key_${replace(var.instance_hostname, ".", "_")}"
  content  = tls_private_key.ssh_key.private_key_pem
}



data "external" "check_hostname" {
  program = ["bash", "-c", "host ${var.instance_hostname} >/dev/null 2>&1 && echo '{\"available\": \"true\"}' || echo '{\"available\": \"false\"}'"]
}

resource "openstack_compute_instance_v2" "www_workload_instance" {
  name        = "www-workload-${var.instance_hostname}"
  provider    = openstack.ovh
  image_name  = "Ubuntu 22.04"
  flavor_name = var.instance_flavour
  key_pair    = openstack_compute_keypair_v2.ssh_keypair.name

  network {
    name = "Ext-Net"
  }

  user_data = data.template_file.user_data.rendered

  lifecycle {
    postcondition {
      condition = data.external.check_hostname.result["available"] == "false"
      error_message = "Hostname is not available. Please choose another hostname, then run terraform apply again"
    }
  }
}

resource "null_resource" "change_ssh_port" {
  depends_on = [openstack_compute_instance_v2.www_workload_instance] # Ensure the instance is created before executing remote-exec provisioner

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = openstack_compute_instance_v2.www_workload_instance.access_ip_v4
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's@#Port 22@Port ${var.ssh_port}@g' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd",
      "sudo ufw allow ${var.ssh_port}/tcp"
    ]
  }
}

resource "null_resource" "add_key_to_user" {
  depends_on = [openstack_compute_instance_v2.www_workload_instance] # Ensure the instance is created before executing remote-exec provisioner

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = openstack_compute_instance_v2.www_workload_instance.access_ip_v4
    port        = var.ssh_port
  }

  provisioner "remote-exec" {
    inline = [
      # Save the public key as a separate file
      "echo '${tls_private_key.ssh_key.public_key_openssh}' > ~/public_key.pem",
    ]
  }
}