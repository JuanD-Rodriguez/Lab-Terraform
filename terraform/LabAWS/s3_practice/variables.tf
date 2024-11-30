# Variable de AWS Region (AWS Region Variable)
variable "aws_region" {
    type = string            # Tipo de variable: Cadena de texto
    default = "us-east-1"   # Valor predeterminado: "us-east-1" (Norte de Virginia)
}

# Variable de Nombre de Bucket (Bucket Name Variable)
variable "bucket_name" {
    type = string                # Tipo de variable: Cadena de texto
    default = "bucket1-labaws"   # Valor predeterminado: "agfwebbucket1" (nombre del bucket)
}

# Variable de Contenido (Content Variable)
variable "content" {
    type = string   # Tipo de variable: Cadena de texto
    # No se especifica un valor predeterminado, lo que significa que debe proporcionarse al utilizar la variable
}
