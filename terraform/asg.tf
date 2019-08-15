resource "aws_launch_configuration" "asg_conf" {
  name                 = "${local.app_full_name}-ecs-lc-${replace(timestamp(), ":", "-")}"
  security_groups      = ["${aws_security_group.sg.id}"]
  key_name             = "${var.key_name}"
  image_id             = "${var.asg_ami}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${local.app_full_name} >> /etc/ecs/ecs.config
echo "0 9 * * * sleep $[($RANDOM % 10)*3]m && yum --security update-minimal -y && yum update -y ecs-init" | crontab -
EOF

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["name"]
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "ecs-${local.app_full_name}-asg"
  vpc_zone_identifier       = ["${aws_subnet.public1.id}"]
  min_size                  = "1"
  max_size                  = "1"
  desired_capacity          = "1"
  launch_configuration      = "${aws_launch_configuration.asg_conf.name}"
  health_check_grace_period = 0
  health_check_type         = "EC2"
  termination_policies      = ["NewestInstance"]

  tag {
    key                 = "Name"
    value               = "ECS - ${local.app_full_name}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["desired_capacity"]
  }
}
