Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA15FD5F82
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3D06B0088; Wed,  8 Apr 2026 03:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164A66B008C; Wed,  8 Apr 2026 03:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052EF6B0092; Wed,  8 Apr 2026 03:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4E2E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:14:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4090160A6D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:14:52 +0000 (UTC)
X-FDA: 84634526424.18.8689329
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id ABBB5180004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:14:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="oHvkDM/l";
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775632490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkYecfrEDehpyTnSdnLfnE1PLT5q98PqstjYt5CPzq0=;
	b=08z+EW/3V4jAduTIWceBFh21lqnM/y1VXUqIuGsmKTBpsWAVICkj0chijOJuLrmqDWjYqB
	pMF+eAMISZBzMTU5gBCTozkDW7/TRc3jcRLg5/iAcuvnholL8OxX72UJK9fgtRdJTM5oGD
	9Ct/lXhBTOn3XK8zB8xY8wI6XJlimio=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="oHvkDM/l";
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775632490; a=rsa-sha256;
	cv=none;
	b=3gx3dBmVXFLez0qMlaQJ++BMNfGfZhM54J1C0tZU66vwhZuYn3/jupaVqKOMhiUIOUWjRz
	c8mtFZ6Xf7jmhoid4A7hPA2XVkOVgIgv1weNU9nU9TiQVxk/ItK9F0QGHzqBGb7Ep+NnE/
	pxvuh8L6uR+6uSw2t5GaLRWIAAqrDXE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C936B3594;
	Wed,  8 Apr 2026 00:14:43 -0700 (PDT)
Received: from [10.163.142.59] (unknown [10.163.142.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 794AE3F641;
	Wed,  8 Apr 2026 00:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775632489; bh=JZ0nyXKtFssfVR054ryj75Xkky66XjJKNhCCmxoaQz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oHvkDM/l6smgsMXsmG9hWm31GqY8XwElsh+7e3E4dZAIRqbDp2UFxVVDvBOJCBA6q
	 BaoXevUaFP2yls/o05WCwHlLFIhUEwTxA5a3Qa8rGtKXT0KvCT8J3YePO8BF608E/u
	 72bgcDnV7VU4iOX/fEScTXwLVMZ45hKQd1cFsIoM=
Message-ID: <4f278b33-5dca-475e-80ab-7c80c1d41d66@arm.com>
Date: Wed, 8 Apr 2026 12:44:36 +0530
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
 <aeb28e78-4943-4330-b323-799dd80207f2@arm.com>
 <bc0d31f5-dd6c-4406-9e25-7e214a225916@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <bc0d31f5-dd6c-4406-9e25-7e214a225916@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABBB5180004
X-Stat-Signature: 4su61sy9dh513jnddubt1sz49nackn6j
X-Rspam-User: 
X-HE-Tag: 1775632490-331152
X-HE-Meta: U2FsdGVkX18IaWSMYRmabupU/SmVYknoVHj0ovyYdwNHGOAvWeRq/B93GF7r0LhWc7rrVQQZad8DLMBJF3HK1S8LmBbE9E8aYOCK1Dq/4TzyIPRV4H9J2nxp0ps2JXfX+2HBEAvuXNyBEt8xFyTCKgZqtIK1OornVlFVyhqK14Z0FPw1PGmMTp4h44lKrcYcWGTk5QJdDiow09+se+8wTwjwWzVHw0ZkH7FoavJvVjy+7kj8VtTJLVMOtCCcb3ds4sNFV1zs77FBtuGX+dWNTI7chSj+R0yuatUH1gsLPTONHTScOpDZ3d+nZpIrJHNBRYFCV06uJ8F8CtyiKTcaMooy6826XOKEQDG+mQ/AqIUKBaCYmiIxdWMVr+GrOQwIeUBBE/m/HSSIsmU28KRRirIZJFsikyZGvZGXIOmGIIWoQj859E8l3OwU9RLgVZIRrhvYtR5g5TpVXeekg314YB6pslMTMoNqpclrimR4GY0zB/2SBBo51INh0EmXHA5GWk7sBjJBBEe3l0bdYYw37xkevhTqj/nrGycm7ZlNukxuG69t18tNYfbSdr4JnhG29Funyn+1axq71CIDorzt1cW/Hud5rY1D2AdNDggRiuMw1PaYxal+WvgqlzDhFW/8r66SHwN6UsPDByZ2OKQ2q+8arUaIL2sTVlKXUz7SL4qB000q8+4Qdz9PB6m5Gcy7rpep03CIift/nud/5UZznaGvN1xeW8bvY5VuJlIqO0qLKS/03eAovQ6vWyuHZZ+hz+eIK/d51hvt+IegsvrKk3BjisbsMs/5jncD78f7WwHLcmxwHNAcI90rS0JxBAQvYrsfn+w7mi6PC+VzoBB10UluYGsPQfe8a/K6egwK/ZqL/3boI2ME8sVoB7j+stBiWaF577rwkWzD11jUXYeNoHk2d+UrT1rHmxkhoxhhp0kjAt30fRRt7thFFPRIyd5x0i9cf41Bqw4oIRfbY7U
 0N8sq/vA
 EaLylkrNHO8IEyCN/FS1JhQH8+NDqn47sRW2vZJv14chEww8EyjSyq+tXNLVj+vanvcRKNgPWCtzAszgpQOxf3R2UvCQp4/+CZB5FFfOfZ3s6GVQbylfYVsLG9DQdt2Q4poQm23mHavRiKYpaMLvdF/ktfYV/YpaFOHWZfJd8K6cH9UpYXi9j3yh1Fou+OZIDeZxElqDoCTNHsiZnUsIuWqZlDhbEhvPciuRRgGdk2GEOoeYEd50e7L0CatwCjJaMLqOm3n4izscp9s3NSKVe1u+tA10o7kuS9hGELI560MhpazIeVbwdnF20u9p8+0lsV0CNR+3oq2Z8wXjDdb0QLe9EE6GI8sK0yD87UYQSpZ+pwupw7G1ICVCX6QnBeYc16Mar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/03/26 9:17 pm, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 11, 2026 at 01:39:25PM +0530, Dev Jain wrote:
>>
>>
>> On 10/03/26 3:08 pm, Lorenzo Stoakes (Oracle) wrote:
>>> On Tue, Mar 10, 2026 at 01:00:12PM +0530, Dev Jain wrote:
>>>> In the quest of enabling batched unmapping of anonymous folios, we need to
>>>> handle the sharing of exclusive pages. Hence, a batched version of
>>>> folio_try_share_anon_rmap_pte is required.
>>>>
>>>> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
>>>> to do some rmap sanity checks. Add helpers to set and clear the
>>>> PageAnonExclusive bit on a batch of nr_pages. Note that
>>>> __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR from the
>>>> PMD path, but currently we only clear the bit on the head page. Retain this
>>>> behaviour by setting nr_pages = 1 in case the caller is
>>>> folio_try_share_anon_rmap_pmd.
>>>>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>>  include/linux/page-flags.h | 11 +++++++++++
>>>>  include/linux/rmap.h       | 28 ++++++++++++++++++++++++++--
>>>>  mm/rmap.c                  |  2 +-
>>>>  3 files changed, 38 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>>> index 0e03d816e8b9d..1d74ed9a28c41 100644
>>>> --- a/include/linux/page-flags.h
>>>> +++ b/include/linux/page-flags.h
>>>> @@ -1178,6 +1178,17 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>>>>  	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>>>>  }
>>>>
>>>> +static __always_inline void ClearPagesAnonExclusive(struct page *page,
>>>> +		unsigned int nr)
>>>
>>> You're randomly moving between nr and nr_pages, can we just consistently use
>>> nr_pages please.
>>
>> Okay.
>>
>>>
>>>> +{
>>>> +	for (;;) {
>>>> +		ClearPageAnonExclusive(page);
>>>> +		if (--nr == 0)
>>>
>>> You really require nr to != 0 here or otherwise you're going to be clearing 4
>>> billion pages :)
>>
>> I'm following the pattern in pgtable.h, see set_ptes,
>> clear_young_dirty_ptes, etc.
>>
>>>
>>>> +			break;
>>>> +		++page;
>>>> +	}
>>>> +}
>>>
>>> Can we put this in mm.h or somewhere else please, and can we do away with this
>>
>> What is the problem with page-flags.h? I am not very aware on which
>> function to put in which header file semantically, so please educate me on
>> this.
> 
> It's a mess in there and this this doesn't really belong.
> 
>>
>>> HorribleNamingConvention, this is new, we can 'get away' with making it
>>> something sensible :)
>>
>> I'll name it folio_clear_pages_anon_exclusive.
> 
> OK
> 
>>
>>
>>>
>>> I wonder if we shouldn't also add a folio pointer here, and some
>>> VM_WARN_ON_ONCE()'s. Like:
>>>
>>> static inline void folio_clear_page_batch(struct folio *folio,
>>> 					  struct page *first_subpage,
>>> 					  unsigned int nr_pages)
>>> {
>>> 	struct page *subpage = first_subpage;
>>>
>>> 	VM_WARN_ON_ONCE(!nr_pages);
>>> 	VM_WARN_ON_ONCE(... check first_subpage in folio ...);
>>> 	VM_WARN_ON_ONCE(... check first_subpage -> first_subpage + nr_pages in folio ...);
>>
>> I like what you are saying, but __folio_rmap_sanity_checks in the caller
>> checks exactly this :)
> 
> This is a shared function that can't be assumed to always be called from a
> context where that has run. VM_WARN_ON_ONCE()'s are free in release kernels so I
> don't think it should be such an issue.
> 
>>
>>>
>>> 	while (nr_pages--)
>>> 		ClearPageAnonExclusive(subpage++);
>>> }
>>>
>>>> +
>>>>  #ifdef CONFIG_MMU
>>>>  #define __PG_MLOCKED		(1UL << PG_mlocked)
>>>>  #else
>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>> index 1b7720c66ac87..7a67776dca3fe 100644
>>>> --- a/include/linux/rmap.h
>>>> +++ b/include/linux/rmap.h
>>>> @@ -712,9 +712,13 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>>>  	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
>>>>  	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
>>>>
>>>> +	/* We only clear anon-exclusive from head page of PMD folio */
>>>
>>> Is this accurate? David? I thought anon exclusive was per-subpage for any large
>>> folio...?
>>
>> The current behaviour is to do this only. I was also surprised with this,
>> so I had dug in and found out:
>>
>> https://lore.kernel.org/all/20220428083441.37290-13-david@redhat.com/
>>
>> where David says:
>>
>> "Long story short: once
>> PTE-mapped, we have to track information about exclusivity per sub-page,
>> but until then, we can just track it for the compound page in the head
>> page and not having to update a whole bunch of subpages all of the time
>> for a simple PMD mapping of a THP."
> 
> OK
> 
>>
>>
>>>
>>> If we're explicitly doing this for some reason here, then why introduce it?
>>>
>>>> +	if (level == PGTABLE_LEVEL_PMD)
>>>> +		nr_pages = 1;
>>>> +
>>>>  	/* device private folios cannot get pinned via GUP. */
>>>>  	if (unlikely(folio_is_device_private(folio))) {
>>>> -		ClearPageAnonExclusive(page);
>>>> +		ClearPagesAnonExclusive(page, nr_pages);
>>>
>>> I really kind of hate this 'we are looking at subpage X with variable page in
>>> folio Y, but we don't mention Y' thing. It's super confusing that we have a
>>> pointer to a thing which sometimes we deref and treat as a value we care about
>>> and sometimes treat as an array.
>>>
>>> This pattern exists throughout all the batched stuff and I kind of hate it
>>> everywhere.
>>>
>>> I guess the batching means that we are looking at a sub-folio range.
>>>
>>> If C had a better type system we could somehow have a type that encoded this,
>>> but it doesn't :>)
>>>
>>> But I wonder if we shouldn't just go ahead and rename page -> pages and be
>>> consistent about this?
>>
>> Agreed. You are correct in saying that this function should receive struct
>> folio to assert that we are essentially in a page array, and some sanity
>> checking should happen. But the callers are already doing the checking
>> in folio_rmap_sanity_checks. Let me think on this.

I have no idea why I used the word "caller" here. Its been some weeks so hopefully
my brain works more coherently after a vacation ...

See folio_add_anon_rmap_ptes, folio_remove_rmap_ptes, folio_try_dup_anon_rmap_ptes
etc, all of them eventually assert the constraints in the deeper functions -
__folio_add_rmap, __folio_remove_rmap, __folio_try_dup_anon_rmap - via __folio_rmap_sanity_checks.

So I meant to say that the batched function advertised to the rest of the mm code
eventually checks all of this.

Indeed my argument regarding "folio_pte_batch() in the caller already checks this"
is shaky as you correctly reason.

So, following the pattern in these functions, I can probably drop all of the
"Context: " part, or just mention that the page table lock needs to be held.

Regarding how to assert that [page, page + nr_pages) lies in the folio ...

renaming page -> pages sounds somewhat confusing - usually when we mean
"an array of pages", we pass a double pointer.

I think the main thing we are missing to document here is that all the
batched functions present in the mm code have an unsaid prerequisite -
the caller *always* first goes through folio_pte_batch_flags() -
(if I am wrong on this then please correct me) the caller cannot construct
an nr_pages and pass it to a batched function, without first checking whether
those nr_pages are "uniform" in some bits, which is why we first go through
folio_pte_batch_flags.

So one alternate solution is to update kerneldoc of every batched helper
to say that the nr_pages passed here must be derived from folio_pte_batch_flags.

Another alternate I was thinking was to do something like

struct folio_subrange {
	struct folio *folio;
	struct page *first_page;
	unsigned long nr_pages;
}

and have a constructor which will do folio_subrange_init() and do the necessary
checks. Then we change all batched functions to accept this. Not sure how
convincing this is.


> 
> You treat that like a license to never put an assert anywhere else in mm... In
> any case I'm not sure I mentioend an assert here, more so the pattern around
> folio v.s subpages.
> 
>>
>>
>>>
>>>>  		return 0;
>>>>  	}
>>>>
>>>> @@ -766,7 +770,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>>>
>>>>  	if (unlikely(folio_maybe_dma_pinned(folio)))
>>>>  		return -EBUSY;
>>>> -	ClearPageAnonExclusive(page);
>>>> +	ClearPagesAnonExclusive(page, nr_pages);
>>>>
>>>>  	/*
>>>>  	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
>>>> @@ -804,6 +808,26 @@ static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
>>>>  	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
>>>>  }
>>>>
>>>> +/**
>>>> + * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
>>>> + *				    mapped by PTEs possibly shared to prepare
>>>> + *				   for KSM or temporary unmapping
>>>
>>> This description is very confusing. 'Try marking exclusive anonymous pages
>>> [... marking them as what?] mapped by PTEs[, or (]possibly shared[, or )] to
>>> prepare for KSM[under what circumstances? Why mention KSM here?] or temporary
>>> unmapping [why temporary?]
>>>
>>> OK I think you mean to say 'marking' them as 'possibly' shared.
>>>
>>> But really by 'shared' you mean clearing anon exclusive right? So maybe the
>>> function name and description should reference that instead.
>>>
>>> But this needs clarifying. This isn't an exercise in minimum number of words to
>>> describe the function.
>>>
>>> Ohhh now I see this is what the comment is in folio_try_share_anon_rmap_pte() :P
>>>
>>> Well, I wish we could update the original too ;) but OK this is fine as-is to
>>> matc that then.
>>>
>>>> + * @folio:	The folio to share a mapping of
>>>> + * @page:	The first mapped exclusive page of the batch
>>>> + * @nr_pages:	The number of pages to share (batch size)
>>>> + *
>>>> + * See folio_try_share_anon_rmap_pte for full description.
>>>> + *
>>>> + * Context: The caller needs to hold the page table lock and has to have the
>>>> + * page table entries cleared/invalidated. Those PTEs used to map consecutive
>>>> + * pages of the folio passed here. The PTEs are all in the same PMD and VMA.
>>>
>>> Can we VM_WARN_ON_ONCE() any of this? Not completely a necessity.
>>
>> Again, we have WARN checks in folio_rmap_sanity_checks, and even in
>> folio_pte_batch. I am afraid of duplication.
> 
> Why on earth are you bothering with 'context' then?
> 
> If having run folio_rmap_sanity_checks() means we never have to assert or think
> about state or context again then why bother?
> 
> I looked in __folio_rma_sanity_checks() and I see no:
> 
> Breaking it down:
> 
> Context: The caller needs to hold the page table lock and has to have the
>          page table entries cleared/invalidated. Those PTEs used to map consecutive
>          pages of the folio passed here. The PTEs are all in the same PMD and VMA.
> 
> - Page table lock <-- NOT checked
> - Page table entries cleared/invalidated <-- NOT checked
> - PTEs passed in must map all pages in the folio? <-- you aren't passing in PTEs?
> - PTEs are all in the same PMD <- You aren't passing in PTEs?
> - PTES are all in the same VMA <- You aren't passing in PTEs?
> 
> So that's hardly a coherent picture no?
> 
>>
>>>
>>>> + */
>>>> +static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
>>>> +		struct page *page, unsigned int nr)
>>>> +{
>>>> +	return __folio_try_share_anon_rmap(folio, page, nr, PGTABLE_LEVEL_PTE);
>>>> +}
>>>> +
>>>>  /**
>>>>   * folio_try_share_anon_rmap_pmd - try marking an exclusive anonymous page
>>>>   *				   range mapped by a PMD possibly shared to
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 42f6b00cced01..bba5b571946d8 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2300,7 +2300,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>
>>>>  			/* See folio_try_share_anon_rmap(): clear PTE first. */
>>>>  			if (anon_exclusive &&
>>>> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>>>> +			    folio_try_share_anon_rmap_ptes(folio, subpage, 1)) {
>>>
>>> I guess this is because you intend to make this batched later with >1, but I
>>> don't see the point of adding this since folio_try_share_anon_rmap_pte() already
>>> does what you're doing here.
>>>
>>> So why not just change this when you actually batch?
>>
>> It is generally the consensus to introduce a new function along with its
>> caller. Although one may argue that the caller introduced here is not
> 
> That's not always the case, sometimes it makes more sense and is cleaner to
> introduce it first.
> 
> All rules of thumb are open to sensible interpretation.
> 
> I'm not sure arbitrarily using the function in a way that makes no sense in the
> code is a good approach but this isn't the end of the world.
> 
>> a functional change (still passing nr_pages = 1). So I am fine doing
>> what you suggest.
>>
>>>
>>> Buuuut.... haven't you not already changed this whole function to now 'jump'
>>> ahead if batched, so why are we only specifying nr_pages = 1 here?
>>
>> Because...please bear with the insanity :) currently we are in a ridiculous
>> situation where
>>
>> nr_pages can be > 1 for file folios, and lazyfree folios, *and* it is
>> required that the VMA is non-uffd.
>>
>> So, the "jump" thingy I was doing in the previous patch was adding support
>> for file folios, belonging to uffd VMAs (see pte_install_uffd_wp_if_needed,
>> we need to handle uffd-wp marker for file folios only, and also I should
>> have mentioned "file folio" in the subject line of that patch, of course
>> I missed that because reasoning through this code is very difficult)
>>
>> To answer your question, currently for anon folios nr_pages == 1, so
>> the jump is a no-op.
>>
>> When I had discovered the uffd-wp bug some weeks back, I was pushing
>> back against the idea of hacking around it by disabling batching
>> for uffd-VMAs in folio_unmap_pte_batch, but solve it then and there
>> properly. Now we have too many cases - first we added lazyfree support,
>> then file-non-uffd support, my patch 5 adds file-uffd support, and
>> last patch finally completes this with anon support.
> 
> I am not a fan of any of that, this just speaks to the need to clean this up
> before endlessly adding more functionality and piles of complexity and
> confusion.
> 
> Let's just add some patches to do things sanely please.
> 
>>
>>
>>>
>>> Honestly I think this function needs to be fully refactored away from the
>>> appalling giant-ball-of-string mess it is now before we try to add in batching
>>> to be honest.
>>>
>>> Let's not accumulate more technical debt.
>>
>> I agree, I am happy to help in cleaning up this function.
> 
> Right, well then this series needs to have some clean up patches in it first.
> 
>>
>>>
>>>
>>>>  				folio_put_swap(folio, subpage, 1);
>>>>  				set_pte_at(mm, address, pvmw.pte, pteval);
>>>>  				goto walk_abort;
>>>> --
>>>> 2.34.1
>>>>
>>>
>>> Thanks, Lorenzo
>>
> 
> Thanks< Lorenzo
> 


