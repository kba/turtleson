TSON
====
A  Concise, permissive, TURTLE-like dialect of JSON

Synopsis
--------

JSON can become quite noisey with all those braces and quotes:

```js
{
    "http://example.org/johnDoe": {
        "foaf:name": "John Doe",
        "type": "String"
    }
}
```

What if you could omit the braces and trailing commas and some quotes? You'd get [CSON](https://github.com/bevry/cson):

```coffee
"http://example.org/johnDoe":
    "foaf:name": "John Doe"
    type: "String"
```

What if you could omit the quotes around strings that contain only
alphanumerics, colon and URI-safe characters?

And omit the colon separating key and value?

And replace quotes with brackets?

You get Turtleson or TSON for short, which is to JSON what Turtle is to
RDF/XML: Easy to write and easy to read:

```turtle
<http://example.org/johnDoe>
    foaf:name "John Doe"
    type "String"
```

How does it work
----------------

All the hard work is done by [CSON](https://github.com/bevry/cson). This module merely
replaces one form of quotation mark for another and surrounds strings
with quotation marks depending on the context. The result is run through
CSON and returned as a JSON data structure.

Installation
------------

As a dependency:

```
npm install --save tson
```

Globally (to use the `tson` CLI tool

```
npm install --global tson
```

API
---

The API is synchronous.

```js
var TSON = require('tson');
```

From a file:

```js
var fromFile1 = TSON.load("./fileName.tson");
var fromFile2 = TSON.loadFile ("./fileName.tson");
```

From a string:

```js
var example = '<http://example.org/johnDoe>' + "\n" +
    "\t" + 'foaf:name "John Doe"' + "\n" +
    "\t" + 'type "String"' + "\n";
var fromString1 = TSON.parse(example);
var fromString2 = TSON.parseString(example);
```

Examples
--------

* The [InFoLiS](http://infolis.github.io) data model
  [is implemented in TSON](https://github.com/infolis/infolis-web/tree/master/data/infolis.tson)
* Syntax-highlighting of TSON files in NodeJS is possible with
  [node-vim2html](https://github.com/kba/node-vim2html). See a 
  [live example](http://infolis.gesis.org/api/tson) of how this 
  looks like.
