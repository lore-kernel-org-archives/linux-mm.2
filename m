Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E742FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D78D6B0005; Fri, 24 Apr 2026 14:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588396B008A; Fri, 24 Apr 2026 14:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E3F6B008C; Fri, 24 Apr 2026 14:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37F706B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:19:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 592BA1402A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:19:42 +0000 (UTC)
X-FDA: 84694262604.07.7275991
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5DC120005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:19:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=q7TD2DdI;
	spf=none (imf03.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777054780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/iO+x+IMoHA/NVDXXg9T5xHjSKwvnY9J1SHxfja5uk=;
	b=f41IEbtYJSey9UF7a7ZuJUPVWxNJu+NhwWSGEgPiGqaftBgnt7OJneOaz40RXFDTnwikE5
	BOpMs4S8l6zldo5iKwXyzwHCmNlNSttHkbAXkkdgWp1we8IPO+fAw9uJlSNnGEWoeECYha
	3Z8PQXXOzcxLmpqP5/4L24kzIhkm7Oo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=q7TD2DdI;
	spf=none (imf03.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777054780; a=rsa-sha256;
	cv=none;
	b=JR4UhGwkJB87UYsLksvb10fwsBb1VGc9OmsOPgYK12BGqTf/+rbPi+Ng3JSL1g2bKoF1Tc
	/AHjj93IMrQDaE+jYBtzys45IjOD4OM8XnLWCPJFbCgV6BiGVm8ev7RGsHajZYIhlWQZXa
	GVdPCQBBqoIy7DZNVezrlamiezRI3VQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J/iO+x+IMoHA/NVDXXg9T5xHjSKwvnY9J1SHxfja5uk=; b=q7TD2DdIlxw2OM/ULRaeZWVqVb
	aesZ4iiHUn44KdP7DmQjoVa6j+Rp8jjiDb4vvJpuAXvop4WkVZFUln+jW8nZAI01qIen7XgGMm8ht
	+Fcy4R2Kuk8LiWidr24V/kidK9uhvai+zDq2ucAb1Sty2QXc0rqamgg7zQTmM03EwG/bLLNwL2hKg
	CpRUufnH0L/8m4ajiqs+j0SqQh163tmTjvH4II8Zus8qtgbVOOmeedPtje6yBar/Z25TyJ3s3PDY6
	3rTCJMW4l4QeWtdhO97Ng3UQU84c6Neo7LsvwfpsjdRDTrt+v+f3BF94AMaMiBGtfSTpxzP+42UAJ
	fu++U+Kg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGL7m-0000000DdnB-3Eg2;
	Fri, 24 Apr 2026 18:19:35 +0000
Date: Fri, 24 Apr 2026 14:19:15 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
Message-ID: <ghgypt4u3etdbccgaxhrnrzjeylfqz257ky74sddvk372gmmg4@mganwyeibp4j>
References: <20260424070234.190145-1-surenb@google.com>
 <20260424070234.190145-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424070234.190145-2-surenb@google.com>
X-Stat-Signature: arxuusoggww5cmqt1mt7g8fxayhn1qht
X-Rspamd-Queue-Id: E5DC120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777054779-254924
X-HE-Meta: U2FsdGVkX19xELn0LSAPJUfpHwSPQQ8GrnHqA3w9au4n+SsaSaGPvzDODuPIvAhiuHGyQ2xPJD8KBi681nW+ceHQvOgMLpItNVyOL4wQLCYZ3VHNRqxoAxo5xArXYTFiuhCxJ3W9C9yjJAWj08K9owoB2F9nci2BWHeKH/qmHR1r+hW7urzi9LH+5xHgctYZL64/0E3Sr4T9Esz7F+TjNtlksAhu7tEd39EcI+eKXsgKAvF4VEgFx5JZU1lBTIte0II57iF0EZtZ/2dw4AO+djwDp/snXmtlxHITvdipOJ1qpQS2zXm7RPW9kTD4gmaa90dgNCXS8/vwBypwwWOlls6l3xC8tJP5rQ02jJZ24AHlRxJ//SG54IPgDmtGTQx/I8kIfxsETVhGrLJ3hNJdOYw/FDf8wJ9bNosLEvIGAbcbREui6gcGcZQw2+fddwIxLng7NzP4H+ekMsu30Nd8SdPfonC60XSvVxVMh9N8uSyZP6kewZeKU7LlkOOLGMKIRHnf0vT5jBK4Ru3EyDxJussqOy9lAkc4XVKkf0cgaD79U0zF3TZ3f2yyWOmUS5/8Gyi5rtEpNSbAFgUVASNpYfnoxeleh2+PUC9hnSNfqgII4jJ6YoIIKeJk7SIbMxLodY3K9HnPFcHxmAghfcCtBoicZKX6zGppSMAA21moTpxR8ysUn16593FdMVZl4FwEJpr8vPkaPKR0gsBzqoIQ2lRvGutYFcokUDYLXKJmNffeyIE+dibvwHtvO+zTz4BziGoeBrncY9Y9vUim9DTF3rvYVYlvmHvPgQhafDPLcg63SKvKmsJfVFvWn6pby4fm4jYX87PJ0ZsfmnjaAGrZMS2q9WIMfenSbIdb/TQs1fZJ8ln2UnZyn4pZr5X2rIcu6rj0mCTugCf7DztEZrd8LXlswBPbv5dtztYoUaZfMNpWN4RzLPlsphBrUiqFeA96st+2FVUnc1DO3lDyhjF
 i+UZVw/R
 KoV8PZZ/SyP2kMcj3n8x/KZNYLc3H81tlCAo9wRPg36JRJ5QiR9UL6IHX6Dbqml6PTLbWo2IQDBSOZwxUrQ8SBVqjbseisF9jfIK+vOXEugR7bsZJi19Jaul1LKAivTYjepPDdDjq8lWkKxN76nDol5DNOstb+XSEX/IKLFtzB+F+M2JvQwgvshPaGpxWwUCy5EqMVAkBAxf56sMpXduZXhabp5uyTzjN6KqWDQY0eB8xu8yfGryxsB7Y4QmDs5IM/PtRzOai7iK+dpf5LSgyjTba3TyOkz0QBqtSims/iQvUraV+88OxYMrzjtEWdLpXHoRsIGmRSdMlcKMldsSXKQOWjYsSQkcxYrD0/xRViHU94bSoHVN7gXuioozMeVUUzQ04ADXT3r1EUz5NHUnCuV8l40Sc4Hcco2N25JVb6xu2TUCZquBYR8x/dotSrm2ZYaIJsLPpd/13v6RZqti7cEDlELF7DtAAKkWy2rZJnK/bpKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/24 12:02AM, Suren Baghdasaryan wrote:
> proc/pid/{smaps|numa_maps} can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/maps. RCU is required to safely
> traverse the VMA tree and VMA lock stabilizes the VMA being processed
> and the pagetable walk.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett <liam@infradead.org>

> ---
>  fs/proc/task_mmu.c | 193 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 154 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 751b9ba160fb..96cfea252db6 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -132,6 +132,22 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  
>  #ifdef CONFIG_PER_VMA_LOCK
>  
> +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +{
> +	int ret = mmap_read_lock_killable(lock_ctx->mm);
> +
> +	if (!ret)
> +		lock_ctx->mmap_locked = true;
> +
> +	return ret;
> +}
> +
> +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +{
> +	mmap_read_unlock(lock_ctx->mm);
> +	lock_ctx->mmap_locked = false;
> +}
> +
>  static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	lock_ctx->locked_vma = NULL;
> @@ -146,25 +162,11 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  	}
>  }
>  
> -static const struct seq_operations proc_pid_maps_op;
> -
>  static inline bool lock_vma_range(struct seq_file *m,
>  				  struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	/*
> -	 * smaps and numa_maps perform page table walk, therefore require
> -	 * mmap_lock but maps can be read with locking just the vma and
> -	 * walking the vma tree under rcu read protection.
> -	 */
> -	if (m->op != &proc_pid_maps_op) {
> -		if (mmap_read_lock_killable(lock_ctx->mm))
> -			return false;
> -
> -		lock_ctx->mmap_locked = true;
> -	} else {
> -		rcu_read_lock();
> -		reset_lock_ctx(lock_ctx);
> -	}
> +	rcu_read_lock();
> +	reset_lock_ctx(lock_ctx);
>  
>  	return true;
>  }
> @@ -172,7 +174,7 @@ static inline bool lock_vma_range(struct seq_file *m,
>  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	if (lock_ctx->mmap_locked) {
> -		mmap_read_unlock(lock_ctx->mm);
> +		unlock_ctx_mm(lock_ctx);
>  	} else {
>  		unlock_ctx_vma(lock_ctx);
>  		rcu_read_unlock();
> @@ -213,17 +215,45 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  	return true;
>  }
>  
> +static inline void drop_rcu(struct proc_maps_private *priv)
> +{
> +	if (priv->lock_ctx.mmap_locked)
> +		return;
> +
> +	rcu_read_unlock();
> +}
> +
> +static inline void reacquire_rcu(struct proc_maps_private *priv)
> +{
> +	if (priv->lock_ctx.mmap_locked)
> +		return;
> +
> +	rcu_read_lock();
> +	/* Reinitialize the iterator. */
> +	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> +}
> +
>  #else /* CONFIG_PER_VMA_LOCK */
>  
> +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +{
> +	return mmap_read_lock_killable(lock_ctx->mm);
> +}
> +
> +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +{
> +	mmap_read_unlock(lock_ctx->mm);
> +}
> +
>  static inline bool lock_vma_range(struct seq_file *m,
>  				  struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	return mmap_read_lock_killable(lock_ctx->mm) == 0;
> +	return lock_ctx_mm(lock_ctx) == 0;
>  }
>  
>  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	mmap_read_unlock(lock_ctx->mm);
> +	unlock_ctx_mm(lock_ctx);
>  }
>  
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
> @@ -238,6 +268,9 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  	return false;
>  }
>  
> +static inline void drop_rcu(struct proc_maps_private *priv) {}
> +static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> +
>  #endif /* CONFIG_PER_VMA_LOCK */
>  
>  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
> @@ -538,12 +571,10 @@ static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
>  
>  static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	if (lock_ctx->mmap_locked) {
> -		mmap_read_unlock(lock_ctx->mm);
> -		lock_ctx->mmap_locked = false;
> -	} else {
> +	if (lock_ctx->mmap_locked)
> +		unlock_ctx_mm(lock_ctx);
> +	else
>  		unlock_ctx_vma(lock_ctx);
> -	}
>  }
>  
>  static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
> @@ -1280,16 +1311,64 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
>  	.walk_lock		= PGWALK_RDLOCK,
>  };
>  
> +#ifdef CONFIG_PER_VMA_LOCK
> +
> +static const struct mm_walk_ops smaps_walk_vma_lock_ops = {
> +	.pmd_entry		= smaps_pte_range,
> +	.hugetlb_entry		= smaps_hugetlb_range,
> +	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
> +};
> +
> +static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
> +	.pmd_entry		= smaps_pte_range,
> +	.hugetlb_entry		= smaps_hugetlb_range,
> +	.pte_hole		= smaps_pte_hole,
> +	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
> +};
> +
> +static inline const struct mm_walk_ops *
> +get_smaps_walk_ops(struct proc_maps_private *priv)
> +{
> +	if (priv->lock_ctx.mmap_locked)
> +		return &smaps_walk_ops;
> +	return &smaps_walk_vma_lock_ops;
> +}
> +
> +static inline const struct mm_walk_ops *
> +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> +{
> +	if (priv->lock_ctx.mmap_locked)
> +		return  &smaps_shmem_walk_ops;
> +	return &smaps_shmem_walk_vma_lock_ops;
> +}
> +
> +#else /* CONFIG_PER_VMA_LOCK */
> +
> +static inline const struct mm_walk_ops *
> +get_smaps_walk_ops(struct proc_maps_private *priv)
> +{
> +	return &smaps_walk_ops;
> +}
> +
> +static inline const struct mm_walk_ops *
> +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> +{
> +	return &smaps_shmem_walk_ops;
> +}
> +
> +#endif /* CONFIG_PER_VMA_LOCK */
> +
>  /*
>   * Gather mem stats from @vma with the indicated beginning
>   * address @start, and keep them in @mss.
>   *
>   * Use vm_start of @vma as the beginning address if @start is 0.
>   */
> -static void smap_gather_stats(struct vm_area_struct *vma,
> -		struct mem_size_stats *mss, unsigned long start)
> +static void smap_gather_stats(struct proc_maps_private *priv,
> +			      struct vm_area_struct *vma,
> +			      struct mem_size_stats *mss, unsigned long start)
>  {
> -	const struct mm_walk_ops *ops = &smaps_walk_ops;
> +	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
>  
>  	/* Invalid start */
>  	if (start >= vma->vm_end)
> @@ -1312,15 +1391,24 @@ static void smap_gather_stats(struct vm_area_struct *vma,
>  					!(vma->vm_flags & VM_WRITE))) {
>  			mss->swap += shmem_swapped;
>  		} else {
> -			ops = &smaps_shmem_walk_ops;
> +			ops = get_smaps_shmem_walk_ops(priv);
>  		}
>  	}
>  
> -	/* mmap_lock is held in m_start */
> +	/* Skip walking pages if gate VMA */
> +	if (vma == get_gate_vma(priv->lock_ctx.mm))
> +		return;
> +
> +	/*
> +	 * Need to drop RCU read lock before the walk due to possibility of sleep.
> +	 * Note that the VMA is still locked.
> +	 */
> +	drop_rcu(priv);
>  	if (!start)
>  		walk_page_vma(vma, ops, mss);
>  	else
>  		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> +	reacquire_rcu(priv);
>  }
>  
>  #define SEQ_PUT_DEC(str, val) \
> @@ -1369,10 +1457,11 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
>  
>  static int show_smap(struct seq_file *m, void *v)
>  {
> +	struct proc_maps_private *priv = m->private;
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
>  
> -	smap_gather_stats(vma, &mss, 0);
> +	smap_gather_stats(priv, vma, &mss, 0);
>  
>  	show_map_vma(m, vma);
>  
> @@ -1413,7 +1502,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		goto out_put_task;
>  	}
>  
> -	ret = mmap_read_lock_killable(mm);
> +	ret = lock_ctx_mm(&priv->lock_ctx);
>  	if (ret)
>  		goto out_put_mm;
>  
> @@ -1425,7 +1514,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  
>  	vma_start = vma->vm_start;
>  	do {
> -		smap_gather_stats(vma, &mss, 0);
> +		smap_gather_stats(priv, vma, &mss, 0);
>  		last_vma_end = vma->vm_end;
>  
>  		/*
> @@ -1434,8 +1523,8 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		 */
>  		if (mmap_lock_is_contended(mm)) {
>  			vma_iter_invalidate(&vmi);
> -			mmap_read_unlock(mm);
> -			ret = mmap_read_lock_killable(mm);
> +			unlock_ctx_mm(&priv->lock_ctx);
> +			ret = lock_ctx_mm(&priv->lock_ctx);
>  			if (ret) {
>  				release_task_mempolicy(priv);
>  				goto out_put_mm;
> @@ -1484,14 +1573,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  
>  			/* Case 1 and 2 above */
>  			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(vma, &mss, 0);
> +				smap_gather_stats(priv, vma, &mss, 0);
>  				last_vma_end = vma->vm_end;
>  				continue;
>  			}
>  
>  			/* Case 4 above */
>  			if (vma->vm_end > last_vma_end) {
> -				smap_gather_stats(vma, &mss, last_vma_end);
> +				smap_gather_stats(priv, vma, &mss, last_vma_end);
>  				last_vma_end = vma->vm_end;
>  			}
>  		}
> @@ -1505,7 +1594,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  	__show_smap(m, &mss, true);
>  
>  	release_task_mempolicy(priv);
> -	mmap_read_unlock(mm);
> +	unlock_ctx_mm(&priv->lock_ctx);
>  
>  out_put_mm:
>  	mmput(mm);
> @@ -3291,6 +3380,31 @@ static const struct mm_walk_ops show_numa_ops = {
>  	.walk_lock = PGWALK_RDLOCK,
>  };
>  
> +#ifdef CONFIG_PER_VMA_LOCK
> +static const struct mm_walk_ops show_numa_vma_lock_ops = {
> +	.hugetlb_entry = gather_hugetlb_stats,
> +	.pmd_entry = gather_pte_stats,
> +	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
> +};
> +
> +static inline const struct mm_walk_ops *
> +get_show_numa_ops(struct proc_maps_private *priv)
> +{
> +	if (priv->lock_ctx.mmap_locked)
> +		return &show_numa_ops;
> +	return &show_numa_vma_lock_ops;
> +}
> +
> +#else /* CONFIG_PER_VMA_LOCK */
> +
> +static inline const struct mm_walk_ops *
> +get_show_numa_ops(struct proc_maps_private *priv)
> +{
> +	return &show_numa_ops;
> +}
> +
> +#endif /* CONFIG_PER_VMA_LOCK */
> +
>  /*
>   * Display pages allocated per node and memory policy via /proc.
>   */
> @@ -3335,8 +3449,9 @@ static int show_numa_map(struct seq_file *m, void *v)
>  	if (is_vm_hugetlb_page(vma))
>  		seq_puts(m, " huge");
>  
> -	/* mmap_lock is held by m_start */
> -	walk_page_vma(vma, &show_numa_ops, md);
> +	drop_rcu(proc_priv);
> +	walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
> +	reacquire_rcu(proc_priv);
>  
>  	if (!md->pages)
>  		goto out;
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

