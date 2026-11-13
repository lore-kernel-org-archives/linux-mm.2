Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF82606EDB2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbSejmPJ
Received: by kanga.kvack.org (Postfix)
	id E67736B05B5; Fri, 13 Nov 2026 12:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E387C6B05B6; Fri, 13 Nov 2026 12:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28076B05B7; Fri, 13 Nov 2026 12:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80706B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:58:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2034FA7AED
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:58:14 +0000 (UTC)
X-FDA: 85430854908.13.38FDAF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63CAF100003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:58:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbSejmPJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794592692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00jMmBFJCXdtkRn+8A2ST7tyVGGZ50JpVGLPQ7zHCRs=;
	b=1f8L1++vIRDqQSuU4Zc7RVdwr0IHbhp3vMzalkupjsZv5iyjgiZbldyfImmeQcCOE7xhka
	7XNW+IN5L2VN1XuOcZos/IdtJLe4Xi8CTjayGOZfLDSdtkJizTMXHOYZ1lbGDVz82ovy07
	e1knzUloYCU2FCxL2vvLYp1DREYpnjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794592692;
	b=W5rnEaHOt6smTAK1hJeagq7x1Z/3lk44HTnABELUjd5L7y1PimACZ2gTTGvuf5ciaLGvY1
	aj+BUaYbeiydjklIDne2JYAGwBlTWAP07TMqB+yAXIv0rUFaLg1oS4yl0IqrxAn0p6GKhq
	/SqQ94zjdF5qlXzXhx2bBBPzOmIfyvY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbSejmPJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D59206281B;
	Fri, 13 Nov 2026 17:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7151F000C4;
	Fri, 13 Nov 2026 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794592691;
	bh=00jMmBFJCXdtkRn+8A2ST7tyVGGZ50JpVGLPQ7zHCRs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lbSejmPJ/zaWI5Zth/4n5ZvyYic5tt7j5BDgRlGEBbus+t0DjlvKiuuU2kPvXp1lX
	 1Gq95ECy89RBBAfgAPI6nHItRhTRDHZQWwnICzxN7i0xtP4QEiDhIMue5Xs7xyab25
	 AhAzcftaN8bSlBBj2uC0vuM9a5cvB2mdVB8uZshK8JkRpZTy/5WbzzQ2HCb3KkmTln
	 9Rx9dJCu+rk3y0aJtNX2cTlcfVuBEiF5FU5DQYsllO/6ihdb+yiEN5wohu+KZ6SoMs
	 oXQulNNq/MgEz0JvVuLs7FYryMC5JxlAep5Y2ZcoPzIZatGTMmBfrD5IHzzV21vt7M
	 d+b9w34naq6KA==
Message-ID: <e16c46e8-d69d-450f-bf98-6f14755cdae5@kernel.org>
Date: Fri, 13 Nov 2026 18:58:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: vmscan: tell direct reclaim the allocation is
 ALLOC_NOFRAGMENT
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-4-kas@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261102093939.3340540-4-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qo5qdbsp43zu6kroj4ccb88n1wk7p4on
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63CAF100003
X-HE-Tag: 1794592692-718961
X-HE-Meta: U2FsdGVkX1/sXYT3jAA3pBb1fSxg4lmiS8dwGwtdf88ly40aOEGg8BKnVDs05NVgLMbavUbjFZhR0uPLwYI0oKg7+3jnfMsxB+v/lji8b10fFaWIgSn8PG2XSh0jYEP9t44w4wHHMs2yYbhpDR6VB4zig2V5Xv4FbqsdXXL2jLXwiuMQ9jtqtc6xeWXr5nbA5uvlhbQXSDmnIK5peka9kJFdO4jD7M2ebpX4qrd1of/dLS/O24WJksO8nXLrlqraMJQ2/ILTxe+aWH7CNq3L45hnisui2Jy8GjkqbT9KA31mqsxCeNFjOCtssASmwYfTIWSvO4WyZLpXuYOr9OfNoB2Z6hZU0FJSHmZz3QlEURoGzYueg+jzCnbVrCBmHyUXL8eN7AyrrATj9nMHdIRvIZRil+h1pdSaysAk5O0u/eGYlji76wKVUVNN4u+t78uuTRyAEJfucd/jsB8WIyae4tFihx9CfP/eaH2iNBE9hq3Z4MKTvLHdy+cKhyWqe+PecxwzBEJYt8GXOVO+0dLtzin5nVhf9luV/f1s55Ej9QHZ1IMb/IRxilLVLInjfWYjW0oYsQrLIB2o4IscW6ATRQH8640kWgYcOWIXV86lOFj9fKT+6bwXbvSNYGMywWRqDwDN+70qCKDQRF3DEtA2Jym7mrk9kksGHSKW3sNVoeSJkxuPFrzPtsVrBh9+cXXBtL93k5ibCTzmhnqZXVHRaRlUs9fLK0FLV4u3ffvTe41ELYrV44rjsFOqc9LbqQMHZ3Mgm1+qu3M1B15HPqdt/E/UuHfdAL77sNxJ3Swfnbjkc++3ZnmqXvvPYWaWmM17Z5iK0yXHWZ6pvL/eQzq8AbASsQphktCEWDcrMdrAdm9+bJcgZ/WqLFK1a/j3iWRl9iXPJrERMw0/6ROgiQBmahGECoYQIv/r5Q90d8jLI5WYEoxmCMgpP96hIbFKALF44MvUbMUq5JU9TbPHDqU
 PfUCiJ4a
 Z7iTaTb8vkWxNHTyb8H+fCFtsLeW3Kh0aennoSSs945mswLmvhj8L/YFhRvSV//tEhkUbBkMy8cCipt2Y6rPOfRqmwDfdmhjcyqQbgy8sYYxpFVKGtfBUaIcyxr0c6jkLZNsmS+td8/w6Yem+rf5q+8AolJAT0bXjk0Ag+cSM5FfU2lME/kRWSQU6xaWaXuzi3JeM3V/5TFrgN04vzMhmNUCjVk6qlcHc6mJLj6g7J4PZYHNBujT4X49e48wumpBukl8ecJM1AM8Ot/TpnBRU0ASwgJE2cP+AvX4z+sdSkRTQWpK4Mf6EXHxYHyEYtycgh7Al1t0KdGPEN6kQwbt0fjv3+rb4Pxz5W+F6X3xfpY7ZWWD+EbOBl/WCIPbojzqwO2+qOuYMPx18PdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 10:39, Kiryl Shutsemau (Meta) wrote:
> Direct reclaim for a costly order stops as soon as the allocation could
> succeed.  compaction_ready() skips a zone and should_continue_reclaim()
> stops reclaiming when zone_watermark_ok() passes, and zone_watermark_ok()
> accepts a free page of any migratetype.
> 
> With defrag_mode, the allocation behind the reclaim is ALLOC_NOFRAGMENT
> and cannot take the free pages left in unmovable and reclaimable
> pageblocks.  Reclaim stops on them anyway, having freed little.
> 
> In Dev Jain's 64K mTHP benchmark, with the high-order watermark check
> already honouring ALLOC_NOFRAGMENT, an order-4 direct reclaim frees 16
> pages on average with defrag_mode and 45 without.  64K faults get a bit
> over half as many folios as without defrag_mode (medians of 15 runs):
> 
>                               defrag_mode=0  defrag_mode=1  defrag_mode=1
>                                                             + this patch
>     64K faults allocated              20750          11538         19759
>     64K faults falling back to 4K       725           9945          1664
> 
> Pass ALLOC_NOFRAGMENT from the allocation down to try_to_free_pages().
> Both checks then ask __zone_watermark_ok_mt() for a free page the
> allocation can take, and an order-4 direct reclaim frees 40 pages on
> average.
> 
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> Reported-by: Dev Jain <dev.jain@arm.com>
> Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
> Tested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

I'd perhaps pass whole alloc_flags to try_to_free_pages(), but other than
that LGTM.

> ---
>  mm/internal.h   |  3 ++-
>  mm/page_alloc.c |  8 +++++---
>  mm/vmscan.c     | 24 +++++++++++++++++++-----
>  3 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 8e58e2db5e09..b43947818f9a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -65,7 +65,8 @@ void folio_mark_lazyfree(struct folio *folio);
>  /* mm/vmscan.c */
>  unsigned long zone_reclaimable_pages(struct zone *zone);
>  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -				gfp_t gfp_mask, const nodemask_t *mask);
> +				gfp_t gfp_mask, const nodemask_t *mask,
> +				bool nofragment);
>  unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  			      int zone_idx);
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d53fb2c67ae1..08f9bdcd3b9f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4451,7 +4451,7 @@ static unsigned int check_retry_zonelist(unsigned int seq)
>  
>  /* Perform direct synchronous page reclaim */
>  static unsigned long
> -__perform_reclaim(gfp_t gfp_mask, unsigned int order,
> +__perform_reclaim(gfp_t gfp_mask, unsigned int order, unsigned int alloc_flags,
>  					const struct alloc_context *ac)
>  {
>  	unsigned int noreclaim_flag;
> @@ -4465,7 +4465,8 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order,
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
>  	progress = try_to_free_pages(ac->zonelist, order, gfp_mask,
> -								ac->nodemask);
> +				     ac->nodemask,
> +				     alloc_flags & ALLOC_NOFRAGMENT);
>  
>  	memalloc_noreclaim_restore(noreclaim_flag);
>  	fs_reclaim_release(gfp_mask);
> @@ -4487,7 +4488,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	int reclaim_order = ac->reclaim_compact_order;
>  
>  	psi_memstall_enter(&pflags);
> -	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
> +	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order,
> +					       alloc_flags, ac);
>  	if (unlikely(!(*did_some_progress)))
>  		goto out;
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..54a16dbb84dd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -142,6 +142,9 @@ struct scan_control {
>  	/* One of the zones is ready for compaction */
>  	unsigned int compaction_ready:1;
>  
> +	/* The allocation cannot fall back to other migratetypes' blocks */
> +	unsigned int nofragment:1;
> +
>  	/* There is easily reclaimable cold cache in the current node */
>  	unsigned int cache_trim_mode:1;
>  
> @@ -6316,6 +6319,17 @@ static bool in_reclaim_compaction(struct scan_control *sc)
>  	return false;
>  }
>  
> +static bool allocation_can_succeed(struct zone *zone, struct scan_control *sc,
> +				   unsigned long mark)
> +{
> +	unsigned int alloc_flags = sc->nofragment ? ALLOC_NOFRAGMENT : 0;
> +	long free_pages = zone_page_state(zone, NR_FREE_PAGES);
> +	int migratetype = gfp_migratetype(sc->gfp_mask);
> +
> +	return __zone_watermark_ok_mt(zone, sc->order, mark, sc->reclaim_idx,
> +				      alloc_flags, free_pages, migratetype);
> +}
> +
>  /*
>   * Reclaim/compaction is used for high-order allocation requests. It reclaims
>   * order-0 pages before compacting the zone. should_continue_reclaim() returns
> @@ -6354,8 +6368,7 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>  		unsigned long watermark = min_wmark_pages(zone);
>  
>  		/* Allocation can already succeed, nothing to do */
> -		if (zone_watermark_ok(zone, sc->order, watermark,
> -				      sc->reclaim_idx, 0))
> +		if (allocation_can_succeed(zone, sc, watermark))
>  			return false;
>  
>  		if (compaction_suitable(zone, sc->order, watermark,
> @@ -6580,8 +6593,7 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
>  		return false;
>  
>  	/* Allocation can already succeed, nothing to do */
> -	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
> -			      sc->reclaim_idx, 0))
> +	if (allocation_can_succeed(zone, sc, min_wmark_pages(zone)))
>  		return true;
>  
>  	/*
> @@ -6965,7 +6977,8 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  }
>  
>  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -				gfp_t gfp_mask, const nodemask_t *nodemask)
> +				gfp_t gfp_mask, const nodemask_t *nodemask,
> +				bool nofragment)
>  {
>  	unsigned long nr_reclaimed;
>  	struct scan_control sc = {
> @@ -6978,6 +6991,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  		.may_writepage = 1,
>  		.may_unmap = 1,
>  		.may_swap = 1,
> +		.nofragment = nofragment,
>  	};
>  
>  	/*


