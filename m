Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F175CA5FFB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0947E6B0124; Mon, 19 Jan 2026 02:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0756A6B0125; Mon, 19 Jan 2026 02:22:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4146B0126; Mon, 19 Jan 2026 02:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC9006B0124
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:22:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D48216064E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:22:37 +0000 (UTC)
X-FDA: 84347870754.11.D990A75
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6C017C0008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:22:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lJgG6z57;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768807355; a=rsa-sha256;
	cv=none;
	b=A0vyODVnVlJTRwE1d9QbiM/cf7hwuN5kIaKyTheStMqfRFBAolY5pgHjiarztl6hDtbXFE
	1QNBVSDSdkAPA2b2UqcfeY0JSmapGBUxCbfYB59WVUzIxHo3ck8yG5dbWw7GsS29KonFWN
	cxm83nXfDmfTL8Vze1LxrZJIx7Flc18=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lJgG6z57;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768807355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXPU57WcR75YcJ/pW45lwH9A6f/k0LxYXK/jf1YSvq8=;
	b=sPZkTue5Nm73Zpo/RKoLcr6vSGWzpccXIhSD4KVPb4zpfhQ4wizP/1J32Hynqf2ViauWxD
	9Mz5Z+afE8GRH/DLHCiUBAsniA7MjQ1EjdOhbn0ZRMsaSgXmquslUfsqvxUehczNEV+Ena
	3X9EKL+Q68xoXG1K2q/qb2I+SO5WF7Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768807349; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JXPU57WcR75YcJ/pW45lwH9A6f/k0LxYXK/jf1YSvq8=;
	b=lJgG6z577W3VL5HScOUSqqxAgWagWnaIXVSZQYsqmBarf87NjNuO4i9fHuWO9kgagAg9BS54OTVzVt49rmL+i/B7R54J4guLAjnk89QmZwJ9HLwGfKAY7ilX2X6PeiiY3AyHzUl0gOt68+sjNo+ZfRam0hWRUxfp6cTvyd8prp8=
Received: from 30.74.144.151(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxJbKuv_1768807346 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 19 Jan 2026 15:22:27 +0800
Message-ID: <3bddd08d-ab25-4aea-a863-353cf143798e@linux.alibaba.com>
Date: Mon, 19 Jan 2026 15:22:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Dev Jain <dev.jain@arm.com>, Barry Song <21cnbao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master>
 <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master>
 <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
 <CAGsJ_4yo-EE__1VzHqxE8ehDOFQuxqP9GXcskkeZ-WTTyz12_A@mail.gmail.com>
 <ccce0551-489a-4612-ab5d-2dd8a5cae66c@arm.com>
 <29634bee-18c6-42c2-ac7f-703d4dfed867@linux.alibaba.com>
 <6ed22a34-ce8a-4531-9776-b28e1a942450@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <6ed22a34-ce8a-4531-9776-b28e1a942450@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: osakgd9exqr7q3au46if3fmdbk7xhrm4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C017C0008
X-Rspam-User: 
X-HE-Tag: 1768807354-593479
X-HE-Meta: U2FsdGVkX1+/98cKQRsPYlcOPVfUmJXSXJxGHUWF+tLpG+NraquQxk8TTknfl96bKWWQNWnLoy3RM13L2By2W1oorxHzY2obJY/BJPZRBCqsBoA31AMB8AKg7g6/Pw/Xexv2BMxUzAdUMsrRH7qGirI6Qxf/D2gzOq73Gpy7ZWpd+FTmEKH3GoIDwpx/5Gziapr3vBngax0MpMQ3Np1Pd8rD1bWNqXm5JguNHeQG9uM5vMtZ4VaugykEfqyrnZbnaT0cpRmksq69sV5SqrcKbGA1EQN+Ksr9GrH4Niu2Y/AuEQ2z2KjjVwe8d4hlAioh9Wv4YDg2nvOiQXSoCEi/wLAHerjxlwBDcxl1QT/07CjlL9fCHS2NeRLpRNtckge/TVJROuFU9/yJ2gNMY6mpXyY/Q60W7SPwfd4MGy3CLW6BvXc74mxGOn2NaAmvq497Mrrpmo5RE+8e6a7slpEhFKJx68w7pT3kFyCXYFHG7U3WTYXyeAVA1K7VZUQehHKbJ7ahqQmsUJxnhXj57dugQtKNPaxKDPjh0DvrObqKKNDh7/dJndUJ/i2jdbAfXCVmmQ6DQ92ZqG/F7136zw4klml8Hg5e+p0xceDfKIYMOMHLPgWdSy+L4ruk5nyBQMe3GMAMgWaHa3WVE1ftibJFdEleU15PcYy0JssbNmqn81AYBBTZYGHEFZIKVYfbeKJU/h3IEMA2P+Di2tC2pMHMIuG0z2vGHVM46b/YzwNWWFE0F436P4Bq0iuPDDu7jvu+6NAPZPLxDrvFjVIdVzGeDLzYGWkdc2qeuncY3WKVMRUlgSooQ9o5o1mXotGWmJ4I0gvCPmSRSTPqgTsMPM33rx1bTLcnoT8j0WZsLXYY+VGCsqnm+UJWgJ70DgSV6pboesSNCb3NZ67p7U+FWQjZTXj+al8xrRC7aTulBVjrY9t7IdtjoQU0E0HY+nJHEovYXdnDV42xHYsm0I+rgSy
 HOFfOqs6
 Bl6W3gfwEo8Q4UlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/19/26 2:36 PM, Dev Jain wrote:
> 
> On 19/01/26 11:20 am, Baolin Wang wrote:
>>
>>
>> On 1/18/26 1:46 PM, Dev Jain wrote:
>>>
>>> On 16/01/26 7:58 pm, Barry Song wrote:
>>>> On Fri, Jan 16, 2026 at 5:53 PM Dev Jain <dev.jain@arm.com> wrote:
>>>>>
>>>>> On 07/01/26 7:16 am, Wei Yang wrote:
>>>>>> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>>>>>>> On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com>
>>>>>>> wrote:
>>>>>>>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>>>>>>>>> Similar to folio_referenced_one(), we can apply batched unmapping
>>>>>>>>> for file
>>>>>>>>> large folios to optimize the performance of file folios reclamation.
>>>>>>>>>
>>>>>>>>> Barry previously implemented batched unmapping for lazyfree
>>>>>>>>> anonymous large
>>>>>>>>> folios[1] and did not further optimize anonymous large folios or
>>>>>>>>> file-backed
>>>>>>>>> large folios at that stage. As for file-backed large folios, the
>>>>>>>>> batched
>>>>>>>>> unmapping support is relatively straightforward, as we only need
>>>>>>>>> to clear
>>>>>>>>> the consecutive (present) PTE entries for file-backed large folios.
>>>>>>>>>
>>>>>>>>> Performance testing:
>>>>>>>>> Allocate 10G clean file-backed folios by mmap() in a memory
>>>>>>>>> cgroup, and try to
>>>>>>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I
>>>>>>>>> can observe
>>>>>>>>> 75% performance improvement on my Arm64 32-core server (and 50%+
>>>>>>>>> improvement
>>>>>>>>> on my X86 machine) with this patch.
>>>>>>>>>
>>>>>>>>> W/o patch:
>>>>>>>>> real    0m1.018s
>>>>>>>>> user    0m0.000s
>>>>>>>>> sys     0m1.018s
>>>>>>>>>
>>>>>>>>> W/ patch:
>>>>>>>>> real   0m0.249s
>>>>>>>>> user   0m0.000s
>>>>>>>>> sys    0m0.249s
>>>>>>>>>
>>>>>>>>> [1]
>>>>>>>>> https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>>>>>>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>> Acked-by: Barry Song <baohua@kernel.org>
>>>>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>> ---
>>>>>>>>> mm/rmap.c | 7 ++++---
>>>>>>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>>>> index 985ab0b085ba..e1d16003c514 100644
>>>>>>>>> --- a/mm/rmap.c
>>>>>>>>> +++ b/mm/rmap.c
>>>>>>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int
>>>>>>>>> folio_unmap_pte_batch(struct folio *folio,
>>>>>>>>>         end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>>>>>         max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>>>>>
>>>>>>>>> -      /* We only support lazyfree batching for now ... */
>>>>>>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>>>>>> +      /* We only support lazyfree or file folios batching for now
>>>>>>>>> ... */
>>>>>>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>>>>>                 return 1;
>>>>>>>>> +
>>>>>>>>>         if (pte_unused(pte))
>>>>>>>>>                 return 1;
>>>>>>>>>
>>>>>>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio
>>>>>>>>> *folio, struct vm_area_struct *vma,
>>>>>>>>>                          *
>>>>>>>>>                          * See Documentation/mm/mmu_notifier.rst
>>>>>>>>>                          */
>>>>>>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>>>>>>> +                      add_mm_counter(mm, mm_counter_file(folio),
>>>>>>>>> -nr_pages);
>>>>>>>>>                 }
>>>>>>>>> discard:
>>>>>>>>>                 if (unlikely(folio_test_hugetlb(folio))) {
>>>>>>>>> -- 
>>>>>>>>> 2.47.3
>>>>>>>>>
>>>>>>>> Hi, Baolin
>>>>>>>>
>>>>>>>> When reading your patch, I come up one small question.
>>>>>>>>
>>>>>>>> Current try_to_unmap_one() has following structure:
>>>>>>>>
>>>>>>>>       try_to_unmap_one()
>>>>>>>>           while (page_vma_mapped_walk(&pvmw)) {
>>>>>>>>               nr_pages = folio_unmap_pte_batch()
>>>>>>>>
>>>>>>>>               if (nr_pages = folio_nr_pages(folio))
>>>>>>>>                   goto walk_done;
>>>>>>>>           }
>>>>>>>>
>>>>>>>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>>>>>>>
>>>>>>>> If my understanding is correct, page_vma_mapped_walk() would start
>>>>>>>> from
>>>>>>>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already
>>>>>>>> cleared to
>>>>>>>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>>>>>>>
>>>>>>>> Not sure my understanding is correct, if so do we have some reason
>>>>>>>> not to
>>>>>>>> skip the cleared range?
>>>>>>> I don’t quite understand your question. For nr_pages > 1 but not equal
>>>>>>> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs
>>>>>>> inside.
>>>>>>>
>>>>>>> take a look:
>>>>>>>
>>>>>>> next_pte:
>>>>>>>                  do {
>>>>>>>                          pvmw->address += PAGE_SIZE;
>>>>>>>                          if (pvmw->address >= end)
>>>>>>>                                  return not_found(pvmw);
>>>>>>>                          /* Did we cross page table boundary? */
>>>>>>>                          if ((pvmw->address & (PMD_SIZE - PAGE_SIZE))
>>>>>>> == 0) {
>>>>>>>                                  if (pvmw->ptl) {
>>>>>>>                                          spin_unlock(pvmw->ptl);
>>>>>>>                                          pvmw->ptl = NULL;
>>>>>>>                                  }
>>>>>>>                                  pte_unmap(pvmw->pte);
>>>>>>>                                  pvmw->pte = NULL;
>>>>>>>                                  pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>>>>>>                                  goto restart;
>>>>>>>                          }
>>>>>>>                          pvmw->pte++;
>>>>>>>                  } while (pte_none(ptep_get(pvmw->pte)));
>>>>>>>
>>>>>> Yes, we do it in page_vma_mapped_walk() now. Since they are
>>>>>> pte_none(), they
>>>>>> will be skipped.
>>>>>>
>>>>>> I mean maybe we can skip it in try_to_unmap_one(), for example:
>>>>>>
>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>> index 9e5bd4834481..ea1afec7c802 100644
>>>>>> --- a/mm/rmap.c
>>>>>> +++ b/mm/rmap.c
>>>>>> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio
>>>>>> *folio, struct vm_area_struct *vma,
>>>>>>                  */
>>>>>>                 if (nr_pages == folio_nr_pages(folio))
>>>>>>                         goto walk_done;
>>>>>> +             else {
>>>>>> +                     pvmw.address += PAGE_SIZE * (nr_pages - 1);
>>>>>> +                     pvmw.pte += nr_pages - 1;
>>>>>> +             }
>>>>>>                 continue;
>>>>>>    walk_abort:
>>>>>>                 ret = false;
>>>>> I am of the opinion that we should do something like this. In the
>>>>> internal pvmw code,
>>>> I am still not convinced that skipping PTEs in try_to_unmap_one()
>>>> is the right place. If we really want to skip certain PTEs early,
>>>> should we instead hint page_vma_mapped_walk()? That said, I don't
>>>> see much value in doing so, since in most cases nr is either 1 or
>>>> folio_nr_pages(folio).
>>>>
>>>>> we keep skipping ptes till the ptes are none. With my proposed
>>>>> uffd-fix [1], if the old
>>>>> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert
>>>>> all ptes from none
>>>>> to not none, and we will lose the batching effect. I also plan to
>>>>> extend support to
>>>>> anonymous folios (therefore generalizing for all types of memory)
>>>>> which will set a
>>>>> batch of ptes as swap, and the internal pvmw code won't be able to
>>>>> skip through the
>>>>> batch.
>>>> Thanks for catching this, Dev. I already filter out some of the more
>>>> complex cases, for example:
>>>> if (pte_unused(pte))
>>>>           return 1;
>>>>
>>>> Since the userfaultfd write-protection case is also a corner case,
>>>> could we filter it out as well?
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index c86f1135222b..6bb8ba6f046e 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -1870,6 +1870,9 @@ static inline unsigned int
>>>> folio_unmap_pte_batch(struct folio *folio,
>>>>           if (pte_unused(pte))
>>>>                   return 1;
>>>>
>>>> +       if (userfaultfd_wp(vma))
>>>> +               return 1;
>>>> +
>>>>           return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>>>> }
>>>>
>>>> Just offering a second option — yours is probably better.
>>>
>>> No. This is not an edge case. This is a case which gets exposed by your
>>> work, and
>>> I believe that if you intend to get the file folio batching thingy in,
>>> then you
>>> need to fix the uffd stuff too.
>>
>> Barry’s point isn’t that this is an edge case. I think he means that uffd
>> is not a common performance-sensitive scenario in production. Also, we
>> typically fall back to per-page handling for uffd cases (see
>> finish_fault() and alloc_anon_folio()). So I perfer to follow Barry’s
>> suggestion and filter out the uffd cases until we have test case to show
>> performance improvement.
> 
> I am of the opinion that you are making the wrong analogy here. The
> per-page fault fidelity is *required* for uffd.
> 
> When you say you want to support file folio batched unmapping, I think it's
> inappropriate to say "let us refuse to
> 
> batch if the pte mapping the file folio is smeared with a particular bit
> and consider it a totally different case". Instead
> 
> of getting in folio (all memory types) batched unmapping in, we have
> already broken this to "lazyfree folio", then
> 
> "file folio", the remaining being "anon folio". Now you intend to break
> "file folio" to "file folio non uffd" and "file folio uffd".

At least for me, I think this is a reasonable approach: break a complex 
problem into smaller features and address them step by step (possibly by 
different contributors in the community). This makes it easier for 
reviewers to focus and discuss. You can see that batched unmapping for 
anonymous folios still has ongoing discussion.

As I mentioned, since uffd is not a common performance-sensitive 
scenario in production, we need to continue discussing whether we 
actually need to support batched unmapping for uffd, and support the 
decision with technical feedback and performance data. So I’d prefer to 
discuss it in a separate patch.

David and Lorenzo, what do you think?

