resource "aws_lb" "wireguard" {
  name               = "${var.project}-${var.env}-webserver-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  security_groups    = [aws_security_group.wireguard_sg.id]

  enable_deletion_protection = true
}

resource "aws_security_group" "wireguard_sg" {
  name        = "${var.project}-${var.env}-nlb-sg"
  description = "Security group for NLB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Wireguard VPN"
  }
}

resource "aws_lb_target_group" "wireguard" {
  name        = "${var.project}-${var.env}-nlb-tg-wireguard"
  port        = 51820
  protocol    = "UDP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "UDP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }
}

resource "aws_lb_listener" "nlb_listener_10933" {
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
  target_id        = aws_instance.this.id
  port             = 51820
}