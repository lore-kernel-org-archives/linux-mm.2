Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721B2606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGRrDED2
Received: by kanga.kvack.org (Postfix)
	id 8707E6B05BA; Mon, 23 Nov 2026 11:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821416B05BB; Mon, 23 Nov 2026 11:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710276B05BC; Mon, 23 Nov 2026 11:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE386B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:24:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96D941A091A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:10 +0000 (UTC)
X-FDA: 85466905860.12.13792FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id EC5C5180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGRrDED2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451049;
	b=x9vj9yb1aEUG4/Tq7bsvXmCXoEnBhyQ5xcu+hi4xfejr4eieJqQsp+2XJjznPS0ZL3q8St
	oJ3Zp1cdJ99JBh1eah4mjQiARS2gRrC2u9SueKb5c32wU7O/QH0q9oCAuSsV8OxBIgDhK5
	LhGgPZFj1cvHGYAFhYgrALtb3ZVLRKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZXIFYILtCNn6BOcPijM59Qx4+riXxSWUomOV63QZGA=;
	b=7L9TR+J0V5NSBwKYVNNWELNDujFSsETz8LX5Jwa9PdHITtk8dNFt43oMCKZT1VNJdOIRJS
	84BIfdG0KF7sEDPRJeYWOfbyWZz9ArqO+XuXgpVvZu/QjQBJ0QrbdBNMlGFNF+YBCW8LdK
	yTJUS5OaZlKre2V5OFl4miytF4NSSbs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGRrDED2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62C5F618AE;
	Mon, 23 Nov 2026 16:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C8E1F0089E;
	Mon, 23 Nov 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451048;
	bh=QZXIFYILtCNn6BOcPijM59Qx4+riXxSWUomOV63QZGA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XGRrDED2jEpYvgE50oiY8fPCgtnMvmLiEjkzS9FnyjwWlK9puHJ6oI7nelee/TFeD
	 lS1P04iIZVUe4XuZ6aRXAsvEiMnq4K4BOVyDge/J9mFHykpnlc6oIgtBnDp/j/fiZh
	 quzGh29ASYGTa7s1f3UQwns13EGVLZ4dveF31N4N07R3HzQjlxL2KuI+vVfxJ9VJ/+
	 1dPbAxOVEL9ztnZEgWbcj5zeFbf7zg5vZVytEaiT4OAqAu5/YHjMMhuHwykzZb+22g
	 H6OMZuUYsYWivzO6wTf7DtreT/FA6O83v58iowhWEzhtkThRU8EzfIcAF7d9G01N67
	 rySgow1eEa+KQ==
Subject: Re: [PATCH net 3/3] net: multicast: account group and source
 allocations to memcg
From: netdev-bot+sashiko@kernel.org
To: x-professor@outlook.com
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 16:24:06 +0000
Message-ID: <179545104659.3135.11573235607470978138@kernel.org>
In-Reply-To: <eabf67fe94dc239f6cc59720e8468f2bf9b4cd62.1795102467.git.x-professor@outlook.com>
References: <eabf67fe94dc239f6cc59720e8468f2bf9b4cd62.1795102467.git.x-professor@outlook.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: EC5C5180003
X-Stat-Signature: xywun6q95xe1yc7qqfupoykkt3t73fis
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795451048-89067
X-HE-Meta: U2FsdGVkX1+4xCvivIGkOMAMn74Z9mnP+I6aKZfOZY6uebgr0BD/TA6mjcE/AEeecJKIFdRr9TrujMQRvbyJMbID+dHmzeym1W+4g608KphU3fprKKiM7Wf5TJWTpLyuCaS4rK9MyAju8M4PL2xM8N72j8pG8UyXpY8WRKI3SvlfPcEJ8fQXkV+Aq8cCGbK3+ZW1S0N7KCC+h5iw2SsWB0IiahLYMCyIYHNp+1S/X4XEur9Ur0nSWeryFhYLGDXO1+pWQ09f1JB8Tmb/p5Yn2p0zf7ko9Cxlzl+MRinUPQgjaI5JIc0ZpWNsiXJrehGnR9HZKcwUwXiLbCEtlQ5N4ELpvB7Awkqx1PaZrBXpuaktwk/2d/9f25teTbtBZ3SFY2W+2ozE0rYMCmBHIGtM9XedSrfZoYnUfMt8mR4c181bhs1WEAwIXBwdqJXxRevqbA5bX3sD55cw7JpycUHpGqW+vOdnGbQ5/3S+qs5six8Juou2mWAfN+v0HgA//9WuFha6J77ykv6C5q6cXTfAyoHEigN7C49d68yEcF53v11SUkFPAZ1t/Tnw72lF19+fdrTP4ZSqaoui9yzxrdvqmmYwZFjfq27FWJdky+SRMa0BD1U2qvgpkSQY7ZJowEoUsDQLGoCM3zSRJAsXTUIG+pgC9FP/APLMuo9iUwlwEK/TsMIGK+iND4yjJlDrTaxBbNq8w5fzuA7PwJj9MLyu+JtuRRqFKo6+I7SIpvYDOzESEUd9+4mM4nxYHrgIL9EdLLBWtcxEFLwuLkoWtgNFaDj73YYOT9aVX/RWNuIuzKkeax22uSJdQNaMEuf6x1+IjBRV+JglIg2kJOysIrgzOENYwCvcmkbuh1cbCx3056buTE9/KBRy6ioibJpd8Prd3tdWYyKujV5T+7IliDQSG9N3fYsoYEoof3SgNz4Lmwpk3XaKEa59DTJfpE+bX8xH0sxm6J2TVkgSCCSWFPV
 jtNtvr4X
 GbEel1Pzl3iMuIceT/Hp1YLaE4i206f/bgY+ZwKiz8nAXK+Uq10KB358vJqgXkW3goSE3EmcaysWOin/0dAgPvSEMfrfrj3eY9MkeTOeVVFrK3silwKnVQ8fhOL3yC5b6SVkzJFlMt6sgvP8zhGetUTpnlCB5DQRTP41URZuIxvLf1EaCaslA1ST1e3NTh32LrE8u146EZgdQz9W8Xp1xlpL45jm7BjtcE9FSNBG9r4eZIRCzwYJjTYfnduBtpPXUAZBjFDaceJC46hC5ymgGhU0bSEtpYFzJHscT1GpnejXpWVdWudxQ+qqpIWmWOHNaXkjgxMvBcQuGYvRgMfvjNoqNCJjAgSlfQfB6HZiG4rzpl8NVItTN8Vm5W53pWEz/2kTVV6VfIEDUzvsSYhYQTvu43r1pGJGnXBJ+u5vdh6xMhbrh8BE6VtP3IlyZOcq4n9wbqXVPZi2TYSV9DE3sgiU3GUycJOUkYQmr1qV9PrS+PaZ5sm+3BDIUZ1o+02erh1BNxUdFKevRdpiKt8zLOE1ClNwD1wR57XCX2f4C60POh0wz6bpLHsGgioS1pZUhlJ9HBVY4zsffHAocwRA5Mcps5eR4J1BIa7zupkCclL0yl1gwCqJNWZqGvCDNT1vIXGddZkL9fdDJbFVUEEsQDPL0km8vdOL3P4un9f+0gw6H0t9jQtxWMU6M4nB1OIKASKlp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix leaves the IPv4 device group records uncharged, even
  though their IPv6 counterparts are now charged.
- [Medium] Several IPv6 allocations whose failure is always silently
  ignored now use GFP_KERNEL_ACCOUNT, so they can fail on memcg charge…

--

net: multicast: account group and source allocations to memcg

This commit adds memcg accounting to the IPv4 and IPv6 multicast source
filter entries and their tomb records. It also accounts the IPv6 live and
deleted device group records. IPv4 keeps GFP_ATOMIC and adds __GFP_ACCOUNT,
IPv6 switches to GFP_KERNEL_ACCOUNT, and a gfp parameter is passed through
__ipv6_dev_mc_inc() and mca_alloc() so that only socket joins charge the
live IPv6 group.

> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index ede1f0825bad5..e7afe61871132 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c

[ ... ]

> @@ -232,7 +233,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
>  	RCU_INIT_POINTER(mc_lst->sflist, NULL);
>  
>  	/* now add/increase the group membership on the device */
> -	err = __ipv6_dev_mc_inc(dev, addr, mode);
> +	err = __ipv6_dev_mc_inc(dev, addr, mode, GFP_KERNEL_ACCOUNT);
>  
>  	dev_put(dev);
>  

[Severity: High]
The IPv6 socket join now charges the live ifmcaddr6 group record. What
about the IPv4 equivalents?

__ip_mc_join_group() in net/ipv4/igmp.c still creates the live ip_mc_list
without accounting:

net/ipv4/igmp.c:__ip_mc_join_group() {
    ...
	rcu_assign_pointer(inet->mc_list, iml);
	____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL);
    ...
}

____ip_mc_inc_group() then allocates the record with
kzalloc_obj(*im, gfp).

The IPv4 deleted group record is also left uncharged. On leave or close
the chain is:

ip_mc_leave_group() / ip_mc_drop_socket()
  ip_mc_dec_group()
    igmp_group_dropped()
      __igmp_group_dropped(im, GFP_KERNEL)
        igmpv3_add_delrec(in_dev, im, gfp)
          pmc = kzalloc_obj(*pmc, gfp);

Its IPv6 counterpart, mld_add_delrec(), is switched to GFP_KERNEL_ACCOUNT
by this patch.

These tomb records stay on in_dev->mc_tomb until crcount counts down
through IGMPv3 interface-change reports. crcount comes from in_dev->mr_qrv
or the per-netns igmp_qrv sysctl. igmp_max_memberships does not limit
these records.

Could a user namespace root in its own netns raise igmp_qrv and the report
interval, and then join and leave distinct groups in a loop? That would
pile up uncharged ip_mc_list records in the same way as the delayed MLD
join/leave reproducer in the commit message, which this patch fixes only
for IPv6.

The commit message gives this reason for charging the IPv6 join:

  "socket joins already propagate allocation failure to the caller"

That is not true for IPv4, since ____ip_mc_inc_group() returns void. It
might explain leaving out the IPv4 live group. It does not explain leaving
out the deleted record, because igmpv3_add_delrec() already ignores
allocation failure the same way mld_add_delrec() does.

Should the IPv4 group records be charged too? For example, an accounted
gfp could be passed to igmpv3_add_delrec() on socket paths, and the IPv4
join could either propagate the failure or force the charge. If they are
left out on purpose, could the commit message say why?

> @@ -770,7 +771,7 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
>  	 * for deleted items allows change reports to use common code with
>  	 * non-deleted or query-response MCA's.
>  	 */
> -	pmc = kzalloc_obj(*pmc);
> +	pmc = kzalloc_obj(*pmc, GFP_KERNEL_ACCOUNT);
>  	if (!pmc)
>  		return;
>  

[Severity: Medium]
With GFP_KERNEL_ACCOUNT, can this allocation now fail when the memcg
charge fails?

For requests without __GFP_HIGH or __GFP_NOFAIL, try_charge_memcg()
returns -ENOMEM in several cases:

  - the current task is an OOM victim with MMF_OOM_SKIP
  - passed_oom && task_is_dying()
  - mem_cgroup_oom() makes no progress

The relevant check is:

mm/memcontrol.c:try_charge_memcg() {
    ...
	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
		ret = -ENOMEM;
		goto out;
	}
    ...
}

mld_add_delrec() returns void and just returns when the allocation fails.
In that case no deleted group record is created, and the MLDv2 leave
state-change report is never sent.

A typical case is an OOM-killed task in a memcg that exits and closes its
multicast sockets:

ipv6_sock_mc_close() / __ipv6_sock_mc_drop()
  __ipv6_dev_mc_dec()
    igmp6_group_dropped()
      igmp6_leave_group()
        mld_add_delrec()
          kzalloc_obj(*pmc, GFP_KERNEL_ACCOUNT) returns NULL

The tomb allocations this patch changes in ip6_mc_del1_src() and
sf_setstate() look similar.

In ip6_mc_del1_src(), when dpsf is NULL, psf is still unlinked and freed
with rv = 0, so the source removal is never announced.

In sf_setstate(), this check drops the record:

	if (!dpsf)
		continue;

The IPv4 tomb conversions avoid this, because GFP_ATOMIC includes
__GFP_HIGH and the charge is forced.

mld_add_delrec() also hardcodes GFP_KERNEL_ACCOUNT, but non-socket callers
reach it through igmp6_group_dropped(). Examples are __ipv6_dev_mc_dec()
called from addrconf, ndisc and the bridge, as well as ipv6_mc_down() and
ipv6_mc_unmap(). On those paths, isn't the deleted record charged to
whichever task happens to trigger the operation?

That seems to conflict with the commit message, which keeps GFP_KERNEL
for:

  "ipv6_dev_mc_inc() callers such as address configuration, which may
  ignore allocation failure"

It also says:

  "A group created by address configuration stays uncharged"

Would it make sense for callers to pass a gfp into mld_add_delrec(), as
igmpv3_add_delrec() already takes one on the IPv4 side?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795102467.git.x-professor%40outlook.com

