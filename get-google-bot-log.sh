#!/bin/bash

usageRun() {
  cat <<-EOF
      Usage: ./get-google-bot-log.sh 2021-01-01 2021-01-02 fr

      PARAMETRES:
      ===========
          1:    start date format 2021-01-01 YYYY-MM-DD
          2:    end date format 2021-01-01
          3:    market place: fr/es


      OPTIONS:
      ========
          -h    Affiche ce message

      EXAMPLES:
      =========
        ./get-google-bot-log.sh 2021-01-01 2021-01-02 fr
        it will collect logs from 2021-01-01 00:00 to 2021-01-02 23:59

EOF
}


function getLogs() {
  func_check_date $1 &&\
  func_check_date $2 &&\
  echo querying : $(func_generate_search_phrase $1 $2 $3)
  echo "-------"
  gcloud --project ornikar-fr-prod-websites\
    logging read \
    --location=global \
    --bucket="ornikar-${3}-prod-websites-log-requests-seo" \
    --format "csv(httpRequest.remoteIp,httpRequest.userAgent,httpRequest.requestUrl,timestamp,httpRequest.status)" \
    --view=_AllLogs \
    "$(func_generate_search_phrase $1 $2 $3)" > $3.$1.to.$2.csv 
}


function func_check_date() {
  if [[ ! $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo -e "\033[31m [ERROR] \033[0m date should be like 2021-01-01"
    exit 2
  fi
}


#######################
# $1: Start Date 2021-01-01
# $2: End Date   2021-01-02
# $3: market place fr/es
#######################
function func_generate_search_phrase() {
    search_string='resource.type="cloud_run_revision" resource.labels.service_name="'"$3-prod-website"'" log_name="projects/ornikar-'"$3-prod-websites/logs/run.googleapis.com%2Frequests"'" timestamp>="'$1'T00:00:00Z" timestamp<="'$2'T23:59:59Z"'
    echo $search_string
}

# Format examples: 
#--format "csv(httpRequest.latency,httpRequest.protocol,httpRequest.referer,httpRequest.remoteIp,httpRequest.requestMethod,httpRequest.requestSize,httpRequest.requestUrl,httpRequest.responseSize,httpRequest.serverIp,httpRequest.status,httpRequest.userAgent,insertId,labels.instanceId,logName,receiveTimestamp,resource.labels.configuration_name,resource.labels.location,resource.labels.project_id,resource.labels.revision_name,resource.labels.service_name,resource.type,severity,timestamp,trace)"

while getopts "h" arg
do
  case $arg in
    h)
    usageRun
    exit 0
    ;;
    ?)
    echo -e "\\033[31m Unknow argument \\033[0m"
    exit 1
    ;;
  esac
done

shift $((OPTIND-1))

getLogs $@
