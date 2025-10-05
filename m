Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C08FCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 02:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6088E0003; Sat,  4 Oct 2025 22:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76978E0002; Sat,  4 Oct 2025 22:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C6E8E0003; Sat,  4 Oct 2025 22:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959F98E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:13:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C63701402A2
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:13:12 +0000 (UTC)
X-FDA: 83962438224.26.35F4DE6
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf11.hostedemail.com (Postfix) with ESMTP id D18D440008
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:13:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HpvFpLx9;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759630391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OP9wXA53d6BP9LdL5Hoy01dmDI1cUKyIJEndcIwA2f0=;
	b=0TS8XznFBKv44lA21iyUcUQhxYgpPNMKBUnVgK5v6ssSsqFm3+Ea7TDp3U9+NuhrgFLOmI
	L7xB7S8hp27ByTeLwL6AMjBTHHD8DpQEJiFYKS16IncGTFqn+K7gSZNF4EZliLVu0UTjkd
	ImEtyS3UUqlaeXX3kvk5LeLxgIcUArk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759630391; a=rsa-sha256;
	cv=none;
	b=69bs4HuCX40WvqBuKwlHLkO1ZmZOu+ifN0Bvcvvfp9PM8Um4GL/5OlMpyYN5QhN0aO+LoZ
	4maPqiNN7EirrrxSvaYs8Kkk1eWNEOgwByD4J4LdajvEGYqSdJmpu/FARvIgYn+NIHNvwB
	M0QsAezR0FFXrccXJ3R6g6LC6NFlCGk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HpvFpLx9;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <31c3f774-edb7-420a-a6a8-3e21f2abd776@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759630388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OP9wXA53d6BP9LdL5Hoy01dmDI1cUKyIJEndcIwA2f0=;
	b=HpvFpLx9tFKGwu1dZrNOffzNFVUw/fe7sids+KZNIb5yFk2SsMGPgTqkHJnz9R+ktyx1gH
	b58wtfZKAc/08cvjc59ZftyVFiRs7q2iMCA6hZ5zuwburCYu75/klygAGUbZjlC7KfMWKf
	RQmVk/XCRnZoRZuQrEKilTbz8Xi7BGE=
Date: Sun, 5 Oct 2025 10:12:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
 <20251005010511.ysek2nqojebqngf3@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251005010511.ysek2nqojebqngf3@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D18D440008
X-Stat-Signature: hhyx6k43ogg3uncuaogcd1szw9axbk3d
X-Rspam-User: 
X-HE-Tag: 1759630390-225134
X-HE-Meta: U2FsdGVkX19qWMpbQdejLaFne1sjk2M4f40BMKIiZAw8hER04UW0m2ddXDtlcXIoQi/sPoO/A4p059qNDB3XtvOxeBDk9/lteWaYornaQyjmr/JKPpdbV5uTmnHie9foPE9hc3o9j2hC4JenwdTQbevZeRECaNukDGzZ+JE9fxEsbZrToD1T0gYS5Cs9WPDKpnUVzkO3Asg7PR5IZkgQmcffICtwokm6e4KSccd+kY4voRLv+oG2sNtcbulFm/zEYRHBf8lHkj7IOU0pWIqBNgqWyvfqdOcTJvoo05va4TNSz9SDJD5OjM6kNja5gdVjUr6B1oWRUoT6oXmrp3bqY55EhscfCH6nGjad+TgThUwCDeuFItXid+U7Y9y3eV9lD/6mmrgEAejRaIluydHAYbqv4XkqrYJ3J5uXAza+LBRXQakAyCql7HZ20/+b4cJix9rssNp8+gvrHHpaKjLiCFX8ZB1o9Czqf9oUITULkz1a4460yCk96gCjebvEGTVB7yNWRVcWSADHXKtADF4juSiih37osFefa/XJkA5E66y1iXXNIiHinQtZmF6+9xPf7Q6sloqHFn3a+PwxzFOf5HCande2YKRJs3WhrUg9eO7KLGqaRGh0MglQCZ2RQ1yxiCMOArX3ehpog+izroZSCp+z/0Sd8mXVuWQlsFRc2vYbWJKGrSEBzvgb3FuWfnh4CvaVlAD2kJbpXQvgD8Rdw3bBmgmTR6zRb+0hUKmQ2OYRMISGZRtbPtvAVggYzMyGDfMPZUDTkgi04yqVw7m86Z+zo74ov9Vof8qYn/If3BahUR6DZJkg/o99u6x3mq+l7tgOIU7gh0/fLmJv1d+TmIDvJoiKfD0niqrXciS8cobxQvN41OYa2v3YsrfX0xr2hnT5rY8yUJZFqA0Qk4I1/1T3Cbw5cqexihFGDlsAgtkbEi08K9FVUYOoAw12L1SGurFmEFNTxyo04r5oIEW
 I6w6RFlz
 VnG/jLfHuiSSQmAXckrSoKQNDESwk/j8PjQJF0TrKu/8olMQRdCDmIRhLKHWjInHpLCemxczDvQ42r4NpJbGcFDk2Y5k2L0fVViJ1SNJIPsOQhCx6oTFv1FixbodUIIJQAS8r5GSaGhLMX6Ce6/PrVjcHJ+8YoXfTxbCGJ6SpXPClMh35TRli5DdQRB6K9yfLN8GyvE4ubS9blR+iHupwvYvdns6lyH5+JmTy5VSLLPjOf88FnMMA5oPRlq6wiDr28tWgu7gf39s12VeF6yxxnPlaupYXr4DpEGTTw5M9x0axNCydyvneZYR9wzGoRssr6OtpZ8KbEPFSqLEnCFQmU/JU/IMzSir3oMzT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/5 09:05, Wei Yang wrote:
> On Wed, Oct 01, 2025 at 06:05:57PM +0800, Lance Yang wrote:
>>
>>
>> On 2025/10/1 16:54, Wei Yang wrote:
>>> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>>>> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>>>> failures deep in the swap-in logic.
>>>>
>>>> hpage_collapse_scan_pmd()
>>>> `- collapse_huge_page()
>>>>       `- __collapse_huge_page_swapin() -> fails!
>>>>
>>>> As David suggested[1], this patch skips any such non-swap entries
>>>> early. If any one is found, the scan is aborted immediately with the
>>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>>> work.
>>>>
>>>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>>>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>>>>
>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>> v1 -> v2:
>>>> - Skip all non-present entries except swap entries (per David) thanks!
>>>> - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>>>>
>>>> mm/khugepaged.c | 32 ++++++++++++++++++--------------
>>>> 1 file changed, 18 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 7ab2d1a42df3..d0957648db19 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>> 	     _pte++, addr += PAGE_SIZE) {
>>>> 		pte_t pteval = ptep_get(_pte);
>>>> -		if (is_swap_pte(pteval)) {
>>>
>>> It looks is_swap_pte() is mis-leading?
>>
>> Hmm.. not to me, IMO. is_swap_pte() just means:
>>
>> !pte_none(pte) && !pte_present(pte)
>>
> 
> Maybe it has some reason.
> 
> I took another look into __collapse_huge_page_swapin(), which just check
> is_swap_pte() before do_swap_page().
> 
> We have filtered non-swap entries in hpage_collapse_scan_pmd(), but we drop
> mmap lock before isolation. This looks we may have a chance to get non-swap
> entry.

Thanks for pointing that out!

Yep, there is a theoretical window between dropping the mmap lock
after the initial scan and re-acquiring it for isolation.

> 
> Do you think it is reasonable to add a non_swap_entry() check before
> do_swap_page()?

However, that seems unlikely in practice. IMHO, the early check in
hpage_collapse_scan_pmd() is sufficient for now, so I'd prefer to
keep it as-is :)



