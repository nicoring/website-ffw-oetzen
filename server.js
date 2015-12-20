var express = require('express');
var fs = require('fs');
var _ = require('lodash');
YAML = require('yamljs');
jsYaml = require('js-yaml');
var bodyParser = require('body-parser');

const yamlFilesPath = 'src/_data/';

function configFiles() { return fs.readdirSync(yamlFilesPath) };

console.log(configFiles());

function loadYamlString(fileName) {
  if (_.takeRight(fileName, 4).join('') != '.yml') {
    fileName += '.yml';
  }
  return fs.readFileSync(yamlFilesPath + fileName, 'utf8');
}

// var data = _.reduce(configFiles, function(acc, fileName) {
//   acc[fileName] = loadYamlString(fileName);
//   return acc;
// }, {});

var app = express();

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

// app.use(express.static('public'));

// app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }))

function parseParams(params) {
  var type = params.type;
  var id = params.id;
  var idSplitted = id.split('.');
  var fileName = idSplitted[0];
  var index = idSplitted[1];
  idSplitted.splice(0,2);
  return {
    type: type,
    fileName: fileName,
    index: index,
    rest: idSplitted
  }
}

app.get('/edit/:type/:id', function (req, res) {
  var config = parseParams(req.params);
  if (!(config.fileName + '.yml' in configFiles())) {
    res.status(404).send("file does not exist")
    return;
  }
  var yamlContent = jsYaml.safeLoad(loadYamlString(config.fileName));
  res.send(yamlContent[config.index]);
});

app.post('/edit/:type/:id', function (req, res) {
  var config = parseParams(req.params);
  if (!config.fileName + '.yml' in configFiles()) {
    res.status(404).send("file does not exist")
    return;
  }
  var fileName = config.fileName + '.yml';
  // load yaml
  var yamlContent = jsYaml.safeLoad(loadYamlString(fileName));
  // edit yaml
  yamlContent[config.index] = req.body.value;
  // safe yaml
  var yamlString = jsYaml.safeDump(yamlContent);
  // write new yaml
  fs.writeFileSync(yamlFilesPath + fileName, yamlString);

  res.send(req.body.value);
});

var server = app.listen(4001  , function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('YAML server listening at http://%s:%s', host, port);
});
