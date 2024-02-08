# build.rs

build.rsはビルド時に実行されるスクリプトで、Cargo.tomlに以下のように記述することで、ビルド時に実行される
ルートディレクトリに追加する

```toml
[package]
...
build = "build.rs"
```
