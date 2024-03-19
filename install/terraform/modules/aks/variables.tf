
variable "client_id" {
}

variable "client_secret" {
}

variable "cluster_name" {
  default = "test"
}

# VMSS is used, so it is unpredictable how NICs will be given to VMs
# So let Azure to create NICs with Public IPs as gameservers require
# Azure Managment SDK can be used to obtain these IPs and map Agones GameServers internal IPs to public
variable "enable_node_public_ip" {
  default = true
}

variable "kubernetes_version" {
  default = "1.28.0"
}

variable "resource_group_location" {
  default = "test"
}

variable "resource_group_name" {
  default = "test"
}
