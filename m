Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C23CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE92C8E0003; Wed, 15 Oct 2025 04:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC12D8E0002; Wed, 15 Oct 2025 04:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFBC8E0003; Wed, 15 Oct 2025 04:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C30AA8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:43:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F08147BDB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:43:23 +0000 (UTC)
X-FDA: 83999709486.14.0AAB697
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95845A000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:43:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jF5VVwGB;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760517801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vN1LEfAFOswtHugzu9XIYq8P3c19bQGK8wW45PsaC+4=;
	b=ZnMf7lRNzY5e0Oa6FbsmPjSq3A6NyUqAggSVUkzlsHK1WHYXavrp6XfjOqKtbyVZ+H1yw2
	TGfmcr5KF9UtuciIHMfD12RUDUKkfoWLRinqsd4EibYxTdHV0TFhHSUttgi5Ex3VP5BfQk
	eORPjtR2L5ti4Q3LeOhA2w5Je3xvbyI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jF5VVwGB;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760517801; a=rsa-sha256;
	cv=none;
	b=3dLdCmO4FtsxwjxXUsPDqhTzND5iEhDvJibRh6TEsE3Ai5r8EaKv64XHueKNYe0qZFdTTz
	uTWXsS6hN4dg5n5DYepZfz2GBf9TmKEauf85Os/h8sRQz1oydvPpnALtqBzwMMbDpZPL8j
	nRleSmNPrTr3/lSXs9AnG37dVzJFYEU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760517798; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=vN1LEfAFOswtHugzu9XIYq8P3c19bQGK8wW45PsaC+4=;
	b=jF5VVwGBZSa+7aFnjbNhR71v09VL1UO4UmZfyQIkB2kmvJaGh+xbzpd07MzEZy9DNPzNJURDkQzKemvsORFC94VMjQy2dlDLs5N946DP3ARyPyPx01bnGdylAscbAkd+Zycf/uPJFkZ7HMwHinJc7r6+IRW3EyH5cT0w8+/zNTw=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqFjWUn_1760517795 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Oct 2025 16:43:16 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  David Hildenbrand
 <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Vlastimil
 Babka <vbabka@suse.cz>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ryan Roberts <ryan.roberts@arm.com>,
  Yang Shi <yang@os.amperecomputing.com>,  "Christoph Lameter (Ampere)"
 <cl@gentwo.org>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Yicong Yang <yangyicong@hisilicon.com>,  Kefeng Wang
 <wangkefeng.wang@huawei.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin
 Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge pmd
In-Reply-To: <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local> (Lorenzo
	Stoakes's message of "Tue, 14 Oct 2025 15:21:33 +0100")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-2-ying.huang@linux.alibaba.com>
	<4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
Date: Wed, 15 Oct 2025 16:43:14 +0800
Message-ID: <87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: ku7z5imskgtwktt9u3o3f5trddfki4t5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95845A000B
X-HE-Tag: 1760517800-522264
X-HE-Meta: U2FsdGVkX1+V0sdBy8zzMjvPiGthpeXLLJFtwOwP3TpqeIYMhHjSFbc1nRZPJ5x2opGCA4c/+RO3nGpzTxcFIEaE6gJTGptJYKcCh3o1UK4XsTeTCzBsfns10Hf8P2a0xBotwXdjI4WKo8xOD3a2OhgghhaZOmCttRmUqBTvsiRMbu3/CkQj+AgV/3OFYf7//eVjZUvH6fwrGtMtDavbpJGVOhfaIvZ3krioCNPQXQHEzBc7wx4LROU41xm1RMwQdaTpd5fQZ/DfPm6WUQmrFgSI3yQ1xRupVigqlPGkhrOYk9sVjgkC3OktrDpu+HZFAn1B8sNR5i/7xiNHGyjMIc5O6i+L3VITs1l1JpmTHGHoWP2CuFQT13dmknwXyaBFQ2YZ1LmmONKH6a+GyyOe+ZK97J5z3N4MjspL3tNS4L31eRmG5Af/pjnEdlm4yOLi0OpzUscqW8OiECR6N33akgYyf1V9Bs9Ost7pFjV5gXvZIOap5+GBp1WE7cJt3FKiwVEEvF/pHuvzE8IVmGcXFQrNSIvoCRYuV3QVME4xBTYEdlqGjolqeShjvsicfydXLlDqrQibKeEblirME52o+ebwKCApm+vQu1xv3i1FjVb82UAoCfhysfn9nqCNMdS0zLc1/63QFU/ZSaGvcB5ROThL7NWPJhm5XxXNkV41cChsa9+LUnprc9102ncMTtK+aWd1QEDFPNNVKd9dJ1a+VGaZXAuRNE6NVKl+DfQ3A2Yupe9wigBpTBzxI5yWSNDPDy4cX2yMY43ndj0h6BFkZemlvK5ntJr/vtnWssW/MF1INpzGBnvGR6dRjrbz2SZ7Qt7wrzb1Mgky5r34FO/ZygoDpV1ZGRoMFpQrEOM7qxFUD0NyUdpYK2jI0kFNcd5GsSEAvuC26uOv70fxJTeczCnWkA5iqL+CIKTq0jdleXUPVEOPubQOAmhABzzSCTez+yA/zfRsLGeNamMuFz8
 v7N2NNPM
 wJkoeRVcapO/R5r4lPae6EsHMLRbnuPxn0yANNceHd3or+z2SSA3gi2JzA9E3oabfkfV9SFgCLD9vTtVwmzX8tbBaf3/rhZR4vEtMBxHfPG65aDfDmmc2VdFllRUYMyISxm7oJZthIGg4WZCK2E+aV3AZjPxDZeSMjLDeZVWez3rnN2P9IziZAML/or/nw5Uobrt7EORE+eqwHGjVnlVJCdv/3Jx1mH/uDEdP/XwJQRbWwW59dMwdUPHkGFInMPNqBcSFDkGYodr7uL2G4A60Y9reAjwWi3wH8v4OHpU83Bc6Pv9fqxYv/n/q9SLwbYY2E10GtduYxBe7IDt9dsPnDHJxgB0/32tQC/BxQdFNHvFv/5ligxbwHqntbBXSuqVTNmeKL36NelMlFQjSR6GESBKs+IjT6ya2wF3qqa+9QUPVo2Vszxwokl/FuFOJgJ3mwnklePe1Lz8OMRla/I7OsD+sCGwPdjlE4+huNg78mJr8H18kMFViMK84kElymTB/IfhDAGAlhR6KJLUVmLYGrjPhw6YuTg7ZcefnBXy/P4zNBE+L8xE3N12GJXVbX1jjvoa3MLdmJGBphdEmyspSKI1h9GvVajBLAHElcd83XhBnhK1p9w7ueHl9UNAEwYaZRJJMhzEsOpTMzhuwgdBS1rpcoDZj1esuKh2yJHbkq9vIjPG+fuLrxmjrvUc5ppySupfDWbLAB2kvfmhs06J8Zwt0gWfiOJ+u5rcslqcT8Pn3sWyn2uNaoNbmjWTGdcCI34m4Tfl3RnGT+eTSrjbd49u6SUQLRjNZs/2z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Lorenzo,

Thanks for comments!

Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:

> On Mon, Oct 13, 2025 at 05:20:37PM +0800, Huang Ying wrote:
>> In the current kernel, there is spurious fault fixing support for pte,
>> but not for huge pmd because no architectures need it. But in the
>> next patch in the series, we will change the write protection fault
>> handling logic on arm64, so that some stale huge pmd entries may
>> remain in the TLB. These entries need to be flushed via the huge pmd
>> spurious fault fixing mechanism.
>>
>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>
> Right now the PTE level spurious fault handling is dealt with in
> handle_pte_fault() when ptep_set_access_flags() returns false.
>
> Now you're updating touch_pmd() which is invoked by follow_huge_pmd() and
> huge_pmd_set_accessed().
>
> 1 - Why are you not adding handling to GUP?
>
> 2 - Is this the correct level of abstraction? It's really not obvious but
>     huge_pmd_set_accessed() is invoked by __handle_mm_fault() on a non-WP,
>     non-NUMA hint huge page fault where a page table entry already exists
>     but we are faulting anyway (e.g. non-present or read-only writable).
>
> You don't mention any of this in the commit message, which you need to do
> and really need to explain how spurious faults can arise, why you can only
> do this at the point of abstraction you do (if you are unable to put it in
> actual fault handing-code), and you need to add a bunch more comments to
> explain this.

This patch adds the spurious PMD page fault fixing based on the spurious
PTE page fault fixing.  So, I assumed that the spurious page fault
fixing has been documented already.  But you are right, nothing prevents
us from improving it further.  Let's try to do that.

The page faults may be spurious because of the racy access to the page
table.  For example, a non-populated virtual page is accessed on 2 CPUs
simultaneously, thus the page faults are triggered on both CPUs.
However, it's possible that one CPU (say CPU A) cannot find the reason
for the page fault if the other CPU (say CPU B) has changed the page
table before the PTE is checked on CPU A.  Most of the time, the
spurious page faults can be ignored safely.  However, if the page fault
is for the write access, it's possible that a stale read-only TLB entry
exists in the local CPU and needs to be flushed on some architectures.
This is called the spurious page fault fixing.

The spurious page fault fixing only makes sense during page fault
handling, so we don't need to do it for GUP.  In fact, I plan to avoid
it in all GUP paths in another followup patch.

As for where to put the spurious PMD page fault fixing code, because
it's THP related code, I thought that we should put it in huge_memory.c,
so I implemented it in huge_pmd_set_accessed().  If we follow the design
of the spurious PTE page fault fixing, we can call the unified
implementation in __handle_mm_fault() after huge_pmd_set_accessed()
reports nothing has been changed.

> Otherwise this just ends up being a lot of open-coded + confusing 'you have
> to go look it up/just know' type stuff that we have too much of in mm :)
>
> So please update commit message/comments, confirm whether this is the
> correct level of abstraction, and address other comments below, thanks!
>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Yang Shi <yang@os.amperecomputing.com>
>> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
>> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>>  include/linux/pgtable.h |  4 ++++
>>  mm/huge_memory.c        | 22 +++++++++++++++++-----
>>  mm/internal.h           |  4 ++--
>>  3 files changed, 23 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 32e8457ad535..341622ec80e4 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>>  #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
>>  #endif
>>
>> +#ifndef flush_tlb_fix_spurious_fault_pmd
>> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
>> +#endif
>
> flush_tlb_fix_spurious_fault(), when the arch doesn't declare it, defaults to
> flush_tlb_page() - why do we just do nothing in this case here?

Because all architectures do nothing for the spurious PMD page fault
fixing until the [2/2] of this series.  Where, we make it necessary to
flush the local TLB for spurious PMD page fault fixing on arm64
architecture.

If we follow the design of flush_tlb_fix_spurious_fault(), we need to
change all architecture implementation to do nothing in this patch to
keep the current behavior.  I don't think that it's a good idea.  Do
you agree?

>> +
>>  /*
>>   * When walking page tables, get the address of the next boundary,
>>   * or the end address of the range if that comes earlier.  Although no
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1b81680b4225..8533457c52b7 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1641,17 +1641,22 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
>>  EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
>>  #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>
>> -void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>> -	       pmd_t *pmd, bool write)
>> +/* Returns whether the PMD entry is changed */
>
> Could we have a kernel doc description here?

Sure.

>> +int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>
> It's 2025 can we use bool please :)

Sure.

>> +	      pmd_t *pmd, bool write)
>>  {
>> +	int changed;
>>  	pmd_t _pmd;
>
> While we're here can we rename this horrible parameter name to e.g. entry? We're
> significantly altering this function anyway so it isn't much more

Sure.

>>
>>  	_pmd = pmd_mkyoung(*pmd);
>>  	if (write)
>>  		_pmd = pmd_mkdirty(_pmd);
>> -	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
>> -				  pmd, _pmd, write))
>> +	changed = pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
>> +					pmd, _pmd, write);
>> +	if (changed)
>>  		update_mmu_cache_pmd(vma, addr, pmd);
>
> We can make this simpler, e.g.:
>
> 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
> 				  pmd, entry, write)) {
> 		update_mmu_cache_pmd(vma, addr, pmd);
> 		return true;
> 	}
>
> 	return false;

No problem.  As long as David is OK with this.

>> +
>> +	return changed;
>>  }
>>
>>  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>> @@ -1849,7 +1854,14 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
>>  	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
>>  		goto unlock;
>>
>> -	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
>> +	if (!touch_pmd(vmf->vma, vmf->address, vmf->pmd, write)) {
>> +		/* See corresponding comments in handle_pte_fault(). */
>
> What are the 'corresponding' comments? How can a reader of this code know what
> they are? This isn't a very helpful comment. Also those comments might be
> moved in future...
>
> Presumably it's:
>
> 		/* Skip spurious TLB flush for retried page fault */
> 		if (vmf->flags & FAULT_FLAG_TRIED)
> 			goto unlock;
> 		/*
> 		 * This is needed only for protection faults but the arch code
> 		 * is not yet telling us if this is a protection fault or not.
> 		 * This still avoids useless tlb flushes for .text page faults
> 		 * with threads.
> 		 */
> 		if (vmf->flags & FAULT_FLAG_WRITE)
> 			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
> 						     vmf->pte);
>
>
> So I don't see why it's so egregious to have the equivalent here, or actually
> ideally to abstract the code entirely.
>
> In commit b22cc9a9c7ff ("mm/rmap: convert "enum rmap_level" to "enum
> pgtable_level"") David introduced:
>
> 	enum pgtable_level {
> 		PGTABLE_LEVEL_PTE = 0,
> 		PGTABLE_LEVEL_PMD,
> 		PGTABLE_LEVEL_PUD,
> 		PGTABLE_LEVEL_P4D,
> 		PGTABLE_LEVEL_PGD,
> 	};
>
> Which allows for sensible abstraction.

Sure.  Based on your discussion with David on this, I will add a
function to do the spurious page fault fixing for the PTE and PMD fault.

>> +		if (vmf->flags & FAULT_FLAG_TRIED)
>> +			goto unlock;
>> +		if (vmf->flags & FAULT_FLAG_WRITE)
>> +			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
>> +							 vmf->pmd);
>> +	}
>>
>>  unlock:
>>  	spin_unlock(vmf->ptl);
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1561fc2ff5b8..8b58ab00a7cd 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1402,8 +1402,8 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
>>   */
>>  void touch_pud(struct vm_area_struct *vma, unsigned long addr,
>>  	       pud_t *pud, bool write);
>> -void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>> -	       pmd_t *pmd, bool write);
>> +int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>> +	      pmd_t *pmd, bool write);
>>
>>  /*
>>   * Parses a string with mem suffixes into its order. Useful to parse kernel
>> --
>> 2.39.5
>>

---
Best Regards,
Huang, Ying

