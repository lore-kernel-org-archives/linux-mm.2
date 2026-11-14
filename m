Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B281606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KOqdodZq
Received: by kanga.kvack.org (Postfix)
	id 024CF6B00EF; Sat, 14 Nov 2026 15:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF766B05B0; Sat, 14 Nov 2026 15:50:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF6F6B05B1; Sat, 14 Nov 2026 15:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68A66B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:50:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29FA6A8030
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:50:27 +0000 (UTC)
X-FDA: 85434917694.02.0DE700E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89DBEC0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:50:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KOqdodZq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794689425;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwaGSL/3pkOXuRFWjGAEeZ8H2QqNy4eHMDMJvtd7dAE=;
	b=syOacPb6ycTz1Ui/9tu64aS/j2DQ50pliwjTyvKnFGLjT533gWP3G/3M/dIFleoInyHzA/
	M0SKjF+V+zwCCtDXWSb1cibvbp7hOcQPiBjeEglFjqqNzZ4pggtTyLl/EpGWD1GeY7EQ8H
	WRJ/kLJNDNkGAQ5ZjpFkeqJ5YXc3K0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794689425;
	b=N665iMCJMs2VtLLgSFu2gZMoFA+AopcNZg1gfvwBlWXEY8dPJUUjxk2IpHaE1Hnjd5PV4H
	GqUMxXikKZrOFHmFbKPKwRPHlYVTmwo9Etf3mwm36Ovlls6gIFe8HlctMHDKMus0NxyV1u
	ElDDoCQc4iKAJIAbPY9X9bTUmv+Laks=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KOqdodZq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD262612FB;
	Sat, 14 Nov 2026 20:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E321F000C5;
	Sat, 14 Nov 2026 20:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794689424;
	bh=XwaGSL/3pkOXuRFWjGAEeZ8H2QqNy4eHMDMJvtd7dAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KOqdodZqz7tf1P+9HE30hneXNgH4+p95vxqnSmK1f7+j2E5pmS1IT3/SEQytOydq1
	 WUcBzXhD40zHNBdqScXYdZrCIeBkri3lRIhOmh5i/lGWSqOpKsyliq+ForjP1LvMQF
	 iHwZKr5KnasNoEhTdGflsGMOsuMEd+Uq87/ztPSXOx3Psf6tSzsXulVyBPPOexhKJ5
	 VNr51diSAk7asDbiZUDFnEzK/JoKYbJdWZizTYXuJE3QR3hWnhXXX0M4Qx+YNrXHdM
	 qBHH6YRF+1lr7zxYDnVJb8jCnUHVm7BMOvnbatoXQyZIS8qdEvbLJdVDEJUPylFpmq
	 8hpOdRD+P+G/A==
Message-ID: <sashiko-outbox-215014@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 11/16] mm/mglru: Run aging when one type is drained
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261114200803.23129-12-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-12-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 20:50:22 +0000
X-Stat-Signature: 6tcuw5kp73r83u836meiqx6bq6d7srgd
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89DBEC0005
X-HE-Tag: 1794689425-658881
X-HE-Meta: U2FsdGVkX192dHOsKHpzOvUVO/lWKw+HZy6KLEbEi5UQNTNfeUICH5I6M3E8V1/xuhCDSrhTQfJP66Aq+ggqrA/X86v8JU4CEPEqMU5yNW9ZdgJM8Of55EjUcbQU18+FUkP8HN3e6nT1xdigJVwpJQz3oXZk9FgVe5aAoBO+Ouu5R+hjdX/l1ur1c2n9mwOObafYyIARf5AlIHWa8P5VaSN/gFQVVKqSAzpb5qvVMG3i9nZUygKG+ESM8G/vk4ikNyzyoY211pr4Atae/hxaIIPN7TZhs/YfTZMvH9parA6ez5Hb5gVSIp6q3EzBIjj3y68qW67gQpeqeuZI7KaYYTH8DFaMVnPa3K1ftIT0V8H+azQeJPZb2AaOEuNTDLa8C4JCo8uJHUs6Od3DoiBfIKu8JbJZbOPTY6YdKq6nebJS5YrxFPvRD/Zej6N5576t8y8FLV3WOVippC4lu+yn1Y1d3qBpxT3fZbXc4pHIGyhC9vwiKEaApIS6VDAVdLqYNIs8ldaAJLP2xJka0qhDmV26aAgtjSQHkmEdFc1w7Y4lIaH+slf7vL7z839UNj+vsiddcvTY+GKDv2nqs1ZmXhkjfJAQObzfvZoHBtJnsCdLqoiqpQXeczuMrMwEaMFtQVYz/cPx9uqftwS8irMnZT1Uxm1FdAroF6CB2JgB16Q7fS+EPfpaXCX1X1qZve6DjAG34Yvblm2iFC7F5etZKtfec/wGZwiX3swSgnpp8ZpQBSgRgRwbAx6esMbwyvNQlBWSpldnJX4+WTSC1c2DrHkZAC1CK/yPhFub0KFPYzm8Dcs7JUyhYfwp8P9w/Azlcigqd5SLqphYjSPEaygWqYYjxRSCCb7tV152k7RiaPHFic7YeHb1xlUig2NDoV3ztXfLX5wE70kQXFB3A5Rm2cO+LSDYXCpej/km7iN9ldQJiXjJHlPl/RacAHZD3mbVstzwnB2hSubBT6OtMtQ
 XhYKIv0p
 KgKOD37y6oHHhcAOCF8D1nW9IxqtQ9cqd84IlTsnfYCjL+GL2PqOIMzpGSc54XvYTzmDPky+CCcie6dM4SRWBrtIDo+9HtLzqtI2yEN9kHD46jbq7y0DkSK1PmIdn4+xSNT63o3bOXtD9r0hzvVWIVDmKUyvDMW/EIX8ERsulxc476zhSk+7MwV8/UAtnXl/bRJ1R8eSaujp1WpCyCHi85P5zSMnL2MdSL4Ty4eFQm6c8NSKvV1KYGxD67PxMfWivT7wSCeXUGoGWo4HwadoX5DiDrKJnNiOGyFledfSB7djy+REKqSVWeObIZTyaQCVlsylOYrCPdBN6gefJ7SJTuj2XH5bk+9gjq+vYm9kuT4YHiXSPHhaUfy+N6lKHCOFGASgNhNEqW2JX0X2Zofbi8fYeK0fjo27QzrH5SSJD7WbrNX6Mp4s/M0pqJ3Tbpfu/QmUKQlf1kDPai6zovqBWLySXrnkto518PEwMJimPZT2TSnEGeHS2bc9LPHrpMUhYKKHpAPcAqBY57ouKLPKhihyiD95WfVkKd6fopuVD3THT/Ih+KcxurNQhx3+Qu01SL6tPqmwOG5j6PhEG0/9Y1/HmSvxjJNsZVRzQXc9tuWgX0opOH7/Qn4vIxKCLAtkhwn2euCU4jE+2qUu4UL/PV4MeaYzAroXWlW1nvzUBqQ1j+dJdJjPvfWo8axAqC9qwkS9VAGor//Ycb7A=
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
- [Medium] mm/mglru: scan_folios() scans seq below min_seq at
  DEF_PRIORITY
- [Low] mm/mglru: missed eviction retry in try_to_shrink_lruvec() on
  concurrent aging
--

commit 230d3708cf744410ec1f04bfd86215ddf2b3c664
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Run aging when one type is drained

This commit moves MGLRU aging after eviction in try_to_shrink_lruvec() and
triggers aging once per invocation when an evictable type is drained.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1450542d709c3..6d942f192e63a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -5226,22 +5235,17 @@ static bool try_to_shrink_lruvec(struct lruvec *l=
ruvec, struct scan_control *sc)
>  	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
> =20
>  	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
> +		bool drained =3D false, do_drained_age;
>  		DEFINE_MAX_SEQ(lruvec);
> +		unsigned long new_seq;
> +		long scanned;
> =20
>  		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
>  			need_rotate =3D true;
>  			break;
>  		}
> =20
> -		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> -			trace_mm_mglru_aging(lruvec, sc, swappiness);
> -			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> -				need_rotate =3D true;
> -			should_age =3D true;
> -		}
> -
> -		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
> -			break;
> +		scanned =3D evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATC=
H, &drained);

[Severity: Medium]
Can calling evict_folio_lists() before should_run_aging() cause
scan_folios() to scan a generation below min_seq[type] at DEF_PRIORITY?

Previously, should_run_aging() ran first and incremented max_seq at
DEF_PRIORITY whenever a type had only MIN_NR_GENS generations
(min_seq[type] =3D=3D max_seq - 1).  With eviction moved ahead of aging,
evict_folio_lists() -> evict_folios() -> scan_folios() now runs while
min_seq[type] =3D=3D max_seq - 1:

mm/vmscan.c:scan_folios() {
    ...
	if (sc->priority =3D=3D DEF_PRIORITY)
		seq =3D lrugen->max_seq - MIN_NR_GENS;
	else if (sc->priority > AGING_PRIORITY)
		seq =3D lrugen->max_seq - 1;
	else
		seq =3D lrugen->max_seq;

	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
    ...
}

Because seq is max_seq - 2 (< min_seq[type]), the while (min_seq < max_seq)
loop in lruvec_populated_min_seq() does not execute and returns max_seq - 2.
scan_folios() then scans the out-of-window slot
lrugen->folios[lru_gen_from_seq(max_seq - 2)][type][zone_idx], prematurely
isolating or promoting folios parked in that slot by memcg reparenting to
await future aging, and re-adding rejected folios via move_folios_to_lru()
at scanned_seq + 1 =3D=3D min_seq[type] instead of promoting them above
min_seq[type].

> =20
>  		if (should_abort_scan(lruvec, sc))
>  			break;
> @@ -5253,6 +5257,27 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>  		if (root_reclaim(sc) && should_age)
>  			break;
> =20
> +		/*
> +		 * Allow drained aging only once per invocation and skip it if
> +		 * max_seq advanced concurrently during eviction
> +		 */
> +		new_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> +		do_drained_age =3D drained && allow_drained_age && max_seq =3D=3D new_=
seq;
> +		allow_drained_age &=3D !do_drained_age;
> +		if (do_drained_age || should_run_aging(lruvec, new_seq, sc, swappiness=
)) {
> +			trace_mm_mglru_aging(lruvec, sc, swappiness);
> +			if (try_to_inc_max_seq(lruvec, new_seq, swappiness, false))
> +				need_rotate =3D true;
> +			should_age =3D true;
> +		}
> +
> +		if (!scanned) {
> +			/* Retry once if aging advanced max_seq */
> +			if (retried || new_seq =3D=3D READ_ONCE(lruvec->lrugen.max_seq))
> +				break;
> +			retried =3D true;
> +		}

[Severity: Low]
Should the retry check compare READ_ONCE(lruvec->lrugen.max_seq) against
max_seq instead of new_seq?

CPU0                              CPU1
try_to_shrink_lruvec()
  max_seq =3D lrugen.max_seq
  evict_folio_lists() -> 0
                                  try_to_inc_max_seq()
                                    inc_max_seq()
                                      lrugen.max_seq++
  new_seq =3D lrugen.max_seq
  max_seq =3D=3D new_seq is false
  /* aging skipped */
  new_seq =3D=3D lrugen.max_seq       <-- breaks without retrying

When a concurrent reclaimer advances max_seq after scan_folios() finds no
folios and before new_seq is read, do_drained_age is skipped because
max_seq !=3D new_seq and should_run_aging() is evaluated against the already
incremented new_seq.  Comparing lrugen.max_seq against new_seq then sees no
change and breaks out of try_to_shrink_lruvec() without retrying eviction
on the newly aged generation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114200803.2312=
9-1-baohua@kernel.org?part=3D11

