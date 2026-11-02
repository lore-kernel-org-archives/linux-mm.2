Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6848606A33F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ue1ws/Sc
Received: by kanga.kvack.org (Postfix)
	id DF90D6B05B9; Mon,  2 Nov 2026 08:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0596B05BA; Mon,  2 Nov 2026 08:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E506B05BB; Mon,  2 Nov 2026 08:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD09D6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:46:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ACAF160C39
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:46:04 +0000 (UTC)
X-FDA: 85390302648.18.453CEE2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56F04160010
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:46:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ue1ws/Sc";
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neXC6d4EWQwZ+yifS+fK2WFD0pggnBVqEPoox7vx5m8=;
	b=qbHW2McQSPDzvf0OPe/G9fC2HdoI7jwen/c9Ow4IC+3cT6mbP/JpCp02AW1DZ9Oqx/WVEu
	TUnnX4b2anT6MUhvfLHuKiD6lCR6oVDnmPt2X9ZqNCP2xupN+5p/qHZvISe50byCdn0hc1
	uQLjZD6Ln3jE1rxDusMPQRLc4+4iNks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627162;
	b=huZlJmpVUaTlfHojNxyfb2ADgtt5HHKn87UY+bS0WAgOaw1IQMDpa4bJjhLWO74E2jDmya
	d7X+XcJXx8FT6miGmAWJOBt6ouWX+B8GUS8YkPuz8pYYt/StCPbijavLNn5bzgNKc92vkk
	nXhmHCeABN0/ErLIWaFnvY9rLIdvh/4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ue1ws/Sc";
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30CED1595;
	Mon,  2 Nov 2026 05:45:58 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E530D3F673;
	Mon,  2 Nov 2026 05:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793627161; bh=fZSZ6MB08kTtvX/igX5bE0NKnkORa6wfmDq57AKqELQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ue1ws/Sc866Fc5NSmv5uMqfh2NjXn5xVtmwW/swW6t0NcN1vx+V6akc7yFu1ps1eQ
	 /dN93sCWVLy/CBxjQu9aR9OXSElgm8jhlXl9zljN8QoiyniJBvqhuAsAUGfHKZiHYt
	 C2GYimd4IBGjCzKIe/1k2Rake0VviytMRe6NXD6k=
Date: Mon, 2 Nov 2026 13:45:56 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: gup: introduce gup_unshared_pages()
Message-ID: <auiUFIM_4Bk0gjwP@e129823.arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-1-bc1ac018c834@arm.com>
 <5feb82ef-a9bc-4ef3-b056-9732563e6225@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5feb82ef-a9bc-4ef3-b056-9732563e6225@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56F04160010
X-Stat-Signature: izas57ie8kb6qk5srdfqpw1tno4874ab
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793627162-606594
X-HE-Meta: U2FsdGVkX19HQ7qrKjP46Qj5SRuMTsV/znK4EmDjH204T6wg+VVVIQQKgdfjboaXZoNr/96PWh+J7Tb7nxEB7GH7YlOprFNf0HxJeienOZ+oaKjXcYmBFcJl9c/xKcpT5gMS6dOAx6KWqlCL+JHOKNkREdKSc57T9oYBKwXTrzeiRZkvua3oSktrx4Dw5hepaoF04G9996fzUxsTx9SCJ8RY0fOWUG/yecOb1/JJbVQ2ewbk+FWgDJC47Hd26KB+Gv9et1CuGtzkS5vPdpmmvBmWrp1pEI7bsH+E4dACBEHDuIBBUMS/zz3LMSBdpRkmlXWKvlivq8nrD+0VYmAqMphF/90jyPNapLZl44wujBUS2BO93iwWp7YsJpuDSWaS1k2p+eq6Tqc/1faaubJSaOd4iWD3jBKzau7gajC0s/jNv+q/LzmZTicT/6mX80CRx35WkN6BdfTg9+TgWSS4+P5tLjpFlq+O9W8+wMbBDfHIz3lzmCo11p/SvpiGIYpp0Pk1XL20uB/Be6mDQmmjFh4zBR0PqREmF2RJbng8uh/07H1TGvbfVKmMDSN6Hj4Tr84DzPYkZQuwP7r/mJQ/VhOO31/OZz7L15sFROTLdt1Di6zDa5uWWUjrKFQcKjNKHx2n7fdym7vkZj4IEdbj9Mx3qS2HZrKCu0OfwH0foPbZllLektb7JaTPgSo9gbNWkdB4fVC4JdnYPnrSCVjamW2tmevLuMIN74MgNfpNzqj+2AmGgiGgIbgvCSfz+bUI6y/74ouAdiVQ3xXVwzvCm86O9GjcXMjZA2onM/Mammy5/z2x18tTw3LBeA+DKGBDZ6HS5uhHBcdm5BMC65LSc1MZVNGVVg/6Bu3Q2fD33zXpp3sDGYdwpCOtOgfBYPaEnag9D/KObUyJFtzxNI150t0AXXZ06TaG87lf/FcUjT+22DPN1cT6qbSzcQIkaFiiN3VpJ2v6Rxh0p9U9G/g
 hg1GkX4r
 dUwMAABAUk7jsME8A6vSMNVcvGL9lcPFTekI3eugMvu+jMjNlJP7lZwks6U9n1IHclkX9JE2rx9CEybO3M6RDKYknzFUAB07UhGsVee5N9q8EDAZ/t/x10qe6cCLfKgzMjP7BzBa6r6fgAaP+OLWokZXC5wKR7Wg3BA9V5TohQWxz9StVpVd/AnhWuuvZbF6c+C37AnaxHvG4FYNFhbsr8t9unU2IUGwmwoVyOmzTF/AT+8qSGAZNz8yqowOIninK7pwZiksyhhWYTeeXKDHwKw4lrDsGhiFwTGx+Xw21jAX3fK4xxeKe9eRRdvFJPaHgrnTvd8+D1DE8g1YQbZqNmSuaYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On 11/2/26 12:30, Yeoreum Yun wrote:
> > This is preparatory patch to make gup_fast_pte_range() batchable.
> > 
> > Introduce gup_unshared_pages() to count consecutive pages within a folio
> > that do not require unsharing, and use it to implement gup_must_unshare().
> > 
> > Also add a folio argument to gup_must_unshare() so callers can reuse an
> > existing folio and avoid the compound_head() call implicit in PageAnon().
> > 
> > There is no functional change.
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/gup.c      | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
> >  mm/internal.h | 49 ++++++------------------------------------
> >  2 files changed, 70 insertions(+), 48 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 7d43ce717b246..49681f63950ec 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -633,6 +633,59 @@ static struct page *no_page_table(struct vm_area_struct *vma,
> >  	return NULL;
> >  }
> >  
> > +unsigned long gup_unshared_pages(struct vm_area_struct *vma, unsigned int flags,
> > +				 struct folio *folio, struct page *page,
> > +				 unsigned long nr_pages)
> 
> Two tab indent.

Okay.

> 
> 
> This function should be static.

Acked.

> 
> As a prerequisite patch you should move gup_unshared_pages() into this file.
> 
> $ git grep gup_must_unshare
> include/linux/rmap.h:    * gup_must_unshare().
> include/linux/rmap.h:    * gup_must_unshare().
> mm/gup.c:       if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
> mm/gup.c:       if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
> mm/gup.c:       if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
> mm/gup.c:               if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
> mm/gup.c:       if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> mm/gup.c:       if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> mm/internal.h:static inline bool gup_must_unshare(struct vm_area_struct *vma,

Might you want move gup_must_unshared() into gup.c from internal.h
I'll do.

> 
> 
> I'm not 100% happy about the function name due to the !folio_test_anon()+!FOLL_LONGTERM
> path, but cannot think of something better.

True.

> 
> > +{
> > +	unsigned int i;
> > +
> > +	/*
> > +	 * FOLL_WRITE is implicitly handled correctly as the page table entry
> > +	 * has to be writable -- and if it references (part of) an anonymous
> > +	 * folio, that part is required to be marked exclusive.
> > +	 */
> > +	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
> > +		return nr_pages;
> > +	/*
> > +	 * Note: PageAnon(page) is stable until the page is actually getting
> 
> You are not calling PageAnon() anymore.

Yes. I'll remove it.

> /* folio_test_anon(folio) is stable until folio gets freed. */
> 
> > +	 * freed.
> > +	 */
> > +	if (!folio_test_anon(folio)) {
> > +		/*
> > +		 * We only care about R/O long-term pining: R/O short-term
> > +		 * pinning does not have the semantics to observe successive
> > +		 * changes through the process page tables.
> > +		 */
> > +		if (!(flags & FOLL_LONGTERM))
> > +			return nr_pages;
> > +
> > +		/* We really need the vma ... */
> > +		if (!vma || vma_is_cow_mapping(vma))
> > +			return 0;
> > +
> > +		/*
> > +		 * ... because we only care about writable private ("COW")
> > +		 * mappings where we have to break COW early.
> > +		 */
> > +		return nr_pages;
> > +	}
> > +
> > +	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
> > +	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
> > +		smp_rmb();
> > +
> > +	/*
> > +	 * Note that KSM pages cannot be exclusive, and consequently,
> > +	 * cannot get pinned.
> > +	 */
> > +	for (i = 0; i < nr_pages; i++) {
> > +		if (!PageAnonExclusive(page + i))
> > +			return i;
> > +	}
> > +
> > +	return nr_pages;
> > +}
> > +
> >  #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
> >  /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
> >  static inline bool can_follow_write_pud(pud_t pud, struct page *page,
> > @@ -668,7 +721,8 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
> >  	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
> >  	page = pfn_to_page(pfn);
> >  
> > -	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
> > +	if (!pud_write(pud) &&
> > +	    gup_must_unshare(vma, flags, page_folio(page), page))
> >  		return ERR_PTR(-EMLINK);
> 
> There is already another instance of page_folio(page) int his file. Use a local
> variable and have one folio lookup. (that's the whole reason for passing a folio)

Okay. I'll merge.

> 
> >  
> >  	ret = try_grab_folio(page_folio(page), 1, flags);
> > @@ -722,7 +776,8 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
> >  	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
> >  		return NULL;
> >  
> > -	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
> > +	if (!pmd_write(pmdval) &&
> > +	    gup_must_unshare(vma, flags, page_folio(page), page))
> >  		return ERR_PTR(-EMLINK);
> 
> Dito.

Acked.

> 
> >  
> >  	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
> > @@ -846,7 +901,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
> >  	}
> >  	folio = page_folio(page);
> >  
> > -	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
> > +	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
> >  		page = ERR_PTR(-EMLINK);
> >  		goto out;
> >  	}
> > @@ -2892,7 +2947,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
> >  			goto pte_unmap;
> >  		}
> >  
> > -		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
> > +		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
> >  			gup_put_folio(folio, 1, flags);
> >  			goto pte_unmap;
> >  		}
> > @@ -2969,7 +3024,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
> >  		gup_put_folio(folio, nr_pages, flags);
> >  		return 0;
> >  	}
> > -	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> > +	if (!pmd_write(orig) &&
> > +	    gup_must_unshare(NULL, flags, folio, &folio->page)) {
> 
> 
> This only works because we don't have PMD mappings of things that are larger than PMDs.
> 
> While at it, pass the proper page.

Okay. I'll change with pmd_page(orig).

> 
> >  		gup_put_folio(folio, nr_pages, flags);
> >  		return 0;
> >  	}
> > @@ -3011,7 +3067,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
> >  		return 0;
> >  	}
> >  
> > -	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> > +	if (!pud_write(orig) &&
> > +	    gup_must_unshare(NULL, flags, folio, &folio->page)) {
> 
> Dito.

Acked.

> 
> >  		gup_put_folio(folio, nr_pages, flags);
> >  		return 0;
> >  	}
> > diff --git a/mm/internal.h b/mm/internal.h
> > index c53c369bf8b5d..35016b1afc8bf 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1282,6 +1282,10 @@ int migrate_device_coherent_folio(struct folio *folio);
> >  int __must_check try_grab_folio(struct folio *folio, int refs,
> >  				unsigned int flags);
> >  
> > +unsigned long gup_unshared_pages(struct vm_area_struct *vma, unsigned int flags,
> > +				 struct folio *folio, struct page *page,
> > +				 unsigned long nr_pages);
> > +
> >  /*
> >   * mm/huge_memory.c
> >   */
> > @@ -1354,51 +1358,12 @@ enum {
> >   * to fallback to the slow path just to lookup the vma.
> >   */
> >  static inline bool gup_must_unshare(struct vm_area_struct *vma,
> > -				    unsigned int flags, struct page *page)
> > +				    unsigned int flags,
> > +				    struct folio *folio, struct page *page)
> 
> Whatever you touch, please also convert to two-tab indent.

Okay.

> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

