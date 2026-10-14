Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FD3CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14086B00A0; Wed, 14 Oct 2026 05:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76FF6B00A2; Wed, 14 Oct 2026 05:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964D96B00A3; Wed, 14 Oct 2026 05:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B05D6B00A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:51:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBE0F1C3C6B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:51:22 +0000 (UTC)
X-FDA: 85320764004.05.2CFAA56
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32AD814000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:51:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EeBYtdAq;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971481;
	b=yEc4TC9hgBJ1K2XHb0GsvTdxo4q/k3fpkyMj3XS4WHG6n1wrMtjn2+lluFO12wtuLlfU+F
	EQLVjQywgH2A8ko3osruHzwIGquuKxUKUPB4IKPxFM9qMEAEpkO8Frf+HxjcwWjio4uKbW
	WzCRPBYBnhp3VDSB/RuZ4frUHEMXvhQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EeBYtdAq;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7PVsWTOJqkiosjUN8H7OzSWCN6+Mwp1tgv/kocb8dk=;
	b=FTPrimxBF2I2N3H3Dom+9SuWwbqWboMaWgolZHor9dxMTWZc6UXxMl6EBpMUtiKsLg+cps
	oo0C5F4aAyNNvlDktB7jlgL6y1RqlGqZNdblZh8p2e994+3EgpSIt6yh06jL6ppdctfP24
	bSQGI9c7InsJzrD4Gw5rX+hUvU27QiU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791971475; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=g7PVsWTOJqkiosjUN8H7OzSWCN6+Mwp1tgv/kocb8dk=;
	b=EeBYtdAqEtoFxNGTgxbeiLe47ZZXfcAnhEMNZnpOoM1c7nTRciDbUeP2iIH0zED5Fl3OXX9QO3G6SLU56E5XLruGC11W0Nl6SLBgv8rmLMAzu+brXv4Sqrhg1o6RuCZCJSiyhqQgGNCKIAjBkYn/Y3mKpZD5l4sknux+/0o5tWM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCon-04_1791971473;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCon-04_1791971473 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 17:51:14 +0800
Message-ID: <41966c48-3a10-43e6-9b12-f15a9621af6f@linux.alibaba.com>
Date: Wed, 14 Oct 2026 17:51:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <as4FIaQlxb_nqyX9@pedro-suse.tail5790ac.ts.net>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <as4FIaQlxb_nqyX9@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32AD814000C
X-Stat-Signature: nhqyod17wnirb8bi1akqmthmomkcaaq9
X-HE-Tag: 1791971477-20145
X-HE-Meta: U2FsdGVkX1/7YYVkeHpoyY6iWNXtVwDYeqXs0y3lFhJSvwZW5NPSN3laUet2H0WjtI/p5uV2DIHYY9mIRySdL7/U8ERCaE2f6ALrD7zOlXkzZFqF6X63JyOlaTNcU3HZOTPiCBQ83f5Hf7nSlaQ06Wh/I4jux0IoXQvA3VGSsR3JG7NgeTpUANJo/7c6YJIKMsjdsbpF4TDVzlR1tuUGJq52GMUgAek8KUJL+Gx9TrmI3O5ndX9QIGl6Xlj3eLq/CG6cjwNvkawmDTtLzkJxPICF5E8HtYuSlbDguUxoDQJhN3iZp0rV9iAUUnXgOjJe4PZk/kDZOatMEMYtyanipYhrNWqHpL5uwsZf7WUjGOzBQ8N/X6Z1Hl/HwwNbfDpw0b8QUMiVAD/9iH3DoWwfrT4pNWMFzZfUVLsJlnn0RWsdf1wSxL7R/t3Zf4rG10CIm9u0HpupvBfcT8WM4YXOfzC4VGEKz0vVREJ1DU7AZiGTxzi9gb/qftr7MkmQmeJVbOAgbq70kUwtH5b0kgrLOo+k2tQPbS0L4xWqVdNN6rDoy9cmUyVcmNeCfc/0mfU2RXKNPxGt38+vvOfspAHrpv2NAXd0Z9SaNOvkfZZwEO0Fu05ywqPws87bkkPACrRKRuQGu7dr8q9j/EEK3RHx7u/4ElTB26qIhknKKmgcuW88033jUZojpvAitNLGMQBNy/gkWGHfWsCiHTamuAE/AvYeSS21OzbutetFRlPn2NsRUVRIIOHwWVkm2oV/89B3tp9vncyiTYrFoXOSI/jW8hAJi2AmU4JpUCpu6c4q3CFxjNVhMPvbmm/f5cZDIsOYxWDZVXXenvDyhJ4xSaHbMLqnVbmUX56b52glelXBUgbfgpd5DO3usUEhpaYlxEcs2IKesHXJVHkLLePWKCTt5eFZm2+Z3o3XNG+0FsEhovf7gbH1M7MY/ml7Hwl8LxT4RDSgNgSIpuhD+MaHswB
 xeorCTY+
 bQcBzihr80DfYw4oXylEBDHBu7990NuiJRETdo1/2/SzSMF8c4V2UHQFqpTqi/Cqr0ibCOkwf9c2rVITDrqTU0D4Jqxu1SenhnAWODsxUve+ujjw567qTuO8uhmX1uPkLr1yO/nArw7cVz+Hh6fnDWC6ac4Vj6FjPxjugL825zfbpbBTBs356+SzsVFBln0jj8tm/foBLY5dIrFfZ5ohYDGpTBnsiqqdADfj/rPC7lucEXtSGsphuUH19m5xwbce+IH1m0YnVT2Sbt1xtEr23u7Ib28IPodog1B94nelgPLzyOoM47eC8RdL+iGv2lfMKtLQyN9eVnf2Zw5l4ijgFheRBDf4SZlI/3y7JCOjibi254hRxrcok64T2mTresWrn1IVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/13/26 6:24 PM, Pedro Falcato wrote:
> On Sat, Oct 10, 2026 at 03:22:18PM +0800, Baolin Wang wrote:
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
>> to after tlb_flush_rmaps() and add smp_wmb()/smp_rmb() memory barriers, so that
>> when we find a pmd_none() while unmapping a folio without holding the PTL, the
>> folio's mappings are guaranteed to have been removed via tlb_flush_rmaps().
>>
>> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
>> Reported-by: Ayush Ranjan <ayushr@modal.com>
>> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks.

> Mostly LGTM, thanks!
> 
>> ---
>> Changes from v1:
>>   - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
>> ---
>>   mm/memory.c | 29 ++++++++++++++++++++---------
>>   1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6a8e7772b8d6..c3a1faf580c8 100644
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
>> @@ -2044,16 +2053,13 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>   	 * to ensure they are still none, thereby preventing the pte entries
>>   	 * from being repopulated by another thread.
>>   	 */
>> -	if (can_reclaim_pt && direct_reclaim && addr == end)
>> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
>> +		/*
>> +		 * The rmap changes need to be observed before PTEs get zapped.
>> +		 * Pairs with smp_rmb() in zap_pmd_range().
>> +		 */
> 
> I'd amend this comment to something like:
> 		/*
> 		 * rmap changes need to be observed before page tables get zapped.
> 		 * Pairs with smp_rmb() in zap_pmd_range().
> 		 */

Ack.

>> +		smp_wmb();
>>   		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>> -
>> -	add_mm_rss_vec(mm, rss);
>> -	lazy_mmu_mode_disable();
>> -
>> -	/* Do the actual TLB flush before dropping ptl */
>> -	if (force_flush) {
>> -		tlb_flush_mmu_tlbonly(tlb);
>> -		tlb_flush_rmaps(tlb, vma);
>>   	}
>>   	pte_unmap_unlock(start_pte, ptl);
>>   
>> @@ -2108,6 +2114,11 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>>   			sync_with_folio_pmd_zap(tlb->mm, pmd);
>>   		}
>>   		if (pmd_none(*pmd)) {
>> +			/*
>> +			 * Order this PMD read before the folio's mapcount read.
>> +			 * Pairs with smp_wmb() in zap_pte_range().
>> +			 */
> 
> and this one to something like:
> 			/*
> 			 * Order this PMD read before any (possible) mapcount/rmap read.
> 			 * This isn't a problem in most cases, due to us synchronizing on
> 			 * the PTE lock, but such doesn't happen when PTE tables are zapped.
> 			 * Pairs with smp_wmb() in zap_pte_range().
> 			 */

Ack.

>> +			smp_rmb();
>>   			addr = next;
>>   			continue;
>>   		}
> 
> Also, as a note, I would suggest we hold off on this fix until the merge window.

No strong opinion.

> I don't think it's that urgent, and it seems like there is a possibility of a
> nicer, cleaner fix. That and we need to audit pmd_none() sites for other
> possible smp_rmb()'s...

