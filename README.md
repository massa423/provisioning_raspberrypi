## 概要

Kubernetesクラスタを構築することを目的としたAnsible Playbook群。

## 前提

* 必要なRaspberry Piは**5台**を想定。
  * master 1台
  * node 4台
* masterサーバでWiFi接続設定が完了していること (wlan0)。
* masterサーバにGit, Ansibleがインストール済みであること。

## 動作検証済み環境

### 筐体

* Raspberry Pi 3 Model B+
* Raspberry Pi 4 Model B

### OS

* Raspbian GNU/Linux 10 (buster)
* Debian GNU/Linux 11 (bullseye)

## 初期構築

### masterサーバの初期構築

1. eth<N>に固定IP(10.0.0.1)を割り当てる

(例) eth0

```
$ sudo sh -c 'echo "allow-hotplug eth0
iface eth0 inet static
    address 10.0.0.1
    netmask 255.255.255.0
    broadcast 10.0.0.255
    gateway 10.0.0.1" > /etc/network/interfaces.d/eth0'

$ sudo reboot
```

2. Ansible実行

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

1. Ansible実行

初回は各サーバに対してパスワード認証でアクセスする。
SSHパスワードを入力するために`-k`オプションを指定する。
実行ユーザは`pi`を想定。

```
$ cd provisioning_raspberrypi/ansible
$ ansible-playbook -i inventories/hosts kubernetes.yml -k -D
```

2. /boot/cmdline.txtの修正

cgroup関連の設定を追加する。

```
$ sudo vim /boot/cmdline.txt
---
cgroup_memory=1 cgroup_enable=memory
---
```

## 運用

### パッケージアップデートを除外して実行

```
$ ansible-playbook -i inventories/hosts kubernetes.yml --skip-tags update_package -D
```
