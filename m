Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE511606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G25CCCy7
Received: by kanga.kvack.org (Postfix)
	id F29146B05B9; Tue, 10 Nov 2026 15:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01B56B05BA; Tue, 10 Nov 2026 15:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D876B05BB; Tue, 10 Nov 2026 15:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6E5B6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:56:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7536A0105
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:38 +0000 (UTC)
X-FDA: 85420418076.18.46E65FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 202C740009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G25CCCy7;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344197;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BS4djIHXSPExI78gwcnoXFCTntRzOyxbc3UMSO1N0AE=;
	b=YBQqKF/myCMe+KZgPdTw95uCoEGw6ufE99kWQx+oam7clQTZaeLzCiKpIY18TotnkAUK0+
	s8/42LWjQW/15nW3yoqvdUFqmC1DPQnHhYPf9qMDhsxM46pKobh5zPrpuJjzbB6AUYEJwR
	PKxwyKRtyFODRTrmmli1L1OVBTOuv0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344197;
	b=M7COBksyM8o9ScoVMPvYjoiWEvs5tJ57KMjI1OpscVhf8zl0US6rz7JIBK6TkMow0D4FGp
	V8Tj9plITHPNry8s6MyXARvvbGASGUgaVJlDJuHaY6+8oDu6kv5RcLf3vrb4gVv7hWRflE
	O0lTe9nMIBb/fzBLUQ5FLa0DLmodBWI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G25CCCy7;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69662438AB;
	Tue, 10 Nov 2026 20:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37601F0089F;
	Tue, 10 Nov 2026 20:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344196;
	bh=BS4djIHXSPExI78gwcnoXFCTntRzOyxbc3UMSO1N0AE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G25CCCy7I9cHIN+LMCmjbqQH5dl9blVoSwACgsws6d8+D9PSnRni3Vag7qOzGZWhQ
	 SYA6Un9WN5ZruBcRB1IS6iIMctzPBqv6RI5Vwzjdzo/TpDerdAgHIFpdDyMu9ree0U
	 ZdKfwpB/fhi0SRAV0X6CCYf/NEJCC3UqUgtp4Ckv+wnp16t//8+PxY3aU9SBrqyy16
	 H8oFDrFPoDZwit4ab3U4QTgCEmblMDalOiUV603oMh6f0td6+DXU+ttLd1z7MjJbL7
	 XKy2NSdmrcaV37wUWcC8EHpfEbyDlVmmDK3xMJbNnhFe0TB7SNpmnfZOxAD53/rDfu
	 6GAjjECnE+j4Q==
Message-ID: <sashiko-outbox-207744@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/15] mm/mglru: balance anon and file scan budget by
 refault rate
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261110202025.25736-8-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
 <20261110202025.25736-8-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:56:33 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 202C740009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hhaiti1n9h3hsws5ent8jpkwu86wgsoy
X-Rspam-User: 
X-HE-Tag: 1794344196-214124
X-HE-Meta: U2FsdGVkX1+7Fy7SPogvaSbcpaVOyKMdGuH3pdCHmlDY2c1kZNwHty0mXvYt6G+UyIqTxeWUMxKNiiXwuOaVmznAWtvYDcJLJen2JZr2JRjzDPN4xLPlpOIiIRnJkr+Z5FpQCg73dtTisWlGl7anFKcZ6cb6XHSFqgQ8QjHdOIQv2Bo1cgyRaEsqTRtpKyqx7K00pQjAykDcO55uy2dzpscBuwTEcVtZeBJbkHdQPifC2q8bdaL0RX17BdUiIAacv3t9EHQWO4vt2RUw/MtjvMz6kwrQhsrktA39VIJ6DUa1COe6DN44NjabkisdOKKJ3kmwGDw7g6ytK932yXOFTjv8rr0y9FSbKv/gSIOhqGpMSj8CVsQPK67UrGdOGKiFZ2hqYkng7X6zKgJJ/eAOpczcZDGmDWkwzMHQSEAMYgKwYw8t95QsmKbPydkfbjpc8oDjD35o9Mj75eaZTwBiWGNXjwaifUZchgafAEd0MZLDOwN4GKG43ZjbV8hYIrVgeBUdUwF4WyDPMowIrA25BPJcF50oSs3KkR1YuTuFsYy4d/dAh52RgaiKyH0PwXLtaVS/9vgao4nQwy5e6pS+vwFA2MQIOSpFuDuUzrnQgSUim9hfJMRj56BCk9srB36LB9+26kZNtJEaBpDBBmF8q99Tu2yayeXWPTewbuy3DZjSb4w4MMKbibTMs2jX9Xqf7QMY9CybpybUue+Dppus9Nx4EE9c/Ag04Hk3HA1K3vE4GA7fPwKphiK2JAmii+LC048qchxYbeVQAQwSvwnzYfc8+QAkZLPImh2Br8fxLyxU2a5SuwyOHATq3+WoC+PTr3LLuhXIMTV4XAQLQd09kiC3dr9qFgZm4+a4qnnj8Ra3GE6Pb2xfsMq/AqhX8MQjJkhhzdHkJuu9iJU+4gS18f+bgoNaOUNbJKtSDF/xCpXEFaWUUvJ57/SmeKgdEiJ5f+w6pss3aUw6A5VfPeB
 raJz2sFM
 9IAnGA+nPGQFh3ISZ4HOHmUqtT18RdGU3DM2ZPM1dtT29us4A21ZH/UNfYcYqIOnkZ4oo9Qcf7Cs/ki7GrWR7LWDuruApMd85EhikpqCu+DLqDQ7iffkSrd5k6JlL4FPgkjDOZHIIZzSr3HrNYDUH3ssX6ZGghY2NkzfjxFMLlGwBDNDvkRk3UqyCC5ueEuroDFOZR19ag++kC8IKJarF7VQIIA00EbOcpL+UWwCHoJUWYdJqMYhYEurIs1T46+aavtPXR0crIGjrSw0wAGx/xR8qN5A8fx9aUWBTpX3aH69uths85gYkVSqgoZIPDcOWwWMBScZq/9cu5k5lo7S65xyQgx554s99trDkt6l4YTWpKm1BGPpHmCgCATudmgbTuC08tnyKs9efLLDCLlGxvxJ1HicJpYLFy0RW9QPVJEyLG5sqqdXPexol/WObSQeu+Ijw62Bq6A7PPfTLmc/jW2l2jqB0CeGfTw2YxSXMHI9VaShAd6s1ucO25LiVVMHdO2RtYHTHnAR9biVaZWAx/TBhQ2ESosca+nmIv8O0FyWRlPbC7BRjSQzg/2f4wyxvUFwE817e6lDsRHXScCSZgCBvXoeZjO8loUfMydVDqrj4AQSN4unr1hpT+/u+bpkXMsmtVxocZwgQnEV2d9YM9FtWO0jZ56x9pgJIuITPgnNagLd1Yr4aCqyDXqvLRjYbttWHW8frTJANeKeYSu6b2V439lC1EikesjVz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] mm/mglru: lru_gen_balance_scan() budgets un-scannable
  generations
- [Low] mm/mglru: lru_gen_prepare_scan() re-adds obsolete offline memcg
  check
- [Low] mm/mglru: u64 overflow in lru_gen_balance_scan() excess budget
  handoff
- [Low] mm/mglru: unzeroed budget on empty scan in evict_folio_lists()
--

commit 20aa81528d31d5bc56afcb10aeda259624bda6c8
Author: Kairui Song <kasong@tencent.com>

mm/mglru: balance anon and file scan budget by refault rate

This commit replaces MGLRU's single-type-per-batch selection with
lru_gen_balance_scan() and evict_folio_lists() to split the scan budget
between anon and file LRUs based on per-type refault rates and LRU sizes.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e2807faf26deb..6b325fe73436a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4858,79 +4858,110 @@ static int get_tier_idx(struct lruvec *lruvec, i=
nt type)

[ ... ]

> +	/* Cross-multiply the ratio above. */
> +	anon_scan =3D mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor =
+ file_factor);
> +	file_scan =3D (u64)total_scan - anon_scan;
> +
>  	/*
> -	 * We scanned some folios but failed to isolate any due to promotions,
> -	 * protections, or races. Retry once to avoid a larger loop.
> +	 * Bound each type by its evictable size. Hand the exceeding part to
> +	 * the other type. Any excess left when total_scan exceeds both sizes
> +	 * is dropped, since it only stresses the scanner with no gain.
>  	 */
> -	if (scanned && !tried) {
> -		tried =3D true;
> -		goto retry;
> -	}
> -
> -	return total_scanned;
> +	if (anon_scan > nr[LRU_GEN_ANON])
> +		file_scan +=3D anon_scan - nr[LRU_GEN_ANON];
> +	if (file_scan > nr[LRU_GEN_FILE])
> +		anon_scan +=3D file_scan - nr[LRU_GEN_FILE];
> +	nr[LRU_GEN_ANON] =3D min_t(u64, anon_scan, nr[LRU_GEN_ANON]);
> +	nr[LRU_GEN_FILE] =3D min_t(u64, file_scan, nr[LRU_GEN_FILE]);
>  }

[Severity: Low]
Can anon_scan overflow u64 when total_scan exceeds total and both if
branches run?

In lru_gen_seq_write() -> run_cmd() -> run_eviction(), the optional
nr_to_reclaim argument defaults to ULONG_MAX, so total_scan passed to
lru_gen_balance_scan() can be near U64_MAX.  When anon_scan exceeds
nr[LRU_GEN_ANON], the first branch sets file_scan to
total_scan - nr[LRU_GEN_ANON] without clamping anon_scan, and the second
branch then adds total_scan - total to the unclamped anon_scan.  If
anon_scan + total_scan - total wraps modulo 2^64 to a value smaller than
nr[LRU_GEN_ANON], nr[LRU_GEN_ANON] is truncated below the available
anonymous size.  Using else if (or clamping total_scan to total upfront)
avoids the overflow.

[ ... ]

> @@ -5051,18 +5083,22 @@ static bool should_run_aging(struct lruvec *lruve=
c, unsigned long max_seq,
>  	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max_=
seq;
>  }
> =20
> -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c,
> -			   struct mem_cgroup *memcg, int swappiness)
> +static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_cont=
rol *sc,
> +		struct mem_cgroup *memcg, int swappiness,
> +		unsigned long nr_to_scan[])
>  {
> -	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
> +	unsigned long total;
> =20
> -	lruvec_evictable_size(lruvec, swappiness, sizes);
> -	evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> +	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +	total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
> =20
> -	nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable);
> -	nr_to_scan >>=3D sc->priority;
> +	/* Just scrape all pages calculated above if this memcg was deleted */
> +	if (!mem_cgroup_online(memcg))
> +		return;
> =20
> -	return nr_to_scan;
> +	total =3D apply_proportional_protection(memcg, sc, total);
> +	total >>=3D sc->priority;
> +	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
>  }

[Severity: Low]
Does this re-introduce the !mem_cgroup_online(memcg) early return that
2e203d692b0cb ("mm/vmscan: remove redundant !mem_cgroup_online() checks")
removed from get_nr_to_scan()?

Offlined memcgs already have all LRU folios reparented and
lruvec_evictable_size() equal to 0, so returning early here only skips
apply_proportional_protection() and misses setting sc->memcg_low_skipped
when an offlined memcg still has stale effective memory.low protection.

[ ... ]

> @@ -5095,6 +5131,30 @@ static bool should_abort_scan(struct lruvec *lruve=
c, struct scan_control *sc)
>  	return true;
>  }
> =20
> +static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec =
*lruvec,
> +			     struct scan_control *sc, int swappiness, unsigned long max_batch)
> +{
> +	int type;
> +	unsigned long batch, scanned, total_scanned =3D 0;
> +
> +	/*
> +	 * Scan both types with the given budgets; the caller checks if
> +	 * reclaim is satisfied after each pass.
> +	 */
> +	for (type =3D LRU_GEN_FILE; type >=3D LRU_GEN_ANON; type--) {
> +		if (!nr_to_scan[type])
> +			continue;
> +
> +		batch =3D min(nr_to_scan[type], max_batch);
> +		scanned =3D evict_folios(batch, lruvec, sc, type, swappiness);
> +
> +		nr_to_scan[type] -=3D min(nr_to_scan[type], scanned);
> +		total_scanned +=3D scanned;
> +	}
> +
> +	return total_scanned;
> +}

[Severity: Low]
When evict_folios() returns 0 for one type because that type has no folios
in scannable generations, shouldn't nr_to_scan[type] be cleared to 0?

Leaving nr_to_scan[type] unchanged causes try_to_shrink_lruvec() to call
evict_folios() on the empty type on every subsequent MIN_LRU_BATCH pass
while the other type still has budget, and then run one extra iteration
(including should_run_aging() and try_to_inc_max_seq()) after the
scannable type's budget reaches 0.

[ ... ]

> @@ -5781,8 +5838,11 @@ static int run_eviction(struct lruvec *lruvec, uns=
igned long seq, struct scan_co
>  		if (sc->nr_reclaimed >=3D nr_to_reclaim)
>  			return 0;
> =20
> -		nr_batch =3D min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
> -		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
> +		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +		lru_gen_balance_scan(lruvec, swappiness,
> +				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
> +
> +		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BAT=
CH))
>  			return 0;
> =20
>  		cond_resched();

[Severity: Medium]
Can lru_gen_balance_scan() assign scan budget to a type that has no folios
in scannable generations instead of handing that budget to the other type?

Previously, isolate_folios() fell back to !type whenever scan_folios()
returned 0.  Now, lru_gen_balance_scan() only transfers excess budget when
a type's share exceeds nr[type] from lruvec_evictable_size(), which sums
folios across all generations min_seq[type]..max_seq including protected
younger generations (such as max_seq - 1 and max_seq at DEF_PRIORITY).

When one type has drained all folios in its scannable cold generations
while still holding folios in younger generations, lruvec_evictable_size()
remains non-zero and lru_gen_balance_scan() keeps assigning budget to that
type.  In try_to_shrink_lruvec(), that share of the scan budget is lost;
in run_eviction() (where priority is fixed at DEF_PRIORITY), if the
remaining scannable type's share rounds down to 0 (for example when
nr_to_reclaim - sc->nr_reclaimed is small or at swappiness =3D=3D
MAX_SWAPPINESS), evict_folio_lists() scans nothing and aborts proactive
reclaim early while the other type still has cold folios.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.2573=
6-1-baohua@kernel.org?part=3D7

