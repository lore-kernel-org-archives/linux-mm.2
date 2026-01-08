Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E02D185FD
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 14:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D3C6B0096; Thu,  8 Jan 2026 09:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8153F6B0098; Thu,  8 Jan 2026 09:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECBF6B0099; Thu,  8 Jan 2026 09:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC926B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:01:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D763138B2E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:01:06 +0000 (UTC)
X-FDA: 84308958132.23.C1F4FF6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55A73A0023
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:01:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=f61WHfum;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fwF0WUmQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=f61WHfum;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fwF0WUmQ;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767880863; a=rsa-sha256;
	cv=none;
	b=KJAKnM5tjfnueUsKGrhYPDUgQLPIMFdc98XKYHEgezXyYocq/jVJyjjxWcA/+vbkkwsLS3
	+YjCyM6audlEn2XFux9ZdIy6U3TYKmgK0a6+pB1+WcBC7LLVY3IDDVsTPkK4HnuABKSB1F
	IY5rp7LtUWfG3pG7vLgs9z/IVm1iIO4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=f61WHfum;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fwF0WUmQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=f61WHfum;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fwF0WUmQ;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767880863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBk9ih3r9seCOiNygirQu746xQraSi7ZSoKlBv+Xuu0=;
	b=jOabw7B+lAgq93TDslhX8SqwiSfW5r386Lk87JXyfTeSvMlYkJDahAxs4bbd8D67VsIblY
	+brwq6tePWxLXWfKPFOOROhqnhUvcN4tZXpTriiXQVJosL8gC3gL4dOLPg01mYUrA2OEMP
	6I836Y4CV+7IUCg4Hpb5Jw4GWCyvUP4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 889F7341AE;
	Thu,  8 Jan 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767880861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vBk9ih3r9seCOiNygirQu746xQraSi7ZSoKlBv+Xuu0=;
	b=f61WHfumwhNs6hry5yoHQBa2/gl8BUg5Bt1YFhacbETnavMVLd+R3Kn6+QrHY13rsCXUMO
	Sg1waxGFZXPvP/1L2DCVv8K5iVnsCS9QGvf2hcB3RZyKqj7FDPBGoPlst5v1vkbfvumaA3
	Ocqk6cjGeQ3K8ecI7LyZmdwatTCkSQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767880861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vBk9ih3r9seCOiNygirQu746xQraSi7ZSoKlBv+Xuu0=;
	b=fwF0WUmQ1CkW4SoSy0UhBoGU7EXmMsXS1hIY993NUBqrWcvrHXaiwe3LzxR8wjVPbL13d2
	4UeL6G7kpfLAYdAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767880861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vBk9ih3r9seCOiNygirQu746xQraSi7ZSoKlBv+Xuu0=;
	b=f61WHfumwhNs6hry5yoHQBa2/gl8BUg5Bt1YFhacbETnavMVLd+R3Kn6+QrHY13rsCXUMO
	Sg1waxGFZXPvP/1L2DCVv8K5iVnsCS9QGvf2hcB3RZyKqj7FDPBGoPlst5v1vkbfvumaA3
	Ocqk6cjGeQ3K8ecI7LyZmdwatTCkSQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767880861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vBk9ih3r9seCOiNygirQu746xQraSi7ZSoKlBv+Xuu0=;
	b=fwF0WUmQ1CkW4SoSy0UhBoGU7EXmMsXS1hIY993NUBqrWcvrHXaiwe3LzxR8wjVPbL13d2
	4UeL6G7kpfLAYdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A9703EA63;
	Thu,  8 Jan 2026 14:01:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q+PKEZ24X2lMKQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 08 Jan 2026 14:01:01 +0000
Message-ID: <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
Date: Thu, 8 Jan 2026 15:01:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Content-Language: en-US
To: Kees Cook <kees@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Jann Horn <jannh@google.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>,
 Joe Perches <joe@perches.com>, Vegard Nossum <vegard.nossum@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
 Yafang Shao <laoar.shao@gmail.com>, Tony Ambardar <tony.ambardar@gmail.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, llvm@lists.linux.dev
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251203233036.3212363-1-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55A73A0023
X-Stat-Signature: bcpriqq4y5ubyirxyuihh48chybjooey
X-Rspam-User: 
X-HE-Tag: 1767880863-894162
X-HE-Meta: U2FsdGVkX1+FQ9u9oNrLxZy/UrNVaChjyTGJHpIyErQ17qpTmANFOEDV/TcMRi7B1XgMrf/qSTYdD9Gf12HcepVsxQ84c0zJwccIJeSEXO/noUxmjBEzk3IkoDiq/wXJAJzj5gpEwRrSAgYfUvSpstsmg+4AwY90M9EXlPn9jZ/FF6Oi2joy5DJiz4mIMTR7TycwGYoJDUue/Ol4erQwEgdfMBssLryxWptoJJwMyCWap8w+f4B0hLCcT5dFlXqwyYAAHpBOVL7GmJYGPCT16OBIzy2n5tif5UWkUK6mvzv88nC4HwEkk4vz8ZHBSBaU0zs5bswvJOtGcv6U9cKTtilrbrBQaueWh6SyXWjMYdblSioVf3xKJ4uvMM1wN84ySEv3IkMoVOYq1G6GW+SgmOzZr1BHR2HgdVtcYJWnXgCxgszmulE5aRGaqN8ix62vJyE0Ixbpcw9KmVTRUF3CKJ0POlihuhV1ea2X6q2aqSdROoH6mX8NG2qy3aQxNHth0m6vI01Yu6hxDhZpqFKtK47jwcEPxm7/4Ip4zDT2ZPKnr8xk0JsTgAItWuOxhu5VonT41uNSYPyHGagRkFmXhkfa+sCj63MnHxwd9vqfB1MwdHe3E4LLIBPJUfulNfSy3KeEKBGdM7DcbR88z9oVZgCbtQ4ZiVdEr8xzShUCXpf5cEBFfbGHkU2uNExlxxdcm4kRVIXtJ333woqDT9i0kIz863FlkUH9sDjRTkdwmzeX5677IgJkf3GJOpgIbqDjE2fQ36CZbfOsblF7JsittsaF8m0YXIInsUkS14X9P79Czbomib7QJ2xRxkcIyBu0z187VvCTDVV4EaPZtOoECm3x4IDKpiCpGCHm9l1nfg/uUUPIdHEhzSf28x0pp+3fQBNRA+N5408EM00sW38VGG673QZDGXYXBohs1RBR+CPxin3A94q8QuRTJ6zpegblF4KnbstgNvhUyFma7xn
 e1ZtnfKh
 E9NBctwPKFB0czLW5I1Ffu4Ddtvh2D3MUK3f4p0mmZevYmVpxy1b08Z73Z52inBHybPgjai7uTbvJueWPjXNX4v8/2XkzA4coAiYLLuRCyXOxF85Jo1nieTBja3UZ+rxrolLieciEp8pGK+T9yl+uKAVuRc1FcNj4uGTuH4psm7Wi9dJoHlimkkpVh+NqUPEiijiUiLf7724Px1VPXt4pDSJ8FdfqxfcafA7b4ECFAAFq5lMF95M/4/3vFYLDI4dTo5FWBeEGweP22LA4uQKLlXkm7S1VQFcduHWrTGDkzfuuKytT7CdzwJ+qYNlE2gCgF9K6nJq5QqYaMg8qlTFWNJJMQEIurrc1gxK4PXEoLDDygwBIKQ723iZGfo7VIOjwnNGHm7HFLk6ZNtR96DAJnJGWi5KIrlFR5R/YwxlbvZd6Qs2Fqt32kOizn89h2+Rw+XkFynxZrVaJre8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 00:30, Kees Cook wrote:
> Introduce type-aware kmalloc-family helpers to replace the common
> idioms for single object and arrays of objects allocation:
> 
> 	ptr = kmalloc(sizeof(*ptr), gfp);
> 	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
> 	ptr = kzalloc(sizeof(*ptr), gfp);
> 	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> 	ptr = kcalloc(count, sizeof(*ptr), gfp);
> 
> These become, respectively:
> 
> 	ptr = kmalloc_obj(*ptr, gfp);
> 	ptr = kmalloc_obj(*ptr, gfp);
> 	ptr = kzalloc_obj(*ptr, gfp);
> 	ptr = kmalloc_objs(*ptr, count, gfp);
> 	ptr = kzalloc_objs(*ptr, count, gfp);
> 
> Beyond the other benefits outlined below, the primary ergonomic benefit
> is the elimination of needing "sizeof" nor the type name, and the
> enforcement of assignment types (they do not return "void *", but rather
> a pointer to the type of the first argument). The type name _can_ be
> used, though, in the case where an assignment is indirect (e.g. via
> "return"). This additionally allows[1] variables to be declared via
> __auto_type:
> 
> 	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> 
> Internal introspection of the allocated type now becomes possible,
> allowing for future alignment-aware choices to be made by the allocator
> and future hardening work that can be type sensitive. For example,
> adding __alignof(*ptr) as an argument to the internal allocators so that
> appropriate/efficient alignment choices can be made, or being able to
> correctly choose per-allocation offset randomization within a bucket
> that does not break alignment requirements.
> 
> Link: https://lore.kernel.org/all/CAHk-=wiCOTW5UftUrAnvJkr6769D29tF7Of79gUjdQHS_TkF5A@mail.gmail.com/ [1]
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

How do you plan to handle this series? Given minimal slab changes (just
wrappers) but there being also changes elsewhere, want to use your hardening
tree? I wouldn't mind.

> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -12,6 +12,7 @@
>  #ifndef _LINUX_SLAB_H
>  #define	_LINUX_SLAB_H
>  
> +#include <linux/bug.h>
>  #include <linux/cache.h>
>  #include <linux/gfp.h>
>  #include <linux/overflow.h>
> @@ -965,6 +966,63 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
>  void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
>  #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
>  
> +/**
> + * __alloc_objs - Allocate objects of a given type using
> + * @KMALLOC: which size-based kmalloc wrapper to allocate with.
> + * @GFP: GFP flags for the allocation.
> + * @TYPE: type to allocate space for.
> + * @COUNT: how many @TYPE objects to allocate.
> + *
> + * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many
> + * allocated @TYPE objects, or NULL on failure.
> + */
> +#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
> +({									\
> +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\

I assume with the hardcoded 1 for COUNT, this size_mul() will be eliminated
by the compiler and not add unnecessary runtime overhead? Otherwise we
should have two core #define variants.

I also noted that the existing kmalloc_array() and kvmalloc_array() do
check_mul_overflow() and return NULL silently on overflow. This AFAIU will
make SIZE_MAX passed to the underlying kmalloc/kvmalloc and thus will cause
a warning. That's IMHO a good thing.

> +	(TYPE *)KMALLOC(__obj_size, GFP);				\
> +})
> +
> +/**
> + * kmalloc_obj - Allocate a single instance of the given type
> + * @VAR_OR_TYPE: Variable or type to allocate.
> + * @GFP: GFP flags for the allocation.
> + *
> + * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
> + * on failure.
> + */
> +#define kmalloc_obj(VAR_OR_TYPE, GFP)			\
> +	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), 1)
> +
> +/**
> + * kmalloc_objs - Allocate an array of the given type
> + * @VAR_OR_TYPE: Variable or type to allocate an array of.
> + * @COUNT: How many elements in the array.
> + * @FLAGS: GFP flags for the allocation.
> + *
> + * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
> + * or NULL on failure.
> + */
> +#define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
> +	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
> +
> +/* All kzalloc aliases for kmalloc_(obj|objs|flex). */
> +#define kzalloc_obj(P, GFP)				\
> +	__alloc_objs(kzalloc, GFP, typeof(P), 1)
> +#define kzalloc_objs(P, COUNT, GFP)			\
> +	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
> +
> +/* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
> +#define kvmalloc_obj(P, GFP)				\
> +	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
> +#define kvmalloc_objs(P, COUNT, GFP)			\
> +	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
> +
> +/* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
> +#define kvzalloc_obj(P, GFP)				\
> +	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
> +#define kvzalloc_objs(P, COUNT, GFP)			\
> +	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
> +
>  #define kmem_buckets_alloc(_b, _size, _flags)	\
>  	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
>  


