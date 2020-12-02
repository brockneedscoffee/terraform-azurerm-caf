module "logic_app_workflow" {
  source = "./modules/logicapp/workflow"

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
