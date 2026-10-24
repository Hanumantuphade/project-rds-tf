region= "ap-south-1"

#sg variables
sg_name= "rds_security_group"
sg_description="Security group for RDS instance"
ingress_port= 5432
ingress_protocol="tcp"
allowed_cidr=["0.0.0.0/0"]
egress_port=0
egress_protocol="-1"
sg_tag_name="rds_security_group"

#subnet variables
rds_name= "rds_subnet_group"
subnet_ids = ["subnet-0bda578f6f09dffd7", "subnet-0216130d4e8b62689"]  # Replace with your subnet IDs
rds_tag_name="rds_subnet_group"

# rds instance variable
allocated_storage=20
db_engine="postgres"
db_engine_version="15.17"
db_instance_class="db.t3.micro"
db_name="mydatabase"
db_username="hamu"
db_password="Hamu123456"


# inside db instance Backup and maintenance variables
db_backup_retention_period=1
db_backup_window="03:00-04:00"
db_maintenance_window="sun:05:00-sun:06:00"
db_tag_name="terraform-rds-instance"

db_engine_pggroup="15"
vpc_id = "vpc-9a8faff2"  # Replace with your VPC ID

