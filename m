Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E43F606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 03:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AbMwFNOK
Received: by kanga.kvack.org (Postfix)
	id 91B1F6B05B2; Fri, 13 Nov 2026 22:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC666B05B3; Fri, 13 Nov 2026 22:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1B96B05B4; Fri, 13 Nov 2026 22:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FFBF6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:42:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC8994036A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:42:24 +0000 (UTC)
X-FDA: 85432327008.19.922EDAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17592140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:42:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbMwFNOK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794627743;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZR4m3lXkMdeeV+iMhQjDhpPR6YonM8ywMfmrqbtlI8=;
	b=ZSLUO+SxXwKrQqxCxlrWTeZleRoo5ltqLZdy7GroGQtP4wF42LEBRCkikTkXhP8XjkO8vk
	LDPJte5hAjPDD0GEcdtcuUl8rf2+lwUBCY9PZwUz++1zKyeB+z4HfWN8vQTuhrd0OyJ68r
	BCJO3qrjNsl2NZVa1X/TnoxkhA1oM2M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbMwFNOK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794627743;
	b=wEeimbd/jwmoxQ+qBCsYazGaAG4bRfOAQjk/1d0CQLhxsWST2ZaTM3PLkBJBRnp3V6uf6L
	WS3c7EcP/aoZ0/JlWDeFN99AGsrl8pMG0fyIOL31YgdiHZEUwuHsNxKdFASfj7BpVKx8OE
	rTNuO96/1sH7ApHv1TgAn/nq3TcmefE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CCF46232D;
	Sat, 14 Nov 2026 03:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958F01F000C4;
	Sat, 14 Nov 2026 03:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794627742;
	bh=AZR4m3lXkMdeeV+iMhQjDhpPR6YonM8ywMfmrqbtlI8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AbMwFNOKdkUBJjqKX4BrBFNZ9tdqxWA8JWMxjuUVh4qxvFzmtbSGzoTPwqg3xZ/Fx
	 hsGHazXxv+sUwtwe07JT95FR0w5Fm6/I/mUSuaYyP/QIJG3xzu7DMUNJmscSxNyPy7
	 zCRpg1MUL68QW1VtgmoyixAo0eF+KJtckxIHDIDsLuYFjal9l/6tPE/KE2AZf/lJXK
	 SDYBaQL6VdaeYLD8v2cDoXRSuOlx6N6C4BMdIZKgvOB3xG5wv+SzMHSSY9RWKRlnpx
	 2a/0iVpmElKpNsvNSIzZLB3QoKYFGDmp13imTTbDgv5LCKFtS+xYJeduLb06kL+89y
	 U/6cIwPDUlrEw==
Message-ID: <sashiko-outbox-214125@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] mm/mglru: skip cold PUD subtrees during aging
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, "Baoquan
 He" <hebaoquan@kylinos.cn>, "Kairui Song" <ryncsn@gmail.com>
In-Reply-To: <20261113084953.412919-4-baoquan.he@linux.dev>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-4-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 03:42:21 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 17592140005
X-Stat-Signature: d5c6nfgspse14bwpo9tkxf5y1weo9noi
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794627742-184186
X-HE-Meta: U2FsdGVkX1/XO5c9faHXFZNqEWayT4RtPY37Fh/txTzYddpcpewhLQrNeafcb0T1+SLozt9UgkodDSPDNUq54KMO6b+Exsz71MvkQDFz7x5WHLp3WMoKtfvZtgBPSM6cBF6KPkuN7GwV73w5CaFth/QjlCPgmHc8PfLO0Wxoe3OoJfHG52z5arWN2PirMpDQPhZZID1zecyQt9m8HRfEg2u9hc7HB9Fz/6jeNck81T1UJaBWVdrrLC0mw2MPyK2PSXsSq1xeN4TCA8+q2kvNfiEqhgkvuZbkUiM46bO7/SsuZpA06LJnAb7LBCbstBUEV1zeZVL7azV8DxhH8QQOIFy9YHkSdUJLUy2u7f1I0ceYg9I5agcuaVpKGhYzVf4VdPEG9O0t+QvJAHBl7iO4bS8U9+USiYx1DljqgJHDAJJ9f4FcdwjqHgdH2ZyE31lMvYzRTLaJYXT7tWApAfG5Mv/pThNZflg/JxXrIFee2wZY3HClWvEh/ywhMjpVyAC49gG0PErDaipDIogIlkllGDLU2ObEBqasZyAjvo0ok+4quo1jUqMOW2YViUzrkBcqw4ZviWasostYWOg2pEmT5opvsLfT6IfVgFJ1TJa9vR/RbB5jo+7AzjQOxqfrxVCp5QQ+J1bc+Md8vMrnrpvWAeqmTa/V/KuHP0v+zhvVf/yoByn4+/AvEDFYI339TMhjwIJHkK4HD9HoOH+bNaD4kwJ3VOmqKhrxXJFDRDClw1zP+xDCadDUK+prk5yb5/8LQDJcojEKW+/EdSgj5fGEBIk2CK2WW0vEGRRZox45cOnneDBMTvSyGo6j1mtyRqZuOVXtu0P5fWc+RyfkoJiOWqSlwcrBJrA4c3A+YeRVsyrd9cz+wkZDHIFqtdhJGhRziScxE7WeLLNl8Mr1ctp2ytyQFfLuagJAKck8E3r9zdQaL7Sb9NVKGe9B8SiBzCZs4hWJ1d+wdfBXMZUeXMT
 QynJrNgJ
 Cp6pgifX2zldmq4wpKoeN9xQKU2f5EKNevKDvxrsFu/aNlrxV3WfrLeJ7+2JsXxjAhESLRqHUbFuW0H7fHypt+eWt3n4p0jdwojXlf8vbleUTUyLFrD6Qr3I97FVkc4SEoi3f702WtLUQUQAFeqYsZJikxV+9+CyamtjzVtCk3FHLprjLjb+mpRctrH5LjabB3yQKKjW+pjjjeN8HconA6+QWYg279ILpYZhBXSSihf5la4AefgfK85AneurIegkdMjI7MbeJGGLmH5DGA33TcnovJPrETahwb/vIau/3IQtV5ZT36S8y3eshzXNsP4riskHx3CU3fIW6ws9GWqDJsWKx6++jPOS7FwpJHwnm0ePcVsekFQ3U6z2pvTzoIZq+j2iZ4MD2HPqCUdZRmG6Id0T/VYvKO2lu3ZEcls8f/o+GGCuPy7deIzPpGPp1zJ8bPlAnT2fsQ87J5eHVa9ZHZQT/mv2L+6H3VshZJpjIDYWqYMQ4xQVhyZvGiegFpLpkVPcJh9VfWlaDhJIgY5uw6rP7XDSfTp4QzMtUVZAbRDEvOkBw6Pm8KgkpMo/Yc9X5lYbV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/mglru: walk_pmd_range() marks PUD young on non-leaf PMD
  accessed bit
- [Medium] mm/mglru: walk_pmd_range() marks PUD young for THP before
  memcg and notifier checks
- [Medium] mm/mglru: PUDs with PMD-mapped THPs are suppressed
  indefinitely once skipped
--

commit 31572808d36982038b4b945e98794001c99a5d21
Author: Baoquan He <hebaoquan@kylinos.cn>

mm/mglru: skip cold PUD subtrees during aging

This commit introduces a PUD-level Bloom filter keyed by (mm, PUD-aligned
address) to skip PUD subtrees that had no young pages in the previous
generation during MGLRU aging walks, and updates it from the rmap feedback
path in lru_gen_look_around().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a0332586b3d83..79d533ebfd108 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -3730,10 +3732,11 @@ static void walk_pmd_range_locked(pud_t *pud, uns=
igned long addr, struct vm_area
>  	*first =3D -1;
>  }
> =20
> -static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned lon=
g end,
> +static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned lon=
g end,
>  			   struct mm_walk *args)
>  {
>  	int i;
> +	bool young =3D false;
>  	pmd_t *pmd;
>  	unsigned long next;
>  	unsigned long addr;
> @@ -3770,8 +3773,10 @@ static void walk_pmd_range(pud_t *pud, unsigned lo=
ng start, unsigned long end,
> =20
>  			walk->mm_stats[MM_LEAF_TOTAL]++;
> =20
> -			if (pfn !=3D -1)
> +			if (pfn !=3D -1) {
>  				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> +				young =3D true;
> +			}
>  			continue;
>  		}

[Severity: Medium]
Does setting young =3D true as soon as get_pmd_pfn() !=3D -1 mark the PUD y=
oung
before checking memcg ownership or MMU notifiers?

get_pmd_pfn() only checks that the PFN is on pgdat and that pmd_young() or
mm_has_notifiers() is true, while the memcg check in get_pfn_folio() and
the notifier young check in pmdp_test_and_clear_young_notify() are deferred
to walk_pmd_range_locked().  A PUD with PMD-mapped THPs belonging to
another memcg on the same node, or cold THPs in an mm with MMU notifiers,
will therefore be recorded in BLOOM_FILTER_PUD on every generation and
never skipped.

> @@ -3781,6 +3786,7 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
>  				continue;
> =20
>  			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> +			young =3D true;
>  		}
> =20
>  		if (!walk->force_scan &&
> @@ -3793,6 +3799,7 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
>  			continue;
> =20
>  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> +		young =3D true;
> =20
>  		/* carry over to the next generation */
>  		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i=
);

[Severity: Medium]
Should young =3D true be omitted from the non-leaf pmd_young(val) block?

When should_clear_pmd_young() is true, setting young =3D true there happens
before checking BLOOM_FILTER_PMD or calling walk_pte_range().  Because CPU
page table walks set the accessed bit on non-leaf PMDs regardless of which
node or memcg owns the underlying PTEs, any accessed non-leaf PMD will
cause walk_pmd_range() to return true and carry the PUD into
BLOOM_FILTER_PUD even when every PMD in the subtree fails the PMD Bloom
filter or has no folios in walk->lruvec.  The young =3D true after
walk_pte_range() already handles non-leaf PMDs that pass suitable_to_scan().

> @@ -3802,6 +3809,8 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
> =20
>  	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, =
&end))
>  		goto restart;
> +
> +	return young;
>  }
> =20
>  static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long=
 end,
> @@ -3812,6 +3821,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long=
 start, unsigned long end,
>  	unsigned long addr;
>  	unsigned long next;
>  	struct lru_gen_mm_walk *walk =3D args->private;
> +	struct lru_gen_mm_state *mm_state =3D get_mm_state(walk->lruvec);
> =20
>  	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
> =20
> @@ -3819,13 +3829,29 @@ static int walk_pud_range(p4d_t *p4d, unsigned lo=
ng start, unsigned long end,
>  restart:
>  	for (i =3D pud_index(start), addr =3D start; addr !=3D end; i++, addr =
=3D next) {
>  		pud_t val =3D pudp_get(pud + i);
> +		void *pud_key;
> =20
>  		next =3D pud_addr_end(addr, end);
> =20
>  		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
>  			continue;
> =20
> -		walk_pmd_range(pud + i, addr, next, args);
> +		/*
> +		 * Use (mm, PUD-aligned address) as the filter key instead of
> +		 * the page table pointer. It is stable across the aging walk
> +		 * and the rmap feedback path, and avoids walking the page
> +		 * tables in lru_gen_look_around().
> +		 */
> +		pud_key =3D (void *)((unsigned long)args->mm ^ (addr & PUD_MASK));
> +
> +		/* Skip a subtree that had nothing young for this lruvec last gen */
> +		if (!walk->force_scan &&
> +		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
> +			continue;
> +
> +		if (walk_pmd_range(pud + i, addr, next, args))
> +			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
> +					    pud_key);

[Severity: Medium]
Once a PUD is absent from BLOOM_FILTER_PUD, can PMD-mapped THPs inside it
ever be scanned by page-table aging again without force_scan?

Previously, BLOOM_FILTER_PMD was checked after pmd_trans_huge() in
walk_pmd_range(), so PMD-mapped THPs were never gated by a Bloom filter.
Gating walk_pmd_range() on BLOOM_FILTER_PUD skips the entire PUD when
pud_key is not present, and iterate_mm_list() clears the next generation's
filter via reset_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1).
The only rmap feedback that populates BLOOM_FILTER_PUD is
lru_gen_look_around(), which folio_referenced_one() only calls when
pvmw.pte is non-NULL:

mm/rmap.c:folio_referenced_one() {
    ...
		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
		    pte_present(pteval)) {
			if (lru_gen_look_around(&pvmw, nr))
				referenced++;
		} else if (pvmw.pte) {
    ...
		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
			if (pmdp_clear_flush_young_notify(vma, address,
						pvmw.pmd))
				referenced++;
    ...
}

For PMD-mapped THPs (pvmw.pte =3D=3D NULL), rmap eviction checks never upda=
te
BLOOM_FILTER_PUD, so any PUD that goes cold for one generation or receives
newly faulted or collapsed THPs after the initial force_scan will be
skipped by aging indefinitely.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113084953.4129=
19-1-baoquan.he@linux.dev?part=3D3

