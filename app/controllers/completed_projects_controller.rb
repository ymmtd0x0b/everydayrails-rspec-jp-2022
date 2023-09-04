class CompletedProjectsController < ApplicationController
  before_action :project_owner?, except: %i[ index ]

  def index
    @projects = current_user.projects.where(completed: true)

    render 'projects/completed/index'
  end
end
