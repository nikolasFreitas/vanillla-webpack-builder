#!/bin/bash

echo "Bem-vindo ao front generator. Aqui vamos criar uma estrutura de dados para um projeto vanilla"
sleep 1
echo "Escolha o nome do projeto"
read projectName
mkdir $projectName && cd $projectName

echo "criando o diretório $projectName..."
baseSource="src"
assetsDirectory="$baseSource/assets"
publicDirectory="$baseSource/public"
jsDirectory="$baseSource/js"
styleDirectory="$baseSource/style"

#git stuff
git init
touch .gitignore
echo "node_modules" >> .gitignore

#Create default directory
mkdir $baseSource
mkdir $assetsDirectory
mkdir $publicDirectory

#Create javascript arquitechture
mkdir $jsDirectory
touch $jsDirectory/index.js
touch $jsDirectory/env.js
mkdir $jsDirectory/service
touch $jsDirectory/service/index.js
mkdir $jsDirectory/helper
mkdir $jsDirectory/component
mkdir $jsDirectory/api

echo "iniciando o npm"
npm init -y
yarn add -D webpack webpack-cli style-loader css-loader
#-----
clear
#Style config
echo "SCSS(1) ou CSS(2), caso nenhum seja definido, o CSS é será default"
select styleChoosed in SCSS CSS
	do
	  case $styleChoosed in
		SCSS )
			echo "Utilizando o SCSS";
			yarn add -D sass-loader sass fibers
			styleSheet="scss";
			styleWebpackConfig="{
				test: /\.s[ac]ss$/i,
        use: [
          // Creates `style` nodes from JS strings
          \"style-loader\",
          // Translates CSS into CommonJS
          \"css-loader\",
          // Compiles Sass to CSS
          {
            loader: \"sass-loader\",
            options: {
              implementation: require(\"sass\"),
              sassOptions: {
                fiber: require(\"fibers\"),
              },
            },
          },
        ],
			}"
		break;;
		CSS ) 
			echo "Utilizando CSS";
			styleSheet="css";
			styleWebpackConfig="{
				test: /\.css$/i,
        use: [
          // Creates `style` nodes from JS strings
          \"style-loader\",
          // Translates CSS into CommonJS
          \"css-loader\",
        ],
			}"
		break;;
		
		* )
			echo "Escolha \"$useLiveServer\" não é válida";
			echo "Utilizando CSS (default)"
			styleSheet="css"
			styleWebpackConfig="{
				test: /\.css$/i,
        use: [
          // Creates `style` nodes from JS strings
          \"style-loader\",
          // Translates CSS into CommonJS
          \"css-loader\",
        ],
			}"
		break;;
	esac
done
sleep 2.5;
mkdir $styleDirectory
touch $styleDirectory/index.$styleSheet

mkdir $assetsDirectory/img
mkdir $assetsDirectory/icons
# ----------

#Webpack config
echo "Criando webpack config"
webpackFile="webpack.config.js"
touch $webpackFile

echo "const path = require('path');

module.exports = {
  entry: './src/js/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
  module: {
    rules: [
      $styleWebpackConfig,
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        type: 'asset/resource',
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/i,
        type: 'asset/resource',
      },
    ],
  },
}" >> $webpackFile
sleep 5

# HTML preapration
touch $publicDirectory/index.html
echo "<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>hello world</h1>
</body>
<script src="../dist/bundle.js"></script>
</html>" >> $publicDirectory/index.html

#Prepare package.json
scriptsLineInPackageJsonBegin=$(grep -n scripts package.json | cut -d : -f 1)
lineToBeDeletedInPackageJson=$(($scriptsLineInPackageJsonBegin + 1))
packageJsonFile="package.json"
newScripts='\\t\t\"build\": \"webpack\"'

#Delete default script
sed -i "$lineToBeDeletedInPackageJson d" $packageJsonFile
#Add new scrips
sed -i "$scriptsLineInPackageJsonBegin a $newScripts" $packageJsonFile

clear
echo "PRONTO! entrar no diretório (cd $projectName) e começar a codar"
echo "Bom hack! :)"
