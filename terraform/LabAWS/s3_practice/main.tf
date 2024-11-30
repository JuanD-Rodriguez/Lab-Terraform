# Bloque de Proveedor
provider "aws" {
    region = var.aws_region  # Establece la región de AWS desde la variable aws_region
}

# Bloque de Recurso de Bucket S3
resource "aws_s3_bucket" "webtest1" {
    bucket = var.bucket_name  # Nombre del bucket obtenido de la variable bucket_name

    # Bloque de Configuración de Hosting Estático 
    website {
        index_document = "index.html"  # Configura "index.html" como el documento de índice
    }
}

# Bloque de Recurso de Objeto de Bucket S3 
resource "aws_s3_bucket_object" "object1" {
    bucket = aws_s3_bucket.webtest1.bucket  # Hace referencia al bucket webtest1

    key = "index.html"  # Nombre del objeto S3

    # Configura el contenido del objeto cargando el archivo "index.html" local
    content = file("index.html")

    content_type = "text/html"  # Establece el tipo de contenido MIME como HTML
}
