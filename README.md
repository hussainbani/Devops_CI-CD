# Devops_CI-CD
This project uses terraform and ansible to perform following things:

Deploy Bastion Hosts
Deploy RDS
Deploy Webserver (No Public IPv4 attached) 
Deploy ALB
Configuration Mangement using ansible. As Webserver has not Public IP attached so we run ansible playbook by creating SSH tunnel using bastion host.
