#!/bin/bash
# /** @file
#
#   A brief file description
#
#   @section license License
#
#   Licensed to the Apache Software Foundation (ASF) under one
#   or more contributor license agreements.  See the NOTICE file
#   distributed with this work for additional information
#   regarding copyright ownership.  The ASF licenses this file
#   to you under the Apache License, Version 2.0 (the
#   "License"); you may not use this file except in compliance
#   with the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#  */

# usage: ./interupts.sh interrupts_name
if [[ -z "$1" ]]; then
	echo "usage: ./interupts.sh interrupts_name"
	exit 1
fi

if [[ -z `cat /proc/interrupts | grep $1` ]]; then
	echo "did not find interrupts '$1'"
	exit 1
fi

filename=`cat /proc/interrupts | grep $1`
i=0
while IFS= read -r line; do
	irq=`echo $line | awk -F ':' '{print $1}'`
	affinity="`echo $i | awk '{printf("%x", lshift(1,$0))}'`$extra"
	file="/proc/irq/$irq/smp_affinity"
	let i++
	if [[ "$i" -gt "31" ]]; then
		i=0
		extra=",00000000$extra"
	fi
	echo "echo $affinity > $file"
	`echo $affinity > $file`
done < <(printf '%s\n', "$filename")
