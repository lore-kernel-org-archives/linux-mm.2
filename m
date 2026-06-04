Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3657BCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE186B0005; Thu,  4 Jun 2026 03:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DF26B008C; Thu,  4 Jun 2026 03:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DC16B0092; Thu,  4 Jun 2026 03:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A266B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:14:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55638EB66
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:14:58 +0000 (UTC)
X-FDA: 84841368276.19.0AC11C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1291710000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:14:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0+CqvLi;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780557297;
	b=XXxMsmLdSrqS5Z74usUHj0HOkgsa4TPcWlZBKCWGSyrRoyDf1hKCWo86JQRBRjrP3G59L8
	Q2J3Xb/UJH5UvtZKo1K7avvggX4cswgpYiqvmFqu5qW5eo9tCU9V5E3w9+0lPgr5OX36uv
	d1iNaOw4TZYbx/6niLwtm9Vp7D+zikY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0+CqvLi;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8m2wBlqrNniJuXWjPa5emnSIuk3xsl0CXNJOG/LcpNg=;
	b=l1GJOBoZDcWNE64BbyocGyiJL9aJScca/xBd0BgVzLp1eIlStM42mg58L/8f+O0FOpciBr
	EBae0XSfJCuOAoYm781FdwapdN2pbJy8A6Rh8SWkiFioHzTKNMdM3+5AevZ6B35C78+gHq
	rqlgJOf/NR9cGXUhH5pFJRM/Zv7zucw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FC7D43BF8;
	Thu,  4 Jun 2026 07:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DEA1F00893;
	Thu,  4 Jun 2026 07:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780557296;
	bh=8m2wBlqrNniJuXWjPa5emnSIuk3xsl0CXNJOG/LcpNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U0+CqvLiNn1W0H5nExQKsf8773YkpbNiH0ZuQcS3bDXRKk9Fk/cmVBGkrMyQLbDQ6
	 Shhca1wkgKb24ZJIH6CQF9xYwvOVxwG9DzzLXa7C3yJKatBS8TW+ue7lELmtaB1fKX
	 6C8f0iKoPB3oaMkD7FTL78fAoe0yXWIO/e+CqFEEJQa4r8aQXKN5m6RZp1f7+CIBvm
	 0tv5f8Knyg5WiAoeyDLRUfQt/8BDS16nciICeSIHMlUUIw0jCBYZ/i7PNMMmC8C4Zo
	 U9xwSKN2kN4BDJI574TsbUnErOaAyUlUwD89lpa1idnNOvw+LZCaj0vIP0btoyRwS5
	 O0n1KgkVJHe3w==
Date: Thu, 4 Jun 2026 08:14:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
Message-ID: <aiElxkLHn2yC3W_3@lucifer>
References: <20260426062718.1238437-1-surenb@google.com>
 <20260426062718.1238437-2-surenb@google.com>
 <ahhMEBYM9bixF2Lg@lucifer>
 <CAJuCfpFJvuFZkgKwJ11RjDXYhTz-a31HO9-5C+Yc=KxbsGvB-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFJvuFZkgKwJ11RjDXYhTz-a31HO9-5C+Yc=KxbsGvB-w@mail.gmail.com>
X-Rspamd-Queue-Id: 1291710000E
X-Stat-Signature: da9jkj9a4bmqrhsbjqarzperjz4cmheu
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780557296-986964
X-HE-Meta: U2FsdGVkX18x4m3Kqpr/SmZRHD0lLEhGDkg1ssBFkZF4p/aZV7jzn34gtm2IUoJoUo74tqmm9TpkyvfqS8TdZVZYUuySQICv5/gfQitV9LeIWV1A6MOzFO4spKJZ5F5jWkLuJ0L6I4beOLxjA03/CoAYfjWcEBKPzGbm8bNI21XNnFoEAyvUnn5+N++UeNw37ygTCfToaZvA0yF/VMVL6AUpo2K40ZEppXyJucmFsYmbcWSmnWTews8FBYql7oY5w0A58EOX34Ca3/m6KfdK2Uy6Tqw6HlfBLQiqJw0ynOwjATtWCtMZd0ImgOHd44lbEtlxlU2vhQYwwDhA79PvYhx2AVtm82UormP/qwrf7VSSl/XdvzgmmgICQz9K1QCvzSvlo/Lgnq4pW4EfqjGP34kDqEoJrb4EvyMzNCY/fAFMkR2mJKRdit0sXW6gAaRsL44PH0QjBI3bBMtEQTpKKWXg2MSNq8htfH15LgqwWTqkSVe1ABicfJGDXyt+dz4S0uUV/8SSgpnoC2HHF9LrrtrHsJY5chmG+Yi1vHYaCGSfNUpvj/i4yh5Kha9mvrmZ0yZZHBC5f61c0FWcwVIC6vYuFLlfcFI8zBnFJxTkESj16Go7Ry4ucllSbaRe2P9kbqan1BzG3CRIc33DB0Ax36WLLujFQYknwrswbulJrTDpHKyB4g1qULBnfObj/+QB30+NQgwgIXUsCRrLFIc6bUYUA5dvMjD81gudr+OCpIlCFuKRhGN+60jq+3CGyb4k4tOUhhahVjMnt3PV9n5EMaKofN2/OeD4VmWSWxEPcEC4L4Da3nXqhiiGeJRp4nNvmhaa7WrWhEs7sMk8Mp9kqfnYZkeCKx54uFjr/pIxfqBbXT17rYrSKla0yDE18x5SG0J1CHQLPDiXtd8FA9t3Qf/7VnKSpD58jQY2I7sWbOVp8cRC/ohI/C0R6cQS3XM5VfxQ4LaOj0sy75h+4+y
 4Fzv3HfC
 dcj/FNchGJMnNd4SS2O8Qak4hjpUzTUfqIql8Lgx2dxMzEQa+mHGjEbHxuZUUG3tiCh1T/oE04CtZAH81xMifncaYBcv9oWinSCzSYKAyOkHt8mnz1IUFHnSPh+C7yWi2rlKQwWFaFKRAWCo4b7wG7i411DJrcl6AT2i6QXwhSnRB1og84GRSn+qnOd/jFHPp5ZoCqtMMVVdV7PpbunirNr/DvoK/+h0EIMe6ZDqo2exv6o29fLki+Ov0KLFIzU2YrhMAQ1gUiVbrOL6vJYDL16e8+oPNR5AelMs7nkDuATDz8VA9X2+3iwQsiRhwKRpLWj76/yxYXFW+wVnRa2mQuXcEBKyjnpEwPOo4gl+ypVs8x9jWV5gbyclb5+stAym/RWbn6Dr/vdKL2bFBH0zxWH2zZSZO4F2A+P9Yjobo7J7ywDbsDLZVbkdFEO8HjqmW0ARAq1L8CI1o+yD5ZkLGcB6P2x8GnJ9LjodlRcDzFXBvReCksVpdNr97Z4GNr6yLL7q+9eYIC4tOuJa14RnjN1wK30mKBoZ6dfMa07AmO93qtKgK3+xPoGX3RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 04:49:48PM -0700, Suren Baghdasaryan wrote:
> On Thu, May 28, 2026 at 8:17 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Sat, Apr 25, 2026 at 11:27:16PM -0700, Suren Baghdasaryan wrote:
> > > proc/pid/{smaps|numa_maps} can be read using the combination of RCU and
> > > VMA read locks, similar to proc/pid/maps. RCU is required to safely
> > > traverse the VMA tree and VMA lock stabilizes the VMA being processed
> > > and the pagetable walk.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Reviewed-by: Liam R. Howlett <liam@infradead.org>
> >
> > The logic LGTM, some nitty things below but in general:
> >
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Thanks!
>
> >
> > > ---
> > >  fs/proc/task_mmu.c | 195 ++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 156 insertions(+), 39 deletions(-)
> > >
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index 751b9ba160fb..1e3a15bf46f4 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -132,6 +132,22 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
> > >
> > >  #ifdef CONFIG_PER_VMA_LOCK
> > >
> > > +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >
> > NIT: But these inlines are unnecessary in a C file. At the kernel optimisation
> > level the compiler already decides whether to inline or not.
> >
> > However in the kernel we redefine this so we lose function tracing and also we
> > don't get warnings about unused functions [0], so this is actually a bit harmful
> > - you can end up with dead code and not know abou tit.
> >
> > Same goes for all the other static inline's in task_mmu.c.
>
> I see. There are a bunch of these small inline functions. Once the
> dust settles, I can clean them up. Dave's series and my folloup patch
> to change smaps_rollup will be changing this code. Maybe after all
> that is done?

Yeah that's fine this obviously isn't urgent! :) tiny nits really.

>
> >
> > [0]: https://elixir.bootlin.com/linux/v7.0.10/source/include/linux/compiler_types.h#L235
> >
> > > +{
> > > +     int ret = mmap_read_lock_killable(lock_ctx->mm);
> > > +
> > > +     if (!ret)
> > > +             lock_ctx->mmap_locked = true;
> > > +
> > > +     return ret;
> > > +}
> > > +
> > > +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > > +{
> > > +     mmap_read_unlock(lock_ctx->mm);
> > > +     lock_ctx->mmap_locked = false;
> > > +}
> > > +
> > >  static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> > >  {
> > >       lock_ctx->locked_vma = NULL;
> > > @@ -146,25 +162,11 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
> > >       }
> > >  }
> > >
> > > -static const struct seq_operations proc_pid_maps_op;
> > > -
> > >  static inline bool lock_vma_range(struct seq_file *m,
> > >                                 struct proc_maps_locking_ctx *lock_ctx)
> > >  {
> > > -     /*
> > > -      * smaps and numa_maps perform page table walk, therefore require
> > > -      * mmap_lock but maps can be read with locking just the vma and
> > > -      * walking the vma tree under rcu read protection.
> > > -      */
> > > -     if (m->op != &proc_pid_maps_op) {
> > > -             if (mmap_read_lock_killable(lock_ctx->mm))
> > > -                     return false;
> > > -
> > > -             lock_ctx->mmap_locked = true;
> > > -     } else {
> > > -             rcu_read_lock();
> > > -             reset_lock_ctx(lock_ctx);
> > > -     }
> > > +     rcu_read_lock();
> > > +     reset_lock_ctx(lock_ctx);
> > >
> > >       return true;
> > >  }
> > > @@ -172,7 +174,7 @@ static inline bool lock_vma_range(struct seq_file *m,
> > >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> > >  {
> > >       if (lock_ctx->mmap_locked) {
> > > -             mmap_read_unlock(lock_ctx->mm);
> > > +             unlock_ctx_mm(lock_ctx);
> > >       } else {
> > >               unlock_ctx_vma(lock_ctx);
> > >               rcu_read_unlock();
> > > @@ -213,17 +215,45 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> > >       return true;
> > >  }
> > >
> > > +static inline void drop_rcu(struct proc_maps_private *priv)
> > > +{
> > > +     if (priv->lock_ctx.mmap_locked)
> > > +             return;
> > > +
> > > +     rcu_read_unlock();
> > > +}
> > > +
> > > +static inline void reacquire_rcu(struct proc_maps_private *priv)
> > > +{
> > > +     if (priv->lock_ctx.mmap_locked)
> > > +             return;
> > > +
> > > +     rcu_read_lock();
> > > +     /* Reinitialize the iterator. */
> > > +     vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> >
> > OK good that we reset this :)
> >
> > > +}
> > > +
> > >  #else /* CONFIG_PER_VMA_LOCK */
> > >
> >
> > We need to pull out the patches from Dave's series and remove this option and
> > default VMA locks on by default :)
>
> I didn't see any followup after Dave posted his v1. I agree it would
> make things much simpler but I don't want to delay these changes too
> much.
> I'll ask Dave if he plans to continue his cleanup. If not, I'll pick it up.

Great thanks!

>
>
> >
> > > +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > > +{
> > > +     return mmap_read_lock_killable(lock_ctx->mm);
> > > +}
> > > +
> > > +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > > +{
> > > +     mmap_read_unlock(lock_ctx->mm);
> > > +}
> > > +
> > >  static inline bool lock_vma_range(struct seq_file *m,
> > >                                 struct proc_maps_locking_ctx *lock_ctx)
> > >  {
> > > -     return mmap_read_lock_killable(lock_ctx->mm) == 0;
> > > +     return lock_ctx_mm(lock_ctx) == 0;
> > >  }
> > >
> > >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> > >  {
> > > -     mmap_read_unlock(lock_ctx->mm);
> > > +     unlock_ctx_mm(lock_ctx);
> > >  }
> > >
> > >  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
> > > @@ -238,6 +268,9 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> > >       return false;
> > >  }
> > >
> > > +static inline void drop_rcu(struct proc_maps_private *priv) {}
> > > +static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> > > +
> > >  #endif /* CONFIG_PER_VMA_LOCK */
> > >
> > >  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
> > > @@ -538,12 +571,10 @@ static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> > >
> > >  static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> > >  {
> > > -     if (lock_ctx->mmap_locked) {
> > > -             mmap_read_unlock(lock_ctx->mm);
> > > -             lock_ctx->mmap_locked = false;
> > > -     } else {
> > > +     if (lock_ctx->mmap_locked)
> > > +             unlock_ctx_mm(lock_ctx);
> > > +     else
> > >               unlock_ctx_vma(lock_ctx);
> > > -     }
> > >  }
> > >
> > >  static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
> > > @@ -1280,21 +1311,75 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
> > >       .walk_lock              = PGWALK_RDLOCK,
> > >  };
> > >
> > > +#ifdef CONFIG_PER_VMA_LOCK
> > > +
> > > +static const struct mm_walk_ops smaps_walk_vma_lock_ops = {
> > > +     .pmd_entry              = smaps_pte_range,
> > > +     .hugetlb_entry          = smaps_hugetlb_range,
> > > +     .walk_lock              = PGWALK_VMA_RDLOCK_VERIFY,
> > > +};
> > > +
> > > +static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
> > > +     .pmd_entry              = smaps_pte_range,
> > > +     .hugetlb_entry          = smaps_hugetlb_range,
> > > +     .pte_hole               = smaps_pte_hole,
> > > +     .walk_lock              = PGWALK_VMA_RDLOCK_VERIFY,
> > > +};
> > > +
> > > +static inline const struct mm_walk_ops *
> > > +get_smaps_walk_ops(struct proc_maps_private *priv)
> > > +{
> > > +     if (priv->lock_ctx.mmap_locked)
> > > +             return &smaps_walk_ops;
> > > +     return &smaps_walk_vma_lock_ops;
> > > +}
> > > +
> > > +static inline const struct mm_walk_ops *
> > > +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > > +{
> > > +     if (priv->lock_ctx.mmap_locked)
> > > +             return  &smaps_shmem_walk_ops;
> > > +     return &smaps_shmem_walk_vma_lock_ops;
> > > +}
> > > +
> > > +#else /* CONFIG_PER_VMA_LOCK */
> > > +
> > > +static inline const struct mm_walk_ops *
> > > +get_smaps_walk_ops(struct proc_maps_private *priv)
> > > +{
> > > +     return &smaps_walk_ops;
> > > +}
> > > +
> > > +static inline const struct mm_walk_ops *
> > > +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > > +{
> > > +     return &smaps_shmem_walk_ops;
> > > +}
> > > +
> > > +#endif /* CONFIG_PER_VMA_LOCK */
> > > +
> > >  /*
> > >   * Gather mem stats from @vma with the indicated beginning
> > >   * address @start, and keep them in @mss.
> > >   *
> > >   * Use vm_start of @vma as the beginning address if @start is 0.
> > >   */
> > > -static void smap_gather_stats(struct vm_area_struct *vma,
> > > -             struct mem_size_stats *mss, unsigned long start)
> > > +static void smap_gather_stats(struct proc_maps_private *priv,
> > > +                           struct vm_area_struct *vma,
> > > +                           struct mem_size_stats *mss, unsigned long start)
> > >  {
> > > -     const struct mm_walk_ops *ops = &smaps_walk_ops;
> > > +     const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> > >
> > >       /* Invalid start */
> > >       if (start >= vma->vm_end)
> > >               return;
> > >
> > > +     if (vma == get_gate_vma(priv->lock_ctx.mm))
> > > +             return;
> > > +
> > > +     /* Might sleep. Drop RCU read lock but keep the VMA locked. */
> > > +     drop_rcu(priv);
> > > +
> > >       if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> > >               /*
> > >                * For shared or readonly shmem mappings we know that all
> > > @@ -1312,15 +1397,16 @@ static void smap_gather_stats(struct vm_area_struct *vma,
> > >                                       !(vma->vm_flags & VM_WRITE))) {
> > >                       mss->swap += shmem_swapped;
> > >               } else {
> > > -                     ops = &smaps_shmem_walk_ops;
> > > +                     ops = get_smaps_shmem_walk_ops(priv);
> > >               }
> > >       }
> > >
> > > -     /* mmap_lock is held in m_start */
> > >       if (!start)
> > >               walk_page_vma(vma, ops, mss);
> > >       else
> > >               walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> > > +
> > > +     reacquire_rcu(priv);
> >
> > OK I was going to say that this RCU lock dance is a bit iffy, but I see
> > that we're sharing code such that this is necessary.
> >
> > >  }
> > >
> > >  #define SEQ_PUT_DEC(str, val) \
> > > @@ -1369,10 +1455,11 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
> > >
> > >  static int show_smap(struct seq_file *m, void *v)
> > >  {
> > > +     struct proc_maps_private *priv = m->private;
> > >       struct vm_area_struct *vma = v;
> > >       struct mem_size_stats mss = {};
> > >
> > > -     smap_gather_stats(vma, &mss, 0);
> > > +     smap_gather_stats(priv, vma, &mss, 0);
> > >
> > >       show_map_vma(m, vma);
> > >
> > > @@ -1413,7 +1500,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >               goto out_put_task;
> > >       }
> > >
> > > -     ret = mmap_read_lock_killable(mm);
> > > +     ret = lock_ctx_mm(&priv->lock_ctx);
> > >       if (ret)
> > >               goto out_put_mm;
> > >
> > > @@ -1425,7 +1512,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >
> > >       vma_start = vma->vm_start;
> > >       do {
> > > -             smap_gather_stats(vma, &mss, 0);
> > > +             smap_gather_stats(priv, vma, &mss, 0);
> > >               last_vma_end = vma->vm_end;
> > >
> > >               /*
> > > @@ -1434,8 +1521,8 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >                */
> > >               if (mmap_lock_is_contended(mm)) {
> > >                       vma_iter_invalidate(&vmi);
> > > -                     mmap_read_unlock(mm);
> > > -                     ret = mmap_read_lock_killable(mm);
> > > +                     unlock_ctx_mm(&priv->lock_ctx);
> > > +                     ret = lock_ctx_mm(&priv->lock_ctx);
> > >                       if (ret) {
> > >                               release_task_mempolicy(priv);
> > >                               goto out_put_mm;
> > > @@ -1484,14 +1571,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >
> > >                       /* Case 1 and 2 above */
> > >                       if (vma->vm_start >= last_vma_end) {
> > > -                             smap_gather_stats(vma, &mss, 0);
> > > +                             smap_gather_stats(priv, vma, &mss, 0);
> > >                               last_vma_end = vma->vm_end;
> > >                               continue;
> > >                       }
> > >
> > >                       /* Case 4 above */
> > >                       if (vma->vm_end > last_vma_end) {
> > > -                             smap_gather_stats(vma, &mss, last_vma_end);
> > > +                             smap_gather_stats(priv, vma, &mss, last_vma_end);
> > >                               last_vma_end = vma->vm_end;
> > >                       }
> > >               }
> > > @@ -1505,7 +1592,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >       __show_smap(m, &mss, true);
> > >
> > >       release_task_mempolicy(priv);
> > > -     mmap_read_unlock(mm);
> > > +     unlock_ctx_mm(&priv->lock_ctx);
> > >
> > >  out_put_mm:
> > >       mmput(mm);
> > > @@ -3291,6 +3378,31 @@ static const struct mm_walk_ops show_numa_ops = {
> > >       .walk_lock = PGWALK_RDLOCK,
> > >  };
> > >
> > > +#ifdef CONFIG_PER_VMA_LOCK
> > > +static const struct mm_walk_ops show_numa_vma_lock_ops = {
> > > +     .hugetlb_entry = gather_hugetlb_stats,
> > > +     .pmd_entry = gather_pte_stats,
> > > +     .walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
> > > +};
> > > +
> > > +static inline const struct mm_walk_ops *
> > > +get_show_numa_ops(struct proc_maps_private *priv)
> > > +{
> > > +     if (priv->lock_ctx.mmap_locked)
> > > +             return &show_numa_ops;
> > > +     return &show_numa_vma_lock_ops;
> > > +}
> > > +
> > > +#else /* CONFIG_PER_VMA_LOCK */
> > > +
> > > +static inline const struct mm_walk_ops *
> > > +get_show_numa_ops(struct proc_maps_private *priv)
> > > +{
> > > +     return &show_numa_ops;
> > > +}
> > > +
> > > +#endif /* CONFIG_PER_VMA_LOCK */
> > > +
> > >  /*
> > >   * Display pages allocated per node and memory policy via /proc.
> > >   */
> > > @@ -3335,8 +3447,13 @@ static int show_numa_map(struct seq_file *m, void *v)
> > >       if (is_vm_hugetlb_page(vma))
> > >               seq_puts(m, " huge");
> > >
> > > -     /* mmap_lock is held by m_start */
> > > -     walk_page_vma(vma, &show_numa_ops, md);
> > > +     /* Skip walking pages if gate VMA */
> > > +     if (vma != get_gate_vma(proc_priv->lock_ctx.mm)) {
> > > +             /* Might sleep. Drop RCU read lock but keep the VMA locked. */
> > > +             drop_rcu(proc_priv);
> > > +             walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
> > > +             reacquire_rcu(proc_priv);
> > > +     }
> > >
> > >       if (!md->pages)
> > >               goto out;
> > > --
> > > 2.54.0.545.g6539524ca2-goog
> > >

