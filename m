Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0EBBCC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C3B6B0099; Sat, 17 Oct 2026 01:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0144A6B009B; Sat, 17 Oct 2026 01:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94D76B009D; Sat, 17 Oct 2026 01:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2A776B0099
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:11:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBED6401F7
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:03:51 +0000 (UTC)
X-FDA: 85330925862.28.55D3BF5
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 480CE100002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:03:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="M5Wn/0ss";
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792213429;
	b=0rr3oodB+U83VefBw5lDG+FpgbixFlCnGPvpbdauz04pLxpHonnK2iMryiJLRDjS5xL28A
	FMiltp3JCWltSYdjyddQPWkofkMqWqKbTfpRgL7xR4uSqf+vpAhYmJnhRXh13Ocs0t7Kpn
	ONrp7jihBqENc7j+bcVoLwY+eSNRtHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="M5Wn/0ss";
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792213429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bNNdf54bPSOyu30QFMPlpmkgCZp3aoSZH9DnyMrUgk=;
	b=BcdqsKAwx0yiXWkcIzWdXiNp2cTglCc5K4gTPwfFoiYp6lzo7MnpfrhhbyAXF5fuIOAhwt
	A1sX1iGdofZ7OW8Hi5xpAMsbY6c3rhdr4dCydyVv8Syx9fzNSvIG4U0u0/qURPUN/ZRhfe
	pRAjFxrRRNDqR9ujQCqQoTaC6DDCCfw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792213425; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3bNNdf54bPSOyu30QFMPlpmkgCZp3aoSZH9DnyMrUgk=;
	b=M5Wn/0ssx07661FCEJ0/4dh7DxqTE4u9tJNC8C3pvtrHYdhrL1MM7jfdHcfaV3eFYgNjQQDj1HSn27ddWxNc4GKKmsT+PfSyWFFiRzvD+YNyRQ0yS4NkgHnC8C8R3zmzk9MJj9X/4LJwp04KEWwcs8imPAGbZNhGZbJuy1whnRk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCwamdB_1792213420;
Received: from 30.42.72.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCwamdB_1792213420 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 13:03:40 +0800
Message-ID: <21710bdf-3923-4e09-a99c-db50bf7e3247@linux.alibaba.com>
Date: Sat, 17 Oct 2026 13:03:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: memory: fix truncation removing mapped folios
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 qi.zheng@linux.dev, jack@suse.cz, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
 <atIsNGVDcWtznMKi@gremlin>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <atIsNGVDcWtznMKi@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 480CE100002
X-Stat-Signature: qdq8q5zzg4pj1t8tweuj3bawq6t341co
X-HE-Tag: 1792213427-978632
X-HE-Meta: U2FsdGVkX19+U+O+lYD6sSC+5nYTDY2aOBB02D2NxOfrXnN51koo8nkXCHUZh2kJat+lIAE3l9W9sJnb5rqF4yKjIny0xvqX6cF2AwZp96SJkHAFpij4v0ku/s4dgU0rKsosFjhgIntwf52aylL32z8RUTbG6l3gYC4M2e02+q3pcBB8DVYUgM+3kN9MPqeTjQOvNmcfZ2z+Ca923lnRyQEK8L099lvWERxCzwhescWWGzCLlS/GEGy2C+Nk9wlfJOmpDxFr7KEczT4t1XMSSBElO5csR4/mfef7wBCDCCOIgTekjttn3AKZl7xwy20uXMtykvnrv/NSKDpfKiUqWFNXuYHrfPgTexT73U9rY+f9OtTtjECWCPnjejwIcrALBZOyH5BBHKo7CfBN/wGY8uKgaJ1qzycPDvTI7mXRZbGhG82nlv/FJbRIrMidv4BX12PtDsKPftOBXPnOpgphMPjWW3N35GUyFzd7bh+4wmlPpxduY2FK19Xt3xUjEsOKgeZiWXOF3dVjPOx+WfQ2XRhlcp8tMZT5MrBDw5WQC65ZKYJAYKWYnXWaiqFkDHSANidWOqUy2x7e9q20zsD+la/g3jXEtcPbiv1r1dF88MCjaosaVKknTr0pXMBSVIUz13DINtrJXDlreptKdrbnGwzhOWOgHTdH/AnlJ+kS7/eaOJ4HV0DweqrvZGHpSMtVPYyiQmc/YJGHgDczA2XGSRivdPZuyvqjBZeyxL5Aa/aiBLHa2veImaJvVzKSTTbGiV4csMkMThR7ynE0fCtZDrb5aHzyEhVzbsU5gsbosOWeLLfb4C50Ut7Mx6w065p2wPDZIr09MZyPYq/RUJQBMGUBzWfGlVoL9QbcDLl6l/ijuZSH1IC7eWuT2YdpqXTljKPnfKdZVVZYBc3yi4089lqVd420CkuTLkmqHWvuUnfswyXZKjVb4ovI+6pdYXIjLkYuvQYUm2lb1l+NF/h
 2fO5fw1R
 3+KdlmmUTbeJyJ7kko6zFBsKAXDLWj3Q/yxpUwqmyFQ8Dftu6hp0lXmZUeytnSiYdMh2PjnjIL27snfyqFsDIAgyNqFy5fzxUGk7NF7zwPclws5YYGTzB12JvWne3jL6bK5Voik/EmaF90maucI3xrAfugz0mLoI0X/Ke3hTsqCSRrbh7nZH5ScRvxHxJtlbftsQ/mxSK8Fc5qUFfvAFymZo4x4bydmjSAJozpTdfVdm7TvIAKWL/i8j9U1HDwyaF+u056VFHJRj/l7UzyZYzYd1FtCy2pTOCDtMvPBaoHtAPiX0QrnykA8X8Ms26c+8sSvRyxwvxoK6Wub+ow8JA1GBa6CZvrWsf4Ew7xilnaZ82tW0rfpCLplsTFM9cxaBCq1NW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/17/26 1:36 AM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 16, 2026 at 09:48:08AM +0800, Baolin Wang wrote:
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
> 
> With nits addressed LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks.

> 
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
> 
> 'zap_empty_pte_table() may have cleared the PMD but not yet modified the mapped
> folios'
> 
> Is that accurate after the patch?
> 
> You run tlb_flush_rmaps() before zap_empty_pte_table() now, and thus
> folio_remove_rmap_ptes() ran for every folio by then.
> 
> Maybe something like:
> 
> 	"zap_huge_pmd() may have cleared the PMD but not yet updated the
> 	 folio mapcount, and zap_empty_pte_table() clears the PMD only
> 	 after the rmaps for the table have been removed, but nothing
> 	 orders the pmd_none() read against later mapcount
> 	 reads. Skipping... <etc.>"

Ack. Thanks. Looks good to me.

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
> 
> Maybe worth a comment here about ordering?

Sure. Will add something like below:

diff --git a/mm/memory.c b/mm/memory.c
index 976cd03954e3..6a93b7fa48b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2052,6 +2052,9 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
          * to hold the pmd lock failed, then we need to recheck all pte 
entries
          * to ensure they are still none, thereby preventing the pte 
entries
          * from being repopulated by another thread.
+        *
+        * Clear the PMD after the rmaps for the table have been 
removed, in case
+        * an incorrect mapcount is observed after unmapping the folio.
          */
         if (can_reclaim_pt && direct_reclaim && addr == end)
                 direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, 
&pmdval);

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
> 
> I think David's getting at (correct me if I'm wrong) doing:
> 
> 	} else if (details && details->single_folio && pmd_none(*pmd)) {
> 		sync_with_folio_pmd_zap(tlb->mm, pmd);
> 	}
> 
> Here, rather than folding into the below?
> 
> I think that's neater also.

As I replied to David, keeping two pmd_none() checks cannot fix the race.

