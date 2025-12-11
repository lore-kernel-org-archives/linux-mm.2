Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9388ED41D5B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BACEC6B0005; Thu, 11 Dec 2025 10:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E466B0007; Thu, 11 Dec 2025 10:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7586B0008; Thu, 11 Dec 2025 10:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70C2B6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:36:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 267B512C9C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:36:01 +0000 (UTC)
X-FDA: 84207590922.26.8A05F0B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 42F1620025
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:35:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765467359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R1+h740r3JzMQ1tkUeEOeAkxOKOV/uerZyz/kgmnpSU=;
	b=sDGd9TZpqzxH9YuPcxz9wNUGT52gKLRdZ7p0hwbgyWVdPgkMq/o+2Ofibj4r8J6MQSW18C
	sxYfpzmvb7CJteeAeToubtzmnWNAmIfuZ2dGRh/bEB0r1JQz1eIOh+bXxfEbKtMxpqtlPY
	U5PSL1p6Y0LxAZtju7HPWJlXshH+05k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765467359; a=rsa-sha256;
	cv=none;
	b=pzn8+PRyZ6xAgzdjER2l7TN50PEKPOibwBXioHceyVJUOzNIldLIP00BAmjyMAnZPZagXB
	pnK/XVbOk9s5VM4vvKW/HjxxGusr31IyX5m3r12UXEQ8DoM/Rlzik2Xcm5AurivX7bQYO/
	6BlcQbAe2XvnRGcdWJ6b+wx2OpZGqOo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E5F51063;
	Thu, 11 Dec 2025 07:35:51 -0800 (PST)
Received: from [10.163.53.200] (unknown [10.163.53.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F3703F740;
	Thu, 11 Dec 2025 07:35:55 -0800 (PST)
Message-ID: <0fa1c315-70ef-46f3-95ec-feb3a75a10be@arm.com>
Date: Thu, 11 Dec 2025 21:05:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
To: Ryan Roberts <ryan.roberts@arm.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com> <aTn0FZig5a_DpTJg@fedora>
 <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: drmrtk54iua8b71iq8pobwnjnykxyrpq
X-Rspamd-Queue-Id: 42F1620025
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765467359-962174
X-HE-Meta: U2FsdGVkX1+ozDbNlauKtEkrTMOPHHe2WA5mvvbM1hUVTtWV45biWSWeW3UsTh+smPmbU4D3S6B7QsM1tKVMoNgb/aid5DX8tS/5oWeUYTT1IQzKIs8LTBbX8hN4+lUMTWUWUv1Q+Or9GwBYol25yP69P/h9IeprmRda2nhNX/5BoOpx8DwMB89AxNKSksA8jMhNd/D1ukQdId6wq0qj3x2KFbBGrDL0OPt4+YJUvrXrzTV3GdjIHB7eaD5L2EjCEmiAw+v6ez7Rduv4NOD2ulP/9EPxuazt1NtU+WklbZAM42KC6e9ozTGpWSDT+i889MYEvL1yeYtPfqN0hVh762n5pTiqhvbqRI69LC1WO31JyELvqB39WemzV+lqXC8mTWPK/b/RVsXc2kgO420QxOrRj83gUrA+kzmdGOYv6ewtnK36e1wJoGZKrhajEbF9Co91eyspcQhgDUxwMuAuh69819vRk3YOyBkoKSu6aQ08sW681R40cMBl8h0+1KojWayWOkXqpslXysNf4M4bzTpbWJhND181nSuc9k/mERyMApiL5jKqLmo9Dg8zEYGmWzRXXxEjVm+YdKVKTJR6YY6gAHCchdSDX56Tcr+J4A1lbyu0hRpVOM2YNfZsoeIZOMbxTy19tXRHy5dYjk65+j0OqkKH3YjIGVSY0bMdh26PvAx3ZBF66wga5PfeiAz/qkxrvAuNSjI2CWukw+crkivIrIHEfjBsuvcn0tHXsZMfa54iHImMrH/qQeZwIcP1dRTSE5BB/1+2EWmgyIXbvOWwt9SFVF5G7wUxR7we7vJM/qVJo5D/grYeMrp7iTgqvGwnQXC7HOF3cV4z7zdrvq7xpPfCR+LaYdPS48Z1Q+ARlzKfYnIqqNvKMCqAlCou66aJwcweLw9vw97eMFUlU6II5pnD23K2Bh6hrJNodThsgrpim9SfsSSmkXcFb5MSBS6pEQN2sLMNp0HFYb/
 uzstV33f
 HujssZn2HXPPk6SVnXdXnqCPOjdiQoj6JkT1+CM9s291p/X2vuHJyrdFXMOur6ygPUi1imxDMfPfl5di9GpoL5EMy2WMBtSAAEPr/abT2tRmqFVpji7J1iLuv3hg2gfozGxiowMzvcNzVMR9+S2UBwVvqH8nbQ+h/xSySqcQRnF+UH3HJ9zopPSljsgc6DWLpIeVFYSF57frfi3jUgj7y9v0cx8NsxvQATgI/r5LHD7ZgVZj3QVYm3/ugGVT1ohFERZStnlLjoYow+9N4HE+GLB52CCOi6sMYIcBS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/12/25 8:58 pm, Ryan Roberts wrote:
> On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
>> On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
>>> Hi Vishal,
>>>
>>>
>>> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
>>>> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
>>>> allocator. Rather than making requests to the buddy allocator for at
>>>> most 100 pages at a time, we can eagerly request large order pages a
>>>> smaller number of times.
>>>>
>>>> We still split the large order pages down to order-0 as the rest of the
>>>> vmalloc code (and some callers) depend on it. We still defer to the bulk
>>>> allocator and fallback path in case of order-0 pages or failure.
>>>>
>>>> Running 1000 iterations of allocations on a small 4GB system finds:
>>>>
>>>> 1000 2mb allocations:
>>>> 	[Baseline]			[This patch]
>>>> 	real    46.310s			real    0m34.582
>>>> 	user    0.001s			user    0.006s
>>>> 	sys     46.058s			sys     0m34.365s
>>>>
>>>> 10000 200kb allocations:
>>>> 	[Baseline]			[This patch]
>>>> 	real    56.104s			real    0m43.696
>>>> 	user    0.001s			user    0.003s
>>>> 	sys     55.375s			sys     0m42.995s
>>> I'm seeing some big vmalloc micro benchmark regressions on arm64, for which
>>> bisect is pointing to this patch.
>> Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
>> are expected for how the test module is currently written.
> Hmm... simplistically, I'd say that either the tests are bad, in which case they
> should be deleted, or they are good, in which case we shouldn't ignore the
> regressions. Having tests that we learn to ignore is the worst of both worlds.

AFAICR the test does some million-odd iterations by default, which is the real problem.
On my RFC [1] I notice that reducing the iterations reduces the regression - till
some multiple of ten thousand iterations, the regression is zero. Doing this
alloc->free a million freaking times messes up the buddy badly.

[1] https://lore.kernel.org/all/20251112110807.69958-1-dev.jain@arm.com/

>
> But I see your point about the allocation pattern not being very realistic.
>
>>> The tests are all originally from the vmalloc_test module. Note that (R)
>>> indicates a statistically significant regression and (I) indicates a
>>> statistically improvement.
>>>
>>> p is number of pages in the allocation, h is huge. So it looks like the
>>> regressions are all coming for the non-huge case, where we want to split to
>>> order-0.
>>>
>>> +---------------------------------+----------------------------------------------------------+------------+------------------------+
>>> | Benchmark                       | Result Class                                             |     6-18-0 |   6-18-0-gc2f2b01b74be |
>>> +=================================+==========================================================+============+========================+
>>> | micromm/vmalloc                 | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  514126.58 |            (R) -42.20% |
>>> |                                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |  320458.33 |                 -0.02% |
>>> |                                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  399680.33 |            (R) -23.43% |
>>> |                                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  788723.25 |            (R) -23.66% |
>>> |                                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |  979839.58 |                 -1.05% |
>>> |                                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  481454.58 |            (R) -23.99% |
>>> |                                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |  615924.00 |              (I) 2.56% |
>>> |                                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         | 1799224.08 |            (R) -23.28% |
>>> |                                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         | 2313859.25 |              (I) 3.43% |
>>> |                                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         | 3541904.75 |            (R) -23.86% |
>>> |                                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         | 3597577.25 |             (R) -2.97% |
>>> |                                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |  487021.83 |              (I) 4.95% |
>>> |                                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  344466.33 |                 -0.65% |
>>> |                                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  342484.25 |                 -1.58% |
>>> |                                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     | 4034901.17 |            (R) -25.35% |
>>> |                                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |  195973.42 |                  0.57% |
>>> |                                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  643489.33 |            (R) -47.63% |
>>> |                                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        | 2029261.33 |            (R) -27.88% |
>>> |                                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |   83557.08 |                 -0.22% |
>>> +---------------------------------+----------------------------------------------------------+------------+------------------------+
>>>
>>> I have a couple of thoughts from looking at the patch:
>>>
>>>   - Perhaps split_page() is the bulk of the cost? Previously for this case we
>>>     were allocating order-0 so there was no split to do. For h=1, split would
>>>     have already been called so that would explain why no regression for that
>>>     case?
>> For h=1, this patch shouldn't change (as long as nr_pages <
>> arch_vmap_{pte,pmd}_supported_shift). This is why you don't see regressions
>> in those cases.
> arm64 supports 64K contigous-mappings with vmalloc so once nr_pages >= 16 we can
> take the huge path.
>
>>>   - I guess we are bypassing the pcpu cache? Could this be having an effect? Dev
>>>     (cc'ed) did some similar investigation a while back and saw increased vmalloc
>>>     latencies when bypassing pcpu cache.
>> I'd say this is more a case of this test module targeting the pcpu
>> cache. The module allocates then frees one at a time, which promotes
>> reusing pcpu pages. [1] Has some numbers after modifying the test such
>> that all the allocations are made before freeing any.
> OK fair enough.
>
> We are seeing a bunch of other regressions in higher level benchmarks too; but
> haven't yet concluded what's causing those. I'll report back if this patch looks
> connected.
>
> Thanks,
> Ryan
>
>
>>>   - Philosophically is allocating physically contiguous memory when it is not
>>>     strictly needed the right thing to do? Large physically contiguous blocks are
>>>     a scarce resource so we don't want to waste them. Although I guess it could
>>>     be argued that this actually preserves the contiguous blocks because the
>>>     lifetime of all the pages is tied together. Anyway, I doubt this is the
>> This was the primary incentive for this patch :)
>>
>>>     reason for the slow down, since those benchmarks are not under memory
>>>     pressure.
>>>
>>> Anyway, it would be good to resolve the performance regressions if we can.
>> Imo, the appropriate way to address these is to modify the test module
>> as seen in [1].
>>
>> [1] https://lore.kernel.org/linux-mm/aPJ6lLf24TfW_1n7@milan/
>

