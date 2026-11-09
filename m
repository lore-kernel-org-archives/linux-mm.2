Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5E0606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fligvshl
Received: by kanga.kvack.org (Postfix)
	id 4525C6B05B3; Mon,  9 Nov 2026 07:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4035D6B05B4; Mon,  9 Nov 2026 07:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1D86B05B5; Mon,  9 Nov 2026 07:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 073936B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:58:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98E57A06A5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:58:02 +0000 (UTC)
X-FDA: 85415583204.24.0B5A8B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBE631A000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:58:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fligvshl;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ta6wbXptveLQwdVO2l5UsnQtwOC+Kp6z3kgO+pESTVI=;
	b=DP+20g88Z7hM7Q5gGcSghABk85HVKVw4afGZV6ih1HyUXHHE/StAIjBJQO5pXZgBvjCDIW
	Cv5Lm0/DonEvZn37QfCsLxyg5W1VX5Wo8o4pZm+0by29X7opceC9/yPrZeE0EZuSTxRjgT
	dxGJH6yJCBlC8aEgF+KcIMc9oJB0S6s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229081;
	b=BKn/ubrCZCZ10Ji6KwWt8v6WXvojp/3GFfHH4TzX9gdkRWoqFullLosVsFjccB1fobuCVt
	hEyaVBOrm9Op8t/+HRXWrnlk6WNy5oFdc3hE4b6vJ4JZxo8aeiLmSQbpFFvjQVzfpLEqZR
	3eZ/AtM2CfQWROnDd79/C1Yw4JsH2Gk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fligvshl;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6752463191;
	Mon,  9 Nov 2026 12:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71D21F008A3;
	Mon,  9 Nov 2026 12:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794229080;
	bh=ta6wbXptveLQwdVO2l5UsnQtwOC+Kp6z3kgO+pESTVI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fligvshlmzi5fvDbnF99CY+QS0zNJr0YRoT1Rvyq23btHmpA9DpsTFltcQxenPyTz
	 K8SCuh3ou3Q8fRRc2kLbT+nQeQeKq+kbgZ/ZMsU4H7xWVk4zLk4ieHCW+YXRq7Q7QV
	 uiZBkSp8OOSQU5QlRIx9nb5D4UzlAShyqVm4XL+YdhOisKv5B6AZsuW09zqzlYbpS2
	 MayogMBhAQEer50SpzOVY+ch9gQLCTlIRV5HZJS3F1qw7TVjgazK65luMcdmzL/SNi
	 4NM1YoHh/37D9Lbu5682PuKBfiU9+rsagDgRtXHxmgRclQAJgO38eU+z+DJHQm+/Cf
	 8s0nyRsMyu2Yg==
Message-ID: <0cc263e5-9bdf-460c-956f-873c3285699e@kernel.org>
Date: Mon, 9 Nov 2026 13:57:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
To: sashiko-reviews@lists.linux.dev,
 Konstantin Khorenko <khorenko@virtuozzo.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
 <sashiko-outbox-203086@kernel.org>
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
In-Reply-To: <sashiko-outbox-203086@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: nkf31myw455a9sdwsf9om719z8nnkeqj
X-Rspamd-Queue-Id: DBE631A000A
X-Rspam-User: 
X-HE-Tag: 1794229080-623191
X-HE-Meta: U2FsdGVkX1+4rHtP11vpbSGXlO6tQynk6zHHHuUf8xVX3R21nSI6GuA+FGwA9t0lsGHpkiqq0qaYBMVZHvJoNojE8DZlUxaZxfIiobqDt+tniAF+UCLXISy6bZMFZfTh+pF26GSQyp6EnpQoMcQEhDU4c/4UVZZ25CH5zRmYokydu4hPPq/aZ4nvdMqRE6tOSsx6H5OKJZRbLDFox42YlSkweCF8LfyP2IL7Ng+Zs4akUPz7aOxNJPpqd+XM/kbdwIEFV6hJrUbg7Prflq0aPngSQocXGBeA9IU53qGNDFt3hp4a5rBpLzWC6ffyuq2pD9R+1cqMwiYwuARtaeGDLYX7oTVfJFAzMCNfcCFMLeKLwSqDI/lbSrQQEjeV+sIbPRERw+rYrzyLp5/GDn3/4Go3WBw5IeWj6LNbMas0QQDGx4JUt8905DWbBOulvjTfoIm36Lgl3cpFJbL01DTrNwO+I2KvXSCcunQNyfMGFlPcR76jVQxz4TrhtM0q7QG6IX4ct4Ryi9OOamQ9y0/IlhMR+YZoJTPLV6o7WnffbCturLho76rD8/LPYXmJdICQWm0XVfTWXVr75laEFqa7+DP+3tSxV6Z00NmT0vXlR0uTDlUlyByfa1ilg3HyVy66YnoP6OwRpZ7bf+45XYAkS1PTevoXeSEz8QKSv/0Juhc88qKKvcZJq9dfkkBoIOKNc8ACw6VVVX1g0ul8pxNvKsEEBoqFSdW4JWyfT3GrDEhl2WbqtUsNVaWU2Ys19yDfDKS5SjQjPY8r2V5MqKNqavRKIaxI6hRxr0cRBb/B9lKqTgPRqCEWZxTX3T4Vp0+AC8GEPzSDhFrnelTblwH6wBKdD7LXas1Hg5ikakpzuFOW4ElS6WhNWC99Ozb3fGMQ/s57sXGdlvvWgqa1s+gO8p1Ra1xXi5WJyaiaBCdb4DTfqBqkr4YFqhqGDyXGH29XPQUZJL5cBDHi7uoXgVA
 O/IPdwqR
 /4ucwwqkgc+izLDBlCplOTzOMRU3Jmm1J6+q729V2aivm8hduP5+tfk8MZpHpbBy/z+IsF38T7aFGM5Dyj7gDdjGjTOH0dhtKJPW9QQAeiP9ubJSkMNVHkVGcd6PrYi8PKb+TbWyauVICpFmCOitS4cO3Ti0a2zVjxR70NvkgtDCyJr8c4Lg9iQA9NZXD0E/+VxNy9OJgKzE2eUbM1vdD/U3UjloxepkTLQwwm+0QN/4xP0eA07oK/Iky40Duw1JHSH5I7GtRgm54szFGaVgYBdxlDoB6pGCl7f3d/9JWtzRMKLQGLFVd0h1nlTAeNlgm0p0iWy5lWed9V8IOIdAFCw5gUFJEI5SbcBz3DnVq/+ZDfARted4G017guPw3DKF0KF2V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 18:05, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] mm: hardware A/D bits discarded for PUD folios in
>   zap_huge_pud() [1]
> --
> 
> commit a6bb79712598f2da7fdcc94c9b1b5f8b9aad8851
> Author: Konstantin Khorenko <khorenko@virtuozzo.com>
> 
> mm/huge_memory: use folio_dup_file_rmap_pud() in copy_huge_pud()
> 
> This commit adds folio_dup_file_rmap_pud() to duplicate file rmap mapcounts
> at the PUD level and uses it in copy_huge_pud() instead of
> folio_add_file_rmap_pud().
> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d0e19d9e6b651..13caf81cb51af 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2100,7 +2100,7 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
>>  		 * TODO: once we support anonymous pages, use
>>  		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
>>  		 */
>> -		folio_add_file_rmap_pud(folio, page, dst_vma);
>> +		folio_dup_file_rmap_pud(folio, page, dst_vma);
>>  		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
>>  	}
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but does zap_huge_pud()
> discard hardware accessed and dirty bits on the PUD folio [1]?
> 
> mm/huge_memory.c:zap_huge_pud() {
> 	...
> 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
> 	...
> 	} else {
> 		...
> 		page = pud_page(orig_pud);
> 		folio = page_folio(page);
> 		folio_remove_rmap_pud(folio, page, vma);
> 		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
> 	...
> }
> 
> Unlike zap_huge_pmd(), which checks the cleared entry and calls
> folio_mark_accessed() and folio_mark_dirty(), zap_huge_pud() removes the
> PUD rmap without propagating the young and dirty bits from orig_pud to the
> folio.  When unmapping a refcounted Device DAX PUD mapping, those hardware
> A/D bits are lost, leaving the folio with stale access and dirty state.

Probably not that relevant for fsdax, which is the only one supporting PUD THPs
IIRC.

-- 
Cheers,

David

