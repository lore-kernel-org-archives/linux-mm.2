Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE450CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75496B0088; Mon, 28 Sep 2026 11:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26BF6B008A; Mon, 28 Sep 2026 11:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14836B008C; Mon, 28 Sep 2026 11:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80EC6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:38:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15917801D7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:38:16 +0000 (UTC)
X-FDA: 85263577392.29.0E2CED1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id E909AA000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:38:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gsr+kq6S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LKAnJVNH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=euolCOmJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NBSYNFWL;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790609894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1mVNj3GmuQmUn8QUDG5rPJ6I+BRzW4FmaeJ4FUK+B8=;
	b=ylrDjoyldg7JgwWJSn7pyKnWmDYVkyafwVZGOppAhKy5Aomf1sdMHCXGz7en/3rV4qf69B
	PV2i4QQDTMPvCOBn8yU7aC87DMMfdedstSbDCZTcIobj07KoLR0otzD1V6sezwD031WS4W
	T+ljpW6rl3KLx6rQkKaJ2+xQ+Rpz5hU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gsr+kq6S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LKAnJVNH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=euolCOmJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NBSYNFWL;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790609894;
	b=jRk42BInZhdwZb3bqE4qWqnOY/qVvPmuX5u+fYY1/iEh2prrEDS+ESvzTExb5jk30cQyrc
	Delqp7eGRLhApx/rchnIzXmvENCYbZhqbBil0MPaoHAxPrQt6N2hmefV8uUqtjixBVrAY0
	Db8HT1Ul7hxbMYSEBaaNpRwzr6hYPD4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3842321BBF;
	Mon, 28 Sep 2026 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790609888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1mVNj3GmuQmUn8QUDG5rPJ6I+BRzW4FmaeJ4FUK+B8=;
	b=gsr+kq6SdRJgCYqSY1CTkAP7tbA2ngDvfros0fFzvN2azAhw9NnnELOksc5Qh/ufQcQHcY
	yYgZrxcIQWguRnfTQRnYB5lfQZlSWgKojQfkmL5APF4U45PxEbYOIyydPtrqREcswDu/Wo
	MLd2/prnMZhgDhkH35Z8lbLcKLqsnXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790609888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1mVNj3GmuQmUn8QUDG5rPJ6I+BRzW4FmaeJ4FUK+B8=;
	b=LKAnJVNHviA6OFWe4pqnUpGpl500RvpMg+m+JvYqS6Zxfwwbm361ETWwBVTyfRKSpvrP4q
	3QJ9wuUmKvcHbZBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790609884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1mVNj3GmuQmUn8QUDG5rPJ6I+BRzW4FmaeJ4FUK+B8=;
	b=euolCOmJ4qejES4tqXBlRkgahEWxgMANsJSKJbFr5by6+hd87KtOSQ+skTpJSvpzE3qDhW
	DDBVcuo4IS3VMjd5Qhe7Dw0k9e42DI3Kd20zE7R17Dydk6A0XTK+Kn4PPP0ZqO55DkwhH6
	0PsVZXwH1oPXKMzmQd5lPziSnBbuQLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790609884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1mVNj3GmuQmUn8QUDG5rPJ6I+BRzW4FmaeJ4FUK+B8=;
	b=NBSYNFWLMeT7LxCo5F0fowqyomTCgeT3AD6gISlAtbmtXplgR1v6B7906z5jUlZovv8QoB
	fSB0+gSSCCmcrKAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6A2B133F3;
	Mon, 28 Sep 2026 15:38:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id am0/GNqJumoQRwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 28 Sep 2026 15:38:02 +0000
Date: Mon, 28 Sep 2026 16:37:52 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Pan Deng <pan.deng@intel.com>
Subject: Re: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
Message-ID: <arqI5QB5tUr8dd_r@pedro-suse.tail5790ac.ts.net>
References: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E909AA000B
X-Rspam-User: 
X-Stat-Signature: n39hpe3hrgt3yoyzqzxiwne4ff6qc49q
X-HE-Tag: 1790609893-231242
X-HE-Meta: U2FsdGVkX19z4d0B8LWS32wK/0wv07l1pAUejk3mqQf/P07MWQd8F4ebgymX/87FZCAVgAHK/A+nFVuSFY6dwl2myoSek59pOkhCPneumS7QMYjNr+g0XO/aVaWNpO9zAziVEgr0Q1h4ws9RRRGm9CO02Osn1/2w55s8dHcuoyZtyV0P3Vwnf0c1nEi4XudtzEHq9Fgjx0mCzuL/DU/fs7fqQmW7Sx8XhNgKJN0Bqq5EqI8gCVyiBw30I2PDSZ2ynJdvUfuBO/Jn335N8uKjfSEj0NfthpHcavXZ4+nqedvF2HtwKcngEDigNNFM7dT0pGTjmWPAUrE/sg5ifqkI/9rYnZKjHFdCyFXsNWLL0Jt9kJMjeqvVKB5e3aMHTi2/2xTipEgNZh0UAbnZ2W6OpnhlZG8E3R0Lqmv5QeqkZ3r3mmOeZca8bLUihHzAa5iai8+XReYGBXZxJobDVUhJJ5PBBJlppzzefwkeVSSOUtDaqPPwkajNugpvLRCm28eSrsrI8WT/76m+wZ+gagqiXDNOfg5JWtG1za4/BY+Vy7ZBYBzSAsh78tfLOK4o9mhT7/ABBOrv8bH8bW1Al16pKEw7t3WG7uKNrCeDsLYYqAvwT9mbo7jVQbD03whPVWhHuqzEuG7oX1YztM2FxvpFW9pcKxFziWfM88Xj4q3pZPGTvnMZkEeMb5hN6vwUmDBzEYQRPrWyLIEtwjrWVluFTLl0s/Sq1qfq31cxZ15QwYEaP6AeKSO8RhkilODR1pEeqATUKSD40b6s/QN88jylED+DrpkRFt/6QpJUEZ7EQ7BRJcNcRIGhwliWw33TSQObwePlMjDevPbb+fXXgdw82k/xgGY/kEU6q55gUZnBFrlEP0Y/YPFdODdxgxYdRZ0ggiQ97EFpHG1NrZpHk4VWcELBT3Z7SqzL+1rK5m8/htLXFZ1pikw19AZOq5IGz3aOhbINhCGJThN2jotOvaS
 Wke4YLFV
 wEXJZ36yvSWvY/DP0CeryxL7BY+qlXG6GyJeJV7Qj+PDZxGJQTy88BUs7NobWpAPDXxL3fPTSvZXM1MoSA5+dpD/8jRExdykYaWxyWWHlqrFO6QrMG6x/1oR3O0FYn6kFa+1hwTGxd+arESeIAofz2WT7ZwnUC/Gmp6wCo1Ip4gaPVEU38dUoZTn49AUHzeX0h5IcMbJg68Pqw2qNSFjAwJlCKKK/M6ZULYVP59GetGyTySOOCjq+ynOIqEi2i7PdO7PlBCfgGnnhkI3WLM7WD2q4BHq42mkwogr3wG7W8qzI9qYYt2cjDZj4QmBbeMB31Tfd
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

I think this asks for numbers?

> 
> Reported-by: Pan Deng <pan.deng@intel.com>
> Closes: https://lore.kernel.org/linux-mm/20260924054301.2330822-1-pan.deng@intel.com/
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

file_pgoff_unchanged perhaps? since we're distinguishing.

In any case, I would prefer if we moved this logic to mm/interval_tree.c, or
any rmap-related header. I don't love opencoding rmap tree assumptions this
deep in vma.c code. WDYT?


Rest obviously looks great to me :)

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

And perhaps similar for this, hiding update vs re-insert in interval tree
code (via a helper) sounds cleaner.

-- 
Pedro

