variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}


variable "EC2InstanceType" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t2.micro"
}

variable "rds_allocated_storage" {
  description = "The allocated storage for the RDS instance in GB."
  type        = number
  default     = 20
}
