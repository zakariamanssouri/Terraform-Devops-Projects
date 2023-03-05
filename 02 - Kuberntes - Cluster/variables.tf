variable "compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaalv55abf2d7q7znheirfcpraz2dmexplp22g5epghof6gmeqwkexq"
}

variable "ssh_key" {
  type        = string
  description = "(optional) describe your variable"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPBAh2vDecXvnc1PbFZCsTAK+Km+MYTJlc92TyuSPewXIcca0WnINj+Eci70fu5XLvsb8ZoowP6dkmVgseh+WotP1FPn7WrR+qgcxS125GEfHTHOxJ1o8wxQWxWMyvHHNbWCvRlvQuM+4+A9SX/KAGk+X3RXSnH+HpwH+KAYGWJrRCGFuQ3zy8L9y1Fawdm6N9dq237Swra5Qkte2lxlRRuDkbpCfI/h514Zg1gVCK4+jMCPfBy8S2Rr1HwBry9ROTRIKyaFVQYlTUmvLDZw1xsYZ6kN5QjPmchMVBupRF2GxN9Cf4SFzxC52OphHILwrcGxOnKGYu/RIs/FxvPRNH10B3Yl6IZzbTcuK7BDMBxx17nxsujDgphqbBWcPQ+/t8YsqviOWZEI4SfbFGVxP1r7bWQBIrFKXHOrLTVTMPkWxGXoFmGdLbs1xjH9adpa0oTyBzb7UFlsJVJPm8PSDqSRUPw9vWtnPn9ED7KnI/A5fNxBkRwHoRnxKrvlaBWF1DKegHyG0f5MeAJKngBh0t867Bjd8L4dgKOrZDU3bJvY8Obf+NUEo7hZ+ZEQPaFNEqH44n5mrBNjr9OrGCuwDRmxRv/ejpcD0N80DnJmIs87X30YYc/QXgMVR0wR4DSKWi7vNXLdgIN1vyURoBvLnDHj35OerqOcWZfwYyZjl8Bw== z.mansouri_etu@enset-media.ac.ma"
}

variable "region" {
  type        = string
  description = "(optional) describe your variable"
  default     = "eu-paris-1"
}
variable "cluster_name" {
  type    = string
  default = "zakaria-cluster"
}

variable "shape" {
  type        = string
  description = "(optional) describe your variable"
  default     = "VM.Standard.A1.Flex"
}
