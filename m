Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F1ACCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F15580083; Mon, 27 Oct 2025 14:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C91E8000A; Mon, 27 Oct 2025 14:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B84C80083; Mon, 27 Oct 2025 14:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 284F68000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:15:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4141A01FE
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:15:49 +0000 (UTC)
X-FDA: 84044697618.16.CB51C51
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E63E1C0014
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:15:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iI7lbNbN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yt07Fsrv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gg7Lu8ed;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Efu9UhKl;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761588947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wb8dpn6xeYP9qyGroEaOUTchBIuSRC6oNA7X2yg9XKc=;
	b=3HgSt8vOERInzkFO61Gy3tXtvj9DYBxb77g1LdDkm67XRayaLWG9KqDkuknsOzOzwhlISf
	H+6e0VOa/i0P3/adlf0DO9hdtKhhfr6Ht5kpBLkCU4z+VENS6Q7BIx6WfOC3hkP7IHp7FL
	wAZHwqL7k/k9UzxADxfnWArra7ypwJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761588947; a=rsa-sha256;
	cv=none;
	b=jTNEpTwgV9E5w1Z960qa4fQ+dhoIfY6dqe3o1K+Dku4b8H0v3FPFDFfZityjAz9r98H2Us
	FNchchM4nK7jGiMF+6qUKIogdH+315fBUWAeNjxaVmJCdiX6CJPYMx7eauLjpj6eejUXK2
	uLqlZ8MpwEIv1J+2dtbP3bf0CNoeyyA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iI7lbNbN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yt07Fsrv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gg7Lu8ed;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Efu9UhKl;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0905621A3D;
	Mon, 27 Oct 2025 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wb8dpn6xeYP9qyGroEaOUTchBIuSRC6oNA7X2yg9XKc=;
	b=iI7lbNbNvFgkDQl6zkHk2olPEYJFjL96NHYQfb8Uo9g6gZq2KyCwTmSuWoSSw7ZVIDZB9z
	DTCRQjW05FTdOs7O4VqSdfZZ8FWiWMvkXyJF58hG9ANGfihtFhv8usuTuCW9nBjg/V/sZ4
	WNFayJJe7OaWKR9qYjp5JWo93rxGajA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wb8dpn6xeYP9qyGroEaOUTchBIuSRC6oNA7X2yg9XKc=;
	b=yt07Fsrv+VIqtXVlfPpuWfcty2qG+aJxbP0ynDrKBrmikSDu5TQahYOihc5ewmae+p+rra
	BN7B5vSbd7/RjDDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wb8dpn6xeYP9qyGroEaOUTchBIuSRC6oNA7X2yg9XKc=;
	b=Gg7Lu8ed0wrBNGFdwRrwCUz4j9AG/9CJw6XV5rsI0DDZm5YmM6URUQ8eV61yOi4awO0miW
	UUmEdl1xWVPbST0Ef3DtiokfY4QzqBZEvNSz2h/xQ4ofkk8GYhDr1Hoz5r7eau6pZkn7dj
	zqKv6YhAJ28RsbDN8MrMZ6OSKQN5xUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588945;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wb8dpn6xeYP9qyGroEaOUTchBIuSRC6oNA7X2yg9XKc=;
	b=Efu9UhKl3KD9GOFWSuoqgEIEc/gzCKWNi84PypwccrVRQphUtIvo0zR+tbmqfAf20oXE4l
	br19pK18O9hSQlDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF9A913693;
	Mon, 27 Oct 2025 18:15:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w2k6NtC2/2jnegAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 18:15:44 +0000
Message-ID: <dcf809c4-2d62-4a77-a25a-1122b1ea999f@suse.cz>
Date: Mon, 27 Oct 2025 19:15:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/17] usercopy: Remove folio references from
 check_heap_object()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-15-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-15-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: budb5j5h4gecj6swqrxfg73tua8yi4oy
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E63E1C0014
X-HE-Tag: 1761588947-499349
X-HE-Meta: U2FsdGVkX1+f4GhhL1DEEQWqVe3gQ4FmOUplxAsVCGQoDxqBMuVWKF9mWB/XQ7V2yW3u/APntzVPBWOkkLpcdIbQFuE1bgN7Gi99TcsMFWAqwKeeMV7ofGAz2GRv4N9pmLtXnTIecF3d/XSw/b0tP3gAdVIg6SsMY6wECcGluu9520/y36gUtoJmB2orGdjLyoPMiKnvKkK9S3GZkAg37ma2tkzw+1EuAOmdHSj7yOR2SrW+L5BMIiESrtpr0ld8pMis7V8o9Ju9t8OL2z5q1mlobVO+Ezcmj/Nu/AUKiz6e/PSp0kqDeWii8anNPi8ysFttL04WbLALBAcwkvEirwMrS8c65MTa/Q4f72/EI9PjOvEzAwc0HI7lpIdZ/y31VECjo/cEufBcQsBNMRVdylV7vDPQGmiPI0PFz3bZkxYTXTfavh67Y70Wn1vd+5Px/cV0cRdrJSlkPZWQ+Q0Q3mZUCgwtnUTjA330nf5EPcWkUlS/wLb/rRLLhMrgtPTZ7n2IMhREO74luM1JwOIkXNREhn2leN8C88K9oSY44aMcErlPr+aGV0PWNOouCEiHaxYDEJ6hoMxkYFy88T56cN0prgUGZA/5GZsq8E53Qw6bybrJ29wA13W0CaJ8oZNp53hf4jq0KmDclQ74voTw7nFL7gASgyUCLDn8vgqQjf9fX/74KPrEU6qg9HBXy4xYeRkEUwu/tVdfKxcfprVuXRJV48MOLP4/EABvo4cjuxwCMwLBjoTmajvukG26WlGOS02wZK1NK/2mG0fL0QKp9kSqhEIfaTQX7AAAPZIvXqft0bE7Piuo6vrmCC3qIRjRAzFLlXUFeomqUUOe0S7AMqKWCHzbPpLK6aSFD8yUYVm46lP0j9OeBGNvP4lzPttwgxwsvx85WUpaeftzv3M1b60IeGv4TbMAeZw4eeonJTIW5Avbhy8K0YOWJWUiqnsyW7xiSeDauqvMuQlGzVc
 n/Q3gceY
 yb3xMhProeYZSumD0OCugp6gZVma5CJHE0DMuX3teAJ1SCHu7balXf6e6yZVxbdPzNmZFiituHb+a/9/oU4ZwiaaTHzhfppiHKEoGSnQ5iS6rKLrvGeIHyalTPqqB4EyLx9vf8m5eeB0VowXz1SXjzZIJt3sWzIFA++T6zvTSVpGKo/wzQFAqJ3c7ZfY4EnWu2GKxM7zpvwpFhrFWf7XsRkR84Z4E+TFpglJ/uPTQghxcCuKWlOlbNHcCjto2L2EtfbL6M0gjfWBjFqQHqr7BUBsgC4J7fKJKOmocR8JoK7WNWuwFo8VbALl2qo5/xM42pxcLTkrhwftpZ+SDj7PVVDxnA54mcyjVJQvp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> Because the pointer being checked may not lie within the first PAGE_SIZE
> bytes of the object, we have to mark all pages as being LargeKmalloc.
> We could use virt_to_head_page() instead, but that would pessimize
> slab objects.

But for slab objects we do page_slab() which does compound_head() anyway, so
that pessimization already happens? Or do you mean something else?

Again we could do page_slab() first and handle large kmalloc when the result
is NULL?

> Once we move to memdescs properly, we'll tag each page
> as being LargeKmalloc anyway, so this is more in keeping with how code
> will be written in the future.

Wouldn't this be the first case whre we would set page type on tail pages of
a compound page? If yes I'd rather postpone it until that's introduced
globally as part of the memdesc conversion, if the reason is mainly the one
disputed above.

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/slub.c     |  8 ++++++--
>  mm/usercopy.c | 21 ++++++++++++---------
>  2 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 39a26a970018..54e425efaa6f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5581,10 +5581,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
>  		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
>  
>  	if (page) {
> +		unsigned long i;
>  		ptr = page_address(page);
>  		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
>  				      PAGE_SIZE << order);
> -		__SetPageLargeKmalloc(page);
> +		for (i = 0; i < 1UL << order; i++)
> +			__SetPageLargeKmalloc(page + i);
>  	}
>  
>  	ptr = kasan_kmalloc_large(ptr, size, flags);
> @@ -6737,6 +6739,7 @@ EXPORT_SYMBOL(kmem_cache_free);
>  static void free_large_kmalloc(struct page *page, void *object)
>  {
>  	unsigned int order = compound_order(page);
> +	unsigned long i;
>  
>  	if (WARN_ON_ONCE(order == 0))
>  		pr_warn_once("object pointer: 0x%p\n", object);
> @@ -6747,7 +6750,8 @@ static void free_large_kmalloc(struct page *page, void *object)
>  
>  	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
>  			      -(PAGE_SIZE << order));
> -	__ClearPageLargeKmalloc(page);
> +	for (i = 0; i < 1UL << order; i++)
> +		__ClearPageLargeKmalloc(page + i);
>  	free_frozen_pages(page, order);
>  }
>  
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index dbdcc43964fb..8d21635147a4 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -164,7 +164,7 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  {
>  	unsigned long addr = (unsigned long)ptr;
>  	unsigned long offset;
> -	struct folio *folio;
> +	struct page *page;
>  
>  	if (is_kmap_addr(ptr)) {
>  		offset = offset_in_page(ptr);
> @@ -189,15 +189,18 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  	if (!virt_addr_valid(ptr))
>  		return;
>  
> -	folio = virt_to_folio(ptr);
> -
> -	if (folio_test_slab(folio)) {
> +	page = virt_to_page(ptr);
> +	if (PageLargeKmalloc(page)) {
> +		page = compound_head(page);
> +		offset = ptr - page_address(page);
> +		if (n > page_size(page) - offset)
> +			usercopy_abort("kmalloc", NULL, to_user, offset, n);
> +		return;
> +	} else {
> +		struct slab *slab = page_slab(page);
>  		/* Check slab allocator for flags and size. */
> -		__check_heap_object(ptr, n, folio_slab(folio), to_user);
> -	} else if (folio_test_large(folio)) {
> -		offset = ptr - folio_address(folio);
> -		if (n > folio_size(folio) - offset)
> -			usercopy_abort("page alloc", NULL, to_user, offset, n);
> +		if (slab)
> +			__check_heap_object(ptr, n, slab, to_user);
>  	}
>  }
>  


