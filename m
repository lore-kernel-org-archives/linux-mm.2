Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03436C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6B36B0005; Tue,  7 Jul 2026 06:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B315D6B009F; Tue,  7 Jul 2026 06:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8686B00A0; Tue,  7 Jul 2026 06:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 668096B0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:23:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30BB1C3888
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:23:08 +0000 (UTC)
X-FDA: 84961592856.01.A6043FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3729C1C0009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:23:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwBekEDD;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783419786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO9n1BXbcFKpE0ytmifaDUpJQYF7fOJjd6hhXMsbhnw=;
	b=W8YVnCgKoVcGd7pp5FIlJuBfQcey1rmDLR1yqvqIYxe8DAeC+UW8Uy8OSJXquzOXn80dvx
	uJetBNJkzkvIPgCIQWz/FO6velglqHQXxsAA+8JzKhJKl/P/xR50e5xC/VRGaxfLD9r8Na
	13caBaLdRhCnExAfAbxQES52Q4S5gfA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwBekEDD;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783419786;
	b=wNvmN9z/Zrdq5zSK1Woq69/cDb9COqktqpDPOuVanfVp6SelTfftmqvyccjwR1qXf+/J9g
	TCp3wY9ZzhBTt/v7YS3uxEEYDZeT7Xv8atCTSmBt96mYVetTLh2NeV8D+ZJEuOkII1uIpI
	U2hj0VRBC5l3Vs5nfNyOgqrcgu7qkwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67D1F40F17;
	Tue,  7 Jul 2026 10:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3940D1F000E9;
	Tue,  7 Jul 2026 10:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783419785;
	bh=uO9n1BXbcFKpE0ytmifaDUpJQYF7fOJjd6hhXMsbhnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MwBekEDDrqDWUBl7OB2GiRJo9KVaANF531LqDSCiYXdCwUfPfgV15P9ZY/fY6CVA6
	 F8ic/FjF/V4shqvt1ft98lkWSY+mj6ovzE4pr5gR635QrF0JPDro+njddQUcumSdQh
	 kZ2VtL+NJM1IHpwBv5iKE1Mc7Oizq03fbEHOGyZREuLCbOunsQHWCjKQPfsYIeYhTn
	 nkzNe0/N0Uo+DMFOtkRTMhjaVVt0gFL67IW/5ZfXccVzW25bfqi117JnWf+/k8p1+/
	 tBKgrRhHBxTqzBMhkUG4DH3unKVaBJ/A7PbihSPTdfDg8mw0xEEWq1UREm34Vk39Dl
	 CNZCNxZb4WFjQ==
Date: Tue, 7 Jul 2026 11:22:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 21/30] mm/vma: add and use vma_[add/sub]_pgoff()
Message-ID: <akzTTCgF1_d7DDZZ@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
 <akZI0n1U32Ptd0ye@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZI0n1U32Ptd0ye@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3729C1C0009
X-Stat-Signature: k54fbks8ye7udf1jdz6g371bmsxngooa
X-HE-Tag: 1783419786-127418
X-HE-Meta: U2FsdGVkX1+gQwX47N5CsbavJftKiupuC7B9qJIQhg12JAVXcekbrYbRJHLYptfRitvr1qQQ2BuvfT01VhRC24vzDkEDeufuuF00BABfH3f06Dg8SCp9hLEDPZemgT98uklr2xZeTckw5x3ivUW+CP7WAjIjZeJ0vTbPyYiAwiuI/M/dL02EdWrHsVuJ3f456YgYv1EOkFKQ87T5ldNRn1tMXn8UC7J4JvrIhRrHMOPnuy312wlWw9n8UPVXwLGQVely4BN5gBRKPpmyzbBXbtNokEr7cILoDtAeZTkYeI3ZBzC1KjOwjGhbfrowIyYa/NDwdly84jSkjkyA5pRF2xBMCcgfjrrXe3i4W9IRfJZ5580VLevTY0VL5c5ho6DXKBne+N2gE/okNQM6wjEr1+o1u1tvFIAh3Fevk/mguVx9GJx6VelDa8AQLTHjsyCFdeQDD17dB4wGsmMHLFVNkrUHdYscL4UZmAcwaKNj7IKJCm4FZ4WMKRfF63l+fLpfHHtgKnheLeQhyFT5NHICgfZlRDSyH5psNSUKQpkTgS9RgBuMCgiJ3oRdHQ7SGlIuduDp7Xb7JgULyqzGGpCRjfqhgDIUGlop4sG4q0JSDijeqJrD95uoFsL+Zd3XUIHSy6RbvDgwAiNPUYj9G0Lq59g7GpSJSTW0CuexZGGHDy1RNps2PjDliYgEIEvveDSD4u80o2L/mx3VwqZZDCpbBTIfRJCKC1oEC4EvyMqCArJUcr54J4aQOc7y/l7FtpLgrVlBvLsCI5JUEaew3NdJ7AUklFWIH1CmZRIDaX13AO15foFXqwQCSrkGjqFgvwzml9H1kO4g85pndx5EZh+Tm9Foo5b8oqm/9MEP4wZrkxE+h2xI/Rt1nMPt5ZfT5WlGSGcpMzuCOVG8yxaG0Yd+Z00D+jYGkZ+D0RYqLwdFLQm2aOUXSbE9qA44dtYuRC9xAyD7zmNbkUUR2sXLfRW
 +g/i1GHC
 vnlhEx0ubuc55HWzZU2YU6dWcEZMZfPH7pJtxE/ZRYsb4rrhu4DV8a4Gqe2MUaCdq9bnXlohMlawh+4KYQTrG3l2zBj7/iGEmMaNWguPB5nF98KBxPZFf1ssHimXkzkUdXO+9WisKPSiji1W9lWDe1p0a0k/oGkreEH8yoaiGeJTdNSQNsAHVlBeNkerPq0EaRCJ28uc0gkAeK3pBH42Abr8u4IhVzp9BYmcjMIsn6f1m0oVtSw2McttQ6lmUUDRThmjJgC8YYogE5pkHWNtYmuDGIG4D+7gVAOqkSjLZxo8NqkH1LSaNPhdPpzEmLwvTPb9YyKf7gbOSVhh8pI+bj/gfZZDukkl6yfv3azNcSOh2vem6wijLhO5xZAvd0kghG3YeUF/tAtQf7rUvKwfNELiOJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:20:10PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:32PM +0100, Lorenzo Stoakes wrote:
> > Add helpers for adding or subtracting to a VMA's page offset, exposed
> > internally for VMA users within mm in mm/vma.h.
> >
> > This is to lay the foundations for tracking anonymous page offset for
> > MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> > value must be reflected in both the file and anonymous offsets.
> >
> > These are used on VMA split and downward stack expansion.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/nommu.c                      |  6 ++++--
> >  mm/vma.c                        |  6 +++---
> >  mm/vma.h                        | 12 ++++++++++++
> >  tools/testing/vma/include/dup.h | 13 ++++++++++++-
> >  4 files changed, 31 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index 7333d855e974..c7fafcd87c14 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -41,6 +41,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> >  #include "internal.h"
> > +#include "vma.h"
> >
> >  unsigned long highest_memmap_pfn;
> >  int heap_stack_gap = 0;
> > @@ -1338,7 +1339,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  		region->vm_top = region->vm_end = new->vm_end = addr;
> >  	} else {
> >  		region->vm_start = new->vm_start = addr;
> > -		region->vm_pgoff = new->vm_pgoff += npages;
> > +		vma_add_pgoff(new, npages);
> > +		region->vm_pgoff = vma_start_pgoff(new);
> >  	}
> >
> >  	vma_iter_config(vmi, new->vm_start, new->vm_end);
> > @@ -1355,7 +1357,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	delete_nommu_region(vma->vm_region);
> >  	if (new_below) {
> >  		vma->vm_region->vm_start = vma->vm_start = addr;
> > -		vma->vm_pgoff += npages;
> > +		vma_add_pgoff(vma, npages);
> >  		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
> >  	} else {
> >  		vma->vm_region->vm_end = vma->vm_end = addr;
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 185d07397ca6..cb7222e20c93 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  		new->vm_end = addr;
> >  	} else {
> >  		new->vm_start = addr;
> > -		new->vm_pgoff += linear_page_delta(vma, addr);
> > +		vma_add_pgoff(new, linear_page_delta(vma, addr));
> >  	}
> >
> >  	err = -ENOMEM;
> > @@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >
> >  	if (new_below) {
> >  		vma->vm_start = addr;
> > -		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
> > +		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
> >  	} else {
> >  		vma->vm_end = addr;
> >  	}
> > @@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
> >  				vm_stat_account(mm, vma->vm_flags, grow);
> >  				anon_vma_interval_tree_pre_update_vma(vma);
> >  				vma->vm_start = address;
> > -				vma->vm_pgoff -= grow;
> > +				vma_sub_pgoff(vma, grow);
> >  				/* Overwrite old entry in mtree. */
> >  				vma_iter_store_overwrite(&vmi, vma);
> >  				anon_vma_interval_tree_post_update_vma(vma);
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 2342516ce00e..47fe35e5307e 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
> >  	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
> >  }
> >
> > +static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> > +{
> > +	vma_assert_can_modify(vma);
> > +	vma->vm_pgoff += delta;
> > +}
> > +
> > +static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> > +{
> > +	vma_assert_can_modify(vma);
> > +	vma->vm_pgoff -= delta;
> > +}
> > +
> >  #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
> >  	struct vma_merge_struct name = {				\
> >  		.mm = mm_,						\
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 7ed165c8d9bc..41fea90a344d 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
> >  	return mas_find(&vmi->mas, ULONG_MAX);
> >  }
> >
> > +static inline bool vma_is_attached(struct vm_area_struct *vma)
> > +{
> > +	return refcount_read(&vma->vm_refcnt);
> > +}
> > +
> >  /*
> >   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
> >   * assertions should be made either under mmap_write_lock or when the object
> > @@ -1170,7 +1175,13 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
> >   */
> >  static inline void vma_assert_attached(struct vm_area_struct *vma)
> >  {
> > -	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
> > +	WARN_ON_ONCE(!vma_is_attached(vma));
> > +}
> > +
> > +static inline void vma_assert_can_modify(struct vm_area_struct *vma)
> > +{
> > +	if (vma_is_attached(vma))
> > +		vma_assert_write_locked(vma);
> >  }
>
> These hunks in dup.h look lost. Should perhaps be on the previous patch
> (adding the helpers).

Yeah, it's because the VMA code starts actually using them in a way that
otherwise breaks the tests at this point, but you're right, functionally it'd be
nicer to add them at the point they're introduced.

Will fix that up on respin!

>
> Anyway, Obviously Correct(tm).
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

