# dokku questdb [![Build Status](https://img.shields.io/github/actions/workflow/status/dokku/dokku-questdb/ci.yml?branch=master&style=flat-square "Build Status")](https://github.com/dokku/dokku-questdb/actions/workflows/ci.yml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

QuestDB plugin for dokku. Currently defaults to installing [questdb/questdb:latest](https://hub.docker.com/r/questdb/questdb).

## Requirements

- dokku 0.19.x+
- docker 1.8.x

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/nunombispo/dokku-questdb.git --name questdb
```

## Commands

```
questdb:app-links <app>                           # list all questdb service links for a given app
questdb:backup <service> <bucket-name> [--use-iam] # create a backup of the questdb service to an existing s3 bucket
questdb:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url> # set up authentication for backups on the questdb service
questdb:backup-deauth <service>                   # remove backup authentication for the questdb service
questdb:backup-schedule <service> <schedule> <bucket-name> [--use-iam] # schedule a backup of the questdb service
questdb:backup-schedule-cat <service>             # cat the contents of the configured backup cronfile for the service
questdb:backup-set-encryption <service> <passphrase> # set encryption for all future backups of questdb service
questdb:backup-set-public-key-encryption <service> <public-key-id> # set GPG Public Key encryption for all future backups of questdb service
questdb:backup-unschedule <service>               # unschedule the backup of the questdb service
questdb:backup-unset-encryption <service>         # unset encryption for future backups of the questdb service
questdb:backup-unset-public-key-encryption <service> # unset GPG Public Key encryption for future backups of the questdb service
questdb:clone <service> <new-service> [--clone-flags...] # create container <new-name> then copy data from <name> into <new-name>
questdb:connect <service>                         # connect to the service via the questdb connection tool
questdb:create <service> [--create-flags...]      # create a questdb service
questdb:destroy <service> [-f|--force]            # delete the questdb service/data/container if there are no links left
questdb:enter <service>                           # enter or run a command in a running questdb service container
questdb:exists <service>                          # check if the questdb service exists
questdb:export <service>                          # export a dump of the questdb service database
questdb:expose <service> <ports...>               # expose a questdb service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
questdb:import <service>                          # import a dump into the questdb service database
questdb:info <service> [--single-info-flag]       # print the service information
questdb:link <service> <app> [--link-flags...]    # link the questdb service to the app
questdb:linked <service> <app>                    # check if the questdb service is linked to an app
questdb:links <service>                          # list all apps linked to the questdb service
questdb:list                                      # list all questdb services
questdb:logs <service> [-t|--tail] <tail-num-optional> # print the most recent log(s) for this service
questdb:pause <service>                           # pause a running questdb service
questdb:promote <service> <app>                   # promote service <service> as DATABASE_URL in <app>
questdb:restart <service>                         # graceful shutdown and restart of the questdb service container
questdb:set <service> <key> <value>               # set or clear a property for a service
questdb:start <service>                           # start a previously stopped questdb service
questdb:stop <service>                            # stop a running questdb service
questdb:unexpose <service>                        # unexpose a previously exposed questdb service
questdb:unlink <service> <app>                    # unlink the questdb service from the app
questdb:upgrade <service> [--upgrade-flags...]    # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to questdb:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `questdb:help` command for any undocumented commands.

### Basic Usage

### create a questdb service

```shell
# usage
dokku questdb:create <service> [--create-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit in megabytes (default: unlimited)
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-p|--password PASSWORD`: override the user-level service password (not used by QuestDB, kept for compatibility)
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-r|--root-password PASSWORD`: override the root-level service password (not used by QuestDB, kept for compatibility)
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for questdb docker container

Create a questdb service named lollipop:

```shell
dokku questdb:create lollipop
```

You can also specify the image and image version to use for the service. It _must_ be compatible with the questdb image.

```shell
export QUESTDB_IMAGE="questdb/questdb"
export QUESTDB_IMAGE_VERSION="latest"
dokku questdb:create lollipop
```

You can also specify custom environment variables to start the questdb service in semicolon-separated form.

```shell
export QUESTDB_CUSTOM_ENV="QDB_PG_USER=admin;QDB_PG_PASSWORD=quest"
dokku questdb:create lollipop
```

### print the service information

```shell
# usage
dokku questdb:info <service> [--single-info-flag]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--internal-ip`: show the service internal ip
- `--initial-network`: show the initial network being connected to
- `--links`: show the service app links
- `--post-create-network`: show the networks to attach to after service container creation
- `--post-start-network`: show the networks to attach to after service container start
- `--service-root`: show the service root directory
- `--status`: show the service running status
- `--version`: show the service image version

Get connection information as follows:

```shell
dokku questdb:info lollipop
```

You can also retrieve a specific piece of service info via flags:

```shell
dokku questdb:info lollipop --config-dir
dokku questdb:info lollipop --data-dir
dokku questdb:info lollipop --dsn
dokku questdb:info lollipop --exposed-ports
dokku questdb:info lollipop --id
dokku questdb:info lollipop --internal-ip
dokku questdb:info lollipop --initial-network
dokku questdb:info lollipop --links
dokku questdb:info lollipop --post-create-network
dokku questdb:info lollipop --post-start-network
dokku questdb:info lollipop --service-root
dokku questdb:info lollipop --status
dokku questdb:info lollipop --version
```

### list all questdb services

```shell
# usage
dokku questdb:list
```

List all services:

```shell
dokku questdb:list
```

### print the most recent log(s) for this service

```shell
# usage
dokku questdb:logs <service> [-t|--tail] <tail-num-optional>
```

flags:

- `-t|--tail [<tail-num>]`: do not stop when end of the logs are reached and wait for additional output

You can tail logs for a particular service:

```shell
dokku questdb:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku questdb:logs lollipop --tail
```

The default tail setting is to show all logs, but an initial count can also be specified:

```shell
dokku questdb:logs lollipop --tail 5
```

### link the questdb service to the app

```shell
# usage
dokku questdb:link <service> <app> [--link-flags...]
```

flags:

- `-a|--alias "BLUE_DATABASE"`: an alternative alias to use for linking to an app via environment variable
- `-q|--querystring "pool=5"`: ampersand delimited querystring arguments to append to the service link
- `-n|--no-restart "false"`: whether or not to restart the app on link (default: true)

A questdb service can be linked to a container. This will use native docker links via the docker-options plugin. Here we link it to our `playground` app.

> NOTE: this will restart your app

```shell
dokku questdb:link lollipop playground
```

The following environment variables will be set automatically by docker (not on the app itself, so they won't be listed when calling dokku config):

```
DOKKU_QUESTDB_LOLLIPOP_NAME=/lollipop/DATABASE
DOKKU_QUESTDB_LOLLIPOP_PORT=tcp://172.17.0.1:8812
DOKKU_QUESTDB_LOLLIPOP_PORT_8812_TCP=tcp://172.17.0.1:8812
DOKKU_QUESTDB_LOLLIPOP_PORT_8812_TCP_PROTO=tcp
DOKKU_QUESTDB_LOLLIPOP_PORT_8812_TCP_PORT=8812
DOKKU_QUESTDB_LOLLIPOP_PORT_8812_TCP_ADDR=172.17.0.1
```

The following will be set on the linked application by default:

```
DATABASE_URL=postgresql://dokku-questdb-lollipop:8812
```

The host exposed here only works internally in docker containers. If you want your container to be reachable from outside, you should use the `expose` subcommand. Another service can be linked to your app:

```shell
dokku questdb:link other_service playground
```

It is possible to change the protocol for `DATABASE_URL` by setting the environment variable `QUESTDB_DATABASE_SCHEME` on the app. Doing so will after linking will cause the plugin to think the service is not linked, and we advise you to unlink before proceeding.

```shell
dokku config:set playground QUESTDB_DATABASE_SCHEME=postgres
dokku questdb:link lollipop playground
```

This will cause `DATABASE_URL` to be set as:

```
postgres://dokku-questdb-lollipop:8812
```

### unlink the questdb service from the app

```shell
# usage
dokku questdb:unlink <service> <app>
```

flags:

- `-n|--no-restart "false"`: whether or not to restart the app on unlink (default: true)

You can unlink a questdb service:

> NOTE: this will restart your app and unset related environment variables

```shell
dokku questdb:unlink lollipop playground
```

### set or clear a property for a service

```shell
# usage
dokku questdb:set <service> <key> <value>
```

Set the network to attach after the service container is started:

```shell
dokku questdb:set lollipop post-create-network custom-network
```

Set multiple networks:

```shell
dokku questdb:set lollipop post-create-network custom-network,other-network
```

Unset the post-create-network value:

```shell
dokku questdb:set lollipop post-create-network
```

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### connect to the service via the questdb connection tool

```shell
# usage
dokku questdb:connect <service>
```

Connect to the service via the PostgreSQL wire protocol (QuestDB supports PostgreSQL wire protocol):

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku questdb:connect lollipop
```

### enter or run a command in a running questdb service container

```shell
# usage
dokku questdb:enter <service>
```

A bash prompt can be opened against a running service. Filesystem changes will not be saved to disk.

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku questdb:enter lollipop
```

You may also run a command directly against the service. Filesystem changes will not be saved to disk.

```shell
dokku questdb:enter lollipop touch /tmp/test
```

### expose a questdb service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku questdb:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku questdb:expose lollipop 8812
```

Expose the service on the service's normal ports, with the first on a specified ip address (127.0.0.1):

```shell
dokku questdb:expose lollipop 127.0.0.1:8812
```

### unexpose a previously exposed questdb service

```shell
# usage
dokku questdb:unexpose <service>
```

Unexpose the service, removing access to it from the public interface (`0.0.0.0`):

```shell
dokku questdb:unexpose lollipop
```

### promote service <service> as DATABASE_URL in <app>

```shell
# usage
dokku questdb:promote <service> <app>
```

If you have a questdb service linked to an app and try to link another questdb service another link environment variable will be generated automatically:

```
DOKKU_DATABASE_BLUE_URL=postgresql://dokku-questdb-other-service:8812
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku questdb:promote other_service playground
```

This will replace `DATABASE_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
DATABASE_URL=postgresql://dokku-questdb-other-service:8812
DOKKU_DATABASE_BLUE_URL=postgresql://dokku-questdb-other-service:8812
DOKKU_DATABASE_SILVER_URL=postgresql://dokku-questdb-lollipop:8812
```

### start a previously stopped questdb service

```shell
# usage
dokku questdb:start <service>
```

Start the service:

```shell
dokku questdb:start lollipop
```

### stop a running questdb service

```shell
# usage
dokku questdb:stop <service>
```

Stop the service and removes the running container:

```shell
dokku questdb:stop lollipop
```

### pause a running questdb service

```shell
# usage
dokku questdb:pause <service>
```

Pause the running container for the service:

```shell
dokku questdb:pause lollipop
```

### graceful shutdown and restart of the questdb service container

```shell
# usage
dokku questdb:restart <service>
```

Restart the service:

```shell
dokku questdb:restart lollipop
```

### upgrade service <service> to the specified versions

```shell
# usage
dokku questdb:upgrade <service> [--upgrade-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-R|--restart-apps "true"`: whether or not to force an app restart (default: false)
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for questdb docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku questdb:upgrade lollipop
```

QuestDB upgrades should be done manually. Users are encouraged to upgrade to the latest release.

While there are many ways to upgrade a QuestDB database, for safety purposes, it is recommended that an upgrade is performed by exporting the data from an existing database and importing it into a new database. This also allows testing to ensure that applications interact with the database correctly after the upgrade, and can be used in a staging environment.

The following is an example of how to upgrade a QuestDB database named `lollipop-old` to a new version.

```shell
# stop any linked apps
dokku ps:stop linked-app

# export the database contents
dokku questdb:export lollipop-old > /tmp/lollipop-old.export

# create a new database at the desired version
dokku questdb:create lollipop-new --image-version latest

# import the export file
dokku questdb:import lollipop-new < /tmp/lollipop-old.export

# run any sql tests against the new database to verify the import went smoothly

# unlink the old database from your apps
dokku questdb:unlink lollipop-old linked-app

# link the new database to your apps
dokku questdb:link lollipop-new linked-app

# start the linked apps again
dokku ps:start linked-app
```

### Service Automation

Service scripting can be executed using the following commands:

### list all questdb service links for a given app

```shell
# usage
dokku questdb:app-links <app>
```

List all questdb services that are linked to the `playground` app.

```shell
dokku questdb:app-links playground
```

### create container <new-name> then copy data from <name> into <new-name>

```shell
# usage
dokku questdb:clone <service> <new-service> [--clone-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit in megabytes (default: unlimited)
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-p|--password PASSWORD`: override the user-level service password (not used by QuestDB, kept for compatibility)
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-r|--root-password PASSWORD`: override the root-level service password (not used by QuestDB, kept for compatibility)
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for questdb docker container

You can clone an existing service to a new one:

```shell
dokku questdb:clone lollipop lollipop-2
```

### check if the questdb service exists

```shell
# usage
dokku questdb:exists <service>
```

Here we check if the lollipop questdb service exists.

```shell
dokku questdb:exists lollipop
```

### check if the questdb service is linked to an app

```shell
# usage
dokku questdb:linked <service> <app>
```

Here we check if the lollipop questdb service is linked to the `playground` app.

```shell
dokku questdb:linked lollipop playground
```

### list all apps linked to the questdb service

```shell
# usage
dokku questdb:links <service>
```

List all apps linked to the `lollipop` questdb service.

```shell
dokku questdb:links lollipop
```

### Data Management

The underlying service data can be imported and exported with the following commands:

### import a dump into the questdb service database

```shell
# usage
dokku questdb:import <service>
```

Import a datastore dump:

```shell
dokku questdb:import lollipop < data.dump
```

### export a dump of the questdb service database

```shell
# usage
dokku questdb:export <service>
```

By default, datastore output is exported to stdout:

```shell
dokku questdb:export lollipop
```

You can redirect this output to a file:

```shell
dokku questdb:export lollipop > data.dump
```

Note that the export will result in a tar archive containing the QuestDB data directory. To restore, extract and place the contents in the QuestDB data directory.

### Backups

Datastore backups are supported via AWS S3 and S3 compatible services like [minio](https://github.com/minio/minio).

You may skip the `backup-auth` step if your dokku install is running within EC2 and has access to the bucket via an IAM profile. In that case, use the `--use-iam` option with the `backup` command.

Backups can be performed using the backup commands:

### set up authentication for backups on the questdb service

```shell
# usage
dokku questdb:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url>
```

Setup s3 backup authentication:

```shell
dokku questdb:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
```

Setup s3 backup authentication with different region:

```shell
dokku questdb:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION
```

Setup s3 backup authentication with different signature version and endpoint:

```shell
dokku questdb:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION AWS_SIGNATURE_VERSION ENDPOINT_URL
```

More specific example for minio auth:

```shell
dokku questdb:backup-auth lollipop MINIO_ACCESS_KEY_ID MINIO_SECRET_ACCESS_KEY us-east-1 s3v4 https://YOURMINIOSERVICE
```

### remove backup authentication for the questdb service

```shell
# usage
dokku questdb:backup-deauth <service>
```

Remove s3 authentication:

```shell
dokku questdb:backup-deauth lollipop
```

### create a backup of the questdb service to an existing s3 bucket

```shell
# usage
dokku questdb:backup <service> <bucket-name> [--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Backup the `lollipop` service to the `my-s3-bucket` bucket on `AWS`:

```shell
dokku questdb:backup lollipop my-s3-bucket --use-iam
```

Restore a backup file (assuming it was extracted via `tar -xf backup.tgz`):

```shell
dokku questdb:import lollipop < backup-folder/export
```

### set encryption for all future backups of questdb service

```shell
# usage
dokku questdb:backup-set-encryption <service> <passphrase>
```

Set the GPG-compatible passphrase for encrypting backups for backups:

```shell
dokku questdb:backup-set-encryption lollipop
```

### set GPG Public Key encryption for all future backups of questdb service

```shell
# usage
dokku questdb:backup-set-public-key-encryption <service> <public-key-id>
```

Set the `GPG` Public Key for encrypting backups:

```shell
dokku questdb:backup-set-public-key-encryption lollipop
```

### unset encryption for future backups of the questdb service

```shell
# usage
dokku questdb:backup-unset-encryption <service>
```

Unset the `GPG` encryption passphrase for backups:

```shell
dokku questdb:backup-unset-encryption lollipop
```

### unset GPG Public Key encryption for future backups of the questdb service

```shell
# usage
dokku questdb:backup-unset-public-key-encryption <service>
```

Unset the `GPG` Public Key encryption for backups:

```shell
dokku questdb:backup-unset-public-key-encryption lollipop
```

### schedule a backup of the questdb service

```shell
# usage
dokku questdb:backup-schedule <service> <schedule> <bucket-name> [--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Schedule a backup:

> 'schedule' is a crontab expression, eg. "0 3 \* \* \*" for each day at 3am

```shell
dokku questdb:backup-schedule lollipop "0 3 * * *" my-s3-bucket
```

Schedule a backup and authenticate via iam:

```shell
dokku questdb:backup-schedule lollipop "0 3 * * *" my-s3-bucket --use-iam
```

### cat the contents of the configured backup cronfile for the service

```shell
# usage
dokku questdb:backup-schedule-cat <service>
```

Cat the contents of the configured backup cronfile for the service:

```shell
dokku questdb:backup-schedule-cat lollipop
```

### unschedule the backup of the questdb service

```shell
# usage
dokku questdb:backup-unschedule <service>
```

Remove the scheduled backup from cron:

```shell
dokku questdb:backup-unschedule lollipop
```

### Disabling `docker image pull` calls

If you wish to disable the `docker image pull` calls that the plugin triggers, you may set the `QUESTDB_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker image pull` is disabled.
