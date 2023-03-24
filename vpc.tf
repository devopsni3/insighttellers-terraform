resource "aws_vpc" "fishing_vpc" {
cidr_block = var.vpcid

tags = {
    Name = "fishing_vpc"
  }

}

resource "aws_internet_gateway" "fishing_gw" {
    vpc_id = aws_vpc.fishing_vpc.id

}