# Backend Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend-api"
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "backend-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend-api"
        }
      }

      spec {
        container {
          name  = "backend-api"
          image = var.backend_image

          port {
            container_port = var.backend_port
          }
        }
      }
    }
  }
}

# Internal Service for Backend
resource "kubernetes_service" "backend_internal" {
  metadata {
    name = "backend-api"
  }

  spec {
    selector = {
      app = "backend-api"
    }

    port {
      port        = var.backend_port
      target_port = var.backend_port
    }

    type = "ClusterIP"
  }
}

# NGINX Ingress Controller Service
resource "kubernetes_service" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }

  spec {
    selector = {
      app = "nginx-ingress"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
    }

    type = "LoadBalancer"
  }
}

# Ingress Resource
resource "kubernetes_ingress_v1" "backend_ingress" {
  metadata {
    name = "backend-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.backend_internal.metadata[0].name
              port {
                number = var.backend_port
              }
            }
          }
        }
      }
    }
  }
}
