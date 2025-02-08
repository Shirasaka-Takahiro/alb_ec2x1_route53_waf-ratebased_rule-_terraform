##ALB
resource "aws_lb" "alb" {
  name               = "${var.general_config["project"]}-${var.general_config["env"]}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.alb_http_sg_id
  ]
  subnets         = var.public_subnet_ids
  ip_address_type = "ipv4"

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-alb"
  }
}

##Target Group
resource "aws_lb_target_group" "tg" {
  name             = "${var.general_config["project"]}-${var.general_config["env"]}-tg"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = "80"
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    path                = "/healthchek.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-tg"
  }
}

##HTTP Listener
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

##Attach target group to the alb
resource "aws_lb_target_group_attachment" "attach_tg_to_alb" {
  count            = length(var.instance_ids)
  target_id        = element(var.instance_ids, count.index % 2)
  target_group_arn = aws_lb_target_group.tg.arn
  port             = 80
}