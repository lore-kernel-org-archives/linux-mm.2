Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E3E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KWXhrImQ
Received: by kanga.kvack.org (Postfix)
	id A69046B05B2; Wed, 11 Nov 2026 04:22:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41F36B05B4; Wed, 11 Nov 2026 04:22:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956B66B05B6; Wed, 11 Nov 2026 04:22:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB5E6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:22:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F122BC0252
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:22:30 +0000 (UTC)
X-FDA: 85422297660.20.19D5224
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2194E140007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:22:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWXhrImQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794388949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qtfi79sNkt5m/VGYUDKWPyqCBF/QwcBOUK8ADQR5ugg=;
	b=A6mlmIdlg+ySRuLrgYIHpzTBlaE1VgPhDOKieh0C+hdv6mIu0/eSU1d/E6dPsn+21m13dw
	QG5rRDw+csfZGqFcsfvowd5xfvDJiMma1n8QphSzJTnsO2dcEEfiH2k7Ca7HfvOeY/0uM8
	Of+XjlHa6QfuDuO7Lapmsh78vuDsLjU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWXhrImQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794388949;
	b=WCQr3vFzT6XI2xbGOgRWSo1Jq2649sKlA20fQNy7/P7YnKlwAmduNcfj7NTOXeCayrkz+2
	pzQ09E7rPbLy1VjLuXbRGIngk6AG9ZJe9i7ENGsziQ+zJUGkOVK1bK87tpCVs5OMjg3G5g
	Bbn/BljOyHZB0LlfPfPWd+BfSQezZ9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 469754706D;
	Wed, 11 Nov 2026 09:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944C71F00A0A;
	Wed, 11 Nov 2026 09:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794388948;
	bh=Qtfi79sNkt5m/VGYUDKWPyqCBF/QwcBOUK8ADQR5ugg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KWXhrImQFuzpZKw/rzBUBYvNMKl1qxn7VBe2anF24Uyk9RZS1Nbr4w1h/RdmecNPZ
	 TVcXiospwwgUvYCcCHCO0wY6pjT5qGDBpyEf30oX64aH2zamK+EQTsSgKROGj3VG2j
	 PImW+0v70imhZhZtFxj7svIiwBrsbzUXtcNjs5slcjX+ovW4Ac6l7CpyvT4LwKb7Pz
	 MzZANZtbMcc1vsZxVDJNYoNaSqn1cK1eppZhObGqluQeMfIImKrrLvIWpo2MOihMJx
	 CmAeZOZlWXmsKZ9E3Symko1yg0hxb3Wco/zvnoFmZHkZZ8pmhQr9rsUzwSaLoqVeIO
	 7RI4baxf/39dg==
Message-ID: <af8dd40d-1561-4497-989b-abedb9afb248@kernel.org>
Date: Wed, 11 Nov 2026 10:22:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use memory barriers for non PMD-sized folios to sync
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, qi.zheng@linux.dev, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <09736bc2e01bec0ca7436733078c82c7e0cc6627.1794376686.git.baolin.wang@linux.alibaba.com>
 <3e5ceb38-d04c-4cd4-a783-5d0edcedf5dd@kernel.org>
 <59c59696-2112-44e6-818c-50bd10789b70@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <59c59696-2112-44e6-818c-50bd10789b70@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2194E140007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: hm6hgst7pny3kschspcnk8ee31oanctc
X-HE-Tag: 1794388948-705198
X-HE-Meta: U2FsdGVkX1+BavwLshE0dx0mBjh/IYjmx+FbCXDraSNC9hKeRmuli8PDQg2jmp5arEz3rB6Sm9y4cTaEvOrfd7GdzONtDBokgydiHf+Ckpz5HTWjKbVQ+JtMi+sDsMSxBkvUjUAuZw3XAUoj1LdVgLefPEQcKa11qIWAm7aJp0xK8TfdWfBBajLW6U+eg6VBNpteOkonfxtwfSPlggnNvQCc2W5jNYwqfMSqfkgOHplO7PHgc+Z0kKumv16guR+c3IU6zW1C+y6e2JIcGpMcknUjcGdwMut1mmFMSDE/BmKWsnlV/uqKLOAQVDjFZMWkzlkKSRdjsa57vcK+9HD5TVvhW+VOiEzW0CMa3Bu1DHDg92s6au5QIkKDJPU/8E/ZNJ4PnYVMXFzyH45erQxcm2nsx7gh3mXwhsQoJG/QgTttqUaYBZ0WdM/s9h6B34g/b/lhL4PWUXoiY3DoQKYboJk08qWZnTeYGrBpWxRvxTb8YWCF7BtKX9GKHrphF6fyQWSK/Gj7NaVHCnFizTzTZEhqACN7zu1PHOY62JXoyVLgo2x6p8snJcjSGU7xRDKqtPuU3dtjQ5wnx8p2Or0cuOlVMAprsyXuFFypjHmOHv4Ffmq7qRSAo7e5XvO2aC8hd+LTHPA1HJ9IufO+0vtTmnyYqCndZ/aO1/F25tmiaShkYlK8Pz/5hffufRoDZu0rxe5RpgPcS89p14MPNI+NlXtakxdYMQwxf8ik8vqXFOzovUngm3NFKSf1ztivLpqO38Kkc97Hk8ZfJhpYP/1YRSvCacstPdHi9sPvJDfN7DWryn2uk11L8jEDf5y6R+hyS6GR2vBfmuF5+1B8lodrJWdM4uvbW9vQUHTG+Io5OW+Pm8ZFpj4qhjr+XXSsKhf0Z9jfDMe8RZmDsJyd/zYQ+TAgBHJKSxYfN+xWd3zF4c7S0W9ipZR6CYXNh+OFPRCAL0StD2XYXs/30j4LZbe
 fhZYM5sV
 +OBmJaDv6JIhO0EfBOQNLbYxdqe7+r/c0LRlENzl/8dOa+2kqtU2ewK92K8LotL++u/XsV1t//fTWpICRay+frVaBusuRSWdfnquAuMHAT7mSsTorex3Nlz++2S7A0LbWG295VuJxo08NEkVwO/R6s/SNvL+kJSnZt3vf/ktzzsaOX+Mcrqv6LIe2BQcQaMSwu/m5zgCycXpSbYbRT6Mu13ddv75T2zkw0G2I0P3Cy6U/5SmjFJpXDg2nRgWrbrDTGS3GCMOWkpfCSsSrz4EmBc2e1RM4L8Hb4qXVLkJLdgYR1kcq/IDOvobvOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 09:43, Baolin Wang wrote:
> 
> 
> On 11/11/26 3:48 PM, David Hildenbrand (Arm) wrote:
>> On 11/11/26 07:06, Baolin Wang wrote:
>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>>> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
>>> PMD is found while unmapping a folio.
>>>
>>> However, for non PMD-sized folios, the cleared PMD can only come from
>>> PTE table reclaim, which clears the PMD only after the rmaps for the
>>> table have been removed. This is plain message passing, and taking
>>> the PMD lock is more than needed, like I did in the previous patch[1].
>>>
>>> Without barriers, the walker can observe the cleared PMD but a stale
>>> mapcount on weakly ordered architectures:
>>>
>>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>>> ================================    ================================
>>> folio_lock()
>>>                                      lock(ptl)
>>>                                      clear PTEs
>>>                                      remove rmaps   /* W mapcount */
>>> [mapcount load satisfied early,
>>>   folio still mapped]
>>>                                      pmd_clear()    /* W pmd */
>>>                                      unlock(ptl)
>>> pmdp_get_lockless() -> none         /* R pmd */
>>> skip the PMD
>>> folio_mapped() -> true              /* R mapcount, stale */
>>> unmapping assumed to have failed
>>>
>>> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
>>> PMD read forbids this outcome:
>>>
>>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>>> ================================    ================================
>>>                                      remove rmaps   /* W mapcount */
>>>                                      smp_wmb()
>>>                                      pmd_clear()    /* W pmd */
>>> pmdp_get_lockless() -> none         /* R pmd */
>>> smp_rmb()
>>> folio_mapped()                      /* R mapcount */
>>>
>>> If R pmd observes W pmd, R mapcount must observe W mapcount, so
>>> folio_mapped() no longer reports the removed mappings.
>>>
>>> No changes for PMD-sized folios unmapping.
>>>
>>> [1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   mm/internal.h        | 26 ++++++++++++++++++++++----
>>>   mm/memory.c          | 12 ++++++++++--
>>>   mm/page_vma_mapped.c |  2 +-
>>>   3 files changed, 33 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index cd3675c044e0..a277bf4841f8 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>    * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>>    * @mm: The mm_struct.
>>>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>> + * @nr_pages: The number of pages in the folio.
>>>    *
>>>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>>    * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>>> @@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>    * against later mapcount reads. Skipping the PMD without synchronization
>>>    * could make folio unmapping code assume that unmapping failed.
>>>    *
>>> - * Wait for concurrent zapping to complete by grabbing the PTL.
>>> + * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
>>> + * folios, otherwise smp_rmb() is sufficient.
>>>    */
>>> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
>>> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp,
>>> +		unsigned int nr_pages)
>>>   {
>>> -	spinlock_t *ptl = pmd_lock(mm, pmdp);
>>> +	if (nr_pages >= HPAGE_PMD_NR) {
>>> +		spinlock_t *ptl = pmd_lock(mm, pmdp);
>>>   
>>> -	spin_unlock(ptl);
>>> +		spin_unlock(ptl);
>>> +		return;
>>> +	}
>>> +
>>> +	/*
>>> +	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
>>> +	 * may clear the PMD after the rmaps for the table have been removed,
>>> +	 * but later mapcount reads could still be observed before the PMD
>>> +	 * read, making the folio appear to be still mapped after unmapping.
>>> +	 * Order the PMD read before later mapcount reads, so that observing
>>> +	 * the cleared PMD implies observing the rmap removals.
>>> +	 *
>>> +	 * Pairs with smp_wmb() in zap_pte_range().
>>> +	 */
>>> +	smp_rmb();
>>>   }
>>>   
>>>   struct zap_details;
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index fe72e66c9c2e..1ee286cdd3af 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2054,8 +2054,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>>   	 * Clear the PMD after the rmaps for the table have been removed, in case
>>>   	 * an incorrect mapcount is observed after unmapping the folio.
>>>   	 */
>>> -	if (can_reclaim_pt && direct_reclaim && addr == end)
>>> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
>>> +		/*
>>> +		 * rmap changes need to be observed before page tables get zapped.
>>> +		 *
>>> +		 * Pairs with smp_rmb() in sync_with_folio_pmd_zap().
>>> +		 */
>>> +		smp_wmb();
>>>   		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>>> +	}
>>>   	pte_unmap_unlock(start_pte, ptl);
>>>   
>>>   	/*
>>> @@ -2110,7 +2117,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>>>   			/* fall through */
>>>   		} else if (pmd_none(*pmd)) {
>>>   			if (details && details->single_folio)
>>> -				sync_with_folio_pmd_zap(tlb->mm, pmd);
>>> +				sync_with_folio_pmd_zap(tlb->mm, pmd,
>>> +						folio_nr_pages(details->single_folio));
>>>   			addr = next;
>>>   			continue;
>>>   		}
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index a931243ca42b..d793ad0c5364 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -295,7 +295,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>   			pvmw->ptl = NULL;
>>>   		} else if (!pmd_present(pmde)) {
>>>   			if (pvmw->flags & PVMW_SYNC)
>>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>> +				sync_with_folio_pmd_zap(mm, pvmw->pmd, pvmw->nr_pages);
>>>
>>
>> If there is no folio, why do we care about the sync? Should there be a folio
>> here? Anyhow, I think sync_with_folio_pmd_zap() really should be consuming a folio.
> 
> Since there are only two cases without a folio: 
> mapping_wrprotect_range() and pfn_mkclean_range(), I'm hesitant to 
> modify all page_vma_mapped_walk() callers to pass in a 'folio' parameter 
> for these 2 cases.
> 
> Or should we add a new flag for the pfn walk?
> 
> / Walk a PFN range which need not belong to a folio /
> #define PVMW_PFN		(1 << 2)
> 
> Then the changes would be:
> } else if (!pmd_present(pmde)) {
> 	if ((pvmw->flags & (PVMW_SYNC | PVMW_PFN)) == PVMW_SYNC)
> 		sync_with_folio_pmd_zap(mm, pvmw->pmd,
>                              pfn_folio(pvmw->pfn));
If we're working on a folio, we better pass in a folio. That might require some cleanups, yes.

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 52fff8dc74213..80fb7ef9bab92 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -884,6 +884,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 #define PVMW_PGTABLE_CROSSED   (1 << 16)

 struct page_vma_mapped_walk {
+       struct folio *folio;
        unsigned long pfn;
        unsigned long nr_pages;
        pgoff_t pgoff;  /* Only meaningful if nr_pages > 1 and not a KSM walk */
@@ -898,6 +899,7 @@ struct page_vma_mapped_walk {

 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)    \
        struct page_vma_mapped_walk name = {                            \
+               .folio = folio,                                         \
                .pfn = folio_pfn(_folio),                               \
                .nr_pages = folio_nr_pages(_folio),                     \
                .pgoff = folio_pgoff(_folio),                           \


The question is really whether pfn_mkclean_range + mapping_wrprotect_range really need that
sync as well.

(we could identify by seeing !folio I guess)

-- 
Cheers,

David

