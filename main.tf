resource authentik_outpost "ldap_outpost" {
  name = "LDAP Outpost"
  type = "ldap"
  protocol_providers = [ ]
  service_connection = var.service_connection_id
  config = var.outpost_configuration
}

resource authentik_group "ldap_clients" {
  name = var.ldap_clients_group_name
}
