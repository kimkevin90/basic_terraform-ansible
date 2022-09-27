/*
1. tfstate 생성된 후 원격에서 상태를 관리하기 위해서 state stroage(Backend) 생성한다.
2. AWS s3 backend / Terraform Cloud로 원격 백엔드 사용한다.
3. local state는 개인작업용도이며, 원격 state 관리 시 동시성 문제가 발생하므로 
locking하여 한작업자가 진행 시 locking을 건다. aws의 경우 DynamoDB로 lock한다.
*/

// AWS S3 사용 시
# terraform {
#   backend "s3" {
#     bucket = "seobi-devops-terraform"
#     key    = "s3-backend/terraform.tfstate"
#     region = "ap-northeast-2"
#   }
# }

// terraform-cloud 사용 시 토큰도 만들어야 한다.
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "seobi"

    workspaces {
      name = "tf-cloud-backend"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

/*
 * Groups
 */

resource "aws_iam_group" "developer" {
  name = "developer"
}

resource "aws_iam_group" "employee" {
  name = "employee"
}



output "groups" {
  value = [
    aws_iam_group.developer,
    aws_iam_group.employee,
  ]
}


/*
 * Users
 */

variable "users" {
  type = list(any)
}

resource "aws_iam_user" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  name = each.key

  tags = {
    level = each.value.level
    role  = each.value.role
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  user   = each.key
  groups = each.value.is_developer ? [aws_iam_group.developer.name, aws_iam_group.employee.name] : [aws_iam_group.employee.name]
}

locals {
  developers = [
    for user in var.users :
    user
    if user.is_developer
  ]
}

resource "aws_iam_user_policy_attachment" "developer" {
  for_each = {
    for user in local.developers :
    user.name => user
  }

  user       = each.key
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  depends_on = [
    aws_iam_user.this
  ]
}

output "developers" {
  value = local.developers
}

output "high_level_users" {
  value = [
    for user in var.users :
    user
    if user.level > 5
  ]
}
