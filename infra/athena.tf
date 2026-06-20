resource "aws_athena_workgroup" "main" {
  name          = "${var.project_name}_${var.environment}_workgroup"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.id}/"
    }
  }
}
