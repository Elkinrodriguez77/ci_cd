# =====================================================
# Ejemplo de Infraestructura como Codigo (Terraform)
# =====================================================
# IMPORTANTE: Este archivo es SOLO PARA ENSENANZA.
# No vamos a ejecutarlo en clase porque requiere una cuenta
# de AWS con tarjeta de credito. Pero es 100% real -
# asi se ve un Terraform de produccion.
#
# La idea es que los estudiantes VEAN como la infraestructura
# se vuelve CODIGO: versionable, revisable, reproducible.
# =====================================================

# Le decimos a Terraform: "vamos a usar AWS"
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# =====================================================
# CONCEPTO CLAVE: declaramos COMO QUEREMOS QUE SE VEA
# nuestra infraestructura. NO escribimos los pasos para
# crearla. Terraform calcula los pasos automaticamente.
# Esto es "declarativo" vs "imperativo".
# =====================================================

# Una "VPC" es la red privada virtual donde vivira nuestra app
resource "aws_vpc" "red_clase" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "red-clase-devops"
    Entorno     = "produccion"
    AdministradoPor = "terraform"
  }
}

# Un "S3 Bucket" - almacenamiento de archivos
resource "aws_s3_bucket" "almacen_app" {
  bucket = "devops-clase-utadeo-2026"

  tags = {
    Name    = "almacen-app"
    Entorno = "produccion"
  }
}

# Si manana queremos cambiar la region, agregar otro bucket,
# o crear 10 mas iguales -> es solo cambiar este archivo
# y correr "terraform apply".
#
# Si manana se rompe TODO -> "terraform apply" lo reconstruye
# identico en minutos. Esto es "ganado, no mascotas".
