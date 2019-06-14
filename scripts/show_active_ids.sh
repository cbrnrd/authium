#!/bin/bash
sqlite3 ids.db ".headers ON" ".mode column" "SELECT * FROM order_ids WHERE activated = 1;" 
