Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EECCCA5FEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D956B011A; Mon, 19 Jan 2026 01:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4956B011B; Mon, 19 Jan 2026 01:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7000F6B011C; Mon, 19 Jan 2026 01:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7776B011A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:37:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F33E7D21F8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:37:10 +0000 (UTC)
X-FDA: 84347756220.27.AE6E7BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 224FD40006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:37:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768804629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HR5572oSydc/+v431u3xGCw+mnO5ICwWZzZrzrqYEo0=;
	b=YYkmswX0bdBBrYD4Fp3EYHsM+Xw9nhl5Wx/VxyOCkRR6EcMPa3vN5KWU7Tzv3PPu834biE
	5UFeKsNlhx3YevbskWSBvVeSyAp5ZunMUHq/bb/suF6LuY7zp+W7Ff3rm25p+I3bKl+c5i
	0qo5R2j+QjELgmrn1mDTT3JE1DV/juw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768804629; a=rsa-sha256;
	cv=none;
	b=n0ziwrYkSf1a5wKKWuJXN2g1s1kpC6fTu7ZRlNNOnY9yDS/Y2wHKEgawuL33T1CdNdcOgT
	/oS1X0MAJtuDM6eW6PwKHUwzl3rG2i6hHC3N7Xr5e5hHf674CZjJPT33YEOPKP5fmaM6XP
	c5PiQVE16c8xhA5Vl2qG/osaPaQUk0o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80CB21517;
	Sun, 18 Jan 2026 22:37:01 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0C303F632;
	Sun, 18 Jan 2026 22:37:02 -0800 (PST)
Message-ID: <6ed22a34-ce8a-4531-9776-b28e1a942450@arm.com>
Date: Mon, 19 Jan 2026 12:06:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <21cnbao@gmail.com>
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <29634bee-18c6-42c2-ac7f-703d4dfed867@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 224FD40006
X-Rspam-User: 
X-Stat-Signature: 644xw3rx5cx57qn9q9h4qcpjtmyhbxp3
X-HE-Tag: 1768804628-752588
X-HE-Meta: U2FsdGVkX1+xRoynto0s/efuIQhu58LC9TxekMgBBDiCqE50uLu4f5CpttFGetGkIfsnJyPntK2Nev7RCL/ZBs+cl0SGpQe4Ix3O/HEHkWxmREpKQ9/nWlIA8izOqqMNphjmN0bpLbtaTtSX7HGD1fjOH7cjNtlzJ+Igc6O6lody6fSF29W+BqZh4+Mg35DupWSOE66gxJbJ/sJ2KOSIX0K4QFWVPCZHElWIYp2ielkA/UzptTf44Pg97Iw6hh3Uh4IUT4crZ9ffyqZU7y0Pr2m8mGWh9b05oFAtGi+pmekXIIYB1wqb0AfTiXJQwLaYi+8Ajn6zPn12MpdSafhrAHdA6L27BVfhbn7/mJ2d+VlkLgvde7KFHCK04GUS5rEFAyVN0UQJvZszIs3ybD10kb9Bqoj2M8f/EsorEDKqVaR4cEYtWK5NTSN5rL6KVBh0rtC391KZjUcLhDspMeotXi1uJfGGsPuX+AbEbwvjQ2BIffO9akZVFD2ipIR65aUcrCJKjgUkCpwjBNOKcjJNs8yx9n0HUtRCONF28yAbRzfS5QjFKdyUiRjeBq1SSdmbVD9wxP4FIg1JkSD247MvFiLKJuWi6JoRjOPmruZqVSzukBJqSlnDSO/FsSCHRqYeXKgE2lnhEbDu21by+ONRxDT0nXZhNo0f3m3WWaxDIdkpu7v3bSdfQ0o0GMlGjKQrd4DlFuIhIp9NhPbCQnKlqTvcdeEnFxG9z0F6WDtjU51D6hN3IK+QPPT8YT5jSXn+YgaYScdVF1hQYtHj0lOjz74QZYzHsLIQFWMxVvr43KM3vAF7nUaUnEQu1+ZxJx+WxkdGcRVYpHnHNVitYTNWIainz7Xr8Dgvr9R6pe/MyeV5vkIwCkWYuljTAp5c8PZZmW+ama4/sX3wpgqt4T3hxv+SdPJjGZkmh2QjCJXJowzNmlpRQmbBE1CRkPxcfL8OtdmViHc2NVGphxqWXSL
 6pHMvFUf
 XMxcG3IU8TB4p+XyC/7Ei03oVMcS0v9YidabOISJXiLEp4TDd3kP7Oz150X/4aSug8LXkxvMFAyLUZg8wrKB7goiUTZK249a/BdygTDat3JepzZDHgAJPj+fLCnybZC/mvUwfkFWQiNrc8VDe2qHwiDX9knUsdjx5dJayuudtWXaFYx4q3zmhPlHBqM+V1Yd8PCWAElhGrcTBNmJEikvAubcOA2XlFKG9IPn3QWwA0d4ScXK/rbi4EnU8zpYoHgpYAtFHU3p1XKs4OV5HBE5uNRumCCUErcP7FcXT9ZahDvkXDiPbrta6rlgPNgrYJYgOFuGR3QeycBcNO31QryPatgOwCnrqpjMwuP/RTP4LxQfWm6WaOnm/lB4wUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 11:20 am, Baolin Wang wrote:
>
>
> On 1/18/26 1:46 PM, Dev Jain wrote:
>>
>> On 16/01/26 7:58 pm, Barry Song wrote:
>>> On Fri, Jan 16, 2026 at 5:53 PM Dev Jain <dev.jain@arm.com> wrote:
>>>>
>>>> On 07/01/26 7:16 am, Wei Yang wrote:
>>>>> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>>>>>> On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com>
>>>>>> wrote:
>>>>>>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>>>>>>>> Similar to folio_referenced_one(), we can apply batched unmapping
>>>>>>>> for file
>>>>>>>> large folios to optimize the performance of file folios reclamation.
>>>>>>>>
>>>>>>>> Barry previously implemented batched unmapping for lazyfree
>>>>>>>> anonymous large
>>>>>>>> folios[1] and did not further optimize anonymous large folios or
>>>>>>>> file-backed
>>>>>>>> large folios at that stage. As for file-backed large folios, the
>>>>>>>> batched
>>>>>>>> unmapping support is relatively straightforward, as we only need
>>>>>>>> to clear
>>>>>>>> the consecutive (present) PTE entries for file-backed large folios.
>>>>>>>>
>>>>>>>> Performance testing:
>>>>>>>> Allocate 10G clean file-backed folios by mmap() in a memory
>>>>>>>> cgroup, and try to
>>>>>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I
>>>>>>>> can observe
>>>>>>>> 75% performance improvement on my Arm64 32-core server (and 50%+
>>>>>>>> improvement
>>>>>>>> on my X86 machine) with this patch.
>>>>>>>>
>>>>>>>> W/o patch:
>>>>>>>> real    0m1.018s
>>>>>>>> user    0m0.000s
>>>>>>>> sys     0m1.018s
>>>>>>>>
>>>>>>>> W/ patch:
>>>>>>>> real   0m0.249s
>>>>>>>> user   0m0.000s
>>>>>>>> sys    0m0.249s
>>>>>>>>
>>>>>>>> [1]
>>>>>>>> https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>>>>>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>> Acked-by: Barry Song <baohua@kernel.org>
>>>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>> mm/rmap.c | 7 ++++---
>>>>>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>>> index 985ab0b085ba..e1d16003c514 100644
>>>>>>>> --- a/mm/rmap.c
>>>>>>>> +++ b/mm/rmap.c
>>>>>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int
>>>>>>>> folio_unmap_pte_batch(struct folio *folio,
>>>>>>>>        end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>>>>        max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>>>>
>>>>>>>> -      /* We only support lazyfree batching for now ... */
>>>>>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>>>>> +      /* We only support lazyfree or file folios batching for now
>>>>>>>> ... */
>>>>>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>>>>                return 1;
>>>>>>>> +
>>>>>>>>        if (pte_unused(pte))
>>>>>>>>                return 1;
>>>>>>>>
>>>>>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio
>>>>>>>> *folio, struct vm_area_struct *vma,
>>>>>>>>                         *
>>>>>>>>                         * See Documentation/mm/mmu_notifier.rst
>>>>>>>>                         */
>>>>>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>>>>>> +                      add_mm_counter(mm, mm_counter_file(folio),
>>>>>>>> -nr_pages);
>>>>>>>>                }
>>>>>>>> discard:
>>>>>>>>                if (unlikely(folio_test_hugetlb(folio))) {
>>>>>>>> -- 
>>>>>>>> 2.47.3
>>>>>>>>
>>>>>>> Hi, Baolin
>>>>>>>
>>>>>>> When reading your patch, I come up one small question.
>>>>>>>
>>>>>>> Current try_to_unmap_one() has following structure:
>>>>>>>
>>>>>>>      try_to_unmap_one()
>>>>>>>          while (page_vma_mapped_walk(&pvmw)) {
>>>>>>>              nr_pages = folio_unmap_pte_batch()
>>>>>>>
>>>>>>>              if (nr_pages = folio_nr_pages(folio))
>>>>>>>                  goto walk_done;
>>>>>>>          }
>>>>>>>
>>>>>>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>>>>>>
>>>>>>> If my understanding is correct, page_vma_mapped_walk() would start
>>>>>>> from
>>>>>>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already
>>>>>>> cleared to
>>>>>>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>>>>>>
>>>>>>> Not sure my understanding is correct, if so do we have some reason
>>>>>>> not to
>>>>>>> skip the cleared range?
>>>>>> I don’t quite understand your question. For nr_pages > 1 but not equal
>>>>>> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs
>>>>>> inside.
>>>>>>
>>>>>> take a look:
>>>>>>
>>>>>> next_pte:
>>>>>>                 do {
>>>>>>                         pvmw->address += PAGE_SIZE;
>>>>>>                         if (pvmw->address >= end)
>>>>>>                                 return not_found(pvmw);
>>>>>>                         /* Did we cross page table boundary? */
>>>>>>                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE))
>>>>>> == 0) {
>>>>>>                                 if (pvmw->ptl) {
>>>>>>                                         spin_unlock(pvmw->ptl);
>>>>>>                                         pvmw->ptl = NULL;
>>>>>>                                 }
>>>>>>                                 pte_unmap(pvmw->pte);
>>>>>>                                 pvmw->pte = NULL;
>>>>>>                                 pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>>>>>                                 goto restart;
>>>>>>                         }
>>>>>>                         pvmw->pte++;
>>>>>>                 } while (pte_none(ptep_get(pvmw->pte)));
>>>>>>
>>>>> Yes, we do it in page_vma_mapped_walk() now. Since they are
>>>>> pte_none(), they
>>>>> will be skipped.
>>>>>
>>>>> I mean maybe we can skip it in try_to_unmap_one(), for example:
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 9e5bd4834481..ea1afec7c802 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio
>>>>> *folio, struct vm_area_struct *vma,
>>>>>                 */
>>>>>                if (nr_pages == folio_nr_pages(folio))
>>>>>                        goto walk_done;
>>>>> +             else {
>>>>> +                     pvmw.address += PAGE_SIZE * (nr_pages - 1);
>>>>> +                     pvmw.pte += nr_pages - 1;
>>>>> +             }
>>>>>                continue;
>>>>>   walk_abort:
>>>>>                ret = false;
>>>> I am of the opinion that we should do something like this. In the
>>>> internal pvmw code,
>>> I am still not convinced that skipping PTEs in try_to_unmap_one()
>>> is the right place. If we really want to skip certain PTEs early,
>>> should we instead hint page_vma_mapped_walk()? That said, I don't
>>> see much value in doing so, since in most cases nr is either 1 or
>>> folio_nr_pages(folio).
>>>
>>>> we keep skipping ptes till the ptes are none. With my proposed
>>>> uffd-fix [1], if the old
>>>> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert
>>>> all ptes from none
>>>> to not none, and we will lose the batching effect. I also plan to
>>>> extend support to
>>>> anonymous folios (therefore generalizing for all types of memory)
>>>> which will set a
>>>> batch of ptes as swap, and the internal pvmw code won't be able to
>>>> skip through the
>>>> batch.
>>> Thanks for catching this, Dev. I already filter out some of the more
>>> complex cases, for example:
>>> if (pte_unused(pte))
>>>          return 1;
>>>
>>> Since the userfaultfd write-protection case is also a corner case,
>>> could we filter it out as well?
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index c86f1135222b..6bb8ba6f046e 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1870,6 +1870,9 @@ static inline unsigned int
>>> folio_unmap_pte_batch(struct folio *folio,
>>>          if (pte_unused(pte))
>>>                  return 1;
>>>
>>> +       if (userfaultfd_wp(vma))
>>> +               return 1;
>>> +
>>>          return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>>> }
>>>
>>> Just offering a second option — yours is probably better.
>>
>> No. This is not an edge case. This is a case which gets exposed by your
>> work, and
>> I believe that if you intend to get the file folio batching thingy in,
>> then you
>> need to fix the uffd stuff too.
>
> Barry’s point isn’t that this is an edge case. I think he means that uffd
> is not a common performance-sensitive scenario in production. Also, we
> typically fall back to per-page handling for uffd cases (see
> finish_fault() and alloc_anon_folio()). So I perfer to follow Barry’s
> suggestion and filter out the uffd cases until we have test case to show
> performance improvement. 

I am of the opinion that you are making the wrong analogy here. The
per-page fault fidelity is *required* for uffd.

When you say you want to support file folio batched unmapping, I think it's
inappropriate to say "let us refuse to

batch if the pte mapping the file folio is smeared with a particular bit
and consider it a totally different case". Instead

of getting in folio (all memory types) batched unmapping in, we have
already broken this to "lazyfree folio", then

"file folio", the remaining being "anon folio". Now you intend to break
"file folio" to "file folio non uffd" and "file folio uffd".


Just my 2C, I don't opine strongly here.


>
> I also think you can continue iterating your patch[1] to support batched
> unmapping for uffd VMAs, and provide data to evaluate its value.
>
> [1]
> https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/

