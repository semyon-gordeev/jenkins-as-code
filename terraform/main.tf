terraform {
  required_version = ">= 0.11.11"
}

provider "aws" {
  version = "~> 2.1"
  region  = "${var.aws_region}"
  profile = "myaws"
}

locals {
  app_full_name = "${var.env}-${var.app_name}"
}

resource "aws_security_group" "sg" {
  name        = "${local.app_full_name}-sg"
  description = "${local.app_full_name}-sg"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  instance_type               = "${var.jenkins_instance_type}"
  ami                         = "${var.jenkins_ami}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  subnet_id                   = "${aws_subnet.public1.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.jenkins_profile.name}"
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 10
    delete_on_termination = true
  }

  tags {
    Name = "jenkins-${var.env}"
  }
}
