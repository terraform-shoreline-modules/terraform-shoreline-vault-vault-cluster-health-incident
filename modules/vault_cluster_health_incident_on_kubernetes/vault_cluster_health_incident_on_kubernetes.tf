resource "shoreline_notebook" "vault_cluster_health_incident_on_kubernetes" {
  name       = "vault_cluster_health_incident_on_kubernetes"
  data       = file("${path.module}/data/vault_cluster_health_incident_on_kubernetes.json")
  depends_on = [shoreline_action.invoke_vault_container_logs,shoreline_action.invoke_get_vault_logs,shoreline_action.invoke_rolling_restart]
}

resource "shoreline_file" "vault_container_logs" {
  name             = "vault_container_logs"
  input_file       = "${path.module}/data/vault_container_logs.sh"
  md5              = filemd5("${path.module}/data/vault_container_logs.sh")
  description      = "A network issue that is affecting the connectivity or performance of the Vault cluster instance."
  destination_path = "/agent/scripts/vault_container_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_vault_logs" {
  name             = "get_vault_logs"
  input_file       = "${path.module}/data/get_vault_logs.sh"
  md5              = filemd5("${path.module}/data/get_vault_logs.sh")
  description      = "Check the logs of the Vault cluster instance to identify the root cause of the issue. This could involve looking for error messages or other indicators of problems with the instance."
  destination_path = "/agent/scripts/get_vault_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rolling_restart" {
  name             = "rolling_restart"
  input_file       = "${path.module}/data/rolling_restart.sh"
  md5              = filemd5("${path.module}/data/rolling_restart.sh")
  description      = "Restart the Vault cluster instance to see if this resolves the issue. This could involve stopping and starting the instance, or rebooting the server if necessary."
  destination_path = "/agent/scripts/rolling_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_vault_container_logs" {
  name        = "invoke_vault_container_logs"
  description = "A network issue that is affecting the connectivity or performance of the Vault cluster instance."
  command     = "`chmod +x /agent/scripts/vault_container_logs.sh && /agent/scripts/vault_container_logs.sh`"
  params      = ["VAULT_POD_NAME","SERVICE_URL","SERVICE_NAME","CONTAINER_NAME","NAMESPACE"]
  file_deps   = ["vault_container_logs"]
  enabled     = true
  depends_on  = [shoreline_file.vault_container_logs]
}

resource "shoreline_action" "invoke_get_vault_logs" {
  name        = "invoke_get_vault_logs"
  description = "Check the logs of the Vault cluster instance to identify the root cause of the issue. This could involve looking for error messages or other indicators of problems with the instance."
  command     = "`chmod +x /agent/scripts/get_vault_logs.sh && /agent/scripts/get_vault_logs.sh`"
  params      = ["VAULT_POD_NAME","LOG_FILE_PATH"]
  file_deps   = ["get_vault_logs"]
  enabled     = true
  depends_on  = [shoreline_file.get_vault_logs]
}

resource "shoreline_action" "invoke_rolling_restart" {
  name        = "invoke_rolling_restart"
  description = "Restart the Vault cluster instance to see if this resolves the issue. This could involve stopping and starting the instance, or rebooting the server if necessary."
  command     = "`chmod +x /agent/scripts/rolling_restart.sh && /agent/scripts/rolling_restart.sh`"
  params      = ["DEPLOYMENT_NAME","NAMESPACE"]
  file_deps   = ["rolling_restart"]
  enabled     = true
  depends_on  = [shoreline_file.rolling_restart]
}

