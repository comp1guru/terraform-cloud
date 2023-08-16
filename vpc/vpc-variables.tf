variable "vpc_tag_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "route_table_tag_name" {
  type        = string
  default     = "vpcroute-table"
  description = "Route table description"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "172.20.64.0/21"
  description = "CIDR block range for vpc"
}

variable "dhcp_options_block" {
  type        = list(string)
  default     = ["172.20.0.234", "172.20.2.196", "AmazonProvidedDNS"]
  description = "DNS servers for VPC"

}

variable "private_tgw_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["172.20.68.0/27", "172.20.68.32/27"]
  description = "CIDR block range for the private tgw subnet"
}
variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["172.20.68.64/26", "172.20.68.128/26", "172.20.64.0/23", "172.20.66.0/23"]
  description = "CIDR block range for the private subnet"
}

variable "private_tgw_subnet_tag_name" {
  type        = list(string)
  description = "Name tag for the private tgw subnet"
}
variable "private_subnet_tag_name" {
  type        = list(string)
  description = "Name tag for the private subnet"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of availability zones for the selected region"
}
