async = require 'async'
fs = require 'fs'
{exec} = require 'child_process'

parent = __dirname + '/examples'

main = ->
  sh """
    mkdir -p gen tmp 2>/dev/null
  """, (err) ->
    throw err if err
    fs.readdir parent, (err, dirs) ->
      throw err if err
      dirs = dirs.sort()
      async.mapSeries dirs, build, (err) ->
        throw err if err

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
