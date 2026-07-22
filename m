Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA742C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0136B007B; Wed, 22 Jul 2026 08:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861BF6B0088; Wed, 22 Jul 2026 08:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0366B008A; Wed, 22 Jul 2026 08:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1BD6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:48:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEAAC1A0171
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:48:53 +0000 (UTC)
X-FDA: 85016392146.13.E85E974
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 622681C000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:48:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tntCcpwE;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784724532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfnrtyzHcc7q+v7KzgfWL76gnj0hMYo6SrwEr84OSvg=;
	b=v6LPV2FZIFPE7ByJ+Z28xWn5+CGnedt4vhrxQqs9cvFsM1SqLioxVQxMAZLEp8aGLPzE57
	uHnYkonWsNpShYRhKWDtt+Rq2bqFCTw0l8+A+KYSezSr2Bo8sfyFOOvwC6/eIT9i9Iy8Vv
	/lBM+HZ4OH5mBy9IQhSqea7hHD1+cwQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tntCcpwE;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784724532;
	b=w55st7Hocul0y3FNVTcZ6GX1YQg8FFxeA1kTOyCQ+q4VTtqrT7nqQr+1GAoAJe4mZN9Bbu
	RNbDxma3bBaYUNM77OwFXQMyvqQoF6oTKQIDm64l6JGAxSSHaEHmBhBxHR0+/t/kdGk8vF
	/WtYE4d09q8XC/p6Ka4IIBxVByUMSRE=
Date: Wed, 22 Jul 2026 20:47:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784724528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfnrtyzHcc7q+v7KzgfWL76gnj0hMYo6SrwEr84OSvg=;
	b=tntCcpwEEhLS/XWXoNqPZperSBZt5F5W/sXXnga+w0LpJtzlyYRmmPtkIVN+6q09sqs/0e
	MBKLhGzAWfMEScfkDQqN2tzJwcoIJJMaLV/AiGzzB3xoYaQOKEo/ckDrFPJlKrtEDtIl+7
	+yyHHnZ8vfdChOnyoYqHc0L9ttrvdyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Message-ID: <amC6frE3LoWYjTMh@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 622681C000C
X-Rspam-User: 
X-Stat-Signature: pw171gtyar6s7zarx7yc4zdycgbeigks
X-Rspamd-Server: rspam04
X-HE-Tag: 1784724530-822113
X-HE-Meta: U2FsdGVkX18SpPEssUn7SqjXi+K6yhZkr8W96DzG2NHYL+r787qhiG+heayxicNwCD4vJn4xSnM99v7o9aSwGxAp5NQHuPPPYnuIGqAXm14UyXj+wJbEPp4SpAsF4ZG5CiwnRe51e/S2ka7LibX7Lf4QShMAxrlpLq8NAurACFRA9b+YDR65LxEY0oaosxziDWB5WXj4ryczAF0lXC6AYOVQUlLgqQUUpvWxImITJHqCo5bm7pghu7LtyFHwtB8SRrIDrxzDEq2CFJIKe+vnF15BtydvRm7JySnEvxGrHfEK2+n677lzrBKaCDiT4abS5rKBmm67bKEWEtMCAJuAQKJb2LgHWCIjwuBMMuhUbRoMtUNNcMwkPndf/HrRO7ZgFPUy10SnG56GxCXmo7nOiIDCnFdi+8oemoZXK1ah4kXHyxIaFfbtMFsgJVMHcERul3eH5n2WOjBUn82BJcY7IZvOGPfXSCDp//2WDOUrM0/ct9BXDEBM/hQpLsWGqkyMDiuisLzSLq8b6J5sljtYcwQc604LQvpoVqjUtZktU9r23fYBvowUqREj7I/rj7jvRx1RxM36kxaN/iU4RZahhYMt6a0RMLENgbPMOl9HpdmB8LlW9u3vclNQwX2bOk3gNYpSXkXtlL/Ibc2GzHRpwllWyrNd+aa6aN0BIMmmRL1ex87pd8DW1pXQQNzA6PVebjZtIWDb93Yd0/T9SA0vdZsEbqqNeaJvaSi/2jXGpynSUL1EkUTFOcIGf3ACHqFF0cPm03kqEvyHLaW3YGxPBrkd9okEdywMkmihe46rvE1q8bAL5NlY8BQowPZTU4xJA/k3rR3qmMvADJIDtAu58rFUzDnKrKGeryyqbxK6sMcKIgfDGOyt64jNrBm1vGMecCMEqgGTupFHW41Jsu+FhhhWVz/AnjJcDajs+bymPZvfATEs/ZUPGup6gG8x+wKYtelxGEG+ouK7x3MmIDD
 miIlql7p
 2wGHt04xaQd40Esx2uQFoG+oEWz72L91etzbCUOdQfVXQFPk5LmKI2gYLy+v01OBWNc3zA8tlstPAvGp3qEfTcS6Z6F8u0DE4CUX1A0/pWwiGuU5mrffDPUiRL7grtQ2VwkYUx+tOgcx2Kc/Gp6D0ZEOnopl/mZR4+90X32UH0gTfJ9qI0wWGKngSdIdvcEmH1/i3b2M5NAP2fLjLw4qOJWTfXSEqiQ/Jz3UtwH0+GT07NO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:15PM +0200, Vlastimil Babka (SUSE) wrote:
> struct kfence_metadata only contains struct slabobj_ext with
> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> enabled, it will end up allocating its obj_exts via
> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
> These will probably then never be freed.
> 
> So things sorta work, but not always in the intended and optimal way.
> The upcoming changes to slabobj_ext layout would additionally need a
> proper refactoring to keep working.
> 
> However, there's little benefit in accounting KFENCE objects. KFENCE
> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> (default to 255) outstanding ones at any time. For any callsite
> prominent enough in the memory allocation profiling stats, allocations
> served from KFENCE will be lost in the noise.
> 
> Thus let's not complicate things and simply stop accounting KFENCE
> objects in allocation profiling and skip them in the related slab hooks.
> 
> We also need to skip kfence objects in mark_obj_codetag_empty() in case
> a sheaf is allocated from kfence, per earlier sashiko review.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  Documentation/mm/allocation-profiling.rst |  7 +++++++
>  mm/slub.c                                 | 11 +++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> index 5389d241176a..d02eb54ee8f2 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -112,3 +112,10 @@ break it out by rhashtable type.
>  
>  - Then, use the following form for your allocations:
>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> +
> +Notes
> +=====
> +
> +- When a slab object is allocated from KFENCE, its accounting is skipped.
> +  KFENCE allocations are rare and limited to a small number, so this omission
> +  is negligible.
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..76acb78f2655 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
>  		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
>  						       slab_exts, offs);
>  
> +		if (is_kfence_address(obj)) {
> +			put_slab_obj_exts(slab_exts);
> +			return;
> +		}
> +
>  		if (unlikely(is_codetag_empty(&ext->ref))) {
>  			put_slab_obj_exts(slab_exts);
>  			return;
> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>  		return;
>  
> +	if (is_kfence_address(object))
> +		return;
> +
>  	slab = virt_to_slab(object);
>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>  	/*
> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>  	for (i = 0; i < objects; i++) {
>  		unsigned int off = obj_to_index(s, slab, p[i]);

I noticed obj_to_index also does the `if (is_kfence_address(obj))` check, so
maybe we could use:

if (is_kfence_address(p[i]))
	continue;
off = __obj_to_index(cache, slab_address(slab), obj);

>  
> +		if (is_kfence_address(p[i]))
> +			continue;
> +
>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>  	}
>  	put_slab_obj_exts(obj_exts);
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao

