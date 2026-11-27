Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B889606A336
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EuaFTw/m
Received: by kanga.kvack.org (Postfix)
	id 461756B05B4; Fri, 27 Nov 2026 08:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439966B05B5; Fri, 27 Nov 2026 08:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376806B05B6; Fri, 27 Nov 2026 08:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 066D36B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:46:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44D028035A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:46:14 +0000 (UTC)
X-FDA: 85481023068.22.08CB319
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8A8F340017
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:46:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EuaFTw/m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795787172;
	b=BoQ0LtkpgTZJiQVmSiWtszfp+Lg2wcoXmPjRRCsAaVKsyiXJ6OpotKcHNgujWzdnGpFjuj
	lXRv1YXL9uyX/9iPLYyaBEc32j5vxLSpuVMdTnU/9lnK8VURwkbPublUbUgec2I26fOKMv
	yjVVk5EetuA71mddXD0zPIw76nCTf+c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795787172;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrboHXR9k3R5ZTIl0xnqUJBd88EpV7GBQtig56U+XN4=;
	b=Xl+iIpCfmmGbl8peuwhdvl7XgsL8d1H4RJk23mmaLB+8hqbVjEw+HBEYG2el1TI66DV0dm
	ihNeMaZMDo2gOvJYevImPoWc0N13fGbkoDvB0bJ3r4ZxHgmi0qZa1nKXCGbe79gEPkGC+t
	fSy/wFnVHi+7thV5jhGT0moC/fZFP1M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EuaFTw/m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D323403D1;
	Fri, 27 Nov 2026 13:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C741F008A0;
	Fri, 27 Nov 2026 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795787171;
	bh=xrboHXR9k3R5ZTIl0xnqUJBd88EpV7GBQtig56U+XN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EuaFTw/mGYQL2/05CbrkWyRgMBbiDWj9UOiQvddq3AJ4j7Hl5+Q47lP7dYEZ03YOx
	 NDSKg8yNY2xKeasTib39XKFEklavOkRFFfTbopUMPrttMM6QtuAOnFdRdTkqn2P9is
	 JP0I/KuMDAz/xJ5VePVHbwi7K1+7tdlSf/bmCbItxElk48g5JMziDEQaTGXMGCu06j
	 JcquGad4zOc1T+F8Cpgll0uA7Ww0dZgzUzJL4+VpSMJd6RTl0HBrBCXQ1/u3flZSRb
	 Fz08WMV9praCyjq8ScPS4/K5Ok05p6+e7r1dqUGvXVzXe0El9IX8/E63wiUVmoKpKM
	 unSZA90TldV8A==
Message-ID: <sashiko-outbox-237513@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/1] mm/vmstat: decay pcp->high of isolated CPUs
 from vmstat_shepherd
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SW9udXQgTmVjaGl0YSAoV2luZCBSaXZlcik=?= <ionut.nechita@windriver.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Suren Baghdasaryan" <surenb@google.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "David
 Hildenbrand" <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Huang Ying" <ying.huang@linux.alibaba.com>, "Marcelo
 Tosatti" <mtosatti@redhat.com>, "Frederic Weisbecker" <frederic@kernel.org>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev, ionut_n2001@yahoo.com, sunlightlinux@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20261126134410.17447-2-ionut.nechita@windriver.com>
References: <20261126134410.17447-1-ionut.nechita@windriver.com>
 <20261126134410.17447-2-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 13:46:09 +0000
X-Stat-Signature: kfnh861q1fjksyayihienyjfje8tmodp
X-Rspamd-Queue-Id: 8A8F340017
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795787172-387717
X-HE-Meta: U2FsdGVkX19+7JeH6NuwV5v6L0ZF2T0OlOY9AXNzBK46Ss3I+ERr20xQHEnH32ZvynE2EKk/WYp3hhj8UvuV1ejoklcJi9pGant20mlzy41dRi2I7BHHVfV0G/SwXm7oKJUtxzwDhzMKxjjdawk1XapJsNvr3UFfyIv+TQQfGM2hnm7C782HIH4+IEbyPetZ8ckClf/058woLIwTprMW1B8qw5vtyzJCqjNz9W/NwpCEet6lKbZ1lM3S8+/k9WldIMu3ZW7tVlIjRddEjndj+615ATVMyOHrAqOSJTl5FT1YNT8BJ0gioyS8NQpL2o3lQxiDrNPj590GxNu5h5zq3idBu7NHWqbEKYQLWCgKZmshPu0/lyjjxsjeDjvLfv0AK7C+7ZDTgyu1HFGkdQUYn6EN7IlGjUC869SOwATDvhGknS13zv4JV5wcuLUaLNUu9VRlkkRMBheGewkUBS+r0R3RutVHFYxOYqlX+FXJ00afKP6R1RQ7VXwNXGP4k9GMUqWz5cw9VxUoEW6BAX+ty8s2BEHVru7df2UQl73ANPF+V0wdBfueHLAWn6xQVP/K4BSPgfL+VGMhl+3hrJzV91Mq08mRlkIYTTGQXPHjMXo3miX0t6b2oqZ1f77wPHMupbwPRclDgnz2GzygXubGUQpe0rR7urKvVkkhzKGI31j5ZJ+zvpupW3l5ey52c89FrHmdzZMC5bLaj5fFSe5NNLjExgksxP0fqhiZo/72G1eWJ/xRArvw0d82U7ofy7dkogD6tu9cSuU0SpNGv9VgftR32gjU4YsV493sQFSZ+lMb05dEsH68k0EBUgBDYAj81CUb0QA/fOlG4dGnzgb3b0t90YnUco8rr4fEnY0IHEpzqxNJyXExU2r7Hw0r+SAAeVYmjuUQQYvSG+NCWJpyKiBXq5zBntWvungi4S8IdBxxqHZSKDLbUVNySTrmLo9rtmPpTbWSBuqolD3e5x6
 WENLg8N8
 dPS+z0+SBbdDr1TFyE4D0+jKisr3fPg5nGrl3RNz0sAaZyLBTuJLS3FVETPJgJKKIzRwBcVhbuNb4SWacd7zn/Q9YUHye++bkCKD/qEb/2A93l+7hbOJO6fLLR3Gk8eDH4aUglSe7W9gmPk70O+1fhYHLzI9k0u9BAeBnNNi8aohdPaeFzSbtDzAL1bfCufR8jxGtg01lGDcSWAc48wQRoSrNApg+F1r6Yuoc+K/7DjKMNpZw4gj0V1J+Dnbd1+jIXV6ee9JhXOV5tFJNj0HDMqW+BIobSQL14HeS6J8o3l4hCpw/pcR5cbB8wITwgDRWpEYscpTB/xbFEWzSdM9MDl5rY9JBDdflnsnpEx4KMAVP22zp4iW6DuQ5hxMXcJuXzN3lMPrB5R1Eh2CcW+oCu3QX3FwvsdLYHge5bBZW1OAgUy5VjLlHXTI2wYogaVhr5jB8I5lzCEG+LbD0bsMzw+Cma3rPHiP2ux67MCa9ERroBv1kB2K9aoF6znR4NzQLTzXmjKDbEQCmzO1Nbti+ysgAbd/WygrPUagGTQHNJ9UqSeD20W+LJsteD6v5WJOL9OuHsDnBCf87Hf6wCsx4t/8rzrvj7yXSKpyhvJ0UTE54qKyujR3ORbJTJd3DCWPQIIgWDfyCmHC6QivGwarzcqfe0rtv+oYFnyYBoLhr8c84FxR+mr8sH4rwvstH951Nfw53yk7h+ILyVvKV4+VdEmD4xtajIrxTfAOq4oB4ty1SHd8iM99ngIkVYf5tlPLbyBwTnd+0TRfSLGwWClq/aN2TaRfPoBmPqIXtf1oNPabACi9AzenEOz+mO1zYlN77KkwMddKWeR3k1tprX1ZK8X782CSWqmHj4Ceice4z0alWOP+ykAjsqBl3wJqXU99qycx0/hdWom5JHzOZzs1tq7gdksh9dvhGwy3uUiyFQgL3VyfmboWQdD8keg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm: stale drain count and extra lock bounce in
  decay_pcp_high()
- [Low] mm: data race on pcp->high_min and pcp->batch in
  decay_pcp_high()
--

commit d20e26af9bbff82ca7f7d0c2d4fea5dc5d2bd609
Author: Ionut Nechita <ionut.nechita@windriver.com>

mm/vmstat: decay pcp->high of isolated CPUs from vmstat_shepherd

This commit makes vmstat_shepherd() remotely decay pcp->high and drain
excess per-CPU pages for isolated CPUs, acquiring pcp->lock while
adjusting pcp->high in decay_pcp_high().

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ce44b8fc45aaf..aa9904eaf6e62 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2586,8 +2586,13 @@ bool decay_pcp_high(struct zone *zone, struct per_=
cpu_pages *pcp)
>  	int high_min, to_drain, to_drain_batched, batch;
>  	bool todo =3D false;
> =20
> -	high_min =3D READ_ONCE(pcp->high_min);
> -	batch =3D READ_ONCE(pcp->batch);
> +	/*
> +	 * pcp->lock is taken because the pageset may belong to a remote CPU,
> +	 * see decay_pcp_high_cpu().
> +	 */
> +	pcp_spin_lock_nopin(pcp);
> +	high_min =3D pcp->high_min;
> +	batch =3D pcp->batch;

[Severity: Low]
Should pcp->high_min and pcp->batch still be read with READ_ONCE() here?

pageset_update() updates pcp->batch and pcp->high_min with WRITE_ONCE()
under pcp_batch_high_lock without taking pcp->lock, so plain loads can
data race and allow the compiler to reload them across the comparisons
and max3() / min() calls below.

>  	/*
>  	 * Decrease pcp->high periodically to try to free possible
>  	 * idle PCP pages.  And, avoid to free too many pages to
> @@ -2601,6 +2606,7 @@ bool decay_pcp_high(struct zone *zone, struct per_c=
pu_pages *pcp)
>  	}
> =20
>  	to_drain =3D pcp->count - pcp->high;
> +	pcp_spin_unlock_nopin(pcp);
>  	while (to_drain > 0) {
>  		to_drain_batched =3D min(to_drain, batch);
>  		pcp_spin_lock_nopin(pcp);

[Severity: Medium]
Can dropping pcp->lock before and between drain batches without
rechecking pcp->count - pcp->high over-drain the remote PCP list and
spin on pcp->lock and zone->lock?

When decay_pcp_high() runs remotely from vmstat_shepherd(), the isolated
CPU can allocate from PCP or drain its own PCP list in
free_frozen_page_commit() while pcp->lock is dropped.  Because the loop
keeps draining the stale to_drain count rather than re-evaluating
pcp->count - pcp->high under pcp->lock, it can drain the isolated CPU's
PCP cache down to 0, well below pcp->high:

CPU0 (vmstat_shepherd)            CPU1 (isolated)
decay_pcp_high_cpu(1)
  decay_pcp_high(zone, pcp)
    pcp_spin_lock_nopin(pcp)
    pcp->high =3D ...
    to_drain =3D pcp->count - pcp->high
    pcp_spin_unlock_nopin(pcp)
                                  rmqueue_pcplist() / free_frozen_page_comm=
it()
                                    /* lowers pcp->count to <=3D pcp->high =
*/
    while (to_drain > 0)
      pcp_spin_lock_nopin(pcp)
      free_pcppages_bulk(...)     <-- drains below pcp->high, down to 0
      pcp_spin_unlock_nopin(pcp)

Once pcp->count reaches 0 with to_drain > 0 remaining, the loop keeps
running every remaining batch iteration, taking the remote pcp->lock and
calling free_pcppages_bulk(), which unconditionally disables IRQs and
takes zone->lock even when count is clamped to 0.  Also, unlocking
pcp->lock right before the loop and immediately re-locking it for the
first batch adds an extra remote lock bounce when to_drain > 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126134410.1744=
7-1-ionut.nechita@windriver.com?part=3D1

