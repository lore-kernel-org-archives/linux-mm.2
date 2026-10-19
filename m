Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F55ACCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA566B0279; Mon, 19 Oct 2026 10:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949896B027C; Mon, 19 Oct 2026 10:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4806B027D; Mon, 19 Oct 2026 10:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 593606B0279
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:21:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E07B814069E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:21:19 +0000 (UTC)
X-FDA: 85339588278.16.70D97BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0FCD3100006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:21:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWhNYPOa;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5wpE0Ce426czQX30iKC6nqUoHP2omOb5e7+spqpF9Q=;
	b=pYSIAuLzcwBZh+aWPnt2R0EptBKReroa61O/gWeayOLwotlzP2fbTaS40VOsvljozIiW9q
	Xoy0zR717hMHVG45U/ccovrso1qyulQnJeWuWMqAcX6S0W+QTOKPdyucsR9XXH2bMuuDwb
	VQ3erHSaT78mIa+60sBaLPWabt3vxIo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWhNYPOa;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419678;
	b=H2m+fQQC0xygcv0ua2PuHkr0ldHOT5Vou0IqBpnsGhNIRJIItTlP7Ygasf6StZpU1nuOLb
	vXChNVovWi5YbefqJWFHHBa+Bnk23k33AfnuxzEKKU9TCkEz43KgXEJNL47HkpJKulkDxN
	d9WecTGgU8XOGcctctReGMQncBG8820=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43B6A4370E;
	Mon, 19 Oct 2026 14:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165381F000C4;
	Mon, 19 Oct 2026 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792419677;
	bh=J5wpE0Ce426czQX30iKC6nqUoHP2omOb5e7+spqpF9Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KWhNYPOan5xPFiCT6IwXfvfrXkuVjX/oWCqOUSeICiPwrZGkX9WJjhqcjJwacxwzL
	 fexJ2d1hVI7uZCaQ/V7pm9RZfn50zIa9bpuRQfLOQHRkFDI4J+IOQA1EK49VtYfvLF
	 t/b5cXp9Rc5ZsEmjlPclmNKjtMk4p0pEm6PQN/DGostcKs+ZoYHFqlGFGGlXTqgxiv
	 btrwUTIPYYqaHUQuGN1m85efSCk0MZL53djPsgeoKt7erFk0fHFvMJrwmAggkh2mF8
	 rQv31lIwCs4WfpEYwUu4A8u/X7vPTc80Kzq3oK9niFH2dCbtEwkuc9VeoK+ROSw4l3
	 2eQUGxgZv5aAw==
Message-ID: <046e3eef-aae6-4361-821e-06cadf250d49@kernel.org>
Date: Mon, 19 Oct 2026 16:21:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
To: "Garg, Shivank" <shivankg@amd.com>, "pfalcato@suse.de" <pfalcato@suse.de>
Cc: "tejavojjala@google.com" <tejavojjala@google.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
 <rppt@kernel.org>,
 "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
 "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "surenb@google.com"
 <surenb@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "nhuhuan@google.com" <nhuhuan@google.com>,
 "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
 <liam@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
 <rientjes@google.com>,
 "torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>,
 "x86@kernel.org" <x86@kernel.org>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
 <atX3lpXQBHH1JPhW@pedro-suse.tail5790ac.ts.net>
 <ad34dd6d-f106-42b1-b8b6-a4487822285f@kernel.org>
 <0346e29faa551efb6a4e21a920d344f5f9b918e5.camel@amd.com>
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
In-Reply-To: <0346e29faa551efb6a4e21a920d344f5f9b918e5.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FCD3100006
X-Stat-Signature: rhi1acrb1fdt1mwhg9g6q4jj1e9a5bsg
X-Rspam-User: 
X-HE-Tag: 1792419677-601458
X-HE-Meta: U2FsdGVkX1+mow+7EhA/48LemeZthjy3eHFmd2z0hQYjwIFPGq3C6RUqzbZFgroabbiuzTl2ZPThHrnw+HBksbHFMpKYZJZAGAdjNQXGZTZ6ZuhmVRPbm8wN0X7Hh5iKY5QlxlDsjyoMEdkzSWIPVSN9sIAUntiXX9VOjmM+rBJL2xwtKcFpxpC3GfetfmYMLBIvddGXmwN8RWGeV00TsKW+3qtYYYalEotjBWc4BqPTaQrUNMA0wUFaamq/nqL3f4H1iys2sUsO1k8Yt1KmTrXzRAOvpiJE3W3dQ1A8HmTegW37kvdtZCX2Kg1A7HZ2uNz7Wue6oiPuU8lvua/aBnpwiG3hMu+J/tV7ywCtvCdaKwI84nO6eyip69ZyIFT/++B6CbGiKH7KU4dmtLIYTZMVbT3AspVAISgZitKylgZ6mU3/9sjAENzFML4UIqrJ5cd5RN79n2Ko6tcYaIoWZyAtJOBDVQqVpf/cwtiUDEFri+PEalOO3SMoxNFM9bL9Yial8MRi15fTMwICN+drlydMRYxQ2PZmIy3DPC+eUr5KZLwF0yMwWnB8GYkEHCGX93KSbV14jK+1F8NieORx22cde0Zr/r1nJNvpvN6ZtRGsGS5GsXiWLXDTOi6Bkjqk6tNnJf/kFkZZ53J273RE+eVW64qxJY0JfBgXdC7zznezjJX0CRDjmnEcuoXbzS0BMqr1g0FjS5ipWH7e96A89+cM5oJMVLWEBE7ey/jLLsVaagzupF5YZ3A0Q7Ht/Zjl3NtwpEd9k/Pg0NRikH8NtCuxzrF4LdPvfSwmCj+MhZpSSD7xcWlgYujyLkBEFDfss4KNuHb99PqrfjJ0Gv/JV2WYdFzPkPuCWJ1Wdl+sCXF+OfBevJ0H5xxecgIJCWbCEYir6+O5jMzXM1LG/FSw6idNcqOMriKbF0HgHpJwjIyKdiAELiqVHG9UnRM1KNh5V+uvwxbcPUT+EhJlGQD
 rLanbNij
 6rx8rUnDSa8J+uwdmc9BCtuBYAykQW8rROw+3Z04Txxuw+ywcNRcyu6RSv34HMMze9guYOpjhBVZ89l8W2+9RoxPVgzrhzuraV7+SNZD1faeoSQ4yHmAZpQA1Cic+YWtxOkkxs2d/+91vTQ6XZPSwdH+dAexnvIr0cU6Z7KGmDZnnG01KMeJw9WTBEPnZaL8pxstpaqgE2OKXmjSmuzBYJ+62zRJH75mS379rChv88i9lXrPVaxN1/5DhIECPCui00gzWJHYgirKlnL4O9EosYDgZA00RfPe2cb3nKPHSvBlEdRvh9jCByKvKPRleEkWO4S3TOYlIEa+fTv8OfXyiqLQvLX4x/IGXRuDLL7oMN5uNLt7cvb5/rgH82EtoVsZJCcsxpgKRd+WqTeUne/CsBwPeNfsH8gdFDqGpaNCuYQ+tiT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 15:10, Garg, Shivank wrote:
> On Mon, 2026-10-19 at 14:23 +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I would suggest that perhaps this should be the fallback for non-preemptible
>>> models. But it gets a little weird with PREEMPT_DYNAMIC I think?
>>
>> Why can't we just use PROCESS_PAGES_NON_PREEMPT_BATCH where we have similar
>> handling already?
>>
>>>
> 
> I did not reuse PROCESS_PAGES_NON_PREEMPT_BATCH because it depends on
> whether clear_pages is defined. While COPY_MC_PAGES_NON_PREEMPT_BATCH
> depends on copy_mc_to_kernel and other constraints. So, using a single
> param for both would make it more messy.

If it would stay it would all have to be cleaned up to end up with a single one.

> 
> However as Pedro pointed, most architectures are full preempt/preempt lazy,
> and with this commit 7dadeaa6e851 ("sched: Further restrict the
> preemption modes"), for PREEMPT_DYNAMIC, preempt=none and preempt=voluntary
> are rejected at boot. preempt_model_preemptible() is therefore always
> true for this case.
> 
> So, this can be simplfied to drop the COPY_MC_PAGES_NON_PREEMPT_BATCH.

Can we simplify the zeroing part as well?

-- 
Cheers,

David

