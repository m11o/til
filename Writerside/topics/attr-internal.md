# attr_internal

クラスを継承した時などに、クラスインスタンス変数やインスタンス変数がバッティングしないようしている
単純に受け取ったattribute名を `@_#{attribute_name}` みたいな感じに変換している