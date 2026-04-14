Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF94F531F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1747F6B0088; Tue, 14 Apr 2026 03:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEA06B008A; Tue, 14 Apr 2026 03:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09086B0092; Tue, 14 Apr 2026 03:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA2D36B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:31:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88D891B807B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:31:28 +0000 (UTC)
X-FDA: 84656341056.14.72DB264
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B7CD180004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:31:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="PW/X3Bs6";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776151886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNl+LPO03zGJUgsQxiHE2yjg9/SCHM7uwbJqE6xVl3U=;
	b=I0FKZ77qhPh4imQLGVmExakgT9MRFmR7cr7D/973/IboMSCd1cMmbA8I1aXpnB4ZYtjHRJ
	Laq8sAyb6TdIR99+60H6/9vpZZVZrNIazltClRyJWmoJU9SmVayhga/Q/qnhhWLkaOTK6k
	0rLhMKPerItnqGFC3PhGjsfypjSD7uM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776151886; a=rsa-sha256;
	cv=none;
	b=XaJCTrYgG6jux3g3Vex6NcHemnlLCHdhaVexA/8w1cTm14Dlnldz8FrGi2+6kUtDNlDObf
	YdBYWymFpsNCtNoItTrpATHdXwxCl8T7X/hMRQBZF1TxrXJZAY5W2q65SZlZ9920EM+YaN
	E0dq0+i+TU9hGY8taPfOjy7yu1O2RE8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="PW/X3Bs6";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63C9F22F8;
	Tue, 14 Apr 2026 00:31:19 -0700 (PDT)
Received: from [10.57.89.16] (unknown [10.57.89.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19F6A3F7B4;
	Tue, 14 Apr 2026 00:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776151885; bh=1MTJayB2QhMtyhYQJ6koMdeIvmyUr+qdTV/ptmiRC80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PW/X3Bs6E85EfWr9rSt/SzrOZBqo2Z4jP8P2X7/0vy8jQSQnogPiKh53dCqYE6eZP
	 IEA53U+t5gFcZo1amxZ3m2s8E8I9AkQ0KeDF3rtSV3nXUipRR4XsSPfamLAKKpeV83
	 bHa0Hn3VYy3p0Hrhmx1hnWspzc6NTgKtxujDJTJ4=
Message-ID: <b5fde792-6b9d-4bd4-8a64-f3a270ceb621@arm.com>
Date: Tue, 14 Apr 2026 08:31:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, akpm@linux-foundation.org, shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 anshuman.khandual@arm.com, Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
 <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B7CD180004
X-Stat-Signature: 3yrwic7nhpmngwj5pu3ejtjef1gyhptc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776151886-955425
X-HE-Meta: U2FsdGVkX1/P8Yhp37RqZHQch7nlbPXpmczcSuB8ll20PR8duoD0UY9PR9B16Jt7Ruwb0FA53Wvn6tceAK3UBjt8ub8+B/ojQMRB9uxJMjZSSeumd4+tKXVYE+/3j7iTaOfUEsdNG+31XSJb86+zxJv1XGIQiFcv1Hh9+W+dDxmUJ/CNCOOktjISf0zj0PtcXKfDuaDjt7C9JES/QYxZ3SQoERR3J6Pgt95NvQXzbnqCjDIwIZGIbKqJoIouKBF3rwo6D7BjSQT3gWe26g/fYp0KDdX261UsDBKAN4jqYm1wOfWzSsQvWNpLrdwezwwPd7Dt3HgG9PVvxvMSvGM/1f1XNU+go/pMmukIwnFhUXoCS6Ccn/Ip5TITFLmHWIka9aRzPsvaC2ERmeZIRL+rHF93S2+6RiZANyVgCVZ96BXvmZUX2mp6i/z9/IYKZ/GDpIFRKWr6sgiRVxHZ8XnynJDtXkM1vkXntirFsVlYSrCAezFqLwMBUaUXmBs/XD/19XLRRGxdQjxaY2SS8bYm00ldaCGusz3xRQkgmpXZTOtmW9HZtdUmGifh5dB2Yaw+KGDvtDiSj6has8Sb6xPLyu9ErPzv9mG/G6yOBHmv6EJYY/7I3uX1aaTVr5yLYkhHv6SWQTCA50OiViWWugn2OmJxdX4gCof5OkumfCsYJDCeh5ne/yK6VDFqQwmF6aZmYATzE4bgFlaesY4OsyUb44l9OeGglO8b+4oB8NwqN89znxgEuAnMyr1ElTubZCTfa/v0jQ5/+3OdUuk71o2CzeYiN8WhIW8bvrG4qpNyNqkCpbHvN2KQDVGZd5YZ0OTXVNh/zj2m9sfkQrPNbHtGEeUnFUQIhNVe3rEAXLbLqEMWlN2L9nDMKOsk6z8VoW4HehuOm0W9ZEpzn7K7P9WoLK73lXWpTOvCV0pF0K+oIJa98xt9IFuh0xU4d+oMaMYIq6LnopKZhORcRS1biPa
 ltQ0CKCO
 Bpr+rmYXIVRarrgpYOJMQi2QhjeOmeKXh8LfhwZW/noJZKnPw1FH6vQPB0ovFskfVCyLPGwkL4n4vw7lIVywTl3qWv7RTe8LXVItm51rIcIBziJg8PQEg5vzHRk0UQfQJq8YHWcGd8qg2TLerlakELR0Cdf0NLUJqrOp/i/H1mSYqu+l0aj86KXYJDclVUncZsbVR1Q82uA2oL6RadhmaVDgnljByV7u/xV4zSBNbdBslIhb9FDUPjqwz8kHu5K5tL8FZe38Sd1qzVvd4PAuln8l2Ft/lXNO4r0TChd2m0q4YlX+k4qvaOeBYtck2rtB3s6d7kB6dInb0J6pnz1W5TZn9bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/04/2026 06:09, Dev Jain wrote:
> 
> 
> On 14/04/26 12:57 am, David Hildenbrand (Arm) wrote:
>> On 4/10/26 16:30, Dev Jain wrote:
>>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>>> mremap tests") validated remapped contents byte-by-byte and printed a
>>> mismatch index in case the bytes streams are not equal. That made
>>> validation expensive in both cases: for "no mismatch" (the common case when
>>> mremap is not buggy), it still walked all bytes in C; for "mismatch", it
>>> broke out of the loop after printing the mismatch index.
>>>
>>> Later, my commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>>> execution time from minutes to seconds using chunkwise memcmp") tried to
>>> optimize both cases by using chunk-wise memcmp() and only scanning bytes
>>> within a range which has been determined by memcmp as mismatching.
>>>
>>> But get_sqrt() in that commit is buggy: `high = mid - 1` is applied
>>> unconditionally. This makes the speed of checking the mismatch index
>>> suboptimal.
>>
>> So is that the only problem with 7033c6cc9620: the speed?
> 
> Yes.
> 
> I'll explain the algorithm in 7033c6cc9620.
> 
> The problem statement is: given two buffers of equal length n, find the
> first mismatch index.
> 
> Algorithm: Divide the buffers into sqrt(n) chunks. Do a memcmp() over
> each chunk. If all of them succeed, the buffers are equal, giving the
> result in O(sqrt(n)) * t, where t = time taken by memcmp().
> 
> Otherwise, worst case is that we find the mismatch in the last chunk.
> Now brute-force iterate this chunk to find the mismatch. Since chunk
> size is sqrt(n), complexity is again
> sqrt(n) * t + sqrt(n) = O(sqrt(n)) * t.
> 
> So if get_sqrt() computes a wrong square root, we lose this time
> complexity.
> 
> Maybe there is an optimal value of x = #number of chunks of the buffer,
> which may not be sqrt(n).
> 
> But given the information we have, a CS course on algorithms will
> say this is one of the optimal ways to do it.
> 
>>
>>>
>>> The mismatch index does not provide useful debugging value here: if
>>> validation fails, we know mremap behavior is wrong, and the specific byte
>>> offset does not make root-causing easier.
>>
>> Fully agreed.
>>
>>>
>>> So instead of fixing get_sqrt(), bite the bullet, drop mismatch index
>>> scanning and just compare the two byte streams with memcmp().
>>
>> How does this affect the execution time of the test?
> 
> I just checked with ./mremap_test -t 0, the variance is very high on my
> system.
> 
> In the common case of the test passing:
> 
> before patch, there are multiple sub-length calls to memcmp.
> after patch, there is a single full-length call to memcmp.
> 
> So the time should reduce but may not be very distinguishable.

My intuition would be the opposite; if you hafve a 4096 byte buffer, I would
have thought that a single memcmp would be significantly faster than sqrt(4096)
= 64 calls, each over 64 bytes.

If you want to keep the common case fast, but also find the first differing
offset on failure, I expect you can exploit the fact that the buffers are all
page aligned. With some prompting, Codex gave me this:


---8<---
static size_t first_mismatch_offset(const void *buf1, const void *buf2,
				    size_t len)
{
	const uint64_t *ptr1 = buf1;
	const uint64_t *ptr2 = buf2;
	size_t word;
	size_t words = len / sizeof(*ptr1);

	assert(!((uintptr_t)buf1 & (sizeof(*ptr1) - 1)));
	assert(!((uintptr_t)buf2 & (sizeof(*ptr2) - 1)));
	assert(!(len & (sizeof(*ptr1) - 1)));

	if (!memcmp(buf1, buf2, len))
		return len;

	for (word = 0; word < words; word++) {
		if (ptr1[word] != ptr2[word]) {
			const unsigned char *bytes1 =
				(const unsigned char *)&ptr1[word];
			const unsigned char *bytes2 =
				(const unsigned char *)&ptr2[word];
			size_t i;

			for (i = 0; i < sizeof(*ptr1); i++) {
				if (bytes1[i] != bytes2[i])
					return word * sizeof(*ptr1) + i;
			}
		}
	}

	return len;
}
---8<---

I've not benchmarked it though...

Thanks,
Ryan



> 
>>
>>>
>>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>
>> Fixes: 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution time
>> from minutes to seconds using chunkwise memcmp")
>>
>> ?
> 
> Not needed. 7033c6cc9620 does not create any incorrectness in the checking
> of mismatch index.
> 
>>
>>> ---
>>> Sorry for sending two patchsets the same day - the problem was made known
>>> to me today, and I couldn't help myself but fix it immediately, imagine
>>> my embarrassment when I found out that I made a typo in the binary search
>>> code which I had been writing consistently throughout college :)
>>
>> :)
>>
>>>
>>> Applies on mm-unstable.
>>>
>>>  tools/testing/selftests/mm/mremap_test.c | 109 +++--------------------
>>>  1 file changed, 10 insertions(+), 99 deletions(-)
>>
>> I mean, it certainly looks like a nice cleanup.
>>
> 


