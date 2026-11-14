Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D916606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kWBKmRxV
Received: by kanga.kvack.org (Postfix)
	id 10AAC6B05B3; Fri, 13 Nov 2026 21:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2036B05B2; Fri, 13 Nov 2026 21:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13916B05B3; Fri, 13 Nov 2026 21:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCE636B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:02:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C5DA160158
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:02:22 +0000 (UTC)
X-FDA: 85432074924.25.D50EAA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 76F11140008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:02:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWBKmRxV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794621740;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60PfPg0qGiMe46lw/reUvdmsR9KqupzcqB/275JhjJk=;
	b=uIQbraMmahyYAynDzKAIR8G26fC+PuPeCiHz6XVNpHywUgGB95dfhmNykgVH4wGODt7/7j
	NwojbXzMgRIfB0orZ2p+0nr20b9rqeLxqt92iQVs1R8/9KJ2XQPb5VYn3kAXy+KZ8rSasc
	8xO4ITJ5ueOjBah2at30fGDfX3i0URY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794621740;
	b=UBze9Fk9pWoLb64Fj8REUP9PVF1kRlHaM7bKIeslHbgMUc/sCHpw0Hsg4eIRb6RCSYuO1z
	UX8zLdaC/jN7SrH6S3ZKr4LRhmv3o8V7aevpKetEpd7FIjp6IZz0LOruUTNpxuPYfCBVeC
	fPbfUnHLhwwrTDonb5L3WZFgCopTMC8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWBKmRxV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4992940D3C;
	Sat, 14 Nov 2026 02:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED071F000C7;
	Sat, 14 Nov 2026 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621739;
	bh=60PfPg0qGiMe46lw/reUvdmsR9KqupzcqB/275JhjJk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kWBKmRxVIRCLL4Nlcygnnh0W6LA74vdgboqzcq18VmB4Nucr9t4iHkLvBWjt+Znj8
	 VcUzQomVsLuUVFqoqH2RQkoNriw18nGsv99jthvBtVmLlOcnS2ZkChqDrIuYf4nFzB
	 0mF5fpXK6PGIiAEwlgP/XB32CWrH8lEe6Rm+uBJiYOBugLdsC/7eC7X7GasFbeJwXq
	 ZxN9K2Do0fijXE43qe0kII8PwoC7l1ajUmgS2rK9HSjR78ttGE/hHoNMxSdKqvKG6V
	 SYczvzKWZA8rccp8RbTapDGsO4KfjLKUP1Dgs6cRSaTPQYG3FimYklRyf8pYW0koq+
	 kBRLFsyJySlNg==
Message-ID: <sashiko-outbox-214030@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 11/16] mm/mglru: Run aging when one type has no
 populatable folios
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261113185541.70203-12-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
 <20261113185541.70203-12-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 02:02:17 +0000
X-Stat-Signature: ojmh3msermj5um9za96djeeserrwgyhq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 76F11140008
X-HE-Tag: 1794621740-667790
X-HE-Meta: U2FsdGVkX19SC8VXtJ2/yFnhFrjByqL6WmP/KamXw/wt5ECE/mwzM2zAFe/UDAZ6ynmmIu+TReTDsVQRS+eSFvHwYevfbdgM9jgcDirOXxbu4wRgPRqsxGLFXWNwa+Y5M1w0C1bRh77uBqXDFCI2uvGRkk84OboppUg0A9VvYD0tt6GxwJ8pyS8m+X+n4nS9ceQqT7dLmNdOj8tdllHU9jrYqwKgIYzVUQo4C+JDLlEIulKRUMgevmgzy7jDoYGprIvIwSituNsaidGEHXEoAXVR4IosACHP7rsp7nFm8C+Fy63aWKhgWZ03yxyNmj4KO7vPRFtabrBa4W+VIv7trNx8jHodbnSPtImL1EefRQqm8sVh5NA0y9jwOhKNa2AR6jmv/lJi20OVkO7fdQz1QTdDfDiBbGK8iixJ+ZxWacz0Ie0LtEx7PzCwss3DKu6lyIF2trPH1sELQfMekYN2vfoHZ94GQu7uMQr5ugbBlUZZOma8jZFC+F9WPdsJFFhA3nq5+7almDpiBB9BDLxNI52xyXpCGJgNntQZrF1DLubx8356+rizrIfQgqh8y174qpusTK6p1uro0vJNF7hG6A0aqL9s0bnCnayvYfp8SA/IWTEGaqsRH1L8W8pJFsXrZ79ENLFykbUKdpNzsap/tCRsfUHe5Byr7iev5OKWR2Nox+ER462B9AIqtuxkLf4ZPYIyLATrsXxDrCErhlhjXeTqsI5+pLUCduEFYfnrxia18xS0qMV7yp9XjFs+6dmiV1XwnJOO09XXg+o6jdcUnSCaRxmz6F9e9Z3xuNvIeuGmIEfciWNbYEzegiTjic25bUTjvks598MrMO01VJ+ItuBGxHl5opfwpTkpeDEvm1O5xFtkgth0uRptVmWw/sGygXR4woB0XF/Egy3q4eiN/gHCCq2Y7rBrQaZGeJ3r4TJc6yFSCf6BmNdysrWHYQ/QycWwjPal5NfT5wsJWiM
 fbmNFBXZ
 zgLuArr3Br6T4r8MfL0+hTf2YGIcSZm5xl/yZzYcZPuLkvwCtqF+HicVDTtRJ/QFR9NNnAKJtlRDT2QFDOo2UQkFyQvEsU8HEWfESwcv/sPpmURSfUg0y5BGdQaVqpe23oiWAMAgLSCQFlAaN30vhgVcSH25bIUcpUbzr7DBGhqV7McT2xuPtHABd/JZosltZBJnbnTjMiDQJEgtcPYRZHqk8EItsY5z6XOAnAIlab41/RObUP5Vq13DxW9p2627dZDaQ7ST9kb07Q3Nsf/aBS7aCQmDOXncvaUCpInLgeYUaL9POrsbw0uURk2WpLMY5MnxzASXdry/bB3+o2xRFIvUtvPPhq82SgXncaqN90gpDpns+smrSJpiJWvbMqpsZPZby5GKKD6iV4G5+qfEpWxnl6erePiFc1kE+jQyDB8P1h135Y56VQlX6+iezTRcuTqq9vmpPbRhgukUdhhBGav1aoFjVcGlt45pKfQrisI5zRmwqeNzIwSnr84r4aBBDQrQlIgvA9Qio0fU4658UqgR/QHipC2Hlt1b5sKK3l+nB8kUvf22ZjerXwIoOoQKxtp2zSsbn26B/5D8Z7nrys6st0/fPtRQe9hsWCdSq15+gN8QXOeYfKDJ7J3+Udkon+meBwPnXHwQUH2WkSFkHAL3JZ0qVhn4m1LfSO5Am0rkm+pyRecTxe/Vq3tpOxcH6fGWluObWbQGnA6w=
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
- [High] mm/mglru: premature loop exit after aging in
  try_to_shrink_lruvec()
- [Medium] mm/mglru: late max_seq read in try_to_shrink_lruvec() causes
  redundant aging
--

commit 9c58557be00bbe7f49dfd8383a560ebff484751b
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Run aging when one type has no populatable folios

This commit moves the aging check in try_to_shrink_lruvec() after
evict_folio_lists() and triggers aging once per invocation when a folio
type has remaining scan budget but no populatable folios were scanned.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 59957fab915b7..9071f8889b5c4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5109,7 +5109,8 @@ static bool lru_gen_imbalanced(struct lruvec *lruve=
c, struct scan_control *sc,
>  }
> =20
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
> -			     struct scan_control *sc, int swappiness)
> +			     struct scan_control *sc, int swappiness,
> +			     bool no_populatable)
>  {
>  	DEFINE_MIN_SEQ(lruvec);
> =20
> @@ -5121,6 +5122,13 @@ static bool should_run_aging(struct lruvec *lruvec=
, unsigned long max_seq,
>  	if (sc->priority =3D=3D DEF_PRIORITY)
>  		return false;
> =20
> +	/*
> +	 * Run aging if scan budget remains but no folios
> +	 * in populatable generations are available to scan.
> +	 */
> +	if (no_populatable)
> +		return true;
> +
>  	/* better to run aging even though eviction is still possible */
>  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max_seq)
>  		return true;
> @@ -5208,6 +5216,13 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>  	bool need_rotate =3D false, should_age =3D false;
>  	int swappiness =3D get_swappiness(lruvec, sc);
>  	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +	/*
> +	 * Avoid aging the lagging type under extreme swappiness,
> +	 * as reclaim of the unpreferred type is disabled until
> +	 * DEF_PRIORITY / 2.
> +	 */
> +	bool allow_no_populatable_age =3D (sc->priority <=3D DEF_PRIORITY / 2) =
||
> +		(swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS);
> =20
>  	/*
>  	 * Proactive reclaim initiated by userspace for anonymous memory only.
> @@ -5225,22 +5240,19 @@ static bool try_to_shrink_lruvec(struct lruvec *l=
ruvec, struct scan_control *sc)
>  	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
> =20
>  	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
> -		DEFINE_MAX_SEQ(lruvec);
> +		unsigned long orig_file, orig_anon;
> +		unsigned long max_seq;
> +		bool no_populatable;
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
> +		orig_anon =3D nr[LRU_GEN_ANON];
> +		orig_file =3D nr[LRU_GEN_FILE];
> +		scanned =3D evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATC=
H);
> =20
>  		if (should_abort_scan(lruvec, sc))
>  			break;
> @@ -5252,6 +5264,21 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>  		if (root_reclaim(sc) && should_age)
>  			break;
> =20
> +		/* Limit no_populatable aging to once per try_to_shrink_lruvec() */
> +		no_populatable =3D allow_no_populatable_age &&
> +			((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] =3D=3D orig_anon) ||
> +			(nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] =3D=3D orig_file));
> +		allow_no_populatable_age &=3D !no_populatable;
> +		max_seq =3D READ_ONCE((lruvec)->lrugen.max_seq);
> +		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable))=
 {
> +			trace_mm_mglru_aging(lruvec, sc, swappiness);
> +			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> +				need_rotate =3D true;
> +			should_age =3D true;
> +		}

[Severity: Medium]
Can reading lruvec->lrugen.max_seq after evict_folio_lists() cause
concurrent reclaimers to run redundant back-to-back aging passes on the
same lruvec?

try_to_inc_max_seq() relies on callers passing the max_seq value observed
when the need for aging was detected, deduplicating concurrent callers via
seq <=3D READ_ONCE(mm_state->seq).  Because max_seq is now read after
evict_folio_lists(), two threads that both observe no_populatable while
max_seq is S can age the lruvec twice:

CPU0                                  CPU1
try_to_shrink_lruvec()                try_to_shrink_lruvec()
  evict_folio_lists()                   evict_folio_lists()
    /* max_seq =3D=3D S:
     * anon scans 0, file shrinks
     */
                                          /* max_seq =3D=3D S:
                                           * anon scans 0, file shrinks
                                           */
  no_populatable =3D true;
  max_seq =3D S;
  try_to_inc_max_seq(..., S, ...)
    /* advances max_seq to S + 1 */
                                        no_populatable =3D true;
                                        max_seq =3D READ_ONCE(lrugen.max_se=
q);
                                          /* reads S + 1 */
                                        should_run_aging(..., no_populatabl=
e)
                                          /* returns true unconditionally */
                                        try_to_inc_max_seq(..., S + 1, ...)
                                          /* ages again to S + 2 */
                                          <-- redundant aging

This triggers unnecessary page-table walks across mm_list, prematurely
advances min_seq once MAX_NR_GENS is reached, and decays PID controller
refault averages in reset_ctrl_pos() on each extra pass.  Reading max_seq
before calling evict_folio_lists() preserves the sequence number at which
no_populatable was observed.

> +		if (!scanned)
> +			break;

[Severity: High]
Does checking !scanned after try_to_inc_max_seq() cause
try_to_shrink_lruvec() to abort without reclaiming any folios right after
aging succeeds?

In scan_folios(), the oldest generation considered for scanning depends on
reclaim priority:

mm/vmscan.c:scan_folios() {
    ...
	if (sc->priority =3D=3D DEF_PRIORITY)
		seq =3D lrugen->max_seq - MIN_NR_GENS;
	else if (sc->priority > DEF_PRIORITY / 2)
		seq =3D lrugen->max_seq - 1;
	else
		seq =3D lrugen->max_seq;

	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
    ...
}

When sc->priority =3D=3D DEF_PRIORITY and an lruvec has only MIN_NR_GENS (2)
generations (min_seq =3D=3D max_seq - 1), scan_folios() sets seq to
max_seq - 2 (< min_seq) and evict_folio_lists() returns scanned =3D=3D 0.
should_run_aging() and try_to_inc_max_seq() then advance max_seq to create
a third generation and set need_rotate =3D true, but if (!scanned) break
immediately exits the loop using the pre-aging scanned =3D=3D 0 result,
rotating the memcg with zero folios reclaimed and escalating reclaim
priority prematurely.

The same premature exit happens at DEF_PRIORITY > sc->priority >
DEF_PRIORITY / 2 whenever the remaining type(s) with non-zero nr[] budget
only have folios in max_seq: evict_folio_lists() returns 0, no_populatable
triggers try_to_inc_max_seq() to move those folios into max_seq - 1, and
if (!scanned) break aborts the loop before they can be scanned, undoing
12316f7902f8 ("mm/mglru: don't abort scan immediately right after aging").

In addition, calling evict_folio_lists() and should_abort_scan() before
should_run_aging() causes scan_folios() at sc->priority <=3D
DEF_PRIORITY / 2 to evict directly from max_seq before
lru_gen_imbalanced() can age page tables to separate hot folios from cold
ones, and skips aging altogether when the first batch satisfies
should_abort_scan().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185541.7020=
3-1-baohua@kernel.org?part=3D11

