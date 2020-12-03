variable tags {
  description = "(Required) map of tags for the deployment"
}

variable name {
  description = "(Required) The name of the Integration Service Environment"
}

variable location {
  description = "(Required) Resource Location"
}

variable resource_group_name {
  description = "(Required) Resource group of the Logic App"
}

variable sku_name {
  description = "The sku name and capacity of the Integration Service Environment"
}

variable access_endpoint_type {
  description = "The type of access endpoint to use for the Integration Service Environment"
}

variable virtual_network_subnet_ids {
  description = "A list of virtual network subnet ids to be used by Integration Service Environment"
}

variable global_settings {}

variable base_tags {}