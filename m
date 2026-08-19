Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBDEC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18626B0092; Wed, 19 Aug 2026 11:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9886B0093; Wed, 19 Aug 2026 11:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7AC6B009D; Wed, 19 Aug 2026 11:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65F106B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:53:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C562EC0439
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:53:54 +0000 (UTC)
X-FDA: 85118464788.16.D1BD527
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id F19D120008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:53:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGEaAZsL;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787154833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLHvEXhl7bh0vVvB52S7db8GJd87oXRQT+N5wVcQ1Ws=;
	b=D6Jifsq3GyhZvQ50xutvev/910VJx1nufURfWfEp1G68SSKSGmT00XTBK8DNuRI/iDypyz
	FzAR5+QHK7k587+9u5a7KTzuRgKp8IyJfwhLFFo6H0y4l2P+V+fsnMJcD9mKyKRharQd+f
	qQ11UFdq2RBy+Zkhp8qOExttM2/t588=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oGEaAZsL;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787154833;
	b=rhN54ZcwlzeeGXlR/J5lqGmvKGkhoqTWmw54I+4jYJG0rct3esD7rlYH4MiZ8zqXG+fWdM
	WNM/nfv2GqSv9yK6E6ZFOYnaRbSf4A+OPoNia2Wd+fWZdiMjVHDa2Nff6j0deHGhQHbhyK
	xX66JgDn3cyhshaaoP6ji56YKhH8fyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13D20416BB;
	Wed, 19 Aug 2026 15:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5631F000E9;
	Wed, 19 Aug 2026 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787154832;
	bh=QLHvEXhl7bh0vVvB52S7db8GJd87oXRQT+N5wVcQ1Ws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oGEaAZsLUiOpJaCVmkYmiTswK1xknZbj0vjIV5zZsc7E6d0UpT2EhwqajNnX9CTDx
	 clsyRk+c5aszdB0sdGkj2MwkAj47YUPGM2xS98Vc2RAPPam+Z0GAwg/DrstZ0Kz7yX
	 yrh41chB/jZcKZpz84nhP+H7xMDPQRAhLbToA8Ga2Gr4PRpEyfHK5W44tYLki3Ey1x
	 AnUEUKUknX2PrTQY+fLdA1c2mnIoqTj7XuT+pRCIUNfEm2wNLJmHyO7zkxg5mF6EsG
	 Ylkuolzme/9nR60/L4lDSzBc5S0FhBY514UPxGCxCBWMShNXgd1MTeuK6r4dWyI3MH
	 nKuXqk3wSrTDA==
Message-ID: <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
Date: Wed, 19 Aug 2026 17:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
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
In-Reply-To: <20260818085702.3395529-3-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F19D120008
X-Stat-Signature: mdgfjikiikwd44yfe4czkecnhgo5h7he
X-Rspam-User: 
X-HE-Tag: 1787154832-532542
X-HE-Meta: U2FsdGVkX19VzZ/qCHZVMEuJmFmxz0I9SDjRjoa8AxH27DvWw2VvC++dTMD9M7B74bYLVZvdX2cJbnPJN/QyxhVwzSv4YAyGEdh97FomFYLe/Tw9UP3LLZIl9KyDip1UhNsXcf2rEUyaqCJhqb3lJdOvqv32G5uoi8+POXwoKv59W97Hb7X3XcF/pr7lQmL5y1k7MUjyk140uLC0BI90cDic3ko+hSurgFhLb9LMk+HFF4ZupgqeeDkGrS2xkhW9u3Rta6s1MXs5XWQBsJ/+MRzO42HBHjZSomGv0XCL+NDTxPk5ltbKxN0y8xD29wCbMe1MgLCBeS+kwiC7+XS6xck9C57ULCPc3t5yD/bM1MEb1GnMfdhme2mtn3l5hixzVwo/PF+GtaXTgksHs1+ycxPSx036qQiNl6LMZyx2rVrgjz70WHQE+UuJTYOkARkw7zwRXCQKR9HaPpXHyHXjtREvuuL7AS51HYLXbZK9K1MibYvERdJvMRcvavaj4JHl0XAaRhPJ6NThUtZVaZs5PrEBCgI/UapQDxbeJVujxwnuHqwcPepwWaKjtPYFJ/CCtHTW/hiDHCZDN9d9buKrWH1iw95EtmdWGXyE6ujCpewo8cqxqpH5HJ5AdAfGUDoIZHX4TW+DzGytPQTwfxRSZDFxEpHzrIbmPVJtWqdulVF0mNwzQ/efCgDqdsD1arFe/xxjkS/ZVC47x/2TWYAEYsfAKdjvKsaeGfHJaXNma4YQSsjl2v3jXxzj6eRSKpnOnWlN9X6hpitSeTsAt6tMCITsEJNfQB7Rh6dGxOEJ5YHSLV0EVGmAJIu9ciuaoERKpGi4EQJ23p5UJ1qGtobgysAlVo7sHRr5N6G/BNUOGj/P6RPfto38rAUHF3Nvkz8ZABaP5qshn+77rFUpZGXRZRAxJkIlucDipdhBuWFa45WDQLyp6DcG2rFmOMpjw7GChn+xiu3MnhMw8pRhWy2
 gyZkvViK
 JM0sZK2advy//absj332XV3yV/uAzYJJov1TShGQrrAYYoqC+1Ow950j9Dcm079xQWOO+6ZhTQV3K40YrFR805DCdoGuX/jBS3wCPqb+xlxiGObMwniyZhuiLDfT76s8DP+HAVLgN88qeZB3Ecdo0U66hHk9vQC2tm1LsRjnmOS758YEEpST51P9YqFArxCBSJznT5RoQSqbL4Efao1QGqZblSzBNWxCwJEl7KPeOBX5rib9+ydtnAeMG9E2YcnNBpsYCgvEsfBEcwnSO3A1/WTauh+drcHV/DzlW8gZUlwFTtoPZeNq1YlpTFucL/bv1H9yuODhMrEOKiIDCsWHhLYroxr9lJ1EniHvWA43OF14OwGYFXtnt4KO2qLApTe17LWsL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  /*
>   * Only struct pages that correspond to ranges defined by memblock.memory
>   * are zeroed and initialized by going through __init_single_page() during
> @@ -822,22 +844,27 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
>   *   zone/node above the hole except for the trailing pages in the last
>   *   section that will be appended to the zone/node below.
>   */
> -static void __init init_unavailable_range(unsigned long spfn,
> -					  unsigned long epfn,
> -					  int zone, int node)
> +static unsigned long __init init_unavailable_range(unsigned long spfn,
> +						   unsigned long epfn,
> +						   int zone, int node)
>  {
>  	unsigned long pfn;
> -	u64 pgcnt = 0;
> +	u64 pgcnt = 0, online_pgcnt = 0;
> +	unsigned long last_subsection = -1;
> +	bool is_online = false;
>  
>  	for_each_valid_pfn(pfn, spfn, epfn) {
>  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
>  		__SetPageReserved(pfn_to_page(pfn));
> +		if (unavailable_pfn_is_online(pfn, &last_subsection, &is_online))
> +			online_pgcnt++;

Can we avoid these helpers?

		const unsigned long subsection = pfn & PAGE_SUBSECTION_MASK;

		/* We can have section-sized online holes with VMEMMAP. */
		if (IS_ENMABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
		    subsection != last_subsection) {
			is_online = pfn_to_online_page(pfn);
			last_subsection = subsection;
		}
		if (is_online)
			online_pgcnt++;

An alternative is an inner loop that just walks in SUBSECTION chunks until epfn.
That would probably be even cleaner and faster.

I remember !vmemmap always only has early sections when they are actually
online. We could extent the comment to clarify that.


(I have patches to clean that init code up)


-- 
Cheers,

David

