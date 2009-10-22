class CommentsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  def show
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params[:comment])

    if @comment.save      #tries to save
        flash[:notice] = "Comment saved." # ilmoitus käyttäjälle
        redirect_to @post
    else
     flash[:error] = "Whoops" # ilmoitus käyttäjälle
     render :action => "new"
    end
  end
end
