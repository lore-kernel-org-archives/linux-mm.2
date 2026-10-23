Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155E8606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TSG+aRIu
Received: by kanga.kvack.org (Postfix)
	id 21A366B0BFD; Fri, 23 Oct 2026 18:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D3A6B0BFE; Fri, 23 Oct 2026 18:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D9D6B0BFF; Fri, 23 Oct 2026 18:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA91D6B0BFD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:03:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E46D1A0283
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:47 +0000 (UTC)
X-FDA: 85355268894.04.7022F74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6FA3F40009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSG+aRIu;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792793025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9LNtsxsoCY3Opnhl7Jnadg+6vMuj2DVUVFsrmi6sWg=;
	b=VGHeXdcgfVxDcMDknv5rwgDXv9ig0j6EVpNN0Fha4fdTH9m9eMrvryhyEfm1bhQxYA8/e+
	zUzK4E1dow3/H7ZSrKlV6mZryyHFAgHVUypPecxkdSGSsikG3+89bDBfEkkpON5LVNghvw
	1ftmJh9NnwTGKGjx06R0FxVfH96ptRE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792793025;
	b=e+IV4WbwJAMIVqUtlQ2ryRuj93HGHspNpLgGFekl3nvhhSiQOdkwD/J6iUipIFffdvxNtK
	YFSUa/NaJK4XfUf2U119EvpbVWOyyxyF1tjTdGTpcp9VtYYSETuWCZ7ohxfHVB9L3s+q1u
	e1xN2EHKoGDb5OHXWYL84vYlJwq2ziA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSG+aRIu;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB76F4403F;
	Fri, 23 Oct 2026 22:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7674B1F01825;
	Fri, 23 Oct 2026 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792793024;
	bh=G9LNtsxsoCY3Opnhl7Jnadg+6vMuj2DVUVFsrmi6sWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TSG+aRIuQIZgMhJbEmq6Cwx1BBFurkRApuxdmdKZeE4btj7u0hn6gRXeU1HchCdC6
	 Vwjx34kBgvTEltK5jwPf25cVXfV/7UwTMrMp7rKwpgbO9rz7tvtri9hHEmhjYYl8rt
	 cgkBBQTWBtUTKtZ7fu2JSqa0eOWcs3yAOsM/d0BinJ+HMoO+pwF4u3tXODLfdFNBxz
	 7HMY+8LhDxfiLLurEECrEkNeC/YhrBL6mw5DGmEVwj4KnktfGpSrG5UvTTdlmHKCna
	 /SCa4UAXOi6nGvWR8Ore6nnCGYda1AKPJYqxcAV4OWSQmBgvd+ufr1jIHE8ppYAG6W
	 X7Rn4O3X0153Q==
Message-ID: <sashiko-outbox-183280@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 14/14] mm/mglru: Avoid scan anon while swapcache
 is low for GFP_NOIO allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, kunwu.chan@gmail.com
In-Reply-To: <20261022220203.91911-15-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
 <20261022220203.91911-15-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 22:03:43 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6FA3F40009
X-Stat-Signature: s48ddc66sh6q3jxzjwdhp1m1t6z199qr
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792793025-16847
X-HE-Meta: U2FsdGVkX1/tw/pn5LATbgbWpnySub5A3gjnV4v9bSHbJ+pZGS5IWST11YLrNNlAYL9sEqXgnYne6kvUWJ18P/pDT9objysbWq13Y0H+rx8BOyrBrYkq0kn8yzRMpBBTOsBI9MJei79p2kW7VP5UlahUQdbyRkehlOxM2V2sIhNUhbGLKGVBLEePeys3mIxGH52sXKCPyVpo8uplBChs2ECYTFa6MUvH47HX5N57WVYVdTJc5IBrepnia6pUxIQc9cVKUsXmhq2iuaqv7/WoyCG66luqiuh77boJjhyvDzKz3U4BukuoG9rGck471413r8B88fMztz6BZ59lnxFm36v4ZQ99YlvlF1M+BGKW/Cb2+1wuItUwG23wEBENG/1mGs4/BYdpACbNTFKSxcoCG4ddYof3oDrSPb4rjgaD/NbsRrDgyxwKs+pRw/8eUj84QaOzOzZNvAkc27swCYppnTic7JgHTivoS0+l83AqxbreLLkz96ZZ4ZBtr3onZZ+HZpEKp6FJGOTBM/3z6OlAgaGH0QiZtNJTUCeW9rjLo0E1OnLbu9mwChLSDhLt7B4rC8UW0Nwf7BoS3ijUDEQtzzMoSlJ9uRgm6DEyRd164dP0lTOUqa7pcxM3AsCtAzuO5h7q4vx86om/Znll8nbVbYn9ZgRBTUOrkZp+yOWyu9iypSkGjRRZCtk7Bj7/B1BmzJk65LP7p9lbV76dbof19yi+QjMqmRCutW1GR5E1RYXBhLsE5q4ztmqhjhQB9NHKRMgqCgRLLTlLa4LVtTfwta+fZ3xnKQEgMPPjYJVrM3H48dwObxNT3kGYzM/ylhzwtuXVcaf7cH0OfVjxrQjEuNNpZNTnxP3pH2IwxS0gU94rsilSNBrSDSkrhFfdg5P/bJVkgtXg74IbDbVCgaUZ3oSngYmHq6iIpNpSl253lrbiIkpx5IgSOZlK7rXYt8l4jfgCOQigpbon6aQdFpc
 1Hqd/9rR
 gO9FFHDtStBOvt8gF6ixzcu/nMSxI1+L5BnMNjsFSkW6SPpUXJa3atcvtAQFgmw/CG/12HNOUQGPk5bFAfEJUDNocONOMChmeewwn3Khd80CR+IpLITWqBgkvIVEVYHNoTjRSjtzCSdURFgjYv8WgWRIxj1IjRryyi7dGpVFBWTjYfsB9fKy1lNq1uxp4Qt3zY1S0pwGABf5qeZrWVOlYrqMRL/nZCuzGRQnZZ6jwp+R5dCMjsqEPEw2VBk/BKlY/rXn1K0dcx2hWEvIBSlzyBECx/Y1KN61yll1fexx2Z4NbmsGtGGBjgoe9EsZxfOonC2wxpugrq7wBbM7UuDevXAj4w02ncIH7uZZjGbEEWg4z/pTTmWMwZQOmQdtatOSACTWNYmhkOMzdxbvaYkWdrbR5t3hQG7RaasvTuhraGfUx8u6SoL4DzQF61z1mF9Wr0p8btbKtb23UrKxZl15GC87PW67HmK0plSfBQ9mfeQx4D/U2Ge0JmvV4n5BK7s5shOER4vQtNt9KdQz+fG2z4Mry+g0twBn2yRfOHWF8BwEvrbklD3sQGElG2A+gsrl3+TvqUQPMgUM7npArtg4BUE6VzjprsiM4kw1eoNLyZZ7+JrWS/nXk733i8yAZXnjX6jJBy+x9zsvgZWfHRmI4+898H/WwZAkTTgQmuLCoBTFRBDSRMloWouI0QoPWMTmP9ekkAxTEU7t/rrnxPFoYAXkVKRSc6i9Nhe9UZQhntm/SPKCUoHMmpODWZbCTxedweqUx0Z8wItFjN+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/mglru: unclamped scan budget on early return in lru_gen_balance=
_scan()
- [Medium] mm/mglru: inconsistent swappiness state when anon reclaim is ski=
pped for GFP_NOIO
--

commit 28e2a43107ca8cde0150881a1f428f1c7e18f418
Author: Bo Zhang <zhangbo56@xiaomi.com>

mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation

This commit enables the low-swapcache check in reclaimable_anon_is_low() for
MGLRU under GFP_NOIO and zeroes nr_to_scan[LRU_GEN_ANON] in
lru_gen_prepare_scan() when can_reclaim_anon_pages() returns false. It also
updates lru_gen_balance_scan() to return early when either nr[LRU_GEN_ANON]
or nr[LRU_GEN_FILE] is zero.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c47fe07f7290a..71bc7fedf7a9d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -5062,26 +5055,23 @@ static void lru_gen_balance_scan(struct lruvec *l=
ruvec, struct scan_control *sc,
>  {
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>  	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
> -	u64 anon_scan, file_scan, total;
> +	u64 anon_scan, file_scan;
>  	u64 anon_weight, file_weight;
>  	int size_bias;
> =20
> -	total =3D nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
> -	if (!total)
> -		return;
> -
>  	if (swappiness <=3D MIN_SWAPPINESS) {
>  		nr[LRU_GEN_ANON] =3D 0;
>  		nr[LRU_GEN_FILE] =3D min_t(u64, total_scan, nr[LRU_GEN_FILE]);
> -		return;
>  	}
> =20
>  	if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
>  		nr[LRU_GEN_FILE] =3D 0;
>  		nr[LRU_GEN_ANON] =3D min_t(u64, total_scan, nr[LRU_GEN_ANON]);
> -		return;
>  	}
> =20
> +	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE])
> +		return;

[Severity: High]
When 1 <=3D swappiness <=3D MAX_SWAPPINESS and either nr[LRU_GEN_ANON] or
nr[LRU_GEN_FILE] is 0, does this early return leave the remaining non-zero
nr[] entry unclamped by total_scan?

Both callers of lru_gen_balance_scan() first populate nr_to_scan[] with the
full unscaled evictable LRU sizes via lruvec_evictable_size(). In
lru_gen_prepare_scan():

    lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
    if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
            nr_to_scan[LRU_GEN_ANON] =3D 0;
    total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];

    /* Just scrape all pages calculated above if this memcg was deleted */
    if (!mem_cgroup_online(memcg))
            return;

    total =3D apply_proportional_protection(memcg, sc, total);
    total >>=3D sc->priority;
    lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);

And in run_eviction():

    lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
    lru_gen_balance_scan(lruvec, sc, swappiness,
                         nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);

Previously, when one type was 0 and swappiness was between 1 and
MAX_SWAPPINESS, execution continued to the end of lru_gen_balance_scan()
where nr[LRU_GEN_ANON] and nr[LRU_GEN_FILE] were bounded to total_scan.

With this change, nr[] is only clamped to total_scan before the early return
when swappiness <=3D MIN_SWAPPINESS or swappiness =3D=3D SWAPPINESS_ANON_ON=
LY. When
swappiness is in the normal range (for example, the default 60) and one LRU
type is 0 (either because !can_reclaim_anon_pages() zeroed
nr_to_scan[LRU_GEN_ANON] under GFP_NOIO, or because an lruvec only has
evictable pages of one type), lru_gen_balance_scan() returns early with the
non-zero nr[type] still set to the entire unscaled evictable size of that
LRU, bypassing sc->priority scaling, memory.low proportional protection in
apply_proportional_protection(), and the nr_to_reclaim target in
run_eviction().

>  	for (int type =3D LRU_GEN_ANON; type <=3D LRU_GEN_FILE; type++) {
>  		int hist =3D lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
>  		/* start at MIN_LRU_BATCH to smooth the rate on gen start */
> @@ -5307,6 +5297,8 @@ static void lru_gen_prepare_scan(struct lruvec *lru=
vec, struct scan_control *sc,
>  	unsigned long total;
> =20
>  	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +	if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
> +		nr_to_scan[LRU_GEN_ANON] =3D 0;
>  	total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
> =20
>  	/* Just scrape all pages calculated above if this memcg was deleted */

[Severity: Medium]
Could zeroing nr_to_scan[LRU_GEN_ANON] in lru_gen_prepare_scan() while
get_swappiness() still returns a non-zero swappiness cause state
inconsistencies across the rest of the MGLRU reclaim and aging paths under
GFP_NOIO when reclaimable_anon_is_low() is true?

In try_to_shrink_lruvec() and shrink_one(), get_swappiness() does not check
can_reclaim_anon_pages() or reclaimable_anon_is_low():

    static int get_swappiness(struct lruvec *lruvec, struct scan_control *s=
c)
    {
            ...
            if (!sc->may_swap)
                    return 0;

            if (!can_demote(pgdat->node_id, sc, memcg) &&
                mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
                    return 0;

            return swappiness;
    }

When swap space is available during GFP_NOIO reclaim with low swapcache,
swappiness remains non-zero while anon scanning is skipped:

1. In try_to_inc_min_seq() and should_run_aging(), a non-zero swappiness
   causes MGLRU to treat LRU_GEN_ANON as evictable:

       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
               return true;

   Because LRU_GEN_ANON is not scanned, min_seq[LRU_GEN_ANON] does not
   advance. When min_seq[LRU_GEN_ANON] lags at max_seq - 3,
   try_to_inc_min_seq() clamps min_seq[LRU_GEN_FILE] to max_seq - MIN_NR_GE=
NS
   and evictable_min_seq() stays below max_seq - MIN_NR_GENS, preventing
   should_run_aging() from aging even after all evictable file generations
   are exhausted.

2. In shrink_one() -> lruvec_is_sizable(), a non-zero swappiness causes
   lruvec_evictable_size() to count unreclaimable anon pages in total:

       lruvec_evictable_size(lruvec, swappiness, sizes);
       total =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];

   For an anon-heavy memcg with little or no file cache under GFP_NOIO,
   lruvec_is_sizable() still returns true even though nothing can be scanne=
d,
   preventing shrink_one() from rotating the memcg.

Would checking can_reclaim_anon_pages() in get_swappiness() (returning 0 wh=
en
anon pages cannot be reclaimed) avoid both this mismatch and the unclamped
nr[LRU_GEN_FILE] budget in lru_gen_balance_scan() for this path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022220203.9191=
1-1-baohua@kernel.org?part=3D14

