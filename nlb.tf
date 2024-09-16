resource "aws_lb" "wireguard" {
  name               = "${var.project}-wireguard-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [var.nlb_subnet_id]
  security_groups    = [aws_security_group.wireguard_nlb_sg.id]
}

resource "aws_security_group" "wireguard_nlb_sg" {
  name        = "${var.project}-nlb-wireguard-sg"
  description = "Security group for NLB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Wireguard VPN"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "wireguard" {
  name        = "${var.project}-nlb-tg-wireguard"
  port        = 51820
  protocol    = "UDP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold = "3"
    interval          = "30"
    # port                = "22"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }
}

resource "aws_lb_listener" "nlb_listener_51820" {
  load_balancer_arn = aws_lb.wireguard.arn
  port              = "51820"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wireguard.arn
  }
}

resource "aws_lb_target_group_attachment" "wireguard" {
  target_group_arn = aws_lb_target_group.wireguard.arn
  target_id        = aws_instance.this[0].id
  port             = 51820
}

data "aws_lb" "wireguard" {
  name = aws_lb.wireguard.name
}