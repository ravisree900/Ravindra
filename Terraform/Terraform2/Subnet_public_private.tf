provider "aws" {
  alias = "primary"
  region = "ap-south-1"
  access_key = "AKIA3MICQOWUKKASCKSG"
  secret_key = "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"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private.id
}

resource "aws_security_group" "mySG" {
  name_prefix = "mySG"
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_instance" {
  ami = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name = "dhatri"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.mySG]
  tags = {
    Name = "public_instance"
  }
}

resource "aws_instance" "private_instance" {
  ami = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name = "dhatri"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.mySG]
  tags = {
    Name = "private_instance"
  }
}