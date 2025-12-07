provider "aws" {

    region = var.region
}


data "aws_ami" "ubuntu-lts" {

    most_recent = true

    owners = ["099720109477"]

    filter {

        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-*.04-amd64-server-*"]
    }

    filter {
      name = "virtualization-type"
        values = ["hvm"]
    }

}


resource "aws_vpc" "my-vpc" {

        cidr_block = var.cidr_vpc

        tags = {

            Name = var.vpc_name
        }
}


resource "aws_subnet" "my-subnet" {

        vpc_id = aws_vpc.my-vpc.id
        cidr_block = var.cidr_subnet
        map_public_ip_on_launch = true
        availability_zone = var.availability_zone

        tags = {

            Name = var.subnet_name
        }


}

resource "aws_security_group" "my-sg" {

        name        = "sg_1"
        vpc_id      = aws_vpc.my-vpc.id

        ingress {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }


        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {

            Name = var.sg_name
        }
}

resource "aws_internet_gateway" "my-igw" {

        vpc_id = aws_vpc.my-vpc.id

        tags = {

            Name = var.igw_name
        }

}


resource "aws_route_table" "my-route-table" {

        vpc_id = aws_vpc.my-vpc.id

        route {

            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.my-igw.id
        }

        tags = {

            Name = var.route_name
        }

}


resource "aws_route_table_association" "my-rta" {

        subnet_id      = aws_subnet.my-subnet.id
        route_table_id = aws_route_table.my-route-table.id


}


resource "aws_instance" "my-ec2" {

        ami           = data.aws_ami.ubuntu-lts.id
        instance_type = var.instance_type
        subnet_id     = aws_subnet.my-subnet.id
        vpc_security_group_ids = [aws_security_group.my-sg.id]
        key_name = var.key_name
        count = var.instance_count

        provisioner "file" {
                source = "anurag.txt"
                destination = "/home/ubuntu/anurag.txt"

                connection {

                type = "ssh"
                user = "ubuntu"
                private_key = file("/home/ubuntu/terraform/DevOps.pem")
                host = self.public_ip
                }

}
        provisioner "local-exec" {

                command = "echo Instance created with Public IP : ${self.public_ip}"

}

        provisioner "remote-exec" {


        inline = [

        "sudo apt update",
        "sudo apt install -y maven"


        ]

        connection {

        type = "ssh"
        user = "ubuntu"
        private_key = file("/home/ubuntu/terraform/DevOps.pem")
        host = self.public_ip

        }

}



        tags = {

            Name = "${var.ec2_name}-${count.index + 1}"
        }

        root_block_device {
          volume_size = var.root_volume_size
          volume_type = var.root_volume_type
        }
}