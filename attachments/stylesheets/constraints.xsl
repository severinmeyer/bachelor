<?xml version="1.0" encoding="UTF-8"?>

<!--
This stylesheet is included in transform.xsl to
generate XML Schema constraints for catalogue schemas.
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:class="http://dna.fernuni-hagen.de/xmlns/iso16757/class/DEV"
	exclude-result-prefixes="class">


	<!-- Root element constraints -->

	<xsl:template name="rootConstraints">
		<xsl:comment>===================</xsl:comment>
		<xsl:comment>Generic constraints</xsl:comment>
		<xsl:comment>===================</xsl:comment>
		<xsl:call-template name="genericConstraints"/>

		<xsl:comment>=========================</xsl:comment>
		<xsl:comment>Product index constraints</xsl:comment>
		<xsl:comment>=========================</xsl:comment>
		<xsl:apply-templates select="class:selectionProperties/*" mode="indexConstraints"/>

		<xsl:comment>============================</xsl:comment>
		<xsl:comment>Product property constraints</xsl:comment>
		<xsl:comment>============================</xsl:comment>
		<xsl:apply-templates select="class:technicalProperties/class:block" mode="productConstraints"/>

		<xsl:comment>==================</xsl:comment>
		<xsl:comment>End of constraints</xsl:comment>
		<xsl:comment>==================</xsl:comment>
	</xsl:template>


	<!-- Generic constraints -->

	<xsl:template name="genericConstraints">
		<xsl:comment>Dictionaries</xsl:comment>
		<xs:key name="DictionaryKey">
			<xs:selector xpath=".//cat:dictionaries/cat:dictionary"/>
			<xs:field xpath="@name"/>
		</xs:key>
		<xs:keyref name="DictionaryKeyRef" refer="DictionaryKey">
			<xs:selector xpath=".//*"/>
			<xs:field xpath="@dictionary"/>
		</xs:keyref>

		<xsl:comment>Custom selection properties</xsl:comment>
		<xs:key name="CustomPropertyKey">
			<xs:selector xpath=".//cat:customSelectionProperties/*"/>
			<xs:field xpath="@name"/>
		</xs:key>
		<xs:keyref name="CustomPropertyKeyRef" refer="CustomPropertyKey">
			<xs:selector xpath=".//cat:customSelectionValues/*"/>
			<xs:field xpath="@name"/>
		</xs:keyref>

		<xsl:comment>Custom selection enums</xsl:comment>
		<xsl:comment>NOTE: It is not possible with XML Schema 1.0</xsl:comment>
		<xsl:comment>to validate that custom enumerated selection</xsl:comment>
		<xsl:comment>values refer to enums of the correct property.</xsl:comment>

		<xsl:comment>Articles</xsl:comment>
		<xs:key name="ArticleKey">
			<xs:selector xpath=".//cat:articleElements/cat:article"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="ArticleKeyRef" refer="ArticleKey">
			<xs:selector xpath=".//cat:product/cat:article | .//cat:accessory/cat:article"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Descriptions</xsl:comment>
		<xs:key name="DescriptionKey">
			<xs:selector xpath=".//cat:descriptionElements/cat:description"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="DescriptionKeyRef" refer="DescriptionKey">
			<xs:selector xpath=".//cat:product/cat:description | .//cat:accessory/cat:description"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Media</xsl:comment>
		<xs:key name="MediaKey">
			<xs:selector xpath=".//cat:mediaElements/cat:media"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="MediaAttributeKeyRef" refer="MediaKey">
			<xs:selector xpath=".//*"/>
			<xs:field xpath="@media"/>
		</xs:keyref>
		<xs:keyref name="MediaElementKeyRef" refer="MediaKey">
			<xs:selector xpath=".//cat:media"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Conformance</xsl:comment>
		<xs:key name="ConformanceKey">
			<xs:selector xpath=".//cat:conformanceElements/cat:conformance"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="ConformanceKeyRef" refer="ConformanceKey">
			<xs:selector xpath=".//cat:product/cat:conformance | .//cat:accessory/cat:conformance"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Accessory groups</xsl:comment>
		<xs:key name="AccessoryGroupKey">
			<xs:selector xpath=".//cat:accessoryElements/cat:accessoryGroups/cat:group"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="AccessoryGroupKeyRef" refer="AccessoryGroupKey">
			<xs:selector xpath=".//cat:accessoryElements/cat:accessoryGroups/cat:group/cat:group"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>
		<xs:keyref name="AccessoryRootGroupKeyRef" refer="AccessoryGroupKey">
			<xs:selector xpath=".//cat:product/cat:accessories"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Accessory products</xsl:comment>
		<xs:key name="AccessoryProductKey">
			<xs:selector xpath=".//cat:accessoryElements/cat:accessoryProducts/cat:accessory"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="AccessoryProductKeyRef" refer="AccessoryProductKey">
			<xs:selector xpath=".//cat:accessoryElements/cat:accessoryGroups/cat:group/cat:accessory"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Accessory product conditions</xsl:comment>
		<xs:keyref name="CustomPropertyElementKeyRef" refer="CustomPropertyKey">
			<xs:selector xpath=".//cat:custom"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>

		<xsl:comment>Unique custom property references in index</xsl:comment>
		<xs:unique name="UniqueCustomPropertyNameRef">
			<xs:selector xpath=".//cat:product/cat:index/*"/>
			<xs:field xpath="@name"/>
		</xs:unique>

		<xsl:comment>Custom values in index</xsl:comment>
		<xs:key name="CustomOpenValueKey">
			<xs:selector xpath=".//cat:customSelectionValues/cat:open"/>
			<xs:field xpath="@name"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="CustomOpenValueKeyRef" refer="CustomOpenValueKey">
			<xs:selector xpath=".//cat:product/cat:index/cat:open"/>
			<xs:field xpath="@name"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>
		<xs:key name="CustomRangedValueKey">
			<xs:selector xpath=".//cat:customSelectionValues/cat:ranged"/>
			<xs:field xpath="@name"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="CustomRangedValueKeyRef" refer="CustomRangedValueKey">
			<xs:selector xpath=".//cat:product/cat:index/cat:ranged"/>
			<xs:field xpath="@name"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>
		<xs:key name="CustomEnumeratedValueKey">
			<xs:selector xpath=".//cat:customSelectionValues/cat:enumerated"/>
			<xs:field xpath="@name"/>
			<xs:field xpath="@enum"/>
		</xs:key>
		<xs:keyref name="CustomEnumeratedValueKeyRef" refer="CustomEnumeratedValueKey">
			<xs:selector xpath=".//cat:product/cat:index/cat:enumerated"/>
			<xs:field xpath="@name"/>
			<xs:field xpath="@enum"/>
		</xs:keyref>
	</xsl:template>


	<!-- Product index constraints -->

	<xsl:template match="class:open|class:ranged" mode="indexConstraints">
		<xsl:comment><xsl:value-of select="@name"/></xsl:comment>
		<xs:key name="{@name}ValueKey">
			<xs:selector xpath=".//cat:selectionValues/cat:{@name}"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="{@name}ValueKeyRef" refer="{@name}ValueKey">
			<xs:selector xpath=".//cat:product/cat:index/cat:{@name}"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>
	</xsl:template>

	<xsl:template match="class:enumerated" mode="indexConstraints">
		<xsl:comment><xsl:value-of select="@name"/></xsl:comment>
		<xs:key name="{@name}EnumKey">
			<xs:selector xpath=".//cat:selectionValues/cat:{@name}"/>
			<xs:field xpath="@enum"/>
		</xs:key>
		<xs:keyref name="{@name}EnumKeyRef" refer="{@name}EnumKey">
			<xs:selector xpath=".//cat:product/cat:index/cat:{@name}"/>
			<xs:field xpath="@enum"/>
		</xs:keyref>
	</xsl:template>


	<!-- Product property constraints -->

	<xsl:template match="class:block" mode="productConstraints">
		<xsl:comment><xsl:value-of select="@name"/></xsl:comment>
		<xs:key name="{@name}BlockKey">
			<xs:selector xpath=".//cat:technicalValues/cat:{@name}"/>
			<xs:field xpath="@id"/>
		</xs:key>
		<xs:keyref name="{@name}BlockKeyRef" refer="{@name}BlockKey">
			<xs:selector xpath=".//cat:product/cat:{@name}"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>
	</xsl:template>

</xsl:stylesheet>
