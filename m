Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C9C606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjUoT5vX
Received: by kanga.kvack.org (Postfix)
	id A9C506B05CA; Fri, 13 Nov 2026 16:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C526B05DE; Fri, 13 Nov 2026 16:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93CA46B05DF; Fri, 13 Nov 2026 16:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60C1E6B05CA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:37:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2744A77BF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:37:22 +0000 (UTC)
X-FDA: 85431407124.28.6245186
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 215A814000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:37:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjUoT5vX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuYdlDuceEy0lQozl99KmLtBB3feMdBndJ4Ls8W3oKI=;
	b=cL25K0sL/MIPbPfILUtKqAlaat5QliYmE82cK1BWbtad0xOlw4FaWdfQBu7dMT+oY5gOjq
	RmXagQAGjXS5T2S1gKKDAzl4bczQOo3Rbu67r/coC1HKBaTIpxRf1+H57omOvwlVv3KDQa
	dxDspBa3wTCUQ7lsjgTUzQGSQbGzTUI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjUoT5vX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605841;
	b=PcRwEBQruKdO23khqXyLpIgSHI8rXZvgu4IHmH7wA2OIPy9l9yiHM0LN0UEkL9L7u+I8XN
	nuwptnhwSfPckAHUvyxG6Wjz1g5UbFVwhHiVN0VuH+1V5c+mwHsJ8603uQrj6GS9dFmVuH
	URJz8fyE8aXGgALpcjwATMWtJO68jnA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68FA842BA2;
	Fri, 13 Nov 2026 21:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707251F000C4;
	Fri, 13 Nov 2026 21:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605840;
	bh=wuYdlDuceEy0lQozl99KmLtBB3feMdBndJ4Ls8W3oKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kjUoT5vXT2NL0LoTh4rtmtDlgNjMKMglFr+pelw8nEU24U/LnUfYcWpmJjFbgvinP
	 tETw/tCT0SErNu1AVwdAegocp3PSugCORvgifIzUFjGofcgw4a5tcZUU3a4mY5IjME
	 3xI7hBH9r2aVHck4Xx1gy+uyM3J6fe27rU67/zxZ3MzXhjmegXyoTbeNHHxbthBWPK
	 gGyaQfEHDQ9bbW0BVTdaqY8xltRSXyGnGzvEXKn1o62Gtrr8j3MS5gXnR2UOjMuwsv
	 Mrz3skjo6avqhJ1ZL94WLds06/sq3/cLuhScvpK8k4ozDerZPZNih61hsb6iJOoXbZ
	 U57Jr9KyyD7Og==
Message-ID: <6af3d5d2-4fab-4a3f-85d9-34564fca8ffe@kernel.org>
Date: Fri, 13 Nov 2026 22:19:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
 <0b794f803517c27ea818a2e894761095300b4da4.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <0b794f803517c27ea818a2e894761095300b4da4.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ffy8pffnfid3uho1b4amhd4bad7bznnk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 215A814000C
X-HE-Tag: 1794605840-101820
X-HE-Meta: U2FsdGVkX19OsnBUF978bgBRPYwD04PPZxXr9HKnlVvynrC26+Q2BfDtEcVMECoebNKpUfv8y0CO1yS9j32BuZLZUgwQfUSGIN84SspcT27sACX0PpcQJzH7laT1gfaKvFjPslAHJWu2Y+CikOSqhVESGnwEmzVpI7HWNEeBH1i9VpFD3Er4drQHRmChjJUu4iZNqieIPgSN+rJgCIL6H337T8vcMGiRjzSQj275aqnZ+M9WWzcpqYv4lrVqDm5ur0r3Lse93ewrCYla33Udw59whsN2PS6Wjeqg1RF9hOUEJl3PbrlSjoHzUtk5h1oh1Dfk8cd1drTa9JWJ+wopHrscIEUXJCxDhvjl5H6sYy9f8tzWrjdPEKwYdKGvPqrt/LCNO0/kiJOAiw62rAP2iibmQGSNFnmJzkhkDebNUw51AxeMM0iKaJxZyf0iP6gmKt/FXY6auAaq2xc95cYtMyX7DbHbb5TQ0IliYvrIUqoIWAmZwyCe9U149aIVS/VLTmuUdJroo32civhGMBaRFAm97le7oMjj2bikiVXrIr2obXzHJ0+at9FmQnLtFgu6tI6R4ZEFJyJuTiQa8Mk7cBZsXUkj0HWHFIhEq5wkg7TykXF9qzI38A60yKJ2L4LjGi0qb26F8Iiph0/wgXxf5gp6c9U6q+6cm2+9hGmdbwEhcnxz6ppFsmTwGuacNFGRy+tROJskX0xabUwG6FkdnRFuxdFK1RbxjRWYzxRz7AhWioT+YWK0qAWG2ZapJZ6JSBUryTRetG7ueUtXLcM3ZZew4gD2+mSyEMW/+SqCgkqSjALFJkK7jf55zgCtF1eInP5qfxD0tbi0CIGNMN0NHDk4V5A7ga/nH92xQKw4NKjla1JlADNiOz1iqR5ebn1KuezBZGSyWDUN1BvvLNZtHLexqiCmn7zCf3O0XmQQjydVkNtVpaXErxZgpXp6JHbZYx0/RzEpk8+KEjJUhcP
 enAZU4rA
 TU1mG+0Xw1mUynfml7tFYgLN/d5KAkggtMA6Xjp9jFU90C8pVMy8/o+aNl9jaPxVSycC6WiPPlKhAB7097qgGCgjiTuQeIPMhEq0xVhKrisYZyfAAXb8y/VLUMdUDsyoTQaKxIcyPevWRVEZn9Pg0weJP+6ppBwMb3FBKZECqrpEwPVuh+S/9/hyUz4jLA/UYeNM+yZKdkNa0nX/UhhuMppPB/2wyQdBOxWos3yoBPBgEaAkh7T0jG5T1rS0AOMHSnZ9rsqmiGtvj7INQFlHv/ZLnGKJ7I6aD2MUq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 21:56, Thomas Hellström wrote:
> On Fri, 2026-11-13 at 21:43 +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 21:34, Thomas Hellström wrote:
>>> Hi, David
>>>
>>>
>>> There are two major problems with the current behaviour.
>>>
>>> 1) The work item executing hmm_range_fault() might have no affinity
>>> at
>>> all to the GPU about to access the memory.
>>>
>>> 2) If migration happens, then hmm_range_fault() will stop and retry
>>> leading to excessive execution time.
>>>
>>> While perhaps Matt's commit message doesn't correctly describe the
>>> GUP
>>> behaviour, do you have any alternative suggestion than to avoid
>>> migration in this case? I think it's a reasonable idea given the
>>> problems with the current code?
>>
>> Adding fault reasons that hack around NUMA hinting such that a actual
>> CPU
>> accessing it later will not trigger ... NUMA hinting?
>>
>> I might be missing the "reasonable" in here :P
> 
> Wouldn't the net effect be that content stays put instead of being
> migrated? In both cases a later CPU access will not trigger NUMA
> hinting except that the proposed change doesn't send content to an
> irrelevant node?

My point is that you are essentially disabling NUMA hinting because the CPU will
no longer trigger NUMA hinting faults.

But then, just disable it entirely. Maybe John knows what to do.

> 
>>
>> I recall that John (cc) kept saying "GPUs and NUMA balancing is
>> inherently
>> incompatible, you have to disable NUMA balancing".
> 
> Perhaps we could force hmm_range_fault() to run on the node closest to
> the GPU. Then at least the migration might be beneficial.

That's also true.

> 
>>
>> You could likely implement something similar to GUP, where you would
>> allow for
>> bypassing protnone for reading.
> 
> We could ofc look at that. Might help in some cases.
Would be interesting if that already solves most of your problem. Apparently for
KVM it did, but not sure why the write side was never that important.

-- 
Cheers,

David

