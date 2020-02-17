output "webserver_public_dns" {
  value = aws_instance.django-webserver.public_dns
}