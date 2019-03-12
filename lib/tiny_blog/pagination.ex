defmodule TinyBlog.Pagination do
	import Ecto.Query
	alias TinyBlog.Repo


	def query(query, page, per_page: per_page) when is_binary(page) do
		query(query, String.to_integer(page), per_page: per_page)
	end

	def query(query, page, per_page: per_page) do
		query
		|> limit(^(per_page + 1))	
		|> offset(^(per_page * (page - 1)))
		|> Repo.all()
	end

	def page(query, page, per_page: per_page) when is_binary(page) do
		page(query, String.to_integer(page), per_page: per_page)
	end

	def page(query, page, per_page: per_page) do
		results = query(query, page, per_page: per_page)
		has_next = length(results) > per_page
		has_previous = page > 1
		
		%{
			has_next: has_next,
			has_previous: has_previous,
			prev_page: page - 1,
			page: page,
			next_page: page + 1,
			list: Enum.slice(results, 0, per_page)
		}
	end
end