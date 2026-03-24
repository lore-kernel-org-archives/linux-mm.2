Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E0DBE9A777
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B91C6B0005; Tue, 24 Mar 2026 08:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969C76B0092; Tue, 24 Mar 2026 08:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A71F6B0095; Tue, 24 Mar 2026 08:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE8A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:02:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F09D91A1ADF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:02:08 +0000 (UTC)
X-FDA: 84580818336.02.F29B064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2559E4001C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:01:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPYBjgOm;
	spf=temperror (imf27.hostedemail.com: error in processing during lookup of ljs@kernel.org: DNS error) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F2A1408E6;
	Tue, 24 Mar 2026 12:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD42C19424;
	Tue, 24 Mar 2026 12:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774353718;
	bh=cI3LTNSwlHdB+Tez7H66TSvkT89A3gqoLgFKYhi3sog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DPYBjgOmiwqojj0OOlQmeiFoeAjOhy5a4hPL7cvL7nLD5C4+QWaD7EhuT4cDnTTFL
	 KDhbDHAE8OjuBoTqhO7Q5dGuekcm4zCU74y8HfxKqB19LBvGyI42HKwF30BYLnOYV+
	 0eobGLo0qjWukpZ47RfZiP9BW95zAHZsW8aTDDZ9iQUJ1d+S0RJLwZb1UdDF87iIaC
	 /VS9PsjquDrz+05boyy9JCTrxljSnLN+IipYHji7SdkDkch29lFrl5IgmnzJUMSZHc
	 wFiWlSqEOys52SAB+2jQtG1HsHkF+6vrsOWuszBbRH+g8EFp9cRurteq1YWmbxXFhm
	 /8ZC1l1baIedQ==
Date: Tue, 24 Mar 2026 12:01:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] mm: list_lru: introduce
 folio_memcg_list_lru_alloc()
Message-ID: <58ea360a-54e1-468e-99b5-57b716026088@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-7-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-7-hannes@cmpxchg.org>
X-Stat-Signature: eyxs3s1aqs51n93rojuddb5z8ck58h1y
X-Rspamd-Queue-Id: 2559E4001C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774353718-671744
X-HE-Meta: U2FsdGVkX19yy71UjRNnTuUEQFvq5FvXOzgDD/Ou2AM/C05tynS/O3Lf87PS7KF6BkR+rBMuX5zCjzwdCERErbwXAf/wFR4RmpSguzi5WzSqSFkzhq4fkJ5bJ6DzYjn3yI44D90Ipfsal5VOXjNYXgYsWrcAprxJqVpNw7fGeMBhPEXBJoeCBi4Y9tDZm0DUd6ARGF1jSzqfXkxwdYcV73nil3m7R4m12j52pYL2N/QFaptJF/qpFUtaHPalBgHzH3PYwoCN9u7VFnKXVxeDFuioLOvnM1Qc33AjL93USF3Kx6HWY59aaMT5PP88Py8VHTQeb/Izee7XXqJYE25RoWfLEXGognGzD1AfdxvLUj+bHntsnYjCyB9sEZcW4mQidooqx1Ln0z6+JRHOmge4tqJmRpuLZCKGonmrK90h2EDQxGla+jCXM1rP4ZAFW8V0gxcx8WyauSBAOBP5Mg045f6g4a0Z9RJqL7HwxRsC5Nq3T4/vWghtSBHbcyDUFRT628FVjo2fqb8EMgqaYvFC9+EizJfJZnE1n5qU59D7MOhr9yuwnhZdRwWeTXXOcO8GhO80IENXlDZHOrOfOf/dwwnWky5HxkHu6tEsxYdNS7wGA9G44p5EcFSL6qV18iYnDSYWyEkvtiWUgzmG2h6FIHUbd+f1O18JYshIJqX/sd178G7eULcCrw9nGSbiGSE+MA6HlnejBl7xoOQnJM6nuUdOHdzmMb6v82SOyqZDbEarsj0Sipp2gYrVrtmuD0A0qsOT70MAl0jUrwt8YoISL2nSVvrFERob581TUfeJ7GrJhgvntTbkZmlfIZnG7B4cFaCV4BS0fa8L/fVAt8v/TXMOcaXjtkDsfsv4iTS/gkA3B3c9wGBMmeomu5D/NROey7/XwVK9jtnz7UWc3Aq2nkX+JeDVWaDIIFBWHs6ylHuZnxbp4YBDjwz6w5JWEscBL+eVS+uuPys6ZL20z83
 8T6hohA5
 iXdybFlubFxWHl9mpXLm2buOpUsVDwpkmcGzu7Kqs97s4OuBkjOPKGzqZobp72j9nKUnhFRkjUc/seRmLtpdydFL6G+onWhOT/hKIWoYPeOczbRNFsJNA+ygcwI6UQOo+FX9NyXbUTB4xhjI5QhqdHmHfsAOvxCP8L920J0ne7iZbn52o52y01f+2kVAs30deJAVfyaZwEuh4n6B1M+pnFzlqvI0NDO+KJAjax9rdbtihK5FE3us/gj8jX4RuYsI4TZdJbx3LCryNSlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:24PM -0400, Johannes Weiner wrote:
> memcg_list_lru_alloc() is called every time an object that may end up
> on the list_lru is created. It needs to quickly check if the list_lru
> heads for the memcg already exist, and allocate them when they don't.
>
> Doing this with folio objects is tricky: folio_memcg() is not stable
> and requires either RCU protection or pinning the cgroup. But it's
> desirable to make the existence check lightweight under RCU, and only
> pin the memcg when we need to allocate list_lru heads and may block.
>
> In preparation for switching the THP shrinker to list_lru, add a
> helper function for allocating list_lru heads coming from a folio.
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Logic LGTM, but would be nice to have some kdoc. With that addressed, feel free
to add:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/list_lru.h | 12 ++++++++++++
>  mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 46 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index 4afc02deb44d..4bd29b61c59a 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
>
>  int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  			 gfp_t gfp);
> +
> +#ifdef CONFIG_MEMCG
> +int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
> +			       gfp_t gfp);

Could we have a kdoc comment for this? Thanks!

> +#else
> +static inline int folio_memcg_list_lru_alloc(struct folio *folio,
> +					     struct list_lru *lru, gfp_t gfp)
> +{
> +	return 0;
> +}
> +#endif
> +
>  void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>
>  /**
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index b817c0f48f73..1ccdd45b1d14 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -537,17 +537,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
>  	return idx < 0 || xa_load(&lru->xa, idx);
>  }
>
> -int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
> -			 gfp_t gfp)
> +static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
> +				  struct list_lru *lru, gfp_t gfp)
>  {
>  	unsigned long flags;
>  	struct list_lru_memcg *mlru = NULL;
>  	struct mem_cgroup *pos, *parent;
>  	XA_STATE(xas, &lru->xa, 0);
>
> -	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
> -		return 0;
> -
>  	gfp &= GFP_RECLAIM_MASK;
>  	/*
>  	 * Because the list_lru can be reparented to the parent cgroup's
> @@ -588,6 +585,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>
>  	return xas_error(&xas);
>  }
> +
> +int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
> +			 gfp_t gfp)
> +{
> +	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
> +		return 0;
> +	return __memcg_list_lru_alloc(memcg, lru, gfp);
> +}
> +
> +int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
> +			       gfp_t gfp)
> +{
> +	struct mem_cgroup *memcg;
> +	int res;
> +
> +	if (!list_lru_memcg_aware(lru))
> +		return 0;
> +
> +	/* Fast path when list_lru heads already exist */
> +	rcu_read_lock();

OK nice I see folio_memcg() explicitly states an RCU lock suffices....

> +	memcg = folio_memcg(folio);
> +	res = memcg_list_lru_allocated(memcg, lru);

...And an xa_load() should also be RCU safe :)

> +	rcu_read_unlock();
> +	if (likely(res))
> +		return 0;

So that's nice!

> +
> +	/* Allocation may block, pin the memcg */
> +	memcg = get_mem_cgroup_from_folio(folio);
> +	res = __memcg_list_lru_alloc(memcg, lru, gfp);
> +	mem_cgroup_put(memcg);
> +	return res;
> +}
>  #else
>  static inline void memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
>  {
> --
> 2.53.0
>

Cheers, Lorenzo

