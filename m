Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BE5C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 04:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59B56B0093; Wed, 12 Aug 2026 00:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AC56B0095; Wed, 12 Aug 2026 00:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA6A6B0096; Wed, 12 Aug 2026 00:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 702006B0093
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:06:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC968120278
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:06:17 +0000 (UTC)
X-FDA: 85091279994.06.789AE84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF04E140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:06:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rg9GEe8O;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786507576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGj7AuQqLNogp9DrzWU8bky6bxff7hTLqE4y5/kLaao=;
	b=fDKRdSjSLAycNdFGV6vUGjrbeolvarTzIVJdElby/Lai+sMDVY1ZnA9esJ/G0SzCpR4xjx
	j2SsDf1bNClpMuS+GC7gghZZBxW+918BZGvCngXZuIcnEr17ahfUUmQPidmU/N1TEIn+hY
	xYDb0xoWvmIwoOKJPqKiIVPpwh3o1fk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rg9GEe8O;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786507576;
	b=MfVSFf/nsH0WXH6EWVUHHNkCc6/x6gbtuJddlFpYK0YrYHQJQEO6n3LI787gw2AkxngXPl
	oCaL66OjHPMmWubJN1s7w2AWZ5SfCwPJSWGv0h3XI+aNvdGzxDHVGpExJWjkl/IYJ/uVv2
	+HDm0i2UP3RRfvr73y8E0YFIymM/NiQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B399D1596;
	Tue, 11 Aug 2026 21:06:10 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 018DD3F86F;
	Tue, 11 Aug 2026 21:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786507574; bh=IHjypAHsNKjpNGDu8aCRCeoUOQ9LFF7rYITg0sTzbDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rg9GEe8ORnIQSzAFzPE9Q3CsOniFeZz3B5DAx1vSbU2ayamMlqi+pdI/abA/SWthR
	 JHd2kD7S7LWpcNIoT65928j5y1fwj3S00eMdlQR9LYSfVNqmGWvx2Jo8nRyP2/XrUC
	 occW+1n2ku+jahULG28ttJSOr0S4qPMQj+wCR/cQ=
Date: Wed, 12 Aug 2026 09:36:11 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, 
	pfalcato@suse.de, agordeev@linux.ibm.com, ryan.roberts@arm.com, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH 3/9] mm: name pointers to copied PTE values ptentp
Message-ID: <hwkurkpobxysltkid5523qxndufebqqmat4qjaq6zhwno2drmh@efwoegm2huo6>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-4-usama.anjum@arm.com>
 <e7osakog3yvdewhdlrk3bsp27pwt2nnhroeb7zihlfxyjotarb@rwxkcb25crh3>
 <b21c4cc9-84a3-429e-8156-0b9967b2f133@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b21c4cc9-84a3-429e-8156-0b9967b2f133@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DF04E140006
X-Rspamd-Server: rspam07
X-Stat-Signature: rr5g8j8hewdjheyxuqj5nugq5p4f3rjx
X-HE-Tag: 1786507575-774721
X-HE-Meta: U2FsdGVkX1/q2MYlqYXlF38y48ZS70xhs8xamzlx2GsyHrenB+M996zfY/3Ib3WxJ8i1sQl9a0mLWRYrUbBwPaw4ZjAYaHD6I7b1URY+IZqgwnjPk+fxOjnjl94S7X/Xq4fsQdpJ4efZboAg4a6hNw7MBZ5RKqPQ0eQ7I7I1Oms+i+4z4hKVatMwDJ4ojY6YpRMNIIeP7nf4YddW7n/LY0+IqnqAx5iDRbjj/YRrNRFlxRf0jnR2L/9xhGHiMMSnRUXOiTwMW2PAhVPk3pRNuJLPTTmIU/EMkVi55KURMptAQ0vYFMejgXEmjFO2/w6I+khM1nq3cPxiZZg/8NE235BS+jKzSz8lTY0nTyflu7RBauTTyD9uY9Vj2yR4loBfmLvd27UiqNsyfnSj/Bk+K9sLMBBGG0kKEYsywsO2pAQCqHiqhmBuo+2ppz/mnEJv2JbTVLQ6In5jei8K3TRL48UB/sFFHNou1iWBkZOB7yYwINPx0/K1hA3XoYxW04rnb6FE7A/23Gh7TaSMWRaPZEVkSD2Cwlh+vW79XTHGbjtdAHn8l+9/huauXbsr4xLdobsX5qdb7Y6INDOrU1YoWgN27aEB7m8UE4WHY+h8T2rE4HtaNeCcFCQx9q8t8A3loKtYBs8nByeGdjRj8bbC4j7Qsk3GPyHaAKThEIUWR7271lYj/OZBr1MDyctarhQhIph5NN+jI2J9UpqDWbkiT2xWMvBwNclhTmCvvr8VIN9IBxPLYf6kR2vIM+xQFeK8xjBNBmjcQz6/pxUN4HwiPRJ7ltzn9cha6NFiQTFyIz5WDWpBzJZuUzrkqsjPVz+0A5z1u07iaaJxm4LweobM7jKs6y87qbQacAdg5IXQj1Yjy94SU1t+pGPBms/pUAfolObz7+9VCv/kGfzrWKR+Zvb+Bu5/Qw1ELDVZXQlD5EECC4I/9RKQSnMjkMke6QC+jsdBTtfXUzOo9zyUXoo
 uoOBJ1//
 T4nmKzY0/mRyVzCdwXBR8b4ZkHiI2IuyJPeuS6a9+yudBFSL/6Iuhsr0VvbpELIhRy2HHqoRn/KnnyTRf0GDb/70CS88Ee21Yfk1Pj4nQMq15oiBweCCWZA9HildaNW1X+bM1m+jMwGWQKAO9E4LsENugptqmIgUhuLXyKPptj7Z3FWa98NpGMuXiYk8Ok8Yy6oRXQCFsqMy0EEc5jx8UzsOim3F+g7Uni4/maF0JboKm0YiDLiRyLu6C218NI5FDnZSDs36go07eIjs+CL2jKDDUcywAeLJ/9knfeJtgO1+YDMgeUG+S1v0K0Su0iPAFRq/Z/C589szKE9v7caJp3zFZmO8ShceCGQ7yJOxklMupHyefHVf44cCLOtmaYqIKoY0OHJrYSY5eV77gzv64IFSdXWUFTeOs82tCmE2DkIhsO+rFsjubQI8aGsaHdpQaueuU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 03:09:07PM +0100, Muhammad Usama Anjum wrote:
> On 11/08/2026 11:58 am, Anshuman Khandual wrote:
> > Subject line is very confusing. Perhaps something like the following.
> > 
> > mm: Rename pointers to copied PTE values as ptentp
> > 
> > But even 'copied PTE values' is not very clear as well.
> 
> Something like:
> 
> mm: rename pointers to logical PTE values as ptentp
> 
> or
> 
> mm: rename pointers to software PTE values as ptentp

Yeah but we need to get these nomenclature right at the very beginning
and also probably get it documented some where.

> 
> > 
> > On Thu, Aug 06, 2026 at 09:38:41AM +0100, Muhammad Usama Anjum wrote:
> >> The hw_pte_t conversion must retain pte_t * for pointers to standalone PTE
> > 
> > We need to explain what is `standalone PTE values` first.
> > 
> >> values. Name the value parameters ptentp in the install_pte callback,
> >> write_protect_page(), and guard_install_set_pte() so the later mechanical
> >> conversion can distinguish them from pointers to PTE table storage.
> >>
> >> Some functions already use the ptentp name, including:
> >> - madvise_folio_pte_batch()
> >> - folio_pte_batch_flags()
> >> No need to convert them.
> >>
> >> This is a naming-only change.
> > 
> > Small nit - s/naming-only/rename
> 
> I'll fix it.
> 
> > 
> > The commit message needs rewrite clearly explaining the following details
> > 
> > - What are standalone PTE values
> Logical/software PTE is correct and better name here.

Right but we need to define these early on and then be consistent in their usage
afterwards in the entire series.

> 
> > - How these are different from HW pgtable pointers
> > - Change is just a rename for pointers into such 'standalone PTE'
> > - These renamed 'ptentp' here would be used for skip or replaced during
> >   upcoming mechanical change via a script
> > - No functional changes intended
> I'll update message in more elaborate way.
> 
> > 
> >>
> >> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> >> ---
> >> Changes since RFC v1:
> >> - Update the description for the architecture opt-in conversion.
> >> ---
> >>  include/linux/pagewalk.h | 2 +-
> >>  mm/ksm.c                 | 4 ++--
> >>  mm/madvise.c             | 4 ++--
> >>  3 files changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> >> index b41d7265c01bc..c34d826c5e4a2 100644
> >> --- a/include/linux/pagewalk.h
> >> +++ b/include/linux/pagewalk.h
> >> @@ -89,7 +89,7 @@ struct mm_walk_ops {
> >>  		       struct mm_walk *walk);
> >>  	void (*post_vma)(struct mm_walk *walk);
> >>  	int (*install_pte)(unsigned long addr, unsigned long next,
> >> -			   pte_t *ptep, struct mm_walk *walk);
> >> +			   pte_t *ptentp, struct mm_walk *walk);
> >>  	enum page_walk_lock walk_lock;
> >>  };
> >>  
> >> diff --git a/mm/ksm.c b/mm/ksm.c
> >> index ad05d7791307e..11d50518d02e9 100644
> >> --- a/mm/ksm.c
> >> +++ b/mm/ksm.c
> >> @@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
> >>  }
> >>  
> >>  static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
> >> -			      pte_t *orig_pte)
> >> +			      pte_t *ptentp)
> >>  {
> >>  	struct mm_struct *mm = vma->vm_mm;
> >>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
> >> @@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
> >>  
> >>  		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
> >>  	}
> >> -	*orig_pte = entry;
> >> +	*ptentp = entry;
> >>  	err = 0;
> >>  
> >>  out_unlock:
> >> diff --git a/mm/madvise.c b/mm/madvise.c
> >> index 07a21ca31bad4..c324cc991f841 100644
> >> --- a/mm/madvise.c
> >> +++ b/mm/madvise.c
> >> @@ -1101,12 +1101,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
> >>  }
> >>  
> >>  static int guard_install_set_pte(unsigned long addr, unsigned long next,
> >> -				 pte_t *ptep, struct mm_walk *walk)
> >> +				 pte_t *ptentp, struct mm_walk *walk)
> >>  {
> >>  	unsigned long *nr_pages = (unsigned long *)walk->private;
> >>  
> >>  	/* Simply install a PTE marker, this causes segfault on access. */
> >> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> >> +	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
> >>  	(*nr_pages)++;
> >>  
> >>  	return 0;
> >> -- 
> >> 2.47.3
> >>
> > 
> > How did we ensure that the above changes are comprehensive and nothing
> > else got left in here ?
> 
> The order of patches and even the code was found out after adding hw_pte_t
> structure. Then everything was converted, until some pte_t pointers were left
> which didn't require conversion.
> 
> If something is left, we'll get build errors when we build a converted architecture.
> So the branch mentioned in the cover letter when built, would produce build errors.
> (Those patches would be sent separately, after finalization of this series).
> 
> Whenever I'm rebasing (on mm-new), I'm rerunning Coccinelle script to see if new code
> has arrived which requires conversion or renaming.

But in the early patch where the manual renaming was done for the script to
pick up 'ptentp' patterns needs to be audited again.

> 
> -- 
> Thanks,
> Usama
> 

