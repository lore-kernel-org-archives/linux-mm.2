Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CCED4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 05:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8554C6B010A; Mon, 19 Jan 2026 00:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8D76B010B; Mon, 19 Jan 2026 00:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7054E6B010C; Mon, 19 Jan 2026 00:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE9A6B010A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:51:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D21B9140667
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:50:59 +0000 (UTC)
X-FDA: 84347639838.14.497C586
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf01.hostedemail.com (Postfix) with ESMTP id A3A6240009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:50:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Hba8xhsA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768801858; a=rsa-sha256;
	cv=none;
	b=C/K4IgA6QrCxzbAYl40me/xcbJGrJE4B97BaqjzHJQDLLvH1TZBkWnXaKTchMCUWMJgtUr
	OE3jjIE1yXckuFAhn9CLBm26fWuVSxpOcO39aSShuWxqCZCjqwZQ5XmIrXLb7LRS9agrGX
	lWmf2Ciom79qjMPpFGWubzw7Ekhs0+4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Hba8xhsA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768801858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8PdWrFDBIYyEs7h2YW96ncFY4ig9Q0IvOWU6B+OmJQ=;
	b=CNMXoTGtTTooSgRbWzN8759rddrLSj4LtjH2z3I+4uKuP+KFVeylrTLYEW97Ls+4WHvd5D
	GBbqtNnpw3o1zv5W1HX3RzFy0GEQTY+ghEDaY37fORaTwIGBuZpKNvEDDzSfusMODEXaUI
	+Iv7eYb34/RyRTZlp5pveWN5HzM9/sE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768801852; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=y8PdWrFDBIYyEs7h2YW96ncFY4ig9Q0IvOWU6B+OmJQ=;
	b=Hba8xhsAXUf2LnaPG5zf2+C1vqRmxLI1IWTSGnwuYnV7WZp3ZAboAoTj8r53DDA67X1EfQvkbgXzHGBUQeABZ3zQ3Sg08YO5KcEdRhhSjyGEw2XcAU6YNG8BMYilk5c1e39zCywVZmVPlzBN1CA+8ni8AFAtBDoY1lWdOtO6r68=
Received: from 30.74.144.151(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxIhExM_1768801849 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 19 Jan 2026 13:50:49 +0800
Message-ID: <29634bee-18c6-42c2-ac7f-703d4dfed867@linux.alibaba.com>
Date: Mon, 19 Jan 2026 13:50:47 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ccce0551-489a-4612-ab5d-2dd8a5cae66c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4czd9nx8p51fyw5cj5yjaqfacqz8fzut
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3A6240009
X-HE-Tag: 1768801856-991459
X-HE-Meta: U2FsdGVkX189wZ3iY4RzCkMfoS8nvgO1GxAR/9EIXSGGgGaDmmrEjQUnC8MoYW8Z89bDox7D8cT9WDcquLnZjysq3gEbl/BJQfpH4usIk9Acslg3SeLs65A73PiVny7V/He+ProUMDmH/8vDBtVwHFkKKPFBz6NASiIIrwhLrftwyXtUqddhslGmZWIizQsyC926m4l5aOEL5OuaQcHauW7Cmb21ocs9yoAb0kzHd8ltXDvtQ+fw07q7JtnMv/tvDl++2DqZ5qh68gkrv1OAEq4lK5ei3KI7jl0HZWix4jvJk9ooQxLLQyS0MK9dOvgkZS+dlzLkBHlBN8X0N0D7Y6Y0dT+F4v45Xv+0w2IpjsqqQm40DC72iTXhm2hz/dfzFetnAD3/s4CPj23BIyJmBwiNSsrdAls03Z2nMB1KzwhbzFRbx7Gm3aUvV02486Dl09PZGKHukMU3gPF6ptEr0JK/YyWpQ3/sa5FNV/ocayBdNggMHbWJTvirBBNCljHiDJdv+0RwmFLPw3A+zlRoIZc7FM26XUSBiYmJYdlJ1gIf89ekVEHTe2W45aJH8y6r8NTPkeY24YpXd9SK6sGOnNOl9QKIpzIfOHcTylBP4M9v3/ijFP7S3pg+iKG4+QbgkmzCXrKji1tcavu8U0yMs8GkbJ4UMdUUZrqH/tC4KlCLds6M/sYCqP0GMLFfR9UnzQ8aSLQ1snrbRkh4hLybTerD8LKLfMGleHW2b5Xv2M/VctXtyl2SqRxaAeNawa+hldAral7co7mcz0ggCnWCScHIAMrewob4Vdg367vHQqbyK0znJViNwVnMElLfHwRkp/84d62ELkHAEkNye1WQ/jWuambPYO5nePl7TGV4VOK/Qnr/zMuz88v71xHUYzAU2jJVKEFzhOKbW0TjLxJS31OCMQRhmb6AdMCbkXGoL/fU8BYqBtWtYYpLmB5Twj55R5oU2l3zTv9lpcQq/JS
 8Dc3jc4C
 PYD3dHFiW3S9DAFe42FPyhu6aSZgtve3YazD4sR2/liTohMSAtEy1LSjJaC6SlV47E4WC7LbyhdDuw3iJlUIYZz0xmD4Xu1oM7tFlLYr9/zDACvJjBH4rp/IlahUTIp2ZBAfbTYvhgShu6WKW9K9KOJw6RZ4fZNpla3qQ3EZdYy3RLZmi1+4KN5zD6Sq0at0BWlNeh7q59xD50tu+APQ9QgwSQWTK61QhEVvd7NqPJfHm8IetMtfR+bqvHAfMRuCklBB2DbPlwKK9sA1RJm89EkcgohRRZkaXgYKrJmNsWU1gwA3TnMs3Nc8W8ZWVR3gEYGASK3lJPcI4DEOtbg7r5o4bEGWKJeHDwStvqGyfLZlu3oOUjA80pOo/44JkIWy5DcjdmRnlrQOq1bVpwxx+FfWK8TAvVUcVuW+bHWeEVK7itqXWhjWNuduMxmRzNao0N+3o6kJWLW72n/YKWKw8yjvVnpKuumne6W0dxw5yX1NpH8BAd57dKxi7Mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 1:46 PM, Dev Jain wrote:
> 
> On 16/01/26 7:58 pm, Barry Song wrote:
>> On Fri, Jan 16, 2026 at 5:53 PM Dev Jain <dev.jain@arm.com> wrote:
>>>
>>> On 07/01/26 7:16 am, Wei Yang wrote:
>>>> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>>>>> On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>>>>>>> Similar to folio_referenced_one(), we can apply batched unmapping for file
>>>>>>> large folios to optimize the performance of file folios reclamation.
>>>>>>>
>>>>>>> Barry previously implemented batched unmapping for lazyfree anonymous large
>>>>>>> folios[1] and did not further optimize anonymous large folios or file-backed
>>>>>>> large folios at that stage. As for file-backed large folios, the batched
>>>>>>> unmapping support is relatively straightforward, as we only need to clear
>>>>>>> the consecutive (present) PTE entries for file-backed large folios.
>>>>>>>
>>>>>>> Performance testing:
>>>>>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>>>>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>>>>>>> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>>>>>>> on my X86 machine) with this patch.
>>>>>>>
>>>>>>> W/o patch:
>>>>>>> real    0m1.018s
>>>>>>> user    0m0.000s
>>>>>>> sys     0m1.018s
>>>>>>>
>>>>>>> W/ patch:
>>>>>>> real   0m0.249s
>>>>>>> user   0m0.000s
>>>>>>> sys    0m0.249s
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>>>>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>> Acked-by: Barry Song <baohua@kernel.org>
>>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> ---
>>>>>>> mm/rmap.c | 7 ++++---
>>>>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>> index 985ab0b085ba..e1d16003c514 100644
>>>>>>> --- a/mm/rmap.c
>>>>>>> +++ b/mm/rmap.c
>>>>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>>>>>        end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>>>        max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>>>
>>>>>>> -      /* We only support lazyfree batching for now ... */
>>>>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>>>> +      /* We only support lazyfree or file folios batching for now ... */
>>>>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>>>                return 1;
>>>>>>> +
>>>>>>>        if (pte_unused(pte))
>>>>>>>                return 1;
>>>>>>>
>>>>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>>                         *
>>>>>>>                         * See Documentation/mm/mmu_notifier.rst
>>>>>>>                         */
>>>>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>>>>> +                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>>>>>>>                }
>>>>>>> discard:
>>>>>>>                if (unlikely(folio_test_hugetlb(folio))) {
>>>>>>> --
>>>>>>> 2.47.3
>>>>>>>
>>>>>> Hi, Baolin
>>>>>>
>>>>>> When reading your patch, I come up one small question.
>>>>>>
>>>>>> Current try_to_unmap_one() has following structure:
>>>>>>
>>>>>>      try_to_unmap_one()
>>>>>>          while (page_vma_mapped_walk(&pvmw)) {
>>>>>>              nr_pages = folio_unmap_pte_batch()
>>>>>>
>>>>>>              if (nr_pages = folio_nr_pages(folio))
>>>>>>                  goto walk_done;
>>>>>>          }
>>>>>>
>>>>>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>>>>>
>>>>>> If my understanding is correct, page_vma_mapped_walk() would start from
>>>>>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
>>>>>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>>>>>
>>>>>> Not sure my understanding is correct, if so do we have some reason not to
>>>>>> skip the cleared range?
>>>>> I don’t quite understand your question. For nr_pages > 1 but not equal
>>>>> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.
>>>>>
>>>>> take a look:
>>>>>
>>>>> next_pte:
>>>>>                 do {
>>>>>                         pvmw->address += PAGE_SIZE;
>>>>>                         if (pvmw->address >= end)
>>>>>                                 return not_found(pvmw);
>>>>>                         /* Did we cross page table boundary? */
>>>>>                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>>>>>                                 if (pvmw->ptl) {
>>>>>                                         spin_unlock(pvmw->ptl);
>>>>>                                         pvmw->ptl = NULL;
>>>>>                                 }
>>>>>                                 pte_unmap(pvmw->pte);
>>>>>                                 pvmw->pte = NULL;
>>>>>                                 pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>>>>                                 goto restart;
>>>>>                         }
>>>>>                         pvmw->pte++;
>>>>>                 } while (pte_none(ptep_get(pvmw->pte)));
>>>>>
>>>> Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), they
>>>> will be skipped.
>>>>
>>>> I mean maybe we can skip it in try_to_unmap_one(), for example:
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 9e5bd4834481..ea1afec7c802 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>                 */
>>>>                if (nr_pages == folio_nr_pages(folio))
>>>>                        goto walk_done;
>>>> +             else {
>>>> +                     pvmw.address += PAGE_SIZE * (nr_pages - 1);
>>>> +                     pvmw.pte += nr_pages - 1;
>>>> +             }
>>>>                continue;
>>>>   walk_abort:
>>>>                ret = false;
>>> I am of the opinion that we should do something like this. In the internal pvmw code,
>> I am still not convinced that skipping PTEs in try_to_unmap_one()
>> is the right place. If we really want to skip certain PTEs early,
>> should we instead hint page_vma_mapped_walk()? That said, I don't
>> see much value in doing so, since in most cases nr is either 1 or
>> folio_nr_pages(folio).
>>
>>> we keep skipping ptes till the ptes are none. With my proposed uffd-fix [1], if the old
>>> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert all ptes from none
>>> to not none, and we will lose the batching effect. I also plan to extend support to
>>> anonymous folios (therefore generalizing for all types of memory) which will set a
>>> batch of ptes as swap, and the internal pvmw code won't be able to skip through the
>>> batch.
>> Thanks for catching this, Dev. I already filter out some of the more
>> complex cases, for example:
>> if (pte_unused(pte))
>>          return 1;
>>
>> Since the userfaultfd write-protection case is also a corner case,
>> could we filter it out as well?
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index c86f1135222b..6bb8ba6f046e 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1870,6 +1870,9 @@ static inline unsigned int
>> folio_unmap_pte_batch(struct folio *folio,
>>          if (pte_unused(pte))
>>                  return 1;
>>
>> +       if (userfaultfd_wp(vma))
>> +               return 1;
>> +
>>          return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>> }
>>
>> Just offering a second option — yours is probably better.
> 
> No. This is not an edge case. This is a case which gets exposed by your work, and
> I believe that if you intend to get the file folio batching thingy in, then you
> need to fix the uffd stuff too.

Barry’s point isn’t that this is an edge case. I think he means that 
uffd is not a common performance-sensitive scenario in production. Also, 
we typically fall back to per-page handling for uffd cases (see 
finish_fault() and alloc_anon_folio()). So I perfer to follow Barry’s 
suggestion and filter out the uffd cases until we have test case to show 
performance improvement.

I also think you can continue iterating your patch[1] to support batched 
unmapping for uffd VMAs, and provide data to evaluate its value.

[1] 
https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/

