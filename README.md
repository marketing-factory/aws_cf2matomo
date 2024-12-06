# aws_cf2matomo

Bash-Skript to download CloudFront Logs and pass them to matomo

You can run this skript ether directly on the matomo server or you can pass the logfiles via matomo API to matom from 
another server. 

_Author_: [Ingo Schmitt](mailto:ingo.schmitt@marketing-factory.de)

_Support and more_: https://github.com/marketing-factory/aws_cf2matomo

## Install

* Clone this repository
* Install locally matomo import skript[import_logs.py](https://github.com/matomo-org/matomo-log-analytics/blob/5.x-dev/import_logs.py)  
* install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
* create a matomo API Token for passing the logs to matomo when matomo is not running on the same machine

## Usage



usage: `getLogs.sh: -s SOURCES3BUCKET -d DESTS3BUCKET -p AWSPROFILE -m MATOMOURL -l MATOMOLOGPARSER -i MATOMOSITE -a MATOMOAPITOKEN  [-r AWSREGION]`

* `-s SOURCES3BUCKET`         Source S3 Bucket where the logs are stored
* `-d DESTS3BUCKET`           Destination S3 Bucket where the analysed logs are moved to
* `-p AWSPROFILE`             aws cli profile for the connection
* `-r AWSREGION`             AWS Region for S3 Buchet, default eu-central-1
* `-m MATOMOURL`              Url for Matomo
* `-l MATOMOLOGPARSER`        path to matomo Logparser import_logs.py
* `-i MATOMOSITE`             Matomo Site ID
* `-a MATOMOAPITOKEN`         Matomo API Token


### Help on Install
#### awscli
`awscli` is needed for downloading the files. So install it directly from AWS, as docker image 
(https://docs.aws.amazon.com/cli/latest/userguide/getting-started-docker.html) 
or via your distribution.

aws cli on Mac can be installed by brew.
`brew install awscli`

#### Matomo Token
* Add IP of remote server to matomo config.ini.php to prevent brute force detection while parsing logs
* Create an "inscure" token!

