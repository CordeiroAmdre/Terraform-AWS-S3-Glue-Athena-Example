output "s3_data_bucket" {
  description = "Nome do bucket S3 com os dados Parquet"
  value       = aws_s3_bucket.data.id
}

output "s3_athena_results_bucket" {
  description = "Nome do bucket S3 para resultados do Athena"
  value       = aws_s3_bucket.athena_results.id
}

output "glue_database_name" {
  description = "Nome do Glue Catalog Database"
  value       = aws_glue_catalog_database.main.name
}

output "glue_table_names" {
  description = "Lista das tabelas criadas no Glue Catalog"
  value       = [for t in aws_glue_catalog_table.tables : t.name]
}

output "athena_workgroup" {
  description = "Nome do Athena Workgroup"
  value       = aws_athena_workgroup.main.name
}

output "athena_example_query" {
  description = "Query de exemplo para testar no Athena"
  value       = "SELECT v.id, v.data_hora, v.valor_total, l.nome AS loja FROM ${aws_glue_catalog_database.main.name}.vendas v JOIN ${aws_glue_catalog_database.main.name}.sessoes_caixa sc ON v.sessao_caixa_id = sc.id JOIN ${aws_glue_catalog_database.main.name}.caixas c ON sc.caixa_id = c.id JOIN ${aws_glue_catalog_database.main.name}.lojas l ON c.loja_id = l.id LIMIT 10;"
}
