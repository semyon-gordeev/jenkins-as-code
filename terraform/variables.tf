variable "app_name" {
  default = "yourcluster"
}

variable "env" {
  default = "prod"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "asg_ami" {
  default = "ami-0fac5486e4cff37f4"
}

variable "jenkins_ami" {
  default = "ami-07d0cf3af28718ef8"
}

variable "key_name" {
  default = "myaws"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "jenkins_instance_type" {
  default = "t2.small"
}