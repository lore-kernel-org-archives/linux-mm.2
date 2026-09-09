Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 226FAC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CC66B0098; Wed,  9 Sep 2026 10:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EDCC6B0099; Wed,  9 Sep 2026 10:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203C26B009B; Wed,  9 Sep 2026 10:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F23D16B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48B11A4182
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:05 +0000 (UTC)
X-FDA: 85194385290.15.6F48B77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 54B87180019
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gUeB99/0";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxSG+xnLXoNNs2ROuIVkq4UavUfbd24H5I1YkUmDyag=;
	b=una1PWH1PrC8iTAhtOaiYoEsQpoRVMGAS5YLCPzDYkMaTIfHnm98R03iHnWNNRUYErH3eW
	YmtL2MSHoxsnjN7GO1grGDCpsbPeWIm5k46wDqM2pVm2ng28hsKsCNhk0tFDQzRvDSHiQ9
	Lox8rec0Psw75XHna+QFBXXlOuFhI38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962463;
	b=NlrBr2t4/P5yzbhnfIgxz52nj61Cnb/1u5yMekiKGbRdnDegBePB5OHImYiuc+GaiOfmJC
	BKmdDO9kemZNN4oedLlEvBvBT6wqqN+LFNgW4OuEfGE0sRvHg3tdqhL23HPrDTuao0rVdP
	rXqrSsbFKPSp1ZEWPqg5822DB2/jCE4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gUeB99/0";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 726D54136C;
	Wed,  9 Sep 2026 14:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E005F1F00A3A;
	Wed,  9 Sep 2026 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962462;
	bh=kxSG+xnLXoNNs2ROuIVkq4UavUfbd24H5I1YkUmDyag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gUeB99/0UlLzaRF7SPfQ8niZ46JmUJdooO+eWrzk4rurvmM7nTlxx1/b9B5SvRez1
	 zuHchEgCxQmzbwSd7VMaiijCYsQ05CBVgugrgLZ3sWSg/rfyDpsLbZeoocnDj2Sq9E
	 7VG2A86oz21V2HLABAKToMY2tj8l5fQEOmlON1Q4mC4VECBSrLr0A41pSBtaAu9ziL
	 5fbWZD/qcj6z7f+Ryyua2qwOE/bV8VFuMu/tnUB/J+08QEDtFKVFuxSbAnz2h6/1Qz
	 XVV6i0wSp+zw8pVdmjMpjQNFIAiWN303sExXHHxVsSnS3q6UWLU6ytiWzgYi0aXF5d
	 +58gmOP9EgaRA==
Message-ID: <60ac97b9-8da3-491d-8d1c-dcd83c7232fb@kernel.org>
Date: Wed, 9 Sep 2026 16:00:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] mm/zswap: use folio_swap_entry() in
 zswap_store_page()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-4-ee6d01dfa5e1@columbia.edu>
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
In-Reply-To: <20260908-folio_swap_entry-v2-4-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54B87180019
X-Stat-Signature: g3zbp3imctnx7uyubu89ctsu8fghz5so
X-Rspam-User: 
X-HE-Tag: 1788962463-995823
X-HE-Meta: U2FsdGVkX1/qHSqRkVRiGIVceZ5L4IxAPikIvIeVLM7Af43ZcrM/aRv/YbkcQRa4zx/WEyXNd88lA4ihW9KJgd5XIp5wuHLN41QzwTVUMMlla4rGnYOXkH3SPa9tlUoM9NNRSWzjNZw29dm9N0yoaGkm1d64o3M7ULMEOmVTJRlLgBYZTSZhvxvLosRwcNoj/+Iq8HuJDsZ21kaWWKRG9kL9KosZLG6CAcHWCUX/B7yEdtPjmp030BY2y4RMsruOXfiS7MyUci/fm2LqlIFVtrMSiD3F2NEEr9LCuMfIe4JgARZxxStNn3ifUDHjqN6iVtqfP9GYX/FocqicyG1mYOn6pWGN9/YOrkjemACr4BxudYcuPFPn3cnjP8J7xougf5wVreRAQ2NzdPm9Unkod3fm4ssbxzgXuQZQ3nQWU1BSKuhLqXxM7NmrkIQvcwZw9kKy+t+WNFeju/BDl5b7U6H13mcZx8Xv0X4SeKzX9+8aDgdgQlnl0kTidfCIthrLumOpZJwjpsvz6kCH/NWOg/smkXoaDPVEjN8a668Jz3yJD0fQVg0K3s97v0cCRMeqN4h5hHOHFiPzDh14UWI5cL0XwPCCT5C8TebGUYqle9DwHFEefV2ioycP7fKHCtGwi49vBN31KJdUOHeMOM9qbCHKS6rMRKHbOwjXt/gVezuXBEzBMYix1fXcHEOF59nb3FOTERHzQLkd+xylidZFTQLs8XnNdA/eU5R0vN9uepYDMc4Hmat5z1gExG9RtMJuSXqV4l2jwBXu3Y14RhRXXnmSSOQciiz4sL6dW5q8jQlWlPuzLGPXZqNL/6TVvurgrmuNN661uPqpnwdg3Khw2cUvF+loEzIBRa8IO3O+NZY4AwSMvqRqYfMZbIibQdLTYZgGocU6KvjDhs6Q+WLL3h+FjQf510Q4KuFHaVh3TfDBuSk06edddFST5phn2gvU7dJZ03QeSQUfeOiOAOh
 fK5nrHGB
 P4vNByOnlW751ozxh06aukxK667FZb2YT/MXjmuu96kX9u0mk5KxRDQpPD0WDgWqDZVL4HakRSPy/gTfBcZQCcniHJsySUDHxzfN7aQpof9FVNZIUJnDh4C+T7hbf6y1DbTPn9RYbOgvJ5xGK0pPDf8+er2iyxRfe+OLHnle0znfwRNZ3BbnxV1Qq9xgLxTSFtqTUI/aMVY3LrFFKKMJBAFq3C+mzLhhF2E1qcVy7BDBUG36DW2f9LrLVKUz+hkdjDyjZDzFBOyyhGBPXqIxRbKVheKyIZBOWls56dxvRracxKNwu5BuJAn7sycysFLdjnDS7dUp7l1YY0Z8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> zswap_store_page() open-codes the swap entry computation from
> folio->swap and the page index. Use folio_swap_entry() instead.
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/zswap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0d8bd72193..c27e22d067e3 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1398,8 +1398,7 @@ static bool zswap_store_page(struct folio *folio, long index,
>  			     struct obj_cgroup *objcg,
>  			     struct zswap_pool *pool)
>  {
> -	swp_entry_t page_swpentry = swp_entry(swp_type(folio->swap),
> -					      swp_offset(folio->swap) + index);
> +	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
>  	struct zswap_entry *entry, *old;
>  
>  	/* allocate entry */
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

