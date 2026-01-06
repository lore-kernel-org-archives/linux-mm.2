Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFD2CE9D66
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8583D6B0093; Tue,  6 Jan 2026 10:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7286B0095; Tue,  6 Jan 2026 10:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4366B0096; Tue,  6 Jan 2026 10:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2CE6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:41:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DBC2B82AA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:41:57 +0000 (UTC)
X-FDA: 84301954674.28.2715282
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 84ADB40004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:41:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sD2z4exr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767714115; a=rsa-sha256;
	cv=none;
	b=bUsK0AoOm58KAAX57YCjS6bRDq1qe4ysUD28jlVREziqrLd9rLTS+h2lDs5aDoK2lfv55h
	XGlHGtHZ3kq5yHS7LTyETLJOUtlPFhmUBAdZubW0QOYbXJGTebe4tn4dqLq1set9mtBirA
	gGLJkdKMW6HD1LJuyEZVERxnBQdOCrY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sD2z4exr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767714115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iByVDmD38s5JhKFTtjPltcBnKNB8pZjXuWFjepg4AvA=;
	b=w3wyQxVK3CB2CLMC2MaQcI+sO49aMxSLTiVRNhGO//h7ZHy333tX5HIy+URSd5bECT4PMS
	M0Pk65LJZor6vZ6JOFj5vTdIPamkxNXdrZ/dI0jk3lrWSxshZUjYZyhisz5Si54fncMjrv
	G5p15VxEHZlJTR4hDPRnSQwJWFxXaPo=
Message-ID: <3e9b27dd-1051-4e40-bd80-0fbbda957f0a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767714111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iByVDmD38s5JhKFTtjPltcBnKNB8pZjXuWFjepg4AvA=;
	b=sD2z4exrVkndcJilqghsE+zBxBQlO4GkU6WEAENU2y/YSmHFjdi3JTPErwJYLi/S6hOC5g
	K3Tj5j/A4Vgiw8fOP7YZy+k0Gct6uXHjin7ywdKBTxxMx1USdipaMVe0zKaSfDKvUeKywG
	BI6f+S2C2Miu+O/fpieSq1/S8e9OOns=
Date: Tue, 6 Jan 2026 23:41:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND v3 2/2] mm: introduce pmdp_collapse_flush_sync() to
 skip redundant IPI
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: dave.hansen@intel.com, dave.hansen@linux.intel.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-3-lance.yang@linux.dev>
 <86ab8a1f-f6a3-4523-8ccc-f99edfd30a7e@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <86ab8a1f-f6a3-4523-8ccc-f99edfd30a7e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84ADB40004
X-Stat-Signature: aa57mzypu4hbe1jko4ang7r7ngpeabsq
X-Rspam-User: 
X-HE-Tag: 1767714113-469338
X-HE-Meta: U2FsdGVkX1+Dtkm9SjKWZZ8dgJ0AN+4dKVbla1KH+wVu5BXo2xXXjMfwAc0c7HvF9Y5Sl5N0VNPs1fX7H6qAucYG5JkSaREblqLr+1QMugO1AhIbHHykVNHn80/uaitT1/WRigGDkRIM3LZPae0e9t1A7a15rFQ5TXuTJrGKTN5RKo/7Ex94gicxT7AZqy2TEuDCNEjq6f2z6IGMigA8avbKvP8czQCjtG4OfXZl1327KuY7gAR3oQ9Ug51Ox0I1s6RmULnizRhbRsD0kBbDgQo70bcfdysNGYoUKL9nmmKjtnbznR+o9BaUXtDqB/yqJpG/RPZdSU+PPcJ3RmzP4ZFPFCbKpQf7rVJHzko/68zV6ic98rKlvYpSnqYmc58lOuI3rVES4fUH7RuZyRyBs8mkcGViCpJDrRBnEts79b9uiyjVTrZOp6WC904gZFNJqEx9NCe1fVHy6RpehinkdSOWdm51Y7iBrKUHMIgODFl+Lj9mTjqeUQUdTFF5dwnIzE+Po4R74HGALAKPKVRDhruYedc6TqjKWv8h+JIgQWXmer/20GX92Yq09Eju6Av0HQZS9IVEorC7uDlhGQiMbXQGqdLd6JiHki6/S0TMr8EGYhO/W2DbmLtYLsFdwNK92SA2VQJdNpCwaiN7qtARH8vqb4mofE2bKygKBbxNYzxgxpBm1j0pr3VC2qA+pcI8/lyoBKuRFYhFxMddZAItN8w95yFrcQeAY7I3zcW8XgNenGSWXIatox2z3ZbOlNiIJLGwhUe77fpn+yscv3TzQWYvSvvt/YYE02YTUAtDSkJuwl1E2wX/qxFB6jjxRN5EaYQACB9Nf/OSsaMhtmwF4XlaL2iV9A8afyOgQR8uiKl9oPIdjqN9LOvF7iZlTidzTLMmqx/LN5V9fUUVD0opvsGlQ3tGjAdFz5gx/6if/AyW6AyegruuWqekvHNxBcNAWwb98/FEcxMrIj7AOI0
 mU9jJwze
 oh4ELtb0XJ2Qw07btdzDtgQ/RNm95dkfRDWFpgU4pnkaaS4Awg6Ivd8ulpl/fHbWCSdc+GoHnGiKQzsxFsakqB/znlFT2YsvuhF0je5V92IoJsCJETUNe/bTxE9aODDFNcxHYko+CrQHZA3ETV2RzFlDswUY+lu6uv4zzdWip1Lnhy3yHlSHQ8yRSHvJD/7KzjxFWqyVF7GmSIA4hWBMZTJ1Ja7XYpE4rj/UU1jcm1DTtZdqGD9Uwj4wvzMExa43FUIgsIXmpEJ0BZ5tBuiMJV8u+2EZB+N6NeltqsoIkD9BBZoqzG2YV444W0GcH2fGX4T9bfG1OeuLW1zLAi0uzzRGp/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/6 23:07, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 13:03, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> pmdp_collapse_flush() may already send IPIs to flush TLBs, and then
>> callers send another IPI via tlb_remove_table_sync_one() or
>> pmdp_get_lockless_sync() to synchronize with concurrent GUP-fast walkers.
>>
>> However, since GUP-fast runs with IRQs disabled, the TLB flush IPI 
>> already
>> provides the necessary synchronization. We can avoid the redundant second
>> IPI.
>>
>> Introduce pmdp_collapse_flush_sync() which combines flush and sync:
>>
>> - For architectures using the generic pmdp_collapse_flush() 
>> implementation
>>    (e.g., x86): Use mmu_gather to track IPI sends. If the TLB flush sent
>>    an IPI, tlb_gather_remove_table_sync_one() will skip the redundant 
>> one.
>>
>> - For architectures with custom pmdp_collapse_flush() (s390, riscv,
>>    powerpc): Fall back to calling pmdp_collapse_flush() followed by
>>    tlb_remove_table_sync_one(). No behavior change.
>>
>> Update khugepaged to use pmdp_collapse_flush_sync() instead of separate
>> flush and sync calls. Remove the now-unused pmdp_get_lockless_sync() 
>> macro.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   include/linux/pgtable.h | 13 +++++++++----
>>   mm/khugepaged.c         |  9 +++------
>>   mm/pgtable-generic.c    | 34 ++++++++++++++++++++++++++++++++++
>>   3 files changed, 46 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index eb8aacba3698..69e290dab450 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>>       return pmd;
>>   }
>>   #define pmdp_get_lockless pmdp_get_lockless
>> -#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
>>   #endif /* CONFIG_PGTABLE_LEVELS > 2 */
>>   #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
>> @@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>>   {
>>       return pmdp_get(pmdp);
>>   }
>> -static inline void pmdp_get_lockless_sync(void)
>> -{
>> -}
>>   #endif
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> @@ -1174,6 +1170,8 @@ static inline void pudp_set_wrprotect(struct 
>> mm_struct *mm,
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>   extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
>>                    unsigned long address, pmd_t *pmdp);
>> +extern pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
>> +                 unsigned long address, pmd_t *pmdp);
>>   #else
>>   static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
>>                       unsigned long address,
>> @@ -1182,6 +1180,13 @@ static inline pmd_t pmdp_collapse_flush(struct 
>> vm_area_struct *vma,
>>       BUILD_BUG();
>>       return *pmdp;
>>   }
>> +static inline pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
>> +                    unsigned long address,
>> +                    pmd_t *pmdp)
>> +{
>> +    BUILD_BUG();
>> +    return *pmdp;
>> +}
>>   #define pmdp_collapse_flush pmdp_collapse_flush
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>   #endif
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 9f790ec34400..0a98afc85c50 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1177,10 +1177,9 @@ static enum scan_result 
>> collapse_huge_page(struct mm_struct *mm, unsigned long a
>>        * Parallel GUP-fast is fine since GUP-fast will back off when
>>        * it detects PMD is changed.
>>        */
>> -    _pmd = pmdp_collapse_flush(vma, address, pmd);
>> +    _pmd = pmdp_collapse_flush_sync(vma, address, pmd);
>>       spin_unlock(pmd_ptl);
>>       mmu_notifier_invalidate_range_end(&range);
>> -    tlb_remove_table_sync_one();
> 
> Now you issue the IPI under PTL.
We do send TLB flush IPI under PTL before, e.g. in 
try_collapse_pte_mapped_thp():

	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
	pmdp_get_lockless_sync();
	pte_unmap_unlock(start_pte, ptl);

But anyway, we can do better by passing ptl in and unlocking
before the sync IPI ;)
> 
> [...]
> 
>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index d3aec7a9926a..be2ee82e6fc4 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -233,6 +233,40 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct 
>> *vma, unsigned long address,
>>       flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
>>       return pmd;
>>   }
>> +
>> +pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned 
>> long address,
>> +                   pmd_t *pmdp)
>> +{
>> +    struct mmu_gather tlb;
>> +    pmd_t pmd;
>> +
>> +    VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>> +    VM_BUG_ON(pmd_trans_huge(*pmdp));
>> +
>> +    tlb_gather_mmu(&tlb, vma->vm_mm);
> 
> Should we be using the new tlb_gather_mmu_vma(), and do we have to set 
> the TLB pagesize to PMD?

Yes, good point on tlb_gather_mmu_vma()!

So, the sequence will be:

	tlb_gather_mmu_vma(&tlb, vma);
	pmd = pmdp_huge_get_and_clear(...);
	flush_tlb_mm_range(..., &tlb);
	if (ptl)
		spin_unlock(ptl);
	tlb_gather_remove_table_sync_one(&tlb);
	tlb_finish_mmu(&tlb);Thanks,
Lance

