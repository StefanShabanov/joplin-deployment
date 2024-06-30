resource "null_resource" "wine_installation" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key
    host        = var.vm_ip
    port        = var.ssh_port
  }

  provisioner "file" {
    source      = "../common/winehq_installation.sh"
    destination = "/tmp/winehq_installation.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/winehq_installation.sh",
      "/tmp/winehq_installation.sh ${var.winehq_version}",
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
