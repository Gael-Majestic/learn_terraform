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

 
}

# Create a security group for the RDS instance
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow MySQL traffic"
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "DBSecurityGroup"
  }
}

# Allow incoming MySQL traffic to the RDS instance
resource "aws_vpc_security_group_ingress_rule" "db_sg" {
  security_group_id = aws_security_group.db_sg.id
  from_port         = 3306
  to_port           = 3306  
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}
 
# Allow outgoing traffic from the RDS instance to anywhere
resource "aws_vpc_security_group_egress_rule" "db_sg" {
    security_group_id = aws_security_group.db_sg.id
    from_port   = 0
    to_port     = 0
    ip_protocol = "-1"
    cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
}

# Create a security group for the EC2 instance
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "AppSecurityGroup"
  } 
}

# Allow incoming HTTP traffic to the EC2 instance
resource "aws_vpc_security_group_ingress_rule" "app_sg" {
  security_group_id = aws_security_group.app_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow incoming SSH traffic to the EC2 instance
resource "aws_vpc_security_group_ingress_rule" "app_sg_ssh" {
  security_group_id = aws_security_group.app_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}
# Allow outgoing traffic from the EC2 instance to anywhere
resource "aws_vpc_security_group_egress_rule" "app_sg" {
    security_group_id = aws_security_group.app_sg.id
    from_port   = 0
    to_port     = 0
    ip_protocol = "-1"
    cidr_ipv4         = "0.0.0.0/0"
}

