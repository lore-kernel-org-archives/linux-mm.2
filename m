Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F17606A338
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aM6nEZLq
Received: by kanga.kvack.org (Postfix)
	id B80D16B05BE; Tue, 10 Nov 2026 15:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58476B05BF; Tue, 10 Nov 2026 15:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46786B05C0; Tue, 10 Nov 2026 15:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 766176B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:56:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 182311A0115
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:53 +0000 (UTC)
X-FDA: 85420418706.20.56BC44E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7D4AE180007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aM6nEZLq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344211;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l77mzptpwFPR69Saw7xaFPb7rD+qcd5bq8eRbzHKKIY=;
	b=lW8AwoI+DAMeEMwXX1d3UHpK2JgL7TMPyG2aUVpyr2FvD09uYs70jVgXnXxAitiwQMlGjL
	DqDC312A0dIisbS05Pfx3somJOHy6NUwDxd2JBJ42af7pJdjra9RgLq0AhXVKkvwsB3NTq
	Dvua0NmLro368ddNNZ4mTNypO2q1jrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344211;
	b=CF/gEWkXf0fDepufDvb5tFQY7Is6cf2eWIP6fEig8OdqcLtMw5HMDhQ5rF7PkZ3NSFOugF
	TlsC8snddrZ1IaFwV9rqf67UqBq0OXYoVxn5hKbzCDUvGADzraoECVOecx6Mcj65N4FDWm
	pyhO0kZSCDL7GWIOe3yJ6rtaPQ6Lm9U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aM6nEZLq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C640060A00;
	Tue, 10 Nov 2026 20:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EC11F008A1;
	Tue, 10 Nov 2026 20:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344210;
	bh=l77mzptpwFPR69Saw7xaFPb7rD+qcd5bq8eRbzHKKIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aM6nEZLqP70IOJ99Bu2pJZi/7lfHToUXB+dYLQ2QGxfipdJuUBqzmAiUHUaLUw3Bf
	 8ZDgpZcQfLoMrZox+KbAi48AKhuyqSWz3hs/0E/wTcLDwoNhCuKTEOECYTKSB0nic4
	 gjy0bSaWHnmMfWuAZU/E2vkqO4pKWnkR4OlvLmnDiIH/zGOw3aMXMwP2Lv5JhXSFEe
	 Q++f7GCMO8RyC6IJtX+a07TD1von15A0EQFYZyLSwLOzoHvii0Uc8P5YaMHX8RM1Hd
	 aryutegQu/Iy3N6b8K7kY1Qq60h0eNJ23rQChiNXGq6qDxnkvd2lg9OHDN/m0BQJuL
	 Twt52rwHwDt2Q==
Message-ID: <sashiko-outbox-207752@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/15] mm/mglru: Avoid scan anon while swapcache is
 low for GFP_NOIO allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com, "Kunwu
 Chan" <chentao@kylinos.cn>
In-Reply-To: <20261110202025.25736-16-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
 <20261110202025.25736-16-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:56:46 +0000
X-Stat-Signature: jjgijhhzq94166w1b8ny84grahxi3ni6
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D4AE180007
X-HE-Tag: 1794344211-676235
X-HE-Meta: U2FsdGVkX1/VP8Gnrz+iHvXfttZrrUXyWeFyhm+TlpX6G92k4xo8DjvX+zAtk2lw+uma9V396EyKChknb5afidsPnjNF7X+Qqqtqqh6oO0taYsGDdYzx5ZDrtZJrTQx9zIUqF1wb9ZExxGmr6uD65mOwEc5I/HqcIrmbwTKPIvH9TawGC0v7/yZXNO4OVc6BuWRiHMNyrML5D4hlO9JccntAwsP7RDHehA0J5KmZpCXJ/jidet9oZR0tZqRuqIsE/8KZILL2zPC84EcRuSbX/cTaIeMjmqrkz34Y1HiBBT6U5cg7l/jODd/BzC8A+3lysfradhrN50LqF4OOs2Y093GfGf2gGrvXMy7LG3JUS8zqYJsFZN45rNjemaJmwxjMPSpa4Fhh+gUlRrAsJQyjqYJKO6noTeTkPjaf40OaMlytleysjA8L+kC/ocKPkC8RpTuxr2l3jrFFOGAbEkeTMTypeI6dzgIYtYaEKg9CYf/0EA5I6uSWN2RdePaCCZgcICCXhzXb2QwuWHmfIbcqbnhC68r0BJ6CPWx9X6lDtt5GEc+7uN2XuBlIiAHExhpy1ZPoOsUs9CaJu8CHAYVxV3yCTiwfIhD05EBvAhEgZKQjDnsXrVD1OUSTten3ud9LlV+aIR41nsgJkJKoUJc2nXJfPy5K3RUT2Slcpl94REZ1zB0u9n0DLAxTRkZfnCx5EbfnyniUD0H/itjvWAPOPe0+u1Wvi/obm/8dPZb2Eu8MxJvK6eOs4a7dvVvPG2nOYO9dJY8OIyMs0mGNtdbKJ7JGFBJGIOAfGSigMujNpsn9UNYCGXwOb39QYx/2Sq8dx1jHq+oz7YB0mzV18iGRjpIaX6jCd9iBO0tX8IOdr2CMgSc8MPVdsGWm1rmRKvdH5jMMwFPvKnT/GEAr/6H6z/QXjNGG+U5icImhBV9hqgRpFTz2vNJyl4OIqEJIQDrIuALiAhD79wn/VPjPB9u
 rwc43F26
 zlirIy9vCFdcUsrPmALCh84qOpocUkDYo+KsoIt3PXf7nG74hNw9FDu33ET+dc/l2wcx3F9CGmDQfSnjaKgFcxZtrR0UF/b1aUqYYh8a32Ff2aMc18uDXHT/R1cpuiPSXdyUVk1cUkRoeYWQ4bYBVXg+mEpQd8TFz/LCIpxKbpFRp08G7i0UHf329Hl8UvJktk5njIzVqOOwPClGdCc8p2QNt/DLjP4ugr1Jrux4qLYnLvF0bkD+TFh9W0+D9qtgpa0VPiActb0XxYXHsfrBJvAcurKJ0UXdNfgfVxuM9DgG/YwQxZMRlmbYpYjETEbD5IuFEaX5c0KmvSidqQVZ2lWV/aekdtXV4w/T1wPlUh9d9NBq3dN65DSjlsI9XWU6t6gL57B/OG+hLcJl4tz7GeO5eDW1XWz6zAhY7SyBVFv1OuHL2v5wuufu66cJkE16twvqetlTuZgd4vHSRJOZ9oLlpNlqNgr2pRgyi46tRQiXs68/lqsb7IcW9mtof6X0N/Mk4Qdluxuqv9pSFYMtuGkYQFEHA3aNldzYNAtVIKGpqxRRCMaUKDLhjiMeLkks0svhikGjzjZdvYhJ8x3m0wi4FBX/zzNFwz8N2nlEE3ZyM4Y9vcy4BUBhbTTsBCj2x4gU0lupuJ3OCbxp4ZYa7meLGblwgHcOr3LzUz6VmfeqQErwWc40RRp08RD9FW5K9x0UoMgMu+ZnsOSA9K/28lBT3EMbjAfC2Ac4wDEZOeUHiy6lFUPkzsCBkIkXLJrjIQMrjdgYUzJTFcSk=
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
- [Medium] mm/mglru: stalled GFP_NOIO aging in should_run_aging() due to
  min_seq clamp
- [Medium] mm/mglru: should_run_aging() calls reclaimable_anon_is_low()
  directly
--

commit bc0f15f68a4ac3f563747aa1e1cc7d4d0f14a37d
Author: Bo Zhang <zhangbo56@xiaomi.com>

mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation

This commit skips anonymous generation scanning in MGLRU during GFP_NOIO
reclaim when swapcache is low by excluding unreclaimable anonymous pages
from lruvec_evictable_size() and adjusting lru_gen_balance_scan() and
should_run_aging().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3793392208781..fa0245a07caa6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -4206,12 +4199,14 @@ static void set_initial_priority(struct pglist_da=
ta *pgdat, struct scan_control
>  	sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>  }
> =20
> -static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> -				  unsigned long nr[])
> +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_con=
trol *sc,
> +				  int swappiness, unsigned long nr[])
>  {
>  	int type;
>  	unsigned long seq;
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +	int nid =3D lruvec_pgdat(lruvec)->node_id;
>  	DEFINE_MAX_SEQ(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
> =20
> @@ -4219,6 +4214,8 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, int swappiness,
>  	nr[LRU_GEN_FILE] =3D 0;
> =20
>  	for_each_evictable_type(type, swappiness) {
> +		if (type =3D=3D LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc=
))
> +			continue;
>  		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
>  			nr[type] +=3D lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
>  	}

[ ... ]

> @@ -5113,12 +5106,19 @@ static bool should_run_aging(struct lruvec *lruve=
c, unsigned long max_seq,
>  			     struct scan_control *sc, int swappiness,
>  			     bool do_balance)
>  {
> +	struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
> =20
>  	/* have to run aging, since eviction is not possible anymore */
>  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
>  		return true;
> =20
> +	/* run aging when GFP_NOIO limits anon reclaim with few swapcache folio=
s */
> +	if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &&
> +	    reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
> +		return true;
> +
>  	/* try to avoid aging, do gentle reclaim at the default priority */
>  	if (sc->priority =3D=3D DEF_PRIORITY)
>  		return false;

[Severity: Medium]
Can min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq ever become true here
when LRU_GEN_ANON has four generations?

Under GFP_NOIO with low swapcache, lruvec_evictable_size() skips
LRU_GEN_ANON while get_swappiness() still returns a non-zero swappiness in
[1, MAX_SWAPPINESS].  Because LRU_GEN_ANON is not scanned, its oldest
generation is never emptied and min_seq[LRU_GEN_ANON] stays at
max_seq - MAX_NR_GENS + 1 (which is < max_seq - MIN_NR_GENS).  When
evict_folios() empties the older file generations, try_to_inc_min_seq()
clamps min_seq[LRU_GEN_FILE] to max_seq - MIN_NR_GENS:

mm/vmscan.c:try_to_inc_min_seq() {
    ...
	if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
		unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;

		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
			min_seq[LRU_GEN_ANON] =3D seq;
		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
			min_seq[LRU_GEN_FILE] =3D seq;
	}
    ...
}

With min_seq[LRU_GEN_FILE] clamped to max_seq - MIN_NR_GENS,
min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq is false.  At DEF_PRIORITY,
should_run_aging() returns false and scan_folios() scans 0 folios from the
already-empty file generations.  At lower priorities, evictable_min_seq()
still uses min_seq[LRU_GEN_ANON] and lru_gen_imbalanced() still counts
unreclaimable anonymous pages in old[LRU_GEN_ANON], stalling aging across
reclaim priorities.

[Severity: Medium]
Should this check !can_reclaim_anon_pages(memcg, pgdat->node_id, sc) and
swappiness <=3D MAX_SWAPPINESS instead of calling reclaimable_anon_is_low()
directly?

When CONFIG_SWAP is disabled, the reclaimable_anon_is_low() stub
unconditionally returns true even for __GFP_IO reclaimers:

mm/vmscan.c:reclaimable_anon_is_low() {
#else
static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
		int nid, struct scan_control *sc)
{
	return true;
}
#endif /* CONFIG_SWAP */
}

On a !CONFIG_SWAP system with NUMA demotion enabled (or on a CONFIG_SWAP
system during GFP_NOIO reclaim where can_demote() is true),
can_reclaim_anon_pages() returns true and lruvec_evictable_size() includes
LRU_GEN_ANON, yet should_run_aging() treats anonymous generations as
unreclaimable and forces premature aging at DEF_PRIORITY whenever
min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq.  In addition, not bounding
swappiness <=3D MAX_SWAPPINESS allows SWAPPINESS_ANON_ONLY to trigger this
check even though file pages are not evictable.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.2573=
6-1-baohua@kernel.org?part=3D15

