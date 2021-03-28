#!/bin/sh

# just check possible changes on GitHub


# test whether there is redirected input
if test -t 0; then
   A=''
else
    while IFS= read -r line; do
    LOG_FILES="$LOG_FILES$line\n"
    done
fi


export POSIXLY_CORRECT=yes
export LC_NUMERIC=en_US.UTF-8

print_help()
{
    echo "Usage: tradelog [-h|--help]"
	echo "       tradelog [FILTER...] [COMMAND] [LOG...]"
	echo ""
}
COMMAND=""
WIDTH=""
TICKER=""
while getopts :abt:wh-: opts
do case "$opts" in
   a) echo "a";;
   b) echo "b";;
   t) TICKER=$TICKER"$OPTARG;"
      TFLAG=1;;
   w) echo "w";;
   h) print_help ;;
   -) print_help;;
   esac
done

shift $(($OPTIND - 1))

# initialize value for the command and delete argument
case $1 in
  list-tick | profit | pos | last-price | hist-ord | graph-pos)
    COMMAND=$1
    shift
    ;;
esac

while [ $# -gt 0 ]
  do
    case $1 in
      *.log.gz)
        LOG_FILES="$LOG_FILES$(gzip -d -c "$1")\n"
        shift
        continue
        ;;
      *.log)
        LOG_FILES="$LOG_FILES$(cat "$1")\n"
        shift
        continue
        ;;
    esac
  done

# checking flags of filters
if [ "$TFLAG" = "1" ]; then
    LOG_FILES=$(echo "$LOG_FILES" | awk -F ';' -v ticker="$TICKER" 'ticker~ $2";" {print}')
    echo "$LOG_FILES"
fi



# 1) RENAME TRADELOG.SH -> TRADELOG
# 2)