defimpl Elasticsearch.Document, for: Snitch.Data.Schema.Product do
  def id(product), do: product.id
  def routing(_), do: false
  def encode(product) do
    %{
      title: product.name,
      description: product.description,
    }
  end
end
