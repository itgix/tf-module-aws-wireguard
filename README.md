The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS WireGuard VPN Terraform Module

This module deploys a WireGuard VPN server on an EC2 instance with an NLB, security groups, and configurable instance settings. Based on the EC2 instance module with WireGuard-specific additions.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- EC2 instance running WireGuard VPN
- Network Load Balancer (NLB) for VPN traffic
- Security groups for VPN and NLB
- *(Optional)* Spot instance support

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.0 |
| AWS provider | >= 4.66 |

## Key Inputs

> This module has **75 variables** covering detailed EC2 instance configuration. The most commonly used are listed below. See `variables.tf` for the complete list.

### General

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create` | Whether to create an instance | `bool` | `true` | no |
| `name` | Name for the EC2 instance | `string` | `""` | no |
| `project` | Project name | `string` | `""` | no |
| `env` | Environment name | `string` | `""` | no |
| `tags` | Tags for all resources | `map(string)` | `{}` | no |

### Instance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` | no |
| `ami` | AMI ID (overrides SSM parameter) | `string` | `null` | no |
| `ami_ssm_parameter` | SSM parameter for AMI ID | `string` | `"/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"` | no |
| `key_name` | Key pair name for SSH access | `string` | `null` | no |
| `subnet_id` | VPC Subnet ID for the instance | `string` | `null` | no |
| `vpc_id` | VPC ID | `string` | `""` | no |
| `user_data` | User data script | `string` | `null` | no |
| `iam_instance_profile` | IAM Instance Profile name | `string` | `null` | no |
| `monitoring` | Enable detailed monitoring | `bool` | `null` | no |
| `source_dest_check` | Controls traffic routing (set false for VPN/NAT) | `bool` | `null` | no |

### Network

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `associate_public_ip_address` | Associate a public IP | `bool` | `null` | no |
| `private_ip` | Private IP address | `string` | `null` | no |
| `vpc_security_group_ids` | Security group IDs | `list(string)` | `null` | no |
| `nlb_subnet_id` | VPC Subnet ID for NLB | `string` | `null` | no |

### Storage

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `root_block_device` | Root block device configuration | `list(any)` | `[]` | no |
| `ebs_block_device` | Additional EBS block devices | `list(any)` | `[]` | no |
| `ebs_optimized` | Enable EBS optimization | `bool` | `null` | no |

## Key Outputs

> This module has **29 outputs**. The most commonly used are listed below. See `outputs.tf` for the complete list.

| Name | Description |
|------|-------------|
| `id` | The ID of the instance |
| `arn` | The ARN of the instance |
| `instance_state` | The state of the instance |
| `private_ip` | The private IP address |
| `public_ip` | The public IP address |
| `primary_network_interface_id` | The ID of the primary network interface |

## Usage Example

```hcl
module "wireguard" {
  source = "path/to/tf-module-aws-wireguard"

  name    = "wireguard-vpn"
  project = "myproject"
  env     = "prod"

  instance_type = "t3.micro"
  vpc_id        = "vpc-0abc1234def567890"
  subnet_id     = "subnet-aaa111"
  nlb_subnet_id = "subnet-bbb222"
  key_name      = "my-key-pair"

  source_dest_check          = false
  associate_public_ip_address = true

  user_data = file("${path.module}/wireguard-init.sh")

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```
