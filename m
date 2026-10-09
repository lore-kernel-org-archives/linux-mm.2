Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A26CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 10:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DBE06B0093; Fri,  9 Oct 2026 06:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3746B0095; Fri,  9 Oct 2026 06:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0D76B0096; Fri,  9 Oct 2026 06:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19E4C6B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:14:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99A24120314
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:14:11 +0000 (UTC)
X-FDA: 85302677502.25.168CF36
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1561D1A0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:14:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=byaqqJyX;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791540849;
	b=xutMNoMqSMEJKD9ycb98bq7QJ3nXNt5qKB8ZU5r4C83EtqV7hKJo/lyA4N7UzryR20EAF6
	A/P7YFfdSfMymz282Y2OFeQM2DhqzTBEQ8dVvdKOLFlyZWijI0lWOniX6mKL1GoHskJ/qh
	+J7vqzs5AstBApLcUPdaHOp+7GVY7Z4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=byaqqJyX;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791540849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mu/ZQABM8qhqcMl44qsHwngC77x8JwfLP3WIFCwDal8=;
	b=iSuVnCVZf/xhd2jyWm11fACeA7+65HSoDudFyglhOPoYPlDNrGCdRQaJ8BxcqSWT5MuRzS
	rQWWxwjbAYPWfB7sxQ49tFIONeKzbUBWExqsKnJ1NoBaOI/mndcOzhq6mzWjQN8PsVt1WJ
	JBbLRZEOxrmLZy87LSvK44fY+FoxKec=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791540845; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=Mu/ZQABM8qhqcMl44qsHwngC77x8JwfLP3WIFCwDal8=;
	b=byaqqJyX2qUr863wX7TDc5QUNiBw1GRY3Yw26kLEldx6Js/Srvq+nnJPG/qKTLXGfEyYur+NN3wkD+3C1FycmjhRx8sApLt4PXYXPLHEO7DmedfQoiRqW3JHP/BEPTUBuctrBjdo4tE+bXoj7d3n5kIABXTtgTsL5LYZLxhN0kg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XCT5rY._1791540843;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCT5rY._1791540843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 18:14:04 +0800
Message-ID: <639389d5-5048-4145-bcbf-c4b2d57e86e8@linux.alibaba.com>
Date: Fri, 9 Oct 2026 18:14:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Ayush Ranjan <ayushr@modal.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>,
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
 <20260925053027.1998394-1-ayushr@modal.com>
 <20260925065013.3682431-1-ayushr@modal.com>
 <20261003033107.1488699-1-ayushr@modal.com>
 <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
 <fyswoh7wpxzlbnjjanggjd2jz6yispmeirhwjl3wzi57nacddb@bjkb6kxyfcal>
 <fbb046b9-be48-42d8-96b3-7e554484b625@linux.alibaba.com>
 <asigKktcrSY80A_2@pedro-suse.tail5790ac.ts.net>
 <5ebaba53-b2de-490e-a14c-c49bbb4337ad@linux.alibaba.com>
In-Reply-To: <5ebaba53-b2de-490e-a14c-c49bbb4337ad@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1561D1A0002
X-Rspam-User: 
X-Stat-Signature: fs4fy6gokw1djw6kozhhd63odargpcm8
X-HE-Tag: 1791540847-800826
X-HE-Meta: U2FsdGVkX1934wTuISenL3Kmk3pKCHg5/UvWRHPIPU0jLWJz8B2mh80Nc0xOc4NfzweNUnVA1QSjvSkfWmHqwBwkOap2gddc8sJxZ8BPzZbYTciKwxhEjxM88lCDkMWou3kJsnIV3SkVVaVjJLjE3H1W2AQwpXGYVECurprGAJu2WqQQMzLuXZMSMNKoboLpDyBJ/UUm+P+S063GTaONeT/SsYB4PvyLoP46xzc23kLWRzQmiqQkOQmNIxuYY7m5qdXbPTNnnU8wbuuydxoqBS0Pyox1eP6/srFDmNt8zeWmzB5SK+R/Zgh5fvZU5DlwSg8neTnd/OEYgMVIzWCQdRlvH0LVaGDECqjlaGeRTyM4JrtNEJkSlP3Z7MQFOekPgTEFGZhCmLxz6cQq6BmPPBpH9LuPnnKgTNZp2iUpfF3Ebk/YN/Fah3RVUBafRXTq/ECrgkHpeYaHYMbWTLHfGVp9ByhVPQ0KFXdOQdkzCzt8M6nCayCzsNo6hRcuzKsuCWM7ZKNeBnTHSaI5coAnOSwFzc4zRwlla/9fvVh6BlXifAg0MasZ/8uucfPjOlh10kG0QoOoR2fm8FHEhn9kNMTV6+lB8dL/a5T8ePSJRrnQrsKClZiBpG/L71ukijbGzwicYWzSgKDjZwYD0auXwuEeY6tyWVy6J1wO12F6ThuLJe+/Yj+STHYIO1xW2NnOp3eF9yinwXDYzlLG3ETDvUo9spo7Cgg4q4TipMdHmu1yDZlitAH9NuUUO9ZikOG93ALzmARRP6F2UIm0VA/+nPqjRsRJueoWoj0ePO72Pl3o+FatmopplpZ5FkXHwOBRx1C9hUI98hlDfxL3o8TV4uZtr1opFwQYXEXMLVak8Y3oshHNgCnE3H0wPNNFyQ2UWws9a89e6FoYuxCDatNS+FAkJYuOn/vVRg1ZfFqMkCvgyOlO1zhEad80IcYiox4QquWIe4gbg19Qh59Y3Ni
 A3Syrqj7
 PjPejojs3mfIB6JH7Gv+WtuKj9Mil72JKRyAlRg6tkZB78j4vwJrxs/X26/LgxYDxqbZXJodMP2ViCOkwwKN16KNHb5DKNPJhq1gv9D7uXOOT3z0CJAm975nP6gFCuSByZX10N7dk3yyOok5OMzU+lapukawkulWGPTEHzPKsrEeGajNmwFZRb2B0XuM/6qzBw+YarJZbKPK7CZjtqEGRvTpGCI5SuORV6P61FMghZJgDmYHrCdcuW6ie6HnoAk2+0aaynY/jjwKOkdc4gjlbsnjGjZnaTIWt9QmphmPHeLelzVtFsM/ZlOzC7oFtGS7QUKGRn4Td4ejbp6ckx/vmkRU+8V79ymq/4RPiZugIn9SwQLtg4AwnH+FrtVj/6RHRP8o5iJpVy+McWqC0TYHHsLEALRc+cGb2TgRdOMWsAVrrGeW0qvBgqK6cnOChxlFzuVn8C5/pfkjJdJEp7hTkak7gqe0yy4vNTC0PRAbzwrHZuXZDl4e7/oZ2hFyARU4agj8fZIJePiCX38g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 5:20 PM, Baolin Wang wrote:
> 
> 
> On 10/9/26 4:41 PM, Pedro Falcato wrote:
>> On Fri, Oct 09, 2026 at 02:46:18PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 10/8/26 5:24 PM, Jan Kara wrote:
>>>> On Sun 04-10-26 22:28:31, Andrew Morton wrote:
>>>>> On Sat,  3 Oct 2026 03:31:03 +0000 Ayush Ranjan <ayushr@modal.com> 
>>>>> wrote:
>>>>>> Gentle ping on this. The reproducer in my previous mail [1] triggers
>>>>>> "Bad page cache ... still mapped when deleted" on 6.18.46 within a
>>>>>> couple of minutes on a 128-CPU bare-metal box, with no fork() and no
>>>>>> gVisor involved.
>>>>>>
>>>>>> We continue to hit this in production at low frequency, so I am happy
>>>>>> to test patches or collect more data if that would help.
>>>>>>
>>>>>
>>>>> fwiw I made gpt and gemini argue about this for a while and ended up
>>>>> with the below.
>>>>
>>>> Worth a try I guess. Let's see :)
>>>>
>>>>> From: Andrew Morton <akpm@linux-foundation.org>
>>>>> Subject: mm: shmem: serialize fault-around against hole punching
>>>>> Date: Sun Oct 4 09:05:31 PM PDT 2026
>>>>>
>>>>> shmem uses filemap_map_pages() for fault-around.  Unlike 
>>>>> shmem_fault(),
>>>>> filemap_map_pages() does not participate in shmem's fallocate 
>>>>> exclusion
>>>>> protocol.
>>>>>
>>>>> During a partial hole punch of a large shmem folio, the folio can 
>>>>> be split
>>>>> and the resulting smaller folios can remain temporarily visible in 
>>>>> the page
>>>>> cache while shmem_undo_range() restarts its walk.  Fault-around can 
>>>>> then map
>>>>> one of those folios again before the hole-punch path removes it.
>>>>>
>>>>> shmem_undo_range() may subsequently delete that folio from the page 
>>>>> cache
>>>>> despite the new userspace mapping.  This can trigger "still mapped 
>>>>> when
>>>>> deleted" warnings and leave stale mappings or inconsistent RSS/ 
>>>>> page-table
>>>>> accounting behind.
>>>>
>>>> So this part of explanation is either incomplete or wrong in my 
>>>> opinion.
>>>> Yes, shmem_undo_range() calls truncate_inode_partial_folio() which can
>>>> split a large folio. Yes, filemap_map_pages() can map those pages 
>>>> back into
>>>> page tables. But how "shmem_undo_range() may subsequently delete 
>>>> that folio
>>>> from the page cache despite the new userspace mapping" happens is 
>>>> unclear
>>>> to me. After splitting a folio, shmem_undo_range() will restart and 
>>>> find the
>>>> newly split (and mapped) folios and calls truncate_inode_folio() to 
>>>> get rid
>>>> of them. Now truncate_inode_folio() calls truncate_cleanup_folio() 
>>>> which
>>>> does:
>>>>
>>>>           if (folio_mapped(folio))
>>>>                   unmap_mapping_folio(folio);
>>>>
>>>> so the mapping is reliably removed under folio lock. Can you perhaps 
>>>> push
>>>> your agents further to explain in more detail how this "still mapped 
>>>> when
>>>> deleted" happens in their opinion?
>>>
>>> Good point and I think you are right.
>>>
>>> Yesterday I quickly reproduced the issue with Ayush's reproducer, and 
>>> I got
>>> the following crash info. From the dump message, we can see that
>>> truncate_inode_folio() is really trying to remove mapped folios, 
>>> which is
>>> incorrect.
>>>
>>> I also quickly tried Andrew's patch, and the issue no longer 
>>> reproduces, so
>>> I initially thought that was the root cause. But after your reminder, 
>>> I now
>>> believe Andrew's patch merely workaround the issue rather than fixing 
>>> the
>>> actual root cause.
>>>
>>> Today I'm going to re-analyze the race with the reproducer (thanks 
>>> Ayush).
>>>
>>> After analysis, I believe the race exists between truncation and
>>> MADV_DONTNEED, and shmem's fault_around() merely makes the issue 
>>> easier to
>>> reproduce. Since MADV_DONTNEED synchronously releases the pagetable page
>>> before calling tlb_flush_rmaps(), this could cause another thread's
>>> truncation to skip zap_pte_range() but still observe the folio's 
>>> mapcount as
>>> non-zero. A possible race scenario is as follows:
>>>
>>> CPU 0                CPU 1
>>>                 madvise_dontneed_single_vma
>>> shmem_fallocate            ......
>>>    ......              zap_pte_range
>>>    truncate_inode_folio            zap_empty_pte_table(pmd clear)
>>>      unmap_mapping_folio
>>>      ......
>>>        zap_pmd_range(saw pmd none)
>>>      filemap_remove_folio
>>>         BUG_ON(folio_mapped)
>>>                     tlb_flush_rmaps
>>
>> Thanks for the investigation!
>>
>> So, I think I understand the problem (rmap walks race PTE zapping, 
>> which no
>> longer serializes on the PTE lock), but I don't understand your 
>> solution at
>> all.
>>>
>>> Based on the above race analysis, I made the following fix that uses 
>>> the PMD
>>> lock synchronously to prevent this race, and the issue no longer 
>>> reproduces.
>>> I will clean it up and send out a formal patch.
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 6a8e7772b8d6..2039ada99b64 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct 
>>> mmu_gather
>>> *tlb,
>>>                  }
>>>          } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>>>
>>> +       add_mm_rss_vec(mm, rss);
>>> +       lazy_mmu_mode_disable();
>>> +
>>> +       /* Do the actual TLB flush before dropping ptl */
>>> +       if (force_flush) {
>>> +               tlb_flush_mmu_tlbonly(tlb);
>>> +               tlb_flush_rmaps(tlb, vma);
>>> +       }
>>> +
>>>          /*
>>>           * Fast path: try to hold the pmd lock and unmap the PTE page.
>>>           *
>>> @@ -2046,15 +2055,6 @@ static unsigned long zap_pte_range(struct 
>>> mmu_gather
>>> *tlb,
>>>           */
>>>          if (can_reclaim_pt && direct_reclaim && addr == end)
>>>                  direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, 
>>> &pmdval);
>>> -
>>> -       add_mm_rss_vec(mm, rss);
>>> -       lazy_mmu_mode_disable();
>>> -
>>> -       /* Do the actual TLB flush before dropping ptl */
>>> -       if (force_flush) {
>>> -               tlb_flush_mmu_tlbonly(tlb);
>>> -               tlb_flush_rmaps(tlb, vma);
>>> -       }
>>>          pte_unmap_unlock(start_pte, ptl);
>>
>> Namely, why moving this hunk of code up there makes any difference.
>> I suppose it's subtly changing memory order, but it's not immediate
>> in any way why this is correct.
>>
>> What you really need (I think) is a happens-before relationship between
>> the rmap changes and the PMD zapping. Something like:
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 330cde31bf8b..17cdd48fff27 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2108,6 +2108,13 @@ static inline unsigned long 
>> zap_pmd_range(struct mmu_gather *tlb,
>>                          sync_with_folio_pmd_zap(tlb->mm, pmd);
>>                  }
>>                  if (pmd_none(*pmd)) {
>> +                       /*
>> +                        * Pairs with tlb_flush_rmaps() in PTE zapping.
>> +                        * Possibly skipping a page table (due to PTE 
>> zapping)
>> +                        * needs to enforce ordering between the rmap 
>> changes
>> +                        * and the PMD getting cleared.
>> +                        */
>> +                       smp_rmb();
>>                          addr = next;
>>                          continue;
>>                  }
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 9f353f0e2ef4..47b25c42bf77 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -89,6 +89,10 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct 
>> vm_area_struct *vma)
>>          tlb_flush_rmap_batch(&tlb->local, vma);
>>          if (tlb->active != &tlb->local)
>>                  tlb_flush_rmap_batch(tlb->active, vma);
>> +       /*
>> +        * rmap changes need to be observed before e.g PTEs get zapped.
>> +        */
>> +       smp_wmb();
>>          tlb->delayed_rmap = 0;
>>   }
>>   #endif
>>
>> On top of your diff. Where the smp_wmb() is perhaps not required: I 
>> suppose TLB flushing
>> works as a sort of memory barrier itself on most/all architectures.
>> Either way, we have to document and fix expectations around this code.
> 
> Agree, I don't think we need smp_wmb() here. Moreover, 
> zap_empty_pte_table() will call the pmd lock/unlock, which already 
> indicates a memory barrier.

After more thinking, I think we still need an smp_wmb(). Please review 
my new fix patch. Thanks.

https://lore.kernel.org/all/0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com/

