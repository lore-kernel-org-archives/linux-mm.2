Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2E0606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cWDNdnBD
Received: by kanga.kvack.org (Postfix)
	id E4E8E6B05B7; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E261E6B05B8; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE546B05B9; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6FCE6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C3D41C3ABE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:06 +0000 (UTC)
X-FDA: 85425267732.30.A09ADC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE6BE180006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWDNdnBD;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459665;
	b=BJtc3C+VzPWwQFhAeIiV1j9o0NtzjEQBOhX1SmAGPZeDhfJUoGZCJiuIycTXo0HOdS3EFV
	BCXyETa0Knh46nGm4yDiLMaSEoNAIruMTp9qEgR52n4DMBGQXs5vTGCyBghmwbnotp4q30
	f7HBrehq+OTPNyVBx48Uo9bRcQ4HvTU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWDNdnBD;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459665;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Nu9LOma8jfstVG78SUDswJ8AQ6NC5xeWdliTGdX6gU=;
	b=zeahw+9lh72lWRgXueKPvHIuRBCt220JKVNVCTVH+Cq2LpM2jA3yE1PsUvapFfjO0i6NY6
	gcHT0b0Pyx8OwXkY4Khq7mnMGQJ7FJnZ0purqx3KbaaqLNhMXUkuBncqQVQC8jtnYDBsLq
	OEjQtsXiuA3dy01NgYOutMDRQTPp4es=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9206D6371F;
	Thu, 12 Nov 2026 05:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19541F00A05;
	Thu, 12 Nov 2026 05:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459664;
	bh=3Nu9LOma8jfstVG78SUDswJ8AQ6NC5xeWdliTGdX6gU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cWDNdnBD3gn0gr13n06d/h8uE3X2Rs+TIm7B0aBarbcBFQqJIK/u1wJ8ZkkKkliAZ
	 getCx2aHWlKCzumgHuZrDk9W3dbYAMS/7sl7/znxU1RRk1s3UJB0l6hPSGapLpechl
	 9ctse5hXVcQTJf5uHprDHD1yXg62+MchBRD8l0XVmWGQZHhF9sZwZqJaIYCJmqbGuG
	 fXwCL3jkn598hOM/PM+MFJ87hqbIeA6Qe3gzfVS3doeakJCYVJyg/6ejQxk/TY/JkY
	 a8vQ9MC+QaW7C/BOmShiobMKCIv8hloG+gcFSPOcG5anrD0dR+C6avBpkVP16H5CaI
	 ymSTzElE8ZeZw==
Message-ID: <sashiko-outbox-210415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 07/16] mm/mglru: balance anon and file scan budget by
 refault rate
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-8-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-8-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:02 +0000
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE6BE180006
X-Stat-Signature: 3mr75bc31z9aq3frtxei73xm4gnrnkqz
X-Rspam-User: 
X-HE-Tag: 1794459664-258255
X-HE-Meta: U2FsdGVkX1/2NwDzKLgRrFZu8uNPAjRJXBq9jwQ54cHMF5Gm1r+yziNm4h/Is/4M0pPzhQXGqn9qrlZLyHR5aUgJdmoFnUiMelDJ4f5Th6AkxUPpW0pH5ZcSOZlRaBqm3Zk/I6Qw27CDeeRz25gCdtofl/veqVcvUbfF+c0sAtPxgPXiTC74mT3ckHXwPXuSB/lT7N2NUycC2cXsUk5B0On5rjOKstWb0GZ8iyhb45JD4+TXIGUr7p2egdKYRbzTUOHNXxYy77Zogv9zVWNKC5qtAu1AptZ7L11Brd9Vt1rRZCinlq0CkgzrIxqDdmyvFZ6E7wSUfFj/VMiVwDFtEwrdfPX5r3F7OvVtGodoOEIqOSqgJCgPsBnmyl+9qas6iFMA4Tv8+LK0u8fJNLbpzfQhRmTiXGSK8Ix1+u7sdkdvBx9Gr7VWsnMFU8qOf3ij9cePp+ytFMndfjjFYvhmk/GgG7Uao6Z+FPRlP/ZCzq9HCQ7z5liBOJhqfnKPKEqzK4VumG02SKaojhKHfw8HMryWv1EmQyTMg6YRpjtRxxGmj+As28OoF/Z2CU0ZJJU+E8czHfyFvyvav7oS58thpPjuildgUFoabBX6RwuNtL7R6gZKu/tyQJiRf/+ewl8a+qxfDGo2nCa8dr8nUVJl+UDJ0JT7APQuuAV1b8+NaXJazvQ5dikv8GScPOWabHvnQIZVHyzfH1U5MBi91jW3cQkIukHBN24GPy5DjOmcuOEahuyLH9lFoYL+EgbBWMK+i9rjxm0XIp4DpbYCnabQNmV1RrgMXQGXrD0LXEpxcKsfu8Ri27J3Fu70I07fd/sJDPBDihi5DKuQd1TUfcl+Wf869DM0xRhYIa82RPbzEAoNrc6DLQzbqcmTzHeIq9qcO8t4bv/uWnfRU0q76qq5osiSZTiFN3GLWuVr5G1EGkp/5hYT5ekQg6v0bvNpiq9gC04DCujxejPQ84HGSTv
 ftTAdKex
 JVETn+dFJT1K6EqNqGy/D5PspkgkOiuY8M28X2TEPj2JqQyHVNVDn4va1Tg2xzEq+rA97ycB+AGjdud+T1hdqHq7FVWC8nPoYAaYLfDvHmhD+rdyliOf0Xf/Skh91k4cweus1xPPYOWXnnZs8wkmqpQfUiTCOZZhgwHeZCEb3V848v/3v9SABXu4/WYAEPAVWvD56+EdY/5jV+n7mVVLqQ6pqfSi3+Wd4uDb7yHLdo8ldIsat4WhbAFI/lrQfMfWBkut5ltjx8p8e2dI9OxzmCtiFA312KUCYoEYErpy8zVjHyuRivzj6uT2sCAEzXqfM86z/YbuhAH8uKAJ97aZVQ0OSvsFfu4zREJk7ZH94qe1IZjcGynUS47Kojdizn8qaBi+JUyXR58NJ+i5ncFEwucT/zv5yRPabB16G6pVcIE24mY2FqBXGHVs4Bq57cPSm/wYLEateK545Dg8mVAVWK68X/KaMzhYMumkdD3AODMXNaj+XU11aCgulUu5ffa3M90KAO0qxUwbAptKOWu79sVtN3hZre/HUgd0zR47Etem0VQV0uf8/9d78XuwS1LbwErxEmftU6TRHuIsjFXNx9kz9Rv0346D5mHnuXio2DzhwR5qMfCqP4MGXVSzyHLbIph1nWfERcnD4Dihv6I9ow2Wbhlyt+yvMlauJVSEt+9FukMj3VR2EgKXYtKbAeAxsnNVaLkhqwNga2DjNuz3I0h4KMZpP2zH1FsVNSS+1Mrvwc8g41jI39y5F4g==
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
- [High] mm/mglru: non-real-name handle in Co-developed-by and
  Signed-off-by trailers
- [Medium] mm/mglru: missing DEF_PRIORITY initialization in
  lru_gen_seq_write()
- [Medium] mm/mglru: lru_gen_balance_scan() budgets un-scannable young
  generations
--

commit 730defb97ea747f35c6996e786706ce8e9143280
Author: Kairui Song <kasong@tencent.com>

> mm/mglru: balance anon and file scan budget by refault rate
>
> Replace get_type_to_scan() and isolate_folios(), which selected one
> type per batch, with a proportional split of the scan budget between
> anon and file, and scan both types each round.
>
> lru_gen_balance_scan() splits the total by
>
>         anon : file =3D swappiness * r_file * w_anon :
>                       (MAX_SWAPPINESS - swappiness) * r_anon * w_file
>
> where r_anon and r_file are the per-type refault rates scaled by
> 4096, clamped to [1, 4096]; a rate at the 4096 ceiling means the type
> refaults at least as often as it is evicted. The w factors bias the
> split toward the LRU sizes at mild swappiness and follow the IO cost
> ratio at the extremes. Both rate accumulators start at MIN_LRU_BATCH,
> so a type without eviction history reads as 100% until evictions
> accumulate, and the floor of 1 keeps a type that never refaults from
> zeroing out the other type's share. Swappiness 0 and
> SWAPPINESS_ANON_ONLY keep their single-type behavior; at swappiness =3D=3D
> MAX_SWAPPINESS the file factor is zero, so anon gets the whole budget,
> as in the classical LRU; swappiness 1 no longer forces file-only
> scanning as the old code did.
>
> The proportional protection and priority reduction are applied to the
> total once, before the split, and each budget is capped at its type's
> evictable size. Regular reclaim derives the total from the evictable
> sizes, so the budgets sum to it. The proactive path re-splits the
> remaining target each round, so eviction keeps working while either
> type makes progress, until the target is met or no progress is
> possible. The debugfs scan_control gets .priority =3D DEF_PRIORITY so
> eviction starts from the oldest gen and reports the default priority
> in the tracepoints.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: lyugaofei <lyugaofei@xiaomi.com>
> Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

[Severity: High]
Under Documentation/process/submitting-patches.rst, Co-developed-by: and
Signed-off-by: tags must use a real full name rather than an account
handle ("lyugaofei").

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2ddaf6181c5d4..d7b4e36cf7415 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[ ... ]
> @@ -5052,18 +5084,18 @@ static bool should_run_aging(struct lruvec *lruve=
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
> -
> -	lruvec_evictable_size(lruvec, swappiness, sizes);
> -	evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> +	unsigned long total;
> =20
> -	nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable);
> -	nr_to_scan >>=3D sc->priority;
> +	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +	total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
> =20
> -	return nr_to_scan;
> +	total =3D apply_proportional_protection(memcg, sc, total);
> +	total >>=3D sc->priority;
> +	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
>  }
[ ... ]
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

[Severity: Medium]
Can lru_gen_balance_scan() assign scan budget to a type whose scannable
generations are empty, losing that budget instead of handing it to the
other type?

Previously, isolate_folios() fell back to !type whenever scan_folios()
returned 0.  Now lru_gen_prepare_scan() caps each type's budget by
lruvec_evictable_size(), which sums all generations from min_seq[type]
through max_seq:

mm/vmscan.c:lruvec_evictable_size() {
    ...
	for_each_evictable_type(type, swappiness) {
		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
			nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
	}
}

At sc->priority =3D=3D DEF_PRIORITY (or sc->priority > DEF_PRIORITY / 2 aft=
er
commit "mm/mglru: lift youngest gen protection for higher priority"),
scan_folios() only scans older generations and cannot scan max_seq - 1 or
max_seq.  When one type has drained its scannable generations while still
holding folios in younger protected generations, lruvec_evictable_size()
reports a non-zero nr[type], so lru_gen_balance_scan() does not transfer
its share of total_scan to the other type.

When the other type receives a 0 share (such as at swappiness =3D=3D
MAX_SWAPPINESS when anon's scannable generations are empty, or when small
total_scan rounds down to 0), evict_folio_lists() returns 0 and aborts
try_to_shrink_lruvec() immediately even though the other type still has
cold evictable folios.  When both types receive non-zero budgets,
evict_folios() returns 0 on the drained type and leaves its nr_to_scan
entry unchanged, causing repeated no-op evict_folios() calls on every
MIN_LRU_BATCH pass before discarding that unspent budget.

[ ... ]
> @@ -5765,8 +5818,8 @@ static int run_aging(struct lruvec *lruvec, unsigne=
d long seq,
>  static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct=
 scan_control *sc,
>  			int swappiness, unsigned long nr_to_reclaim)
>  {
> -	int nr_batch;
>  	DEFINE_MAX_SEQ(lruvec);
> +	unsigned long nr_to_scan[ANON_AND_FILE];
> =20
>  	if (seq + MIN_NR_GENS > max_seq)
>  		return -EINVAL;
> @@ -5782,8 +5835,11 @@ static int run_eviction(struct lruvec *lruvec, uns=
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

[Severity: Medium]
Was .priority =3D DEF_PRIORITY accidentally dropped from the scan_control in
lru_gen_seq_write()?

The commit message notes that the debugfs scan_control gets
.priority =3D DEF_PRIORITY so eviction starts from the oldest generation and
reports the default priority in tracepoints, but lru_gen_seq_write() leaves
sc.priority zero-initialized:

mm/vmscan.c:lru_gen_seq_write() {
    ...
	struct scan_control sc =3D {
		.may_writepage =3D true,
		.may_unmap =3D true,
		.may_swap =3D true,
		.reclaim_idx =3D MAX_NR_ZONES - 1,
		.gfp_mask =3D GFP_KERNEL,
		.proactive =3D true,
	};
    ...
}

With sc.priority =3D=3D 0, run_eviction() -> evict_folio_lists() ->
evict_folios() -> scan_folios() takes the sc->priority !=3D DEF_PRIORITY
branch (seq =3D lrugen->max_seq) and can evict from the youngest generations
whenever older generations of a type are empty, while reporting priority 0
in trace_mm_vmscan_lru_shrink_inactive().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D7

