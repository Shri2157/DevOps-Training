provider "aws" {
    region = "us-east-1"
  
}

resource "aws_s3_bucket" "Test-s3" {
    bucket = "unique-s3-bucket-name"

    tags = {
        Name = "Test-s3"
    }
  
}	