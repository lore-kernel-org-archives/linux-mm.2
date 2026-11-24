Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD91E606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPExmO/r
Received: by kanga.kvack.org (Postfix)
	id E15F26B063B; Tue, 24 Nov 2026 03:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC67B6B063D; Tue, 24 Nov 2026 03:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5466B063E; Tue, 24 Nov 2026 03:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A315F6B063B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:25:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 281B71A0AE1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:25:28 +0000 (UTC)
X-FDA: 85469328336.07.C4D80B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74010C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:25:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nPExmO/r";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795508726;
	b=lhKU1ZNWCI3dcAqdx93jdK4kouV3N+SY3WMfYfc8viwuLX/xxmO0HFVK0k//+S7B3tec6O
	jMLOhIM80l2AuIjml5w31/vpDbF+o8cmq4xCDy89pa3ktI+B+sKdfWZVqJ2doHjIvMOosF
	PlKVUIp69euk9ULejRU3T0F2AIfW5kQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795508726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YC56fOuK2lKYPOoLLh5K2Mmq0DOi0LfSniRN6pltyg=;
	b=XlObJAwjfPT8v1ArYq5Cjq/SPc18RLAX+24OeV1t5N/bQqxPcmsDs5mIW+pr5bbF/15Oo6
	PfE5iUOxSsiOom+PzH0XKRUIHFZFugAj9qkBDJX7jRKrmdPRd3NFfdfFA70X/SIIMGAor/
	ir6iTCN9D6+iZkNZbMHEcxcFzdjaCQo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nPExmO/r";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0212C6224F;
	Tue, 24 Nov 2026 08:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA771F000C0;
	Tue, 24 Nov 2026 08:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508725;
	bh=/YC56fOuK2lKYPOoLLh5K2Mmq0DOi0LfSniRN6pltyg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nPExmO/r+i9gdd3EAohwkDsXt1p80upAUPOUyQn3Mn4iaQdFqzONg1Wt/cOivBttv
	 Gj2OjcQZYdN+pgo5w9hAJGg3IjqV8oj1iGqW1sdhfwxD4re/RyKU+a6+QYDJPHJ2mh
	 s1mfqA2Tsd5m0ut+b2Jds2M7oxMaVhlpOYwr99NkEuNSzWVRqCn6/sIZgZmBj5zD/R
	 gN71INdtQaLPHuvU+nhN2UGRjl6Lnf8xvKUJlfoitHnSNatzS+c8uICRrOT9ECewju
	 4iuv3BiGNHtUR5JoCN6zu+nOS5tcE6q8jLX8Swsax1c+4PHgkPP5aogewdTTVXImlB
	 aNgBaPLjwaEJA==
Message-ID: <031b595a-376f-4848-bfd1-ea85d273db13@kernel.org>
Date: Tue, 24 Nov 2026 09:25:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] fs/proc/task_mmu: read the PMD once in
 smaps_pmd_entry()
To: Usama Arif <usama.arif@linux.dev>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
References: <20261123163301.1568240-1-usama.arif@linux.dev>
 <20261123163301.1568240-4-usama.arif@linux.dev> <awR2bZl4CvSuInmk@gremlin>
 <94a074f1-753c-4ed1-99e8-59d227f70ea3@linux.dev>
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
In-Reply-To: <94a074f1-753c-4ed1-99e8-59d227f70ea3@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 74010C0003
X-Stat-Signature: mhp8qxfeisq3fboeaf84jp1y7en774bt
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795508726-738210
X-HE-Meta: U2FsdGVkX19cPCUNiRlOd1vwQJYE/nzCWtpOvsStYbEDhPbTjmjL1pB3qiNpHrjsOpOyS3md34Y2Nzy5l5V8EjwaldTmWiim9YR9PBhQ9CH4e5KMAdANkkEMkuRhghdUNtTkCYdWkgSRYN0/5ffTc3kP/VDXAGY2gOzktTCK8L3HyVtfCFiAC0IQj6K+tJJyvlRgbGUgZXLYCcaa9cZSIvaxOob17lzCcP1kAi1yoFbcikvyI4evW3RTHZ/0g6Mu5+hD4i6RYbvsbGKo8j1kXqmo0Vc7mswLe352vtSfrGLGnBRKekLUAPa09yv4rSF8+DYNNAjPrRxahrzqFvHeuTr9Ofo1Ii/Pg55YROjy91In2cq5ajalfOK7JHNOzkvmRo8hinmefE2Kfh3i3l1+RSC9jgGK06oW45YAgXuY6lE5XOhf7m9K97oSG52931wJcXWRONFJ/ucCeDxxT4f8pCQkonQay9zPfo5NYQfRldLBW88kvY/mP5p1rfm6zNKfYFzQYmM9o0QfADXAn6JtElgDFQ9ghO8YCkK+DOj/G7n2D5oLS9u4o0sbS8esZC5qv77LhaUO9Dcbhy2zLCGobKBW/xsSb7/dPgqb5KLXVEZTuBeoITpc2Zc4nnnX8k9v7A0EbQE3+lQy3+gAKsXwYmkU1AMVW+wGKJJ6Fi10hYHMUocNUFMaqeEWWihv/ydJLmnNUuOZqLMJ0yd4+WKcibieKX5qpkuGUIiUy+rMdH1mZiJ6Xqa0BKmMx6GUzOwUWIYULB+Wk20nAC5LtfqrfPWjzs5pkMXgSgdY22hFLObd+HWN4/iY95JQ+twZtNEYbA2uHSoLY9t7u5mRrKbbr6IkkAOxadFNH+E9p5Wf5ooXycz9+1SbgYkNLu9+lTVJQS9uxhL5eIVN/KSHMcx08IRW1GhyEG71hEITDSxkEqx2gG7W9fCxZd7PLx05FJrpTpoRwo3e9n24KNuCveM
 Tgh3beLG
 UE5kHUUZ+NFf3n1xg/p3o5GIgCy5c3kc6Cmc0fLMS1rTs3QzQKo511GAmCCxmOHgozQiIHsuIoNztpgfH0E7lqYvdw2wONdHBEpklUwXubN3uiMJp5oZUFfu+m7uFQjGuQT1zdRXHAZL/E2S4IIFCH65CuRDJw6H1psbzNxJ6x2tDFkZ898yMmK1EuL7oLVyamLeBKTsQSN8EtrqbQb+WX/VK1V1TeLHdd9P5lOlWUt4v8EIcI3J50np6ATK/9rsMReEsa397K7uL5cXn6UrH0pUuzilhtZLete0wtD3MkSewvSLAyzwUAwHLD4n5mY0k/Tx4gsP5nPq8bpWm55JhZmbvXLxsGuEUgpcNU3XZumrSK7yLRTs0XC4donm14/1HW6b33hoXD5xAfZ5klnX+6y3299ET+AYiV/X11A5hjs9e+trKjj3Ei2Zxwvdb8cHqcBG6NYAhEnMW3IQo7Z1hNkeMTe3e3Iy9kVO06MKphiDSsGCYsHEFRGu6BRUMVEqq6pbUzEIqrmdhQr4UlGRgQKjeVp5T3qw7VR5ZmJcqCz1c+71z5qzKFtAscxs7BKYfae4JWIn4QX1V8nBigXPx2GcuHccLovywAyXQ19aQneo05A4XBxa9qf6uAT1g946W+VaW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 18:55, Usama Arif wrote:
> 
> 
> On 23/11/2026 09:24, Lorenzo Stoakes (ARM) wrote:
>> On Mon, Nov 23, 2026 at 08:32:09AM -0800, Usama Arif wrote:
>>> smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
>>> into a local with pmdp_get(), the way smaps_pte_entry() already does
>>> with ptep_get(), so that every test sees the same value.
>>>
>>> No functional change intended.
>>>
>>> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>
>> LGTM so:
>>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> 
> Thanks for the reviews!!
> 
>>
>>> ---
>>>  fs/proc/task_mmu.c | 11 ++++++-----
>>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>>> index 540c936aad4714..105c4998eef48f 100644
>>> --- a/fs/proc/task_mmu.c
>>> +++ b/fs/proc/task_mmu.c
>>> @@ -1022,14 +1022,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>>>  	struct page *page = NULL;
>>>  	bool present = false;
>>>  	struct folio *folio;
>>> +	pmd_t pmdval = pmdp_get(pmd);
>>
>> NIT: Can this be const or are the helpers not safe for it?
> 
> Ah yes, good point. Its good to have const here.
> 
> I think the rest of the series is good to merge. Should I wait
> a few days and send a new revision with the const change here?

I'd pick the fist two directly. Can you resend the other 3 such that Andrew can
pick them?

-- 
Cheers,

David

