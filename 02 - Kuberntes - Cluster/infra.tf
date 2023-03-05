
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.110.0"
    }
  }
}

provider "oci" {
  region              = "eu-paris-1"
  auth                = "SecurityToken"
  config_file_profile = "terraform"
}

module "vcn" {
  source         = "oracle-terraform-modules/vcn/oci"
  version        = "3.5.3"
  compartment_id = var.compartment_id

  region = var.region

  vcn_name      = "k8s-vcn"
  vcn_cidrs     = ["10.0.0.0/16"]
  vcn_dns_label = "k8svcn01"

  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}
