provider "aws" {
  region = "us-east-1"
  access_key = "AKIARP72LJ4GGANATRPY"
  secret_key = "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"
}
resource "aws_instance" "QAserver" {
  ami = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  count = 3
  key_name = "jannu"
  tags = {
    Name = "QAserver${count.index + 1}"
  }
}