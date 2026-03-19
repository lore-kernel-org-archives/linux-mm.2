Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5249109023A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44556B04F1; Thu, 19 Mar 2026 11:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4576B04F2; Thu, 19 Mar 2026 11:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909586B04F3; Thu, 19 Mar 2026 11:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D99C6B04F1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:05:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 365CF1DAEC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:05:41 +0000 (UTC)
X-FDA: 84563136882.25.E4ADC13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5BC1940019
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:05:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HrwI0qww;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773932739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emqZn/b9l25CBFiRC2TuMdoNkgDJNPNWQD3vaNNfAhY=;
	b=ssqfCV99sJgOg9gSySlwKdDMOnHNzxwxM+Xt3PD8iuKdz0Ye451izDPywDztMGAD59L3T/
	QZLiHP4SrUyoE1riEciN2qZZQlEyafGM5RcHfhRj/+IBF6CuJWkaKl5SdfYAiAwFvRagOp
	BKhN0uMUaLpJDSNQSB/ATeF4vWeP3UE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773932739; a=rsa-sha256;
	cv=none;
	b=I3i5ZVuOCib9CIBM9cZyrxoAFvSRmZTj7L0SQv2W3Bh1Jly0OrqsHwPXGzWo10EKoNMppV
	X6TipYhxC5UMlq220ShwEPedIuhcUUUNLk9WADyN2fOD98t1P2qaycG4OYK5hstq099MDe
	7TmAI4dlyFpgNRDwLkyJAvzSqxvGXIM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HrwI0qww;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6109B43C36;
	Thu, 19 Mar 2026 15:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D87AC19424;
	Thu, 19 Mar 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773932738;
	bh=93+721BAS0IjsUTl5If6UAZKiQ+Wsnp2WxjiW01z+dU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HrwI0qwwnhz3j4dB+z7y3TuiVKnPObUvncoUklEG5zgXFfISJ2MJVdco2OtXrW2wO
	 KzYAgmv+78LCU1/co4njUX0rnce8k+qFBYh9WiFDRVaiAqqXR2R2/xobdGJV6olSKf
	 ct/6gwzREeB0miMCzJ4eG3PB4sozTxyYp7XVlHKtN+k27bK/m1r1qFxHBIbWPP6eKY
	 OLedLyhenLavuUFUnZTaLd4LZnvQSnnNJ4PwlP+wpfp3JgC8EqYWaJXrDr49qNlVyO
	 9C5IUJmRap0KKWAqacP1TvOZOPHRQIkMOxHiAKEzVldVgcKKCZWvj7tJyIjD9w7d2G
	 dtfN4Y6W1Ns+Q==
Date: Thu, 19 Mar 2026 15:05:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v2 15/16] mm: add mmap_action_map_kernel_pages[_full]()
Message-ID: <d877ee66-1ac9-4b1b-b860-6919dc58edfe@lucifer.local>
References: <cover.1773695307.git.ljs@kernel.org>
 <8e28e4b63bae67bfa1a59ccbac9dc6db1442d75d.1773695307.git.ljs@kernel.org>
 <CAJuCfpF6eS18HLgNvQtkLGd=7N0_L1JPmF0GzM-Z0QimRWT7AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpF6eS18HLgNvQtkLGd=7N0_L1JPmF0GzM-Z0QimRWT7AQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BC1940019
X-Stat-Signature: jreb63b6z1if3rteckhiq4nyif5z433x
X-Rspam-User: 
X-HE-Tag: 1773932739-275547
X-HE-Meta: U2FsdGVkX1+R04DLEJcVry1LsxxP7jiEedFXa8wT+7BfHC230L4N4GzP27l9oAnASGFK+MvKYnePpdxQ9trweBcjX57otfWJIuLCTc/f/6XJU/CQB4c09300uyDe7iATt+0lMp519fqFqIKazejTtnElNyhf6yTmiaakxgFCTbAJvwuROzDJw3INUQc23ZjyVGt/YD2Nsp02pfejYN60miaDEXGSusPqPetD273eH4lQ7cqajGEf7z0k35dT486h0ipI3ZpZoPlfCGUEhoe+wUjTjm0mWVDCvVROeYNo+4ATGQhWd1mdJZXVVjM0jG4DuR1dov0BEr6In3R3rQqMo+vw6q2FxniYLflss1L/yOlhcbYtJAg3YfB89YaUQGcLWFgHr0LPkLQxMtclpbk7MNhkvl59yAdsStI4t2yNtXySMZg5TgJY/11xmAbsH6dntQMjHM55YWR8PyvVjhzsfpoEdA3W1rjYpDJKXTP8Jiub1Bmv3oA498Y/aEi2hoXwQXcDocfR0rptEiLDw/IJiRKroUuDQcLGTrVBxiVYgqedwq7QE4liYy8t6tYx7v/+9a9UvWOMgX19c6qaAPPphdviiisnrGkOpWI4k+njB8z86uL+bkGgQHVnvRUpJdswmI1MRIYBaLLUkLmzWcDD3gU0PmV9IHiy0JxDpExQGnJ/GX6Z2rzyuDfY3I8vFLJa2xrxHdEIyaVB1T4l352FxxE91B37Rlt5vAKIG/tM6AD7bEW2U4mX4acsvbwEadKGiVc9w7my66aOSBIYLg5+8rhp4Ai0vK0yCH+7ytu7whhAXgJLw6JgylbixSEdKynuhQBxubJjT4vNO5P4IdT9yXYvRoBgVxYlSlbgNwJ3bPxM3W8dtAqmUKXSfnsT8xetgasztvRJn/rZFRKeFFmlDqA7HGmC24G0J5wUpGhUiVLwVAR8o1etKHQeqnwSzp7/wbVdHbH5CIe8+yLtcFH
 tDYvMpWb
 HIQiKOeliUhl4kI7HAVLeIazLdn0AgD4nPuFiPvFveQmm/8EwN4Rp3N/OmtzEccdRoYygdn30fKg384eP1udq9SiEWKZ1125zLeeGyby8j9WjFTS/67v2r7rPpJ0dCtPmKUpFP3RcOzhCR4r9EgyCrlNKmkne7x0/HXbBAiBgvokqGsSztFU3bR5H6Os/po8l8tGTw7wD4XQdaMzJbI4KyFQMv8SuDv4lADulz4JtUKDT4Fd2Cd+znZVzAcNkanhGMrnYYxG4mDVbe1M6FzeK6UWqFSAw1QHZZ4If5cAGToiffKjkJrBCiXk93gUflSUEvn0p1/UdY0/CPCwXpDWkONuLFHisg1GN1klv+Zs3gudYju/ntN5tOTAc4TIKu5/C1uXhGcQtJH+pHXK3tTljo95dCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:00:13AM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 16, 2026 at 2:14 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > A user can invoke mmap_action_map_kernel_pages() to specify that the
> > mapping should map kernel pages starting from desc->start of a specified
> > number of pages specified in an array.
> >
> > In order to implement this, adjust mmap_action_prepare() to be able to
> > return an error code, as it makes sense to assert that the specified
> > parameters are valid as quickly as possible as well as updating the VMA
> > flags to include VMA_MIXEDMAP_BIT as necessary.
> >
> > This provides an mmap_prepare equivalent of vm_insert_pages().
> >
> > We additionally update the existing vm_insert_pages() code to use
> > range_in_vma() and add a new range_in_vma_desc() helper function for the
> > mmap_prepare case, sharing the code between the two in range_is_subset().
> >
> > We add both mmap_action_map_kernel_pages() and
> > mmap_action_map_kernel_pages_full() to allow for both partial and full VMA
> > mappings.
> >
> > We also add mmap_action_map_kernel_pages_discontig() to allow for
> > discontiguous mapping of kernel pages should the need arise.
> >
> > We update the documentation to reflect the new features.
> >
> > Finally, we update the VMA tests accordingly to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> With one nit,
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  Documentation/filesystems/mmap_prepare.rst |  8 ++
> >  include/linux/mm.h                         | 95 +++++++++++++++++++++-
> >  include/linux/mm_types.h                   |  7 ++
> >  mm/memory.c                                | 42 +++++++++-
> >  mm/util.c                                  |  6 ++
> >  tools/testing/vma/include/dup.h            |  7 ++
> >  6 files changed, 159 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
> > index be76ae475b9c..e810aa4134eb 100644
> > --- a/Documentation/filesystems/mmap_prepare.rst
> > +++ b/Documentation/filesystems/mmap_prepare.rst
> > @@ -156,5 +156,13 @@ pointer. These are:
> >  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
> >    physical address and over a specified length.
> >
> > +* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
> > +  pointers in the VMA from a specific offset.
> > +
> > +* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
> > +  page` pointers over the entire VMA. The caller must ensure there are
> > +  sufficient entries in the page array to cover the entire range of the
> > +  described VMA.
> > +
> >  **NOTE:** The ``action`` field should never normally be manipulated directly,
> >  rather you ought to use one of these helpers.
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index df8fa6e6402b..6f0a3edb24e1 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2912,7 +2912,7 @@ static inline bool folio_maybe_mapped_shared(struct folio *folio)
> >   * The caller must add any reference (e.g., from folio_try_get()) it might be
> >   * holding itself to the result.
> >   *
> > - * Returns the expected folio refcount.
> > + * Returns: the expected folio refcount.
>
> nit: I see both "Returns:" and "Return:" being used in the codebase
> but this header file uses "Return:", so for consistency you should
> probably do the same. This also applies to later instances in this
> patch.

Well here I'm just adding the colon, while I'm here (maybe have been an
update in response to feedback actualy).

And this function that's not part of my change already uses 'Returns' and
I'm pretty sure that's the correct form.

So I think not a big deal to keep using that?

>
> >   */
> >  static inline int folio_expected_ref_count(const struct folio *folio)
> >  {
> > @@ -4364,6 +4364,45 @@ static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
> >         action->type = MMAP_SIMPLE_IO_REMAP;
> >  }
> >
> > +/**
> > + * mmap_action_map_kernel_pages - helper for mmap_prepare hook to specify that
> > + * @num kernel pages contained in the @pages array should be mapped to userland
> > + * starting at virtual address @start.
> > + * @desc: The VMA descriptor for the VMA requiring kernel pags to be mapped.
> > + * @start: The virtual address from which to map them.
> > + * @pages: An array of struct page pointers describing the memory to map.
> > + * @nr_pages: The number of entries in the @pages aray.
> > + */
> > +static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
> > +               unsigned long start, struct page **pages,
> > +               unsigned long nr_pages)
> > +{
> > +       struct mmap_action *action = &desc->action;
> > +
> > +       action->type = MMAP_MAP_KERNEL_PAGES;
> > +       action->map_kernel.start = start;
> > +       action->map_kernel.pages = pages;
> > +       action->map_kernel.nr_pages = nr_pages;
> > +       action->map_kernel.pgoff = desc->pgoff;
> > +}
> > +
> > +/**
> > + * mmap_action_map_kernel_pages_full - helper for mmap_prepare hook to specify that
> > + * kernel pages contained in the @pages array should be mapped to userland
> > + * from @desc->start to @desc->end.
> > + * @desc: The VMA descriptor for the VMA requiring kernel pags to be mapped.
> > + * @pages: An array of struct page pointers describing the memory to map.
> > + *
> > + * The caller must ensure that @pages contains sufficient entries to cover the
> > + * entire range described by @desc.
> > + */
> > +static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
> > +               struct page **pages)
> > +{
> > +       mmap_action_map_kernel_pages(desc, desc->start, pages,
> > +                                    vma_desc_pages(desc));
> > +}
> > +
> >  int mmap_action_prepare(struct vm_area_desc *desc);
> >  int mmap_action_complete(struct vm_area_struct *vma,
> >                          struct mmap_action *action);
> > @@ -4380,10 +4419,59 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
> >         return vma;
> >  }
> >
> > +/**
> > + * range_is_subset - Is the specified inner range a subset of the outer range?
> > + * @outer_start: The start of the outer range.
> > + * @outer_end: The exclusive end of the outer range.
> > + * @inner_start: The start of the inner range.
> > + * @inner_end: The exclusive end of the inner range.
> > + *
> > + * Returns: %true if [inner_start, inner_end) is a subset of [outer_start,
> > + * outer_end), otherwise %false.
> > + */
> > +static inline bool range_is_subset(unsigned long outer_start,
> > +                                  unsigned long outer_end,
> > +                                  unsigned long inner_start,
> > +                                  unsigned long inner_end)
> > +{
> > +       return outer_start <= inner_start && inner_end <= outer_end;
> > +}
> > +
> > +/**
> > + * range_in_vma - is the specified [@start, @end) range a subset of the VMA?
> > + * @vma: The VMA against which we want to check [@start, @end).
> > + * @start: The start of the range we wish to check.
> > + * @end: The exclusive end of the range we wish to check.
> > + *
> > + * Returns: %true if [@start, @end) is a subset of [@vma->vm_start,
> > + * @vma->vm_end), %false otherwise.
> > + */
> >  static inline bool range_in_vma(const struct vm_area_struct *vma,
> >                                 unsigned long start, unsigned long end)
> >  {
> > -       return (vma && vma->vm_start <= start && end <= vma->vm_end);
> > +       if (!vma)
> > +               return false;
> > +
> > +       return range_is_subset(vma->vm_start, vma->vm_end, start, end);
> > +}
> > +
> > +/**
> > + * range_in_vma_desc - is the specified [@start, @end) range a subset of the VMA
> > + * described by @desc, a VMA descriptor?
> > + * @desc: The VMA descriptor against which we want to check [@start, @end).
> > + * @start: The start of the range we wish to check.
> > + * @end: The exclusive end of the range we wish to check.
> > + *
> > + * Returns: %true if [@start, @end) is a subset of [@desc->start, @desc->end),
> > + * %false otherwise.
> > + */
> > +static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
> > +                                    unsigned long start, unsigned long end)
> > +{
> > +       if (!desc)
> > +               return false;
> > +
> > +       return range_is_subset(desc->start, desc->end, start, end);
> >  }
> >
> >  #ifdef CONFIG_MMU
> > @@ -4427,6 +4515,9 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
> >  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
> >  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >                         struct page **pages, unsigned long *num);
> > +int map_kernel_pages_prepare(struct vm_area_desc *desc);
> > +int map_kernel_pages_complete(struct vm_area_struct *vma,
> > +                             struct mmap_action *action);
> >  int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
> >                                 unsigned long num);
> >  int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 7538d64f8848..c46224020a46 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -815,6 +815,7 @@ enum mmap_action_type {
> >         MMAP_REMAP_PFN,         /* Remap PFN range. */
> >         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> >         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> > +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from array. */
> >  };
> >
> >  /*
> > @@ -833,6 +834,12 @@ struct mmap_action {
> >                         phys_addr_t start_phys_addr;
> >                         unsigned long size;
> >                 } simple_ioremap;
> > +               struct {
> > +                       unsigned long start;
> > +                       struct page **pages;
> > +                       unsigned long nr_pages;
> > +                       pgoff_t pgoff;
> > +               } map_kernel;
> >         };
> >         enum mmap_action_type type;
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index f3f4046aee97..849d5d9eeb83 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2484,13 +2484,14 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >                         struct page **pages, unsigned long *num)
> >  {
> > -       const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
> > +       const unsigned long nr_pages = *num;
> > +       const unsigned long end = addr + PAGE_SIZE * nr_pages;
> >
> > -       if (addr < vma->vm_start || end_addr >= vma->vm_end)
> > +       if (!range_in_vma(vma, addr, end))
> >                 return -EFAULT;
> >         if (!(vma->vm_flags & VM_MIXEDMAP)) {
> > -               BUG_ON(mmap_read_trylock(vma->vm_mm));
> > -               BUG_ON(vma->vm_flags & VM_PFNMAP);
> > +               VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
> > +               VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
> >                 vm_flags_set(vma, VM_MIXEDMAP);
> >         }
> >         /* Defer page refcount checking till we're about to map that page. */
> > @@ -2498,6 +2499,39 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >  }
> >  EXPORT_SYMBOL(vm_insert_pages);
> >
> > +int map_kernel_pages_prepare(struct vm_area_desc *desc)
> > +{
> > +       const struct mmap_action *action = &desc->action;
> > +       const unsigned long addr = action->map_kernel.start;
> > +       unsigned long nr_pages, end;
> > +
> > +       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> > +               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> > +               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> > +               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> > +       }
> > +
> > +       nr_pages = action->map_kernel.nr_pages;
> > +       end = addr + PAGE_SIZE * nr_pages;
> > +       if (!range_in_vma_desc(desc, addr, end))
> > +               return -EFAULT;
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(map_kernel_pages_prepare);
> > +
> > +int map_kernel_pages_complete(struct vm_area_struct *vma,
> > +                             struct mmap_action *action)
> > +{
> > +       unsigned long nr_pages;
> > +
> > +       nr_pages = action->map_kernel.nr_pages;
> > +       return insert_pages(vma, action->map_kernel.start,
> > +                           action->map_kernel.pages,
> > +                           &nr_pages, vma->vm_page_prot);
> > +}
> > +EXPORT_SYMBOL(map_kernel_pages_complete);
> > +
> >  /**
> >   * vm_insert_page - insert single page into user vma
> >   * @vma: user vma to map to
> > diff --git a/mm/util.c b/mm/util.c
> > index a166c48fe894..dea590e7a26c 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1441,6 +1441,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
> >                 return io_remap_pfn_range_prepare(desc);
> >         case MMAP_SIMPLE_IO_REMAP:
> >                 return simple_ioremap_prepare(desc);
> > +       case MMAP_MAP_KERNEL_PAGES:
> > +               return map_kernel_pages_prepare(desc);
> >         }
> >
> >         WARN_ON_ONCE(1);
> > @@ -1472,6 +1474,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
> >         case MMAP_IO_REMAP_PFN:
> >                 err = io_remap_pfn_range_complete(vma, action);
> >                 break;
> > +       case MMAP_MAP_KERNEL_PAGES:
> > +               err = map_kernel_pages_complete(vma, action);
> > +               break;
> >         case MMAP_SIMPLE_IO_REMAP:
> >                 /*
> >                  * The simple I/O remap should have been delegated to an I/O
> > @@ -1494,6 +1499,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
> >         case MMAP_REMAP_PFN:
> >         case MMAP_IO_REMAP_PFN:
> >         case MMAP_SIMPLE_IO_REMAP:
> > +       case MMAP_MAP_KERNEL_PAGES:
> >                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
> >                 break;
> >         }
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 6658df26698a..4407caf207ad 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -454,6 +454,7 @@ enum mmap_action_type {
> >         MMAP_REMAP_PFN,         /* Remap PFN range. */
> >         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> >         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> > +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from an array. */
> >  };
> >
> >  /*
> > @@ -472,6 +473,12 @@ struct mmap_action {
> >                         phys_addr_t start;
> >                         unsigned long len;
> >                 } simple_ioremap;
> > +               struct {
> > +                       unsigned long start;
> > +                       struct page **pages;
> > +                       unsigned long num;
> > +                       pgoff_t pgoff;
> > +               } map_kernel;
> >         };
> >         enum mmap_action_type type;
> >
> > --
> > 2.53.0
> >

