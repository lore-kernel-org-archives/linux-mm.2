Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1204606A691
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0RRJX22
Received: by kanga.kvack.org (Postfix)
	id B30906B05B3; Mon, 23 Nov 2026 11:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B7C6B05BA; Mon, 23 Nov 2026 11:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E836B05BB; Mon, 23 Nov 2026 11:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70DEB6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:24:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1AED16091B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:08 +0000 (UTC)
X-FDA: 85466905776.18.6716A43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29167180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0RRJX22;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451047;
	b=oMvIrbVVOh67QSZQii8s9TEkYxhZb1yeB6lWMJxhUcNeLW9mt4yFkdL+Vx9ayT8aoeHYxa
	Kar0cFbU+SEUfH8a/HyzGoYdDdGHqPvnFr8Od3BIZpDluh1VY1Q9m50Nz3nnc06eYIRVyL
	zmHz0epFv371d2pd8uNZa1iFWQPHmTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ME4azgngOCTJNfnpv6QdSj8+9zz0mmaxRAUYJ+dI6fs=;
	b=sGiluPbkXRGpqQHVubDs+D/5AhET/wZtaOtcd5d+SbnKZ6y9UyL78Rr6iYRU6kpfBkTNWQ
	XQ5UCwT7svKU1fagzXtU20ZZ9bQg53ksJFBLFk9JMa+0njGgZZidOA52dRICUgHxM/PH1d
	/SywEAJf2HeNu/MH9oM10ayjxVWWpWs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0RRJX22;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F23A40233;
	Mon, 23 Nov 2026 16:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092631F0093E;
	Mon, 23 Nov 2026 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451046;
	bh=ME4azgngOCTJNfnpv6QdSj8+9zz0mmaxRAUYJ+dI6fs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=N0RRJX22wIA9TkrEx1tjIGlt3lmxaaFzDw/lSUKyIMt7cEWat0bGVFjYgbHgQQIQ2
	 wOvA3XXlvtWO1f1JVBiDYbwdK/x8ko0nO7axlVj9H/10hDnuJzbI+fzgQBsZyd3iyf
	 DS2Cs0ZpiH8PGSjjJTIpPYHpJZwlhtk8WwUWxLJNrRKOvTCggl7YAdMYYNw46WiL/+
	 xfoCRKY9H1WBegipnLGbXBdh9JpuvtHGFvbLnktk5J4XqkQsAnQ+Eka++pDNeJD5Ez
	 7/bHrIW1JP4ekQL+qhotAKmiHj52y+Nvpmvdrgob7idGvYtJhV2BwZlSKp22CWiTiw
	 RJVWToXrKWUFw==
Subject: Re: [PATCH net 2/3] net: account IPV6_2292PKTOPTIONS and multicast
 socket state to memcg
From: netdev-bot+sashiko@kernel.org
To: x-professor@outlook.com
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 16:24:04 +0000
Message-ID: <179545104461.3135.5611486557181472051@kernel.org>
In-Reply-To: <5f2e25611e300561db512cd3ad3190f4d782484a.1795102467.git.x-professor@outlook.com>
References: <5f2e25611e300561db512cd3ad3190f4d782484a.1795102467.git.x-professor@outlook.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 29167180003
X-Stat-Signature: hx7wf7iubm947we5sytyf6ytgii99s5p
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795451047-401434
X-HE-Meta: U2FsdGVkX1/+fu68ykl+aVgvgi4gSJfsVdnnupb575mPO6CB9imL2zw8P5HEmqMM/ZoJZThFxqzTV9CwE7HqM6In5sj8hWfmF3FlQ/tY7Tr1XVNpYRK3BZXG/hndz523yKl2kZiPh8RCt4Qit8iJ1T/9wKXTPwL7xYpqvK8yf2/dcGf2qADbr89w8tzNZbQWF5on4lu+1hYYUkQSA61pS51zxibEHdH5+guKjUU8oFGxJ6eYamR4LqKybTSGriKEdXQf0jLwqPRrYw1OqyTz/phMY5crwet4+//IhNt2EEgjn6RgLuGbYY3/SUuWk/SiVCzzvO4Z8BSo/WKiKq86LtNMbtGnwELgrZeJHyIg7N8IPPB2j5gl4Du/yLuMycMcaDg6qKwapb8XDzyGOjBMVuQ6uWh5aQdxCSSg0Y0y1Urfc4Kd3/7jODKmB6T/LJTMJh180iNI2zgn1P+iSgw2x2KCnGyh+ebHBYpJJo4KZXsj1wI3ZyjPP5/IkyNFQvEE44qrHddkVS2M5oqJJXbLuPYVi1Fj8IgSrVcH6Zxon5S810vtGvUJn1rY9JxUlXwkLm5xZooPcp7kwHdGZCwdSy8y1BsdiHUaWS3K2uATQP4eXWyWPWZF/ysu4jSGVWKw2OPUpVH9OSn4lXb1zmzd4HbJg4yG6mR7fyY8qf9UWtmi8KQ/dIduk327HxH1FtVYUF0P+Z6vqHq4l/2UC9LMHiMtcDKw9B0+Kq8kPJuudpIL66GeRgN7fj6mroMhgQVcG5KtBxAgeLICE6BelhCVbJOY3iVcpTUyv4NmKbe2DUeHP/tw4Hd1FKJtEK3SHBS27qalNxO0/oPhb2rYc2BglOO75zYFMEmVzZjDvXDC4UD5t9GPaCFQzXsSxt5H9+NLIardx8AeqMeV3jvn9daqhOOdJ515WNpdo3QMvz+vFaOQ16Juvzi9AGEVTcYRwSItOmJxEKivSZ1IxQc4iZE
 tyPNR48E
 vqrqr7RtCC4LWlJ4qk/0QkIIEk9XBRpD8v+jR2xrZ0SAziY9idoZ2C4sRagyNBaa+kMrQT66DqscvQJm6xyvZp/jssu8VO0A7gUUmbLfa0zjdZhaYoyIardi/QLRRIeYLgHyZbIJCp5LbOHaoM5CM45v2O6ge5idgB0x7sBxq2whNNimGPgXrue0yC2DlAGZisxmDGW2d+kNT4MJTqzbKNUVetO6MJzcGRLlBdoLgs+4oqJieo3/893ckqypX+C2KD2m/m9dbadKZjQJDJLGugLUDgglnUkiStpWcdD10lj8LxY2CvDeIpo6DNdJdb7HliB7GCEmS3SDE8cUEt5aeDDRnX+S5c3JppqUMd2LcVhUNvpMde7Y/jnK8mK4zvC74+jeGjmWsxq6R7E+XIs6589fmmNp9ksRTSXm1Hk1AujXi1HYvda9cg9R9G31G1kbloHVzfLrYwBVoEUWaSTAJ/TcRJsKj0vftamfW4YqbC1UwHyl5+uxDvM70AIeTwSPl/PuoVFeHPGDs837lgPpBiwurasdjvgese2cDEDU+1v4oB90WslJaE9cd/rJjNiy0XqRhCWXUD+de7y/DBivw98o3dGRxFdNgHVWg4kG87UyLJedMXJpBAU6Be+zxsobXTxpYTTjcPDQgdubwcKCBJwVNBwsESx8myXEYn/k3GEeFwju3bqgbVg1v5Yva73qLU//kwamaBfKM2PeJjHsb7OZBi37tvDCSutKAkPCIFSZgBMAUTxVPR1/OZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch charges the IPV6_2292PKTOPTIONS buffer to memcg only
  where setsockopt() first allocates it (do_ipv6_setsockopt(),…
- [Medium] This patch charges the per-socket multicast records but not
  the per-device objects that the same join and source operations create.
- [Low] In the source-removal (!add) branch of ip6_mc_source()
  (net/ipv6/mcast.c:437 in this commit), the code allocates a smaller…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the commit
  message describes it as a general sock_kmalloc() issue: 'Allocations…

--

net: account IPV6_2292PKTOPTIONS and multicast socket state to memcg

This commit changes several long-lived socket allocations to
GFP_KERNEL_ACCOUNT so they are charged to the memory cgroup. The affected
allocations are the IPV6_2292PKTOPTIONS cmsg buffer, the IPv4 and IPv6
multicast source lists, and the IPv4 and IPv6 multicast membership
records. sock_kmalloc() itself is left unchanged because some of its
callers run in softirq context.

> sock_kmalloc() limits allocations using sk_omem_alloc and optmem_max,
> but does not request kernel memory cgroup accounting.  Allocations retained
> by a socket can therefore consume kernel memory without contributing to
> memory.current.

[ ... ]

> sock_kmalloc() itself is left unchanged: some callers run in softirq
> context, where current_obj_cgroup() uses an explicitly active memcg or
> the root memcg, so those allocations have different charge-attribution
> semantics.

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. The
commit message describes this as a general sock_kmalloc() problem, but the
reason given for leaving sock_kmalloc() alone only covers softirq callers.

Several process-context sock_kmalloc() sites also keep allocations for the
life of the socket. They are uncharged and limited only by optmem_max:

net/ipv4/tcp_ipv4.c:__tcp_md5_do_add() (TCP_MD5SIG, no capability check):

	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);

net/ipv4/tcp_ao.c:tcp_ao_key_alloc() (called from tcp_ao_add_cmd()):

	key = sock_kmalloc(sk, size, GFP_KERNEL);

net/ipv6/anycast.c:ipv6_sock_ac_join() (needs ns_capable(CAP_NET_ADMIN),
which a user namespace provides):

	pac = sock_kmalloc(sk, sizeof(struct ipv6_ac_socklist), GFP_KERNEL);

net/ipv6/exthdrs.c:ipv6_renew_options() (unprivileged via IPV6_RTHDR, also
HOPOPTS/DSTOPTS; smaller, since each header is at most 8*255 bytes):

	opt2 = sk ? sock_kmalloc(sk, tot_len, GFP_ATOMIC) :
		    kmalloc(tot_len, GFP_ATOMIC);

The anycast record is the twin of the IPv6 multicast membership record that
this patch converts in __ipv6_sock_mc_join().

The TCP_MD5SIG keys alone let an unprivileged TCP socket hold close to
optmem_max (128 KiB by default). That is the same per-socket size as the
IPV6_2292PKTOPTIONS reproducer.

Should these sites be converted too? If not, could the commit message say
why they stay uncharged?

> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index bfa448028f8a1..5fe8736c7b472 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2381,7 +2381,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
>  	err = -ENOBUFS;
>  	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
>  		goto done;
> -	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
> +	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL_ACCOUNT);
>  	if (!iml)
>  		goto done;
>  

[Severity: Medium]
The socket record is charged here. What about the per-device group record
that __ip_mc_join_group() creates a few lines later?

	rcu_assign_pointer(inet->mc_list, iml);
	____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL);

____ip_mc_inc_group() allocates struct ip_mc_list with:

	im = kzalloc_obj(*im, gfp);

On leave, __ip_mc_dec_group()->igmpv3_add_delrec() creates an IGMPv3 tomb
with:

	pmc = kzalloc_obj(*pmc, gfp);

Neither allocation uses __GFP_ACCOUNT.

The caller picks the group address, so each charged ip_mc_socklist can pin
a separate, larger, uncharged ip_mc_list (timer, lock, refcounts).

In a user+net namespace with igmp_max_memberships raised, a socket could
hold its optmem_max budget in charged records plus several times that in
uncharged ip_mc_list objects. Join/leave churn on an IGMPv3 device also
builds up uncharged tombs.

A later patch in this series, "net: multicast: account group and source
allocations to memcg", charges the IPv6 versions: mca_alloc() for
ifmcaddr6, plus the ip6_sf_list entries and tombs. It also charges the IPv4
ip_sf_list entries and tombs. At the end of the series, though, the IPv4
ip_mc_list and its igmpv3_add_delrec() tombs still seem to be uncharged.

____ip_mc_inc_group() returns void, and __ip_mc_join_group() ignores its
allocation failure, which may be why it was left out. Could one of the
commit messages say so, or should these allocations be charged as well?

[ ... ]

> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 82573260b7409..89394f8d963f6 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -748,7 +748,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  		if (optlen > 64*1024)
>  			break;
>  
> -		opt = sock_kmalloc(sk, sizeof(*opt) + optlen, GFP_KERNEL);
> +		opt = sock_kmalloc(sk, sizeof(*opt) + optlen, GFP_KERNEL_ACCOUNT);

[Severity: High]
This charges the buffer where setsockopt() first allocates it. Can the same
payload still be copied without any charge?

IPV6_2292PKTOPTIONS can be set on an IPv6 TCP listener; the getsockopt()
side is even limited to SOCK_STREAM. Each child that completes the
handshake then copies the listener's options:

net/ipv6/tcp_ipv6.c:tcp_v6_syn_recv_sock() {
    ...
	opt = ireq->ipv6_opt;
	if (!opt)
		opt = rcu_dereference(np->opt);
	if (opt) {
		opt = ipv6_dup_options(newsk, opt);
		RCU_INIT_POINTER(newnp->opt, opt);
    ...
}

ipv6_dup_options() copies the full tot_len:

net/ipv6/exthdrs.c:ipv6_dup_options() {
    ...
	opt2 = sock_kmemdup(sk, opt, opt->tot_len, GFP_ATOMIC);
    ...
}

That copy uses GFP_ATOMIC with no __GFP_ACCOUNT. It also runs in softirq,
where current_obj_cgroup() would not pick the user's memcg anyway.

sk_clone_lock() also resets the child's budget:

	atomic_set(&newsk->sk_omem_alloc, 0);

so every child passes its own optmem_max check.

With one charged listener and N connections, does this still keep N copies
of up to ~64 KiB each (in ~128 KiB kmalloc_large allocations) outside
memory.max? The copies are held whether the children sit in the accept
queue (up to the backlog) or have been accepted.

MPTCP (net/mptcp/protocol.c) and SCTP (net/sctp/ipv6.c) make the same
uncharged copy.

The copy runs in softirq, so __GFP_ACCOUNT at that call would not charge
the right memcg. Would closing this need a charge against the listener's
memcg instead?

>  		retv = -ENOBUFS;
>  		if (!opt)
>  			break;
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index 0d982f7d29cda..ede1f0825bad5 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c

[ ... ]

> @@ -435,7 +436,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
>  		} else {
>  			newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr,
>  							      psl->sl_count - 1),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL_ACCOUNT);
>  			if (!newpsl) {
>  				atomic_add(struct_size(psl, sl_addr, psl->sl_max),
>  					   &sk->sk_omem_alloc);

[Severity: Low]
This is the source-removal (!add) branch of ip6_mc_source(). It is reached
through MCAST_LEAVE_SOURCE_GROUP or MCAST_UNBLOCK_SOURCE when sl_count > 1.
With the charge added here, can an operation that shrinks the socket's
memory now fail?

If the cgroup is at memory.max, the charge can enter memcg reclaim or the
memcg OOM killer. If that cannot make progress, or the task is dying or is
already the OOM victim, sock_kmalloc() returns NULL. The source then stays
in the filter and setsockopt() returns -ENOBUFS. The error path does keep
the filter state consistent.

The IPv4 counterpart, ip_mc_source(), removes the source in place without
allocating:

	for (j = i+1; j < psl->sl_count; j++)
		psl->sl_addr[j-1] = psl->sl_addr[j];
	psl->sl_count--;

Could this allocation stay uncharged? Alternatively, psl could be shrunk in
place the way IPv4 does it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795102467.git.x-professor%40outlook.com

