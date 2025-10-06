Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB6CCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 15:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D578E0015; Mon,  6 Oct 2025 11:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54D28E0002; Mon,  6 Oct 2025 11:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C914B8E0015; Mon,  6 Oct 2025 11:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B81CD8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:03:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6066F11A93D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:03:12 +0000 (UTC)
X-FDA: 83968007424.17.27DD7E6
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3262E1A001A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:03:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cu4RLiyc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759762990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ix6wMbpKpMLTaE8hkEfVLxl4w4AKwmdKBZJL6cnFg8Y=;
	b=dwBjy8W6C7QD9drEvsaqcyHEHpMIhsZ+HgkO5bt9/wzOINCgofCChV7+t0vUT4iOCG5yAt
	7moUBp94BW7ihbTWkF0wWWFuvVWEtlUBPFV4kttJMn1YRUTl3UByl71zPz5iX1TVSW7Rzq
	n1OK1IV1iFiCeV6EPKGjt0LIEY6tLLc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cu4RLiyc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759762990; a=rsa-sha256;
	cv=none;
	b=JN5IhGiF8euDB7btDGc31hCLdjqgY3vMAjXVYA+basKO0gyo7Hni08gsc9P6lmDe8ih9W+
	OfAufI42Z5m3QDmGQsliPICr9OGkLxWo3ihwcFJV4JwnE7I5H4itGRmNWLC5iqiTJsk9+n
	14KB7qb6WISTI5PKhCWKiJBXVFAUAos=
Message-ID: <41dd848c-c27b-4373-9e89-3fda9e302cfb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759762982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ix6wMbpKpMLTaE8hkEfVLxl4w4AKwmdKBZJL6cnFg8Y=;
	b=Cu4RLiycV7X4kV3vML/ileqDNEvrw2hsXNg/1S9vyn7Xy1i1UrRtN/Impbl/AXusa/AyIV
	yfOv+WhPI3UvQadiG4aQs993wIuZ/h2KNvSRDk24Gf7y0NP09rLPkZpCrFtSLdWCkFz5R3
	rRySMHJvN/JUsl83O+5PPZ/aBYRQOHQ=
Date: Mon, 6 Oct 2025 23:02:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, akpm@linux-foundation.org
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
X-Rspamd-Queue-Id: 3262E1A001A
X-Rspamd-Server: rspam03
X-Stat-Signature: 9amfiinbhpntat9a8j9tworpz6d3s4bk
X-HE-Tag: 1759762989-10147
X-HE-Meta: U2FsdGVkX18mkkR1z8I/fmS5F9YSmhNEX4/6LthAYqF7/2pkYNwayIHDu2pMaSrtHWuD0mRRAWacDigE/+XYXK+/cyr90CArkK8RPoT6JY+diKNvFUMcFNFxbAxBhAc7ty1khVB4fOUzgAu/2InYX7X3TtEar5nSG4cChlhijC8SeAWWvpO1crllvD8a18dcq24LeAdMtz07HWXuUTEiLJT9Fd7wNc2bFcARVT11pJLb0aSS3PLcEqST0PSTEWx+u13OsSABCNY88/hu0TbhPVX1fRC8HyVf/agtjtfEso/mDJ/5jyv68YyAFDIcrwshWhEfm4zA3CFxExyrhdkUI1n2lciduPRKBs3Xf1uxkzkrONoEAtuTcYm3UaKbobaj8yNM0VRfAgZi1svkvjLFtsG098KZFSuAZB7xRocmV1f2+r08os+BY023WdsfR2D3qa+UFfz2JImuFzF+vlXG+ddOf/6d+2oSZa++lO0sPN+NtskWYvZL+zylCTDt8ClW6O+sL5HIUiXoqIT32hNG0oLOQ2oohsioY+KT+7IENwrvhlUPRUcfmqgfoE8d8vqv3+w5dC7FpIQlmA2ALla2NEcnu5qew2qzlI8nebGgMGRK11vlWj8OAAhlf0RC0nD/N0S8xy4NTXa1gc+TnCqOHB8wH6qYcU/GlQ26W6DLUoI9+a04ZJqi+qk9l1ox57F/Sw19sWLKOks4M/fCciAeMLNhxaVqZhskFThTL0e/A6Jy6jChWXmqRtRHeUZVL7Sq9LN/B8aoZUXvoeiHrCNg+pb7Qw1tg2QhtxKpzts8i6iXPRmpSG0Z0DTqNzGQKkTq7MhoBu1wHXWsg3vHjKxtLp6VBJrPuSOknWKVKWo3zVrhMIYU25LmlYpk/cwRokAGQH1i4QpR7grVwdpXTAVTBT0gNkRA/EFTWCh29rT0CTDZBJhV2oHDC6pBwCstRqfvRQ5JnhfOmux4xKoJdzf
 51l9Tkqq
 LM9kQ4ayi7VQj4sUFCXd2u37WCR4De1tUlRK7w8yVBfhqAY3p8JNFXOkTHfPnpo4iaFmUzQkVpL7UwKtyEl4Dg9UfawwKadXPoXGa2Ym5BPH0Dob3NZSUgtX7dj/tjnpIIg+WZUxyhSBNLjG6uEjqLBQu74Lbs5kgv6V3NbF+/YYFaQHTfqWIsofr3MIozl5XDpk+GabhuV8CJNSH+vtvNLD0AmhCXzeWK8Yvi4iK2kMbYnTeaMBNme+jzram63XSSwrAldcydJU6ztE4zezUNgHKIHuGqU6RsAmtYj7sX8hGvgWb7EmSafOyNJLwUzGO3P9KVFtMX4AR67oDEQQTA84dtQ4yLfmFY6TpnmMvRkC0D2jjeqNet+lbeQ==
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

Cool!

I'll take a closer look and adjust the patch description accordingly ;)

Thanks a lot for the lesson!

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

Ah, I see ;p

@Wei could you send a patch to add the non_swap_entry() check there?

