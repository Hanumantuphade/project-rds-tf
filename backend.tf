terraform {
  backend "s3" {

    bucket         = "hamu-terra-bkt1628"
    key            = "prod/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    use_lockfile   = true
  }
}