terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "seobi"

    workspaces {
      name = "terraform-lab-network"
    }
  }
}


###################################################
# Local Variables
###################################################

locals {
  context = yamldecode(file(var.config_file)).context
  config  = yamldecode(templatefile(var.config_file, local.context))
}


###################################################
# Providers
###################################################

provider "aws" {
  region = "ap-northeast-2"
}