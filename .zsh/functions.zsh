tunnel_console_dev_db() {
  tldev
  tkldev
  tldbdev
  tpdbdev
}

tunnel_console_stg_db() {
  tlstg
  tklstg
  tldbstg
  tpdbstg
}

tunnel_console_prod_db() {
  tlprod
  tklprod
  tldbprod
  tpdbprod
}

get_console_ops_box() {
  kubectl get pods -n console --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep eng-console-ops-ops-standby
}

get_pm_ops_box() {
  kubectl get pods -n fellowship-of-the-coin --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep eng-payment-mediator-ops-ops-standby
}

get_ls_ops_box() {
  kubectl get pods -n fellowship-of-the-coin --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep eng-lending-service-microservice
}

k_exec(){
  echo "Name the pod: "
  read pod_name

  kubectl exec -it $pod_name -- /bin/bash
}

kcp_upload_file() {
  echo "Enter the path to the file you want to upload: "
  read local_file

  kubectl cp -n console $local_file /$(getopsbox):/tmp/
}

kcp_download_file() {
  echo "Enter the path to the file you want to download: "
  read remote_file_name

  kubectl cp -n console $(getopsbox):$remote_file_name /Users/martinleepan/Downloads/$remote_file_name
}

k_scale_pod() {
  echo "Enter the name of the pod to scale: "
  read pod_name

  echo "Enter the number of pods to scale to: "
  read pod_size

  kubectl scale deployment $pod_name --replicas=$pod_size
}

kpods_detailed() {
  kubectl get pods --all-namespaces -o jsonpath="{..image}" |\
  tr -s '[[:space:]]' '\n' |\
  sort |\
  uniq -c
}
