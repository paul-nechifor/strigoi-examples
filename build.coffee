async = require 'async'
fs = require 'fs'
{exec} = require 'child_process'

parent = __dirname + '/examples'

main = ->
  async.series [init, processAll], (err) ->
    throw err if err

init = (cb) ->
  sh 'mkdir -p gen tmp 2>/dev/null', cb

processAll = (cb) ->
  fs.readdir parent, (err, dirs) ->
    return cb err if err
    if process.argv.length > 2
      name = process.argv[2]
      dir = dirs
      .filter (d) -> d.indexOf(name) is 0
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
    genDir: '../../gen/' + name
    tmpDir: '../../tmp/' + name

  sh """
    node_modules/.bin/strigoi -d '#{full}' --configure '#{configure}'
  """, cb

main()
