Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8C8CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DA06B00A4; Tue,  2 Jun 2026 03:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35876B03F0; Tue,  2 Jun 2026 03:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D713C6B0401; Tue,  2 Jun 2026 03:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C67226B00A4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:08:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7424E40802
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:08:50 +0000 (UTC)
X-FDA: 84834095220.12.7BAA30B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id AEE804000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:08:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bhtBWrQZ;
	spf=pass (imf27.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HbIQSY6RnBYFiruuHeLXge2JJ67C2QiNkYzOnkIakk=;
	b=I8fc7phmmDqTaZZsw47yI36ynyuVcNt1gEYtyb5qU23VsLmXQVrxWn7HNazuh7QJhFI1hh
	gM6D1IMElIp6v0Ss3KlVsQMbWwJVRI8ot5s/UQl0fGJFgfL8Nm/eX8yl4Lh8OPAFhKHTTv
	mxSXFmW+KgICmMoPRVSDMflEyjQk2S8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384128;
	b=hFddVHA6nIaoJJKTnTl3FLiKOV5oY1neYOOrERznOuYO5FTGw+2f8Mm94QBmiJ/KBYe/z/
	JDaxGaucKLjuxNnskoOhQcYQX+hzf3KfwtLW0KBGJ5zWkieSL7YmRaByzaerDpZD0Pt0Ac
	y5cv/U7FPr5uYYdIAr3h1czjMnZ8k80=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bhtBWrQZ;
	spf=pass (imf27.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <88aa1f75-1cdd-499e-b352-0cd6c7f0d079@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780384125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HbIQSY6RnBYFiruuHeLXge2JJ67C2QiNkYzOnkIakk=;
	b=bhtBWrQZwWULm5HT+cPCDnDuqhKrKp+OYj3fIfs5b78EoFIrrSCgJvsE13F7DKrZ2AM5FG
	G/puPKiinamGDx8ZovmwsYYtApjsaRPqrFu1hoJZ0l6hcVjwwv1gerLs1tuKZQTFQ+rZS1
	uMVrbj9VFb9eyr31f9e+P3nvilUf988=
Date: Tue, 2 Jun 2026 15:08:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 liushixin2@huawei.com, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Muchun Song <muchun.song@linux.dev>
References: <20260519121646.40833-1-kaitao.cheng@linux.dev>
 <20260519105424.e422131a0ffb49e19ed1aebe@linux-foundation.org>
 <bd3667a2-fd81-4761-a763-f6418d9c09f9@linux.dev>
 <4bfe16a2-3bb9-44e2-8b3b-8c77857a4944@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <4bfe16a2-3bb9-44e2-8b3b-8c77857a4944@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEE804000A
X-Stat-Signature: wcn8f1hqn6t8t31g7zpmkywwn55r6rd3
X-HE-Tag: 1780384128-250679
X-HE-Meta: U2FsdGVkX1976CNUnPLe7Xhcp6NABRHw/159hrvEfNfLCFkf6Ke4HyDTqFjo+b1tpqJ+NWNRKaRU+BjAkNXuSOEf5FYf7t11rIJnmLoi5S8nkjZHHWwUaPnYZWFihxNh6FX3+JFCiRnDjlJ7H1xjD9npqrsyod8qwTYdoW25P2IDRp+vnB3c9TwM+MxSKPcSDqEmHiKoT3PHdILv8mv8OFxbCyjuFkc7pj0s+nxgeg2uBcM9Ri7uJw5dBKEG6+ExQr4MB38rIqA/uqOaZauA0+Z4hT77x7cHdMm4bzVI7AMQC/MHweQ2dCKBhM6EDHkdPHJngcI/up2l4Qapl17tqjXHbYBP27bwZAGCGOH95qLQ5GbPTzIYs7ZQuTOEFxsvhlWICXy3y3G61xNjh//Z4igJhxRNAx9z58rbatzsj0p7oDPxEVCTzF/98VwNJz5g2kwTHnIuCcS4xOp6i5gxg7TqSjmtzfo8JR0BMYFpbp4PNt6GRSQlgcGkBWkAluhK5nEuSeqS/tD78rJKU2TuYuhdqFckRtVYOBzPf0R1gr9jrjDQenZtBeMzdVNoS6h7tVfVN88JlUaw4BpSBxNZypW1yuaFWAVhsfdGAOMTWk3NdGGXcA0b3mi9bBS8SqjWmCClzkLDzf2bEFydDXMYHZlL/7fupvk7lid3ox2TQozJbU+sDDRf1VsA27Iavq9o9t1LYDQ1dqASVjNxD4Vsxu+ql3N8YzXm9X5mkW09uW+axAYPHy1e73NEgT1+edUghw4eyrqhxQ0DFQ3s8Js6BEmRGC90Yxw8++tzmiX4gOXzEf/WLIfgAA3Bt2kl7xm2u6ztZShUCcWR/nD+uBTdoyPG+3bTeocS1JfJiEN+t7Ncj1eLyvSd+opTykVHykK2B3vTT6dfCcKPUTJVQP8vGk/P3BderbXICS4LgVZxcUnUCdXM+hA5AWcl7x7lP9EN+oGuAuezkbN8MclXGoL
 pfPLB1zz
 TXTq4xqiYULvzVLKiTNAuXNXwgAgQp9NceqPtKDiDtf89xzejEmEVPV5qp9uP2jV/IG/kuIFikytmAYJ+HWVjPeyg/PSVUWbJsJtJ17+3KTZN1Ceh0/ebxOJ07anWs1k415HapHHSBnmHqcK6kka4cxrdo2hQ0+k++g248K27LRciJZzquiOp7xK+XDEQfATox6FsyTlAF+C5BM/TzmcZZDFB+7Y8/oBpe/+k8JjAFnoSUCM+7X45zLxOiydVpAMAPlw8vfGGbcASPfyyuJm0Pzs1uObaQAND7LFKBHbmSRtlSmmTh2+v0GnQxJaAk6nMX4wisTRwrjywI+1cznQMVwTybA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/2 00:21, David Hildenbrand (Arm) 写道:
> On 5/22/26 11:35, Kaitao Cheng wrote:
>> 在 2026/5/20 01:54, Andrew Morton 写道:
>>> On Tue, 19 May 2026 20:16:46 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>
>>>> page_is_unmovable() checks HugeTLB pages without holding hugetlb_lock and
>>>> without pinning the folio. This is intentional for the pageblock scanning
>>>> paths, but it means the HugeTLB folio can be freed concurrently after
>>>> PageHuge() or folio_test_hugetlb() succeeds.
>>>
>>> Thanks.  What are the userspace-visible runtime effects of this?
>>
>> The direct user-visible effect is not memory corruption, but degraded forward
>> progress in the page isolation / contiguous allocation path.
>>
>> If the race makes folio_nr_pages() return 1 while the current page is still
>> treated as a tail page of the old HugeTLB folio, the computed step can
>> underflow:
>>
>>         step = folio_nr_pages(folio) - folio_page_idx(folio, page);
>>
>> The caller then does:
>>
>>         start_pfn += step;
>>
>> With unsigned arithmetic this can wrap and move start_pfn backwards, typically
>> near the beginning of the old hugepage range rather than advancing past it. In
>> many cases this only means rescanning part of the same hugepage range, so the
>> effect may be limited to extra scanning work.
>>
>> However, it still violates the scanner's forward-progress assumption: step
>> is expected to advance start_pfn. If the same transient state is observed
>> repeatedly, the scanner can keep revisiting the same PFNs, causing excessive
>> latency and, in the worst case, an apparent stall in operations that rely on
>> page isolation or contiguous allocation.
>>
>>
>> Here is another point raised by AI, the old code also used folio_test_lru()
>> on a folio pointer obtained without holding a reference. If the folio is
>> freed and the old head page is reused or observed as a tail page of another
>> compound page, folio_test_lru() can reach const_folio_flags(), which asserts
>> that the passed folio is not a tail page. On DEBUG_VM kernels, that can
>> trigger a VM_BUG_ON_PGFLAGS() crash.
>>
>>>> The existing code avoids folio_hstate() and uses size_to_hstate() because
>>>> the HugeTLB flag may already have been cleared. However, if
>>>> size_to_hstate() returns NULL, the code still falls through and computes
>>>> the scan step from folio_nr_pages(). If the folio has been freed and the
>>>> head/large state has been cleared, folio_nr_pages() can return 1. When the
>>>> current page is a tail page, subtracting folio_page_idx() from 1 can
>>>> underflow and make the scanner skip too far.
>>>>
>>>> Treat a NULL hstate as unmovable so the scanner does not try to skip over
>>>> an unstable HugeTLB folio. Once a valid hstate is found, derive the number
>>>> of pages from the hstate instead of reading the folio size again. Also
>>>> validate the page index before computing the step to avoid underflow if the
>>>> page/folio relationship changed concurrently.
>>>
>>> This code sounds rather sketchy, and it sounds like it will remain
>>> sketchy after the patch.  And AI review says "hey, this code is
>>> sketchy":
>>> https://sashiko.dev/#/patchset/20260519121646.40833-1-kaitao.cheng@linux.dev
>>
>> Following David Hildenbrand's suggestion, I made some changes as shown below.
>> I'm not sure whether there are still any other issues.
>>
>> --- a/mm/page_isolation.c
>> +++ b/mm/page_isolation.c
>> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>>          * We need not scan over tail pages because we don't
>>          * handle each tail page individually in migration.
>>          */
>> -       if (PageHuge(page) || PageCompound(page)) {
>> +       if (PageCompound(page)) {
>>                 struct folio *folio = page_folio(page);
>> +               unsigned long nr_pages, pfn;
>> +               unsigned int order;
>> +
>> +               order = compound_order(&folio->page);
>> +               if (order > MAX_FOLIO_ORDER)
>> +                       return true;
> 
> Would we also have to care about non-order-of-2?

There should not be any non-order-of-2 compound pages here. Neither the
buddy allocator's allocation model nor the folio_size() / size_to_hstate()
implementation supports non-order-of-two compound pages.
 
>>
>>                 if (folio_test_hugetlb(folio)) {
>>                         struct hstate *h;
>> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>>                          * The huge page may be freed so can not
>>                          * use folio_hstate() directly.
>>                          */
>> -                       h = size_to_hstate(folio_size(folio));
>> -                       if (h && !hugepage_migration_supported(h))
>> +                       h = size_to_hstate(PAGE_SIZE << order);
>> +                       if (!h || !hugepage_migration_supported(h))
>>                                 return true;
>> -
>> -               } else if (!folio_test_lru(folio)) {
>> +               } else if (!PageLRU(page)) {
> 
> Hm, is that required because we could VM_BUG_ON?

Yes, that is one of the reasons for the change.

page_is_unmovable() does not hold a reference on the folio, and the folio
can be freed and reused concurrently while this scanner is running. In that
case, the previously obtained folio pointer may no longer refer to a valid
folio head. If the original head page is reused as a tail page of another
compound page, folio_test_lru(folio) can hit the folio flag checks and
potentially trigger a VM_BUG_ON_PGFLAGS().

>>                         return true;
>>                 }
>>
>> -               *step = folio_nr_pages(folio) - folio_page_idx(folio, page);
>> +               nr_pages = 1UL << order;
>> +               pfn = page_to_pfn(page);
>> +               *step = (pfn | (nr_pages - 1)) + 1 - pfn;
>>                 return false;
>>         }
>>
> 
> 

-- 
Thanks
Kaitao Cheng


