#Networking
resource "oci_core_vcn" "vcn" {
    compartment_id              = var.compartment_id
    display_name                = var.vcn_name
    cidr_block                  = var.vcn_address_space.vcn
    is_ipv6enabled              = var.vcn_is_ipv6enabled
    dns_label                   = "vcn"
#    default_route_table_id      = oci_core_route_table.route_table.id
}

resource "oci_core_internet_gateway" "internet_gateway" {
    compartment_id              = var.compartment_id
    vcn_id                      = oci_core_vcn.vcn.id
    enabled                     = true
    display_name                = var.internet_gateway_display_name
}

resource "oci_core_default_route_table" "route_table" {
    manage_default_resource_id  = oci_core_vcn.vcn.default_route_table_id
    compartment_id              = var.compartment_id
    route_rules {
        network_entity_id       = oci_core_internet_gateway.internet_gateway.id
        destination             = "0.0.0.0/0"
        description             = "Route table to allow Internet access"
    }
}

resource "oci_core_dhcp_options" "dhcp" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "NextDNS"

  options {
      type = "DomainNameServer"
      server_type = "CustomDnsServer"
      custom_dns_servers = [ "45.90.28.197", "45.90.30.197" ]
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["pgorzynski.freeddns.org"]
  }
}

module "pihole_subnet" {
    source                      = "../modules/subnet"
    compartment_id              = var.compartment_id
    subnet_cidr_block           = var.subnet_cidr_block.piholeSubnet
    oci_core_vcn                = oci_core_vcn.vcn.id
    subnet_name                 = var.subnet_names.piholeSubnet
    dns_label                   = "pihole"
}

resource "oci_core_network_security_group" "pihole_nsg" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn.id
    display_name = "pihole_subnet_nsg"
}


resource "oci_core_network_security_group_security_rule" "pihole_nsg_egress" {
  #checkov:skip=CKV_OCI_2:Ensure NSG does not allow all traffic on RDP port (3389)
  #checkov:skip=CKV2_OCI_2:Ensure NSG does not allow all traffic on RDP port (3389)
  #checkov:skip=CKV_OCI_21:Ensure security group has stateless ingress security rules
network_security_group_id = oci_core_network_security_group.pihole_nsg.id
direction                 = "EGRESS"
protocol                  = "6"
destination               = "0.0.0.0/0"
destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "pihole_nsg_ingress_tcp" {
  #checkov:skip=CKV2_OCI_2:Ensure NSG does not allow all traffic on RDP port (3389)
  #checkov:skip=CKV_OCI_21:Ensure security group has stateless ingress security rules
  #checkov:skip=CKV_OCI_22:Ensure no security groups rules allow ingress from 0.0.0.0/0 to port 22
for_each = toset(["22", "80", "443", "53"])
network_security_group_id = oci_core_network_security_group.pihole_nsg.id
direction                 = "INGRESS"
protocol                  = "6"
source                    = "0.0.0.0/0"
destination_type          = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = each.key
      max = each.key
    }
  }
}

resource "oci_core_network_security_group_security_rule" "pihole_nsg_ingress_udp" {
  #checkov:skip=CKV2_OCI_2:Ensure NSG does not allow all traffic on RDP port (3389)
  #checkov:skip=CKV_OCI_21:Ensure security group has stateless ingress security rules
  #checkov:skip=CKV_OCI_22:Ensure no security groups rules allow ingress from 0.0.0.0/0 to port 22
for_each = toset(["53", "67"])
network_security_group_id = oci_core_network_security_group.pihole_nsg.id
direction                 = "INGRESS"
protocol                  = "17"
source                    = "0.0.0.0/0"
destination_type          = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = each.key
      max = each.key
    }
  }
}