#!/usr/bin/bash

script_dir=$(dirname "$0")

# スクリプトが存在するディレクトリに移動し、移動できなかった場合にエラーを出力して終了する
cd "$script_dir" || { echo "Error: Failed to change directory"; exit 1; }

pwd

./update.sh

git branch | grep -oP "[^ ]?(main|\d+\.\d+)$" | xargs git push origin
