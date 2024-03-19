

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.66"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "agones" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "agones" {
  name                = var.cluster_name
  location            = azurerm_resource_group.agones.location
  resource_group_name = azurerm_resource_group.agones.name
  # don't change dns_prefix as node pool Network Security Group name uses a hash of dns_prefix on on its name
  dns_prefix = "agones"

  kubernetes_version = var.kubernetes_version

// Default node has to be 1. Maybe can delete later or change to spot in Azure?
  default_node_pool {
    name                  = "default"
    node_count            = 1
    vm_size               = var.system_vm_size
    enable_auto_scaling   = false
    enable_node_public_ip = var.enable_node_public_ip
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  tags = {
    Environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = var.system_vm_size
  node_count            = 1
  enable_auto_scaling   = false
  node_taints = [
    "agones.dev/agones-system=true:NoExecute"
  ]
  node_labels = {
    "agones.dev/agones-system" : "true"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "spotd2v2" {
  name                  = "spotd2v2"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2_v4"
  node_count            = 1
  enable_auto_scaling   = false
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}


resource "azurerm_network_security_rule" "gameserver" {
  name                       = "gameserver"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "7000-8000"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_kubernetes_cluster.agones.node_resource_group
  # We don't use azurerm_resources datasource to get the security group as it's not reliable: random empty resource array
  # 55978144 are the first 8 characters of the fnv64a hash's UInt32 of master node's dns prefix ("agones")
  network_security_group_name = "aks-agentpool-55978144-nsg"

  depends_on = [
    azurerm_kubernetes_cluster.agones,
    azurerm_kubernetes_cluster_node_pool.system,
  ]

  # Ignore resource_group_name changes because of random case returned by AKS Api (MC_* or mc_*)
  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}
