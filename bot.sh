#!/usr/bin/env bash
#
# Commit Bot by Steven Kneiser
#
# > https://github.com/theshteves/commit-bot
#

info="Commit: $(date)"
echo "OS detected: $OSTYPE"

case "$OSTYPE" in
    darwin*)
        cd "`dirname $0`" || exit 1
        ;;

    linux*)
        cd "$(dirname "$(readlink -f "$0")")" || exit 1
        ;;

    *)
        echo "OS unsupported (submit an issue on GitHub!)"
        ;;
esac

# Define a pattern for commits
# Example: Commit 3 times on Mondays, 1 time on Tuesdays, etc.
day_of_week=$(date +%u) # 1 = Monday, 7 = Sunday

case "$day_of_week" in
    1) commit_count=3 ;; # Monday
    2) commit_count=1 ;; # Tuesday
    3) commit_count=2 ;; # Wednesday
    4) commit_count=4 ;; # Thursday
    5) commit_count=1 ;; # Friday
    6) commit_count=0 ;; # Saturday
    7) commit_count=2 ;; # Sunday
    *) commit_count=0 ;; # Fallback
esac

# Perform the commits based on the pattern
for ((i = 1; i <= commit_count; i++)); do
    # Add a delay between commits to spread them out (e.g., 1-2 hours)
    delay=$((RANDOM % 7200 + 3600)) # 3600s = 1 hour, 7200s = 2 hours
    sleep "$delay"

    # Generate commit message
    info="Commit: $(date)"
    echo "$info" >> output.txt
    echo "$info"
    echo

    # Detect current branch (main, master, etc)
    branch=$(git rev-parse --abbrev-ref HEAD)

    # Ship it
    git add output.txt
    git commit -m "$info"
    git push origin "$branch"
done

cd -