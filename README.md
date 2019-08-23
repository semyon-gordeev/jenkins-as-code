# Jenkins as Code

Installs and configures Jenkins on Debian/Ubuntu servers.

## Preinstall

You can test this automation on your own Debian/Ubuntu machine or create a test cluster in AWS using the terraform script:

```
cd terraform/
terraform apply
```

The test cluster includes 1 VM for Jenkins and a small ECS cluster to test the ECS deploy.

An example of a repo to deploy is [here](https://github.com/semyon-gordeev/test_jenkins).

Use `terraform destroy` to remove the test cluster.

## Usage

`make jenkins host=[your_host_address]`

Update `group_vars/all` to change parameters of the installation.
