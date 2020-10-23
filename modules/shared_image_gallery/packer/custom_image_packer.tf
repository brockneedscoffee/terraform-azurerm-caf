resource "null_resource" "packer-exec" {
  provisioner "local-exec" {
    command = "packer build -var-file=/tf/caf/public/landingzones/caf_shared_services/scenario/110-shared-image-gallery/packer_config.pkvars.hcl /tf/caf/modules/shared_image_gallery/packer/image-builder1.pkr.hcl"
  }
}