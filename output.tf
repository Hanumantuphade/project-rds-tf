# RDS instance identifier
output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.default.id
}

# RDS database endpoint
output "rds_endpoint" {
  description = "RDS database endpoint address and port"
  value       = aws_db_instance.default.endpoint
}

# RDS database address
output "rds_address" {
  description = "RDS database hostname"
  value       = aws_db_instance.default.address
}

# RDS database port
output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.default.port
}

# Database name
output "rds_database_name" {
  description = "Initial database name"
  value       = aws_db_instance.default.db_name
}

# Security group ID
output "rds_security_group_id" {
  description = "Security group ID attached to RDS"
  value       = aws_security_group.rds_sg.id
}

# DB subnet group name
output "rds_subnet_group_name" {
  description = "RDS DB subnet group name"
  value       = aws_db_subnet_group.rds_subnet_group.name
}