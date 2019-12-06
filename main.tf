provider "tfe" {
  hostname = "${var.tfe_hostname}"
}

resource "tfe_oauth_client" "test" {
  organization     = "acme5"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "${var.github_oauth_token}"
  service_provider = "github"
}

resource "tfe_policy_set" "test" {
  name         = "global-policy-set"
  description  = "A brand new policy set"
  global       = true
  organization = "acme5"
  #  policies_path          = "policies/globalk" -<< this cna be subpath in repo

  vcs_repo {
    identifier         = "Galser/tfe-policy-fork-test"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = "${tfe_oauth_client.test.oauth_token_id}"
  }
}
