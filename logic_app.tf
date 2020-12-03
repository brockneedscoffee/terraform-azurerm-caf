module "logic_app_action_http" {
  source = "./modules/logic_app/action_http"

  for_each = local.logicapp.logic_app_action_http

  name                 = each.value.name
  logic_app_id         = try(each.value.lz_key, null) == null ? local.combined_objects_logic_app_workflow[local.client_config.landingzone_key][each.value.logic_app_workflow_key].id : local.combined_objects_logic_app_workflow[each.value.lz_key][each.value.logic_app_workflow_key].id
  method               = each.value.method
  uri                  = each.value.uri
  body                 = try(each.value.body, null)
  headers              = try(each.value.headers, null)
  run_after            = try(each.value.run_after, null)
}

output "logic_app_action_http" {
  value = module.logic_app_action_http
}

#####
module "logic_app_trigger_http_request" {
  source = "./modules/logic_app/trigger_http_request"

  for_each = local.logicapp.logic_app_trigger_http_request

  name                 = each.value.name
  logic_app_id         = try(each.value.lz_key, null) == null ? local.combined_objects_logic_app_workflow[local.client_config.landingzone_key][each.value.logic_app_workflow_key].id : local.combined_objects_logic_app_workflow[each.value.lz_key][each.value.logic_app_workflow_key].id
  schema               = each.value.schema
  method               = try(each.value.method, null)
  relative_path        = try(each.value.relative_path, null)
}

output "logic_app_trigger_http_request" {
  value = module.logic_app_trigger_http_request
}

#####
module "logic_app_workflow" {
  source = "./modules/logic_app/workflow"

  for_each = local.logicapp.logic_app_workspace

  name                               = each.value.name
  resource_group_name                = module.resource_groups[each.value.resource_group_key].name
  location                           = lookup(each.value, "region", null) == null ? module.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  integration_service_environment_id = null
  logic_app_integration_account_id   = null
  workflow_schema                    = try(each.value.workflow_schema, null)
  workflow_version                   = try(each.value.workflow_version, null)
  parameters                         = try(each.value.parameters, null)
  global_settings                    = local.global_settings
  base_tags                          = try(local.global_settings.inherit_tags, false) ? module.resource_groups[each.value.resource_group_key].tags : {}
  tags                               = try(each.value.tags, null)
}

output "logic_app_workflow" {
  value = module.logic_app_workflow
}

#####
module "integration_service_environment" {
  source = "./modules/logic_app/integration_service_environment"

  for_each = local.logicapp.integration_service_environment

  name                               = each.value.name
  resource_group_name                = module.resource_groups[each.value.resource_group_key].name
  location                           = lookup(each.value, "region", null) == null ? module.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  sku_name = each.value.sku_name
  access_endpoint_type = each.value.access_endpoint_type
  virtual_network_subnet_ids = each.value.virtual_network_subnet_ids
  global_settings                    = local.global_settings
  base_tags                          = try(local.global_settings.inherit_tags, false) ? module.resource_groups[each.value.resource_group_key].tags : {}
  tags                               = try(each.value.tags, null)
}

output "integration_service_environment" {
  value = module.integration_service_environment
}
