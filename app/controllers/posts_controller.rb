class PostsController < ApplicationController
  before_action :authenticate_user
  
  def index
    @posts = Post.all.order(created_at: :desc)
  end
  
  def recommend
    @posts = Post.where(recommend: 1).order(created_at: :desc)
  end
  
  def popular
    @posts = Post.all.order(created_at: :desc)
  end
  
  def show
    @post = Post.find_by(id: params[:id])
    # @user = User.find_by(id: @post.user_id)
    @user = @post.user
    @answers_count = Answer.where(post_id: @post.id).count
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(content: params[:content],
                     hint: params[:hint],
                     answer: params[:answer],
                     user_id: @current_user.id,
                     explain: params[:explain],
                     numAnswer: 0)
    @post.save
    @user = User.find_by(id: @current_user.id)
    @user.numMake += 1
    @user.save
    redirect_to("/posts/index")
  end
  
  def hint
    @post = Post.find_by(id: params[:id])
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    @user = User.find_by(id: @current_user.id)
    @user.numMake -= 1
    @user.save
    redirect_to("/posts/index")
  end
  
  def answer
    # @post = Post.find_by(id: params[:id])
    @post = Post.find_by(id: params[:id])
    @answer = Answer.find_by(user_id: @current_user.id, post_id: @post.id)
    @user = User.find_by(id: @current_user.id)
    @post.numAnswer += 1
    @post.save
    @user.numAnswer += 1
    @remark = @answer.remark
    if @remark == @post.answer
      @yes = 1
      @user.point += 1
    else
      @yes = 0
    end
    @user.save
  end
end
