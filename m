Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240F6F9D0C9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4486B0092; Tue, 14 Apr 2026 07:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685036B0093; Tue, 14 Apr 2026 07:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B466B0095; Tue, 14 Apr 2026 07:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4647D6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:57:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03BEA139E08
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:57:48 +0000 (UTC)
X-FDA: 84657012258.30.C24B951
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E05EC000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:57:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xfh+yOh7;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776167867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZWm1b3CJTwLAjjLGEBBwUidipKBroWTF5VLvtDoPzk=;
	b=0vEI4g/44T8OoUPTIEg6B5ul9OUGzbflfgRq0D1wK+ock8TiYfgEXH4acq5KkUKv06u9b8
	oEbI7kjfCrxnjKq/vQMj/Uw1BXUUtKJgx/vNdyqvt+bom2pY3uI68snLpjaPoUyRNX1LnC
	1vd8R+SX+LyhGjasmN3O3Uzkzx+YK1g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xfh+yOh7;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776167867; a=rsa-sha256;
	cv=none;
	b=A+x/WLt2nUREBFurHy9sk7reT5j8pWvj53uvImMkKNOghKL+KhKaaNBMcGMlerkN0HaIsp
	pNxedl6k3tCOWF5+DW9/PtP+QMXAgT5tzBiRybT+kWZqRCuz326Gds+521EUuIoJbWjgJD
	iHKrJxQtvrDOz19BzCiT+KbJPo2YnK8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F9424ECA;
	Tue, 14 Apr 2026 04:57:40 -0700 (PDT)
Received: from [10.164.148.48] (MacBook-Pro.blr.arm.com [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 313BD3F7B4;
	Tue, 14 Apr 2026 04:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776167866; bh=vOcBlgSM2qLFVSPVRbXMWVKLX9rgrZAYe2cLY0rvs9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xfh+yOh7yP8V2dV0b476IyBNP0d8VTve9M7b6Vpd2Bu9Drxe4L9RtIAQEf/EqG/FH
	 wtbo/Xoa4SX/r2Z9Z0xj7YeQ9gJiJrqr1tfyOVRv+bxFscG38LGjp7vpgrVs0cDRKc
	 0KoOPKll4JtHB4t7BJsji0QORq9u7O1qqqi6brX0=
Message-ID: <62baa8cd-eecc-41f4-88ab-f9605c7f2fcf@arm.com>
Date: Tue, 14 Apr 2026 17:27:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: Ryan Roberts <ryan.roberts@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 anshuman.khandual@arm.com, Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
 <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
 <b5fde792-6b9d-4bd4-8a64-f3a270ceb621@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <b5fde792-6b9d-4bd4-8a64-f3a270ceb621@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4i3xnwq6r9c3kkxh9e4gtpt7hy9bah6x
X-Rspamd-Queue-Id: 2E05EC000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1776167867-468251
X-HE-Meta: U2FsdGVkX19zhFsw8QYP/jbVo9NYSxaS3Bu1zfqa9L0h7Hp9j3fq2V4n0qWZbt5h45jD7sY3SqBBxjHnSQrulIlyWc7nPcDLLLkAkXL+w+gp+VonqmYtHGBQMJd5S8ZdqAkz8m9yC26ySy4I4OhBvsY/YJNPR2vQahe6W4qYBE5x1zM85yrzK9u89efy97jPQeuJUrRutXPgYUgfO/SKH/y1uzBm0AyiXI4Wv/5UbJlBdadc+63Deh3aL2nE1d8YC4/q5vNbzFfQwMyYENhRiD54BFH/cS3S/CxpmvbXEXot8btnDhme1QXSJ4LXSiczFP258u852+WrKQwRDm/hEj2z+ZeoK0BIUi88X2EU/8G3eq/wg+RsgOUBRz/RJ7teJ0EyYYCsxBtuE2vfNrVRPvfzTvrT/Op2ojaKfGnqmtCuRi/0RrgNzUMWmRGbX3ALYJilgO8eocZpOGRzl0OYsfx/Us0d0kk+HRi/PRIc7j1j13Gq2/SxgZXFXIxcRdJYKU6oG/yztjsy7UcUFRchy2hLWplgz7vCyIAkvHjo2MQ2dWw4j5SbSPUA8SB6boqltaRKC89qYV5/HWnDIjXx7faoyqsRaX6LYvnnTQ9+OeO59v8MFAdruBNFv9JLPXwEy0SNjGvICLvKt83siPIHTIxJBzP1bG3M4G5zdDw5hi7EBq/+o+E9gNIEJvUl0rx2XwkQ+ZDd/EcFc97Jz6uqe34Q9lCNNO81JSCfBdgcpF1IZLqmKgYOOqQfAvcpcrfxGCv30DE6vkT0YPez/ZSUpeS62u5cec+f8JxSo6sN7Ajr/tevsYPZiLp0e9uMlpH5BPuwA0MadK/hmE6z1pBQ7bFqX+Di9SlhugLsVMwD8YkkN458EYFuIe4EwYHTlZbi9GlD+yR5Gv0TNKc0LLDuX6x6wzzqZff8p7MEzkFKelbQbkbKTVOAHXGUmf0T1sMFnqDM/+uS6aF8r+EkwPO
 nKjoA4Ex
 obfbK739zHXPDVYPl2buZtlUO2PpiplI61SPQb2PUVTnTurR71X47C9VebDVOLGg6QoIyXu0X0g9QZcIUBLJ01ifYbInT0i9E8lkgDnXz/W6N8NMS487AlJcQoA/p3YY68N8Sk7UFZJDSJ6T/8ZdHlJ/K2R98jU8b6NF5yKqZ4ZxVDBLYqy9WB0CUTW2E73ODDirqeDy4dCxSWy4/CfOR8V1PDFEZ97skmZRpKsREWbldDb/UmX9513b+wgT2dob15DJFnL2c8xQCcRJsrlevXvpABos0XXGL6HH2e2+egEm0MOiSZxu9lnZEOcasD7CrNNc5Nw46qRBaD4pfzgapp4jaWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/04/26 1:01 pm, Ryan Roberts wrote:
> On 14/04/2026 06:09, Dev Jain wrote:
>>
>>
>> On 14/04/26 12:57 am, David Hildenbrand (Arm) wrote:
>>> On 4/10/26 16:30, Dev Jain wrote:
>>>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>>>> mremap tests") validated remapped contents byte-by-byte and printed a
>>>> mismatch index in case the bytes streams are not equal. That made
>>>> validation expensive in both cases: for "no mismatch" (the common case when
>>>> mremap is not buggy), it still walked all bytes in C; for "mismatch", it
>>>> broke out of the loop after printing the mismatch index.
>>>>
>>>> Later, my commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>>>> execution time from minutes to seconds using chunkwise memcmp") tried to
>>>> optimize both cases by using chunk-wise memcmp() and only scanning bytes
>>>> within a range which has been determined by memcmp as mismatching.
>>>>
>>>> But get_sqrt() in that commit is buggy: `high = mid - 1` is applied
>>>> unconditionally. This makes the speed of checking the mismatch index
>>>> suboptimal.
>>>
>>> So is that the only problem with 7033c6cc9620: the speed?
>>
>> Yes.
>>
>> I'll explain the algorithm in 7033c6cc9620.
>>
>> The problem statement is: given two buffers of equal length n, find the
>> first mismatch index.
>>
>> Algorithm: Divide the buffers into sqrt(n) chunks. Do a memcmp() over
>> each chunk. If all of them succeed, the buffers are equal, giving the
>> result in O(sqrt(n)) * t, where t = time taken by memcmp().
>>
>> Otherwise, worst case is that we find the mismatch in the last chunk.
>> Now brute-force iterate this chunk to find the mismatch. Since chunk
>> size is sqrt(n), complexity is again
>> sqrt(n) * t + sqrt(n) = O(sqrt(n)) * t.
>>
>> So if get_sqrt() computes a wrong square root, we lose this time
>> complexity.
>>
>> Maybe there is an optimal value of x = #number of chunks of the buffer,
>> which may not be sqrt(n).
>>
>> But given the information we have, a CS course on algorithms will
>> say this is one of the optimal ways to do it.
>>
>>>
>>>>
>>>> The mismatch index does not provide useful debugging value here: if
>>>> validation fails, we know mremap behavior is wrong, and the specific byte
>>>> offset does not make root-causing easier.
>>>
>>> Fully agreed.
>>>
>>>>
>>>> So instead of fixing get_sqrt(), bite the bullet, drop mismatch index
>>>> scanning and just compare the two byte streams with memcmp().
>>>
>>> How does this affect the execution time of the test?
>>
>> I just checked with ./mremap_test -t 0, the variance is very high on my
>> system.
>>
>> In the common case of the test passing:
>>
>> before patch, there are multiple sub-length calls to memcmp.
>> after patch, there is a single full-length call to memcmp.
>>
>> So the time should reduce but may not be very distinguishable.
> 
> My intuition would be the opposite; if you hafve a 4096 byte buffer, I would
> have thought that a single memcmp would be significantly faster than sqrt(4096)
> = 64 calls, each over 64 bytes.
> 
> If you want to keep the common case fast, but also find the first differing
> offset on failure, I expect you can exploit the fact that the buffers are all
> page aligned. With some prompting, Codex gave me this:
> 
> 
> ---8<---
> static size_t first_mismatch_offset(const void *buf1, const void *buf2,
> 				    size_t len)
> {
> 	const uint64_t *ptr1 = buf1;
> 	const uint64_t *ptr2 = buf2;
> 	size_t word;
> 	size_t words = len / sizeof(*ptr1);
> 
> 	assert(!((uintptr_t)buf1 & (sizeof(*ptr1) - 1)));
> 	assert(!((uintptr_t)buf2 & (sizeof(*ptr2) - 1)));
> 	assert(!(len & (sizeof(*ptr1) - 1)));
> 
> 	if (!memcmp(buf1, buf2, len))
> 		return len;
> 
> 	for (word = 0; word < words; word++) {
> 		if (ptr1[word] != ptr2[word]) {
> 			const unsigned char *bytes1 =
> 				(const unsigned char *)&ptr1[word];
> 			const unsigned char *bytes2 =
> 				(const unsigned char *)&ptr2[word];
> 			size_t i;
> 
> 			for (i = 0; i < sizeof(*ptr1); i++) {
> 				if (bytes1[i] != bytes2[i])
> 					return word * sizeof(*ptr1) + i;
> 			}
> 		}
> 	}
> 
> 	return len;
> }
> ---8<---
> 
> I've not benchmarked it though...

Interesting, thanks Ryan.

It may be faster from a constant-factor PoV - cache, CPU etc not from a
time complexity PoV.

But the point is that this is not a problem worthy of solving : )

> 
> Thanks,
> Ryan
> 
> 
> 
>>
>>>
>>>>
>>>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>
>>> Fixes: 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution time
>>> from minutes to seconds using chunkwise memcmp")
>>>
>>> ?
>>
>> Not needed. 7033c6cc9620 does not create any incorrectness in the checking
>> of mismatch index.
>>
>>>
>>>> ---
>>>> Sorry for sending two patchsets the same day - the problem was made known
>>>> to me today, and I couldn't help myself but fix it immediately, imagine
>>>> my embarrassment when I found out that I made a typo in the binary search
>>>> code which I had been writing consistently throughout college :)
>>>
>>> :)
>>>
>>>>
>>>> Applies on mm-unstable.
>>>>
>>>>  tools/testing/selftests/mm/mremap_test.c | 109 +++--------------------
>>>>  1 file changed, 10 insertions(+), 99 deletions(-)
>>>
>>> I mean, it certainly looks like a nice cleanup.
>>>
>>
> 


