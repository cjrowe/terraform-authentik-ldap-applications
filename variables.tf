variable "service_connection_id" {
  type = string
  description = "Service Connection used to create LDAP Outpost"
}

variable "outpost_configuration" {
  type = string
  description = "Specific configuration details for outpost. Should be formatted as Json string"
}

variable "ldap_clients_group_name" {
  type = string
  description = "Authentik Group to create that all LDAP-querying service accounts will be added to"
  default = "ldap-clients"
}