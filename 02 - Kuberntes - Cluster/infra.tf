
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


resource "oci_core_security_list" "private_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-private-subnet-sl"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

}

resource "oci_core_security_list" "public_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-public-subnet-sl"
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_subnet" "vcn_private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.1.0/24"

  route_table_id    = module.vcn.nat_route_id
  security_list_ids = [oci_core_security_list.private_subnet_sl.id]
  display_name      = "k8s-private-subnet"
}

resource "oci_core_subnet" "vcn_public_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = "10.0.0.0/24"
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public_subnet_sl.id]
  display_name      = "k8s-public-subnet"
}


# Kubernetes cluster
resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = "v1.25.4"
  name               = "zakaria-cluster"
  vcn_id             = module.vcn.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.vcn_public_subnet.id
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
    service_lb_subnet_ids = [oci_core_subnet.vcn_public_subnet.id]
  }
}
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = "v1.25.4"
  name               = "k8s-node-pool"
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.vcn_private_subnet.id
    }
    size = 2
  }
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    memory_in_gbs = 6
    ocpus         = 1
  }
  node_source_details {
    image_id    = "ocid1.image.oc1.eu-paris-1.aaaaaaaak6elqqhj63ovtcn5p2bvfsx7r2omdetdxklwqo27fjg3a3n4psua"
    source_type = "image"
  }
  initial_node_labels {
    key   = "name"
    value = "k8s-cluster"
  }
  ssh_public_key = var.ssh_key
}
