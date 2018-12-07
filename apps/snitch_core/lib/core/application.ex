defmodule Snitch.Application do
  @moduledoc """
  The Snitch Application Service.

  The Snitch system business domain lives in this application.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, pid} =
      Supervisor.start_link(
        [
          supervisor(Snitch.Repo, []),
          Snitch.Tools.ElasticsearchCluster,
          worker(
            Elasticsearch.Executable,
            [
              "Elasticsearch",
              # assuming elasticsearch is in your vendor/ dir
              "vendor/elasticsearch/bin/elasticsearch",
              9200
            ],
            id: :elasticsearch
          ),
          worker(
            Elasticsearch.Executable,
            [
              "Kibana",
              # assuming kibana is in your vendor/ dir
              "vendor/kibana/bin/kibana",
              5601
            ],
            id: :kibana
          )
        ],
        strategy: :one_for_one,
        name: Snitch.Supervisor
      )

    {:ok, pid}
  end
end
