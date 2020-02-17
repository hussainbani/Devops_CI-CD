resource "aws_kms_key" "AS1-Key" {
  description             = "For RDS Encryption"
  enable_key_rotation = "false"
}

resource "aws_db_subnet_group" "mariadb-subnet" {
  name       = "mariadb-subnet"
  subnet_ids = ["${aws_subnet.Private-1.id}", "${aws_subnet.Private-2.id}", "${aws_subnet.Private-3.id}"]
  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_parameter_group" "mariadb-parameters" {
  name   = "mariadb-parameters"
  family = "mariadb10.2"

  parameter {
    name  = "max_allowed_packet"
    value = 16777216
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "AS1-mariadb" {
  allocated_storage    = "${var.STORAGE_DB}"
  identifier = "django-db"
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.2.21"
  instance_class       = "${var.db_instance_type}"
  name                 = "djangoDB"
  username             = "djangouser"
  password             = "Rand0mPassw0rd"
  skip_final_snapshot = "true"
  db_subnet_group_name = "${aws_db_subnet_group.mariadb-subnet.id}"
  parameter_group_name = "${aws_db_parameter_group.mariadb-parameters.name}"
  multi_az = "${var.multiAZ}"
  vpc_security_group_ids = ["${aws_security_group.RDS-sg.id}"]
  kms_key_id = "${aws_kms_key.AS1-Key.arn}"
  storage_encrypted = "true"
  tags = {
    sre_candidate = "Hussain Abbas"
  }
  }