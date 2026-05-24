resource "kind_cluster" "default" {
  name            = "kind-cluster"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 31437
        host_port      = 8080
      }

      extra_port_mappings {
        container_port = 30478
        host_port      = 8443
      }
    }
  }
}
