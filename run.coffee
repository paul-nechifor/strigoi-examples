async = require 'async'
fs = require 'fs'
{exec, spawn} = require 'child_process'

parent = __dirname + '/tests'
argv = require('minimist') process.argv.slice(2), string: '_'

main = ->
  async.series [init, processAll], (err) ->
    throw err if err

init = (cb) ->
  sh 'mkdir -p gen tmp 2>/dev/null', cb

processAll = (cb) ->
  fs.readdir parent, (err, dirs) ->
    return cb err if err
    if argv._.length > 0
      dir = dirs
      .filter (d) -> d.indexOf(argv._[0]) is 0
      .sort((a, b) -> a.length - b.length)[0]
      return build dir, cb
    dirs = dirs.sort()
    async.mapSeries dirs, build, (err) ->
      return cb err if err

sh = (script, cb) ->
  exec script, (err, stdout, stderr) ->
    process.stdout.write stdout
    process.stderr.write stderr
    return cb err if err
    cb()

build = (name, cb) ->
  full = parent + '/' + name
  configure = JSON.stringify
    genDir:
      if argv.save or argv.s
        '../../correct/' + name
      else
        '../../gen/' + name
    tmpDir: '../../tmp/' + name
  i = if argv.install or argv.i then '--install' else ''
  sh """
    node_modules/.bin/strigoi #{i} -d '#{full}' --configure '#{configure}'
  """, (err) ->
    return cb err if err
    verify name, cb

verify = (name, cb) ->
  return cb() unless argv.verify or argv.v
  p = spawn 'diff', ['-Nur', 'correct/' + name, 'gen/' + name]
  p.stdout.pipe process.stdout
  p.stderr.pipe process.stderr
  p.on 'close', (code) ->
    return cb 'err-' + code unless code in [0, 1]
    cb()

main()
