#!/usr/bin/env bash
# Usage: history-search TEXT
#
# Search command history for TEXT.
history-search() {
	local TEXT="$*"
	history | grep "$TEXT"
}
