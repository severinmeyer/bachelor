#!/bin/sh -e

# TASK
#   Validate catalogs/catalogNN*.xml
#   against content/partNN/catalogNN.xsd
#
# DEPENDENCIES
#   libxml2-tools <http://xmlsoft.org/>

for catalog in catalogs/catalog*.xml; do
	part=$(echo "$catalog" | cut --characters 17-18)
	schema="content/part$part/catalog$part.xsd"

	xmllint --noout --schema "$schema" "$catalog"
done
