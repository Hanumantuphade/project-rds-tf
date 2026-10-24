#region
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
#sg
variable "sg_name" {

  type=string
}
 variable "sg_description" {

  type= string
 }
 variable "ingress_port"{
    type=number
 }
 variable "ingress_protocol" {
  type=string
}
 
variable "allowed_cidr" {
  type=list(string)
}
variable "egress_port" {
  type=number
}
variable "egress_protocol" {
  type=string
}
variable "sg_tag_name" {
  type=string
}

#subnet
variable "rds_name"{
  type=string
}
variable "subnet_ids" {
  type=list(string)
}
variable "rds_tag_name" {
  type=string
}
#rds instance
variable "allocated_storage" {
  description = "The allocated storage in GB"
  type        = number
  
}
variable "db_engine" {
  description = "The database engine to use"
  type        = string
 
}
variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
 
}
variable "db_instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
 
}

variable "db_name" {
  description = "The name of the database to be created"
  type        = string
 
}

variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
 
}

variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
}
variable "db_backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  
}

variable "db_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
 
}

variable "db_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  
}
variable "db_tag_name" {
  type = string
}

variable "db_engine_pggroup" {
  description = "The version of the parameter group"
  type        = string
  
}


variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be deployed"
  type        = string
}



