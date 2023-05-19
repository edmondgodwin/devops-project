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

