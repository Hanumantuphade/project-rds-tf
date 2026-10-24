
# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = var.sg_name
  description = var.sg_description

  ingress {
    from_port   = var.ingress_port  # PostgreSQL default port (replace with your DB engine's port if different)
    to_port     = var.ingress_port
    protocol    = var.ingress_protocol
    cidr_blocks = var.allowed_cidr  # Allows access from any IP address (for testing purposes)
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.egress_protocol  # Allows all outbound traffic
    cidr_blocks = var.allowed_cidr
  }

  tags = {
    Name = var.sg_tag_name
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.rds_tag_name
  }
}

# RDS instance
resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.${var.db_engine}${var.db_engine_pggroup}"  # Adjust if needed
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Backup and maintenance settings
  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window

  skip_final_snapshot = true  # Skip final snapshot on deletion (for testing purposes)

  tags = {
    Name =var.db_tag_name
  }
}
