resource "aws_iam_role" "dcore_s3_cloudwatchlogrole" {
  name = "roles for s3 and cloudwatch specific bucket"
  assume_role_policy = "${aws_iam_policy.dcores3policy}"
}
resource "aws_iam_policy" "dcores3policy" {
  name        = "S3-policy"
  description = "Allow access s3 and cloudwatch"
  policy      = "${file("policys3bucket.json")}"
  depends_on = [ "aws_s3_bucket.dcore-s3-bucket","aws_cloudwatch_log_group.dcore-s3-loggroup" ]
}
resource "aws_s3_bucket" "dcore-s3-bucket" {
  bucket = "dcore s3 bucket"
  acl    = "private"
  tags = {
    Name        = "Dcore s3"
    Environment = "${var.dcore_environment}"
  }
}
resource "aws_cloudwatch_log_group" "dcore-s3-loggroup" {
  name = "Dcore s3 loggroup"

  tags = {
    Environment = "${var.dcore_environment}"
  }
}