# -------------------------
# AWS Required Provider
# -------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}


provider "aws" {
  region  = var.region
  profile = var.aws_profile
}


# Data source to reference your existing VPC by ID
data "aws_vpc" "existing" {
  id = var.vpc_id
}


# Data source to reference your existing subnet by ID
data "aws_subnet" "existing" {
  id = var.subnet_id
}


# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.name}-ec2-sg"
  description = "EC2 security group for SSH and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.IngressIP]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.IngressIP]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.name}-ec2-sg"
    ManagedBy = "Terraform"
  }
}


# -------------------------
# EC2 AMI Selection
# -------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-*"]
  }
}


# Data source to reference your existing security group by ID
data "aws_security_group" "existing" {
  id = var.security_group_id
}


# Data source for the SSH keys query
data "aws_key_pair" "existing" {
  key_name = var.key_name
}


# -------------------------
# EC2 Instance Instantiation
# -------------------------
resource "aws_instance" "test_terraform_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.existing.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  # Enforce IMDSv2
  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.name}-instance"
    ManagedBy = "Terraform"
  }
}