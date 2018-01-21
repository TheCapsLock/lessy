class Api::Users::ProjectsController < ApiController

  def index
    @projects = current_user
      .projects
      .order(:id)
      .page(params[:page])
  end

  def create
    @project = Project.create!(create_project_params)

    NotificationsChannel.broadcast_to(
      current_user,
      action: 'create#projects',
      id: @project.id,
    )

    render status: :created
  end

private

  def create_project_params
    fetch_resource_params(:project, [:name]).merge(user: current_user)
  end

end
