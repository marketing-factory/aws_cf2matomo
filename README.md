# aws_cf2matomo

Bash script to download CloudFront Logs and pass them to Matomo.

You can run this script either directly on the Matomo server, or you can pass the log files via the Matomo API to Matomo from another server.

_Support and more_: https://github.com/marketing-factory/aws_cf2matomo

## Install

* Clone this repository.
* Install the Matomo import script locally: [import_logs.py](https://github.com/matomo-org/matomo-log-analytics/blob/5.x-dev/import_logs.py).
* Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html).
* Create a Matomo API token for passing the logs to Matomo when Matomo is not running on the same machine.

## Usage

Usage: `getLogs.sh: -s SOURCES3BUCKET -d DESTS3BUCKET -p AWSPROFILE -m MATOMOURL -l MATOMOLOGPARSER -i MATOMOSITE -a MATOMOAPITOKEN  [-r AWSREGION]`

* `-s SOURCES3BUCKET`: Source S3 Bucket where the logs are stored.
* `-d DESTS3BUCKET`: Destination S3 Bucket where the analyzed logs are moved to.
* `-p AWSPROFILE`: AWS CLI profile for the connection.
* `-r AWSREGION`: AWS Region for S3 Bucket, default is eu-central-1.
* `-m MATOMOURL`: URL for Matomo.
* `-l MATOMOLOGPARSER`: Path to the Matomo Log Parser import_logs.py.
* `-i MATOMOSITE`: Matomo Site ID.
* `-a MATOMOAPITOKEN`: Matomo API Token.

### Help on Install

#### awscli

`awscli` is needed for downloading the files. Install it directly from AWS, as a Docker image (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-docker.html), or via your distribution's package manager.

On a Mac, `awscli` can be installed with Brew: `brew install awscli`.

#### Matomo Token

* Add the IP address of the remote server to your Matomo `config.ini.php` to prevent brute force detection while parsing logs.
* Create an "insecure" token.