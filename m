Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0F5CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 00:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7B26B0088; Tue, 13 Oct 2026 20:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81CC6B0092; Tue, 13 Oct 2026 20:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970A56B0095; Tue, 13 Oct 2026 20:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 618746B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:18:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA1A6140391
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:18:17 +0000 (UTC)
X-FDA: 85319319834.17.6FE79E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AAB7140006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:18:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzn17pG9;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791937096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ojGJwDPTVvH1mNyQFRD6ZgJPJ+C3Xv6E6vMi/T8h+E=;
	b=qBjohNeNbAO3nwY8vykblo8Xejio2fd07Yg4V/0x/n3O8sD4NDKhkehs4CZndsyW3Z1XGV
	aXojYgnM8Iu9ID2TLyt+/U5FgiRKQWVwB+mbbsS8sqMq/zswhLwxqAySdy+b6k8efvsuLq
	J4eU4M21MrFq2qEv85wBZl65A9VRKOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791937096;
	b=y9mmFeQm9JsOu2Gb9ULdzEuQdQhvPUa0xPUw9bKLdMc7rC+VBuV9MGufqA0oRqLlOMSxTP
	886OxKmGBOKJ3IZOPIPUM57ajwlyRxEPaO7TheoOjuQcoatwSejyOOdfm91V+EblYcPa5c
	WZd+qdTLFXaWq37y5jDwvBVT9vlGvXQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzn17pG9;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9669B601DB;
	Wed, 14 Oct 2026 00:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C578F1F000FF;
	Wed, 14 Oct 2026 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791937095;
	bh=6ojGJwDPTVvH1mNyQFRD6ZgJPJ+C3Xv6E6vMi/T8h+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hzn17pG99bpu4AnLp0GZuqYv84aeXmdu4EX/E6PlW4tSL5nn0xPhvQDvylCA8J4uJ
	 HbbsWrjqdsqr+5dUmhTwGFQS3JYlfN73D/LFNtot6qcrLEm6LPWCW10jnGuow8zifc
	 9RyfYHDVGFy+nXcM/0BGc+00HvdJnXD85ukvRN9qe5PCHldwZ/SwfZgQsVrDYuRLw4
	 XI91kO7ay9LNFSMbz2EBR+tGXBLbTyQS7QJtF3/E0EiEg1gYfXe9Nij9xqHqlw8yXc
	 wTI1Rre0YJdOPZ1g0a8kjdVzSL6xkVCi5EVgekdy5FMoYjeb3OUTRwk/jmjGIBzG0i
	 J94sV8320RL7A==
Date: Wed, 14 Oct 2026 00:18:13 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Message-ID: <as7JC8o2kggiq_ss@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182814.27450-6-kanchanapsridhar2026@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1AAB7140006
X-Stat-Signature: oj16tuo6i4th4u5h4tp63igbx5o9k37b
X-HE-Tag: 1791937095-821690
X-HE-Meta: U2FsdGVkX18Ay/tMTax07t2QuV8IFACaK4qWOwAkW1KuD97XSgjXxPeQ/BVhua8lu3enip/FAP6Bdjp7ALLBhS6DCaLJPd+VgV1qj0a0En5Bm7kymqMf6SIVsqubzDEoVuYJhaNVNmRkfz1x1DKPOQQMgVdQyEuydMfewijsAGWA5wVuHHSPcMsCAoZ/XhBQHxmu/nn3WZVjEecPd6am65R0TLmHn/MgEXRxOKknZMkS/YlhMPqkjMeJyHyf394n5hWCIdsNu7suUjhokoXnwSnfcAPkL6uYdYNkpciRDPJVoc1A2lRGtDpc8Q6X2OAOpeZG19VJ5f9IpdUHV0rVT3P2vIhO6cLa8DFB6n8/27WviTTJz/EwmfHyXgjr5rjrHkoU83O4WWDQQjUukYY052ugYzUvsF6lx578WpBuBWrqTV7h9e4vw09/T7siIiUk0z55Ir1xX8PF5KTzOFC4RFsfiBOYOibuBLFNBXiJ9prI2iWTlEjpRCkL3bCJkFXfLConHJxuATLJ5y7mxPw46Zd6nsKObVIr33++6MU1NehX3YpPS1mRoNLPkSPY7mNWnQy6DhyuHPaM2H603dT8xO3dYLUolH0gYyp0mAjlCbbdje/pPa8+uNQKIsD79wY+p5mqKONweujd9aB9SI5xL5oVGrhtum4gKOhGZNMQun06XYUFvN1Hz59D2W0ClImKgcSfwa7+U0DBn9HDSpRGhw0TwqdBRLuTSe2sHaAKHMKHCIy4FyaoQcHQEquZOf+Urzil7AGfMInibewSQ2GPVQUYedPBNM5fQnERBIPVXYOLmz7DphRU0tbMtn65a8wzHkuVLOIhix05f0hHEON417brZ2ShWIbMe2PXJh2AQhsVzX7qhOJQkO5ejmy5+DG0a6OKU8YOvJCmtYPBUUytLqj9Au6Gq9g94Lt8GZIaRONxIBkDKsDgMTjOFX14J7ePe/hRht+/Uxpn/VJsFvG
 p48ojaDk
 XLnD8bCAosFMmNQOfmVlHBw/8Xi1lHCeDqRCUzDDPiWdEdIwE6fXVeZY59TOMwNfZeyuaC/vRNVNCZhq76si/47U9kCZrcdouhuEkxbd7yj9kFfddJQ1vtfN7EARX+s6AvUGXae9cam0zToTe5ZmWJ5cBq6WQWdi+XkzUmZmi5S3Lpx0w4ltiwR+LpdNleBqPy0ywVSc/a5tkAQZ3pejpAUwYXqDqO1KDVKJKn22i+u68i1AcIgWFEQAImf54BHfGVgArZiO/fWee98Y1sHCr+n7KLnc3jo9SFlaR4kUMhXMvJbQsgJLmpJI+HoRUcJEJFlRHVY3DJTiwkRPLamfwE50V1MGS6RBvTlgyuzun/5MAy4fBf+2aD0PuFWFq8J/rFHQm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> When storing a folio in zswap, save the folio's node id in the zswap
> entry instead of relying on the zswap_entry being allocated on the same
> node. This enables optimizations such as batch allocation of zswap
> entries for large folios using kmem_cache_alloc_bulk() that does not
> support specifying a node id.
> 
> The size of the zswap_entry remains unchanged as 'referenced' is lumped
> in with the 'length' (as it doesn't need a full unsigned int anyway).
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> ---
>  mm/zswap.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ca513a9f89e3..c2731d3acb2c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writeback
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * pool_idx - id of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
> @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> -	unsigned int length;
> -	bool referenced;
> +	struct {
> +		unsigned int length:31;
> +		bool referenced:1;
> +	};
> +	int nid;

This will increase the size of the struct now with pool_idx, right?

Before you patch on x86_64:

struct zswap_entry {
	swp_entry_t                swpentry;             /*     0     8 */
	unsigned int               length;               /*     8     4 */
	bool                       referenced;           /*    12     1 */
	u8                         pool_idx;             /*    13     1 */

	/* XXX 2 bytes hole, try to pack */

	unsigned long              handle;               /*    16     8 */
	struct obj_cgroup *        objcg;                /*    24     8 */
	struct list_head           lru;                  /*    32    16 */

	/* size: 48, cachelines: 1, members: 7 */
	/* sum members: 46, holes: 1, sum holes: 2 */
	/* last cacheline: 48 bytes */
};

After:

struct zswap_entry {
	swp_entry_t                swpentry;             /*     0     8 */
	struct {
		unsigned int       length:31;            /*     8: 0  4 */

		/* Bitfield combined with next fields */

		bool               referenced:1;         /*    11: 7  1 */
	};                                               /*     8     4 */
	struct {
		unsigned int               length:31;            /*     0: 0  4 */

		/* Bitfield combined with next fields */

		bool                       referenced:1;         /*     3: 7  1 */

		/* size: 4, cachelines: 1, members: 2 */
		/* last cacheline: 4 bytes */
	};

	int                        nid;                  /*    12     4 */
	u8                         pool_idx;             /*    16     1 */

	/* XXX 7 bytes hole, try to pack */

	unsigned long              handle;               /*    24     8 */
	struct obj_cgroup *        objcg;                /*    32     8 */
	struct list_head           lru;                  /*    40    16 */

	/* size: 56, cachelines: 1, members: 7 */
	/* sum members: 49, holes: 1, sum holes: 7 */
	/* last cacheline: 56 bytes */
};

I think we want to reorder the fields. We can probably also avoid the
bitfield if the maximum page size is 64K (is it?)

struct zswap_entry {
	swp_entry_t                swpentry;             /*     0     8 */
	u16                        length;               /*     8     2 */
	u8                         pool_idx;             /*    10     1 */
	bool                       referenced;           /*    11     1 */
	int                        nid;                  /*    12     4 */
	unsigned long              handle;               /*    16     8 */
	struct obj_cgroup *        objcg;                /*    24     8 */
	struct list_head           lru;                  /*    32    16 */

	/* size: 48, cachelines: 1, members: 8 */
	/* last cacheline: 48 bytes */
};


>  	u8 pool_idx;
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
> @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *val,
>  * lru functions
>  **********************************/
>  
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -	return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct zswap_entry *entry)
>  {
> -	int nid = entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
>  
>  	/*
> @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
>  
>  static void zswap_lru_del(struct zswap_entry *entry)
>  {
> -	int nid = entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
>  
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
>  
> @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio, long index,
>  {
>  	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
>  	struct zswap_entry *entry, *old;
> +	int nid = folio_nid(folio);
>  
>  	/* allocate entry */
> -	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> +	entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);

We don't need to allocate the entry on the same node anymore, should we
drop this and let the slab allocator handle it as it sees fit?

>  	if (!entry) {
>  		zswap_reject_kmemcache_fail++;
>  		return false;
> @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *folio, long index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx = pool->idx;
> +	entry->nid = nid;
>  
>  	old = xa_store(swap_zswap_tree(page_swpentry),
>  		       swp_offset(page_swpentry),
> -- 
> 2.39.5
> 

