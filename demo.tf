provider "null" {}

variable "vpc1" { 
  type = "list"
  default = [
      "name1",
      "name2",
      "name3",
  ]
}

variable "region" {
  default = "us-east1"
}

variable "sa_email" {
  default = "sa_email@example.com"
}

variable "group_email" {
  default = "group@example.com"
}

variable "user_email" {
  default = "user@example.com"
}

/*
variable "bindings1" {
  type = "map"
  default = {}
}
*/

variable "bindings2" {
  type = "map"
  default = {}
}

variable "bindings3" {
  type = "list"
  default = []
}

data "null_data_source" "values" {
  inputs = {
    all_values = "${join(",",var.vpc1)}"
  }
}

resource "null_resource" "cluster" {
   triggers {
     region = "demo"
     bindings1 = "{'us-east-1' = 'image-1234' 'us-west-2' = 'image-4567' 'us-west-3' = 'image-45671' }"

     bindings2 = "{'roles/resourcemanager.folderEditor' = ['serviceAccount:${var.sa_email}','group:${var.group_email}',] 'roles/resourcemanager.folderViewer' = ['user:${var.user_email}',]}"
     bindings3 = ["test"]
   }
}

module "test" {
  source = "./test"
  bindings = {
    "roles/resourcemanager.folderEditor" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
    ]

    "roles/resourcemanager.folderViewer" = [
      "user:${var.user_email}",
      "user:${var.user_email}",
      "user:${var.user_email}",
    ]
  }

}

output "all_ids" {
  value = ["${data.null_data_source.values.outputs["all_values"]}"]
}

output "all_ids1" {
  value = "${element(split(",",data.null_data_source.values.outputs.all_values),1)}"
}

output "bindings" {
  value = "${module.test.bindings}"
}

output "bindings1" {
  value = "${null_resource.cluster.triggers.bindings1}"
}

output "bindings2" {
  value = "${null_resource.cluster.triggers.bindings2}"
}



