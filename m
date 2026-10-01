Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBE6CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8AC6B0099; Thu,  1 Oct 2026 09:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF726B009B; Thu,  1 Oct 2026 09:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7EE6B009D; Thu,  1 Oct 2026 09:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151966B0099
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:19:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E4BB80284
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:19:47 +0000 (UTC)
X-FDA: 85274114814.08.7730E6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B6A9F40007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:19:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/iq83bw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnWeqdfJvPaLO0zxZ1rgF6uSlPv8HCyAEObGRlF1V7g=;
	b=2+eJkgGilHv2xEgf/E26li6XRxfYolH8KQzMc4F1Bh5y+Oq+bK6hAyZt8h0iSvIieP/rRt
	AR1ht72aeYpif+K1ZoJKHsB+rFTP+MoOSinIyDwZhwOFAWw+iJrsvgS5a1uD4iViMWw8tb
	9qsMxwtM0j3+bRgQa4dSmBcoJdA1OyE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/iq83bw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790860785;
	b=k1e1rIkqtVJoyDcFJ3s86o5ljwr/ffiZow1cVtrHfCd1cGeIh+u7ob450BITyftn7xdFUQ
	VMkYxOWPMxUwzwX2SClvFDyo4Vyrxlqk/KrUYtZH7whlo/7XF/CEW+rOErv8naRaCguked
	grKt/NZdDdFrda98T1jUJuodKu3rXp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCA3D43A7C;
	Thu,  1 Oct 2026 13:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3AE1F000FF;
	Thu,  1 Oct 2026 13:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860784;
	bh=WnWeqdfJvPaLO0zxZ1rgF6uSlPv8HCyAEObGRlF1V7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H/iq83bwefWg6YEAvBt3p5OoC8YuQlDellwlZVxRxocA19xDtjYbDftQq2+9afzpU
	 2dSmkLHYtQEL6BxMmml2z7htQ6WXLMvuY3q9G7vHRnS0bxGs+LNr1DruQaiEGWKdQO
	 3iJx0A/h1lnwTr+963Bm6se+E233H5pmut38TKIZ+cbCKIlBZCpJRe+DwpiccYJ1/g
	 4lwpQsj4c3QQ8MtafACUqrRtwSZpSgehqu68vWU1U4JmGT0G3AkHJrrEHJSxxuPZgU
	 RQsYMoxstF5ODCSgQs6lEbB5QFfB0S/h6t2ZDZD1U6JKsERLxDe/a8/YQW0rZKxpOd
	 RKYk0kP56XC+w==
Message-ID: <32ce43e7-ca22-4275-ac2d-b0fdd942c7a9@kernel.org>
Date: Thu, 1 Oct 2026 15:19:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 6/9] selftests/mm: mremap_test: replace random data
 with deterministic pattern
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-7-sarthak.sharma@arm.com>
 <b45813af-df08-4270-93ac-d99ee42830ec@kernel.org>
 <54f1d9b8-948a-482d-8fa5-694fd937c9e8@arm.com>
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
In-Reply-To: <54f1d9b8-948a-482d-8fa5-694fd937c9e8@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B6A9F40007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8e3m5q9ueac6og5w5rz7n9nynt1k3w58
X-HE-Tag: 1790860785-287116
X-HE-Meta: U2FsdGVkX1+xcaTRIaZ034/mSs/Z3yEC64/Lw26xPNzx25i9OhQX0stGh4cstPOL3CodAfyjUVEZbHlMY0Hh2vuoJALLzCQHLPMXwxHTkkUGmkTQeNtTyOGUhRRN3X4QwsPHkCh5l+RMN9LPfEz+YkCJXyJ56xn7l0qxN26m3ilWRiFCyfS4aoAFSXyUkpDliNNzTzdyzoRLs8KdGAxtlSTwkmeWcfL8VO1M40zZYqgFMnvckvIKE3dRaqMGco3u+CEA8z+qcoJ3OEqkk2KsvMfHHi3uVIsPGCyiPs2Y86mZ1JktmV0xDTg8TJ3DJF+0HIerGeEpN9EpHU0WhTicDgyOSCsMZqfeqz8kTmAuu1noEn28owO8ATYm9pKppuoRhQRi6ClGlTCtggK4VbSm6hkc7lZaGc/0oddB9sCxdT0VJwCx2kvGmBhO4mS7/5Se3E2bt2g+ZFjU8c4r1Lyo5e3Hl3GV7GDjz86B1h6qBrkFQyz2r8LBnnyOqutZFLQrNrkfAqMLm7suY01Pj3xY9X8WMhIJqLHEnhuJHbinNoNWx6nX2JOoOgy3NjH8Q4SYqFBTZAgndBmy6lmIv4pAs5d0TtioPeDmOmbf5HJ9kFNPQH8sORTCQgpTdEuQ0OfKH5alumWxj1XaU/Dbt32MkP1z/uZ4f22ieIgc1pgEzeYQbGE+ET2Vl6DecMlOr9z3cOV9d/AnpzltPK4Kn5kQiK94z2w1QrwV67dP4bjlsrlQCK0Huy7WWfetrBBSosoki0EGSHrvJkyuXngAvdlUeGNvrBCvt+xqO0yrlS+ekeZglskDm4qoNObDu75+jZ+B/C++sM0EdVxFhsWf+98I66lVgXTdIBIUYj71fIkBejr6y7+lN6ZcnAG2Or0gDYBiMV7H4NZ0jv8f7ASnAAfDLjAnRPR1N3LVQakHDUrZDybUsl/XbnHDrc2nvxnatyOvDdfzWPCv0sN6VIoLLO4
 1yaD+aW+
 CQ5KluFxJsm8o1awqAwFUKyT19NpGXFWTKnMsUB+/BXu3Ruhc5V4544SrjEu+6vutcnjtDlxAZ8fBQh74FlzKnYX3vvlPJx39YwI/TF8NwEuHe4CSBx6Nb+MzEYqM6yMvCcWcdPFvP0o0pEhhJeS6qrkMrHYheifJd8HWuj72ls0NH5QMjnWXYR2DipW3wWO9qSxtcMeGY1/DCBunyFbM5F6TP/SIenJSIt8j4kDNdd3QZlPtbIZ8p6Wo52baIF2BDgxmbJWYfPK68zy/JJZYn7ElUNSHtjfEX8mZWLqC92LvK4AAe22wCRhvJCVGeguIMJM8RqGdypDAXfK8PjTd5aW74WBbGYeQQ7mfdVKQeogWNAnwsGfcavVmhK0LXENqQnDh0sH28LbX9NM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 15:16, Sarthak Sharma wrote:
> 
> 
> On 10/1/26 5:30 PM, David Hildenbrand (Arm) wrote:
>> On 9/24/26 07:00, Sarthak Sharma wrote:
>>> mremap_test uses a random data stream to detect corruption after remap
>>> operations. This requires seed handling and byte by byte validation,
>>> which is inefficient.
>>>
>>> Replace it with a deterministic pattern where every word in a page
>>> contains its one-based page index. Use memcpy() and memcmp() to
>>> initialize and validate the mappings. Remove the pattern seed and
>>> its command line option. Also update the comment diagrams to
>>> reflect the new deterministic pattern.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>> ---
>>
>> How will this patch change with the change in threshold handling? Does it make
>> sense to reshuffle the patches?
> 
> From an intermediate patch POV, both ways of doing should be identical:
> 
> a) Remove threshold first, then remove randomization:
> 	i) Adjust random buffer size according to what the test requires
> 	   and implement the start, mid end pages checking
> 	ii) Replace rand approach with fixed pattern
> 
> b) Remove randomization first, then remove threshold:
> 	i) Adjust fixed pattern size according to threshold
> 	ii) Implement the new logic of start, mid and end pages checking
> 	    and adjust pattern size
> 
> But if we plan to remove perf and timing infrastructure before (which I
> plan to do in v2), yes removing threshold first would be neater, since
> it will keep both the removal patches together. Please let me know if I
> am missing something.

No, looks good. I'll take a look at the patches again in a v2.

-- 
Cheers,

David

