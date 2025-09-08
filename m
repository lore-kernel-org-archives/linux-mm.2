Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D3FCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 08:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A4E58E0006; Mon,  8 Sep 2025 04:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9521A8E0001; Mon,  8 Sep 2025 04:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840E38E0006; Mon,  8 Sep 2025 04:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 587328E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:13:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0639911B1BA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:13:43 +0000 (UTC)
X-FDA: 83865369126.06.CC100FA
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id C838A40003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:13:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PMZ3gWn5;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757319221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w104asye4dQPBM14xEIAY+w47JIy6lcQtIGWUqDYksg=;
	b=lXj1jte0NxUQaHpWNSDc3qtiMO65Dbn26vfe7JahMVflmH/8qHpx53i8/SZ0uFcD9LhltB
	K5uoUM3zhUrWVrH349JGzk0LOYYMblsBtiwP4zKKVLdiqJqS2n/5+yWPlPb5LJAj3DAv0w
	DmuUyszqAeMR4H7tmSJb/N9Fan5rgSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757319221; a=rsa-sha256;
	cv=none;
	b=J2JGY05ngDw1Th36rjMDDT2r9V5H0DRT7bmblEqXVKgOHsZ86z+zAjoKCxHnZC2xwVIie0
	jnbSpX803m6jyUkcByGko5xa70SJnFGmP+JDU15dF/0wtIdjg3q3m25wjOrAbxu/HCf8fT
	Y1iB4+qlgEa82TRwQkkxlM9qid4vT/s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PMZ3gWn5;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bc1182e7-3f70-4645-b8c4-a97898e57041@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757319218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w104asye4dQPBM14xEIAY+w47JIy6lcQtIGWUqDYksg=;
	b=PMZ3gWn5RLox4cEF7MNlYLQlI+O8S+N7tB5ZArAXTLyA9mD6jXXEnLu72tLpOyswDB+6CK
	w7WV09Rk7nLSg+AbYPq9jAVYIMUz40W1PoqbwmR6SV/FU06dVoEHcXh+jObj0oDylC4Zra
	P0Wssmz6tZvL/bgGwXQUpugaIqAIC2Q=
Date: Mon, 8 Sep 2025 16:13:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm: avoid processing mlocked THPs in deferred split
 shrinker
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com, akpm@linux-foundation.org
References: <20250908040713.42960-1-lance.yang@linux.dev>
 <5a1429ad-3900-404a-bdca-f25623ce603a@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <5a1429ad-3900-404a-bdca-f25623ce603a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C838A40003
X-Stat-Signature: unz8cxbkeh5ytehgcrncqnynqsajbejt
X-HE-Tag: 1757319220-455882
X-HE-Meta: U2FsdGVkX1/Q7VJdUYO/cEKygm4xwMIjNvXObbvPR3jLB0bR4Vol40OVaxPg3CEPKCcGT5ZG3HZTCgPHUh9yi93BkSrY2N0P4Gao+FSpz8knFkBbo6IZ8t69izrKWrcjtZWelLgNAKOkxhQA6OXnrbf9YMGDxLK7Nywq8hOq8vVi7MTzvxWLE5273lov8O7DTFRp8uN01Fc3gb67AeOwqBZ6cNolOLabPArMo6NvXk2ppvLgcBN4xk7XHv96PgoV2ToXauuWrGXOMxIElTeouQ2xV8sO+8rXKM8DTlKBzCMfCdEFSUHOqvY9erPulbSzC/px9zkZ4rHO0HBtlXoXPd126+MlWKVIgYSQnL3SuqrFCJwzuXzDjAznpwn8RHpj8FFaWyMurtfaWu0MKY8mMz6d0QVskmoiLmkFL/2TBFjGD1Vx3YLJMmhTW8ZvFdvEDuCMrHqzr0A3N8TEe/ovBH5S2lvRna/lTMUTqMITPwIKLPCtOBPF93ogj1d47Q4Gpv0b2svn+mTzXyhTI03C3plndqcpzfeQR/P/jUT2V/HYcx13UjAzZ8CrdoDlfiAP58P37sTuqE2d3Xyiw58Kmx4jdo7Br80APWEQR/jxQC0jOwL4pybEBUnYwfsryE+OpkZmBQA5AtSRnGd0oUbCtpdtKRHhG8p/kvFUCOjVtpURdUQLTFJXMicow8Xud7ycvW5YnjOMzGztldPiiiwsGHTC6QpXMqYZF3ruzctSfGj1Q5xrUC5IiC+TmnF789FkF3By4Ow1k8LB8SubiuDZ81BnDiQ1A/tWYRW50aM7+EAhiTZbcdybyurZ1d2GJUW9hPKxSlxn0bbPP0pc6Qf5ynsOXNsPFZ7w4q45albonPQM3AoNdIP+LojYRGGklcN/Mp/ZSQPWQ47gWQVHFFD5gX/GOMXUxOZR/Q3N/qefo4YT5ZZmwfcCEcnggirqYjP+ZfUzKN+vDCB/WNAuO1j
 ITpZkLiO
 QHarihf7gHvF2HvDSECMeZVP4Mr0pbQiYMD2vCl4LKe5gPtz0mk2/IU86yBCz1u4a1YpZYZSMA7OdccpZjIPja7LJkG3UiF1U4U6WD4nUg3Orm+CIg97pJkSM2nFXPWvlismf8yfIEJyo2e8YKtdkb4OEkSoCBJTtFrU8CkNtdhVp/iIaALd3g1BUH1NL3oMg0r9J7V1Dy+ydbFppRvdIjygUbxax1DCqeNdXn5ma4swfRL7XEfK+/qnqlI79z5xxlFIry+FFaKz9ec6z0iqtB21eHyi3r9vo2HUw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 15:38, David Hildenbrand wrote:
> On 08.09.25 06:07, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
> 
> Subject should likely be more specific:
> 
> mm: skip mlocked THPs that are underused early in deferred_split_scan()

Right, that's a much better and more precise subject. Thanks!

> 
>>
>> When a new THP is faulted in or collapsed, it is unconditionally added to
>> the deferred split queue. If this THP is subsequently mlocked, it remains
>> on the queue but is removed from the LRU and marked unevictable.
>>
>> During memory reclaim, deferred_split_scan() will still pick up this 
>> large
>> folio. Because it's not partially mapped, it will proceed to call
>> thp_underused() and then attempt to split_folio() to free all zero-filled
>> subpages.
>>
>> This is a pointless waste of CPU cycles. The folio is mlocked and
>> unevictable, so any attempt to reclaim memory from it via splitting is
>> doomed to fail.
> 
> I think the whole description is a bit misleading: we're not reclaiming
> memory from fully-mapped THPs even when they are underused, because it
> could violate mlock() semantics where we don't want a page fault+memory 
> allocation on next access.
> 
> So something like the following might be clearer.
> 
> "When we stumble over a fully-mapped THP in the deferred shrinker, it 
> does not make sense trying to detect whether it is underused, because 
> try_to_map_unused_to_zeropage(), called while splitting the folio, will 
> not actually replace any zero-ed pages by the shared zeropage.
> 
> Splitting the folio in that case does not make any sense, so let's not 
> even scan if the folio is underused.
> "

Nice, that makes it much clearer. My understanding was indeed imprecise.

> 
> 
> 
> If I run my reproducer from [1] and mlock() the pages just after 
> allocating them, then I essentially get
> 
> AnonHugePages:   1048576 kB
> 
> converted to
> 
> Anonymous:       1048580 kB
> 
> Which makes sense (no memory optimized out) as discussed above.

Yes, my reproducer also shows exactly that. It's clear a lot of work is
done but no memory is actually optimized out ;)

> 
> 
> [1] https://lkml.kernel.org/r/20250905141137.3529867-1-david@redhat.com
> 
>>
>> So, let's add an early folio_test_mlocked() check to skip this case.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/huge_memory.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 77f0c3417973..d2e84015d6b4 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4183,6 +4183,9 @@ static unsigned long deferred_split_scan(struct 
>> shrinker *shrink,
>>           bool underused = false;
>>           if (!folio_test_partially_mapped(folio)) {
>> +            /* An mlocked folio is not a candidate for the shrinker. */
> 
> /*
>   * See try_to_map_unused_to_zeropage(): we cannot optimize zero-filled
>   * pages after splitting an mlocked folio.
>   */

Got it. I'll update the changelog and this comment as suggested.

> 
>> +            if (folio_test_mlocked(folio))
>> +                goto next;
>>               underused = thp_underused(folio);
>>               if (!underused)
>>                   goto next;
> 
>

Cheers,
Lance

