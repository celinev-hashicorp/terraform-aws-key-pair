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

################################################################################
# Key Pair
################################################################################

resource "aws_key_pair" "this" {
  count = var.create ? 1 : 0

  key_name        = var.key_name
  key_name_prefix = var.key_name_prefix
  public_key      = var.create_private_key ? trimspace(tls_private_key.this[0].public_key_openssh) : var.public_key

  tags = var.tags
}

################################################################################
# Private Key
################################################################################

resource "tls_private_key" "this" {
  count = var.create && var.create_private_key ? 1 : 0

  algorithm = var.private_key_algorithm
  rsa_bits  = var.private_key_rsa_bits
}
