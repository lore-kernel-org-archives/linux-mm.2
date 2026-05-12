Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B46ACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331986B008A; Tue, 12 May 2026 03:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3086B008C; Tue, 12 May 2026 03:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9766B0092; Tue, 12 May 2026 03:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2776B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:57:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91CF28BFE7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:57:25 +0000 (UTC)
X-FDA: 84758012850.13.57C2D90
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24B2B1C000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:57:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=khnEacOL;
	spf=pass (imf20.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18v/4uyxXIQTQZIdA2LvZajSRQjs5bWxtdt9Zd58gzE=;
	b=nbE1VLukf4oVdWCFG6YqaN7SRUEALunnR0djJ3nOk9wp0N5aGT5um6lJw6cXBXNCsfOsfC
	EJ9dpWaQ8Jl1XHmO2H2+M1xFBnSn6YfPt8LacpoSjtxNknrzb7cW+z+eb5jNZnqMDOyQ9H
	toSq38OiqGRLjUFSbvq93cyuqBdh7Uc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=khnEacOL;
	spf=pass (imf20.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572643; a=rsa-sha256;
	cv=none;
	b=47inc6RTyHSxBmx7FjYAAwY7MyBq1UendBBgYAN5oi1yu3MUyxEGpzWfSxBgf1jXyzkOvO
	PvY5gr+EKGxhnmjRZY1v1Pa+CFJbyOhgwpWMceBKOLfG5tbp52AhmQ5fOXoDG4KdyCuj+H
	YrzuwREJpU/caSDTz1K8f6kjS9TPj9A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778572639; bh=18v/4uyxXIQTQZIdA2LvZajSRQjs5bWxtdt9Zd58gzE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=khnEacOLFQ88wMiptEgM6OKn8BgbyaNY+pcjm/fl0I0GW3q78nxOOIorLCLu+jebL
	 B3gvdlRJDgYMFiyVfrlIcexZE4GZUBIuGj5Rp2dVPB8FqYT5uCJyhK0KbGiUgwOldo
	 3t/Z/+BqbrR9L4y6F3UNelXo5ceij6mViEDvr1ZI=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E4F82C3A; Tue, 12 May 2026 15:57:15 +0800
X-QQ-mid: xmsmtpt1778572635tz51ckzcx
Message-ID: <tencent_FFCDE2856BFC5941B165FEC5837B44E72605@qq.com>
X-QQ-XMAILINFO: NAOky/E1C/NcX06iziEZYctycAzJNqm69aygWL2QPFhVmT0l5oI4v6oiGQxpXW
	 YdQOdmJbRNpfPu8LAEPPFWMQQPwy3pxVjagaLI7Z6NdBSO0uSn1wI5X/TDLNFlliuBrM1nNRaeP0
	 xN5A+JIdAMS6Yz5AF/CPBlIhHH2IehgXZb3gz1x9R8eaSCLv0GOVQVWpkWfHpniLLDcuMMoO8ypr
	 Cdjd9zzgk25KiWVBvS8bxVHNNiRy86eEz/kydqWv9AlcRx/90yq8aLYdjhnSBQW+XYddL9dozgNU
	 smh3Jed3pizkoEQIQXJtht2hrdi5fVnC8uERrY9fygOdiFxvIMJ2j2qxvXiCLSc4tp3EUXW2VIy3
	 5IUs6OcmcvKAEFq2PxMxq8AjDz5ok7Ycr/qJAAn3rPtrKDL/h5Gv4XPiwJADOXoA2+juwTivTB6B
	 Z94/93xlIO4A3ozAygjLEviN2qMvkpi1LEQAnwd0TvjqfAQnnu3pgbE77Wuy86ENgrcfzgnCm8h3
	 VQUBYf6rL7eRJaiig2tr3SyxZnVDuJGB7HCR+iWsDl1dnisFy66bv+16wOEMdfBMYiOalWO2CMWT
	 hE3p8VNa9zWZ2bxXz64yAfs0i261dmF5YR/K3yTUlChk3HqOgLlEue76YHhh3q93PANFszVwE34S
	 XsN4NNY0Idyp6qSeOkxMscX1CNvnPJ99hZUBlkAiaP+7G+Sngek0MKQTvqhr0MjRx2s9sMk0fkhP
	 5ej/oPkzRYOL2wPvCMYkuw8A32Uqv/fYNjGWYbgmVD1Am/b/dnj1ILmUWFmAMUr0AOni0scpb1qo
	 EmcVFnz859xS9q1PBsKAVeIfOiCloV1SyBfuvsAf60Eg0+h+M09tqiGKJc8YXOJagrlm97hnXHQX
	 oZyG52+MG1rGTgniNc4XavD0VS67v9sA4TwF9df4kCY83r2fg5CV4zeicw4iDKopmL0YZh/lp2Yq
	 p9blNnSLk9+nOvL/rjEjVRz8uNNcvKNhHhPSfMOjYYbE5zmerPemdGs/u6IB1vXS1sRWDVmi6n/X
	 zVb1JHVd5L1vPywosaAbCLo6jKeaxEeGjFIzmo5HikNmXlsLaBCvStlZVwzSZwzBpVbyqzvA==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-OQ-MSGID: <c761d333-d921-4b23-b099-af1cd0cdc977@qq.com>
Date: Tue, 12 May 2026 15:57:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/5] mm: swap: fall back to order-0 after large swapin
 races
To: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 Yosry Ahmed <yosry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <tencent_CD11FE9B4A0B362E95E776C5F679598FAA07@qq.com>
 <24edd9d6-99f2-4d3d-83eb-69b406f4a9a0@kernel.org>
 <CAMgjq7Cokjb4-F9=cvwKmWR0q4==Vd61FHnjKbRdSHKH57erxw@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAMgjq7Cokjb4-F9=cvwKmWR0q4==Vd61FHnjKbRdSHKH57erxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24B2B1C000A
X-Stat-Signature: cui8zor3zgqgamtau1o4ckuht95gpkko
X-HE-Tag: 1778572642-452864
X-HE-Meta: U2FsdGVkX1+7ObSlQ2j7r0Q1xh13czEgLyRw5lMQ8rrEmV/5pfEy4SPZermGqNi9qtXBMaN968Ev0ebIzMgQi8PVw19vkR4GUw6RpWVVa9Hk/P4AAcWunx5rk2bzZuxIxflbQH3Doo1kMbKqTwMACzPKGzcpy0a3q+jImKbwVrMDAQ40ScyFXBTPG/nr5gF8Cjzp1vN+IqBiO3wPd7UWoLZ1PpSafvOiFjQqqpFaqLznPInEtbdA2KdQ3mZRwF/XMQJezbxwSw+tVAlYGhwTI6Swzek2XA2AsPGQcX1IWte8dTM0y8LGw7iHetQGmsfhBkT4v4aHPTDyN/pjgDIGU56e0sxM+ZcBPyy+67gy29pdEIOlPN19Flk4YuaasU5f7WSwFozrY3Os+cJWiQQpgQU28J/jL9zlcnuBZSM3CK3pbM8w7ml09/LmT1W1aceoGMzE0DXIb6vb++v8QOioefaPBS27cf8MPzzNEqlTo4yOASnbbLmBk4GegmdxFepmNw9VfOa0LLii125DppMcRUbI1Z8HvRtK7vmH9iRiKI/BS2iKxIy0C6tCZFbXv2k4Lb/fpuvlQMY9wQST6EPj6KF4+qrLo4GQ7zX8O8T33ld9XJn+3kATS9zQjE56ORQlFryXclGqk4g91SWOzJ+hYqaMWg/qIsVK1d5aEUSPhm/BqWjo1J7oovi4h041JX9dilHFxjlV8//v6xeroCHJUkPZ6kQrxvmBgafjBOUitW9W8XqSc16qzZJODFQv+9o+ZnVmxKgjRyIlw5V9vZm0aXLFcYHr4OGJIatW/g55Q13fKJlP1vyiGexAaBitfWjisb1L5JUBzgs0Nsu0uGwV3WYNGCAUOJgjKRw8wyk3Zi3ZoR9X3TBEIQXPKUWqwF34yzB1O7hgI9MJTcBayNp2/OqczJKySC2t0rIWOBNNZpri2b2vEVxeOyYr5K3IVvykVk4ffAWXo/ZQEjl3Zr3
 4d2GlXiq
 qWhi16Aw1TsMf/LUhhHsaKb8N853ibwrIPFbjyKvnS+8GkHq98tRzD4jd5ar7GOvc2Scc2IpT9A43CJXRBlWOjUp8F/ZLiiDY2oS8WB2FbSg+IbNLlqxN5ko1mNjHOPfURlP6rWKR5rbecKyE0q2JwiTv2s8Xhpw01AKzt/+2rVs16UDA1aLM0oGV0IzQikpZbuxBS9Pz7jQt/jBfnMT8etrE4tDBHQs5W6w1dieFgRzYWfYuKaGUT1BsGfpVfPGPsz6PGNSgSq5IW/BJ0tUc2O9anpFXNdMfkiRIfoHzpzGWKIR3s3lerJYFAgXnRRiRPyPrXgWZweojefTSdiBdevVvb8LC8t57bqKLLhrxsXPl4rwyvfr3qhpR4pjK1xZG1YyD74EeZnIqI2snlLY6T5nNaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 10:59 PM, Kairui Song wrote:
> On Mon, May 11, 2026 at 9:14 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 5/8/26 22:20, fujunjie wrote:
>>> swapin_folio() documents that a large folio insertion race returns NULL
>>> so the caller can fall back to order-0 swapin. do_swap_page() currently
>>> turns that NULL into VM_FAULT_OOM if the PTE is unchanged, which is
>>> harsher than necessary and gets in the way of rejecting large folio
>>> ranges for backend reasons.
>>>
>>> Move the synchronous swapin sequence into a helper and retry with an
>>> order-0 folio when a large folio cannot be inserted into the swap cache.
>>> Count the event as an mTHP swapin fallback before dropping the failed
>>> large allocation.
>>>
>>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>>> ---
>>>  mm/memory.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
>>>  1 file changed, 39 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index ea6568571131..84e3b77b8293 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4757,6 +4757,44 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>  }
>>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>
>>> +static struct folio *swapin_synchronous_folio(swp_entry_t entry,
>>> +                                           struct vm_fault *vmf)
>>> +{
>>> +     struct folio *swapcache, *folio;
>>> +     bool large;
>>> +     int order;
>>> +
>>> +     folio = alloc_swap_folio(vmf);
>>> +     if (!folio)
>>> +             return NULL;
>>> +
>>> +     large = folio_test_large(folio);
>>> +     order = folio_order(folio);
>>> +
>>> +     /*
>>> +      * folio is charged, so swapin can only fail due to raced swapin and
>>> +      * return NULL.
>>> +      */
>>> +     swapcache = swapin_folio(entry, folio);
>>> +     if (swapcache == folio)
>>> +             return folio;
>>> +
>>> +     if (!swapcache && large)
>>> +             count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
>>> +     folio_put(folio);
>>> +     if (swapcache || !large)
>>> +             return swapcache;
>>> +
>>> +     folio = __alloc_swap_folio(vmf);
>>> +     if (!folio)
>>> +             return NULL;
>>> +
>>> +     swapcache = swapin_folio(entry, folio);
>>> +     if (swapcache != folio)
>>> +             folio_put(folio);
>>> +     return swapcache;
>>> +}
>>> +
>>>  /* Sanity check that a folio is fully exclusive */
>>>  static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>>>                                unsigned int nr_pages)
>>> @@ -4860,17 +4898,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>               swap_update_readahead(folio, vma, vmf->address);
>>>       if (!folio) {
>>>               if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
>>> -                     folio = alloc_swap_folio(vmf);
>>> -                     if (folio) {
>>> -                             /*
>>> -                              * folio is charged, so swapin can only fail due
>>> -                              * to raced swapin and return NULL.
>>> -                              */
>>> -                             swapcache = swapin_folio(entry, folio);
>>> -                             if (swapcache != folio)
>>> -                                     folio_put(folio);
>>> -                             folio = swapcache;
>>> -                     }
>>> +                     folio = swapin_synchronous_folio(entry, vmf);
>>>               } else {
>>>                       folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
>>>               }
>>
>> There are some upcoming changes with:
>>
>> https://lore.kernel.org/r/20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com
>>
>>
>> All the of that logic you have in swapin_synchronous_folio() should ideally not
>> go into memory.c, but into some swap specific code.
>>
>> But
>>
>> https://lore.kernel.org/r/20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com
> 
> Thanks for mentioning this!
> 
> I think Junjie's change fits better after that change indeed. And I
> checked the code, it should fits easily too.
> 
> It's already strange enough that THP swapin is bundled with
> synchronous swapin, we better not make it more divergent here, and add
> more bits into memory.c.
> 
> And this commit will limit it to anon, no shmem, which is another
> strange detail. Or we'll have to repeat everything and copy these code
> to shmem.c...
> 
> Once all swap-ins uses basically the same path as in that series, all
> swap-ins will be able to have similar THP and zswap THP support too.

Thanks David and Kairui.

That makes sense. The helper in memory.c was mainly added to demonstrate
the fallback needed by this RFC, but I agree that growing more large-folio
swapin logic in the anon synchronous swapin path is not the right
direction.

I will not carry this patch forward in its current form. If I continue
with this work, I will rebase it on top of Kairui's swap-table or unified
swapin work and keep the allocation and fallback handling in the swap-specific
common path.

I also noticed Alexandre is already working on the large-folio swapin
side, so I will follow that series to avoid duplicating work.

Thanks for the pointers.


