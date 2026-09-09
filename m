Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4AAAC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E553A6B008A; Wed,  9 Sep 2026 07:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E062A6B0092; Wed,  9 Sep 2026 07:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42DB6B0093; Wed,  9 Sep 2026 07:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD02F6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:30:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08CEB1A01A6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:30:58 +0000 (UTC)
X-FDA: 85194006996.10.EFE2670
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 426E04000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:30:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRybbNra;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788953456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kql9G2zdyt6ZJFywS3ZVlugu5+he5hLWWrL/U7LDx3k=;
	b=eUAOR8r7CyWSanntcwqA064mlSJ4IBWB5K0/A26rK9+apaZkwdMg1eXoLBXIo81RyioVuh
	aY4NMDnqVIFpvwO0lG/KyaqdjEFj/bh5BFP999z0FGCdxrOb0s1HRRg3kCtblvBdIJITaO
	OkMqGPjrwGKf/Zjy1VvptiL17+bnkig=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788953456;
	b=o8U7lgH6BXjng9yI/d+YbJBCX2cjVL38JWGYE4wZg+sYLRCE1WQ06JCT5XHNxZsHXb1zJs
	7JsMYbjGoHMyylcD6zQUy+Uf0Q3Y4UbAEejyvXYgMAzJA8DoNeuEkB2a7etTl4KupCJQZm
	EOBnXdwb5OA/Hqvt3kQCo1m/2iEpbdU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRybbNra;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 288CD40270;
	Wed,  9 Sep 2026 11:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298341F00A3D;
	Wed,  9 Sep 2026 11:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788953455;
	bh=kql9G2zdyt6ZJFywS3ZVlugu5+he5hLWWrL/U7LDx3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RRybbNral0sY22hhcoz6HaIyVeKE2oJFiF6t95RxLBLSdu/Oa4wlNWDh9LmfJ9Eed
	 iXwnxBS8UvyhyyE57jKgXr/6tickVpe3ztp4AHyPlz4bRgvGI9kDAB45C6BDzhdjCJ
	 8DanpZOh1L/5Q8EsGHQgey7kpOgynNjhYAF+g7ykpmkbABGn22U4EdFzyf/dJ5NRAf
	 nLKHz+pBsV8i9UA0K7CWArOItY9MyIUuLYt9vfX8Rwn1o795fOI2TbavG9pep8JZ1d
	 nEnvD1icU25l0X3w9kcBw+Zg5tB344SlJxTioXR+W8Y3BjJw9sSlwXW8OX5rUYPVZy
	 /RQC2Us4m8B+w==
Date: Wed, 9 Sep 2026 12:30:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 27/39] mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
Message-ID: <aqFDKJlj76O1hR2R@gremlin>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
 <20260909130141.2c5d250d@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909130141.2c5d250d@p-imbrenda>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8jm5jetnc8pnub3jsm9rjktnkicuugpd
X-Rspamd-Queue-Id: 426E04000A
X-HE-Tag: 1788953456-333896
X-HE-Meta: U2FsdGVkX18Q79CRpOzhoZRyV1mJiP47gqaD00k+4mOK0MOZDvZ9hhtPi7S0oZermDU5aB7FgOG9Hx9cgLDFl1y43z80m+EUkKpQ3b8gnUcl5n5cicOY8vEL7CXvZ9eFoiFUklNRyfxAFurDDimrEMh8Ep52Gs1hHBxpjnNamE4Uv+Mj9d6/Wr7GCwe1V+SAFFLwa9aitIt+3yMyhL9dAplFOjqz8lhCK0rGqgwAjYbRVLBxdRo5N+CPKwSE/CDqcpu6qk9asMEWuBzELL+zko+WFGD/63CiBrRdKfwOLHa/qDYpfsmaVXhCVeZNeOeX5nI0j9cax8QQuZny71eAXu40Au/27Po6qe+4GD1LjZkoBT6Z+YYKtUZmZ7luSwi4G3ldzTI/AE6Ak/9ZGYhdOEIQkXZZ34Ak6E8R9DjgfgMu/7GGartS1wx6tDU1GjIIJsahPtJfrin4QyPK3avtc0RlfIVxLC3cLz3zoyPITGx9/avj+XDwMchhTbOjjACEucVHTPKgVeEvLLbjntsOoSzFrLApR4kQI3mhn8RGixnPp1fANCMUrktmCZDJyRqpEK1n61ewj3vHSffufFY3c8rHy5Mazv0ESp5KCXa7RT+s0uHhi4/MZojWla9iJh/lFQ5NjG+dSM/WWK6dNx8YJuDF0v0UMu6gPUPMkQifbqRObVzIEcZpyKwWSgK3ck7WULcUinoxWP1QASzc5VdtKwVZAsfoJXc4RZWRnAjlqaJ4kRZuDl7hJ2UGRJ9mj0/KrmYFWVKtyDNGyAkCNnr2cd8gmYG8Q2JqjBe1GAW7KPGEoQ7KF99s/ABFs2ZSIHURWwJ1M38zOpmJI1umd3yOqoJL/7DyvDHdy/ZPrYI/QobcHDh97UE8j46BXh3bQIfxVb7BB+R7ZZ44eF/XlCLKV7O6IuFYKRVl+l1BbPN6Oh0L7A/ii0p37c1Wry5bST/KOliV54ncLQhLukt0Ftp
 iWy9qO3c
 wNwpB3Cawtwz9qNGOAbANIhob+W7vYj/qz3XU2Bo9VU3H0ijkbBnYNPNOeIOxc4qVHSOp6AIkoRP2nEI1a8TO2WNXxy1OyUCZH76uzqUL7at/dcB4lwtDxfRS7qWbe4M2GM0g1Euc4uKqagiq5oLVO6E1ytKiQ2dz5KAqUtYyYKVWUfknKR78FJ/CksVexLYyg6aQv0WmYX1oXSGi0s/Z6w+lp9wGANEJ55kpuy0ma3GsHTyGs/OEaFuBM8ntqkKbYrAKggaWkjy8+qi+OkR3/kx8kRz7G8/CpeoxGCSDbxdhW3/YZi4aB/Gi1mDY4o2dUG6n2aUjEcwqzc77MYeWDl1YNeWeMARAPGsq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 01:22:07PM +0200, Claudio Imbrenda wrote:
> On Tue, 08 Sep 2026 21:01:31 +0100
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> [please note that I had to prune the CC list quite aggressively because
> my SMTP server was not happy]

Yeah sorry about that, I already pruned the list a LOT from what b4 wanted, and
still ended up with a ton of people (I consider maintainers for stuff I touch
the minimum cc, but also added mm reviewers).

>
> > The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> > more than a page and it is inconsistent with other VMA predicates that
> > typically are prefixed by vma_.
> >
> > Rename to vma_is_hugetlb() for consistency, and while we're here update
> > some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> > oopses.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> for s390:
>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks!

>
> but please see the comment below
>
> > ---
> >  arch/arm64/kvm/mmu.c                      |  4 ++--
> >  arch/powerpc/mm/book3s64/radix_tlb.c      |  6 +++---
> >  arch/powerpc/mm/nohash/e500_hugetlbpage.c |  2 +-
> >  arch/powerpc/mm/nohash/tlb.c              |  2 +-
> >  arch/riscv/kvm/mmu.c                      |  2 +-
> >  arch/riscv/mm/tlbflush.c                  |  2 +-
> >  arch/s390/mm/gmap_helpers.c               |  6 +++---
> >  arch/sparc/mm/init_64.c                   |  2 +-
> >  drivers/gpu/drm/drm_gpusvm.c              |  2 +-
> >  fs/coredump.c                             |  2 +-
> >  fs/hugetlbfs/inode.c                      |  2 +-
> >  fs/proc/task_mmu.c                        |  8 ++++----
> >  include/asm-generic/tlb.h                 |  2 +-
> >  include/linux/hugetlb.h                   |  4 ++--
> >  include/linux/mm.h                        | 19 ++++++++++++++++---
> >  include/linux/rmap.h                      |  2 +-
> >  kernel/events/core.c                      |  2 +-
> >  kernel/sched/fair.c                       |  2 +-
> >  mm/gup.c                                  |  4 ++--
> >  mm/huge_memory.c                          |  2 +-
> >  mm/hugetlb.c                              | 14 +++++++-------
> >  mm/internal.h                             |  2 +-
> >  mm/madvise.c                              |  4 ++--
> >  mm/memory.c                               | 12 ++++++------
> >  mm/mempolicy.c                            |  2 +-
> >  mm/migrate_device.c                       |  2 +-
> >  mm/mmap.c                                 |  2 +-
> >  mm/mmu_gather.c                           |  2 +-
> >  mm/mprotect.c                             |  2 +-
> >  mm/mremap.c                               |  6 +++---
> >  mm/page_vma_mapped.c                      |  4 ++--
> >  mm/pagewalk.c                             |  2 +-
> >  mm/swapfile.c                             |  2 +-
> >  mm/userfaultfd.c                          | 26 +++++++++++++-------------
> >  mm/vma.c                                  |  8 ++++----
> >  mm/vmscan.c                               |  2 +-
> >  tools/testing/vma/include/stubs.h         |  2 +-
> >  37 files changed, 92 insertions(+), 79 deletions(-)
>
> [...]
>
> > diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> > index ff63ffb1dbd2..3f6783b93e67 100644
> > --- a/arch/s390/mm/gmap_helpers.c
> > +++ b/arch/s390/mm/gmap_helpers.c
> > @@ -102,7 +102,7 @@ __context_unsafe(/* pte_unmap_unlock() not instrumented */)
> >
> >  	/* Find the vm address for the guest address */
> >  	vma = vma_lookup(mm, vmaddr);
> > -	if (!vma || is_vm_hugetlb_page(vma))
> > +	if (!vma || vma_is_hugetlb(vma))
> >  		return;
> >
> >  	/* Get pointer to the page table entry */
> > @@ -139,7 +139,7 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
> >  		vma = find_vma_intersection(mm, vmaddr, end);
> >  		if (!vma)
> >  			return;
> > -		if (!is_vm_hugetlb_page(vma))
> > +		if (!vma_is_hugetlb(vma))
> >  			zap_vma_range(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
> >  		vmaddr = vma->vm_end;
> >  	}
> > @@ -247,7 +247,7 @@ static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
> >  		 * proof to catch unexpected zeropages in other mappings and
> >  		 * fail.
> >  		 */
> > -		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
> > +		if ((vma->vm_flags & VM_PFNMAP) || vma_is_hugetlb(vma))
>
> Would it be possible to replace this ^ with !vma_can_gup() ?
>
> (obviously not in this patch, since vma_can_gup() is only introduced at
> the end of the series)

Sure, I could squash that into the 'use and apply vma_can_gup()' patch. Will do
on next respin!

>
> >  			continue;
> >  		addr = vma->vm_start;
> >
>
> [...]

--
Cheers, Lorenzo

