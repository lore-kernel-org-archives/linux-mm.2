Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05A7ED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BDC6B0088; Tue, 14 Apr 2026 04:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72BC6B008A; Tue, 14 Apr 2026 04:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88CF6B0093; Tue, 14 Apr 2026 04:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7E6B6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:02:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75E12B9629
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:02:06 +0000 (UTC)
X-FDA: 84656418252.20.B7931BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BBD6D180004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:02:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDvA0e24;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776153724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urvgN/yMTuNv2BuuzZttwqyWHQHT9owBAejZd95LjtU=;
	b=zBmt0cFd6YyE76MU62CktfaGAx1OGOit3j+L76Rug9FOICyusaA36TEYj8jsbZTvJkIHnf
	yibejhhTZVbj8aAq46MnhXaqmTfMhVqpBqyrMUzcHfHffyhrc2342z+dhgZOLe+AFKHBh8
	Xv+5kMK3RMJgMDu3ENMyi46QYIAQ0wE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDvA0e24;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776153724; a=rsa-sha256;
	cv=none;
	b=4BPRQm6HtP9adYBXrBKGXcKD1EF3ZTuAQs164epoFZnsycZMsSzmVpjPzupIlat8YeYx/L
	3SjQezXm09IdEZCaK73HG7Y/pH3us6i+4WdYlzngekmDooMRyPQHsigRvCphH6Z4LbXFos
	dQOuy4OUsuIu/VnIrcYU4aWVeQmy1y0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2425D60018;
	Tue, 14 Apr 2026 08:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ADDC2BCB5;
	Tue, 14 Apr 2026 08:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776153723;
	bh=L8/Ms4z3Rfz0P3/99Pl/TB9+7FARk+jRgE/Haq9jXI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vDvA0e24lF0uHA7W8Hr/ombykHCqFZVvXqNiiHT6/2EAeS9Gc2cqt57O7eJk1eUeQ
	 5NPjTrjsEdn0i5lX+iaON5WqxPWI+bpVVe3fJheunC0OGoXhVjKKe1NYvPU1i301c/
	 X5P2PRdHbYoKKgo88iWffT6rD0ruCFFR7IQ/rbBeS+FqngMNtyvBCmFql+26hkJZG0
	 JF82EdrRYmQPutI/L1jzILn0LvumPO23JXzd7l+X4nrbTaC1Vlo2a8unfgDJssSqKB
	 VUi17DQvGb0LIqssR9wDhV1QEAuj5wVVKU8QVTCusTF1B/43PY/jvlIzA1LOKQy2DF
	 XTTzo1PHP9J8w==
Message-ID: <134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
Date: Tue, 14 Apr 2026 10:01:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
 <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BBD6D180004
X-Stat-Signature: xadm93goryf7mkma1ohhq7n6gyeg8ht9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776153724-155464
X-HE-Meta: U2FsdGVkX19cdZfNBAGj4qsh/B+QO2KrIYGtn6Ch5pVkRb8eWIg9BDWh1Ucp+DAcjpCTP3gLYi6MxnS0GS/uNO9ewNM1QdD82w2MmZF0/Ev+BwM+tTyD00prphEvJgTFJSCy+Cm794vt7mRE6fpEnQeZsI8Ajc/qKDe5j+tln6OM2pv7q2RHLgSkJb1P3xEWNlBrv8qa5ZcCqoNDUfsPOfbAdiSy5Hz1cWXRpaH1TLu1VfcJr087CfBcI33w8+O2N0y/YHUoonbnHM1UesjPmhCdCIQQqjbqCN+4Y16gqqRIr3bqRNFLXq1TEyzj71/KQmt0a8gPrn5HxeCuMEEOpJPN6V+Ug6V3qTq4sZDPuR5iFQjxzezHEr0FcxE0pugupX5rSHk8SlmCNlUtIgDQecfERFyZYYM4BBWIcH0NK1NdbpVZOh3gGGrTX8EQpru9VKHqEaosSnbyju+9CHcK+GW2U5xegggzci8oSwpKLWjr3EEIj8t1Yh4MaPvW7CaE+LplkUtva0N19GBCv338tCJoxKmxCYSI2mtWWkhJkBq2g4XEMB8uTSkRjBJFd/lJZ9P4doufoRrK4HfH59jIxwZcw4CAJuTqYlJnxGdXi5tPloZxBtlRu9mhofahZn3ZnQbkO8HYjhUCyPmcdNwGKwmegWAEhUQ7atDcqosMDwbsjmYp0+GCNegt7zNLfHBPWg6loVYJV9hp8rb0yk1BdYpUEXfyqY/XZGiRbCXxjbhbdaK2ZnNFm3Qq5UnVdtzlkU4hR/1Evood47nAAGi0e7yf2iG1k5xj0DxSRuEHb76DP746yijw2AK9+nCgvMITzEa6KvdSaf2o3dwB9/Cge5iaNJj+hKcg+PwN61WxVYdea2DxzPzrFV2tDDjsp+zt2R+86EdNyVrLNs5C9XPKaC2gAMZX/Hp1gA5zJrAUnNOvIYGoOzs4zFuM2+bkhf3irJawfja9j9BMd56qeN1
 vd/ma4ZM
 SLV+LxxJT/cchxRqNIoCcawUKTfB3F7qjPUYgcUXe+ET8k9+3sVL5fvSO+OJ5dwlhdhpqqGgR8DLT1iTqc1xlpUZdodm+U37d5x+8sHFFJ3D9jaUuUz43ooudFmUPURrE2KblZ3qdBPeVQRCjaA8b2sFg5OPYe62thQhVgdqoj+3hqNmjLtnrwKX2V9aLb1SKF1gYfkjBVu0YZUzNgwBU+Ur4xuocoigXTJ+6D+OiRhz46wbzlhgKijCESvGbpFOgZv91GFccRrMMbWVBjjzGWH+LBeXArcrRyI9nd3I2qbaMxb7WshhPyP2fAuOMAjOFS7PuwcY7Gba7ej3lNkUQI+BgDCo0r/ghV9+QPBxOHCdzozg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 07:09, Dev Jain wrote:
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

Ah, thanks for clarifying.

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

Okay, so doesn't matter. I agree that we should simplify all that.

The exact index is irrelevant. Whoever wants to debug the test failure
could modify the test to find that out. It's one of the tests we don't
really expect to fail (often).

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

Yes, agreed.


I would suggest to rewrite/simplify/clarify the patch description, not
talking about "buggy" etc, focusing on the simplification.

"
The original version of mremap_test (7df666253f26: "kselftests: vm: add
mremap tests") validated remapped contents byte-by-byte and printed a
mismatch index in case the bytes streams didn't match. That was rather
inefficient, especially also if the test passed.

Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
execution time from minutes to seconds using chunkwise memcmp") used
memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
the problematic index only if it discovered a problem.

However, the implementation is overly complicated (e.g., get_sqrt() is
currently not optimal) and we don't really have to report the exact
index: whoever debugs the failing test can figure that out.

Let's simplify by just comparing both byte streams with memcmp() and not
detecting the exact failed index.
"


-- 
Cheers,

David

