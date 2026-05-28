Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A01CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CC46B0005; Thu, 28 May 2026 11:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCE46B0088; Thu, 28 May 2026 11:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA9D6B0092; Thu, 28 May 2026 11:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C86976B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:17:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B1F21A08DD
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:17:32 +0000 (UTC)
X-FDA: 84817182744.09.61B5A27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A26518000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:17:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V+Lk/Vou";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779981450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RW3Y2Ha3gqM7/bLJDb0CSWGAyMmc2M3HAzXjApfc9PM=;
	b=qOc/kEIjyYFsH0CFM+NEQJ9ba5C5hKQpAqjHRyQECpwvw7vg2/NsQTAtvSAaoQX5vSrKJi
	Ns1/4kfIxmK/9ny0oPJML9ilWnOgU8XTP0Xt+/YHlcw9Qv6mEmXSa7hGNF92rOrNv6popA
	VYtzslDuox4kNXbKNfDVwXTqqrnypjg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V+Lk/Vou";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779981450; a=rsa-sha256;
	cv=none;
	b=pAnmdaxPwjO6LkumqDIKvZPR+YNg+IdvcpbV9Hn4HlcTmYTAfumn6xTEM4zgrU4yLhestu
	TD27IWxIDTo0Xej9B+J0diU75JnwjE8bZviPPLHAqGpzcD4vmsv7iVLYcQmrnbUIX0yJyP
	417fR6JeRR9jNnRfVUBLAxJMt5potjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EA9D6014B;
	Thu, 28 May 2026 15:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E5A1F000E9;
	Thu, 28 May 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779981449;
	bh=RW3Y2Ha3gqM7/bLJDb0CSWGAyMmc2M3HAzXjApfc9PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V+Lk/Vou8B4X4HqKhqT9Yn91rGugeQspM1gum0DLyaS9FC+jMMFAK0skYZwGkeM7o
	 amjmF8Kthrzdm/5as3ZkZB67RBDtXlXZvC1OWt/Cjop3vKfsoxqnZETvdg5PDb5ZOI
	 oTvR2Fr6NfSPP0qYY6/w6rtVMxMzH9GgvNySqyurabsrzTqfSh3gvmwa1GJiec1BIx
	 8rYCJPOcUdXAUS8GXurZDLDOo1pf4ZONuPnAviengmNcbNK4QJQ7nq+pJZTZR+afo9
	 4okXd+ZSoi/Xp8IFXgSj/HiKLx5W9fCwflA0+w0BrF4ayUFqKKgMGjuI9zDNGyrFDu
	 5PbwDv7gowrIA==
Date: Thu, 28 May 2026 16:17:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
Message-ID: <ahhMEBYM9bixF2Lg@lucifer>
References: <20260426062718.1238437-1-surenb@google.com>
 <20260426062718.1238437-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426062718.1238437-2-surenb@google.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: nc75exg5wm7owzw66kw9sugbykx377g4
X-Rspam-User: 
X-Rspamd-Queue-Id: A26518000B
X-HE-Tag: 1779981450-700977
X-HE-Meta: U2FsdGVkX18GXwAWlbQRFvqKCfCYtonK91XEwdTqkf7FApReLJub1tgW7asF5v+dRC87WPAZqYZQQsdU5kKvrn+kRwOv8jRPmTifDUW7bhcl/RNQgmzKxcpeEr7cpymYmFLlRX6ie88Oh1PThW6PYYibk9D+91NDyAml/4wIGxg/4ihKtOZ7G7LPLEjR75m5mH4ErTotALBfUtS1KzSTnlmZNwKFOWAqoKGwX97RRDhpA1rwtRddYuMPL1+gmyoLHwWYoVs57qFHcJPiIV+8YlvYBNWEev2ZPD2k2li4q1pOfLgsQqYH7Jgk2cH8iS+LmS1LU/wlWTo8KTgIaLNGoEUY+K8JwUXVsadP9872XzRO4SLZfXyiq8TmhV3Kps2FXwYXQEJuTm4T7H0C7Gdfjd/IngbC8zkCsxBRA+ApF+Uiv2ONpjWwyFc5Ql9FElRJfF2+v2DDVO+nQgAlqQpw58F7uEgDRgG/PkGb7781t0L5Ndx13XqajWiK8F5oWJmrGBK8ZigtKL5fRO5Sp91Fd2UCg2+CcCwtL2U1zy7htaONKRU20Lqc8ANO24pNf4XBCzLZG7eYrHuR2sAorSsFFmbuD/vhfwvyprxBRbjFV8jvS5MkAjYKMGAgbgSksHvR+n9PKLoMujDcaAcUchvq36DUR32CP7zcJg9M0gUnmyAftf6y21enita8z8xEQiORMJbyGsDRPwhcFxiDErary/0qqQzT/OJMzq3HK7lhFDhqXRbLHKo4I8xDhg+8HMuypG4WUn8g320HUnpR3aH+qf5rTohHE7TX6Uk7ALb77gPGqiZT48bRw/en69Ta+/qd2DYljTijhlWCGiaLAXfdE5XDOVUJxf1rFHt/iB16/nweZJQs9B+Amrgv78RKWcXi5SWBcDZouM8VkKyXXu2r0w575p1gpOnkoHGmzW1QGpYzTKFYbBCmcoXBfzFlhP8cT1AV595liHKasusi8/i
 RIMOGYtf
 rRxYZmjTAYd0HJx6kO/UG7VH9AWxuQy54duL1OSs548SWTAgO7TtdxAdPCbLP3OYYhjZVKaV1r/yRtV2z1z0mj2R68K0OfPV5r3nMfMXEMaulBGHV4qsTxaYPxh4qYPp8nthc06aPEbMawi57TfJnouyNGIj/TXTDvigy25OdprOWz6jgjL8ZHeXVwqWkC+ZeCiwQVbYCCW2MT+lbr683RV/0AXHyIzQ587nEP9Mm1F+4keeOU9S0VAMMOODOUyuIo9E2iFM5dqwxuc0aMfpiYJd+zWC8xV7SkRfwylWudbetfV0d+N19K6zbcOy3jb9tAUccL69kY+y84ckBlKkv34PdhGHnt2VvK0phcfaWu8A+yfqXkcIbRPunjiYhGnGQ5r8BvrneY5bUrbemMmtseQ+PlITBjRRX0dfWerUby/u/vR+qkW0Rv1mllhXyRoEepELt4Runw59MZiosxcmPtOus4YL4M5NTypCJ+5/S2tafImut9nimZf5Y8IZYVWfB53XgX5Kq9rk71AZLmpJ4T8t2uCvxo6EJXWVjqojJmNrIlwfYyy1NTY/nFbNELeDO5etz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 11:27:16PM -0700, Suren Baghdasaryan wrote:
> proc/pid/{smaps|numa_maps} can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/maps. RCU is required to safely
> traverse the VMA tree and VMA lock stabilizes the VMA being processed
> and the pagetable walk.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett <liam@infradead.org>

The logic LGTM, some nitty things below but in general:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 195 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 156 insertions(+), 39 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 751b9ba160fb..1e3a15bf46f4 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -132,6 +132,22 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>
>  #ifdef CONFIG_PER_VMA_LOCK
>
> +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)

NIT: But these inlines are unnecessary in a C file. At the kernel optimisation
level the compiler already decides whether to inline or not.

However in the kernel we redefine this so we lose function tracing and also we
don't get warnings about unused functions [0], so this is actually a bit harmful
- you can end up with dead code and not know abou tit.

Same goes for all the other static inline's in task_mmu.c.

[0]: https://elixir.bootlin.com/linux/v7.0.10/source/include/linux/compiler_types.h#L235

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

OK good that we reset this :)

> +}
> +
>  #else /* CONFIG_PER_VMA_LOCK */
>

We need to pull out the patches from Dave's series and remove this option and
default VMA locks on by default :)

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
> @@ -1280,21 +1311,75 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
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
>  		return;
>
> +	if (vma == get_gate_vma(priv->lock_ctx.mm))
> +		return;
> +
> +	/* Might sleep. Drop RCU read lock but keep the VMA locked. */
> +	drop_rcu(priv);
> +
>  	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
>  		/*
>  		 * For shared or readonly shmem mappings we know that all
> @@ -1312,15 +1397,16 @@ static void smap_gather_stats(struct vm_area_struct *vma,
>  					!(vma->vm_flags & VM_WRITE))) {
>  			mss->swap += shmem_swapped;
>  		} else {
> -			ops = &smaps_shmem_walk_ops;
> +			ops = get_smaps_shmem_walk_ops(priv);
>  		}
>  	}
>
> -	/* mmap_lock is held in m_start */
>  	if (!start)
>  		walk_page_vma(vma, ops, mss);
>  	else
>  		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> +
> +	reacquire_rcu(priv);

OK I was going to say that this RCU lock dance is a bit iffy, but I see
that we're sharing code such that this is necessary.

>  }
>
>  #define SEQ_PUT_DEC(str, val) \
> @@ -1369,10 +1455,11 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
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
> @@ -1413,7 +1500,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		goto out_put_task;
>  	}
>
> -	ret = mmap_read_lock_killable(mm);
> +	ret = lock_ctx_mm(&priv->lock_ctx);
>  	if (ret)
>  		goto out_put_mm;
>
> @@ -1425,7 +1512,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>
>  	vma_start = vma->vm_start;
>  	do {
> -		smap_gather_stats(vma, &mss, 0);
> +		smap_gather_stats(priv, vma, &mss, 0);
>  		last_vma_end = vma->vm_end;
>
>  		/*
> @@ -1434,8 +1521,8 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
> @@ -1484,14 +1571,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
> @@ -1505,7 +1592,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  	__show_smap(m, &mss, true);
>
>  	release_task_mempolicy(priv);
> -	mmap_read_unlock(mm);
> +	unlock_ctx_mm(&priv->lock_ctx);
>
>  out_put_mm:
>  	mmput(mm);
> @@ -3291,6 +3378,31 @@ static const struct mm_walk_ops show_numa_ops = {
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
> @@ -3335,8 +3447,13 @@ static int show_numa_map(struct seq_file *m, void *v)
>  	if (is_vm_hugetlb_page(vma))
>  		seq_puts(m, " huge");
>
> -	/* mmap_lock is held by m_start */
> -	walk_page_vma(vma, &show_numa_ops, md);
> +	/* Skip walking pages if gate VMA */
> +	if (vma != get_gate_vma(proc_priv->lock_ctx.mm)) {
> +		/* Might sleep. Drop RCU read lock but keep the VMA locked. */
> +		drop_rcu(proc_priv);
> +		walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
> +		reacquire_rcu(proc_priv);
> +	}
>
>  	if (!md->pages)
>  		goto out;
> --
> 2.54.0.545.g6539524ca2-goog
>

