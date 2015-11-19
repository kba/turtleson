#!env node
var TSON = require('../lib')
var util = require('util');
args = process.argv.slice(2);
if (args.length === 0) {
  console.log('Usage: tson [--pretty] /path/to/file.tson');
} else if (args[0] === '--pretty') {
  var obj = TSON.load(args[1]);
  console.log(util.inspect(obj, {
    colors: true,
    depth: 10
  }));
} else {
  var obj = TSON.load(args[0]);
  console.log(JSON.stringify(obj, null, 2));
}
