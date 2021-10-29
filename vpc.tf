provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  public_subnets  = ["10.0.0.0/24"]

  enable_dns_support = true
  enable_dns_hostnames = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
