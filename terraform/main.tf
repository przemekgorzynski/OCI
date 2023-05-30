terraform {
    required_version = ">=1.1.9"
  backend "http" {
    update_method = "PUT"
    address       = var.OCI_PAR
  }
}

provider "oci" {}

#output "pihole_compute_data" {
#  value = module.pihole_compute.compute_data.public_ip
#}
