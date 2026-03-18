Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A101077617
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DB2C6B0319; Wed, 18 Mar 2026 16:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C186B031A; Wed, 18 Mar 2026 16:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2516B031B; Wed, 18 Mar 2026 16:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A89D6B0319
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:39:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E547213938F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:39:39 +0000 (UTC)
X-FDA: 84560349678.21.734548C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2218F180009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:39:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E47VA4ey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9qAmvL+E7GhoNNXcS2jc5i15Agnn1pOv0DyJg+YtQw=;
	b=oFmr4FwbrIJBKWnTRef/2c/OETZs1svPUAFzCVy0OpsNVZJyK59lSJtt+oAcb3Zuyqcnm+
	JvYW4xnObGRJ6CsZZYdteWKUWntWkQB5rv5w3xObDsHoeRTyhndNUG8/saFcHH8HNmAPHX
	elQEtsS2K5Uue2SkiC4VbrhX3DYbydw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E47VA4ey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866378; a=rsa-sha256;
	cv=none;
	b=LqtoH1S4m0L9tIJcF8mhgegMN9HQWr+2FmTkvuPXqGk8EbvNfZ7LjuL1AsvFtnO7dRypU9
	w/AU6FMfnsXQ/+q598QqLdS8oAp86CkI8Q3QRQpACE+einyYvkMo7Uudt0Z2qFB4MV3sKq
	/QNZvXt6rZbCe9cwUAvmwO8lZrJHNQ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03845416A3;
	Wed, 18 Mar 2026 20:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7479EC19424;
	Wed, 18 Mar 2026 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866376;
	bh=ko4orCFKsaEPvSaBxnt5g878sJgcfWQEheBNrNLKEMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E47VA4eyxbQXzd9/UHnJc4CUyaJrHozBi4afZf6c2jVcv2hd+Z0m+zIqpNy1M8pcj
	 w9oXKVlXsLe1VI72kOIoJ7l6ut2RfKSHB1X8nGTrbocnlF7Eed4LpFpwhujoluz0ah
	 A2YQHuP+2I42ZaCouQNufu5wxVSBwJIHljGN7Mpuwkfmno/V0udnRXB25cKn2Fu76k
	 Bj63OdwEfHZJK2feU7hXM5AaBG8wRBm9rVwUfTJFLT5MH/nlGD/sZWJpPDFTJMmEYQ
	 nIrm5s3/krtA3DDEiPdP/tIOsTj2jTMHTs15YMbXC5SKfl8L20fd17zraYnMf17hnN
	 qalFYxNmTkB4w==
Date: Wed, 18 Mar 2026 20:39:25 +0000
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
Subject: Re: [PATCH v2 06/16] mm: add mmap_action_simple_ioremap()
Message-ID: <330f3614-7dc1-4e80-96c4-8472b25108bb@lucifer.local>
References: <cover.1773695307.git.ljs@kernel.org>
 <1e58aaf3cdb61cc317d890c12c9a558dfc206913.1773695307.git.ljs@kernel.org>
 <CAJuCfpGocCSRT0yDxPOLg2NZ+W_ZSTjHGPZRKBd3U90=sQtHCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGocCSRT0yDxPOLg2NZ+W_ZSTjHGPZRKBd3U90=sQtHCw@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2218F180009
X-Stat-Signature: 9xncfqf1mjqsbn49xpnuo3j5ykd5tt69
X-Rspam-User: 
X-HE-Tag: 1773866377-731215
X-HE-Meta: U2FsdGVkX18pn/Kx0uBR3zikETTbC0CfCRVgNC6J15Cmc6iGrzBhKFVAnqh4V6lK24499VCZamkNF2zqyW5QVlEG3ZiBEgNJcTyj8Duj6Ro0ndEwFiHyf19Gxymqw24wu3+WWZw0FtRtVGuUcbxej5bfKJLp+RghOdFfdnE49+Vqo01RjFzoq2+2CZUdlZ7ANb9h9eg0YfRkMWbpJOnJLvIZSArtkkds7XD1w/bfxQbyJmAaMac+mo/q5O2q/24Yr5kZQsF86+TA/ZR28hoNTN0QBJyYLIsGCfkx1121eOXjNpKRt6OAIVndfa8j0/60yhFaTzzoFyFNzfQ/SytUzlCwo6aClsRp0ZxR7pjg2JxCpVkWCPWh0R0QYIqB7V23omz2SpNm5YX/osDLPMUH+7xmFT5By/0tkZoHdNfHODYMmeMk97rafU2L38C4Fi424KQmgzPzoPSsDgGziOXJe6W8ktlyvIdk/u+oT/hqBoPTmMwfP+vUOpueq7dUAyiDsMcW4tLt6RrP0uEpEOtfhnw0rPEa2O/NIbpOsDQondrFYrhBWCdDn+5BJEfvrgPdTp+TavHRFulhXt40b7JiPJjxArsugoPaW9ssxTFuS5PS8nTW3qM3sKHjGaf3UX/ml0LTW7Hb33ys5sB8jeWHK8iIKKXoaBRgrxowoLa+LYM2A7a45b2IYCdVg5BPpf5BtCDD+Vjkju0pGb4ubUx+MwFFfEGakYu7xrZGyWRmbO90q9OL7iyAvnjDxziK2jUuxl+BGR2uXVf86+IsHQa0zPY8t5r+hVN02F3EgWQJ1Q+EcaKkRZP2rqmrUKLPHE3hRhgT99UnmNE9bFjAsayhjqNa60DYq3hO9rfxJ9C2d2p+bU7r+Nnu/NQjCNw3EUSo1FVH4TvuNmTLktzdowZ9A5PJ4cPb7wcgH1W8n/VJYEhl/9BbfFejJ9zlaZQWHVlCuWDiMOl35VZ9zwktnO/
 qJiBsIoN
 pQG8MQien3h75sOZpM71ylkS4FGv4NESVvHS03xKLHs2qW3kPzR7RFzhkkl5nEF5wyhXRihBdCYRaZxftbGj0H3f8v48K65vzK7WvMs6miR9QDGHHWMzYSbtUupiXIYn9xfD2SMd0nzQxNOq6pkMVVeX5hE9UghXO/mpZdAqrZtGKnnjbG1DkwfEwUgNlK2g1IiK2TX6FYujWvCTXHLVTdWTuatokzduXGL2F+ojbfHUuM6k0ylemEzqSh608k8rCWKcauTj+6kiXjetXPy7aXk38FPxvSJxffnDF9Da/CY/RcMPpVGq91cOABF8576SDtsTbYqzXICH7VmuSSHHzAqGf8UcO8ZXCN3cStPZfK6jPbVQfTD24nUruTzLFEBlmfsA9w8I3nIgbrmXJLfqhdh4jVKKQ0Zc8r+z5/ND8D4DqqWOjCGPCG7VP0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 09:14:28PM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 16, 2026 at 2:13 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > Currently drivers use vm_iomap_memory() as a simple helper function for
> > I/O remapping memory over a range starting at a specified physical address
> > over a specified length.
> >
> > In order to utilise this from mmap_prepare, separate out the core logic
> > into __simple_ioremap_prep(), update vm_iomap_memory() to use it, and add
> > simple_ioremap_prepare() to do the same with a VMA descriptor object.
> >
> > We also add MMAP_SIMPLE_IO_REMAP and relevant fields to the struct
> > mmap_action type to permit this operation also.
> >
> > We use mmap_action_ioremap() to set up the actual I/O remap operation once
> > we have checked and figured out the parameters, which makes
> > simple_ioremap_prepare() easy to implement.
> >
> > We then add mmap_action_simple_ioremap() to allow drivers to make use of
> > this mode.
> >
> > We update the mmap_prepare documentation to describe this mode.
> >
> > Finally, we update the VMA tests to reflect this change.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> A couple of nits, but otherwise LGTM.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  Documentation/filesystems/mmap_prepare.rst |  3 +
> >  include/linux/mm.h                         | 24 +++++-
> >  include/linux/mm_types.h                   |  6 +-
> >  mm/internal.h                              |  2 +
> >  mm/memory.c                                | 87 +++++++++++++++-------
> >  mm/util.c                                  | 12 +++
> >  tools/testing/vma/include/dup.h            |  6 +-
> >  7 files changed, 112 insertions(+), 28 deletions(-)
> >
> > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
> > index 20db474915da..be76ae475b9c 100644
> > --- a/Documentation/filesystems/mmap_prepare.rst
> > +++ b/Documentation/filesystems/mmap_prepare.rst
> > @@ -153,5 +153,8 @@ pointer. These are:
> >  * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
> >    the entire mapping from ``start_pfn`` onward.
> >
> > +* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
> > +  physical address and over a specified length.
> > +
> >  **NOTE:** The ``action`` field should never normally be manipulated directly,
> >  rather you ought to use one of these helpers.
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ad1b8c3c0cfd..df8fa6e6402b 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4337,11 +4337,33 @@ static inline void mmap_action_ioremap(struct vm_area_desc *desc,
> >   * @start_pfn: The first PFN in the range to remap.
> >   */
> >  static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
> > -                                         unsigned long start_pfn)
> > +                                           unsigned long start_pfn)
> >  {
> >         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(desc));
> >  }
> >
> > +/**
> > + * mmap_action_simple_ioremap - helper for mmap_prepare hook to specify that the
> > + * physical range in [start_phys_addr, start_phys_addr + size) should be I/O
> > + * remapped.
> > + * @desc: The VMA descriptor for the VMA requiring remap.
> > + * @start_phys_addr: Start of the physical memory to be mapped.
> > + * @size: Size of the area to map.
> > + *
> > + * NOTE: Some drivers might want to tweak desc->page_prot for purposes of
> > + * write-combine or similar.
> > + */
> > +static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
> > +                                             phys_addr_t start_phys_addr,
> > +                                             unsigned long size)
> > +{
> > +       struct mmap_action *action = &desc->action;
> > +
> > +       action->simple_ioremap.start_phys_addr = start_phys_addr;
> > +       action->simple_ioremap.size = size;
> > +       action->type = MMAP_SIMPLE_IO_REMAP;
> > +}
> > +
> >  int mmap_action_prepare(struct vm_area_desc *desc);
> >  int mmap_action_complete(struct vm_area_struct *vma,
> >                          struct mmap_action *action);
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 4a229cc0a06b..50685cf29792 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -814,6 +814,7 @@ enum mmap_action_type {
> >         MMAP_NOTHING,           /* Mapping is complete, no further action. */
> >         MMAP_REMAP_PFN,         /* Remap PFN range. */
> >         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> > +       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> >  };
> >
> >  /*
> > @@ -822,13 +823,16 @@ enum mmap_action_type {
> >   */
> >  struct mmap_action {
> >         union {
> > -               /* Remap range. */
> >                 struct {
> >                         unsigned long start;
> >                         unsigned long start_pfn;
> >                         unsigned long size;
> >                         pgprot_t pgprot;
> >                 } remap;
> > +               struct {
> > +                       phys_addr_t start_phys_addr;
> > +                       unsigned long size;
> > +               } simple_ioremap;
> >         };
> >         enum mmap_action_type type;
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index f5774892071e..0eaca2f0eb6a 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1804,6 +1804,8 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
> >  int remap_pfn_range_prepare(struct vm_area_desc *desc);
> >  int remap_pfn_range_complete(struct vm_area_struct *vma,
> >                              struct mmap_action *action);
> > +int simple_ioremap_prepare(struct vm_area_desc *desc);
> > +/* No simple_ioremap_complete, is ultimately handled by remap complete. */
> >
> >  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
> >  {
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 9dec67a18116..f3f4046aee97 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3170,6 +3170,59 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
> >         return do_remap_pfn_range(vma, start, pfn, size, prot);
> >  }
> >
> > +static int __simple_ioremap_prep(unsigned long vm_start, unsigned long vm_end,
>
> nit: vm_start and vm_end are used only to calculate vm_len. You could
> reduce the number of arguments by just passing vm_len.

Ack will fixup!

>
> > +                                pgoff_t vm_pgoff, phys_addr_t start_phys,
> > +                                unsigned long size, unsigned long *pfnp)
> > +{
> > +       const unsigned long vm_len = vm_end - vm_start;
> > +       unsigned long pfn, pages;
> > +
> > +       /* Check that the physical memory area passed in looks valid */
> > +       if (start_phys + size < start_phys)
> > +               return -EINVAL;
> > +       /*
> > +        * You *really* shouldn't map things that aren't page-aligned,
> > +        * but we've historically allowed it because IO memory might
> > +        * just have smaller alignment.
> > +        */
> > +       size += start_phys & ~PAGE_MASK;
> > +       pfn = start_phys >> PAGE_SHIFT;
> > +       pages = (size + ~PAGE_MASK) >> PAGE_SHIFT;
> > +       if (pfn + pages < pfn)
> > +               return -EINVAL;
> > +
> > +       /* We start the mapping 'vm_pgoff' pages into the area */
> > +       if (vm_pgoff > pages)
> > +               return -EINVAL;
> > +       pfn += vm_pgoff;
> > +       pages -= vm_pgoff;
> > +
> > +       /* Can we fit all of the mapping? */
> > +       if ((vm_len >> PAGE_SHIFT) > pages)
> > +               return -EINVAL;
> > +
> > +       *pfnp = pfn;
> > +       return 0;
> > +}
> > +
> > +int simple_ioremap_prepare(struct vm_area_desc *desc)
> > +{
> > +       struct mmap_action *action = &desc->action;
> > +       const phys_addr_t start = action->simple_ioremap.start_phys_addr;
> > +       const unsigned long size = action->simple_ioremap.size;
> > +       unsigned long pfn;
> > +       int err;
> > +
> > +       err = __simple_ioremap_prep(desc->start, desc->end, desc->pgoff,
> > +                                   start, size, &pfn);
> > +       if (err)
> > +               return err;
> > +
> > +       /* The I/O remap logic does the heavy lifting. */
> > +       mmap_action_ioremap(desc, desc->start, pfn, vma_desc_size(desc));
>
> nit: Looks like a perfect opportunity to use mmap_action_ioremap_full() here.

Yeah can do!

>
> > +       return mmap_action_prepare(desc);
>
> Ok, so IIUC this uses recursion:
> mmap_action_prepare(MMAP_SIMPLE_IO_REMAP) -> simple_ioremap_prepare()
> -> mmap_action_prepare(MMAP_IO_REMAP_PFN).

Yep, it's one level, I think that should be ok? :)

>
> > +}
> > +
> >  /**
> >   * vm_iomap_memory - remap memory to userspace
> >   * @vma: user vma to map to
> > @@ -3187,32 +3240,16 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
> >   */
> >  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
> >  {
> > -       unsigned long vm_len, pfn, pages;
> > -
> > -       /* Check that the physical memory area passed in looks valid */
> > -       if (start + len < start)
> > -               return -EINVAL;
> > -       /*
> > -        * You *really* shouldn't map things that aren't page-aligned,
> > -        * but we've historically allowed it because IO memory might
> > -        * just have smaller alignment.
> > -        */
> > -       len += start & ~PAGE_MASK;
> > -       pfn = start >> PAGE_SHIFT;
> > -       pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;
> > -       if (pfn + pages < pfn)
> > -               return -EINVAL;
> > -
> > -       /* We start the mapping 'vm_pgoff' pages into the area */
> > -       if (vma->vm_pgoff > pages)
> > -               return -EINVAL;
> > -       pfn += vma->vm_pgoff;
> > -       pages -= vma->vm_pgoff;
> > +       const unsigned long vm_start = vma->vm_start;
> > +       const unsigned long vm_end = vma->vm_end;
> > +       const unsigned long vm_len = vm_end - vm_start;
> > +       unsigned long pfn;
> > +       int err;
> >
> > -       /* Can we fit all of the mapping? */
> > -       vm_len = vma->vm_end - vma->vm_start;
> > -       if (vm_len >> PAGE_SHIFT > pages)
> > -               return -EINVAL;
> > +       err = __simple_ioremap_prep(vm_start, vm_end, vma->vm_pgoff, start,
> > +                                   len, &pfn);
> > +       if (err)
> > +               return err;
> >
> >         /* Ok, let it rip */
> >         return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
> > diff --git a/mm/util.c b/mm/util.c
> > index cdfba09e50d7..aa92e471afe1 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1390,6 +1390,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
> >                 return remap_pfn_range_prepare(desc);
> >         case MMAP_IO_REMAP_PFN:
> >                 return io_remap_pfn_range_prepare(desc);
> > +       case MMAP_SIMPLE_IO_REMAP:
> > +               return simple_ioremap_prepare(desc);
> >         }
> >
> >         WARN_ON_ONCE(1);
> > @@ -1421,6 +1423,14 @@ int mmap_action_complete(struct vm_area_struct *vma,
> >         case MMAP_IO_REMAP_PFN:
> >                 err = io_remap_pfn_range_complete(vma, action);
> >                 break;
> > +       case MMAP_SIMPLE_IO_REMAP:
> > +               /*
> > +                * The simple I/O remap should have been delegated to an I/O
> > +                * remap.
> > +                */
> > +               WARN_ON_ONCE(1);
> > +               err = -EINVAL;
> > +               break;
> >         }
> >
> >         return mmap_action_finish(vma, action, err);
> > @@ -1434,6 +1444,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
> >                 break;
> >         case MMAP_REMAP_PFN:
> >         case MMAP_IO_REMAP_PFN:
> > +       case MMAP_SIMPLE_IO_REMAP:
> >                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
> >                 break;
> >         }
> > @@ -1452,6 +1463,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
> >                 break;
> >         case MMAP_REMAP_PFN:
> >         case MMAP_IO_REMAP_PFN:
> > +       case MMAP_SIMPLE_IO_REMAP:
> >                 WARN_ON_ONCE(1); /* nommu cannot handle this. */
> >
> >                 err = -EINVAL;
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 4570ec77f153..114daaef4f73 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -453,6 +453,7 @@ enum mmap_action_type {
> >         MMAP_NOTHING,           /* Mapping is complete, no further action. */
> >         MMAP_REMAP_PFN,         /* Remap PFN range. */
> >         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> > +       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> >  };
> >> >  /*
> > @@ -461,13 +462,16 @@ enum mmap_action_type {
> >   */
> >  struct mmap_action {
> >         union {
> > -               /* Remap range. */
> >                 struct {
> >                         unsigned long start;
> >                         unsigned long start_pfn;
> >                         unsigned long size;
> >                         pgprot_t pgprot;
> >                 } remap;
> > +               struct {
> > +                       phys_addr_t start;
> > +                       unsigned long len;
> > +               } simple_ioremap;
> >         };
> >         enum mmap_action_type type;
> >
> > --
> > 2.53.0
> >

Cheers, Lorenzo

