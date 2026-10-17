Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED6FCC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BBA6B0092; Sat, 17 Oct 2026 00:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C336B0095; Sat, 17 Oct 2026 00:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631226B0096; Sat, 17 Oct 2026 00:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4E16B0092
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:52:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A60D8A0210
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:52:30 +0000 (UTC)
X-FDA: 85330897260.03.58339E8
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf05.hostedemail.com (Postfix) with ESMTP id 69237100002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:52:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Eug3PI9c;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792212749;
	b=QTqS+cpvFTbwgUArSjPx5q7S0nOsDzS+i+d4rBANwO8QSVpaxb2VkkZKZ4UmrTB+P5A9/9
	SpzZW1aTyyv8zSbddQDecdfauXpB6RMSb8VQ/Zv0zCYlZB1mkFzQ2jBXH5mLBPjWR2JDAZ
	D5sCiNSA557Qp/fcg55a6GCrZSvnNZc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Eug3PI9c;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792212749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJEDBL4BEKtkKheS+/j1A4lhBNqndMdblxr/ngjfYmk=;
	b=U0FJxdYvGvNbaChnkwh2gl+a+/5wsN26yh0y9TrFOyk29u7e9JzFFYV1lfoUxvyz3u1qxj
	FNRY8Re1xz82dmizrt4rCPkFrPU3arA+i2dMrGjvNubqHyk+PFPVqrPxxGJ5mvfyKCCESm
	74xjfaw3jzFks5PjJAqOGryQqC6Ra1k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792212743; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gJEDBL4BEKtkKheS+/j1A4lhBNqndMdblxr/ngjfYmk=;
	b=Eug3PI9cmlOhVSxjNCHLaiy5AY6MvUOcfplY5C+LEyitevaQGkTP+EIx4wAi1TeyZdZMbduFVisGgxN7PyGKHtMEh+65TMOBp/EJFezh2H/vcF9mgtoV90UZWRU3FN/+ZD27EED1OEtdaKvMbPOoW7RdmomxiBs8jIYLIyJa88I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCwX0Vf_1792212739;
Received: from 30.42.72.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCwX0Vf_1792212739 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 12:52:20 +0800
Message-ID: <179c26ed-1764-4e5b-a7ee-047ddabbfea1@linux.alibaba.com>
Date: Sat, 17 Oct 2026 12:52:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
 <094c9af9-3ade-420d-87d1-976730a5079a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <094c9af9-3ade-420d-87d1-976730a5079a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 69237100002
X-Rspam-User: 
X-Stat-Signature: 3u9yp5ebruuj8x5a91dywhrhptep1kjk
X-HE-Tag: 1792212747-871849
X-HE-Meta: U2FsdGVkX1/wdKG/sCeO9iY4ilJUwmx8reW2XRylY+LEG9qs7haUfQGU8JWWx/fpjMOIv0qLvHCf3hmjc3GZs/khbK5k9Zt4WdUE7bFBZT+OUMD099sKHns5DWRYdUDqIVX43/izt8vcMGkO6GRYVq0JibbL9DZNibf+YKxWbbK2uTfAbQfJmKwrA6qTRr/uXZdI6uDGDuIzG+PmPGZjIu3wZpIA4OcaihGnxgzkWKbi+2fsBohpuNcC/QdhjeSYXTfrDnLHviFbYeCOf/aQsz/MveL2Ws929I6I2oqmO24vaNXCLLjeLuAGPZ0nHabv20/Al4d/RMrl3kxxNcLfDRrBei3+y7sVo9Wpi7zjvctSdnNkcA8LAoluXftAUDcAc2pbtFcp2944Hc7og7fGdED794b3nAawfnR1opPwqI9raHLsI8qJCeptBwmoSJlMgoIfyMsxsssL3iDr/o6T4bs0mb032lm56O9FVZR5D1PvOTxoafAc75MmWiNLv2GqmZHtFCRRCm/txnl6ZcioFNg4IDd81sft23rSMjs+yrgMF1MZGldw990ubwMlIP5TWoQ19TR6Qcmqf0p+emg1+quNcgFyuJbBdsjxLG7H0H6kVILNlBVBI9QbWGjXexfWqNSK8qLSo+TidJaWIQVwJq2+WzGpnSmFHCVc+pO/2EiD6D4fRoJz0gtsGtOe/nfWE5eQW2Wa2s2syYz6OUlnRUMuUZuSNPBBXHodHFRmxY8GIykRcx00x4bvsW73oBGfQDUULtIRnoAFt5pZqv3PN97A0ZCg+4fEA4dhAS579MDrSU/0VNk9xqMYA/tLCvVUB3RFj/oEJmqGKh+2VhPUqURRRISBc+WwO9H93kZkwetNLTZgSwkzyuy4dkFabs5qroh23ofv/PyDwt6Wr2fMzw3YesdBKZkGjMxrfrikCB/yxZv2ovS84oc7v8cNpGfDUF927rPOFZ7RrTlnhY+
 PRTOf/l/
 JWrBzNoue+PDvmwJjBVdM1XzpdJOfkRlrdP1HVBDzozK6Fistknaueu8hVsec1qO4GMocZfWMxPhIZtxXOpfW059iGXXorSjFQhB85D7aOShF/9N8vDQq+6hv5c7uAAlB6tIjnEdmN2lC0CrgN3J43lwrvc7h6Peyf/+ZTwL6tjYj3DiPZnFY+YDsrke+fA/5g4tl/UcveaiuOhoANBBJMNe36a6E8TTwt223tL1BPoNRsL45rBAJ7H3RS/JhV82g6CZD+HT9/5qX2RbTtVqlkt0DO6oFm07LDLuyhb8w5viLGVFWaDVNxHzgpSVadVAzxRu0aDH+oGjaVqby+VXevPX2Gagk1GviDyh4CprSK7VqP473EkcG74bnOnhn36sX4jb9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 5:30 PM, David Hildenbrand (Arm) wrote:
> On 10/16/26 03:48, Baolin Wang wrote:
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
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Changes from v2:
>>   - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
>> Changes from v1:
>>   - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
>> ---
>>   mm/internal.h |  9 +++++----
>>   mm/memory.c   | 25 ++++++++++++-------------
>>   2 files changed, 17 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 0434dfcfc36f..6d8f494296a4 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -585,14 +585,15 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
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
>> + * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
>> + * yet modified the mapped folios to indicate they are unmapped. Skipping the
>> + * PMD without synchronization could make folio unmapping code assume that
>> + * unmapping failed.
>>    *
>>    * Wait for concurrent zapping to complete by grabbing the PTL.
>>    */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6a8e7772b8d6..8f7ba427371b 100644
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
>> @@ -2046,15 +2055,6 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
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
>> @@ -2102,12 +2102,11 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>>   				continue;
>>   			}
>>   			/* fall through */
>> -		} else if (details && details->single_folio &&
>> -			   folio_test_pmd_mappable(details->single_folio) &&
>> -			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>> -			sync_with_folio_pmd_zap(tlb->mm, pmd);
>>   		}
>> +
>>   		if (pmd_none(*pmd)) {
>> +			if (details && details->single_folio)
>> +				sync_with_folio_pmd_zap(tlb->mm, pmd);
>>   			addr = next;
> 
> By keeping it in the else path above you avoid re-taking the lock if you just
> sync'ed already when you saw pte_present() and resulted in pte_none().

If I understand you correctly, you want something like below?

	} else if (details && details->single_folio && pmd_none(*pmd)) {
		sync_with_folio_pmd_zap(tlb->mm, pmd);
	}

	if (pmd_none(*pmd)) {
		addr = next;
		continue;
	}

But this doesn't fix the race, because CPU 0 could see the first 
pmd_none() return false and the second pmd_none() return true, in which 
case no sync would happen at all.

Moreover, if you mean the sync already happens in zap_pte_range() via 
pte_offset_map_lock() (because the PMD is none), note that in this case 
zap_pte_range() returns the start address, meaning we'd recheck the PMD 
when we get back to zap_pmd_range(). So even with 'keeping it in the 
else path', we'd still call sync_with_folio_pmd_zap() to sync this none PMD.

	addr = zap_pte_range(tlb, vma, pmd, addr, next, details);
	if (addr != next)
		pmd--;

Please correct me if I misunderstand your point. Thanks.

