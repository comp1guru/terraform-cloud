### VPC Network Setup
resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_tag_name}"
  }
}

# Create the tgw private subnet
resource "aws_subnet" "private_tgw_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.private_tgw_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = var.private_tgw_subnet_tag_name[count.index]
  }
}

# Create the private subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = var.private_subnet_tag_name[count.index]

  }
}

# Create the dhcp option set
resource "aws_vpc_dhcp_options" "domain" {
  domain_name         = "domain.com"
  domain_name_servers = var.dhcp_options_block

  tags = {
    Name = "domain.com"
  }
}
# VPC DHCP Options Association resource
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.custom_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.domain.id
}


# Route the private subnet traffic through the IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.custom_vpc.id

  /*   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  } */

  tags = {
    Name = "${var.route_table_tag_name}"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "internet_access" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.main.id
}

# Route table and subnet associations
resource "aws_route_table_association" "tgw_access" {
  count          = length(var.private_tgw_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_tgw_subnet[count.index].id
  route_table_id = aws_route_table.main.id
}

