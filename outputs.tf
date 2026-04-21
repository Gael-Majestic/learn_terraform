output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.app_server.public_ip
}


output "db_endpoint" {
  description = "Endpoint of the RDS instance."
  value       = aws_db_instance.app_db.endpoint
}

#After applying this configuration, you can use:
#terraform output instance_public_ip
#to get the public IP address of the EC2 instance, and  
#terraform output db_endpoint
#to get the endpoint of the RDS instance.
