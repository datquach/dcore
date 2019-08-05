resource "aws_iam_group" "Devs" {
  name = "developers"
}

resource "aws_iam_group" "Testers" {
  name = "For QA testers"
}

resource "aws_iam_policy" "policyfordevs" {
  name        = "DevsPolicy"
  description = "For Devs policy which access for load balacner and log groups"
  policy      = "${file("policyfordevs.json")}"
}

resource "aws_iam_policy" "policyfortesters" {
  name        = "testers-policy"
  description = "Tester policy which access to log group only"
  policy      = "${file("policyfortesters.json")}"
}

resource "aws_iam_group_policy_attachment" "Devs-attach" {
  group      = "${aws_iam_group.Devs}"
  policy_arn = "${aws_iam_policy.policyfordevs.arn}"
}

resource "aws_iam_group_policy_attachment" "Testers-attach" {
  group      = "${aws_iam_group.Testers}"
  policy_arn = "${aws_iam_policy.policyfordevs.arn}"
}