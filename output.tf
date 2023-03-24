output "vpc_id" {
    value = aws_vpc.fishing_vpc.id
}

output "pub_subnet" {
    value = aws_subnet.fishing_pub_sub.id
}

output "priv_subnet" {
    value = aws_subnet.fishing_priv_sub.id
}
