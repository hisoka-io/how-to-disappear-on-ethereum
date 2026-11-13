# The checklist

1. **Use a mixnet where practical.** Especially for private transactions
   where timing matters.[^1] Tor or a VPN can also help protect your IP
   address.[^9]
2. **Check your wallet's privacy settings.** Review analytics, RPC
   providers, and background requests that may expose your activity.[^2]
3. **Keep wallet identities separate.** Avoid connecting unrelated
   addresses to the same applications or services.[^2]
4. **Watch for browser tracking.** Cookies and browser fingerprints,
   combinations of details about your browser and device, can link your
   activity across sessions.[^3]
5. **Plan how gas is paid.** Consider broadcasters, relayers, or sponsored
   transactions instead of funding fresh wallets from known addresses.[^4]
6. **Avoid obvious transaction patterns.** Distinctive amounts and
   immediate withdrawals can make transactions easier to link.[^5]
7. **Consider the anonymity set.** More deposits do not always mean more
   plausible matches for your transaction.[^14]
8. **Consider internal swaps.** Private transfers and swaps within
   supported systems can reduce visible links. External swaps can still
   reveal assets and amounts, and do not erase public history.[^4]
9. **Be careful with fresh addresses.** Gas funding and later transfers
   can reconnect addresses you intended to keep separate.[^11]
10. **Know who handles your transactions.** Solvers can receive order details.[^12] Relayers
    receive the requests they must submit.[^13] Remote provers given
    unprotected private inputs can read them.[^4]
11. **Avoid sharing transaction details.** Transaction hashes, amounts,
    timestamps, and screenshots can reveal connections.[^5]
12. **Protect viewing keys and backups.** These may expose private
    transaction history if compromised.[^4]
13. **Prefer local proving when practical.** Remote proving may expose
    private inputs, depending on the implementation.[^4]
14. **Review application permissions.** Disconnect unused applications
    and check wallet access and token approvals. Disconnecting an app
    does not revoke its permission to spend approved tokens.[^8]
15. **Think about where funds go afterward.** Withdrawing to known wallets
    or identified exchanges can reconnect your activity.[^5]
16. **Use trusted software.** Keep wallets updated, verify what you sign,
    and understand the protocols you use.

[^1]: Piotrowska et al., “The Loopix Anonymity System” (2017). [F03]
[^2]: MetaMask, Privacy Notice. [B08]
[^3]: Tor Project, Browser Fingerprinting Protections. [H01]
[^4]: RAILGUN, documentation (“Learn” wiki). [J09]
[^5]: Béres et al., “Blockchain is Watching You: Profiling and Deanonymizing Ethereum Users” (2020). [B45]
[^8]: MetaMask, “How to manage dapp permissions”. [H03]
[^9]: Electronic Frontier Foundation, “Choosing the VPN That’s Right for You”. [F14]
[^11]: ERC-5564: Stealth Addresses. [C33]
[^12]: CoW Protocol, Auction Schemas. [E29]
[^13]: ScopeLift, Umbra Protocol. [C35]
[^14]: Wang et al., “On How Zero-Knowledge Proof Blockchain Mixers Improve, and Worsen User Privacy” (2023). [C04]
