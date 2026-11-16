Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB10606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ty4JmrlU
Received: by kanga.kvack.org (Postfix)
	id 10DAF6B05B2; Mon, 16 Nov 2026 05:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0923B6B05BC; Mon, 16 Nov 2026 05:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E740B6B05BD; Mon, 16 Nov 2026 05:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B902B6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:47:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5646A8091D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:47:16 +0000 (UTC)
X-FDA: 85440655272.05.157276E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 82135120005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:47:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ty4JmrlU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ly7V3SrHtZViQ6MtbvivLUpsgPdJPaNMjgihUn8ZpHs=;
	b=EyXJ7xpGWO3Um+hMXLG3zo80eA1d/EjzYm2mvQxXpJodX6tndXL7oiReIGso5DYHeb5WQ0
	+P7dnjxPbqJVgKQNkhT+tz/JEgfcMv3lvwcqRGXviz6rQYmev8LEopGLUH4JJT+BWjl/nT
	1bh8Hj3TeC31lZaDyXVaa/wRAhqYMPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826034;
	b=Zy0Ty2Qs6XJ8lhdg3cc/zuGoadYnD7lqcwxpBNgzlcr/Ej8RPpzqK1Ej7tnqNE6C6vpKsD
	ZNmf0HDDlyMHzSRzlYeYsur9jV6MQ1fOTeicdgoVGwxSslzWK+cK2CpeMdyHbvx8i6LFRs
	qIdZehaPI8oELwNBDwKnnWfG6wC2EPw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ty4JmrlU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97EC24043D;
	Mon, 16 Nov 2026 10:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB091F000C4;
	Mon, 16 Nov 2026 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826033;
	bh=Ly7V3SrHtZViQ6MtbvivLUpsgPdJPaNMjgihUn8ZpHs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ty4JmrlUS5kwJfARWUSFPwalabr4sHyJRVqesfs4h6tVSEVjc1/WUrR6J1XSFypeU
	 grVDLv3OD8lci5/0KOuFX05J0SphuYF8ahf/my2S70VqcyBZS/BLOsFEAsqoqCA7q+
	 ThWJq6jPaRI4nS3i2LlRtoQVq4pCa7LU6A2R8r8Q0Thkn3ZtXD05V7v58i9BcRVWBr
	 r2IFJYB44CmB6c4UGdDc+9cheL9rPDELpsbNHJJ294KBvj6r3d6fR0dxwPEMh9LyH9
	 Q/NYGFbnpoUJunLuRln2tgiHTf9U0+2DzwUsocl2cKjqj/0DaTWJNmRdx6WZAOX/yP
	 yVeKReaiY4Wlw==
Message-ID: <43dde2e9-24a7-4e09-ba07-d1166963e16b@kernel.org>
Date: Mon, 16 Nov 2026 11:47:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slab: allow sheaves for SLAB_NOLEAKTRACE caches
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20261113-kmemleak_sheaves-v2-1-8c557c66cec2@debian.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261113-kmemleak_sheaves-v2-1-8c557c66cec2@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 157dgxzpapbwbw1fzq5gnn7gfyb6ttma
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 82135120005
X-HE-Tag: 1794826034-748682
X-HE-Meta: U2FsdGVkX19BAFpSTouTjyhQVZ1bA1CZ3tdEKcDblt2ApE9tuFmTj5CE006APUgRFLRGQHlajZVQZHCF5JmNP4lfpp9qt+PjWS4PjU179mHk22IB12VSb6JYbUJ9TAxdCgWsQuBKxHtSHCvHWnp4Lv16kZk6W/fJexCawfoTTQNZvx9/MPBJ4X6VUf3iaT4l5DGhDR80S6yuq2WYqsaPWl5YZDfs14hbnb+D9J2CSCVt8o7aLsFg5iyvl/n3RLPifGz1iIxgMWyXgVZxr7Iby49WmTaPrOkMkp5gRKn7i3sGVbi8IKvCqXc3p4xi1J7pcQDzovyvpMoOceeWQxIQuiYQTaOi4qenvtVkga4dHN41mLRYaCZFlDabbI+er/O/GvSab9K4GSyOjTjpEyNaZ0P3YDeWhJJn27vlfPZTRrk3SQryO0Wy1pV+Gbh/zELs0/KF+RtXSkhmt7q9/RZyhSy9mqvnS9J83BVF1qal5JdlVxkhzR+OnBn+iy9TlIol7XzUx87WZz68ZQG2mZxgzG4yDfbSde7rNFJoObv/2na7C7DaJfo6/vYx46318HzA9hqOX8864OP0+CHwVx8L1+nA0TIUd2ynkkHtuCtHiUax8fQnNKV1aEvYNqcT/PfnGUa9xsooxXomI95GduHej414s5V/rkYhdN8j2Poer83P33/uZ2WXqgRU8/qVoAsGeqKhNjUxtIV1GVYqUryQ7o7M+NofqECY2v15h5Ty8L5uIZAKF41luUX+CbB9mEKn+Gh6l9jJ5VhAn528MJriPiobStUzX2VD9z/w0c09pr43QPNC9p+xs6iROr7tUyRn7okNhsQlw0LfVE2vr+aEU29wewtGrzi4ccpKBQ1EiCHdw+dkqLVj180qlmguTyMdCozMEG5DkmZFSwpx+8lqGdmj7XmLPvYYlbErqLIsasX5Mofo6jR4rdH3ZdhXLweQ48Ye8LFQFE5N4Fhm07v
 pMSwxFlE
 lLFwQ0xATT1s9NqYo+yMzCuK284g05n4pjxIRu956pmpVjjY1/2KEJXsuDp6BNCEPKDuT6ZoSVakL8AYbgS5+K66aLmMrrqScL8OHVL8TH3WMUupYcVbPt4EmirbTg3/seVbOKbQYiTWrptCbCCoAAJB27Y34G/wVOlNJqgMVQqtumu5M2OmpiNuFPPhFZMtwEn714hfLc32frJ37ghinkC5n2z28/4wt/AzeVgwQNJ/WVukGj4rCZNjNmukxriaXAzt9XLfteZcj8JoLs3xKwwvNo5DYM4ARZG9u4Bhs8zUmWv+0nDo+/KnbEEEp5jjn3jSBoxj+PPdeoq9R5Gf7pVUNRp45WfJ3fdiuwdXEwYT4Mx9JDPzYFv9X3Cwua0daK4sGQFBBOuv36uWDF0iFbEkSHKWOCjTg1oQjP9qqyRDLcJVD22FFa7ie/UY2iOilesqHZO7hkG+dNG8jRRlzq7vQVE/ruVqseKVva+sSTj++5QdIeyX90c/PpNMnBMaKFRxeQwvK8DMfE5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 15:36, Breno Leitao wrote:
> This is a patch that makes kmemleak cheaper to run, by letting
> kmemleak's own metadata cache use a _new_ sheaves type. The flag only
> makes that possible without recursion.
> 
> The cost today:
>   * every allocation kmemleak tracks needs one kmemleak_object from
>     object_cache. An RCU callback frees it later.
> 
> Why that's slow:
>   * object_cache has no sheaves, so each of those allocations and frees
>     goes to the shared slab lists under n->list_lock.
>      - On meta's fleet kmemleak kernels, list_lock is the second most
>        contended lock, after kmemleak_lock.
>      - About 88% of that wait is RCU callbacks freeing kmemleak objects.
> 
> Why sheaves aren't allowed:
>   * a sheaf is a kmalloc object. Tracking it makes kmemleak allocate
>     another kmemleak_object, which needs a sheaf, and so on.
> 
> When I reported the recursion in [1], I suggested keeping
> SLAB_NOLEAKTRACE caches away from sheaves, and commit e47c897a2949
> ("slab: add sheaves to most caches") did that. It stopped the
> recursion, but it took the sheaves away from the whole cache, although
> only the kmemleak tracking of the sheaf itself recursed.
> 
> Commit 17c38c88294d ("slab: remove cpu (partial) slabs usage from
> allocation paths"), from the same series, then left these caches with
> no per-CPU caching at all.
> 
> In hindsight, skipping kmemleak only for the
> sheaf itself, as the new SLAB_ALLOC_NO_LEAKTRACE does, would have been
> the better fix.
> 
> The sheaf is allocated with SLAB_ALLOC_NO_RECURSE as well, like kmalloc
> sheaves. Without it, a backing kmalloc cache that needs a new sheaf of
> its own allocates it with SLAB_ALLOC_NO_LEAKTRACE too. kmemleak then
> does not track that sheaf, and can report objects queued in it by
> kfree_rcu() as leaks.
> 
> SLAB_ALLOC_NO_RECURSE also skips allocation tagging, so mark the codetag
> of these sheaves empty on free, as is done for kmalloc sheaves.
> 
> Link: https://lore.kernel.org/all/aW_NK2NXVgtuzCVH@gmail.com/ [1]
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Applied to slab/for-next, thanks!

> ---
> Changes in v2:
> - Fix sashiko findings:
>   - Set SLAB_ALLOC_NO_RECURSE along with SLAB_ALLOC_NO_LEAKTRACE, so the
>     flag stays off the kmalloc cache's own sheaf allocation, per Catalin
>     Marinas.
>   - Mark the codetag of SLAB_NOLEAKTRACE sheaves empty on free, per
>     Catalin Marinas.
> - Link to v1: https://patch.msgid.link/20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org
> ---
>  mm/slab.h |  1 +
>  mm/slub.c | 22 +++++++++++++---------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index e94ac63d10dc03..7b20f10aa46a2e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -23,6 +23,7 @@
>  #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
>  #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
>  #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
> +#define SLAB_ALLOC_NO_LEAKTRACE	0x10 /* skip kmemleak tracking */
>  
>  #define SLAB_FREE_DEFAULT	0x00 /* no flags */
>  #define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
> diff --git a/mm/slub.c b/mm/slub.c
> index 8369853ddca721..b927cd684ec656 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2850,6 +2850,14 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	if (s->flags & SLAB_KMALLOC)
>  		alloc_flags |= SLAB_ALLOC_NO_RECURSE;
>  
> +	/*
> +	 * kmemleak allocates its metadata from SLAB_NOLEAKTRACE caches, so
> +	 * tracking their sheaves would recurse into kmemleak. NO_RECURSE stops
> +	 * NO_LEAKTRACE from reaching the kmalloc cache's own sheaf allocation.
> +	 */
> +	if (s->flags & SLAB_NOLEAKTRACE)
> +		alloc_flags |= SLAB_ALLOC_NO_LEAKTRACE | SLAB_ALLOC_NO_RECURSE;
> +
>  	sheaf_size = struct_size(sheaf, objects, capacity);
>  	sheaf = kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA_NO_NODE);
>  
> @@ -2883,7 +2891,7 @@ static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  	 * warning, therefore replace NULL with CODETAG_EMPTY to indicate
>  	 * that the extension for this sheaf is expected to be NULL.
>  	 */
> -	if (s->flags & SLAB_KMALLOC)
> +	if (s->flags & (SLAB_KMALLOC | SLAB_NOLEAKTRACE))
>  		mark_obj_codetag_empty(sheaf);
>  
>  	VM_WARN_ON_ONCE(sheaf->size > 0);
> @@ -4727,7 +4735,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
>  		if (init && p[i] && !is_kfence_address(p[i]))
>  			memset(p[i], 0, zero_size);
>  
> -		if (alloc_flags_allow_spinning(ac->alloc_flags))
> +		if (alloc_flags_allow_spinning(ac->alloc_flags) &&
> +		    !(ac->alloc_flags & SLAB_ALLOC_NO_LEAKTRACE))
>  			kmemleak_alloc_recursive(p[i], s->object_size, 1,
>  						 s->flags, init_flags);
>  		kmsan_slab_alloc(s, p[i], init_flags);
> @@ -7987,13 +7996,8 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>  	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
>  		return 0;
>  
> -	/*
> -	 * Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES).
> -	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
> -	 * have sheaves to avoid recursion when sheaf allocation triggers
> -	 * kmemleak tracking.
> -	 */
> -	if (s->flags & (SLAB_NO_SHEAVES | SLAB_NOLEAKTRACE))
> +	/* Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES). */
> +	if (s->flags & SLAB_NO_SHEAVES)
>  		return 0;
>  
>  	/*
> 
> ---
> base-commit: 630059a5a632377b9b7b487baccde92b7ae1dd47
> change-id: 20261110-kmemleak_sheaves-b3531591ad21
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 


