Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D91E9DE62
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993E76B0005; Thu,  9 Apr 2026 04:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DEF6B0088; Thu,  9 Apr 2026 04:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE486B008A; Thu,  9 Apr 2026 04:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67EAC6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:14:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BACBE2A9A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:14:42 +0000 (UTC)
X-FDA: 84638306004.11.94AAC57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B49C140004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:14:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzHoVBeR;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775722480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulGrRC0jdaRv1vkQacAN0gKiQVv3lZkNSeu99fGuA2E=;
	b=UpEBqwbwEIF4N6edcolpW3SMaKq3AdBtfB4WsT1MHtqPZm3Q52qGjUqDseW3l9CcD1CIQJ
	MaKvStlLBZcuwz6tF+Wu6YR6Zm7fPTP2q0o6HSSfdbFZz9cTPBpCdhSlDc5uzMGoehxqU/
	Fhh2sjGD9odWwvV73oxo6MDfhGqUN0o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzHoVBeR;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775722480; a=rsa-sha256;
	cv=none;
	b=hYh46gdwHhyjWh/hKjR2YP9qVyhjbNZkOE8XB8NUej+iMKb7xbYPGu7PHjHmApMqWjDsmM
	gcQs7ms4jh+vcbOo4roJ67tbOBkFicswkkK1EWMq2T0TtlLfV6uv5qHDPqQKCzaxVnraYW
	I5F6+CbgY+gA4VBcb03sY3meL1J5oYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9257E60123;
	Thu,  9 Apr 2026 08:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABD9C4CEF7;
	Thu,  9 Apr 2026 08:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775722479;
	bh=3G5Y64fdJYhpPq7ZwMBZEixlrfHpeuaE8YXrRUfjeMs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OzHoVBeRvY/SsR06SwsiSiPOpUf/NeNeO4KCQ0hNXg00N+yKidPIAkYDUEm9IdNrk
	 vDmreE9oiiil6bCPRhEF5TIaV1mw68kw+UTV3PZWmYnOatG48gpRcTxuLy9ItYjpDu
	 YAUfI0+rdR/p6aO03Jj4W47eLSmjPhAxh0rOeFzu8ScWCrbR9K6YodD9JXmfUxC664
	 23hIyo1iVYlLo71vl+7Fg3stF4il+ImnBRfqZz24TFfGraJ8LbG5DJBTZHuzcWK5hg
	 9EPm1kjYUet+TSleyKr50u/2zBfC/jB9m2maCM8/sqitwoiNXOHAO34bYEb0Rr09iD
	 UxfM9W1yZ++wA==
Message-ID: <2e3f7c8c-c443-4e71-ad60-36c5203de09b@kernel.org>
Date: Thu, 9 Apr 2026 10:14:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032347.232939-1-npache@redhat.com>
 <8a4568de-e0f9-471b-bc94-1062d4af3938@kernel.org>
 <ee39e605-0d9f-433b-9dfa-f70fd92edfac@kernel.org>
 <c4e80668-9018-48fc-883c-5d52a5950065@kernel.org>
 <CAA1CXcA8nE2PZrB4J1gV5v16PeQ7X2AiwjJ3gO1Q8hW7tyTtPQ@mail.gmail.com>
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
In-Reply-To: <CAA1CXcA8nE2PZrB4J1gV5v16PeQ7X2AiwjJ3gO1Q8hW7tyTtPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B49C140004
X-Stat-Signature: y33dbtyuyyyakrynaggfyy37dxjqsw45
X-Rspam-User: 
X-HE-Tag: 1775722480-671752
X-HE-Meta: U2FsdGVkX19gBzn1H0aet1tKRephUXyN0Pxw/04Qyk7xg4jL/fxr3glJZaU5+sV9LgQ82Y7g9SSAm0Rm5ba5O8CVHvJCYcfa8ecIkdEdk4Jd7uNpE+jnqep4hsA0aS1ZkE6Wrd6r1ah2sBdd83/p25/fC32pxYgvx1lXhjDyPrqZOqwPWx3YZs/27JRB/TGvn61x645MM+bCeEz9B9jnM+Q+0yjdWLRKN52ObyHU4wnRNGS6uN1dCfjS5Z8xcIua0a/jDIOuCPkERKMx3r0KDpCFXumUvG7WCV5pFhR4udm3UkgCIy1pV06q15k+PNYJiGjaor3oDv6RdJFkwEvU7MCHZN0EPaDEPULugfTkqv51Zrx2cs/Nl8nrwNaTrmT+mXXuhDYClvmct8KLKpZWMtD8nLCoKEL3GZUr6NbwJHPa0ZIu1t01+TgL5C35TO0/tAhveT7TuNqRslqKAVzsALlBBDEGKTs4zXotblNqu4FQvyDfw+W/mJsv3zpoBsB4IMYnMwJDGcn4dziUGgubmB2je9oAuvEkbNTw9Qhwd5N7wF353o8aM64CRSf6CZps+BXDUKlaPsOB9vPVy3cypzpydf/jp8ujG+VGvjv3iIiEwnVTLjUGcK74+kRM0Ys1ZgqpV6w6rhIuKxSPn1OhBaJCf8ixbPUcZOBVjikuvTV7B8ncxiPzzFV/KLO+SN8HoW1Rdc0pEaMu4kV4T9dbnu9rzUksib6S2lOcup8rY/WFRNV08njHHtCbeE6a/QwduXjsO+2I/iB/S5GbWZNZB9QKLjx+n3fmSwdknt6IOlFFkRMrFCP01I0V/e+ZpOhKc8PyjdvihGpsVBb0m/jgn9sgi0f7tVWnjB3e4WVHMb3ITSXZmbT/EMORN0xFCvG8m/g8c66G0pLMB/8tvPFUNvv1TgemhjY1yOCs1KSqJkq0teIM9UPchefYuy13yzjLk++B2Oa5fzYk849rLkI
 VGDk3BN9
 2IKKKvUvCMgKM0337sT/PM5cJLqqSPlTex9fAwbX+R2i51CIBk2eIxoWtRzf+UC98owIE6IBNWojiQkYm7937se5vB7Jocq9IzJrUv5I/oWEnQKG87M/LG5xQB0D40qzk7bKsWn6NLJxVHSGFRLEWYiE69XnDC+S5TVBeiJaq+axX7ipcSwPXG2MBUNVdO04wSfG/ywOkdiCX5mNZi/KhvWwEPSId8Dqo4ra6kihfpyYwNMidg4PGBCYcxjGwZsYerPGTfT4uiM9D40IQh7LQF93sdLLt2zKB40Rqwv3F+K7b6wqhuXmHPlfjOxKrcZ8znWIxO0ZS7gdWydyTGVw/Q/HAvH7r5kTBuXWlQX8I8KylNmP+CpudZn7/MvFL4ZPn5UeIehNcmwFpjoUgoP0seZz6+5VcncvQgSHpHYeTZeWJdcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 21:48, Nico Pache wrote:
> On Thu, Mar 12, 2026 at 2:56 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 3/12/26 21:36, David Hildenbrand (Arm) wrote:
>>>
>>> Okay, now I am confused. Why are you not taking care of
>>> collapse_scan_pmd() in the same context?
>>>
>>> Because if you make sure that we properly check against a max_ptes_swap
>>> similar as in the style above, we'd rule out swapin right from the start?
>>>
>>> Also, I would expect that all other parameters in there are similarly
>>> handled?
>>>
>>
>> Okay, I think you should add the following:
> 
> Hey! Thanks for all your reviews here.
> 
> For multiple reasons, here is the solution I developed:
> 
> Add a patch before the generalize __collapse.. patch that reworks the
> max_ptes* handling and introduces the helpers (no functional changes).

I assume that's roughly the patch I shared below? If so, sounds good to me.

-- 
Cheers,

David

