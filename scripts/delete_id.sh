#!/bin/bash

ID=$1

echo "Running command: DELETE FROM order_ids WHERE id=\"$ID\""

sqlite3 ids.db "DELETE FROM order_ids WHERE id=\"$ID\""
