terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_lightsail_instance" "github_runner" {
  name              = var.instance_name
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  
  tags = {
    Name        = var.instance_name
    Purpose     = "GitHub Self-Hosted Runner"
    Environment = "test"
  }
}

resource "aws_lightsail_instance_public_ports" "github_runner" {
  instance_name = aws_lightsail_instance.github_runner.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }
}