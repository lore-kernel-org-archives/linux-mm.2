Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E57CCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E476B0088; Wed, 10 Jun 2026 03:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7B86B008A; Wed, 10 Jun 2026 03:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F416B008C; Wed, 10 Jun 2026 03:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B26D96B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:05:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5880D1A0893
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:05:42 +0000 (UTC)
X-FDA: 84863117724.08.BFC08D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9201B2000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:05:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eS77paJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781075140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6mN/g5BT5iHzCmQaxkco8KHpTiQWAtdgD7vgOhTo8A=;
	b=k/4SrlrwDkarQGPSqaQ7ZpyKS93T0U8oWmcjCaW3GTSnJ2msDzAcGKNjSc4VjruuGU7abl
	+Qz+kSet3vJRri2ZPUqZ8rbj2A9csZr3YFTh0255cbpxNorpYPGJ7KgIN+fU9iopUYa9/R
	ubm86h3LZWt7QQRs+D8rih8usHnpuwo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eS77paJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781075140;
	b=Np079e60cY4/gHMcJIapDEfgs8G4QOUMk/YuonR9yCBB9xdhjovUBJjyp5uHqxndwDtrhm
	z+tu91lAmyCl+C0NErctTlxck8Z0g/L46cIbjoi3UMwDtyD4Wt/T67H6U7xlZbb+kHCPCI
	fZ95+TxkIwezKOkaVwZtPSYHypyqJbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81C3A4024E;
	Wed, 10 Jun 2026 07:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252871F00893;
	Wed, 10 Jun 2026 07:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781075139;
	bh=F6mN/g5BT5iHzCmQaxkco8KHpTiQWAtdgD7vgOhTo8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eS77paJX+kjsQpdW8p0Kf9F6thV2td8zsgOmce1O4jsc/FDlNYyZjJtnvuTp1cJ4s
	 PYWtWUQ2EkfQblAUA3kousIhmCHO4gLDwWS9kH07iwboGRgAAworpvCkB+zQ+i6ewg
	 VhyNqW7a51iIYTDmMGVKRScAPq8L5KxpUUIYAw3hmxJzrdX1iXx21LL4ZQym7xR3gf
	 /0p8gEEpZTKnE3MO3muAw4ozO9HYjvDb5lfLW0XEwMoWcjaM/xZRnrOkBR8oPSNXq4
	 CU/crwsQpMEjr/8O14D+U1HcAwJFmuPmPw9vrTDF2xAfdPaLMNVGQYWpSoPTfewipA
	 PiZcAsc/9LOJw==
Date: Wed, 10 Jun 2026 08:05:32 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
Message-ID: <aikLCwuzqBetvDrf@lucifer>
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com>
 <aifO_rCurVhFRTcl@lucifer>
 <CAJuCfpFOpvNmV4aHnk3Vi0Jg4vF4Cmsm86h2vODZ84FVLXt9yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFOpvNmV4aHnk3Vi0Jg4vF4Cmsm86h2vODZ84FVLXt9yw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9201B2000B
X-Stat-Signature: rs5b5ct46jyk6uzzutmjbxhaya3tjxx1
X-HE-Tag: 1781075140-424594
X-HE-Meta: U2FsdGVkX1+c3MLmxs6vqoa0FuSHulPdi5rPbkcrI2cgtL5k9U7PGoiPjdwCwRDLl2SUAwRJniUz/oOIHxA+RXdYgZNx+6ml39OPmirVexWOiv/MPSBg9hhTSs0zorAT6W4/GLG/h7Npopgc6EIWFPuUOSOf/zWSDAsFe8QDCazxsPpYbguvMX0284UnUPcAFMS1ThPw5wC8wpBVIygFBmaq071eCX88V+1Q4lusBqLmeIqM2Cpb9/xxbg7b126b4nCrZcFs2/cI7SzFuFbLPBARecIAeiDy8gzeimOaLv6olK8rkPa8TDm00wUGaoMZlkP/PEjizVxFnViZ14XDyYd3va1+ONI0Bk0MOSHqvuB8BPQKp9kd7lgTXYWEjdhzmCMKGcENv/E4k/Um8WUilc9k5wPGgiGJeBc1BhsuTC6fAJJNKGRKkRD0G+gcqjnaiOO8tP4h5ZzKgXKWrOMPgH7mZ3qngRE1wZjpdELQFO5gti8hF5R2TVND5r6AwOQiez/b8Ff56+6c74phvDzdTyDxXS0sL+DmVL791iPE1YakxR7hQsxSKhKFmKGdOMJYiNNussjdt2cNt5PQ1RE7FOV8ezqqdU7jckiI2AmYR4MIHRjLnFKS5qU3/V5j8O1O2Am4I2goRI7DpDpzAIX0+nYlcYEtPfbvpEm8yDlUwCM1wgtQIOlnkgk+th3laU96D8WTxqZVz108wSvILfpMpspMrNuxwnKw+RgcEXGhVwwjXjNT7ABlAoJehFB4mALHDdU3S7R65M2JbLleItjvVNx+/c/kEdaMeyVtBWBkt9QLX31gUiDZX+/+BPkjNljOP95aenpUqgT4QRBQKkMAbfjk/g4ocO+Bsdx5hHTftGUlcMu9zhIYvTsES4KLS1Ht6BFnPdhtyu9Bev1Xsn31k/Vfe/A0fhhVponsMz17/KaVhd2c/bA81Y4n9irWewj/SwUV24GeRyqiMmgEW64
 VBTOpnYO
 vD8uCUNndWBXPKHmcJYFWAXd0PxLFmGiiwmm6Y/vlSHWkllvRoQbVFzrgZ7ZA1iE2z4sxUE6VGnvRlCFAFHndVpd+viqMXDqFJJ6ezQo58euHNCR8ShDs2o+PH0Lq6kqoheTzMEXUPMJAQ9Q140QbV1wQVTnwLW5fiqfKsaUn3SjqhDnCv4YXuat/gJLwN5hJQOHJ2cz/Gm+OyODREkpNRmPSFPk6rXMQK96jlGINUWfLrTyyjEuSBXvYs7mE5IfD+ev7ZiCQAumtyjVFjjvVrcM75xKKALYW1nhur77IqzqpS6DDKO0GbffBXe/NBCzaiXqJjeuvyktQVUt69/GB+RZW7gixv0HRTJJdQLTiAnZlRnTTd5OYHLA6Ux2vThol7rPmMuWVJGO7rAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 10:11:03AM -0700, Suren Baghdasaryan wrote:
> On Tue, Jun 9, 2026 at 3:00 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Fri, Jun 05, 2026 at 06:57:29PM -0700, Suren Baghdasaryan wrote:
> > > proc/pid/smaps_rollup can be read using the combination of RCU and
> > > VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> > > required to safely traverse the VMA tree and VMA lock stabilizes the
> > > VMA being processed and the pagetable walk.
> > > Note that we have to keep the logic to drop mmap_lock on contention
> > > because even when using per-VMA locks we might have to fall back to
> > > holding the mmap_lock.
> > >
> > > Running Paul's contention benchmark [1] shows considerable improvement
> > > both in median and in the worst case latencies:
> > >
> > > Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> > > --busyduration 2 --procfile smaps_rollup
> > >
> > > Baseline:
> > >
> > >     0.174     0.161     2.553
> > >     0.174     0.164     2.663
> > >     0.174     0.165     2.664
> > >     0.174     0.166     2.679
> > >     0.174     0.167     2.691
> > >     0.174     0.168     2.704
> > >     0.174     0.169     2.729
> > >     0.174     0.172     2.741
> > >     0.174     0.174     2.745
> > >     0.174     0.174     2.755
> > >     0.174     0.175     2.790
> > >     0.174     0.177     2.809
> > >     0.174     0.179     3.096
> > >     0.174     0.183     3.144
> > >     0.174     0.184     3.158
> > >     0.174     0.185     3.175
> > >     0.174     0.185     4.568
> > >     0.174     0.198     4.821
> > >     0.174     0.214     5.143
> > >     0.174     0.251     5.220
> > >
> > > Patched:
> > >
> > >     0.007     0.007     1.952
> > >     0.007     0.007     1.955
> > >     0.007     0.007     1.955
> > >     0.007     0.007     1.955
> > >     0.007     0.007     1.957
> > >     0.007     0.007     1.969
> > >     0.007     0.007     2.065
> > >     0.007     0.007     2.075
> > >     0.007     0.007     2.146
> > >     0.007     0.007     2.195
> > >     0.007     0.007     2.223
> > >     0.007     0.007     2.259
> > >     0.007     0.007     2.488
> > >     0.007     0.007     2.562
> > >     0.007     0.007     2.599
> > >     0.007     0.007     2.697
> > >     0.007     0.007     3.030
> > >     0.007     0.007     3.075
> > >     0.007     0.007     3.145
> > >     0.007     0.007     3.225
> >
> > Ohhh lovely!
> >
> > >
> > > [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Having looked through it carefully the logic looks correct to me, but I
> > think we can improve how this is implemented, so attach a patch with my
> > suggestions folded up to make life easier!
> >
> > > ---
> > >  fs/proc/task_mmu.c | 134 ++++++++++++++++++++-------------------------
> > >  1 file changed, 59 insertions(+), 75 deletions(-)
> > >
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index 023422fcee12..c2bd9f5bbbcd 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -233,6 +233,16 @@ static inline void reacquire_rcu(struct proc_maps_private *priv)
> > >       vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> > >  }
> > >
> > > +static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
> >
> > Hmm seems David and I are saying the same things :) but yeah this name being
> > very close to mmap_lock_is_contended() is suboptimal.
> >
> > Also the inline is pointless here and suppresses the compiler unused check which
> > isn't helpful.
>
> Ack.
>
> >
> > But in general, given we already have the lock context I think we can do away
> > with this altogether, see below.
> >
> >
> > > +{
> > > +     struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> > > +
> > > +     if (!lock_ctx->mmap_locked)
> > > +             return false;
> > > +
> > > +     return !!mmap_lock_is_contended(lock_ctx->mm);
> >
> > As David said, !! is not a necessary incantation any more :)
>
> Ack.
>
> >
> > > +}
> > > +
> > >  #else /* CONFIG_PER_VMA_LOCK */
> > >
> > >  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > > @@ -268,6 +278,11 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> > >       return false;
> > >  }
> > >
> > > +static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
> > > +{
> > > +     return !!mmap_lock_is_contended(priv->lock_ctx.mm);
> >
> > Similarly. But also as above I don't think we need this.
>
> Sadly, for now we do (see my later comment).
>
> >
> > > +}
> > > +
> > >  static inline void drop_rcu(struct proc_maps_private *priv) {}
> > >  static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> > >
> > > @@ -1486,12 +1501,15 @@ static int show_smap(struct seq_file *m, void *v)
> > >  static int show_smaps_rollup(struct seq_file *m, void *v)
> > >  {
> > >       struct proc_maps_private *priv = m->private;
> > > +     struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> > > +     struct mm_struct *mm = lock_ctx->mm;
> > >       struct mem_size_stats mss = {};
> > > -     struct mm_struct *mm = priv->lock_ctx.mm;
> > >       struct vm_area_struct *vma;
> > > -     unsigned long vma_start = 0, last_vma_end = 0;
> > > +     unsigned long vma_start = 0;
> > > +     unsigned long last_vma_end = 0;
> >
> > I mean I kinda prefer these separate but obviously not necessary :P
>
> It looked nicer I think :)

Yeah tbh I think you're right

>
> >
> > > +     loff_t pos = 0;
> > >       int ret = 0;
> > > -     VMA_ITERATOR(vmi, mm, 0);
> > > +
> >
> > Yeah extra line as David said :)
>
> Ack.
>
> >
> > >
> > >       priv->task = get_proc_task(priv->inode);
> > >       if (!priv->task)
> > > @@ -1502,89 +1520,55 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >               goto out_put_task;
> > >       }
> > >
> > > -     ret = lock_ctx_mm(&priv->lock_ctx);
> > > +     hold_task_mempolicy(priv);
> > > +     ret = lock_vma_range(m, lock_ctx);
> > >       if (ret)
> > >               goto out_put_mm;
> > >
> > > -     hold_task_mempolicy(priv);
> > > -     vma = vma_next(&vmi);
> > > -
> > > -     if (unlikely(!vma))
> > > +     vma_iter_init(&priv->iter, mm, 0);
> > > +     vma = proc_get_vma(m, &pos);
> > > +     if (unlikely(!vma) || vma == get_gate_vma(priv->lock_ctx.mm))
> > >               goto empty_set;
> >
> > Is the gate VMA check here necessary? We already check it in the loop.
>
> We need it to avoid resetting vma_start, which is being reported even
> when no normal VMAs are present.

Well previously smap_gather_stats() would just be a no-op for a gate VMA, as it
has:

	if (vma == get_gate_vma(priv->lock_ctx.mm))
		return;

Not sure if you'd have VMAs past that (is that even possible?) but in that case
we would have set vma_start previously.

>
> >
> > >
> > > +     if (IS_ERR(vma)) {
> > > +             ret = PTR_ERR(vma);
> > > +             goto out_unlock;
> > > +     }
> >
> > Again this is duplicated.
> >
> > > +
> > >       vma_start = vma->vm_start;
> >
> > Could just drop the gate check, and replace this with:
> >
> >         vma_start = IS_ERR(vma) ? 0 : vma->vm_start;
>
> Yeah, that would work. I don't have a strong preference but avoiding
> the loop on error seemed cleaner to me. Will change.
>
> >
> > > -     do {
> > > -             smap_gather_stats(priv, vma, &mss, 0);
> > > +     while (vma) {
> > > +             if (IS_ERR(vma)) {
> > > +                     ret = PTR_ERR(vma);
> > > +                     goto out_unlock;
> > > +             }
> > > +
> > > +             if (vma == get_gate_vma(priv->lock_ctx.mm))
> > > +                     break;
> > > +
> > > +             /*
> > > +              * If after retaking mmap_lock, already reported VMA grew or
> > > +              * merged with the next one, then iterate from last_vma_end.
> > > +              */
> >
> > Hmm, but if the already reported VMA grew, vma->vm_start would not be <
> > last_vma_end would it?
>
> The scenario is: we reported the VMA before it grew, we set
> last_vma_end to its vm_end then dropped the lock. Later after VMA grew
> we searched past the last_vma_end and found the same VMA because now
> it spans past last_vma_end. In this case vma->vm_start will be less
> than last_vma_end and I think this would happen either if the VMA grew
> or got merged with its upper neighbor.

OK yeah, I was thinking in terms of 2 adjacent VMAs, but in that case a 'grow'
is a merge, so it's either merge or grew into unmapped space.

>
> >
> > So surely this is only covering the merge case?
> >
> > > +             smap_gather_stats(priv, vma, &mss,
> > > +                               vma->vm_start < last_vma_end ? last_vma_end : 0);
> >
> > I don't love how compressed this is.
> >
> > I also don't love that 0 is taken to be 'start from vma->vm_start' and I
> > also don't love that the code in smap_gather_stats() actually special cases
> > this...
> >
> > How about passing last_vma_end and making smap_gather_stats() more sane? In
> > the other invocation of smap_gather_stats() we could pass vma->vm_start
> > here.
> >
> > We can then move the comment into smap_gather_stats(). E.g.:
> >
> >                 /* Handles the case of VMA merged since mmap locked drop too. */
> >                 smap_gather_stats(priv, vma, &mss, last_vma_end);
> >
> > To make life easier I put all of my suggestions into a patch which I've
> > attached :) (though it is untested) let me know what you think.
>
> I was trying to minimize changes to the current logic but that would
> be cleaner. I think it would be better to make this logical change as
> a separate prerequisite patch. If you agree then I'll do that in my
> next version.

Yeah makes sense, thanks!

>
> >
> >
> > >               last_vma_end = vma->vm_end;
> > >
> > >               /*
> > >                * Release mmap_lock temporarily if someone wants to
> > > -              * access it for write request.
> > > +              * take it for write request.
> >
> > I think this is better rewritten to reflect the changes. E.g.:
> >
> >                 /*
> >                  * If the VMA lock is not taken, we hold the often contended
> >                  * mmap lock. This can be because the arch doesn't support VMA
> >                  * locks,or we had to fall back to the mmap lock.
>
> I intend to postpone this patchset until after Dave's patchset lands
> into mm-unstable, so this "arch doesn't support VMA locks" part will
> not be there, but othereise SGTM.

Yeah that'd be neater, be good to eliminate all the !CONFIG_PER_VMA_LOCK stuff.

>
> >                  *
> >                  * To relieve pressure, check if it is indeed contended, then
> >                  * temporarily release it.
> >                  */
> >
> > >                */
> > > -             if (mmap_lock_is_contended(mm)) {
> > > -                     vma_iter_invalidate(&vmi);
> > > -                     unlock_ctx_mm(&priv->lock_ctx);
> > > -                     ret = lock_ctx_mm(&priv->lock_ctx);
> > > -                     if (ret) {
> > > -                             release_task_mempolicy(priv);
> > > +             if (is_mmap_lock_contended(priv)) {
> >
> > We have both mm and lock_ctx already.
> >
> > So we could instead do:
> >
> >                 if (lock_ctx->mmap_locked && mmap_lock_is_contended(mm)) {
> >                         ...
> >
> > Right?
>
> Unfortunately not. If you look at the struct proc_maps_locking_ctx
> definition, mmap_locked will not be there if CONFIG_PER_VMA_LOCK=n.

Ugh. We probably shouldn't have bothered making that conditional :>)

> That's why I have to introduce versions of is_mmap_lock_contended()
> for both CONFIG_PER_VMA_LOCK and !CONFIG_PER_VMA_LOCK configs. And
> that's why I'm leaning towards waiting for Dave's cleanup to be posted
> which will eliminate CONFIG_PER_VMA_LOCK. It will clean up many other
> similar helpers in this file.

Yeah that simplifies everything.

>
> I just realized I did not CC Dave to this series before, so adding him now.
>
> >
> > > +                     unlock_vma_range(&priv->lock_ctx);
> >
> > OK this confuses me - we're gated on lock_ctx->mmap_locked, so this is exactly
> > the same as unlock_ctx_mm(lock_ctx) right?
> >
> > There's no situation here where the VMA lock would be unlocked.
> >
> > Surely it'd therefore be clearer to just call unlock_ctx_mm(lock_ctx)
> > direct?
>
> Technically yes but one thing I forgot to do here is to remove the
> lock_ctx_mm()/unlock_ctx_mm() helpers because after this change there
> are no direct users for them.

OK, but we do need to make this situation clear as otherwise it's
confusing. Maybe just move to calling unlock_vma_range() unlock_range() or
something?

>
> >
> > > +                     ret = lock_vma_range(m, lock_ctx);
> > > +                     if (ret)
> > >                               goto out_put_mm;
> >
> >
> > In the case of VMA locks being supported, but we fell back to mmap locks, this
> > seems to just be getting us back to the invariant that the RCU read lock is
> > held.
> >
> > However, it's a bit confusing given we're explicitly checking for the
> > mmap_locked case, so I think it's worth a comment explaining that we might have
> > fallen back to mmap lock, but could still get the VMA lock on the next VMA.
> >
> > E.g.:
> >
> >         /*
> >          * If we are using VMA locks but fell back to an mmap lock, we may
> >          * be able to VMA lock the next VMA, so reset the lock and try again.
> >          *
> >          * Otherwise, if the arch doesn't support VMA locks, this simply
> >          * retakes the mmap lock.
> >          */
>
> Yeah, I can see now that this case is quite confusing and needs more
> comments. Will do in the next rev.

Thanks

>
> >
> >
> > > -                     }
> > > -
> > > -                     /*
> > > -                      * After dropping the lock, there are four cases to
> > > -                      * consider. See the following example for explanation.
> > > -                      *
> > > -                      *   +------+------+-----------+
> > > -                      *   | VMA1 | VMA2 | VMA3      |
> > > -                      *   +------+------+-----------+
> > > -                      *   |      |      |           |
> > > -                      *  4k     8k     16k         400k
> > > -                      *
> > > -                      * Suppose we drop the lock after reading VMA2 due to
> > > -                      * contention, then we get:
> > > -                      *
> > > -                      *      last_vma_end = 16k
> > > -                      *
> > > -                      * 1) VMA2 is freed, but VMA3 exists:
> > > -                      *
> > > -                      *    vma_next(vmi) will return VMA3.
> > > -                      *    In this case, just continue from VMA3.
> > > -                      *
> > > -                      * 2) VMA2 still exists:
> > > -                      *
> > > -                      *    vma_next(vmi) will return VMA3.
> > > -                      *    In this case, just continue from VMA3.
> > > -                      *
> > > -                      * 3) No more VMAs can be found:
> > > -                      *
> > > -                      *    vma_next(vmi) will return NULL.
> > > -                      *    No more things to do, just break.
> > > -                      *
> > > -                      * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
> > > -                      *
> > > -                      *    vma_next(vmi) will return VMA' whose range
> > > -                      *    contains last_vma_end.
> > > -                      *    Iterate VMA' from last_vma_end.
> > > -                      */
> > > -                     vma = vma_next(&vmi);
> > > -                     /* Case 3 above */
> > > -                     if (!vma)
> > > -                             break;
> > > -
> > > -                     /* Case 1 and 2 above */
> > > -                     if (vma->vm_start >= last_vma_end) {
> > > -                             smap_gather_stats(priv, vma, &mss, 0);
> > > -                             last_vma_end = vma->vm_end;
> > > -                             continue;
> > > -                     }
> > >
> > > -                     /* Case 4 above */
> > > -                     if (vma->vm_end > last_vma_end) {
> > > -                             smap_gather_stats(priv, vma, &mss, last_vma_end);
> > > -                             last_vma_end = vma->vm_end;
> > > -                     }
> >
> > OK so you're rolling all this up into the 'if after retaking mmap_lock'
> > bit.
>
> Yep, because Cases 1-3 and quite natural. Case 4 is the only "special"
> case here IMO, so we handle it separately with separate comments
> added.

Yeah.

>
> >
> > I don't love that we're losing this information, but also it's maybe a
> > little more than we need here and it's making
> >
> > But perhaps could we transfer this into the commit message as a
> > later-findable justification?
>
> Sure, that I can do.

Thanks!

>
> >
> > > +                     /* Resume from the last position. */
> > > +                     pos = last_vma_end;
> > > +                     vma_iter_init(&priv->iter, mm, pos);
> > >               }
> > > -     } for_each_vma(vmi, vma);
> > > +             vma = proc_get_vma(m, &pos);
> > > +     }
> > >
> > >  empty_set:
> > >       show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
> > > @@ -1593,10 +1577,10 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >
> > >       __show_smap(m, &mss, true);
> > >
> > > -     release_task_mempolicy(priv);
> > > -     unlock_ctx_mm(&priv->lock_ctx);
> > > -
> > > +out_unlock:
> > > +     unlock_vma_range(&priv->lock_ctx);
> > >  out_put_mm:
> > > +     release_task_mempolicy(priv);
> >
> > Previously this was done under the mmap lock, now it's not. I don't think
> > this should be an issue but just highlighting.
>
> Yeah, I looked into that but found no evidence that it's a problem. If
> anyone knows otherwise please let me know.
>
> Thanks for the review, Lorenzo! Much appreciated.

No problem! Thanks for the patch :)

Cheers, Lorenzo

