Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7F7CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2F56B00DB; Thu, 25 Jun 2026 03:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484936B00DC; Thu, 25 Jun 2026 03:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A4F6B00DD; Thu, 25 Jun 2026 03:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10A546B00DB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:26:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9114A1C5F05
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:26:23 +0000 (UTC)
X-FDA: 84917601846.30.8250573
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf12.hostedemail.com (Postfix) with ESMTP id 705BF40007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:26:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782372381;
	b=hTIfzFP+yTHURZqBr0CqsNMbI0zITwmJsH0udcPMvtXqHlafb+jmN/CFWVBktobECDq2VN
	3Oyo4BA/Ik/9PUykFuY/K4Zz9rNNffMobAJJfiA1sbOjTPlbFiIOnYISbVq5Zwhf1PtAjn
	dkyWa5MFTVWAgauB/91Wt1tJJ950PEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5rjlpjpln/OQF/MFigzfhap+Q60XqCoGKPkDC4HAvUE=;
	b=dfSMIEyxemdMM0/kCqa9udr37xfhMqTkpcf90mpo+lvMJXzO/W04HHPv/or316UjWVs+nG
	E/GBLEhcm9FjxRigfX6z4UwewWlCTF2N8zaRiB7zF5EXboAaf/b1dxuZsvLPJ6j27w+LWH
	wdVDVmPYl/wb/5qjo2Q5B9uUf1uyg4U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1408A3EDE9;
	Thu, 25 Jun 2026 07:26:15 +0000 (UTC)
Message-ID: <2885ebe3-e478-4c99-a48a-606b1db835a6@ghiti.fr>
Date: Thu, 25 Jun 2026 09:26:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com
Cc: chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, chrisl@kernel.org, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624075700.751467-1-alex@ghiti.fr>
 <3523f142-778c-4efd-9675-3c68b33e7e3d@kernel.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <3523f142-778c-4efd-9675-3c68b33e7e3d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTFJ9hiieAq68IGhaRrzEV/GZqQjMTTFMZ9hUg41+kNVhP5pDUgvpMIPRxpG7ieDDbHX8JQdlFIbDjXf2uV/O6TwdqbC8kzLMxfDnBVT0M2ZJL1wmgxLisc+LjAEKf3y5umu3w7HQMr1IAGgojIUNAaRyG8B7pllVcQKfMiLy7l118uJiLjGYPd9Hcmx/FJPHDQRAtk87YnGSc4tEyXjou5Kr/xcis5q2kNZzcIoE4OZDdjUnEgYrb2F58jcYJYPpOyH1EJ01UZ0w2UVNV2j6Xtyex2+o25cAWkLl+kBaW93IdZnmggZrR3585Uv81RZH1yjOA8Ug7AEXVOu0MVzu9KbaAE83O3FXOBwC+mah1xk0pzPbUXdPb/Ql//r+PHGofV/sz+uU17U03HGRv2Q7PriIIJTJxtLq2JU9gFHMBhkiVUrOVq7Y6SKuQUOi3aMWChbrdUIK1/KGbHRSU9LCQwdNEN6bS/d9lzT5fQLE5we2NQz0lMzySRFYM0ElULw6jBL6NtdvblK4RVwItt5ggw3PrCwefSpxWwSNTKkAqyPtZpZBElSqnjj/s1AXkzH09TIkryrg3xuwSIN1+ikLcvBHszFeAn+64rN6zHerCdC0bL5NLJeHqe1ujchOP0Kwldk/BljncYv2TnfpJcug/fuGikiBLit0r5s/pSQ+DfjyQ
X-Stat-Signature: 1exfgf3tg69umka69x5b3kxnrcs9fj9n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 705BF40007
X-HE-Tag: 1782372381-349562
X-HE-Meta: U2FsdGVkX1+3NbOh8u+J2/lu4FEJN1tmLWgJP6bzxITJ2mSN3AMQWrfxoUm5WZvmNBVVsI2RNzXWcq4UBwuRjkZ7ud3Wj1JiMVlhIqRSaW1v+lyFFNtA/m9KeirrhESI7zlyuIfB0noawYp06Kyq+/ItxS2aD6HhjJ+pkzB7fTaoLw97EPxnQskResTNDDzx8EQxTY8oqsjKOREBF42/cLcL3Gp97maU0OMDnBbQdGtstC23QgZHmh+pCp29UxL7rWbKXFVlcgRN3+2FdYhlaJbCTLDsGhGfFau4kcLWOrK6yxrfEgGroM8+hAE1xMf4Ix6M2xA9kKuvP46eVkB6m80lVPt4GGJ512h8rIOGcO615GxOpuWFcareycBBxzuLae5dk0GCvW+/yk736GLo6yrFnTQoAyseas17t5seRUsIfgznRnXmwZnTYZ2dmMxGE48+K9YQ0ji2xDrt1eW3TvxRdBKZQ1jTZYwLlocTm2TYUtMOc6xiKFNKQRTNQCkis/6k63IPPZN7V1tJzn/mtx5ReZ/0ESR2542kG569w+S1146HhHx71bOK/NzTrnnSa8w3HH2SiXZqK+JtdRWo8I+cqsbdJ524VjFOUE1p89U/S/bZ9rbosi8M/SkkhrH+l34+yajYwjN3hblaP1XfGbzrRDjFOkL6w9a+omQOgowVx4gEawKqIZwc2l3ipMxy7KwvOc8Y/KbtN/BR8ySVVlYewMQ9060XQEK/RJAVs64iEl77ZWWSBp2fv87eOPCz4dRv5j23pbKWUdbxaUTFcg4Js4aNx0Cjmfra7OO2l2PQ8o7uZQRE2OaldVJnMXSo29CWvzBNQK7S6TE5bJtM0Wlu7VwbaVtD60F4o3Jov0BBY5hbc21GcnsVvlHibsaWrcrcvWvBtHKaxsNlShGN/JvHlvEtJ7lAeb0xG49OMFNK45CMedjj5yqM3yOqx2x6rgeHxwevuWNexsk04z7
 dQ/iZuEi
 KV1EzCSTz5PTnmJ8MFKeqgWFp6PqnyDI4ubY5cWVnyTo+ukGwuoFz9q6jNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 6/24/26 16:58, David Hildenbrand (Arm) wrote:
> On 6/24/26 09:55, Alexandre Ghiti wrote:
>> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
>> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>>
>> zswap is the same kind of in-memory, synchronous backend as zram, not a
>> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
>> swapin_readahead().
>>
>> Here are the results from bypassing readahead for zswap too: it was
>> measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
>> off, on Sapphire Rapids and 3 iterations.
>>
>>    768M memcg (sustained swap thrash):
>>      metric                 mm-new    + bypass    delta
>>      build time (s)          405.0       341.7    -15.6%
>>      zswap-in (GB)            79.5        53.0     -33%
>>      zswap-out (GB)          144.8       115.6     -20%
>>      swap readahead (pages)  6.79M       0.45M     -93%
>>      swap_ra hit (%)          72.1        89.9     +18pp
>>
>>    1G memcg (light pressure, build not memory-bound):
>>      metric                 mm-new    + bypass    delta
>>      build time (s)          177.7       176.0    ~same (no regression)
>>      zswap-in (GB)            10.2         7.5     -26%
>>      zswap-out (GB)           27.7        25.1      -9%
>>      swap readahead (pages)  1.07M       0.08M     -93%
>>      swap_ra hit (%)          68.6        87.2     +19pp
>>
>> The gain is from no longer prefetching pages that are pointless for an
>> in-memory backend: readahead inflates anon residency and thrashes the
>> page cache (file pages get evicted and re-read), lengthens each fault by
>> synchronously (de)compressing a cluster of neighbours, and adds
>> compression traffic when those extra pages are reclaimed.
>>
>> Bypassing swap readahead for zswap therefore makes sense.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
> [...]
>
>>   #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ff338c2abe92..5aa1ea9eb48a 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>   	if (folio)
>>   		swap_update_readahead(folio, vma, vmf->address);
>>   	if (!folio) {
>> -		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
>> -		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
>> +		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
>> +		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
>> +		    zswap_present_test(entry))
> This should really be abstracted into a reasonably-named helper that can live in
> swap code.
>

Makes sense, I'll come up with something.

Thanks,

Alex


