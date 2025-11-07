Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A796CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6DC8E0009; Thu,  6 Nov 2025 22:53:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DF98E0002; Thu,  6 Nov 2025 22:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB318E0009; Thu,  6 Nov 2025 22:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4F88E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:53:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAC55B83C6
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:53:50 +0000 (UTC)
X-FDA: 84082442220.22.03B34AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FD6E20005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:53:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aj6wZOA4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762487629; a=rsa-sha256;
	cv=none;
	b=8nesTceDpj/jm9nwe1xujrzzciyaEaBpptIRyEVdKRPTYFSoD2ZiutbW76cBoK0XI7oNU4
	+h/XA00xU9GmL4wLOSFw4BHec/BzG64Rt3VnbCGvkHwFwe6T6VY0i3xEb3FpIu35+CMWMj
	73twIF5FpcYqcoLLPIA96l8NGV26T5w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aj6wZOA4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762487629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffjtxdTM20U0KiJJQ8gQyBUn1aPzkMcMUfLD7ssoW2U=;
	b=m42gIL6nwDkwQf9fcnalvsvdX3Lfew5i2PWpmz9F6/lJuRdTB5XT/1nTm5fGrBd/h/2BS1
	/xP53IOsJ3abzBflWJUCuxdPXKjTKS/KSw6gGmxjsJHRmhHz64MYd0CLtwVCM0Xmid8pC5
	iBILtN8yBXWxgpMqL7z6TStW8cKtkak=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E60C940B18;
	Fri,  7 Nov 2025 03:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4A8C4CEF8;
	Fri,  7 Nov 2025 03:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762487627;
	bh=qPQrDC4pqEccrd+WZeXGR0TqGt+hmB5tkru+7RCZNlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aj6wZOA40pHVyNtDVKnc1AXjXHCwrNFRyy0fGlzNo3pt+uEjZAP1Djash7uN7F9eE
	 syY+ICi/KDynnnot29wlzSi5c3/DcfGLJXeOBr1LKQArXCiQZL9MU8cOBFC5NGIuez
	 YFXxASWmwSeEFQyC9ysQRgXA8FvNc+F55M2CiaGvWzSMFxbvfLB3zz7CJq92biO6+d
	 1urVPv9rOkPXujGLFMRDv6nA5Q4xPgvO0BnHPt4qjKshqXBbZtoqOgbQsIR/DbRKH+
	 iZgHRKJHTRzvbjFLf51ARgCFv6GJQifI/k61WYCED+/r6wV09nPR/+Rh738s5DzJD3
	 3LP5RkUDv4w8A==
Date: Thu, 6 Nov 2025 19:52:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251107035207.GA47797@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-4-hch@lst.de>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2FD6E20005
X-Stat-Signature: dkkd8krb65iso668t9jxbrp4ccx6smim
X-Rspam-User: 
X-HE-Tag: 1762487629-188485
X-HE-Meta: U2FsdGVkX1/cVXQvYU7oCFSNTHP3rGyaarA4ioEnIAS3vrWWDFjr+t5upP09MaboNJ3JLt3QS3Zq4bm7/I7fBqlBr73Dg/9y5oKddx3gT4nBAjDX0xkGq4qSrrgE1Q/RcN9p89DqR/3bFjqjJZY189v1wUw8zIxSkKpR5uUxtJpIi6PeFPZZUXKogWRcUNhtC1APopjsKRF6tVW82+uWDqUIMBiLMtaEj/gulp4KgOAaYApjllnyT9+j1QfpfWTuBrXe3QNIHgQqfE+3Cu5kzKvEe1yax1Woj7iKRCvuWfCo0QEOJK5HgULC34n+zGPPnc0DxIIgs2sRYowox8rqSFLk5us9d3qwKPmbQqCdrJZcRWtNKXDY+WdlLQYXlgisc4vJ9R/1MlOMNj551KtgY/USFCeV97AqSlqI92AmrhSko3OzjVNmCoIOD5SltUfeTE2YoJ7EbXLp0IdbsfgaBOm9etlKSxDQs/icn48T2n+4uDys6/kXyfBWtbJ0PVchg2DdBXNa/RcVlIyyn5Vlo3JPZypKhlC23aJVNg2VhobYKqmE+5zNte2eHZjEZIepLnD5eOyKRXDic0+4qfoHUuSSSSSHxYQe2U4JPjy3CYVa63bSoGiHlbPCpsm6KTSGi6c3Wmfd+GSlSYmqSzw6RwV4pr/DnpvpVwJAV1a7IJLm0jvn9V3i1MSJvKoj+TXOpND8CjiMNeUqOYieNLumzoTkhZv/tp/N+HohApG3tNq1X9Qml65s8KtXA7tn2HzbikqwsWLh75OqIyKzOykbjtRqHdu8sNvZskl6f5LOL7z/yJDciFgYB1X64IxVpP33mOIpU9IfcUEgxnWk4f9dC28zMcf6oq9WwsLWZ8MVAFe0ioQReMxIbHCm0VYLLFHZiUQyjhaWaXFC2RVU6ECQI1I/s1IWoW0Ok2oNnKoJJ0pnUsrmjgw5Q/mQkHQMqb57E//YKU/cqwCQf2ylOx6
 uNUVPh3f
 ladO+w/2XeddrjHktr4SUIc5UfNhZZfbtWV8uqFdR8S1Ggs8AK7gfXugzljMUtAY44qB92N2ngxAXZU4QXrw9+OVeVFFrXlmL6ZwmYk6zZC3fwOimIN5XUshspB3Ja06MGR5nQDzjHdZT0xwxC449u7RlSV6TjKGA3PnDO+8/0k6yv9vCzs7bVEXgpmRI5TOgsOJadQ+qVlhfn5q+c9X0Xxez+xQYI3uk8UYZMues1HTkjELboHkaxTdMTNhUJWUq5YxNt6HgEsQtgaeF+DGHNsbtnI/xwa0vlUnSGbgSqwJFub0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:33AM +0100, Christoph Hellwig wrote:
>  /**
> - * mempool_alloc - allocate an element from a memory pool
> + * mempool_alloc_bulk - allocate multiple elements from a memory pool
>   * @pool:	pointer to the memory pool
> + * @elem:	partially or fully populated elements array
> + * @count:	size (in entries) of @elem
>   * @gfp_mask:	GFP_* flags.
>   *
> + * Allocate elements for each slot in @elem that is non-%NULL.

elem => elems (and likewise for mempool_free_bulk())

>   * Note: This function only sleeps if the alloc_fn callback sleeps or returns
>   * %NULL.  Using __GFP_ZERO is not supported.
>   *
> - * Return: pointer to the allocated element or %NULL on error. This function
> - * never returns %NULL when @gfp_mask allows sleeping.
> + * Return: 0 if successful, else -ENOMEM.  This function never returns -ENOMEM
> + * when @gfp_mask allows sleeping.
>   */
> -void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
> +int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
> +		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip)

What exactly is the behavior on partial failures?  Is the return value 0
or is it -ENOMEM, and is the array restored to its original state or
might some elements have been allocated?

> +/**
> + * mempool_alloc - allocate an element from a memory pool
> + * @pool:	pointer to the memory pool
> + * @gfp_mask:	GFP_* flags.
> + *
> + * Note: This function only sleeps if the alloc_fn callback sleeps or returns
> + * %NULL.  Using __GFP_ZERO is not supported.
> + *
> + * Return: pointer to the allocated element or %NULL on error. This function
> + * never returns %NULL when @gfp_mask allows sleeping.
> + */
> +void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
> +{
> +	void *elem[1] = { };
> +
> +	if (mempool_alloc_bulk_noprof(pool, elem, 1, gfp_mask, _RET_IP_) < 0)
> +		return NULL;
> +	return elem[0];
> +}
>  EXPORT_SYMBOL(mempool_alloc_noprof);

How much overhead does this add to mempool_alloc(), which will continue
to be the common case?  I wonder if it would be worthwhile to
force-inline the bulk allocation function into it, so that it will get
generate about the same code as before.

>  	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
>  		spin_lock_irqsave(&pool->lock, flags);
> -		if (likely(pool->curr_nr < pool->min_nr)) {
> -			add_element(pool, element);
> -			spin_unlock_irqrestore(&pool->lock, flags);
> -			if (wq_has_sleeper(&pool->wait))
> -				wake_up(&pool->wait);
> -			return;
> +		while (pool->curr_nr < pool->min_nr && freed < count) {
> +			add_element(pool, elem[freed++]);
> +			added = true;
>  		}
>  		spin_unlock_irqrestore(&pool->lock, flags);
> -	}
>  
>  	/*
>  	 * Handle the min_nr = 0 edge case:
> @@ -572,20 +614,41 @@ void mempool_free(void *element, mempool_t *pool)
>  	 * allocation of element when both min_nr and curr_nr are 0, and
>  	 * any active waiters are properly awakened.
>  	 */

The above comment has a weird position now.  Maybe move it into the
'else if' block below.

> -	if (unlikely(pool->min_nr == 0 &&
> +	} else if (unlikely(pool->min_nr == 0 &&
>  		     READ_ONCE(pool->curr_nr) == 0)) {
>  		spin_lock_irqsave(&pool->lock, flags);
>  		if (likely(pool->curr_nr == 0)) {
> -			add_element(pool, element);
> -			spin_unlock_irqrestore(&pool->lock, flags);
> -			if (wq_has_sleeper(&pool->wait))
> -				wake_up(&pool->wait);
> -			return;
> +			add_element(pool, elem[freed++]);
> +			added = true;
>  		}
>  		spin_unlock_irqrestore(&pool->lock, flags);
>  	}
>  
> -	pool->free(element, pool->pool_data);
> +	if (unlikely(added) && wq_has_sleeper(&pool->wait))
> +		wake_up(&pool->wait);
> +
> +	return freed;
> +}
> +EXPORT_SYMBOL_GPL(mempool_free_bulk);

- Eric

