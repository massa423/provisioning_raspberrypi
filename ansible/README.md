## 前提

* kubernetesクラスタを構築することを目的としている。
* 必要な raspberry pi は4台を想定。
  * master 1台
  * node 3台
* masterサーバでWiFi接続設定が完了していること (wlan0)。
* masterサーバにansibleがインストール済みであること。

## 動作検証済み環境

* raspberry pi 3B+
* Raspbian GNU/Linux 9 (stretch)

## 構築

### 初期構築

初回は各サーバに対してパスワード認証でアクセスする。
SSHパスワードを入力するために`-k`オプションを指定する。
実行ユーザは`pi`を想定。

```
ansible-playbook -i inventories/hosts kubernetes.yml -k -D
```

### パッケージアップデートを除く

```
ansible-playbook -i inventories/hosts kubernetes.yml --skip-tags update_package -D
```
