

// resource "azurecaf_name" "sig_name" {
//   for_each =  local.shared_services.shared_image_gallery.galleries
//   name          = each.value.name
//   prefixes      = [local.global_settings.prefix]
//   resource_type = "azurerm_shared_image_gallery"
//   random_length = local.global_settings.random_length
//   clean_input   = true
//   passthrough   = local.global_settings.passthrough
// }


// resource "azurecaf_name" "image_definition_name" {
//   for_each =  local.shared_services.shared_image_gallery.image_definition
//   name          = each.value.name
//   #prefixes      = [local.global_settings.prefix]
//   resource_type = "azurerm_shared_image"
//   random_length = local.global_settings.random_length
//   clean_input   = true
//   passthrough   = local.global_settings.passthrough
// }


resource "azurerm_shared_image_gallery" "gallery" {
  for_each = local.shared_services.shared_image_gallery.galleries
  name     = each.value.name
  #azurecaf_name.sig_name[each.key].result
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  location            = module.resource_groups[each.value.resource_group_key].location
  description         = each.value.description

}


resource "azurerm_shared_image" "image" {
  for_each = local.shared_services.shared_image_gallery.image_definition
  name     = each.value.name
  #azurecaf_name.image_definition_name[each.key].result
  gallery_name        = azurerm_shared_image_gallery.gallery[each.value.gallery_key].name
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  location            = module.resource_groups[each.value.resource_group_key].location
  os_type             = each.value.os_type

  identifier {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }
}

resource "null_resource" "packer-exec" {
  count = local.shared_services.packer.use_packer ? 1 : 0
  provisioner "local-exec" {
    command = "packer build -var-file=${local.shared_services.packer.packer_configuration_file_path} ${local.shared_services.packer.packer_file_path}"
  }
}