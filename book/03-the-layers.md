# The layers

Open your Ethereum wallet and check your balance.

Most wallets communicate with Ethereum through an RPC provider, a
service that answers requests for blockchain information. When your
wallet checks a balance, the provider receives the address being
queried and may also see your IP address. This can happen before you
send a transaction or sign a message.[^1]

Now imagine sending a payment. More parties become involved, each with
a different view of what you're doing.

The illustration on the following page follows these ordinary
interactions, showing where information can become visible before and
after a transaction reaches Ethereum.

\begin{figure}[p]
\centering
\includegraphics{design/figures/exports/layers-flowchart.pdf}

\smallskip
{\small\itshape Different actions expose information to different
observers. Not every interaction follows the same route.}
\end{figure}

A block explorer receives the addresses you search for.[^2] Your
internet provider can observe aspects of your network connection,
such as its destination and timing. HTTPS, which encrypts the
connection, generally prevents it from reading the contents of your
requests.[^5]

Applications introduce another set of observers.

Consider swapping tokens through a decentralised exchange. Before
submitting a transaction, the application may contact services that
provide prices, liquidity information, or transaction estimates.
Depending on how it is built, these services may receive your wallet
address, proposed trade, or information about your connection.[^1]

The smart contracts may be decentralised, but the services used to
interact with them do not necessarily offer the same privacy
guarantees.

Sending a transaction introduces another set of observers.

Nodes monitoring Ethereum's public network can see pending transactions,
including the sender, destination, value and contract call data, before
confirmation.[^10]

Some wallets use private submission services instead. These restrict
who can see a transaction before it reaches a block, but the services
receiving it may still inspect its contents.[^6]

Block builders assemble transactions into proposed blocks, and
validators participate in block production. Systems such as MEV-Boost
also involve relays connecting builders with proposing validators.[^3]

Once a transaction is included in a public block, its public contents
become part of Ethereum's public record.

Over time, repeated activity may reveal patterns: which applications an
address uses, when payments occur, and where funds move next.[^7]

An address does not automatically identify its owner. But a publicly
shared address or an ENS name, a readable name associated with an
address, may provide that connection. Another service may also hold
information identifying its owner.
A transfer between two addresses, however, does not prove that both
belong to the same person.[^4]

An exchange may also hold identity information associated with an
address. If its records are combined with an application's records
or the public transaction history, they can reveal connections that
none established on its own.[^8]

These interactions raise different privacy questions.

A transaction can reveal information on Ethereum. A network connection
can reveal where a request came from. And the request itself can reveal
what someone wanted to know.

\begin{center}
\begin{minipage}{\linewidth}
\centering
\includegraphics{design/figures/exports/privacy-layers.pdf}

\smallskip
{\small\itshape Transaction details, the source of a request and the
information it asks for need different protections. Combining them
still depends on the implementation and how it is used.}
\end{minipage}
\end{center}

To understand how these protections work together, we need to look at
privacy both on and off the chain. The next chapter covers network
connections and wallet requests. We then turn to the transaction itself
and what can be kept private on Ethereum.[^9]

[^1]: MetaMask, Privacy Notice. [B08]
[^2]: Etherscan, “What is Etherscan?” [J02]
[^3]: Flashbots, MEV-Boost Overview. [B06]
[^4]: Béres et al., “Blockchain is Watching You: Profiling and Deanonymizing Ethereum Users” (2020). [B45]
[^5]: Electronic Frontier Foundation, “Choosing the VPN That’s Right for You”. [F14]
[^6]: Flashbots, Protect Settings Guide. [B18]
[^7]: Ethereum.org, JSON-RPC API. [B01]
[^8]: Béres et al., “Blockchain is Watching You: Profiling and Deanonymizing Ethereum Users” (2020). [B45]
[^9]: Ethereum Foundation, “PIR for wallets”. [F10]
[^10]: Flashbots, Mempool Dumpster. [B04]
