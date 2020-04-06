resource "aws_security_group" "sg-grafana" {
  name        = "sggrafana"
  description = "This security group is for grfana / kibana / ansible master admin instance."
  vpc_id = "${aws_vpc.infra-eu-vpc.id}"
  tags ={
    Name = "sg-grafana"
  }
}
resource "aws_security_group_rule" "sg-grafana-in-ssh-pri-ee" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["80.235.115.248/32"]
  description       = "ssh"
  security_group_id = "${aws_security_group.sg-grafana.id}"
}
resource "aws_security_group_rule" "sg-grafana-in-ssh-sec-ee" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  description       = "ssh"
  security_group_id = "${aws_security_group.sg-grafana.id}"
}
resource "aws_security_group_rule" "sg-grafana-in-http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  description     = "http"
  security_group_id = "${aws_security_group.sg-grafana.id}"
}
resource "aws_security_group_rule" "sg-grafana-in-https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  description       = "https"
  security_group_id = "${aws_security_group.sg-grafana.id}"
}
resource "aws_security_group_rule" "sg-grafana-out-all-any" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg-grafana.id}"
}