provider "aws" {
  region = var.aws_region
}

# Fetch the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create or reference a key pair
resource "aws_key_pair" "vpn_key" {
  key_name   = "openvpn-key"
  public_key = file(var.public_key_path)
}

# Security group to allow SSH and OpenVPN
resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn-security-group"
  description = "Allow SSH and OpenVPN traffic"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : null

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # **Recommendation:** Restrict to your IP
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "openvpn-sg"
  }
}

# EC2 Instance running Ubuntu 22.04 LTS
resource "aws_instance" "openvpn" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.vpn_key.key_name
  security_groups        = [aws_security_group.openvpn_sg.name]
  associate_public_ip_address = true
  subnet_id              = var.subnet_id != "" ? var.subnet_id : null

  tags = {
    Name = "OpenVPN-Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y wget
              wget https://git.io/vpn -O openvpn-install.sh
              chmod +x openvpn-install.sh
              AUTO_INSTALL=y ./openvpn-install.sh
              # Copy the .ovpn file to /home/ubuntu/
              cp /root/*.ovpn /home/ubuntu/
              chown ubuntu:ubuntu /home/ubuntu/*.ovpn
              chmod 644 /home/ubuntu/*.ovpn
              EOF

  provisioner "local-exec" {
    command = "echo '${self.public_ip}' > vpn_ip.txt"
  }
}

output "vpn_server_ip" {
  description = "Public IP of the OpenVPN server"
  value       = aws_instance.openvpn.public_ip
}
