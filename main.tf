# Configure the AWS provider
provider "aws" {
  region = "var.region"
}

# Create an RDS instance 
resource "aws_db_instance" "app_db" {
  allocated_storage    = var.rds_allocated_storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "app_db"
  username             = "admin"
  password             = "password123"
  skip_final_snapshot  = true
}

# Create an EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "var.EC2InstanceType"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mysql
              EOF

  tags = {
    Name = "AppServer"
  }

  vpc_security_group_ids = [aws_db_instance.app_db.vpc_security_group_name]

}
