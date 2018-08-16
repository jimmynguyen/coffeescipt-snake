grunt
rm -rf coffeescript-snake
mkdir coffeescript-snake
mkdir coffeescript-snake/fonts
mkdir coffeescript-snake/out
cp index.html coffeescript-snake/
cp ./out/* coffeescript-snake/out/
cp ./fonts/* coffeescript-snake/fonts/
rm -rf coffeescript-snake.zip
7z a coffeescript-snake.zip coffeescript-snake