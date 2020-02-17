variable "region" {
  default = "eu-west-1"
}

variable "ami" {
  default = "ami-0987ee37af7792903"
}

variable "webserver_instance_type" {
  default = "t2.medium"
}

variable "bastion_instance_type" {
  default = "t2.small"
}

variable "db_instance_type" {
  default = "t2.medium"
}

variable "multiAZ" {
  default = "true"
}
variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}
variable "PATH_PUB_KEY" {}
variable "STORAGE_DB" {}
variable "PATH_PRIV_KEY" {}