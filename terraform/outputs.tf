output "instance_public_ip" {
  description = "Public IP address of the Lightsail instance"
  value       = aws_lightsail_instance.github_runner.public_ip_address
}

output "instance_name" {
  description = "Name of the Lightsail instance"
  value       = aws_lightsail_instance.github_runner.name
}

output "instance_state" {
  description = "State of the Lightsail instance"
  value       = aws_lightsail_instance.github_runner.state
}