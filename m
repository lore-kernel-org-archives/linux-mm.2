Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB06BFD064E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B131A6B0005; Wed, 11 Mar 2026 04:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0F16B0089; Wed, 11 Mar 2026 04:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC5E6B008A; Wed, 11 Mar 2026 04:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74C716B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:09:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 169085A3E7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:09:41 +0000 (UTC)
X-FDA: 84533058162.13.0F6FD36
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04A1612000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:09:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773216579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8588WXIlGxdI88sSbf+mUXGvcOTg3AGxb2i0pO6tW6o=;
	b=eVOD1Fx2Y289htRMYWidU/HZMi4pyqoI2hB3BIkzyklMIjRh8TioJOja1+ogErL6/dJ9DS
	XCbUYw+pC2YZtoetMiLJJUNVVDRy8PN6BDaegIQK6IyCBi0m7GqELj4PLx9Jxp4xNRd69H
	2mzTA8bCuMcmUL9K8brX6HLdCJCguHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773216579; a=rsa-sha256;
	cv=none;
	b=CjW4+FKGWuYh2HtKioMY5jhm1TruQA36yYk5hiXgVh+OtKHFLqtjUAqWKu8YHeER/TGp9D
	wO+85jl5yB9DoSZhTSlx9hBgZm0DFrW7p+Bn2X4RB3SSEMRqfCwEXgVLnbM71mK8EbNkNg
	vdpC6idkZ0y24TOvXuk73KpgIuETfjE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96E93165C;
	Wed, 11 Mar 2026 01:09:31 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1E1C3F73B;
	Wed, 11 Mar 2026 01:09:28 -0700 (PDT)
Message-ID: <aeb28e78-4943-4330-b323-799dd80207f2@arm.com>
Date: Wed, 11 Mar 2026 13:39:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] mm/rmap: introduce folio_try_share_anon_rmap_ptes
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
 kas@kernel.org, willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-9-dev.jain@arm.com>
 <3ff22f08-5617-4c05-8fa0-1d808806e322@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <3ff22f08-5617-4c05-8fa0-1d808806e322@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04A1612000C
X-Stat-Signature: cacqhi6aawsw96ame178nyh8fpy4abof
X-Rspam-User: 
X-HE-Tag: 1773216578-97133
X-HE-Meta: U2FsdGVkX19KabP/FoHf9+3XWPfuR77+pfQy3lgt4rmMsajddw5eLxuYJ9R3SCBNoHYB1mJPQKUwyAcLEyJ84XOM61gESUS0Nam5cdQ2qONxygirF3n7V+Bpsk3HgsgzUmHe+WSpbpOpRvQmwP3RluZm3yPrJUKFyT66jOUlpyQ7ehuOHZO7xZrRlyeadeosHVh7208V+x8TQ3ao7RSL6UPVHXdeczvoMDNddPa34q/v76BualjwyGdSaqxEGV+fzswgUGSEZWTw/jjvfw//jVBMTpbQEVpjb/jJdLpCXztOQ0wQem8X9J/yAyK1Magu+k83chVaKhradSUuF/Lmua/aREYZRueaY86IxTXRay3gcG/oOZ6rmnh3hn3XFTjODswU0tVCcyJQ/chzCsx+UVcTFIAECnfoSWzM+mINcbQlyBLM4r3lv+1p+XOTP5ACzxd2Hi7HnySu+qm9mWQ6AnDlnTtZjTl5TP9uTBUoNEc4f7jCY6G1Ju24Mi9ocTjoWYnMOAFQ4hWDqyp2y0n4IxtHnbc7mqrnsPbsi/fRu9x01rjVqrByy0RmjpUZXMzYkWPNKfY6gR8g1yDjvw+qNxqpuymk8FbBLreKAr8wawhUUuGyYzUefo8wPOX3A4/s82rPgvyMiR8ll7psmg9r/Ahsnydzo/VKjr+O6eM4xrMJB7gGOyTXK4w36NazlL9WhyaJzTrVJP4Jb02TdbWqWAwNZ4AqWocuYskRZn7Drps0WS5lPiI+6zWTAcZf1nSksHOh5LVEXyx5R/kDp8HpWIOnMwGyTw61/TT3foBSZt6kHjqiksZlYYLlWA1Hbabn6lElENs447sDs3wreJCgO9gw1RPoUNHrmUUEYIhCP4sECL6xs1JR9zTBdE0SH5tLg/yvAthIz6u1jeh5bLVqyeo1eH5P+3ly/xvvmIivNxKRbPcYAtvs3H7FbCFTDnXzf1zQFO0o4ULWhgye4GG
 p0IlMslc
 rak+jQtD3fycHY7uqSy0HJJ5bcSoRgwWMcpu4UH4/jxChcdWN3liVWmZmLD3Dt7Rrj9WvSOwyMFcnFTVVWlpFHlkeruhcUshIEc3STehb1IUAxVtmnN4WyHD9O/blfoBOgzdQDwwi+8hP/yn96Hwz/5HltHxrn2oYVHMf5WQADwiIXzeYCVN1vRBhSLzla7tdiR8vI9jXGs2+snP4LFaTU/lrr3u0jR+LSi8lx2YcmNd0Y0K7eIvyD/6gKBiG0zHgQdEQq58Wi1EblA/epBEBEDtUD6i7ZqHzJ/YSGARpbkfibZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 3:08 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:12PM +0530, Dev Jain wrote:
>> In the quest of enabling batched unmapping of anonymous folios, we need to
>> handle the sharing of exclusive pages. Hence, a batched version of
>> folio_try_share_anon_rmap_pte is required.
>>
>> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
>> to do some rmap sanity checks. Add helpers to set and clear the
>> PageAnonExclusive bit on a batch of nr_pages. Note that
>> __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR from the
>> PMD path, but currently we only clear the bit on the head page. Retain this
>> behaviour by setting nr_pages = 1 in case the caller is
>> folio_try_share_anon_rmap_pmd.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/page-flags.h | 11 +++++++++++
>>  include/linux/rmap.h       | 28 ++++++++++++++++++++++++++--
>>  mm/rmap.c                  |  2 +-
>>  3 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index 0e03d816e8b9d..1d74ed9a28c41 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -1178,6 +1178,17 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>>  	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>>  }
>>
>> +static __always_inline void ClearPagesAnonExclusive(struct page *page,
>> +		unsigned int nr)
> 
> You're randomly moving between nr and nr_pages, can we just consistently use
> nr_pages please.

Okay.

> 
>> +{
>> +	for (;;) {
>> +		ClearPageAnonExclusive(page);
>> +		if (--nr == 0)
> 
> You really require nr to != 0 here or otherwise you're going to be clearing 4
> billion pages :)

I'm following the pattern in pgtable.h, see set_ptes,
clear_young_dirty_ptes, etc.

> 
>> +			break;
>> +		++page;
>> +	}
>> +}
> 
> Can we put this in mm.h or somewhere else please, and can we do away with this

What is the problem with page-flags.h? I am not very aware on which
function to put in which header file semantically, so please educate me on
this.

> HorribleNamingConvention, this is new, we can 'get away' with making it
> something sensible :)

I'll name it folio_clear_pages_anon_exclusive.


> 
> I wonder if we shouldn't also add a folio pointer here, and some
> VM_WARN_ON_ONCE()'s. Like:
> 
> static inline void folio_clear_page_batch(struct folio *folio,
> 					  struct page *first_subpage,
> 					  unsigned int nr_pages)
> {
> 	struct page *subpage = first_subpage;
> 
> 	VM_WARN_ON_ONCE(!nr_pages);
> 	VM_WARN_ON_ONCE(... check first_subpage in folio ...);
> 	VM_WARN_ON_ONCE(... check first_subpage -> first_subpage + nr_pages in folio ...);

I like what you are saying, but __folio_rmap_sanity_checks in the caller
checks exactly this :)

> 
> 	while (nr_pages--)
> 		ClearPageAnonExclusive(subpage++);
> }
> 
>> +
>>  #ifdef CONFIG_MMU
>>  #define __PG_MLOCKED		(1UL << PG_mlocked)
>>  #else
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 1b7720c66ac87..7a67776dca3fe 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -712,9 +712,13 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>  	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
>>  	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
>>
>> +	/* We only clear anon-exclusive from head page of PMD folio */
> 
> Is this accurate? David? I thought anon exclusive was per-subpage for any large
> folio...?

The current behaviour is to do this only. I was also surprised with this,
so I had dug in and found out:

https://lore.kernel.org/all/20220428083441.37290-13-david@redhat.com/

where David says:

"Long story short: once
PTE-mapped, we have to track information about exclusivity per sub-page,
but until then, we can just track it for the compound page in the head
page and not having to update a whole bunch of subpages all of the time
for a simple PMD mapping of a THP."


> 
> If we're explicitly doing this for some reason here, then why introduce it?
> 
>> +	if (level == PGTABLE_LEVEL_PMD)
>> +		nr_pages = 1;
>> +
>>  	/* device private folios cannot get pinned via GUP. */
>>  	if (unlikely(folio_is_device_private(folio))) {
>> -		ClearPageAnonExclusive(page);
>> +		ClearPagesAnonExclusive(page, nr_pages);
> 
> I really kind of hate this 'we are looking at subpage X with variable page in
> folio Y, but we don't mention Y' thing. It's super confusing that we have a
> pointer to a thing which sometimes we deref and treat as a value we care about
> and sometimes treat as an array.
> 
> This pattern exists throughout all the batched stuff and I kind of hate it
> everywhere.
> 
> I guess the batching means that we are looking at a sub-folio range.
> 
> If C had a better type system we could somehow have a type that encoded this,
> but it doesn't :>)
> 
> But I wonder if we shouldn't just go ahead and rename page -> pages and be
> consistent about this?

Agreed. You are correct in saying that this function should receive struct
folio to assert that we are essentially in a page array, and some sanity
checking should happen. But the callers are already doing the checking
in folio_rmap_sanity_checks. Let me think on this.


> 
>>  		return 0;
>>  	}
>>
>> @@ -766,7 +770,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>
>>  	if (unlikely(folio_maybe_dma_pinned(folio)))
>>  		return -EBUSY;
>> -	ClearPageAnonExclusive(page);
>> +	ClearPagesAnonExclusive(page, nr_pages);
>>
>>  	/*
>>  	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
>> @@ -804,6 +808,26 @@ static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
>>  	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
>>  }
>>
>> +/**
>> + * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
>> + *				    mapped by PTEs possibly shared to prepare
>> + *				   for KSM or temporary unmapping
> 
> This description is very confusing. 'Try marking exclusive anonymous pages
> [... marking them as what?] mapped by PTEs[, or (]possibly shared[, or )] to
> prepare for KSM[under what circumstances? Why mention KSM here?] or temporary
> unmapping [why temporary?]
> 
> OK I think you mean to say 'marking' them as 'possibly' shared.
> 
> But really by 'shared' you mean clearing anon exclusive right? So maybe the
> function name and description should reference that instead.
> 
> But this needs clarifying. This isn't an exercise in minimum number of words to
> describe the function.
> 
> Ohhh now I see this is what the comment is in folio_try_share_anon_rmap_pte() :P
> 
> Well, I wish we could update the original too ;) but OK this is fine as-is to
> matc that then.
> 
>> + * @folio:	The folio to share a mapping of
>> + * @page:	The first mapped exclusive page of the batch
>> + * @nr_pages:	The number of pages to share (batch size)
>> + *
>> + * See folio_try_share_anon_rmap_pte for full description.
>> + *
>> + * Context: The caller needs to hold the page table lock and has to have the
>> + * page table entries cleared/invalidated. Those PTEs used to map consecutive
>> + * pages of the folio passed here. The PTEs are all in the same PMD and VMA.
> 
> Can we VM_WARN_ON_ONCE() any of this? Not completely a necessity.

Again, we have WARN checks in folio_rmap_sanity_checks, and even in
folio_pte_batch. I am afraid of duplication.

> 
>> + */
>> +static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
>> +		struct page *page, unsigned int nr)
>> +{
>> +	return __folio_try_share_anon_rmap(folio, page, nr, PGTABLE_LEVEL_PTE);
>> +}
>> +
>>  /**
>>   * folio_try_share_anon_rmap_pmd - try marking an exclusive anonymous page
>>   *				   range mapped by a PMD possibly shared to
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 42f6b00cced01..bba5b571946d8 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2300,7 +2300,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>
>>  			/* See folio_try_share_anon_rmap(): clear PTE first. */
>>  			if (anon_exclusive &&
>> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>> +			    folio_try_share_anon_rmap_ptes(folio, subpage, 1)) {
> 
> I guess this is because you intend to make this batched later with >1, but I
> don't see the point of adding this since folio_try_share_anon_rmap_pte() already
> does what you're doing here.
> 
> So why not just change this when you actually batch?

It is generally the consensus to introduce a new function along with its
caller. Although one may argue that the caller introduced here is not
a functional change (still passing nr_pages = 1). So I am fine doing
what you suggest.

> 
> Buuuut.... haven't you not already changed this whole function to now 'jump'
> ahead if batched, so why are we only specifying nr_pages = 1 here?

Because...please bear with the insanity :) currently we are in a ridiculous
situation where

nr_pages can be > 1 for file folios, and lazyfree folios, *and* it is
required that the VMA is non-uffd.

So, the "jump" thingy I was doing in the previous patch was adding support
for file folios, belonging to uffd VMAs (see pte_install_uffd_wp_if_needed,
we need to handle uffd-wp marker for file folios only, and also I should
have mentioned "file folio" in the subject line of that patch, of course
I missed that because reasoning through this code is very difficult)

To answer your question, currently for anon folios nr_pages == 1, so
the jump is a no-op.

When I had discovered the uffd-wp bug some weeks back, I was pushing
back against the idea of hacking around it by disabling batching
for uffd-VMAs in folio_unmap_pte_batch, but solve it then and there
properly. Now we have too many cases - first we added lazyfree support,
then file-non-uffd support, my patch 5 adds file-uffd support, and
last patch finally completes this with anon support.


> 
> Honestly I think this function needs to be fully refactored away from the
> appalling giant-ball-of-string mess it is now before we try to add in batching
> to be honest.
> 
> Let's not accumulate more technical debt.

I agree, I am happy to help in cleaning up this function.

> 
> 
>>  				folio_put_swap(folio, subpage, 1);
>>  				set_pte_at(mm, address, pvmw.pte, pteval);
>>  				goto walk_abort;
>> --
>> 2.34.1
>>
> 
> Thanks, Lorenzo


