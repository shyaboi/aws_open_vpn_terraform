# #!/bin/bash

./terraform init

./terraform apply -auto-approve

sleep 65

ip=$(cat vpn_ip.txt | xargs)

# Debugging: Show the original value of 'ip'
echo "Original IP: [$ip]"

# Remove leading and trailing single quotes
ip=$(echo "$ip" | sed "s/^'//; s/'$//")

# Debugging: Show the updated value of 'ip'
echo "Cleaned IP: [$ip]"

# Run the scp command with the cleaned 'ip' variable, auto-accepting the fingerprint
# echo scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@$ip:/home/ubuntu/*.ovpn .
scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@$ip:/home/ubuntu/*.ovpn .