# 概要

Elasticsearchにテストデータを流してLogFormatや動作確認をMacのDocker上で行うことを目的としたもの

# 必要なもの

## Docker/Docker Compose

* [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)
* [Docker Compose](https://docs.docker.com/compose/install/#prerequisites)

# ダミーログ生成ツール

makelogsとapache-loggen辺りは入れておいたほうが楽

* [elasitc/makelogs](https://github.com/elastic/makelogs): Elasticsearchに直接データを流し込むことができる
* [apache-loggen](https://inokara.hateblo.jp/entry/2015/06/21/225143): Apache httpdのアクセスログのダミーデータを生成できる。JSON出力も可能
* [jqでJSONをLTSVに変換する@tkuchikiの日記](https://tkuchiki.hatenablog.com/entry/2016/04/01/173354): 実運用のログフォーマットはJSONよりLTSVにすることが多いので、apache-loggenをLTSVにしたいときのメモ
* [elastic/example](https://github.com/elastic/examples): Apache/Nginx/Twitter等のダミーログデータ等とその使い方がLogstashやKibanaのダッシュボードデータとともに掲載されている

# 手順

```shell
# Elastic Stackを起動
$ git clone git@github.com:st1t/my-elastic-stack.git
$ cd my-elastic-stack/
$ docker-compose up

# テストデータ投入
$ makelogs
Generating 14000 events from 2018-12-24T00:00:00Z to 2018-12-26T23:59:59Z
creating index template for "logstash-*"
indexing [================================================================================] 100% 0.0s

created 14000 events in 56 seconds.

$ curl localhost:9200/_cat/indices
green open .kibana_1  EQGH1AsiSMmZiMZRZLHW-g 1 0     4 0 22.5kb 22.5kb
green open logstash-0 BL6WClfsTRqau8ZwJDB9aw 1 0 14005 0 82.3mb 82.3mb
$

# Kibana上からも確認
$ open http://localhost:5601
```

# Elasticsearchのデータを全て削除したい場合

```shell
$ bash reset.sh
$ docker-compose up -d
```

# Tips

## ドキュメントにsourceやtraceという名称が入っているとバッティングするのでimport時に置換しておく

```shell
cat ~/Desktop/app.json | sed -e 's%"source":%"app_source":%g' -e 's%"trace":%"app_trace":%g' >> mount/filebeat/import/app.json
```