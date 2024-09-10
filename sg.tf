resource "aws_security_group" "wireguard" {

  count  = var.create_wireguard_sg ? 1 : 0
  vpc_id = var.vpc_id
  name   = "${var.project}-${var.env}-wireguard-sg"

  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project}-${var.env}-wireguard-sg"
    ManagedBy = "Terraform"
  }
}