provider "aws" {
  region = "ap-northeast-2"
}

/*
 IAM 유저 생성
 * No count / for_each
 */
resource "aws_iam_user" "user_1" {
  name = "user-1"
}

resource "aws_iam_user" "user_2" {
  name = "user-2"
}

resource "aws_iam_user" "user_3" {
  name = "user-3"
}

output "user_arns" {
  value = [
    aws_iam_user.user_1.arn,
    aws_iam_user.user_2.arn,
    aws_iam_user.user_3.arn,
  ]
}


/*
 * count 리소스 / 데이타 /모듈에 적용가능
 count의 경우 0~10의 유저중 4를 삭제하면 하나씩 땡겨와야하므로 관리 힘듬
 반면 for_each는 key 값만 삭제하면된다.
 */

resource "aws_iam_user" "count" {
  count = 10 // meta-argument로 불린다.

  // index 0부터 시작
  name = "count-user-${count.index}"
}

output "count_user_arns" {
  value = aws_iam_user.count.*.arn
}


/*
 * for_each 
  set / map 지원 한다.
  set은 unique한 값
  map은 key value 형식
 */

resource "aws_iam_user" "for_each_set" {
  // set은 list이므로 each.key / each.value 동일한 값을 제공
  for_each = toset([
    "for-each-set-user-1",
    "for-each-set-user-2",
    "for-each-set-user-3",
  ])

  name = each.key
}

output "for_each_set_user_arns" {
  value = values(aws_iam_user.for_each_set).*.arn
}

resource "aws_iam_user" "for_each_map" {
  // foreach의 key값은 string이여야 한다.
  for_each = {
    alice = {
      level = "low"
      manager = "posquit0"
    }
    bob = {
      level = "mid"
      manager = "posquit0"
    }
    john = {
      level = "high"
      manager = "steve"
    }
  }

  name = each.key // alice, bob, john

  tags = each.value // 태그에 해당 value들 적용
}

output "for_each_map_user_arns" {
  value = values(aws_iam_user.for_each_map).*.arn
}