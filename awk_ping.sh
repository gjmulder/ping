#!/bin/sh

awk '/64 bytes from/ {print substr($1, 1, 11) "," substr($8, 6)} /no answer yet/ {print substr($1, 1, 11) ",NA"}' ping.out | tr -d "[ ]"
