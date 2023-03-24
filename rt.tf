
resource "aws_route_table" "fishing_priv_rt" {
    vpc_id = aws_vpc.fishing_vpc.id
}

resource "aws_route_table" "fishing_pub_rt" {
    vpc_id = aws_vpc.fishing_vpc.id
}


resource "aws_route_table_association" "fishing-pub-sub-rt-association" {
    route_table_id = aws_route_table.fishing_pub_rt.id
    subnet_id = aws_subnet.fishing_pub_sub.id
}



resource "aws_route_table_association" "fishing-priv-rt-association" {
    route_table_id = aws_route_table.fishing_priv_rt.id
    subnet_id = aws_subnet.fishing_priv_sub.id
}



resource "aws_route" "route-pub-rt" {
  route_table_id = aws_route_table.fishing_pub_rt.id
  destination_cidr_block = var.rt_destination_cidr
  gateway_id = aws_internet_gateway.fishing_gw.id

}

resource "aws_route" "route-priv1-rt" {
  route_table_id = aws_route_table.fishing_priv_rt.id
  destination_cidr_block = var.rt_destination_cidr
  gateway_id = aws_internet_gateway.fishing_gw.id

}
