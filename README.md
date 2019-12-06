# tfe-policy-set-via-tfe-provider
Setting Policy Set in TFE via TFE Provide

Example of how to set up `sentinel policy set` in Terrafrom Enterprise via `tfe provider` : https://www.terraform.io/docs/providers/tfe/index.html 

Usage for Terraform CLI : 

- Create auth token in teh VCS of your choice, I am using GitHub fro example : https://github.com/settings/tokens
- Export it as environment variable by executing :
```export TF_VAR_github_oauth_token=YOUR_TOKEN```
- Create [variables.tf](variables.tf) with the content :
```terraform
variable "tfe_hostname" {
  default = "FQDN of your TFE instance here"
}

variable "github_oauth_token" {
  type = string
}
```
- Create following main code : 

Full code ( from [main.tf](main.tf) ) : 

```terraform
provider "tfe" {
  hostname = "${var.tfe_hostname}"
}

resource "tfe_oauth_client" "test" {
  organization     = "acme5" # TFE organitzation, not the GiutHub's one
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "${var.github_oauth_token}"
  service_provider = "github"
}

resource "tfe_policy_set" "test" {
  name         = "global-policy-set"
  description  = "A brand new policy set"
  global       = true
  organization = "acme5" # again, TFE organization
  #  policies_path          = "policies/globalk" -<< this cna be subpath in repo

  vcs_repo {
    identifier         = "Galser/tfe-policy-fork-test" # <<-- your Sentinel policy set repo
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = "${tfe_oauth_client.test.oauth_token_id}"
  }
}
```
- Do `terraform init` 
- Apply code `terraform apply`
```bash
...
Terraform will perform the following actions:

  # tfe_policy_set.test will be created
  + resource "tfe_policy_set" "test" {
      + description  = "A brand new policy set"
      + global       = true
      + id           = (known after apply)
      + name         = "global-policy-set"
      + organization = "acme5"

      + vcs_repo {
provider "tfe" {
          + branch             = "master"
# tfe-policy-set-via-tfe-provider
          + identifier         = "Galser/tfe-policy-fork-test"
          + ingress_submodules = false
# tfe-policy-set-via-tfe-provider
variable "tfe_hostname" {
          + oauth_token_id     = "ot-WF2Xrqrsdfsdfsd3242134324"
        }

    }
...
```
 
- Enjoy! Now you should have Policy Set named **"global-policy-set"** in your TFE

