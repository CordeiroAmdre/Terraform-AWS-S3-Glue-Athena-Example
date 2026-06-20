variable "project_name" {
  description = "Prefixo usado nos nomes dos recursos AWS"
  type        = string
  default     = "pdv"
}

variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}
