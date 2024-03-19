

// Actually used
variable "client_id" {
}

variable "client_secret" {
}

variable "enable_node_public_ip" {
  default = true
}

variable "kubernetes_version" {
  default = "1.28.0"
}

variable "system_vm_size" {
  default = "Standard_D2_v2"
}


// Unused
variable "resource_group_location" {
  default = "test"
}

variable "resource_group_name" {
  default = "test"
}

variable "cluster_name" {
  default = "test"
}

