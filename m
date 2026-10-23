Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5167606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmdzTSUQ
Received: by kanga.kvack.org (Postfix)
	id C53A56B0BFC; Fri, 23 Oct 2026 18:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87996B0BFD; Fri, 23 Oct 2026 18:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3BB6B0BFE; Fri, 23 Oct 2026 18:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7496B0BFC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:03:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 581C7160279
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:43 +0000 (UTC)
X-FDA: 85355268726.05.4138F1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 97098160010
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmdzTSUQ;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792793021;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wvAjV3VEH0y9Aouo90x71QioxDU/M+tApVOpGKG9M4=;
	b=E6I+wT86rEDh+Fo50pV0i40z5n1xz/RU+4qHa9DK4DcovDB4YqMTsDqOXgtMbeECPVLUek
	797GjvDN58TQA8iYtduVXXZqE7XYMdcbP0aOeXMUl2ghb6F/LKghOsFJd2xC67uRTpZRPK
	VOdqa+2qkmqbwc7TTR6Nj0zwqNytB+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792793021;
	b=l9RiemA61c62tAbLj3Z0sLRYFa3UN/kDrHfXsAa/qF/6kDdKS2oA8jOfOGjDK5enMWUQ2B
	z9EV6K1y1K5iufAeA3pWKWIa88arP63QHWF3LDnLFWYujfVbFQrl7Tr2mbjV64BvNXLTLG
	yQwXQoQQCJGjSRQEQfzY/LmWMZG/6mE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmdzTSUQ;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEBDE43DC7;
	Fri, 23 Oct 2026 22:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6668A1F01825;
	Fri, 23 Oct 2026 22:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792793020;
	bh=6wvAjV3VEH0y9Aouo90x71QioxDU/M+tApVOpGKG9M4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cmdzTSUQyANuHLNiUCoQ0Q8a09G02viHHSxwqK0oyv0S5vaPVG1wdlGkfIbIDEQ3R
	 NH8vw0sMD87cDC5p7T7m3Jvhy4nmYk8mecpwsLM9hmSPBGd++j0f1LVUMzDttNLf4R
	 T1TbteL4RpFxJOflaRUdllhuVa7aIZ5eZ7cK6AvVLoJw/36YdbaROWtfjQE/62UpF8
	 9lhBF3ke25pBhvPNYwDqsiGhZfplQ9rhMcTuY8/qCiow92DQxTvFl3xLp2B0gZ6e6l
	 5ZylQSvAFoTJD01b4+DtathdTwjiArPznO7ksJbyrG3lGsbeuIvuTIHlkQVdtx5/DL
	 Q1ULVMX4lX0ww==
Message-ID: <sashiko-outbox-183273@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 07/14] mm/mglru: balance anon and file scan
 budget by refault rate
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, kunwu.chan@gmail.com
In-Reply-To: <20261022220203.91911-8-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
 <20261022220203.91911-8-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 22:03:38 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 97098160010
X-Stat-Signature: r765rz5o4nc743z5haffy6zw336dhxum
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792793021-251728
X-HE-Meta: U2FsdGVkX1/ojjXYYqyoceJwzoPn3t3Wt+hFfqqORxGGTkALkpBodnLsGyb7dluspQC2gO959cxJHYvDZf9h8eNwZNyL79Hhytevb6dLdurbbaJX2XXX0VQI9Whcl0B4QWY39ctGeS9Sm1Mle5MFbQuzpi+bo8pH3IZRqaknRIQmL/PmcMAXGGD3qw03ZvNAJhtDh5KKmeSDwcTiBabHafeIZ9EEhDiSfVqsjdgZUdZQNLIbRQTzGwptbqmVZNTcyZ/wEQCPUTHi/dZLXDx3VnSCHkuBzoCI5Q0bqsAMcOqTSS1tjMxDE2btaLwhfcD5ful0xAF7Ly+5qE+q2o3gT23k/4NFMYca4iQitW5ijXppIx9iEp6TZLkhez7xB7DuwzsnVaxyC2Q+mbU7HfVdchtW0jD8WET+MXOCq475vADZDipHyt5HZGb9ML+c2kZgNNCSTf3+SagWUQeqP6qiXz1qMqtm2sucdJqnWEhHQTNoWjcTWs5DSiV1j5xLeJWxm/FCG6VixI6RPlHYxYyM9+O9P0YeCv9136kPUW09m+70c27yKnTWqNMYAvHCoIVxZFV4BMW/gh/WgMbXUwOjtdXtxtZtzdz2hEmlndOJdFhSrPtV3Yo5JNJ0Bf+fTFM5EWtSbTrW1pIVOyIkgd5+SvSqYW4yOKT1YouaO6f8I6IqgL3lRUiE+e97ik8/APZnm34N6XjhQxxFLlyxU/rmmSkuD1xcrXWOcG1oiU96wmDDsL+r9UKuBYdUnuYr1JgMu/kO7KcY4pS3tWtsdb+DPZ/gVckr58z8AsO1PzMWSubkYeNw8O1MBWuWsbG7svh5KH4Nf0m5spIsQ0d1gHJSpnJ/kV04aLrjJ5opDfXXYO0lLtD7ac4K8BSAqOCtTYyiFqTFYha4qQaQeWrEAlUeqwhIqT7KfcS1pyKiaIPLu069mWF5SZPwwSjwrnAQzQKLd5pkjVbyYK1Hh1p/lnb
 bZwGLiCv
 DFXyHJylIQyzSsrZEW8ZmKyIkdnQ/IQsZFTq+Sg4aO3T7OrGsoYVc3Gp7VorPysAVxT0DOLmPn+XsVWlUrgZWq1O+0THVbVj0Trw5eGv5l6sxkJCnSsy2kPrkdSBZ2t34Wmyt+PrBKLHVlBeYCpKcx7vYd2nszfr1LlPzzwQE75htH/XhDYCimIpo6CLJC3KD1zSsfJ+J0KWWG+CcaYqkMTQsxnHUvlI7j8FV+YQ/rRbE/6dyIXBvaSvcBKT5dCMAqOBZwMeeFPF83vWd2s0Uz0XjmhmcbYjiFLtOfiSJ4jznZEP4InLrq2bqBSOm5LEJEDiAzzbUbbdNlL322cSkCp4QMRRUMLeAy+pdWtS6fw7B0qClguwXeUa83+kxeL6CE0NJOj8ReeHeqaVznH9HXzowpLYQPqB73Gs5Sz1Mlaz11PGjE3R+RSOJRGbNJAfAKNo3dKW8eJcnDaDoFDzTFViYWHX8qdnm6yc16tKaDQKPkECjBd1qKjYwqtMzHMTdjgbJxsPB2BgzZUjjS504Te40eFrybWEg1RMyl5yYbfac2npll+OoB8I3mUpXJXX29N1coaUY5eFPsZ6tlDAFUVFTcCkKOnJlTV3yWLJN5RqRdi7bh5ikm9oRZLeHkXbGyHDXn+8wErJQWb/SnGU6hxpoaxzB4u64u1PsVG4dFGqzaAd6ogb3HIf5frMq7v3Fz3xc0w+g9jAuzOjci79bWpc4T8nsGG7xY9Lx
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
- [Medium] mm/mglru: lru_gen_balance_scan() budgets un-scannable gens and z=
ones
--

commit ce196f9c0d172466d44f73b512ed408a9ecb6e36
Author: Kairui Song <kasong@tencent.com>

mm/mglru: balance anon and file scan budget by refault rate

This commit replaces get_type_to_scan() and isolate_folios() with
lru_gen_balance_scan() and evict_folio_lists() to split the scan budget
proportionally between anon and file LRUs based on per-type refault rates
and LRU sizes.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index cc20ba8c6cf2c..fed39b0422e01 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5019,79 +5019,110 @@ static int get_tier_idx(struct lruvec *lruvec, i=
nt type)

[ ... ]

> +static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
> +		unsigned long total_scan, unsigned long nr[])
>  {

[ ... ]

> -	/*
> -	 * We are running out of the current reclaim type. Fall back to
> -	 * the other type if allowed.
> +	 * The more extreme the swappiness, the wider the IO cost gap between
> +	 * anon and file, so the split should follow the IO cost ratio rather
> +	 * than the sizes. With a mild swappiness, balance the scan by the
> +	 * actual LRU size more.
>  	 */
> -	if (!scanned && !tried && type_fallback_allowed) {
> -		type =3D !type;
> -		tried =3D true;
> -		type_fallback_allowed =3D false;
> -		goto retry;
> -	}
> +	size_bias =3D max(1, min(swappiness, MAX_SWAPPINESS - swappiness));
> +	anon_weight =3D nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
> +	file_weight =3D nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
> +
> +	anon_factor =3D (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_wei=
ght;
> +	file_factor =3D (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_G=
EN_ANON] * file_weight;
> +
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

[ ... ]

> @@ -5212,22 +5244,22 @@ static bool should_run_aging(struct lruvec *lruve=
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
> +				 struct mem_cgroup *memcg, int swappiness,
> +				 unsigned long nr_to_scan[])
>  {
> -	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
> +	unsigned long total;
> =20
> -	lruvec_evictable_size(lruvec, swappiness, sizes);
> -	evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> +	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +	total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
> =20
> -	/* try to scrape all its memory if this memcg was deleted */
> +	/* Just scrape all pages calculated above if this memcg was deleted */
>  	if (!mem_cgroup_online(memcg))
> -		return evictable;
> -
> -	nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable);
> -	nr_to_scan >>=3D sc->priority;
> +		return;
> =20
> -	return nr_to_scan;
> +	total =3D apply_proportional_protection(memcg, sc, total);
> +	total >>=3D sc->priority;
> +	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
>  }
> =20
>  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control=
 *sc)
> @@ -5260,6 +5292,30 @@ static bool should_abort_scan(struct lruvec *lruve=
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

[ ... ]

> @@ -5948,8 +6001,11 @@ static int run_eviction(struct lruvec *lruvec, uns=
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
Can budgeting with lruvec_evictable_size() in lru_gen_balance_scan() cause
lost scan budget and premature reclaim termination in try_to_shrink_lruvec()
and run_eviction() when one type has no folios in scannable generations or
eligible zones?

Previously, isolate_folios() in mm/vmscan.c fell back to scanning !type
whenever scan_folios() returned scanned =3D=3D 0. With isolate_folios() rem=
oved,
lru_gen_prepare_scan() and run_eviction() rely on lruvec_evictable_size()
and lru_gen_balance_scan() to cap each type's budget by nr[type] and hand
any excess to the other type.

However, lruvec_evictable_size() sums folios across all generations up to
max_seq (including the protected youngest generations max_seq - 1 and
max_seq) and across all zones:

mm/vmscan.c:lruvec_evictable_size() {
	for_each_evictable_type(type, swappiness) {
		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
			gen =3D lru_gen_from_seq(seq);
			for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
				nr[type] +=3D max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
		}
	}
}

In contrast, scan_folios() only scans zones 0..sc->reclaim_idx, and at
sc->priority =3D=3D DEF_PRIORITY (or after the later commit "mm/mglru: lift
youngest gen protection for higher priority" in this series, which caps
scanning at max_seq - MIN_NR_GENS) it does not scan the youngest generation=
s:

mm/vmscan.c:scan_folios() {
	if (sc->priority =3D=3D DEF_PRIORITY)
		seq =3D lrugen->min_seq[type];
	else
		seq =3D lrugen->max_seq;

	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
}

When one type has no scannable folios in eligible generations or zones (for
example, after its cold generations <=3D max_seq - MIN_NR_GENS are drained =
or
when its folios reside in zones > sc->reclaim_idx, such as under GFP_DMA32),
lruvec_evictable_size() still reports a large non-zero nr[type] from the
active generations or higher zones. As a result, lru_gen_balance_scan() does
not cap that type's budget or transfer it to the scannable type.

In the proactive reclaim path (lru_gen_seq_write() -> run_cmd() ->
run_eviction()), sc.priority is fixed at DEF_PRIORITY. Once one type drains
its cold generations while retaining folios in max_seq - 1 or max_seq, any
round where the other type's share rounds down to 0 in:

	anon_scan =3D mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + f=
ile_factor);
	file_scan =3D (u64)total_scan - anon_scan;

(for instance, whenever nr_to_reclaim - sc->nr_reclaimed =3D=3D 1 for swapp=
iness
between 1 and 199, or for larger remaining targets when one factor dominate=
s,
or at swappiness =3D=3D MAX_SWAPPINESS when anon's cold generations are emp=
ty)
assigns the entire remaining budget to the drained type and 0 to the type
that still has cold folios. evict_folio_lists() then scans 0 from the drain=
ed
type, skips the scannable type, and returns 0, causing run_eviction() to
abort before meeting nr_to_reclaim.

Similarly, in regular reclaim (try_to_shrink_lruvec() ->
lru_gen_prepare_scan() -> lru_gen_balance_scan() -> evict_folio_lists()),
when evict_folios() returns scanned =3D=3D 0 for the un-scannable type:

	nr_to_scan[type] -=3D min(nr_to_scan[type], scanned);

leaves nr_to_scan[type] unchanged. While the scannable type still has budge=
t,
evict_folio_lists() repeatedly calls evict_folios() (acquiring
lruvec->lru_lock) on the empty type on every MIN_LRU_BATCH iteration, and
once the scannable type's share is consumed, the empty type's remaining
budget is lost instead of being transferred to the scannable type.

Should lru_gen_balance_scan() bound each type by the size of its scannable
generations and eligible zones, or should evict_folio_lists() transfer the
remaining budget to the other type when evict_folios() returns 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022220203.9191=
1-1-baohua@kernel.org?part=3D7

