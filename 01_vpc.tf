resource "aws_vpc" "dcore" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.dcore.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"
}
# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.dcore.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-1b"
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.dcore.id}"
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.dcore.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}
resource "aws_route_table" "db-private-rt" {
  vpc_id = "${aws_vpc.dcore.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}
# Create elastic ip for nat gateway
resource "aws_eip" "dcore-nat" {
  vpc= true
}

resource "aws_nat_gateway" "dcore-nat-gw" {
    allocation_id = "${aws_eip.dcore-nat.id}"
    subnet_id = "${aws_subnet.public-subnet}"
    depends_on = ["aws_internet_gateway.gw"]
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

resource "aws_route_table_association" "db-private-rt" {
  subnet_id = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.db-private-rt.id}"
}



# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
  name = "vpc_test_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  vpc_id="${aws_vpc.dcore.id}"
}

# Define the security group for private subnet
resource "aws_security_group" "sgdb"{
  name = "sg_test_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.dcore.id}"
}

resource "aws_network_acl" "dcore_default" {
  vpc_id = "${aws_vpc.dcore.id}"

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 40001
    to_port    = 40001
  }

  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 40000
    to_port    = 40000
  }

   egress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }
}