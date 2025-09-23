Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF51CAC5AA
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 01:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6C78E000A; Mon, 22 Sep 2025 21:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE188E0001; Mon, 22 Sep 2025 21:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE9E8E000A; Mon, 22 Sep 2025 21:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07A508E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:49:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90F701A02DB
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:49:15 +0000 (UTC)
X-FDA: 83918832270.21.AD35AAE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B9D540008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:49:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NsZlq29c;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758592153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiWATjJlRyNXagDcw5KRHJfeXKRLsAKy/bPmDguzbG0=;
	b=270mNV6+58PfOhlRaDEPGi0jj121A0k03M9DgisQmJzTGe7aZCDs7eTZzGcBej2vII/MKf
	7XncdT1ZJY0N77xwxtyHfv/x7zA7lJLlKr6jov3+wTd71/nv/Cjf3OdsNPxV3KRcmd7qxP
	BT36ByoP8lFnk5grW2e52p6kkQ042xI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758592153; a=rsa-sha256;
	cv=none;
	b=P6v7UQ5QWKEl81tt+BHlK+csSqCEzupxsI1PDBz8vDQt0m4fHijl5ziTz5/NEKRhe1LsUo
	IIq2wOLDRNytbKLZAXoHg2HJ875O8gg18kYdsIGcT4SWj6LS9hrAEYHQJzg205PFMxmHMR
	U2Dk7ZBFCJZnZPoP2PN4ig4GJwjRIUE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NsZlq29c;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9471bd83-911f-433d-8ce2-f83f080ed264@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758592150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KiWATjJlRyNXagDcw5KRHJfeXKRLsAKy/bPmDguzbG0=;
	b=NsZlq29cN7YJE4XCbL77ung8YpUPS/Ew9mPVomMh00fJjOeP0PekGP1EtxZgGpMCHL7cOg
	hn8YGsfqo2M5EI3luUBnZUXQOc4F7+KZLHXZfeHrkKaRVyvNSVVMtRyO46aE7/0e6fCf2M
	ugvJETzfOwEkWEw7g7wKHzc6mVClt/E=
Date: Tue, 23 Sep 2025 09:48:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ud3x9zepat83gtbu1cehtzodwqwjjw5n
X-Rspamd-Queue-Id: 5B9D540008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758592153-344367
X-HE-Meta: U2FsdGVkX1/BpmyOWD/9wz/M/Ccla0LkCTZ3wb+HuwFx07r8Z2Vpr2MljW14kQJcpBNwVT+JFriu0m//8/XNTEhU7UF60CeMckMC0ydRdFmbKcEh4wmdRhPAos+UCUy72zuonDbtEensETXM+JzNE17ak0GOy67Mj7yswyAOOR7/LytCq6mM1CAshkMOED8jlMN8DAlGQjsrAyJO5MP50aoIKlNjQOZlkp0BEoDBsm7aiLJdwznLDGHD/SK5Mq4fDdYyW6+lPYYTc20BEAaX20YnQqAN1ax8fQVSLdPOT7HWKnbrfqJlEJ3XRlFGzRq5BvtBRP3QgNr8YlacCQVo1134CFXx375aPdU9uuiVmiPsTgol38M7DOYlKdsNvz8hB7/r9bvG9kj2O9TxnUxG7t3n+yFvTmSklCNK4Ik5S18yoTBHCVeV57F4JS8C3C5nvKz9jK6OngqbC2U+ZnQ4RTiEbQFZUb49dAmc1IWasHlr3YbD7HDBG1alG9fSVRasOrHTMUZuRBReeXIYRIsMbgv6F0LYuUFwpVPRtnQKQJBuVNi4cmCUZCMB7o0WStttCXnstHG1cQqy+cnc1xOrljSpXkBFynZBxjB9PDjQ3wCI7e6JoszcHvPkjAE+v8DvDH6r2CHv8sOT1SQjlfJ0AAzzLKR6On4GsmIZHc5p1c94Y4GUKp00hcw3fZRXxBAGwZMMWyzYp+g7yxKNq25kVGV6H0G85wo8uCINC0vTF9mjNth0rn5IObWJG0mYWdG4FWrmxhRyasj0c35uAY4kGvQh2pOn3Uq9k/r+OVPsU0Khtdbe8zbjQmPU4nUtuje5QrtfI0PSrI91/PtYlZ5Yh3JJYcGCbpjwm5OecoMhG/F6iNnQJCfq0wzcibhgLBqGjH0/SSAmoYNpzOcR4muCW/QvZf3zx1k6DXn8/vARVhRtK189S8n1FvuuH1nqiQLBTEo1+JaM/xUxOrhXpqR
 DMU40Sn3
 0sjeP3j9FPanM6s847Czt9T0JDJhXQX5UWmHmql0UdMHpx0b3sHpTXPyTxTIroSRXaL7xWdzs4SwGRkecCV5U0eLFePgFpCB60deAXeAXs8yMaFM0iOnZffdh7B1KEbrctR9L0ExT5ShewMHVyYAaDYraIwkeiBCaEgd3COUOPydbDVqVAAeTglZfoKylWDyDaGv6H4luU0zrzzGqJqfcQ39yAlDs60JM+9f0E9Gp4T6VEv9f91GMlaS6B2OBl4ZuNyah51IVmhvSvB91vS9Vn6/fHsu2kmJYbuTGSpboX0PPR9RuscB8tt/LXpimKBuXqfRGj86dWCdQRI7okDxP1HTMfL6yrf8cSjklGaQe8EX7GQCCqT4HpYF9xnTxr9c7AftWsAskDvNlmOSSxvVFh0x6B0sce9Tkn8ERIrxmcL1yKMGecvNokP4iMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/23 01:59, David Hildenbrand wrote:
> On 22.09.25 19:24, Catalin Marinas wrote:
>> On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When both THP and MTE are enabled, splitting a THP and replacing its
>>> zero-filled subpages with the shared zeropage can cause MTE tag mismatch
>>> faults in userspace.
>>>
>>> Remapping zero-filled subpages to the shared zeropage is unsafe, as the
>>> zeropage has a fixed tag of zero, which may not match the tag 
>>> expected by
>>> the userspace pointer.
>>>
>>> KSM already avoids this problem by using memcmp_pages(), which on arm64
>>> intentionally reports MTE-tagged pages as non-identical to prevent 
>>> unsafe
>>> merging.
>>>
>>> As suggested by David[1], this patch adopts the same pattern, 
>>> replacing the
>>> memchr_inv() byte-level check with a call to pages_identical(). This
>>> leverages existing architecture-specific logic to determine if a page is
>>> truly identical to the shared zeropage.
>>>
>>> Having both the THP shrinker and KSM rely on pages_identical() makes the
>>> design more future-proof, IMO. Instead of handling quirks in generic 
>>> code,
>>> we just let the architecture decide what makes two pages identical.
>>>
>>> [1] https://lore.kernel.org/all/ 
>>> ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
>>> Closes: https://lore.kernel.org/all/ 
>>> a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>>> when splitting isolated thp")
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>
>> Functionally, the patch looks fine, both with and without MTE.
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks for taking time to review!

>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 32e0ec2dde36..28d4b02a1aa5 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4104,29 +4104,20 @@ static unsigned long 
>>> deferred_split_count(struct shrinker *shrink,
>>>   static bool thp_underused(struct folio *folio)
>>>   {
>>>       int num_zero_pages = 0, num_filled_pages = 0;
>>> -    void *kaddr;
>>>       int i;
>>>       for (i = 0; i < folio_nr_pages(folio); i++) {
>>> -        kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>> -        if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>> -            num_zero_pages++;
>>> -            if (num_zero_pages > khugepaged_max_ptes_none) {
>>> -                kunmap_local(kaddr);
>>> +        if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>>> +            if (++num_zero_pages > khugepaged_max_ptes_none)
>>>                   return true;
>>
>> I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
>> former will need to read from two places. If it's noticeable, it would
>> affect architectures that don't have an MTE equivalent.
>>
>> Alternatively we could introduce something like folio_has_metadata()
>> which on arm64 simply checks PG_mte_tagged.
> 
> We discussed something similar in the other thread (I suggested 
> page_is_mergable()). I'd prefer to use pages_identical() for now, so we 
> have the same logic here and in ksm code.
> 
> (this patch here almost looks like a cleanup :) )

Yeah, let's keep it as-is for now.

Using the same pages_identical() pattern as KSM makes the logic
consistent.

And it's simple enough to be easily backported to stable trees ;)

> 
> If this becomes a problem, what we could do is in pages_identical() 
> would be simply doing the memchr_inv() in case is_zero_pfn(). KSM might 
> benefit from that as well when merging with the shared zeropage through 
> try_to_merge_with_zero_page().

Right, there is room for that optimization. I will look into it as a
follow-up patch after this one is settled and backported, especially if
the performance overhead turns out to be a real concern :)

Cheers,
Lance

