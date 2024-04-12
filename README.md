# ZeosLib 8.x

## 概要

データベースコンポーネント

カテゴリ: Delphi

## このブランチは何？　update_git_svn

中央集中管理型のsubversionリポジトリの ZeosLib をさくっと gitリポジトリにして定期同期するツールです。

これでリモートがいつ消滅しても安心です？

## マスターリポジトリ

### 自分で用意したほうが簡単に最新にできます。

1. 準備

git svn clone --stdlayout --prefix=svn/ -r8126:HEAD https://svn.code.sf.net/p/zeoslib/code-0 ZeosLib

cd ZeosLib

curl -o update.sh https://raw.githubusercontent.com/okamepowder/ZeosLib/update_git_svn/update.sh

./update.sh

2. 更新

./update.sh


# メモ

 バージョン 8.0.0 以前の8千以上の無駄なログを省略して、r8126 以降の変更を取得します。

## ブランチは強制上書きされるので、直接利用しない。

変更を加える場合はブランチを新規に作る

main, 数値.数値 ブランチは強制上書きされます。

gitでsvnブランチを追うのは困難なので強制上書き方式を採用しています。

## 更新

NASなどのcronを利用して、ローカルサーバーなどのgiteaなどに自動pushすると使いやすくなるかと思います。

Windowsタスクスケジューラーに登録する場合は、sample-task.vbs,sample-update.bat,sample-update.shをコピーして名称変更します。
環境に合わせて内容を修正します。 サンプルは 更新確認 と origin に向けて git pushします

## ブランチ名は簡素化しています

mainブランチ ： svn/trunk

数値.数値 ブランチ : remotes/svn/数値.数値-patches
