Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67524C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 05:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550BF6B0005; Sun, 18 Jan 2026 00:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D48A6B0089; Sun, 18 Jan 2026 00:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0956B008A; Sun, 18 Jan 2026 00:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29D396B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:46:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D4091404D2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:46:52 +0000 (UTC)
X-FDA: 84344000664.08.B24C3CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98CAE120004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:46:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768715211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UcdqeoBShezB1UdnhKKlQizEDAfruq6bLrpoq6KJU2g=;
	b=0nBs8Q+AlZBECw0mWpUBuOb4T1QlR1RJdoJt0AxIqRdMfVScvVWqFD/JUBgYb28zQaW9t/
	I/ktVEILu+ttdZCFc4P4ImNNRGPik4M54ieIA0DibmTiExeDJmGMzksm5f5lrkTXLyakLm
	8/nOgm1zVUK4TnaWAMPZAWWF9e8RCtE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768715211; a=rsa-sha256;
	cv=none;
	b=eGfA75/rPI0aGcSkgQWPqZUKmvok1DyIROOmcWwwoku6i9IJ+cndPDCAOp5Btky2KXYfFt
	a8nPFcWAZIoxDeIFQBpxLTmWNb2o1O/D9hGPvpIxp4+uIdeNR8bR8+89tRyl/rLwDT7xkr
	zFoOrEB7Ey7IJ2IqTqC03tio7T3Gcow=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8CE31517;
	Sat, 17 Jan 2026 21:46:42 -0800 (PST)
Received: from [10.164.10.251] (unknown [10.164.10.251])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5155F3F632;
	Sat, 17 Jan 2026 21:46:43 -0800 (PST)
Message-ID: <ccce0551-489a-4612-ab5d-2dd8a5cae66c@arm.com>
Date: Sun, 18 Jan 2026 11:16:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Barry Song <21cnbao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yo-EE__1VzHqxE8ehDOFQuxqP9GXcskkeZ-WTTyz12_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98CAE120004
X-Stat-Signature: toutewrzwk4oowwx3dsgfn7x35tmhe9r
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768715210-49735
X-HE-Meta: U2FsdGVkX1/3RA8s/Xoo9fxMz2paCx3Ck5BAjQAs6O+TilDTUYlssauhKc9k5R9XW00MTbardNep+G6eB8CM7KMZV6R6j37LMeykpWtl9N/grAcGrNQXX6SEf0YPNtGxlfgTBjzvh0pA/LlE54SUOZkIGpTIkgW1vatEvGhSiwa3hIk5cqVMRMCKeTFRwZjK6xo7UsMGoR9mCBgD/bL4O75ZpsMPWwlnznBGl+iraU0rtNO7QChwV0TDrHlko33Z+mC7gKWmYHewOhaokXgtvblWHScsc5nejq8QlScvLl8nV+4+/SjnMYeehdaqgXcmi/OY051st+GXDvvpPp1kHDttrmyFb6nTiZKApGEB5WinNu8EmJ4KevztuWQWVFrTbpwD8KC+K+KHjdzi/cPBAgk2TjKOIPnx6pkrwoVSqx7ARhBdWmHz0gpklCIY2vnX5pg552525kt9iqqxCq6rBgI3kwqGjlBlxq1xYLmPbaHawk4HzjNlZ83htZndXHyRU7iC+Q4RPvsaFIbm3nNaNEoQjl0UOtFDxruxuuWBBW+fPtoPVd6X9Q0/q2YdKMtfqHnVa8fxq3hmXpAweaQfF7i7Ko61XORz6FugNjYqYiKrSF3jTqkZH17ZIbz4FM5k4QDDCP7uUEurUjEzZLEwMlCWVg31k8/Frs3u/ttqHKzcINgmr+c0rhAu6ZRYQpeugs2X/NuguCPXkyAN+0suFLwTyEG9XyDjudyxzEZYGMaIc0TYYWjMEIsoPASwhU0a7f7XNeIbmSmd0IDXu4KYnJLBN1TyCYYwxX/mTdnFGdkj8dcAUVxlJa8VX40svzE9oPmQG2vvrr7lsXmYQdx22DvTx0ozLHjUb1UCaS/xCc+NJ0MGaEMkTSmWOJXa8v8FZ9nq/6zvp+DIlkoiuqCr/Uk7WHPYt5oGwi2xTcjGXPZvZ8ThlUcFjvxGLPQIHe+Ou9GulI/yI4tliFy1R/O
 Ul187Lxg
 nzlr93tCdKm32b0j2WRrRTmpr3w9T5nX8Xj0HK+VCGITS47EbFPtIucIq2wKyAA7k/0xVib/96K7B/nGR1bmw0Bi8VjwRuK6kPWl+SzzrVTSMQjJwM7mUEMBl/VKQaiisk4Y3Io9lKKN45TBQ3CJj553gE60ghPNQfdIAvC8N/K2KthikGs2FR3Ir/cFJuFC58pXHKYYPzm+KNdcYlru6TVCJMn0kXvvkBKFmODxxfEYTpt9rdppKTVF9fIwTuDObSHJRELI7vJUozo0LoK6Qly/x7Q+xX0oqR8InTevSpn/iVScD2LpqxSylY7iU08FzpGILfrXbq7fBIgZlNvyu/Ssa27s/FMCQ7B7rt+E7RBuHFVZSzHKIMeZx0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/01/26 7:58 pm, Barry Song wrote:
> On Fri, Jan 16, 2026 at 5:53 PM Dev Jain <dev.jain@arm.com> wrote:
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
>>>>>>       end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>>       max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>>
>>>>>> -      /* We only support lazyfree batching for now ... */
>>>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>>> +      /* We only support lazyfree or file folios batching for now ... */
>>>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>>               return 1;
>>>>>> +
>>>>>>       if (pte_unused(pte))
>>>>>>               return 1;
>>>>>>
>>>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>                        *
>>>>>>                        * See Documentation/mm/mmu_notifier.rst
>>>>>>                        */
>>>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>>>> +                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>>>>>>               }
>>>>>> discard:
>>>>>>               if (unlikely(folio_test_hugetlb(folio))) {
>>>>>> --
>>>>>> 2.47.3
>>>>>>
>>>>> Hi, Baolin
>>>>>
>>>>> When reading your patch, I come up one small question.
>>>>>
>>>>> Current try_to_unmap_one() has following structure:
>>>>>
>>>>>     try_to_unmap_one()
>>>>>         while (page_vma_mapped_walk(&pvmw)) {
>>>>>             nr_pages = folio_unmap_pte_batch()
>>>>>
>>>>>             if (nr_pages = folio_nr_pages(folio))
>>>>>                 goto walk_done;
>>>>>         }
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
>>>>                do {
>>>>                        pvmw->address += PAGE_SIZE;
>>>>                        if (pvmw->address >= end)
>>>>                                return not_found(pvmw);
>>>>                        /* Did we cross page table boundary? */
>>>>                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>>>>                                if (pvmw->ptl) {
>>>>                                        spin_unlock(pvmw->ptl);
>>>>                                        pvmw->ptl = NULL;
>>>>                                }
>>>>                                pte_unmap(pvmw->pte);
>>>>                                pvmw->pte = NULL;
>>>>                                pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>>>                                goto restart;
>>>>                        }
>>>>                        pvmw->pte++;
>>>>                } while (pte_none(ptep_get(pvmw->pte)));
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
>>>                */
>>>               if (nr_pages == folio_nr_pages(folio))
>>>                       goto walk_done;
>>> +             else {
>>> +                     pvmw.address += PAGE_SIZE * (nr_pages - 1);
>>> +                     pvmw.pte += nr_pages - 1;
>>> +             }
>>>               continue;
>>>  walk_abort:
>>>               ret = false;
>> I am of the opinion that we should do something like this. In the internal pvmw code,
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
> Thanks for catching this, Dev. I already filter out some of the more
> complex cases, for example:
> if (pte_unused(pte))
>         return 1;
>
> Since the userfaultfd write-protection case is also a corner case,
> could we filter it out as well?
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index c86f1135222b..6bb8ba6f046e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1870,6 +1870,9 @@ static inline unsigned int
> folio_unmap_pte_batch(struct folio *folio,
>         if (pte_unused(pte))
>                 return 1;
>
> +       if (userfaultfd_wp(vma))
> +               return 1;
> +
>         return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> }
>
> Just offering a second option — yours is probably better.

No. This is not an edge case. This is a case which gets exposed by your work, and
I believe that if you intend to get the file folio batching thingy in, then you
need to fix the uffd stuff too.

>
> Thanks
> Barry

