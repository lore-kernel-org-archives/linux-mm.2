Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F79ACCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 12:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9F38E0006; Wed, 12 Nov 2025 07:20:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685208E0003; Wed, 12 Nov 2025 07:20:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570778E0006; Wed, 12 Nov 2025 07:20:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 412B58E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:20:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E642B4CAD7
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:20:25 +0000 (UTC)
X-FDA: 84101862810.24.23280D5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id A27051C0010
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:20:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="IllhdVQ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ll+CVdWp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="IllhdVQ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ll+CVdWp;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762950024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fJgBzJQP0sS2omGggkPaz3ok+zhlqSlX+D5dBkkZgY=;
	b=p8syyzrykBU+v3nmOBwyu3mTsAJWYRXszgYb1d8MUSxFPRDrcuBkG6+RvReG/QWzcicfMd
	CmGQYhnSmOCroHOuaNlG2TjYuJmoheHO620tba8W8CLgN88WW/HhxH6bwYEGyRLZgd3sLY
	XfBwqBzjIOUn0hO3OmveTNzZ+qr7kTc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="IllhdVQ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ll+CVdWp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="IllhdVQ/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ll+CVdWp;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762950024; a=rsa-sha256;
	cv=none;
	b=4Vggz1YCWqAhFyN1bmqNo+ASR4q8Ukf+UU5sKC9fcYGbDrVLk8P0gPIfPzJxfoiNdwpwWx
	5q6kB7b2ECk3qaRAudA8KENY9cCCYSh37Bw1pY7Emai7GrIgbZgaDXgLtw6O4BRT+U89Xj
	xjS+cJqcb+XmjKTBZRke7e56Z9XOQTc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C22AA21A6E;
	Wed, 12 Nov 2025 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762950021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fJgBzJQP0sS2omGggkPaz3ok+zhlqSlX+D5dBkkZgY=;
	b=IllhdVQ/WTFKBvcCMx/Q/Yn/R0MD1Y3AZB7S/X2kmpEmNXQ8B6YDhQj7H2iJn842Yvr3Pp
	6K4qL1iYm3HIdtDnw1T6D5noEIHbuoa29uRyAHAQLE/CtsfZNAgn3EwbdCNlMTFS30AYJQ
	IUsvsBm4Q3ZYRaWmPYQtxLWm8HndVXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762950021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fJgBzJQP0sS2omGggkPaz3ok+zhlqSlX+D5dBkkZgY=;
	b=Ll+CVdWpYsnPw/VXyoFhLvtYX8uTbnC/BmThQhkK1uyOY0gnEWbKYktk/wnmPtS8nMJFDu
	FQcVegPLwNhGS6BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762950021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fJgBzJQP0sS2omGggkPaz3ok+zhlqSlX+D5dBkkZgY=;
	b=IllhdVQ/WTFKBvcCMx/Q/Yn/R0MD1Y3AZB7S/X2kmpEmNXQ8B6YDhQj7H2iJn842Yvr3Pp
	6K4qL1iYm3HIdtDnw1T6D5noEIHbuoa29uRyAHAQLE/CtsfZNAgn3EwbdCNlMTFS30AYJQ
	IUsvsBm4Q3ZYRaWmPYQtxLWm8HndVXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762950021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fJgBzJQP0sS2omGggkPaz3ok+zhlqSlX+D5dBkkZgY=;
	b=Ll+CVdWpYsnPw/VXyoFhLvtYX8uTbnC/BmThQhkK1uyOY0gnEWbKYktk/wnmPtS8nMJFDu
	FQcVegPLwNhGS6BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB6433EA61;
	Wed, 12 Nov 2025 12:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dMg9KYV7FGmvLAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 12:20:21 +0000
Message-ID: <c691c9c1-a513-4db3-95f6-3d24111680b7@suse.cz>
Date: Wed, 12 Nov 2025 13:20:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mempool: add mempool_{alloc,free}_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251111135300.752962-1-hch@lst.de>
 <20251111135300.752962-8-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251111135300.752962-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A27051C0010
X-Stat-Signature: 83jf9tm47h4m538u8zxz1wqy4njjdsc7
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762950023-369935
X-HE-Meta: U2FsdGVkX181FW3l5xULvYgzjiU4tDKPfmUtFglcXMTn3SmzXV2gVWKsQbP2gmoEYAixXTR8TOj0PDVXpQDECREGSl9oNVfKG0PPHh9btwsg122GDsu8RTKKQhehbm8zhhg/Fr2InThC+6ebvcKczTWt8UxbVF+WI32GGBrrwTuEan8xCLRLPhMNbK1KuLDTUiHxp8LAOr7FP4jVQXvgN0HfYS/ZvX40GFIt7BjqlJhy932UFxL/garqQzt8JkI277M2i27tq5RFF7t/Juh9wS4jGf8gXyXd4QwVmazyrwPjBEpsAMjIcDj2uq0Z4wCoGh6xqyQf/EUK/+sL+1fDZ90nKVLmmFxw34NWC6nQAd3boj+3WN/+A4ZNInBpaxncZ11RLidcBnj+619cw5UrOgdS/wb4B8Sx5A3trbqp/vp0cB/uIAlpH5Wy6l25xrIwuBBrYo+t2+Bun7gZ6Kbz+Jwc05pnAqeGX31k5ImNYTPhTpU7gyA5hIbSGxjRyGXiu7rIsQsJycnrtHEhkRU1hkIP9DEwPJPwlJb1+596Za7Gb3VOH7bF+O3I7zawYq4zXmC2xKA8ioCCqr9W8r5iaZIZQMef/zHf01wybbG1PuuLy0b71q4WdVvkXoIgvpG5FwIeoHBWdgVvM9I9iJrZ1j0yILruIOi9tZO4e9nAlD1uGOaGJELlvbM8q9CrnNh3JVrCzOZJ1yZ3qEpaU6ykaaa62pOO7oYpOFh5OXThwKKe4PO9WaoySaXG0QFBjSFQCi9XUuxsX/L+ij3uIDDBLV82zHPPOXFG4B6twnMmkMfMytRqodZLwdc/Qw+a+Eqik4ykGPk4IoklsyujITdGVfGdM/IAsgb2ma1BbO3+8PHXrBqOKJtLLIL7TpHkkpVmnTzQ25iIVwkTkNcEnEEXsS5w4soKECQzNjmd6gFPqqhedcdDIl15NvUuc2Omx60opAOSZVMPt6Pg/WJeslD
 qtuO3GHU
 v7cYhPKL5+T5ocSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 14:52, Christoph Hellwig wrote:
> Add a version of the mempool allocator that works for batch allocations
> of multiple objects.  Calling mempool_alloc in a loop is not safe because
> it could deadlock if multiple threads are performing such an allocation
> at the same time.
> 
> As an extra benefit the interface is build so that the same array can be
> used for alloc_pages_bulk / release_pages so that at least for page
> backed mempools the fast path can use a nice batch optimization.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/mempool.h |   7 ++
>  mm/mempool.c            | 182 ++++++++++++++++++++++++++++++----------
>  2 files changed, 145 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index 34941a4b9026..486ed50776db 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -66,9 +66,16 @@ extern void mempool_destroy(mempool_t *pool);
>  extern void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask) __malloc;
>  #define mempool_alloc(...)						\
>  	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
> +int mempool_alloc_bulk_noprof(mempool_t *pool, void **elem,
> +		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip);
> +#define mempool_alloc_bulk(pool, elem, count, gfp_mask)			\
> +	alloc_hooks(mempool_alloc_bulk_noprof(pool, elem, count, gfp_mask, \
> +			_RET_IP_))
>  
>  extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
>  extern void mempool_free(void *element, mempool_t *pool);
> +unsigned int mempool_free_bulk(mempool_t *pool, void **elem,
> +		unsigned int count);
>  
>  /*
>   * A mempool_alloc_t and mempool_free_t that get the memory from
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 8cf3b5705b7f..e2f05bec633b 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -21,11 +21,16 @@
>  #include "slab.h"
>  
>  static DECLARE_FAULT_ATTR(fail_mempool_alloc);
> +static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
>  
>  static int __init mempool_faul_inject_init(void)
>  {
> -	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
> -			NULL, &fail_mempool_alloc));
> +	if (IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc", NULL,
> +			&fail_mempool_alloc)) ||
> +	    IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc_bulk", NULL,
> +			&fail_mempool_alloc_bulk)))
> +		return -ENOMEM;

Pedantically speaking the error (from debugfs_create_dir()) might be
different, probably doesn't matter in practice.

> +	return 0;
>  }
>  late_initcall(mempool_faul_inject_init);
>  
> @@ -380,16 +385,21 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
>  }
>  EXPORT_SYMBOL(mempool_resize);
>  
> -static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
> +static bool mempool_alloc_from_pool(struct mempool *pool, void **elems,
> +		unsigned int count, unsigned int allocated,
> +		gfp_t gfp_mask)
>  {
>  	unsigned long flags;
> -	void *element;
> +	unsigned int i;
>  
>  	spin_lock_irqsave(&pool->lock, flags);
> -	if (unlikely(!pool->curr_nr))
> +	if (unlikely(pool->curr_nr < count - allocated))

So we might be pessimistic here when some of the elements in the array
already are not NULL so we need in fact less. Might be an issue if callers
were relying on this for forward progress? It would be simpler to just tell
them not to...

>  		goto fail;
>  alloc:
> -	element = remove_element(pool);
> +	for (; allocated < count; allocated++) {
> +		if (!elems[allocated])
> +			elems[allocated] = remove_element(pool);
> +	}
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
>  	/* Paired with rmb in mempool_free(), read comment there. */
> @@ -399,15 +409,16 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
>  	 * Update the allocation stack trace as this is more useful for
>  	 * debugging.
>  	 */
> -	kmemleak_update_trace(element);
> -	return element;
> +	for (i = 0; i < count; i++)
> +		kmemleak_update_trace(elems[i]);
> +	return true;
>  
>  fail:
>  	if (gfp_mask & __GFP_DIRECT_RECLAIM) {
>  		DEFINE_WAIT(wait);
>  
>  		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> -		if (pool->curr_nr) {
> +		if (pool->curr_nr >= count - allocated) {
>  			finish_wait(&pool->wait, &wait);
>  			goto alloc;
>  		}
> @@ -426,7 +437,7 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
>  		spin_unlock_irqrestore(&pool->lock, flags);
>  	}
>  
> -	return NULL;
> +	return false;
>  }
>  
>  /*
> @@ -442,6 +453,72 @@ static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
>  	return *gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
>  }
>  
> +/**
> + * mempool_alloc_bulk - allocate multiple elements from a memory pool
> + * @pool:	pointer to the memory pool
> + * @elems:	partially or fully populated elements array
> + * @count:	size (in entries) of @elem
> + * @gfp_mask:	GFP_* flags.  %__GFP_ZERO is not supported.

We should say __GFP_DIRECT_RECLAIM is mandatory...

> + *
> + * Allocate elements for each slot in @elem that is non-%NULL. This is done by
> + * first calling into the alloc_fn supplied at pool initialization time, and
> + * dipping into the reserved pool when alloc_fn fails to allocate an element.
> + *
> + * This function only sleeps if the alloc_fn callback sleeps, or when waiting
> + * for elements to become available in the pool.
> + *
> + * Return: Always 0.  If it wasn't for %$#^$ alloc tags, it would return void.

My sympathies :) But see below.

> + */
> +int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
> +		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip)
> +{
> +	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
> +	unsigned int i = 0;
> +
> +	VM_WARN_ON_ONCE(count > pool->min_nr);
> +	VM_WARN_ON_ONCE(!(gfp_mask & __GFP_DIRECT_RECLAIM));

... per here.

> +	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
> +	might_alloc(gfp_mask);
> +
> +	/*
> +	 * If an error is injected, fail all elements in a bulk allocation so
> +	 * that we stress the multiple elements missing path.
> +	 */
> +	if (should_fail_ex(&fail_mempool_alloc_bulk, 1, FAULT_NOWARN)) {
> +		pr_info("forcing mempool usage for pool %pS\n",
> +				(void *)_RET_IP_);
> +		goto use_pool;
> +	}
> +
> +repeat_alloc:
> +	/*
> +	 * Try to allocate the elements using the allocation callback.  If that
> +	 * succeeds or we were not allowed to sleep, return now.  Don't dip into
> +	 * the reserved pools for !__GFP_DIRECT_RECLAIM allocations as they
> +	 * aren't guaranteed to succeed and chances of getting an allocation
> +	 * from the allocators using GFP_ATOMIC is higher than stealing one of
> +	 * the few items from our usually small pool.
> +	 */

Hm but the code doesn't do what the comment says, AFAICS? It will try
dipping into the pool and might succeed if there are elements, only will not
wait for them there?

> +	for (; i < count; i++) {
> +		if (!elems[i]) {
> +			elems[i] = pool->alloc(gfp_temp, pool->pool_data);
> +			if (unlikely(!elems[i]))
> +				goto use_pool;
> +		}
> +	}
> +
> +	return 0;
> +
> +use_pool:

So should we bail out here with -ENOMEM when !(gfp_mask & __GFP_DIRECT_RECLAIM)?

> +	if (!mempool_alloc_from_pool(pool, elems, count, i, gfp_temp)) {
> +		gfp_temp = gfp_mask;
> +		goto repeat_alloc;

Because this seems to be an infinite loop otherwise?

> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mempool_alloc_bulk_noprof);
> +

