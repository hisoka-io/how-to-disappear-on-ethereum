# Why this matters

In September 2026, a former Ethereum node operator heard from federal
investigators through his old roommate, who forwarded their email.

They wanted to know whether he had operated an Ethereum node in
Manhattan between 2021 and 2023. He had run a node from his apartment.

He wasn't suspected of a crime. Investigators were building a case
against someone accused of stealing more than $50 million from a DeFi
protocol. According to his account, prosecutors wanted testimony
about the Ethereum node he had operated in Manhattan.

His eventual testimony lasted roughly ten minutes.

What makes the story interesting is how they found him.

According to his account, investigators obtained IP addresses for nodes
from a block explorer and matched them against records held by his
internet provider. His old roommate had set up the internet connection,
which explained where the first email went.

He had not published his home address on Ethereum. Records outside the
chain were enough to connect him to a node he had stopped running years
earlier.[^02-why-this-matters-1]

Nothing about the blockchain itself needed to be broken.

This is a recurring problem with digital privacy. Information about us
rarely lives in one place. A wallet address is on a blockchain. An IP
address is in a server log. A name is in an exchange database. A home
address is in a billing record.

A single record may say little. Combining them can reveal more.

And the connections are not always made by investigators.

In January 2025, a co-founder of the hardware wallet company Ledger was
kidnapped from his home in France, along with his partner. The
attackers demanded a cryptocurrency ransom. Both victims were rescued
by police.[^02-why-this-matters-2]

Four months later, Coinbase disclosed that criminals had bribed
customer-support contractors to obtain personal information belonging
to customers.[^02-why-this-matters-3] A breach notification reported 69,461 affected
people.[^02-why-this-matters-6] The stolen records included names,
addresses, phone numbers, identity documents, and financial
information.[^02-why-this-matters-3]

In July 2026, attackers demanded cryptocurrency from a family held in
its home near Paris. French reporting linked the attack to stolen data
from Waltio, a cryptocurrency tax-reporting service.[^02-why-this-matters-12] Waltio said
email addresses and historical financial figures were exposed, while
private keys were not.[^02-why-this-matters-13]

In October 2026, a group calling itself WhiteArmor claimed to have
stolen user records from Wagyu.xyz, a cryptocurrency swap service
offering access to Monero without identity verification.

The group claimed to possess 38,628 swap orders and 10,139 IP
addresses, along with wallet information, session data, and browser
fingerprints. Its ransom message included a remarkably casual demand:

> *"Our demand is only \$5,000,000... hehe"*[^02-why-this-matters-4]

Wagyu's operator later acknowledged that three months of data had been
leaked, while stating that no funds were lost and swaps remained
unaffected.[^02-why-this-matters-5]

The incident illustrates an important distinction. A service can
protect users' funds while exposing information about the people using
it. Even when a cryptocurrency conceals transaction details, the
services surrounding it may still retain information that connects
transactions to their users.

These were different incidents, with different circumstances. But they
show the same thing: knowing someone's identity and connecting it to
their financial activity creates risks far beyond the internet.

A wallet can be cryptographically secure while its owner remains
exposed.

Private keys protect the ability to spend funds. They do not protect
the information surrounding those funds.

That distinction matters because most people do not think of
themselves as having anything to hide.

You might receive a payment from a client, contribute to a public
cause, send money to a friend, or use a decentralised application. None
of these activities needs to be unusual for someone to want privacy.

But the person paying you does not need to know how much you have
saved. A customer does not need to see every supplier your business
pays. A stranger who discovers your wallet address should not
automatically learn years of your financial history.

Yet on Ethereum, much of that information is public by default.

Open a block explorer and enter an address. You can inspect its
balance, token holdings, transaction history, contract interactions,
and the addresses it has exchanged funds with. In many cases, you can
follow the money backward to its original source or forward to its
next destination.[^02-why-this-matters-7]

This transparency is not an accident.

Ethereum was designed so that anyone could independently verify the
state of the network. Publicly available transaction data makes that
verification possible without trusting a central authority.[^02-why-this-matters-11]

It is one of Ethereum's most important properties.

But public verification and public exposure are not the same thing.

We need ways to establish that a transaction is valid without
revealing who made it, how much they own, or what else they have done.

That is the problem privacy engineering is trying to solve.

Some of the information surrounding a transaction is exchanged before
it reaches Ethereum. Your wallet communicates with services that answer
requests and help submit transactions. Those interactions can reveal
information that never appears on the blockchain.[^02-why-this-matters-8]

Protecting transaction details therefore addresses only part of a
person's privacy. The services they use and the records those services
hold matter too.

The next chapter follows two ordinary actions: checking a balance and
sending a payment. It explains who can observe each interaction and
what they can learn.

[^02-why-this-matters-1]: Dylan Brodeur, “1.5 Days in Court” (18 October 2026). [D14]
[^02-why-this-matters-2]: Gendarmerie nationale, “Enlèvement de David Balland” (24 January 2025). [D15]
[^02-why-this-matters-3]: Coinbase, “Protecting Our Customers — Standing Up to Extortionists” (15 May 2025). [D16]
[^02-why-this-matters-4]: CTI Updates, repost of the alleged Wagyu.xyz ransom notice (27 October 2026). [D25]
[^02-why-this-matters-5]: PerpetualCow, response to the Wagyu.xyz data leak. [D26]
[^02-why-this-matters-6]: Coinbase breach notification, Maine Attorney General (May 2025). [J01]
[^02-why-this-matters-7]: Ethereum.org, JSON-RPC API. [B01]
[^02-why-this-matters-8]: MetaMask, Privacy Notice. [B08]
[^02-why-this-matters-11]: Ethereum.org, “Nodes and clients”. [K01]
[^02-why-this-matters-12]: Le Parisien, report on the Taverny home invasion (23 September 2026). [D27]
[^02-why-this-matters-13]: Waltio, “Questions & Answers — Security Incident”. [D28]
