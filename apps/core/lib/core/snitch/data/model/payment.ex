defmodule Core.Snitch.Data.Model.Payment do
  @moduledoc """
  Payment API and utilities.

  Payment is a polymorphic entity due to the many different kinds of "sources"
  of a payment. Hence, Payments are not a concrete entity in Snitch, and thus
  can be created or updated only by their concrete subtypes.

  To fetch the (associated) concrete subtype, use the convenience utility,
  `to_subtype/1`

  > For a list of supported payment sources, see
    `Core.Snitch.Data.Schema.Payment.PaymentMethod`
  """
  use Core.Snitch.Data.Model

  @doc """
  Deletes a Payment alongwith the concrete subtype!

  If a `payment` is of type "card", then deleting it will also
  delete the associated entries from "`snitch_card_payments`" table.
  """
  @spec delete(non_neg_integer | Schema.Payment.t()) ::
          {:ok, Schema.Payment.t()} | {:error, Ecto.Changeset.t()}
  def delete(id_or_instance) do
    QH.delete(Schema.Payment, id_or_instance, Repo)
  end

  @spec get(map()) :: Schema.Payment.t() | nil | no_return
  def get(query_fields) do
    QH.get(Schema.Payment, query_fields, Repo)
  end

  @spec get_all() :: [Schema.Payment.t()]
  def get_all, do: Repo.all(Schema.Payment)

  @doc """
  Fetch the (associated) concrete Payment subtype.
  """
  @spec to_subtype(non_neg_integer | Schema.Payment.t()) :: struct()
  def to_subtype(id_or_instance)

  def to_subtype(payment_id) when is_integer(payment_id) do
    payment_id
    |> get()
    |> to_subtype()
  end

  def to_subtype(payment) when is_map(payment) do
    case payment.payment_type do
      "ccd" -> Model.CardPayment.from_payment(payment.id)
      "chk" -> payment
    end
  end
end