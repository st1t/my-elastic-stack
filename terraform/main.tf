provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.53.0"
    }
  }
}

locals {
  vpc_id       = "xxxx"
  subnet_id    = "xxxx"
  ssh_key_name = "xxxx"
}
