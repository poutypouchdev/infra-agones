

// Actually used
variable "client_id" {
}

variable "client_secret" {
}

variable "docker_registry_username" { 
}

variable "docker_registry_password" {
}

variable "enable_node_public_ip" {
  default = true
}

variable "min_node_count" {
  default = 0
}

variable "kubernetes_version" {
  default = "1.28"
}

// Unused
variable "resource_group_location" {
  default = "test"
}

variable "resource_group_name" {
  default = "test"
}
