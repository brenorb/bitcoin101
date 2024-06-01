#!/usr/bin/env bash
####################
set -e
####################
####################
init() {
	bundle install
	bundle exec jekyll serve -H 0.0.0.0
	tail -f /dev/null
}
####################
init

