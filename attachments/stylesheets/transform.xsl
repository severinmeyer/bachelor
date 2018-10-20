<?xml version="1.0" encoding="UTF-8"?>

<!--
This stylesheet transforms the class definition of a
Content Part into the corresponding catalogue schema.

Templates for the generation of XML Schema constraints
are placed in the dedicated stylesheet constraints.xsl.
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:class="http://dna.fernuni-hagen.de/xmlns/iso16757/class/DEV"
	exclude-result-prefixes="class">

	<xsl:include href="constraints.xsl"/>
	<xsl:output method="xml" indent="yes"/>


	<!-- Root -->

	<xsl:template match="/class:class">
		<xsl:comment>This is an automatically generated catalogue schema for ISO 16757-CONTENTPARTNUMBER</xsl:comment>

		<xs:schema
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns="http://dna.fernuni-hagen.de/xmlns/iso16757/partCONTENTPARTNUMBER/catalog/DEV"
			xmlns:cat="http://dna.fernuni-hagen.de/xmlns/iso16757/partCONTENTPARTNUMBER/catalog/DEV"
			targetNamespace="http://dna.fernuni-hagen.de/xmlns/iso16757/partCONTENTPARTNUMBER/catalog/DEV"
			elementFormDefault="qualified">

			<xs:include schemaLocation="../../schemas/catalog.xsd"/>

			<xsl:comment>Root element</xsl:comment>
			<xs:element name="catalog" type="cat.CatalogType">
				<xsl:call-template name="rootConstraints"/>
			</xs:element>

			<xsl:comment>Metadata standard</xsl:comment>
			<xs:group name="content.MetadataStandardGroup">
				<xs:sequence>
					<xsl:apply-templates select="class:metadata/class:standard" mode="metadata"/>
				</xs:sequence>
			</xs:group>

			<xsl:comment>Selection property names</xsl:comment>
			<xs:simpleType name="content.SelectionPropertyNamesType">
				<xs:restriction base="name.PropertyNameType">
					<xsl:apply-templates select="class:selectionProperties/*" mode="names"/>
				</xs:restriction>
			</xs:simpleType>

			<xsl:comment>Selection values</xsl:comment>
			<xs:group name="content.SelectionValuesGroup">
				<xs:sequence>
					<xsl:apply-templates select="class:selectionProperties/*" mode="selectionValues"/>
				</xs:sequence>
			</xs:group>

			<xsl:comment>Technical property names</xsl:comment>
			<xs:simpleType name="content.TechnicalPropertyNamesType">
				<xs:union>
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xsl:apply-templates select="class:technicalProperties/*" mode="simplePaths"/>
						</xs:restriction>
					</xs:simpleType>
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xsl:apply-templates select="class:technicalProperties/*" mode="multiPaths"/>
						</xs:restriction>
					</xs:simpleType>
				</xs:union>
			</xs:simpleType>

			<xsl:comment>Technical values</xsl:comment>
			<xs:group name="content.TechnicalValuesGroup">
				<xs:sequence>
					<xsl:apply-templates select="class:technicalProperties/*" mode="technicalRoot"/>
				</xs:sequence>
			</xs:group>

			<xsl:comment>Bss property names</xsl:comment>
			<xs:simpleType name="content.BssPropertyNamesType">
				<xs:restriction base="name.PropertyNameType">
					<xsl:apply-templates select="class:bssProperties/*" mode="names"/>
				</xs:restriction>
			</xs:simpleType>

			<xsl:comment>Product index</xsl:comment>
			<xs:group name="content.ProductIndexGroup">
				<xs:sequence>
					<xsl:apply-templates select="class:selectionProperties/*" mode="productIndex"/>
				</xs:sequence>
			</xs:group>

			<xsl:comment>Product properties</xsl:comment>
			<xs:group name="content.ProductPropertiesGroup">
				<xs:sequence>
					<xsl:apply-templates select="class:technicalProperties/*" mode="productProperties"/>
				</xs:sequence>
			</xs:group>
		</xs:schema>
	</xsl:template>


	<!-- Metadata standard -->

	<xsl:template match="*" mode="metadata">
		<xs:element name="part" type="xs:nonNegativeInteger">
			<xsl:attribute name="fixed">
				<xsl:value-of select="class:part"/>
			</xsl:attribute>
		</xs:element>
		<xs:element name="version" type="xs:gYearMonth">
			<xsl:attribute name="fixed">
				<xsl:value-of select="class:version"/>
			</xsl:attribute>
		</xs:element>
	</xsl:template>


	<!-- Names -->

	<xsl:template match="*" mode="names">
		<xs:enumeration value="{@name}"/>
	</xsl:template>


	<!-- Selection values -->

	<xsl:template match="class:open" mode="selectionValues">
		<xs:element name="{@name}" minOccurs="0" maxOccurs="unbounded">
			<xsl:choose>
				<xsl:when test="@type = 'string'">
					<xsl:attribute name="type">cat.StringSelectionValueType</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'decimal'">
					<xsl:attribute name="type">cat.DecimalSelectionValueType</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'integer'">
					<xsl:attribute name="type">cat.IntegerSelectionValueType</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'boolean'">
					<xsl:attribute name="type">cat.BooleanSelectionValueType</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xs:element>
	</xsl:template>

	<xsl:template match="class:ranged|class:enumerated" mode="selectionValues">
		<xs:element name="{@name}" minOccurs="0" maxOccurs="unbounded">
			<xs:complexType>
				<xsl:apply-templates select="class:range|class:enums" mode="selectionValues">
					<xsl:with-param name="type" select="@type"/>
				</xsl:apply-templates>
			</xs:complexType>
		</xs:element>
	</xsl:template>

	<xsl:template match="class:range" mode="selectionValues">
		<xsl:param name="type"/>
		<xs:simpleContent>
			<xs:restriction>
				<xsl:choose>
					<xsl:when test="$type = 'decimal'">
						<xsl:attribute name="base">cat.DecimalSelectionValueType</xsl:attribute>
					</xsl:when>
					<xsl:when test="$type = 'integer'">
						<xsl:attribute name="base">cat.IntegerSelectionValueType</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:apply-templates select="*" mode="rangeBoundaries"/>
			</xs:restriction>
		</xs:simpleContent>
	</xsl:template>

	<xsl:template match="class:enums" mode="selectionValues">
		<xs:complexContent>
			<xs:restriction base="cat.SelectionEnumType">
				<xs:attribute name="enum" use="required">
					<xs:simpleType>
						<xs:restriction base="name.EnumNameType">
							<xsl:apply-templates select="class:enum" mode="names"/>
						</xs:restriction>
					</xs:simpleType>
				</xs:attribute>
			</xs:restriction>
		</xs:complexContent>
	</xsl:template>


	<!-- Range boundaries -->

	<xsl:template match="class:minInclusive" mode="rangeBoundaries">
		<xs:minInclusive value="{@value}"/>
	</xsl:template>

	<xsl:template match="class:minExclusive" mode="rangeBoundaries">
		<xs:minExclusive value="{@value}"/>
	</xsl:template>

	<xsl:template match="class:maxInclusive" mode="rangeBoundaries">
		<xs:maxInclusive value="{@value}"/>
	</xsl:template>

	<xsl:template match="class:maxExclusive" mode="rangeBoundaries">
		<xs:maxExclusive value="{@value}"/>
	</xsl:template>


	<!-- Technical simple paths -->

	<xsl:template match="class:block" mode="simplePaths">
		<xsl:param name="path" select="''"/>
		<xsl:apply-templates select="*[not(self::class:multiValue)]" mode="simplePaths">
			<xsl:with-param name="path" select="concat($path, @name, '/')"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="simplePaths">
		<xsl:param name="path"/>
		<xs:enumeration value="{concat($path, @name)}"/>
	</xsl:template>


	<!-- Technical multi value paths -->

	<xsl:template match="class:block" mode="multiPaths">
		<xsl:param name="path" select="''"/>
		<xsl:param name="constraints" select="''"/>
		<xsl:param name="isMultiValue" select="'false'"/>
		<xsl:apply-templates select="*" mode="multiPaths">
			<xsl:with-param name="path" select="concat($path, @name, $constraints, '/')"/>
			<xsl:with-param name="isMultiValue" select="$isMultiValue"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="class:multiValue" mode="multiPaths">
		<xsl:param name="path"/>
		<xsl:apply-templates select="*" mode="multiPaths">
			<xsl:with-param name="path" select="$path"/>
			<xsl:with-param name="constraints" select="'\[[0-9]+\]'"/>
			<xsl:with-param name="isMultiValue" select="'true'"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="multiPaths">
		<xsl:param name="path" select="''"/>
		<xsl:param name="constraints" select="''"/>
		<xsl:param name="isMultiValue" select="'false'"/>
		<xsl:if test="$isMultiValue = 'true'">
			<xs:pattern value="{concat($path, @name, $constraints)}"/>
		</xsl:if>
	</xsl:template>


	<!-- Technical root -->

	<xsl:template match="class:block" mode="technicalRoot">
		<xs:element name="{@name}" minOccurs="0" maxOccurs="unbounded">
			<xs:complexType>
				<xs:complexContent>
					<xs:extension base="cat.TechnicalRootBlockType">
						<xs:sequence>
							<xsl:apply-templates select="*" mode="technicalValues"/>
						</xs:sequence>
					</xs:extension>
				</xs:complexContent>
			</xs:complexType>
		</xs:element>
	</xsl:template>


	<!-- Technical values -->

	<xsl:template match="class:multiValue" mode="technicalValues">
		<xsl:param name="maxOccurs" select="1"/>
		<xsl:apply-templates select="*" mode="technicalValues">
			<xsl:with-param name="maxOccurs" select="@maxOccurs"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="class:block" mode="technicalValues">
		<xsl:param name="maxOccurs" select="1"/>
		<xs:element name="{@name}" minOccurs="0">
			<xsl:if test="$maxOccurs &gt; 1">
				<xsl:attribute name="maxOccurs">
					<xsl:value-of select="$maxOccurs"/>
				</xsl:attribute>
			</xsl:if>
			<xs:complexType>
				<xs:sequence>
					<xsl:apply-templates select="*" mode="technicalValues"/>
				</xs:sequence>
			</xs:complexType>
		</xs:element>
	</xsl:template>

	<xsl:template match="class:open" mode="technicalValues">
		<xsl:param name="maxOccurs" select="1"/>
		<xs:element name="{@name}" minOccurs="0">
			<xsl:if test="$maxOccurs &gt; 1">
				<xsl:attribute name="maxOccurs">
					<xsl:value-of select="$maxOccurs"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@type = 'string'">
					<xsl:attribute name="type">cat.StringTechnicalValueType</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'decimal'">
					<xsl:attribute name="type">cat.DecimalTechnicalValueType</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'integer'">
					<xsl:attribute name="type">cat.IntegerTechnicalValueType</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'boolean'">
					<xsl:attribute name="type">cat.BooleanTechnicalValueType</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xs:element>
	</xsl:template>

	<xsl:template match="class:ranged" mode="technicalValues">
		<xsl:param name="maxOccurs" select="1"/>
		<xs:element name="{@name}" minOccurs="0">
			<xsl:if test="$maxOccurs &gt; 1">
				<xsl:attribute name="maxOccurs">
					<xsl:value-of select="$maxOccurs"/>
				</xsl:attribute>
			</xsl:if>
			<xs:complexType>
				<xs:simpleContent>
					<xs:restriction>
						<xsl:choose>
							<xsl:when test="@type = 'decimal'">
								<xsl:attribute name="base">cat.DecimalTechnicalValueType</xsl:attribute>
							</xsl:when>
							<xsl:when test="@type = 'integer'">
								<xsl:attribute name="base">cat.IntegerTechnicalValueType</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<xsl:apply-templates select="class:range/*" mode="rangeBoundaries"/>
					</xs:restriction>
				</xs:simpleContent>
			</xs:complexType>
		</xs:element>
	</xsl:template>

	<xsl:template match="class:enumerated" mode="technicalValues">
		<xsl:param name="maxOccurs" select="1"/>
		<xs:element name="{@name}" minOccurs="0">
			<xsl:if test="$maxOccurs &gt; 1">
				<xsl:attribute name="maxOccurs">
					<xsl:value-of select="$maxOccurs"/>
				</xsl:attribute>
			</xsl:if>
			<xs:complexType>
				<xsl:apply-templates select="class:enums" mode="technicalValues"/>
			</xs:complexType>
		</xs:element>
	</xsl:template>

	<xsl:template match="class:enums" mode="technicalValues">
		<xs:attribute name="enum" use="required">
			<xs:simpleType>
				<xs:restriction base="name.EnumNameType">
					<xsl:apply-templates select="class:enum" mode="names"/>
				</xs:restriction>
			</xs:simpleType>
		</xs:attribute>
	</xsl:template>

	<xsl:template match="class:dynamic" mode="technicalValues">
		<xsl:param name="maxOccurs" select="1"/>
		<xs:element name="{@name}" type="cat.DynamicTechnicalValueType" minOccurs="0">
			<xsl:if test="$maxOccurs &gt; 1">
				<xsl:attribute name="maxOccurs">
					<xsl:value-of select="$maxOccurs"/>
				</xsl:attribute>
			</xsl:if>
		</xs:element>
	</xsl:template>


	<!-- Product index -->

	<xsl:template match="class:open|class:ranged" mode="productIndex">
		<xs:element name="{@name}" type="cat.SelectionValueRefType" minOccurs="0"/>
	</xsl:template>

	<xsl:template match="class:enumerated" mode="productIndex">
		<xs:element name="{@name}" type="cat.SelectionEnumRefType" minOccurs="0"/>
	</xsl:template>


	<!-- Product properties -->

	<xsl:template match="*" mode="productProperties">
		<xs:element name="{@name}" type="name.IdRefType"/>
	</xsl:template>

</xsl:stylesheet>
