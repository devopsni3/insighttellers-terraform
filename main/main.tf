provider "aws" {
  region  = "us-east-1"
  access_key = "AKIA6NOHM6G6O25H54UI"
  secret_key = "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"
}

resource "aws_vpc" "pesca360_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "pesca360 VPC"
  }
}

resource "aws_subnet" "pesca360_public_subnet" {
  vpc_id            = aws_vpc.pesca360_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pesca360 Public Subnet"
  }
}

resource "aws_subnet" "pesca360_private_subnet" {
  vpc_id            = aws_vpc.pesca360_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pesca360 Private Subnet"
  }
}

resource "aws_internet_gateway" "pesca360_ig" {
  vpc_id = aws_vpc.pesca360_vpc.id

  tags = {
    Name = "pesca360 Internet Gateway"
  }
}

resource "aws_route_table" "pesca360_public_rt" {
  vpc_id = aws_vpc.pesca360_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pesca360_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.pesca360_ig.id
  }

  tags = {
    Name = "pesca360 Public Route Table"
  }
}

resource "aws_route_table_association" "pesca360_public_1_rt_a" {
  subnet_id      = aws_subnet.pesca360_public_subnet.id
  route_table_id = aws_route_table.pesca360_public_rt.id
}

resource "aws_security_group" "pesca360_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.pesca360_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "m4.xlarge"
  key_name      = "pesca360"

  subnet_id                   = aws_subnet.pesca360_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.pesca360_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  sudo amazon-linux-extras install docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo chkconfig docker on
  sudo yum install -y git
  sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  EOF

  tags = {
    "Name" : "pesca360"
  }
}
