Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC6BFA0C58
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440E06B0092; Wed, 15 Apr 2026 04:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419266B0093; Wed, 15 Apr 2026 04:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308276B0095; Wed, 15 Apr 2026 04:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAEE6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:50:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BB4614053D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:50:35 +0000 (UTC)
X-FDA: 84660169230.08.B0FDBBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0BBA140005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:50:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyJz40R1;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776243033; a=rsa-sha256;
	cv=none;
	b=lDLPM7BHLcAhNb33hikEry9wlcdpYgdsItKC1rxRt8lWhDlMpLKN8Rk70i3+BfxIc1b3e9
	zs4zUaBFj5EAzVjQ8Wk0bD/raF2aga5OCVSapaLkBr9TIi1S0OtuxuPtHfVzF+nA2Q1iUe
	9hYNQJRXmvudJFLSrAM8CxcwP4J1rS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776243033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwLrwIUfEw37M0n4n7wNMgZr6lOOWSkFw5+n+UaT1OQ=;
	b=zwRySHFhz2zStQy/xPWlOyKF1R0bFR1lowGa9SY+VEKMM8RRxLDt/OxA8+N2vQuqJuDiqy
	yHZxvxy5b4nf1apVd1VRQVaOImoOMz+IgCS2ZC+VDW46M5np5lF5I9OkfYyg6wKVEJybXF
	euNnkHc7378RgjR2euy8firgD8QQrko=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyJz40R1;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0335D600AE;
	Wed, 15 Apr 2026 08:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B52C19424;
	Wed, 15 Apr 2026 08:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776243032;
	bh=EA/NXf/KyrRthCQc5z0PuVqZcc04Ic4HWmatgZmzjVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RyJz40R1L75t+ZY06L75VfFbTXy5F4Ogjtdjwak+NBOx6Rhzy+WxuaygGaKd88q3J
	 NmXvwaonSZ+6iCeXRS9JgsqCTWMkME5ldrIgypBfk07MFwQYqik7JiKU7UBZUwR1Ll
	 IOYG7XHFqGVfPW4zen6vhhjAMDN+W5MG6T2I70xiyzdCwpaKVLLh9gsrAXB2fa4cUH
	 CZYrmYrC8lWdXWBqtJ5Iru+WOQhtaRHv7s4QOpu9feEBuMoH83/AbGnMKkQG1LTwLS
	 quCgMJy3//FL1BNx4Djd99fH7601HAqRuZDOARnoK9yXF2s1bfQZx4KmrInLyGMgmB
	 3/SwXiieJ6kkQ==
Message-ID: <fd3b649d-f08f-48b4-a103-128022751449@kernel.org>
Date: Wed, 15 Apr 2026 10:50:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260415044509.579428-1-dev.jain@arm.com>
 <2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org>
 <57b5d0f9-3e56-4f96-9e3a-2f475a78a8eb@arm.com>
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
In-Reply-To: <57b5d0f9-3e56-4f96-9e3a-2f475a78a8eb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0BBA140005
X-Stat-Signature: grddbkg3ytykad776jmcu4gqpmbxktp3
X-HE-Tag: 1776243033-450494
X-HE-Meta: U2FsdGVkX18SR1JVsW4AdE8BVTCs0IjtP3viMqeZUfVP4oYS9n9o1xJMYuM1ZmWzJLOuZuChPKVzlf8kjlZhrtgvQVFwnlSAhrOGTvjURJMUL1EhwobtREUweN6MqkaiLt9QJLA5ya6cauKCR62t8EuLT8BoXrqacMprpNuHc1ifgB2CSqc1s/1nDgEfTlvnIF79YaGFjuFV1h8KWtMJcfvcGwxhkKkogBorN0rP8+AfxolHaS9CLu1IBz+KJACzFlqmUceqr/YVrnyPekNdaCw5o1awUXsVR7rFnfRHxoBOGWfEarW/w55YaLA5gu6BTZhGLwp26A3lAfgnMSIemRD4grbxMxMxSUfNBWLIxKd354MQSYPlDCYMpy01MC8Go8I/4VpEkZ7SpL05b72A5uiic6+7nry4F4RJZUObZ/1J6OmnpU6OdlZ1Ec5XCVVZQix5tz10rfPoYG4CS1tuJsL/i8KGAGByBIDzVVrHQWyRDA0qrPmDhtJGSxJO6X4e2BEODZJjDcP7hMmXzcSL374DbYCiYL/HuiE9iFPAtUyy+qoj0Kk4IyO51VNQdAt0k7+aP2/Ud51sp3NqDdfMzmQ/kXbw6kjcUFJLS8ekzRuDMxGoxE5Bsw2jYPedAz4tIxppySpaT8+zTkx2BaM1vqkR+LeBbyB/cSQzfygtSi0DesIf3Q7E31a66nSz4t7/XNYJbZfra9AeKznLFzyv4dHHnU0PRGCAw+AIwtgqtaDx6lOL5fRi3teP9Z6/ThIL546s4/QgQ4GhWllQYk3X/6wuMinbUoplwFdfTbYFFlXrzqWs8Uytv8s9KXzoBuIRNS+EJFAnvLSIeBzEqhFSTv/MQgI9SjxUQfbS5Dce3N15VJnhRmxQkZmAokWJEs941QA8c6IUkKLjcZ6xJLF56dWbRnUiU94ZVsHiKKYWq0ifCsozS25CQu9MrZ345evbWVKNqnauXMyeLQr3WBV
 fY4Z+GCM
 93hwAwn6jxx7Lhje3pbKWAkK4e4TVutkeuFiA32ThtvqGJlUSDnSUXriWDS42BWsqn1YFXg4yT0oA5YKozJPHMbyZN/iLnOeVOfBfORrkohtE58cuzNX93eytjFvvUW8WABSwZomEV6S61GMgW96YVyi+vkeLpN8OjlGt5uf0b4gGFmZI8hnBi09G5uoaJkVmQes87h4HprCWQcyYUUAZ5KMAqFjTraA2E2OHcI9RbBUc9ND/zXQVa9tak14vh86yC0QA+Ovo/PqmUlAkCywlMEa1Osx7zyqPGR7EiNffSrV7ioA2ezyAcDGTjpifUA1ieIyoMWcHS3L6w+SLMIuSzz46s9YYmDI1oFnOqmbPK2V+uY5D9FpRMRetrXf+Ndskjzxp//lpBnDbbAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 10:35, Dev Jain wrote:
> 
> 
> On 15/04/26 1:18 pm, David Hildenbrand (Arm) wrote:
>> On 4/15/26 06:45, Dev Jain wrote:
>>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>>> mremap tests") validated remapped contents byte-by-byte and printed a
>>> mismatch index in case the bytes streams didn't match. That was rather
>>> inefficient, especially also if the test passed.
>>>
>>> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>>> execution time from minutes to seconds using chunkwise memcmp") used
>>> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
>>> the problematic index only if it discovered a problem.
>>>
>>> However, the implementation is overly complicated (e.g., get_sqrt() is
>>> currently not optimal) and we don't really have to report the exact
>>> index: whoever debugs the failing test can figure that out.
>>>
>>> Let's simplify by just comparing both byte streams with memcmp() and not
>>> detecting the exact failed index.
>>>
>>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>
>> I'll note something interesting: before 7033c6cc9620, we would check
>> random bytes in the stream. With 7033c6cc9620 we only check the first
>> threshold bytes IIUC.
> 
> Before 7033c6cc9620, the block of code was:
> 
> 	/* Verify byte pattern after remapping */
> 	srand(pattern_seed);
> 	for (t = 0; t < threshold; t++) {
> 		char c = (char) rand();
> 
> 		if (((char *) dest_addr)[t] != c) {
> 			ksft_print_msg("Data after remap doesn't match at offset %llu\n",
> 				       t);
> 			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
> 					((char *) dest_addr)[t] & 0xff);
> 			ret = -1;
> 			goto clean_up_dest;
> 		}
> 	}
> 
> which is still checking the first threshold bytes only. Note that
> pattern_seed remains constant at runtime, so 7033c6cc9620 just replaces
> this with a buffer filled with the rand() stream.

Ah, thanks for clarifying, I got lost in the changes.

So to your patch here, definitely

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

> 
>>
>> That means, that we are not actually verifying most of the area at all
>> anymore?
>>
>>
>> The whole test options are extremely questionable:
>>
>> $ ./mremap_test --help
>> ./mremap_test: invalid option -- '-'
>> Usage: ./mremap_test [[-t <threshold_mb>] [-p <pattern_seed>]]
>> -t       only validate threshold_mb of the remapped region
>>          if 0 is supplied no threshold is used; all tests
>>          are run and remapped regions validated fully.
>>          The default threshold used is 4MB.
>> -p       provide a seed to generate the random pattern for
>>          validating the remapped region.
>>
>> Nobody will ever set these parameters, really. And tests that test
>> different things each time they are run are not particularly helpful.
>>
>> We should just remove all that and do something reasonable internally.
>>
>> That is
>>
>> a) Remove all the perf crap (ehm sorry, "advanced tests that don't
>>    belong here and that nobody ever runs") from this functional test
> 
> Hmm... perhaps this is useful, we can keep this by default so we can
> detect if a bug comes up in PMD/PUD mremap? If the test takes too long
> we know we have messed up something there. Although "test taking too
> long" is not a nice way to know that there is a bug ...

Exactly. And we should strive for tests in selftests/mm that just work
(tm). Any other useful (benchmarking) tools can go to tools/mm.

> 
> and test won't even take long perhaps since memcmp on 1G will be fairly
> fast. In case we mess up PMD/PUD mremap real bug reports will come sooner
> than anyone detecting this from mremap_test.
> 
> So I'll remove this.
> 
>>
>> b) Remove all options from the test. Nobody ever uses them. They are
>>    stupid.
> 
> Agreed.
> 
>>
>> c) Remove any randomization from the test. There is no need for random
>>    patterns, just fill pages with increasing numbers.
> 
> Agreed.
> 
>>
>> d) Just always verify the whole regions. Without the rand() magic this
>>    will probably be just ... fairly fast?
> 
> Yeah we are doing a simple memcmp() so it is fine.
> 
> I'll implement these changes.


Thanks a bunch!


-- 
Cheers,

David

