# On-chain privacy

So far, we have treated private transactions as a black box. We assumed
that the sender, recipient, and amount could be hidden, without asking
how.

Now we can open it.

There is no single way to make a transaction private. Some systems hide
the connection between deposits and withdrawals. Others conceal amounts,
create new receiving addresses, or keep parts of an application's
execution private.

They also leave different information visible.

We will begin with shielded pools, where users can move funds without
making every movement public.

## Shielded pools

Imagine depositing 10 ETH into a shared pool. Other people deposit funds
too. Later, you want to send some of your balance to another person.

In an ordinary Ethereum transfer, the sender, recipient, and amount are
public. In a shielded system, the pool can verify that you have funds to
spend without revealing which private balance belongs to you.

The pool uses cryptographic commitments to represent private funds.
A commitment is a public record that hides its underlying private
information.[^05-the-tools-1]

A zero-knowledge proof lets the system check that a transaction follows
the rules without revealing the private information used to create it.[^05-the-tools-1]

The wallet keeps a private note, a record of funds it can spend. The
public commitment is derived from the note's details.[^05-the-tools-1]

A *nullifier* marks private funds that have been spent. The contract
rejects a nullifier it has already seen, preventing repeat spending
without publicly identifying the note it came from.[^05-the-tools-1]

There are three actions worth understanding.

**Shielding** moves funds from a public address into the private system.
The deposit is generally visible on Ethereum, including information such
as the asset and amount.[^05-the-tools-1]

**Private transfers** move funds within the shielded system, where
supported. These can hide the sender-recipient relationship and
transaction amounts.[^05-the-tools-1]

**Unshielding** moves funds back to a public address. The withdrawal is
visible, but the proof does not directly reveal which private funds were
spent.[^05-the-tools-1]

\begin{center}
\includegraphics{design/figures/exports/shielded-pool.pdf}
\end{center}

Different systems build on this idea in different ways.
Railgun supports private balances, transfers, and
certain DeFi interactions within a shielded system.[^05-the-tools-1]

Privacy Pools uses association sets, which
are selected groups of deposits. When withdrawing, a user can prove
that their funds belong to one of these groups without revealing the
specific deposit. The provider maintaining the group can change which
deposits qualify for a private withdrawal.[^05-the-tools-4]

\Needspace{100mm}

These systems offer meaningful privacy protections, but they do not make
every action surrounding a transaction invisible.

### What remains visible

The cryptography can work exactly as intended while the way someone uses
a pool reveals clues about their activity.

Consider depositing 10 ETH and withdrawing 10 ETH shortly afterward. If
few other transactions could plausibly match that withdrawal, an
observer may suspect a connection.[^05-the-tools-5]

\begin{center}
\begin{minipage}{\linewidth}\centering
\includegraphics[width=\linewidth]{design/figures/exports/privacy-loss.pdf}

\smallskip
{\small\itshape Matching amounts close in time can suggest a link.
They do not prove it.}
\end{minipage}
\end{center}

This does not mean withdrawing the same amount is always a mistake.
Fixed-denomination pools are designed around common amounts. In pools
that support different amounts, however, an unusual amount can make a
transaction stand out.

Timing, public addresses, and later movements can provide additional
clues. None may identify the user on its own, but together they can
narrow the possibilities.

This is why the *effective anonymity set* matters. A pool might have
thousands of deposits, but only a smaller number may remain plausible
matches after considering the information an observer can see.[^05-the-tools-25]

Other links can be more direct. Withdrawing to an address already
associated with you reveals that you received funds. Even a fresh
address can become linked to an existing wallet if you fund its gas fees
from that wallet.[^05-the-tools-23]

Some protocols use a broadcaster, a service that submits a transaction
and pays its gas in return for a fee.[^05-the-tools-1] Supported private transfers
can avoid withdrawing funds to a public wallet.[^05-the-tools-1] A swap through an
external exchange can still reveal the assets and amounts traded, even
when its proceeds return to a private balance.[^05-the-tools-1]

What happens afterward matters too. Sending funds to a known exchange
account or reusing an address can reveal where funds went, even when the
earlier private activity remains concealed.[^05-the-tools-5]

A shielded pool can provide strong privacy for the information it is
designed to hide. But amounts, timing, addresses, and later activity can
leave small clues that become more revealing when combined.

The proof may remain secure while those clues make a transaction easier
to trace.

## Private rollups

Shielded pools allow private transfers and, in some designs, interactions
with supported financial applications.[^05-the-tools-1] Another approach is to build
privacy into the environment where applications run.

Private rollups process transactions outside Ethereum and use it to
verify the results. They allow applications to keep certain data and
computations private while using cryptographic proofs to verify that
transactions follow the system's rules.[^05-the-tools-7]

For example, an application could update a private balance or check
whether someone is eligible to use a service without revealing the
underlying information.

Aztec is one example of this approach. Its architecture supports both
private and public execution, allowing applications to choose which
information they reveal.[^05-the-tools-7]

Rollups such as Starknet also use proofs to verify execution. Starknet
publishes enough data for observers to reconstruct its public state.
Using proofs does not by itself make a rollup private.[^05-the-tools-8]

Even with private execution, some information can remain public.
Moving funds between Ethereum and the rollup can leave public records,
and applications can choose to reveal particular actions or results.[^05-the-tools-9]

## Encrypted tokens

Sometimes the sender and recipient are not the main concern. The amount
is.

Imagine a company paying contractors on Ethereum. It may be acceptable
for observers to know that payments occurred, but not how much each
person received.

Confidential tokens are designed for this kind of problem. Some use
encryption to keep balances and transfer amounts private.

Fully homomorphic encryption, or FHE, allows an application to compute
with encrypted values without first decrypting them.[^05-the-tools-19]

For example, two values encrypted using a compatible setup can be added
together:

$$
\operatorname{Enc}(a),\ \operatorname{Enc}(b)
\xrightarrow{\text{encrypted addition}}
\text{an encryption of }a+b
$$

Here, $\operatorname{Enc}(a)$ means an encrypted version of the value
$a$. The result is an encrypted sum. Neither input needs to be revealed
during the calculation.[^05-the-tools-19]

This is a simplified illustration. The addition uses operations defined
by the encryption scheme, rather than ordinary arithmetic on the
encrypted values.

Applications can use these operations to update encrypted balances and
check that a transfer does not exceed the available funds.

Projects such as Zama and OpenZeppelin provide tools for creating tokens
with encrypted balances and transfer amounts.[^05-the-tools-10]

The application's rules determine who is allowed to decrypt particular
values. Privacy also depends on how the underlying system manages
decryption keys and enforces those permissions.[^05-the-tools-20]

Encrypting amounts does not necessarily hide the addresses involved.
Observers may still see which addresses interact and when transactions
occur.[^05-the-tools-10]

## Stealth addresses

Keeping payment amounts private addresses one kind of exposure.
Receiving every payment at the same public address creates another.

Suppose you publish one Ethereum address and use it to receive payments.
Anyone who knows that address can examine its incoming transfers and
build a history of payments associated with it.

Stealth addresses offer a way to separate these payments.

Instead of sharing a new address every time, a recipient publishes
reusable receiving information. A sender uses it to generate a fresh
on-chain address for each payment.

The recipient's wallet checks public announcements to find payments
intended for them and derives the keys needed to spend the funds.[^05-the-tools-11]

The sender knows the destination they generated for the recipient. Other
observers cannot derive that connection from the published receiving
information alone.[^05-the-tools-11]

\begin{center}
\begin{minipage}{\linewidth}\centering
\includegraphics{design/figures/exports/stealth-addresses.pdf}

\smallskip
{\small\itshape One set of reusable receiving information supports a fresh
address for each payment. The arrows show address generation, not public
transfers.}
\end{minipage}
\end{center}

ERC-5564 describes a standard approach to stealth addresses on Ethereum.
Umbra illustrates a stealth-payment workflow.[^05-the-tools-12] Fluidkey provides
a different receiving design, including service-side viewing access.[^05-the-tools-21]

Payments can arrive at separate addresses rather than accumulating at
one publicly known address. However, individual payments may still
reveal their amounts, assets, senders, and timestamps.[^05-the-tools-23]

Spending the received funds introduces another consideration. A newly
generated address may hold tokens but no ETH to pay transaction fees.
Funding it from an existing public wallet can create a visible connection
between the addresses.[^05-the-tools-11]

Some implementations use a relayer, a separate service that submits the
spending transaction and handles its fee. This can avoid a direct funding
transfer from the recipient's public wallet, though the service may
charge a fee from the received funds.[^05-the-tools-12]

Sending funds from several of these addresses to one public wallet can
link the payments again.[^05-the-tools-23]

## Intents and private execution

Not every approach to privacy involves hiding balances or transaction
history. Some focus on how transactions are executed and who has access
to their details.

Consider swapping one token for another.

In a typical on-chain swap, a user submits a transaction describing how
the trade should be executed. With an *intent*, the user instead specifies
the outcome they want, such as exchanging one token for another at an
acceptable price.[^05-the-tools-13]

Other participants, often called *solvers*, attempt to fulfill that
request.[^05-the-tools-13]

\begin{center}
\begin{minipage}{\linewidth}\centering
\includegraphics{design/figures/exports/intent-execution.pdf}

\smallskip
{\small\itshape A direct transaction specifies an action. An intent
specifies an outcome for a solver to fulfill. Neither flow alone
establishes privacy.}
\end{minipage}
\end{center}

This approach can support more flexible execution, including transactions
that involve multiple applications or blockchains.[^05-the-tools-22]

Privacy becomes relevant when considering how orders are shared and
processed. Some systems limit the visibility of orders before settlement,
while others use separate environments for confidential execution.[^05-the-tools-15]

Projects working in this broader area include CoW Protocol, NEAR Intents,
and confidential swap systems. They use different approaches to order
execution, coordination, and privacy. NEAR’s described confidential
design uses approved operators and a bridge to the public network.
Its privacy therefore depends on those operators and that bridge.[^05-the-tools-15]

The information available to participants depends on the system's design.
An order may be visible to certain parties during execution.[^05-the-tools-14] Other
details become public when the transaction settles.[^05-the-tools-23]

Intents change how users express what they want to do. The privacy of that
interaction depends on how the request is handled, who processes it, and
what information eventually reaches the blockchain.

\Needspace{85mm}

## Choosing the right approach

Each approach protects a different part of a transaction.

\begingroup
\fontsize{11}{14}\selectfont
\renewcommand{\arraystretch}{1.45}
\setlength{\tabcolsep}{6pt}

| Approach | Protects | May remain visible |
|---|---|---|
| Shielded pools | Transfer links | Public entry and exit |
| Private rollups | Private execution | Public actions |
| Encrypted tokens | Amounts | Addresses |
| Stealth addresses | Receiving links | Individual payments |
| Intents | Design-dependent | Order and settlement details |

\endgroup

The right approach depends on what you want to keep private. These
technologies can also work together, depending on how they are designed
and used.

[^05-the-tools-1]: RAILGUN, documentation (“Learn” wiki). [J09]
[^05-the-tools-4]: Privacy Pools, Association Set Provider documentation. [J10]
[^05-the-tools-5]: Béres et al., “Blockchain is Watching You: Profiling and Deanonymizing Ethereum Users” (2020). [B45]
[^05-the-tools-7]: Aztec, State Management. [E12]
[^05-the-tools-8]: Starknet, Data Availability. [E13]
[^05-the-tools-9]: Aztec, L1–L2 Communication (Portals). [J12]
[^05-the-tools-10]: OpenZeppelin, Confidential Token Contracts. [G01]
[^05-the-tools-11]: ERC-5564: Stealth Addresses. [C33]
[^05-the-tools-12]: ScopeLift, Umbra Protocol. [C35]
[^05-the-tools-13]: CoW Protocol, “Intents”. [J11]
[^05-the-tools-14]: CoW Protocol, Auction Schemas. [E29]
[^05-the-tools-15]: NEAR, “Confidential Intents: Confidential Execution for Cross-Chain Transactions” (24 February 2026). [E32]
[^05-the-tools-19]: Zama, Confidential Blockchain Protocol Litepaper. [E2]
[^05-the-tools-20]: Zama, Key Management Service. [E4]
[^05-the-tools-21]: Fluidkey, Technical Walkthrough. [E27]
[^05-the-tools-22]: NEAR Intents, “What are Intents?” [C27]
[^05-the-tools-23]: Ethereum.org, JSON-RPC API. [B01]
[^05-the-tools-25]: Wang et al., “On How Zero-Knowledge Proof Blockchain Mixers Improve, and Worsen User Privacy” (2023). [C04]
