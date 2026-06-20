resource "random_id" "suffix" {
  byte_length = 4
}

# ---------------------------------------------------------------------------
# Bucket de dados (recebe os Parquets)
# ---------------------------------------------------------------------------

resource "aws_s3_bucket" "data" {
  bucket        = "${var.project_name}-data-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------------------------
# Upload dos 12 arquivos Parquet para S3
# ---------------------------------------------------------------------------

resource "aws_s3_object" "data_files" {
  for_each = local.tables

  bucket = aws_s3_bucket.data.id
  key    = "data/${each.key}/${each.key}.parquet"
  source = "${path.module}/../LocalDummyData/${each.key}.parquet"
  etag   = filemd5("${path.module}/../LocalDummyData/${each.key}.parquet")
}

# ---------------------------------------------------------------------------
# Bucket de resultados do Athena
# ---------------------------------------------------------------------------

resource "aws_s3_bucket" "athena_results" {
  bucket        = "${var.project_name}-athena-results-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "athena_results" {
  bucket = aws_s3_bucket.athena_results.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
