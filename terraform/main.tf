#providers
#Error: Failed to query available provider packages
# Configure the AWS Provider

provider "aws"{
  region = var.region
}

#AWS resource code
resource "aws_instance" "myEC2" {
  ami = var.ami_id 
  instance_type = var.instance_type
  key_name = "kp"
  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }

  tags = {
    Name = "Webserver"
  }
#userdata

user_data = <<-EOF

#!/bin/bash

sudo yum -y update
sudo amazon-linux-extras install epel
sudo yum  install nginx -y
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx

sudo rm -rf /usr/share/nginx/html/*

sudo wget https://html5up.net/tessellate/download --no-check-certificate -P /tmp/
sudo unzip /tmp/download -d /usr/share/nginx/html/
EOF

}

#default VPC
resource "aws_default_vpc" "vpc" {

}

#Security group
resource "aws_default_security_group" "traffic" {
  vpc_id      = aws_default_vpc.vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

