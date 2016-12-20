module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON "package.json"

        # lint .coffee
        coffee_jshint:
            options:
                globals: [
                    "angular"
                ]
            your_target: [
                "app/src/**/*.coffee"
            ]

        # compile .coffee to .js
        coffee:
            glob_to_multiple:
                expand: true
                flatten: true
                cwd: "app/src"
                src: ["*.coffee"]
                dest: "out/js"
                ext: ".js"

        # concat .js files
        concat:
            options:
                stripBanners: true
                banner: "/*! <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today('yyyy-mm-dd') %> */"
                separator: ";"
                nonull: true
            dist:
                src: [
                    "node_modules/jquery/dist/jquery.min.js"
                    "node_modules/bootstrap/dist/js/bootstrap.min.js"
                    "node_modules/angular/angular.min.js"
                    "out/js/**/*.js"
                ]
                dest: "out/app.min.js"

        # minify .js
        uglify:
            options:
                sourceMap: false
                mangle: false
            my_target:
                files:
                    "out/app.min.js": ["<%= concat.dist.dest %>"]

        # concat .css files
        concat_css:
            all:
                src: [
                    "node_modules/bootstrap/dist/css/bootstrap.min.css"
                    "node_modules/bootstrap/dist/css/bootstrap-theme.min.css"
                    "app/css/*.css"
                ]
                dest: "out/app.min.css"

        # minify .css
        cssmin:
            target:
                files: [{
                    expand: true
                    cwd: "out"
                    src: ["app.min.css"]
                    dest: "out"
                    ext: ".min.css"
                }]

    # load css tasks
    grunt.loadNpmTasks "grunt-concat-css"
    grunt.loadNpmTasks "grunt-contrib-cssmin"

    # load coffee tasks
    grunt.loadNpmTasks "grunt-coffee-jshint"
    grunt.loadNpmTasks "grunt-contrib-coffee"

    # load js tasks
    grunt.loadNpmTasks "grunt-contrib-concat"
    grunt.loadNpmTasks "grunt-contrib-uglify"

    grunt.registerTask "default", [
        "concat_css",
        "cssmin",
        "coffee_jshint",
        "coffee",
        "concat",
        "uglify"
    ]