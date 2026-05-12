Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E7ECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341156B008A; Tue, 12 May 2026 01:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3C26B008C; Tue, 12 May 2026 01:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CC96B0092; Tue, 12 May 2026 01:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00C5B6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:59:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A51701C0287
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:59:15 +0000 (UTC)
X-FDA: 84757715070.12.E790F57
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CDC111A0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:59:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GKw/OT+l";
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778565554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4GI5sg7ZA1+8J3qUDRkE/CR8KNp2SwHD5iZtnEuqb8=;
	b=RmyhTOkF1VnpV47tUjwyDW9OlCcDGJW0OQwKToqIjPm2A3uYtfvr6xeLemcePZV7rOmzk2
	OnT80LSRVc8sajDULhbiTfXtt2r6uarol6TQPH3BdhfHOv9NCb8BiRPBxtZp1wRYbM+Drm
	1jr5FNCN9heePtGl1QdvhkMBq9GkW7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GKw/OT+l";
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778565554; a=rsa-sha256;
	cv=none;
	b=RbyyCn47A3bjemprV6XNMfxpIX0aFmCXlUWvH0Qh1PZXh1VofpofRyk4thKdZdezHGZi1j
	dUKjjRiZX/GCDhv+afImBCodrSl9Z1Qsdt3jOIherZ4sjEMVvn51/kj1WqoWClvnTn8voO
	FxGyxOcBPP+Qqe9vIMajqU/wSnLf+dI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC891691;
	Mon, 11 May 2026 22:59:07 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65F343F85F;
	Mon, 11 May 2026 22:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778565552; bh=JCYzFh2p3KHpCECa75vfHl1ln78s6zH+bg/pm+7JBm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GKw/OT+lB3l1dxnftq78lgBEvVmARysDg5OtSIt8bA/Y9aR6w/u75xbPN5yHturYr
	 6uE2bQOCHNtux/y8TLzNVtju+DviYQLPnEeSd7/zU3dfVFwhUo5bvgCjHLB3wock9U
	 vD6SzIyJGPcTiyXjSqM3Os0+dubnsvnyTrPPtAdU=
Message-ID: <45ad2925-9d01-427a-9ac0-650c4b2d07e4@arm.com>
Date: Tue, 12 May 2026 11:29:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm/memory: Batch set uffd-wp markers during
 zapping
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-5-dev.jain@arm.com>
 <4b36ddb9-c11a-4320-85d4-3e059e67384f@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4b36ddb9-c11a-4320-85d4-3e059e67384f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDC111A0002
X-Stat-Signature: 3apre47krun7busi85n5ffa76m7k9iap
X-HE-Tag: 1778565553-584419
X-HE-Meta: U2FsdGVkX187znJuEChjetGXjCQ76NHuHkBEO4hyMxxMt1h2S537Sqch9D7IW5aHqiV8AILEJdoL72MkSzoG8IpMBoSwEyzWzMSieKvljlIgmVRZRISrdli3+g9SnNMpW36U/6HmN+rCUw2oOWp2n/rtRvL3oE7vmg2Qg7arCIT6qz0HBwgkP/X1fXX6gVygjxcXAbf/vmroJqRCyWhAYUTNjMSILXb31WwOjYRrfbFNqpBBgmGEti1oChzxNI+rImlj0VbNVy7maj416vxKn3UVaPuoES+TNWqRy3ouyx/cT2Oy4oXP4n/udZ0YePtBcZZivguibG2lXE/RflZkRru5kFa6uddorn1//uPIy3yMW1+s7polyoFZlPNMjtVxwLMYo088yCEespyKzBpQMAyf4EFnC6jbXjpgnkf6du/XAGmNEIVtkxf4jnRM879PleO+nDi5v5qBDXX7SG6uFCxE2gjnrYYA5WVdZriIgNurb2mymiNahF7Wd7xystVLxTc6sYSH2EFyOia9SAz1CS8JzkTE8gjrPtm6PEsMd6PTQTgOfCvDAyDeiZWosQGs6pSj3c67oU6PPMEPwkXQ50SJ5JeLnjEGILWz79zdSJ3iK5YUAY50uDtg1NI5X8+rdF/Xe/cBlT511/RAcHiN6DIb5LBWaY5rOheagb0Xrx2xN49+E6m2g+dkwgVRFNakuYB/bUEM07JvlaRkIztXXYK4rVD69J9bVKR3skiKwBFkArNnE715zaO41t8UZRucqVz71y9djFBv1KqKeRn1exLa5giWweafbaODPkPLIFtwUMF3YIDHiITKB1z0EooX9v4lLYHRbgtTeaWEeS1LqKktBXaP9CKcD8DyaDmsbI9bKhynLt5cW8DsR68rVPVDdWhT5mx+bwJ3S02e6HC8CrTmpYmKI2TfgReyp3Vr2U2p3SbFKrjiPgaOWdLF+PL18gZNiEAAVAPNgwTYcNp
 yX8RbGiY
 WpumiB7w9ZSq6buTETLjqo+WIDprsZkou6ejAMk3e3kFEXzmwGJP7GfUSyJD8AxqDGuGUEv01OUQj5Ysks6npuJuRRRWGaAxkLJF7qK8E63EcIGY+J2ps543YQ4136h2dY/0bRcdh/LyVyXmBNT0lpjE/t3aXvMV0r99IiszqWGn1RTfNEc2WnJ4XKpdr+VzmblbY1OFLJQVvNQWyyJ68GOtwyYlOYku7j1ojWv70W6VToEa2kuEB/Rl1vVV1uvrpUS0P31JJIfnLHx1mgurwGq2PbgVm7IXNAYeR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 1:07 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:44, Dev Jain wrote:
>> In preparation for the next patch, enable batch setting of uffd-wp ptes.
>>
>> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
>> that nr through either folio_pte_batch or swap_pte_batch, guaranteeing that
>> all ptes are the same w.r.t belonging to the same type of VMA (anonymous
>> or non-anonymous, wp-armed or non-wp-armed), and all being marked with
>> uffd-wp or all being not marked.
>>
>> Note that we will have to use set_pte_at() in a loop instead of set_ptes()
>> since the latter cannot handle present->non-present conversion for
>> nr_pages > 1.
>>
>> Convert documentation of install_uffd_wp_ptes_if_needed to kerneldoc
>> format.
> 
> You should mention why the uffd_supports_wp_marker()+vma_is_anonymous() calls in
> zap_install_uffd_wp_if_needed can be dropped.

Okay.

> 
>>
>> No functional change is intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/mm_inline.h | 34 +++++++++++++++++++++-------------
>>  mm/memory.c               | 20 +-------------------
>>  mm/rmap.c                 |  2 +-
>>  3 files changed, 23 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index a171070e15f05..6f7ecede2fb45 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -566,9 +566,17 @@ static inline pte_marker copy_pte_marker(
>>  	return dstm;
>>  }
>>  
>> -/*
>> - * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
>> - * replace a none pte.  NOTE!  This should only be called when *pte is already
>> +/**
>> + * install_uffd_wp_ptes_if_needed - install uffd-wp marker on PTEs that map
>> + *				    consecutive pages of the same large folio.
>> + * @vma: The VMA the pages are mapped into.
>> + * @addr: Address the first page of this batch is mapped at.
>> + * @ptep: Page table pointer for the first entry of this batch.
>> + * @pteval: old value of the entry pointed to by ptep.
>> + * @nr_ptes: Number of entries to clear (batch size).
>> + *
>> + * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
>> + * replace none ptes.  NOTE!  This should only be called when *pte is already
>>   * cleared so we will never accidentally replace something valuable.  Meanwhile
>>   * none pte also means we are not demoting the pte so tlb flushed is not needed.
>>   * E.g., when pte cleared the caller should have taken care of the tlb flush.
>> @@ -576,11 +584,11 @@ static inline pte_marker copy_pte_marker(
>>   * Must be called with pgtable lock held so that no thread will see the none
>>   * pte, and if they see it, they'll fault and serialize at the pgtable lock.
>>   *
>> - * Returns true if an uffd-wp pte was installed, false otherwise.
>> + * Returns true if uffd-wp ptes were installed, false otherwise.
>>   */
>>  static inline bool
>> -pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>> -			      pte_t *pte, pte_t pteval)
>> +install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma, unsigned long addr,
>> +			      pte_t *ptep, pte_t pteval, unsigned long nr_ptes)
> 
> If we conditionally do something, what about while at it shorten it to:
> 
> 	cont_install_uffd_wp_ptes()

Why "cont_"? Did you mean to say "cond" ("conditionally").

> 
> Also, less churn in this patch if you don't change pte->ptep
> 
> (because if you do, you should then also do pteval->pte :) )
> 
> So I'd just leave that as is in this patch.

So I'll change pte->ptep and pteval->pte because I hate pte pointers
called pte : )
> 
>>  {
>>  	bool arm_uffd_pte = false;
>>  
>> @@ -588,7 +596,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>>  		return false;
>>  
>>  	/* The current status of the pte should be "cleared" before calling */
>> -	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
>> +	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
>>  
>>  	/*
>>  	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
>> @@ -610,13 +618,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>>  	if (unlikely(pte_swp_uffd_wp_any(pteval)))
>>  		arm_uffd_pte = true;
>>  
>> -	if (unlikely(arm_uffd_pte)) {
>> -		set_pte_at(vma->vm_mm, addr, pte,
>> -			   make_pte_marker(PTE_MARKER_UFFD_WP));
>> -		return true;
>> -	}
>> +	if (likely(!arm_uffd_pte))
>> +		return false;
>>  
>> -	return false;
>> +	for (int i = 0; i < nr_ptes; ++i, ++ptep, addr += PAGE_SIZE)
>> +		set_pte_at(vma->vm_mm, addr, ptep, make_pte_marker(PTE_MARKER_UFFD_WP));
>> +
>> +	return true;
>>  }
> 
> I wonder whether this growing function is really appropriate to be in the header
> file? Can we just move that whole thing into mm/memory.c?
> 
> It's called on every try_to_unmap_one() invocation, but I doubt we care about a
> function call here.

Makes sense.

> 
>>  
>>  static inline bool vma_has_recency(const struct vm_area_struct *vma)
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 0c9d9c2cbf0e0..f14311c4d2001 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1610,29 +1610,11 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>>  			      unsigned long addr, pte_t *pte, int nr,
>>  			      struct zap_details *details, pte_t pteval)
>>  {
>> -	bool was_installed = false;
>> -
>> -	if (!uffd_supports_wp_marker())
>> -		return false;
>> -
>> -	/* Zap on anonymous always means dropping everything */
>> -	if (vma_is_anonymous(vma))
>> -		return false;
>> -
>>  	if (zap_drop_markers(details))
>>  		return false;
>>  
>> -	for (;;) {
>> -		/* the PFN in the PTE is irrelevant. */
>> -		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
>> -			was_installed = true;
>> -		if (--nr == 0)
>> -			break;
>> -		pte++;
>> -		addr += PAGE_SIZE;
>> -	}
>> +	return install_uffd_wp_ptes_if_needed(vma, addr, pte, pteval, nr);
>>  
>> -	return was_installed;
>>  }
>>  
>>  static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index bd4e3639e26ed..b17dce752a1ea 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2266,7 +2266,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		 * we may want to replace a none pte with a marker pte if
>>  		 * it's file-backed, so we don't lose the tracking info.
>>  		 */
>> -		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
>> +		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
>>  
>>  		/* Update high watermark before we lower rss */
>>  		update_hiwater_rss(mm);
> 
> 


