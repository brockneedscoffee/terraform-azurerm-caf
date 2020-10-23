resource "azurerm_postgresql_server" "postgresql" {

  name                         = azurecaf_name.postgresql.result
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version    = var.settings.version
  sku_name   = var.settings.sku_name
  
  administrator_login          = var.settings.administrator_login
  administrator_login_password = try(var.settings.administrator_login_password, azurerm_key_vault_secret.postgresql_admin_password.0.value)

  auto_grow_enabled                 = try(var.settings.auto_grow_enabled, false)
  storage_mb = try(var.settings.storage_mb, null)
  backup_retention_days             = try(var.settings.backup_retention_days, null)
  create_mode                       = try(var.settings.create_mode, "Default")
  creation_source_server_id         = try(var.settings.creation_source_server_id, null)
  geo_redundant_backup_enabled      = try(var.settings.geo_redundant_backup_enabled, null)
  infrastructure_encryption_enabled = try(var.settings.infrastructure_encryption_enableduto_grow_enabled, false)
  restore_point_in_time            = try(var.settings.restore_point_in_time, null)
  public_network_access_enabled    = try(var.settings.public_network_access_enabled, true)
 
  ssl_enforcement_enabled          = try(var.settings.ssl_enforcement_enabled, true)
  ssl_minimal_tls_version_enforced = try(var.settings.ssl_minimal_tls_version_enforced, "TLSEnforcementDisabled")
  tags                             = try(var.settings.tags, null)
  
  

  dynamic "identity" {
    for_each = lookup(var.settings, "identity", {}) == {} ? [] : [1]

    content {
      type = var.settings.identity.type
    }
  }

  dynamic "threat_detection_policy" {
    for_each = lookup(var.settings, "threat_detection_policy", {}) == {} ? [] : [1]

    content {
      enabled = var.settings.threat_detection_policy.enabled
      disabled_alerts = var.settings.threat_detection_policy.disabled_alerts
      email_account_admins = var.settings.threat_detection_policy.email_account_admins
      email_addresses = var.settings.threat_detection_policy.email_addresses
      retention_days = var.settings.threat_detection_policy.retention_days
      storage_account_access_key = var.settings.threat_detection_policy.storage_account_access_key
      storage_endpoint = var.settings.threat_detection_policy.storage_endpoint
    }
  }
}

resource "azurecaf_name" "postgresql" {
  name          = var.settings.name
  resource_type = "azurerm_postgresql_server"
  prefixes      = [var.global_settings.prefix]
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
}

# Generate postgresql server random admin password if not provided in the attribute administrator_login_password
resource "random_password" "postgresql_admin" {
  count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

  length           = 128
  special          = true
  upper            = true
  number           = true
  override_special = "$#%"
}

# Store the generated password into keyvault
resource "azurerm_key_vault_secret" "postgresql_admin_password" {
  count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

  name         = format("%s-password", azurecaf_name.postgresql.result)
  value        = random_password.postgresql_admin.0.result
  key_vault_id = var.keyvault_id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "sql_admin" {
  count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

  name         = format("%s-username", azurecaf_name.postgresql.result)
  value        = var.settings.administrator_login
  key_vault_id = var.keyvault_id
}

resource "azurerm_postgresql_active_directory_administrator" "aad_admin" {
  count = try(var.settings.azuread_administrator, null) == null ? 0 : 1

  server_name         = azurerm_postgresql_server.postgresql.name
  resource_group_name = var.resource_group_name
  login               = try(var.settings.azuread_administrator.login_username, var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].name)
  tenant_id           = try(var.settings.azuread_administrator.tenant_id, var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].tenant_id)
  object_id           = try(var.settings.azuread_administrator.object_id, var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].id)
}












