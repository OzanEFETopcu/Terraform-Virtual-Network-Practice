terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}

resource "aws_security_group" "vpc-web" {
  name = "vpc-web"
  description = "VPC Web"
  ingress {
    description = "Allow Port 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    description = "Allow Port 443"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress{
    description = "Allow all ip and ports outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-0274f4b62b6ae3bd5"
  instance_type = "t3.micro"
  user_data = file("${path.module}/simpleWeb.sh")
  tags = {
    "Name" = "EC2 Demo"  
  }
  vpc_security_group_ids = [aws_security_group.vpc-web.id]
}