provider "aws" {
  region = "ap-northeast-2"
}


/*
 * Conditional Expression
 * Condtion ? If_True : If_False
 */
variable "is_john" {
  type = bool
  default = true
}

locals {
  message = var.is_john ? "Hello John!" : "Hello!"
}

output "message" {
  value = local.message
}


/*
 * Count Trick for Conditional Resource
 */
variable "internet_gateway_enabled" {
  type = bool
  default = false
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

// count를 사용하여 조건에따라 internet_gateway 생성
resource "aws_internet_gateway" "this" {
  count = var.internet_gateway_enabled ? 1 : 0

  vpc_id = aws_vpc.this.id
}