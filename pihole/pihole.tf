module "pihole_compute"{
    source                  = "../modules/compute"
    compartment_id          = var.compartment_id
    fault_domain            = var.fault_domains[1]
    availability_domain     = var.availability_domains[1]
    shape                   = var.pihole_shape
    hostname                = var.pihole_hostname
    local_public_key_path   = var.local_public_key_path
    memory                  = var.pihole_memory
    ocpus                   = var.pihole_ocpus
    private_ip              = var.pihole_private_ip
    vnic_name               = "pihole_vnic"
    subnet                  = module.pihole_subnet.subnet_data.id
    dns_label               = "pihole-vm"
    image_id                = var.pihole_image_id
    user_data_base64        = filebase64("${path.module}/cloud-init.yaml")
    nsg_ids                 = [oci_core_network_security_group.pihole_nsg.id]
}

resource "oci_core_volume" "pihole_block_volume" {
    #Required
    compartment_id          = var.compartment_id

    #Optional
    availability_domain     = var.availability_domains[1]
    display_name            = var.pihole_block_display_name
    is_auto_tune_enabled    = true
    size_in_gbs             = var.pihole_block_volume_size_in_gbs
    vpus_per_gb             = var.pihole_block_volume_vpus_per_gb
}


#resource "oci_core_volume_attachment" "pihole_block_volume_attachment" {
#    attachment_type         = "iscsi"
#    instance_id             = module.pihole_compute.compute_data.id
#    volume_id               = oci_core_volume.pihole_block_volume.id
#    device                  = var.volume_device
#    display_name            = "pihole_block_volume_attachment"
#    is_read_only            = false
#    is_shareable            = false
#}