terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region              = "eu-paris-1"
  auth                = "SecurityToken"
  config_file_profile = "terraform"
}

resource "oci_core_vcn" "testVcn" {
  dns_label      = "internal"
  cidr_block     = "192.168.0.0/16"
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaalv55abf2d7q7znheirfcpraz2dmexplp22g5epghof6gmeqwkexq"
  display_name   = "myvcn"
}

resource "oci_core_subnet" "TestSubnet" {
  depends_on = [
    oci_core_vcn.testVcn
  ]
  #Required
  cidr_block        = "192.168.1.0/24"
  compartment_id    = "ocid1.tenancy.oc1..aaaaaaaalv55abf2d7q7znheirfcpraz2dmexplp22g5epghof6gmeqwkexq"
  vcn_id            = oci_core_vcn.testVcn.id
  display_name      = "mySubnet"
  security_list_ids = [oci_core_security_list.test_security_list.id]
}

resource "oci_core_security_list" "test_security_list" {
  #Required
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaalv55abf2d7q7znheirfcpraz2dmexplp22g5epghof6gmeqwkexq"
  vcn_id         = oci_core_vcn.testVcn.id
  display_name   = "test_security_list"

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Some traffic"
    tcp_options {
      min = 4000
      max = 4000
    }
  }
  ingress_security_rules {
     protocol    = "6"
    source      = "0.0.0.0/0"
    description = "SSH traffic"
    tcp_options {
      min = 22
      max = 22
    }
  }

}

# resource "oci_core_security_list" "SecurityList-TestVCN" {

#   depends_on = [
#     oci_core_vcn.testVcn , oci_core_subnet.TestSubnet
#   ]
#   compartment_id = "ocid1.tenancy.oc1..aaaaaaaalv55abf2d7q7znheirfcpraz2dmexplp22g5epghof6gmeqwkexq"
#   vcn_id         = oci_core_subnet.TestSubnet.id
#   display_name   = "SecurityList-TestVCN"

#   ingress_security_rules {
#     #Required
#     protocol = var.protocol
#     source   = var.source_address
#     tcp_options {
#       min = 4000
#       max = 4100
#     }
#   }
# }

