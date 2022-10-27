resource authentik_outpost "ldap_outpost" {
  name = "LDAP Outpost"
  type = "ldap"
  protocol_providers = {for p in authentik_provider_ldap.ldap_provider : p => p.id}
  service_connection = var.service_connection_id
  config = var.outpost_configuration
}

resource authentik_group "ldap_clients" {
  name = var.ldap_service_accounts_group_name
}

resource authentik_application "ldap_application" {
  count = var.applications.length

  name = var.applications[count.index].name
  slug = var.applications[count.index].slug
  protocol_provider = authentik_provider_ldap.ldap_provider[count.index].id
}

resource authentik_provider_ldap "ldap_provider" {
  count = var.applications.length

  name = "${title(var.applications[count.index].slug)}LDAP"
  base_dn = coalesce(var.applications[count.index].ldap_config["base_dn"], var.default_base_dn)
  bind_flow = coalesce(var.applications[count.index].ldap_config["bind_flow_uuid"], authentik_flow.ldap_login.uuid)
  search_group = authentik_group.ldap_clients.id
  bind_mode = coalesce(var.applications[count.index].ldap_config["bind_mode"], var.default_bind_mode)
  search_mode = coalesce(var.applications[count.index].ldap_config["search_mode"], var.default_search_mode)
}

resource authentik_user "ldap_user" {
  count = var.applications.length

  username = "ldap-${var.applications[count.index].slug}"
  name = "Service User used by ${var.applications[count.index].name} to authenticate against LDAP server"
  path = "users/ldap"
  groups = [ authentik_group.ldap_clients.id ]
}

resource authentik_token "ldap_app_password" {
  count = var.applications.length

  identifier = "ldap-app-password-${var.applications[count.index].slug}"
  user = authentik_user.ldap_user[count.index].id
  intent = "app_password"
  description = "Password used by ${var.applications[count.index].name} to authenticate using LDAP"
  expiring = false
  retrieve_key = false
}

resource authentik_flow "ldap_login" {
  designation = "authentication"
  name = "ldap-password-auth"
  slug = "ldap-password-auth"
  title = "LDAP Password Login"
}

resource authentik_flow_stage_binding "ldap_login_identification" {
  order = 10
  stage = data.authentik_stage.default_authentication_identification.id
  target = authentik_flow.ldap_login.uuid
}

resource authentik_flow_stage_binding "ldap_login_password" {
  order = 20
  stage = data.authentik_stage.default_authentication_password.id
  target = authentik_flow.ldap_login.uuid
}

resource authentik_flow_stage_binding "ldap_login_login" {
  order = 100
  stage = data.authentik_stage.default_authentication_login.id
  target = authentik_flow.ldap_login.uuid
}

data authentik_stage "default_authentication_identification" {
  name = "default-authentication-identification"
}

data authentik_stage "default_authentication_password" {
  name = "default-authentication-password"
}

data authentik_stage "default_authentication_login" {
  name = "default-authentication-login"
}
