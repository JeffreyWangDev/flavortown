class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_minimal, only: [ :edit, :update, :destroy ]
  before_action :set_project, only: [ :show ]

  def index
    @projects = current_user.projects.with_attached_banner

    authorize Project
  end

  def show
    authorize @project
    
    # Load project owner (creator) with includes to avoid N+1
    @owner = @project.memberships.includes(:user).where(role: :owner).first&.user
    
    # Calculate metrics efficiently
    @devlogs_count = @project.posts.where(postable_type: "Post::Devlog").count
    ship_event_ids = @project.posts.where(postable_type: "Post::ShipEvent").pluck(:postable_id).map(&:to_i)
    @total_hours = ship_event_ids.any? ? Post::ShipEvent.where(id: ship_event_ids).sum(:hours) || 0.0 : 0.0
    @followers_count = @project.memberships_count
    @ship_certified = @project.posts.where(postable_type: "Post::ShipEvent").exists?
    
    # Format total time as "Xh Ym"
    hours = @total_hours.to_i
    minutes = ((@total_hours - hours) * 60).round
    @total_time_formatted = "#{hours}h #{minutes}m"
    
    # Load timeline posts with all necessary associations to avoid N+1
    @timeline_posts = @project.posts
      .includes(:user)
      .order(created_at: :desc)
      .limit(50)
    
    # Preload postable associations and attachments to avoid N+1
    devlog_posts = @timeline_posts.select { |p| p.postable_type == "Post::Devlog" }
    if devlog_posts.any?
      devlog_ids = devlog_posts.map { |p| p.postable_id.to_i }
      devlogs = Post::Devlog.where(id: devlog_ids).with_attached_attachments.index_by(&:id)
      devlog_posts.each do |post|
        post.association(:postable).target = devlogs[post.postable_id.to_i]
      end
    end
    
    ship_posts = @timeline_posts.select { |p| p.postable_type == "Post::ShipEvent" }
    if ship_posts.any?
      ship_event_ids = ship_posts.map { |p| p.postable_id.to_i }
      ship_events = Post::ShipEvent.where(id: ship_event_ids).index_by(&:id)
      ship_posts.each do |post|
        post.association(:postable).target = ship_events[post.postable_id.to_i]
      end
    end
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    if @project.save
      # Create membership for the current user as owner
      @project.memberships.create!(user: current_user, role: :owner)
      flash[:notice] = "Project created successfully"
      redirect_to @project
    else
      flash[:alert] = "Failed to create project"
      render :new
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project

    if @project.update(project_params)
      flash[:notice] = "Project updated successfully"
      redirect_to @project
    else
      flash[:alert] = "Failed to update project"
      render :edit
    end
  end

  def destroy
    authorize @project
    @project.destroy
    flash[:notice] = "Project deleted successfully"
    redirect_to projects_path
  end

  private

  # These are the same today, but they'll be different tomorrow.

  def set_project
    @project = Project.with_attached_banner.find(params[:id])
  end

  def set_project_minimal
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :demo_url, :repo_url, :readme_url, :banner)
  end
end
