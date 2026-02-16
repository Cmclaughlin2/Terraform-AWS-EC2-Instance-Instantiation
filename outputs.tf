output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.test_terraform_instance.id
}


output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.test_terraform_instance.public_ip
}


output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.test_terraform_instance.public_dns
}


output "public_ssh_key_usage" {
  description = "Public key used to SSH into the EC2 instance"
  value       = aws_instance.test_terraform_instance.key_name
}