
#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <lab-number>"
	echo "Example: $0 1"
	exit 1
fi

case "$1" in
	1|2|3)
		lab_dir="LAB$1"
		;;
	*)
		echo "Invalid lab number: $1"
		echo "Please choose 1, 2, or 3."
		exit 1
		;;
esac

cd "$lab_dir"
python -m autograder.run.submit assignment.ipynb