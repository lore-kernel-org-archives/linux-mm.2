Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 263BBEF9014
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C806B009F; Wed,  4 Mar 2026 11:58:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D96D6B00A0; Wed,  4 Mar 2026 11:58:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5466B00A1; Wed,  4 Mar 2026 11:58:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1D56B009F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:58:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1CE1BA17E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:58:33 +0000 (UTC)
X-FDA: 84508989306.03.796F484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 15D684000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:58:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LE39/pb7";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTRiBmtioRmvl45WVMSHIEfgjr5Fv3KMawEauwx9ciI=;
	b=gFBIr6D/M9iqr10WjeXAyKZWVOvHFh5Tf7lv1DBXgsCljgDmQZ96JVixmqnk8BCzAP/JHf
	pChHEddM3psZIL1wT02u7fIQWUhNhEVs1W5nfhGnxr3R3iMbvc0PxJaw4bROrFWcJEQ5Ql
	z/7AEry4ZAGN7BVx/SRcIhICRm/7mhk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LE39/pb7";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643512; a=rsa-sha256;
	cv=none;
	b=8QY4HZ5G4gFS5aJXlba13UQduhTbZCWgKu7CQyfNTn0GusPhLQHUBD0V1TCXa8uFMOpNkj
	Vbd8YU03x3bqm/84lNqxfT0Jr8ym6cxCqS9waXuyzfbZX7Qx+KHwhcup2EEsql+Zd6GZuI
	aX6g5rcTjhWCabNMiqicsnFjU9r/Lm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 118D2444CB;
	Wed,  4 Mar 2026 16:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506DAC2BC87;
	Wed,  4 Mar 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772643510;
	bh=gt8PqqovFf1xLv4Q1zVMfYqYqUK+EQak4A80Hc02NSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LE39/pb7RAXXwTk/mO6o0YD6l/cJEy06Z7h9wmDYPF0vzF96PCX1vxT/dVeD0yVen
	 flpPxEgM8VbsEJseiAcr5h93ppXp+39Rm3wfGgoW96u812DuLAcCDud9UGBiKa9UGV
	 GMKh+UPgO4HVRyZOefc10YdzRFG4R6yY/DtZdVbD2mffN0kB2flzFUfyFdGmG/dRcC
	 YjRBJ2pD24GGvbkaGYriHDmS5BjdlgV51L3irEmEiLhB19/ssE6lg7LRIbF+QIPrru
	 uzPgIRDr2PNuSWqrRpXSKUmqvPPeL0RBbYudyrtxV7IxIJjPex2gHSaJOGpEH527vv
	 W+suMeggt8Bqw==
Date: Wed, 4 Mar 2026 16:58:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <50987b7f-39ec-479d-9700-317cb0b95e6e@lucifer.local>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-4-surenb@google.com>
 <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
 <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15D684000B
X-Rspamd-Server: rspam08
X-Stat-Signature: 35xm4pcunfq5r98j86wdpjj4ymc1kcm6
X-HE-Tag: 1772643511-449194
X-HE-Meta: U2FsdGVkX1/7L7iOOFwlDc8nF7E7CAbit6dJaW8xmBCua6Cvn9rVa7AjdSTQWyklwmTaOGrNahicMeihz301vczQPda4JcNWTxHXQpUfRvuxcg2zqaCgfrzCvt64G46mkZUCl1g859lI0LJ2ZyxOvEP4NTD23qHSPNY2+YT6aUh7L/g6N5yPKsXoOlJWWx7K+aGInqB7eBOjuch9Q6HqpVlMI4bcS8wqzeiPw7zh964ym68HDk8a9ABWDNsrNYrRRuQr1Iu2PESommABhr/H0eKP7MP9X8d5k0utrjsKSc7ASfVgV+LeYtIbEnyjo42VUKlxXDJcziePeaVlqyIOm0uCNCLvns9qzQy2jYlNSIVKHda4oCpBGHnpPHHuT6F3Q/POcjcunhl6NpfKRdGqglk2wsdZd7Bj49pFSNqkfZE9HJcBLLEzP/Lhq2RySYKXEhfGshC9VbIsU4z4HAuD6SWWHlvoc95K6C2/eZ5wwUEPLXFcjuyU3oAaN1zdS8qATmhPhPlvo5XsePFqFd8L3Gl+CAkXVjCegPOWLTd7jLPe9RTIMR2Nyd9foOn3jK3rLqMiYL2f5zjlJL8ZvywIcb5xCwLR2sG0Kk16YTpqmNrmXq8oLEJ+8HSvkq4lQnYGcQBF+yZy/VYtocioBLcwO1TXbeywzjiWbOBoR4kjE+XVwLihvB6Mr8I5346YLhD0s71frcVZNNnyeWqI2stjpESmiNAVebP1HDxIvEfgsJwABev3g68UI1zvw81tWXf4BMUSuhOgGyN+PiwFYtMmhaa9NDLKyR6NjGflDlxH0T/hUvoYb3nLLvOJpIY19JhCVjZLtx13fFIhn+rimzLkRdqPEJbKNzoLflvzgR3AphUTmVxJXO+kRA7sESzkwufog71jZcL1GowoVl3IVdr9ez7WZ12AJffFxjODgHBHiZw2lEaDBPHriTVx+jxpPQTxGpfAXzf0Y05Z3Gaw2SZ
 p8FwU0cB
 KWoLS3cg9I2H5yHSaVcJj4OaY/ZiLoeE1LyoeFAAZSo2ov2QA80VcAEMNIneiNta7ix9ejvYHRCWF10so70aSKBTDbmcNjiaqeFN0Al/5mg7dtFG1HzcGfWl+eUSQfCPJSwwYGNQ1hR0uiGh/ieFlHxylQTrzXZ4U/bYC6ibsTYiTmneTV8iGYXTt7BJawg9GSffWIQ0MVZfmdtyAiSQkt0uXFthcWWpJZoGbdmWeUgdr+CPaK3FlI46oGL6BI7yC0w57YOk4xJtsE/IhHebg1WgVBPHLy5gSWXbfE2nN72AvDuu83QBEYc9a915EmdXIPFVKAnXFAHsqHkFmLuyW7ZpVtUb1hyDluAJ6/xR5KONW1RH94HVb83fBmibT+qih44LB4u1R9mPEuL49hmmU9LoFOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 03:59:17PM -0800, Suren Baghdasaryan wrote:
> On Mon, Mar 2, 2026 at 7:25 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> > > Replace vma_start_write() with vma_start_write_killable() when
> > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > Adjust its direct and indirect users to check for a possible error
> > > and handle it. Ensure users handle EINTR correctly and do not ignore
> > > it.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Have raised concerns below but also this feels like you're trying to do a bit
> > too much in one patch here, probably worth splitting out based on the different
> > parts you changed.
> >
> > > ---
> > >  arch/s390/kvm/kvm-s390.c |  2 +-
> > >  fs/proc/task_mmu.c       |  5 ++++-
> > >  mm/mempolicy.c           | 14 +++++++++++---
> > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > >  mm/vma.c                 | 22 ++++++++++++++--------
> > >  mm/vma.h                 |  6 ++++++
> > >  6 files changed, 50 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > index 7a175d86cef0..337e4f7db63a 100644
> > > --- a/arch/s390/kvm/kvm-s390.c
> > > +++ b/arch/s390/kvm/kvm-s390.c
> > > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > >               }
> > >               /* must be called without kvm->lock */
> > >               r = kvm_s390_handle_pv(kvm, &args);
> > > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > > +             if (r != -EINTR && copy_to_user(argp, &args, sizeof(args))) {
> >
> > This is horribly ugly, and if we were already filtering any other instance of
> > -EINTR (if they're even possible from copy_to_user()) why is -EINTR being
> > treated in a special way?
> >
> > I honestly _hate_ this if (errcode != -EINTR) { ... } pattern in general, I'd
> > really rather we didn't.
> >
> > It's going to bitrot and people are going to assume it's for some _very good
> > reason_ and nobody will understand why it's getting special treatment...
> >
> > Surely a fatal signal would have previously resulted in -EFAULT before which is
> > a similar situation so most consistent would be to keep filtering no?
>
> Current code ignores any error coming from kvm_s390_handle_pv() and
> proceeds with copy_to_user(), possibly overriding the former error. I
> don't really know if this is an oversight or an intentional behavior,
> so I wanted to minimize possible side effects. I guess I should try to
> fix it properly (or learn why this was done this way). I'll post a
> separate patch to error out immediately if kvm_s390_handle_pv() fails
> and will ask s390 experts for review.

Thanks!

>
> >
> > >                       r = -EFAULT;
> > >                       break;
> > >               }
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index e091931d7ca1..1238a2988eb6 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > >               struct clear_refs_private cp = {
> > >                       .type = type,
> > >               };
> > > +             int err;
> > >
> > >               if (mmap_write_lock_killable(mm)) {
> > >                       count = -EINTR;
> > > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > >                                               0, mm, 0, -1UL);
> > >                       mmu_notifier_invalidate_range_start(&range);
> > >               }
> > > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > > +             err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > > +             if (err < 0)
> >
> > Again with this < 0 :) let's be consistent, if (err).
>
> Ack.

Thanks!

>
> >
> > > +                     count = err;
> > >               if (type == CLEAR_REFS_SOFT_DIRTY) {
> > >                       mmu_notifier_invalidate_range_end(&range);
> > >                       flush_tlb_mm(mm);
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index 90939f5bde02..3c8b3dfc9c56 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
> > >                       &queue_pages_lock_vma_walk_ops : &queue_pages_walk_ops;
> >
> > There's a comment above:
> >
> >  * queue_pages_range() may return:
> >  * 0 - all pages already on the right node, or successfully queued for moving
> >  *     (or neither strict checking nor moving requested: only range checking).
> >  * >0 - this number of misplaced folios could not be queued for moving
> >  *      (a hugetlbfs page or a transparent huge page being counted as 1).
> >  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without MOVEs.
> >  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspecified.
> >  */
> >
> > You should add the -EINTR to it.
>
> Ack.

Thanks!

>
> >
> > >
> > >       err = walk_page_range(mm, start, end, ops, &qp);
> > > +     if (err == -EINTR)
> > > +             return err;
> >
> > Again, you're special casing without really any justification here. Let's please
> > not special case -EINTR unless you have a _really good_ reason to.
> >
> > And also - if we fail to walk the page range because we couldn't get a VMA write
> > lock, that's ok. The walk failed. There's nothing to unlock, because we didn't
> > even get the write lock in the first place, so there's no broken state, it's as
> > if we failed at some other point right?
> >
> > So I don't see why we're special casing this _at all_.
>
> I want to avoid possible -EINTR code override with -EFAULT in the code below.
> walk_page_range() can return -EINVAL and any other error that
> ops->pte_hole or ops->test_walk might return. We might be fine
> treating all of them as -EFAULT but masking -EINTR seems wrong to me.
> I don't really know a better way to deal with this but if you have a
> good alternative I would really appreciate it.

As per Matthew we needn't worry, and in any case if we want to check for fatal
signal early exit we can do if (fatal_signal_pending(current)) {} I think?

>
> >
> > >
> > >       if (!qp.first)
> > >               /* whole range in hole */
> > > @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
> > >                                     flags | MPOL_MF_DISCONTIG_OK, &pagelist);
> > >       mmap_read_unlock(mm);
> >
> >
> > >
> > > +     if (nr_failed == -EINTR)
> > > +             err = nr_failed;
> >
> > Ugh please don't, that's REALLY horrible.
> >
> > Actually the only way you'd get a write lock happening in the walk_page_range()
> > is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops are used
> > which specifies .walk_lock = PGWALK_WRLOCK.
> >
> > And this flag is only set in do_mbind(), not in migrate_to_node().
> >
> > So this check is actually totally unnecessary. You'll never get -EINTR here.
>
> Ah, good point. I'll drop this part.

Thanks!

>
> >
> > Maybe this code needs some refactoring though in general... yikes.
>
> Right.
>
> >
> > > +
> > >       if (!list_empty(&pagelist)) {
> > > -             err = migrate_pages(&pagelist, alloc_migration_target, NULL,
> > > -                     (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
> > > +             if (!err)
> > > +                     err = migrate_pages(&pagelist, alloc_migration_target,
> > > +                                         NULL, (unsigned long)&mtc,
> > > +                                         MIGRATE_SYNC, MR_SYSCALL, NULL);
> >
> > Given the above, this is unnecessary too.
>
> Ack. Will drop.

Thanks!

>
> >
> > >               if (err)
> > >                       putback_movable_pages(&pagelist);
> > >       }
> > > @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, unsigned long len,
> > >                               MR_MEMPOLICY_MBIND, NULL);
> > >       }
> > >
> > > -     if (nr_failed && (flags & MPOL_MF_STRICT))
> > > +     /* Do not mask EINTR */
> >
> > Useless comment... You're not explaining why, and it's obvious what you're doing.
> >
> > > +     if ((err != -EINTR) && (nr_failed && (flags & MPOL_MF_STRICT)))
> >
> > Weird use of parens...
> >
> > And again why are we treating -EINTR in a special way?
>
> Ah, actually I don't think I need this here. If queue_pages_range()
> fails nr_failed gets reset to 0, so the original error won't be masked
> as -EIO. I'll drop this part.

Thanks!

>
> >
> > >               err = -EIO;
> > >       if (!list_empty(&pagelist))
> > >               putback_movable_pages(&pagelist);
> > > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > > index a94c401ab2cf..dc9f7a7709c6 100644
> > > --- a/mm/pagewalk.c
> > > +++ b/mm/pagewalk.c
> > > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
> > >               mmap_assert_write_locked(mm);
> > >  }
> > >
> > > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
> > >                                        enum page_walk_lock walk_lock)
> > >  {
> > >  #ifdef CONFIG_PER_VMA_LOCK
> > >       switch (walk_lock) {
> > >       case PGWALK_WRLOCK:
> > > -             vma_start_write(vma);
> > > -             break;
> > > +             return vma_start_write_killable(vma);
> > >       case PGWALK_WRLOCK_VERIFY:
> > >               vma_assert_write_locked(vma);
> > >               break;
> > > @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > >               break;
> > >       }
> > >  #endif
> > > +     return 0;
> > >  }
> > >
> > >  /*
> > > @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
> > >                       if (ops->pte_hole)
> > >                               err = ops->pte_hole(start, next, -1, &walk);
> > >               } else { /* inside vma */
> > > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > > +                     err = process_vma_walk_lock(vma, ops->walk_lock);
> > > +                     if (err)
> > > +                             break;
> > >                       walk.vma = vma;
> > >                       next = min(end, vma->vm_end);
> > >                       vma = find_vma(mm, vma->vm_end);
> > > @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
> > >               .vma            = vma,
> > >               .private        = private,
> > >       };
> > > +     int err;
> > >
> > >       if (start >= end || !walk.mm)
> > >               return -EINVAL;
> > > @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
> > >               return -EINVAL;
> > >
> > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > +     err = process_vma_walk_lock(vma, ops->walk_lock);
> > > +     if (err)
> > > +             return err;
> > >       return __walk_page_range(start, end, &walk);
> > >  }
> > >
> > > @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
> > >               .vma            = vma,
> > >               .private        = private,
> > >       };
> > > +     int err;
> > >
> > >       if (!walk.mm)
> > >               return -EINVAL;
> > > @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
> > >               return -EINVAL;
> > >
> > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > +     err = process_vma_walk_lock(vma, ops->walk_lock);
> > > +     if (err)
> > > +             return err;
> > >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> > >  }
> > >
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index 9f2664f1d078..46bbad6e64a4 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
> > >       if (anon_dup)
> > >               unlink_anon_vmas(anon_dup);
> > >
> > > -     /*
> > > -      * This means we have failed to clone anon_vma's correctly, but no
> > > -      * actual changes to VMAs have occurred, so no harm no foul - if the
> > > -      * user doesn't want this reported and instead just wants to give up on
> > > -      * the merge, allow it.
> > > -      */
> > > -     if (!vmg->give_up_on_oom)
> > > -             vmg->state = VMA_MERGE_ERROR_NOMEM;
> > > +     if (err == -EINTR) {
> > > +             vmg->state = VMA_MERGE_ERROR_INTR;
> >
> > Yeah this is incorrect. You seem adament in passing through -EINTR _no
> > matter what_ :)
>
> You got me figured out ;)
>
> >
> > There are callers that don't care at all if the merge failed, whether through
> > oom or VMA write lock not being acquired.
>
> Ah, I see. I was a bit puzzled by this vmg->give_up_on_oom flag. I
> think what you are saying is that errors from
> vma_merge_existing_range() are ignored unless this flag is set and
> even then the only possible error is ENOMEM.
>
> >
> > There's really no benefit in exiting early here I don't think, the subsequent
> > split will call vma_start_write_killable() anyway.
>
> But are we always calling split after the merge?

We wouldn't if start == vma->vm_start and end == vma->vm_end but that'd be a nop
anyway :) [in vma_modify(), the only caller].

>
> >
> > So I think this adds a lot of complexity and mess for nothing.
> >
> > So can we drop all this change to the merge logic please?
>
> Ok but is there a good reason for this unusual error handling logic in
> vma_merge_existing_range()?

It's specifically so we can indicate _why_ the merge didn't succeed, because the
function returns NULL. Is checked in vma_modify().

Better this way than an ERR_PTR().


>
> >
> > > +     } else {
> > > +             /*
> > > +              * This means we have failed to clone anon_vma's correctly,
> > > +              * but no actual changes to VMAs have occurred, so no harm no
> > > +              * foul - if the user doesn't want this reported and instead
> > > +              * just wants to give up on the merge, allow it.
> > > +              */
> > > +             if (!vmg->give_up_on_oom)
> > > +                     vmg->state = VMA_MERGE_ERROR_NOMEM;
> > > +     }
> > >       return NULL;
> > >  }
> > >
> > > @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
> > >       merged = vma_merge_existing_range(vmg);
> > >       if (merged)
> > >               return merged;
> > > +     if (vmg_intr(vmg))
> > > +             return ERR_PTR(-EINTR);
> > >       if (vmg_nomem(vmg))
> > >               return ERR_PTR(-ENOMEM);
> > >
> > > diff --git a/mm/vma.h b/mm/vma.h
> > > index eba388c61ef4..fe4560f81f4f 100644
> > > --- a/mm/vma.h
> > > +++ b/mm/vma.h
> > > @@ -56,6 +56,7 @@ struct vma_munmap_struct {
> > >  enum vma_merge_state {
> > >       VMA_MERGE_START,
> > >       VMA_MERGE_ERROR_NOMEM,
> > > +     VMA_MERGE_ERROR_INTR,
> > >       VMA_MERGE_NOMERGE,
> > >       VMA_MERGE_SUCCESS,
> > >  };
> > > @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
> > >       return vmg->state == VMA_MERGE_ERROR_NOMEM;
> > >  }
> > >
> > > +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> > > +{
> > > +     return vmg->state == VMA_MERGE_ERROR_INTR;
> > > +}
> > > +
> > >  /* Assumes addr >= vma->vm_start. */
> > >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> > >                                      unsigned long addr)
> > > --
> > > 2.53.0.414.gf7e9f6c205-goog
> > >
> >

Cheers, Lorenzo

