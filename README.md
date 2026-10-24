# Terraform-Based AWS RDS PostgreSQL Infrastructure

Provision and manage **Amazon RDS for PostgreSQL using Terraform** with infrastructure automation, remote state management, security group configuration, database subnet groups, and automated backup settings.

This hands-on project demonstrates how to use Infrastructure as Code (IaC) to provision and configure managed database infrastructure on AWS.

## Architecture Overview

The project uses Terraform to provision an Amazon RDS PostgreSQL instance and its associated networking configuration in AWS Mumbai (`ap-south-1`). Terraform state is stored remotely in Amazon S3.

### Architecture Flow

```text
                 Developer
                     |
                     v
              Terraform CLI
                     |
                     v
              AWS Provider
                     |
          +----------+-----------+
          |                      |
          v                      v
   Amazon S3 Bucket       AWS Infrastructure
   Remote State            ap-south-1
          |                      |
          |             +--------+---------+
          |             |                  |
          |             v                  v
          |       RDS Security Group   Existing VPC
          |             |                  |
          |             |             Existing Subnets
          |             |                  |
          |             |             RDS Subnet Group
          |             |                  |
          |             +--------+---------+
          |                      |
          |                      v
          |             Amazon RDS
          |             PostgreSQL 15.17
          |             db.t3.micro
          |             20 GB Storage
          |
          +---- Terraform State
                Encryption
                S3 Lockfile
```

> Note: This is a logical overview. The VPC and subnet IDs are supplied as existing infrastructure in the Terraform variables; this project does not create them. The diagram does not imply that the database is publicly accessible or that it has Multi-AZ enabled.

## AWS Resources Used

| Resource | Purpose |
|---|---|
| Amazon RDS | Managed PostgreSQL database |
| AWS Security Group | Controls network traffic to the database |
| RDS DB Subnet Group | Associates the RDS instance with two existing subnets |
| Amazon S3 | Stores the Terraform state file remotely |
| Terraform AWS Provider | Connects Terraform to AWS |
| Terraform Variables | Manage configurable infrastructure parameters |
| Terraform Outputs | Expose database and networking information |

## Technology Stack

- **Cloud Provider:** Amazon Web Services (AWS)
- **Infrastructure as Code:** Terraform
- **Database:** Amazon RDS for PostgreSQL
- **Database Engine Version:** PostgreSQL 15.17
- **Region:** Asia Pacific (Mumbai) — `ap-south-1`
- **Instance Class:** `db.t3.micro`
- **Allocated Storage:** 20 GB
- **Remote State:** Amazon S3
- **State Locking:** S3 lockfile
- **Provider Version Constraint:** `~> 6.69.0`

## Project Features

### 1. Infrastructure as Code

Used Terraform to define and provision AWS resources through configuration files rather than creating every resource manually in the AWS Management Console.

### 2. Remote Terraform State

Configured an Amazon S3 backend to store Terraform state centrally.

Backend configuration includes:

- S3 bucket: `hamu-terra-bkt1628`
- State key: `prod/terraform.tfstate`
- AWS region: `ap-south-1`
- State encryption: Enabled
- State locking: S3 lockfile using `use_lockfile = true`

Remote state helps maintain a centralized record of managed infrastructure. State locking helps prevent conflicting Terraform operations when supported by the backend configuration.

### 3. Security Group Configuration

Created an AWS security group for the RDS instance with PostgreSQL traffic configured on port `5432`.

The current practice configuration uses `0.0.0.0/0` for inbound access. This is overly permissive and should be replaced with a trusted source, such as an application security group or an authorized IP range, before deployment in a real environment.

### 4. RDS DB Subnet Group

Configured an Amazon RDS DB subnet group using two existing subnet IDs.

This associates the database with the specified subnets. Actual subnet placement, availability-zone distribution, and network reachability depend on the existing VPC configuration.

### 5. Amazon RDS for PostgreSQL

Configured a managed PostgreSQL database with the following parameters:

| Parameter | Configuration |
|---|---|
| AWS Region | `ap-south-1` |
| Engine | PostgreSQL |
| Engine Version | `15.17` |
| Instance Class | `db.t3.micro` |
| Allocated Storage | 20 GB |
| Database Name | `mydatabase` |
| Database Port | `5432` |

### 6. Backup and Maintenance Configuration

Configured database backup and maintenance settings through Terraform.

| Setting | Configuration |
|---|---|
| Backup Retention | 1 day |
| Backup Window | `03:00–04:00` UTC |
| Maintenance Window | Sunday, `05:00–06:00` UTC |
| Final Snapshot on Deletion | Skipped |

The backup and maintenance windows are configured in UTC. Actual backup behavior and availability depend on AWS RDS settings and service constraints.

**Important:** Skipping the final snapshot is suitable only when data loss is acceptable for the practice environment. Review this setting before managing important data.

### 7. Terraform Variables and Outputs

Used `variables.tf` and `terraform.tfvars` to separate configurable parameters from resource definitions.

The `output.tf` file exposes:

- RDS instance identifier
- RDS endpoint
- RDS hostname
- Database port
- Database name
- Security group ID
- RDS DB subnet group name

These outputs help retrieve important resource details after a successful Terraform deployment.

## Project Structure

```text
terraform-aws-rds/
├── provider.tf
├── version.tf
├── backend.tf
├── terraform.tfvars
├── variables.tf
├── main.tf
├── output.tf
└── README.md
```

## Prerequisites

Before deploying this project, ensure you have:

- An AWS account.
- AWS CLI installed and configured.
- Terraform installed.
- Permissions to create and manage RDS instances, security groups, DB subnet groups, and S3 backend resources.
- An existing VPC and two suitable subnet IDs.
- An existing S3 bucket configured for the Terraform backend.

The S3 backend bucket must exist before Terraform initializes the backend. Ensure the configured AWS identity has the necessary S3 permissions and that the existing VPC and subnet IDs are valid in the selected region.

## Deployment Guide

### Step 1: Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_REPOSITORY_DIRECTORY>
```

Replace the placeholders with your actual GitHub repository URL and directory name.

### Step 2: Configure AWS Credentials

Configure your AWS CLI credentials using a suitable authentication method.

```bash
aws configure
```

Alternatively, use an AWS profile or an IAM role when appropriate.

### Step 3: Configure Variables

Review `terraform.tfvars` and update the region, VPC ID, subnet IDs, database settings, and other values for your environment.

**Never commit real database passwords or other secrets to GitHub.** Prefer a secure secrets-management method and ensure sensitive state files are protected.

### Step 4: Initialize Terraform

```bash
terraform init
```

This initializes the AWS provider and the configured S3 backend.

### Step 5: Validate the Configuration

```bash
terraform fmt -check
terraform validate
```

Formatting and validation help catch configuration and syntax issues before deployment.

### Step 6: Review the Execution Plan

```bash
terraform plan
```

Review the planned changes carefully before creating or modifying AWS resources.

### Step 7: Apply the Configuration

```bash
terraform apply
```

Inspect the plan and confirm the operation when prompted.

### Step 8: View Terraform Outputs

```bash
terraform output
```

This displays the configured outputs, including the RDS endpoint and database port.

### Step 9: Clean Up Resources

When the practice project is no longer needed, review the resources and potential data-loss implications before running:

```bash
terraform destroy
```

Terraform may delete the RDS instance and associated resources managed by this configuration. The configured `skip_final_snapshot = true` means a final RDS snapshot will not be created through that setting. The existing VPC, existing subnets, and separately managed S3 backend bucket are not resources created by this configuration.

## Security Considerations

This is a learning project. Review these items before using the configuration for a real application:

- Restrict inbound PostgreSQL access instead of allowing `0.0.0.0/0`.
- Never commit database passwords, access keys, or other secrets.
- Protect Terraform state because it can contain sensitive information.
- Keep S3 backend access limited to authorized identities.
- Consider enabling S3 versioning and reviewing additional state-protection measures.
- Review RDS encryption, deletion protection, final snapshots, backup retention, and network accessibility requirements.
- Verify that the database is reachable only through the intended network paths.

## What I Learned

Through this project, I gained hands-on practice with:

- Provisioning AWS resources using Terraform.
- Managing Terraform configuration through variables and outputs.
- Configuring an S3 remote backend and S3-based state locking.
- Working with AWS security groups and database subnet groups.
- Provisioning Amazon RDS for PostgreSQL.
- Configuring automated backups and maintenance windows.
- Reviewing infrastructure plans and managing resource lifecycles.
- Applying security considerations to cloud database infrastructure.

## Future Improvements

Potential improvements for a future iteration include:

- Restricting database access to trusted application security groups.
- Managing secrets through AWS Secrets Manager.
- Enabling deletion protection and final snapshots.
- Reviewing Multi-AZ deployment requirements.
- Adding S3 versioning and stronger remote-state protection.
- Creating separate development, testing, and production configurations.

These are potential enhancements and are not claimed as implemented in the current project.

## Author

**Hanumant Uphade**

Aspiring Cloud and DevOps Engineer | AWS | Terraform | Infrastructure as Code

GitHub: https://github.com/Hanumantuphade/project-rds-tf
---

If you found this project useful, feel free to explore the repository and share feedback or suggestions for improvement.

#AWS #Terraform #AmazonRDS #PostgreSQL #DevOps #InfrastructureAsCode #CloudComputing
