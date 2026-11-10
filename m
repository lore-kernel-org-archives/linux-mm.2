Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5FA606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOGLKWu6
Received: by kanga.kvack.org (Postfix)
	id 1F5816B05B3; Mon,  9 Nov 2026 21:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A64B6B05B4; Mon,  9 Nov 2026 21:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3436B05B5; Mon,  9 Nov 2026 21:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7DE76B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:23:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C2CAA036E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:23:50 +0000 (UTC)
X-FDA: 85417613820.19.78B96C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D34EB140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:23:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOGLKWu6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794277428;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+lzFeOLtG99Ghw9rX8G9p1QUCxnDj5eZlO4QzFSIas=;
	b=we80cwOXVbO/9eJ8UlhGzkKIbksoWHVGdTLb/phykxF2wqhLAnaOCSPGX9yTxp6vB9pyN/
	S2athUwEOiCZXKdeYBDkGO5mFBUjUz9DN7q5mNTlTiWWsyNHRdszDHzEA4RWZDlJXzQpuB
	xPwFdcyTjCJgygEJq55CjVLsAXS0C7k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOGLKWu6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794277428;
	b=6/HPvoUO9gvOliOoHHSjaNU0x3LcnRAw0AMjG/n8z1+BOIemSS6e4rS8gaKr9Wr47QBJiM
	4cyYuifaOvYrplCypvWGI5wVl3sJpOJuytbxEWa4/IgWQDdwrgJbvcyCueyxIralHS2Jz1
	QQgSzpEIR33IRLr8Tu4vs5OPtZIfvTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3477C61264;
	Tue, 10 Nov 2026 02:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA141F008A1;
	Tue, 10 Nov 2026 02:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794277428;
	bh=A+lzFeOLtG99Ghw9rX8G9p1QUCxnDj5eZlO4QzFSIas=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IOGLKWu6U2jlr8eViXU1gCgBZA8adj0frtLiodU/busKR5eEm5s6yfDZntS5oxw6c
	 NTfF9gLWvfACN3wq8trUkbz5JkiasKDhu92o9cmXGRd2kHKWedzv84gLjkectZajP1
	 TGMINjX+nnRDMcp8Z9RUAnmT88gYhyBvqtZTmPZOPyuhdfU+//TY0AttNs6DIZJ0fd
	 ocCkl5A3JKkRdJd8WOskeeu2B4AY3n1bGDOxFhOTY7KBvjjIMnT/soj4hny6bpfSNH
	 cHdA+8LpZNYZH3jerZnhS3V+OSgnJpCVH2KMfP2H53J/ZwxcVATC4effDDlfdIm72L
	 IST5UC/5nfBtA==
Message-ID: <sashiko-outbox-206041@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] mm: memcg: read root lruvec stats from the node
 counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>, akpm@linux-foundation.org
Cc: yosry@kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, ljs@kernel.org, linux-mm@kvack.org, damon@lists.linux.dev, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261110015321.611093-3-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
 <20261110015321.611093-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 02:23:46 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D34EB140003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: k11wti69zimjge6hhwap13ar7ekwsd3s
X-HE-Tag: 1794277428-841237
X-HE-Meta: U2FsdGVkX18obAvQb1fB1P2ib2j+ELeIMaS7gj+1DDoRPMDFwAl7GViw2ZE71P2XvWwmpzKrmJNPBTe4LYPMZBQaaDAQA1We8gyBdYJKf34/RC7NMhOD3jsmYa50+7wi3CnpGibMcNg1G70AzupBVmZNzoyKnZQUzyrR6xJANNfjpIlkFJAIN8bFwSLhEmI3uuFCLAjrpqi6MC3Lldfcda0SGeVGHxypGY+FNjfiRd/5d4+P8donuxNJJCnVgtwoE8VAaqTTKile1sUA1jZko3ogat251jB1mrI0OOF4R/wXH3ghMY3vpL7YTE6Ci1Rzebg4y7LbuZsemoBsZtmKZu7QYo/yI9JHBQBD7pf/rEhJ+wj6UyUCN2KqJjHWtbi6u7Afo54LqRjFbbE5si4BDOnuYUfGOmOhZz9ixqp0DxBYhIVfjQcVD5U9X6jPlirGIumfnPIkxhYj9krOUOWMPKl0mg/wfx6ZpgSemVIr2cHMA2pk8WJDQinAqBFZE9uB7DzbxH6HZui7FccjCO397IaeinsPjmVadEiP6/Omi+dMkQdmMo+UYbkncUrnWdf51QZn1ZyO5Hbu4nUpyOAcr2Rk73u/FyKW0lXckRrTT0vFLYUsbBJz8j/DFeJl8/hVCkNQ0v9Ujz2vHxzca4lkNtzyrENpJ3Z/VV9em81lD53RommbwkRaSH5Rrpyf5/g3Z8N0+RV2NkvMOCUzO53eY5P3JqIaa0iHrnxpn1+WFfaJB5KQl6w+85mRTMPsywJXTqY58x+OU1Ar5hEfuaYrEupNo7bHoejblIh+1BRSgln9SHtoBuRpr6yjyuqi2SZY9av9RrsSMWXtI6fVmxEqBwDHkVZB14Lr7hwEUxH1ah7mLsU5CVTrzA99h/WlNF0z7thCwCf+lq4cYh/ELF8pV71Z7aNPy8SwFD0gDn6nhgfi2zy3Mx+q0RQUZ0TxGxoLhakWZrm6DhThGJ9WVox
 Rt8l4hdq
 Qp+9diO6EdDGng3Dl8fnJYi+jsFsnllsZSkgCXn2nLYXjmbd8vyJsDUJs5zAtFxJOp517NsG0whmUpqNv5lhJnunkGHMox48BNGM/C+FsHbybME5KhxxU+k/6OvaqwM/FLlGbeU2UQjGwrLLXqpnY0Jhnw61ZQjG1aDPDl0X6Jqjq/IfsJF+PtkyvHLZatTz3DJ3LFaMF0sJjlQXYtUecHQUzuPvheG+wMCJzNfIPA1NyzYC4+hsKOTV4BR8YYsf4mFc8fzibDSVVJfBDSIn8oRFKf4kqrkX0YXNxWd6ho+d3XDueZEQHd93EnB7RjFVXiCbwIXu7CoGjmdz2wu3cxOrHDG/BifSOzyNH6eJzEXdtnQ8W2Zs6TAbZvowvhEV2kntwtAmerdEwn9rvICNMoJ6hcgG9FH84JvApi+gekiOo9tme0pBO/07vTj3JpsakL/rIUFWYYwt8vy/KCjI4YyOb5vvuDQmOrz0EElHbe0CEnru1+3rxlkO1sbMLhZ4+N74hetD9Gzjjvm0WsMaP3MaRmDKQVpU65Ck7QOcfF+ivjgtzifOyktlHgiRX7rzYpjb48Xru+dSvTipsungmSHWhhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: memcg: node_stat_includes_unaccounted() omits file and
  writeback stats
--

commit d2ba314724a8ba015e3bf2a30f155f1beba25a8c
Author: Joanne Koong <joannelkoong@gmail.com>

mm: memcg: read root lruvec stats from the node counters

This commit changes lruvec_page_state() and lruvec_page_state_monotonic()
to read per-node vmstat counters instead of rstat values for the root
memcg when querying stats that only track memory charged to a memcg.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ebc9330aeae5..2575bf2ba0ea6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

[ ... ]

> @@ -504,13 +511,52 @@ struct lruvec_stats {
>  	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
>  };
> =20
> +/*
> + * Whether the node counter for @idx can also count memory that isn't ch=
arged
> + * to a memcg (eg kernel memory that isn't accounted). For these stats, =
the
> + * node counter can be larger than the root memcg's value, so the root m=
emcg
> + * has to read its rstat value instead.
> + */
> +static bool node_stat_includes_unaccounted(enum node_stat_item idx)
> +{
> +	switch (idx) {
> +	case NR_SLAB_RECLAIMABLE_B:
> +	case NR_SLAB_UNRECLAIMABLE_B:
> +	case WORKINGSET_NODERECLAIM:
> +	case NR_VMALLOC:
> +	case NR_KERNEL_STACK_KB:
> +	case NR_PAGETABLE:
> +	case NR_SECONDARY_PAGETABLE:
> +#ifdef CONFIG_HUGETLB_PAGE
> +	case NR_HUGETLB:
> +#endif
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

[Severity: Medium]
Should node_stat_includes_unaccounted() also include NR_FILE_PAGES,
NR_FILE_MAPPED, and NR_WRITEBACK?

For NR_FILE_PAGES, swapcache operations such as __swap_cache_add_folio(),
__swap_cache_del_folio(), and __swap_cache_alloc() update NR_FILE_PAGES
only in the node counter while accounting swapcache in the lruvec under
NR_SWAPCACHE:

mm/swap_state.c:__swap_cache_add_folio() {
	...
	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
	...
}

Reading node_page_state(pgdat, NR_FILE_PAGES) for the root lruvec
therefore includes all swapcache pages, which inflates the "file" counter
in the root cgroup's memory.numa_stat (double-counting swapcache alongside
"swapcached") and causes it to diverge from memory.stat even after a
flush.

Similarly, __folio_mod_stat() -> lruvec_stat_mod_folio() updates the node
NR_FILE_MAPPED counter without updating memcg rstat whenever an uncharged
folio (folio_memcg(folio) =3D=3D NULL, such as a driver mapping or a
root-cgroup __GFP_ACCOUNT kernel folio) is mapped into userspace, and
nfs_folio_mark_unstable() and nfs_folio_clear_commit() update
NR_WRITEBACK only in the node counter for unstable NFS pages awaiting
server COMMIT.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110015321.6110=
93-1-joannelkoong@gmail.com?part=3D2

