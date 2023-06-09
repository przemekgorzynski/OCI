#CONECTION
variable "tenancy_ocid"                     {}
variable "user_ocid"                        {}
variable "fingerprint"                      {}
variable "private_key_path"                 { default = "/home/runner/.ssh/key.pem" }

#GENERAL
variable "compartment_id"                   { default = "ocid1.tenancy.oc1..aaaaaaaai6pwlqfxlt2bw7jw5uti2hf2jnwmaxr6wdyrap3q7pqxbjn4bvwa" }
variable "region"                           { default = "eu-frankfurt-1" }
variable "availability_domains"             { 
  type = list  
  default = ["WHWJ:EU-FRANKFURT-1-AD-1", "WHWJ:EU-FRANKFURT-1-AD-2", "WHWJ:EU-FRANKFURT-1-AD-3"]
}
variable "fault_domains"                    { 
  type = list
  default = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]
}  
variable "local_public_key_path"            { default = "./id_rsa.pub"}
variable "volume_device"                    { default = "/dev/oracleoci/oraclevdb" }

#NETWORKING
variable "vcn_name"                         { default = "Oracle-vcn" }
variable "vcn_is_ipv6enabled"               { default = "false" }
variable "internet_gateway_display_name"    { default = "Internet gateway" }
variable "route_table_display_name"         { default = "Route table" }
variable "vcn_address_space"  {
  type = map(string)
  default = {
    vcn               = "10.0.0.0/16"
  }
}
variable "subnet_cidr_block"  {
  type = map(string)
  default = {
    piholeSubnet      = "10.0.1.0/24"
  }
}
variable "subnet_names"       {
  type = map(string)
  default = {
    piholeSubnet      = "pihole_subnet"
  }
}

#PIHOLE
variable "pihole_hostname"                  { default = "pihole-vm" }
variable "pihole_shape"                     { default = "VM.Standard.E2.1.Micro" }
variable "pihole_memory"                    { default = "1" }
variable "pihole_ocpus"                     { default = "1" }
variable "pihole_private_ip"                { default = "10.0.1.100" }
#https://docs.oracle.com/en-us/iaas/images/ - images #Ubuntu22.04
variable "pihole_image_id"                  { default = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaany47uztnfnnuj3ccxztw3bq6dma6djo3gn3uemjwplcgklgy774a" }
variable "pihole_block_display_name"        { default = "pihole-disk" }
variable "pihole_block_volume_size_in_gbs"  { default = "50" }
variable "pihole_block_volume_vpus_per_gb"  { default = "10" }

# AMD
# VM.Standard.E2.1.Micro, VM.Standard.A1.Flex
# 1GB 1CPU