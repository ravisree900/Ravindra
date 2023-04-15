resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_instance" "my_instance" {
  ami = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet.id
  key_name = "my-key"

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("${path.module}/my-key.pem")
    host = aws_instance.my_instance.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}

resource "aws_security_group" "my_sg" {
  name = "my_sg"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}
