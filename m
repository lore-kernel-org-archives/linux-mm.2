Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A42606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=V9G2ZsSo
Received: by kanga.kvack.org (Postfix)
	id 7D8FD6B05CD; Tue, 27 Oct 2026 05:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7633A6B05CE; Tue, 27 Oct 2026 05:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62AC66B05CF; Tue, 27 Oct 2026 05:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33D8F6B05CD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:03:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE9AA1C41F4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:53 +0000 (UTC)
X-FDA: 85367818746.20.7E2B278
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7191120007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V9G2ZsSo;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNG24tQY55R3gZy9VxOdBRDeZa6e92m1sqs1xmlBkCI=;
	b=6WU9gaKTDQSsAr+I2AtVFPJAh2xNW73FvX38a+7HRoFDA0Fb4qvc4qUNmKAsqaCEsoPfzP
	gU3muvtFG+XqfAjH5iktuvp2alvQT29AzLZep0MR/ca0GBipTzsMQORr7n1asW9Eu0Ns9T
	S9wxKh+XZurB/Kjr1MmexPnaQRETVZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091831;
	b=kJZ/f3C8/QLlBMbXuh02hOKwTdTeDsfeMpv8OCQc5BTomje6mRV+mISh9ae5kOZXsih7ae
	M2zTC9/wUdAMNNHDGCUWuY0Yrdll9Okcz/YMsCLitNKLB54jWRMZPIDwrFjYu/Ys5j4JGk
	JzHHLsoMEvFQ/szJh/3lF5qw9suH0Lo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V9G2ZsSo;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793091828; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TNG24tQY55R3gZy9VxOdBRDeZa6e92m1sqs1xmlBkCI=;
	b=V9G2ZsSoC/mP00KApo0Ul17Ds8M0dFfV1yr/ZxpnANEeTu53sHRHZbkpijlJr0C8OyrtML01Sk44ncDjibGmeF0QrmYMMUbgVGj4WH2+MzHKpozOmMo0YEXHH0Tddqi8Gv3Dbo28KIfDehHoZ+gzHW96mjOE4RHJP+f0RAeUdWQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDdD3Pp_1793091826;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdD3Pp_1793091826 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 17:03:47 +0800
Message-ID: <87e32afd-75de-4407-8f0c-fb70b40d5eca@linux.alibaba.com>
Date: Tue, 27 Oct 2026 17:03:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
 <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7191120007
X-Stat-Signature: he1jdr7ffja59swxzxzeinyyhfjauu4e
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793091830-102044
X-HE-Meta: U2FsdGVkX18P/V5RKUu58dXSYv/yc89rOuVzcURj5agpSEbV4OW+7mRi8XB1CNEi388VN0ZuQJ3wuEAqQej6JllSQpsVZ3AilbkxbPgrt/UmTd/DNouVv6IF6KxfHRDS2dczn3G3jbe9Q0NfDuQjPbvX9OIbJ2xR+wbgKFN+X85Qpqy9y8fh5hXALrKNpnMmky9gQbnm8aOF7X92rcxI9G8XOB5xVqh9I4WFuuShNY4SbBuWXSWLyizUUD0gPOAjjwgS5Nxry2hjKbGtbnF0efSOEbB6qIbP9Hm9ZbzA1z+ZX8kbo6QyDaQAOkxM4EqL7FR/FRPlkkvP52vrVlMWZgGfhXvbJ1yGrmqGl/hLzUDDnpoBols7igmljstcumwB0uT8wztbkhzCtxrIP936wQz4slcZ7IDZfOXOWb9Nh4kD/zPN4nnQaSfbbaCD6g9Vfpfz9V6iRL2n3D5Xr4w15Ro3KCM2CSO2p7isMpqgc88kb2B+knnNZmU0+0Wmd05/jSn43nREqzcK3v85XeN3Oslh8M0PE8QjBCH1/YhI13cMQIxHxAEdvPrROfOqB7QNziFk0R73O4dRPgv+AoSmOFFbKx6ycBQ6LtNr9h+YNaLCP+aa04dsIeNdYOF+91ny5DGTskl5vpq4yoWh78pCa1iU0aH/XoxAmaHaB9Bdj7rtqAelVaayuQzFpJTsH7N/3wJQ1L9NcYYTUEsTYvEvquL+LP6yYoUgMJDhPpISrmLaEz3lr9XVfIjDPujB3iENhCG//PKagz3Q1MTjAMeUERgKNJ/JmBk1V9hybZjJjuIMJ0e1+Gjtv4YhNzKPl5Z/dPCQy6Yii9vuwlEvoriSuNug4LpSYPEF49wnjgOvmeAaVAtYfOBlkAwf/Kh0tzQDvLVQMEUZEz2WyuNpMia7gJWzOKr9zb+81yfT0zooY3HuRvAtdxWoz8zWoRl/6rRWUAc0Yw57VR3h1o8NFCY
 r527yKFK
 Nky96XYD5AjEzT1H2QbCah3/GL7cH/hquXt1KFL9I6XdkpP0MCIICAH/p1VZHLxx8U7NZn4zZ7paC0ZtIfxDLcbwv009tMt0SLp7IHBbkqfVK+Vs+I4ahKyHKf7MYq699c+qKzro3hJO9p9pKAUD/jpp4vGfD5JSXnCBd1JIy9g+7YW8IFHj+0fp3mCWNDRh4f5jvyXOwMRpU0rPkElxDhxrnHseNGvdGLnBCRcHRvR7zLc9HXYgqFagwirA2kHtkQmyOrRMpPdd6SazJ2r5LHi5FDwiBCpz9e/loU3vei7U4Hbh/ZND3UvEjRdC9vzvkn4i6kTusR8ZH+imx9vpQUG1Hwvrsyk6WWrhECW3pfXCOPP0D/M7d3UFB9qlaUIhn9ldc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 5:00 PM, David Hildenbrand (Arm) wrote:
> On 10/27/26 03:19, Baolin Wang wrote:
>> Ayush reported an issue that shmem/tmpfs folios are still mapped when
>> truncating them on production:
>> "
>> BUG: Bad page cache in process ...  pfn:...
>> page dumped because: still mapped when deleted
>> "
>>
>> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
>> branch, and I got the following crash info. From the dump message, we can
>> see that truncate_inode_folio() is really trying to remove mapped folios,
>> which is incorrect.
>>
>> "
>> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
>> index:0x3880 pfn:0x191647
>> [  189.171995] memcg:ffff0000cc073d40
>> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
>> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
>> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
>> .......
>> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
>> [  189.172026] ------------[ cut here ]------------
>> [  189.172027] kernel BUG at mm/filemap.c:155!
>> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> .......
>> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
>> 7.3.0-rc4+ #277 PREEMPT(lazy)
>> .......
>> [  189.183986] Call trace:
>> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
>> [  189.184391]  __filemap_remove_folio+0x34/0x160
>> [  189.184633]  filemap_remove_folio+0x4c/0xb0
>> [  189.184859]  truncate_inode_folio+0x34/0x58
>> [  189.185087]  shmem_undo_range+0x220/0x658
>> [  189.185308]  shmem_fallocate+0x2f0/0x470
>> [  189.185527]  vfs_fallocate+0x128/0x328
>> ......
>> [  189.187078]  el0t_64_sync+0x184/0x188
>> "
>>
>> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
>> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
>> MADV_DONTNEED synchronously releases the pagetable page before calling
>> tlb_flush_rmaps(), this could cause another thread's truncation to skip
>> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
>> as non-zero. A possible race scenario is as follows:
>>
>> CPU 0                           CPU 1
>> shmem_fallocate                 madvise_dontneed_single_vma
>>    unmap_mapping_range            .......
>>    ......
>>    (filemap_map_pages() remap folios)
>> 				  zap_pte_range
>>    truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>>      unmap_mapping_folio
>>      ......
>>        zap_pmd_range (saw pmd none, skip)
>>
>>    filemap_remove_folio
>>      BUG_ON(folio_mapped)
>>                                      tlb_flush_rmaps(remove rmaps)
>>
>> To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
>> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
>> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
>> without holding the PTL, the folio's mappings are guaranteed to have been
>> removed via tlb_flush_rmaps().
>>
>> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
>> Reported-by: Ayush Ranjan <ayushr@modal.com>
>> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Changes from v4:
>>   - Put the pmd_none() check in the 'else if' branch (per David).
>> Changes from v3:
>>   - Collect review tags from Qi, Pedro and Lorenzo. Thanks.
>>   - Update the related comments per Lorenzo.
>> Changes from v2:
>>   - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
>> Changes from v1:
>>   - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
>> ---
>>   mm/internal.h | 10 ++++++----
>>   mm/memory.c   | 30 +++++++++++++++---------------
>>   2 files changed, 21 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index b1b0f29d2216..ffb8eaec90e3 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
>>   void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>   
>>   /**
>> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>    * @mm: The mm_struct.
>>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>    *
>>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
>> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
>> - * indicate that it's unmapped. Skipping the PMD without synchronization could
>> - * make folio unmapping code assume that unmapping failed.
>> + * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>> + * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
>> + * for the table have been removed, but nothing orders the pmd_none() read
>> + * against later mapcount reads. Skipping the PMD without synchronization
>> + * could make folio unmapping code assume that unmapping failed.
>>    *
>>    * Wait for concurrent zapping to complete by grabbing the PTL.
>>    */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index e911e63ba1ed..d9c54549b85b 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>   		}
>>   	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>>   
>> +	add_mm_rss_vec(mm, rss);
>> +	lazy_mmu_mode_disable();
>> +
>> +	/* Do the actual TLB flush before dropping ptl */
>> +	if (force_flush) {
>> +		tlb_flush_mmu_tlbonly(tlb);
>> +		tlb_flush_rmaps(tlb, vma);
>> +	}
>> +
>>   	/*
>>   	 * Fast path: try to hold the pmd lock and unmap the PTE page.
>>   	 *
>> @@ -2043,18 +2052,12 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>   	 * to hold the pmd lock failed, then we need to recheck all pte entries
>>   	 * to ensure they are still none, thereby preventing the pte entries
>>   	 * from being repopulated by another thread.
>> +	 *
>> +	 * Clear the PMD after the rmaps for the table have been removed, in case
>> +	 * an incorrect mapcount is observed after unmapping the folio.
>>   	 */
>>   	if (can_reclaim_pt && direct_reclaim && addr == end)
>>   		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>> -
>> -	add_mm_rss_vec(mm, rss);
>> -	lazy_mmu_mode_disable();
>> -
>> -	/* Do the actual TLB flush before dropping ptl */
>> -	if (force_flush) {
>> -		tlb_flush_mmu_tlbonly(tlb);
>> -		tlb_flush_rmaps(tlb, vma);
>> -	}
>>   	pte_unmap_unlock(start_pte, ptl);
>>   
>>   	/*
>> @@ -2102,12 +2105,9 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>>   				continue;
>>   			}
>>   			/* fall through */
>> -		} else if (details && details->single_folio &&
>> -			   folio_test_pmd_mappable(details->single_folio) &&
>> -			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>> -			sync_with_folio_pmd_zap(tlb->mm, pmd);
>> -		}
>> -		if (pmd_none(*pmd)) {
>> +		} else if (pmd_none(*pmd)) {
>> +			if (details && details->single_folio)
>> +				sync_with_folio_pmd_zap(tlb->mm, pmd);
>>   			addr = next;
>>   			continue;
>>   		}
> 
> 
> 
> } else if (pmd_none(*pmd) && details && details->single_folio)) {
> 	sync_with_folio_pmd_zap(tlb->mm, pmd);
> }
> 
> if (pmd_none(*pmd) {
> 	addr = next;
> 	continue;
> }
> 
> 
> Minimal change required, no?

No, keeping two pmd_none() checks cannot fix the race, as I replied 
before. [1]

[1] 
https://lore.kernel.org/all/179c26ed-1764-4e5b-a7ee-047ddabbfea1@linux.alibaba.com/

