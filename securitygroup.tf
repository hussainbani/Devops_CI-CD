resource "aws_security_group" "jump-box" {
  name        = "jump-box"
  description = "Allow SSH"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    sre_candidate = "Hussain Abbas"
    Name = "jump-box"
    }
}

resource "aws_security_group" "django-web" {
  name        = "django-web"
  description = "Allow HTTP & HTTPS"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = ["${aws_security_group.jump-box.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    sre_candidate = "Hussain Abbas"
    Name = "django-web"
    }
}

resource "aws_security_group" "RDS-sg" {
  name        = "RDS-sg"
  description = "Allow Mysql Connection"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.django-web.id}"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    sre_candidate = "Hussain Abbas"
    Name = "RDS-sg"
    }
}