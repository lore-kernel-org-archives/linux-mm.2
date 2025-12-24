Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED930E7491B
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 06:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B006B0005; Wed, 24 Dec 2025 01:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2FB6B0088; Wed, 24 Dec 2025 01:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E18E6B008A; Wed, 24 Dec 2025 01:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F180F6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:35:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E6EA13B12C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:35:58 +0000 (UTC)
X-FDA: 84253404396.24.5F34670
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33082A0007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:35:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766558156; a=rsa-sha256;
	cv=none;
	b=2BUU2cMQNK7F50Qs+/cxdNyD6Bu6/5GitSD2u9Gre+UK12cRSY5aT+QE6pT7u5a65wzVjb
	p1rYLWCaCWxW+I6PTDrhVOsA539ocbwV/frepFcAtvVANUVuMN+5gRwrgSF72ZLacBH4ai
	A7wQN0I/Fwr+SlOjtxXGER+r9f/ZJW4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766558156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kQpbR6grljlWnC1lqDYgotib/aC9fa8Up8DdFvizSx0=;
	b=mixSgxQvYd2a89/uLCqh3WEbSyIZ0UvDLe+g9L1k43AcQN++Q1kEGYeHJpwEVPvebSilWi
	HZxPl2ygIm0CFg4C9D3IzO4TJ2f0s7JillH3Qa+v6RR3bKKJBW8KMfTMrWQDBR/QK4lZQO
	z2JLME3sBN+cV8mNwYQe1XIoSOSIMPA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29C7E339;
	Tue, 23 Dec 2025 22:35:48 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E06943F5A1;
	Tue, 23 Dec 2025 22:35:52 -0800 (PST)
Message-ID: <31e0d55f-b4a3-4b4c-8018-82d76c429d7b@arm.com>
Date: Wed, 24 Dec 2025 12:05:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
To: Ryan Roberts <ryan.roberts@arm.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <3d2fd706-917e-4c83-812b-73531a380275@arm.com>
 <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <8490ce0f-ef8d-4f83-8fe6-fd8ac21a4c75@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33082A0007
X-Stat-Signature: e5x79iadjedirmjustbf9tksnoqmyyin
X-HE-Tag: 1766558156-75117
X-HE-Meta: U2FsdGVkX19QNoWRW49SWJfhi6WYCPlSbs15u1C++49u/EZxga+EXVYT/KuQ8gtPUnz3StLfPivLSmLvarYu6S0k8ki1GZbMsc5McmreeBdrsHV4NwxeP6cE6+P4q2VrDQqMeL30tYgkw4So7BKDjqBzwBZwE8g9N1uwbYGfus5Ymx2GRY3w3XeduNaROMXVQUow8EErDouH87qwD6VCFy4NHgM6DTBTYIX/EzpJ12nP4Nh9XU8Q4b+/kjioPTWDaYOiq68yKYwyWdr3dGC8NAwQETUhEQIqWauxTXNcm2c4Oqvz4Hr0AwBIfdUjTxKWa/Chpp8DiZXMzNsP8kK8wQ5DsqGsxKz+v1gFAbdPvPICiUM5R+ViFyPwWDBcMEU2akORC+IeMZewX/522kNNKsWQqbA/Mlhq0UXWQmn7d5sganhXBM+J9eKSjsNaIScdKN6bWTC6yxbzPzP08FXCwdGOjQpA9n6bK1bjjqXGXrAuglZnCkYQ6VqWUPbY766l2N+pDT8vaaRXB5zD6v5c5maBTQiUQR3aDE4w4aq58qaNaglYaBrgU/vYy/xlsp33Pon86SZ53aGaz8PZv1Rty32p72Kv3YJlh5LAEFRB1rF/WSXA5SklDt6c0NOLBgrIn371bAy2EiIcrEA74SPvVV1y5o+PyUUQNQcIAMQRQ/hGol7ZLJ+1XB/lye07ovvowviCE3Qwy/JYtTrzMPRfZK3l2DEIOzhWoyJxfaj0cHNDiqya9Z9WAA8Jn1hNu1Zw97owqWRh0wTv8mbPFuoKBwKDJch05h9GdVXLrHVj+qlt6RTKkvD2ePnixzAYuGDhCrz3P76SS9oBgbZB1Q+JVDH/6UDLoYxcg0Zjk0Efeqj28kpmy/I/NENEwiQ11HLfX1XUfiVW51lnp/Dsgfl7Az/7Qfe36X/5Apk2hmoZTh8l8YREykURwH+gCu8y4LbjIYJKlsQpieCgxMobii7
 g+CkM3Nt
 9gDDr8h7suakWnwt3OAiFpmyvCsH1LA/Qcz+Z6c6T0AY9TSxjGVpQDG9srTqw3wWcvVp355pGG8vH2fnJVmFw3zcXXuDwl5N56Nu5Q+yUYmE483TcJguP7NJYP1aQirag77gbvHjKrZaG7XiihT9jPFWtmK+KjqEtHWkvWN2X+ViFoLTQO+Y/ZV3ZnScZBIQ7lXWejos7ZN3nqyUGq4JeHsbC0o8NgCkQHU0carA84qs3rNNTlkQwvbxWKtIDkXuFihuH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/12/25 5:23 pm, Ryan Roberts wrote:
> On 18/12/2025 04:55, Dev Jain wrote:
>> On 17/12/25 8:50 pm, Ryan Roberts wrote:
>>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
>>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
>>>>>> Introduce a module parameter to enable or disable the large-order
>>>>>> allocation path in vmalloc. High-order allocations are disabled by
>>>>>> default so far, but users may explicitly enable them at runtime if
>>>>>> desired.
>>>>>>
>>>>>> High-order pages allocated for vmalloc are immediately split into
>>>>>> order-0 pages and later freed as order-0, which means they do not
>>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
>>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>>>>> can affect performance.
>>>>>>
>>>>>> However, when the PCP caches are empty, high-order allocations may
>>>>>> show better performance characteristics especially for larger
>>>>>> allocation requests.
>>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
>>>>> else try large order, else fallback to order-0" Could that provide the best of
>>>>> all worlds without needing a configuration knob?
>>>>>
>>>> I am not sure, to me it looks like a bit odd. 
>>> Perhaps it would feel better if it was generalized to "first try allocation from
>>> PCP list, highest to lowest order, then try allocation from the buddy, highest
>>> to lowest order"?
>>>
>>>> Ideally it would be
>>>> good just free it as high-order page and not order-0 peaces.
>>> Yeah perhaps that's better. How about something like this (very lightly tested
>>> and no performance results yet):
>>>
>>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
>>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
>>> memory leaks when running mm selftests...)
>> Wow I wasn't aware that we can do this. I see that free_hotplug_page_range() in
>> arm64/mmu.c already does this - it computes order from size and passes it to
>> __free_pages().
> Hmm that looks dodgy to me. But I'm not sure I actually understand what is going
> on...

I think this is fine. This function frees either the altmap (in which no struct page is
freed), or the array of struct pages in the vmemmap:

free_map_bootmem -> vmmemap_free (altmap=NULL) -> unmap_hotplug_range(free_mapped=true, altmap=NULL) -> ultimately __free_pages.

free_map_bootmem is called from section_deactivate, and takes in a virtual address corresponding to the vmemmap struct pages.
This virtual address is retrieved from sparse_decode_mem_map (note that the return value of this function is misleading).


