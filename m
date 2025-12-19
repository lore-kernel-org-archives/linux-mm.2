Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F69D767DB
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BD66B0088; Fri, 19 Dec 2025 06:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BF76B0089; Fri, 19 Dec 2025 06:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AD66B008A; Fri, 19 Dec 2025 06:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C44646B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:17:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78C8EC0736
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:17:20 +0000 (UTC)
X-FDA: 84235969440.02.3DA5A72
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 949831C0009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:17:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766143038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XGAwITMqnfo+p/LgVP07Bzd4VLm5LwJwlkoPClnUyO0=;
	b=7YjulUk1V49Ig5Xec/TrEY8WwZZZk+sjFiIQp1ZFbtjPzajNmP7rf63fbJydNfINY2juWD
	s7UYLjXHf6cjtZrLU7wnunryrV9TsQZNcQQmTfW2EY8phHxdPTrIU8Rq+JRA3ApbNKvZHA
	HdHtpQgb31QMqwpWhvuEY1n54Rk5890=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766143038; a=rsa-sha256;
	cv=none;
	b=fdx7/ysfOXeATQCHjiJdDc72Vwu8/bG/OgH8rPmWHAioC0LvTrRQ1Mz0Enq+rCVgNel2N/
	q9FmAuscEtpF97vOSmMOSokDBy0s4xDlCBDHZXbafFE9+Pdahi1DZRGlv4DRKy7n/UxBx/
	Hg716os+CHnDsnID/T3mtf3iTwsqqV4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49022FEC;
	Fri, 19 Dec 2025 03:17:10 -0800 (PST)
Received: from [10.57.93.157] (unknown [10.57.93.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF1923F73F;
	Fri, 19 Dec 2025 03:17:15 -0800 (PST)
Message-ID: <4e191cba-a009-4354-bf0e-720f1a761a42@arm.com>
Date: Fri, 19 Dec 2025 11:17:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Uladzislau Rezki <urezki@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
 <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com>
 <307a3cb2-64c6-4671-9d50-2bb18d744bc0@arm.com>
 <17bdf357-251a-4b95-8cba-6495ce11ceb7@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <17bdf357-251a-4b95-8cba-6495ce11ceb7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: wb3umt1wsymowytgf74ru9ykcgunefaa
X-Rspam-User: 
X-Rspamd-Queue-Id: 949831C0009
X-HE-Tag: 1766143038-797503
X-HE-Meta: U2FsdGVkX1/mNmgiNoaJHJCWf+bgMZqs0GN30W6TkqQ38OzyNaYA/0aP1r0TZt2OlQF4S3aKYV+acqnwM4pCRhUu1nfJzGOLrUs8OTewqMW8UqmPK2Kocn9yHqloFPiwpHTLoFKUlts3Dhuv3lasKOL6RS+OjXatmOhBa9d2mcOlekjHhg5w9Pldz9g/HRWcQpP9zOwFLoYHLqv3bFDKz0vYFykeSE8Z/N1jKY2eGS65Me/bNDJJV0drOZQOZTV64kjtMNCddVJoTZhoSwgQqsLPHzFI772ux6k5gN2qbbV4HlrlVD7S4RoptjyRrRPrmEwoaIWHHxLU/U/BSgwlsACLplJkFswlc1Kt7vroeD/65Bf7oeInvsyXr53IA1qjz+gWqNbDXAvmj7S9iLb2JXXIMVvTc6r+tZErlXGoTMM18yGzKaQ8MQQNWD4gOrRvPXsbiJL+pMZeCktF6LdW4zVS7U9Y7Xu7fODzO3IeanZuaYYCHp63bIsjCkfz5KniJjKM5TQFFHvV8al1VhXiCScSxOuPf1f6MkxVxgYcPhB4728hWlgIGNHPlVRyvsS76nFBMWHe7+zHmm+1LKLOV1i4Aer6XXzDfdrmnD2bCv3et+VotLx8atdp/O+O7kUg31RvpaNTmfamK0s93kmjiD+GVhxMdL3ZqWDEhroo1uBcC51Z+eSyhIzgVbNp8Cqa5ImdKkniXQS/PhR44qJYHYze1WOkOYYhM+qZR2i4NjTTshb/afuc9V5yzf5/TWtIcuqYUUUbCJscKneXci651ggn43+weASgYUwtqCeWY/Q8jyKtTSSzHWWaDq7ru6+D0hgA8lyQP74bh0jGnUM5O9o9SR6nbQFVBu4Y80Kslbl3DqXzn6tPM7hq4EZ8g8bCQqDJ3ksyqUamFk8wMI++/lmqyqo45POK7DajB2Gq6IXUNk/sVtCsJuEiq+wWOywMxfLgOGTsj4/SIzqlfBR
 Es79tQhs
 3ButO8EGEm1H6FiSmrSmocgE9ZFJ7f8KRPT3lzx9DxGZEGyL7FGST8w+0AMD4wZVyDUIWq9TftRAfWC9f9PrMPl2dyrdrgUZev9JGfJ+pOZvPp8uXwHpEkkYsJuAxPSByphl7WDYEjcMWNHw3DQayeaSX11Am+Rn5eXxciyHhYjJL+7qz9y0lohW8qjZD459eVs1tk3Sg9zw4P0HE5Gq9xLIW+jKz4MXKZSzTwEnwu7XUOmqHNfasdcvRmJYbG7s0mGTbRdzxtU/eo7pY2QURDLaSfe6AQLybj1Pn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/12/2025 08:33, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 12:56, Ryan Roberts wrote:
>> + David, Lorenzo, Matthew
>>
>> Hoping someone might be able to explain to me how this all really works! :-|
>>
>> On 18/12/2025 11:53, Ryan Roberts wrote:
>>> On 18/12/2025 04:55, Dev Jain wrote:
>>>>
>>>> On 17/12/25 8:50 pm, Ryan Roberts wrote:
>>>>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>>>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>>>>>> Introduce a module parameter to enable or disable the large-order
>>>>>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>>>>>> default so far, but users may explicitly enable them at runtime if
>>>>>>>> desired.
>>>>>>>>
>>>>>>>> High-order pages allocated for vmalloc are immediately split into
>>>>>>>> order-0 pages and later freed as order-0, which means they do not
>>>>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>>>>>> can affect performance.
>>>>>>>>
>>>>>>>> However, when the PCP caches are empty, high-order allocations may
>>>>>>>> show better performance characteristics especially for larger
>>>>>>>> allocation requests.
>>>>>>> I wonder if a better solution would be "allocate order-0 if available in
>>>>>>> pcp,
>>>>>>> else try large order, else fallback to order-0" Could that provide the
>>>>>>> best of
>>>>>>> all worlds without needing a configuration knob?
>>>>>>>
>>>>>> I am not sure, to me it looks like a bit odd.
>>>>> Perhaps it would feel better if it was generalized to "first try allocation
>>>>> from
>>>>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>>>>> to lowest order"?
>>>>>
>>>>>> Ideally it would be
>>>>>> good just free it as high-order page and not order-0 peaces.
>>>>> Yeah perhaps that's better. How about something like this (very lightly tested
>>>>> and no performance results yet):
>>>>>
>>>>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>>>>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>>>>> memory leaks when running mm selftests...)
>>>>
>>>> Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
>>>> arm64/mmu.c already does this - it computes order from size and passes it to
>>>> __free_pages().
>>>
>>> Hmm that looks dodgy to me. But I'm not sure I actually understand what is going
>>> on...
>>>
>>> Prior to looking at this yesterday, my understanding was this: At the struct
>>> page level, you can either allocate compond or non-compound. order-0 is
>>> non-compound by definition. A high-order non-compound page is just a contiguous
>>> set of order-0 pages, each with individual reference counts and other meta data.
> 
> Not quite. A high-order non-compound allocation will only use the refcount of
> page[0].
> 
> When not returning that memory in the same order to the buddy, we first have to
> split that high-order allocation. That will initialize the refcounts and split
> page-owner data, alloc tag tracking etc.

Ahha, yes, this all makes sense now thanks!

> 
>>> A compound page is one where all the pages are tied together and managed as one
>>> - the meta data is stored in the head page and all the tail pages point to the
>>> head (this concept is wrapped by struct folio).
>>>
>>> But after looking through the comments in page_alloc.c, it would seem that a
>>> non-compound high-order page is NOT just a set of order-0 pages, but they still
>>> share some meta data, including a shared refcount?? alloc_pages() will return
>>> one of these things, and __free_pages() requires the exact same unit to be
>>> provided to it.
> 
> Right.
> 
>>>
>>> vmalloc calls alloc_pages() to get a non-compound high-order page, then calls
>>> split_page() to convert to a set of order-0 pages. See this comment:
>>>
>>> /*
>>>   * split_page takes a non-compound higher-order page, and splits it into
>>>   * n (1<<order) sub-pages: page[0..n]
>>>   * Each sub-page must be freed individually.
>>>   *
>>>   * Note: this is probably too low level an operation for use in drivers.
>>>   * Please consult with lkml before using this in your driver.
>>>   */
>>> void split_page(struct page *page, unsigned int order)
>>>
>>> So just passing all the order-0 pages directly to __free_pages() in one go is
>>> definitely not the right thing to do ("Each sub-page must be freed
>>> individually"). They may have different reference counts so you can only
>>> actually free the ones that go to zero surely?
> 
> Yes.
> 
>>>
>>> But it looked to me like free_frozen_pages() just wants a naturally aligned
>>> power-of-2 number of pages to free, so my patch below is decrementing the
>>> refcount on each struct page and accumulating the ones where the refcounts goto
>>> zero into suitable blocks for free_frozen_pages().
>>>
>>> So I *think* my patch is correct, but I'm not totally sure.
> 
> Free in the granularity you allocated. :)

Or in order-0 chunks if split_page() was called... Yes, I understand the
requirements of the current __free_pages() and co, but my questions are all
intended to help me figure out if we can do something better...

background:

In v6.18 vmalloc would (mostly) allocate order-0 pages then __free_page() on
each order-0 page. In v6.19-rc1 Vishal has added a patch that allocates a set of
high-order non-compound pages to satisfy the request then calls split_page() for
each one. We end up with order-0 pages as before that get freed that same way as
before. This is intended to 1) speed up allocation and 2) prevent fragmentation
because the lifetimes of larger contiguous chunks are tied together.

But for some (unrealistic?) allocation patterns it turns out there is a big
perforamcne regression; the large allocation is always going to the buddy
whereas before it could usually get it's order-0 pages from the pcp list.

So I'm looking for ways to fix it, and have a patch that not only fixes the
regression but improves vmalloc performance 2x-5x in some cases.

The patch basically looks for power-of-2 sized and aligned contiguous chunks of
order-0 pages whose refcounts were all decremented to 0 then calls
free_frozen_pages() for each of those chunks. So instead of posting each order-0
page into the pcp or buddy, we post the power-of-2 chunk.

Anyway, from your explanation, I believe this is all safe and correct in
principle so I will post a proper patch for review.

But out of this discussion it has also emerged that arm64 is likely using
__free_pages() incorrectly in it's memory hot unplug path; Dev is going to take
a look at that.

> 
>>>
>>> Then we have the ___free_pages(), which I find very difficult to understand:
>>>
>>> static void ___free_pages(struct page *page, unsigned int order,
>>>               fpi_t fpi_flags)
>>> {
>>>     /* get PageHead before we drop reference */
>>>     int head = PageHead(page);
>>>     /* get alloc tag in case the page is released by others */
>>>     struct alloc_tag *tag = pgalloc_tag_get(page);
>>>
>>>     if (put_page_testzero(page))
>>>         __free_frozen_pages(page, order, fpi_flags);
>>>
>>> We only test the refcount for the first page, then free all the pages. So that
>>> implies that non-compound high-order pages share a single refcount? Or we just
>>> ignore the refcount of all the other pages in a non-compound high-order page?
>>>
>>>     else if (!head) {
>>>
>>> What? If the first page still has references but but it's a non-compond
>>> high-order page (i.e. no head page) then we free all the trailing sub-pages
>>> without caring about their references?
> 
> Again, free in the granularity we allocated.
> 
>>>
>>>         pgalloc_tag_sub_pages(tag, (1 << order) - 1);
>>>         while (order-- > 0) {
>>>             /*
>>>              * The "tail" pages of this non-compound high-order
>>>              * page will have no code tags, so to avoid warnings
>>>              * mark them as empty.
>>>              */
>>>             clear_page_tag_ref(page + (1 << order));
>>>             __free_frozen_pages(page + (1 << order), order,
>>>                         fpi_flags);
>>>         }
>>>     }
>>> }
>>>
>>> For the arm64 case that you point out, surely __free_pages() is the wrong thing
>>> to call, because it's going to decrement the refcount. But we are freeing based
>>> on their presence in the pagetable and we never took a reference in the first
>>> place.
>>>
>>> HELP!
> Hope my input helped, not sure if I answered the real question? :)

Yes, it definitely helped! I saw Vishal's reponse too, which is much appreciated!

Thanks,
Ryan



