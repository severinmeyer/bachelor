#!/bin/sh -e

# TASK
#   Validate content/partNN/classNN.xml
#   against schemas/class.xsd
#
# DEPENDENCIES
#   libxml2-tools <http://xmlsoft.org/>

for class in content/part*/class*.xml; do
	xmllint --noout --schema ./schemas/class.xsd "$class"
done
