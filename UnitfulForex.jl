module ForexUnits
using HTTP, JSON
using Unitful

function request(url)
    try
        response = HTTP.get(url)
        return String(response.body)
    catch e
        return "E: $e"
    end
end

@dimension ¤ "¤" Currency
@refunit EUR "EUR" Euro ¤ true

rates = (JSON.parse ∘ request)("https://api.exchangeratesapi.io/latest")["rates"]

for rate ∈ rates
    curr = :(@unit $(rate[1]) $(rate[1]) $(rate[1]) (1/$(rate[2]))*EUR false)
    eval(curr)
end

end

using Unitful

Unitful.register(ForexUnits)
