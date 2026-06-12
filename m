Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB73CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312B36B0093; Fri, 12 Jun 2026 06:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA086B0095; Fri, 12 Jun 2026 06:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228326B0096; Fri, 12 Jun 2026 06:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10DF46B0093
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:10:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFFEB1C3925
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:10:26 +0000 (UTC)
X-FDA: 84870840852.27.086F90F
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id F399A40009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:10:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GSk4CN21;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781259025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q519vfwp1vW5ZXI0F5glbgBRXP0Kz0Zm9ehHeL4ROgQ=;
	b=YN8xayrs8HMirNzekxxe8ex8RbTuWrMvbefHXhNWnIqJI5a083nmtasHtCVEdDTMRo66uc
	9uT8rmMuxJUTHaOyAEUfkIrY+zCY41Wnm+uF1uTHXsmHVG0E4ngQomOraZw+FxJ9q1zjO3
	aHJJcA//GTvaU4z+XYdk6fzrGHep8nk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GSk4CN21;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781259025;
	b=f4R+EUiqtv10sumAA3xKiDwWJAW4PaA4OjDM1/byOUrhba5CIbrmek0iFrt0HIzoZZBSKo
	UzUag32qi3XUzi5xu2F1tsxDfC/q3fb38+cC/MsuLXvXfwWGTaDdWD4JADr82HlzK1prcL
	0RbCFbRY1pR+8zS7LWhaedtxx9W5iDM=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781259022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q519vfwp1vW5ZXI0F5glbgBRXP0Kz0Zm9ehHeL4ROgQ=;
	b=GSk4CN21/+x0DhgwLZXMmbEYTgJEStM0ZtUCWysnAXXh7WS0fw03tsYDUqz1WdvihuhrGb
	nBxH+iYYEaEFvpOuz5cE5kS4ZxIqyjkn2j/GS9s7p6kc/+x5U8V4MdpA3iuEBf4aVqJc5G
	+e/gd1FIzbAGElC99XoNaCVgOnfVkzk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 10:10:20 +0000
Message-Id: <DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Petr Tesarik" <ptesarik@suse.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>
References: <20260612085052.59291-1-ptesarik@suse.com>
In-Reply-To: <20260612085052.59291-1-ptesarik@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F399A40009
X-Rspam-User: 
X-Stat-Signature: 75ksrxagunydhsga5j1pwbuigg68dgi6
X-Rspamd-Server: rspam09
X-HE-Tag: 1781259024-321984
X-HE-Meta: U2FsdGVkX19E/hygK/1dRYqLM+LPqO0KC16xbx2OSUuEdSqh2+c9WP4/obxxC6Gf1sKgYoabXouCpEBD2t4N4Z13U1LfM/IMRJ2+6Nddy/CvVO3NwMJGwwtdvg4Lbo/kkRFybtUAP5VPJp0fxtlY4BlQMGKuPK6x2nZ2nVZ4IUFziMYWG0xgEnyJrlWVmKDta6Ocuuma1dtIXewsm1XjJrfSVnqt8sWea8IIuE1QrfH6JxJrUXaa0xyU/B9nHICGvAN9PBJdkqopBjIPMGHI2YflNHyjqq5llgFcfueveg/+oKOFBM7FGGJRLYgDaLPXi/ubqUnclKRhKR5uWkGMX5FUq2Pq8IlGiZMO86tpGgbV6m2Yp1e1sxDTWqXo0D8RPNsQR6MmrIR/fm0crlpSUfdMeaGj/pmQ13WTM/aJ2GJN7+M9TCB+wwkGNPBpinQKl3x9rOkFqs1SpMZj8o//k4A+y118pYQLoeE6fyLu8iazq8CaI80M1DQQbJ6Hpjc7eqAdoEApv/HF1tep90rWnt/jgxwLmGcYKyxGXx983S+AUm6FrG3YjMRtNfRUfR4Ynl39f0ohY6/25w53NhOQ3SmIbzlpspQWa0p/OtFjF1O+7xmG1QEPT/J3mVJzJCIIOrVzmKmSvVpOpjRZOSjLOkGBndl/pgNqGew59ytaq9LENTVQBQjMgxHQXQ7qCfWQUaUnmfK7pPGA5nctWJnSIG+j9CLASCvKCPBIJB1UYKbzUjZ+sObVe6G9hCAut74z0MTIVE4SJ+FtBhM4c6LQfreFJV4MUOtVMoVjSBVMUyv7A90y+HNh6hm1TKofNpLvn/yS1UPk2i6ig5JudrFEZov0A01MLkfJd/SVzlp56/EIbmB0nNyxOLitRkHGwOAMn9WiT+h73ssN9Q4T2V57Mo8CAc3JpeIFs6AL/Ba0MlgoYJsTFqCbl/02g7HswJWKulSefADgSOeNrrkFZkG
 ju4FYDRV
 yooWsPuF8EVJYGpoXjkz+mdjP84EEALeCHWNVQu+NGIolIfYsM9UoryGNqffWUlI4ZzOnoHqfoXns+FZTWOyasLUZ/GPkw4ed9UQjpNfzagtZQdBrfysaNGJsMrZdh8sFaHJp3u/eQkIQWMcD6PGlOrs9A7aBiRn04lS5w72DG9j73ld2KChT7ZRMJDYiD0YlWhk6NeSVyScMAsGkekHNnFbS6rVQpp8ykvbcliFeuQvdqeNwvAGC4TDfR9M0Ws07KjenJA/QQF3WkA4w9fNCcShpUHKHkWYs2ZJk6tkr2LaMeuFPSmBGWReoN0lfIL8GBF4oomELU9ex+PnVrtYYaILm/hWnC4xvxMxr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 12, 2026 at 8:50 AM UTC, Petr Tesarik wrote:
> Change node_reclaim() to return an enum indicating whether any
> pages have been reclaimed, because that's all the information
> needed by the only caller, get_page_from_freelist().
>
> This leads to the following translation of the old macro
> identifiers to the new enum values:
>
> - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
> - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
> - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
> - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS
>
> Originally, I was looking for occurences of NODE_RECLAIM_SOME
> and NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because
> they are typecast from the result of a relational operator. This
> seemed a bit fragile, so I dug a bit deeper and came up with this
> proposed cleanup.
>
> Signed-off-by: Petr Tesarik <ptesarik@suse.com>
>
> --
>
> Changes from v1:
> - use an enum instead of a bool
> ---
>  mm/internal.h   | 17 +++++++++--------
>  mm/page_alloc.c | 19 ++++---------------
>  mm/vmscan.c     | 18 +++++++++---------
>  3 files changed, 22 insertions(+), 32 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a20..89b0ea28051c1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void)
>  }
>  #endif /* CONFIG_DEBUG_MEMORY_INIT */
> =20
> -#define NODE_RECLAIM_NOSCAN	-2
> -#define NODE_RECLAIM_FULL	-1
> -#define NODE_RECLAIM_SOME	0
> -#define NODE_RECLAIM_SUCCESS	1
> +enum node_reclaim {
> +	NODE_RECLAIM_NONE,
> +	NODE_RECLAIM_SUCCESS,
> +};
> =20
>  #ifdef CONFIG_NUMA
>  extern int node_reclaim_mode;
> =20
> -extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
> +extern enum node_reclaim node_reclaim(struct pglist_data *pgdat,
> +				      gfp_t gfp_mask, unsigned int order);
>  extern int find_next_best_node(int node, nodemask_t *used_node_mask);
>  #else
>  #define node_reclaim_mode 0
> =20
> -static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
> -				unsigned int order)
> +static inline enum node_reclaim node_reclaim(struct pglist_data *pgdat,
> +					     gfp_t mask, unsigned int order)
>  {
> -	return NODE_RECLAIM_NOSCAN;
> +	return NODE_RECLAIM_NONE;
>  }
>  static inline int find_next_best_node(int node, nodemask_t *used_node_ma=
sk)
>  {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f7db8f049bd23..83a1caac5ac9c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3899,8 +3899,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  		if (!zone_watermark_fast(zone, order, mark,
>  				       ac->highest_zoneidx, alloc_flags,
>  				       gfp_mask)) {
> -			int ret;
> -
>  			if (cond_accept_memory(zone, order, alloc_flags))
>  				goto try_this_zone;
> =20
> @@ -3921,22 +3919,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned i=
nt order, int alloc_flags,
>  			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
>  				continue;
> =20
> -			ret =3D node_reclaim(zone->zone_pgdat, gfp_mask, order);
> -			switch (ret) {
> -			case NODE_RECLAIM_NOSCAN:
> -				/* did not scan */
> -				continue;
> -			case NODE_RECLAIM_FULL:
> -				/* scanned but unreclaimable */
> +			if (node_reclaim(zone->zone_pgdat, gfp_mask, order) =3D=3D NODE_RECLA=
IM_NONE)
>  				continue;
> -			default:
> -				/* did we reclaim enough */
> -				if (zone_watermark_ok(zone, order, mark,
> -					ac->highest_zoneidx, alloc_flags))
> -					goto try_this_zone;
> =20
> +			/* did we reclaim enough */
> +			if (!zone_watermark_ok(zone, order, mark,
> +					       ac->highest_zoneidx, alloc_flags))
>  				continue;
> -			}
>  		}
> =20
>  try_this_zone:
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3f3ff25e561ac..d5bd55620ee9a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7786,9 +7786,9 @@ static unsigned long __node_reclaim(struct pglist_d=
ata *pgdat, gfp_t gfp_mask,
>  	return sc->nr_reclaimed;
>  }
> =20
> -int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int=
 order)
> +enum node_reclaim node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask=
, unsigned int order)
>  {
> -	int ret;
> +	unsigned long nr_reclaimed;
>  	/* Minimum pages needed in order to stay on node */
>  	const unsigned long nr_pages =3D 1 << order;
>  	struct scan_control sc =3D {
> @@ -7815,13 +7815,13 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t=
 gfp_mask, unsigned int order)
>  	if (node_pagecache_reclaimable(pgdat) <=3D pgdat->min_unmapped_pages &&
>  	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=3D
>  	    pgdat->min_slab_pages)
> -		return NODE_RECLAIM_FULL;
> +		return NODE_RECLAIM_NONE;
> =20
>  	/*
>  	 * Do not scan if the allocation should not be delayed.
>  	 */
>  	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC=
))
> -		return NODE_RECLAIM_NOSCAN;
> +		return NODE_RECLAIM_NONE;
> =20
>  	/*
>  	 * Only run node reclaim on the local node or on nodes that do not
> @@ -7830,20 +7830,20 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t=
 gfp_mask, unsigned int order)
>  	 * as wide as possible.
>  	 */
>  	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id !=3D numa_node_=
id())
> -		return NODE_RECLAIM_NOSCAN;
> +		return NODE_RECLAIM_NONE;
> =20
>  	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
> -		return NODE_RECLAIM_NOSCAN;
> +		return NODE_RECLAIM_NONE;
> =20
> -	ret =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >=3D nr_pages;
> +	nr_reclaimed =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
>  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
> =20
> -	if (ret)
> +	if (nr_reclaimed >=3D nr_pages)
>  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
>  	else
>  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
> =20
> -	return ret;
> +	return NODE_RECLAIM_SUCCESS;

Should that be returning NODE_RECLAIM_NONE when !ret?

