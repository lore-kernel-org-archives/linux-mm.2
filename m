Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D15EACD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 10:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5E46B0137; Fri,  8 May 2026 06:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66756B0138; Fri,  8 May 2026 06:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EC26B0139; Fri,  8 May 2026 06:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD5AF6B0137
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:12:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57E34A07A4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:12:33 +0000 (UTC)
X-FDA: 84743838186.06.BE70007
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 824DD140005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:12:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4dUvE+S;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778235151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3M4BVUeod7EsE+qXOSOWLKWHoWslD2RxHgWBj0aiUmE=;
	b=gyD3QbhNE2iZqyr7VXC1ydm9vtHvKMBQ0Zu5jguE4NU4HaTpOzjrfp83x37kooqa3WPI8A
	aptfoQ33YxEaDcXx/LytV0YTJMn22Ae5yP+Dz76ROM31W2WL7yrWEMIHmIxwDL0H9D6Phv
	2h8WgDPHFjD2kDGmgScVzAXn0jHHhtI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4dUvE+S;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778235151; a=rsa-sha256;
	cv=none;
	b=h4lQf1Ti5PHArpFloPERN1j42C5Qpuwo4aTKJZMJ6ImFHCPirzanmVmbx9mFyyXqwvtlBq
	XzuOEzjQufIpHMxxC26OEoIpPyJHKneeqmvMInNWxTeMDcYXEs0HtZbhnF4DqH4FnJVyOu
	klZv4YxKnmbHxBecAh9ytvNtcvJBN+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 892A743B59;
	Fri,  8 May 2026 10:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79958C2BCB0;
	Fri,  8 May 2026 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778235150;
	bh=mPW1suWcBNXHM4rmLBS8M3I/y4AtZZ/H0fZ1cIPIBKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R4dUvE+Sl0M8nNwXwoA7TYhLb9H31T3bfqiWkk6bhraXAn0LTgx90vVyH8hPMsHAB
	 Pw302qNkqO5xZnVmqdXEgGP543kejzukiSUl7/PNE7O9qnLirqV3T/d+lA4pfxW0gA
	 1TxAj3qOhgKKm1UPg0gboc2/zmPXFbbwtaZcFyMTnoYdsVUeIOvaPuxa2UlcGJ87pq
	 j9KI9UJCZvpYoHgH9hCZXEHZ7kRAW6cDZn5Wa9JK+JrMFPqd8q1fcHJOjGcEbC3rWD
	 pR5LH2+83uX9euGh20uGIFiNxBmKWw6Oo5jUsiinMl0wNzEg5rO88dYbhHawsSm/Vi
	 vwZdYj/1vnl6Q==
Message-ID: <a07231f7-c5a1-4de0-8d4a-459d5ecb5676@kernel.org>
Date: Fri, 8 May 2026 12:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm: Make per-VMA locks available universally
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181955.0C443845@davehans-spike.ostc.intel.com>
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
In-Reply-To: <20260429181955.0C443845@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 824DD140005
X-Rspam-User: 
X-Stat-Signature: 49gmid8wsa6dqpbiciuknq3rqmjintjx
X-HE-Tag: 1778235151-943529
X-HE-Meta: U2FsdGVkX1+TYeNkIgoG8oxpwB+uOgrkNZ6FniRJnI/o1hX4o8meRbdigDK5iZWt7QsnKHBoqrtT6BA+fOCN3P9zgkQUele0bTvURGCyPu73r7HR2gbLLF4GrX5EAtJowB40o4CD49PsGB0oG5jG7oW6/wbHs/HfEVBlPtT3q9deicJxw2yuA74P6B8yVUxk0J+JqEV6wkwskFIUdA10IkXXlE8DWMk73KoGsoMjoN4RAOlnDooVwzeTcQ86TiAe+2pbt33q0YN/w8pVKRWlfo1cVEzPsmuzDv359zwIa95B9ensF793wGL66HN2x98tz0GI4YiNDQLFqPlClA7SgEBURwSSZ4RvboIHaDbfCuHMAJMOTEQR7MwF+sSclyX9oSCULcAOKC3/WKBcTk84WOF99oM7XRBCS39j7SKWlKB2ruZ4MaPO2vKtrzSBSB8PuDnKsz4o2wPrllUfAlpdRvK4ns5ggITewmexvwFPgWsJuEBRNSKjhCrwsFT239akgTDTmbR/BPRIEeqYgbCJfyVcXVexlRz8T/Rr3B3BYKOVS/R36y6o3vYUJYb6MKe1/zhfehfo1GPBx/mt4iYca0hji75Md6wHrlZoww3Qj/d/xkY2O6ZmwJ72eYDsa7N+tL9YausDEd0ZnK4iC5zxPhx4JqvAu6kdB+4KsSeE/JnpjdPBzeFHd+hJaOpnpr+lYCp4CsYeq6PXMeU+UMmZBcM2X5avkd6E8U6yO68r4T3a0eePR5y5syFYxgiqA5HwLApk7iw1M2Xw+JOI2PO8iIufd3k6kYdhq6p0TTfQ4FniGvD21W1UiYlhSy+SYP4kDRDBYWVMPwfeN5/F3NxwyusvMChi5hYTrND+E4AEd7TfhsFZl4HIRfv9jaMO95vvvn68T0oDeUmh/KXtH6ruqzG2HRCZ0CO0E9Lf67JChdOs4/Tn4uJ++AOcHjUg+k1WBHKPowc4rJf4hkrC50l
 X7/7dXrV
 DKTFeJLjCqY1faRtRzR4m0mgrnNq0Wiom73F2l2OZKZt4nNersaSnEdjYqlEc+ds886AqLDLnk933v+iLED9kPQcuR4iVM3nTSItVkuBNE+/5BkI5h1zPE1fCfPXZJI96FcHLeH8M9JiaJZHN6pNFBQFyvmf+EQAO23rWsbWke7KWM4UgiCwx9DJbL/jVx5CGTcGTysA0pPSNvJ9HkjLVyYE+4GSOJxOLmScjGQPS1/o+Z9FjQviRy68KdWXret6XKyvWpcB5xFcwMCit8fG15O2qNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 20:19, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.

Yes, we should really just make it now just a fixed part of the kernel design.

> 
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
> 
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=n configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
> 
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* can bring additional
> simplifications.
> 
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. 

I'd assume most distributions would already enable it.

mm_struct is very likely not a problem.

On x86-64, the smallest size for vma_area_struct possible (make allnoconfig)
seems to be 68bytes. The largest size (make allyesconfig) with lockdep and all
that is 256bytes. Without lockdep we are at 192 bytes: independent of per-VMA locks.

I'd expect that on most 64bit configs we usually end up with 192 bytes today.

Given that our slab sizes are ...32/64/96/128/192/..., I guess we'd have to be
lucky to jump between sizes on most configs.

Maybe on 32bit? Not sure if anybody would really notice.

> I suspect there are some very simple ways to implement the
> per-VMA locks that don't require any additional fields, especially if
> such an approach was limited to SMP=n configs*. For now, do the
> simplest thing: use the same implementation everywhere.
> 
>  * For example, since SMP=n configs don't care much about scalability or
>    false sharing, there could be a single, global VMA seqcount that is
>    bumped when any VMA is modified instead of having space in each VMA
>    for a seqcount.


I'd do that only if we actually determine this to be a problem.


-- 
Cheers,

David

