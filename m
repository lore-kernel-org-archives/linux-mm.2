Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1114CC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2491E6B0092; Wed, 26 Aug 2026 09:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9DA6B0095; Wed, 26 Aug 2026 09:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138236B0096; Wed, 26 Aug 2026 09:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E28AB6B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:31:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F732C038E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:31:38 +0000 (UTC)
X-FDA: 85143507876.02.434773B
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D9931C000F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:31:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C7d7rAfs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787751096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7COlPnPt96sXgAr1UJEQMrW+e4A73s5JoHxHPizxms=;
	b=GV0ycf3KDyobPbfhfA3ZGUbXhHsxohxqi6luzp8JVeB1PLYgwxyU8ODmEobI/mdh5EvOAp
	xqgzoXGBaPD/8CPfBbwdb7xHMNok1+hdlQNCYUQm0f+Gs5uL8btbzZxqxZKX+USaxT9i+v
	11ISQFyc6/jHWx5TGUxePfp54k5IBh4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C7d7rAfs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787751096;
	b=3gWEv0+SULeVh3eZNAb0ZzcBZC+D8ikhKp4XvyJe+YaG5LLxrb8q7nmKdVaxffmdcvErO5
	USuBPwsaCLpVxpdGAiA+XXf1BLp0h8Luhcz0FaEup6D+q+jM3T/uT9Lvg0g+p29y1loNqY
	s8CHoc7V9WeQvVwm5m+FiL91EvCiUHM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x3tyovTSuHPSGETPwcjNdH5ZDZ4Zl6jfQyrC3+aX5GQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787751093; v=1; x=1788355893;
 b=C7d7rAfscWZy0lLuMytPxF9pgrfuOaRgMYISc1/Z/1ekH7m6KwUUUVs7I/FQk5fFxanGRNr1
 FfLjlV9SjV3Q1aosChAyoGtGq7gr9vGv5vtnBQQQozVs6nJmb825Sf4melvZFebpCsEpUyh6Y/C
 708zwiatiA5PHri6t9I7Twus=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:5b::)
	by mta11.migadu.com with ESMTPS id 4f3da476f759c30b;
	Wed, 26 Aug 2026 13:31:33 +0000
X-Mizu-Trace-ID: 4f3da476f759c30b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Usama Arif <usama.arif@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm/swap: refault on swap-in, not in the swap cache allocator
Date: Wed, 26 Aug 2026 06:31:28 -0700
Message-ID: <20260826133130.806177-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825172604.3243589-3-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6i7tqymmscwehkjiwhusq6tqh1xha96a
X-Rspamd-Queue-Id: 7D9931C000F
X-HE-Tag: 1787751096-111609
X-HE-Meta: U2FsdGVkX1+7NsJ9ESfjyG8M3LC4qGU6ZHqBUlCPGbqbigpTylSi0ggJoe8t26uGQ3aBJLRbjlTi9ugyjYwlSA+zDEiSfrpA49DPZwP/elHJyN2oeujpVGS4I6blfhKyb77ig8lnY/1f/YkJ3kB/7FMkrrNe2VRVzWUZgitjrkERm8JWGlNDi4Vb9+8VaHGRxlBIlozdH9HLd2Qflm8tiRRgwTwivBdA0B8TE8sT0KizTdGDA2lDbsYCiFCyv7xW09X2JKEA3O3rKwSIGbNAgOM3KQi4TNbj6jtheOvScqg4BYCFY0RpwTHFbuwDp/SXKVOB//Fw2qQnPqXkoUDr9REJXd5ufQYDAYpynQicPZkmXteyO6KsyuClo06cHpoEsm+P7bg8o+7n+V6XBjcr1wKymkjsH5e5qI2aViRpCKLzEWS3ew0sFyNazTGZvSvEHbpn8WQVW8v+s2xZwYE9aV8mGfLC77ggLqndrqAUe6LTPktbqcaHXcSmUHKPdBxBQROGsTdSs+zVsmglHmvbt+wYgn8M94g58ZnUmqLnig9PZSWZ/GKeymzIYo0aVVdUoKr9VNeQLo845VTiQlG9a7EkVq/HI15RhavrDtAk2EioBim6d5gL7QPWOs2ELBLuqsIprFD9F3ErKNUS2g7pEAN0X8tCP0Klbtz7h7ONXj1o+FhE7gVfg4qkGrm1A0LsFwzpygkRSrw18sWzAW/GJ8V1PIr2HeDAIW3S360i3Osh7a79E6BPr4OmfJMNvdNNA88LWQPGKsPHtzHEa0hkXifouv3V2Sq5sDz6ViazTGA4UDtu0qaRy/cJjNXri67QhHCeVrpwu+nUTEbrhSIdHhSv9UwGkWzeXbfB32X2witTnz1LZZpT6RDEOw9UVePEEBmtFOkD4o1I635sCNb6iNfRJesGWYmUbpI+KLbjYkZpaIPkfdQxhszzlnn0kF06F6XBaTz/yNV7oS73VJg
 64Z1b/uV
 4FsaHcb0rVNfoscKKBErU5NZ2ZykbKlPXf5ZtefhXQS92dg0OT4TKojLtJ6MG7Iff4BsG4twv9ETpYKRvYy3xBDf/hYPjSP3l+mdTHFkjH06mynKmZgOABVC1IZ+UCtAMgDOJO1V/H0KON3XWcYIAwJBumbYsl7+7K00iOms/y+ilKI3iDjTc1/mgzIZ36tCoWJqicy0SKj2ND1ADViShpe0sUBG5sbPtKK0ytMiUffYyuLf8zK6rbi6kK1YamJ4oeGocssy+lhcY4ZGA4Ac4Q6bAPKtHTHPF3B3hmjrffM7umWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 19:24:52 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> The swap cache allocator evaluates the refault of every folio it
> allocates.  zswap writeback also allocates through it: the shrinker puts
> a buffer folio in the swap cache to write the compressed data out, and
> that allocation is then counted as an anon refault (and, if the eviction
> looks recent, as an activation) even though nothing faulted the page
> back in.  On a workload that writes back continuously this inflates
> workingset_refault_anon and workingset_activate_anon substantially.
> 
> Move the refault evaluation out of the allocator and into the two
> swap-in callers, which read the slot's shadow before the allocation
> overwrites it.  zswap writeback keeps allocating the buffer, but no
> longer reports a refault for it.
> 
> The refault is evaluated before folio_add_lru(), as it was before this
> patch, so workingset_refault() still sets PG_workingset/PG_active while
> the folio is off the LRU: folio_add_lru() consumes both when it picks
> the LRU list, and under MGLRU when it picks the generation.
> 
> Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap_state.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index bf8ff2d2dbf1..8046fea015c9 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -483,8 +483,6 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  
>  	/* memsw uncharges swap when folio is added to swap cache */
>  	memcg1_swapin(folio);
> -	if (shadow)
> -		workingset_refault(folio, shadow);
>  
>  	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
>  	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> @@ -646,17 +644,26 @@ static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
>  		pgoff_t ilx, bool readahead)
>  {
>  	struct folio *folio;
> +	void *shadow = NULL;
>  
>  	do {
>  		folio = swap_cache_get_folio(entry);
>  		if (folio)
>  			return folio;
> +		/*
> +		 * Capture the slot's shadow before the allocation overwrites it,
> +		 * so a fresh swap-in can be evaluated as a refault below.
> +		 */
> +		shadow = swap_cache_get_shadow(entry);
>  		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);

Can this refault against a shadow from a different cache generation?
Another swap-in can replace this value, reclaim its folio, and install
a newer shadow while this caller is allocating.  This caller can then
win the locked insertion but still use the older snapshot.

What I think should be done here is have an optional shadow output to
__swap_cache_alloc_folio() and return the value captured by the successful
__swap_cache_add_check() under ci->lock and se that output in the swap-in
path?

>  	} while (PTR_ERR(folio) == -EEXIST);
>  
>  	if (IS_ERR_OR_NULL(folio))
>  		return NULL;
>  
> +	if (shadow)
> +		workingset_refault(folio, shadow);
> +
>  	folio_add_lru(folio);
>  	swap_read_folio(ctx, folio);
>  	if (readahead) {
> @@ -688,17 +695,26 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
>  {
>  	struct swap_io_ctx ctx = {};
>  	struct folio *folio;
> +	void *shadow = NULL;
>  
>  	do {
>  		folio = swap_cache_get_folio(entry);
>  		if (folio)
>  			return folio;
> +		/*
> +		 * Capture the slot's shadow before the allocation overwrites it,
> +		 * so a fresh swap-in can be evaluated as a refault below.
> +		 */
> +		shadow = swap_cache_get_shadow(entry);
>  		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
>  	} while (PTR_ERR(folio) == -EEXIST);
>  
>  	if (IS_ERR(folio))
>  		return folio;
>  
> +	if (shadow)
> +		workingset_refault(folio, shadow);
> +
>  	folio_add_lru(folio);
>  	swap_read_folio(&ctx, folio);
>  	swap_read_submit(&ctx);
> -- 
> 2.53.0-Meta
> 
> 

