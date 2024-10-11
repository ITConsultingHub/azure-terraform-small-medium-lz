variable "location" {
  type    = string
  description = "azure resources location"
  default = "eastus"
}
variable "product_name" {
  type = string
  nullable = false
  description = "(Mandatory) Project/Application name. e.g skynet \nThis will be used as prefix for all resources created."
  
}
variable "vnets" {
  description = "Map of vnets to create"
  type = map(object({
    name          = string
    address_space = string
  }))
  default = {
    spoke1 = { name = "hub", address_space = "10.0.0.0/20" },
    spoke2 = { name = "prod", address_space = "10.1.0.0/16" },
    spoke3 = { name = "staging", address_space = "10.2.0.0/16" },
    spoke4 = { name = "dev", address_space = "10.3.0.0/16" }
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "client_id" {
  description = "Azure Client ID (Service Principal)"
  type        = string
}
