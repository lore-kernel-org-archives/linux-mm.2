Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2DA606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RBqJw7tC
Received: by kanga.kvack.org (Postfix)
	id 36F606B05B5; Wed,  4 Nov 2026 06:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3207E6B05B6; Wed,  4 Nov 2026 06:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E85C6B05B7; Wed,  4 Nov 2026 06:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E37916B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:30:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A49E1606EB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:30:48 +0000 (UTC)
X-FDA: 85397219376.08.0240F30
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 948AE40005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:30:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RBqJw7tC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793791846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiRnenZMo+9r0+H1Od/X/l9/yOgB8T+K8XN++fWe+Ek=;
	b=Kz3lL/oTDa2x1jb5+vBNgOlWZFdlEB937rS7TzzbDz8hOsMvu0qTQCzxV2Bq+vsThcR7w5
	lH/Igkjns8I76kMooWYu7JGHwjYPLpBUZytzOLVHj29tfAePqQutrF3SI7X+Y6Pw7JHlLz
	T4pOUvn97VZ+kmDJ1yjLc0/VRj2K8eE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RBqJw7tC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793791846;
	b=AVFnfsiefixMijmWEvSOlC0qCXTzLIecMLzI+kgW187StbT6owCeLSo8Yt3JnNsrE6OoWq
	ym2mbUTBs4CWvUciP7WC4FiqUQztC8OBpsRNHm2YgWKT6rBSNN6Xpe/wSJSZ6wZAxkg6HQ
	jpOXE7zRGKuIGU1WifiLj9kNKfbp+AM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AEC61650;
	Wed,  4 Nov 2026 03:30:42 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 802853F632;
	Wed,  4 Nov 2026 03:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793791845; bh=2en4pD6as0Aj+lkLrfYmqixWuI8RkQC0CgeUk58Ez6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RBqJw7tC3L/DYfBd6sF3QagVaIurjKf4QdiX1AOTMWbzHps47cEWyvdGFgYeT0gjR
	 xXEdt56lZ/69wu5uIU9JwmUFlVq2gdycx2nUERX+0IFMRsRbD6RWX79BxY9Eye8yvo
	 x2lqesotxLmFCCGORRxpKzL873JcmL6xEkiPbP7A=
Date: Wed, 4 Nov 2026 11:30:41 +0000
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
Subject: Re: [PATCH v2 4/4] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Message-ID: <ausXYZLcv4ZL1TYP@e129823.arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-4-bc1ac018c834@arm.com>
 <0f7a599b-0b22-442b-bfb3-435a85abd550@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f7a599b-0b22-442b-bfb3-435a85abd550@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 948AE40005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5zwos3ggr6mj4h8x87b35notqeurcxdt
X-HE-Tag: 1793791846-519427
X-HE-Meta: U2FsdGVkX1+oswDfOMbWPsxA8CXSvtGC40hHX1B2Fcm++6cU3Q+WHr0Cvn2y9uUwq7W6RhpKk4nuzgLBCcFP37Mxr1fi9WUfPuy8BtO9VmdMWOG4mHLCnZ96vzZTqFChAN7fKbTw5+/rHlL2PgM4SH+XxlUkcVtMtLcR2qQIDZ3EHOyyH9geKNQJfBHsQsxrLTxNPxkd6jbfdG/tqikOmkDQnQCKlzFd7teLX8r4A2fgcWlQF/FSJb3F6BVIBJsB/NXolpQkQ3yvmRAVIh4g8itwofvGxBctEwjVYktvKCU2xgVdwOB5ERn4oVtEyutiY3Fe4P8dCDAoq66eV3fb1iwNouxqVE78l87MexcpfcoPLFPaQmJbQ8PuChD9JHPm0p7fY0YNnyaWR1A3jEE3pBniMQa4lUg003Hk5FwtOGHqhV6nLn0ZA8q2bGG6cy3b5L6QAHzFtsSovy/bffKJ6kSD9VzAeYs3EDp1eRr4+B2GK2eeybNTJ22SSDQJJ2eBXF4u0XSNBXI6s7k43Ur2GZveVY/toTMG0VeA/MlP3P8IMPLDBqV4cgSp9+ofb94F6GNBgzjwknAkpZ3YL5WpUaqSFlYZ6ZTOzEnSmaER+osWHlow23xjwEcRncfxJ/zn4NWYR3LUvmJVzG7x/nnGyGfG+zmv87W/YQyikAKPR8ZOql4mJpUUkAez+VS3rB2wW2zxWnZiRtMPxymi3agDckvLBfrwBJQoNh/EVWPfxt8tAwtxXZ1+gb/Rxz0s2Enop4qm2M+tK/cesSzfQPE8K242BCfmiy8mXGmCEmsQ71fM8wKJgBETlKlHMs5NiGOxYdavc+wR8Lwt6QlDtw+xpD51Ol8cxBQnPJc7roo7ZXYxfECciygejeX5qGoOAWtkSOMtrpU0PnEw9CGCtln0xYvMd+f7Hwu6TME2Fn30yD6OA6LNi/8RsNzYE+bRJC6KTLuJYoFB1gALoMe/sPp
 ikF+vQMl
 HuayfHX6ByiQAEO0IkqbSEUR+izPnOMn+ZbdMXuR8pma7m38bvFYhh4RR7PiA82p5eijKx0ReXG6NX/wGCuezrZwIRHw5ELpoRlbMzdCIRizI0DtbxEotnfbc9viXYgDDAgp1LNsEGKC9uNTLZE0ztvEtGTnYGLhMKq/G/UcRx1J1X8inDJjIkuCZr/WnfqkBr9MmHt3wB+P5UtL+iFTYoqCrcL7UCRIw4n0+FKbV+wPwLIy6hgHjQF5eXVO7NpdrFe99cTg5JmRBVo4akiGOeC5wSJtPOwdSRiPWyiornp1Bi8LupXV/3bU8NHcyE1nxl0ampQ0cJAgXhNHNl/7VN2vUq+mAnSVwMh0X9X7nxPPWjqJ2XdgcRVACSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On 11/2/26 12:30, Yeoreum Yun wrote:
> > GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
> > costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> > atomic, a full barrier and a node stat update for FOLL_PIN), a
> > gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
> > pays sixteen of each and a PTE-mapped 2 MB THP pays 512.
> > 
> > The users are the hot ones: iov_iter_extract_user_pages() pins every
> > O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
> > buffers through it, and so does RDMA memory registration.
> > With mTHP those buffers are PTE-mapped large folios.
> > 
> > After the head page has been grabbed and verified as before, extend the
> > run to the following PTEs that map the next pages of the same folio
> > with the same protection bits, take the remaining references for the
> > run with try_grab_folio(), and fill pages[] from the run.
> > The PTEs of the run are read while the reference on the folio is held,
> > so the folio can neither be collapsed, freed nor split underneath the scan.
> > A read-only run of an anonymous folio stops at the first page
> > that gup_must_unshare() rejects, so the per-page exclusivity guarantee for
> > FOLL_PIN is kept.
> > 
> > folio_pte_batch_flags() does the scan.  It reads the entries with
> > ptep_get(), which is not safe without the page table lock on
> > CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
> > and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
> > Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
> > site, so the other callers do not change.
> > 
> > The order-0 path keeps its instruction sequence.  The folio flags are
> > tested before folio_set_referenced() on purpose: a load of the flags
> > right after that locked instruction cost about 25% on order-0 pages in
> > the gup_test benchmark below, and reading them first brings that path
> > back to the baseline.
> > 
> > gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
> > per call, median of 15 runs, two baseline boots / one patched boot, on
> > an x86-64 VM:
> > 
> >                        get_user_pages_fast()   pin_user_pages_fast()
> >                        before       after      before       after
> >   4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
> >   64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
> >   1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
> >   2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
> >   2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us
> > 
> > fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
> > buffer in 64 kB mTHP, median of 15 five-second runs:
> > 
> >   bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
> >   bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
> >   bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s
> > 
> > IORING_REGISTER_BUFFERS of 1 GB, median of 15:
> > 
> >   64 kB mTHP           6179/5998 us  ->  1599 us
> >   1 MB mTHP            5790/5801 us  ->   893 us
> >   4 kB pages           7173/6741 us  ->  6763 us
> > 
> > Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/gup.c | 46 +++++++++++++++++++++++++++++-----------------
> >  1 file changed, 29 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 49681f63950ec..94a9dc45e5953 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2901,7 +2901,8 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
> >  		unsigned long addr, unsigned long end,
> >  		unsigned int flags, struct page **pages)
> >  {
> > -	unsigned long nr_pages = 0;
> > +	unsigned long nr_pages = 0, nr_batch;
> > +	struct folio *folio = NULL;
> >  	pte_t *ptep, *ptem;
> >  
> >  	ptem = ptep = pte_offset_map(&pmd, addr);
> > @@ -2910,7 +2911,9 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
> >  	do {
> >  		pte_t pte = ptep_get_lockless(ptep);
> >  		struct page *page;
> > -		struct folio *folio;
> > +		unsigned long i;
> > +
> > +		nr_batch = 1;
> >  
> >  		/*
> >  		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
> > @@ -2937,19 +2940,21 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
> >  			goto pte_unmap;
> >  
> >  		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
> > -		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
> > -			gup_put_folio(folio, 1, flags);
> > +		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep))))
> >  			goto pte_unmap;
> > -		}
> 
> As discussed, we should really add some more details why each of these
> comparisons is required. Let's do that in a separate patch.
> 
> (I recall the pte check is required for concurrent PTE changes like
> unmap/protection etc and the pmd check is for THP collapse on architectures
> without IPI during TLB flushes)

Yes. It's a fast path for checking the unmap/protection like THP
collapse or KSM.

might below comments is enough:

/*
 * Recheck the PTE after grabbing the folio to detect concurrent unmapping
 * or protection changes, such as by KSM.
 *
 * Also recheck the PMD: THP collapse can detach the PTE table while its
 * entries remain unchanged. Checking the PTE alone would not detect
 * that we are walking a detached page table.
 */

> 
> >  
> > -		if (!gup_fast_folio_allowed(folio, flags)) {
> > -			gup_put_folio(folio, 1, flags);
> > +		if (!gup_fast_folio_allowed(folio, flags))
> >  			goto pte_unmap;
> > -		}
> >  
> > -		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
> > -			gup_put_folio(folio, 1, flags);
> > -			goto pte_unmap;
> > +		if (folio_test_large(folio))
> > +			nr_batch = folio_pte_batch_flags(folio, NULL, ptep, &pte,
> > +							 (end - addr) >> PAGE_SHIFT,
> > +							 FPB_LOCKLESS | FPB_RESPECT_WRITE);
> 
> Batching after the checks above, when we already stabilized the folio by
> grabbing a reference should indeed be correct.
> 
> Concurrent collapse should already see the raised reference and back off.

Yes. but do you want to make a comment in here like:

 /*
 * The reference acquired above keeps the folio stable for the following checks.
 */

> 
> > +
> > +		if (!pte_write(pte)) {
> > +			nr_batch = gup_unshared_pages(NULL, flags, folio, page, nr_batch);
> > +			if (nr_batch == 0)
> 
> !nr_batch

Okay.

> 
> > +				goto pte_unmap;
> >  		}
> >  
> >  		/*
> > @@ -2958,16 +2963,23 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
> >  		 * see Documentation/core-api/pin_user_pages.rst for
> >  		 * details.
> >  		 */
> > -		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
> > -			gup_put_folio(folio, 1, flags);
> > +		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio))
> >  			goto pte_unmap;
> 
> The label is now slightly misnamed.

might abort_out or out seems enough.
> 
> > -		}
> > +
> > +		if (nr_batch > 1 && try_grab_folio(folio, nr_batch - 1, flags))
> > +			nr_batch = 1;
> > +
> >  		folio_set_referenced(folio);
> > -		pages[nr_pages] = page;
> > -		nr_pages++;
> > -	} while (ptep++, addr += PAGE_SIZE, addr != end);
> > +		for (i = 0; i < nr_batch; i++) {
> > +			pages[nr_pages + i] = page + i;
> > +		}
> 
> No need for {}. Rik will replace that with a proper helper later.
> 
> > +		nr_pages += nr_batch;
> > +		folio = NULL;
> > +	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
> >  
> >  pte_unmap:
> > +	if (folio)
> > +		gup_put_folio(folio, 1, flags);
> >  	pte_unmap(ptem);
> >  	return nr_pages;
> >  }
> > 

Thanks!

-- 
Sincerely,
Yeoreum Yun

