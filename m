Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097FE606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Z2iMXep+
Received: by kanga.kvack.org (Postfix)
	id 113A86B05B0; Mon, 26 Oct 2026 07:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB956B05B1; Mon, 26 Oct 2026 07:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0015E6B05B2; Mon, 26 Oct 2026 07:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83E86B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:02:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DF7A1A06C0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:02:34 +0000 (UTC)
X-FDA: 85364489028.10.5503ABD
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54CBB40006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:02:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z2iMXep+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793012551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSuWPrxQH7bI6MmyeQzCssh89AeufZoIj1R3yBnzkTk=;
	b=VSkaTwYh6HXs0XLQH+i3HvOribFVAXXyr8axe6QcgZA8JlAVk75vZyV12gnW84d4M/pAVs
	pj0NJDJFMMA4C4h0070yJ99GeMHOfM2UcOjBk5uZLjNNkvGQAFXN6biysmJFx8zyLGx5nV
	U2mw+x0HBka6TRpsULE++QkQ3KFJcZE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z2iMXep+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793012551;
	b=PM4b2UduM386y8U6MukxOBZpE1Mc1rlW4udLJ/EUHApd5R2CKN2YEls7/50zHqpYkx1V89
	NLqEwt2feBURM2Oxn0Pgrj4B+RB4lg+XU0HDMxONzr6BMcw9ZEzq5qH4xckM4HR4ajmB5w
	F/mOD07zXa8ZchWXoHP0zbq6EKw+m5Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793012547; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WSuWPrxQH7bI6MmyeQzCssh89AeufZoIj1R3yBnzkTk=;
	b=Z2iMXep+es5hLm7HF52tjuL79dmRwANDY+49stB2ORVVHCxwaUbQaZlVqpVVJnI1BbW7j3YIPRcuZPfWmxwGV7RPNSJsS1GxqzWlPtE1Pr4DF9+ZC6aunvp2GarR1YQisGR5RvN8qlTl3ycjDxMETzLeVSQES397HeCOkiR7WFc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDX0EnS_1793012546;
Received: from 30.74.144.181(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDX0EnS_1793012546 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 19:02:26 +0800
Message-ID: <8779b778-c124-49ff-8072-2c995394ed8e@linux.alibaba.com>
Date: Mon, 26 Oct 2026 19:02:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <4cc521a118564b4145edf0324066ab532fb41181.1792979870.git.baolin.wang@linux.alibaba.com>
 <c3dd24e7-68e4-47f9-a9d2-067c5534a4c4@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c3dd24e7-68e4-47f9-a9d2-067c5534a4c4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54CBB40006
X-Stat-Signature: habia8rtmu1hoz337r3c84d4q4z97et4
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793012549-646837
X-HE-Meta: U2FsdGVkX18m37p9PKZZ/Ohk2+02rVn3xDd45G0FEZ1yf81GOmGF0lZDXyqHUWEa8jfypH85sczPSbNrHub7uStvc/5ikzglU4NLPDR5UOAjXFCjTs43L6+is8yG2/ReVLIDd5B89a6J6ExJyN5xKZJbzlQwlQ/IsrmlG5vzNqxfN4Mi/jXsltdl+zFY08auDoP0xYPtISNOIpl5XEtNlrQu9OFM21ddkWP7L+QcMQPlfscgR6DQ2RQ6qK/vztvSQBof71OP2ZXHXGQaZlOVKA/i7xC5kpn/rkS/IQWNVUfOp0B6bIOjIQeUJtjE8E7XgCDunHMGH1pHhgOsCdARqZI8OaY/Sp1XcqVU9OoamdNs97vw2n31I0FvTekfMintwF3fNThT/gBVNRqd7jd2OZkDIwaVlbPfW8WRfRdgHMYeQDx9FaFqFIsVq06yO8oGVIjj+1VRoa+ouOwGuRRFwz0tmbumIzwZBPbXinvRflnAbBRWaqrQzUpIutYxoyqceLwaZx+FDA8a6EsEoUps581KkzFZi1Crrnr2FXHjoV8u6sJJA825UnXjC0XkURFsbsiDyVkZumQ95HcoEsoqaBSzwgCRViN7eEY7dLajkEHrwXEdh3M3BRcfPt1sDO3v1lDqKhLw1mK84IUpbOQnoY1Pw6LCMCoDXBk9IBKTlC+yZk/QSvelCl+N2JgEBLXwTrhLHCgPX6KhynNDiZdBCGuhEU4SJhkEgjckZTk1h1yuvsPshKcWlv/W3yqEfksx57Oqaaac2WUgFUsBWqeE+/s5uRXWLiEHBpTsHQtqYAauTq/QDvnfJSJEBGROfFM8G5Nd7Cst7Ztv6GzQn7LuDyAAtQXZJvOgG1awBQLZX+SK9s/8bpLh1k/ayuUiVHXPApXedNQyi7unve4/llnFJGnyfYKTPRnQiENbfSggegUPUaPjOlavgVbthamh1DyLnWKRS8+tH1tQKSYthgE
 ZSKRzy+b
 QRshY1HYsEXy4X/4ZeoZX3P5J86k8Xm+ZK07XAiMM8HGcQqA4SVv4SHasWzzzBdMd9rEr3ywDt/XIGj9aLbqJvoWHQOc2wBFRGarN8q+0lx35sLASltgrsXS/Iiqe7Kcyu0AKeyHKpBMzLGhgA5ujm3RkmW0OcpyYk7+YNbnceNCqxlKVtjsLa1p4D1tvu1T77kB8zlbV1d2WlapKhnFJSDW2k8kpD+VNvHvkRvhp6mERPrt7JRXB9hRZDIWUeFfV7gGFTdZxX3y+maTl6bsdAOC+QDcaJv7UQYIRyRacCOiTXhw33/fOunhzsjAND/jEvm528EnbeIEVYIqRSYIz+JZVzkuG+7rUHm+0Vahd59nEzeme/8eOuTWA0Enrjp2tZqVa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 6:00 PM, David Hildenbrand (Arm) wrote:
> On 10/26/26 03:05, Baolin Wang wrote:
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
>> Changes from v3:
>>   - Collect review tags from Qi, Pedro and Lorenzo. Thanks.
>>   - Update the related comments per Lorenzo.
>> Changes from v2:
>>   - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
>> Changes from v1:
>>   - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
>> ---
>>   mm/internal.h | 10 ++++++----
>>   mm/memory.c   | 28 +++++++++++++++-------------
>>   2 files changed, 21 insertions(+), 17 deletions(-)
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
>> index e911e63ba1ed..6a93b7fa48b2 100644
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
>> @@ -2102,12 +2105,11 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
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
>>   			continue;
>>   		
> Sorry if I sound annoyed, but why don't you keep the
> 
> } else if (pmd_none(*pmd)) {
> 
> above as I suggested?
> 
> Because we fancy unnecessary PMD table lock cycles?

Ah, sorry, I misunderstood what you meant before [1]. Yes, this is still 
correct and looks good to me.

[1] 
https://lore.kernel.org/all/179c26ed-1764-4e5b-a7ee-047ddabbfea1@linux.alibaba.com/

Do you want me to respin a new version or just apply the following diff?

diff --git a/mm/memory.c b/mm/memory.c
index 6a93b7fa48b2..d9c54549b85b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2105,9 +2105,7 @@ static inline unsigned long zap_pmd_range(struct 
mmu_gather *tlb,
                                 continue;
                         }
                         /* fall through */
-               }
-
-               if (pmd_none(*pmd)) {
+               } else if (pmd_none(*pmd)) {
                         if (details && details->single_folio)
                                 sync_with_folio_pmd_zap(tlb->mm, pmd);
                         addr = next;

