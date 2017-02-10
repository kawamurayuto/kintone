require 'kintone/command'

class Kintone::Command::RecordStatus < Kintone::Command

  def self.path
    'record/status'
  end

  def update(app, id, action, assignee: nil, revision: nil)
    body = { app: app, id: id, action: action }
    body[:revision] = revision if revision
    body[:assignee] = assignee if assignee
    @api.put(@url, body)
  end

end
