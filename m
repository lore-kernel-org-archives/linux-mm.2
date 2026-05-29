Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B571CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758306B0005; Fri, 29 May 2026 01:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F456B0088; Fri, 29 May 2026 01:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645936B008A; Fri, 29 May 2026 01:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5443A6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:57:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E246640DED
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:57:13 +0000 (UTC)
X-FDA: 84819399546.10.1BA66CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0DEC14000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:57:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fgqx2Y8R;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780034232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bikGWbo7Z8u+Y86zGUnLKB2GE1vzG3CgAboXfzOGk8Q=;
	b=PoLh6PudS0BjE3n1O0oX8JRA/sl+m/hxYDVJ62R5jWpkJmvGh4A8/MkyjLKYY1Xi7AKKgQ
	a2iVNZCZQnk2R76Eunz5MDvMKqM8F0JTtUEwliTdPEsNU7agQEbok9tRJrzVSjOdOTBBQ9
	V857N3kYTx8JFbtY9sjgmXpVxQVIfhg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fgqx2Y8R;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780034232; a=rsa-sha256;
	cv=none;
	b=efXLesxgvjEQB485ogNcy+LJF41hoyS/+Ec6zt4VEIRLJuGw+hZzeQkvCvzHuwQy2qZRpv
	RY8zMRXxu8lBsn9g70NGipnUP3gMjB6olYr1phGdHpunJx8X0WrZlOLs3neN/aww1PNqEO
	SgMQkkbwtkf6N88TQ+oMkBXbdSCHRXQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC81C20E3;
	Thu, 28 May 2026 22:57:05 -0700 (PDT)
Received: from [10.164.19.8] (unknown [10.164.19.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08C023F7B4;
	Thu, 28 May 2026 22:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780034230; bh=xtznZdFjBfsx+x5Ya5ydKOlmG98EyGoHWLUMAFrCTzA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fgqx2Y8RR687yU7zdX7ZpAqBz6WeA7sNuW3FzjxAGEN1Z7gVhSnzL5ZXasdq2mGvp
	 905qzto8FzndnoeDZUaU/fLkjBxjXTkaV4N86n9HCvGjJVkq4Ksnd7IOMxL6ZT9FeW
	 9GMisM4bQxSR4tTSRIe40iHkFT2ePhj7hn4oYxlg=
Message-ID: <176c83fb-edf0-47b3-9823-21a92ea8b4c7@arm.com>
Date: Fri, 29 May 2026 11:27:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
 rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-6-jiangwenxiaomi@gmail.com>
 <340c811e-2501-46c3-8a55-19e955c5ae8a@arm.com>
 <CAHKocdHOT13DHdz+DsT2BaP0EJSKdoWU2NO-wjFwB9+--CqsHw@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAHKocdHOT13DHdz+DsT2BaP0EJSKdoWU2NO-wjFwB9+--CqsHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: efc6ztb57bw3dfkog9eio4zq4fsofky6
X-Rspamd-Queue-Id: 0DEC14000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780034231-303936
X-HE-Meta: U2FsdGVkX19kF7lR+DG4GDdo5Gge2dULfKkztEDz7aIDiHucRz7NWwzpXzB8uaRZNVyDomxvMzmd758tIG5tRyxQ3IzRwSkgzjrEWIPfLI5nDVvysi0qQhRY5vaKWWB4leEYdihMcms6xA4s4cUIcPzU7QRqSE8J2shwaRCNqgkkJ/FOArSA1OYjFSpLtu8Z+vwmT+RwF9JNIfZUSbRbY9qnDDkVVliybEtttQwXTKnMddXmQ+aVViVH65IODqNzqKBQbc46q/eYMTfyHjDCONkVaLdQs2rC9hRtSokNfI/OWMjlNnUyud5VgB8dd4l+yacRGpPJTGV3g6NJ7IGYDR9FU0UxFo6uXO4Vl1lrkew2Ngbi+pKb9ST8oZuHUw+wOcAEsmy5SzoS3Oq70R14zNiIT/o79TKBCj32Q0TFlx9RptbTcGownEXZaVHslreomu6zCXZS80Ocv+Zx42uAZMe+3bh6d3KW1LDESqrmbO+sz5t83FYoQUbnDRi6AyqiQ23q0PQwiYSDFMEP+oqdG3K2uk+sSnnbgxh3L8gY31/W0JUVrXO/HbezbWYI1hbavSVzCM9ifua/y3hMnIiPNeKCsaQruNap0i7qYEDgjU4EweUOXUFvBv82YkEmL9dvpdk5KnDw02CQ0OrN/Wy2wceWYhxByckLazYM06FADKHy6pT5XmTIal5hcY6XerijAArimB2kEv903CQ56T5ibN+F9DNf438kPnikN8N65EqfKccYK4Kzo5ASKkZ6Ar0Oit/TcjeySpwl3gLzWH4ALxWsxCNDxYODBQbY+3hys/hogXImjU5v8fg+50b0Vqv4i1cJQdvraoE3bK7b9MYNaMqgn8pgxI2lommQNxe1Vsyhj0zRPGcapzS4O2bBK7Ee0IrtmuVbi/j6qm0r5qh4YLnFO8K0ibsxV+UNJk8fVZHVNTBHTZl2XyVo+xxYxfEedca7mDM5SwpQnu8WrOc
 ccdF4SlP
 F0dapxUrtpbB2+BRpHgzvGMvuTcHHa3MYkXEa2ghNW1UQq4v6IoWiZK1gzhbSIB9/6QNo/6kS1wPbLPAfmJzr32YgLCK3nwMbEDaejT18pUOJOv8iMXCO8cLh06f9Lhpv3xxUzTld2xIIb1GzaGWsRNL6LHyq3Yu1FhRh4GtcQvpcTCoMdulSSpHzS/f8fBYZqqEEtFQ+rsVeh0mbFKxDSg/B5hht8fA2zHNhfVGV3ZDMSLMSFlDpvuynOAqQrbEYc1YxosUbAzFIFHSKRCyvWy4OxDUaNpFHcU+2sRQ5BOrq8ya/4rAZY2LxFS7ToSsNLq+5RmWSOM5l5YVhO2tKV6ALQ4JrZWtu40v/Uxez31twK21lqbNDs0wSlfv27JKlHdxETwRt/MU2o/DNp5NjECY8XZ2TzOTC7oB2bVRpIsClHIQUm8G6wqcwDTnVUASCOKftzXvaxaTW2tA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/26 9:12 am, Wen Jiang wrote:
> On Wed, 27 May 2026 at 16:28, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 22/05/26 11:01 am, Wen Jiang wrote:
>>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>>>
>>> In many cases, the pages passed to vmap() may include high-order
>>> pages. For example, the systemheap often allocates pages in descending
>>> order: order 8, then 4, then 0. Currently, vmap() iterates over every
>>> page individually—even pages inside a high-order block are handled
>>> one by one.
>>>
>>> This patch detects physically contiguous pages (regardless of whether
>>> they are compound or non-compound) by scanning with
>>> num_pages_contiguous(), and maps them as a single contiguous block
>>> whenever possible. The first page's pfn must be aligned to the
>>> mapping order for the batched mapping to be used.
>>>
>>> Pages with the same page_shift are coalesced and mapped via
>>> vmap_pages_range_noflush_walk() to avoid page table rewalk.
>>>
>>> As users typically allocate memory in descending orders (e.g.
>>> 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
>>> for contiguous pages since subsequent pages are likely order-0 as well.
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>> ---
>>>  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 80 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index deb764abc0571..50642246f4d40 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3542,6 +3542,84 @@ void vunmap(const void *addr)
>>>  }
>>>  EXPORT_SYMBOL(vunmap);
>>>
>>> +static inline int get_vmap_batch_order(struct page **pages,
>>> +             unsigned int max_steps, unsigned int idx)
>>> +{
>>> +     unsigned int nr_contig;
>>> +     int order;
>>> +
>>> +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
>>> +                     ioremap_max_page_shift == PAGE_SHIFT)
>>
>>
>> Why bail out on ioremap_max_page_shift == PAGE_SHIFT? The code
>> path for ioremap is different from vmap right?
>>
>>
> 
> ioremap_max_page_shift is under CONFIG_HAVE_ARCH_HUGE_VMAP which
> controls both ioremap and vmap huge mappings.

I don't get it. So with this patch if nohugeiomap is passed on kernel
cmdline, then vmap-huge is also disabled. That does not sound correct.
Currently ioremap_max_page_shift does not play at all with the normal
vmap code path. It is only involved in ioremap_page_range().


> 
>>> +             return 0;
>>> +
>>> +     nr_contig = num_pages_contiguous(&pages[idx], max_steps);
>>> +     if (nr_contig < 2)
>>> +             return 0;
>>> +
>>> +     order = fls(nr_contig) - 1;
>>> +
>>> +     if (arch_vmap_pte_supported_shift(PAGE_SIZE << order) == PAGE_SHIFT)
>>> +             return 0;

Also, for arches where this function does not do anything special
(i.e return PAGE_SHIFT), we will effectively not do any huge mappings
for them.


>>> +
>>> +     /* Ensure the first page's pfn is aligned to the order */
>>> +     if (!IS_ALIGNED(page_to_pfn(pages[idx]), 1 << order))
>>> +             return 0;

This condition is a bit fragile. It may happen that we have, say 2^8
contigous pages, but they are aligned to only 2^4. We are operating
on a page array and have no idea if the caller has passed some
random subrange of the array.

I think the purpose of these checks is this - to do an early bailout
if arch does not support huge mappings, or the alignment is not correct,
instead of finding this out very deep into vmap_pages_range_noflush_walk.

So you could do something like (completely untested and may miss some edge cases):

order = ilog2(nr_contig);

order = min(order, __ffs(page_to_pfn(pages[idx])));

order = vm_shift(PAGE_SIZE << order) - PAGE_SHIFT;

Where vm_shift() is the helper I had used in my patch.

>>> +
>>> +     return order;
>>> +}
>>> +
>>> +static int vmap_batched(unsigned long addr, unsigned long end,
>>> +             pgprot_t prot, struct page **pages)
>>> +{
>>> +     unsigned int count = (end - addr) >> PAGE_SHIFT;
>>> +     unsigned int prev_shift = 0, idx = 0;
>>> +     unsigned long start = addr, map_addr = addr;
>>> +     int err;
>>> +
>>> +     err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
>>> +                                             PAGE_SHIFT, GFP_KERNEL);
>>> +     if (err)
>>> +             goto out;
>>> +
>>> +     for (unsigned int i = 0; i < count; ) {
>>> +             unsigned int shift = PAGE_SHIFT +
>>> +                     get_vmap_batch_order(pages, count - i, i);
>>> +
>>> +             if (!i)
>>> +                     prev_shift = shift;
>>> +
>>> +             if (shift != prev_shift) {
>>> +                     err = vmap_pages_range_noflush_walk(map_addr, addr,
>>
>> It would be worth documenting vmap_pages_range_noflush_walk() that
>> it can take an array of pages which are not all contiguous, but it
>> may have contiguous chunks, as hinted by page_shift.
>>
>> Otherwise this looks good.
>>
>>> +                                     prot, pages + idx,
>>> +                                     min(prev_shift, PMD_SHIFT));
>>> +                     if (err)
>>> +                             goto out;
>>> +                     prev_shift = shift;
>>> +                     map_addr = addr;
>>> +                     idx = i;
>>> +             }
>>> +
>>> +             /*
>>> +              * Once small pages are encountered, the remaining pages
>>> +              * are likely small as well.
>>> +              */
>>> +             if (shift == PAGE_SHIFT)
>>> +                     break;
>>> +
>>> +             addr += 1UL << shift;
>>> +             i += 1U << (shift - PAGE_SHIFT);
>>> +     }
>>> +
>>> +     /* Remaining */
>>> +     if (map_addr < end)
>>> +             err = vmap_pages_range_noflush_walk(map_addr, end,
>>> +                             prot, pages + idx, min(prev_shift, PMD_SHIFT));
>>> +
>>> +out:
>>> +     flush_cache_vmap(start, end);
>>> +     return err;
>>> +}
>>> +
>>>  /**
>>>   * vmap - map an array of pages into virtually contiguous space
>>>   * @pages: array of page pointers
>>> @@ -3585,8 +3663,8 @@ void *vmap(struct page **pages, unsigned int count,
>>>               return NULL;
>>>
>>>       addr = (unsigned long)area->addr;
>>> -     if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
>>> -                             pages, PAGE_SHIFT) < 0) {
>>> +     if (vmap_batched(addr, addr + size, pgprot_nx(prot),
>>> +                             pages) < 0) {
>>>               vunmap(area->addr);
>>>               return NULL;
>>>       }
>>


