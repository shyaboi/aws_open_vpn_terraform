# AWS OpenVPN Server Deployment with Terraform

This project automates the setup and teardown of an OpenVPN server on an AWS instance using Terraform and Bash scripts. The setup includes the creation of the necessary AWS infrastructure, SSH keys, and VPN access. After deployment, a client `.ovpn` file is generated for connecting to the VPN server.

## Requirements

- **Terraform**: Install Terraform from [terraform.io](https://www.terraform.io/downloads), or use the .exe in the dir.
- **AWS Account**: Make sure you have valid AWS credentials configured, either in `~/.aws/credentials` or through environment variables.
- **SSH Key**: A public SSH key file for accessing the instance. This should be specified in your Terraform configuration.
- **OpenVPN Client**: Any OpenVPN-compatible client to connect to the VPN using the generated `.ovpn` file.

## Configuration

### Files

- **`main.tf`**: The main Terraform configuration file defining the resources (AWS instance, security groups, etc.) needed to set up the VPN server.
- **`variables.tf`**: Contains the configurable variables like AWS region, instance type, SSH key path, etc.
- **`do_thing.sh`**: A script to initialize and apply the Terraform configuration, retrieve the IP of the VPN server, and download the `.ovpn` client configuration file.
- **`undo_thing.sh`**: A script to tear down the Terraform setup and clean up generated files.

### Variables

The configuration can be customized by modifying the `variables.tf` file:

- `aws_region`: The AWS region where the instance will be deployed.
- `instance_type`: The type of AWS instance to be used (e.g., `t2.micro`).
- `public_key_path`: Path to your SSH public key file.
- Other settings such as instance name tags can also be adjusted here.

## Usage

### 1. Set Up the VPN Server

Run `do_thing.sh` to initialize Terraform, deploy the instance, and retrieve the `.ovpn` file.

```bash
./do_thing.sh
```

# VPN Setup and Management Script

This script performs the following steps:

1. **Initialize and Deploy with Terraform**

   - Initializes Terraform and applies the configuration.
   - Waits for the instance to fully initialize (`sleep 65` ensures the server is ready).
   - Reads the public IP of the VPN server from `vpn_ip.txt`.
   - Downloads the generated `.ovpn` file to the local directory, which can be used with an OpenVPN client.

2. **Connect to the VPN**

   - Once the `client1.ovpn` file is downloaded, you can use it with an OpenVPN client to connect to your VPN server.

   **Linux CLI:**

```bash
   sudo openvpn --config client1.ovpn
```

## macOS: Use an OpenVPN client like Tunnelblick.

## Windows: Use OpenVPN GUI.

### Tear Down the VPN Server

Run `undo_thing.sh` to destroy the Terraform-managed resources and clean up local files.

```bash
./undo_thing.sh
```

# This script will:

- Run `terraform destroy` to remove the deployed AWS instance and related resources.
- Delete generated Terraform files:
  - `.terraform`
  - `.terraform.lock.hcl`
  - `client.ovpn`
  - `terraform.tfstate`
  - `terraform.tfstate.backup`
  - `vpn_ip.txt`

## Troubleshooting

- Ensure your AWS credentials are properly configured and have sufficient permissions.
- Verify that your SSH key path in `variables.tf` is correct and accessible.
- If the `.ovpn` file isn't generated or accessible, check the instance logs to ensure the OpenVPN installation completed successfully.

## License

This project is licensed under the MIT License.
