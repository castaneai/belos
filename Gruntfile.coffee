'use strict'

mountFolder = (connect, dir) ->
  return connect['static'](require('path').resolve(dir))

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  appConfig =
    src: 'src'
    dist: 'dist'
    tmp: '.tmp'

  grunt.initConfig
    config: appConfig

    compass:
      dist:
        options:
          sassDir: '<%= config.src %>/styles'
          cssDir: '<%= config.tmp %>/styles'

    watch:
      compass:
        files: ['<%= config.src %>/styles/{,*/}*.{sass,scss}']
        tasks: ['compass:dist']
      livereload:
        options:
          livereload: true
        files: [
          '<%= config.src %>/{,*/}*.html'
          '{<%= config.tmp %>,<%= config.src %>}/styles/{,*/}*.css'
        ]

    connect:
      options:
        port: 9000
        hostname: 'localhost' # set '0.0.0.0' to public server
      livereload:
        options:
          middleware: (connect) ->
            return [
              require('connect-livereload')()
              mountFolder(connect, appConfig.tmp)
              mountFolder(connect, appConfig.src)
            ]

    open:
      server:
        url: 'http://localhost:<%= connect.options.port %>'

    copy: {}

    htmlmin:
      dist:
        files: [
          expand: true
          cwd: '<%= config.src %>'
          src: ['*.html']
          dest: '<%= config.dist %>'
        ]

    useminPrepare:
      options:
        dest: '<%= config.dist %>'
      html: '<%= config.src %>/index.html'

    usemin:
      options:
        dirs: ['<%= config.dist %>']
      html: ['<%= config.dist %>/{,*/}*.html']
      css: ['<%= config.dist %>/styles/{,*/}*.css']

    cssmin: {}

  grunt.registerTask('server', ['connect:livereload', 'open', 'watch'])
