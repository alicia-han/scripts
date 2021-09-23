#!/bin/bash


#######################
# Get Vitrine Logs
# $1: Start Date
# $2: End Date
# $3: (optional) output redirection
#######################

function getLogs() {
  gcloud --project ornikar-fr-prod-websites logging read 'resource.type="cloud_run_revision"
log_name="projects/ornikar-fr-prod-websites/logs/run.googleapis.com%2Frequests" 
resource.labels.service_name="fr-prod-website"' --limit 10 --format "csv(httpRequest.remoteIp,httpRequest.userAgent,httpRequest.requestUrl,timestamp,httpRequest.status)"
}


#resource.labels.service_name="fr-prod-website"' --limit 10 --format "csv(httpRequest.latency,httpRequest.protocol,httpRequest.referer,httpRequest.remoteIp,httpRequest.requestMethod,httpRequest.requestSize,httpRequest.requestUrl,httpRequest.responseSize,httpRequest.serverIp,httpRequest.status,httpRequest.userAgent,insertId,labels.instanceId,logName,receiveTimestamp,resource.labels.configuration_name,resource.labels.location,resource.labels.project_id,resource.labels.revision_name,resource.labels.service_name,resource.type,severity,timestamp,trace)"
while getopts "h" arg
do
  case $arg in
    # a)
    # $OPTARG
    # ;;
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

getLogs


#case $1 in
#  aaaa)
#  shift 1
#  ccRunServices "$@"
#  ;;
#  "")
#  exit 0
#  ;;
#  *)
#  echo -e "\\033[31m Error \\033[0m No Such Option" 1>&2
#  exit 1
#  ;;
#esac
