### 
# Parse a turtle-like CSON syntax

###
Fs = require 'fs'
CSON = require 'cson'

class TSON

	_convertToCSON: (inText) ->
		outText = ''
		mlComment = null
		mlString = null
		for line in inText.split(/\n/)
			# skip multiline strings and one-line comments
			if not mlString and not mlComment and not /^\s*#/.test(line)
				# Quote the first word if not quoted
				line = line.replace /^(\s*)([^"'\s]+?)(:\s|:?\s*$|\s)/, (match, $pre, $key, $suf) -> "#{$pre}'#{$key}'#{$suf}"
				# Add colons as appropriate
				line = line.replace /^(\s*)(["'][^"']+["'])(\s*$|\s)/, (match, $pre, $key, $suf) -> "#{$pre}#{$key}:#{$suf}"
				# Replace angle bracket delimited URIs
				line = line.replace /(\s)<([^>]+)>/, (match, pre, url) -> "#{pre}'#{url}'"
			else if mlString and line.indexOf(mlString) > -1
				mlString = null
			else if mlComment and line.indexOf(mlComment) > -1
				mlComment = null
			else if not mlString
				# Detect multiline string
				line.replace /('''|""")/, (match) -> mlString = match
			else if not mlComment
				# Detect multi-line comment
				line.replace /###/, (match) -> mlComment = match
			outText += line
			outText += "\n"
		return outText

	parse: -> @parseString.apply(@, arguments)
	parseString: (inText, opts) ->
		return CSON.parseString @_convertToCSON(inText)

	load: -> @loadFile.apply(@, arguments)
	loadFile: (file, opts) ->
		result = Fs.readFileSync(file)
		return result if result  instanceof Error
		return @parseString(result.toString(), opts)

module.exports = new TSON


# ALT: test/test.coffee
