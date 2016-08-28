#! /bin/sh

##
# Wrapper for various setup scripts included in the docker-mailserver
##

if [ -z "$DOCKER_IMAGE" ]; then
  DOCKER_IMAGE=tvial/docker-mailserver:latest
fi

_usage() {
  echo "Usage: $0 <subcommand> <subcommand> [args]

SUBCOMMANDS:

  email:

    $0 email add <email> <password>
    $0 email del <email>
    $0 email list (not yet implemented)

  config:

    $0 config dkim
    $0 config ssl

  debug:

    $0 debug fetchmail (not yet implemented)
"
  exit 1
}

_docker() {
  docker run --rm \
  -v "$(pwd)/config":/tmp/docker-mailserver \
  -ti $DOCKER_IMAGE $@
}

case $1 in

  email)
    shift
    case $1 in

      add)
        shift
        _docker addmailuser $@
        ;;
      del)
        shift
        _docker delmailuser $@
        ;;

#      list)
#        ;;

      *)
        _usage
        ;;
    esac
    ;;

  config)
    shift
    case $1 in
      dkim)
        shift
        _docker generate-dkim-config
        ;;

      ssl)
        shift
        _docker generate-ssl-certificate
        ;;
      *)
        _usage
        ;;
    esac
    ;;

  debug)
    shift
    case $1 in
      fetchmail)
        _docker sh -c "cat /etc/fetchmailrc_general /tmp/docker-mailserver/fetchmail.cf > /etc/fetchmailrc; /etc/init.d/fetchmail debug-run"
        ;;
    esac
    ;;

  *)
    _usage
    ;;
esac
