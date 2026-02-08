Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16641EF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 04:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A126B0005; Sat,  7 Feb 2026 23:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1A46B0088; Sat,  7 Feb 2026 23:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17846B0089; Sat,  7 Feb 2026 23:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0EDE6B0005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 23:06:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C924C1E6D
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:06:33 +0000 (UTC)
X-FDA: 84419952666.24.C78AD27
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id F257118000C
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:06:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MOWZ+ZGR;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770523591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnYuG1+aCX2u+rotI13J0ci1rd1Dt/+JxIlZC/9lbAM=;
	b=wksGydDwNI6TQf28rPqjBNlhHGCge7R3CmQ1oQ3/xjeOHkI0bawfOZ3AkLsdvpIpKFbxby
	7wYoK2GfdEkAOSjxqDMcVLTtJCiS7J+MMLPi4fLytAP7lk2oHLfjgmjhQEmjfi0Re/jPnE
	KGla9G3kmk05de1TFvCmuzmBn2i6J0I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MOWZ+ZGR;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770523591; a=rsa-sha256;
	cv=none;
	b=RV8eyaVdt6AHi3J67lwOvOjUbNubMk1cGg6fVPHkmK46uKo/iEl53SNEHXIzkiUcZsFAgN
	jzRNznq1ug1UWRMPhxeEEjNwFBviVa6hV61das+c28ADwW9BSxVW/iXBPcVAUB+G/sY+Nq
	TZnY8Awi0txaamhIR8MitOMs7O180ag=
Message-ID: <8e552bda-7d34-477a-8574-25a9183e6a92@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770523587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fnYuG1+aCX2u+rotI13J0ci1rd1Dt/+JxIlZC/9lbAM=;
	b=MOWZ+ZGRVIxwhBvWwqXiE1GX/wBAEPf8RKNCrjsekGsiUVwx1BvcGW/Rf8KVK4sQqLsGWl
	H/G5nwkddSNnc5LLFS3yF5B/X2Ya5M/cdciXEQ2qV9SJYFPk0XaPspy40oRv3TNwtoM84r
	r2tcaqmb7PY7g/HC6qunK/ko60lzqQk=
Date: Sun, 8 Feb 2026 12:06:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Barry Song <21cnbao@gmail.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev>
 <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: x5q9tpgffxsujheummgztgp9xaqzrbn6
X-Rspam-User: 
X-Rspamd-Queue-Id: F257118000C
X-HE-Tag: 1770523589-818513
X-HE-Meta: U2FsdGVkX1+sgs6z5puo72j8UQZ8kwn7V8Dg2UElHZjKIdd4o55fHnboNySm4oeD2tY+t+KZOSgxwT00rl3niV3Zgm7+US6hjaAZjQa2VBsD9EBc4lWhgtvS9yGr+9xRim5ne2SLBCxTaMvXm8LMYCTwFmX3UkcEuAXR3HLTYWLHuMTmjV5E1RWdXYxm+Iz8kWErEWx/cgp/XhWDn4J9hF6gBVFURa8AuA/mafn0J0dvDGsV1aqQaEKUdRH0yxjxQ4xBQ04cNg84YC0yzTZ+TWLp3FbkU9rOHn09sQsP4OKpkxGlmY4psaw+QIpdaRuKq911HdG4ZuKr8th91UjU+qeVm7SKsyrFyrC0d1+m46Pw7CrEdbbnE8z/isXusH9/XqldWsD5gPMH1jwiswO/uWbmvSh1nNCZ4vwFIg5EPsZavTvgXo9gyANExA9zv7yjAAv5byW0DPi3IHwDMuJCTpZvkl5IjQInjEd8iEeETPrOsiWYyveDegzw+CssCdiQUYjoTSjzEAvlmxlszB5CXiQ1fRjJZCFaYwHM0cK9zBnjGTxBmO6/HpAIjHxckS9mNhcsXd7LvpwS9zUwpvzqcMHehbLTtf1ssiVEuzGnkC1KwYuFCcl7DCQrpfXigMXiFxyozTNxUcEYDlaQc8WLw2ml7dL1K+jXOb8bSafPoOg85dhc1bAyfr/0xZ00brxNl44Dp9SYir6/3VWqOcdPlxg+kkih3e+F0ot3VCbCnB71YMFq0Nn0pO0sa3cXYASiUJcBDe6l4vfJIagmUfR1BVbU0nrZ8Bm51xwfKuRMKs37/ZUXu5ciOytmXgzYZhqcXoX7siUq30ovs93TJJNFdS1Q8wRlZ4t1VTTD8P0XMWzQgfQxMYj+2hNJNDGSZpqJK/9hPYId0dnjxUvW1anZyQagRHuooHRwl7ehLjbSjVFmTcx/8aeyvDrxTAD9omwDsoE8iDJ3rMd1VXSHYok
 dZiHwqub
 GKSYwvBO4yabpDpj8DYfIckpaiptuZFYGP5YMK7jzXjEDkVDMQlFoM8q55PbPAEOjYGco1BECxPym2IZ1ld39+H7ETpmCDrpNW3iT0Eyw37u7Uup31gLBN7AzNb7d/i6awyvn/avzn6F6dPM0ygHYDHC26slyVyKpbX+2qXtjQ0hSkbsdo4GaXTL5JtGBJNd4ow5nVWQVbq9mlv7tTiZ5zNtTuELtkb2VZO0uL4TSA2eghcK4AxmERd2ON1sGxcDuTIv82J8Bl4GyYra5TWOKizsjJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/8 05:38, David Hildenbrand (Arm) wrote:
> On 2/7/26 14:51, Lance Yang wrote:
>>
>>
>> On 2026/2/7 16:34, Barry Song wrote:
>>> On Sat, Feb 7, 2026 at 4:16 PM Vernon Yang <vernon2gm@gmail.com> wrote:
>>>>
>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>>
>>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>>> continuously access 128 MB memory, while the cold task only accesses
>>>> its memory briefly and then call madvise(MADV_FREE). However, 
>>>> khugepaged
>>>> still prioritizes scanning the cold task and only scans the hot2 task
>>>> after completing the scan of the cold task.
>>>>
>>>> And if we collapse with a lazyfree page, that content will never be 
>>>> none
>>>> and the deferred shrinker cannot reclaim them.
>>>>
>>>> So if the user has explicitly informed us via MADV_FREE that this 
>>>> memory
>>>> will be freed, it is appropriate for khugepaged to skip it only, 
>>>> thereby
>>>> avoiding unnecessary scan and collapse operations to reducing CPU
>>>> wastage.
>>>>
>>>> Here are the performance test results:
>>>> (Throughput bigger is better, other smaller is better)
>>>>
>>>> Testing on x86_64 machine:
>>>>
>>>> | task hot2           | without patch | with patch    |  delta  |
>>>> |---------------------|---------------|---------------|---------|
>>>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>>>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>>>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>>>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>>>
>>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>>
>>>> | task hot2           | without patch | with patch    |  delta  |
>>>> |---------------------|---------------|---------------|---------|
>>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>>>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>>>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>>>
>>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>   include/trace/events/huge_memory.h |  1 +
>>>>   mm/khugepaged.c                    | 13 +++++++++++++
>>>>   2 files changed, 14 insertions(+)
>>>>
>>>> diff --git a/include/trace/events/huge_memory.h b/include/trace/ 
>>>> events/huge_memory.h
>>>> index 384e29f6bef0..bcdc57eea270 100644
>>>> --- a/include/trace/events/huge_memory.h
>>>> +++ b/include/trace/events/huge_memory.h
>>>> @@ -25,6 +25,7 @@
>>>>          EM( SCAN_PAGE_LRU, "page_not_in_lru")              \
>>>>          EM( SCAN_PAGE_LOCK, "page_locked")                  \
>>>>          EM( SCAN_PAGE_ANON, "page_not_anon")                \
>>>> +       EM( SCAN_PAGE_LAZYFREE, "page_lazyfree")                \
>>>>          EM( SCAN_PAGE_COMPOUND, "page_compound")                \
>>>>          EM( SCAN_ANY_PROCESS, "no_process_for_page")          \
>>>>          EM( SCAN_VMA_NULL, "vma_null")                     \
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 8b68ae3bc2c5..0d160e612e16 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -46,6 +46,7 @@ enum scan_result {
>>>>          SCAN_PAGE_LRU,
>>>>          SCAN_PAGE_LOCK,
>>>>          SCAN_PAGE_ANON,
>>>> +       SCAN_PAGE_LAZYFREE,
>>>>          SCAN_PAGE_COMPOUND,
>>>>          SCAN_ANY_PROCESS,
>>>>          SCAN_VMA_NULL,
>>>> @@ -583,6 +584,12 @@ static enum scan_result 
>>>> __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>                  folio = page_folio(page);
>>>>                  VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>>>>
>>>> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
>>>> +                   folio_test_lazyfree(folio)) {
>>>
>>> We have two corner cases here:
>>
>> Good catch!
>>
>>>
>>> 1. Even if a lazyfree folio is dirty, if the VMA has the VM_DROPPABLE 
>>> flag,
>>> a lazyfree folio may still be dropped, even when its PTE is dirty.
> 
> Good point!
> 
>>
>> Right. When the VMA has VM_DROPPABLE, we would drop the lazyfree folio
>> regardless of whether it (or the PTE) is dirty in try_to_unmap_one().
>>
>> So, IMHO, we could go with:
>>
>> cc->is_khugepaged && folio_test_lazyfree(folio) &&
>>      (!pte_dirty(pteval) || (vma->vm_flags & VM_DROPPABLE))
> 
> Hm. In a VM_DROPPABLE mapping all folios should be marked as lazy-free 
> (see folio_add_new_anon_rmap()).

Ah, I missed that apparently :)

> The new (collapse) folio will also be marked lazy (due to 
> folio_add_new_anon_rmap()) free and can just get dropped any time.
> 
> So likely we should just not skip collapse for lazyfree folios in 
> VM_DROPPABLE mappings?
> 
> if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
>      folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
>      ...
> }

Yep. That should be doing the trick. Thanks!

