Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82608CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDBB56B008A; Wed, 27 May 2026 04:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2D56B008C; Wed, 27 May 2026 04:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9966B0092; Wed, 27 May 2026 04:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAE006B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:51:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E9228F9DC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:51:51 +0000 (UTC)
X-FDA: 84812582022.16.031E07A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C717340016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:51:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A4bj/hmQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779871909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cw6Hq3fwY9dORsY8hW5a014rXACoZ3Q9ELeTsBjnSJM=;
	b=Fst7bMmkbmcKRsIZ4xOE3HYZ/v3z60zXjrLc4RbVFYHMwHy2duKg515id2gmPq3z+RuVzl
	LFtyP/JgGGN+16pRYOZDDieY4btHIu6jYmpmptUZcINT1ygnHPk8pB5c8p6dxNw/hSMxxm
	gn7GvJZhnlUobu9N61p43uCZTNnLnmQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A4bj/hmQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779871909; a=rsa-sha256;
	cv=none;
	b=32Lxr72ej5zHjjm0Vt11kcUVAGhwaFJJPKN8NwFnlqMi6NZ8iaNDlJkbiaE0qgHDJvzNCR
	3T2fg6QVcinIx+Z4Fnhl3J3aeL82v8VtdPxJB5GZ5oRDwKi6hTaKn5rhdyeC0VQ5eV8+bf
	qFFJPUtL+WZKT/kxHkCK8HBYbwTrvRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C15BC4396D;
	Wed, 27 May 2026 08:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AD71F00A3D;
	Wed, 27 May 2026 08:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779871908;
	bh=cw6Hq3fwY9dORsY8hW5a014rXACoZ3Q9ELeTsBjnSJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A4bj/hmQa3H0KsSybQA679jZY8C2M2EBxCmGFd4kLjKqsNk3QWKHZjyPK5mXRkcfX
	 VpWCAte43G/7b72JGRYwED2VJuyypr5CTDlz+B/TBjr+N205H33pNj87fbEH7GjTMD
	 f4IzoJPCYeB66bnO4D2+DjO3keQikG9pILexzAijVpqCIMzJOir5m7RmSLWK4oBGUx
	 HpxXjQHd9D1kqOUe/dWA+5FlGHtZur/fBmi1sPvyfdRgQVFYYfU4QdQGQhpaG5w5EU
	 Y1D1Hds9rZPfYSD7ptH/l2KRCdPsgF384y4fFB2IicC6PJSaekfzn3Pg06DbJM/mVv
	 ywTh7ch9dWuXw==
Message-ID: <e4dcfbc8-2666-452c-90b2-25c4b2c50c9f@kernel.org>
Date: Wed, 27 May 2026 10:51:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Matt Fleming <mfleming@cloudflare.com>,
 kernel-team <kernel-team@cloudflare.com>
References: <20260527070239.2252948-1-hch@lst.de>
 <20260527070239.2252948-2-hch@lst.de>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C717340016
X-Stat-Signature: 1zgubu5prejwi77xstd1kn55g3oy5sun
X-Rspam-User: 
X-HE-Tag: 1779871909-244556
X-HE-Meta: U2FsdGVkX184XIc1q8yYDyk9cvq28JB0LLte5fzJjy2lMqwSDxrMfwO7R3EWxIjYeYFhkve3NspwcbdNsTOv5t1NKZhOP6IeyQfazk0b3mMEzf3l8aO+4WC+MKTWISyKvqcnpaFu0d1UToPOn+sgJfsUl0p2z2rXZsP3mJe6FNfTR35jbfjQzkmg/YlcYc5iGwNUujEDaF+562DTd0OFp8mG7asoCLAWu1oE9JOGPn2cein5gthDJ1UZY25tw368PhiKlVAk1sC0xlqQblXhNN3mtgwtdLyLf5+zX+QdVRxIaYOXDFUVKdRWG90CT32gyXVyVB4foxyWMxno541FBJ6GWrrjYD4eRdIgIxKuGtJgFs4fijRCad9I3EqPCNPeRgeRQAPPwETJ2ax+c5H33er8uPXDiCmLAKkAOxUjwP5RT/8XjGfSJkXeOARRzExEEgRBC3M9mvSMQMTPrNtypUNQ0uqIVw3KE8CLY+DU0tpnuaNlDwEE7riBubJDKiC67XJzyNQ5/gG++2T1ej2o4E1j/Gj0Y+auTpMk3UI9Mwup/cBWht1xPyUi8cJAHS+gOj6dhgZ76WgnumzUp8xkvPwfDKrimIPPJQkxl7FqPt0i74p4ncSWBUWB8RtY+N3jGlgx6fFCvYRcXE+Zw57q7ww+u98NZwpvgtvZsjswUUcdNS8I1hHH308WuhE52gyOHeLM2O1YCmfQishn95mUvntN78RiT7oHMToXXU2iCDQ49M7gIw6cYjpjlV4MQDNMN6egyMiAdzDspbIvcWbz/nc3aI1Vj+pMhUfa1IVTiCpe+QLEJq6BnBhvaOjXcZRbh6R0FfagQ85PjBLa5hBfl7LMupsDTUnGB6H1l98dufPP/Sr6z9VvikW0+YiDxkyiixOc6rj1/q7lh90oYhzkyODl0239kvIskjZ+HnJojjenFy9zznWYbtpUUcNBDbxpqzrKlIPbnlYkVRlL6x+
 2miHHluO
 Phf4Dhwgnfxyg6jY86xUrXlfShr6R3VLu1spICoOBcUWFFyAjLKKxgr3iveZmCUbaYjM5N1vqSMBtXWsfpuFC13NSoFRpnhaxIAbQxr7M0kDyg3LtlH/nvwh8QWU76ZODiMbDgCeRVUPKyKPzpGfCJ1/XCZgDGK3XkJ8yb5FXldHSgPYuicEn+mpbWaAZrmeDRs9SitpvQn4z+qo9t3qfGAA/q5lVjPM7TnTNo3XL8FS8ocPqQ3IOEnHSL3jT1D8LjUT3U0wtDZNuio64le2fTKIC+5hmsSUqJrOzJzjp7Dijx9PnrQuT13E0rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/05/2026 09.02, Christoph Hellwig wrote:
> The kmem_cache_alloc_bulk return value is weird.  It returns the number
> of allocated objects, but that must always be 0 or the requested number
> based on the implementations and the handling in the callers, but that
> assumption is not actually documented anywhere, which confuses automated
> review tools.
> 

I remember, this API behavior was requested by AKPM when I developed
kmem_cache_alloc_bulk.  I trusted AKPM's decision, but I cannot explain
why this choice was made.

I kept the netdev code usage below. The current napi_skb_cache_get_bulk
have a retry logic that assumes that a partial bulk number can be
returned (which it cannot as Hellwig explains).  Cc Alex/Olek please
review the changes below as you added this retry logic.


> Fix this by returning a bool if the allocation succeeded and adding a
> kerneldoc comment explaining the API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/gpu/drm/msm/msm_iommu.c       |  6 +--
>   drivers/gpu/drm/panthor/panthor_mmu.c | 12 +++---
>   include/linux/slab.h                  |  6 ++-
>   io_uring/io_uring.c                   | 23 +++++------
>   lib/test_meminit.c                    | 19 +++++----
>   mm/kasan/kasan_test_c.c               |  5 +--
>   mm/kfence/kfence_test.c               |  9 +++--
>   mm/slub.c                             | 58 +++++++++++++++------------
>   net/bpf/test_run.c                    |  7 ++--
>   net/core/skbuff.c                     | 24 ++++++-----
>   tools/include/linux/slab.h            |  2 +-
>   tools/testing/shared/linux.c          | 19 ++++-----
>   12 files changed, 93 insertions(+), 97 deletions(-)
> 

[...]

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 44ac121cfccb..73045b688385 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -288,11 +288,11 @@ static inline struct sk_buff *napi_skb_cache_get(bool alloc)
>   
>   	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
>   	if (unlikely(!nc->skb_count)) {
> -		if (alloc)
> -			nc->skb_count = kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> -						GFP_ATOMIC | __GFP_NOWARN,
> -						NAPI_SKB_CACHE_BULK,
> -						nc->skb_cache);
> +		if (alloc && kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> +						   GFP_ATOMIC | __GFP_NOWARN,
> +						   NAPI_SKB_CACHE_BULK,
> +						   nc->skb_cache))
> +			nc->skb_count = NAPI_SKB_CACHE_BULK;
>   		if (unlikely(!nc->skb_count)) {
>   			local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
>   			return NULL;
> @@ -353,16 +353,18 @@ u32 napi_skb_cache_get_bulk(void **skbs, u32 n)
>   
>   	/* No enough cached skbs. Try refilling the cache first */
>   	bulk = min(NAPI_SKB_CACHE_SIZE - nc->skb_count, NAPI_SKB_CACHE_BULK);
> -	nc->skb_count += kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> -					       GFP_ATOMIC | __GFP_NOWARN, bulk,
> -					       &nc->skb_cache[nc->skb_count]);
> +	if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> +				  GFP_ATOMIC | __GFP_NOWARN, bulk,
> +				  &nc->skb_cache[nc->skb_count]))
> +		nc->skb_count += bulk;
>   	if (likely(nc->skb_count >= n))
>   		goto get;
>   
>   	/* Still not enough. Bulk-allocate the missing part directly, zeroed */
> -	n -= kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> -				   GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> -				   n - nc->skb_count, &skbs[nc->skb_count]);
> +	if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> +				  GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> +				  n - nc->skb_count, &skbs[nc->skb_count]))
> +		n = nc->skb_count;
>   	if (likely(nc->skb_count >= n))
>   		goto get;
>   

