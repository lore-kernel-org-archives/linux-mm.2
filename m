Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E66CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCE66B008C; Wed, 14 Oct 2026 04:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4676B0098; Wed, 14 Oct 2026 04:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A119C6B0099; Wed, 14 Oct 2026 04:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2736B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:38:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0234D8045C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:38:16 +0000 (UTC)
X-FDA: 85320579834.10.EEDEFBB
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2411220008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:38:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eWwoFvyt;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791967094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfozdcxqBChVvaf7D3SigXB2jJovmVY483zJua6pyIA=;
	b=v1lfOauXrYQGqyNvRWrOweY3HT8W8yteJH1iKZT4zhCLHwQhb6EHOh0rEtzYp/EGvWpUdV
	H9ulxEBAZUBN/+LZI25ryn1WcPpIdc2zRG5ZGiK/BVSMAan8wciWGnw/wOsLRCz7EH3Kcp
	fGl0JIiw1PAgQ3My7mAMjz6VMpVhr/Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eWwoFvyt;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791967094;
	b=gQHwB43jOsb9PkkEqIBuz34uq3dAR0sp//jqkEUlv9RRjjOPBUlp508D+EKQvdYtsJ17+y
	b9+7l1S+c+anTcSB5/yek81CZEXU9po0P1IE8xbbrnWOqtYcWF7j99VFH7Itz94EWzpk80
	F+LmCais11ExbqaXGse/e0/0rz8d0fQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791967090; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HfozdcxqBChVvaf7D3SigXB2jJovmVY483zJua6pyIA=;
	b=eWwoFvyt+6Vs8Gw1JxR3D6ied4VS1bp0brsxZKyW4i5n8zP+4+tJAW6h9CXQii2KbMWgwTepKhFQB70WKi4dVp2DGy9Ictpqvm+AYpVxU6wuHA2EzlWaglIrZwvDTzD9RfdtS1j0kDqP09XuzYwif6GDfeCu/QLry6KheXgAenA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCoZJ.D_1791967088;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCoZJ.D_1791967088 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 16:38:09 +0800
Message-ID: <a6feb3f1-c08d-4d54-a38b-55fafcfec7b8@linux.alibaba.com>
Date: Wed, 14 Oct 2026 16:38:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Lance Yang <lance.yang@linux.dev>, Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, mark.rutland@arm.com, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <20261013153953.77575-1-lance.yang@linux.dev>
 <516828fb-558d-4a20-9532-51f50d6ba042@bytedance.com>
 <f111bec5-6148-4649-8805-79a250f6e736@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <f111bec5-6148-4649-8805-79a250f6e736@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2411220008
X-Rspam-User: 
X-Stat-Signature: ybsgfgc8ifkisbd88kfiukx6gnocdz5r
X-HE-Tag: 1791967092-324105
X-HE-Meta: U2FsdGVkX1/1FBgn4hfMxdlAYv2OcjC6RU8Iz7/3ckcp7nkzobPj+YQg5boX4jrPUfdqEmSmNBA3tiuI1HW2e8Dr+Rs/AIlhkoLsk1AhGf5ylduAPD1tjmJwIrcviOfYAkPgYiNiRKPdVADsGzYQcGZUlInknmFEdG29zbaTdlUnfjdXXNr1VPmNquAZGb3TLlBSw1LRILx8PbM30h1nvS+e9tFJV7Sblj0D2H0AJXmSzkTUhbvgdfPp+/6fr0B0ujj3ojR378Uye6LowycHZEBKhqOcT3mzuEuXZRM9ku9Nb5oIxyXY1ZpDEZ6LwSjX6wOgGDz4AyFvjKFhwFMOTcBUldf4Gj6WYZAX5yGKSkKk3ZTZ+Tc/1tebromokFzI50gMTNDkl7NqmVq/OiDxjpNgl7CY6trExtTZfHtGTruwsvRRharZUBO27cZoNsOsw0qEM83TIxOhYeKri39Ax0sribG5t3Yi9Lm7nwzswpR49eF7qpkOm1CpkWlwPI9+HWXT6zCNYBVwtHvA0BefkWZahIoUhvTgU9Sq35YuWvX8gHaQL1DYRw+yS2Tvi8qDSO2QFcaO28YZYklCAH2t9ASAnj2xmUgvGwewGeSNU9BfRwrTEn5iei1I3O6ikUkVGEqa8wfBAeIwg8YcZsVenwQd7rKZC3Ulfp5KK3Q7RqOk/nL1SqT0CgPf57QRSSWFSXhmfayR9j1tb8QdJnQJ8hTtdvuaLMG5YzFSgAWK45GpnRpD8Lmt8i2zgdxhiJYbq+Er8x+V5UTf10y2UtCOB891N07TRM33eOEWjNv4OReGk+LlXEyHUvtnQDsW1usqwqj6Tu2gt62rgIMJF+ng+yVdu60jPD4uww/8WxX8hmcFOCxr0fjAYNzlFrUQuCYwIzR39cVFb1PI6noDmZW30kg7MJa3fJiNiWCUON/ZfqKGl6f3pdZmpJIZeE5FAen/hwuhGldujVUpZI5QGPI
 uqOMXPj7
 i/3Es7iC8osXU79qf5KuSWZi8ZW/Ujegntz1axgosSOKzwW5Hw8eeL/uoAm1fZlIeiuGmCuqX113ueWcltEElxvhlSxPRgm98I0ogIwx/OBNzI0x6LTZEuaMKD6/z8EzIu0XSiUKQDzgmH7gROKdBUv8+0KOEsFa57pt03JpjKlvwB5U9jGXr1Bs8TPTtYDuEL2Z2zOrqGhEyILpdt8koJkrlNNlHAIAFj8G+HJNFUXIQyTj1f3nUeOL3s8yqbgTfFZDQYeInwRoRyivkpDYtGnMi6JXv1KpwKz8jl1/XXO6qNjQ92287ZIfbRcHnJ+Sxrw9nfbIsYbpt8k4mupx2plYVKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 2:46 PM, Lance Yang wrote:
> 
> 
> On 2026/10/14 14:31, Zhao Gongyi wrote:
>> On 10/13/26 11:39 PM, Lance Yang wrote:
>>>>
>>>> +    /*
>>>> +     * Keep the producer-side invariant documented in pgtable.h 
>>>> true even
>>>> +     * if a direct caller passes an invalid descriptor with 
>>>> PTE_CONT set.
>>>> +     */
>>>> +    if (!pte_valid(pte))
>>>> +        return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
>>>
>>> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
>>> before we get here ... no? Why not fold !pte_valid(pte) into the
>>> !mm_is_user(mm) check below and return __set_ptes() directly?
>>>
>>>     if (!mm_is_user(mm) || !pte_valid(pte))
>>>         return __set_ptes(mm, addr, ptep, pte, nr);
>>>
>>> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
>>> rather add a VM_WARN_ON() to catch that. Silently clearing the bit would
>>> hide a caller bug :)
>>>
>>
>> Hi Lance,
>>
>> Thanks for taking a look.
> 
> Cheers!
> 
>> Yes, you are right. The public set_ptes() wrapper already strips PTE_CONT
>> before calling contpte_set_ptes(), so the pte_mknoncont() in the invalid
>> path is unnecessary for the current in-tree path.
>>
>> The issue I was trying to avoid is not that the incoming pte already has
>> PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/prot
>> and then adds PTE_CONT again based on alignment. For an invalid 
>> descriptor,
>> that transparent contiguous encoding should be skipped entirely.
>>
>> So your suggested shape makes sense to me. I will change this to return
>> through __set_ptes() directly for invalid descriptors, and add a warning
>> for any unexpected direct caller that passes an invalid PTE with PTE_CONT
>> set, e.g.:
>>
>>     if (!mm_is_user(mm) || !pte_valid(pte)) {
>>         VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));

mprotect() can trigger the warning here when setting PAGE_NONE for a 
batch of PTEs?

>>         return __set_ptes(mm, addr, ptep, pte, nr);

I am trying to convince myself that the 'nr' passed in is always 
CONT_PTE_SIZE aligned, but it seems OK.

