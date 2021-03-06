#*******************************************************************************
# issue_mail_with_attachments Redmine plugin.
#
# Authors:
# - https://github.com/team888
#
# Terms of use:
# - GNU GENERAL PUBLIC LICENSE Version 2
#*******************************************************************************
default_settings = {
    :enable_mail_attachments => true,
    :attach_all_to_notification => false,
    :mail_subject => '[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] (#{issue.status.name}) #{issue.subject}',
    :mail_subject_wo_status => '[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.subject}',
    :mail_subject_4_attachment => '[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] |att| '
}
default_settings = ActionController::Parameters.new(default_settings)

Redmine::Plugin.register :issue_mail_with_attachments do
  name 'Issue Mail With Attachments plugin'
  author 'team888'
  description 'Send issue notification mail with file attachments'
  version '0.0.1'
  url 'https://github.com/team888/redmine-issue_mail_with_attachments-plugin'
  author_url 'https://github.com/team888'

  settings :default => default_settings, :partial => 'settings/issue_mail_with_attachments_settings'
end

require "issue_mail_with_attachments/mailer_patch.rb"

Rails.configuration.to_prepare do
  require_dependency 'mailer'
  # load patch module
  unless Mailer.included_modules.include? IssueMailWithAttachments::MailerPatch
    Mailer.send(:include, IssueMailWithAttachments::MailerPatch)
  end
end