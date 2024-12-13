# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "student_number" {
  description = "Student number to be used in resource names"
  type        = string
  default     = "100907197"  # Your student number
}

# EC2 Instance
resource "aws_instance" "student_instance" {
  ami           = "ami-0453ec754f44f9a4a"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-instance-${var.student_number}"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "student_bucket" {
  bucket = "lamptey-bucket-${var.student_number}"

  tags = {
    Name = "Student-Bucket-${var.student_number}"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group-${var.student_number}"
  description = "Security group for RDS PostgreSQL instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "student_database" {
  identifier           = "rds-${var.student_number}"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"

  username = "studentadmin"
  password = "ChangeThisPassword123!"  # IMPORTANT: Change this password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true

  tags = {
    Name = "Student Database ${var.student_number}"
  }
}

# Outputs for reference
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.student_instance.id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.student_bucket.id
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.student_database.endpoint
}

