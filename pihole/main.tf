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
  filename = "./ansible/inventory.yml"
  content  = <<EOF
all:
  hosts:
    pihole:
      ansible_host: ${module.pihole_compute.compute_data.public_ip}
  EOF
}

resource "local_file" "block_storage_data" {
  filename = "./ansible/block_data.yml"
  content  = <<EOF
block_attachment_id: ${oci_core_volume_attachment.pihole_block_volume_attachment.id}
  EOF
}