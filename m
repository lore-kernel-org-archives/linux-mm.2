Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F9BCD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8626B0005; Wed, 17 Jun 2026 07:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9606B0088; Wed, 17 Jun 2026 07:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871776B008A; Wed, 17 Jun 2026 07:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8D66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:50:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF642A03A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:50:18 +0000 (UTC)
X-FDA: 84889236516.03.5CBF4FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E805410000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:50:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZnOCI4U;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781697017;
	b=3TS4MKfCeqINhEqc6Iw+MBWzg52U/FOx7YM8RdzhUFya8u3TXam1ETtAqncLPQ2SIcMyHn
	bsuu3T5D0yRGz5qSeTdHDt9J/ee7ZgbP18PIZVkJQE/y2OfbOPxAaXcU40Jb3A98XiIe/S
	zAuBitu7gFGz+xLuJ1SmjyfVhTEnamE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZnOCI4U;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781697017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVkNiTSVLIF7LekdJUy0e+m4ZQM0CSRCkFIfRKKLO50=;
	b=af6G0bqKeoOcG5EaoEKkEdPuNF8ZKHdOsW7DVZjWUUs5NQPvt1Va5rKlr3Mj17U/4VbUn7
	t9sMWfWu0qJabhzmIEeIDNzKUq+iY2dgzk1MISGOPJvi/jtDqKlCbLzEt2mYmhGZaAF4nN
	+0g5rZw4fXOw7aE/fLa/mAsjgy9YB5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29A1841A14;
	Wed, 17 Jun 2026 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C84F1F00A3A;
	Wed, 17 Jun 2026 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781697016;
	bh=HVkNiTSVLIF7LekdJUy0e+m4ZQM0CSRCkFIfRKKLO50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fZnOCI4Uug6POq2h+NWbR0uX/o1CFrDhx3LMy+HX3vR0PD7fjUjJOcSOwNppBeHzz
	 BiVD9zFBVoOfLtETcRIkHlIgXqY7gbIGC+1DuRnveCdWpJKJtBwkfcfxVpRmyFQbE3
	 56cUMGvMyM4s9VcxN4Hyhrt3JLq89jfccS9Wtg9LFWB+hADL5z0X9SaD3ucfhspEN9
	 cMmE05GtQuEKHoW6xWVwJ3OQ6CUNyC/swv754fLnkGE9qCAHyUurSrB4KSzv0ip3fp
	 wetlp4S7pc11Hyp/qCGMPyuGehLWAwqmpGkVS5yKPxHlJoThpFqA6PgiuMMdYrKYvl
	 o4W1qynTNB+Bw==
Message-ID: <3b20ad2e-bb69-44be-bad3-5efeb169c573@kernel.org>
Date: Wed, 17 Jun 2026 13:50:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Dave Hansen <dave.hansen@intel.com>,
 Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com,
 jannh@google.com
References: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
 <20260609143801.7917-2-xueyuan.chen21@gmail.com>
 <930d9121-9176-4a7b-a2d7-8224f94000d3@intel.com>
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
In-Reply-To: <930d9121-9176-4a7b-a2d7-8224f94000d3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E805410000E
X-Stat-Signature: bihzwtpe3h39w3ow6rwgjt5dbrgbuf5p
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781697016-380141
X-HE-Meta: U2FsdGVkX19UIxoLn80Oc+kqPwIxEpjOjeHpLV44YqsmzS9Igc6H4VxoTUdY0AlcJyCdN/vT14D1MBaxwGA3BmwZXDxTTwigoPEANZhKdB0MCofGFim3N7l6My2fpTgRobBSTx7iss05QEaSPq5RpOLbdpb+o7sQ9iAJwbs6PQis+6WIlrnIyZaIahXDJhNHLPtgfWFcIDyeM/ehkNu4+m2WrBxam1FDJuHX4xyTXy7z9pRsGYymFxstbxqBeCrsyHgbOjl8IYWjxEW2gTXY5JqvD3c/WyDwrDA6o752QTtnEGGkfZVuTGKYGk1c+wvj5aY0+C4+eldrwW4m/fPXl+tTXiI6ikMGhWwK1y4wfZ9KOH6hDy+7yq5T1BcPtKzozBJqVCEZQ9cZ1tgBM510EHZCxvRQR7uBbx79JY/Bt0wZSMo1JYGICoUd3SNTbEWOp7r+N/Ym586M7kn2P40UlczQ4ogqJ2fuDXk/VO/6VTiTLbxOAjbCUkATyLGU3TZkQj6YjKk5Yr/pFw0+Fiv2nJdgNXjVaXPLOg0LfgnmwQ3UG9OiyrhRTfAbaSpwk6UYa5ttiBpqSmHQes3qCNsXxc0Gk/ueen7bSokC4Iiu12wMlJdSoe2pESGndidT0LLYRQUiD3WfWXHJ6mI+riNeCsbZmu+s4AU/bj43EP/TBsbs7dmVi16exGUidY3IA2hmZkZ3QxlMTMQcOHRNvuBUGNJxmNzwZP8X+DXzMUQW/ona7A6lz2gIC5GVpWPnkA/mTMYEyg8qF3py26Zmb3aFbQraU842vsmzHrl2Ak5csnBA/UbwcR6iBdzqCdLfdlmV408NKCV3dqS0SWwjViBM4NsIgsYr7lKDwI0XthSOP/osgq1Cdj0Dk3gTrSmAEMv/sQUQh++6YMID0x3ObDl7vSF13bmN6RjrvqPkb2Ncp7QNMwm6m5xAonlOHw4wmGKKkvL7zq9knK923qFTX+z
 +8PgU/bW
 V9cYBrKBd3YzLLj+hQVp0nPKbC+91j19WypNxFZC7RUiyW1XpI5uNTm2Cesi7X2OAwn9T+Lp1QvhdqFvh2IzrJimNn3fOlBpkQNmGG8JRhLQOX5aCRZj0VJH8T+RX2S3XxsG3ApqBsDDWySE6elW6lwoPFQXTGtR8belckLB35vqGRf+K8Q/pseWuRKmZO9GUTqzK0Vln/nz26+2gAdS9AON4ZIZ6CNU4mZrcMCfe9aFU/gk9CrCzvr4aehRsVwORBwgPzAY1QxyArPnOfwPOQklyh1FC4UZ/aAd2PzPk9SvJcaHRwFZKsIJJy+j9Dxv3VZRviBp76UT+cZ3hl/DEstJeEjzefKnXd675BmTzV1IUyd5M2MVVewypbwkluYpR4y0/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 21:33, Dave Hansen wrote:
> On 6/9/26 07:37, Xueyuan Chen wrote:
>> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
>> +{
>> +	return false;
>> +}
> 
> This is a rather wonky function. It's going to cause all kinds of fun if
> it is used like this:
> 
> 	arch_make_pages_readonly(syscall_table, 1);
> 
> It's also kinda weird to have it return a bool, and not check that bool
> at the single call site. Some things come to mind:
> 
> 1. This function needs commenting. It needs to say what it does, when
>    architectures should override it and what their implementations
>    should look like. It needs to be clear that this can't be used for
>    anything really important. What should architectures do with alias
>    mappings? Are they allowed to touch non-direct map aliases? Are they
>    required to?

Yes, kerneldoc please.

> 2. The return type needs to be reconsidered. Is 'bool' even acceptable?
>    Should it just be 'void' if callers can't do anything when it fails?
> 3. What should the naming be? "readonly" vs "ro". Should it have a
>    "maybe" since it's kinda optional?

We're adjusting the directmap, remapping a r/w page to be r/o. I think we should
be very clear about which transition we expect+support.

Also, I rather hate the "set_memory" naming scheme ... "set_direct_map" is
clearer. Anyhow ...

Now we are throwing a "arch_make_pages_*" into the mix.

Should it really contain the "arch"?
Should it really contain the "make" ?

Why can't we just reuse set_memory_ro and pass address+nr_pages? (highmem check?
Could that be moved in there?)

Or do we want a "change_direct_map_ro()" / "remap_direct_map_ro" interface?


> 4. Should this new API be folio or page-based in the first place?
> 5. Is mm/huge_memory.c the right place to define a generic mm function,
>    even a stub?

+1


-- 
Cheers,

David

