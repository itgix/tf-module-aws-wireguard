resource "aws_security_group" "wireguard_sg" {

  count  = var.create_wireguard_sg ? 1 : 0
  vpc_id = var.vpc_id
  name   = "${var.project}-${var.env}-wireguard-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
    self        = true
  }
}