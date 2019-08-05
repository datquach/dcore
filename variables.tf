variable "projectname" {
  default = "dcore"
}

variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "192.168.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "192.168.11.0/24"
}

variable "ami" {
  description = "AMI for EC2"
  default = "ami-4fffc834"
}

variable "instancetype" {
  default = "t3.xlarge"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/core/.ssh/id_rsa.pub"
}

variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "ecs_key_pair_name" {
  description = "ECS key pair name"
}

variable "dcore_environment" {
  description = "Dcore enviroment DEV/Prod"
}

variable "aws_profile" {
  description = "AWS Profiles which is used for running terraform"
}
