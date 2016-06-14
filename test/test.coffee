test = require 'tapes'
TSON = require '../src/'
{inspect} = require 'util'

dump = (x) -> inspect x, {colors:true, depth: 10}

test 'Loading a file', (t) ->
	x = TSON.load 'test/data/test1.tson'
	t.notOk x instanceof Error, 'loaded without error'
	console.log dump x
	t.end( )

test 'Loading a list of objects', (t) ->
	x = TSON.loadCSON 'test/data/list-of-obj.tson'
	t.notOk x instanceof Error, 'loaded without error'
	# console.log inspect x, {colors:true, depth: 10}
	console.log dump x
	console.log dump TSON.load 'test/data/list-of-obj.tson'
	t.end( )

# ALT: src/index.cofee
