Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA086EA3C21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFCD6B008A; Thu,  9 Apr 2026 06:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7996B008C; Thu,  9 Apr 2026 06:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315636B0092; Thu,  9 Apr 2026 06:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 215C46B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:10:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B66B61606C6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:10:55 +0000 (UTC)
X-FDA: 84638598870.08.AC18EEB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F061100007
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:10:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DoXJefwm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775729454; a=rsa-sha256;
	cv=none;
	b=1zqtOzGZ5/ho+XzZ5f9D4Lwim13GofCm0WuxPaQRE6P0/yjYIej+ihaFfXWPaMtiXVDJSV
	5YPGEAIauw08Utm/S4woPxORu1XAUO5UKFTRBuWZ3FWmCGVYQTCQcjZmAnneT4tGDsxN2f
	cXHiUKeCI6tt+XNYRIk1lcYhCIfpIcw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DoXJefwm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775729454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2FigYED1pze1+QNonRTD2+UmVbmoc123ryoS8VxaOU=;
	b=sqSRHs1eLZfmP8/EG+Li7tfLJbFn+DlowuKdM8yHk9Rx/fydA9104rL6jSmm1WPUHxzG41
	csbZpemc27TKYUGpi0AsYpLRpu1NLKUkqhnI957fT/sh6cUuMB0a/VTKs45hXD9ouQ2lpB
	JCvkRqeEzn9dGq0Qwwt3+BjMy9EdVcA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73DAE3297;
	Thu,  9 Apr 2026 03:10:46 -0700 (PDT)
Received: from [10.164.148.43] (unknown [10.164.148.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A9393F632;
	Thu,  9 Apr 2026 03:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775729452; bh=xIGIsShfGZskdnuFPNvuPLkTAert80RGZC2aB1q7CjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DoXJefwmEF4Xv70LZdkYk6MtFwB06HynMMQiS9dxHAGyDBhDs6tIQxU6JqGlaxxT1
	 5l0KuSbVXUsmv7dZFj7pBdLci58Ix28p+xTpPcqqgCgREtAbIg718vw3jXbj/yM9py
	 6vibhorVUqWAuDsmXYGl7v3TKTbr8WA+aB2BJdKI=
Message-ID: <46fbd241-4d64-409a-b9dc-77e778ca088e@arm.com>
Date: Thu, 9 Apr 2026 15:40:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-6-baohua@kernel.org>
 <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com>
 <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F061100007
X-Stat-Signature: bo535cifwdq59hc8scj98tx5wda8wkox
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775729453-228618
X-HE-Meta: U2FsdGVkX1+GBxRZ3m/smxcNfMeN9nQveq1Bj8w2N5LZDTLVIwcGIFiKr6QoT67qjbJDXNYDhyBJ5kAJ4tnthiT6d5OcY/mcZq97MEfT4oeAO9y0dKtiTUu8F3MzXjCTxyEgyag1J9aceAMXQ5jbwQq820v0itvqIYY3U4Wr/Naw2pMtHMAou0fLO9WAWjsLH9VDk+cviVu5fQl7ANE/0flx27YitkB1yMbu89KHlyyaNwGDNL3D+71itqYsvy4jrIp1pZchdFpFr5R/Sal0SPrnhS0YtvuJpG4qIKGQweP9hQB3CopxgxISYSw+4tdMvWyfSAVjrhU5zxC53QsTaiRjLmKYRsEAXN8UjlNyOxqXZVVOy24t3ML7iwicjdElVHO/KJjyhjZKdiFw8pWxXbgC9W1+pgbWNAtp2GpPPjPzCeWF9vtKHEpI0sjm7lDz2tPof+rLw0PNJbWyUWoH9zuUhcpKwPD+FSnN/Ae1hv3jB1+1i51GnUv/luSYZcZsuefj5xljbed9SkLIJpq6zy20kq0gKH4ObvTAzNBb5iFel9B7G8u22hbf3V8kVTz4e17MQtaUGeHX9vOENPO1Gi5HZ9kq/4MO3fRDgyvxWdwHOPcKv5g1Z5CS+b7CXFwnRqBJetsVOsm3iKUBdXDn81G7bldQHj0oiZZX9hCsGjsGPd9TIJfWFRmj3fEs/rTmgjzoClEwdVJQv0vADtmXvxRZozwtNAgsKbAXwyufOHQdx0cxfoQjir6wcyleBt6/bEi16KgOiGyXpW9+4n1PWPusws7/fAVQZhzXkOuc9S7sxgCQJwt5OwdbI9kY6y+W3rlyGecXX6I9xgwMzbxDstEkPESCjP/DMewMXzcfXT4Cg/l3uVuYLNBL1sX+ZBIPyvMAoXOWhQnVrBwdyafBj5+zI2QS+9FWZ33p9dXb+VChPfO0YPofqAFmHE2CYuiL7iKKdtKlNICkbCPAS2J
 83IQxig4
 MPE8M1RlAK1l3QT2OI4U8qqR6nQ+H/Z95uDkCSN7RDkWWSKHYhA384nZpH8qwR0CXZ3aKWCDLzNARQBQQsnsFhcGETYAW6FxrJEqpk/yKkBWz0sJiNbcDxsdU2iikHRYh3VP+SPl1YzIFdfgziM0abMuRq5EKh7tyn8zHVwI6WP4I237sv65QWrQJx2+HXGhwmLt+DUrf+urSMjUw77FYylZmtlR3nBV0CfSvZWgzbVcqR8GZpcrlyI81e/mPqGSQChz9dKkcbt1uV0rqpa+YImffkdJTRSl33nxDtRUtFCwnzJSVTHEire4yxl91a/Q7AHPyz0NdPD1mf2Cv6Ey3ZgdVT/OgbHh0ZMesBSja5Y+n2gv4J5QfFmvwhJWqtvoz8Myr3OOh4uQ/Ejev8OUNHyr4KYo29cr+mEoH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/04/26 3:24 am, Barry Song wrote:
> On Wed, Apr 8, 2026 at 10:03 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
>>> In many cases, the pages passed to vmap() may include high-order
>>> pages allocated with __GFP_COMP flags. For example, the systemheap
>>> often allocates pages in descending order: order 8, then 4, then 0.
>>> Currently, vmap() iterates over every page individually—even pages
>>> inside a high-order block are handled one by one.
>>>
>>> This patch detects high-order pages and maps them as a single
>>> contiguous block whenever possible.
>>>
>>> An alternative would be to implement a new API, vmap_sg(), but that
>>> change seems to be large in scope.
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> ---
>>>  mm/vmalloc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 49 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index eba436386929..e8dbfada42bc 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3529,6 +3529,53 @@ void vunmap(const void *addr)
>>>  }
>>>  EXPORT_SYMBOL(vunmap);
>>>
>>> +static inline int get_vmap_batch_order(struct page **pages,
>>> +             unsigned int max_steps, unsigned int idx)
>>> +{
>>> +     unsigned int nr_pages;
>>> +
>>> +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
>>> +                     ioremap_max_page_shift == PAGE_SHIFT)
>>> +             return 0;
>>> +
>>> +     nr_pages = compound_nr(pages[idx]);
>>> +     if (nr_pages == 1 || max_steps < nr_pages)
>>> +             return 0;
>>
>> This assumes that the page array passed to vmap() will have compound pages
>> if it is a higher order allocation.
>>
>> See rb_alloc_aux_page(). It gets higher-order allocations without passing
>> GFP_COMP.
>>
>> That is why my implementation does not assume anything about the property
>> of the pages.
> 
> If you’re asking about support for non-compound pages, I think
> that’s fine. My current use case is dma-buf, where pages are
> compound. I recall discussing this previously with David and
> Uladzislau.
> 
> If you’re working with non-compound pages, I’m happy to add
> support in the next version. I’m also happy to reuse some of your
> code and credit you as Co-developed-by if you’re willing. I actually
> prefer your __vmap_huge() name over my
> vmap_contig_pages_range().
> 
> Does that make sense to you?

Yeah it will perhaps be better to have a fast-path detecting compound
pages, and if not then checking contiguity. So sure please go ahead
sharing some of my code and you can co-credit me.


> 
>>
>> Also it may be useful to do regression-testing for the common case of
>> vmap() with a single page (assuming it is common, I don't know), in
>> which case we may have to special case it.
> 
> I agree, so I had Xueyuan test single pages and highlighted this
> in the cover letter. There is no regression: "vmap() is 5.6×
> faster when memory includes some order-8 pages, with no
> regression observed for order-0 pages."
> 
>>
>> My implementation requires opting in with VM_ALLOW_HUGE_VMAP - I suspect
>> you may run into problems if you make vmap() do huge-mappings as best-effort
>> by default. I am guessing this because ...
>>
>> Drivers can operate on individual pages, so vmalloc() calls split_page()
>> and then does the block/cont mappings. This same issue should be present
>> with vmap() too? In which case if we are to do huge-mappings by default
>> then we can do split_page() after detecting contiguous chunks.
>>
>> But ... that may create problems for the caller of vmap() - vmap now
>> has the changed the properties of the pages.
> 
> I don’t see this as a problem at all. Splitting pages does not
> affect physical or virtual contiguity; it only changes the
> contents of struct page objects, not the PTE/PMD mappings.
> For ioremap, there isn’t even a struct page, yet the mappings
> can still be huge.

Okay so I was under the impression that *not* splitting the page
will be problematic.

But, vmalloc splits pages because the caller can operate on
individual struct pages by vmalloc_to_page(). To the contrary,
since the caller of vmap() decides what kind of pages to
virtually-map, we don't have the problem I was raising. So
I guess we are fine by making vmap do huge-mappings by default.

> 
> Thanks
> Barry


