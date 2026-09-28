Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909A3CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC806B009D; Mon, 28 Sep 2026 11:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C356B009E; Mon, 28 Sep 2026 11:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D976B009F; Mon, 28 Sep 2026 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53E496B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:10:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0661C0204
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:10:23 +0000 (UTC)
X-FDA: 85263507126.21.AADDC2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 03BB780012
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:10:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lGo4Tp9F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+Lpc48c0OWZCSnpgp7hxgg6GPXtxYE50L2BN0lmMfs=;
	b=Vk4lXd+xkc8pkB60EU+r8pDQla2Bkz8UswZQ4No+XUftcN9wOJMyEl/kpOp4vFdfM5pdIx
	kUxNdbWMxcWsrFwQmDtk6Cog1wpH/VwvPLofoHLJ4MEQMYd+ostTNC4MrGhs+/PpmH20XN
	sseFeQzPJWBk2Btwurz+t2lc+IW9454=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lGo4Tp9F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608222;
	b=qNKoxx8vo39V/FC/F4sp9lAxDXJebjpjmhapibDQYb3wFQz27PzzWtvs2YwYNq0q3/rlWd
	qJ3pyKPcqCfCpUgmeftGL1YQVqIzIzxe/cxFRirU9s6EPye4ARHqqZYVdCvRxZxq8TMEK9
	O8uUs4/PRt8fc5uPiAHul21vgVCgFM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E410600CB;
	Mon, 28 Sep 2026 15:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77C11F000FF;
	Mon, 28 Sep 2026 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790608221;
	bh=K+Lpc48c0OWZCSnpgp7hxgg6GPXtxYE50L2BN0lmMfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lGo4Tp9FRGlvUVgLuT933IuIuniLtK6YyRajun0S12ByxMSIGvn3Y528MrZ6ZzmT1
	 ru3irFQZNTKqaskfnY44uqGkdSsrR1omdJaLlvHmFeGlHhcwv3CNzzTKKSEIHux+PW
	 b1aNLexHeozx2XB1wg47Pvdv7AanTr925NDQj5qVkfCIcQXIL89TcwChgO2fjJiijx
	 YaQ8rZbd5YrNy7IfwIcm2myxcLbIzAM03STKAmum//mFxTPr7vXaP5NM4fgRnE5iy9
	 ci/J1izZZMHI+tLq8bg9EsoAVmOWTYCYw9SVeQvE9XqRV+wB23+UYZq8bmry46Gbu7
	 iiwY8RSTHYGyw==
Date: Mon, 28 Sep 2026 16:10:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pan Deng <pan.deng@intel.com>
Subject: Re: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
Message-ID: <arqDFj6nOVh7-Ehu@gremlin>
References: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
X-Stat-Signature: ozcdwicps4gq3sm78khdxfp17hdibory
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03BB780012
X-HE-Tag: 1790608221-580662
X-HE-Meta: U2FsdGVkX18BE1RUsf2VELPbRRfvwnG8A4oJysKlxgtvgOCHSpanWWXr0/hJ/2pHgspTSoYEoT7yTcgqJBMOq2HAe05U1OHE1KW6xZ8ylorE2DY25BXSTH3TxcyyxTAnHV3vz50Bh1bqk08btwkwtLAD+7tatGX7TXihcwrJSYI9vi0v9UG4G1JWTpV8ixdgDSGJwzNtk/D4a1xL9wB+rVhOnsQiHKezmxOtPLeBNwDfO3ra+zE7LsGIAR+g4OHkvMNuef9AUzE6acXlB6ZQrGC0kzxVkD3TgaccTZLw5wAgYQRD3D1tEiWs1wuwuzowVbQ0+ycTaNGDjnDozGhCen+EquosV55CnEDRRPGEUCXLxudL7apZxmnPhoH4cFPKZglplPtCaUFO7d3QWt7v0KZYMlBToqp1HsHwWwnOMqd6aHnqFWuL+sV5KD5EajclxhKQwa3YYHEVuB7BN/faK+n5QhJJVGF0uDzc0rkJaU9fpdBoINylK1vUkIXvpprKlxpKnKQY5L85dvqaNDnGWB8RVSVWnEL8wisYoBjfqRjSVK2BfRmgLHhbins+UlGIb1R8jnfQnsQ8APOaUeU1s2T9t/ezE2HVAfmZQvlCRY4/sxRQXl9mxTnFX4GlnxsDN4tWAs/pu9s8YPL3WOnK/kI1Bat9+zbaH7Fdv+48lHR42FkTskh2CJO1j9xHXyMtGC/HlCs9ZdRmPKBiFtYivSFMte5xv94Cj9bbT1hqoWqBNuGkGm24H7Z8qMgm0ybkpw04fDKze21hmdkrW3/BVxBA/MTd5aZoEfOHvr8hrHB+w3wXgX66YJIfF+lDu+qQj7qzAblvL826CWK4li3DSlCq9DBHXzgY2dOjEPxu6hbgqune22ORFnQk2Wt2/eJejf3uFKzz+qEsPRC+Hl2sGFcHgpZIgFp3j/PDvCwgpHGjKSdzzakgHhs2zPvnl8x+dE1JK2rhYvlYXjxDuKV
 b63TLx/b
 uqeXIkT3mwW/zHAo+FcnWnQa7mUOAWiiDInWRSKxakVBxjgiBfw1ubgedGw2Te+UWs4trpLORuQSDf5XnXtUzb8Fu4p9M6Ui8JsqsUFkUuynZgKgcQ1AMg0H9C4fA2K+nvE3G8NgJQf7zko+3029ACNJ55DVCJxfpTCXVhIkusSCH/T1JuBqA0+yD9bX3Mj1Y+cFrhKBbLr7XoGk/XCtmQ5fK1KBi5sUT1wrBRQtkak88zmI5MvadqztLWRV0ec0XCI9d3ujyBqKqwGnIrPkSxAG4BfETAjEIoexafYIQ/wb3Nhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 07:32:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> When updating a VMA, vma_prepare() unconditionally removes it from its rmap
> interval trees under the rmap lock, and vma_complete() reinserts it before
> releasing the lock.
>
> This is wholly unnecessary if its page offset (file rmap) or anonymous page
> offset (anon rmap) is unchanged.
>
> So, track whether they will change in the newly introduced
> vp->anon_pgoff_unchanged and vp->pgoff_unchanged fields, and use them to
> determine whether to remove the VMA or not.
>
> The rmap lock keeps things safe as no rmap walks can concurrently occur
> during the operation.
>
> Additionally, some architectures (arm, parisc, nios2, csky) have dcache
> flush rmap walkers which take only flush_dcache_mmap_lock(), which is
> likewise held across the operation.
>
> It's also necessary to keep the rb_subtree_last field updated in the
> interval tree so implement anon_rmap_tree_update_inplace() and
> mapping_rmap_tree_update_inplace() to do that.
>
> This is done in vma_complete(), after the VMA's range has been updated, so
> in the interim the field may be invalid. However, given the locks described
> above, this cannot be observed until after the state is corrected.
>
> The anonymous rmap is keyed on anon_vma_chains not VMAs, so in those
> instances anon_rmap_tree_update_vma_inplace() iterates over
> vma->anon_vma_chain, invoking anon_rmap_tree_update_inplace() on each one.
>
> For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
> is also updated in anon_rmap_tree_update_inplace().
>
> When performing a VMA shrink or a split where the VMA is the lower one, the
> page offset cannot change, so set the flags unconditionally in these cases.
>
> When merging VMAs the page offset is unchanged only in some cases, so
> update init_multi_vma_prep() to set the flags only if the page offsets
> remain the same.
>
> These changes ultimately result in less rmap lock contention.
>
> Reported-by: Pan Deng <pan.deng@intel.com>
> Closes: https://lore.kernel.org/linux-mm/20260924054301.2330822-1-pan.deng@intel.com/

Andrew - Can you switch these 2 tags to:

Suggested-by: Pan Deng <pan.deng@intel.com>

Please, thanks! :)

> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h                |  3 +++
>  mm/interval_tree.c                | 33 ++++++++++++++++++++++++++++++++
>  mm/vma.c                          | 40 ++++++++++++++++++++++++++++++++++-----
>  mm/vma.h                          |  2 ++
>  tools/testing/vma/include/stubs.h |  8 ++++++++
>  5 files changed, 81 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6e71eaa4af3f..94c2eb055716 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4357,6 +4357,8 @@ void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
>  				    struct address_space *mapping);
>  void mapping_rmap_tree_remove(struct vm_area_struct *vma,
>  			      struct address_space *mapping);
> +void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma);
> +
>  struct vm_area_struct *
>  mapping_rmap_tree_iter_first(struct address_space *mapping,
>  			     pgoff_t pgoff_start, pgoff_t pgoff_last);
> @@ -4374,6 +4376,7 @@ void anon_rmap_tree_insert(struct anon_vma_chain *avc,
>  			   struct anon_vma *anon_vma);
>  void anon_rmap_tree_remove(struct anon_vma_chain *avc,
>  			   struct anon_vma *anon_vma);
> +void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc);
>  struct anon_vma_chain *
>  anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
>  			  pgoff_t pgoff_start, pgoff_t pgoff_last);
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 7bbbf15cfbf0..eafde5d12ef5 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -64,6 +64,21 @@ void mapping_rmap_tree_remove(struct vm_area_struct *vma,
>  	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
>  }
>
> +/**
> + * mapping_rmap_tree_update_inplace() - Update file rmap tree to reflect an
> + * in-place change in a VMA's size.
> + * @vma: The VMA whose size has changed.
> + *
> + * The file rmap lock must be held.
> + *
> + * Invalid to do so if @vma->vm_pgoff has changed.
> + */
> +void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
> +{
> +	/* Propagate all the way up the tree. */
> +	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);
> +}
> +
>  struct vm_area_struct *
>  mapping_rmap_tree_iter_first(struct address_space *mapping,
>  			     pgoff_t pgoff_start, pgoff_t pgoff_last)
> @@ -111,6 +126,24 @@ void anon_rmap_tree_remove(struct anon_vma_chain *avc,
>  	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
>  }
>
> +/**
> + * anon_rmap_tree_update_inplace() - Update anon rmap tree to reflect an
> + * in-place change in the size of @avc's VMA.
> + * @avc: The anon_vma_chain whose VMA's size has changed.
> + *
> + * The anon rmap root lock must be held.
> + *
> + * Invalid to do so if the VMA's anonymous pgoff has changed.
> + */
> +void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
> +{
> +#ifdef CONFIG_DEBUG_VM_RB
> +	avc->cached_vma_last = avc_last_pgoff(avc);
> +#endif
> +	/* Propagate all the way up the tree. */
> +	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
> +}
> +
>  struct anon_vma_chain *
>  anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
>  			  pgoff_t pgoff_start, pgoff_t pgoff_last)
> diff --git a/mm/vma.c b/mm/vma.c
> index 077e23694143..8b333ec0c958 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -201,8 +201,15 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
>  	if (vp->file)
>  		vp->mapping = vma->vm_file->f_mapping;
>
> -	if (vmg && vmg->skip_vma_uprobe)
> +	if (!vmg)
> +		return;
> +
> +	if (vmg->skip_vma_uprobe)
>  		vp->skip_vma_uprobe = true;
> +	if (vma_start_pgoff(vma) == vmg_start_pgoff(vmg))
> +		vp->pgoff_unchanged = true;
> +	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
> +		vp->anon_pgoff_unchanged = true;
>  }
>
>  /*
> @@ -331,6 +338,15 @@ anon_rmap_tree_post_update_vma(struct vm_area_struct *vma)
>  		anon_rmap_tree_insert(avc, avc->anon_vma);
>  }
>
> +static void
> +anon_rmap_tree_update_vma_inplace(struct vm_area_struct *vma)
> +{
> +	struct anon_vma_chain *avc;
> +
> +	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> +		anon_rmap_tree_update_inplace(avc);
> +}
> +
>  /*
>   * vma_prepare() - Helper function for handling locking VMAs prior to altering
>   * @vp: The initialized vma_prepare struct
> @@ -359,14 +375,16 @@ static void vma_prepare(struct vma_prepare *vp)
>
>  	if (vp->anon_vma) {
>  		anon_vma_lock_write(vp->anon_vma);
> -		anon_rmap_tree_pre_update_vma(vp->vma);
> +		if (!vp->anon_pgoff_unchanged)
> +			anon_rmap_tree_pre_update_vma(vp->vma);
>  		if (vp->adj_next)
>  			anon_rmap_tree_pre_update_vma(vp->adj_next);
>  	}
>
>  	if (vp->file) {
>  		flush_dcache_mmap_lock(vp->mapping);
> -		mapping_rmap_tree_remove(vp->vma, vp->mapping);
> +		if (!vp->pgoff_unchanged)
> +			mapping_rmap_tree_remove(vp->vma, vp->mapping);
>  		if (vp->adj_next)
>  			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
>  	}
> @@ -387,7 +405,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
>  	if (vp->file) {
>  		if (vp->adj_next)
>  			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
> -		mapping_rmap_tree_insert(vp->vma, vp->mapping);
> +		/* Need only propagate the change inplace. */
> +		if (vp->pgoff_unchanged)
> +			mapping_rmap_tree_update_inplace(vp->vma);
> +		else
> +			mapping_rmap_tree_insert(vp->vma, vp->mapping);
>  		flush_dcache_mmap_unlock(vp->mapping);
>  	}
>
> @@ -406,7 +428,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
>  	}
>
>  	if (vp->anon_vma) {
> -		anon_rmap_tree_post_update_vma(vp->vma);
> +		/* Need only propagate the change inplace. */
> +		if (vp->anon_pgoff_unchanged)
> +			anon_rmap_tree_update_vma_inplace(vp->vma);
> +		else
> +			anon_rmap_tree_post_update_vma(vp->vma);
>  		if (vp->adj_next)
>  			anon_rmap_tree_post_update_vma(vp->adj_next);
>  		anon_vma_unlock_write(vp->anon_vma);
> @@ -593,6 +619,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>
>  	init_vma_prep(&vp, vma);
>  	vp.insert = new;
> +	vp.pgoff_unchanged = !new_below;
> +	vp.anon_pgoff_unchanged = !new_below;
>  	vma_prepare(&vp);
>
>  	/*
> @@ -1346,6 +1374,8 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	vma_start_write(vma);
>
>  	init_vma_prep(&vp, vma);
> +	vp.pgoff_unchanged = true;
> +	vp.anon_pgoff_unchanged = true;
>  	vma_prepare(&vp);
>  	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
>
> diff --git a/mm/vma.h b/mm/vma.h
> index 7a683272c0a8..336b4ced82c9 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -28,6 +28,8 @@ struct vma_prepare {
>  	struct vm_area_struct *remove2;
>
>  	bool skip_vma_uprobe :1;
> +	bool pgoff_unchanged :1;
> +	bool anon_pgoff_unchanged :1;
>  };
>
>  struct unlink_vma_file_batch {
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index e4acc6f1fe7b..f0a69393c02a 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -267,6 +267,10 @@ static inline void mapping_rmap_tree_remove(struct vm_area_struct *vma,
>  {
>  }
>
> +static inline void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
> +{
> +}
> +
>  static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
>  {
>  }
> @@ -281,6 +285,10 @@ static inline void anon_rmap_tree_remove(struct anon_vma_chain *avc,
>  {
>  }
>
> +static inline void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
> +{
> +}
> +
>  static inline void uprobe_mmap(struct vm_area_struct *vma)
>  {
>  }
>
> ---
> base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
> change-id: 20260925-speed-up-inplace-rmap-808fbb3848f5
>
> Best regards,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

--
Cheers, Lorenzo

