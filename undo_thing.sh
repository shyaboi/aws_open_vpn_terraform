#!/bin/bash
./terraform destroy -auto-approve

rm -r .terraform

rm .terraform.lock.hcl

rm client.ovpn

rm terraform.tfstate

rm terraform.tfstate.backup

rm vpn_ip.txt