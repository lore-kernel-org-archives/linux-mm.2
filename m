Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871DBCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA27A6B03F1; Mon,  1 Jun 2026 10:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A5F6B03F3; Mon,  1 Jun 2026 10:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D692A6B03F4; Mon,  1 Jun 2026 10:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4B096B03F1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:57:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9716B1A06EC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:57:11 +0000 (UTC)
X-FDA: 84831646662.20.0517265
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D8A4440010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:57:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DmPtwlnl;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780325830;
	b=1pHyvuANZZBupKqA3En7W9H6reNwJbeNqYiWZuF2suTyb3KjmvfXwnZVmkMOZ6aagkZgYn
	cV9EGAxUhOCzIMl24vBqzbi6Lgkn/fXxR7c8hOxHMfmGMKIMR+gdVrMbCf1z+ATm/1Ztdd
	41zSv84FRx9W3F7+B0tqIeA2cMlwkwY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DmPtwlnl;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1t/ManZAWEebrPYdzsq82/sjnNgqYWKOrNsvRuTGDqE=;
	b=HXBLJCUFeWTiuUWywf/6KRilFR24i5v2Vd4+uVr9/I9ovTs5MsYnWOMWFsS13r+0UjKgZ2
	8hAqUP+zC9aarEuYsCiXYTZSl0G5AsRoKr01VDaUgSXGB52pia92UQip9cVCpn+8BSbQ/7
	0ZfRxsEObIOXXerErUnMUjF3FGq/qIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A61C601DE;
	Mon,  1 Jun 2026 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071241F00893;
	Mon,  1 Jun 2026 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780325829;
	bh=1t/ManZAWEebrPYdzsq82/sjnNgqYWKOrNsvRuTGDqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DmPtwlnl+B3egT/xi6nL2xSaSOXbt6fvZlsliUpTNk+MHGyiwK0bY4NeOXFHisLcV
	 HcOB4UCfbIrNLM2Qho0q2roDLnYc6gPyGWdbo2Uqv24DerHP0kH89RF5FT8BQeLho3
	 g4CCHgVf7WRhQ8IeCc8A7XpPQiwiLAB0OKG29WDmnubHWRWyOEMf4lB3A+E0z8+TfV
	 vVIWPXhgCNeSERwfZZg20SBFQOlEh1gGHbUuQV3k54/3ebkAmBZQiI/OvGEeEiRt75
	 adjMIB/EluqHUYOsTScQDAFS2lhh9pBlaUa+UJmmu22BvEdgo4J0Jb5LImB2cpbE0m
	 EuVA9K8r2mNuA==
Message-ID: <23e80c27-320a-4ea7-8c8c-025e06f2161a@kernel.org>
Date: Mon, 1 Jun 2026 16:57:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: move reclaim-internal declarations out of
 swap.h
To: Jianyue Wu <wujianyue000@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
 <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-3-1b9a4ac255b4@gmail.com>
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
In-Reply-To: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-3-1b9a4ac255b4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8A4440010
X-Stat-Signature: rc7d7pah7up4sbmoc9msyg7smwxobsdz
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780325829-849533
X-HE-Meta: U2FsdGVkX1/RghWJQ+BHIicDD+H5dZ7IjQ4fiFSXdJ7BmV/3X7XooVTEkbNxgfK1STH9X/ULCsj015bF4shqWALLeTuG5RkgK6tJNflIz99nqG2GMOX15Tghsvsgyar/0Br2Hb+GxfdA4uqzuwSoFtqX/Nj8mEijdMDOTUAsVpSmGtoLg8UPhszYgOMMfiGzALVB8kgMtuowKio05FCCGgBS1s+FHFcpG/s2ogwUEm49xH21tbLEkbKjriHgRNqKa2UgUsEX/2pvABA7rq3iLre2eILZwlUgDWypkYtmOE2TUe5gOQTE8jhZmdbVvMrzJFvrLYETUu3JTbHCeWvb+WHbMJNsJAndELRmj4lJhGb2kjcHaDv5sL8BsCOhNQONJAY6uDpA0+PwmD5HK79cI9UpWRkXX7pG0Dw5dqtq53dT9RnrrGm17wV1fcW+0mWSFeoOwj5ZWexp63ECr9F5Wcrd7kgBXaJTPvjgVoNs1gOmnN59HeYXvylysWCKI4llXgj2BRksqVjGcSIyhP+7647GzJTE9z0XDxe7f9izVOaGpwNkzTqVMfnbTeYai25Zb5fgXerelLm6WtKR2YvYhXiWmKKMKnyWvEeKXjC3XUF+s+DfKrmwVA6BlOo4XfcFQxFll9SVxbrEJk3/t+nGPQEPtVH6+fl25Wiaf2NrrQIqZTvUQVGo66mKX06O87nOez0jv6XoFiDIBg90GuRN48v/FEhSZovDMTU8K5aenHGwt8wECy+VgMCIJ4erAL5vo7ZJYPjbIgVorwod4ehEPhvOrPDxGddpZ3l2ckYy542kgfEaULz3QQ9jqKZnehEuq886CfwcI1qhcY/QLtzLDxM6Kj9OJN84DgWedoaTlLevjgWtONPS+L96wGXQ7r3wyKIFTuO67oog64oAMhrtsW3Y8yqAJ15EdBxuUVjKU5ZYYZJCB8GDsk2QIVYufLlLP53zBwYHlCT8+hnuMTT
 89ASL4r/
 KbZH925D1MnpBu4uYYbaqtqbD4E4zWA48bqFHGXGTDf6wJUu1JRuCIBYkaUjeJ2sCPGIQLAW0Tqx6YZZl2a6fiN+dQJVohCQWHn/Dm9oKnmdJQSHhqCwtD4+ALYybhH4sBPFsE2sfPK5Sli4/LEBYGjSfuERuY9irfXdeSnNats5VFWkUj7gr+NVG/OT7yNM+T+/mcxMnNP4qZ5EL7nB8jlPEW1F01rnq5J6/XwTA85o0yvJ0N1u8kQ7faoKmkYGZaS4MeYkVjposjvBNY5MGF+8cXOo2MY9rLPhwvRYlE0vjOsnnWm1acz0VEz/HoE1LpnSx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 11:50, Jianyue Wu wrote:
> Keep include/linux/swap.h focused on swap-facing interfaces by moving
> MM-internal reclaim and workingset declarations into mm/internal.h.
> 
> Leave the small set of LRU helper declarations that are used outside mm/
> in swap.h so this cleanup does not need a new public header under
> include/linux/.
> 
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  include/linux/swap.h | 75 +++++-----------------------------------------------
>  mm/internal.h        | 66 +++++++++++++++++++++++++++++++++++++++++++++
>  mm/memfd.c           |  1 +
>  3 files changed, 73 insertions(+), 69 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index c36f72877e8b..1ef6ae7b2db7 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -292,39 +292,17 @@ static inline swp_entry_t page_swap_entry(struct page *page)
>  	return entry;
>  }
>  
> -/* linux/mm/workingset.c */
> -bool workingset_test_recent(void *shadow, bool file, bool *workingset,
> -				bool flush);
> -void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
> -void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
> -void workingset_refault(struct folio *folio, void *shadow);
> -void workingset_activation(struct folio *folio);
> -
>  /* linux/mm/page_alloc.c */
>  extern unsigned long totalreserve_pages;
>  
>  /* Definition of global_zone_page_state not available yet */
>  #define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
>  
> -
> -/* linux/mm/swap.c */
> -void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
> -		unsigned int nr_io, unsigned int nr_rotated);
> -void lru_note_cost_refault(struct folio *);
> -void folio_add_lru(struct folio *);
> -void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
> -void mark_page_accessed(struct page *);
> -void folio_mark_accessed(struct folio *);
> -
> -static inline bool folio_may_be_lru_cached(struct folio *folio)
> -{
> -	/*
> -	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
> -	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
> -	 * will be sensible, but nobody has implemented and tested that yet.
> -	 */
> -	return !folio_test_large(folio);
> -}
> +/* Generic folio LRU helpers used outside mm/. */
> +void folio_add_lru(struct folio *folio);
> +void mark_page_accessed(struct page *page);
> +void folio_mark_accessed(struct folio *folio);
> +void lru_add_drain_all(void);
>  
>  extern atomic_t lru_disable_count;
>  
> @@ -333,43 +311,7 @@ static inline bool lru_cache_disabled(void)
>  	return atomic_read(&lru_disable_count);
>  }
>  
> -static inline void lru_cache_enable(void)
> -{
> -	atomic_dec(&lru_disable_count);
> -}
> -
> -extern void lru_cache_disable(void);
> -extern void lru_add_drain(void);
> -extern void lru_add_drain_cpu(int cpu);
> -extern void lru_add_drain_cpu_zone(struct zone *zone);
> -extern void lru_add_drain_all(void);
> -void folio_deactivate(struct folio *folio);
> -void folio_mark_lazyfree(struct folio *folio);
> -extern void swap_readahead_setup(void);
> -
>  /* linux/mm/vmscan.c */
> -extern unsigned long zone_reclaimable_pages(struct zone *zone);
> -extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -					gfp_t gfp_mask, nodemask_t *mask);
> -unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
> -
> -#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
> -#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
> -#define MIN_SWAPPINESS 0
> -#define MAX_SWAPPINESS 200
> -
> -/* Just reclaim from anon folios in proactive memory reclaim */
> -#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
> -
> -extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> -						  unsigned long nr_pages,
> -						  gfp_t gfp_mask,
> -						  unsigned int reclaim_options,
> -						  int *swappiness);
> -extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
> -						gfp_t gfp_mask, bool noswap,
> -						pg_data_t *pgdat,
> -						unsigned long *nr_scanned);
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
>  long remove_mapping(struct address_space *mapping, struct folio *folio);
> @@ -390,11 +332,6 @@ static inline void reclaim_unregister_node(struct node *node)
>  }
>  #endif /* CONFIG_SYSFS && CONFIG_NUMA */
>  
> -#ifdef CONFIG_NUMA
> -extern int sysctl_min_unmapped_ratio;
> -extern int sysctl_min_slab_ratio;
> -#endif
> -
>  void check_move_unevictable_folios(struct folio_batch *fbatch);
>  
>  extern void __meminit kswapd_run(int nid);
> @@ -554,7 +491,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  
>  void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
>  #else
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  {
>  	return READ_ONCE(vm_swappiness);
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index 5602393054f3..5475ba38a621 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -24,6 +24,72 @@
>  
>  struct folio_batch;
>  
> +bool workingset_test_recent(void *shadow, bool file, bool *workingset,
> +			    bool flush);
> +void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
> +void *workingset_eviction(struct folio *folio,
> +			  struct mem_cgroup *target_memcg);
> +void workingset_refault(struct folio *folio, void *shadow);
> +void workingset_activation(struct folio *folio);
> +
> +void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
> +		unsigned int nr_io, unsigned int nr_rotated)
> +		__releases(lruvec->lru_lock);
> +void lru_note_cost_refault(struct folio *folio);
> +void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
> +
> +static inline bool folio_may_be_lru_cached(struct folio *folio)
> +{
> +	/*
> +	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
> +	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
> +	 * will be sensible, but nobody has implemented and tested that yet.
> +	 */
> +	return !folio_test_large(folio);
> +}
> +
> +static inline void lru_cache_enable(void)
> +{
> +	atomic_dec(&lru_disable_count);
> +}
> +
> +void lru_cache_disable(void);
> +void lru_add_drain(void);
> +void lru_add_drain_cpu(int cpu);
> +void lru_add_drain_cpu_zone(struct zone *zone);
> +void folio_deactivate(struct folio *folio);
> +void folio_mark_lazyfree(struct folio *folio);
> +void swap_readahead_setup(void);
> +
> +unsigned long zone_reclaimable_pages(struct zone *zone);
> +unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> +				gfp_t gfp_mask, nodemask_t *mask);

Skimming over this, what a confusing function name (having free_pages() etc in
mind). In particular, that it's interesting in a single high-order page judging
from the interface?

I wonder if making it clearer that this is a direct reclaim interface would
improve the situation.

"direct_reclaim_...()"

Similar for try_to_free_mem_cgroup_pages -- which actually consumes nr_pages.

Just a random thought ...

Moving a lot of stuff out of swap.h sounds like a good idea. I do wonder if
mm/internal.h should be split up as well (to minimize future conflicts).

-- 
Cheers,

David

