Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE2EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4089A6B0088; Tue, 28 Apr 2026 03:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA036B008A; Tue, 28 Apr 2026 03:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9D76B008C; Tue, 28 Apr 2026 03:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B88E6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:52:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E98B8D549
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:52:26 +0000 (UTC)
X-FDA: 84707197092.03.2A9EC88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C98FB4000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:52:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjLCFQjU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777362744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JF8V1T3pnmO8fko2hJ+5KwwhP6du1oCJgRMzeu4uqo=;
	b=HYrm87q3kbvztAQEWzDsCGjIHYUKU4ILKpEKbfa171BDVOmqIkU2M8dK5piSouX53mbawH
	pcspfI52bx1KUVzke5R4iGD5fUOnNmEnljRDtRBG2FJmg9iJ+REOfaYjkSQy2aoHX6ZZUX
	MO3taug65NPwjROHXqydZpqeHNu2rBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777362744; a=rsa-sha256;
	cv=none;
	b=1o8+/+56FAK0BXdFYSean0rz2zZp1Tg/oz5L4hBudeTKRtuEcsEmOsU9flcWLmZ3A1LsK6
	1j7uuGjvzYtpmtv9ickFcM5t/RbYZ1xvHpwGUGWblXM3a1s+SE8mTMPMvI3Zh9Ix+xDooU
	Je7fZSDDmzLQun/2MuXYrUIAkMNCyYk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjLCFQjU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E04A261421;
	Tue, 28 Apr 2026 07:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08F6C2BCAF;
	Tue, 28 Apr 2026 07:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777362743;
	bh=KiGBp9SBRr0S2SXmmAPqSl+u4SEOgHA1uGT3SstawwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GjLCFQjU5XtMIR8p2eUHF/UWAM3rz6xZtiteqH9mcF/Bbm0PvaCdhkYoFJLGQSAH6
	 NU+UqmQjnxZXYTuWhqjjm8pLO7oFBCYo+7rRTICVh4gAu67PGrqy90X1HVTMfio0E4
	 p35H3mRqvSxp47kRl96y94PYS6TM0FqgsBA89sR0EGpc7PfaGDp1yKJxz+SN67b8w9
	 GhHHdfFSgrTeOLdduvttmvYXLk4gsAiP9oUfNNhG9OwyzcAhwxyN2FGmmOMyfDjv7l
	 WQU1ikAd8gcOb21b696ddPm2emWuXyL07t8Bxx9eFLZCAjBk2rh4RhpUAjz8Xklfjk
	 Yrbw1tNNzGoVA==
Message-ID: <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
Date: Tue, 28 Apr 2026 09:52:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
To: Feng Tang <feng.tang@linux.alibaba.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Liam.Howlett@oracle.com,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
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
In-Reply-To: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C98FB4000A
X-Stat-Signature: 4kxwgma16nu8zizz7uu7znwhwfkf75mj
X-Rspam-User: 
X-HE-Tag: 1777362744-433531
X-HE-Meta: U2FsdGVkX18+C3bFYl04cn5ZqON7hAnCS4LRmPYN0U8ZhRnqOoaGacGey2Us2/ZvJkKcEFN6hJ0C84yajyY9BEtrR4jqCJ9JzrXEmdcdw3//JrzJu3EhJI4HcvXG06KCwf01o8j/Ss59md/8RXCwLC1Z+qP6WRrY4OM3aJhuxTvTXa9qYXPp7j6ieNMpGzHi7HyjxhR5cVM+3NP+d/yh757gLCOVrqG8Ecf8PtzGVkLDeZ+4hNLNoFGASAdEF00I0Gxn9SzNI1BGLbBMJpBFR7K2OxWChZXufe5LTrC5y+cYzMbOa8NEvdjx88LLqM1cEpfcn+iLQRKiQ3a/zNVPpo5OrY3MsYMgLyBz45exfis/c+XYCj6+2slMJejseSO/SMJaBqKAY4wl27vXlOIpF7CYnNyj5Wg3UdemgCyCko8FwsiujyH7Sy6/eRzNOmXAZ77TLGTNRuZrBEf2ScJDwpXoq5qAJmk30a8OeTzGqX7G0YME9AUuxMkfPbVEN0POH8o7oXyLsHuJtfMvxGeCiPPyIAwDmJ4ZEGez1rw7Kav/rWrV8cPSYVfug6jSc5WQOu2LOIm+rqfvfezwwA1lLMedSr+yZOW3L29MPrqo2DqMu7PHhDFhUF7DvcwKkug4Qmnw6fPwzt+RBg4S4T/ESedkHNVeCaGrY/BiEUn4ZF5+3V740hlBufqVpDfsQqLBUMqD90Kv03Cyh1vBIy8BtbQ2hYa6iAmFH54gNHPu+/FfWiz45HavaunUf29bURV+H98ON4pGhH++wuIhH9rkbAirsgN3YoOR4e9WsOQtt/bqrxA9wcR97p4szawhLp2//MqAQUcbUdld3b88ODRzMgrwYbPaNuFPYdqd+xLv0/Ljqysb54zD5BcJUrRkysoYjci9XGEhkex6yliCJuBy70EI9LpCqg6ST+saUxMBhjyO88EluS30CeAiidgtcFx8Xf6Ho3nACSRjUMByyfs
 nXk7Z17w
 jJenjj9hOlQuR0YOjudwoCIFi7/dNZ1aIH++P9FQAeWxy2cO+ES1RWVxzYY9Z7mTkujvrOSJRlf0x+ogVjYpJxomZ0C23yrNDpky4PB3H2f3Sop+1uHjAf4OYNAdBippF/xsg1+/FQzTZPkbxD8muZOuYV2ANS488hPbOIpc14IhDkDxGEkNb/hYrptaFqwHGeKkJ93eSAZRyEIjriR47VZmJk+UkczCVkss6/lP81RALkNZIEDcYPkuEWehDK5D5NuLZlZUmrcU4IATNEaNJxj20mnZ+G4wAVrFFlJTIJ6ixGbQiyJwLY5LY1grMYYCtWMFV1Qz07PXJjVIjBxyJZVlYvxYFoIfKBgWOh3rwjTzwaIaN+RmCFJopruvwvLJFCuIJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 08:05, Feng Tang wrote:
> There was a report on a multi-numa-nodes ARM server that when IOMMU is
> disabled, the dma_alloc_coherent() function always returns memory from
> node 0 even for devices attaching to other nodes, while they can get
> local dma memory when IOMMU is on with the same API.
> 
> The reason is, when IOMMU is disabled, the dma_alloc_coherent() will
> go the direct way and call dma_alloc_contiguous(). The system doesn't
> have any explicit cma setting (like per-numa cma), and only has a
> default 64MB cma reserved area (on node 0), where kernel will try
> first to allocate memory from.
> 
> Robin Murphy suggested to setup pernuma cma or disable cma, which did
> solve the issue. 

That sounds like the obvious approach to me.

> While there is still concern that for customers
> which don't have much kernel knowledge, they could still suffer from
> this silently as some architectures enable cma area by default (not
> an issue for X86 though, which set CONFIG_CMA_SIZE_MBYTES to 0 by
> default) for most Linux distributions.

Okay, so on x86 it is not silent, because they don't even have a default CMA area?

> 
> One thought is to follow the current cma reserving policy for platform
> with 'CONFIG_DMA_NUMA_CMA=y', that if the numa cma (either the 'numa cma'
> or 'cma pernuma' method) is not explicitly configured, set it up
> according to size of default 'dma_contiguous_default_area', while
> skipping the numa node where the 'dma_contiguous_default_area' lies
> in, this way the default behavior of platform with one NUMA node is
> kept unchanged.

So, the kernel is configured to have a certain CONFIG_CMA_SIZE_MBYTES size, but
you go ahead and multiply that by the number of nodes? Sounds wrong.

The whole proposal here looks rather hacky.

Wouldn't a default for e.g., pernuma_size_bytes make more sense, that users can
then overwrite on the cmdline?

> 
> To get the node info of cma area, add some helpr funciton and setup
> in cma code.
> 
> Reported-by: Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
> Suggested-by: Ying Huang <ying.huang@linux.alibaba.com>
> Suggested-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
> ---
> Changelog:
> 
>   since v2:
>     * setup the numa cma are following default cma, while
> 	  skipping the node holds the default cma (Robin Murphy)
> 	* add cma_get_node() help and related code
> 	* add reporter info 
> 
>   since v1:
> 	* don't use the original way of adding alloc_pages_node()
> 	  before trying default cma node (Robin Murphy)
> 	* setup default numa cma area if not configured (Ying Huang)
> 
>    v2: https://lore.kernel.org/lkml/20260423095243.14239-1-feng.tang@linux.alibaba.com/
>    v1: https://lore.kernel.org/lkml/20260414090310.92055-1-feng.tang@linux.alibaba.com/
> 
>  include/linux/cma.h     |  1 +
>  kernel/dma/contiguous.c | 14 ++++++++++++--
>  mm/cma.c                | 11 ++++++++++-
>  3 files changed, 23 insertions(+), 3 deletions(-)

[...]

>  		if (numa_cma_size[nid]) {
>  
>  			cma = &dma_contiguous_numa_area[nid];
> @@ -255,8 +265,6 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>  	phys_addr_t selected_limit = limit;
>  	bool fixed = false;
>  
> -	dma_numa_cma_reserve();
> -
>  	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
>  
>  	if (size_cmdline != -1) {
> @@ -312,6 +320,8 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>  		if (ret)
>  			pr_warn("Couldn't queue default CMA region for heap creation.");
>  	}
> +
> +	dma_numa_cma_reserve();
>  }
>  
>  void __weak
> diff --git a/mm/cma.c b/mm/cma.c
> index c7ca567f4c5c..3bbfafeaf6c1 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -54,6 +54,11 @@ const char *cma_get_name(const struct cma *cma)
>  }
>  EXPORT_SYMBOL_GPL(cma_get_name);
>  
> +extern int cma_get_nid(const struct cma *cma)
> +{
> +	return cma->nid;
> +}

Why do you have to store the nid instead of just looking it up from the base_pfn
in here?

Also, what is the expectation when the ranges would span different NIDs? (is
that possible?)

-- 
Cheers,

David

