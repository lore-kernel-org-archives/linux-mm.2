Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F88C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFBB6B0098; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B076B0092; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303736B0096; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03F8B6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:25:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F505A045D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:25:29 +0000 (UTC)
X-FDA: 85147423578.20.17A3EF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A3278180004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:25:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n7/r67hd";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787844327;
	b=0T5eVUW24Mz78dyhZSsjfFxg6FJZwBpcugoCPfAJB97a49L07L1gUM3PJSj+FsDK4PkO1I
	cg+EeosrUZIG0MQai9zppK/TLTzcCuMbXYZChEoYhh23ItZDYWBsgxMwdGgxFlqbEOsTgo
	4ePew+arwJFud6FQ7x1+/X2TrS2sWXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787844327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIsr8YGMo1u0diDgy7h2P49ddYFTWI12rSRTVLjwN7Q=;
	b=eH3NrHWIf1KF8Q/V9/vriNOD/znCjKqucXbfHOD+NK0bJ5LaQTJFzdTGmisbTu42O4wIlb
	r6Ak7pEnklsYW63UmJbRB1KGNtLp6tFOnrH9TpLdayt+atty6mgHfQhi84NS6GhhzMRHuY
	e+vyuhMnu3QuhyQEyXqq0HuF9uWTFns=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n7/r67hd";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC20040A6A;
	Thu, 27 Aug 2026 15:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5131F000E9;
	Thu, 27 Aug 2026 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787844326;
	bh=GIsr8YGMo1u0diDgy7h2P49ddYFTWI12rSRTVLjwN7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n7/r67hdM7EezCfE26KRK2p12eJIjZ/zBDqUya+yxx8kActvRK0dT6D7YnTi8zp3D
	 4d41BK6Qpq5Gyo33Nn/djyf1JLp+a4OUfKCnwamvZClFSEfqe1xw8KMKtrRMx++6ft
	 Ow8m1WQnc+JA/ePg6/Nm1V4PxbQBpYvMangBE/7J9Hnb6c/agMyESFVPsK8T12pg1g
	 TZlP00Ox1zyDN6UaJ3gJqRVw8PmIs0bP5cMSVTIDqUa0I0rui9YuhokAOUrA33H+6e
	 JLZaOPwp/rabQ0jLFDyNc3W18u0ttP62T2oxjTaGDzxy4RngOy71oJMnLZVDR/DRsh
	 znLuRviPpcegg==
Message-ID: <c3b713c5-ff65-4f83-a8c7-5cea4ad13873@kernel.org>
Date: Thu, 27 Aug 2026 17:25:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/huge_memory: dequeue the deferred split after the
 split freeze
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org, usama.arif@linux.dev
Cc: lance.yang@linux.dev, ziy@nvidia.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, liam@infradead.org,
 nico.pache@linux.dev, dev.jain@arm.com, ryan.roberts@arm.com,
 balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-3-kirill@shutemov.name>
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
In-Reply-To: <20260826162101.1314941-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3278180004
X-Stat-Signature: 1btdtjdwgxuj4uu1jmo5zfc3r1d9n7pq
X-HE-Tag: 1787844327-864811
X-HE-Meta: U2FsdGVkX1/3FU7aX56Ao9zoNwIzBDdVb30reU/RDbrPscIlhM09IHICXhrx3hi5z7J0RtfkFM9gY3YqaG1A6zEDQrt0HzSZwWmv59raOdP9HZNu70YB48BczWbgTadPxEgrkgDu16XX5z0g+qP6lXae+5JE1SntipBKALJv9s/a3A6eJ6qcsHOqlTe1aRcwjH4aJwIPZF1AZWEJ98fexJU9phteA9RAlO6dIXmq6elvz9Z3HgjX2rfUozoCSSA3UmZlxbIck2saaJy7AcQ82157dGtpZfSISmVqOe86bPgmWFX8o75ZEvc5bZjzTmli/FB1KSbkxbbkJWS9njbBPf1k38EM0GUs/sAECxGFeMrGtgckSAkeqTFL9eMv1xZLXNJmp6sC4+dshfXxBd4anVosKRAhqcxT1ZhwcWErUOYXgFwKDfiTpG5eq0srMGb7IuuDD9G8r1X6K5Eg72TnBj1Fle6RS1Z3FqEZBS9GpsrmBicX9a6pua9wO0fHbNoKCOFTVMshpjK1R+T1zSgjtzSAGmEcruaAuvsAmxw71ckXd3RYdhYb15fSVUdRTVQz1doCwrxNOaRvP4qausE6CJiIa3xgpxnEOAj1jZK0am9gn10CA2Dw63BZ0rKAtrERKRcWdzN85fX8hz5suyK5Rr7dus+JFMFOmOHiLl22BBWMHiHhjkNnHfJ7ULL7kAdqIwnXrovej6qUKS+HuP+ymfyZpIGN+KFleATxmuaidbrv7VOl3s8ItwI7y0j4hAh3vTmFRokwxdFfinW72PDiciNJ/KoksH5ClcgPpGbqknfjVJQhRKRgZ7nOOlZviAi5ek3plkHJ3bez8LJl1QOCCTyA7e+VGSs6wUQsfN61oko1r72y1iqnIKk38qedKbIQVvZhR4umo3njieBXO3740kP/fjW1uYhlvldF53C1JSqTA8//vBvpDwWqax3l8pMmg0ZlWOx+w+lA2QtrD/K
 /wCGKcXb
 PZbGlgNmfMj+ToC6ImYclZzObDiS78g+5PNRkgrIZOmXeFvOx0y0No7ReMaQdwK14+HxNOUqSLsgIcbKocEHa/Mihqmh/uh6pkKVcR+dC/pTDWlQ4UBvM4Utlw957QFpYQc+tpI+e7FOykFPQLK0QWkE230knLwZF22/CuvMgVL/oWXCW0oJqQ4VCgdXRsV2SRi6/4VKi9NoALEaDGQU9rjB9mVQZ59YDtbY3shOF/tJwUL33E2YNAj4aRPDKSM+SiTfycTidJA5aawLqv3Uu29199revRFz34wJG7jN0r4KIu5ihJVsgNboeLRq5Qjzz1HKD3seglE++HPOH2lqGnl+pQs685SSY/ceA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 18:20, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
> across the freeze. It is only there to stop deferred_split_scan() from
> touching the folio under split.
> 
> With deferred_split_isolate() fixed, the workaround can be dropped.
> 
> Unqueue the folio after folio_ref_freeze(), the way
> __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
> zero refcount and a memcg still set, and both hold there.
> 
> If the split is called from deferred_split_scan(), the unqueue is a
> no-op -- the folio is already removed from the list. But
> PG_partially_mapped is still set, so it has to be cleared here or
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

