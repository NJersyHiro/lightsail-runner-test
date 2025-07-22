variable "aws_region" {
  description = "AWS region for the Lightsail instance"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name of the Lightsail instance"
  type        = string
  default     = "github-runner-test"
}

variable "availability_zone" {
  description = "Availability zone for the instance"
  type        = string
  default     = "us-east-1a"
}

variable "blueprint_id" {
  description = "Blueprint ID for the instance (OS image)"
  type        = string
  default     = "ubuntu_20_04"
}

variable "bundle_id" {
  description = "Bundle ID for the instance (size/performance)"
  type        = string
  default     = "nano_3_0"  # 512 MB RAM, 1 vCPU, 20 GB SSD
}