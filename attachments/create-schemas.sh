#!/bin/sh -e

# TASK
#   Transform content/partNN/classNN.xml
#   into content/partNN/catalogNN.xsd
#   with stylesheets/transform.xsl
#
# NOTE
#   Each specific catalogue schema uses a dedicated target
#   namespace. However, it is not possible to dynamically
#   create namespace attributes with XSLT [1, Section 7.6.2].
#   As a workaround, the XSLT stylesheet embeds the string
#   CONTENTPARTNUMBER, which is replaced with the part number
#   after a schema is created.
#
#   [1] James Clark: XSL Transformations (XSLT) Version 1.0,
#   W3C Recommendation, 1999, http://www.w3.org/TR/1999/REC-xslt-19991116/
#
# DEPENDENCIES
#   libxslt-tools <http://xmlsoft.org/XSLT.html>

for class in content/part*/class*.xml; do
	part=$(echo "$class" | cut --characters 13-14)
	schema="content/part$part/catalog$part.xsd"

	xsltproc stylesheets/transform.xsl "$class" |\
		sed "s/CONTENTPARTNUMBER/$part/g" > "$schema"
done
