resource "null_resource" "docker_installation" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key
    host        = var.vm_ip
    port        = var.ssh_port
  }

  provisioner "file" {
    source      = "../../../scripts/docker_install.sh"
    destination = "/tmp/docker_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker_install.sh",
      "/tmp/docker_install.sh",
    ]
  }
}

# resource "null_resource" "data_management_user_creation" {
#   depends_on = [null_resource.required_software_installation]
#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = var.private_key
#     host        = var.vm_ip
#     port        = var.ssh_port
#   }
#
#   provisioner "file" {
#     source      = "../common/data_management_user.sh"
#     destination = "/tmp/data_management_user.sh"
#   }
#
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/data_management_user.sh",
#       "/tmp/data_management_user.sh ${var.username} ${var.user_password}",
#     ]
#   }
# }
