Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC021D3CCAB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4296B0088; Fri, 16 Jan 2026 04:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC056B008A; Fri, 16 Jan 2026 04:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1816B008C; Fri, 16 Jan 2026 04:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFDA6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:53:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFD561A035A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:53:14 +0000 (UTC)
X-FDA: 84337363908.26.6C9D21B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2FF7180008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:53:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768557193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+Azk5OL1cHbLhDKwX4Bu5Iz3BnrGTbJkIhH0nf8Txc=;
	b=kAT7P546F2BjF899TbnDl3P4zOHi1AU+hoSa/Hmq2x4QYwmyIW8ulRI21W1t425vTbkbUd
	pi1Opn7TSZIetT3LGkQE13QP6/alwkHxBH8xgpEFImKK3R99PLshyojH8GhHEBVVM/n1IB
	A7DB+Crg+jWfFj/m9sHRLRHRC+4P1c8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768557193; a=rsa-sha256;
	cv=none;
	b=SDtLDjoapXYPNU4029V2Y/knEBT/VigyJ61O0lvQp+0UbHyLSFmDUPiCvVxZ2xgfMIBL8l
	Y4Rce9xQZL0W5eWQJ/m7mwqCB8nsPkS37lrc6fg3myY63SjJah58/zO5iyeMRJD61RtLah
	GKJWXktpE4il/Dm5YLDtXtbXywH+FGo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64B851515;
	Fri, 16 Jan 2026 01:53:05 -0800 (PST)
Received: from [10.164.136.46] (unknown [10.164.136.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADF7B3F694;
	Fri, 16 Jan 2026 01:53:05 -0800 (PST)
Message-ID: <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
Date: Fri, 16 Jan 2026 15:23:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Wei Yang <richard.weiyang@gmail.com>, Barry Song <21cnbao@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260107014601.dxvq6b7ljgxwg7iu@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2FF7180008
X-Stat-Signature: axd9j69mbcgffeoqcscj6ff49saw6od7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768557192-595029
X-HE-Meta: U2FsdGVkX1/LGTaRvPnrd7eGGC6fQVQY9Yubnuc9yQi4r+y7aRZxzrVeb5ya1G9vpHZfqycuf1WCTdOSCnzgE518nKAnuvpyUU7zeIUPjKc0j/6rT95kohWrU7jrNU9uYyNoNBtNrikO8Jkzovzw7HfjFiPPWZl0bPINVtS6RjA4jPjQ/Je/2VrbFx/kZygPZ/GT2YTCcUTnFYY7+POjnfcYDCShTWOX9BhoqCIKeG163TV4h/eZpHJzQH3mSP1QpM62PEFEjqZykXC4UzFvKZP2WGX1v00x5tOgk4RnRFbb3PquAArOJRRFK5Gkbud291a88RZQVqn9OAFGm0M9xx+m4t9tCluKfgErFyMrvf4V5DAmUXmazvVHn1ZUqjjUqgF2oG56+JlkRhwswNCSiujg/Z87xily5kAEYxbBuKpTbux+iLwkWgijEFDg2xBlxsZMYjoY6hGsW0vBNxcZY/UH9odi1R405DMItHiaYqR6KTKMn73TOpsee4nJWIwXLGDgXxyCVfBaTMQuhMHxkdHCJUz1XexQtrTG5TwW8t/IDpOZ5TPFvuTIiPLBabqBqS3mesyjyzmI04gLzRmktRHoVBwVjmebp4a+6Qsf9I3YoDX7AeG+rPuG4d3dW289tzAYAb0MZKxDAHmeQEC6rdVDYh2R6+UZPkybqJaRj+mXwqWRZ1UubN43E1IK2OxsvXseojUz3yzXlMCTgGCaZUnd7/rriylqjkT46eClqGDMn95c3QgcJIhXlmH0PPjceX5Rit77r6DIaRO38hVF6rrreVNlu/TE+nbF9i8VM6578KJK3OZNC8Vg11oUSxsvgsDT82iOu0GZWhfKm3VIVSZ4rGMYtgA9Ft4jr6kN3p+qFjYimP4GAkyQouu6ncMmCGUghkpGwEpplBbotzGyks8qNKnAoaH9FjOwRH7DhJLC/9cufORP/1k1Myx2qk0goXWyNjwDKMoKvjpfQRf
 xs2VoNls
 LYfb4kLRL1M3sGrMdwqY+Iuvc68hpUTw0dUlbbTBmgx9KLdjekmLAJaUBfDc9m2JWqOkRWFoKQO59v6RCUi7/VvzkFgnvUke3soPCS9dh+aj0a94crLM/VHtFBVy0FYsR9a4Q0l0RJvJqSbybVjaAqBOqKYpd4ZFn4CiB9iy+NZRNmKRVzF3nX6dLjITY4A9oqbMYYsxTtT56Mrnhcz0u7oDw950OpO1XVbNKQHBP8NAVuVGO6jq682Wh0fpoZKCb2dAu/jQh03HRLVLS2F9RWHjOpRymkad5+2dGKD244RE+hRydK40Y8HTxXrNf3aHv1fk53yMIJ8EMaZ6QJD0+zYzAOHOqxocznRs73T+IexSxTLnOxwYX5tcLww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/01/26 7:16 am, Wei Yang wrote:
> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>> On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>>>> Similar to folio_referenced_one(), we can apply batched unmapping for file
>>>> large folios to optimize the performance of file folios reclamation.
>>>>
>>>> Barry previously implemented batched unmapping for lazyfree anonymous large
>>>> folios[1] and did not further optimize anonymous large folios or file-backed
>>>> large folios at that stage. As for file-backed large folios, the batched
>>>> unmapping support is relatively straightforward, as we only need to clear
>>>> the consecutive (present) PTE entries for file-backed large folios.
>>>>
>>>> Performance testing:
>>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>>>> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>>>> on my X86 machine) with this patch.
>>>>
>>>> W/o patch:
>>>> real    0m1.018s
>>>> user    0m0.000s
>>>> sys     0m1.018s
>>>>
>>>> W/ patch:
>>>> real   0m0.249s
>>>> user   0m0.000s
>>>> sys    0m0.249s
>>>>
>>>> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>> Acked-by: Barry Song <baohua@kernel.org>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>> mm/rmap.c | 7 ++++---
>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 985ab0b085ba..e1d16003c514 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>>       end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>       max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>
>>>> -      /* We only support lazyfree batching for now ... */
>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>> +      /* We only support lazyfree or file folios batching for now ... */
>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>               return 1;
>>>> +
>>>>       if (pte_unused(pte))
>>>>               return 1;
>>>>
>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>                        *
>>>>                        * See Documentation/mm/mmu_notifier.rst
>>>>                        */
>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>> +                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>>>>               }
>>>> discard:
>>>>               if (unlikely(folio_test_hugetlb(folio))) {
>>>> --
>>>> 2.47.3
>>>>
>>> Hi, Baolin
>>>
>>> When reading your patch, I come up one small question.
>>>
>>> Current try_to_unmap_one() has following structure:
>>>
>>>     try_to_unmap_one()
>>>         while (page_vma_mapped_walk(&pvmw)) {
>>>             nr_pages = folio_unmap_pte_batch()
>>>
>>>             if (nr_pages = folio_nr_pages(folio))
>>>                 goto walk_done;
>>>         }
>>>
>>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>>
>>> If my understanding is correct, page_vma_mapped_walk() would start from
>>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
>>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>>
>>> Not sure my understanding is correct, if so do we have some reason not to
>>> skip the cleared range?
>> I don’t quite understand your question. For nr_pages > 1 but not equal
>> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.
>>
>> take a look:
>>
>> next_pte:
>>                do {
>>                        pvmw->address += PAGE_SIZE;
>>                        if (pvmw->address >= end)
>>                                return not_found(pvmw);
>>                        /* Did we cross page table boundary? */
>>                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>>                                if (pvmw->ptl) {
>>                                        spin_unlock(pvmw->ptl);
>>                                        pvmw->ptl = NULL;
>>                                }
>>                                pte_unmap(pvmw->pte);
>>                                pvmw->pte = NULL;
>>                                pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>                                goto restart;
>>                        }
>>                        pvmw->pte++;
>>                } while (pte_none(ptep_get(pvmw->pte)));
>>
> Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), they
> will be skipped.
>
> I mean maybe we can skip it in try_to_unmap_one(), for example:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9e5bd4834481..ea1afec7c802 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 */
>  		if (nr_pages == folio_nr_pages(folio))
>  			goto walk_done;
> +		else {
> +			pvmw.address += PAGE_SIZE * (nr_pages - 1);
> +			pvmw.pte += nr_pages - 1;
> +		}
>  		continue;
>  walk_abort:
>  		ret = false;

I am of the opinion that we should do something like this. In the internal pvmw code,
we keep skipping ptes till the ptes are none. With my proposed uffd-fix [1], if the old
ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert all ptes from none
to not none, and we will lose the batching effect. I also plan to extend support to
anonymous folios (therefore generalizing for all types of memory) which will set a
batch of ptes as swap, and the internal pvmw code won't be able to skip through the
batch.


[1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/

>
> Not sure this is reasonable.
>
>

