Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D20606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hs2SXW9V
Received: by kanga.kvack.org (Postfix)
	id 898E56B00EF; Fri, 20 Nov 2026 05:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FB76B05B8; Fri, 20 Nov 2026 05:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785EC6B05B9; Fri, 20 Nov 2026 05:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50A1B6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:33:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4A3A80EE9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:33:14 +0000 (UTC)
X-FDA: 85455135108.14.77C4FAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 15EF31A0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:33:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hs2SXW9V;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170793;
	b=lIhTNIbyWfm94Aeh7LpoSXl94eiSU++DqZjeQ+BDlFGbQDOR/Xvts4bApUi0XCm+IhQb6p
	O1iltRBRAncSC9ZoIUelG35ZloZNWrlBUpEMHzX7QbVMDcyIOAO5buZzOvKLJ+r+ErTKRc
	VPr+W2d4NmDP1v0gi5m0mKwnKHIzXNA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8WTG0DzS1hPuRXBgn6FCxY0K+Jl6xxWQ77sF6Yqsjw=;
	b=ny3cR1a1XTfIIxHkJr46jkgzPK2pBiVUtZM9RnYw+Griqm2HijchLAr6lP95Jn7KCT+SR2
	DdabEIzrm+9jThomUgfH5sj64+VX/SQ5cSmbN8umd29jOPWytbx/SCvSdS/u8smKLsDw6B
	SS/r6ZLhqEQ6RhSWvDVMBuCwnU1J6ug=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hs2SXW9V;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B8D561147;
	Fri, 20 Nov 2026 10:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E202D1F000C0;
	Fri, 20 Nov 2026 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170791;
	bh=j8WTG0DzS1hPuRXBgn6FCxY0K+Jl6xxWQ77sF6Yqsjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hs2SXW9VNA9jRs6jViEkz1v+oyKqHMNia2qjPasfAlLAyjaHV/S4J4ZZe49Kx4+a+
	 58ry23EIAvQJzBlaV0saAV2mWatcNcL1WZRXxGq8K6CvfMKf1dW1DQNS1Q71Ryx3s2
	 K1bPlHDScNcLC3SPiBme8UW8lXqxKdtPHSh1lvVyhN+2RJWwzZTWi6LtuYrkJzroXz
	 PJfXAqGImdjymdl95TKiIFGIJzOoi5Z8pP4INhHq+sm0v1+hfa9Nv+KTINrJkb15IH
	 5rsm4zdGEm+0JokSjMQ/Xie9yWgMzKtYbQccQ0tJRrGZ4kyFvcAkpczMmj0s+oOMCp
	 chMTeTZxyan/A==
Message-ID: <0d55ddb1-0cc7-4d87-9d29-9165d35102a7@kernel.org>
Date: Fri, 20 Nov 2026 11:33:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mempool: account the element array to the caller
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <20261119-alloc_tag-v1-3-efcccfd3a9c9@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261119-alloc_tag-v1-3-efcccfd3a9c9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: esbq7bboajhwxk975iyzuzor8x6qcqhx
X-Rspamd-Queue-Id: 15EF31A0003
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795170792-650595
X-HE-Meta: U2FsdGVkX1/SdVtg9libD8glqPaDdU6j3YN79G+CF/l/Pxm3VOU1tgsfdKLWp4tih7U9H+n4Yrt+RDZ6MT5+5Zrm3xUHcsmNgfnWie7dWewLllgKyfcf37asyJGrBe66s1ErqPJ6o6W6ZyCnuN77myVBIwzqD20VJtekWF1aV9ZslQ5mSKjt/8QaknB7GDviJsztaFW6eWgQUxYKTAD7lL3V8XhH/tAa+tpFZa3YfAEZ/p4EAh9q70SaizYgSHq8tsl1SWj+SymCbVpUS51xEnHDt3biXZpo8B9k9NOYZQ5Ou+A7uNHL64ilIF9FMCZa435noYwrvcs/gBbYByJAQ43u+/rjy9lEhmKUtsUJ/uI0UjOfhyS2njnszQWRO42P9mkfQtYPArISuf7dij9fYh+bOHSUq0iQ3BzolFEa9Xn2rVVZmbb75AOkCOnLOhYAAdVFZoghCu7Mif1HbNM9XsdY//+ZFttJfbu5l0tt183ihxbU7NyzZgaKrkDu31TrKt+1JA/7C2GRQn+vdVKv5iLTEIeZC0/BMH60f1rDSMO5L4wPVZ8hbp0A5AJstptEn6NfUqqndU/8EUCUDZKPpdNBpDpHlot6INA/H9TzHc7f1ynBbjroyTsTsz9A3Svw6/xy95ZAW5M5ZXpe/xr2IGGk6VsT9kupC28YFdEhBoFxWbPrDaNbUtx4JfOTWSgUHzV0H6zm4mH/CA5IDYZeauEnrYZwh6Ksi1u/cJ8TIIiJUNepC+Lrk5JGyhT+C3mV6VQw9z7hC3lDDqI373Yxy0sqxJlT3RUrA+zOfpgvz5DCAFwOURY2lvOpBkwSl5Ut7dEMs0SLOXElvU7DWV4si7xxhU3DQrBODNsgkz06REYwymcFcPLobxFf1y5EStyPHy8WWFE9n3rJ2Ga/naQZyWttfwMeQ4osxKGpWJNRKrhqTn5MxzXwL8W6Vo8dsBOfCCqrU/0i6WgRVUUekKJ
 UWxXQJLi
 Uoesqo9MJpjVVX6T013fHUO2nDn6HFCqaBeIXyaTEjz6bZ7XJjzvbL1LiFsUxv2vM6aeEK0KByfwdYTJPGfqxZP5NJd1HgeKNzD5grZnvtsfqMIgHeJMAatsHtlnJsxJJ2L9lGwkZRN9v8stLWWXDcv5hBOlmR0BQqtBBoc4FjJFBM3zC6Nc/vmT0VfvS6PwvSGtmLX2i0p1swxBU8jvAPi4a5z3RvtDFxOGlTugzoRdkIbuhJFiFF1+JeInSLZcaPKTf8WbHMJJ3TSNzgINWzNCQ14jNT4tAIgyNZ2gVd0BW/xSzfJicFgsH24CLRpnrQC474qQWvx6ui7ejkVJ2v91eOqLFQGELYKdhhzaw5+ut4Qg+MZ9K47cFNjZck6BMGq2fVrfBr04dKRtwPQYTYxrRLYJGoxOPyDZpIEggK7JTBDuJY8Ri2/V0nxa/GHOlpcqzcnsIYC6x9XfKnRXP8Sk4YYRoteW9TidLLr1BY78NqiTjPIguNuYDPJaY+7ChULPgclLTyK31LkIcPRHV/LfzY2gDDzjLptX6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 09:52, David Hildenbrand (Arm) wrote:
> mempool_create_node() accounts the struct mempool and all elements to
> the caller, but the array of element pointers allocated by
> mempool_init_node() and mempool_resize() ends up being accounted to
> mm/mempool.c in /proc/allocinfo.
> 
> Let's consistently account all mempool allocations to the caller, like
> ptr_ring_init() and ptr_ring_resize() do, by using the _noprof variants.
> 
> mempool_init_node() is only called from mempool_init_noprof() and
> mempool_create_node_noprof(), which already set the allocation tag.
> 
> While at it, make mempool_init_node() static and rename it to
> mempool_init_node_noprof(): it is not used outside of mm/mempool.c, and
> calling it without an allocation tag would be wrong.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, but if this is due to an AI report, they should teach it better about
what's urgent, to the point of not reporting such things at all :)

> ---
>  include/linux/mempool.h |  3 ---
>  mm/mempool.c            | 19 ++++++++++---------
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index 5444dcb63efa8..7f8e257017c01 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -38,9 +38,6 @@ static inline bool mempool_is_saturated(struct mempool *pool)
>  }
>  
>  void mempool_exit(struct mempool *pool);
> -int mempool_init_node(struct mempool *pool, int min_nr,
> -		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
> -		void *pool_data, gfp_t gfp_mask, int node_id);
>  int mempool_init_noprof(struct mempool *pool, int min_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data);
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 5e0ba516efdbf..30cbe44d464b3 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -243,7 +243,7 @@ void mempool_destroy(struct mempool *pool)
>  }
>  EXPORT_SYMBOL(mempool_destroy);
>  
> -int mempool_init_node(struct mempool *pool, int min_nr,
> +static int mempool_init_node_noprof(struct mempool *pool, int min_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data, gfp_t gfp_mask, int node_id)
>  {
> @@ -257,8 +257,9 @@ int mempool_init_node(struct mempool *pool, int min_nr,
>  	 * max() used here to ensure storage for at least 1 element to support
>  	 * zero minimum pool
>  	 */
> -	pool->elements = kmalloc_array_node(max(1, min_nr), sizeof(void *),
> -					    gfp_mask, node_id);
> +	pool->elements = kmalloc_array_node_noprof(max(1, min_nr),
> +						   sizeof(void *), gfp_mask,
> +						   node_id);
>  	if (!pool->elements)
>  		return -ENOMEM;
>  
> @@ -279,7 +280,6 @@ int mempool_init_node(struct mempool *pool, int min_nr,
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(mempool_init_node);
>  
>  /**
>   * mempool_init - initialize a memory pool
> @@ -299,8 +299,8 @@ int mempool_init_noprof(struct mempool *pool, int min_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data)
>  {
> -	return mempool_init_node(pool, min_nr, alloc_fn, free_fn,
> -				 pool_data, GFP_KERNEL, NUMA_NO_NODE);
> +	return mempool_init_node_noprof(pool, min_nr, alloc_fn, free_fn,
> +					pool_data, GFP_KERNEL, NUMA_NO_NODE);
>  
>  }
>  EXPORT_SYMBOL(mempool_init_noprof);
> @@ -333,8 +333,8 @@ struct mempool *mempool_create_node_noprof(int min_nr,
>  	if (!pool)
>  		return NULL;
>  
> -	if (mempool_init_node(pool, min_nr, alloc_fn, free_fn, pool_data,
> -			      gfp_mask, node_id)) {
> +	if (mempool_init_node_noprof(pool, min_nr, alloc_fn, free_fn,
> +				     pool_data, gfp_mask, node_id)) {
>  		kfree(pool);
>  		return NULL;
>  	}
> @@ -384,7 +384,8 @@ int mempool_resize_noprof(struct mempool *pool, int new_min_nr)
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
>  	/* Grow the pool */
> -	new_elements = kmalloc_objs(*new_elements, new_min_nr);
> +	new_elements = kmalloc_array_noprof(new_min_nr, sizeof(*new_elements),
> +					    GFP_KERNEL);
>  	if (!new_elements)
>  		return -ENOMEM;
>  
> 


