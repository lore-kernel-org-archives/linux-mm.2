Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AD7D74961
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9F86B0089; Fri, 19 Dec 2025 03:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CE96B008A; Fri, 19 Dec 2025 03:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978FB6B008C; Fri, 19 Dec 2025 03:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 881026B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:33:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39112C0517
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:33:46 +0000 (UTC)
X-FDA: 84235557252.02.7750599
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8946540002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:33:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZjsEG/9L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766133224; a=rsa-sha256;
	cv=none;
	b=f6aaCDXPefelYY/ClETci/FO40do+1H44mZ2T8dq08hVGgA9oLOO1NhanTWVQrYnfOTrBD
	QM9YBgrGZbMWHa9iPAXwzZqi/sWZImdtrlKMkbvLY4+L2ANvmNgMUeyddlUvj6x+ANGPkc
	QkBWvuWDn5FQDMzTdR/8nGyOWC4Bjcw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZjsEG/9L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766133224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIDsQCwlqqgP9x9GwBolDPm/BGDimG14wr8Ggbd7TzM=;
	b=FoEVnoOAZ8xg/f/3VrpSK16rkxH8zGVlVn6weX+jz2HZfdN9tdIqmFr6j0NKYkk3b0c8YX
	JsSMhuPs4T+pSTiG8+GIRu9L2mbLYza7SSBnnpoeT+cjwO2e1mK4xeSFNCscZLwq40fbOT
	7p/grTRYjMcoYCsQtUrxXaEuewmq6Ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07D3460008;
	Fri, 19 Dec 2025 08:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7294CC4CEF1;
	Fri, 19 Dec 2025 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766133223;
	bh=4B+l2MwUz1LMaqEP+Zj6ou6Q2OwRYmTVRKq1sbXUiYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZjsEG/9LnbdsPCmJJJOnM4nJv2T9cbYHSWCO1ly86HNVVMYKd8R5Ky+hsvtHEgkkA
	 tz/GDzPz177KWKPPn0ML9QgZ3BbnmIeOieeoSF50feiXiAxkuYfMMFKd9sD3nFKqY9
	 jDkbEzjD6IVp1gh3xVX5HCru/ReqIk5rSANqJc2yo3W5JplQGQb2gSaLjcqTX6mRdg
	 N4esTbRlRkCO8pTIXfNVbkvfUE2xnmETpoiQ3gsG6GZpuPq+k7xdYGrKZr+Zs4i9gH
	 88EgAaEt9Bo+vzK6LJDu4rHEjhOjy+QYnIT/4ja4Ndlz3M4/Rr8OIdtXxsQu89ToOq
	 MovY6cgMV3+BA==
Message-ID: <17bdf357-251a-4b95-8cba-6495ce11ceb7@kernel.org>
Date: Fri, 19 Dec 2025 09:33:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Uladzislau Rezki <urezki@gmail.com>,
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <307a3cb2-64c6-4671-9d50-2bb18d744bc0@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8946540002
X-Rspamd-Server: rspam10
X-Stat-Signature: b4bm1ypskxeq96q1zx1jr1hpx3r7nzxe
X-HE-Tag: 1766133224-773818
X-HE-Meta: U2FsdGVkX18kOnYz1exM4gk+1NWIcTBdxUd5pTXmt9At5fnyueCu4v8ZH+Nm9uXOyODQbcnEhJIBDlZx0n568rBTlVT9uzPbM4HRj3WIloaZ0cZ0HCFXiIS8Kdu87e5FQfdhNcimvUjmOB1mL6sn7kT5eGQHE0WaVKfllVHTmcDWqfgkJ0h6+ZAWJdNaQwwmkSSshvlNogqyEfBUwDXljVJF1lHEPFvN3L3o+ktRY1cpXUmzvEMe/7ZfEMvN7K9jDIkUrFgbnDEKuulq1W4Z7ZLQyud0lQIcHirueEouMunKdT4wS7poag1YAZCZxoDKRbIydMWpALUcdSRfO16PlR74e0Qs7deaY+dI7YZ5TlKcKyNwGSvXEjYoSi5XKQHX2lz9q0gH9zHWI0uyPbB2YR13QTmODJB1DooWYsD2Yx+A8h56p1lX7MZXEuYomZfdB3q7O/4YZoYaeCxm/ogJDqvBGR8COf7a2hunLkz6dvNn5ZWTd/ZaSgF3XOBhscRfikaMtG3Rr9fN1aUuBEX7CKQPLIplaV73E+6+nLHo8gPogEUS2p83AMFU+rYFPKh7qhKu0gN8juern73QwI0Xjp+++qmbcrcwqwlMcpHbgsYRBakzRlN4RkXVoOb8QT9cBseRfjmJ0cCrtVkTlNBY1AozsDuyPdURxcXUwc5trGVcGw5ZE+YK+NilxMkrN3H9lVhY677LQiaAbw9kavW6J5osObZr5kj1Sj5ho7amNnL1KUch5u+YLoTNCe8FyZsFGcv17IzRo955vgCzNYEx4l/H2iunia28YjkZizNFzbAwxGwP0/QHT6dePcrDiwcQsO8FEsZRDLfvtajd42ok0BcOSOB0423xYTKhHPO/wj7AQWYmqvuQ01133sEDwYV9PYTwJZbsHuop8i0m1TBDoA1C3dxk0Pr8+DnhmfE4GVuLwAnuQO6wNIFaKm4GcX15LDk4e7ETIGXtcqUWJpT
 HoNLo+ea
 mnPyXwENftoBb2ZVH+ZtKoFDiqx10OOp0icg3JvfZ/HySvYO4bFmI7Rtao8m3Sh+7iWDzoP+5Y/P2jR6TveuYgD4zgPcnAZC9gJn+0rg1cNJFtK7K3b6STgplhA01rQjxBNYHkaIDqxKU9xuLgsIdQb6RmdRIn55LUmNulK9OfCScsiluU+/tCFXBXrOT3bAef/s/MR86xeUEGKNFOB4YxglwHZ6f+4e25UUkgBHxl3LOlcm9zHG0tz1AArik9MVov+KdWot0ftRWbPcWmtBidRtOvQ2Ttu4kutFqokEilTMVJ+diV2QagGek3CDadO0iPw668FiWpRLX2fv2tKR2MVxrsWrV+n2B9ojF5QDliwU9Ob7UeSuZTPNS4I6TgAkJyQ90
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:56, Ryan Roberts wrote:
> + David, Lorenzo, Matthew
> 
> Hoping someone might be able to explain to me how this all really works! :-|
> 
> On 18/12/2025 11:53, Ryan Roberts wrote:
>> On 18/12/2025 04:55, Dev Jain wrote:
>>>
>>> On 17/12/25 8:50 pm, Ryan Roberts wrote:
>>>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>>>>> Introduce a module parameter to enable or disable the large-order
>>>>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>>>>> default so far, but users may explicitly enable them at runtime if
>>>>>>> desired.
>>>>>>>
>>>>>>> High-order pages allocated for vmalloc are immediately split into
>>>>>>> order-0 pages and later freed as order-0, which means they do not
>>>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>>>>> can affect performance.
>>>>>>>
>>>>>>> However, when the PCP caches are empty, high-order allocations may
>>>>>>> show better performance characteristics especially for larger
>>>>>>> allocation requests.
>>>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>>>>> else try large order, else fallback to order-0" Could that provide the best of
>>>>>> all worlds without needing a configuration knob?
>>>>>>
>>>>> I am not sure, to me it looks like a bit odd.
>>>> Perhaps it would feel better if it was generalized to "first try allocation from
>>>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>>>> to lowest order"?
>>>>
>>>>> Ideally it would be
>>>>> good just free it as high-order page and not order-0 peaces.
>>>> Yeah perhaps that's better. How about something like this (very lightly tested
>>>> and no performance results yet):
>>>>
>>>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>>>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>>>> memory leaks when running mm selftests...)
>>>
>>> Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
>>> arm64/mmu.c already does this - it computes order from size and passes it to
>>> __free_pages().
>>
>> Hmm that looks dodgy to me. But I'm not sure I actually understand what is going
>> on...
>>
>> Prior to looking at this yesterday, my understanding was this: At the struct
>> page level, you can either allocate compond or non-compound. order-0 is
>> non-compound by definition. A high-order non-compound page is just a contiguous
>> set of order-0 pages, each with individual reference counts and other meta data.

Not quite. A high-order non-compound allocation will only use the 
refcount of page[0].

When not returning that memory in the same order to the buddy, we first 
have to split that high-order allocation. That will initialize the 
refcounts and split page-owner data, alloc tag tracking etc.

>> A compound page is one where all the pages are tied together and managed as one
>> - the meta data is stored in the head page and all the tail pages point to the
>> head (this concept is wrapped by struct folio).
>>
>> But after looking through the comments in page_alloc.c, it would seem that a
>> non-compound high-order page is NOT just a set of order-0 pages, but they still
>> share some meta data, including a shared refcount?? alloc_pages() will return
>> one of these things, and __free_pages() requires the exact same unit to be
>> provided to it.

Right.

>>
>> vmalloc calls alloc_pages() to get a non-compound high-order page, then calls
>> split_page() to convert to a set of order-0 pages. See this comment:
>>
>> /*
>>   * split_page takes a non-compound higher-order page, and splits it into
>>   * n (1<<order) sub-pages: page[0..n]
>>   * Each sub-page must be freed individually.
>>   *
>>   * Note: this is probably too low level an operation for use in drivers.
>>   * Please consult with lkml before using this in your driver.
>>   */
>> void split_page(struct page *page, unsigned int order)
>>
>> So just passing all the order-0 pages directly to __free_pages() in one go is
>> definitely not the right thing to do ("Each sub-page must be freed
>> individually"). They may have different reference counts so you can only
>> actually free the ones that go to zero surely?

Yes.

>>
>> But it looked to me like free_frozen_pages() just wants a naturally aligned
>> power-of-2 number of pages to free, so my patch below is decrementing the
>> refcount on each struct page and accumulating the ones where the refcounts goto
>> zero into suitable blocks for free_frozen_pages().
>>
>> So I *think* my patch is correct, but I'm not totally sure.

Free in the granularity you allocated. :)

>>
>> Then we have the ___free_pages(), which I find very difficult to understand:
>>
>> static void ___free_pages(struct page *page, unsigned int order,
>> 			  fpi_t fpi_flags)
>> {
>> 	/* get PageHead before we drop reference */
>> 	int head = PageHead(page);
>> 	/* get alloc tag in case the page is released by others */
>> 	struct alloc_tag *tag = pgalloc_tag_get(page);
>>
>> 	if (put_page_testzero(page))
>> 		__free_frozen_pages(page, order, fpi_flags);
>>
>> We only test the refcount for the first page, then free all the pages. So that
>> implies that non-compound high-order pages share a single refcount? Or we just
>> ignore the refcount of all the other pages in a non-compound high-order page?
>>
>> 	else if (!head) {
>>
>> What? If the first page still has references but but it's a non-compond
>> high-order page (i.e. no head page) then we free all the trailing sub-pages
>> without caring about their references?

Again, free in the granularity we allocated.

>>
>> 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
>> 		while (order-- > 0) {
>> 			/*
>> 			 * The "tail" pages of this non-compound high-order
>> 			 * page will have no code tags, so to avoid warnings
>> 			 * mark them as empty.
>> 			 */
>> 			clear_page_tag_ref(page + (1 << order));
>> 			__free_frozen_pages(page + (1 << order), order,
>> 					    fpi_flags);
>> 		}
>> 	}
>> }
>>
>> For the arm64 case that you point out, surely __free_pages() is the wrong thing
>> to call, because it's going to decrement the refcount. But we are freeing based
>> on their presence in the pagetable and we never took a reference in the first place.
>>
>> HELP!
Hope my input helped, not sure if I answered the real question? :)

-- 
Cheers

David

