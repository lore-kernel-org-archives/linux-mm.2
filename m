Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F048D43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50D06B0005; Thu, 11 Dec 2025 22:56:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B025A6B0006; Thu, 11 Dec 2025 22:56:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18376B0007; Thu, 11 Dec 2025 22:56:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7CF6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:56:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24F3884EC8
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:56:06 +0000 (UTC)
X-FDA: 84209455932.11.8BFE07D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id F37F740002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:56:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765511764; a=rsa-sha256;
	cv=none;
	b=jHp4TcJFtTG+WSdo4fiSgv5DYTFwBqdAPWiRF7MBSLgYGRH4HoKd58y+BnR28IFA+QlKmd
	PuK0foB8QV5nouvx5N++A5wrtOuFRWlYfLyYAbIy3BEYEeI3bfhm7Ph1jbHBDS69KNdQKb
	Ln5QNRyQgYqKsRHGEVODXZJCApN74Bw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765511764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0/99pot1l48NrQK/S1jTn1DVlAAEGasXemlJ5x89sk=;
	b=23ieVljkix9f3tpr0oErXR6z/SXQ9SWLQ45kC0+JGETdYk0lMYSd1MKINxonbspPF3S1FT
	GtP4dQG30eIiGCB89lPgn6uWn4An7fvXhS3quDs2pfXZPdce3LY9GXXFpBS1GdPGN5OXEi
	kefVYr2D83aBboUCjfFl+5MbVi2u1NU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 930D71063;
	Thu, 11 Dec 2025 19:55:55 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF28B3F762;
	Thu, 11 Dec 2025 19:56:00 -0800 (PST)
Message-ID: <9baf5ba4-fe44-4b0b-a249-5535e68068f8@arm.com>
Date: Fri, 12 Dec 2025 09:25:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com> <aTn0FZig5a_DpTJg@fedora>
 <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com> <aTrlwpeQyvM9_FX-@milan>
 <f5bc0a98-3ab2-4dad-bf05-917528744ef7@arm.com> <aTrwN_C0JI7BuKeV@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aTrwN_C0JI7BuKeV@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F37F740002
X-Stat-Signature: c8jqpi57h7eoyjd9tb6ttkam3jqeqpg9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765511763-633618
X-HE-Meta: U2FsdGVkX18f5CbD5ZXqrKgwKheH7dOTfhBrrLgvGgmONAMStWcY9vlPmPIg4lMzjbpoTxRBlkleRZp5JOh+2gHvA/AORrmZb0ajXDtlr0CqbKUh2BAJIlzWohvSsr9TcFsYaJfsSri5OkUntbogytyPdmsW3/3SdtsasPLP6kWgIAXUxtXc3AjvzG7ywNrmOHtSlHfhbsGVeUBMejmHnUrtsWJJlm6K1O8tsjjN1T/0Q2bdhyD5Odb5w8QKHC6wwV/hemppHtEGPRC/2qrFnWbgz+shUEHvKmXDG9BBcNwoKlrSJjtSPAonQmS5PbAn4IJROEJ8udHeHYLO3bjKYP+jyzrHi/1iTYUGF8k/DDsBzdqCn/4raZQ7irahY1EUO3lhdXZufwtf40YSaPmcGiLjP/2ktAeowsdE6330cMpNRvch4ew/+Q7pcO1nBSKI6dzx0TX0WTIJfMbEPKh4pD0/a4ZCf3mRnZRpe0vxAkyFbqmYrYbVIc0I8GIOcG+sqvzyx70aOM50lzg02HSNphKHUCb1sdbkQmJ9wBtZVReJb3xOrAWM3N86hmiODOJprfq8NHFWZIRV4JR44wOu/bpPJocAwgYfqRt2oUlfi1wEJepxopE/XjK/vt2wozbvji9J2wfV0tskgB6jKvPUY1DBpk1irKQtEia+SBDbtEBrq/GTA1xVRJjF6gIev1sdoYqiP0bhNZFWxwoKkYjR6ddL4OT1RDxSx8Vne8GMAoYgKmWqdACRCk3+I8XzYrOFSD7Io4fZ76IQ854JJqRw8+Yp+Jwe9Jed7sS9g8NbDYg8SysWpD9ldSZFSiVzaNaCM/9N6UYmF7UxLrrk/5+Oz7jkNoWslSykhfVbjKAYncXlY48nFFF/3FAZzbj6G0BdquyhHk8ALiMHlexEZu1T9BjwcRPlkbrYKJiUATpyZeIdNsxJZFbhE5F8dy6be/GTIUjJsZxe2kvaqsbrujN
 GU5dLD+K
 bNXkNoMIBYnTfOKdfa0I5NVD7OyRnMSyckoLbYJwUcDplrw7aO9LtJ/oUutalw8vC553pPbWwt461ItQRKcCgRZGMpKdXUt/UXgK7M6Ymfe/+Cb+iAgaqfhRE62mOW8/N/cJkILHDgiLEg1mpYMO3AQRdDenNBuWWrrtqsSGR8W65p2u8nlDYi7X9CqMyIR2yZAYd7xFOHP5MMCvjX16AhCi80/eCuwHi/5g8ck/Gd7zXcNh6u8BLAw44cIzQk8nDi7jJqC6YFatXwqJvifQz5iQvJYvQHegeSiWL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/12/25 9:54 pm, Uladzislau Rezki wrote:
> On Thu, Dec 11, 2025 at 09:13:28PM +0530, Dev Jain wrote:
>> On 11/12/25 9:09 pm, Uladzislau Rezki wrote:
>>> On Thu, Dec 11, 2025 at 03:28:56PM +0000, Ryan Roberts wrote:
>>>> On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
>>>>> On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
>>>>>> Hi Vishal,
>>>>>>
>>>>>>
>>>>>> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
>>>>>>> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
>>>>>>> allocator. Rather than making requests to the buddy allocator for at
>>>>>>> most 100 pages at a time, we can eagerly request large order pages a
>>>>>>> smaller number of times.
>>>>>>>
>>>>>>> We still split the large order pages down to order-0 as the rest of the
>>>>>>> vmalloc code (and some callers) depend on it. We still defer to the bulk
>>>>>>> allocator and fallback path in case of order-0 pages or failure.
>>>>>>>
>>>>>>> Running 1000 iterations of allocations on a small 4GB system finds:
>>>>>>>
>>>>>>> 1000 2mb allocations:
>>>>>>> 	[Baseline]			[This patch]
>>>>>>> 	real    46.310s			real    0m34.582
>>>>>>> 	user    0.001s			user    0.006s
>>>>>>> 	sys     46.058s			sys     0m34.365s
>>>>>>>
>>>>>>> 10000 200kb allocations:
>>>>>>> 	[Baseline]			[This patch]
>>>>>>> 	real    56.104s			real    0m43.696
>>>>>>> 	user    0.001s			user    0.003s
>>>>>>> 	sys     55.375s			sys     0m42.995s
>>>>>> I'm seeing some big vmalloc micro benchmark regressions on arm64, for which
>>>>>> bisect is pointing to this patch.
>>>>> Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
>>>>> are expected for how the test module is currently written.
>>>> Hmm... simplistically, I'd say that either the tests are bad, in which case they
>>>> should be deleted, or they are good, in which case we shouldn't ignore the
>>>> regressions. Having tests that we learn to ignore is the worst of both worlds.
>>>>
>>> Uh.. Tests are for measure vmalloc performance and stressing. They can not be just
>>> removed :) In some sense they are synthetic, from the other hand they allow to find
>>> problems and bottle-necks + measure perf. You have identified regression with it :)
>>>
>>> I think, the problem is in the
>>>
>>> +   14.05%     0.11%  [kernel]          [k] remove_vm_area
>>> +   11.85%     1.82%  [kernel]          [k] __alloc_frozen_pages_noprof
>>> +   10.91%     0.36%  [kernel]          [k] __get_vm_area_node
>>> +   10.60%     7.58%  [kernel]          [k] insert_vmap_area
>>> +   10.02%     4.67%  [kernel]          [k] get_page_from_freelist
>>>
>>>
>>> get_page_from_freelist() call. With a patch it adds 10% of cycles on
>>> top whereas without patch i do not see the symbol at all, i.e. pages
>>> are obtained really fast from the pcp list, not from the body.
>>>
>>> The question is, why high-order pages are not end-up in the pcp-cache?
>>> I think it is due to the fact, that we split such pages and freeing them
>>> as order-0 one.
>> Please take a look at my RFC:
>>
>> https://lore.kernel.org/all/20251112110807.69958-1-dev.jain@arm.com/
>>
>> You are right, we allocate large folios but then split them up and free
>> them as basepages. In patch 2 I have proved (not rigorously) that pcp
>> draining is one of the issues.
>>
> You sent out RFC 12 of NOV :-/ I have missed those two patches from you,
> even though you put me into "to".
>
> Appreciate that you point me on your work. Let me have a look at this.
>
> Could you please resend RFC based on latest code-base?

Yup I'll do that. I was trying to get some perf numbers from LTP - fsstress,
but the variance seems to be high on the system I am testing. I would
appreciate if you or someone can run some benchmarks (filesystem is what I
believe would benefit).

>
> --
> Uladzislau Rezki
>

