Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E05FCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 08:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3386B0088; Thu, 11 Jun 2026 04:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A896B008C; Thu, 11 Jun 2026 04:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890B76B0092; Thu, 11 Jun 2026 04:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3226B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:35:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E45D1C21BD
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:35:05 +0000 (UTC)
X-FDA: 84866971770.16.5E2E962
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B2204000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:35:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VI3BnmI5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781166903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIdrkYCaRKHtO0F3ILNakuhWS7z2U2qtXW4LOAf0juo=;
	b=myhG6t9E2AQ6kO3wXSOLrzHmxtKH+q3qJb1mSarcPON7W5BDDfJESoJa1cbdKP+mNhbP7b
	Z8/U51rXbGFa0tzAF8hGjelw0/yDQ8r6kt0AQ7MWAwt8bNLq7m+QAvy4l4i5XLhysfqOEM
	DsC8U3F87I2G0Z6pSZ9jBKEyC3U9ywc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VI3BnmI5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781166903;
	b=srScuZHnf8DcrrfaJPs8B4hqo5+U+ilmX2eSn5IVbkuFMQnmUAL3TgormlQHJmWNjYCkrg
	5TT469xtVnEu2upNX/cV0So6yMeYY3HmdrHmaZ2oa9Acxa973SzEbdmBcxwGx32LdVL/PY
	L//XiQ1tpVKB6f3A0T7FC8km8Vb2J+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DDB1417A5;
	Thu, 11 Jun 2026 08:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196E71F00893;
	Thu, 11 Jun 2026 08:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781166902;
	bh=BIdrkYCaRKHtO0F3ILNakuhWS7z2U2qtXW4LOAf0juo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VI3BnmI5yKVWZcu3g5JVCB4QJzql4j5YoLCWDGgOMGEToCuY/c8Kw3mMMUvPiaCZY
	 C7oxjRkBj4ETyRNEEp2r0VDtRc19tJ/itH4miv3jkmpZLEhsaRxwG4f8geCj23bRyv
	 xXAiCPnlLG6EJDBkzxVLhd8EHG27Zs78BmLVADeKHE3nso+m19DdoElpxvx7XZsbYe
	 JAKmh4Jw9O0uFeEPFVutzliZMrpai0IXVKnjaNrcvJh3v5x+0PBrEukgcSvpvosM5N
	 0fo2NRHDCwjwlUlYBy+F8FNIWaEeItUV3KgaWMHavwOVsthnGIl4RN8KA2ajJ+JxTP
	 6AEi2ra2tAhAA==
Message-ID: <159d1e20-5b21-4329-ac9a-f7a5cb0fd56a@kernel.org>
Date: Thu, 11 Jun 2026 10:34:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
 <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: skmy1c1sueio6xzzb4mu7zwb87x68q7m
X-Rspamd-Queue-Id: 3B2204000D
X-HE-Tag: 1781166903-927620
X-HE-Meta: U2FsdGVkX1/EYVEyyVjzRuiQCOfp/VkfELtlgZzmin1rLKpf9akL2u6iSU4KNJKWl8E09FXT6AZOlP7Ejo988XPZ6sY67SmsYcoQswXqlWz9k8Fq6JWfz4T7prLgNUZmwrSUGHYCGMqnmCS8VBOeW3Df/5f0Z8jbrCob3YkHrmiGQMUn+tf5VxeKyGoo5VGEAU2hjORIs+XkwFEopp5hUbW2BPqhbZ6hl6SfIQti0/prgcG934n04ydOhZi2h+JWDTGTyPODbTD2VxhirlpRyfXr+DATbfi7GNP6prO6kzAzqzCmlVFCIMHn+exDoEb/7TD5F+50GP9Qa+HUCv3zfX8+ObadK3zaNbAuvVHjExYYyum6Omkl57U+pTAxX6V0die8E8gjg9+QWdAWewe1nVcpnth5sGVql2FZhQ5wDSre1HBpT5hLqqSDyQUJ4JBFzDger/eX3AfSNII0knwmNvCExMNAYNvuKGtgZo85ojS+sMm/0yc1JJ+2hf7hSb2IevM9C2o3a4MCpMkckpFCcMnm3RbbKbXEM5ydvGDXcAf8cxpNdzQKRIMJeJ8CQQvMZ1J0/5kbTTPp258m2CqWrDvj95TU5nS2nWny/dYNyej5JOMUJ8GnIWENp4aaYRsFg7MJ4AXBdh+mDRF5I4WGTqraZesshCtEP/eQUNhTRYPA3AkI+WVyqC7UH5W1j2ir4vb7qLtQSywBXyoHfpz15pf/i3mij5aiVTt1jt8dR6Goc98qaEIX35wh9linLzlgDhxqjtAoDg+xBgZ8OO7FVKlsmaVLS46KLqMW2Gs4NL/Mb6FjvX95j/IZi6mqzOe5GxO5d+z7kJUTmkuJaXcNFmjtTlmaOnk3l1xb8mMTu+lZFQcJOdcv+IYevibXFaO/BYS/CTkNXbMVjew/UniviAntiSAaWOqgeC3kZXtc93RZDzbJ/nRjbEFwhnO3EeQi/NI+QpYS//dPA69/RJb
 rjWoufLN
 YJ1g39kyvnFqSMNnElQKACOYeibLQUI178ccrvM7ze4IlzunWZxt1w7TKGI+Q/VN615RaIWW4C0PWo7bfbPuxUUxKBT8+dUTBoGCeD6rhzQgBi/ueQgcSQK4bvC1xUaQF1wHmqMmXEbhdPr+JBoX3ZdgNklCzIXBRSNSu+xoerOzb4NC0FficglUiKVFrhpZ70Xo4UPmqzDkW2QX1Qmk3pRKzkCx1wdBFhcEtFaDMyF+Cu6Vj33fQxK2EVfYDkHJKKwl9xxcEDfSwe3pu+NvZ/Qqe8rkb2K8NSSyQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 05:19, Harry Yoo wrote:
> 
>> This potentially adds overhead of the is_kfence_address() check to
>> allocation hotpath, but that one is designed to be as small as possible,
>> and it's only evaluated if zeroing is about to happen. This means (aside
>> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
>> zeroing itself comes with an overhead likely larger than the added
>> check.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/kfence/core.c |  2 +-
>>  mm/slub.c        | 23 ++++++++---------------
>>  2 files changed, 9 insertions(+), 16 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index e2ee8f1aaccf..8e5264d3ddbf 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4565,9 +4565,10 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>>  
>>  static __fastpath_inline
>>  bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>> -			  gfp_t flags, size_t size, void **p, bool init,
>> +			  gfp_t flags, size_t size, void **p,
>>  			  unsigned int orig_size)
>>  {
>> +	bool init = slab_want_init_on_alloc(flags, s);
>>  	unsigned int zero_size = s->object_size;
>>  	bool kasan_init = init;
>>  	size_t i;
>> @@ -4608,7 +4609,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>  	for (i = 0; i < size; i++) {
>>  		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
>>  		if (p[i] && init && (!kasan_init ||
>> -				     !kasan_has_integrated_init()))
>> +				     !kasan_has_integrated_init())
>> +				 && !is_kfence_address(p[i]))
> 
> I hope we could make it bit more verbose and straightforward,
> something like:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 5d7ea72ebebd..29cf4590f9d9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4573,7 +4573,6 @@ bool slab_post_alloc_hook(struct kmem_cache *s,
> gfp_t flags, size_t size,
>  {
>  	bool init = slab_want_init_on_alloc(flags, s);
>  	unsigned int zero_size = s->object_size;
> -	bool kasan_init = init;
>  	size_t i;
>  	gfp_t init_flags = flags & gfp_allowed_mask;
> 
> @@ -4591,29 +4590,37 @@ bool slab_post_alloc_hook(struct kmem_cache *s,
> gfp_t flags, size_t size,
>  	if (slub_debug_orig_size(s))
>  		zero_size = ac->orig_size;
> 
> -	/*
> -	 * When slab_debug is enabled, avoid memory initialization integrated
> -	 * into KASAN and instead zero out the memory via the memset below with
> -	 * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
> -	 * cause false-positive reports. This does not lead to a performance
> -	 * penalty on production builds, as slab_debug is not intended to be
> -	 * enabled there.
> -	 */
> -	if (__slub_debug_enabled())
> -		kasan_init = false;
> -
> -	/*
> -	 * As memory initialization might be integrated into KASAN,
> -	 * kasan_slab_alloc and initialization memset must be
> -	 * kept together to avoid discrepancies in behavior.
> -	 *
> -	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
> -	 */
>  	for (i = 0; i < size; i++) {
> -		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
> -		if (p[i] && init && (!kasan_init ||
> -				     !kasan_has_integrated_init())
> -				 && !is_kfence_address(p[i]))
> +		bool skip_init = false;
> +
> +		if (is_kfence_address(p[i])) {
> +			/*
> +			 * kfence zeroes the object instead of SLUB to avoid
> +			 * overwriting its own redzone, and zeroing of
> +			 * s->object_size will corrupt it.
> +			 */
> +			skip_init = true;

But now we perform this check even if init is false, making it more hot.

> +		} else if (__slub_debug_enabled()) {
> +			/*
> +			 * KASAN never zeroes memory when slab_debug is enabled
> +			 * to avoid overwriting SLUB redzones. This does not
> +			 * lead to a performance penalty on production builds,
> +			 * as slab_debug is not intended to be enabled there.
> +			 */
> +			skip_init = false;
> +		} else if (kasan_has_integrated_init()) {
> +			/*
> +			 * ARM64 can set memory tags and zero the memory using
> +			 * a single instruction. Since HW_TAGS KASAN uses that
> +			 * while tagging the object, a separate zeroing is
> +			 * unnecessary unless slab_debug is enabled.
> +			 */

(I like the new/updated comments)

> +			skip_init = true;
> +		}>

And these two are now done in every loop iteration even though they don't
depend on the object. Yeah it's a static key and build-time constant but still.

But maybe there's some middle ground?

Above the loop do (with your comments).

bool init;

/* ARM64 can ...
 * ...
 * But KASAN never zeroes ...
 */
if (kasan_has_integrated_init() && !__slub_debug_enabled())
	init = false;
else
	init = slab_want_init_on_alloc(flags, s);

In the loop:

		if (p[i] && init && !is_kfence_address(p[i]))
			memset(p[i], 0, zero_size);

> +		p[i] = kasan_slab_alloc(s, p[i], init_flags, init && skip_init);
> +		/* memset and hooks come after KASAN as p[i] might get tagged */
> +		if (p[i] && init && !skip_init)
>  			memset(p[i], 0, zero_size);
>  		if (alloc_flags_allow_spinning(ac->alloc_flags))
>  			kmemleak_alloc_recursive(p[i], s->object_size, 1,
> 


