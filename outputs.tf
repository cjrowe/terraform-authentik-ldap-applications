output "ldap_client_group_id" {
  value = length(authentik_group.ldap_clients) == 0 ? "NOT DEFINED" : authentik_group.ldap_clients[0].id
}
