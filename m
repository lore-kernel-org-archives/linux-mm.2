Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A846C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9896B0092; Mon, 20 Jul 2026 03:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3532B6B0093; Mon, 20 Jul 2026 03:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21ADA6B0095; Mon, 20 Jul 2026 03:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D79C86B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:50:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6486BA0790
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:50:13 +0000 (UTC)
X-FDA: 85008381906.10.9C34361
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55A82A0011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:50:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d+B7Jwzj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784533811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hbz4m11xQLaEtf8XVVJxSHy4D4sghpoBDJFK4GKy9w=;
	b=2NxoY8ep7BOYFmzem/ZCHHWWeYpmpe2N9DpHgfwCjkSlTvwYZrU4UziKlyLqsSDV+ayN1T
	UgLuC9TF5U/DUY68Wo9UYqmDFZM/sJyvyztUu0JLTR0Gg0Fiz3o5+0DypVkgEg/pfvhn1W
	fO1d+I++zajs5AmWeRUMRZ7ZLXDGlGY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d+B7Jwzj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784533811;
	b=iLSeqEB1qXzpXtb5qig7XXEW186EYPAg0vVJpXnUhJVGyNPK0pY6t8veuZFU7yoJh+3INv
	YL827i5pWkp5ZonJQ8rqnYZDXR/hpOOxPhVKctPBPopbZ1Ekb/V57w751p9J8pc8/ZGV0w
	uPjeKmjXFIbuYkKJjqrQY1HjdiYr0Ts=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 436AB2B;
	Mon, 20 Jul 2026 00:50:06 -0700 (PDT)
Received: from [10.164.19.57] (unknown [10.164.19.57])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 298693F86F;
	Mon, 20 Jul 2026 00:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784533810; bh=20qVoOi+T2bd14GUaGlaJo6iftl057+Jngsl1bAE5qU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d+B7JwzjApBVbNGi/lZVbeh8UDrT1DNYUjgEgWc2GIraJ4HHEnEOz05tgrJy8uOcR
	 ly5nI4ECdfjDFJ6B1IAFwgGREIjN1LaSc5DQ3enBRjZoQgzj8vCP7YoXH3VqFxvdtv
	 2TrrKsNOSbNa7mTY1F58riP357VHmop81eIHr/1s=
Message-ID: <e650604f-316c-48f6-8279-05c162bcdf21@arm.com>
Date: Mon, 20 Jul 2026 13:20:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/7] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, baohua@kernel.org,
 Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-7-jiangwen6@xiaomi.com>
 <fbea7f50-ee00-4466-8788-1cc78303f5bc@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <fbea7f50-ee00-4466-8788-1cc78303f5bc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 55A82A0011
X-Stat-Signature: d8wyb475jyh8ppqgcp9g3a6etmfpxiwy
X-Rspam-User: 
X-HE-Tag: 1784533811-312106
X-HE-Meta: U2FsdGVkX1/2OBNp1GGZXNN+H8v6AAV0Qbok60pL1vcxZE8tx4D4rcq8vi9H3x8pLIM7+ClXE/fIGocKm9kL2N2ARpn4RiU3zhdJsYqkuJ4Iu9azfDVavt5nJkm4Hm/SnOQlHYdJoFWihAphjUHBahsD0Nm6q8wvUkE1u5pnWVdhWEayjzs7tZ7CVKPDTpLiXlu55ymdUnjHYE0yYc2lOThj845y2EkdztLCbacwpJE4ZM/G4tBvymE2hRzJjLCrssUS6kGSyL02w8jN0I4pSpoRN83gr4v8pW9rpP0jrzL/OA7sXnxCNyd2OJey7/GfzEQXkIVmDVxSet11ZksVyUF57Mn4g8MzJOxWSbTN2b6b66a1+ySBcmH3UuZWHIJJPrW7Jqp6NTFvU9HPcvmzoVACN80HxONxPGWyRK9QJIYZNPvfOxH9p0LR5ynnspm4XDsgc4y6Huo6C10GmbUDriBkvQoRv34VKEkHYHBo6ZUsEDHtvEzeiaSDJU+StCz3KQd4ZwvD/hjslhGNGo5f1dILF+usv1SJdZ/3gdiYBz1Yf34RpKXpzS6C0b08L0O/adRLDxJoEH9/WX6EAOkbmLtOtabhlKUP5PFwN6FDlvhoQ33y4X7vF+FN+dkMA8BXHZ1ubF0G0w8F/rc5O4/oEb1Y6u5ZjEmJSp6UpX/PXTUu5t/QJcWYImEJB/UQP+p6upFYzG4OVJth5ULLGhJFWV9FV6/IIkZoD+2+y6KcVexZAzNn6tBoKdY7ZJMuKtuj1tYz/BOjbzmSAzUc/tKmgyfOpCAe9ow4gAfyaEUgDRDUaAOhhJkrTzizuf465H4prjxxR35Cij+LK2XOUyfTUx3WRzcFldW+L4pkofac/6fO5iWlo7gNyE5BlMhXyZvh5CCfbyJKonJRUkHlXk/zBpDT7JjlzJFvFN8fY4L6bdfn/027az54CvaHrKDWLRoaoXo5o6nBLKssHeLvuaH
 H5nAGgU/
 Je5f803YqISDdAqdYy5e1OLPOyhYmRqg14BqHtZBfvr1ArltBZIGs8ih7Xk3pafRV/WpHKqq+GrTECgmhiEfVS+OMt4u31OENvyZoqYV1twFDtVol/vDSsn3DktKjTsHqPx6D5JH/oc7TXygyEUPkBxqZ5/+7XnjQG3xjmV9xtMWSRgtI5paeF+1n8G7hV97T5TgGysJx8C3Xw+CCuMKrO5B7F47oQCts6/NWHg6eBqC0//QSu4hKjlz7BndptUCJtKU26Y4dYH9cGP+GEXNX2hOSAPneuim+rMdlll3nD/ka7SOTWXfE32rzsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[------]

>> +
>> +	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
>> +	if (nr_contig < 2)
>> +		return 0;
>> +
>> +	order = ilog2(nr_contig);
>> +	pfn = page_to_pfn(pages[idx]);
>> +
>> +	/* Limit order by pfn alignment */
>> +	if (pfn > 0)
>> +		order = min_t(int, order, __ffs(pfn));
> 
> Wouldn't it make sense to determine that before you call num_pages_contiguous?
> Because then, you can just scan to that maximum instead of the given nr_pages.

Right!


> 
>> +
>> +	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
>> +		return 0;
>> +
>> +	return order;
>> +}
>> +
>> +static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>> +		pgprot_t prot, struct page **pages)
>> +{
>> +	unsigned int count = (end - addr) >> PAGE_SHIFT;
> 
> "nr_pages" ? Also, can be const.
> 
>> +	unsigned int prev_shift = 0, idx = 0;
>> +	unsigned long map_addr = addr, batch_end = addr;
>> +	int err;
>> +
>> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
>> +					     PAGE_SHIFT, GFP_KERNEL);
> 
> Is the indentation on the second parameter line off?
> 
>> +	if (err)
>> +		goto out;
>> +
>> +	for (unsigned int i = 0; i < count; ) {
>> +		unsigned int shift = PAGE_SHIFT +
>> +			get_vmap_batch_order(pages, prot, count - i, i);
> 
> Having two indices, i and idx, is just confusing.
> 
> The whole function is a bit overly complicated. Does it really buy us much to
> batch over vmap_pages_range_noflush_walk() calling with the same shift?

It will buy us more in the sense that, vmap() speed is sensitive to the number
of pagetable walks. I think that is reflected by the ioremap(1MB) 1.35x speedup
mentioned in the cover letter.

In terms of callers, not sure. I would expect a caller to get the highest
power of 2 from the total needed nr_pages, then get the next highest power
of 2 from the remaining, and so on.

For the arm64 TRBE usecase, the relevant code is the rb_alloc_aux_page() caller in
kernel/events/ring_buffer.c. We may get multiple same order requests if can't
get the first requested higher order.

Since on the cover letter I see Wen and team have tested on boards, I lean
towards saying it is reasonable to assume a usecase where such order
fallback can happen.

But yeah the code for this currently is not so nice I agree.

> 
>> +
>> +		if (!i)
>> +			prev_shift = shift;
>> +
>> +		if (shift != prev_shift) {
>> +			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
>> +					prot, pages + idx, prev_shift);
>> +			if (err)
>> +				goto out;
>> +			prev_shift = shift;
>> +			map_addr = batch_end;
>> +			idx = i;
>> +		}
>> +
>> +		/*
>> +		 * Once small pages are encountered, the remaining pages
>> +		 * are likely small as well.
> 
> "small pages" is odd. Maybe
> 
> "Once we fail to batch pages, we expect to fail batching for all remaining
> pages, so just give up."
> 
>> +		 */
>> +		if (shift == PAGE_SHIFT)
>> +			break;
>> +
>> +		batch_end += 1UL << shift;
>> +		i += 1U << (shift - PAGE_SHIFT);
>> +	}
>> +
>> +	/* Remaining */
>> +	if (map_addr < end)
>> +		err = vmap_pages_range_noflush_walk(map_addr, end,
>> +				prot, pages + idx, prev_shift);
>> +
>> +out:
>> +	flush_cache_vmap(addr, end);
>> +	return err;
>> +}
>> +
>>  /**
>>   * vmap - map an array of pages into virtually contiguous space
>>   * @pages: array of page pointers
>> @@ -3600,8 +3678,8 @@ void *vmap(struct page **pages, unsigned int count,
>>  		return NULL;
>>
>>  	addr = (unsigned long)area->addr;
>> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
>> -				pages, PAGE_SHIFT) < 0) {
>> +	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
>> +				pages) < 0) {
> 
> Nit: single line would make that nicer to read.
> 


