import Pkg
function build_deps()
    Pkg.add("HTTP")
    Pkg.add("Gumbo")
    Pkg.add("Cascadia")
    Pkg.add("Blink")
    Pkg.add("JSON")
end

using HTTP, Gumbo, Cascadia, Blink, JSON

w = Window(async=false)
function goto(address)
    loadurl(w, "$address")
end

function scrape(address)
    r = HTTP.get("$address")
    r_parsed = parsehtml(String(r.body))
    head = r_parsed.root[1]
    body = r_parsed.root[2]
end

const SOLANA_RPC_URL = "https://api.mainnet-beta.solana.com"

def get_solana_balance(pubkey)
    request_body = JSON.json(Dict(
        "jsonrpc" => "2.0",
        "id" => 1,
        "method" => "getBalance",
        "params" => [pubkey]
    ))
    response = HTTP.post(SOLANA_RPC_URL, ["Content-Type" => "application/json"], request_body)
    return JSON.parse(String(response.body))
end

def get_latest_block()
    request_body = JSON.json(Dict(
        "jsonrpc" => "2.0",
        "id" => 1,
        "method" => "getLatestBlockhash",
        "params" => []
    ))
    response = HTTP.post(SOLANA_RPC_URL, ["Content-Type" => "application/json"], request_body)
    return JSON.parse(String(response.body))
end

# Contoh penggunaan:
# println(get_solana_balance("YourWalletPublicKeyHere"))
# println(get_latest_block())
