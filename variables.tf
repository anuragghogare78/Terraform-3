variable "region" {

    description = "The AWS region to deploy resources in"


}

variable "vpc_name" {

    description = "The name of the VPC"

}

variable "subnet_name" {

    description = "The name of the subnet"

}

variable "cidr_vpc" {

    description = "The CIDR block for the VPC"


}

variable "cidr_subnet" {

    description = "The CIDR block for the public subnet"


}

variable "availability_zone" {

        description = "The availability zone for the subnet"
}

variable "sg_name" {

        description = "The name of the security group"

}

variable "igw_name" {

        description = "The name of the Internet Gateway"
}


variable "route_name" {

        description = "The name of the route"
}


# variable "ami_id" {

#         description = "The AMI ID for the EC2 instance"
# }

variable "instance_type" {

     description = "The instance type for the EC2 instance"
}


variable "key_name" {

        description = "The name of the key pair for the EC2 instance"
}


variable "instance_count" {

        description = "The number of EC2 instances to launch"
}

variable "ec2_name" {

        description = "The name tag for the EC2 instance"

}

variable "root_volume_size" {


        description = "The size of the root volume in GB"
}

variable "root_volume_type" {

        description = "The type of the root volume"
}

