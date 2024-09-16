#!/bin/bash

# Replace [user] and [path to your private key] with your own information
user="ec2-user"
private_key="~/.ssh/aws.cer"

# Replace [path to the file containing instance public IPs] with the actual path to your file
public_ips_file="/Users/mac/Projects/aws_files/scripts/public_ips.txt"

# Read the content of the file containing instance public IPs into an array
instances=()
while IFS= read -r line; do
  instances+=("$line")
done < "$public_ips_file"

# Replace [public keys] with your own public keys
public_keys=("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmLMoQyUgedx7zkU7Axgp06rJTn+1G9avQf/KrB6TPC7tQGDshN4CXv0dTvdDtZFOBarIn+zdQ8lUktLim0/InZv+hFyCFbazkRxwqlUqKnD4ywQxf+ZCBCEnhPfl/lCGiHjYiQF6kyLQP7JXb54HQ6RJK8UPodZtJBvbMSHzeV8j0N9SUMhE+8Dbm2nfSpg/SyzPL90KiODAhGYJ8LoplUHC7jWlxokdOr/8iDG68KnR+Vtd4d41EZAOelvCvEmTfp0wqVnNH/9Xg6lH/H16sr69YTpeoQ1/3yzTIl+YuJiWkcJdFtgsk+OWLvcF1ETNBOHiDzciBgbzT3ye73Ss9 ec2-user@ip-172-31-92-165.ec2.internal")

for instance in "${instances[@]}"; do
  echo "Copying public key to $instance..."
  # Copy the public key to the instance
  ssh-keyscan -t rsa "$instance" >> ~/.ssh/known_hosts
  for key in "${public_keys[@]}"; do
    echo "Adding public key to authorized keys on $instance..."
    ssh -i "$private_key" "$user@$instance" "mkdir -p ~/.ssh && echo \"$key\" >> ~/.ssh/authorized_keys"
  done
done

echo "Script execution completed."
