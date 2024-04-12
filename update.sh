#!/usr/bin/bash

script_dir=$(dirname "$0")

# スクリプトが存在するディレクトリに移動し、移動できなかった場合にエラーを出力して終了する
cd "$script_dir" || { echo "Error: Failed to change directory"; exit 1; }

check_init_branch_names() {
    # 初期化 - ブランチ名、タグ名
    git log -n 1 --pretty=format:"%H" main > /dev/null 2>&1  || git branch -m master main
    git log -n 1 --pretty=format:"%H" 8.0.0 > /dev/null 2>&1 || git tag 8.0.0 svn/tags/8.0.0-stable
    check_update_branch_names
}

check_update_branch_names() {
    # tagsは意味がないので作らない。

    # patches ブランチ作成
    git branch -a | grep -P "^\s*remotes/svn/([89]|\d{2}).\d{1,2}-patches\$" | \
    grep -oP "\d+\.\d+" | sort --version-sort -r | \
    xargs -I {} sh -c "
        # ブランチAの最新のコミットを取得
        commitA=\$(git log -n 1 --pretty=format:\"%H\" remotes/svn/{}-patches 2>&1);
        # ブランチBの最新のコミットを取得
        commitB=\$(git log -n 1 --pretty=format:\"%H\" {} 2>&1);
        # 2つのコミットを比較
        if [ \"\$commitA\" != \"\$commitB\" ]; then
            # コミットが異なる
            git branch -f {} remotes/svn/{}-patches
            # git push origin {}
        fi
    "

    # mainブランチ更新
    # ブランチAの最新のコミットを取得
    commitA=$(git log -n 1 --pretty=format:"%H" remotes/svn/trunk 2>&1);
    # ブランチBの最新のコミットを取得
    commitB=$(git log -n 1 --pretty=format:"%H" main 2>&1);
    # 2つのコミットを比較
    if [ "$commitA" != "$commitB" ]; then
        # コミットが異なる
        git branch -f main remotes/svn/trunk
        # git push origin main
    fi
}


if [[ ! -d ".git" ]] && [[ ! -e "HEAD" ]]; then
    # 現在のディレクトリ名を取得
    dir_name=$(basename "$PWD")

    # ディレクトリ名が ".git" で終わっているかどうかを確認
    if [[ $dir_name != *".git" ]]; then
        echo "Error: Directory name does not end with '.git'"
        exit 1
    fi

    # 初期設定 : non bare : git svn clone --stdlayout --prefix=svn/ -r8126:HEAD https://svn.code.sf.net/p/zeoslib/code-0 ZeosLib
    git init --bare --shared
    git --bare svn init --stdlayout --prefix=svn/ https://svn.code.sf.net/p/zeoslib/code-0
    git --bare svn fetch -r8126:HEAD

    # 最適化
    git fsck --full
    git reflog expire --expire=now --all
    git gc --prune=now

    # 初期化 - ブランチ名、タグ名
    check_init_branch_names
else
    if [[ -d ".git" ]]; then
        git config --local svn-remote.svn.url > /dev/null 2>&1 || { \
            git svn init --stdlayout --prefix=svn/ https://svn.code.sf.net/p/zeoslib/code-0
            git svn fetch -r8126:HEAD
            check_init_branch_names
        }
    fi
fi

git config --local svn-remote.svn.url > /dev/null 2>&1 || { echo "Error: Not git svn repository"; exit 1; }
git config --local svn-remote.svn.fetch > /dev/null 2>&1 || { echo "Error: Not git svn repository"; exit 1; }

if [[ -e "HEAD" ]]; then
    # git config --local core.bare  : true
    output=$(git --bare svn fetch 2>&1)
else
    output=$(git svn fetch 2>&1)
fi

if [[ "no" != "no$output" ]]; then
    echo $output
    check_update_branch_names
else
    # 直接 git svnした場合
    git log -n 1 --pretty=format:"%H" main > /dev/null 2>&1 || check_init_branch_names

    echo "更新はありません"
fi
