Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C5AAC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196CC6B00BD; Mon, 21 Sep 2026 09:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147E46B00BF; Mon, 21 Sep 2026 09:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05DC46B00CF; Mon, 21 Sep 2026 09:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84E86B00BD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:17:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71B8314017B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:26 +0000 (UTC)
X-FDA: 85237820892.23.6AB65D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF2451A0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YOp7P/Hh";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789996644;
	b=mlvtYUAMKvX/Ls0Q+wI5VBwJr+lhngOFeRMEUspZB3kT25tzcbfLQabqSxVaYY4OK6YXAI
	pA9zVBSw3NucVYy2OMXPa8g2be/KJJGM82obXBIr6mmwobtvM+vIbic5qnD2VFUNFIERmQ
	ffhzBHVuJpShWNlCacos6Y59wHZPNxk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YOp7P/Hh";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789996644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdO/1qNOWoyatEwYn7xF77VAMMYfSFesr52raVoM2g0=;
	b=d6BvVdWb6awegXxuPsMlf/jPgq5msV2D0GJRVk51VOWDQ4xZueDbauVtZidbpaRocgPJHe
	U2axuXxZhWhq2RO1dLbivz6hpbVNORMf4hsTudeH7nIGMZFkqUo+6+94DYy6BRbZyh1u+V
	q/hd2WDpMVs8wDTLBN1G7dvjwX2ev7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53992600D1;
	Mon, 21 Sep 2026 13:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889C81F000FF;
	Mon, 21 Sep 2026 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789996644;
	bh=mdO/1qNOWoyatEwYn7xF77VAMMYfSFesr52raVoM2g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YOp7P/HhFoWCbFNP1Kg1DcohDthKn7Vk8/kd4iFNUPUy2kIIUrBYBD7eYpRgqKvCT
	 T9k3EmIJRky8Jd7bmpBG1s37nMaSnfpPKlG3YBEZsMl2HCHoPxF67Yphnmx5TH8B6G
	 W1rTkNZRz9hm13HD5c7e+gaE9NaU8LAx+3+O7eldHrtHwiHs+XNQtNT+GgEA9HYUrH
	 GSXFSUXZgyWi1re8DchivL48dUbbNI8TZcoZ5AFSzRNxQljbuEQC/Ck1tcdD0ZCfx/
	 Q/DBQnOAfixhhnr69hLosb8a+mw14SYsKX+fDgNxfdv3pDPH2iYH/FJpSsQp0UHQCW
	 Jp6twnn4+BWFA==
Date: Mon, 21 Sep 2026 14:17:21 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/7] mm/slab: Give bucket caches the alignment of the
 caches they mirror
Message-ID: <arEdcaJz4i5HP26a@thinkstation>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-2-kees@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF2451A0009
X-Stat-Signature: p8hjtx1qib4zwdohi39actjekxiy6pb5
X-Rspam-User: 
X-HE-Tag: 1789996644-9766
X-HE-Meta: U2FsdGVkX18wxWjgIx0Pnov+6im+jhqH97Ke8CBlow/stNebz5yrnLgTq0NL5zio/6d8fvaFnKPBE9KoKqPSAfR3RlreuwN80pOeAGWcjLurDNyAomSDqETKm8qGd8nNEdqjbHmHxLJgeBgbxJicNhDIQRx8h3ePe9GDuDnIKCjBz7hHI1B2b7N9VjMmTsowHD1+ZO20G0Y9pGevvwDrAf0xGYjkjK1qoEuIcWecHDwYITG4pcDhwZZgjUGgXdsx+y+ap/Dz450J3FnSte1LFwYNo1ql+auxzvuSCwGRR3XiDbWScKeJv8Uwf8T32B83/TFiPZwAYuMzDHB5O9pOBJJ/2KWXX9fp+0QVOo7VF5E48LnKGwTeoqJYl88pxf+yLlQVhpxyE4kOKoiRpdzywUm/0zVhVHOutYhxugR6iTWUqpTY87eT2hSfViSuPJ8ETb7QG+U0T3Q8+RnwL4GtwOA6/DD3Z4MoiXUNx6VjSkv8Ehk4r0UNBA6z7HaHfMrXfOuMjjxIco1SILv0ScLmqPGVgSV8tAfGTFERhIhNT6Feopg6rHjv2mmoE9lRI2ciERRLMt1CAyMsCaZo5XCuK8mxfcGlsHiNinNAPqo/hdi576Z1qgd3u3rIK5HbdBYafEVFMoS7iNfnibsSh7b6RoZJlGAHVwXVXUWs90WiQcewqtn9T2A3Ch3zMLhS5dtUnY7RGxPD69AlP4JY+I1gDlXMJNW/p1wbouXqXcgDjPFkOnJHI3tgMACwrLnOXzQ13GRL5gpf/0/31rnlnQ6aN4jZlcp5Yul0K1IDmA35RwInmmThWhI+lxDt2N0gx8NCFx1UJkqUbsZ8/4l/ygUBvfYJ0vVHosw5HaXG3WBXo1yjpYODBBtkxuQygxqKmRH4J4uG8igTRI4xFxQkFRtlqrSQwqT95QnOCkdYqwpTPpnFt8bSH2DPRXxo19/KB48vkWbcSA8AuyABZLHeOeC
 gCQv+LT1
 4vPAvWRREogwhNDsC8z7ZBUhWVrsPtyJ255Vc3bj2MIMa6TVw01jcWrrvTbT9RDJEY5J1K/dSAnWYK2TJp9fkXY6Sg2dAbogsNeJbKsJH+hWUzhgMuhFt66MA2nsGGzJCZH38BRuqvC/diQ/UOaZeTFMM2SWt0HPQtD9vDPBpsWvY3wQ8nN1VcLsjhNYkRlwOwTLm8o8refdXgQ9Ku1H2pBv3Xg5GYSXrq2jJY036iGJHXeDIFdfsezD6JxMl3gZO8STxnR2+jDK2ehOhuUceuFW70+HrgxFlbOF4E03Cpa3IfWWB9TGE2K/V9q0cpvOk9Byq9axqQim9eWD5cyPlZ5l9DekJdH9e7uSZQ6JJJ9Jv8ASaUAxfP6iCx0vbDpl/pQKft2MXteerpFuDvhR7JLqtpk/LZmSYkVAVLe5HQzWrV9FZmFyBliB4qjVr14jk6RMtXtUnc7Lx53IRaYJQdRW1ou3PQj2RNXdB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:58:13AM -0700, Kees Cook wrote:
> A bucket set is created with kmem_cache_create_usercopy(..., align = 0),
> so calculate_alignment() falls back to arch_slab_minalign(), typically 8
> bytes. The general kmalloc caches it stands in for are created through
> create_boot_cache(), which starts from ARCH_KMALLOC_MINALIGN and raises
> it to the largest power-of-two divisor of the size:
> 
> 	if (flags & SLAB_KMALLOC)
> 		align = max(align, 1U << (ffs(size) - 1));
> 
> This is only a problem when slab metadata is enabled with
> CONFIG_KASAN=y, CONFIG_SLUB_DEBUG_ON=y, or "slab_debug=...", because
> metadata changes the stride size off a power of two, for example:
>
> 	size 128:  bucket align=8 size=224  | kmalloc align=128  size=384
> 	size 512:  bucket align=8 size=608  | kmalloc align=512  size=1536
> 	size 2048: bucket align=8 size=2144 | kmalloc align=2048 size=6144

Hmm... I think what adds confusion here is that in new_kmalloc_cache()
we adjust the size based on alignment, but in create_boot_cache() we
don't do that. Perhaps let's make it consistent and move it to
new_kmalloc_cache()?

> So bucket allocations will fail the IS_ALIGNED(p, ARCH_DMA_MINALIGN)
> check, potentially creating problems for non-coherent DMA situation.

I was wondering "Why should they respect kmalloc alignment..." but yeah,
It makes sense if the users were using kmalloc and depended on its
alignment.

Well, but that's already done in new_kmalloc_cache() and
kmem_buckets_create() should already honor ARCH_KMALLOC_MINALIGN? 

The largest-power-of-two-divisor-alignment guarantee was introduced by
commit ad59baa31695 ("slab, rust: extend kmalloc() alignment guarantees
to remove Rust padding")

...which makes me wonder what you're trying to fix here?

> Take the alignment from the cache being mirrored, which is where the
> size and the name suffix already come from. Nothing changes where the
> alignment was already implied by the size.
>
> Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: <linux-mm@kvack.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  mm/slab_common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 270408ce5a9d..cc58f192f349 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -487,7 +487,8 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
>  			if (WARN_ON(!cache_name))
>  				goto fail;
>  			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
> -					0, flags, cache_useroffset,
> +					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
> +					flags, cache_useroffset,
>  					cache_usersize, ctor);
>  			kfree(cache_name);
>  			if (WARN_ON(!(*b)[aligned_idx]))
> -- 
> 2.34.1

-- 
Cheers,
Harry / Hyeonggon

