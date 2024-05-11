

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.89"
    }
  }
}

provider "azurerm" {
  features {}
}

################ AGONES ###################

resource "azurerm_resource_group" "agones" {
  location = var.resource_group_location
  name     = "rg-agones-${var.resource_group_name}"
}

resource "azurerm_kubernetes_cluster" "agones" {
  name                = "agones-cluster-${var.resource_group_name}"
  location            = azurerm_resource_group.agones.location
  resource_group_name = azurerm_resource_group.agones.name
  # don't change dns_prefix as node pool Network Security Group name uses a hash of dns_prefix on on its name
  dns_prefix = "agones"

  kubernetes_version = var.kubernetes_version

  // Default node has to be 1, can't be SPOT, and can't have a taint, which seems to be required for Agones.
  default_node_pool {
    name                  = "default"
    node_count            = 1
    vm_size               = "Standard_D4s_v4"
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

// Run Agones on a User node pool instead.
resource "azurerm_kubernetes_cluster_node_pool" "system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_B2s"
  node_count            = 1
  enable_auto_scaling   = false
  node_taints = [
    "agones.dev/agones-system=true:NoExecute"
  ]
  node_labels = {
    "agones.dev/agones-system" : "true"
  }
}

################ Game Server NODE POOLS ###################
// All LOWER CASE NAMES

resource "azurerm_kubernetes_cluster_node_pool" "d2as5" {
  name                  = "d2as5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2as_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2ads5" {
  name                  = "d2ads5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2ads_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2d5" {
  name                  = "d2d5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2d_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2ds5" {
  name                  = "d2ds5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2ds_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d25" {
  name                  = "d25"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2s5" {
  name                  = "d2s5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2s_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2as5" {
  name                  = "e2as5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2as_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2ads5" {
  name                  = "e2ads5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2ads_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2d5" {
  name                  = "e2d5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2d_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2ds5" {
  name                  = "e2ds5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2ds_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e25" {
  name                  = "e25"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2s5" {
  name                  = "e2s5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2s_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "f2s2" {
  name                  = "f2s2"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_F2s_v2"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2as4" {
  name                  = "d2as4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2as_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2a4" {
  name                  = "d2a4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2a_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2ds4" {
  name                  = "d2ds4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2ds_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2d4" {
  name                  = "d2d4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2d_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2s4" {
  name                  = "d2s4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2s_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d24" {
  name                  = "d24"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2as4" {
  name                  = "e2as4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2as_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2a4" {
  name                  = "e2a4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2a_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2ds4" {
  name                  = "e2ds4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2ds_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2d4" {
  name                  = "e2d4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2d_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2s4" {
  name                  = "e2s4"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2s_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e24" {
  name                  = "e24"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2_v4"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}



################ NETWORK ###################
# Needed by Agones
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
    azurerm_kubernetes_cluster_node_pool.d2as5,
    azurerm_kubernetes_cluster_node_pool.d2ads5,
    azurerm_kubernetes_cluster_node_pool.d2d5,
    azurerm_kubernetes_cluster_node_pool.d2ds5,
    azurerm_kubernetes_cluster_node_pool.d25,
    azurerm_kubernetes_cluster_node_pool.d2s5,
    azurerm_kubernetes_cluster_node_pool.e2as5,
    azurerm_kubernetes_cluster_node_pool.e2ads5,
    azurerm_kubernetes_cluster_node_pool.e2d5,
    azurerm_kubernetes_cluster_node_pool.e2ds5,
    azurerm_kubernetes_cluster_node_pool.e25,
    azurerm_kubernetes_cluster_node_pool.e2s5,
    azurerm_kubernetes_cluster_node_pool.f2s2,
    azurerm_kubernetes_cluster_node_pool.d2as4,
    azurerm_kubernetes_cluster_node_pool.d2a4,
    azurerm_kubernetes_cluster_node_pool.d2ds4,
    azurerm_kubernetes_cluster_node_pool.d2d4,
    azurerm_kubernetes_cluster_node_pool.d2s4,
    azurerm_kubernetes_cluster_node_pool.d24,
    azurerm_kubernetes_cluster_node_pool.e2as4,
    azurerm_kubernetes_cluster_node_pool.e2a4,
    azurerm_kubernetes_cluster_node_pool.e2ds4,
    azurerm_kubernetes_cluster_node_pool.e2d4,
    azurerm_kubernetes_cluster_node_pool.e2s4,
    azurerm_kubernetes_cluster_node_pool.e24,
  ]

  # Ignore resource_group_name changes because of random case returned by AKS Api (MC_* or mc_*)
  lifecycle {
    ignore_changes = [
      resource_group_name
    ]
  }
}


################ MATCHMAKER ###################

resource "azurerm_resource_group" "matchmaker" {
  location = var.resource_group_location
  name     = "rg-mm-${var.resource_group_name}"
}

resource "azurerm_service_plan" "matchmaker" {
  name                = "serviceplan-matchmaker-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.matchmaker.name
  location            = azurerm_resource_group.matchmaker.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "matchmaker" {
  name                = "poutypouchgames-matchmaker-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.matchmaker.name
  location            = azurerm_service_plan.matchmaker.location
  service_plan_id     = azurerm_service_plan.matchmaker.id

  site_config {
    application_stack {
      docker_image_name = "matchmaker:latest"
      docker_registry_url = "https://poutypouchgamesacrcentralus.azurecr.io"
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
    }
  }
}

################ SERVICE DISCOVERY ###################

resource "azurerm_resource_group" "servicediscovery" {
  location = "Central US"   # WATCH OUT! If changing this, it's also hard coded below. So we only get one.
  name     = "rg-sd-central-us"
}

resource "azurerm_service_plan" "servicediscovery" {
  name                = "serviceplan-servicediscovery-central-us"
  resource_group_name = azurerm_resource_group.servicediscovery.name
  location            = azurerm_resource_group.servicediscovery.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "servicediscovery" {
  name                = "poutypouchgames-servicediscovery-central-us"
  resource_group_name = azurerm_resource_group.servicediscovery.name
  location            = azurerm_service_plan.servicediscovery.location
  service_plan_id     = azurerm_service_plan.servicediscovery.id

  site_config {
    application_stack {
      docker_image_name = "servicediscovery:latest"
      docker_registry_url = "https://poutypouchgamesacrcentralus.azurecr.io"
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
    }
  }
}



















/**
Recommended by Playfab
Dasv4  series
D2as v4 instance        70/month        7/month spot 

Do Free AKS. Can get up to 10 nodes.

Benchmarks:
https://learn.microsoft.com/en-us/azure/virtual-machines/linux/compute-benchmark-scores

Good:
Highlight to see if used.

Standard_D2ads_v5
Standard_D2as_v5
Standard_D2ds_v5
Standard_D2d_v5

Standard_D2as_v4
Standard_D2a_v4
Standard_D2ds_v4
Standard_D2d_v4
Standard_D2s_v4
Standard_D2_v4

Standard_E2ads_v5
Standard_E2as_v5
Standard_E2ds_v5
Standard_E2d_v5

Standard_E2as_v4
Standard_E2a_v4
Standard_E2ds_v4
Standard_E2d_v4
Standard_E2s_v4
Standard_E2_v4

Standard_F2s_v2

Standard_D11_v2
Standard_DS11_v2

Flaky:
Standard_D2s_v5
Standard_D2_v5

Standard_E2s_v5
Standard_E2_v5

    v6 in preview

Standard_D2as_v5     6/mo    2.5GHz - 3.5GHz AMD
Standard_D2ads_v5    7/mo    2.5GHz - 3.5GHz AMD
Standard_D2ps_v5     6/mo    3.0GHz Ampere
Standard_D2pds_v5    7/mo   3.0GHz Ampere
Standard_D2pls_v5    6/mo    3.0GHz Ampere
Standard_D2plds_v5   6/mo    3.0GHz Ampere
Standard_D2d_v5      8/mo    2.7-3.5/4.0 GHz Intel
Standard_D2ds_v5      8/mo    2.7-3.5/4.0 GHz Intel
Standard_D2_v5      7/mo    2.7-3.5/4.0 GHz Intel
Standard_D2s_v5      7/mo    2.7-3.5/4.0 GHz Intel

x Standard_D2d_v4      8/mo    2.5-3.4 GHz Intel 8272CL
x Standard_D2a_v4      7/mo    2.3GHz - 3.3GHz AMD
x Standard_D2as_v4     7/mo    2.3GHz - 3.3GHz AMD
x Standard_D2ds_v4      8/mo    2.5-3.4 GHz Intel 8272CL
x Standard_D2_v4      7/mo    2.5-3.4 GHz Intel 8272CL
x Standard_D2s_v4      7/mo    2.5-3.4 GHz Intel 8272CL


    v6 in preview
E Series

Standard_E2as_v5     8/mo    2.5GHz - 3.5GHz AMD
Standard_E2ads_v5     10/mo    2.5GHz - 3.5GHz AMD
Standard_E2ps_v5     8/mo    3.0GHz Ampere
Standard_E2pds_v5    9/mo   3.0GHz Ampere
Standard_E2d_v5    10/mo    Intel
Standard_E2ds_v5   10/mo    Intel
Standard_E2_v5   9/mo    Intel
Standard_E2s_v5   9/mo    Intel

x Standard_E2bds_v5   12/mo    Intel


x Standard_E2a_v4      9/mo    2.3GHz - 3.3GHz AMD
x Standard_E2as_v4     9/mo    2.3GHz - 3.3GHz AMD




NONONONONONNONONONOOOO

D2ls _v5      15/mo    2.7-3.5/4.0 GHz Intel 
D4ls _v5      30/mo     Only 75% spot savings. So NO.

D2lds _v5      17/mo    2.7-3.5/4.0 GHz Intel 
D4lds _v5      35/mo     Only 75% spot savings. So NO.

DC2ads_v5   Only 30% spot savings. So NO.

DC2as_v5    Only 30% spot savings. So NO.

D2_v3      7/mo    2.3 GHz Intel 8272CL
D4_v3      14/mo

D2s_v3      7/mo    2.3 GHz Intel 8272CL
D4s_v3      14/mo

D2_v3      7/mo     Intel
D4_v3      14/mo

DC1s_v3      7/mo    Intel
DC2s_v3      14/mo   Sketchy. Less Cores. So NO.

DC1s_v2      7/mo    3.7-5.0 GHz Intel
DC2s_v2      14/mo   Sketchy. Less Cores, More power though. How? Try it.

    v6 in preview
F Series mostly seems like the old D series.

F2s_v2      6/mo    2.3 GHz Intel
F4s_v2      12/mo

F1      4/mo    2.3 GHz Intel
F2      7/mo
F4      14/mo

F1s      4/mo    2.3 GHz Intel
F2s      7/mo
F4s      14/mo



Ampere Arm
resource "azurerm_kubernetes_cluster_node_pool" "d2ps5" {
  name                  = "d2ps5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2ps_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2pds5" {
  name                  = "d2pds5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2pds_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2pls5" {
  name                  = "d2pls5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2pls_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "d2plds5" {
  name                  = "d2plds5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_D2plds_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2ps5" {
  name                  = "e2ps5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2ps_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}
resource "azurerm_kubernetes_cluster_node_pool" "e2pds5" {
  name                  = "e2pds5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.agones.id
  vm_size               = "Standard_E2pds_v5"
  enable_node_public_ip = var.enable_node_public_ip
  node_count            = var.min_node_count
  max_count             = var.max_node_count
  enable_auto_scaling   = true
  priority          = "Spot"
  eviction_policy   = "Delete"
  spot_max_price    = 0.05
}


*/