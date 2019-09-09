class AnswerController < ApplicationController
  before_action :authenticate_user
  
  def create
    @answer = Answer.new(
                     user_id: @current_user.id,
                     post_id: params[:id],
                     remark: params[:remark]
                     )
    @answer.save
    @post = Post.find_by(id: @answer.post_id)
    # if @answer.remark == @post.answer
    #   @yes = 1
    # else
    #   @yes = 0
    # end
    redirect_to("/posts/#{@post.id}/answer")
  end
end
