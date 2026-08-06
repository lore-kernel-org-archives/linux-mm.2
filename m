Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8175C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76F16B00BE; Thu,  6 Aug 2026 04:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E273E6B00C0; Thu,  6 Aug 2026 04:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D026B00C1; Thu,  6 Aug 2026 04:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AECA36B00BE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:41:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCB42A0448
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:13 +0000 (UTC)
X-FDA: 85070200026.26.5AD2DBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 31C7716000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omSocrIJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wURvHk/gRMQGUJv+zpXWYKJYaTNaJMIS70fBlrF/NE=;
	b=BYXEExaBW1aZ3A/6O6FB5F8H6BWN0LSYj82dSs5to9i9s81S7u2z0xtvsVOVXRP91yMute
	3vswfW16+m2RfrAcf1AxZWl5FL6bboFzo0sy9+INPaT8ebp5A6dqmrcM2j5Kh5nE4q/1M5
	Se/2egkJRyXN7oG5siLJ7sDZRxQHyYM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omSocrIJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005672;
	b=GKZacRoQCdnKfki37UlcdURLJEmshR7SKraqdIzvVL/zovcQMWZZqeJ4n8YEcRpzfGVUU9
	ydNgShdCsh5CfbOGgY35MSqLx1mSVp2xPjU+GgjA61htMhpZKvHtrnbYFwYzZkzeh8G90X
	zEUungn1WXUC4mUn6rsP8Y9f4wo1Haw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EF1060AAB;
	Thu,  6 Aug 2026 08:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2121F000E9;
	Thu,  6 Aug 2026 08:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786005671;
	bh=6wURvHk/gRMQGUJv+zpXWYKJYaTNaJMIS70fBlrF/NE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=omSocrIJOd3epz0Zk7VYPLQoIydgsSrM3HbIdITgEg2cP9aAb1iLkGFHr8jZYQSnP
	 i5vi/LSCvP3i8G3+ek5Sg+V09jcgZapbOZDTRfYU8/yKJeBDOnsk6j7ZDnPFP/zvSC
	 RmYrsaKV1q4gXOnZKIC16HAL7q/29+xnshekt9zISxhPHNnDA1cRNEHm2DiKQ1u8Fe
	 88QbqZv0r3FMliJc6al0BXavXHnMm4yp2FJFJwpY3H+28I9bA/aiQusDJ52zSlsLT9
	 1JN1cj5KC0jwSsMGb99xnoaa9CSNaLV4SKsylpbv+Uom/kls6pLEPTT8cCHXyLXBHg
	 DSK5M/J3bPnrA==
Message-ID: <699fc1b0-7af8-42ac-9882-c01225379586@kernel.org>
Date: Thu, 6 Aug 2026 10:41:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: avoid skipping pages after splitting large
 folios
To: Yunhui Cui <cuiyunhui@bytedance.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 00moses.alexander00@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
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
In-Reply-To: <20260806055501.56761-1-cuiyunhui@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31C7716000D
X-Stat-Signature: m64cq85hm1cxjuaffg8iza1g99pmxya1
X-Rspam-User: 
X-HE-Tag: 1786005672-968964
X-HE-Meta: U2FsdGVkX19bZvBEgbMTOFC1OOpx+OiZI4BIYecD8/u3oiCS4a0tOI9oQRkf0/3iCL2W1q7CoLRM2M8i3HaEZc3sP+Cs09kmNe5PqpK/17LHRmIH8Xk5R1rvoCYmvWoXGtRX/bYTwlTM73/raIGHK3c7WjaTFzvRfEhUrtY9PVf3ezKL8TcqEtUaAMwwStXWHKgj+WvGdt5+uDYUS/yl1lhTsJyfhwiqaAL38yYMDifAMJdFxoonfIu7xLXg/Sf7bZ1Oz7LAydbfamUqLfPziM71WVCkCLcUweTan4N75pbpGMz9O30QU414B3+z6Q40jjBrFe4GY+QIQJegpoaPrHwcOMx3maQSNIcjCzzo721eQiW1P8NctZLalz7fjQZSwRQ7JTZ79mR3dtbWCLrKQDQvbQb3yhQSgSZ0G62MWoku58l4agHa5qFa8CQgevO1fjvVDZ8sysmzZNg6rY2b7tFhArh5yY2aH5aoaMcYmoSBeMEBYeDQg6dMhZeIW9wALqVzKoQgkmSZq/9MA1ZA9JvRBbH52b1K1GPJTAUhNgF9yZBu0oVemt11nSZ1LsJliHqz7Rbyb2525gSzhdaUx5+m8ikLZ8PGSEEgfG4F2+hD5N5JjUXsCvpuDvf2B3983/ME3RglOlnBPTU7Z1oQELNvLn8DoeCgZq86L8kNb5iv31MNqA8t1WMM5CbGuA5qNLw3XZdnS8NSLf5eik7C7ZVZi94iuMHvBEZwxy7fPh42zNFWf1vgxb+zJOZevFJS9Mg4YiqCRUmZOIU3nSwmZ4ds8OG0euhmDHTzQ1GzweuUm418kNbcnPMJdrGa+5aaIW6cUzyGg2wkcUmqkLgKys4SBBd5KRZYSaGKpzmnuxiHizqVuf4flwWC3LwJgc8fo8Itl5QrNjoCDU3997xGFzq0Go0O3gLISN/hauOUIGMbvHFMzBpfV3AG4dOJDd51im3/dD+ROGDFJl3Gxw/
 YBIEkSjV
 dPYzZddgeagZeKRX59UCKzGv5NshE8qu//ly/YaHn1V3zPjoX+VlWTEL4bm0+tiKPcKSXN87m5H7ne4EzYcI0BW+juxxQfif3R17yU5s1RDYB88ULwAtL0vKZQUnp0xINqDx+XQyWf/lfMxbII1c5tBP7xAbzhJ1Ugioy3CAOoDXMzE6BC/orYCS+qkoH9a6l+Dztw8N4xg9vrLyrYhupEM3v9Pc6uxPdhuzY5UhwvtAAKXVo9ivQuXEHg1rSxeNFZYwUwGlkFUx8smnts+JhJQseEt6hfUE9ka+ursVcMIj3HJ5eLcTMmo7/SRDYkKmRfKD3Qgt/ujhnZCHk1HsepGapihXnh7wMtdY3/0fPCf6LMXhBXBfRYB1nYa9+IBE4HusS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 07:55, Yunhui Cui wrote:
> madvise_inject_error() advances through the requested range using the
> size of the page returned by get_user_pages_fast(). Saving the size
> before error injection is required for hugetlb pages because successful
> soft offlining can dissolve the source huge page.
> 
> That stride is incorrect for non-hugetlb large folios in system memory.
> The memory failure handlers split such a folio and handle only the base
> page for the supplied PFN. Advancing by the pre-split folio size then
> skips the remaining pages in the requested range while madvise() still
> reports success.
> 
> Advance by PAGE_SIZE for non-hugetlb folios in system memory. Retain
> folio_size() for hugetlb and ZONE_DEVICE folios, as compound Device DAX
> folios are handled as a whole.
> 
> Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page order before page migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> ---
>  mm/madvise.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 5a09cc24f04a0..e9d4c3bbc5290 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1455,20 +1455,25 @@ static int madvise_inject_error(struct madvise_behavior *madv_behavior)
>  
>  	for (; start < end; start += size) {
>  		unsigned long pfn;
> +		struct folio *folio;
>  		struct page *page;
>  		int ret;
>  
>  		ret = get_user_pages_fast(start, 1, 0, &page);
>  		if (ret != 1)
>  			return ret;
> +		folio = page_folio(page);
>  		pfn = page_to_pfn(page);
>  
>  		/*
> -		 * When soft offlining hugepages, after migrating the page
> -		 * we dissolve it, therefore in the second loop "page" will
> -		 * no longer be a compound page.
> +		 * Non-hugetlb large folios in system memory are split and only
> +		 * the addressed base page is handled. Hugetlb folios may be
> +		 * dissolved and ZONE_DEVICE folios may be handled as a whole,
> +		 * so save their size before error injection.
>  		 */
> -		size = page_size(compound_head(page));
> +		size = PAGE_SIZE;
> +		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
> +			size = folio_size(folio);


We should never ever try deferring "how much has been mapped" from a single PTE.

While this currently works for hugetlb, it's just an anti-pattern to throw
hugetlb checks and similar around.

So this is not the way to fix it.

-- 
Cheers,

David

