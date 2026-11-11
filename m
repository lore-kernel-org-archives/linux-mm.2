Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2035B606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GmHCuvlc
Received: by kanga.kvack.org (Postfix)
	id 2CAD76B05CD; Wed, 11 Nov 2026 03:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1A96B05CE; Wed, 11 Nov 2026 03:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFBE6B05CF; Wed, 11 Nov 2026 03:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF2A26B05CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:43:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E9DA1A01B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:43:12 +0000 (UTC)
X-FDA: 85422198624.26.DFC84D0
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf13.hostedemail.com (Postfix) with ESMTP id B5A1820005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:43:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GmHCuvlc;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794386590;
	b=X+mMUFV3iMLnXNkaHKPOp3x2muK60z/vv1cs7lfkY1VJ54WF2WLaEfXAdHWZ2IZ/q8UxwO
	tiUeietbowfTtFJ7X2a4D4NO+SDaACEC+e0xddjLWiANv+nqSAuNKSqxF7wHgC/5dRfcQU
	P+QWFt6yNRjazwstePk8RbD/u3Be1SI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GmHCuvlc;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794386590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=je3HtlkLcRLrQhsQj5hoLe+iA4mHnRWsfHzVv+rTg0M=;
	b=ORZG0aMnRzcnlJzn3NnxiUrnhQuoHvK9+GctoQ3YTsKau8TOO3y+ZC6qHm8fOnjDZ4Nc0d
	0peZhHt7CPgd5e7Tob2vLrmsl+PihrorcfW0k4NUsUS4Wrn3bowU12R8l9WRPAdLy7a8do
	18KdB029mlxKNNtyNBtDxyikc4t9riQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794386585; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=je3HtlkLcRLrQhsQj5hoLe+iA4mHnRWsfHzVv+rTg0M=;
	b=GmHCuvlcmXefncC19tym59Zclf7TYgsfpXqqlGb/ckZRrQ2BsW35/gpCuOitoVVHs1aIR+6/C5dmQuiXBLc+U/k6zfUQ/thuB7Y1mbAep8DTWVfNv4qmiP/iefi0bCAEKtnUPJSo75cbOYH517OZqPHPx6kWGmriVXDF7zeQtSc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XEYJi.Z_1794386582;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEYJi.Z_1794386582 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 16:43:03 +0800
Message-ID: <59c59696-2112-44e6-818c-50bd10789b70@linux.alibaba.com>
Date: Wed, 11 Nov 2026 16:43:01 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3e5ceb38-d04c-4cd4-a783-5d0edcedf5dd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: im9pozby6y6qrr5whhg5rwzbehxsydqq
X-Rspamd-Queue-Id: B5A1820005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794386588-570527
X-HE-Meta: U2FsdGVkX19mJZ/epM+oi/h0v8hVy+cC7sVvJ+XH/0keMN82JgedYGyJIqqwftmnEbKv1D0DVdyWjCjgj1rnQfikvmFy8VnYo4S94NTcq7PD3ImOjoCAQW9/PRxa1+MDoGyYOKUdRPOgPKTKocOGeh2Hx2EWZju75V9fv0VUOSeieDRTQDKbv8By4+0QoUxsLaB0RaSvuvLti0q5YT3v2GIQ3xiGLq3Ubk8YZ/5DHWtR8RSV8sJnhXwj02QX7Fov3SbNCbmb6lUVwcbGsPwryAboqsFHXjz59Lg6DKbHXGxHqKPZDFVSkZBg8WVOsZYJ0hA5SAzpg9JNH373yq0i2fqpie5sXNDMtAexgOdH8xj8SHgRKlYdA39GpQRihlpwMIoWP3i2Q9gTjj5/oSBqYBOceIJpY4+u7LribE0Y0CQ7poETO73mb1J+1t3YYHeOSceKYPd4xpAnl67mjtD6vFbHNZ/W03T/ls+g1qCN8pzL9EIbMQJE2H7SO+4NoZL0b5/yeP1QodlU8We9u6IP03pydhWOtMYKdfqcy6VJ8gdClT8/tFTo+wzzJ6vHu/vgI2aYBWOvaSUiaMgndqQkSrDNZB3bxqMlwbrlJJHTY3rMLAADJtODLffGwj0DgSUqBMkVufNJrqYZRnfSO2L/QrmWZST63ClxIuiIvh9evsFxHdQciyZyPXK3EExMEUbC2+raASSAwQj9a0/6c23wkx99W6GxPyFS7HO6H+ugxTYHdJ0YUD07hzvVvOzDybW3Nmc5PLUWEjwcE2370gfWnW4P6skpnI6v28bTLlYuytfGw4FJfr6m3WzT8Rg9luX1VF4XUtRCvaYl94pEylssjGYIEdncuS7mK1uffxCWfsL5pq2OqdoVKwkwffAZKub4o98ooD67qAViAfUYSyXDYAt1f0fIBu6OndojHVr6DAu3pioxKWoiUo5PAtMUij9AIC71OfJWFzYtk1IvBcW
 dW0FYGj+
 63g1BWb28qgkwQBSYnj/ECmn89lxn12W2lQi+QzsVfzOISaCGB+5hATM8eNOjY8sxuLJYtINwMh54pRJS4ftJL8g2jb//0gEsvddsjaeocRLSMkj+wMoCWEmgcsbYyMJrXZKIu3QETVsMY9wfNol5MCQR0wPvoCWqnFi3Ph0KRFsreHsMJ6TcSk0WMXwrTBnNXIw7Xsulx/zk7uP8BWGWPlb1EL8hB81EEdnocqsSmPVioWtF082mD506TNtzhInf8+YhARRj8E4MDlO9G5LHnbBMTZ+8D0ZIzZFUfu1kSeA4dd0f+3jzNZ2CtFWLhemWj0V3no9cgGbNqX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 3:48 PM, David Hildenbrand (Arm) wrote:
> On 11/11/26 07:06, Baolin Wang wrote:
>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
>> PMD is found while unmapping a folio.
>>
>> However, for non PMD-sized folios, the cleared PMD can only come from
>> PTE table reclaim, which clears the PMD only after the rmaps for the
>> table have been removed. This is plain message passing, and taking
>> the PMD lock is more than needed, like I did in the previous patch[1].
>>
>> Without barriers, the walker can observe the cleared PMD but a stale
>> mapcount on weakly ordered architectures:
>>
>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>> ================================    ================================
>> folio_lock()
>>                                      lock(ptl)
>>                                      clear PTEs
>>                                      remove rmaps   /* W mapcount */
>> [mapcount load satisfied early,
>>   folio still mapped]
>>                                      pmd_clear()    /* W pmd */
>>                                      unlock(ptl)
>> pmdp_get_lockless() -> none         /* R pmd */
>> skip the PMD
>> folio_mapped() -> true              /* R mapcount, stale */
>> unmapping assumed to have failed
>>
>> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
>> PMD read forbids this outcome:
>>
>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>> ================================    ================================
>>                                      remove rmaps   /* W mapcount */
>>                                      smp_wmb()
>>                                      pmd_clear()    /* W pmd */
>> pmdp_get_lockless() -> none         /* R pmd */
>> smp_rmb()
>> folio_mapped()                      /* R mapcount */
>>
>> If R pmd observes W pmd, R mapcount must observe W mapcount, so
>> folio_mapped() no longer reports the removed mappings.
>>
>> No changes for PMD-sized folios unmapping.
>>
>> [1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/internal.h        | 26 ++++++++++++++++++++++----
>>   mm/memory.c          | 12 ++++++++++--
>>   mm/page_vma_mapped.c |  2 +-
>>   3 files changed, 33 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index cd3675c044e0..a277bf4841f8 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>    * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>    * @mm: The mm_struct.
>>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>> + * @nr_pages: The number of pages in the folio.
>>    *
>>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>    * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>> @@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>    * against later mapcount reads. Skipping the PMD without synchronization
>>    * could make folio unmapping code assume that unmapping failed.
>>    *
>> - * Wait for concurrent zapping to complete by grabbing the PTL.
>> + * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
>> + * folios, otherwise smp_rmb() is sufficient.
>>    */
>> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
>> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp,
>> +		unsigned int nr_pages)
>>   {
>> -	spinlock_t *ptl = pmd_lock(mm, pmdp);
>> +	if (nr_pages >= HPAGE_PMD_NR) {
>> +		spinlock_t *ptl = pmd_lock(mm, pmdp);
>>   
>> -	spin_unlock(ptl);
>> +		spin_unlock(ptl);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
>> +	 * may clear the PMD after the rmaps for the table have been removed,
>> +	 * but later mapcount reads could still be observed before the PMD
>> +	 * read, making the folio appear to be still mapped after unmapping.
>> +	 * Order the PMD read before later mapcount reads, so that observing
>> +	 * the cleared PMD implies observing the rmap removals.
>> +	 *
>> +	 * Pairs with smp_wmb() in zap_pte_range().
>> +	 */
>> +	smp_rmb();
>>   }
>>   
>>   struct zap_details;
>> diff --git a/mm/memory.c b/mm/memory.c
>> index fe72e66c9c2e..1ee286cdd3af 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2054,8 +2054,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>   	 * Clear the PMD after the rmaps for the table have been removed, in case
>>   	 * an incorrect mapcount is observed after unmapping the folio.
>>   	 */
>> -	if (can_reclaim_pt && direct_reclaim && addr == end)
>> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
>> +		/*
>> +		 * rmap changes need to be observed before page tables get zapped.
>> +		 *
>> +		 * Pairs with smp_rmb() in sync_with_folio_pmd_zap().
>> +		 */
>> +		smp_wmb();
>>   		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>> +	}
>>   	pte_unmap_unlock(start_pte, ptl);
>>   
>>   	/*
>> @@ -2110,7 +2117,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>>   			/* fall through */
>>   		} else if (pmd_none(*pmd)) {
>>   			if (details && details->single_folio)
>> -				sync_with_folio_pmd_zap(tlb->mm, pmd);
>> +				sync_with_folio_pmd_zap(tlb->mm, pmd,
>> +						folio_nr_pages(details->single_folio));
>>   			addr = next;
>>   			continue;
>>   		}
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index a931243ca42b..d793ad0c5364 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -295,7 +295,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>   			pvmw->ptl = NULL;
>>   		} else if (!pmd_present(pmde)) {
>>   			if (pvmw->flags & PVMW_SYNC)
>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> +				sync_with_folio_pmd_zap(mm, pvmw->pmd, pvmw->nr_pages);
>>
> 
> If there is no folio, why do we care about the sync? Should there be a folio
> here? Anyhow, I think sync_with_folio_pmd_zap() really should be consuming a folio.

Since there are only two cases without a folio: 
mapping_wrprotect_range() and pfn_mkclean_range(), I'm hesitant to 
modify all page_vma_mapped_walk() callers to pass in a 'folio' parameter 
for these 2 cases.

Or should we add a new flag for the pfn walk?

/ Walk a PFN range which need not belong to a folio /
#define PVMW_PFN		(1 << 2)

Then the changes would be:
} else if (!pmd_present(pmde)) {
	if ((pvmw->flags & (PVMW_SYNC | PVMW_PFN)) == PVMW_SYNC)
		sync_with_folio_pmd_zap(mm, pvmw->pmd,
                             pfn_folio(pvmw->pfn));
	goto next_pmd;
}

