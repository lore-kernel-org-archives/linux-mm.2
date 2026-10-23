Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E90C606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RweT/F1H
Received: by kanga.kvack.org (Postfix)
	id 485156B0BFA; Fri, 23 Oct 2026 18:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C8D6B0BFC; Fri, 23 Oct 2026 18:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BFC6B0BFD; Fri, 23 Oct 2026 18:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E46C46B0BFA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:03:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7797614026F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:41 +0000 (UTC)
X-FDA: 85355268642.30.D7D80B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C38FB4000F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:03:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RweT/F1H";
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792793019;
	b=GfWUg4qNYdsSeexQ7Oh5Rz9Mvjk/dctMz1qsR4eJZF2CQBZ30GAHa+ww9wQCO3w0iwbXSp
	bKbHJreiQGoDu36l34kUSculiRB7gopNwIEnRrgTyTMMnZmZ75+SrX+JuK9oUZO0q+KmgE
	dcEZckqzL/FHF0pC1WIUcKBkr+8Vm2g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RweT/F1H";
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792793019;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft9euXcxz0nyHm86ze20y9BqlJeloBnjUZKZ404qvF8=;
	b=PrbVMCIIGWYqXng7x8tk00Bl57A5+S4Nd90IWgcVm9xFmKPYXyhSnEDYWBbLC0zQgvsWLp
	PTxRB10DfH5T0bRE63VOJv4BjLbNUS+NjszVJYShmcSEI4SGy9zN84LbeomYTO8h7bz+jH
	c+YuKmAOImWMhEWgBtx6NIpLoWxTInE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE3EC416F1;
	Fri, 23 Oct 2026 22:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FC41F01825;
	Fri, 23 Oct 2026 22:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792793018;
	bh=ft9euXcxz0nyHm86ze20y9BqlJeloBnjUZKZ404qvF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RweT/F1H6RScQkpPNRMj/TQqH7ArDdSlsXJrPZQnYPxfZALmYIy2h8sldgRck5ryV
	 8dzkzY6ilYJl4ixDsD0SdeBTmPE6j70eqVPSkW+AvwXvHhWXvRPRSn8cBfg0n5aSXS
	 kqEFcRm4JLB6XP6yDXy4D3/XxPBwfVs9xZWPH8EJgc1UxnaXxszcH3v/uTM9KEmEX+
	 QVKmdQtQpJMpM13KozVCuVY4heGBrvVb2FZIA36hteQMWva7qIuE499vtPfCrxTGvW
	 5Zba8zG5nWJ6zmx78PePl29Pz6yNKp8wfucjwksD1PeoTWFjuYnvjUuRLDOvLMk7KP
	 smq0GXMXDfxhw==
Message-ID: <sashiko-outbox-183271@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 05/14] mm/mglru: skip zones above reclaim_idx
 instead of rotating them
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, kunwu.chan@gmail.com
In-Reply-To: <20261022220203.91911-6-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
 <20261022220203.91911-6-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 22:03:37 +0000
X-Stat-Signature: 97dcfhgfdkf7xhrcwenshae1rocbnfrs
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C38FB4000F
X-Rspam-User: 
X-HE-Tag: 1792793019-977430
X-HE-Meta: U2FsdGVkX18ccT/QfXfUFlu6Wvqk0t/m4HN2YLFeuHTOFZpYy6nA8dUMnNC8YM2xB0FjYNJ/vyqUeJ8f1Sd+37HS9Cpa3GHIvqx7n1LPvLFUwYAdHH+OCLiu+lfZgKMdn4x+XgahwK35xGveJNvvUZVTYJSKka8j7233h3TAp4q3uAR96cK+JFendYFaz75JT89G3XLiipe+qQDCytuOQWHaTe+2JplvFoyZ81bwmkRE9GEuIss7nf/gzituR/JlmsP6GrXw1SuKoLfqremHOL5Ylj0+kSjeu7zX3rOeMzP0zq3XuF99p1aiRUIL2WdjRQsIMZAfPQl1iJ5OaJ73+IG9svZoWVtPKh/cwvzig5iOWPvEf+vB6S6tYSd/mvfW6oGy7d3uYZP3IRnYyouRTf7PxdQR9OvO/n9F/fq3U6G2utGyKcFHnQ8hvnEn/+qxZZgROLidrI1pruG3OsQ301dqVzSKSLqtfFfQQEjoUWs7TFK0eu2eP7FksFmY4ZMBC8cYYwG3xDNJw1b8LeY6gYMZGAxj5jxJH2/Q6O5wC0ZQMi9ai9OLIAOhQpbG0pg692mSHk+4rtfK8aIDn5FUXSR0nNBO66tzaDqndtUkAlHtG1jo5VxTz4TAC+gkygEBgFl8c8jmqiXg8wDK2kAGAnuP/5hHZ4SDIW3tgtEzCPMhHQmPJH6ViJufocSQKJSsmMh9fuVvTy5ffZCcPJicR8LZl52Q8U2YVhTUUflyAmYrkDtYEc7s7sLdLYTll0AcoNAJqVlR+Y1OlQr5hx63jdfJwtb2NZ6H1ghmmi4rZo0QDmZqtdC8oxum9hP+aUiAj50Jd5UEAVMPd7Mn/LJlhGmj0GVUVrt3OaMwRmbFQpVmJwuVo0OyO92v3RcagnHfnY/hH4qYAyCHyFV+TZHfzQYP6CrZuzdSP6OpPcd06Kw8dr/EaD/8wnlFyPLU1bphjwdLjXHD5+X6SLUtSe3
 e8Mh5Bhi
 fECFS7BtlMPHWnY/8uASsJ2RFhhOaNqzwUsoSD/C6XMT7Hj76L/aPsVc+502vzAoccOuJ5luSDBOz8GgY/lf9+lSQLtJEID9JbZgaNOCREF3tPHiyvTY3XEudr3HQHayUtcRqUszg5yndAl5jdXrZLsDUMtyt8/DvFUcUOwcmgZKHuxqFTzzuPErrpJMXKeWsJp0PIuQBRGk3fP1dgBhfUY+ByJx0mhnNi+p7bez/VwX/NWWSYpeVrbLagjG7j/oMQFxRudUUA4BeV5nurFjVKjSRHGgI+a/LeKLZKWsWWqAH6SochjEdSEjeWv/XO/b/LBCA0ZCqYvwdLhDSSodrHVFFs+LggzhEAwFnYDzd2QBjZCy93PSKEnqMvwMMIFrAN35jNpWNzK64zCChwCSUDitZhTqSElWWdPrbcW/t8XnSpJYKVJpcuXfH/+E14gBf29DSVKGJ4o/QSRGl6vJjeP4i6zM4s0ySBFfr/X1/eBpZvj2pae1h6VE+ZK291g1w71Iiu0D5nMfRcK0HyICm3a92oIXQOJwN9/iWa7ssqdOhTgfuSUuLGo57KSld0lIy5sYFSw1+kxj+o0qYbIvpwFF5g5YbDR7LEED3lQBSlEERhTeF9wRjiL0Y6GiAvMLgBebbE9LkO+I4F5OIM1WRkwwSJoWfTOfhqFCc/fYQe6cZRYAjjvrrH0Gjg1mocaeROPxhomOv1mftfx94WGqnhcGuVgYakcVXauF7OacJ7t4IdCwy6igbaPPawJ9r1fJyqJfGNTCo6mbV5DQ=
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
- [High] mm/mglru: pinned min_seq in higher zones stalls aging in scan_foli=
os()
--

commit 1b2f683d6b8bd1e171eb9677315ba8a3d9431b9b
Author: Kairui Song <kasong@tencent.com>

mm/mglru: skip zones above reclaim_idx instead of rotating them

This commit restricts scan_folios() and lruvec_populated_min_seq() during
eviction to zones at or below sc->reclaim_idx, and removes the ineligible-z=
one
rotation branch from sort_folio(). try_to_inc_min_seq() continues to check =
all
zones up to MAX_NR_ZONES before advancing min_seq.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a365a4bc8c988..09ea72b354a56 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4132,7 +4132,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int =
type, int swappiness)
> =20
>  /* Similar to lruvec_evictable_size, return the oldest populated seq of =
the type */
>  static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int=
 type,
> -					      unsigned long max_seq)
> +					      int zone_limit, unsigned long max_seq)
>  {
>  	int gen, zone;
>  	unsigned long min_seq;
> @@ -4143,7 +4143,7 @@ static unsigned long lruvec_populated_min_seq(struc=
t lruvec *lruvec, int type,
>  	min_seq =3D READ_ONCE(lrugen->min_seq[type]);
>  	while (min_seq <=3D max_seq) {
>  		gen =3D lru_gen_from_seq(min_seq);
> -		for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> +		for (zone =3D 0; zone < zone_limit; zone++) {
>  			if (!list_empty(&lrugen->folios[gen][type][zone]))
>  				return min_seq;
>  		}
> @@ -4166,7 +4166,7 @@ static void try_to_inc_min_seq(struct lruvec *lruve=
c, int swappiness)
>  	/* Requires at least MIN_NR_GENS gens for basic functionality */
>  	seq =3D lrugen->max_seq - MIN_NR_GENS;
>  	for_each_evictable_type(type, swappiness) {
> -		min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, seq + 1);
> +		min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES,=
 seq + 1);
>  		if (min_seq[type] > lrugen->min_seq[type])
>  			seq_inc_flag =3D true;
>  	}

[ ... ]

> @@ -4863,10 +4864,8 @@ static bool sort_folio(struct lruvec *lruvec, stru=
ct folio *folio, struct scan_c
>  	 * longer be promoted or protected, so just isolate them. The one
>  	 * exception is lru_gen_reparent_memcg(), which is handled above.
>  	 */
> -	if (min_gen =3D=3D max_gen) {
> -		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
> +	if (min_gen =3D=3D max_gen)
>  		return false;
> -	}
> =20
>  	/* protected */
>  	if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDTH) + 1=
) {
> @@ -4883,13 +4882,6 @@ static bool sort_folio(struct lruvec *lruvec, stru=
ct folio *folio, struct scan_c
>  		return true;
>  	}
> =20
> -	/* ineligible */
> -	if (zone > sc->reclaim_idx) {
> -		gen =3D folio_inc_gen(lruvec, folio, min_gen);
> -		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
> -		return true;
> -	}
> -
>  	return false;
>  }
> =20
> @@ -4921,16 +4913,17 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  		       struct scan_control *sc, int type, int tier,
>  		       struct list_head *list, int *isolatedp)
>  {
> -	int i;
>  	enum node_stat_item item;
> +	int zone_idx;
>  	int sorted =3D 0;
>  	int scanned =3D 0;
>  	int isolated =3D 0;
>  	int skipped =3D 0;
>  	int gen, max_gen;
> -	unsigned long min_seq;
> +	unsigned long seq;
>  	unsigned long remaining =3D nr_to_scan;
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +	struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>  	DEFINE_MAX_SEQ(lruvec);
> =20
>  	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> @@ -4942,24 +4935,22 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	 * when under pressure to respect swappiness more and reduce IO cost.
>  	 */
>  	if (sc->priority =3D=3D DEF_PRIORITY)
> -		min_seq =3D lrugen->min_seq[type];
> +		seq =3D lrugen->min_seq[type];
>  	else
> -		min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
> +		seq =3D lrugen->max_seq;
> =20
> -	gen =3D lru_gen_from_seq(min_seq);
> +	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq=
);
> +	gen =3D lru_gen_from_seq(seq);
>  	max_gen =3D lru_gen_from_seq(max_seq);
> =20
> -	for (i =3D MAX_NR_ZONES; i > 0; i--) {
> +	/* Scan eligible zones in descending order. */
> +	for (zone_idx =3D sc->reclaim_idx; zone_idx >=3D 0; zone_idx--) {

[Severity: High]
During zone-constrained reclaim in mm/vmscan.c (where sc->reclaim_idx is be=
low
MAX_NR_ZONES - 1 and zones above sc->reclaim_idx are populated, such as
GFP_DMA32 reclaim with a populated ZONE_NORMAL or GFP_KERNEL reclaim with a
populated ZONE_MOVABLE), can keeping MAX_NR_ZONES in try_to_inc_min_seq()
while removing the ineligible-zone rotation from sort_folio() stall aging a=
nd
memcg rotation?

Previously, scan_folios() visited all zones and sort_folio() rotated folios=
 in
zones above sc->reclaim_idx from min_gen to min_gen + 1. Once the oldest
generation was emptied across all zones, try_to_inc_min_seq() incremented
lrugen->min_seq[type] from max_seq - 3 (when MAX_NR_GENS generations exist)=
 to
max_seq - 2, allowing should_run_aging() to trigger try_to_inc_max_seq().

With scan_folios() restricted to zones 0..sc->reclaim_idx, folios in zones
above sc->reclaim_idx remain in min_seq[type]. Because try_to_inc_min_seq()
still passes MAX_NR_ZONES to lruvec_populated_min_seq(), lrugen->min_seq[ty=
pe]
stays pinned at max_seq - 3 even after min_seq[type] is completely drained =
in
eligible zones 0..sc->reclaim_idx.

In this commit, at sc->priority =3D=3D DEF_PRIORITY, scan_folios() caps the
lruvec_populated_min_seq() search bound at seq =3D lrugen->min_seq[type]. O=
nce
min_seq[type] is empty in zones 0..sc->reclaim_idx, lruvec_populated_min_se=
q()
still returns the pinned min_seq[type], so scan_folios() scans empty lists =
and
returns 0 at DEF_PRIORITY.

A later commit in this series ("mm/mglru: lift youngest gen protection for
higher priority") changes the DEF_PRIORITY search bound in scan_folios() to
lrugen->max_seq - 1, and another commit ("mm/mglru: Run aging when pages are
rare outside the youngest gen") adds lru_gen_imbalanced() to
should_run_aging(). However, both should_run_aging() and shrink_one() still
rely on state across all zones:

mm/vmscan.c:should_run_aging() {
	DEFINE_MIN_SEQ(lruvec);

	/* have to run aging, since eviction is not possible anymore */
	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
		return true;

	/* try to avoid aging, do gentle reclaim at the default priority */
	if (sc->priority =3D=3D DEF_PRIORITY)
		return false;

	/* better to run aging even though eviction is still possible */
	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max_seq;
}

mm/vmscan.c:shrink_one() {
	...
	need_rotate =3D try_to_shrink_lruvec(lruvec, sc);
	...
	if (need_rotate && mem_cgroup_online(memcg))
		return MEMCG_LRU_YOUNG;

	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
		return 0;
}

When lrugen->min_seq[type] remains pinned at max_seq - 3 by folios in zones
above sc->reclaim_idx (and lru_gen_imbalanced() / lruvec_is_sizable() sum
nr_pages across all MAX_NR_ZONES):

1. should_run_aging() sees min_seq + MIN_NR_GENS < max_seq and does not run
   try_to_inc_max_seq() (or inc_min_seq() inside inc_max_seq()), stalling
   page-table aging.

2. Once eligible zones 0..sc->reclaim_idx drain their older generations and
   lruvec_populated_min_seq() advances seq to max_seq in scan_folios(),
   sort_folio() hits min_gen =3D=3D max_gen and isolates folios from the yo=
ungest
   generation without tier or reference protection.

3. If a memcg has no folios in eligible zones 0..sc->reclaim_idx but has
   folios in zones above sc->reclaim_idx, try_to_shrink_lruvec() returns
   need_rotate =3D false while lruvec_is_sizable() returns true, so shrink_=
one()
   returns 0 instead of rotating the memcg.

Should should_run_aging() and the size checks also account for sc->reclaim_=
idx,
or how should min_seq and max_seq advance when older generations are only
populated in zones above sc->reclaim_idx?

[ ... ]

([PVF1])

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022220203.9191=
1-1-baohua@kernel.org?part=3D5

