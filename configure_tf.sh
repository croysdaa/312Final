#!/usr/bin/env bash

cat <<EOF >configure_tf.sh
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
  region                   = "us-east-1"
  shared_credentials_files = ["/.aws/credentials"]
}

resource "aws_instance" "app_server" {
  ami           = "ami-01e5ff16fd6e8c542"
  instance_type = "t2.large"
  key_name = "tf-key-pair"
  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "tf-key-pair" {
  key_name = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "../../../tf-key-pair"
}

data "local_file" "private_key_path" {
  filename = local_file.tf-key.filename
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port	= 0
    to_port	= 0
    protocol	= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.example.id
  cidr_blocks       = ["0.0.0.0/0"]
}
EOF

cat <<EOF >output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.app_server.public_dns
}

output "private_key_path" {
  value = data.local_file.private_key_path.filename
}
EOF

cat <<EOF >variables.tf
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "MinecraftFinal"
}
EOF
