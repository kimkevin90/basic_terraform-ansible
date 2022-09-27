// https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
provider "local" {
}

resource "local_file" "foo" {
  filename = "${path.module}/foo.txt"
  content  = "hello wrold1!"
}

data "local_file" "bar" {
  filename = "${path.module}/bar.txt"
}

// resoruce는 바로 data.value 넣기
output "file_var" {
  value = data.local_file.bar
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "foo" {
  cidr_block = "10.123.0.0/16"

  // vcp 명 적용
  tags = {
    "Name" = "this is test vpc"
  }
}

// resoruce는 바로 value 넣기
output "vpc_foo" {
  value = aws_vpc.foo
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs
data "aws_vpcs" "this" {

}

output "vpcs" {
  value = data.aws_vpcs.this
}