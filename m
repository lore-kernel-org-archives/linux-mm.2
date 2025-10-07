Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43111CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 10:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1CE58E0010; Tue,  7 Oct 2025 06:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CDEC8E0005; Tue,  7 Oct 2025 06:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90AF98E0010; Tue,  7 Oct 2025 06:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 81ACF8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:25:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FE851408B8
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:25:29 +0000 (UTC)
X-FDA: 83970936378.30.1BDBF65
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id 072B9180005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:25:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SqKqFZgI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759832727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1Qr/71x7vAffwB+BoaxiI5z0WOOCKgzr0UJkBVFUpE=;
	b=NA4BLDFIHhGio6b3DrYwiKG4piBhaAAuHGkA4KF3aNcTeT6JCAYEnhnKswiMkKJeByCe6N
	RJiBHiDQNyj8dS6Cfn0mllR9gX61p8bUgNCbs2WEy1UA7ldxhTxHPB56tWIS5HxnfT8V2+
	ecJy9ebetftSyoT2VDftIbjfgK0yy/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759832727; a=rsa-sha256;
	cv=none;
	b=vJvfKz/4ZDc4k6Be/1RNd9lBgu7xWUdHx2yxGuGdy8ulfF4CR+fPYcVQmv6AIYga9e0ZGr
	hR9b4Q7If4PoGZr3A+XXQcldZwhv0GD37xVAN/yXCYPrUMjTGaFzbuwXjzGDnSH/M6Nw5L
	b0ye7kTKGpVxRqQxVHMLhbkyNiZa7nk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SqKqFZgI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <29742109-13c2-4fa6-a3a1-d12b14641404@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759832724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1Qr/71x7vAffwB+BoaxiI5z0WOOCKgzr0UJkBVFUpE=;
	b=SqKqFZgIYKoV0S7J1CAQvyvkQcIPcwSyhGfTQdAamHUi4SyOW6IQF6JGbtTOkwnMkM1rcl
	6vugkpgjvz1qVgjBuy0wj17KViXX/gE9oDjC4CWp7PGYsMOmuHTQoaX1xWXdRN9rITI3lR
	Z5DDHIjcA2+A6I5UU0ZU9ouNNrA27yI=
Date: Tue, 7 Oct 2025 18:25:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
 <20251005010511.ysek2nqojebqngf3@master>
 <31c3f774-edb7-420a-a6a8-3e21f2abd776@linux.dev>
 <09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 072B9180005
X-Rspamd-Server: rspam02
X-Stat-Signature: nd6urtkduqt1dqziinckzkbfxyf8bnuf
X-HE-Tag: 1759832726-807227
X-HE-Meta: U2FsdGVkX1+io0XBj9iov7Hc3RBDeO2/qZfiLm/d0PxdmHVrAI9ly9Dt6MZjpWh0mLLp9kIBHF6tt/OPHNhZpE0g293ijk8pwoFF68NZwmiQmqKVoHADPuVFLzq4odcGhhNGqB4ANo5InyqkAolEfLp2hGzDO2b07iHVtTALOO7cRy9o+9L9uvd0//c8vyNoURf70+YynMVul1DmuhkYNOpcUXMk52COR9JdU2rNOTd1cbXAPk/YB/QjxCAEKRAlw3t5SpTvDC5kIN9eanTDfKDAC1HSk70ELifA2D0Py/gaQXbD423vZTGXu6fXISJza/M1xy58tJuXhqpJ3KUJmWNNpHQy3nBfPvNTA2fA7bmx9FNUTJjhbpkdm0pKDKnIQ+BKbFG2oiUc1ciXGzzLCxu/OLt/VgmTmRlrq+fZAR4K+7lRBU3vV4AxanG0ROb4GdolNdkUUihI/DzK/JZc7Vt3KPN1vqU92BicSTx0qNKNBwyqAuY2yuV/GiTl6DeabIyoqccXlGyrRLwp5bmzwOROcsUy8KfuJTnYAgmRo+Yk5k7FIcrJTOXKUvBdc5YgCWKQ2Dv3STTilh9VO3XwDPED5hA1YHT6NdIdsq9IghyREC80Y/yG53Fx1+TuK50tkCPK1oA/fckuMupI9yAglJ64vbsFm45HSu1dvMaXapgNJ13ojr2REoPwEffYSSWxMdatO+CmzRLeRb5QMofhD5f8Jzx2OtP591p8GpzE/ACoVRMr/rYG1JtqPHxL+7Qs8fGYdG9tdBBry0S/rPN0VKPv4A0XlzIreAkwxkJTyDH6m6sBL6ZJRR1JxkgSJr23fbIZSwy8K+tOILd+L4QsrWgswvPM89J7IYO759ZTqhWtqV0czHRIzA9QLF+mLj9y8n7LvHHnO8oYmTGGQ6PJpqBFsIRrbZ7U1/w4dm/9u3gZS1mSWeK3oUhJx2tcOS2J2e+S86a84oURgoZGRO6
 hknujaP/
 umO/hufKWv45xQvFewetpMdZlUJNbM2goaF0V+kKm4jdbQwkQMlzMzNWt4Hs1kJL8idg61VGjN9nDw94TmNKALVMCUCl/FmmCjRgiRMpoi+WPlYhh6AeR0rPcdyzWexiA6SNPLpy3uJGHEeYKq6DYW5UpA/MujDe5jGHOACFMtACUSbZAsaja26MXE1xhGkmlD2piKoriFMBK2C/HLDajVZcIGrBPgj+sUFitGs993UMTqbA/pRyzplugOAS8kit8iX9K4bmowntkLCyp3GgLag3mlndi3Gw3wLVXRHCa0qBb8PDwrdRbOx5E9bVw9I98M0jVDTUjGhcCJBytUNiCHK4+NwK+4f+zmXa8BqHwcLCqyQMyFDyBfotjqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/6 22:18, David Hildenbrand wrote:
> On 05.10.25 04:12, Lance Yang wrote:
>>
>>
>> On 2025/10/5 09:05, Wei Yang wrote:
>>> On Wed, Oct 01, 2025 at 06:05:57PM +0800, Lance Yang wrote:
>>>>
>>>>
>>>> On 2025/10/1 16:54, Wei Yang wrote:
>>>>> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>>
>>>>>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>>>>>> markers) are not caught early in hpage_collapse_scan_pmd(), 
>>>>>> leading to
>>>>>> failures deep in the swap-in logic.
>>>>>>
>>>>>> hpage_collapse_scan_pmd()
>>>>>> `- collapse_huge_page()
>>>>>>        `- __collapse_huge_page_swapin() -> fails!
>>>>>>
>>>>>> As David suggested[1], this patch skips any such non-swap entries
>>>>>> early. If any one is found, the scan is aborted immediately with the
>>>>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>>>>> work.
>>>>>>
>>>>>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb- 
>>>>>> a7c8-1ba64fd6df69@redhat.com
>>>>>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680- 
>>>>>> dcd55219c8bd@lucifer.local
>>>>>>
>>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>>> ---
>>>>>> v1 -> v2:
>>>>>> - Skip all non-present entries except swap entries (per David) 
>>>>>> thanks!
>>>>>> - https://lore.kernel.org/linux-mm/20250924100207.28332-1- 
>>>>>> lance.yang@linux.dev/
>>>>>>
>>>>>> mm/khugepaged.c | 32 ++++++++++++++++++--------------
>>>>>> 1 file changed, 18 insertions(+), 14 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>> index 7ab2d1a42df3..d0957648db19 100644
>>>>>> --- a/mm/khugepaged.c
>>>>>> +++ b/mm/khugepaged.c
>>>>>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct 
>>>>>> mm_struct *mm,
>>>>>>     for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>>          _pte++, addr += PAGE_SIZE) {
>>>>>>         pte_t pteval = ptep_get(_pte);
>>>>>> -        if (is_swap_pte(pteval)) {
>>>>>
>>>>> It looks is_swap_pte() is mis-leading?
>>>>
>>>> Hmm.. not to me, IMO. is_swap_pte() just means:
>>>>
>>>> !pte_none(pte) && !pte_present(pte)
>>>>
>>>
>>> Maybe it has some reason.
>>>
>>> I took another look into __collapse_huge_page_swapin(), which just check
>>> is_swap_pte() before do_swap_page().
> 
> Thanks for pointing that out.
> 
> A function that is called __collapse_huge_page_swapin() and documented 
> to "Bring missing pages in from swap" will handle other types as well.
> 
> Unbelievable horrible.
> 
> So let's think this through so we can document it in the changelog 
> properly.
> 
> We could have currently ended up in do_swap_page() with
> 
> (1) Migration entries. We would have waited.
> 
> -> Maybe worth it to wait, maybe not. I suspect we don't stumble into
>     that frequently such that we don't care. We could always unlock this
>     separately later.
> 
> 
> (2) Device-exclusive entries. We would have converted to non-exclusive.
> 
> -> See make_device_exclusive(), we cannot tolerate PMD entries and have
>     to split them through FOLL_SPLIT_PMD. As popped up during a recent
>     discussion, collapsing here is actually counter-productive, because
>     the next conversion will PTE-map it again. (until recently, it would
>     not have worked with large folios at all IIRC).
> 
> -> Ok to not collapse.
> 
> (3) Device-private entries. We would have migrated to RAM.
> 
> -> Device-private still does not support THPs, so collapsing right now 
> just means that the next device access would split the folio again.
> 
> -> Ok to not collapse.
> 
> (4) HWPoison entries
> 
> -> Cannot collapse
> 
> (5) Markers
> 
> -> Cannot collapse
> 
> 
> I suggest we add that in some form to the patch description, stating 
> that we can unlock later what we really need, and not account it towards 
> max_swap_ptes.
> 
>>>
>>> We have filtered non-swap entries in hpage_collapse_scan_pmd(), but 
>>> we drop
>>> mmap lock before isolation. This looks we may have a chance to get 
>>> non-swap
>>> entry.
>>
>> Thanks for pointing that out!
>>
>> Yep, there is a theoretical window between dropping the mmap lock
>> after the initial scan and re-acquiring it for isolation.
>>
>>>
>>> Do you think it is reasonable to add a non_swap_entry() check before
>>> do_swap_page()?
>>
>> However, that seems unlikely in practice. IMHO, the early check in
>> hpage_collapse_scan_pmd() is sufficient for now, so I'd prefer to
>> keep it as-is :)
> 
> I think we really should add that check, as per reasoning above.
> 
> I was looking into some possible races with uffd-wp being set before we 
> enter do_swap_page(), but I think it might be okay (although very 
> confusing).

How about the version below?

```
Currently, special non-swap entries (like PTE markers) are not caught
early in hpage_collapse_scan_pmd(), leading to failures deep in the
swap-in logic.

A function that is called __collapse_huge_page_swapin() and documented
to "Bring missing pages in from swap" will handle other types as well.

As analyzed by David[1], we could have ended up with the following
entry types right before do_swap_page():

   (1) Migration entries. We would have waited.
       -> Maybe worth it to wait, maybe not. We suspect we don't stumble
          into that frequently such that we don't care. We could always
          unlock this separately later.

   (2) Device-exclusive entries. We would have converted to non-exclusive.
       -> See make_device_exclusive(), we cannot tolerate PMD entries and
          have to split them through FOLL_SPLIT_PMD. As popped up during
          a recent discussion, collapsing here is actually
          counter-productive, because the next conversion will PTE-map
          it again.
       -> Ok to not collapse.

   (3) Device-private entries. We would have migrated to RAM.
       -> Device-private still does not support THPs, so collapsing right
          now just means that the next device access would split the
          folio again.
       -> Ok to not collapse.

   (4) HWPoison entries
       -> Cannot collapse

   (5) Markers
       -> Cannot collapse

First, this patch adds an early check for these non-swap entries. If
any one is found, the scan is aborted immediately with the
SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
work.

Second, as Wei pointed out[3], we may have a chance to get a non-swap
entry, since we will drop and re-acquire the mmap lock before
__collapse_huge_page_swapin(). To handle this, we also add a
non_swap_entry() check there.

Note that we can unlock later what we really need, and not account it
towards max_swap_ptes.

[1] 
https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com
[2] 
https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
[3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master
```

I also think it makes sense to fold the change that adds the
non_swap_entry() check in __collapse_huge_page_swapin() into
this patch, rather than creating a new patch just for that :)

Hmmm... one thing I'm not sure about: regarding the uffd-wp
race you mentioned, is the pte_swp_uffd_wp() check needed
after non_swap_entry()? It seems like it might not be ...

```
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f4f57ba69d72..bec3e268dc76 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct 
mm_struct *mm,
  		if (!is_swap_pte(vmf.orig_pte))
  			continue;

+		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
+			result = SCAN_PTE_NON_PRESENT;
+			goto out;
+		}
+
  		vmf.pte = pte;
  		vmf.ptl = ptl;
  		ret = do_swap_page(&vmf);
```

@David does that sound good to you?

