# Terraform-AWS-EC2-Instance-Instantiation
This project demonstrates how to use Terraform to provision an Amazon Linux EC2 instance in an existing AWS VPC. It is designed as an entry-level project for IT professionals and cloud engineers who want to learn infrastructure as code and basic AWS resource management.

# Terraform AWS EC2 Deployment

This Terraform configuration provisions an Amazon EC2 instance within an existing VPC and subnet, along with a dedicated security group allowing SSH and HTTPS access. The EC2 instance uses the latest Amazon Linux 2 AMI.

## Table of Contents

- [Prerequisites](#prerequisites)  
- [Files](#files)  
- [Variables](#variables)  
- [Usage](#usage)  
- [Generating an SSH Key](#generating-an-ssh-key)  
- [SSH into the EC2 Instance](#ssh-into-the-ec2-instance)  
- [Resources Created](#resources-created)  
- [Outputs](#outputs)  
- [Security Considerations](#security-considerations)  

---

## Prerequisites

Before using this configuration, ensure you have:

- Terraform version >= 1.5.0  
- An AWS account with proper credentials configured  
- An existing VPC and subnet  
- AWS CLI configured with the appropriate profile  
- Optional: An existing SSH key pair for EC2 access (or generate one, see below)  

---

## Files

- `main.tf`        : Core Terraform configuration including provider setup, data sources, security group, and EC2 instance resource  
- `variables.tf`   : Variable definitions for region, resource names, subnet, VPC, security groups, and other parameters  
- `outputs.tf`     : Terraform outputs providing instance information like ID, public IP, DNS, and SSH key pair name used  
- `terraform.tfvars` : User-provided values for the variables (not included in repository, contains sensitive data)  

---

## Variables

| Variable Name        | Description                                        | Type   | Default             |
|---------------------|----------------------------------------------------|--------|-------------------|
| `region`            | AWS region to deploy resources                     | string | us-east-2         |
| `name`              | Prefix name for resources                           | string | demo              |
| `IngressIP`         | IP address allowed to access EC2 via SSH/HTTPS     | string |    |
| `aws_profile`       | AWS CLI profile name                                | string | |
| `instance_type`     | EC2 instance type                                   | string | t3.micro          |
| `key_name`          | Name of existing AWS EC2 key pair for SSH          | string |                  |
| `vpc_id`            | ID of the existing VPC                               | string |                  |
| `subnet_id`         | ID of the existing subnet                             | string |                  |
| `security_group_id` | ID of an existing security group to reference (optional) | string |           |

> **Note:** All required variables without defaults must be defined in the `terraform.tfvars` that you create.

## Creating Your `terraform.tfvars` File

Before running Terraform, create a `terraform.tfvars` file to provide the required variable values. This file ensures Terraform knows which VPC, subnet, security group, and SSH key to use.

### Steps to create `terraform.tfvars`

1. Create the file in the same directory as your Terraform files:

## Example `terraform.tfvars` Values

| Variable Name        | Example Value                                    | Description                                       |
|---------------------|-------------------------------------------------|--------------------------------------------------|
| `region`            | `us-east-2`                                     | AWS region to deploy resources                   |
| `name`              | `demo`                                          | Prefix name for resources                         |
| `IngressIP`         | `203.0.113.2`                               | IP address allowed to access EC2 via SSH/HTTPS   |
| `aws_profile`       | `user_profile`                             | AWS CLI profile name                              |
| `instance_type`     | `t3.micro`                                      | EC2 instance type                                 |
| `key_name`          | `my-ec2-key`                                    | Name of SSH key pair in AWS                       |
| `vpc_id`            | `vpc-0abcd1234efgh5678`                         | ID of the existing VPC                             |
| `subnet_id`         | `subnet-0abcd1234efgh5678`                      | ID of the existing subnet                           |
| `security_group_id` | `sg-0abcd1234efgh5678`                          | Optional: existing security group ID             |

## Notes on `terraform.tfvars`

- Replace example values with your actual AWS account information.  
- Ensure `IngressIP` matches your current machine’s public IP to allow SSH access.  
- Keep this file secure; it contains sensitive information.  
- Save the file. Terraform will automatically use the values from this file when you run `terraform plan` or `terraform apply`.

---

## Usage

### Initialize Terraform
```bash
terraform init
```

### Validate Configuration
```bash
terraform validate
```

### Preview Changes
```bash
terraform plan
```

### Apply Configuration
```bash
terraform apply
```

### Destroy Resources
```bash
terraform destroy
```

### Generating an SSH Key

### If you do not have an existing AWS EC2 SSH key pair, generate one locally and import it to AWS:

### 1. Generate a key pair locally
```bash
ssh-keygen -t <type> -b <key_size> -f <your-chosen-file-path>
```

### 2. Import the public key to AWS
```bash
aws ec2 import-key-pair --key-name <your-key-name> --public-key-material file:<your-file-path> --profile <your_profile> --region <your_region>
```

# SSH into the EC2 Instance

### SSH into your instance
```bash
ssh -i <file_path_to_your_private_key> ec2-user@<instance_public_ip>
```

## Resources Created

### Security Group: `<name>-ec2-sg`
- **Ingress Rules:**
  - TCP **22 (SSH)** from `IngressIP`
  - TCP **443 (HTTPS)** from `IngressIP`
- **Egress Rules:**
  - All outbound traffic

### EC2 Instance: `<name>-instance`
- **AMI:** Latest Amazon Linux 2  
- **Subnet:** Existing subnet (`subnet_id`)  
- **Security Group:** Newly created EC2 security group (`<name>-ec2-sg`)  
- **SSH Key Pair:** Existing or generated key (`key_name`)  
- **Metadata Options:** IMDSv2 enforced for enhanced security

### Outputs
These values come from the `outputs.tf` file:

| Output Name            | Description                                  |
|------------------------|----------------------------------------------|
| `instance_id`          | The ID of the EC2 instance                   |
| `instance_public_ip`   | Public IP address of the EC2 instance       |
| `instance_public_dns`  | Public DNS of the EC2 instance              |
| `public_ssh_key_usage` | Name of the key pair used to SSH into instance |


### Security Considerations

# - Only the IP defined in IngressIP can access the EC2 instance via SSH and HTTPS
# - IMDSv2 is enforced to improve instance metadata security
# - Ensure terraform.tfvars does not get committed to version control as it may contain sensitive information
# - SSH private keys should be stored securely and not shared
