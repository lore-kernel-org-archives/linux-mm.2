Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418B7D6554E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43F06B0005; Wed, 17 Dec 2025 06:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1756B0089; Wed, 17 Dec 2025 06:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD606B008A; Wed, 17 Dec 2025 06:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9E96B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:49:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A101409DA
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:49:21 +0000 (UTC)
X-FDA: 84228792522.12.F3592D4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4FBB540005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:49:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765972159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6+ZOjsvYG8O9Bnt0bUIqaH4t86FOOPqlpmxuCvO7uM=;
	b=t4kfrQeTYKm9jS2P9ruA84IaQhMciUdEjv/Os987CvxNbyUgVds1sjdS/SK89UZT6ruZcI
	FphitciCuPOnr4+vVymMjosgG1VNz+i8icI3NY3Ru5a87rkZzdlaBnQUaqE1WIcaC1d7qP
	shjaE0to1jx0AmlBrCjSay3dQuebeuo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765972159; a=rsa-sha256;
	cv=none;
	b=8A/EMy1pJFhP4tc6Bo9XZMR5w6IMLasdsUsVfsVRWF+7NZH4UV+VQ9vFmXBLvBJjk6KHG1
	7rxgwI06Y1YHLBomwzRt9OHCFpPPGJUZugRzJrJAGQnjb32Lz3SUxmm5c5HVLDz37isHgf
	BGN4+l/tEuao00aTAkBw9QdP2/Iu/Mc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 132DF1516;
	Wed, 17 Dec 2025 03:49:11 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 408D03F73B;
	Wed, 17 Dec 2025 03:49:16 -0800 (PST)
Message-ID: <1329f4ad-5fe1-41e8-97f4-0b58caf86fce@arm.com>
Date: Wed, 17 Dec 2025 17:19:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
To: Uladzislau Rezki <urezki@gmail.com>, Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com> <aUIpciUKUeclNk2s@MiWiFi-R3L-srv>
 <aUKXs_3bxLyMvTgu@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aUKXs_3bxLyMvTgu@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ynastjqqeiw78zj3tmewougugsgduqkj
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FBB540005
X-HE-Tag: 1765972159-36459
X-HE-Meta: U2FsdGVkX198V4LKB7Z17tZIqvjnxy3vbg8+Cp2Ss2fr3wHV/ww7OdVvlAwhKlY2P4JtQ6zBALUDmshohssykWfX9jyxHXS/tRVY1fhGog8Py5zZ8CZkuCLgXLRAmE68sKGcjW9kaWkZWzrEEJWIrvTAIRvbJdhHoDAQS94H+XEmji/uKIijaQXn/a8UH2OfzuzuyuxENsMp6mzsVQGMdy9kzhXndgcI73/WJYLjpvOp4tQnCRnEFKqREsnGaitzq1n3ybUBBQczmjDsk9jNcT7bvheN5kG8c0JYwoC8awAzBC+7x2rSjg9r2TkjGjSQNaD+TpnugCJsd3StxSKg96KWK2nVC3DmIP+RdY4SlhioigzSPh0H7LzG6c1PZDdZ4E2BCHRKnflVQG8UFnRBSAFW9WwhSEWK7cCNaCliVWNscsnz+SuTu+R8jy5zfG5RdjapzPWhdbxxs9V/3xy/9PibMlnDgNIt0jqjjy5AsyALj3vr3rWQ8BfRJbzLTtUld77ZuDV29vf/ScItdfQ+5PnR7E8zgt6jHcGX9mxsGguEtYQJDcP0kCMWd64jJTDwUmQ8hMzx4SZptZ/frJpLcVGRG/eCpZcyInl4LE++N2L+um4jjACo0+18nEr2e0/c+ahFIKOjfw3H238smZqxmX83eDXpvZDVUce707qD02q/2A1bhzAV8XPDIeDXaQUHE0dxXrWajrWuD3rZThjckgmmjXA7YYm4KDMQbnHPF4GzVNPLwnqlC/oHQLI9zN2idd81G8LulcsNRJA4CZDe1bfJVgm2r/GyUeHAmwSWmv/bP41BUH1UpEL/KoXw6TxQx+alvot1GZGYtA/0OA7n4uQPO4HrEATH82sWrkRUhxMWJOn9sqBqmbCcMjRLId6jpl+gNIo0xGLheDa4H3PZhfaC9VZka2redo6B3PdnDtTSATEF5i1GYWb3RVixWzZICVpdAWIt+UwNh9ro48q
 yvTGYhwp
 oibjdwpBfZoZ8/kaXHCMd92erg+srzfrwOVV1eILRUIsyNNJFFyxV4dMLhurV337Sdo4sv8LysTC4pHClPigYfaT8f8x8eIhX9Q9sWZ6PXNE+kMbe9PNm5f0P42Y8zPsf2LixbEDNg8hxhYRmCvF8/m1NfSIllHcAwsrylVHkWBbE8KPW6wBNRxMBorSPub/uHXz4ITyf5P9MoCDOnuHhB/yiDtbpmyyLQJJwY9cCIi/gifC5PlGaNoA3q5DLcR7yjdkwdjuKwZavaLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/12/25 5:14 pm, Uladzislau Rezki wrote:
> On Wed, Dec 17, 2025 at 11:54:26AM +0800, Baoquan He wrote:
>> Hi Uladzislau,
>>
>> On 12/16/25 at 10:19pm, Uladzislau Rezki (Sony) wrote:
>>> Introduce a module parameter to enable or disable the large-order
>>> allocation path in vmalloc. High-order allocations are disabled by
>>> default so far, but users may explicitly enable them at runtime if
>>> desired.
>>>
>>> High-order pages allocated for vmalloc are immediately split into
>>> order-0 pages and later freed as order-0, which means they do not
>>> feed the per-CPU page caches. As a result, high-order attempts tend
>> I don't get why order-0 do not feed the PCP caches.
>>
> "they" -> high-order pages. I should improve it.
>
>>> to bypass the PCP fastpath and fall back to the buddy allocator that
>>> can affect performance.
>>>
>>> However, when the PCP caches are empty, high-order allocations may
>>> show better performance characteristics especially for larger
>>> allocation requests.
>> And when PCP is empty, high-order alloc show better performance. Could
>> you please help elaborate a little more about them? Thanks.
>>
> This is what i/we measured. See below example:
>
> # default order-3
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3718592 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740495 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3737213 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740765 usec
>
> # patch order-3
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3350391 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3374568 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3286374 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3261335 usec
>
> why higher-order wins, i think it is less cyclesto get one big chunk from the
> buddy instead of looping and pick one by one.

I have the same observation that getting a higher-order chunk is faster than bulk allocating basepages.
(btw, I had resent my RFC, in case you missed!)

>
> --
> Uladzislau Rezki

