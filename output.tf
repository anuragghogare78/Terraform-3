output "public_ip" {

  value = [for instance in aws_instance.my-ec2 : instance.public_ip]

}

output "instance_name" {

  value = [for instance in aws_instance.my-ec2 : instance.tags.Name]

}

output "debug" {

  value = data.aws_ami.ubuntu-lts

}
