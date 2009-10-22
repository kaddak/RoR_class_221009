class PostsController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  
  # GET /posts
  # GET /posts.xml
  # use allways these method names
  def index
    if session[:user_id].nil? # if not logged in
      @posts = Post.all_published # moved code from here to models
    else # if logged in
      @posts = Post.all.reverse
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments

    respond_to do |format|
      if session[:user_id].nil? && !@post.published? # if not logged in and post not published, but user types url ?- convention to use if returns a boolean
        format.html { redirect_to :root } #if we're inside respond_to block -use format.html {}= do...end
        #raise ActiveRecord::RecordNotFound ///= proper way to do the redirection -> so that search engines know what to do
        # the page that is raised is the page in public 404.html
        # shows it in the production environment
      else
        format.html # show.html.erb
        format.xml  { render :xml => @post }
      end
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @user = User.find(session[:user_id])
    @post = @user.posts.new(params[:post])


    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
