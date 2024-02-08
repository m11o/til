# traitについて

共通の振る舞いを定義することができる

```
pub trait Summary {
    fn summarize(&self) -> String;
}

pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
```

## traitで定義されたメソッドはtraitを読み込んだscope内でしか実行できない

```
trait Client {
  fn exec();
}

// 別ファイル(NG)
struct HogeClient {}

client = HogeClient {}
client.exec() // error

// 別ファイル(OK)
struct HogeClient {}

use crate::client::Client

client = HogeClient {}
client.exec() // OK
```

## traitではasync/awaitを使用できない(Supportされていない)

async-trait crateを使用することで実現することができる
ref: https://crates.io/crates/async-trait

## Why async fn in trait is hard?

https://smallcultfollowing.com/babysteps/blog/2019/10/26/async-fn-in-traits-are-hard/

面白そう
後で読む

## traitの実装順番が指定されるのはなぜか

```
Different impl member order from the trait
```

みたいなwarningが出てくる

## AsRef = trait

traitでした
AsRef traitを実装していると、as_refメソッドを使用することができる
