"use strict"

angular.module "app", []

    .controller "DefaultController", ($scope, $timeout, $interval) ->
        # define constants
        WIDTH = 40
        HEIGHT = 20

        # define classes
        Snake = (length, positions, direction) ->
            this.length = length
            this.positions = positions
            this.direction = direction
            this.unpaintedLength = 0
            undefined
        Position = (row, col) ->
            this.row = row
            this.col = col
            undefined

        # board
        resetBoard = () ->
            $scope.board = new Array HEIGHT
            for _, row_ndx in $scope.board
                $scope.board[row_ndx] = new Array WIDTH
                for _, col_ndx in $scope.board[row_ndx]
                    setSquare row_ndx, col_ndx, "blue"
            undefined
        setSquare = (row_ndx, col_ndx, color) ->
            board = $scope.board
            board[row_ndx][col_ndx] = getSquare color
            $scope.board = board
            undefined
        getSquare = (color) ->
            return "<div class=\"square-#{color}\"></div>"
        paintBoard = () ->
            board = $scope.board
            board_html = ""
            for _, row_ndx in board
                for _, col_ndx in board[row_ndx]
                    board_html += board[row_ndx][col_ndx]
            $timeout () ->
                $("div#board").html board_html
            undefined

        # snake
        initializeSnake = () ->
            board = $scope.board
            positions = new Array 1
            positions[0] = new Position Math.floor(board.length/2)-1, Math.floor(board[0].length/3)-1
            $scope.snake = new Snake 1, positions, "E"
            colorSnake()
            undefined
        colorSnake = () ->
            snake = $scope.snake
            for position, ndx in snake.positions
                if ndx is 0
                    setSquare position.row, position.col, "black"
                else
                    setSquare position.row, position.col, "white"
            undefined
        isPositionValid = (row, col) ->
            # checks if snake collides into walls
            isValid = row >= 0 and row < $scope.board.length and col >= 0 and col < $scope.board[0].length
            # checks if snake collides into self
            if isValid
                for position in $scope.snake.positions
                    # if snake collides
                    if row is position.row and col is position.col
                        isValid = false
                        break
            return isValid
        isMouseFound = (row, col) ->
            return row == $scope.mouse.row and col == $scope.mouse.col
        move = () ->
            if not $scope.isPaused
                snake = $scope.snake
                row = snake.positions[0].row
                col = snake.positions[0].col

                if snake.direction is "N"
                    row--;
                else if snake.direction is "S"
                    row++;
                else if snake.direction is "W"
                    col--;
                else if snake.direction is "E"
                    col++;

                if not isPositionValid row, col
                    $interval.cancel $scope.promise
                    $scope.isStarted = false
                    displayMessage "YOU LOST :("
                else if isMouseFound row, col
                    $scope.snake.positions.unshift(new Position row, col)
                    $scope.snake.unpaintedLength += 4
                    colorSnake()
                    showMouse()
                    if $scope.isStarted
                        paintBoard()
                else
                    resetBoard()
                    $scope.snake.positions.unshift(new Position row, col)
                    if $scope.snake.unpaintedLength <= 0
                        $scope.snake.positions.pop();
                    else
                        $scope.snake.unpaintedLength--
                    colorSnake()
                    colorMouse()
                    paintBoard()
            else
                displayMessage "PAUSED"
            undefined

        # mouse
        showMouse = () ->
            indices_to_exclude = []
            for position in $scope.snake.positions
                index = position.row*WIDTH + position.col
                indices_to_exclude.push index
            indices = []
            for row in [0...HEIGHT-1]
                for col in [0...WIDTH-1]
                    index = row*WIDTH + col
                    if indices_to_exclude.indexOf(index) is -1
                        indices.push index
            if indices.length is 0
                $interval.cancel $scope.promise
                $scope.isStarted = false
                displayMessage "YOU WON :D"
            else
                index = indices[Math.floor (Math.random()*indices.length)]
                row = Math.floor index/WIDTH
                col = index%WIDTH
                $scope.mouse = new Position(row, col)
                colorMouse()
            undefined
        colorMouse = () ->
            setSquare $scope.mouse.row, $scope.mouse.col, "red"
            undefined

        # keyboard controls
        defineKeyboardControls = () ->
            document.onkeydown = (e) ->
                e = e or window.event
                if $scope.isStarted
                    if not $scope.isPaused
                        # up arrow - up
                        if e.keyCode is 38
                            if $scope.snake.direction isnt "S" || $scope.snake.positions.length is 1
                                $scope.snake.direction = "N"
                        # down arrow - down
                        else if e.keyCode is 40
                            if $scope.snake.direction isnt "N" || $scope.snake.positions.length is 1
                                $scope.snake.direction = "S"
                        # left arrow - left
                        else if e.keyCode is 37
                            if $scope.snake.direction isnt "E" || $scope.snake.positions.length is 1
                                $scope.snake.direction = "W"
                        # right arrow - right
                        else if e.keyCode is 39
                            if $scope.snake.direction isnt "W" || $scope.snake.positions.length is 1
                                $scope.snake.direction = "E"
                    # p - pause
                    if e.keyCode is 80 or e.keyCode is 13
                        $scope.isPaused = not $scope.isPaused
                    # r - reset
                    else if e.keyCode is 82
                        $interval.cancel $scope.promise
                        reset()
                else
                    # enter - start
                    if e.keyCode is 13
                        start()
            undefined

        # game modes
        reset = () ->
            $scope.isStarted = false
            displayMessage "PRESS ENTER TO START"
            undefined
        start = () ->
            $scope.isStarted = true
            $scope.isPaused = false
            $scope.speed = 100
            resetBoard()
            initializeSnake()
            showMouse()
            paintBoard()
            $scope.promise = $interval move, $scope.speed
            undefined

        # message display
        displayMessage = (message) ->
            $("div#board").html "<span style='margin:0;vertical-align:middle;display:inline-block;font-size:36px;'>#{message}</span>"
            undefined

        # initialize
        defineKeyboardControls()
        reset()