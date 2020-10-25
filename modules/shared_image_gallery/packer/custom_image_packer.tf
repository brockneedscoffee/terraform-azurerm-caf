resource "null_resource" "packer-exec" {
  count = var.settings.use_packer ? 1 : 0
  provisioner "local-exec" {
    command = "packer build -var-file=${var.settings.packer_file_path} ${var.settings.packer_configuration_file_path}"
  }
}