locals {
  subnets_hub = {
    "snet-management" = {
      address_prefix = "10.0.1.0/24"
    },
    "GatewaySubnet" = {
      address_prefix = "10.0.15.224/27"
    },
    "snet-shared" = {
      address_prefix = "10.0.4.0/22"
    },
    "AzureFirewallSubnet" = {
      address_prefix = "10.0.15.0/26"
    }
  }
  subnets_dev = {
    "default" = {
      address_prefix = "10.3.1.0/24"
    }
  }
  subnets_prod = {
    "default" = {
      address_prefix = "10.4.1.0/24"  # Updated to match new production VNet
    }
  }
  subnets_staging = {
    "default" = {
      address_prefix = "10.2.1.0/24"
    }
  }
}
