call grunt
rmdir /s /q "coffeescript-snake"
mkdir "coffeescript-snake"
mkdir "coffeescript-snake/fonts"
mkdir "coffeescript-snake/out"
copy "index.html" "coffeescript-snake/"
copy "out" "coffeescript-snake/out"
copy "fonts" "coffeescript-snake/fonts"
del "coffeescript-snake.zip"
call 7z a coffeescript-snake.zip coffeescript-snake
rmdir /s /q "coffeescript-snake"