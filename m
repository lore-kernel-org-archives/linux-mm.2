Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFA0C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698F76B0088; Thu, 24 Sep 2026 05:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649DB6B0092; Thu, 24 Sep 2026 05:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5386B6B009E; Thu, 24 Sep 2026 05:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27B126B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:36:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A14891402D0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:36:27 +0000 (UTC)
X-FDA: 85248150414.11.9D7B6C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C4C3F140005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:36:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i62KZs0V;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790242585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiYfP3OJ/9LAMpeByACJ22Dt1rNk0pU/miAnrdFKvlc=;
	b=221l/8pOzhpc8OSNEhk+RnWgyHaN1mSmKgXeZdut7w/XhA/P5dNXiI3lgvRjP7xrR0RY8y
	mHjKsqyJ6rtQEbAdV2pX4K631GONkIUoDtkA1VWAN5KUJyqbFYJnWUeydZvERWiXVTWwVh
	YANxDu6N30M5J83IVa/AQLRrf24X4ac=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i62KZs0V;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790242585;
	b=1XZZwCL5EIB6VIwgrDTX+FLfcYwyvAPFD7R3PTw1YjhAiyRQv1etHanoReHGT1BTwQ7bPO
	hluMTUOcRNKHebtjX9Yify/axup2wUHxsPs+6494okZ4qVrm87cyreaK2FnvKE7qSdTJ7v
	XfSt/UsV+qrfxZXjnYDGO9KVpX8+m1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB0DD405B9;
	Thu, 24 Sep 2026 09:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C551F000FF;
	Thu, 24 Sep 2026 09:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790242584;
	bh=ZiYfP3OJ/9LAMpeByACJ22Dt1rNk0pU/miAnrdFKvlc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i62KZs0VBwe+7WBncDD2NIaGeytnxoCGW4Vafmq0m9+p38DyxbtEY9F5+z7w8RKUI
	 at2jPMAUdLGsOUedUT/Qs/GhkYLvX5xwWmLR4E093NhOY2B5AsPmLMTIYd0n1b3eLE
	 jhIHPNz/x+Rp64R6tyhnplcsec22FnQ4SrGhtQLsrwH0+Cm/NeU3z9pg0VBt9ToLhj
	 Q7Zrc9xaStAscYiuWDpsqw2oUJ1Li0YUXbw7+rGS3g7rIksABijDxpbfG4K9ZwVYCC
	 Z7i6jmG/FLBm6CXdF95+gRQYlDQL6tw6t5Wz5xcqudIbdlZZ1BYUfP78+H/98o7l4l
	 QLY5FdGww5brQ==
Message-ID: <0d798541-6486-44ff-ae57-f631d1465688@kernel.org>
Date: Thu, 24 Sep 2026 11:36:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] netfs: Fix missing alloc tagging of direct mempool
 allocations
Content-Language: en-US
To: Hao Ge <hao.ge@linux.dev>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Christian Brauner (Amutable)" <brauner@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>
Cc: netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Erhard Furtner <erhard_f@mailbox.org>, stable@vger.kernel.org
References: <20260923063759.34667-1-hao.ge@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260923063759.34667-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4C3F140005
X-Stat-Signature: sag4f4tabsfdd34ae1crg8xrwn8b4g9u
X-HE-Tag: 1790242585-436302
X-HE-Meta: U2FsdGVkX19bZ0nOV8+mx2/2krf9cpkvxeZPa122H96wv0zQuIx2gfif+fBFIk7LAw7bJDUlHTxWsVaW9/g9PC7qdym3I77nt1YXtl8I1A38MJfTGb42T3wPJIzcrXQJcNcgjE/JMnyzGwoVHDLJodV72i9LdrnO9pLAvRiUoRZaL1terFcqcB53+qGRUO/JYD+qskhVy0aLWh6QN73MyoAQ48DxxjqbSsSD8fDNINKFiGtoNey6ziJwU3zXQj1vDd5cpq2ccFGBa3z9PSWJiSfaDCKXg/+/xXF7a+spPR3NjE7xE8+XJjdvb1w0yTaG4FW8YsK/RlIR3t/Nc8L2OyUVBtmyix0zWmEB1KBf/V+xz4td+B1l4l/BHLc4RHeYbP0TVcMZZsWhZd7Kk1jMeoE3IJhCm7tvBwzIYqvjlAiGVsgSpsoR976RhHfSnRr1lnhBuop3rv3oXRrfkFTKCwsWHNa+EOmFpxBTHfK9wI6RpEuFcZTuqYfzHUUP2lqaSgvOAnHunu47mrr17nwa3+XgNRZuNiyeIeebOccbDuWIi1gx/H++fX6DxIRqOEKgPZhiW5Ojy6gUetpl3pTwVLgPebeYBz2PTh5BbiKyiP1dKC+oYVqexgTDdXlxqcOxBPJWu12wwLsj40brhaHBwLT4OsLcaoExVnawFNw6ov7HRH//0rHOvMuGtNoQIoepEIdpJZm771J9oJoAA9IOW/fcPxBAZdFN7mHtjAyX4SATVJi8UIstzDDNV6/lIZ9NbbafoAAPryM+DdycxiZQ24tMo49s1eGqDNlIvhMZTERB4d2KF36ptg9KpACI1iE+SSN5LMfIdgXQ1IohS8SaPhZhNvXdHLTPq6X6ICP/xxftk/ICFWIpDXa8HEKPiDRqoX+iv11kBtxCh/2sn43DtwNzxbhLiK6OSttBD1Yjp7D9lNOZVe3cV5/ezomo01htPTAukyKSm1qPA+rm2BQ
 ThCMuGcT
 ph21okW+2wWbB/bAGXnlwwMBw9PDWvcKtpLJIacRI+bsYRJzjKLrsw890+CZtLia3dbVbt2bGJd1VKFhw2EVq3CKdJHYYIBNtDeREbHRZ0aELuellnwVqKtnGwo1alqemAXfJIS23csjFoPLoNmyq3qSV1QlE0XGbzi/I2J2X06443m0mEF9gP0HYD1V5f+epy2hs0aqBo63qR+tVo7NHe1O6a61kEYKeQfpuXvP+Et5NugH1fz6d+y+1M508OD3m52pm4aScc6pkUtKUIMDyfaYqtWblH9ykAfxhjsI9pMglQ7v5jdMLvBW5PQ4zNlLqhHUgthe/XdNFaGUeOdOTsuLu0FhzJDZMuAEOi7j5Fgb9AEUBubTPvV+iEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Christoph

On 9/23/26 08:37, Hao Ge wrote:
> Commit 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by
> adding a mempool") added a mempool for the folio_queues and made the
> request, subrequest and folio_queue allocations distinguish between
> writeback and everything else.  Writeback is part of memory reclaim
> and must not fail due to ENOMEM, so it allocates under GFP_NOFS
> through mempool_alloc(), which may dip into the pool's reserve and,
> if that runs empty, wait for elements to be returned.  The
> GFP_KERNEL paths, which can return -ENOMEM to their callers, invoke
> the pool's ->alloc() callback directly instead.
> 
> The direct call, however, skips the alloc_hooks() wrapper that the
> mempool_alloc() macro provides.  The pool callbacks, mempool_alloc_slab()
> and mempool_kmalloc(), call kmem_cache_alloc_noprof() and kmalloc_noprof()
> and rely on current->alloc_tag having been set by the caller.  With
> CONFIG_MEM_ALLOC_PROFILING_DEBUG=y this leads to
> 
>     current->alloc_tag not set
>     WARNING: ./include/linux/alloc_tag.h:161 at __alloc_tagging_slab_alloc_hook
>     alloc_tag was not set
>     WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook
> 
> at allocation and free time respectively, as reported when reading
> files on a CIFS mount.  The allocations are also missing from
> /proc/allocinfo.
> 
> Wrap the direct ->alloc() invocations in alloc_hooks() with a new
> mempool_alloc_noreserve() helper in include/linux/mempool.h, next to
> the other alloc_hooks()-wrapped macros such as mempool_alloc().  The
> GFP_KERNEL paths keep their failable allocation semantics, they just
> get tagged now.
> 
> Fixes: 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by adding a mempool")
> Reported-by: Erhard Furtner <erhard_f@mailbox.org>
> Closes: https://lore.kernel.org/all/0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org/
> Tested-by: Erhard Furtner <erhard_f@mailbox.org>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Seems ok enough as a hotfix. The naming perhaps isn't ideal, we have
mempool_alloc_preallocated() already for the opposite case. Maybe
mempool_alloc_no_preallocated() to complement it? Rather long though.

I guess long-term it would be neater to have a mempool_alloc() variant with
extra parameter that says if preallocated pool is allowed or not. The "gfp
== GFP_KERNEL" check is probably not an universal one. mempool_alloc() is
actually rather aggressive in getting objects from the pool before even
attempting reclaim. Makes sense for I/O usecases but maybe not for this one?

> ---
> Changes in v2:
> - Move the alloc_hooks() wrapper from fs/netfs/internal.h into
>   include/linux/mempool.h as mempool_alloc_noreserve(), per Suren's
>   suggestion, so it is not netfs-specific.
> 
> v1 Link: https://lore.kernel.org/all/20260922023541.51532-1-hao.ge@linux.dev/
> ---
>  fs/netfs/objects.c        | 4 ++--
>  fs/netfs/rolling_buffer.c | 2 +-
>  include/linux/mempool.h   | 7 +++++++
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
> index 7f6a3e912602..ad549daa9c79 100644
> --- a/fs/netfs/objects.c
> +++ b/fs/netfs/objects.c
> @@ -34,7 +34,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
>  
>  		rreq = mempool_alloc(mempool, gfp);
>  	} else {
> -		rreq = mempool->alloc(gfp, mempool->pool_data);
> +		rreq = mempool_alloc_noreserve(mempool, gfp);
>  		if (!rreq)
>  			return ERR_PTR(-ENOMEM);
>  	}
> @@ -214,7 +214,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
>  	struct kmem_cache *cache = mempool->pool_data;
>  
>  	if (rreq->gfp == GFP_KERNEL)
> -		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
> +		subreq = mempool_alloc_noreserve(mempool, rreq->gfp);
>  	else
>  		subreq = mempool_alloc(mempool, rreq->gfp);
>  	if (!subreq)
> diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
> index 424e77a9a109..d30d5ef6d86e 100644
> --- a/fs/netfs/rolling_buffer.c
> +++ b/fs/netfs/rolling_buffer.c
> @@ -29,7 +29,7 @@ struct folio_queue *netfs_folioq_alloc(unsigned int rreq_id, gfp_t gfp,
>  	struct folio_queue *fq;
>  
>  	if (gfp == GFP_KERNEL)
> -		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
> +		fq = mempool_alloc_noreserve(&netfs_folioq_pool, gfp);
>  	else
>  		fq = mempool_alloc(&netfs_folioq_pool, gfp);
>  	if (fq) {
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index a0fa6d43e0dc..6da502aef2f7 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -70,6 +70,13 @@ int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
>  #define mempool_alloc_bulk(...)						\
>  	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
>  
> +/*
> + * Allocate a new element without dipping into the pool's reserves or
> + * waiting.  Returns NULL on failure.
> + */
> +#define mempool_alloc_noreserve(_pool, _gfp)				\
> +	alloc_hooks((_pool)->alloc(_gfp, (_pool)->pool_data))
> +
>  void *mempool_alloc_preallocated(struct mempool *pool) __malloc;
>  void mempool_free(void *element, struct mempool *pool);
>  unsigned int mempool_free_bulk(struct mempool *pool, void **elem,


