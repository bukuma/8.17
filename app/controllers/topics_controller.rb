class TopicsController < ApplicationController
  before_action :authenticate_user!
  
  #2-11
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

      @topicts = Topic.where('title LIKE ?', "%#{@title}%")
      # これは検索処理を行っています。
      # where('title LIKE ?', "%#{@title}%")という部分はSQLクエリを形成していて、
      # titleというフィールドが@titleの文字列を含む全てのTopicオブジェクトを探しています。

    else
      # 検索していない場合は、else以降が実行されます。

      @topics = Topic.all
      # 検索していない場合は、全てのTopicオブジェクトを取得します。
      # これはすべての投稿を表示するためです。

    end

    render :index
  end
  # ここまで
  
  def new
    @topic = Topic.new
    render :new
  end 
  
  def create
    @topic = Topic.new(topic_params)
    
    if params[:topic][:image]
      @topic.image.attach(params[:topic][:image])
    end
    
    if @topic.save
      redirect_to new_topic_path, notice: '登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end 
  
  # 課題２－１２
  def edit
    @topic = Topic.find(params[:id])
    render :edit
  end

  def update
    @topic = Topic.find(params[:id])
    if params[:topic][:image]
      @topic.image.attach(params[:topic][:image])
    end
    if @topic.update(post_params)
      redirect_to index_topic_path, notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  # ここまで
  
  # ２－１２
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to index_topic_path, notice: '削除しました'
  end
  # ここまで
  
  private
  def topic_params
    params.require(:topic).permit(:title, :body, :image)
  end
  
end