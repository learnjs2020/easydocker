const process = require('process');
var args = process.argv; 

var site = args[2];

var dockerFile = 'angular11';
var dockerFn = __dirname + '/dockerFiles/' + dockerFile;

var site_image = dockerFile + '-image';
var site_container = site + '-container';

var site_path = __dirname + '/apps/sites/' + site;
var site_cfg = __dirname + '/apps/sites/' + site + '/dockerSetting.json';

var cfg = {};

try {
    cfg = require(site_cfg); 
} catch (e) {}

var cmd = '';
cmd += 'echo "Start docker app .."' + "\n";
cmd += 'cd ' + site_path + "\n";
cmd += 'docker build -f ' + dockerFn + ' -t ' + site_image + ' .' + "\n";
cmd += 'docker container stop ' + site_container + "\n";
cmd += 'docker container rm ' + site_container + "\n";

var cmd_ports  = '';
for (var i = 0;  i < cfg.ports.length; i++) {
    cmd_ports += ' -p ' +  cfg.ports[i] + ':' +  cfg.ports[i] + ' '
}

cmd += 'docker run -d ' + cmd_ports + ' -v "'+ site_path + '":/var/_localApp  --name  ' + site_container + ' ' + site_image  + "\n";

fs = require('fs');
fs.writeFile(__dirname + '/_cron/addHost_' + new Date().getTime() + '.sh', cmd, function (err) {
// fs.writeFile('addHost_' + new Date().getTime() + '.sh', cmd, function (err) {
    if (err) return console.log(err);
    console.log('success');
});

// console.log(cfg.ports);
console.log(cmd);
