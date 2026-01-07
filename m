Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED87CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B6F6B0092; Tue,  6 Jan 2026 21:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09316B0093; Tue,  6 Jan 2026 21:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1436B0095; Tue,  6 Jan 2026 21:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC7746B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:29:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63751D0FEA
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:29:28 +0000 (UTC)
X-FDA: 84303586416.27.B8E21D8
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 604E240007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:29:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m+2RnwjV;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767752966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvVNxl0vYanRjAda51MqOz06aqccjdsHpO3yOVybwFM=;
	b=UeIM+SOomrk9mVYE3DNEZnXjqI76mXCmXMcp0TJnSTJ49l2I/dRaYfqizrjCenMyMO1nqn
	WrYmsSNHn7X93RXjEamyXktk+/h0Vh0uONmJCNmujFW3jxMrDx0/6d62TRVkZAxunUzWgj
	q5jKFeG72WJeKDGIgNm1tl3QS/cb+Pk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m+2RnwjV;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767752966; a=rsa-sha256;
	cv=none;
	b=WqWIPVHbsdFgjIHwjWm19Z6BPA/ZqFKI8dewKY8KlzQURMwKgPa5tRrdMRk9KXrGKJ1jb6
	P6VdrI6JaylhlqoX6L9pAxKAhQqcg5elaBQLzlhvbtC9C/jx3syTFOK2cP3NCZK0o7/Q/2
	fI6FhCptK9N1HuPjjSUdlYKiohM0BP0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767752962; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kvVNxl0vYanRjAda51MqOz06aqccjdsHpO3yOVybwFM=;
	b=m+2RnwjVdne35Pr57bsmur2Mzvk5+Tdnj9bIOljNVHK7cQtRU562SVWzGgQ/q8vCsVIIOLd666N4DsSjQvtiSt2DgdK40BewGsNYfSYjpV684aQZ6kfYFFZNDV16evQiFg+s/USjd0aTQdPiPUGFk0BoF8zQrqb+HxLboucTjoQ=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwX9Qu3_1767752958 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 07 Jan 2026 10:29:19 +0800
Message-ID: <cd626b19-2636-477e-ab01-26380b12d4b1@linux.alibaba.com>
Date: Wed, 7 Jan 2026 10:29:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Barry Song <21cnbao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master>
 <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master>
 <CAGsJ_4xfVnPKSPvHYWa1cPK7kZC4F6hKreny9RsKfSCyC4RHuQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4xfVnPKSPvHYWa1cPK7kZC4F6hKreny9RsKfSCyC4RHuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 604E240007
X-Stat-Signature: qi8o3t7frj15gffa89qss373u4mzfbs3
X-Rspam-User: 
X-HE-Tag: 1767752965-239155
X-HE-Meta: U2FsdGVkX19WDKYDL4x4v/59+qXGNhRrl/iHbwaVSml2rbMjg6k9g5QblITdCFvPvteY7KWraE8Nwsg/PsAcvfcpZUOREKnEI9XHxjQf1oaJWOpeoPgBy640J9fT/h0diwMAHVRPg5w1NvbufbJ+11FrbfWlMvMVt2HhfCF9BEZkCd4Q4F1CdrVdBVuMhsoYt7UPdwtJGjwYkefjL46Qf80OU1Gg//5HMjoPpO8sojpCvkzi7iliohGVS7BesHvPS25K0uBCn9uIKUxFaunEHZ52kUQ5etL6b4TwmBowMVSqX132qUs2njjAYDAc+U2gQ4FuYCaIgEhceqBP1R9RzlumUxNk+HihyQ5zdIGaAXmPfYonK0o/2JR429nJZTrfjRu1gx26e6/Gm/XuujrGgHYUwqoiibXe7CNgVX7oZC29EaHMrMvOgOXpc8036VzfbBFg1Lyw8nJ1FWZGvxV8FS4NDywOegbc+Ud4yeHpG5yjzNWotp6IzbR0W4B/j4G07iWTbKCXZ9YPJS+cJ/2CyGCfuSzV+Kue5TvKjPahg1xb3IJBbfQTdRUOr4QjujIZ7JIEnrL/fmqgx33quTYRLJ5pu+uXsSV/JhvgbvOukDAhSoEDvv3oHPJiJ6sU2Ft+e5F1CfkFumL8Dpe7sDyoaPyZ7ZHvnr4hReA6fjd/IMi2NNXxksSsiOAx5b805T7EfDytPZtvcHh1N7Qaa0Fp/mIajiXLTHhGKKGJSUhdenj9OcP58NDYYpJu+bmPmDK5/frUOEApxPmUX45Vad2ERfZtaB0lUAnUiudLZ4H4Fzfy+px/YNDlH7pO47myIM7+4JhgrOKUCbxuDogtrh87FPIKRvB9atzJtU0BeMk0n4kpNBsgDMe9iRPlgV2VoZdMfztv32HpPSpG4m4Yx/fXz9AxEH2KyWBdKM9kPig8olw0qdpO94LvNIfN1FIwu1yOQTs3sNlqAkvAV7T8o4v
 S9KXb3et
 v8JQ3crHiraLtvViquMj9FagOR3H2+CeKnO3fTgYZRhgUhRxR0EPy6E+vDYfwT02bck/7Do4TjAh7HQy2njl757uArRqdNv0oeVFVk/R4C6e77sQqafqzTAsVptNHEgaV1YZA+V9wkzj6JBOJ5dJFc33r8LM6nhEvGkZrLMA81QiGppHLNTlba3FftQb1ufeNH0c6TVCWTV+oWygzEOPH1yOG/X4mQnipowlsdMxUhj8lUiFMl8Dqv53ngOR+H5a6h7n0EUsFQgtMw3bYEwGkBZxdCqLHde27i6TOaCyU5WVV+A2U6bL06VCTb3dO06pir6zyy24VYv/XpnnRDz2GaDoBXWRtMcp76TgkNckApKMGKd1ncxr+rvbwVSJruQ9hsHZVfpMVVkWii14u1hRifvLNg3e7KYaZjd5g8enbEfQ28qeuF94WHjpY9mKK69u12N4JTgqbE5sM7LMKqxvGrTC7zAAesnMHUAGLQyn7udB3kjxOFvc+FDDt/l87rGMw8atC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/7/26 10:21 AM, Barry Song wrote:
> On Wed, Jan 7, 2026 at 2:46 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>>> On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>
>>>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>>>>> Similar to folio_referenced_one(), we can apply batched unmapping for file
>>>>> large folios to optimize the performance of file folios reclamation.
>>>>>
>>>>> Barry previously implemented batched unmapping for lazyfree anonymous large
>>>>> folios[1] and did not further optimize anonymous large folios or file-backed
>>>>> large folios at that stage. As for file-backed large folios, the batched
>>>>> unmapping support is relatively straightforward, as we only need to clear
>>>>> the consecutive (present) PTE entries for file-backed large folios.
>>>>>
>>>>> Performance testing:
>>>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>>>>> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>>>>> on my X86 machine) with this patch.
>>>>>
>>>>> W/o patch:
>>>>> real    0m1.018s
>>>>> user    0m0.000s
>>>>> sys     0m1.018s
>>>>>
>>>>> W/ patch:
>>>>> real   0m0.249s
>>>>> user   0m0.000s
>>>>> sys    0m0.249s
>>>>>
>>>>> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Acked-by: Barry Song <baohua@kernel.org>
>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> ---
>>>>> mm/rmap.c | 7 ++++---
>>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 985ab0b085ba..e1d16003c514 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>>>        end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>        max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>
>>>>> -      /* We only support lazyfree batching for now ... */
>>>>> -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>> +      /* We only support lazyfree or file folios batching for now ... */
>>>>> +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>                return 1;
>>>>> +
>>>>>        if (pte_unused(pte))
>>>>>                return 1;
>>>>>
>>>>> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>                         *
>>>>>                         * See Documentation/mm/mmu_notifier.rst
>>>>>                         */
>>>>> -                      dec_mm_counter(mm, mm_counter_file(folio));
>>>>> +                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>>>>>                }
>>>>> discard:
>>>>>                if (unlikely(folio_test_hugetlb(folio))) {
>>>>> --
>>>>> 2.47.3
>>>>>
>>>>
>>>> Hi, Baolin
>>>>
>>>> When reading your patch, I come up one small question.
>>>>
>>>> Current try_to_unmap_one() has following structure:
>>>>
>>>>      try_to_unmap_one()
>>>>          while (page_vma_mapped_walk(&pvmw)) {
>>>>              nr_pages = folio_unmap_pte_batch()
>>>>
>>>>              if (nr_pages = folio_nr_pages(folio))
>>>>                  goto walk_done;
>>>>          }
>>>>
>>>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>>>
>>>> If my understanding is correct, page_vma_mapped_walk() would start from
>>>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
>>>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>>>
>>>> Not sure my understanding is correct, if so do we have some reason not to
>>>> skip the cleared range?
>>>
>>> I don’t quite understand your question. For nr_pages > 1 but not equal
>>> to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.
>>>
>>> take a look:
>>>
>>> next_pte:
>>>                 do {
>>>                         pvmw->address += PAGE_SIZE;
>>>                         if (pvmw->address >= end)
>>>                                 return not_found(pvmw);
>>>                         /* Did we cross page table boundary? */
>>>                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>>>                                 if (pvmw->ptl) {
>>>                                         spin_unlock(pvmw->ptl);
>>>                                         pvmw->ptl = NULL;
>>>                                 }
>>>                                 pte_unmap(pvmw->pte);
>>>                                 pvmw->pte = NULL;
>>>                                 pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>>                                 goto restart;
>>>                         }
>>>                         pvmw->pte++;
>>>                 } while (pte_none(ptep_get(pvmw->pte)));
>>>
>>
>> Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), they
>> will be skipped.
>>
>> I mean maybe we can skip it in try_to_unmap_one(), for example:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 9e5bd4834481..ea1afec7c802 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>                   */
>>                  if (nr_pages == folio_nr_pages(folio))
>>                          goto walk_done;
>> +               else {
>> +                       pvmw.address += PAGE_SIZE * (nr_pages - 1);
>> +                       pvmw.pte += nr_pages - 1;
>> +               }
>>                  continue;
>>   walk_abort:
>>                  ret = false;
> 
> 
> I feel this couples the PTE walk iteration with the unmap
> operation, which does not seem fine to me. It also appears
> to affect only corner cases.

Agree. There may be no performance gains, so I also prefer to leave it 
as is.

