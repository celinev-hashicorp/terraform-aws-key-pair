terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.4"
    }
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.2"
    }
  }
  provider "doormat" {}

  data "doormat_aws_credentials" "creds" {
  provider = doormat
  role_arn = var.role_arn
}
  provider "aws" {
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
  region     = var.region
}
}

