variable "aws_region" {
  description = "AWS region to deploy the VPN"
  default     = "us-west-2" # Change region as needed
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  default     = "~/ssh/id_rsa.pub" #set your pub ket location
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro" # Eligible for free tier
}

variable "vpc_id" {
  description = "VPC ID where the instance will be launched"
  default     = "" # Optional: If left blank, default VPC will be used
}

variable "subnet_id" {
  description = "Subnet ID within the VPC"
  default     = "" # Optional: If left blank, default subnet will be used
}
