Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD7310BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54736B0099; Fri, 27 Mar 2026 03:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C076B009B; Fri, 27 Mar 2026 03:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B424A6B009D; Fri, 27 Mar 2026 03:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A19496B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:46:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BF115DEC1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:46:30 +0000 (UTC)
X-FDA: 84591060540.30.26A7784
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B3E9160006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:46:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JAnfdjN+;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BbvXU+EcgP/Ll4wd+ud3WbXmBXvM1kICAq+VSuGkwM=;
	b=HU4r6DK5538NjtRJPaVibI+Z43rYV2sbisNQkIu6YFt6oHDvvqOhCGCMqKOBZ4Kwe2numO
	fN15GtXW50nCBvwxH1ufmfQVVcYOrb43/y7kKqLC9RMFsH0oqXJa9FCDzwkvGW2Fz+5F8i
	EdJDfJhMVPg7V0ZohYkGegO2TF7DZWM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JAnfdjN+;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774597588; a=rsa-sha256;
	cv=none;
	b=kRlJjSXFPzrajfXzwdeO04KLE0f7NtahZzaYupeusp6IRAJNCBGw/rWQt3Iul7ARkkw+Xr
	gnLMjHL+xF2JkFMk72w02Aj9rOeuXVAVkhjC0kYlutpQaoITocdRLnEE1mbRLKrK3lJBiP
	0yYMCwZdLIrxvu3vHI2SZMh9estRZts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64C2140746;
	Fri, 27 Mar 2026 07:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BD4C19423;
	Fri, 27 Mar 2026 07:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774597587;
	bh=YpYLgI0jbsF+A0nzcAUua2nUX4/yXL66W0C5PJTgXrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JAnfdjN+EsvFi1j+dVGjzyHPyTGqTDMKTZrNVgQtgdS3xTJN/KeC6SXfA6DW6KjZ+
	 aXiEtUM3bJ0ki+Z9akOlTunEzzX5U9ssu8zkRelLpjeQHa/HwmIwwj6h10u5dOEg0M
	 EKBK/9ZwAoABVZvbLpHEF0ii0f6vV3ud6iWKWuUuKizQooRHUkahfT6Z9o8xP7UzAv
	 V7Ey/wrGk7siZDOJ5MJ/BLtJ5l6cix8sJsH1OOi+2j3uqZx/SfPbQJnE1wX5So5cdI
	 qTCscyLEFql+4cw/7JjIAf1/JD2WybgTQS/Y93nhclmXbb4rNjhVp/Hxc+mgKRvhwF
	 qjAqgYGSU/bnA==
Date: Fri, 27 Mar 2026 10:46:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 10/15] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <acY1x8M3y7xWLwBa@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-11-rppt@kernel.org>
 <CADrL8HXajnfE=WusxL=DeF7VcvrsX9z5XDC4mPt1JfMOd7J5DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HXajnfE=WusxL=DeF7VcvrsX9z5XDC4mPt1JfMOd7J5DA@mail.gmail.com>
X-Rspamd-Queue-Id: 7B3E9160006
X-Stat-Signature: qxj8bw17zw7c7zqkzrnu1s5kha4h3cmo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774597588-963068
X-HE-Meta: U2FsdGVkX19bQ6v7FA+QtXodEfh48n3XstPCPqLkmNNV6ds9JnCNsSArxdDb5qhdUKJzM8TxczEl7h9/P9tQ1/Z2ay+S0G/X6gUgCudyIB1IIhbT7Iy7L8vyVlS7+ngdLOIm1vj7EVcc60uQGkDzVUqjX4uCeZCOSDUJGgGrENMdFkRKoinvwqHPG+5NzIqjVLIsHbeGbTY2P0/mz3QcoKhyK1uGp0CZAMnSk4rCi0FJAJ+Ibi0K/ch6vCqtr51hJ+jAYz81ke0RwhPr+HyKhQhN+a1JImNuqmRb7/TyUG1AFpHc4ySqHyYtwq/0uiX5b2OX/mmVMS7MR68kLwIw7F2GhsA/vPxAGJ21RA6Q/SbGilHH+P8sRme2bxhLMgOliAoXyuUzb2/33NbAeBFK0TQa6kKIjFc94iaccBdZqSyTLNHi3zgpAa238/o2aTuFMq5Rf8VBmw1Fx2xA2YYJg9KdKVhG+48DC0lJaQ9Ui+M6E94J/NA+mSw7CaNYQiDmO8Hn9gNuPe05gsdMrC/PFj8ieCxtDFhfUeoi1I0/xP7SEHbwLJtZj/qWaH3gEoamhqSSyNxcgJD1gKc7eNgPwbs93xuIgv1XcAwcZAQXIdOekTabmjafw41OazXUmVWOR6A7mbG+DC8i3eXXg0bbv1/QrF0dBpe1Lqg22vZZ2ypYnkXpGV/C2MD0il4bmQjmCQIo1zDhqcBJV1FdNyGncugYrTF+TPR1jiN82uIQ7+TOk7o8KcVDBfChHRXjqgX8qMJAKBvxgPCPwVZNB/2h50kmVTAD2lvZE9K8O+Ez5OMtrbcXVDYAilK5H7OtyeaNe8pSGm/EiLX+kDsdeSu7RWO6wKyB3QpLkPNrLvNpQ/RE31hTF3EC2ZSTtGW2QvUWo11Q63FCbnWXOK27SAUxGogQZExFmPKtr6GPkSMYYRwKUAFaytbeyjV604lA1dPkgSp28OpReWre+qqEksM
 n3yvRz5N
 Ay3VIfyA7Mlf96L+AdTuGlPxS6j1cdXQUpV6AJt2c/Iw88pAc7XMAvRTsdLbPJMJzjRZ0R8vtLxfZ5zMycmLTrBwJ33DL0oe8ciz6ro1GUmoTwEUZ/XEZk22hZVt5mGelU51cmVHxu7oxLPbYiB0gDdBlhABZ/mz+xIlzSKqkwZ/+sQem7RuOu9m3KpalkAzas7DjIxzS3MBosaPqK40Me9PvIlXv5j25F0RYctmS3y6iWCkqqMWdqB438G4qF8L9vtpWiigUIQaw/7JHMzQA/XSs8JZcdnT1nCPqIFvitHDpDjmwFDzroO5USF/Ev0vfz+/c94yyifnxH5YjZ3mnp0SRdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 06:13:37PM -0700, James Houghton wrote:
> On Fri, Mar 6, 2026 at 9:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use
> > them in __mfill_atomic_pte() to add shmem folios to page cache and
> > remove them in case of error.
> >
> > Implement these methods in shmem along with vm_uffd_ops->alloc_folio()
> > and drop shmem_mfill_atomic_pte().
> >
> > Since userfaultfd now does not reference any functions from shmem, drop
> > include if linux/shmem_fs.h from mm/userfaultfd.c
> >
> > mfill_atomic_install_pte() is not used anywhere outside of
> > mm/userfaultfd, make it static.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/shmem_fs.h      |  14 ----
> >  include/linux/userfaultfd_k.h |  21 +++--
> >  mm/shmem.c                    | 148 ++++++++++++----------------------
> >  mm/userfaultfd.c              |  79 +++++++++---------
> >  4 files changed, 106 insertions(+), 156 deletions(-)
> >
> > diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> > index a8273b32e041..1a345142af7d 100644
> > --- a/include/linux/shmem_fs.h
> > +++ b/include/linux/shmem_fs.h
> > @@ -221,20 +221,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
> >
> >  extern bool shmem_charge(struct inode *inode, long pages);
> >
> > -#ifdef CONFIG_USERFAULTFD
> > -#ifdef CONFIG_SHMEM
> > -extern int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> > -                                 struct vm_area_struct *dst_vma,
> > -                                 unsigned long dst_addr,
> > -                                 unsigned long src_addr,
> > -                                 uffd_flags_t flags,
> > -                                 struct folio **foliop);
> > -#else /* !CONFIG_SHMEM */
> > -#define shmem_mfill_atomic_pte(dst_pmd, dst_vma, dst_addr, \
> > -                              src_addr, flags, foliop) ({ BUG(); 0; })
> > -#endif /* CONFIG_SHMEM */
> > -#endif /* CONFIG_USERFAULTFD */
> > -
> >  /*
> >   * Used space is stored as unsigned 64-bit value in bytes but
> >   * quota core supports only signed 64-bit values so use that
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index 4d8b879eed91..bf4e595ac914 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -93,10 +93,24 @@ struct vm_uffd_ops {
> >         struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
> >         /*
> >          * Called during resolution of UFFDIO_COPY request.
> > -        * Should return allocate a and return folio or NULL if allocation fails.
> > +        * Should allocate and return a folio or NULL if allocation
> > +        * fails.
> >          */
> >         struct folio *(*alloc_folio)(struct vm_area_struct *vma,
> >                                      unsigned long addr);
> > +       /*
> > +        * Called during resolution of UFFDIO_COPY request.
> > +        * Should lock the folio and add it to VMA's page cache.
> 
> I don't think "should lock the folio" is accurate. That sounds like
> "it will call folio_lock()" but it actually calls
> __folio_set_locked(). Maybe this is better:
> 
> "Should only be called with a folio returned by alloc_folio() above.
> The folio will set to locked."

Yeah, sounds good.
 
> > +        * Returns 0 on success, error code on failure.
> > +        */
> > +       int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
> > +                        unsigned long addr);

> > @@ -404,6 +400,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
> >
> >         set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
> >
> > +       if (page_in_cache)
> > +               folio_unlock(folio);
> 
> I don't really like doing the folio_unlock() *here*, I think it's
> clearer if the callers (mfill_atomic_pte_continue() and
> __mfill_atomic_pte()) unlocked the folio themselves. But that's just
> my opinion.

We already have page_in_cache here, so I'd prefer to keep a single
folio_unlock() rather than add additional if (page_in_cache) in
__mfill_atomic_pte().
 
> > +
> >         /* No need to invalidate - it was non-present before */
> >         update_mmu_cache(dst_vma, dst_addr, dst_pte);
> >         ret = 0;
> > @@ -836,41 +856,18 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
> >
> >  static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
> >  {
> > -       struct vm_area_struct *dst_vma = state->vma;
> > -       unsigned long src_addr = state->src_addr;
> > -       unsigned long dst_addr = state->dst_addr;
> > -       struct folio **foliop = &state->folio;
> >         uffd_flags_t flags = state->flags;
> > -       pmd_t *dst_pmd = state->pmd;
> > -       ssize_t err;
> >
> >         if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> >                 return mfill_atomic_pte_continue(state);
> >         if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
> >                 return mfill_atomic_pte_poison(state);
> > +       if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> > +               return mfill_atomic_pte_copy(state);
> > +       if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
> > +               return mfill_atomic_pte_zeropage(state);
> 
> Thanks for this cleanup. :)
> 
> >
> > -       /*
> > -        * The normal page fault path for a shmem will invoke the
> > -        * fault, fill the hole in the file and COW it right away. The
> > -        * result generates plain anonymous memory. So when we are
> > -        * asked to fill an hole in a MAP_PRIVATE shmem mapping, we'll
> > -        * generate anonymous memory directly without actually filling
> > -        * the hole. For the MAP_PRIVATE case the robustness check
> > -        * only happens in the pagetable (to verify it's still none)
> > -        * and not in the radix tree.
> > -        */
> > -       if (!(dst_vma->vm_flags & VM_SHARED)) {
> > -               if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> > -                       err = mfill_atomic_pte_copy(state);
> > -               else
> > -                       err = mfill_atomic_pte_zeropage(state);
> > -       } else {
> > -               err = shmem_mfill_atomic_pte(dst_pmd, dst_vma,
> > -                                            dst_addr, src_addr,
> > -                                            flags, foliop);
> > -       }
> > -
> > -       return err;
> > +       return -EOPNOTSUPP;
> 
> WARN_ONCE() here I think.

I'll add VM_WARN_ONCE() here.

> Feel free to add:
> 
> Reviewed-by: James Houghton <jthoughton@google.com>

Thanks!

-- 
Sincerely yours,
Mike.

