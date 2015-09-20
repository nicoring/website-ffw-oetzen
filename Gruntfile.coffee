#global module:false

"use strict"

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-exec"

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
      jekyll:
        cmd: "jekyll build --trace"

    watch:
      options:
        livereload: true
      source:
        files: [
          "src/_drafts/**/*"
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
          "exec:jekyll"
        ]

    connect:
      server:
        options:
          port: 4000
          base: 'public'
          livereload: true

  grunt.registerTask "build", [
    "exec:bower"
    "copy"
    "exec:jekyll"
  ]

  grunt.registerTask "serve", [
    "build"
    "connect:server"
    "watch"
  ]

  grunt.registerTask "default", [
    "serve"
  ]
