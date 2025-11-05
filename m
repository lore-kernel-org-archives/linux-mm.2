Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0FECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79DE8E000A; Wed,  5 Nov 2025 09:02:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51098E0003; Wed,  5 Nov 2025 09:02:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19418E000A; Wed,  5 Nov 2025 09:02:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E26E8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:02:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5770F4AE42
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:02:21 +0000 (UTC)
X-FDA: 84076718082.25.BE5BEE8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id D8042180017
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:02:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jSawCLWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6jWZV+5B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dHtNGHeO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3KknuFGt;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762351339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1KLyRXc/r/40zsKXUPDVsW9kzTy2ShCAC+tY+mZk9o=;
	b=oslqHgXcHT4Pp3BlEAXqY8949o1qpdF64FikBLn7hZfeSxHA5MaQaJiSJE0VvAO3tSEHJy
	e5ZhuEM/+M+YjRNAJY8dgI0rQjqor9/5D/Ivh8DARQO/M4S7s2UwP5i3CS9b9KA3MVNfln
	3mI7DJpSuY2Z6tlVPucROOEJW2IO+Fw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762351339; a=rsa-sha256;
	cv=none;
	b=tiovpn24D133Cd0E6RH72Gjc3lYrsTnBIjf6wI5Od0YS5JWvKQZBHGmgjeKKtm0mIhKZqx
	/s3+Tt4KMsL0iGzbWbD7oCHUPFqa8eYPEFqwW1m1huTTF5JOHwmftMNuNNGEd0m/uD8hOb
	6o87dDuqmfm/bN4rCMJA0iw62mVigcA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jSawCLWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6jWZV+5B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dHtNGHeO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3KknuFGt;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB915211FD;
	Wed,  5 Nov 2025 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762351337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V1KLyRXc/r/40zsKXUPDVsW9kzTy2ShCAC+tY+mZk9o=;
	b=jSawCLWukAtYGiC3VKjmVqHswkPKcwIAgFG5YsQkG+BbAMuEtohHO40xIYJHn1fN4WNLUB
	4tq3dcOqnHWRyQjyDDSIvG6fBjzGMIzBZmOIHMQ+7UFJgHBQnH5gW7NzKqtCdqQ+cHCxiw
	LATMdc+uPS5gPCf2hwzrCxkdr4aeKo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762351337;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V1KLyRXc/r/40zsKXUPDVsW9kzTy2ShCAC+tY+mZk9o=;
	b=6jWZV+5BJl8MPQ6zUWYalHhKRcv07toNF43tiZGgMUYDt4w00QBZKFmjtMuiM6PPgtMSYz
	aEGHqMAHR8hpgzDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762351334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V1KLyRXc/r/40zsKXUPDVsW9kzTy2ShCAC+tY+mZk9o=;
	b=dHtNGHeOH5/tXCmFzGwMiIIhv24VuGj6+LgmeXgTPLfeiIzRLjjVFfqR2APyakaErnLw3b
	8J5uzIhSl87YnwAkmpAePVlKr6TRBZShDirsPJSIUkn4wccOPW6sTEZelngR5hxhh/TFHv
	B6E2CX9i7apWcAmHInISFqn2q+DFsZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762351334;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V1KLyRXc/r/40zsKXUPDVsW9kzTy2ShCAC+tY+mZk9o=;
	b=3KknuFGttO9XYqDU+6WW0WCRLhWdfB0W0Zmx5+uJfk9AtrZz/FPpoa/QBJeQJUNdJlC2dw
	XZKGwLr45UiEHfBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1CD813699;
	Wed,  5 Nov 2025 14:02:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zyUGK+ZYC2nDMQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 14:02:14 +0000
Message-ID: <c6dbd7f1-0368-4ab2-83ab-e51b2b3e92b7@suse.cz>
Date: Wed, 5 Nov 2025 15:02:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mempool: update kerneldoc comments
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Eric Biggers <ebiggers@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-2-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251031093517.1603379-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xkurmt19hj7jqohb4fa3uxdxy9yx9t8d
X-Rspam-User: 
X-Rspamd-Queue-Id: D8042180017
X-Rspamd-Server: rspam01
X-HE-Tag: 1762351338-496116
X-HE-Meta: U2FsdGVkX19b/dy9EvXa7kXPpdgn4QnJXQUTzTdElykgvAi8fizoP3xc6PiQOBZ9A+2NQX6LqrEv/SYwnYTjjA6FMmtXq97SogLhNQPpOZ6bSmCpkyQZxVbAjLX3mrq45TlRAmVUzMcVGftfvpmeIQLJ2VfI1PT0XA/O6zM3Q55ijXsMtcZb0lNwBUyWr8Yh/oWQJw4M/d3VY3GI4YVU4ljNsb0IXabz51MPli2UpcyjK2Aq04Gzavjrtxilwkx3ooQzSelG6wn8oVEwNy+UV6kn6/p5wdo4Ox+jwW/0qwTdE2xnm0gW7FV2iYksDViVS9C/OlHFBiTnqvjBM8EHilIEMVwN/VN50mmG0c9XRy0o1ZgWOVRyeTSmaIoCPp1InZlMOxaoq/4O66vwmMteKOZAjYERp5xkpMsTy8mypeKI6OTlWlcyGt+UrHdhYj+DOtkKdqJPIJSvIsY/zwIFq9ztpuTn65g9s0mSlVW+wkKkhEGgKGeZjV+GkttEVthfWo4vRQ+NPXr6uBdPXNYrnTqYX7plOAEMmkZN7LF3AawdwfLyAkP9e0IdOnKAlWzKNQ5BvPTdTsQ4IbCR/I1epFV1MdDQSdNH0sUydxcCshFoWZ/oTfHY0w21BEy4Z7hGZlf5Te88LPDZwowYmNXuybTo5eHwPCp/Oz0rKKMvNsSYF+tdjitm1ycJGHpojKBedxehl+FjvR5sWGT2AYq/Jv9hSp0ZYhIcdcSDs+uwu7X6BNHuBxGhzN24nfM/y1nZ4AfT9UKV0ZVnVxMC8op26pn02lMghBZV4d9vMzNmkCXp3TE19X+pFEwst+W9PmCztZDv9jJl5z9mZY1YJSz2DFTXphB61pn7sOQXpTvgeDE9F9zNqneSgch2HUf2+8TpcuK+lmpROfOY6K7QvNlPlUBmxUSNQDT1k19vLM1xUzdL1NV6NtFBmIovb7eveqeL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 10:34, Christoph Hellwig wrote:
> Use proper formatting, use full sentences and reduce some verbosity in
> function parameter descriptions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/mempool.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 1c38e873e546..d7c55a98c2be 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -372,18 +372,15 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
>  EXPORT_SYMBOL(mempool_resize);
>  
>  /**
> - * mempool_alloc - allocate an element from a specific memory pool
> - * @pool:      pointer to the memory pool which was allocated via
> - *             mempool_create().
> - * @gfp_mask:  the usual allocation bitmask.
> + * mempool_alloc - allocate an element from a memory pool
> + * @pool:	pointer to the memory pool
> + * @gfp_mask:	GFP_* flags.
>   *
> - * this function only sleeps if the alloc_fn() function sleeps or
> - * returns NULL. Note that due to preallocation, this function
> - * *never* fails when called from process contexts. (it might
> - * fail if called from an IRQ context.)

Why remove this part? Isn't it the most important behavior of mempools?

> - * Note: using __GFP_ZERO is not supported.
> + * Note: This function only sleeps if the alloc_fn callback sleeps or returns
> + * %NULL.  Using __GFP_ZERO is not supported.
>   *
> - * Return: pointer to the allocated element or %NULL on error.
> + * Return: pointer to the allocated element or %NULL on error. This function
> + * never returns %NULL when @gfp_mask allows sleeping.
>   */
>  void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>  {
> @@ -456,11 +453,10 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
>  
>  /**
>   * mempool_alloc_preallocated - allocate an element from preallocated elements
> - *                              belonging to a specific memory pool
> - * @pool:      pointer to the memory pool which was allocated via
> - *             mempool_create().
> + *                              belonging to a memory pool
> + * @pool:	pointer to the memory pool
>   *
> - * This function is similar to mempool_alloc, but it only attempts allocating
> + * This function is similar to mempool_alloc(), but it only attempts allocating
>   * an element from the preallocated elements. It does not sleep and immediately
>   * returns if no preallocated elements are available.
>   *
> @@ -492,12 +488,14 @@ void *mempool_alloc_preallocated(mempool_t *pool)
>  EXPORT_SYMBOL(mempool_alloc_preallocated);
>  
>  /**
> - * mempool_free - return an element to the pool.
> - * @element:   pool element pointer.
> - * @pool:      pointer to the memory pool which was allocated via
> - *             mempool_create().
> + * mempool_free - return an element to a mempool
> + * @element:	pointer to element
> + * @pool:	pointer to the memory pool
> + *
> + * Returns @elem to @pool if its needs replenishing, else free it using
> + * the free_fn callback in @pool.
>   *
> - * this function only sleeps if the free_fn() function sleeps.
> + * This function only sleeps if the free_fn callback sleeps.
>   */
>  void mempool_free(void *element, mempool_t *pool)
>  {


