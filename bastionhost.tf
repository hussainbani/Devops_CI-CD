resource "aws_instance" "jump-box" {
  ami           = "${var.ami}"
  instance_type = "${var.bastion_instance_type}"
  security_groups = ["${aws_security_group.jump-box.id}"]
  key_name = "${"${aws_key_pair.AS1-ssh-key.key_name}"}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 30
  delete_on_termination = "true"
  }
  subnet_id = "${random_shuffle.Public-Subnet-ID.result[0]}"

  tags = {
    Name = "JumpBox"
    sre_candidate = "Hussain Abbas"
  }
}