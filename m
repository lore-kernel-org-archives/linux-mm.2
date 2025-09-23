Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D18CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 12:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F47C8E0020; Tue, 23 Sep 2025 08:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4CB8E0001; Tue, 23 Sep 2025 08:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5945C8E0020; Tue, 23 Sep 2025 08:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 451118E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:04:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E15AF1396FA
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:04:42 +0000 (UTC)
X-FDA: 83920383204.01.AD9CC99
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D716A0004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:04:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RYNpYPHd;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758629081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gk6eqZAFbX16sas/2kwE2G4a7ts2lJRHO7QXaYrFraE=;
	b=T+uIuQFOLAGKs0U/5tqWCKWWQKAsnk4mKb1D3nYmEC1f5PjRS9CtCQAXoAAZOtnZLoYGYf
	IvnKQVnfFiek3vEMH8ybf5s8WPqOzX3yTHIVxbGrA7ns9j0/wyreaA1KN+8xTPDDz9b8HY
	GerFlUwaa21GSBgxiovOFOS2Ee9ib/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758629081; a=rsa-sha256;
	cv=none;
	b=LncDBtash/jfxj79SniDfKrWEfUJ5mI8Z3AOuU72BQ5y8UxoLqxzB18XLopcUDYRAc83v6
	2yWI1UAB360AJeh46SqnetRLbAgzM+Y7naAHRqmPHZv9RtYk9AYroOkIKnHZzdLS5CFieG
	CAOVppZScoO+iFGRA4UKom+n6wZkjaY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RYNpYPHd;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <3734c5a7-6b3f-4af1-ac35-6bd680823be5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758629077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gk6eqZAFbX16sas/2kwE2G4a7ts2lJRHO7QXaYrFraE=;
	b=RYNpYPHd2k0bh9y0HCKQd4gHfuRL/axnDG6gO211K7wPMxOmhySDA/74pfMz2VMbDhK3x8
	ZnAbmEezV0E2kHK7kw/VT5JJClf3+ebKpPD6F7Rj60cETRvmVVrKada7NfskvXxs4npNVR
	x5REP7lHguHRrQ6JhP1YbRbGmWx3H+U=
Date: Tue, 23 Sep 2025 20:04:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
 Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com> <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: knokxphupcfuz79xj96jheb8qj5a7iqs
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D716A0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758629080-303668
X-HE-Meta: U2FsdGVkX186E9X1Y/WTjXX5PZXZ5Inh1r5Eei1SJPSHQ+GHqFpBmDfCPmFbJ1cO1fI4++BKDtqYuUmmk2nGS+ulneHS9CHQXYo1Nco3vNvDXVrLJ2gbfe/qgS8Q8mmzc2Hn73HK3RoiXsAKUWJFaInXnabkSnUk6LY2P2mCXAA6FEDkyX49SvrYetFFLLXPZTFEFa1QafLPdOf5vYkORSTX8GMMyhXfxdr3vB8t3VxOK+OYYd6tjm5GdZyvqCYqul1KT4lq7itkImEOHkx6c43vXhorjXyvyITAdk+KFglKBPD//LCD5Xcw/KnFBu5/v/HHBM0v4ApuXXHIZturYQmmcBerBbdhReZhNQGscMvQKAxRMCnymaLDDTmSJqL0HYitCHhVs9b56vCQ0mjPq7pOJhKMmNxYnO//YFFzzfFk4xQbk/RP+0/5cFUolrjqGDXtfvQlcliz+T/aGQFBtfOirk3YDc98jhIXSTYoT733H7wEstioUKtqi1oOucQCGUclC6cHpn/17/NrD1cB5pEMENClOLtuZagrkB0mSL4Vb5bFtx9GApoBMVpQqRgakzE36AuwuRHAvuOWPW/VshopdYtPz9rKwysLxXfJpJv4lp9hi80SMK67vSgk1/42js1Zl8A+p9mAQrL/rjVLPISrhKeVU6280lWI0zCpM2BS5e1/wh2eWALpEy6XVwisp9SdpvmBmGA1O0z/LsczdA4aP4yYNKK/BeRsOaAdYVfed3WOjBBZrXwFND/hcl9/xRW3/X7Lxy0zsjdd+3SZBflu/XBm8iLZcBtsT8EcXL1gSK9LDBjg5+Nr+q4dwVzl4cxr2ghAMGesb+4CRuFjTKeW7GKkuB5x78SrTWBtfuMz9WabPt2Yl2dUmPYxXEmFWOtKDTET4HN/fLvXNWrzT1GDYAJUoTf0AaXXVhHEW3uIINkKJA7QXI8VeJTG4tZ3joC0AraGSmJKFJRbcsz
 CSCMud4C
 whHcJEQWU7LJbQJrJ91guW2qHpwEKxcorUaz46feFZ0kZiYHjwGFK8BcfQafT+RnmT6ZJnxFbVE4Vcs3Z14tMVkxUTcF3+mbfY1i0Fn1NKc6IKhkV2WXePtUFN3EEaFnAUpmxo0GTbg8YVOPbdtA6o90xC8yyQh1ik5OZcMvOGbuF076bMBHJFHZM7Y8n8yy8dgT20rZmWffTjpe1yBBGyik2ScpCvv3GrFeLHzhDm77T4NZNh+q1xf1Es/oHtzsyy2TSPEvvdAnCHEanvf2HCsXW7Iwem68ZijTEJSQCpEYKVFb8bae+4pvdcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/23 20:00, David Hildenbrand wrote:
> On 23.09.25 13:52, Catalin Marinas wrote:
>> On Mon, Sep 22, 2025 at 07:59:00PM +0200, David Hildenbrand wrote:
>>> On 22.09.25 19:24, Catalin Marinas wrote:
>>>> On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 32e0ec2dde36..28d4b02a1aa5 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -4104,29 +4104,20 @@ static unsigned long 
>>>>> deferred_split_count(struct shrinker *shrink,
>>>>>    static bool thp_underused(struct folio *folio)
>>>>>    {
>>>>>        int num_zero_pages = 0, num_filled_pages = 0;
>>>>> -    void *kaddr;
>>>>>        int i;
>>>>>        for (i = 0; i < folio_nr_pages(folio); i++) {
>>>>> -        kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>>>> -        if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>>> -            num_zero_pages++;
>>>>> -            if (num_zero_pages > khugepaged_max_ptes_none) {
>>>>> -                kunmap_local(kaddr);
>>>>> +        if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>>>>> +            if (++num_zero_pages > khugepaged_max_ptes_none)
>>>>>                    return true;
>>>>
>>>> I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
>>>> former will need to read from two places. If it's noticeable, it would
>>>> affect architectures that don't have an MTE equivalent.
>>>>
>>>> Alternatively we could introduce something like folio_has_metadata()
>>>> which on arm64 simply checks PG_mte_tagged.
>>>
>>> We discussed something similar in the other thread (I suggested
>>> page_is_mergable()). I'd prefer to use pages_identical() for now, so 
>>> we have
>>> the same logic here and in ksm code.
>>>
>>> (this patch here almost looks like a cleanup :) )
>>>
>>> If this becomes a problem, what we could do is in pages_identical() 
>>> would be
>>> simply doing the memchr_inv() in case is_zero_pfn(). KSM might 
>>> benefit from
>>> that as well when merging with the shared zeropage through
>>> try_to_merge_with_zero_page().
>>
>> Yes, we can always optimise it later.
>>
>> I just realised that on arm64 with MTE we won't get any merging with the
>> zero page even if the user page isn't mapped with PROT_MTE. In
>> cpu_enable_mte() we zero the tags in the zero page and set
>> PG_mte_tagged. The reason is that we want to use the zero page with
>> PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
>> memcmp_pages() messed up KSM merging with the zero page even before this
>> patch.
>>
>> The MTE tag setting evolved a bit over time with some locking using PG_*
>> flags to avoid a set_pte_at() race trying to initialise the tags on the
>> same page. We also moved the swap restoring to arch_swap_restore()
>> rather than the set_pte_at() path. So it is safe now to merge with the
>> zero page if the other page isn't tagged. A subsequent set_pte_at()
>> attempting to clear the tags would notice that the zero page is already
>> tagged.
>>
>> We could go a step further and add tag comparison (I had some code
>> around) but I think the quick fix is to just not treat the zero page as
>> tagged.
> 
> I assume any tag changes would result in CoW.
> 
> It would be interesting to know if there are use cases with VMs or other 
> workloads where that could be beneficial with KSM.
> 
>> Not fully tested yet:
>>
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index e5e773844889..72a1dfc54659 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page 
>> *page2)
>>   {
>>       char *addr1, *addr2;
>>       int ret;
>> +    bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
>> +    bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
>>       addr1 = page_address(page1);
>>       addr2 = page_address(page2);
>> @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page 
>> *page2)
>>       /*
>>        * If the page content is identical but at least one of the 
>> pages is
>> -     * tagged, return non-zero to avoid KSM merging. If only one of the
>> -     * pages is tagged, __set_ptes() may zero or change the tags of the
>> -     * other page via mte_sync_tags().
>> +     * tagged, return non-zero to avoid KSM merging. Ignore the zero 
>> page
>> +     * since it is always tagged with the tags cleared.
>>        */
>> -    if (page_mte_tagged(page1) || page_mte_tagged(page2))
>> +    if (page1_tagged || page2_tagged)
>>           return addr1 != addr2;
> 
> That looks reasonable to me.

Yeah, looks good to me as well.

> 
> @Lance as you had a test setup, could you give this a try as well with 
> KSM shared zeropage deduplication enabled whether it now works as 
> expected as well?

Sure. I'll test that and get back to you ;)

> 
> Then, this should likely be an independent fix.
> 
> For KSM you likely have to enable it first through /sys/kernel/mm/ksm/ 
> use_zero_pages.

Got it.


