Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01926D26D7A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3A96B0005; Fri,  9 Jan 2026 12:12:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1946B0089; Fri,  9 Jan 2026 12:12:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4593C6B008A; Fri,  9 Jan 2026 12:12:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 310BE6B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:12:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C45D8140470
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:12:19 +0000 (UTC)
X-FDA: 84313068798.03.0A59D83
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53FAA10000C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:12:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dD0Qlq5v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cJKN681x;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dD0Qlq5v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cJKN681x;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767978737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqC+IvhivAp+vymnjjyxSHw6MxxDRHN2PRL011syc3I=;
	b=sVlVoyFd/phcRYXpGy5c+KtHHhN4rb/T4HoMRtsxmtCPjZgDDbz9/CYwIe1fNyMR8BL/FJ
	OUWeuoNjb5ZdeO5gdjyC09nNnoZId4ls5vhYPFdu1W/u9ClsMBhc5DcSGLz+a2a+h4pDD5
	fDMUZj23SFEgNGiYGb/XMPSf9m6lo5I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dD0Qlq5v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cJKN681x;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dD0Qlq5v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cJKN681x;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767978737; a=rsa-sha256;
	cv=none;
	b=aknHw5sqq94Gj6f/Oifs5wVXXoKoxhyhwR83j5MfbOcEpQx/qW0ZY9J2A+47FPog2B9keQ
	ccUBQ0oITougHCOd/+VOrvFkSQ/CspbxYHiN4g+B3tJrYvEaq4ckUgoz3ObI+2aupuEdDo
	x4ZNMveAzticbZzwdvUxDJPBWa3Ytlo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6AE145BFFC;
	Fri,  9 Jan 2026 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767978735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hqC+IvhivAp+vymnjjyxSHw6MxxDRHN2PRL011syc3I=;
	b=dD0Qlq5v9SNvqqSvgEfI4qbjuYCdo4CM3z6ABwVYFqpp8Hn4YNteJzFdpBIRyzOJYFpo0F
	NSgIJR6ea+Srro/TcskbfDShLRvwDRO1RmyvSAdrH2+mfDYatPgxXGPq+GDRArqzJSuWLV
	YZkE3k3DSsOI6BwlqsLK/xilP6QtbXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767978735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hqC+IvhivAp+vymnjjyxSHw6MxxDRHN2PRL011syc3I=;
	b=cJKN681xCoDAR1CGporHgMHuGduZH2q4h/VhpEdBXyNlQ0OwxXLh9FPVvO2d4r7KQq+d+6
	GZ45cwAdogz5ErAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767978735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hqC+IvhivAp+vymnjjyxSHw6MxxDRHN2PRL011syc3I=;
	b=dD0Qlq5v9SNvqqSvgEfI4qbjuYCdo4CM3z6ABwVYFqpp8Hn4YNteJzFdpBIRyzOJYFpo0F
	NSgIJR6ea+Srro/TcskbfDShLRvwDRO1RmyvSAdrH2+mfDYatPgxXGPq+GDRArqzJSuWLV
	YZkE3k3DSsOI6BwlqsLK/xilP6QtbXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767978735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hqC+IvhivAp+vymnjjyxSHw6MxxDRHN2PRL011syc3I=;
	b=cJKN681xCoDAR1CGporHgMHuGduZH2q4h/VhpEdBXyNlQ0OwxXLh9FPVvO2d4r7KQq+d+6
	GZ45cwAdogz5ErAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2798F3EA63;
	Fri,  9 Jan 2026 17:12:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 83bICO82YWlxTgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 09 Jan 2026 17:12:15 +0000
Message-ID: <379d2aaa-7b5f-4deb-9c1a-f2721851a0ae@suse.cz>
Date: Fri, 9 Jan 2026 18:12:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Content-Language: en-US
To: Kees Cook <kees@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Matthew Wilcox <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>,
 Joe Perches <joe@perches.com>, Christoph Lameter <cl@linux.com>,
 Marco Elver <elver@google.com>, Vegard Nossum <vegard.nossum@oracle.com>,
 Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Jann Horn <jannh@google.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>,
 Tony Ambardar <tony.ambardar@gmail.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-4-kees@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251203233036.3212363-4-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zdnj7rtho3kq3kcn6dn5xyupyfx1w61e
X-Rspamd-Queue-Id: 53FAA10000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767978737-752964
X-HE-Meta: U2FsdGVkX1+CjddN6Lmx2G1q+gBhKOuEPYSHHDDFE5AT2uNEdeP8Xvn9klceW+8i1TEImotNsi8kYL1kcLayHINMMgKsJRtj0KKZNMEXomTPDiM5kA/wP+PmjC3e0MPljMu0Ppf1QzZUhhmKy9mnTYCQxihpdQVsEYsF1d9NLCQ9cWxgGAZW1HGxaRcCA49CsNdxduA/xGDOrFm6iERaEzO4ztDbfNFTRAWZ2cGDjHuiHgYeVfDvfErBC1p+zh5BSHvPvcpCwVbDjCL5mqsyZCChSD+m1XrR1oF3rDMMJOlhDJ9LT55E5QqtZUD8z15mRhKxuQ9mvLxBOc55XTgI1stCIoH3inl+KZ/1i4IOXC+l13Q18YMUdKP/OaAnRSJCfcLKjwrWVwZow1ErYYZJCep0rY/FGHnpKaWyAQiqdhJybH3aKRTcv+xVJEP91TzxYMkx1bHDB+L5PJGNQCHr6ghxT9aeh6WgGspPsGD9JrPVKNt2Bd4bMPn+7YgqpZJONVmC6+dIWqJNzqyQUGDQu/5cXLiA9HzU56ldYb/7+8CbYr+S3vB4wdOCl3RAp4XQlWEqlKv46cTJfRR3mc5/BBtgxhDODVAaHght7W3CrzhiZ5qNvDrgX9RSAWXbGbyv2QUvmve7kOSIA1NbISDkj8iOReybbctzphXYj00j0fknvF9IBJAN+fGZH696YKa3qm+cHN43JyONRE0XDvVujA8SHAyM9SRC4ZgO/ucjfd4ggT9L/wgCPJal1cVi1Oi9g7X/PeLmnRj6ensvguyiUzcxBIaCsUz+W1NkRF3x0ttH+g6lyl2CJ/zrLRJpIhokWlzVKU584ZhK7pETxSxfaYv+8wqpDNvpWneNGp3TqvqUIfQpifNaNrNkKALSuVV1IsG2hR1kkuZmViWrHcFotTed5KoA4fTQZgVvxLEYq3Q6/xQUYxaqk05FnEmked2bEWvsVbEE5Olm+yAyeGH
 UMccLi20
 iRuW08DPqy4zj4tnU4EqgsibNkx+lfroiPggFBesqJq6hGY0WuW1pulSGQAr8bUoKqcxXq0p8RkoVTlq9TBh1cmcdY8NW6JDsqBlZiagaelCSr4uKh2uF/aui2IbhBk/O4bKOxhwRSYKYqH9G93fYHORfP3c6Syq+ZeA2qDkkSJvJhzSLXU4nwhnKIdw65jmuINZxaXdGX1wV1OxdQC3mXZPJqZKLbx30LUEKBtxyO/6+02DAzaXNFeiQnIF539dyVJxJk37bDxfXGJkhYIBufXHJnJVDKRUscKRe+uKv7bVAR9OSMsP5xRybEkRaTAf33uGw8vT49gm0FeNKZLvLmNJvxuheMxk1+rjMM2A6aUCpW9rVrPgDUifnVBODFxFj75Ar9/qodisYuE7NhW2uIYats1tPypidLYRRCR/RYXOohWFMOAcuIi9IGPq/Al6ehL8T4OOYUcFqz2NbWnLD6HN7dgm17v3IHkR9igeh9wP5ZpFSCtfuEF9GzgiRr+z/N4IDdpuXy7SYlbizr8F0b0zhG582MPUkdkZ3wdQIUCCpRV69Q9X/z9mrERQTAyfO9WveUNr74d4j05PxlJZnV8SjlAujWF2GN/5jbwgFCU4o+TOi5XNroCHEg9pAgWAUHyqEl9uOe/zu08WOCxmkCIqJ/odSUx3jfqR5ujTdk+ptWJFFe/aweYrR9APkElPYmBZlVyMPsGrkflIwSqiBZxLiIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 00:30, Kees Cook wrote:
> As done for kmalloc_obj*(), introduce a type-aware allocator for flexible
> arrays, which may also have "counted_by" annotations:
> 
> 	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
> 
> becomes:
> 
> 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> 
> The internal use of __flex_counter() allows for automatically setting
> the counter member of a struct's flexible array member when it has
> been annotated with __counted_by(), avoiding any missed early size
> initializations while __counted_by() annotations are added to the
> kernel. Additionally, this also checks for "too large" allocations based
> on the type size of the counter variable. For example:
> 
> 	if (count > type_max(ptr->flex_counter))
> 		fail...;
> 	size = struct_size(ptr, flex_member, count);
> 	ptr = kmalloc(size, gfp);
> 	ptr->flex_counter = count;
> 
> becomes (n.b. unchanged from earlier example):
> 
> 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> 	ptr->flex_count = count;
> 
> Note that manual initialization of the flexible array counter is still
> required (at some point) after allocation as not all compiler versions
> support the __counted_by annotation yet. But doing it internally makes
> sure they cannot be missed when __counted_by _is_ available, meaning
> that the bounds checker will not trip due to the lack of "early enough"
> initializations that used to work before enabling the stricter bounds
> checking. For example:
> 
> 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> 	fill(ptr->flex, count);
> 	ptr->flex_count = count;
> 
> This works correctly before adding a __counted_by annotation (since
> nothing is checking ptr->flex accesses against ptr->flex_count). After
> adding the annotation, the bounds sanitizer would trip during fill()
> because ptr->flex_count wasn't set yet. But with kmalloc_flex() setting
> ptr->flex_count internally at allocation time, the existing code works
> without needing to move the ptr->flex_count assignment before the call
> to fill(). (This has been a stumbling block for __counted_by adoption.)
> 
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: <workflows@vger.kernel.org>
> Cc: <linux-doc@vger.kernel.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  Documentation/process/deprecated.rst |  7 ++++
>  include/linux/slab.h                 | 48 ++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 91c628fa2d59..fed56864d036 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -387,6 +387,7 @@ allocations. For example, these open coded assignments::
>  	ptr = kzalloc(sizeof(*ptr), gfp);
>  	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
>  	ptr = kcalloc(count, sizeof(*ptr), gfp);
> +	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
>  	ptr = kmalloc(sizeof(struct foo, gfp);
>  
>  become, respectively::
> @@ -395,4 +396,10 @@ become, respectively::
>  	ptr = kzalloc_obj(*ptr, gfp);
>  	ptr = kmalloc_objs(*ptr, count, gfp);
>  	ptr = kzalloc_objs(*ptr, count, gfp);
> +	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
>  	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> +
> +If `ptr->flex_member` is annotated with __counted_by(), the allocation
> +will automatically fail if `count` is larger than the maximum
> +representable value that can be stored in the counter member associated
> +with `flex_member`.
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 726457daedbd..2656ea610b68 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -982,6 +982,33 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
>  	(TYPE *)KMALLOC(__obj_size, GFP);				\
>  })
>  
> +/**
> + * __alloc_flex - Allocate an object that has a trailing flexible array
> + * @KMALLOC: kmalloc wrapper function to use for allocation.
> + * @GFP: GFP flags for the allocation.
> + * @TYPE: type of structure to allocate space for.
> + * @FAM: The name of the flexible array member of @TYPE structure.
> + * @COUNT: how many @FAM elements to allocate space for.
> + *
> + * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
> + * @FAM elements, or NULL on failure or if @COUNT cannot be represented
> + * by the member of @TYPE that counts the @FAM elements (annotated via
> + * __counted_by()).
> + */
> +#define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
> +({									\
> +	const size_t __count = (COUNT);					\
> +	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
> +	TYPE *__obj_ptr;						\
> +	if (WARN_ON_ONCE(overflows_flex_counter_type(TYPE, FAM,	__count))) \
> +		__obj_ptr = NULL;					\
> +	else								\
> +		__obj_ptr = KMALLOC(__obj_size, GFP);			\
> +	if (__obj_ptr)							\
> +		__set_flex_counter(__obj_ptr->FAM, __count);		\
> +	__obj_ptr;							\
> +})
> +
>  /**
>   * kmalloc_obj - Allocate a single instance of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate.
> @@ -1005,23 +1032,44 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
>  #define kmalloc_objs(VAR_OR_TYPE, COUNT, GFP)		\
>  	__alloc_objs(kmalloc, GFP, typeof(VAR_OR_TYPE), COUNT)
>  
> +/**
> + * kmalloc_flex - Allocate a single instance of the given flexible structure
> + * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
> + * @FAM: The name of the flexible array member of the structure.
> + * @COUNT: How many flexible array member elements are desired.
> + * @GFP: GFP flags for the allocation.
> + *
> + * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
> + * failure. If @FAM has been annotated with __counted_by(), the allocation
> + * will immediately fail if @COUNT is larger than what the type of the
> + * struct's counter variable can represent.
> + */
> +#define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, GFP)	\
> +	__alloc_flex(kmalloc, GFP, typeof(VAR_OR_TYPE),	FAM, COUNT)
> +
>  /* All kzalloc aliases for kmalloc_(obj|objs|flex). */
>  #define kzalloc_obj(P, GFP)				\
>  	__alloc_objs(kzalloc, GFP, typeof(P), 1)
>  #define kzalloc_objs(P, COUNT, GFP)			\
>  	__alloc_objs(kzalloc, GFP, typeof(P), COUNT)
> +#define kzalloc_flex(P, FAM, COUNT, GFP)		\
> +	__alloc_flex(kzalloc, GFP, typeof(P), FAM, COUNT)
>  
>  /* All kvmalloc aliases for kmalloc_(obj|objs|flex). */
>  #define kvmalloc_obj(P, GFP)				\
>  	__alloc_objs(kvmalloc, GFP, typeof(P), 1)
>  #define kvmalloc_objs(P, COUNT, GFP)			\
>  	__alloc_objs(kvmalloc, GFP, typeof(P), COUNT)
> +#define kvmalloc_flex(P, FAM, COUNT, GFP)		\
> +	__alloc_flex(kvmalloc, GFP, typeof(P), FAM, COUNT)
>  
>  /* All kvzalloc aliases for kmalloc_(obj|objs|flex). */
>  #define kvzalloc_obj(P, GFP)				\
>  	__alloc_objs(kvzalloc, GFP, typeof(P), 1)
>  #define kvzalloc_objs(P, COUNT, GFP)			\
>  	__alloc_objs(kvzalloc, GFP, typeof(P), COUNT)
> +#define kvzalloc_flex(P, FAM, COUNT, GFP)		\
> +	__alloc_flex(kvzalloc, GFP, typeof(P), FAM, COUNT)
>  
>  #define kmem_buckets_alloc(_b, _size, _flags)	\
>  	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))


