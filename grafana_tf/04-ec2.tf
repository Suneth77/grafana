data "template_file" "userdata-grafana" {
  template = "${file("${path.module}/templates/grafana_userdata.sh.tpl")}"
  //vars ={
  //  ebs_vol = "/dev/nvme1n1"
  //  grafana_mysql_host = "${aws_db_instance.grafana-rds.address}"
  //}
}


resource "aws_eip" "grafana-eip" {
  vpc                       = true
  tags ={
    Name = "grafana-eip"
  }
}

resource "aws_instance" "grafana" {
  ami                         = "ami-01b01bbd08f24c7a8"
  instance_type               = "t3.medium"
  key_name                    = "grafana"
  subnet_id                   = "${aws_subnet.infra-public-subnet-01.id}"
  vpc_security_group_ids      = ["${aws_security_group.sg-grafana.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data_base64            = "${base64encode(data.template_file.userdata-grafana.rendered)}"

  //lifecycle {
  //  ignore_changes = ["user_data_base64"]
  //}

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  volume_tags = {
    Name = "grafana"
  }
  tags ={
    Name = "grafana"
  }
  depends_on    = ["aws_eip.grafana-eip"]
}
resource "aws_eip_association" "grafana-eip-assoc" {
  instance_id   = "${aws_instance.grafana.id}"
  allocation_id = "${aws_eip.grafana-eip.id}"
}