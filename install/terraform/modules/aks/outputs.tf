
output "cluster_ca_certificate" {
  value = nonsensitive(base64decode(azurerm_kubernetes_cluster.agones.kube_config.0.cluster_ca_certificate))
  depends_on = [
    # Helm would be invoked only after all node pools would be created
    # This way taints and tolerations for Agones controller would work properly
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
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.agones.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.agones.kube_config_raw
}

output "host" {
  value = nonsensitive(azurerm_kubernetes_cluster.agones.kube_config.0.host)
}

output "token" {
  value = nonsensitive(azurerm_kubernetes_cluster.agones.kube_config.0.password)
}
