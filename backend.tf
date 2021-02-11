terraform {
  backend "gcs" {
    bucket      = "terraform-tes1"
    prefix      = "terraform1-folder"
    credentials = "playground-s-11-1b668525-b211c38179b9.json"
  }
}