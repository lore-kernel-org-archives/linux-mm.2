Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AE3D41D61
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4E36B0005; Thu, 11 Dec 2025 10:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6661C6B0007; Thu, 11 Dec 2025 10:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D246B0008; Thu, 11 Dec 2025 10:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 402696B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:43:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04E4F88579
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:43:35 +0000 (UTC)
X-FDA: 84207610032.11.744DF45
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E8BD40004
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:43:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765467814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PhtmtkJXn5gbFcgiCnB5xVtpxEqMswT+Mxi/vcJZiTE=;
	b=QjWRk1dQ2ZPVqrFCrM0y1kTItt1Y2EM/FqTqIx6lu8b97eOI4eu11b0Jd45qnV6kjmItOo
	qtf1Kdd5AlDrpMyCSJzYDawErjYuCAbd2H9zMT6aslcP9NoD1ryqepdi12D3hYRdecI+ss
	LuN2UaanV3znYwBrUV9QSpgozlJXs40=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765467814; a=rsa-sha256;
	cv=none;
	b=EV6tPhH6bAi3cKwi/+4jUnKkUgw+sZaJP2UiSez4nJP1s341gUh18g5fOvsHSBStUHfdbs
	ci0HWNpVRyhkiyqHjzVxZ9SBvR1yRNunWTZT36sYkAJE2+WiPksxQfIxoMU26XOjBdtWTO
	I4bKzucjxCfz+ijgy/T8vZK3aQPFN6M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D4691063;
	Thu, 11 Dec 2025 07:43:26 -0800 (PST)
Received: from [10.163.53.200] (unknown [10.163.53.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52FC93F740;
	Thu, 11 Dec 2025 07:43:31 -0800 (PST)
Message-ID: <f5bc0a98-3ab2-4dad-bf05-917528744ef7@arm.com>
Date: Thu, 11 Dec 2025 21:13:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
To: Uladzislau Rezki <urezki@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com> <aTn0FZig5a_DpTJg@fedora>
 <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com> <aTrlwpeQyvM9_FX-@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aTrlwpeQyvM9_FX-@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: eimdr9n3p6rxqzj5dr9bkwifzick1zwc
X-Rspamd-Queue-Id: 2E8BD40004
X-Rspamd-Server: rspam06
X-HE-Tag: 1765467813-256053
X-HE-Meta: U2FsdGVkX18ixH56vYY8xJvSn6nrdTbmeiV9TYwg7TSAoggU7b0AiO9YBaJkZ41CFhh2QlpRJ3KINi4qQoIJwPj7wmmgnRygpljaptrSNc1FF82jEmfklxF+wc6NOxfcsh8hvYdVRgiP61bMh1rMzRSDAo0fLKknGwDqRSLvGm5JfU7InVWGQ6fHdSmLQDw8e4LsblWFbKSZlBJrIwUJKG/TdgZ4PSRaHjx/rnYxkdqgRuO0kMqez73Gn3Pel9VRrZJKM97rJc5BtFRFgV2syZYwL4i5pF8Q8Y6YlIdRPrDUnuWAwfKUQQ2c1YhifX2LY5ksLF5aDQXnQb8ipOUWEPZq9Ui0DxTJuP/0UH7UjrlmZM6quIj7wl9AXWMCfukboPkxDnTe7CLypHtj5qa4bHJkMthygxra61xAKObyLX0125RL854GBg30u71M62ZF0fSr9+M8pAaZm5dcvKe8y6FPx2ExgXjryuQ8ZHjLQbQCRYu2eKSyCM1TJIBofzU2WYhvAl0Uwb3lbrFaC8Q7iUaPQihmBFI1KTnPq6mgqncH7M/W/jmLxPh2cbzT5jx69UF5MJWs47AI0iLkiABR7qv0Lbqm6dRLpa+6fXxGWi586FV2/FF/7g/db2GECpcOEfYlM7NFabjUlird3Z4oJ3JqlSqfy9/7tBL4ldSkjtwJKtgfZN7mpBCMAQl86472rJ/AqW17k2TjTLJyHZSmY/4b7wLZTLEdvqPZIXYrwCxBQrGV6DeG84AfY8YMeX5UHqpd8Nge94WqBw5QOVHe4zbOOwR7t2BSZjK66t1jHrMi6BMDgM2NN963hL81AAh/5bzt3jl6kc73YmSwE9oDvbt0S/as5GtCR0p/oN28Dn6KYvwRmamvER3ZWWLo2v9YQh3yhWNhJWXVuX1dOxeEnCE2Jy0q1VtEGQ3l+ulmTchGcAGpvGEnGrrgWXFQCdtV4uEIdaouPvIsRRxEmb4
 cMmu3mT7
 YjGp89KF/ONvljK+U0XzS8T86TIyJW/RDV745uj+brlw6WdPSxLibO3+Q7Iv7XLpGh9QeIu8g36NAR8WDM6A6yAzLADsNEVZRVf7oQlx/RQUchwnzRjkttbUuxqVt8aY5uEXymsUrMxw9qG+FdrIRK3VcNDs88d7zxqepxh3OtCqgFigBVYSJtnl0BZVW+uSd9KoRz6qZEbB00GLpQAVwXARE+Km0cWVLfPrBAgSfGQkI4CeAJNreH3t7pCn/9ZZLBJzjSMY/BjMz72BqmJkTCTupVt9TMjBGrDw4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/12/25 9:09 pm, Uladzislau Rezki wrote:
> On Thu, Dec 11, 2025 at 03:28:56PM +0000, Ryan Roberts wrote:
>> On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
>>> On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
>>>> Hi Vishal,
>>>>
>>>>
>>>> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
>>>>> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
>>>>> allocator. Rather than making requests to the buddy allocator for at
>>>>> most 100 pages at a time, we can eagerly request large order pages a
>>>>> smaller number of times.
>>>>>
>>>>> We still split the large order pages down to order-0 as the rest of the
>>>>> vmalloc code (and some callers) depend on it. We still defer to the bulk
>>>>> allocator and fallback path in case of order-0 pages or failure.
>>>>>
>>>>> Running 1000 iterations of allocations on a small 4GB system finds:
>>>>>
>>>>> 1000 2mb allocations:
>>>>> 	[Baseline]			[This patch]
>>>>> 	real    46.310s			real    0m34.582
>>>>> 	user    0.001s			user    0.006s
>>>>> 	sys     46.058s			sys     0m34.365s
>>>>>
>>>>> 10000 200kb allocations:
>>>>> 	[Baseline]			[This patch]
>>>>> 	real    56.104s			real    0m43.696
>>>>> 	user    0.001s			user    0.003s
>>>>> 	sys     55.375s			sys     0m42.995s
>>>> I'm seeing some big vmalloc micro benchmark regressions on arm64, for which
>>>> bisect is pointing to this patch.
>>> Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
>>> are expected for how the test module is currently written.
>> Hmm... simplistically, I'd say that either the tests are bad, in which case they
>> should be deleted, or they are good, in which case we shouldn't ignore the
>> regressions. Having tests that we learn to ignore is the worst of both worlds.
>>
> Uh.. Tests are for measure vmalloc performance and stressing. They can not be just
> removed :) In some sense they are synthetic, from the other hand they allow to find
> problems and bottle-necks + measure perf. You have identified regression with it :)
>
> I think, the problem is in the
>
> +   14.05%     0.11%  [kernel]          [k] remove_vm_area
> +   11.85%     1.82%  [kernel]          [k] __alloc_frozen_pages_noprof
> +   10.91%     0.36%  [kernel]          [k] __get_vm_area_node
> +   10.60%     7.58%  [kernel]          [k] insert_vmap_area
> +   10.02%     4.67%  [kernel]          [k] get_page_from_freelist
>
>
> get_page_from_freelist() call. With a patch it adds 10% of cycles on
> top whereas without patch i do not see the symbol at all, i.e. pages
> are obtained really fast from the pcp list, not from the body.
>
> The question is, why high-order pages are not end-up in the pcp-cache?
> I think it is due to the fact, that we split such pages and freeing them
> as order-0 one.

Please take a look at my RFC:

https://lore.kernel.org/all/20251112110807.69958-1-dev.jain@arm.com/

You are right, we allocate large folios but then split them up and free
them as basepages. In patch 2 I have proved (not rigorously) that pcp
draining is one of the issues.

>
> Any thoughts?
>
> --
> Uladzislau Rezki
>

