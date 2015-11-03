test = require 'tapes'
TSON = require '../src/'
{inspect} = require 'util'

test 'Loading a file', (t) ->
	x = TSON.load 'test/data/test1.tson'
	t.notOk x instanceof Error, 'loaded without error'
	console.log inspect x, {colors:true, depth: 10}
	t.end( )


# ALT: src/index.cofee
