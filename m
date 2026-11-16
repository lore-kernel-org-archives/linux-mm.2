Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C6E606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Kl1YzAVp
Received: by kanga.kvack.org (Postfix)
	id DFF226B05B1; Sun, 15 Nov 2026 22:44:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFBA6B05B2; Sun, 15 Nov 2026 22:44:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E436B05B3; Sun, 15 Nov 2026 22:44:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 988C86B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:44:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99702A862A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:44:53 +0000 (UTC)
X-FDA: 85439590866.20.8C1AE2C
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 929A9100002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:44:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Kl1YzAVp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794800692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZQTmnkOlTIQcpFlUhpI85UknghQOhoWHtJld43E1F0=;
	b=ZT1acU0nr0skJzztLZ98CP0T6xLG3BSaB/i0uYumh/Jv7vAxZxxVlTTIRjWgVdSKotaaJt
	3YJQULIkjFGO4QDsgzn3a6e9HJAJVMW8nuQkdDLbIgxlqF0zo6XZvmvjI0FxCbs/Y7ayoo
	azol/5Qs2fW+VJVYDgSmwZPti5qdGQo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Kl1YzAVp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794800692;
	b=IdirP5B8beFpnbHrfnz3n5XHlI7UznVDU5blFSt1cvIaUu5gGKptH7Sp6YBcisxniY/xpS
	cmqyUDSFt4MbULazDDqEX1DL0oLI/nFDyaIDvw+aBUanL4AD5Q3ZswJnPwu+A/J5+yJ1Eu
	RI03vF/9NE+LpJKxnrccqyJiHNNTNag=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794800687; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1ZQTmnkOlTIQcpFlUhpI85UknghQOhoWHtJld43E1F0=;
	b=Kl1YzAVpD+9SZbdmzvS15sXtfFpOB4DXYh8iFZccOIG0snCskrtw96qWCSIfgHlOuLzdRXixQHV+KWxXCI6yyvFFLSnsJq0z5EkDq79AyC+wm2+zryW+WAB4SWY6X/o6+VbmSwViwQfjBlcJLiydTgUVw9RvuW56g37IEBV3sYc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XElOevH_1794800685;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XElOevH_1794800685 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Nov 2026 11:44:46 +0800
Message-ID: <d1856861-62d7-4bc0-a8b7-39ccfc064f34@linux.alibaba.com>
Date: Mon, 16 Nov 2026 11:44:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <16bb1a14-04f4-4524-9882-20d452175a3d@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <16bb1a14-04f4-4524-9882-20d452175a3d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 929A9100002
X-Stat-Signature: 3pik1cuijstcdrfo9ph8kud1k7c47zf7
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794800690-629715
X-HE-Meta: U2FsdGVkX1/05neCmU4BC5fS5/223OL2Rc2NprCvDn6tMeeV6VFUvnPySe53lOOqNAY3EXQrIrbHuQbXOMOf36BeDvHJ3w3ScK3BVmoPlDI9q4l2V5n+7PXiigA7kCQOkEBeUMqmRNKS6CNraPFIIxHXBgf42F91/YaDSlRPIiYEn6bKuYJv4rfJbA7qn6WClfsQC6QvZA7M3878hYGy1lao1yFvTmF/8llSeh7bAKkckF9isiC8VF15nd3Dxlv2vln7eTOjrRwXOeKvDyuszKjI3BT6/3V/6f8l/wBLuKr99Xi4M8onXo32MAKSTzUtadAt7LPenZNiRbQ4ditkvhfq5t5R2H1UmhMqudSAdBbr4HFcsozBXnLMgCXTIAsBn4QS546WIk+hjayHH12Xa6NLrQj9vMfg7roT3mvZt4lelGXpXsLvn2Ju5dd0JFZzWpkWYpo9QBKQpN3m2QrgmJlqtp+ZCuKEY3VWPFggxsKH/uv/Mg5MbnycpMc+QkntE7QXtXbbRYyXkTC3g1EN5AfdnLAtrVkJOb4hL64pZwEIiQwLQUFHJAve2cI8g5BI66YHDMk9/vpJYEd8H9u5TYBTCwEzo0HzQPRS6AVIGtlerZVu2KocRSSqXbpkqrD7Nx4IUnNdMQOMgLFY3TCSWBd1RKk8hu++MNFTMpub+LobJQJuNi2HtyT/sZdlFd1hSl+WfROQs3L8iU5mgh2+72v/MpQVkDzKwBPn5m2/coAThfWGqqaoH78aDZLyMJLdxvuwKxlzpw5sQmSON0QwIk5lDFGsH1HP53obSk2iOwWYb6xHiLyvLSteBLfvttLh4Yr5it7M1/jYjno0kdlQxDuwHPY6KPyPta5mb1WjpzHP7nryedpasN+cCPFz6pMPSSiXHHLu0ScdHt5UD9q8WaWQA9tRji3jjsxlRz+B/Cygzr80gbiO36AH1XXXmOMy9B2JY+1m0z/jTUgt94O
 ctG5or1j
 74xWd+alWiq7lsL5smf5EfUtSeTJYvoI+5blhXrJ07csQetYaA74TZOsDKtMwStRdfjhk4VTTaQBSWGOVOiW88YvYoJfMPJ8AWBVHHsu/c+ArVRIotNtJIufEDv5mNth2qV3Jpzr85E56qUtAqgQrOQHqEwDNjuXFnzBtk2ucPZx51xGyMP2B8fnZZ5i3SVxZGLzWYImbHkaEDcedKOqHdTLIXm74mIxWwGbyKhMcl+fmDgf3XGEShjb+uUZ1y1YmsNFu+EtwbPrPRZXGPmKGgd1v01mPbVlqfQiffSTGKoQHYc2ICSOLxN9rRsm/9Oh0+1goBOVruiJ3E2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/14/26 1:39 AM, David Hildenbrand (Arm) wrote:
> On 11/5/26 03:56, Baolin Wang wrote:
>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>> with concurrent page table reclamation via zap_empty_pte_table().
>>
>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>> and try_to_migrate(), the other callers do not perform post-walk accounting
>> checks, so the race has no observable impact on them.
>>
>> For migration, the race can cause unnecessary retries. For reclaim via
>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>> fact already unmapped (as shown below), which may lead to unexpected OOM
>> or increased refaults.
>>
>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>> --------------------------------    --------------------------------
>> folio_lock(F)
>> try_to_unmap(F, TTU_SYNC)
>>                                      zap_pte_range(full PMD range)
>>                                        spin_lock(ptl)
>>                                        clear PTEs
>>                                        zap_empty_pte_table()
>>                                          spin_trylock(pml)
>>                                          pmd_clear()
>>                                          spin_unlock(pml)
>>
>>    page_vma_mapped_walk()
>>      observe !pmd_present(pmde)
>>      nr_pages < HPAGE_PMD_NR
>>      skip synchronization
>>      return false
>>
>> try_to_unmap() returns
>> folio_mapped(F) == true
>> nr_unmap_fail += folio_nr_pages(F)
>>                                      tlb_flush_mmu_tlbonly()
>>                                      tlb_flush_rmaps()
>>                                        remove F's rmaps
>>                                      spin_unlock(ptl)
>>
>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>> issues on weakly ordered CPUs.
>>
>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>> Cc: stable@vger.kernel.org
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/page_vma_mapped.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index e6b6170c2f4f..8797467b6f0c 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>   			spin_unlock(pvmw->ptl);
>>   			pvmw->ptl = NULL;
>>   		} else if (!pmd_present(pmde)) {
>> -			if ((pvmw->flags & PVMW_SYNC) &&
>> -			    thp_vma_suitable_order(vma, pvmw->address,
>> -						   PMD_ORDER) &&
>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> +			if (pvmw->flags & PVMW_SYNC)
>>   				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>   
>>   			goto next_pmd;
> 
> Baolin, how to proceed with that? Are you intending a resend? Including some of
> the performance impact and ways forward to optimize?

I hope we can merge this fix first if no other objections. As I replied 
to Barry, whether to set TTU_SYNC for small folios should be done in a 
separate patch (this is a pre-existing issue) with proper measurement 
(though it may be hard to measure the actual impact). What do you think?

