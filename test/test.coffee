test = require 'tapes'
TSON = require '../src/'

test 'Loading a file', (t) ->
	x = TSON.load 'test/data/test1.tson'
	t.notOk x instanceof Error, 'loaded without error'
	t.end( )


# ALT: src/index.cofee
