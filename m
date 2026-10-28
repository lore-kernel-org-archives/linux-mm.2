Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB61A606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P+WdPRe7
Received: by kanga.kvack.org (Postfix)
	id 0CBE56B0948; Tue, 27 Oct 2026 22:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D976B0949; Tue, 27 Oct 2026 22:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5166B094A; Tue, 27 Oct 2026 22:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE9A56B0948
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:21:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69BBC1C435C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:21:22 +0000 (UTC)
X-FDA: 85370433204.09.961B7D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B85731C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:21:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P+WdPRe7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793154080;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3d7IuWyLJEgj1UrdUlaZ2L9R7FsoPWLaaJOXVBI47ak=;
	b=QVU/bxmcljKjAhz/jRHmy0pbsQXoTh8KEiNaCktxeK5zTArQfLLTDko41RxvC8qOTcbpkH
	0/bDrXbLgZ7RSGfrZRTPnpVLay/+8CkjAqckrZNOhBGOWZoVtBXw4xtIwRYlpx7Upm7yEL
	0TwdztZm/wMzMtVwC8dqfaZ9MiAkg2Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P+WdPRe7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793154080;
	b=UZO1jeQZTYNwSpYg6/9+jvvIsbqUPnIXIO9fakzRe7mqlsoyB86C0KsJ00g7UPz/ohQXvP
	RE7vdVfzjdbb/Ql+oc8AY69GjFSKSSE/ngd3iONTS0V+US/ogyzTncvwdqTsYzzXF85rK/
	esBRb4KZD77URw5MpOxuSMLV1d/euhk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 927C642A4A;
	Wed, 28 Oct 2026 02:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AA41F01825;
	Wed, 28 Oct 2026 02:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793154079;
	bh=3d7IuWyLJEgj1UrdUlaZ2L9R7FsoPWLaaJOXVBI47ak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P+WdPRe7u/2yoMG7IPPpkBYAqQ4OXV+0tHz0SNymBLOld6L6rkiEZb1GN2RaaJesV
	 p7XzrLmoNt5/J4gB1MC081YBEiarPNmBbAmLE3X0haUWVJPdUa/oChiqQHgkH3VjbN
	 coM6gqWNyucCUWtu94iUfBxBnew+PpJ4OvbsJl0XlSoJJ5YXBwX4cDS+yCHBKMVdR+
	 738pP3Io2lqwx05nCbT/m+BQ/8fUJv7unU4vRSBcywNXVKFdeRYicI4MIL/1W9XYJn
	 BYshzUsIwSIoTNfB9QXAnEQ4xnqNH1+RTQC5+jld+/yEjQ2m3Cj726vputvxNJuYTw
	 mzqizmSX/IlUQ==
Message-ID: <sashiko-outbox-187340@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/mglru: skip oom killing for high order allocs in
 kswapd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bingfang Guo" <bingfangguo@tencent.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Kairui
 Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "David
 Hildenbrand" <david@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Yu Zhao" <yuzhao@google.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com>
References: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 02:21:18 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B85731C0006
X-Stat-Signature: njmxcx1os91cp8n9iq53kb3woaz4wszc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793154080-265837
X-HE-Meta: U2FsdGVkX188Obe7nmcDeHMX+eCwOY42Bl8RsooAUfz3XC1A+x8YBBmlVaxhTWuqsu+CNWrEFsryhNM0ESMZB7Dx9NbM3A4sUP8zlkEAxzg0BccM9sqeRJQhljN5tU1Hf/sbadYOlhOW+Hw6lp2oAcCtt6QoAi6/9mFhCoPaQ0mbArOsaDRxT4qcRNNWrXYREQ4h3TilJd4r5LTT0rSynDD8zIwfMNySVhPos8Ujtrqz+5Qqpu1491ek78sVv4rfVmiTgA6Fv1z1NoGKwodjJyopJIy6eXwCxtR/BvG3cVQWUtC6e5cDzRkOkCPtDhQ0oX0iWKxkDjyg9w/mom08coosO19NGMM5+cFBnzA3sQS5yCNub+WnYZUiNMjazucCBsGLDhYJKpA+wdSjbqSpPqZKAYVZg3IX/KQCBal8wKa9B3F+i+4tT1TT4hw1tCts6P3U2Rvw5UIvjNZrigGiRyczPHNWphZZc4k1K4pVhk71yw0ZkIEq4J1bVNV+3H/s1AIQgv+D5MllE7XwLCIwt1eA/0qjB6GKm77Gz8g5MQNWftvzPwGWbqV268b6oIHKP7j+AhjVissvdtbdapGND0ItgnmHdjUc64aQ20i+aK0saZxbL+4BbXL0Bp873xm37y6GaDOLx9g9y4j6k/2Mul1PBbH9vdHujISrGgAUlnSDABW33qcYzjY61dQMP/kulaHazpqmTh/zq8yZ3wONn7An+7lGObmTHUXztOzeW2ynH6ZsK7ViLGtnrd88nq5dCqW4CGVGImS0Y5j/dZL4+oEKDpuOa8ROQyRyraWc5RxIY/vcnGRu/PGMu7LvD4JGnkT7hH9/CeEEy7LXghJDkNrS8WsNpa69Nd2GtxNLI8M1/39eUn6tRp6oy9MhzK7wJm5bNJsGjk1pamPEdbTNf8ym1EmKHbrOIOJZXMornsoykF84ymBkJV1mFMx3mIK6M8h/3VqO/sMNhqOUKGQ
 /Txot14O
 FIVisndRZadvliR2TNQRSB4iW0XL0Fkigo6XYdvj9gVvVQEzfh0a+G2C1eb2Bnkvu9PcC/dlPPVO/vrisZdRmKMbe6S8Z1WFfME7ernLPqr9ynu87AlR8PbsU/0Z4b7+IdIv7uUubY6FDclz5OVKLHG5gSfqYoWYaoIVgIQAfeHUtGRWA8EnkhJU7ierw17QJpV5td/mrmIs8t6kwyWzgwcYtNa9Bdaw7NepK0U9ag8/2PRo2OV67ZWCSXHUnS8Fx3/9LfAX2b+zevKvtDWIAvpo2TSEzqI4iXobW6CiqmWqQlMpOIgJLOSBKTYlh8rcLs/q+xKsFS6rTaTgry0rhEC+ikrtnR70h7Vy4bGSxnEf8yO+wu9iZZ0goXy6/BPvKaW6wGMoSFJriOgH+C0jFv5too1v91U2yDcRtXtxeTqZD5XwPDTEtL8GrB7c/G0MxEG6RSB0YXuxaNfzFoTd9QW5cLEjUR42fkZWffL+y+oq0MgusItrvCMbwpwn14zltVMFptMoJqftr2nCRDRwv0Fz+Pl1xOBMrh98XFPXSBzpGWE/OBx2J26lquOZ4x5eBisCMBJKOOe7lqsJySmwv0PwjHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/mglru: lru_gen_age_node() still OOM-kills for order 1..3 reclaim
--

commit cb44e931601f0546134f19e7185758d84dbc23fb
Author: Bingfang Guo <bingfangguo@tencent.com>

mm/mglru: skip oom killing for high order allocs in kswapd

This patch skips invoking the OOM killer in lru_gen_age_node() when
sc->order > PAGE_ALLOC_COSTLY_ORDER so that high-order allocations in
fragmented systems with MGLRU min_ttl_ms enabled do not repeatedly trigger =
OOM
kills from kswapd.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce83..b32777468ead8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4407,6 +4407,12 @@ static void lru_gen_age_node(struct pglist_data *p=
gdat, struct scan_control *sc)
>  			reclaimable =3D lruvec_is_reclaimable(lruvec, sc, min_ttl);
>  	} while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
> =20
> +	/*
> +	 * OOM killing won't help high order allocations. Skip and let them fai=
l.
> +	 */
> +	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> +		return;

[Severity: High]
Can kswapd still prematurely OOM-kill user processes during compaction-indu=
ced
reclaim for orders 1 through PAGE_ALLOC_COSTLY_ORDER?

Prior to commit 30d77b7eef019 ("mm/mglru: fix ineffective protection
calculation"), lru_gen_age_node() skipped OOM kills for any non-zero
sc->order, matching should_abort_scan():

mm/vmscan.c:lru_gen_age_node() {
	/* check the order to exclude compaction-induced reclaim */
	if (!min_ttl || sc->order || sc->priority =3D=3D DEF_PRIORITY)
		return;
}

mm/vmscan.c:should_abort_scan() {
	/* check the order to exclude compaction-induced reclaim */
	if (!current_is_kswapd() || sc->order)
		return false;
}

In __alloc_pages_slowpath(), any order 1..3 allocation with
__GFP_KSWAPD_RECLAIM calls wake_all_kswapds(), even when the caller specifi=
es
GFP_NOWAIT, __GFP_NORETRY, or __GFP_RETRY_MAYFAIL (for example, multi-page
slab allocations in allocate_slab(), network fragment refills in
skb_page_frag_refill(), or large-folio readahead).

When kswapd runs balance_pgdat(), it sets sc.gfp_mask to GFP_KERNEL (losing
the original caller's GFP flags) and does not run compaction inside the
reclaim loop. In kswapd_shrink_node(), sc->order is only reset to 0 after
reclaiming compact_gap(sc->order) pages:

mm/vmscan.c:kswapd_shrink_node() {
	if (sc->order && sc->nr_reclaimed >=3D compact_gap(sc->order))
		sc->order =3D 0;
}

If physical memory is fragmented for orders 1..3 while order-0 watermarks a=
re
healthy, and aging pushes all memcg generations younger than min_ttl_ms bef=
ore
compact_gap(sc->order) pages are reclaimed, sc->order remains in 1..3 and
lru_gen_age_node() will still invoke out_of_memory() on each priority step
until all processes are killed.

Additionally, checking sc->order after the mem_cgroup_iter() loop means
lruvec_is_reclaimable() is evaluated across every memcg even when sc->order
causes an early return.

Would initializing reclaimable as:

	bool reclaimable =3D !min_ttl || sc->order;

at the top of lru_gen_age_node() restore the original exclusion for all
compaction-induced non-zero orders and avoid the unnecessary
lruvec_is_reclaimable() checks (while still allowing OOM kills if kswapd fa=
lls
back to order-0 reclaim in kswapd() when order-0 watermarks are unbalanced)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-fix-mglru-=
kswapd-age-v1-1-b1ffdec4ae52@tencent.com?part=3D1

