provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "jenkins-terraform" {
  name       = "jenkins-terraform"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "4.3.4"
  namespace  = var.namespace
  values = [
    file("values.yaml")
  ]
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  set {
    name  = "chart-admin-password"
    value = var.admin_password
  }
  depends_on = [
    kubernetes_namespace.jenkins-infra
  ]
}


resource "kubernetes_namespace" "jenkins-infra" {
  metadata {
    name = var.namespace
  }

}
