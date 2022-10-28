variable "service_connection_id" {
  type = string
  description = "Service Connection used to create LDAP Outpost"
}

variable "outpost_configuration" {
  type = string
  description = "Specific configuration details for outpost. Should be formatted as Json string"
}

variable "ldap_service_accounts_group_name" {
  type = string
  description = "Authentik Group to create that all LDAP-querying service accounts will be added to"
  default = "ldap-clients"
}

variable "default_base_dn" {
  type = string
  description = "The default Base DN to use for applications if one is not specified"
}

variable "default_bind_mode" {
  type = string
  description = "The default Bind Mode that will be applied to applications if one is not specified"
  default = "direct"
}

variable "default_search_mode" {
  type = string
  description = "The default Bind Mode that will be applied to applications if one is not specified"
  default = "direct"
}

variable "applications" {
  type = list(object({
    name = string
    slug = string
    ldap_config = map(string)
    app_config = map(string)
    user_ids = list(string)
  }))
  description = "Details of LDAP authenticated applications to create"
}