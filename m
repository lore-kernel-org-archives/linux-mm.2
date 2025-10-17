Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D7FCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69CA8E004C; Fri, 17 Oct 2025 04:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED128E0016; Fri, 17 Oct 2025 04:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBE08E004C; Fri, 17 Oct 2025 04:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2C458E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:37:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D818883D5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:37:59 +0000 (UTC)
X-FDA: 84006953478.11.F632920
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3FDBAA0007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:37:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F5ZWTzz7;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUldie7YGbLgK/yUkH/YlCJZv6GnJjzFSBkdYHC+iuw=;
	b=fP2uc9mP+52FI/ake6zJn2oMiwcV8uwmwLaY7hS0oPniYmbPjHIiyJSfA3zI9uyq+gbo4p
	GQq+EnQ/1xJZ39drSDBYb5vVa/j/6xkzYU8hboed442RWbSw2wrBRP/3m35mA+IgQmHmhk
	ZgUs28hwWCN7gf7ulKeNB1JXcoxByIE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F5ZWTzz7;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760690277; a=rsa-sha256;
	cv=none;
	b=O3k0CzlNlzYKOE+CrJbmcsk8UNjsV3h/L/nAdl54UxbJdGpzhXYsfaXRKzNlWFWjso6WvV
	6UIPlBCNpqB0tHpvepreV9eAuJOU8WQ4pFnhiCZbQkxlIiuw9mSkK8ipjLAzD8miydTIA+
	/g0mwfZCijMpLJEX9QRHgWLme8X2HPs=
Message-ID: <ab918a83-edb2-4a19-821d-a96de9e097eb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUldie7YGbLgK/yUkH/YlCJZv6GnJjzFSBkdYHC+iuw=;
	b=F5ZWTzz7Zz3Sl05h3xS6IboA6vtdszAnjlmZld5d+7to+cFum/X5E5I3uloZbtE9+7k2YE
	Z9F2yn5erSW5kBeffWKY32Eff/A/iF7OqmRmcX1dJvTDarRXBCSMtSjn3CvHBMNYhiMV73
	ItzP1OEurmm47FemeczRbSR4F+sAWvw=
Date: Fri, 17 Oct 2025 16:37:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: David Hildenbrand <david@redhat.com>, Wei Yang
 <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
 <20251017012724.4bo5oj2g6tdmp2fv@master>
 <1674efca-6d4e-4247-8b1c-b6816360d8bb@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1674efca-6d4e-4247-8b1c-b6816360d8bb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FDBAA0007
X-Stat-Signature: yxd8gu9r9jz5pbqnzoeptgqucwwbz6d6
X-Rspam-User: 
X-HE-Tag: 1760690276-733815
X-HE-Meta: U2FsdGVkX1+ZDB5ZZtpRq3aNVSni7zkjqXHO+empJ0c1HtVlW3AbMIxOmHJhKBqAMyUQSw1HYdZhN6T+WiAUKY5kMCleznP+f+yM63SR0FV87GDp7djT8VadGgzekwNJViS/XjEfKq97U4iKpw96vDr1bk1PpsM46upPmT+UwLauf5wRMUi0jOBmAmEW5v+N5qQsEm3VY7mZwCOIjOTbdA3i8f5AHNVliUOao8IiRYPfBGWWdUpvvXLyh9vLTD5haZlrgNXQxrJNA7rM1mhmMG9lnzPmnS4tdBrkD3Gnqsb/Q3qS6Q1WuZ4krBH4ufwAAexd88WEJawkkN/+5d9LC73R1w/xYpicxQY+3tgF+sC3lfWmwCwvR0v+T1jl936HD0NjYxShSSpUkpPfolsjVHD1lXY//TOoJYh54/Z2iD0VlLh/DYNtqLVbX/dh4plBJ2ztepzTbDI9maPRExy8VuJ3z4EJwpqUKyNspWpFuQuDGrTEQ1WQapYQwYI8brhKEleEpDEaQQHMvjhB5LZR0zEL183EOhz5TupgiaScMlkevQ+DubIGZpzcCIFNmqYWf8L308COyVP0No2gwVD2660liaRJp+Wp1ZKKXOdVliXFkG7KDZgOnVLqGx8o6DYIkSwiBAPAsiHffw1nO84HO+JFDC+NuhzYujPfO+/+nc5YbzXn5kjS0RCpBMf3LXVGfOIO2PPRD0xtt/yn+S7JFubp+W/p0RpfUQfdWP74MsGW3E/EQzxpo8ZQCuR9B7LreVBkcVUpZFwcjRtldUSzZMzPD9YYbwsRCZEyq39aHufpVg7wtis4wJ1+1akBWHDxU/7B/jjXTAPrgSFJBhlVqkyBzLdTU4D7r0ZMytbdD/HCJG9kMCIpoPa8yO2ht4G0vBrv+cKe9WL308svh8dOOMTMhNzZZcD9VpHiJSeklNPTg6yzAo1C38hHRUKn1NFevyJYV27npfH0FagQcr5
 6+k7aYQo
 ua9OSUkNsrO72pNB/TXh/8cCTBRo6ShBYsBUgdysa8MQ6eD6losaxuCTSAATL2Ktb2OwFzKPErCKhkoVp8WGZ0EKvg7EkE2JQ0ZVUk4ZWlDGI9ZQuz/mwq82Z7pqs2UWfzVzXm910gtnA4lXvuNoAsKqh9EpOD/wwbiDvYikSjaNwDQ1DKPSxCsk3PwrKsLTI9anufGA1Gv8kN46OsR0CA35zcrUF8yQhE4MU/YqGCwsy59WUXD3kdWQENmlVQ/Dby7Lumqn0IPhW1gCw1GXmBwbyLFL8pIdPTpOP0TGO4iSSK60ltanp98oAXLJPlLQWNcghqhGDCf8Y5uiIKDkiSKWzA+IVY8abDm4dr42jdIuS/3WC/FqaXqB0/ahN/5lJZliz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 16:11, David Hildenbrand wrote:
> On 17.10.25 03:27, Wei Yang wrote:
>> On Thu, Oct 16, 2025 at 11:47:06AM +0530, Dev Jain wrote:
>>>
>>> On 16/10/25 9:06 am, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> A non-present entry, like a swap PTE, contains completely different 
>>>> data
>>>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>>>> non-present entry, it will spit out a junk PFN.
>>>>
>>>> What if that junk PFN happens to match the zeropage's PFN by sheer
>>>> chance? While really unlikely, this would be really bad if it did.
>>>>
>>>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>>>> in khugepaged.c are properly guarded by a pte_present() check.
>>>>
>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>    mm/khugepaged.c | 13 ++++++++-----
>>>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index d635d821f611..0341c3d13e9e 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t 
>>>> *_pte,
>>>>            pte_t pteval = ptep_get(_pte);
>>>>            unsigned long pfn;
>>>> -        if (pte_none(pteval))
>>>> +        if (!pte_present(pteval))
>>>>                continue;
>>>>            pfn = pte_pfn(pteval);
>>>>            if (is_zero_pfn(pfn))
>>>> @@ -690,9 +690,10 @@ static void 
>>>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>>>             address += nr_ptes * PAGE_SIZE) {
>>>>            nr_ptes = 1;
>>>>            pteval = ptep_get(_pte);
>>>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>> +        if (pte_none(pteval) ||
>>>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>>                add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>>> -            if (is_zero_pfn(pte_pfn(pteval))) {
>>>> +            if (!pte_none(pteval)) {
>>>
>>> Could save a level of indentation by saying
>>> if (pte_none(pteval))
>>>     continue;
>>>
>>
>> Vote for this :-)
> 
> I suspect there will be a v2, correct?

I was hoping a v2 wouldn't be necessary for this ;p

Of course, if we'd prefer a v2, I'm happy to send one out.

Cheers!

