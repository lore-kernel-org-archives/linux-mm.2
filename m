Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF00CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 19:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D56A6B0005; Wed, 13 May 2026 15:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F276B0088; Wed, 13 May 2026 15:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41D16B008A; Wed, 13 May 2026 15:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E020F6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:43:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B861A0455
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:43:32 +0000 (UTC)
X-FDA: 84763421064.13.817E75A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF8F64000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:43:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PswWi5U5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778701410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wNnq/aOOL++S47nNNBM4V5byyZaRjmNH9kTCTDWejU=;
	b=vtRNLpSlQ2r53Pwh3jNq8TqWLbY/CgkCln4yenoOLjh6kE3jXvSKUq+BKnjq7IVr2ZEu7p
	YN/Sbn20L2hlBH3NOTDzlNr2uPiQUCa+mnV3JJ2yCWqLsEQkfNdwYOfqPdnFsPsQs6e1Bw
	Yd226FPBJN0wuVJ9/DflC5XU41YmDNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778701410; a=rsa-sha256;
	cv=none;
	b=HHtcapW9Wkoj/IAQDB3TFJB37LakyRR9nwVFDLQ/sbVN+I+BjdENQZY8CgNtMoCygx4mB+
	5lRYqE/3chWxFtXdunVcchNGw3ugSBM6fZHYCyn+QczTQxTFh9VpsCfd/fBzW10OVwSgtH
	pN8yRWMltHSkAuDQHUdKT+9+ztlK/O4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PswWi5U5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98C4744142;
	Wed, 13 May 2026 19:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B38C19425;
	Wed, 13 May 2026 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778701409;
	bh=mjCtTKqd0fVUd6hQ2t6t5iSRgHn1i0rQEkCW2VMbau8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PswWi5U5R2uMro/LaDmbP7VIqiyhF4gylLPGQUCiQuw0rY6WNXUl9KHQApUPsQd6W
	 4fU1gwteWEOaTMqkI93WiVxzlsmY5RLpkTOQXBs6OeNljyWOTHpXMEU4+yZXIS+rIb
	 XTuaFLkH7nuXrHcfhoWVIGxw5BzbyLGpgaAIcBPmGVhYdwBm/LLY61kmnLbpkEKz9G
	 nM1PwFq8U0jihBiIGhcNyZDYC5qFhXFqz3+0b9dvi7xkmrzYaK2DorsMyuKzCS8Vi3
	 IcRb/pFyeq0zW/AxYEUbhRztgWkD72M0Ua/qp8qdEhEzO/vFNX+lBO5Fqbi9da9bIt
	 wjjySZetYrNcA==
Message-ID: <c2881d16-a12c-4598-8f8d-3b6523266fcc@kernel.org>
Date: Wed, 13 May 2026 21:43:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
 <0ba9bc77-ace1-4077-a193-4540880b242b@amd.com>
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
In-Reply-To: <0ba9bc77-ace1-4077-a193-4540880b242b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AF8F64000E
X-Stat-Signature: wfdos4kesyz4phycdimpqje1eirz1a3m
X-Rspam-User: 
X-HE-Tag: 1778701410-480504
X-HE-Meta: U2FsdGVkX1/5EOeVn13gSnFEsGfU2YH7FGoBa++qM8mmMmNnTYEQ90CTG87WJHxYWv4q655TQoOvku+/6RCiqa9w6TN10C1SJVAE8dSxtwz3SlHSYnrlMVO9rL5jWuug7/+sWt9cYyyF4XtmuQcFL/v7NRsxlMC9CIfCzD51x6nUxeAHfu1VreS3IMewdWyHGn6BSiDlnDYX7vcXY9U3s6p9v+mGuxZEt0XkLI7cP2xhBxRikc+9wAQA9ZNYPd8EQJpxCULetVKUZcMJgf+cbpmCNfS5WYTUR7lAVtmcIOkXxGprk7n8Ku5jJL71Tx9qR6tY/pNx8q0Wp+iSjnV0uZsLQnvIpq4/iWBZ9Nvwp6WjdOkXl69A1xEtLGPlIFUGRsHnI0rMK/Wa74ayiQvkEaPOqJR6GOWrVm+E2s+YJRcSZjSDFn/pJcX0Km8fsM9blG51XkSY2DUt49TpTaGnDDQZDmDS/54Rg3uf+OLDphyX+3b6VJkRNwYWdCtM2UzQXLVio7cRx696W0zOm+syiu+OYyPIie0iftttp9jBCgTevUASv+kyogLmZWZ0XemoOnV523EME6sunGqm/RNPS+eOvXKzti5Shiy/BtcgLHJtiIlJC9DoTuwLqPvqbfknUAUk3n4e98Ycz9LjKQ3tDxfjQuwNzTwzUDRxZjQAToKhocEFDMtUKrO+IirGULy2rvFcXgWZeaks8qdNIqcIgWH1iYpnbeEh3QKpvwd4DXG3EJbJl3eDudtXPgezS6Hwb3u1bjtcxyjYlzzLPp1Ow5cVoBJde8WMmi4sxbKFE3Ix/3WT6nygjxZ0gCq2HqIKXDFOORupTmP1cmRBvHj8ZOJcZhjx2KL7PZe/wP4tRtK4wQ4io+45VH88JjdeSO+lDX/2hFifS6VF2JZHxRETHNPQUQgSlNzDp5B9bsTni6DcHp28XR09oEPSQMnEyoEG4nkwfy4NVzXHuA7ZdAg
 kG4jySd7
 5kyNQSk6OMUyGIOGZvqH4f+AJn1cP9slLrhTdXKgBzuEDwVBwRrYhNkzd5YbCtO3RCeS0nbXUcOiZL4cTJFQGFVXSVMViyxaCxkaE/BHb256TORmSlTok8Kik7iNtuOXsLUJhrAGDdD5oB3tCiN93pV8NEUoxOlLvRpSVAnCJmwmi/WeqGXFO8mOwZvY4cBtLaRmTSydVwNfQBdh38q366Wn52wCJBDC3ydhsbV9SrLx3o40Vauj2y78YM7ci8nLnZXWXDYa52VJp7u/87ajBaxO0WgZkv/pExZ2mE9aEjYsUBwuc5sh31ETuFauDxggW8vDz9OsvpbeRF80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 13:54, Christian König wrote:
> On 5/13/26 10:37, David Hildenbrand (Arm) wrote:
>> On 5/13/26 09:47, Christian König wrote:
>>> Hi David & Thomas,
>>>
>>> ...
>>>
>>> Exactly that is one of the major reasons why we aren't using a shmem as backing store for TTM buffers in the first place.
>>
>> What was the problem with that the last time this was considered?
>>
>> shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).
>>
>> For internal mounts, it must be enabled accordingly
>> (/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).
>>
>> Some distributions still default to "never". I guess if an admin enables it, you
>> would just get THPs.
> 
> Yeah, exactly that is not acceptable. We have some customers who already use that approach through udmabuf, so we already have some experience with it.
> 
> And I can't count how often I had to explain that it's a configuration issue and that the admin has to enable THP to get decent performance.

A lot of concern with shmem and THP is around memory waste.

But the DRM use case of shmem is really different than ordinary shmem usage, in
particular when it can steer the folio size used (and better control memory
waste I assume?).

> 
>> If "distro default" is the only problem, I guess we could think about how to
>> improve that. For example, just let internal GPU DRM objects allocate any folio
>> size available and supported etc.
> 
> Mhm, that sounds not so bad.
> 
> I think what drivers really need is that they can give the order to shmem_read_folio_gfp() and get a folio with that order or -ENOMEM as return.

Is it really helpful to fail and not make progress on a fragmented system?

I'd assume you'd want the largest folio up to a specific order. Not larger,
because it would waste memory. But maybe smaller to make progress.

> 
> In other words we need to enforce it and if the desired page size doesn't work we can then still decide if we want a fallback or not based on the use case the driver tries to implement.

In which use case would you not want to fallback? Would it be something to
tackle separately later?

> 
>> Would that make it possible to just use shmem natively? (e.g., how would this
>> interact with shmem features like folio migration, would that be workable with
>> DRM objects?).
> 
> Mostly, I mean there is still the use case for UC and USWC memory but at least for AMD GPUs that is mostly negligible (we need it for a handfull of workarounds for HW bugs etc...).

Thanks!

-- 
Cheers,

David

