#!/usr/bin/env bash
# Author: Ingo Schmitt <ingo.schmitt@marketing-factory.de>

usage() {
cat << EOF
This script downloads all avaliable AWS CF Logfiles and processes the to matomo

usage: $0 -s SOURCES3BUCKET -d DESTS3BUCKET -p AWSPROFILE -m MATOMOURL -l MATOMOLOGPARSER -i MATOMOSITE -a MATOMOAPITOKEN  [-r AWSREGION]

-s SOURCES3BUCKET:         Source S3 Bucket where the logs are stored
-d DESTS3BUCKET:           Destination S3 Bucket where the analysed logs are moved to
-p AWSPROFILE:             aws cli profile for the connection
-r AWSREGION:              AWS Region for S3 Buchet, default eu-central-1
-m MATOMOURL:              Url for Matomo
-l MATOMOLOGPARSER:        path to matomo Logparser import_logs.py
-i MATOMOSITE:             Matomo Site ID
-a MATOMOAPITOKEN:         Matomo API Token

EOF
}




while getopts ":s:d:p:r:m:l:i:a:h" OPTION; do
    case "${OPTION}" in
        s)
          SOURCES3BUCKET="${OPTARG}";;
        d)
          DESTS3BUCKET="${OPTARG}";;
        p)
          AWSPROFILE="${OPTARG}";;
        r)
          AWSREGION="${OPTARG}";;
        m)
          MATOMOURL="${OPTARG}";;
        l)
          MATOMOLOGPARSER="${OPTARG}";;
        i)
          MATOMOSITE="${OPTARG}";;
        a)
          MATOMOAPITOKEN="${OPTARG}";;
        h)
          usage
          exit 0;;
        *)
          usage
          exit 0;;
    esac
done

shift $(( OPTIND - 1 ))

TMPDIR=""
CWD="$(pwd)"

test ! ${AWSREGION} && AWSREGION="eu-central-1"
test ! -d ${TMPDIR} && mkdir -p ${TMPDIR}



test ! ${SOURCES3BUCKET} && usage
test ! ${DESTS3BUCKET} && usage
test ! ${AWSPROFILE} && usage
test ! ${MATOMOURL} && usage
test ! ${MATOMOLOGPARSER} && usage
test ! ${MATOMOSITE} && usage
test ! ${MATOMOAPITOKEN} && usage


function cleanup {
    [[ -n "${TMPDIR}" ]] && rm -rf "${TMPDIR}"
    cd "${CWD}"
}

trap cleanup EXIT
TMPDIR="$(mktemp -d 2> /dev/null || mktemp -d -t 'cflogs')"

printf 'TMPDIR=%q\n' "${TMPDIR}"

FILELIST=$(mktemp)

aws s3 ls --profile $AWSPROFILE --region=$AWSREGION $SOURCES3BUCKET/ | awk '{print $4}' > $FILELIST

while read filename; do
  if [ -n "$filename" ];then
    aws s3 cp $SOURCES3BUCKET/$filename $TMPDIR/ --profile $AWSPROFILE --region=$AWSREGION
    python3 $MATOMOLOGPARSER  \
        --url=$MATOMOURL \
        --idsite=$MATOMOSITE  \
        --log-format-name=amazon_cloudfront  \
        --recorders=4 \
        --enable-http-errors \
        --enable-http-redirects \
        --enable-static \
        --token-auth=$MATOMOAPITOKEN \
        $TMPDIR/$filename && aws s3 mv $SOURCES3BUCKET/$filename $DESTS3BUCKET/ --profile $AWSPROFILE \
        --region=$AWSREGION || echo "Matomo failed on $filename"
    rm $TMPDIR/$filename
  fi
done < $FILELIST

rm -r $FILELIST