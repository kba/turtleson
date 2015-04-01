### 
# Parse a turtle-like CSON syntax

###
Fs = require 'fs'
CSON = require 'cson'
Vim2HTML = require 'vim2html'

class TSON
	_quoteValueIfNecessary: (s) ->
		# Change <> to ''
		s = s.replace /^<(.*)>$/, (match, uri) -> "'#{uri}'"
		# unless it is already quoted
		return s if /^["'].*["']$/.test(s)
		# unless it is a number
		return s if /^[\d\.]+$/.test(s)
		# unless it is a boolean
		return s if /^(true|false|yes|no|on|off)$/.test(s)
		# unless it is null
		# return s if /^null$/.test(s)
		# unless it is an array/object opener
		return s if /[\[\{]\s*$/.test(s)
		# It's a string, quote it
		return "'#{s}'"

	_convertLine: (line) ->
		self = @
		line = line.replace /\s*$/, ''
		line.replace ///
		^
		(\s*)			# indent
		([^\s]+[^:\s]) 	# key
		\s*				# optional space
		(:?\s*)?		# delim
		([^\s].*)?		# value
		\s*				# outdent - discard
		$
		///, (match, indent, key, delim, val) ->
			hit = true
			# If the key is a three-letter delim, return immediately
			if /['"#]{3}/.test(key)
				return line
			# If the key is a closing delim, return immediately
			if /[\}\]]/.test(key)
				return line
			# console.log "#{key}: #{line}"
			ret = indent
			# Quote the key, if not quoted
			key = key.replace /^[^"']+$/, (s) -> "'#{s}'"
			ret += key
			ret += ": "
			if (val)
				val = self._quoteValueIfNecessary(val)
				ret += val
			return ret


	_convertToCSON: (inText) ->
		self = @
		outText = ''
		mlComment = null
		mlString = null
		mlArray = null
		for line in inText.split(/\n/)
			# skip multiline strings and one-line comments
			if not (mlString or mlArray or mlComment or /^\s*##?[^#]/.test(line) or /[\[\]\{\}]/.test(line))
				hit = false
				line = self._convertLine(line)

			# Detect multiline string
			if mlString and line.indexOf(mlString) > -1
				mlString = null
			else if not mlString
				line.replace /('''|""")/, (match) -> mlString = match

			if mlArray
				if /\]\s*$/.test(line)
					mlArray = null
				else
					line = line.replace /^(\s*)([^\s].*)\s*/, (match, indent, val) ->
						val = self._quoteValueIfNecessary(val)
						return "#{indent}#{val}"
			else if not mlArray
				line.replace /\[\s*$/, (match) -> mlArray = true

			if mlComment and line.indexOf(mlComment) > -1
				mlComment = null
			else if not mlComment
				# Detect multi-line comment
				line.replace /###/, (match) -> mlComment = match

			outText += line
			outText += "\n"
		# console.log outText
		# Vim2HTML.highlightString outText, '/tmp/mep', {syntax:'coffee', tabstop: 2}, () ->
		return outText

	parse: -> @parseString.apply(@, arguments)
	parseString: (inText, opts) ->
		return CSON.parseString @_convertToCSON(inText)

	load: -> @loadFile.apply(@, arguments)
	loadFile: (file, opts) ->
		inputString = Fs.readFileSync(file)
		return inputString if inputString instanceof Error
		# console.log inputString.toString()
		outputString = @parseString(inputString.toString(), opts)
		return outputString

module.exports = new TSON


# ALT: test/test.coffee
