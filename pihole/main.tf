terraform {
    required_version = ">=1.1.9"
  backend "http" {
    update_method = "PUT"
  }
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.122.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

output "pihole_compute_data" {
  value = module.pihole_compute.compute_data.public_ip
}


resource "local_file" "inventory" {
  filename = "ansible/inventory.yml"
  content  = <<EOF
[pihole_group]
pihole ansible_host=${module.pihole_compute.compute_data.public_ip}
  EOF
}