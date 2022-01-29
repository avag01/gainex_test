terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }
}

provider "google" {
  credentials = "sinuous-pact-339707-b886fbcb72d6.json"
  project = "sinuous-pact-339707"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_cloud_run_service" "webapp" {
  name     = "test-terraform"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "eu.gcr.io/sinuous-pact-339707/terraform-test"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.webapp.location
  project     = google_cloud_run_service.webapp.project
  service     = google_cloud_run_service.webapp.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
