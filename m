Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB88EC982CD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DEDD6B0088; Fri, 16 Jan 2026 10:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8E26B009B; Fri, 16 Jan 2026 10:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AEED6B009E; Fri, 16 Jan 2026 10:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE466B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:49:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D428EC0946
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:49:21 +0000 (UTC)
X-FDA: 84338261322.14.32DD677
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30BF51C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:49:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u9OafwcF;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578560; a=rsa-sha256;
	cv=none;
	b=LflF6VDCvpOsTq6fm7qi5x1qbAAzSgwCOu/pcMi7SJ509bvV0K+7gtT259hLVqeI1QNRp3
	nY9kTDYoL1RXQU9e76tkYbHf2qrATsDHusqlndGrtWJ7BOSJKkYqQdMjOriBiSqrazmK2K
	P5iwgeb9J/lgZHyKGgSaemlJrS8iI8g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u9OafwcF;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHMLXqA9TxG65qWXMMsOEMcFl3LZezM4qnFGZY051ss=;
	b=5xRnzBowyZ5SPGDkTBRGU9YgXoTSqKG/s/hm31wvNoez9eTLykU70tpgg8osP6YNrGar3j
	aaEY3fQb+Rmu5sLZeSOHrvE2ZowHNzKTWo41JfDxzXD/jEiF4wRwDGe6GgfE78IY3byfp7
	oX8NITbyjQhORZuCyklfYTEQehAPTdA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768578555; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hHMLXqA9TxG65qWXMMsOEMcFl3LZezM4qnFGZY051ss=;
	b=u9OafwcFmwfCeqjCrjDNiOOx09dMPFnDSDYMvh5cgqF0MRidfYOQHsQcnmLRy1KTKFVhTlf4foS8zMLaVRoSKGdOBQRHqPhMtS0wKqngi83/YhPBk8CuOJeVY3qpAHHONUJkQQf5C+AxPo8cVzr1SPRhCyxBZaozJ6d3w6LQFaI=
Received: from 30.100.3.200(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxAeMbS_1768578550 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Jan 2026 23:49:13 +0800
Message-ID: <84214d4c-2898-462c-ad27-fee39502128a@linux.alibaba.com>
Date: Fri, 16 Jan 2026 23:49:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Barry Song <21cnbao@gmail.com>, Dev Jain <dev.jain@arm.com>
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4yo-EE__1VzHqxE8ehDOFQuxqP9GXcskkeZ-WTTyz12_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 30BF51C0005
X-Stat-Signature: d476mfjsregq1ue46xddbfa5jzfaaeqr
X-Rspam-User: 
X-HE-Tag: 1768578557-251951
X-HE-Meta: U2FsdGVkX1/xE06RF8JxEKacGfaq2iRd6DP1kbZnARCITH/q3DcpjN/Jc8jHnrsWBL7+LNvA34Bj62iNtG+KxgX0ZW+8qIFu90eTF/jmKHwmFbpOxy3RdtQ+VA8Cf9xo8Vub6F6GO2efyKxP+48lcBssANmexyziQljw0b1hLkg7xy06ElRMGEumU/Ft3/qsZSa6kBk3yEZi6cZwdolfQbxROxv2EqAsmkIBKbpQ2BV+iyFfm5gS9+yMWxk09ckgUBvBnnXjIz3CUdJKG6MjYR+vrigMtKng5+nrHas7gr9/OUWW6of4YBXh+Q+KP8TAfieA7Xfm3lrWYOIalLUG4WRni70IXAfByrIbS//pxTAJZvSxPunNMZqlvf8SEsL+ZtS052oDO+9UEdOGYiYBTdGvEXzmWpxsMrWqGuUgISr32WrGoOCGW1jO/cGfguxF7w/Jr8R5+TdpT0hr8pQ+WYwrW3tHzbP8dqz3Kb4WcjR2Ho+CHxd5dsINO3XxpovIRDmajEhPbuxcD7SMvYrk7fSvaVMw+6mHByZh+xFrCuDHmcjCBFq301wYiZe8oBjdAQzhpLRnbig+J/Pk9AvXtQthEGigfbyMAIzc7ioAkQKuhw6/eIs0R8IqZDcu6txwzh26M/WCOUObmFulEklF85dRLWrbErjzTWuEToX2y3eWVKkmFBNzLqqGw8gYqgZ5YSEhWX5Osc5iE47i4VuquZQ36SLF20AmAfHLrulidKzMzxAPaVmTSUHSCgs3Uc5jr5tFrgNjs9UN3+tU6jiksXaMn3CPE5aXBrebQCU7+9UNsNgWSU3DSMgd3xhi2nC+YfvOw1jK6gAmODwvtXHfHqsPhPq5qxjLfMwku0x74y0rbm28EgTz/wXKiT9d8BBqfBEGz7os55j+b6G5/3OTv9z+Vmjar0uIGYFiBbM0U+1eFkfD0+pigUfAnN/stuLV3kJc1XdyMfJL24QELw3
 vfnbZrYk
 mUectnqlOxohZiqJFsC/3bms5yFmwZDUTpVxgeU9E8Lz3zHqaUaQn4lsiiV7lH9Zq0IViVy9vTZwsGcvm3Y9Z9uCFIGuOewwUMjlC9aZpq0dgRTUZEhRFblhJGRla4EOlaXqbbbnjYyvM6nOOgzKp1/7632n+CqzX8D47mk2m2NWYrzvWBBVTZ6e7NLY5TxtiGNqRSc07OXjWky8IBhK3PkCSGOLf+odjo0erwteywxCrWNsdN/fyxg6BzLpBfHmNJM+jFgwomfbC2BCMhsyFd7XZPkx5LpKrsg6eWtB/4HhtmTNYusgWEs1PzzRKvGL3zMQLNWG97WvmHvSk5I59GlVgR2x1FtpDed5z5woKY/LjCHzLqD63DynbC2J831hhFX3aIJn0S+cXWXDwWJQu882AgFiqRLW4xvTb58Fdx4AeznzTLcNvi3hOM4GUB+LU7SVVCJTpgcT8iOT3HpeT1KktK6pgPXL0Yc/gzhLQ3IHW9weBwSQy7X0sVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/16/26 10:28 PM, Barry Song wrote:
> On Fri, Jan 16, 2026 at 5:53 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>> On 07/01/26 7:16 am, Wei Yang wrote:
>>> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>>>> On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>>>>>> Similar to folio_referenced_one(), we can apply batched unmapping for file
>>>>>> large folios to optimize the performance of file folios reclamation.
>>>>>>
>>>>>> Barry previously implemented batched unmapping for lazyfree anonymous large
>>>>>> folios[1] and did not further optimize anonymous large folios or file-backed
>>>>>> large folios at that stage. As for file-backed large folios, the batched
>>>>>> unmapping support is relatively straightforward, as we only need to clear
>>>>>> the consecutive (present) PTE entries for file-backed large folios.
>>>>>>
>>>>>> Performance testing:
>>>>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>>>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>>>>>> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>>>>>> on my X86 machine) with this patch.
>>>>>>
>>>>>> W/o patch:
>>>>>> real    0m1.018s
>>>>>> user    0m0.000s
>>>>>> sys     0m1.018s
>>>>>>
>>>>>> W/ patch:
>>>>>> real   0m0.249s
>>>>>> user   0m0.000s
>>>>>> sys    0m0.249s
>>>>>>
>>>>>> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>>>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>>> Acked-by: Barry Song <baohua@kernel.org>
>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> ---
>>>>>> mm/rmap.c | 7 ++++---
>>>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>> index 985ab0b085ba..e1d16003c514 100644
>>>>>> --- a/mm/rmap.c
>>>>>> +++ b/mm/rmap.c
>>>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>>>>        end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>>        max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>>
>>>>>> -      /* We only support lazyfree batching for now ... */
>>>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>>> +      /* We only support lazyfree or file folios batching for now ... */
>>>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>>                return 1;
>>>>>> +
>>>>>>        if (pte_unused(pte))
>>>>>>                return 1;
>>>>>>
>>>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>                         *
>>>>>>                         * See Documentation/mm/mmu_notifier.rst
>>>>>>                         */
>>>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>>>> +                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>>>>>>                }
>>>>>> discard:
>>>>>>                if (unlikely(folio_test_hugetlb(folio))) {
>>>>>> --
>>>>>> 2.47.3
>>>>>>
>>>>> Hi, Baolin
>>>>>
>>>>> When reading your patch, I come up one small question.
>>>>>
>>>>> Current try_to_unmap_one() has following structure:
>>>>>
>>>>>      try_to_unmap_one()
>>>>>          while (page_vma_mapped_walk(&pvmw)) {
>>>>>              nr_pages = folio_unmap_pte_batch()
>>>>>
>>>>>              if (nr_pages = folio_nr_pages(folio))
>>>>>                  goto walk_done;
>>>>>          }
>>>>>
>>>>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>>>>
>>>>> If my understanding is correct, page_vma_mapped_walk() would start from
>>>>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
>>>>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>>>>
>>>>> Not sure my understanding is correct, if so do we have some reason not to
>>>>> skip the cleared range?
>>>> I don’t quite understand your question. For nr_pages > 1 but not equal
>>>> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.
>>>>
>>>> take a look:
>>>>
>>>> next_pte:
>>>>                 do {
>>>>                         pvmw->address += PAGE_SIZE;
>>>>                         if (pvmw->address >= end)
>>>>                                 return not_found(pvmw);
>>>>                         /* Did we cross page table boundary? */
>>>>                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>>>>                                 if (pvmw->ptl) {
>>>>                                         spin_unlock(pvmw->ptl);
>>>>                                         pvmw->ptl = NULL;
>>>>                                 }
>>>>                                 pte_unmap(pvmw->pte);
>>>>                                 pvmw->pte = NULL;
>>>>                                 pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>>>                                 goto restart;
>>>>                         }
>>>>                         pvmw->pte++;
>>>>                 } while (pte_none(ptep_get(pvmw->pte)));
>>>>
>>> Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), they
>>> will be skipped.
>>>
>>> I mean maybe we can skip it in try_to_unmap_one(), for example:
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 9e5bd4834481..ea1afec7c802 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>                 */
>>>                if (nr_pages == folio_nr_pages(folio))
>>>                        goto walk_done;
>>> +             else {
>>> +                     pvmw.address += PAGE_SIZE * (nr_pages - 1);
>>> +                     pvmw.pte += nr_pages - 1;
>>> +             }
>>>                continue;
>>>   walk_abort:
>>>                ret = false;
>>
>> I am of the opinion that we should do something like this. In the internal pvmw code,
> 
> I am still not convinced that skipping PTEs in try_to_unmap_one()
> is the right place. If we really want to skip certain PTEs early,
> should we instead hint page_vma_mapped_walk()? That said, I don't
> see much value in doing so, since in most cases nr is either 1 or
> folio_nr_pages(folio).
> 
>> we keep skipping ptes till the ptes are none. With my proposed uffd-fix [1], if the old
>> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert all ptes from none
>> to not none, and we will lose the batching effect. I also plan to extend support to
>> anonymous folios (therefore generalizing for all types of memory) which will set a
>> batch of ptes as swap, and the internal pvmw code won't be able to skip through the
>> batch.
> 
> Thanks for catching this, Dev. I already filter out some of the more
> complex cases, for example:
> if (pte_unused(pte))
>          return 1;

Hi Dev, thanks for the report[1], and you also explained why mm-selftets 
can pass.

[1] 
https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/


> Since the userfaultfd write-protection case is also a corner case,
> could we filter it out as well?
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index c86f1135222b..6bb8ba6f046e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1870,6 +1870,9 @@ static inline unsigned int
> folio_unmap_pte_batch(struct folio *folio,
>          if (pte_unused(pte))
>                  return 1;
> 
> +       if (userfaultfd_wp(vma))
> +               return 1;
> +
>          return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> }

That small fix makes sense to me. I think Dev can continue to support 
the UFFD batch optimization, and we need more review and testing for the 
UFFD batched operations, as David suggested[2].

[2] 
https://lore.kernel.org/all/9edeeef1-5553-406b-8e56-30b11809eec5@kernel.org/

