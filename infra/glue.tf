locals {
  tables = {
    lojas = {
      columns = [
        { name = "id", type = "int" },
        { name = "nome", type = "string" },
        { name = "cidade", type = "string" },
        { name = "uf", type = "string" },
      ]
    }

    caixas = {
      columns = [
        { name = "id", type = "int" },
        { name = "loja_id", type = "int" },
        { name = "numero", type = "int" },
      ]
    }

    operadores = {
      columns = [
        { name = "id", type = "int" },
        { name = "nome", type = "string" },
        { name = "matricula", type = "string" },
        { name = "ativo", type = "boolean" },
      ]
    }

    categorias = {
      columns = [
        { name = "id", type = "int" },
        { name = "nome", type = "string" },
      ]
    }

    produtos = {
      columns = [
        { name = "id", type = "int" },
        { name = "codigo_barras", type = "string" },
        { name = "nome", type = "string" },
        { name = "categoria_id", type = "int" },
        { name = "preco", type = "decimal(10,2)" },
        { name = "ativo", type = "boolean" },
        { name = "ncm", type = "string" },
        { name = "cest", type = "string" },
      ]
    }

    clientes = {
      columns = [
        { name = "id", type = "int" },
        { name = "nome", type = "string" },
        { name = "cpf_cnpj", type = "string" },
        { name = "email", type = "string" },
      ]
    }

    formas_pagamento = {
      columns = [
        { name = "id", type = "int" },
        { name = "nome", type = "string" },
      ]
    }

    sessoes_caixa = {
      columns = [
        { name = "id", type = "bigint" },
        { name = "caixa_id", type = "int" },
        { name = "operador_id", type = "int" },
        { name = "data_abertura", type = "timestamp" },
        { name = "data_fechamento", type = "timestamp" },
        { name = "valor_abertura", type = "decimal(10,2)" },
        { name = "status", type = "string" },
      ]
    }

    vendas = {
      columns = [
        { name = "id", type = "bigint" },
        { name = "data_hora", type = "timestamp" },
        { name = "sessao_caixa_id", type = "bigint" },
        { name = "operador_id", type = "int" },
        { name = "cliente_id", type = "int" },
        { name = "cpf_cnpj_consumidor", type = "string" },
        { name = "valor_total", type = "decimal(12,2)" },
        { name = "desconto", type = "decimal(10,2)" },
        { name = "status", type = "string" },
      ]
    }

    itens_venda = {
      columns = [
        { name = "id", type = "bigint" },
        { name = "venda_id", type = "bigint" },
        { name = "produto_id", type = "int" },
        { name = "quantidade", type = "decimal(10,3)" },
        { name = "preco_unitario", type = "decimal(10,2)" },
        { name = "subtotal", type = "decimal(12,2)" },
      ]
    }

    pagamentos_venda = {
      columns = [
        { name = "id", type = "bigint" },
        { name = "venda_id", type = "bigint" },
        { name = "forma_pagamento_id", type = "int" },
        { name = "valor_pago", type = "decimal(12,2)" },
      ]
    }

    movimentacoes_caixa = {
      columns = [
        { name = "id", type = "bigint" },
        { name = "sessao_caixa_id", type = "bigint" },
        { name = "tipo", type = "string" },
        { name = "valor", type = "decimal(12,2)" },
        { name = "data_hora", type = "timestamp" },
        { name = "justificativa", type = "string" },
      ]
    }
  }
}

# ---------------------------------------------------------------------------
# Glue Catalog Database
# ---------------------------------------------------------------------------

resource "aws_glue_catalog_database" "main" {
  name = "${var.project_name}_${var.environment}_db"
}

# ---------------------------------------------------------------------------
# Glue Catalog Tables (uma por entrada em local.tables)
# ---------------------------------------------------------------------------

resource "aws_glue_catalog_table" "tables" {
  for_each = local.tables

  database_name = aws_glue_catalog_database.main.name
  name          = each.key
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "classification" = "parquet"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data.id}/data/${each.key}/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = "1"
      }
    }

    dynamic "columns" {
      for_each = each.value.columns

      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }
}
