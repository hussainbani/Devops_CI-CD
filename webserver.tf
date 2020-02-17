resource "aws_key_pair" "AS1-ssh-key" {
  key_name   = "AS1-ssh-key"
  public_key = file("${var.PATH_PUB_KEY}")
}

resource "random_shuffle" "Public-Subnet-ID" {
  input = ["${aws_subnet.Public-1.id}", "${aws_subnet.Public-2.id}", "${aws_subnet.Public-3.id}"]
  result_count = 1
}

resource "aws_instance" "django-webserver" {
  ami           = "${var.ami}"
  instance_type = "${var.webserver_instance_type}"
  security_groups = ["${aws_security_group.django-web.id}"]
  key_name = "${"${aws_key_pair.AS1-ssh-key.key_name}"}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 60
  delete_on_termination = "true"
  }
  subnet_id = "${random_shuffle.Public-Subnet-ID.result[0]}"

  tags = {
    Name = "django-webserver"
    sre_candidate = "Hussain Abbas"
  }

  provisioner "remote-exec" {
    inline = ["sudo add-apt-repository ppa:jonathonf/python-3.6 -y", "sudo apt-get update -y", "sudo apt-get install build-essential libpq-dev libssl-dev openssl libffi-dev zlib1g-dev -y", "sudo apt-get install python3-pip python3-dev -y"]

    connection {
      agent = false
      bastion_host = "${aws_instance.jump-box.public_ip}"
      bastion_user = "ubuntu"
      bastion_port = 22
      bastion_private_key = file("${var.PATH_PRIV_KEY}")
      host		  = "${self.private_ip}"
      user        = "ubuntu"
      private_key = file("${var.PATH_PRIV_KEY}")
      timeout = "4m"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook --private-key ${var.PATH_PRIV_KEY}  --ssh-common-args '-o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -W %h:%p -q ubuntu@${aws_instance.jump-box.public_ip} -i ${var.PATH_PRIV_KEY}\"' -i ${self.private_ip}, master.yml"
  }
}

