Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6753FC5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 08:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B306B0095; Wed, 19 Aug 2026 04:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5426B0098; Wed, 19 Aug 2026 04:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C4C6B009B; Wed, 19 Aug 2026 04:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12396B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:54:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74638A1D63
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:54:18 +0000 (UTC)
X-FDA: 85117407396.10.6BD4973
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C4FC240003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:54:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOu4u+EX;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787129656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUHE8vO3mY8kflzEgME4ShNYgQSCxic+3gn46iev0wU=;
	b=UgFs76ODnhiHgclxpH/egeOqgnou5zxe7icEzLJ0A0zQpRjII+76/nrsK7BaalU0ogeXh1
	fZ+BZFDBXErBg1UIwY8jIXhz4oyr6kZ3ZYJjsRToD99mepuLeNcXW5w/vghx0vdAC50+Pt
	OhB+Ft2RRrRtKLzuioH2d59R8ongW2E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOu4u+EX;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787129656;
	b=pcpVa+OQ0H6ZttsdbCA1MqZWlKwNN4IWVVjZIHtGs8SDYwggje60bbwadPKX5Br0s7YJfw
	XHsfel5FAd34D+CDGfQKythonG45TlwcWKoXzbVTsWPGYO4Uy88wfXgAe2rdp7ewEeLX5a
	Ck/mcLsy9WdM7DeuAcDVK49qjsvKefA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 397B760A59;
	Wed, 19 Aug 2026 08:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676DB1F00A3D;
	Wed, 19 Aug 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787129655;
	bh=ZUHE8vO3mY8kflzEgME4ShNYgQSCxic+3gn46iev0wU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bOu4u+EXZIJ4fb6yNHV+gptSogl76KO/z7YS7VyCLtNbuPTYm9sbElAv5PW+QJL3X
	 HK0AE5wTQw90HqGxM4Vkedz2bNGaHl6PLY13MJ4mG1a7Y0UxSBtqllCoB81I36rFEt
	 HSv23G4jXYEpkjx2/+THqkADbffM30vgR810HCBijXTaO6YWmv5aDkkD/OsDlQHBiz
	 q4TWRvAdufwtBofTyhKN7EveHSNYzQEoIQN6nLqUKVnWJZHqTFhrzcd/O5cD2P6OXS
	 jkn4UfbGDusx5i1T1mG6f9pKS6nmBHGhYlrJl5w7ZDgCqEzyxim84xTaoX8Yqb5AZ2
	 sYOV4SsdB4RfA==
Message-ID: <68cb43c6-6ed2-488f-916a-b22bb956adcf@kernel.org>
Date: Wed, 19 Aug 2026 10:54:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
 <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
 <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
 <2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
 <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
 <35cca76a-4d3a-451a-b492-dd4423ac3e63@kernel.org>
 <aoVuRWz0VkKiJPzd@tiehlicka>
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
In-Reply-To: <aoVuRWz0VkKiJPzd@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4FC240003
X-Stat-Signature: dkrdzg3446ab3d7cextd745ue13o79fd
X-Rspam-User: 
X-HE-Tag: 1787129656-302062
X-HE-Meta: U2FsdGVkX18A0Kkjkkvp4C3tLGCDVbJyxejKbo1/emMDcGit7tg0dFBLErxT3Gr95sVfkBXr+Qn5fiWtDHnuG0sh0ERiU4ZS9xmF9LSdL2BQQER69lyrVEAoP2QaPVWctDvy2TLQzdoYZRqBvz1oFUv7knNaGz1s9utGNXYAThTyqDpOXSXeh22o20cOYeSKF6jHRWNGE8lRttvPHRy/XLObhoGd7eWERqr2az4m1i48AQg/A9qcTOsovbUZegedOgSTGdYD2DIWqo1Tu59OJMwxViIzPrpHctu2CMG57Cq7/w43wz0jRSYWIXj7Pf3J6AabqOyuuYf0iDkQfVrfG5UyhsuNO3hBklC4V4mYbL8pD7ov483LdzYwwmVTn4H06p1E+dU5ARH4gMc5aG/OAq/X9VsNZdpHf3mPyWlmcsuyIiDRUHqSl6MyLYGHc7V/Jl4k6RLonPLFuDtGsD9vStKlPztoFAMxeqFKOwITyoZ15qzP6J9JnigzDvkpCfz/O8pxUrFVqOsx0t1WQLN45RXhdmk7+IjNFoOmigUlxK8pJ5WEFDy1cESra6Pk3b7eFX5wrNlx+Ivrx1d0PJDRoIGJ1k4PExEDUEkAa14vlA6Bzf175jADA26F7U6P5FPHgl8iyS2oHmEBJdoTW6X5eMVkykHATV7Z1vytvVjAT1tTHo+CbqRVbfinffykdSBVp8dzSE7+ZwusJR2aUVEfeb7CsC1TXQHhgMFOe51UgDdjhOfPdwoCNHnCa8HA7VBH0dwBn8LiHXiiAy4cGophii3P0ltmnldO7amMBGn+k5ay+ZldsaVXCoD6LiwQOYHfi9e3VvejoE3iujKzB6lE8pmdndLhAzVWAnqkBScu+7Uncnxu1k0M2zK5+dwOjhzh4gol8Z/q7PENsjgstFI+vlssNhes4rdyRE/v1cKOKc6rbk4NiyFoxld7fdlYvrNI/RjernSFFNwV/sqvp0L
 EiMtNwXD
 AUWGgeHrGpaFYKmirlazLTDO3Fbc0j09MblsWoLT8VokYgwm/TchHG73IJ1ZhnRJ0VwklNqWL09KUeefhKLWZQXKceNcBo9kvbnJA3zhcOKtP1wtP4qWNoQsHU8HMzP2KYeDMFGQ4Pj2RrGNranlArsV9ON/ElJBsBCBBJNM6XR37kFKVLs0/NdEz3pb1t9/cQT7GMy5jrN0p+lNh0Jx0ThhwqLqG/NY+u6lSush9bQZ7GropK3pQvxhnFUC34qOBA2mHAGlIQZxYZ5imM41EDLpQTIzsgSb6y92zoSPAygYwZNFb4EOyTERCVgWF7xUlrP9rwlOvmSDmyN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 10:50, Michal Hocko wrote:
> On Wed 19-08-26 09:53:25, David Hildenbrand wrote:
>> On 8/18/26 20:55, Andrew Morton wrote:
>>>
>>>
>>> Not understanding.
>>>
>>> Maybe you refer to adding a patch to -stable but not to -linus?  That's
>>> against the -stable rules
>>> (Documentation/process/stable-kernel-rules.rst).
>>
>> It's tricky: if a problem only exists in stable (there is nothing to fix in
>> Linus' tree), then a stable-only fix is acceptable.
> 
> The crucial quiestion is whether this is something that needs a code fix
> or a configuration fix. Really fighting for low latencies with
> PREEMPT_NONE is a kinda lost battle. You might want to play whack a
> mole...

Yes, I read your comment on the other thread afterwards and I agree.

The whole reason we added cond_resched() all over the place over the years was
to avoid splats from false detected hung tasks (e.g., 30s ...).

Not to optimize latency in the ms range.

-- 
Cheers,

David

