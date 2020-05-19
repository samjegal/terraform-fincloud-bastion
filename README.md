# Financial Cloud Bastion Terraform Module

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module which creates Bastion instance on Financial Cloud.

## Usage

```terraform
module "bastion" {
  source = "github.com/samjegal/terraform-fincloud-bastion"

  prefix = "dev"

  vpc_id     = fincloud_virtual_private_cloud.stage.id
  cidr_block = "192.168.11.0/24"
  address    = "192.168.11.11"

  login_key_name = fincloud_login_key.stage.name
  init_script_id = fincloud_init_script.create-user.id
}
```
