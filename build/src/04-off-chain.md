# Off-chain privacy

Suppose Ethereum allowed you to transfer funds without revealing the
sender, recipient, or amount.

For now, we can treat the system that makes this possible as a black
box. Assume its cryptography works exactly as intended.

We still need to protect the information exchanged while using it.

We will start with the network connection, then look at the
information a wallet requests.

## Network privacy

One way to hide your IP address from a destination is to send traffic
through another server.

A VPN does this by forwarding your connection through its own server.
The destination sees the VPN's IP address rather than yours. But the
VPN provider can observe information about your connection, so some
trust moves from the destination to the VPN.[^04-off-chain-1]

Tor routes traffic through several relays, servers that pass messages
along, typically in entry, middle and exit roles. No single ordinary relay needs to know both who
sent the request and where it is going.[^04-off-chain-2]

A mixnet, short for mix network, also routes messages through relays,
but deliberately adds delays and mixes messages with other traffic.
Some designs generate extra messages to make real activity harder to
distinguish from background traffic.[^04-off-chain-3]

\begin{center}
\begin{minipage}{\linewidth}\centering
\includegraphics{design/figures/exports/network-routes.pdf}

\smallskip
{\small\itshape Three approaches to network privacy. The VPN example uses one
intermediary, Tor separates the source and destination across relays,
and mixnets additionally obscure message timing through delays and
mixing.}
\end{minipage}
\end{center}

Hiding an IP address does not necessarily hide when a message was sent.

Suppose a private transaction appears on Ethereum shortly after your
device sends a burst of traffic. Someone monitoring both events may
try to connect them through their timing.[^04-off-chain-4]

Tor is designed for relatively fast communication, so an observer
capable of watching both ends of a connection may still compare
traffic patterns.[^04-off-chain-2]

Mixnets deliberately make that comparison harder by delaying and
mixing messages. For a private transfer, waiting a little longer may
be an acceptable trade-off. The protection depends on the amount of
traffic, the independence of the relays, and what the observer can
see. A quiet network offers fewer messages to blend with.[^04-off-chain-3]

Nym offers mixnet-based routing for general network traffic.[^04-off-chain-5]
HOPR rewards relays for delivering messages.[^04-off-chain-13] Both involve the delay
and traffic trade-offs above.

Nox is a mixnet being developed at Hisoka for blockchain transactions
and general network traffic. Its design routes web requests and
blockchain queries, including encrypted connections that stay private
between the client and the destination.[^04-off-chain-12]

The last relay in the route can also submit a transaction and pay its
gas fee. The user pays that relay through a shielded payment,
which conceals who made that payment. This still leaves the relay with
the transaction it must execute. Routing alone does not hide what an
ordinary query asks the destination.[^04-off-chain-12]

## Query privacy

Hiding your IP address does not hide what you ask a server.

Suppose you want to check an Ethereum address's balance. Even through
Tor or a mixnet, an ordinary RPC request identifies the address.
The request includes the address as a parameter.[^04-off-chain-6] If several such
requests share a connection, the server can associate those queries.
That association does not prove that one person owns the addresses.

The balance is public. Your interest in that address may not be.

What if you could retrieve the balance without revealing which
address you wanted?

Private information retrieval, or PIR, lets a wallet fetch a record
without revealing which one it selected, under the protocol's security
assumptions.[^04-off-chain-7]

Imagine a database of account records. Downloading it all and searching
locally avoids revealing your choice, but becomes expensive as it grows.

In this small example, each entry holds one account record:

$$
D =
\begin{bmatrix}
d_{1,1} & d_{1,2} & d_{1,3} & d_{1,4}\\
d_{2,1} & d_{2,2} & d_{2,3} & d_{2,4}\\
d_{3,1} & d_{3,2} & d_{3,3} & d_{3,4}
\end{bmatrix}
$$

Your wallet wants the record at position $(2,3)$.

$$
\boxed{\text{Can we retrieve }d_{2,3}\text{ without revealing }(2,3)\text{?}}
$$

The wallet sends a query that conceals this position. The server
computes a response, from which the wallet recovers its record.[^04-off-chain-7]

\begin{center}
\begin{minipage}{\linewidth}\centering
\begin{tikzpicture}[x=1mm,y=1mm,line width=0.4pt,>=stealth,font=\small]
  % (a) ordinary lookup
  \node[anchor=west,font=\footnotesize] at (0,34) {(a) Ordinary lookup};
  \node at (12,28) {Client}; \node at (88,28) {Server};
  \draw[dashed,gray] (12,25) -- (12,8); \draw[dashed,gray] (88,25) -- (88,8);
  \draw[->] (12,20) -- (88,20); \node[above,font=\footnotesize] at (50,20) {Request $(2,3)$};
  \draw[<-] (12,12) -- (88,12); \node[above,font=\footnotesize] at (50,12) {Response $d_{2,3}$};
  % (b) PIR
  \node[anchor=west,font=\footnotesize] at (0,0) {(b) Private information retrieval};
  \node at (12,-6) {Client}; \node at (88,-6) {Server};
  \draw[dashed,gray] (12,-9) -- (12,-26); \draw[dashed,gray] (88,-9) -- (88,-26);
  \draw[->] (12,-14) -- (88,-14); \node[above,font=\footnotesize] at (50,-14) {Private query $Q$};
  \draw[<-] (12,-22) -- (88,-22); \node[above,font=\footnotesize] at (50,-22) {Encoded response $R$};
\end{tikzpicture}

\smallskip
{\small\itshape Ordinary database requests reveal the selected
position. PIR conceals the selection while allowing the client to
recover the requested record.}
\end{minipage}
\end{center}

Researchers published work on PIR in 1995.[^04-off-chain-8] Making PIR practical for
wallets means handling large, changing blockchain databases, with
extra computation and data transfer.[^04-off-chain-9]

The Ethereum Foundation's private-reads research includes private
account-balance lookups for wallets. It hides which address was
selected, but a separate check is needed to establish that the
server's answer is correct.[^04-off-chain-9]

Raven is a general-purpose PIR framework being developed at Hisoka
to make private blockchain lookups usable in wallets. It gives developers
a way to serve records through private queries, so the server can
answer without learning which record the wallet selected. Its scope
includes different kinds of blockchain records, with Railgun wallet
lookups as one application.[^04-off-chain-10]

The cost is extra computation and data transfer to keep those queries
private as the underlying data changes. Raven's query protection also
leaves the request's IP address and timing exposed unless the wallet
separately protects its connection.[^04-off-chain-10]

The Ethereum Foundation provides a reference client for developers
working on wallet integration.[^04-off-chain-11]

Network privacy and query privacy protect different parts of the same
interaction. One makes it harder to identify where a request came
from. The other hides which information was requested.

Neither changes what Ethereum records about a transaction.

For that, we need to look inside the black box.

[^04-off-chain-1]: Electronic Frontier Foundation, “Choosing the VPN That’s Right for You”. [F14]
[^04-off-chain-2]: Dingledine, Mathewson and Syverson, “Tor: The Second-Generation Onion Router” (2004). [F01]
[^04-off-chain-3]: Piotrowska et al., “The Loopix Anonymity System” (2017). [F03]
[^04-off-chain-4]: Wang et al., “Time Tells All: Deanonymization of Blockchain RPC Users with Zero Transaction Fee” (2025). [B29]
[^04-off-chain-5]: Nym, “Introducing Mixnet Tuning in NymVPN”. [F08]
[^04-off-chain-6]: Ethereum.org, JSON-RPC API. [B01]
[^04-off-chain-7]: Ethereum Foundation, “PIR for wallets”. [F10]
[^04-off-chain-8]: Chor, Goldreich, Kushilevitz and Sudan, “Private Information Retrieval”: original publication record. [F05]
[^04-off-chain-9]: Ethereum Foundation, “PIR for wallets”. [F10]
[^04-off-chain-10]: Hisoka, “Introducing Raven”. [F07]
[^04-off-chain-11]: Ethereum Foundation, “PIR for wallets”. [F10]
[^04-off-chain-12]: Hisoka, Nox documentation. [F19]
[^04-off-chain-13]: HOPR, “Incentives”. [J03]
