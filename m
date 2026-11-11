Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6E5606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JD0zJMqj
Received: by kanga.kvack.org (Postfix)
	id B39066B05C7; Wed, 11 Nov 2026 06:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10716B05C8; Wed, 11 Nov 2026 06:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2026B05C9; Wed, 11 Nov 2026 06:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6E66B05C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:13:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4BEF1A01A7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:13:02 +0000 (UTC)
X-FDA: 85422576204.29.4C5EEA0
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf08.hostedemail.com (Postfix) with ESMTP id 30900160002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:12:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JD0zJMqj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iFCeq1rcYiNwyil1uZwKm8dH4THN8/OfZC39f1A/no=;
	b=no/GBLSRyHhmpTepGOArbB/SWPzsQPPPm5W5CBiQobsZg8fw8uGpGkkjTx0we+fkuO46Mn
	SycXGUjIyIoFCkKIbKYinCgSHwtP2IAq0BvOmM+HNzdompcTWbORQu9NHwm6fqREyHa5bi
	jbFxGoghjNgsytJnBohm2+47KsCahiM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JD0zJMqj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395580;
	b=H+uJhBDteeI/3O7KlTtbFMlifwtzWy37SAEJGMFikTt7Wlj5UMmZ6w6guEvXKhM2gDe7+W
	bdQRlDuYFxD4GWp0GKm+YN7WWSfrGJRGWjjJaN4T+PnqulhKlumlsHkH5fyvMrtDKVQOQJ
	s2Phc6J9g8HsotMUVnyy98ip1OO0yLI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794395576; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/iFCeq1rcYiNwyil1uZwKm8dH4THN8/OfZC39f1A/no=;
	b=JD0zJMqjv7hP80xP3ryv/FllkTpbO/Xisc1uH6RMkPnZdvXsy4Jd6wkHsZzsTzDcS2gjJL79LWG3wn1CSra+xH0RcCAy2W23S/ofNK8ttVnXvMX/OPfJEVXXu2ZPf0h9Jz37Rcv9zMOXnefP+rBwixcEBpmZJwm0EMSsgjMvxgw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XEYhO6q_1794395574;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEYhO6q_1794395574 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 19:12:54 +0800
Message-ID: <544da2b9-9ce6-437d-9e1c-1361a8e5aa12@linux.alibaba.com>
Date: Wed, 11 Nov 2026 19:12:53 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use memory barriers for non PMD-sized folios to sync
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, qi.zheng@linux.dev, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <09736bc2e01bec0ca7436733078c82c7e0cc6627.1794376686.git.baolin.wang@linux.alibaba.com>
 <3e5ceb38-d04c-4cd4-a783-5d0edcedf5dd@kernel.org>
 <59c59696-2112-44e6-818c-50bd10789b70@linux.alibaba.com>
 <af8dd40d-1561-4497-989b-abedb9afb248@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <af8dd40d-1561-4497-989b-abedb9afb248@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30900160002
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mu4aryan636whopj5fasbupxgx8pa3bb
X-HE-Tag: 1794395578-664537
X-HE-Meta: U2FsdGVkX1/44tmyaZrjv0GelrrTaUfuvKfj1aVKnfkfWkndzfYFkCgIHSqpqT2w/FUFLyCoeDxopWX80L+KnoQBMU9wB4I6NEkA9PV96uE/Kh39QPUMFhdI0K9XygaGgijFHHrkG4wiThNsbfM4aotC7FASXIfBL5LI1H1b0WyYCbncku4RijEJ8FlquHsAXK9bO3y0uYbaPbXIn89mF0tvfw34TbqvGJ0dGENv2TKj7BB4YAVN+dU/irASBFhz7mVpe+M/39EOwruzvl6TlL0e7fcLqiuX6L+tpW/KLOoOwSJjRxn4SlWllhCvmoxCBtH/o0KuZxBq1nWiHPN8G3CW/qrCER3G8EPW3KZpDd0+gRM+0rbOerpKNFOnuhODMHtAbZJs2Go6Nl2ZNulWu4b1XM+ZmuN0JbDObXSmiVbNKW++191wiUplFNKHoiHKd1oH8/UN0pi2Ew4YnHUjXfDjpCgcSclYkYGYsRhARuBMLX9sSEkTx+2s3yqn8/LfEX0sijRh9zSAF1W8+5rFqSp0kdthRs5kjvaHJwZmic68rNc2L5J4vCvBYoir6lKc6lQ0amCIlZoGZzHclRere7Es9X60k4nIaBN2UFUwgtS/5evVqeaBKUbKHzs4QQ265AfDRwEoulOBcgwYITu1GOixzQ/IyWaprNHasfZDIkPFO9PR0tnkruNZ4D5CH5zQ5ZHFCoNQygTs+ym7V/fXNmVAjr6jf1tanI7f8JKByeo0MWS4WMBAMFw+fNeF3wcKiGjYtLFKK0hKu56HGIvBCuKUSOKieGF0oq+c1GzCLn4sM7Lqg7+3euCpFWQrb5OfhtstjaxgyUHfRowchz8caTW1R9RNby/wdEkTBP0Po+PCTq4CcGxT87Ek/jfnWT4DxMTHSz8BM8rwSxtU96njAxgVSDXBaJdv6aKRk6jphkLlub++zN7XG+yrfPIG6Zm8aFB/npRRmjafFbgA9yC
 jOdlMalY
 TP7S27p3d9yyEp/cdc8Xg50nLL+1E4epeQNCjbRs+J02Xw9QnLalfjjGJJiyWO+b9uWgNPS0LkOU9IB6yRM+bC9gpRqJ4bHapOXw5df07mP94TBxKYZwnlrCilV9nNY99f4uAIRWBBvSYCcV32ko0H2zvN4SKnQu6f8n+702cZ+kN1BHbvV7mIvh4kM7eEas4lgMZhsMahJ+d+lr0tQfIw8Rf8swYlDm2vNHuJG3xSHA6cvsoeyYCBeZkgkdyW/z/tpRMv/lHSPPZ0YsklmEDjPKXRterNwHXX0TCZGWPEKLnxzZAgoffuPz9itB3ZRcGT50VpeR8l/zevS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 5:22 PM, David Hildenbrand (Arm) wrote:
> On 11/11/26 09:43, Baolin Wang wrote:
>>
>>
>> On 11/11/26 3:48 PM, David Hildenbrand (Arm) wrote:
>>> On 11/11/26 07:06, Baolin Wang wrote:
>>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>>>> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
>>>> PMD is found while unmapping a folio.
>>>>
>>>> However, for non PMD-sized folios, the cleared PMD can only come from
>>>> PTE table reclaim, which clears the PMD only after the rmaps for the
>>>> table have been removed. This is plain message passing, and taking
>>>> the PMD lock is more than needed, like I did in the previous patch[1].
>>>>
>>>> Without barriers, the walker can observe the cleared PMD but a stale
>>>> mapcount on weakly ordered architectures:
>>>>
>>>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>>>> ================================    ================================
>>>> folio_lock()
>>>>                                       lock(ptl)
>>>>                                       clear PTEs
>>>>                                       remove rmaps   /* W mapcount */
>>>> [mapcount load satisfied early,
>>>>    folio still mapped]
>>>>                                       pmd_clear()    /* W pmd */
>>>>                                       unlock(ptl)
>>>> pmdp_get_lockless() -> none         /* R pmd */
>>>> skip the PMD
>>>> folio_mapped() -> true              /* R mapcount, stale */
>>>> unmapping assumed to have failed
>>>>
>>>> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
>>>> PMD read forbids this outcome:
>>>>
>>>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>>>> ================================    ================================
>>>>                                       remove rmaps   /* W mapcount */
>>>>                                       smp_wmb()
>>>>                                       pmd_clear()    /* W pmd */
>>>> pmdp_get_lockless() -> none         /* R pmd */
>>>> smp_rmb()
>>>> folio_mapped()                      /* R mapcount */
>>>>
>>>> If R pmd observes W pmd, R mapcount must observe W mapcount, so
>>>> folio_mapped() no longer reports the removed mappings.
>>>>
>>>> No changes for PMD-sized folios unmapping.
>>>>
>>>> [1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    mm/internal.h        | 26 ++++++++++++++++++++++----
>>>>    mm/memory.c          | 12 ++++++++++--
>>>>    mm/page_vma_mapped.c |  2 +-
>>>>    3 files changed, 33 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/mm/internal.h b/mm/internal.h
>>>> index cd3675c044e0..a277bf4841f8 100644
>>>> --- a/mm/internal.h
>>>> +++ b/mm/internal.h
>>>> @@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>>     * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>>>     * @mm: The mm_struct.
>>>>     * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>>> + * @nr_pages: The number of pages in the folio.
>>>>     *
>>>>     * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>>>     * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>>>> @@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>>     * against later mapcount reads. Skipping the PMD without synchronization
>>>>     * could make folio unmapping code assume that unmapping failed.
>>>>     *
>>>> - * Wait for concurrent zapping to complete by grabbing the PTL.
>>>> + * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
>>>> + * folios, otherwise smp_rmb() is sufficient.
>>>>     */
>>>> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
>>>> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp,
>>>> +		unsigned int nr_pages)
>>>>    {
>>>> -	spinlock_t *ptl = pmd_lock(mm, pmdp);
>>>> +	if (nr_pages >= HPAGE_PMD_NR) {
>>>> +		spinlock_t *ptl = pmd_lock(mm, pmdp);
>>>>    
>>>> -	spin_unlock(ptl);
>>>> +		spin_unlock(ptl);
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
>>>> +	 * may clear the PMD after the rmaps for the table have been removed,
>>>> +	 * but later mapcount reads could still be observed before the PMD
>>>> +	 * read, making the folio appear to be still mapped after unmapping.
>>>> +	 * Order the PMD read before later mapcount reads, so that observing
>>>> +	 * the cleared PMD implies observing the rmap removals.
>>>> +	 *
>>>> +	 * Pairs with smp_wmb() in zap_pte_range().
>>>> +	 */
>>>> +	smp_rmb();
>>>>    }
>>>>    
>>>>    struct zap_details;
>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>> index fe72e66c9c2e..1ee286cdd3af 100644
>>>> --- a/mm/memory.c
>>>> +++ b/mm/memory.c
>>>> @@ -2054,8 +2054,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>>>    	 * Clear the PMD after the rmaps for the table have been removed, in case
>>>>    	 * an incorrect mapcount is observed after unmapping the folio.
>>>>    	 */
>>>> -	if (can_reclaim_pt && direct_reclaim && addr == end)
>>>> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
>>>> +		/*
>>>> +		 * rmap changes need to be observed before page tables get zapped.
>>>> +		 *
>>>> +		 * Pairs with smp_rmb() in sync_with_folio_pmd_zap().
>>>> +		 */
>>>> +		smp_wmb();
>>>>    		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>>>> +	}
>>>>    	pte_unmap_unlock(start_pte, ptl);
>>>>    
>>>>    	/*
>>>> @@ -2110,7 +2117,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>>>>    			/* fall through */
>>>>    		} else if (pmd_none(*pmd)) {
>>>>    			if (details && details->single_folio)
>>>> -				sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>> +				sync_with_folio_pmd_zap(tlb->mm, pmd,
>>>> +						folio_nr_pages(details->single_folio));
>>>>    			addr = next;
>>>>    			continue;
>>>>    		}
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index a931243ca42b..d793ad0c5364 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -295,7 +295,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>    			pvmw->ptl = NULL;
>>>>    		} else if (!pmd_present(pmde)) {
>>>>    			if (pvmw->flags & PVMW_SYNC)
>>>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>>> +				sync_with_folio_pmd_zap(mm, pvmw->pmd, pvmw->nr_pages);
>>>>
>>>
>>> If there is no folio, why do we care about the sync? Should there be a folio
>>> here? Anyhow, I think sync_with_folio_pmd_zap() really should be consuming a folio.
>>
>> Since there are only two cases without a folio:
>> mapping_wrprotect_range() and pfn_mkclean_range(), I'm hesitant to
>> modify all page_vma_mapped_walk() callers to pass in a 'folio' parameter
>> for these 2 cases.
>>
>> Or should we add a new flag for the pfn walk?
>>
>> / Walk a PFN range which need not belong to a folio /
>> #define PVMW_PFN		(1 << 2)
>>
>> Then the changes would be:
>> } else if (!pmd_present(pmde)) {
>> 	if ((pvmw->flags & (PVMW_SYNC | PVMW_PFN)) == PVMW_SYNC)
>> 		sync_with_folio_pmd_zap(mm, pvmw->pmd,
>>                               pfn_folio(pvmw->pfn));
> If we're working on a folio, we better pass in a folio. That might require some cleanups, yes.

OK.

> The question is really whether pfn_mkclean_range + mapping_wrprotect_range really need that
> sync as well.

I don't think they need to sync. Similarly, page_mapped_in_vma() doesn't 
actually need sync either, since the subsequent operations don't check 
folio's mapcount.

