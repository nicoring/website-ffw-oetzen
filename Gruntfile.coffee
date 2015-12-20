#global module:false

"use strict"

basicAuth = require('basic-auth-connect')

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks "grunt-shell-spawn"
  grunt.loadNpmTasks "grunt-contrib-imagemin"

  grunt.initConfig

    copy:
      bootstrap:
        files: [{
          expand: true
          cwd: "src/bower_components/bootstrap-sass/assets/stylesheets/"
          src: ["**"]
          dest: "src/_sass/vendor"
        },
        {
          expand: true
          cwd: "src/bower_components/bootstrap-sass/assets/javascripts/"
          src: ["bootstrap.js"]
          dest: "src/javascripts/vendor"
        }]
      glyphicons:
        files: [{
          expand: true
          cwd: "src/bower_components/bootstrap-sass/assets/fonts/"
          src: ["**"]
          dest: "src/fonts"
        }]
      animate:
        files: [{
          expand: true
          cwd: "src/bower_components/animate-scss/src"
          src: ["**"]
          dest: "src/_sass/vendor/animate"
        }]
      jquery:
        files: [{
          expand: true
          cwd: "src/bower_components/jquery/dist/"
          src: ["jquery.min.js", "jquery.min.map"]
          dest: "src/javascripts/vendor"
        }]
      miniParallax:
        files: [{
          expand: true
          cwd: "src/bower_components/mini-parallax/"
          src: ["jquery.mini.parallax.js"]
          dest: "src/javascripts/vendor"
        }]
      wow:
        files: [{
          expand: true
          cwd: "src/bower_components/wowjs/dist"
          src: ["wow.min.js"]
          dest: "src/javascripts/vendor"
        }]
      lodash:
        files: [{
          expand: true
          cwd: "src/bower_components/lodash/"
          src: ["lodash.min.js"]
          dest: "src/javascripts/vendor"
        }]

    exec:
      bower:
        cmd: "bower install"
      jekyllProd:
        cmd: "JEKYLL_ENV=production jekyll build --trace"
      jekyllDev:
        cmd: "jekyll build --trace"

    shell:
      edit:
        command: "node server.js"
        options:
          async: true

    watch:
      # options:
      #   livereload: true
      source:
        files: [
          "src/_drafts/**/*"
          "src/_data/**/*"
          "src/_includes/**/*"
          "src/_layouts/**/*"
          "src/_posts/**/*"
          "src/_sass/**/*"
          "src/stylesheets/**/*"
          "src/images/**/*"
          "src/javascripts/**/*"
          "_config.yml"
          "src/**/*.html"
          "src/**/*.md"
        ]
        tasks: [
          "exec:jekyllDev"
        ]

    connect:
      options:
        port: 4000
        base: 'public'
        hostname: '*'
        # livereload: true
      server:
        {}
      authServer:
        options:
          middleware: [
            (req, res, next) ->
              next()
          ]
          # middleware: [ basicAuth('admin', '1234') ]

    imagemin:
      dynamic:
        options:
          optimizationLevel: 7
        files: [{
          expand: true
          cwd: "src/raw_images"
          src: ["**/*.{png,jpg,gif,svg}"]
          dest: "src/images"
        }]



  grunt.registerTask "build:dev", [
    "exec:bower"
    "copy"
    "exec:jekyllDev"
  ]

  grunt.registerTask "build:prod", [
    "exec:bower"
    "copy"
    "exec:jekyllProd"
  ]

  grunt.registerTask "serve", [
    "build:prod"
    "connect:server"
    "watch"
  ]

  grunt.registerTask "edit", [
    "build:dev"
    "connect:authServer"
    "shell:edit"
    "watch"
    "shell:edit:kill"
  ]

  grunt.registerTask "default", [
    "serve"
  ]
