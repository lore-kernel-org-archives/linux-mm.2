Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D0FEE6B49
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89916B0089; Fri,  6 Feb 2026 13:27:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37D26B0092; Fri,  6 Feb 2026 13:27:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4ED6B0093; Fri,  6 Feb 2026 13:27:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0CE6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:27:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26EFEC14A8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:27:43 +0000 (UTC)
X-FDA: 84414865206.08.B6F3BB2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96C6A14000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:27:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpzMrBZC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Qtgtfa8M;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpzMrBZC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Qtgtfa8M;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770402461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iiO6KStHMjfBoHYoJNoTzz4CTh/mo+WVWBiIoXOdnM=;
	b=xYcmSGuotB4hqgU1VXM5Q6zPlhUe4S2EZttJKaUutINR2b56GTj8VfJf7yXttwaA4jXAfx
	wyAff5kRilVnPlDRpb5/lNKPN42S/GgjZhT3oVaoCnMlViXo0Vp0JokV9IifNQLC0ava4P
	0lAO8uXfR56q8n73Q2J3rzFKy2Z8Ne4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpzMrBZC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Qtgtfa8M;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpzMrBZC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Qtgtfa8M;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770402461; a=rsa-sha256;
	cv=none;
	b=bHbluxD+3o9UJH74D9YWmMgtrnRusJ2O9mXoq6CKocnzerWyVMd9cyDRmY4QZc2tb6SV+q
	9EeFxnn3KHMKCm53WrOaTxNQwPwoIgCFJ3lBul06vaxXdsnles93IWt2+3mCoxPpHzNjuS
	TfSbFT5TIGkmYPlZhaTuKxa//I036r8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 009883E774;
	Fri,  6 Feb 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770402459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2iiO6KStHMjfBoHYoJNoTzz4CTh/mo+WVWBiIoXOdnM=;
	b=XpzMrBZCRpsMqBWqK4hSlfWLf7VDIRjR8kOSpd6vE1Un30zeCBXHNQiwzOZhw5qoSn+H9x
	0/5uStF68XgntksVt6jS2FkStIztURb9iz5fGM2b15W4AioLgbOxnOeDDhqrYFyFcAhFsS
	Dbmm28RbpvXQnSZoTfR+6ooJSrDgxcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770402459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2iiO6KStHMjfBoHYoJNoTzz4CTh/mo+WVWBiIoXOdnM=;
	b=Qtgtfa8MrbH3oBliaJqzXtePX+dSA3w+kmTiVdX8Pj9EW2vFJpdzJYEl6LMn64BOP/1GEW
	9YX/YiWT4zOE2wAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770402459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2iiO6KStHMjfBoHYoJNoTzz4CTh/mo+WVWBiIoXOdnM=;
	b=XpzMrBZCRpsMqBWqK4hSlfWLf7VDIRjR8kOSpd6vE1Un30zeCBXHNQiwzOZhw5qoSn+H9x
	0/5uStF68XgntksVt6jS2FkStIztURb9iz5fGM2b15W4AioLgbOxnOeDDhqrYFyFcAhFsS
	Dbmm28RbpvXQnSZoTfR+6ooJSrDgxcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770402459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2iiO6KStHMjfBoHYoJNoTzz4CTh/mo+WVWBiIoXOdnM=;
	b=Qtgtfa8MrbH3oBliaJqzXtePX+dSA3w+kmTiVdX8Pj9EW2vFJpdzJYEl6LMn64BOP/1GEW
	9YX/YiWT4zOE2wAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE3223EA63;
	Fri,  6 Feb 2026 18:27:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HsVcMJoyhmk4RAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 18:27:38 +0000
Message-ID: <52b408e8-ea29-439d-8e34-91c4cae8009a@suse.cz>
Date: Fri, 6 Feb 2026 19:27:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/slab: use prandom if !allow_spin
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <20260206171348.35886-1-harry.yoo@oracle.com>
 <20260206171348.35886-3-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260206171348.35886-3-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96C6A14000D
X-Stat-Signature: dhuigysjezcrb99auk5ntdumcirh4q89
X-Rspam-User: 
X-HE-Tag: 1770402460-327651
X-HE-Meta: U2FsdGVkX19YULPkQUYLN64/mbL0debQX6lkKPKPwBdL8biqxn3cYBz3WuTvxKYe1J4xlP4vuxRC3MNPDXu54lHVH8hOcGQqApi6O2fn4Dr8S6X3VE/MZETqVX4SO3vd4sjk8D9K2oRlWoFOZ0VjscSgyrJYCO1QNvG1xlNjiF8z9+P9tY+Dj6XVXhBQd2QBLF546x1VZjOrITttrsAvr/zUNKaF8Era/7AoNqZP5b8PiCckQRaood+2jICaarTg9XkxgvzmKiw6tcWq2DitaQq8lbZ+9pbpoOwk9gSDtCGwBcNJMmU57zcbUsDD/Zr/9gDn2jRDN1aDHG2gck5lwlbARDCaJFBH9+Rso+IrQjzhCDbUtV6qZFr/0UYm4Fr8xYDGhV3UDK3EYSmjv1Jjm9vtOma6s/Gci29xQovoOjikLutiQ7D4qCEIUc847jfc1UBLSF6q56YA1mx0Zzz9oHjy7KqJfsw4DnJApN9AikjV/abY0yyzqv0VmNVTH6KzTjaOFWmto0+D11iy9li314m1LY/N6M2liSuEFAiEl8zUqUllavGcBFCrBhEClrWs0U1isZYDnW+7jCGtMalOMJNyaALrLcuRv9lCP8A8lB5ScgheAHoxqxD3VUxzBAwUeMOpbPR+wIuPND5EJfHw1eHzqH65Ku9yvR11XehgeKuIGexlfhW+2EGeZlD5Rovn876BUx9ztAVcHvRqjZ/E3v0O6Y6vfaa6conZ9fKbkPEax4L9pTEFBvnTW/nPDLYF8r4JXf9TVB1ty3Ietne/TgqJj21gAcq/KN4ixhuU/wmwSBGJv18rCJEkFzQJ+k78wYxecALpqaolInOnBzCt5qaX908fC4baBRZ4edwUmWzMTQod9X4zUU4emjdUzVEbMeeBMJks6Sv1Pf4VY4Pbqz+ra0aPvDgCnxdsaoVjNBjozprjGWldHtuaVek9aIMopB+2ZUjLLYAZB18ZoVO
 jJwl5Jfi
 IhVxTmrNBW+S2dRj9GJWcH7KbbWdWXY9VTKfPQXnpOhP46eQ7jPcpLlNLVtIYR/aRxtJvXahnlZ+ppBd9h0UzGD17UlUT6UGaTaYQqgSVZva3mSw0tUFsUPMmkevs/la8GplUKUgtER7R4nXWGwLiNrJa6JIlWwc04htZHBrCWi9r2avYDBOa7vHyTZaDxIdtWhSqnSjThLXOqxUC5v2UXHErwQz3eP2QgZ+h0+gc0lA/t3nIblt/FCfhNU1qfpRRndjRe/Y0ERS3gFu7MJXRjpxDvgGu9ul5xsZklFhqmuWhPQ4sM0vPOGO6oXeubildBOL+PVqZwNqX+n1LMas7X6hXF9m3VMKhdilvHHVsAfQnQd/1Gj4MAAtq7/AFip0Kf+7S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 18:13, Harry Yoo wrote:
> When CONFIG_SLAB_FREELIST_RANDOM is enabled and get_random_u32()
> is called in an NMI context, lockdep complains because it acquires
> a local_lock:
> 
>   ================================
>   WARNING: inconsistent lock state
>   6.19.0-rc5-slab-for-next+ #325 Tainted: G                 N
>   --------------------------------
>   inconsistent {INITIAL USE} -> {IN-NMI} usage.
>   kunit_try_catch/8312 [HC2[2]:SC0[0]:HE0:SE1] takes:
>   ffff88a02ec49cc0 (batched_entropy_u32.lock){-.-.}-{3:3}, at: get_random_u32+0x7f/0x2e0
>   {INITIAL USE} state was registered at:
>     lock_acquire+0xd9/0x2f0
>     get_random_u32+0x93/0x2e0
>     __get_random_u32_below+0x17/0x70
>     cache_random_seq_create+0x121/0x1c0
>     init_cache_random_seq+0x5d/0x110
>     do_kmem_cache_create+0x1e0/0xa30
>     __kmem_cache_create_args+0x4ec/0x830
>     create_kmalloc_caches+0xe6/0x130
>     kmem_cache_init+0x1b1/0x660
>     mm_core_init+0x1d8/0x4b0
>     start_kernel+0x620/0xcd0
>     x86_64_start_reservations+0x18/0x30
>     x86_64_start_kernel+0xf3/0x140
>     common_startup_64+0x13e/0x148
>   irq event stamp: 76
>   hardirqs last  enabled at (75): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
>   hardirqs last disabled at (76): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
>   softirqs last  enabled at (0): [<ffffffff813b2dda>] copy_process+0xc7a/0x2350
>   softirqs last disabled at (0): [<0000000000000000>] 0x0
> 
>   other info that might help us debug this:
>    Possible unsafe locking scenario:
> 
>          CPU0
>          ----
>     lock(batched_entropy_u32.lock);
>     <Interrupt>
>       lock(batched_entropy_u32.lock);
> 
>    *** DEADLOCK ***
> 
> Fix this by using pseudo-random number generator if !allow_spin.
> This means kmalloc_nolock() users won't get truly random numbers,
> but there is not much we can do about it.
> 
> Note that an NMI handler might interrupt prandom_u32_state() and
> change the random state, but that's safe.
> 
> Link: https://lore.kernel.org/all/0c33bdee-6de8-4d9f-92ca-4f72c1b6fb9f@suse.cz
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slub.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d46464654c15..4d76af84f018 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -43,6 +43,7 @@
>  #include <linux/prefetch.h>
>  #include <linux/memcontrol.h>
>  #include <linux/random.h>
> +#include <linux/prandom.h>
>  #include <kunit/test.h>
>  #include <kunit/test-bug.h>
>  #include <linux/sort.h>
> @@ -3308,8 +3309,11 @@ static void *next_freelist_entry(struct kmem_cache *s,
>  	return (char *)start + idx;
>  }
>  
> +static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
> +
>  /* Shuffle the single linked freelist based on a random pre-computed sequence */
> -static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
> +static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> +			     bool allow_spin)
>  {
>  	void *start;
>  	void *cur;
> @@ -3320,7 +3324,19 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
>  		return false;
>  
>  	freelist_count = oo_objects(s->oo);
> -	pos = get_random_u32_below(freelist_count);
> +	if (allow_spin) {
> +		pos = get_random_u32_below(freelist_count);
> +	} else {
> +		struct rnd_state *state;
> +
> +		/*
> +		 * kmalloc_nolock() called in an NMI context might interrupt
> +		 * and change the state in the middle.
> +		 */
> +		state = &get_cpu_var(slab_rnd_state);
> +		pos = prandom_u32_state(state) % freelist_count;
> +		put_cpu_var(slab_rnd_state);

I don't think this prevents the changing in the middle? We just stored the
pointer in a local variable state, but the prandom call will still access
the percpu variable through that?

So we might need to disable irq here, and have another percpu state that's
used when in_nmi()?

> +	}
>  
>  	page_limit = slab->objects * s->size;
>  	start = fixup_red_left(s, slab_address(slab));
> @@ -3347,7 +3363,8 @@ static inline int init_cache_random_seq(struct kmem_cache *s)
>  	return 0;
>  }
>  static inline void init_freelist_randomization(void) { }
> -static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
> +static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> +				    bool allow_spin)
>  {
>  	return false;
>  }
> @@ -3438,7 +3455,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	alloc_slab_obj_exts_early(s, slab);
>  	account_slab(slab, oo_order(oo), s, flags);
>  
> -	shuffle = shuffle_freelist(s, slab);
> +	shuffle = shuffle_freelist(s, slab, allow_spin);
>  
>  	if (!shuffle) {
>  		start = fixup_red_left(s, start);
> @@ -8337,6 +8354,9 @@ void __init kmem_cache_init_late(void)
>  {
>  	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
>  	WARN_ON(!flushwq);
> +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +	prandom_init_once(&slab_rnd_state);
> +#endif
>  }
>  
>  int do_kmem_cache_create(struct kmem_cache *s, const char *name,


