resource "aws_instance" "ec2_instances" {
  for_each      = var.instances
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair
  security_groups = var.security_group
  root_block_device {
    volume_size = var.volume_size_gb
  }

  tags = {
    Name = each.key
  }
}

output "public_ips" {
  value = { for instance_name, instance in aws_instance.ec2_instances : instance_name => instance.public_ip }
}

output "private_ips" {
  value = { for instance_name, instance in aws_instance.ec2_instances : instance_name => instance.private_ip }
}

resource "aws_instance" "ansible" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_pair
  security_groups = var.security_group
  root_block_device {
    volume_size = var.volume_size_gb
  } 
  tags = {
    Name = "ansible_master"
  }
  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install -y python3.7
            sudo yum install -y python3-pip
            python3 -m pip install --user --upgrade pip
            python3 -m pip install ansible
            EOF
}

output "ansible_publicip" {
  value = aws_instance.ansible.public_ip
}