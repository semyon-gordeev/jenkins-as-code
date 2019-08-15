resource "aws_ecs_cluster" "cluster" {
  name = "${local.app_full_name}"
}

data "template_file" "ecs_template" {
  template = "${file("${path.module}/service.json")}"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${local.app_full_name}-td"
  container_definitions = "${data.template_file.ecs_template.rendered}"
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "${local.app_full_name}-service"
  cluster                            = "${aws_ecs_cluster.cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.ecs_task.arn}"
  desired_count                      = 1
  deployment_maximum_percent         = "100"
  deployment_minimum_healthy_percent = "0"
}

resource "aws_ecr_repository" "repo" {
  name = "${local.app_full_name}"
}