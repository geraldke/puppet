#!/bin/sh

syntax_errors=0
error_message=$(mktemp /tmp/error_message.XXXXXX)

if git rev-parse --quiet --verify HEAD > /dev/null
then
  against=HEAD
else
  # Initial commit diff against an empty tree object
  against=4b825dc642cb6eb91060e54bf8d69288fbee4904
fi

# Get list of new/modified manifest and template files to check (in git index)
for indexfile in `git diff-index --diff-filter=AM --name-only --cached $against | egrep '\.(pp|erb)'`
do
  # Don't check empty files
  if [ `git cat-file -s :0:$indexfile` -gt 0 ]
  then
    case $indexfile in
      *.pp )
        # Check puppet manifest syntax
        git cat-file blob :0:$indexfile |
          puppet parser validate > $error_message ;;
      *.erb )
        # Check ERB template syntax
        git cat-file blob :0:$indexfile |
          erb -x -T - | ruby -c 2> $error_message > /dev/null ;;
    esac
    if [ "$?" -ne 0 ]
    then
      echo -n "$indexfile: "
      cat $error_message
      syntax_errors=`expr $syntax_errors + 1`
    fi
  fi
done

rm -f $error_message

if [ "$syntax_errors" -ne 0 ]
then
  echo "Error: $syntax_errors syntax errors found, aborting commit."
  exit 1
fi
