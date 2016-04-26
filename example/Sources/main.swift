import Emoji
import Frank

get { _ in
  return "Hello 🇨🇭\n"
}

get(*) { (_, name: String) in
  return (EMOJI.findUnicodeName(name)
    .map { "\($0)" }
    .first ?? "¯\\_(ツ)_/¯") + "\n"
}

