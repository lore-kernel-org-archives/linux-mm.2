Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85BD210ED65C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E6A6B0092; Fri, 27 Mar 2026 07:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE63E6B0095; Fri, 27 Mar 2026 07:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC7C6B0096; Fri, 27 Mar 2026 07:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB8A6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:31:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 171E313C5BF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:31:21 +0000 (UTC)
X-FDA: 84591627162.15.874153A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 458241C0016
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:31:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4MjpK69;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774611079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1htkOFK/bcP73glmAvHkeGBgOA0jelxijWwoDWPzV4=;
	b=jHuu75ORU5jKKDKZ0dc+UDyMLFPpzhqMlDEB09LKL0ZbKcgYEzG6prhiJ0J7hHimixVv7V
	CEGvtMhUC66bKO/5D5yk0ysLfWa4W1YHSIGWTIniaGs2RfEkxZIeeaKBn4MdpgfRhClWTR
	FxZIJae+rtGxNsItbfeZQdWsK8UI5mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774611079; a=rsa-sha256;
	cv=none;
	b=5AUwd+pJZuudOt+c2FIbhPp2BemFbHAvco9RrHIu4gs5JPEUVbv/umvnuVhw8ZzP/R6BoC
	asV/fEL1/uvgH01Gf2rb7c2JTT0L69F/Zw3LRLWUWcGyq36Etnz4xQqKz2eLKhOrdgZffL
	SfDpYI6z7zEiC4Dgqe/RdL1YWXrdm7I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4MjpK69;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3414F44400;
	Fri, 27 Mar 2026 11:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C54C19423;
	Fri, 27 Mar 2026 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611078;
	bh=mOs+f1u+WyiqSYt3GiUnjwCnkAFMVSxmeQkggvC2jHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4MjpK69mTjB/d2r6HzwMtnkpMhj2cskZeq51ftIyHennIa4UuCYvWAsK8iGF7qq7
	 X4C8uDhyAVOa3c3YnkWLnQ/y52VQT4mIc4BId9LWlE2RE3UWPY+4RT/i56F36rg2n1
	 F5/yPnkFF9H3F0t35IBJsXhAoitFF4aBJzdqpeVbnchRKAVB7/IfIkX0EzslHgbymv
	 XLNXYmoqkKQL0dSkCjBjcRJPNokENji14QZKgVc2q/1YzqZssKYyoHVfxEWQp9vZyQ
	 22A97Yrhcii0R9h3fZ9vztdAWUGJcu8Za9rfEvFS11k9EqOJG3JFV+bAMvC44Xxmj3
	 y32xynP6g2Alg==
Date: Fri, 27 Mar 2026 14:31:06 +0300
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
Subject: Re: [PATCH v2 12/15] mm: generalize handling of userfaults in
 __do_fault()
Message-ID: <acZqemRy3ltBWGL2@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-13-rppt@kernel.org>
 <CADrL8HVUJ5FL97d9ytxp2WXos6HS+U+ycpsi5VxffsW9vacr9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HVUJ5FL97d9ytxp2WXos6HS+U+ycpsi5VxffsW9vacr9Q@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: z6kfpcch7o3duaik99tqoba6k9kpiwy8
X-Rspamd-Queue-Id: 458241C0016
X-Rspam-User: 
X-HE-Tag: 1774611079-844546
X-HE-Meta: U2FsdGVkX18FfYjGr9Rk3Dm1xmZ7Zi0IP0k3yLyz2WyzQf+D9LOPAe0JQxSLFO/ESdkBfMkV9MWjr+hPAzSAbrmkWmBMN8z5GU4ZINHHEKIZJ+FuK7nDy6H4fX+ZhnCROrhzAbTqK50/cuCvoV9qx4BJT5DMmHFBzx7IUrAkg5pB6ePcMNeXkeYz2kihLkWwEETHXTmwdNtDHQyLnwSoMWBu0oSr73k6AscTQvCR8HZ3ZB6hX6Carh32ydOrQp/xWJjevmk4ExNDDPWGGprv16oUwkAp5HuFTdPn4CM9ocVN0RhOeOuFDdnyTUwyM0/18KBx9VMulIjAnytrTMJaCbPLby6FBRgDqT2cL8SvPLB1L1u/wG+01Emy12Bj6m06IgsAX+3E+KqRme1KhLOP5ZOmuXbHJRELBCT9RooIlvHz7PbEcHWKXCGE6FajS96Xjc44rrDGhoUBkHEEl0AimzZNJolq3Rhz6OZCq5yuUUXlJgoZnLMlu3wVMyt6p9smaZ8VoR3vEecTbNFXuGIOG6MDOyGool4rcgMExXcaGx/Brg61scthe0q7DfsSkR8tcUqTa7LgYZiRVuppU0ZEzJbL+3S5Sv/78+GU4GtwNEK2FKexzSBGd6oJE5vNaZ74MeE1aqGKmL3mmHxkSg3RmxyNVfjrVJFwve0JOIXoRg3zU0KV4sVsv90q67EmsHmiewI7pUoBU63OkJOhilWFK+GOP+HWbEYir6YMAu+3j5EJQ5jpLUSqAkbL+65mDMYqDaurIvB7/5yQu3VuyfmTcadmm5cdFM48WefG1pOnaunMsb9jiGzu0LsRaeldYuHA9PRrlOZPcBYpCi2pCvzQhINj43dsT3ZjaXxWnM+aCn2DuDCvL/EdgjqEk9ypDj+aI21AJGGCP81ITghnGcinuoknompVhY9r46Dbv/YexVSJqyF8C3Incbrymtq9cBozjDAQE/mS0benV/4oQJ7
 mwhyweyg
 xwJ30ak73Xc9tvlb06t6pkBuMIXAIpH9ImF2zhbmBQ+++2PmQlJQBgVOd7hpOpRjp35GCjNZwCCAgvSuSjI77oBT4NTiEmQEHCz9XHTp5HioPWTiicLtHL8PmIe952H9xuOhjMuStEsypuq1CCVhJ/8pQXvPa+3eepbr1k7cwp6UTJF9BKlh3wQ7Tci8xnsXjLjSnGTQyWSNjP2rTRj1itwdCY8CveCP4lruhhQ5yX83CRatp9nIIH8VCAr7dlHxJwKjDL5dZoG4l7Nk/VEReUije41CEaIWI8/eksN8BOJLthl088dJytYMU3qoMAJJTOzQyTsgX2k5JPnx1pCOg6EbWZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 06:55:15PM -0700, James Houghton wrote:
> On Fri, Mar 6, 2026 at 9:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: Peter Xu <peterx@redhat.com>
> >
> > When a VMA is registered with userfaulfd, its ->fault()
> > method should check if a folio exists in the page cache and call
> > handle_userfault() with appropriate mode:
> >
> > - VM_UFFD_MINOR if VMA is registered in minor mode and the folio exists
> > - VM_UFFD_MISSING if VMA is registered in missing mode and the folio
> >   does not exist
> >
> > Instead of calling handle_userfault() directly from a specific ->fault()
> > handler, call __do_userfault() helper from the generic __do_fault().
> >
> > For VMAs registered with userfaultfd the new __do_userfault() helper
> > will check if the folio is found in the page cache using
> > vm_uffd_ops->get_folio_noalloc() and call handle_userfault() with the
> > appropriate mode.
> >
> > Make vm_uffd_ops->get_folio_noalloc() required method for non-anonymous
> > VMAs mapped at PTE level.
> >
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/memory.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
> >  mm/shmem.c       | 12 ------------
> >  mm/userfaultfd.c |  8 ++++++++
> >  3 files changed, 51 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 07778814b4a8..e2183c44d70b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5328,6 +5328,41 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
> >         return VM_FAULT_OOM;
> >  }
> >
> > +#ifdef CONFIG_USERFAULTFD
> > +static vm_fault_t __do_userfault(struct vm_fault *vmf)
> > +{
> > +       struct vm_area_struct *vma = vmf->vma;
> > +       struct inode *inode;
> > +       struct folio *folio;
> > +
> > +       if (!(userfaultfd_missing(vma) || userfaultfd_minor(vma)))
> > +               return 0;
> > +
> > +       inode = file_inode(vma->vm_file);
> > +       folio = vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
> 
> If you do away with the change you made to vma_can_userfault(), please
> add a WARN_ON_ONCE() here if uffd_ops or uffd_ops->get_folio_noalloc
> are not present.
> 
> > +       if (!IS_ERR_OR_NULL(folio)) {
> > +               /*
> > +                * TODO: provide a flag for get_folio_noalloc() to avoid
> > +                * locking (or even the extra reference?)
> > +                */
> 
> I think a whole new op is better than adding a flag. Something like
> uffd_ops->folio_present().

Right now it follows what shmem does, let's keep it as TODO for future
optimizations.
 
> > +               folio_unlock(folio);
> > +               folio_put(folio);
> > +               if (userfaultfd_minor(vma))
> > +                       return handle_userfault(vmf, VM_UFFD_MINOR);
> > +       } else {
> > +               if (userfaultfd_missing(vma))
> > +                       return handle_userfault(vmf, VM_UFFD_MISSING);
> > +       }
> > +
> > +       return 0;
> > +}
> > +#else
> > +static inline vm_fault_t __do_userfault(struct vm_fault *vmf)
> > +{
> > +       return 0;
> > +}
> > +#endif
> > +
> >  /*
> >   * The mmap_lock must have been held on entry, and may have been
> >   * released depending on flags and vma->vm_ops->fault() return value.
> > @@ -5360,6 +5395,14 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
> >                         return VM_FAULT_OOM;
> >         }
> >
> > +       /*
> > +        * If this is an userfaultfd trap, process it in advance before
> 
> "If this is a userfault"

Indeed :)
 
> > +        * triggering the genuine fault handler.
> > +        */
> > +       ret = __do_userfault(vmf);
> > +       if (ret)
> > +               return ret;
> > +
> >         ret = vma->vm_ops->fault(vmf);
> >         if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
> >                             VM_FAULT_DONE_COW)))
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 68620caaf75f..239545352cd2 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2489,13 +2489,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >         fault_mm = vma ? vma->vm_mm : NULL;
> >
> >         folio = filemap_get_entry(inode->i_mapping, index);
> > -       if (folio && vma && userfaultfd_minor(vma)) {
> > -               if (!xa_is_value(folio))
> > -                       folio_put(folio);
> > -               *fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
> > -               return 0;
> > -       }
> > -
> >         if (xa_is_value(folio)) {
> >                 error = shmem_swapin_folio(inode, index, &folio,
> >                                            sgp, gfp, vma, fault_type);
> > @@ -2540,11 +2533,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >          * Fast cache lookup and swap lookup did not find it: allocate.
> >          */
> >
> > -       if (vma && userfaultfd_missing(vma)) {
> > -               *fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
> > -               return 0;
> > -       }
> > -
> >         /* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
> >         orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
> >         if (orders > 0) {
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 7cd7c5d1ce84..2ac5fad0ed6c 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2045,6 +2045,14 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> >             !vma_is_anonymous(vma))
> >                 return false;
> >
> > +       /*
> > +        * File backed memory with PTE level mappigns must implement
> 
> "File-backed VMAs (except HugeTLB VMAs) must implement
> ops->get_folio_alloc() to support userfaults, as all userfaults in
> file-backed VMAs wlll call ops->get_folio_alloc() to determine the
> userfault type."

I like (except HugeTLB) more than "PTE ...", but it's not here to determine
the userfaulfd type, it's here to ensure we can __do_userfault() for a
memory type. 

	/*
	 * File backed VMAs (except HugeTLB) must implement
	 * ops->get_folio_noalloc() because it's required by
	 * __do_userfault() in page fault handling.
	 */
 
> > +        * ops->get_folio_noalloc()
> > +        */
> > +       if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
> > +           !ops->get_folio_noalloc)
> 
> With the separate folio_present() (or whatever) op, this check becomes
> more obvious. (Looking at this right now, it looks like we're checking
> for UFFDIO_CONTINUE/minor fault support here, but that's not really
> what's going on.)
> 
> Honestly I'm not 100% sure if this check should be here. If it's going
> to be here, then we should probably also have checks like these here:
>
> if (vm_flags & VM_UFFD_MINOR && !ops->get_folio_noalloc)
> 
> and
> 
> if (vm_flags & VM_UFFD_MISSING && !ops->alloc_folio)
> 
> So, maybe we should just leave it up to ops->can_userfault() to make
> sure we're doing the right thing?

This must be in the core so it can reject VMAs that can't be used in
__do_userfault() without complicating hot path in the page fault handler
with extra conditions.

> 
> > +               return false;
> > +
> >         return ops->can_userfault(vma, vm_flags);
> >  }
> >
> > --
> > 2.51.0
> >

-- 
Sincerely yours,
Mike.

