class PostsController < ApplicationController
  before_action :authenticate_user!

  # このActionを編集してください
  def index
    @title = params[:title]
    # ここで、params[:title]とはURLから送られてくるパラメータ（データ）の中から
    # タイトルに関する情報を取得しています。
    # 例えば、サイトのURLがhttp://xxxx.com/?title=myTitleだとすれば、
    # params[:title]はmyTitleという文字列を返します。
    # この情報は@titleというインスタンス変数に保存され、その後の処理で利用されます。

    if @title.present?
      # ここでは@titleが存在するかどうかをチェックしています。
      # つまり、ユーザーが何かタイトルを検索している場合はこの処理が実行されます。

      @posts = Post.where('title LIKE ?', "%#{@title}%")
      # これは検索処理を行っています。
      # where('title LIKE ?', "%#{@title}%")という部分はSQLクエリを形成していて、
      # titleというフィールドが@titleの文字列を含む全てのPostオブジェクトを探しています。

    else
      # 検索していない場合は、else以降が実行されます。

      @posts = Post.all
      # 検索していない場合は、全てのPostオブジェクトを取得します。
      # これはすべての投稿を表示するためです。

    end

    render :index
  end
  # ここまで
  
  # ここから
  def new
    # new.html.erbでは@postの変数を使用するので、インスタンスを生成しておきます。
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    # まず最初に、新しいPostオブジェクトを作成します。
    # その際にpost_paramsメソッドを通じて受け取ったパラメータ（タイトル、本文、画像など）を使って初期化します。
    # ここで、post_paramsはユーザーから送られてきたデータのうち、安全に使用できるデータをフィルタリングする役割を果たします。

    if params[:post][:image]
    # ユーザーが画像を送信してきた場合に対応します。
    # この条件分岐は、送信データ（params[:post][:image]）に画像が含まれているかどうかを確認します。
     
      @post.image.attach(params[:post][:image])
      # 画像が送信されてきた場合、その画像を@postオブジェクトにアタッチ（添付）します。
    end

    if @post.save
       # ここで、@postオブジェクトをデータベースに保存します。
      # 保存が成功すればtrueを返し、何らかの問題で保存できなければfalseを返します。
     
      redirect_to index_post_path, notice: '登録しました'
      #  保存が成功した場合、ユーザーを投稿一覧ページ（"/"）にリダイレクトさせます。
      # その際、「登録しました」という通知メッセージを表示します。
      
    else
      # 登録に失敗した場合に処理されます。
      
      render :new, status: :unprocessable_entity
      # 保存が失敗した場合、再度新規投稿フォーム（:newビュー）を表示します。
      # その際、HTTPステータスコードとして422（Unprocessable Entity）を返します。
      # これは、リクエストは理解されたが、バリデーションエラーや他の理由で処理できなかったことを意味します。
      
    end
  end
  
   # ここから追記
  def edit
  # editメソッドは、ユーザーがデータを編集するためのページを表示するためのものです。
  # ここでは、特定の投稿を編集するための画面を表示します。

    @post = Post.find(params[:id])
    # URLから取得したidパラメータを使用して、データベースから対象の投稿を取得します。
    # 取得した投稿はインスタンス変数@postに保存されます。
    # インスタンス変数に保存することで、その変数はビュー内でも利用可能になります。

    render :edit
  end

  def update
  # updateメソッドは、実際にデータベースの情報を更新するためのものです。

    @post = Post.find(params[:id])
    # URLから取得したidパラメータを使用して、データベースから対象の投稿を取得します。

    if params[:post][:image]
    # 送信されたパラメータに画像が含まれているかどうかをチェックします。

      @post.image.attach(params[:post][:image])
      # もし含まれていれば、その画像を投稿に紐づけます。

    end

    if @post.update(post_params)
    # post_paramsというメソッドで送信データを適切にフィルターし（不正なデータの更新を防ぐため）、
    # そのデータを使って投稿を更新します。
    # 更新に成功したら、trueを返します。

      redirect_to index_post_path, notice: '更新しました'
      # 更新に成功した場合は'更新しました'で投稿一覧ページにリダイレクトします。

    else
    # 更新に失敗した場合（例えば、バリデーションに失敗するなど）

      render :edit, status: :unprocessable_entity
      # 失敗した場合は、編集画面を再度表示します。
      # この時、エラーメッセージとともにフォームが表示され、ユーザーにどの部分が間違っているかを知らせます。
    end
  end
  # ここまで
  
  
  
    # ここから追加
  def destroy
  # データベースのレコードを削除するために使用されます。
  # ここでは、投稿（Post）のレコードを削除するために使っています。

    @post = Post.find(params[:id])
    # URLから投稿のID（params[:id]）を取得して、それに対応する投稿をデータベースから探します。
    # そして、その投稿のデータをインスタンス変数@postに代入します。

    @post.destroy
    # @postオブジェクト（つまりデータベースの一つの投稿レコード）を削除します。
    # この操作はデータベースからそのレコードを完全に取り除きます。

    redirect_to index_post_path, notice: '削除しました'
    # 投稿が削除されたら、ユーザーを投稿の一覧画面（index）にリダイレクトします。
    # 同時に、'削除しました'という通知メッセージも表示します。

  end
  # ここまで
  
  private
  # post_paramsメソッドは、RailsのStrong Parametersと呼ばれる機能を用いたものです。
  # このメソッドは、ユーザーから送られてきたパラメータ（データ）から安全に使用可能なものだけを
  # 抽出・フィルタリングする役割を果たします。
  # Strong Parametersは、安全性のために重要な機能で、
  # 想定外のパラメータによる不正なデータ操作（マスアサインメント脆弱性）を防ぐ役割があります。
  def post_params
    
    params.require(:post).permit(:title, :body, :image)
    # params.require(:post)の説明
    # paramsは送られてきたパラメータ（データ）全体を保持するハッシュのようなオブジェクトです。
    # require(:post)は、その中から:postキーを持つデータを取り出します。
    # :postキーが存在しない場合、例外（エラー）が発生します。

    # permit(:title, :body, :image)の説明
    # permitメソッドは、:postキーの中からさらに指定したキー（この場合、:title、:body、:image）のみを抽出します。
    # これにより、これら以外のパラメータが送られてきてもそれらは無視され、データベースに影響を与えることはありません。
  end
  # ここまで
  
  
end
