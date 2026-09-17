Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2168C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9AAF6B008A; Thu, 17 Sep 2026 11:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BB46B008C; Thu, 17 Sep 2026 11:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9139A6B0092; Thu, 17 Sep 2026 11:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 706066B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:54:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66104C03D1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:54:04 +0000 (UTC)
X-FDA: 85223700408.24.1EA0BEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98DAA18000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:54:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PK1JV148;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789660442;
	b=Mqmux4ctCcrAcc/IZjWYEjoDxsGQ3BkDiw+WidjdPkOGZ/fmxWQBJFLf6pnmNQL6bm27/r
	EtX0BwxzlzqQFPSutqX/W5MImP8ujo1f5rqDBm8s1g4AlHSSIQBTZ9KlZisdjRkIGxWB3+
	iDXUE33rl74oVlQNwgZVdywzzGDpZjM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PK1JV148;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789660442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPH6qf9tTmILRDRkSSFPngCp/v4lHSqWdSjRppjcWwA=;
	b=EA9m2ml6Os+ZUcn/eBA6oEYcE2AGJVbFuuHp3MTdN6RTJL4VEKjEBsc/1qdLARfWF521Q0
	o/cECaVreknSUA7HSMu0YcC7iMUQvgm9D/DQDMLSANf8dcYuzlka1csE/s1DzBHjPWtjtY
	6PRTJBpqFOy1Bq28AfggO583Galh4m8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2B2D601F1;
	Thu, 17 Sep 2026 15:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3141F000FF;
	Thu, 17 Sep 2026 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789660441;
	bh=hPH6qf9tTmILRDRkSSFPngCp/v4lHSqWdSjRppjcWwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PK1JV1485YMoCcTJI72m37Jd9fm5S31VtwW0gFIPi4GiOJ9d9hVaqtqb0Nj3ArSgy
	 pG1CeBw8mSrtzjQDiCbKQF1Kg1XLF63MLu/gbuSJHt6IGXRcqQVcu2c+NotiTYb0BR
	 22dZ8DCIY5m9HsBkSsfQ+2lISgPJBFSoqoOhqV3AWu/RQ1/nmCdvsnjEDqNXSaO+yd
	 oVx/WnAOz1QU9r7Lgv33Mb6Fz8qJOEelSnJhg2OVoD+fFyDpxvtxtUiQ3Cjg0Bg2ps
	 mPIf8zBuuiCPZ0mtv5nXg7OLUTfxSgyhcPgZEJNLxJE6P14tBsa70vLnZCDmmaWOup
	 b+Mb2BgTtToPQ==
Message-ID: <248118c1-b204-4d79-97ce-1406439ed08f@kernel.org>
Date: Thu, 17 Sep 2026 17:53:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating
 promotion
To: Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com,
 pfalcato@suse.de, osalvador@suse.de, hannes@cmpxchg.org,
 raghavendra.kt@amd.com
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260916223525.65ae1628b1457a716efc298f@linux-foundation.org>
 <aquOLzXGdLmyBaIT@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <aquOLzXGdLmyBaIT@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98DAA18000D
X-Stat-Signature: tg31dqnpd59px7ghpwoupssuhymm8qxk
X-Rspam-User: 
X-HE-Tag: 1789660442-231831
X-HE-Meta: U2FsdGVkX191OKgkQ8yL+LkYXPJz2yF0Sc+g516OVmOw+BU26SiiaDPhRPg76ro1XANndQCI2vNpXRfwPPkMTqE2SQBtW1RLzcqll2BPuHMJa5jL7/zYcM7kRE8j1+KMPAFJ4lNlr6rfKH2LqiwdmGQlvb+m7DxCRUXVyKZxYT4cFVOzNDlNvS44FxNvfApu7K3C21W++p4Bzwip6jmjIOwvBM6b1xciY2NSIIuwMRG8xFsmVdlFVRPgrlzDgldPz22ZkNuqGQobW4fWzUFS/th5cX4vW+SrmB070ro7xAjxFfMb9Kz9IV6rUGPqngX1GiH8KW81DW+2OZ9e9LvmQzO7xXvUVrW2xS8RUcs6Ba06f9yHMV67MO0j9AesrAYztXJ8zmXShChcOu42WVa9F239khvxX1igS/EBaQ6NoJKSnzr+ZG7z/cFXyajq9y935+9tNlQNsyPnkPNvG0RLMhfYfGKFXH00aqOjlf9/d/y6BdrLcupUCp2raM2LiNKtk2ngtoTlPPvm+jMwOpn3yDNFrYw3UtJ1GpECCaMeaM0sN9iiCVjENSA+pW1txQvR6uOqchHhPumiEROTSxWmN5lwGPOgCUtgsP95Q/h2QdYvomacuPqQ8zowxdyJGb+2N3mw4t8RUgjal6zQfRX+SeNnhjv0v1DL50KnIebCE6p7lsS2wkk6Bxnvp68Bal4rx3bYbM4E471nvsPyaL1xy6jgigjkmIps54gQnI+/w6KmevX9E6rKyHiZhPClJ2ui6fK7sLchYX0iAcapWYPQzBbc+vJIw80kpmlXdtSMtFdCUp3fOl4UPvGh5bphC0LlzTlMzwQWUhCujXGz4Tj74PIZ4jN9TSouKO/sH3UOATARozDUxtpY0lOkB8v38NsAkpvKBRCfl9rXIAUCuYa2lcbTkp7Wi+3rmnQgdVgAJGvY9rp2Cs2IWe9UR22Fv6J3j5E6C69NZEva6KaS6x1
 rMSBWS2a
 RXlltxlpm6HAo4bkDDGXTvaSLn/QMSF9LC23fyPxwEbfEbKq6HJ4AKssBa/2WfbJY03tFbu7PjIdUZtetCA4Y9J/Gb0D+zLqhXXPpKFPJgbDXuNpzoOZTJtzH/vNqd0EafUZjlhlvFqc6T9MDWbqIFFvOZeKwZ1L225qK3tqH9xeWD832spQ+2O1UttpVTgY6tqUQO59SEs/uJowWhVEt243zcAHnWgCujANGDGvJL1Jj3ZE+Q2zz5YfMQXlM9XZjZJhJTmzlGVYIW9DFC8cZVwAeaOqUYKnCqtTwtikR3LkfciKwq9Hrz17JJU3yL8yjyC0XX02FyebB6UdMu47BA6aO7k2tcK4tx3VIYvTQnRFemBqzzHrXSaZbizNRPg9PI7di+7o0E07kT6cpCpZkOm5TCDf+US50Hk2ugCkbKEHvMO2YBRPBPrj1Mlamx7U2c5UguIBkDWs+kWymAgwjJJV8h6YSAz9Ly+OM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 08:59, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 10:35:25PM -0700, Andrew Morton wrote:
>> On Thu, 10 Sep 2026 20:18:22 -0400 Gregory Price <gourry@gourry.net> wrote:
>>
>>>
>>> Functional observation:
>>>   A 20 GB hash table VMA that previously remained entirely on CXL was
>>>   split evenly between DRAM and CXL after the changes - and tier
>>>   residency tracked hotness.  This was previously affected by the
>>>   stavation issue caused by the "unaccessed VMA" filter.
>>
>> This seems very significant?
>>
>> Why cc:stable and Fixes:?  Is this something which ran at these sorts
>> of speeds before the offending commits?
>>
> 
> It's actually that the changes functionally broke numa balancing to the
> point that it just became completely ineffective for very common use
> cases.
> 
> We only didn't notice because another bug:
> https://lore.kernel.org/all/20260629163337.1264881-1-hannes@cmpxchg.org/
> 
> hid almost all these issues from being apparent on large workloads
> (which was differently horrendous - that bug made ~70-90% of some
>  database workload memory ineligible for tiering)
> 
> Once the shmem fix went in, all the starvation and filtering issues
> become more apparent when the bandwidth numbers stopped making sense
> (see above).
> 
> Basically numa balancing has been broken since 2022/2023, and anyone
> who has done any testing with it since then has been working off of
> bad data (incomplete VMA coverage).

I'll go through the patches from a MM side. I am not a big expert on
kernel/sched/fair.c side of things. Would be good if someone could have a look
on that.

-- 
Cheers,

David

