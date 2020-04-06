# Define our VPC
resource "aws_vpc" "infra-eu-vpc" {
  cidr_block           = "${var.infra-vpc-cidr}"
  enable_dns_hostnames = true
  #enable_classiclink    = true

  tags = {
    Name = "infra-vpc"
  }
}

#Define public subnets
resource "aws_subnet" "infra-public-subnet-01" {
  vpc_id            = "${aws_vpc.infra-eu-vpc.id}"
  cidr_block        = "${var.infra-public-subnet-cidr-01}"
  availability_zone = "us-east-2a"

  tags = {
    Name = "infra-pub-sub-01"
  }
}

resource "aws_subnet" "infra-public-subnet-02" {
  vpc_id            = "${aws_vpc.infra-eu-vpc.id}"
  cidr_block        = "${var.infra-public-subnet-cidr-02}"
  availability_zone = "us-east-2b"

  tags = {
    Name = "infra-pub-sub-02"
  }
}

resource "aws_subnet" "infra-public-subnet-03" {
  vpc_id            = "${aws_vpc.infra-eu-vpc.id}"
  cidr_block        = "${var.infra-public-subnet-cidr-03}"
  availability_zone = "us-east-2c"

  tags = {
    Name = "infra-pub-sub-03"
  }
}

#Define private subnets
resource "aws_subnet" "infra-private-subnet-01" {
  vpc_id            = "${aws_vpc.infra-eu-vpc.id}"
  cidr_block        = "${var.infra-private-subnet-cidr-01}"
  availability_zone = "us-east-2a"

  tags = {
    Name = "infra-prv-sub-01"
  }
}

resource "aws_subnet" "infra-private-subnet-02" {
  vpc_id            = "${aws_vpc.infra-eu-vpc.id}"
  cidr_block        = "${var.infra-private-subnet-cidr-02}"
  availability_zone = "us-east-2b"

  tags = {
    Name = "infra-prv-sub-02"
  }
}

resource "aws_subnet" "infra-private-subnet-03" {
  vpc_id            = "${aws_vpc.infra-eu-vpc.id}"
  cidr_block        = "${var.infra-private-subnet-cidr-03}"
  availability_zone = "us-east-2c"

  tags = {
    Name = "infra-prv-sub-03"
  }
}


# Define internet gateway
resource "aws_internet_gateway" "infra-igw" {
  vpc_id = "${aws_vpc.infra-eu-vpc.id}"

  tags = {
    Name = "infra-igw"
  }
}

#Define nat gateway
resource "aws_eip" "infra-nat-gw-eip" {
  vpc                       = true
  tags = {
    Name = "infra-nat-gw-eip"
  }
}

resource "aws_nat_gateway" "infra-nat-gw" {
  allocation_id = "${aws_eip.infra-nat-gw-eip.id}"
  subnet_id     = "${aws_subnet.infra-public-subnet-01.id}"
  tags = {
    Name = "infra-nat-gw"
  }

  depends_on = ["aws_internet_gateway.infra-igw","aws_eip.infra-nat-gw-eip"]
}

#Define the public route table
resource "aws_route_table" "infra-pub-rtb" {
  vpc_id = "${aws_vpc.infra-eu-vpc.id}"

  tags = {
    Name = "infra-pub-rtb"
  }
}

#Define the private route table
resource "aws_route_table" "infra-prv-rtb" {
  vpc_id = "${aws_vpc.infra-eu-vpc.id}"
  tags = {
    Name = "infra-prv-rtb"
  }
}

# Assign the public subnets to public route table
resource "aws_route_table_association" "infra-pub-rtb-assoc-01" {
  subnet_id      = "${aws_subnet.infra-public-subnet-01.id}"
  route_table_id = "${aws_route_table.infra-pub-rtb.id}"
}

resource "aws_route_table_association" "infra-pub-rtb-assoc-02" {
  subnet_id      = "${aws_subnet.infra-public-subnet-02.id}"
  route_table_id = "${aws_route_table.infra-pub-rtb.id}"
}

resource "aws_route_table_association" "infra-pub-rtb-assoc-03" {
  subnet_id      = "${aws_subnet.infra-public-subnet-03.id}"
  route_table_id = "${aws_route_table.infra-pub-rtb.id}"
}

# Assign the private subnets to private route table
resource "aws_route_table_association" "infra-prv-rtb-assoc-01" {
  subnet_id      = "${aws_subnet.infra-private-subnet-01.id}"
  route_table_id = "${aws_route_table.infra-prv-rtb.id}"
}

resource "aws_route_table_association" "infra-prv-rtb-assoc-02" {
  subnet_id      = "${aws_subnet.infra-private-subnet-02.id}"
  route_table_id = "${aws_route_table.infra-prv-rtb.id}"
}

resource "aws_route_table_association" "infra-prv-rtb-assoc-03" {
  subnet_id      = "${aws_subnet.infra-private-subnet-03.id}"
  route_table_id = "${aws_route_table.infra-prv-rtb.id}"
}

#Route to internet gateway from public route table
resource "aws_route" "infra-igw-route" {
  route_table_id            = "${aws_route_table.infra-pub-rtb.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.infra-igw.id}"
  depends_on                = ["aws_route_table.infra-pub-rtb","aws_internet_gateway.infra-igw"]
}

resource "aws_route" "infra-nat-gw-route" {
  route_table_id            = "${aws_route_table.infra-prv-rtb.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = "${aws_nat_gateway.infra-nat-gw.id}"
  depends_on                = ["aws_route_table.infra-prv-rtb","aws_nat_gateway.infra-nat-gw"]
}