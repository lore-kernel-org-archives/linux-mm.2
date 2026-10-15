Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E35CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44BD6B0088; Thu, 15 Oct 2026 02:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CA56B008A; Thu, 15 Oct 2026 02:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32FB6B008C; Thu, 15 Oct 2026 02:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 833ED6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:41:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2C01808CB
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:41:52 +0000 (UTC)
X-FDA: 85323915264.21.01125A5
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id C1FE880007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:41:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iwXyxfmy;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792046511;
	b=ynGK0FK3hCCSwCQtfoZHl4B+JlXybcTb4c9wNsjpuwSDYwVOCytG8ZWkGOzb6cf8PTAFEK
	eCz7FjvXzJ3yVR20NlHlcc+uFpInyQMSNkRqTle23tTpiWSPST1PBUB8dFzqKf9hrpQCh5
	r647XnZONFDV9vPIvLSfMZ047vwBG/s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iwXyxfmy;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792046511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kibslPdex3kvOCjH6VpWlnah8blg0nm8DCA8cn/iXBI=;
	b=MfpjeUNvTQ1BymN9+niyvq25FmdkzO0ESpLgC8YObn9X3kyAfQP9vJydTsNry3ybsfB65w
	HSZr2MuhC7lbPA+XOf6H+L65O5zyFtC1C93dqne2W5YS1LyyYzeXjnPv41PlfHgho96dhq
	rOZuBojp1U/2VkZ17to7+943EdMRf4Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792046507; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kibslPdex3kvOCjH6VpWlnah8blg0nm8DCA8cn/iXBI=;
	b=iwXyxfmy4YULvszwj5u1jaNUjm3JzvFppBrHwicKTvizoMG7BBnCdpp1WWqwo+fWCY+ImlqHgsurzUMePDf69eWaC7bvBstiT2a0rAuy8/Coe+inwrC+PFY4t/s8T6CHGD6rYwNcOmbzoeYT00qDk3F1/K1SsatDsVM4VPP2BnY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCqvFCR_1792046505;
Received: from 30.74.144.143(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCqvFCR_1792046505 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 14:41:45 +0800
Message-ID: <02c9a968-92e2-49e2-bffc-74d264a5c911@linux.alibaba.com>
Date: Thu, 15 Oct 2026 14:41:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1FE880007
X-Rspam-User: 
X-Stat-Signature: so6nbwcgbzpq43t81b38csq4gutofrpy
X-HE-Tag: 1792046509-410053
X-HE-Meta: U2FsdGVkX1+0V5CFKBqIOXdICIzVjv8eHOoZXcoqumSWvctF+rNQYjNtJry1Cvm3XDiW+31lftnV5JSiRLkO9QJAFE+Csy1mu9fgRrsCwCO0O3FS9TFkSDvOty1OfpbyQ4e0HR+HT5BsuchRIcG0pX03jVvponR2Uqk/zGqBwaZdcw79Ye5za9hPxJXm1LcYTJs2Npnz8MaKTMyhgtiTYh9ugepkMfTICAA7JdTMy+MpjAeN56g7cj6TZPQjrrNNxPn8Rx4YCnmMcrPqB72vyT1TBff4wcVUX6wXDf8Jp40efb8buAiDBORIb/mgMFcUYPHjvJsLT723A6TmZij+7Mon8W1KNyFutLuJLa8l3fYwpVT+sJQOJBhVPzoLGLTnVwza8PyUMCMiLTZsKbDyM/Ys6OryFXwKd0k+hCJdVgu4772aD1Ph9Av+j3pN9AhtCpQS2vLYM//PeyDqQbyRTZSlKZaFJg8DPqc+fdIg4lu9uXui2Kf9mo29fJiUx3H+b4OuhldVPROpgs3YgHkKz6+xek8EUXQwVgfFWQnOG1J2zvfEsnvRY33LcNz1uNsZsgIShPvczc31dwmZPNQYLFNJlodJ+aitcW3cKaSD8TaP2NTi6cwm/ODruCaG7xiDaVA8pfNzegs3CMLMLsWlwDE0f+TilfUVR29JUm0s3GdPRDwfLY7H8xiwTs9LJwOC0vVFvyiyHjjfQoXC8tZTBK0PVO0dCEagmqXSWjEFSO+Ut6Tnku99xhbCLmlk8Cc7o8pnx4WQb8eakChBxeoOLEqvXunCUpdhiQTguAx7tLD7sMe+gdfJ9BQ37WjdX1NI412xm38zuOlREDoHi/oI5Iz98/obbpCTLmtTfcqEBZ/VfScDzkeOy3gySxg94zaJtwYRvTUkiIOrn/Qp6da9QV3dakU4gp5rEkBYkoS2rfK6j9TH5ew2sRE3wngy4Uhh3xPTDZrcEhsxbiKhn0S
 9A1pvom2
 AmnSHJGhhGQBgiDcHgIlnNp7zDZLgeGeI/IYjTAty71i5m2TXtC+H0fuZeLnoZG5JgVNpKhWBE/p5d3T7O9UmHUrbeMtxoDNKNSHgjtxVJJL7muLLd8uP56T72rRjPpLPjrc2Dbi81JwtnrN0hj9xM22m/RbIICYanf16gOmDTO6wuQS/kfc+9JOgm4fUZfUmzSTHEs3vNcLRVYOn/sGJSy4gzcAB+4KDehHHqHbAzwYrkhbVxO5fpf0rDtYzwtuoX6NEo1Rc3ZjoLbT3Haur35vNXIeyf1yQGHSUqV0ECralGNn5/9WR658YQSTp9pO14w5lUdFBLffF7QXI0TaFmBgnug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 9:25 PM, David Hildenbrand (Arm) wrote:
> On 10/13/26 11:36, Baolin Wang wrote:
>>
>>
>> On 10/12/26 6:23 PM, David Hildenbrand (Arm) wrote:
>>> On 10/10/26 09:22, Baolin Wang wrote:
>>>> Ayush reported an issue that shmem/tmpfs folios are still mapped when
>>>> truncating them on production:
>>>> "
>>>> BUG: Bad page cache in process ...  pfn:...
>>>> page dumped because: still mapped when deleted
>>>> "
>>>>
>>>> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
>>>> branch, and I got the following crash info. From the dump message, we can
>>>> see that truncate_inode_folio() is really trying to remove mapped folios,
>>>> which is incorrect.
>>>>
>>>> "
>>>> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
>>>> index:0x3880 pfn:0x191647
>>>> [  189.171995] memcg:ffff0000cc073d40
>>>> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
>>>> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
>>>> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
>>>> .......
>>>> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
>>>> [  189.172026] ------------[ cut here ]------------
>>>> [  189.172027] kernel BUG at mm/filemap.c:155!
>>>> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>>> .......
>>>> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
>>>> 7.3.0-rc4+ #277 PREEMPT(lazy)
>>>> .......
>>>> [  189.183986] Call trace:
>>>> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
>>>> [  189.184391]  __filemap_remove_folio+0x34/0x160
>>>> [  189.184633]  filemap_remove_folio+0x4c/0xb0
>>>> [  189.184859]  truncate_inode_folio+0x34/0x58
>>>> [  189.185087]  shmem_undo_range+0x220/0x658
>>>> [  189.185308]  shmem_fallocate+0x2f0/0x470
>>>> [  189.185527]  vfs_fallocate+0x128/0x328
>>>> ......
>>>> [  189.187078]  el0t_64_sync+0x184/0x188
>>>> "
>>>>
>>>> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
>>>> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
>>>> MADV_DONTNEED synchronously releases the pagetable page before calling
>>>> tlb_flush_rmaps(), this could cause another thread's truncation to skip
>>>> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
>>>> as non-zero. A possible race scenario is as follows:
>>>>
>>>> CPU 0                           CPU 1
>>>> shmem_fallocate                 madvise_dontneed_single_vma
>>>>     unmap_mapping_range            .......
>>>>     ......
>>>>     (filemap_map_pages() remap folios)
>>>>                    zap_pte_range
>>>>     truncate_inode_folio            zap_empty_pte_table(pmd clear)
>>>>       unmap_mapping_folio
>>>>       ......
>>>>         zap_pmd_range (saw pmd none, skip)
>>>>
>>>>     filemap_remove_folio
>>>>       BUG_ON(folio_mapped)
>>>
>>> That reminds me of sync_with_folio_pmd_zap() usage in page_vma_mapped_walk().
>>>
>>> Isn't that the better approach?
>>
>> I had considered this approach before, but it is not feasible. IIUC, the
>> sync_with_folio_pmd_zap() is used to address the race with zap_huge_pmd(), and
>> both the PMD clear and the folio mapcount decrement are performed under the PMD
>> lock in zap_huge_pmd().
> 
> Just to be clear, I am thinking about something like the following on the
> zap_pmd_range() side:
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c94..a8820ad7e2f21 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -584,14 +584,15 @@ void free_pgtables(struct mmu_gather *tlb, struct
> unmap_desc *desc);
>   void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> 
>   /**
> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>    * @mm: The mm_struct.
>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>    *
>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
> - * indicate that it's unmapped. Skipping the PMD without synchronization could
> - * make folio unmapping code assume that unmapping failed.
> + * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
> + * yet modified the mapped folios to indicate they are unmapped. Skipping the
> + * PMD without synchronization could make folio unmapping code assume that
> + * unmapping failed.
>    *
>    * Wait for concurrent zapping to complete by grabbing the PTL.
>    */
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3de..c585f5eb255c9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2139,9 +2139,7 @@ static inline unsigned long zap_pmd_range(struct
> mmu_gather *tlb,
>                                  continue;
>                          }
>                          /* fall through */
> -               } else if (details && details->single_folio &&
> -                          folio_test_pmd_mappable(details->single_folio) &&
> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
> +               } else if (details && details->single_folio && pmd_none(*pmd)) {
>                          sync_with_folio_pmd_zap(tlb->mm, pmd);
>                  }
>                  if (pmd_none(*pmd)) {
> 

Yes, I've considered that. However, implicit memory barriers give me a 
headache, so I ended up going with explicit memory barriers (suggested 
by Pedro).

If you don't like memory barriers, let me re-check whether the implicit 
memory barriers here can ensure race safety with 
sync_with_folio_pmd_zap(). A simplified logic is as follows:

CPU 0 (truncation)                        CPU 1 (zapping)
down_read() ->Acquire A1.                pte spin_lock() ->Acquire A4
                                          clear mapcount

                                          pmd spin_lock() ->Acquire A5
                                          clear pmd
                                          pmd spin_unlock() ->Release R5

if (pmd_none()) { //read pmd
                                          pte spin_unlock() ->Release R4
     pmd spin_lock() ->Acquire A2
     pmd spin_unlock() ->Release R2
}
up_read() -> Release R1

spin_lock(y) ->Acquire A3
folio_mapped() // read mapcount
spin_unlock(y) ->Release R3

CPU 0 constraints:
1. R2 is a release, so "read pmd" completes before R2.
2. A2 completes before A3 (ACQUIRE vs ACQUIRE).
3. "read mapcount" completes after A3, hence after A2.

CPU 1 constraints:
1. R5 is a release. Both "clear mapcount" and "clear pmd" complete 
before R5.

According to above constraints, if CPU0 sees pmd_none() caused by CPU1's 
clear pmd, and CPU0 then acquires the same pmd lock released by CPU1 at 
R5, then CPU1's clear mapcount happens before CPU0's later folio_mapped().

Therefore folio_mapped() is guaranteed not to read the old mapcount in 
this case. So I think sync_with_folio_pmd_zap() can work, but needs a 
small change to avoid the double pmd_none() check.

David, does the following diff look good to you?

diff --git a/mm/memory.c b/mm/memory.c
index 6a8e7772b8d6..c0aadab1b59e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
                 }
         } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);

+       add_mm_rss_vec(mm, rss);
+       lazy_mmu_mode_disable();
+
+       /* Do the actual TLB flush before dropping ptl */
+       if (force_flush) {
+               tlb_flush_mmu_tlbonly(tlb);
+               tlb_flush_rmaps(tlb, vma);
+       }
+
         /*
          * Fast path: try to hold the pmd lock and unmap the PTE page.
          *
@@ -2044,16 +2053,8 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
          * to ensure they are still none, thereby preventing the pte 
entries
          * from being repopulated by another thread.
          */
-       if (can_reclaim_pt && direct_reclaim && addr == end)
+       if (can_reclaim_pt && direct_reclaim && addr == end) {
                 direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, 
&pmdval);
-
-       add_mm_rss_vec(mm, rss);
-       lazy_mmu_mode_disable();
-
-       /* Do the actual TLB flush before dropping ptl */
-       if (force_flush) {
-               tlb_flush_mmu_tlbonly(tlb);
-               tlb_flush_rmaps(tlb, vma);
         }
         pte_unmap_unlock(start_pte, ptl);

@@ -2102,12 +2103,11 @@ static inline unsigned long zap_pmd_range(struct 
mmu_gather *tlb,
                                 continue;
                         }
                         /* fall through */
-               } else if (details && details->single_folio &&
-                          folio_test_pmd_mappable(details->single_folio) &&
-                          next - addr == HPAGE_PMD_SIZE && 
pmd_none(*pmd)) {
-                       sync_with_folio_pmd_zap(tlb->mm, pmd);
                 }
+
                 if (pmd_none(*pmd)) {
+                       if (details && details->single_folio)
+                               sync_with_folio_pmd_zap(tlb->mm, pmd);
                         addr = next;
                         continue;
                 }

