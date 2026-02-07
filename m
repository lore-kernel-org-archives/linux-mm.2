Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BBEEE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 21:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F356B008A; Sat,  7 Feb 2026 16:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD606B0092; Sat,  7 Feb 2026 16:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DC16B0093; Sat,  7 Feb 2026 16:38:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE1A06B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 16:38:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA3F61A04CF
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 21:38:36 +0000 (UTC)
X-FDA: 84418975032.24.2EAAA68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D93D78000E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 21:38:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqQdBh9s;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770500315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3c+ke1+1YRs9ZPfmTKL7Kv76NCMB4fpCYmnUMfkl5A=;
	b=TGwMGgSTmeP6yibx9Qai159FqUXPcKwOdmsWOZFlu2fPGYTmg3kFIGrmoX61Wo968INrsU
	FMOSJt9Ht2LMFo+tawMugAbL9oVZnc1JauEyZuUpIjzHqCcJRxZx0sMTvndqQCquiplX2J
	nnrcJT0zxi6OksCWraO6ZuSTNG0saGc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqQdBh9s;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770500315; a=rsa-sha256;
	cv=none;
	b=QTBLadBw1HtFOR0uAaGS1DATi7aALlXHPpCqynugb65r8obFafZn+7Y6fTDvgUMNtvcdlH
	T9wlO8DCeCS7N35fNaf6SvjD4TLBoYfFQLaLmF1tbwjfHrisiRAp0AB3wO34el/TSXLyMY
	ZVyV+KB/8NXLEo3YGHrSDlquiNpmjZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 000F24449C;
	Sat,  7 Feb 2026 21:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D905C116D0;
	Sat,  7 Feb 2026 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770500313;
	bh=WL8RKMbXY74d2CMJPJNygFuS7ayXvrx45a6R7LYDj/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oqQdBh9sl6T/WoQmTaqwSb+Hf0W7EvI/kz5P31jLzegkKDtz2Ljid8W0a6qZvnbdH
	 eh1iE41dYG47VNOpmCQZCYvp9S0EbWv4zIhmPQGuuYHEqA57hGvaJycE2ykfOHa4iW
	 raj3idE2OVz3b6S7FnTiM+vfW54nZvXs0fAMPWFmZjQAJEr2z0EEGBo/L7rM1W/dgD
	 oAexAibCpB0/ZsKxrnQW2VWR9Kz8Y2pDd2ehZjP5DQqbDefH+p0w73/85XuGLf1mET
	 htAEXO7MRYF67M6LBaqMqGw9PkiMXaG3vxVURvUTUzoTe6JqMIrNZCenwDS9evvaYZ
	 N3C0d6yewvc7g==
Message-ID: <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
Date: Sat, 7 Feb 2026 22:38:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: Lance Yang <lance.yang@linux.dev>, Barry Song <21cnbao@gmail.com>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bwhocwkcwboyde7dgfbto8w68eunob5q
X-Rspamd-Queue-Id: D93D78000E
X-Rspam-User: 
X-HE-Tag: 1770500314-766310
X-HE-Meta: U2FsdGVkX19/8icHJSqhOTi+edVzN0FozkIVqHsnouNUpXCj7zQnotpNaHEenjuqdiwayLr5pMbvwTBKo3zFCMvqqtwGpgdr/Jm6h4UuoV5HS9lmdK1AWz6kp1TGGrNbd0GkjF0NPUNWdG+toC3j2PckkVA7vRQOnnaPsYpI3agNJWhuax60dIDol0lOHxmkWP11m1bFDDWKyIh6v84SlQGeWBTR/y0sKS0zaCrJPbrjSLlQhnDzekcacCgAXF00OK9aBC6HxQ22aMoYJHt6s3nWkPnOgbH/+kFkspoCvltN0UNH7HbZ76TCTndWD2QNIpK+PcenmaGo266CHl6vXJHTPxdw+Vdh1IAOZIrkLQ3heDhIQira9QDLRoh7qG2tM6TDn1Iwqvj+hEnbJlx0QcDjL0jm5a6O2wxOzvbxti3lcwLaP1IL555L5ofegE1rzTVacfBox4d+JCcVsKjBoJBz+HRDbfTDfuF8KTNj97v2IcKN2ehxFR1HsLgIsKpasRRo5ip3KWaHwWDslCk+gBUzinthhNXT2vs0aA/EDNPIOk+kVKIB5CF1IK9m931DEVBWncjM6kTpI9GwHpAq3PKCKwzYyP7j44eMua01kNH/vxKh9Ehv6ZZFWTBK8mHa3yiQ8ZEC/DvtpzHbLbJWW5M4szD7dH6nfSv/KNi+WWhCiWl1V8RuDT2vKGnn8YW5X9ToqbhuOpROoYepncEBlWx/+TucK7tU6Y6/CrAbjuJs67khafbxvKkNDTlx7eY0JlojVsE0S2MY1sCbmh4lSd8olGMQxEyCuPfM9EdWwrUXvfyDp0Sauw609KO7bavWVklhZks1bLV1ST88V5Hhdvj29TlMPyU4PsPSZSeYF+z7IIRQvBn1aXfuit87Y6DJ5WjQKddEe4cFMwgdLo0J17ZxVzTHKiXgW8g/hwHqd8eWEs2MvSBG7jPizpJ2D+kVYdXSeYXAOt/f57fV4bl
 DP1wtCyG
 RX525JyV2vtS48HrKtFa3XH7SceYdJN5w0jFsWAlQpkT3/ZHXBQKi5uZATzSvKOCesV2U/v18V+nPgkGt2wNjcFXg9M4bnYB9IlflAaIDV10N/dAfoujrcagPEvB8LrOOrJpWV4AiS5/Y5sEuo8YMDXhWFqXILfGt75gYymlPB6uskJY7pxn8V5UyoGfFG4Krc4ek8OX0veZo2Tlz5hw1jZTOTZdxlxp6PN9NlLYHaoctUlmQjNndR1cXcs2cQoElO398QlLvnheJ5Oh2wFtrEbLNf1i2Gh33BK3yfoEaPnyIWbAbxiZklEu0n66xlA5W1K/UqGY7+krz/C0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 14:51, Lance Yang wrote:
> 
> 
> On 2026/2/7 16:34, Barry Song wrote:
>> On Sat, Feb 7, 2026 at 4:16 PM Vernon Yang <vernon2gm@gmail.com> wrote:
>>>
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>
>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>> continuously access 128 MB memory, while the cold task only accesses
>>> its memory briefly and then call madvise(MADV_FREE). However, khugepaged
>>> still prioritizes scanning the cold task and only scans the hot2 task
>>> after completing the scan of the cold task.
>>>
>>> And if we collapse with a lazyfree page, that content will never be none
>>> and the deferred shrinker cannot reclaim them.
>>>
>>> So if the user has explicitly informed us via MADV_FREE that this memory
>>> will be freed, it is appropriate for khugepaged to skip it only, thereby
>>> avoiding unnecessary scan and collapse operations to reducing CPU
>>> wastage.
>>>
>>> Here are the performance test results:
>>> (Throughput bigger is better, other smaller is better)
>>>
>>> Testing on x86_64 machine:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>>
>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>   include/trace/events/huge_memory.h |  1 +
>>>   mm/khugepaged.c                    | 13 +++++++++++++
>>>   2 files changed, 14 insertions(+)
>>>
>>> diff --git a/include/trace/events/huge_memory.h b/include/trace/ 
>>> events/huge_memory.h
>>> index 384e29f6bef0..bcdc57eea270 100644
>>> --- a/include/trace/events/huge_memory.h
>>> +++ b/include/trace/events/huge_memory.h
>>> @@ -25,6 +25,7 @@
>>>          EM( SCAN_PAGE_LRU,              
>>> "page_not_in_lru")              \
>>>          EM( SCAN_PAGE_LOCK,             
>>> "page_locked")                  \
>>>          EM( SCAN_PAGE_ANON,             
>>> "page_not_anon")                \
>>> +       EM( SCAN_PAGE_LAZYFREE,         
>>> "page_lazyfree")                \
>>>          EM( SCAN_PAGE_COMPOUND,         
>>> "page_compound")                \
>>>          EM( SCAN_ANY_PROCESS,           
>>> "no_process_for_page")          \
>>>          EM( SCAN_VMA_NULL,              
>>> "vma_null")                     \
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 8b68ae3bc2c5..0d160e612e16 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -46,6 +46,7 @@ enum scan_result {
>>>          SCAN_PAGE_LRU,
>>>          SCAN_PAGE_LOCK,
>>>          SCAN_PAGE_ANON,
>>> +       SCAN_PAGE_LAZYFREE,
>>>          SCAN_PAGE_COMPOUND,
>>>          SCAN_ANY_PROCESS,
>>>          SCAN_VMA_NULL,
>>> @@ -583,6 +584,12 @@ static enum scan_result 
>>> __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>                  folio = page_folio(page);
>>>                  VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>>>
>>> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
>>> +                   folio_test_lazyfree(folio)) {
>>
>> We have two corner cases here:
> 
> Good catch!
> 
>>
>> 1. Even if a lazyfree folio is dirty, if the VMA has the VM_DROPPABLE 
>> flag,
>> a lazyfree folio may still be dropped, even when its PTE is dirty.

Good point!

> 
> Right. When the VMA has VM_DROPPABLE, we would drop the lazyfree folio
> regardless of whether it (or the PTE) is dirty in try_to_unmap_one().
> 
> So, IMHO, we could go with:
> 
> cc->is_khugepaged && folio_test_lazyfree(folio) &&
>      (!pte_dirty(pteval) || (vma->vm_flags & VM_DROPPABLE))

Hm. In a VM_DROPPABLE mapping all folios should be marked as lazy-free 
(see folio_add_new_anon_rmap()).

The new (collapse) folio will also be marked lazy (due to 
folio_add_new_anon_rmap()) free and can just get dropped any time.

So likely we should just not skip collapse for lazyfree folios in 
VM_DROPPABLE mappings?

if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
     folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
	...
}


-- 
Cheers,

David

