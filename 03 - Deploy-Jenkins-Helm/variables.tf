variable "kubeconfig_path" {
  type = string
  description = ""
}

variable "namespace" {
  type = string
  description = "(optional) describe your variable"
  default = "jenkins-namespace"
}

variable "admin_password" {
  type = string
  description = "Jenkins admin Password"
}