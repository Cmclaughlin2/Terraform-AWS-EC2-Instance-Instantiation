variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "name" {
  description = "Prefix name for resources"
  type = string
  default ="demo"
}

variable "IngressIP" {
  description = "IP address of node that will send ingress traffic."
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "profile_name"
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}


variable "key_name" {
  description = "Name of the existing AWS EC2 Key Pair to use for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the existing subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID of the existing security group"
  type        = string
}
