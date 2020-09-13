## 概要

Kubernetesクラスタを構築することを目的としたAnsible Playbook群。

## 前提

* 必要なRaspberry Piは**4台**を想定。
  * master 1台
  * node 3台
* masterサーバでWiFi接続設定が完了していること (wlan0)。
* masterサーバにGit, Ansibleがインストール済みであること。

## 動作検証済み環境

### 筐体

* Raspberry Pi 3 Model B+
* Raspberry Pi 4 Model B

### OS

* Raspbian GNU/Linux 9 (stretch)
* Debian GNU/Linux 10 (buster)

## 構築

### masterサーバの初期構築

実行ユーザは`pi`を想定。
localhostに対する実行時、`ansible_connection`が`local`では
`python3-apt`インストール有無に関わらず未インストールエラーが発生する。
ssh経由で接続を行えば発生しないため、パスワード認証用に`sshpass`を
インストールする。

```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "python3-apt must be installed to use check mode. If run normally this module can auto-install it."}
```

また、`python3-apt`はAnsibleの`apt`モジュールの必須要件のため
あわせてインストールする。

```
$ sudo apt-get install python3-apt sshpass

$ git clone https://github.com/massa423/provisioning_raspberrypi.git

$ cd provisioning_raspberrypi/ansible
$ ansible-playbook -i inventories/hosts localhost.yml -k -D
```

この時点でmasterサーバにdhcpdがインストールされ、各nodeサーバに
`10.0.0.0/24`のレンジからIPアドレスが割り振られる。
それに応じて適宜`inventories/hosts`のIPアドレスを修正する。

### Kubernetesクラスタサーバの構築

初回は各サーバに対してパスワード認証でアクセスする。
SSHパスワードを入力するために`-k`オプションを指定する。
実行ユーザは`pi`を想定。

```
$ cd provisioning_raspberrypi/ansible
$ ansible-playbook -i inventories/hosts kubernetes.yml -k -D
```

### パッケージアップデートを除外して実行

```
$ ansible-playbook -i inventories/hosts kubernetes.yml --skip-tags update_package -D
```
