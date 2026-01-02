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
  kubectl get pods -n console --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep eng-console-ops-standby
}

get_pm_ops_box() {
  kubectl get pods -n fellowship-of-the-coin --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep eng-payment-mediator-ops-standby
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

ic_restore() {
  bundle exec rake db:drop db:create
  echo "Enter the path to the file you want to restore: "
  read path_to_file
  pg_restore --clean --no-acl --no-owner -h localhost -U martinlp -L <(pg_restore -l $path_to_file | grep -vE 'TABLE DATA public (admins|alertable_cities|api_counters|api_logs|ar_internal_metadata|article_objects|articles|audits|blazer_audits|booking_alerts|booking_algorithm_logs|booking_ledgers|booking_transaction_events|careers|clients_clone|daily_price_plans|event_logs|extras|galleries|images|incident_types|old_rvs_prices|payment_request_logs|price_plan_consultations|price_plans|primavera_invoices|search_logs|sessions|special_offers|taggings|tags|vans)') -d indiecampers $path_to_file
}

daily_dump() {
  aws s3 cp s3://all-indie-all-backups/postgres/prod/platform/prod-indie-platform_`{date +'%Y%m%d'}`_0230.dump ~/Downloads/dumps/prod-indie-platform_`{date +'%Y%m%d'}`.dump
}

aws_exec_pricing_service() {
  echo "Enter ENV in capital letters ie: DEV"
  read env
  task_arn="$(aws ecs list-tasks --cluster ${env}-indie-pricing-cluster --service ${env}-indie-pricing-service --desired-status RUNNING --region eu-west-1 --query 'taskArns[0]' --output text)"
  
  aws ecs execute-command --cluster ${env}-indie-pricing-cluster --task $task_arn --container pricing-app --interactive  --command "/bin/bash" --region eu-west-1
}

aws_exec_search_service() {
  echo "Enter ENV in capital letters ie: DEV"
  read env
  task_arn="$(aws ecs list-tasks --cluster ${env}-indie-search-cluster --service ${env}-indie-search-service --desired-status RUNNING --region eu-west-1 --query 'taskArns[0]' --output text)"
  
  aws ecs execute-command --cluster ${env}-indie-search-cluster --task $task_arn --container search-app --interactive  --command "/bin/bash" --region eu-west-1
}

vam-connect() {
  local instance_id=$(aws ec2 describe-instances \
    --region eu-west-1 \
    --filters "Name=tag:Name,Values=vehicle-allocation-model" \
              "Name=instance-state-name,Values=running" \
    --query 'Reservations[0].Instances[0].InstanceId' \
    --output text)
  
  if [ "$instance_id" = "None" ] || [ -z "$instance_id" ]; then
    echo "Error: No running vehicle-allocation-model instance found"
    return 1
  fi
  
  echo "Connecting to instance: $instance_id"
  aws ssm start-session --target "$instance_id" --region eu-west-1
}

ecs_exec_vam() {
  local cluster="${1:-PRD-vehicle-allocation-cluster}"
  local container="${2:-vehicle-allocation}"
  
  echo "Finding running tasks in cluster: $cluster"
  
  # Get all running task ARNs
  local tasks=$(aws ecs list-tasks \
    --cluster "$cluster" \
    --desired-status RUNNING \
    --region eu-west-1 \
    --query 'taskArns[]' \
    --output text)
  
  if [ -z "$tasks" ]; then
    echo "No running tasks found in cluster $cluster"
    return 1
  fi
  
  # Convert to array
  local task_array=($tasks)
  
  if [ ${#task_array[@]} -eq 1 ]; then
    # Only one task, connect directly
    local task_id=$(echo "${task_array[1]}" | cut -d'/' -f3)
    echo "Connecting to task: $task_id"
    aws ecs execute-command \
      --cluster "$cluster" \
      --task "$task_id" \
      --container "$container" \
      --command "/bin/bash" \
      --interactive \
      --region eu-west-1
  else
    # Multiple tasks, let user choose
    echo "Multiple tasks found:"
    local i=1
    for task in "${task_array[@]}"; do
      local task_id=$(echo "$task" | cut -d'/' -f3)
      echo "  $i) $task_id"
      ((i++))
    done
    
    echo -n "Select task number: "
    read selection
    
    local selected_task="${task_array[$((selection-1))]}"
    local task_id=$(echo "$selected_task" | cut -d'/' -f3)
    
    echo "Connecting to task: $task_id"
    aws ecs execute-command \
      --cluster "$cluster" \
      --task "$task_id" \
      --container "$container" \
      --command "/bin/bash" \
      --interactive \
      --region eu-west-1
  fi
}
