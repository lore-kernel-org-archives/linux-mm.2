Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44934CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771EE80086; Mon, 27 Oct 2025 14:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721CA8000A; Mon, 27 Oct 2025 14:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9DF80086; Mon, 27 Oct 2025 14:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADB28000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:39:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEF57160148
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:39:53 +0000 (UTC)
X-FDA: 84044758266.11.0ABB9C8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 69C271C0003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:39:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RteJ7yg9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFtSb3UX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RteJ7yg9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFtSb3UX;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761590391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UdNcCz5jl1QRTKAi0eT8hEWfVN0MVORcJZftQx/sno=;
	b=BkOVwf8jzUxWEXlNflvlsBhUUy9p4fx9Bo61OWs+mlte6By+IY1pS9QcdY48VBF/izQZc8
	k0GrS0NwYo/fXsgJOY5KT0cAFKubb76QhfmNF34Zg5ThohJzdrtmaT0F/QXK9WRZGjL4LB
	1DgHcDGmZD5NFZm4DpBN64kgne7dUO4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RteJ7yg9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFtSb3UX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RteJ7yg9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFtSb3UX;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761590391; a=rsa-sha256;
	cv=none;
	b=XRpsXlSjPxPfACzX0tGdcG9qe+pEk0xSolcMk0oW0K6VKFag/5IzwSoqwmTBdD8EDNlIf3
	TrUS8cXbFAMr5OnqcCT3k8clvX7XBtwVZPRT8tQhFLrgigcEWOfGp7rxcV/xavlnx3HpqB
	0tgFDEukZpGOBUkymhrxyd5qQvGagSI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9AA0021A63;
	Mon, 27 Oct 2025 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761590389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5UdNcCz5jl1QRTKAi0eT8hEWfVN0MVORcJZftQx/sno=;
	b=RteJ7yg9x777kw/nguxd08RFPlRW/AuFt3adcuOui5ZYWBDHTT3lM6EPgLLOcRDZBoDs7p
	NxWE4z6zdMdS7zmNDXr+PR+ZSrXPqycls2AFqADOkI92c0gN/JS3ShcDENou+o9MVS4e8A
	tzDutenqlQTCxwPNQ7C7h9pyD8KkYgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761590389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5UdNcCz5jl1QRTKAi0eT8hEWfVN0MVORcJZftQx/sno=;
	b=UFtSb3UXcWJ14WyahfaJRhACj1B9xr5T94Zx4KsQresu6JVHJ4d708FZaVdb08M0X+EFin
	+0C8xq7jRQozfXBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761590389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5UdNcCz5jl1QRTKAi0eT8hEWfVN0MVORcJZftQx/sno=;
	b=RteJ7yg9x777kw/nguxd08RFPlRW/AuFt3adcuOui5ZYWBDHTT3lM6EPgLLOcRDZBoDs7p
	NxWE4z6zdMdS7zmNDXr+PR+ZSrXPqycls2AFqADOkI92c0gN/JS3ShcDENou+o9MVS4e8A
	tzDutenqlQTCxwPNQ7C7h9pyD8KkYgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761590389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5UdNcCz5jl1QRTKAi0eT8hEWfVN0MVORcJZftQx/sno=;
	b=UFtSb3UXcWJ14WyahfaJRhACj1B9xr5T94Zx4KsQresu6JVHJ4d708FZaVdb08M0X+EFin
	+0C8xq7jRQozfXBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E5EB13693;
	Mon, 27 Oct 2025 18:39:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jCZMHnW8/2j4EgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 18:39:49 +0000
Message-ID: <d9468a23-d39f-4005-8ff3-3abb429d7dc5@suse.cz>
Date: Mon, 27 Oct 2025 19:39:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/17] kasan: Remove references to folio in
 __kasan_mempool_poison_object()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 kasan-dev <kasan-dev@googlegroups.com>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-17-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-17-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 69C271C0003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gbc1b1a6ry1cw1knarfp1kr9y56zsx9e
X-HE-Tag: 1761590391-16343
X-HE-Meta: U2FsdGVkX1/7qVRcEOsBexF5AHo1xiSTYzXic7BvJShlOWrsnd6mnbaiyOXv1L+UIOajamYzufi/MprqHCQOfWc8qWfQC6KB5JfNViknchnUevdg/1d9XcboO/zsTOcK3GZmE8B2a4DN996Su7QcAmyP7gAx1TTO6oexS2H33+v0rIJPRIKEgq3Xe3Ki6PC4qW4FD3X8ehLuKL361o+7JAOmIsI4RI6fhgTfu98SEKrorMQtT/pDWZPvuiq+b/Yni12KQjdWGlo7Gq1bClNrem6O7du/lNpWnW89YT2zDedcxgcTHS2khawq75WfjCvVhypAEiQmvxxg6I9J2JXt2OboVJiwQLglDPT6+c9NmWq+tZIfz24KCk2AW7cTgCgcnMjuBGYpGvOicyn9NbSqYL1M1GFHQZo5M4mThr5t16iW/MStBnWNKRPlXCKRYp13N7x5soPy36Cya8f1aA99U3K/V9fMxydl7oWRIYFwqf53dMuQBtFduXrA29ZBt5aVZOzrf7p/G7UWIOD+eTVodv5BSMfDI8R1ATm12AJTI9czvSATyrWMvKmPfrW8yVru/RVgMTBwPM2e0LrMMHf/SAS/KaqAKH4NTH2tVxpXDhH1c6EC7UNU4oCvlW5Y5BGSAPlx8ANhicYqS28NEMlGrPtjSN+BlbTfkehSwflFnC+4LCusP+UhuqVQpkQB0T47PDCreCl37DDk0/uaFTjS3c6R24piPByspnd9bK31AQFk7X6MsT8IwI0OPzvldzmKb8GzFlkDcRuSNGpYP6vEck+msCHGA6hjeJstJ0YFt6/5hyPTSO2tPOv8dmV5Smewzyjan09C3tcMTdF8SIGARRL+SFhQVgzHP+pTRy2uAyh0OUWLFteyf/U+A66zPrxdSogma/EWHMGQbW80tKDbp+6Wcinn3FB+q6OZoWZw1Pem9GJMCK2VN0kmMGBfqtb8j/uY7dzuPGDYmPZzmxF
 KOdYUuXu
 6PMqkOOoZ07CWTgkr/wUm/FGLDCNjj8BfmXAj7gAZDCIw2MPeb99zrdmZAaDsG6Yjn6c6KW4fZRGFzyzOkq9vx0MFLIrDLKkxRJLMZGnbG5R805n7rwPz6z2kdC7Aiu7n0KwtY0J9S1ejVIm0xXqlDiG4sgfpWOAOynrOuU9hUKcQwiny0XgPgrOiLDRdCkSrGhWd4XaULZPjdp0uHVx9MRShsZLbQZSl0KpnXQ72C4Gou4fDaF3NkEf5U3U1X802PNq17BgyoZVyflK9i0OwrZII8baEJRSOmF/C/AYaw8ysl1gBTkHH7DzDzNneaZzfBtbZAVWFIxYz4qhUKK8lbN4mtUSMSlWINfy1yphHruAS2renohwzs9FZgrSVfyw0JScii/ZElMhP2GRVC6bt73lyKR5Xi4dsVzgWIsgR1JAi5deHQs1yMq3ghjbGhFjfifXoiXGlZRCEqy4nGwoyDHafePoTAcebJaLfQZRLiOy03Vo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct slab from struct page and struct
> folio, remove mentions of struct folio from this function.  We can
> discard the comment as using PageLargeKmalloc() rather than
> !folio_test_slab() makes it obvious.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand <david@redhat.com>

+Cc KASAN folks

This too could check page_slab() first, but it's not that important. Note
that it should be fine even with not marking all tail pages as
PageLargeKmalloc(), as ptr should be pointer to the head page here.

> ---
>  mm/kasan/common.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 22e5d67ff064..1d27f1bd260b 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -517,24 +517,20 @@ void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
>  
>  bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>  {
> -	struct folio *folio = virt_to_folio(ptr);
> +	struct page *page = virt_to_page(ptr);
>  	struct slab *slab;
>  
> -	/*
> -	 * This function can be called for large kmalloc allocation that get
> -	 * their memory from page_alloc. Thus, the folio might not be a slab.
> -	 */
> -	if (unlikely(!folio_test_slab(folio))) {
> +	if (unlikely(PageLargeKmalloc(page))) {
>  		if (check_page_allocation(ptr, ip))
>  			return false;
> -		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
> +		kasan_poison(ptr, page_size(page), KASAN_PAGE_FREE, false);
>  		return true;
>  	}
>  
>  	if (is_kfence_address(ptr))
>  		return true;
>  
> -	slab = folio_slab(folio);
> +	slab = page_slab(page);
>  
>  	if (check_slab_allocation(slab->slab_cache, ptr, ip))
>  		return false;


