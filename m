Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7DF1061B00
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB466B008A; Mon, 30 Mar 2026 10:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C096B008C; Mon, 30 Mar 2026 10:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4156B0096; Mon, 30 Mar 2026 10:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1CEC6B008A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:33:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EFD28C420
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:12 +0000 (UTC)
X-FDA: 84602971824.18.DEF2806
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 92A194001A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkKntV3J;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gR8ZMmjK8wEzSBbZYciViEr6AK1vwCcyvb+gPoaisQ=;
	b=Z4zepWwQW0PjN/T66Q4/rDYtYMh1tH06b1J3Yqo684crx1y5gmM/1FmGTv8kkN/SBjB4lA
	qG/W8bemZi6QvIzFe9mc2CrfC1uNymQSC6vscUcpA2rRfCBdGp//7lRB2lXGHRBrjk5Jg8
	Ru7sTb0qybCgmIgfe0Zbp8YiDD39fdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881190; a=rsa-sha256;
	cv=none;
	b=PAU1QX1YQ9/OZ+0mAP6yA0oY+2fLqhQUAQfGzbRW5m4gfwqahdB71SoSc6kvNM0qca2SPi
	TyyF6V3xLrOaV6Ngz3qfGEKiCWxIoPvQxaCGj1CV/PWdtmNQoRGBEbWo9SfaPdSaR3ROhE
	2ggR6uKq96cs7luyLzvtcdTeL47/QSI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkKntV3J;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B4D344137;
	Mon, 30 Mar 2026 14:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E102C19423;
	Mon, 30 Mar 2026 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881189;
	bh=N9y0x55MeIUDuj/970TQa0+5Agph4ZoIsLckCPZfjMU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=BkKntV3Jhvr98iWM1n5sF1FhzawD+hyCYgqy3kxQqXurscMFVhJ4nOzjkYhI5/5o4
	 5hTIJioCL3gBueIHd1rgTeXJ9RrKUZEkgcEWnQcB2nBm4Bm6+nNeGFC+1/5P1mm3ah
	 /H8ZpeTMmxS/Ir+wxi50m0aZOx2ZsbIIxKV5Dw7Pg7ZmLk16kXFfoN4ROaNgq8SADN
	 bbQf/UEVBxtw54HjvPwmCkxQIxCHhZ2Apci2kV+9LYE26ekVZWAMdlCz3W2mcJjz2d
	 qoPJQOxv6U0378A7rDyC5BDkZSk01m7/rxsx20wwEGkbuggXa02BIRF60ioyLciGEV
	 od0GV0G/Zaskg==
Message-ID: <8b3eae05-046a-4413-ae56-f70e1b1dfc83@kernel.org>
Date: Mon, 30 Mar 2026 16:33:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm/page_alloc: Optimize free_contig_range()
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-2-usama.anjum@arm.com>
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
In-Reply-To: <20260327125720.2270651-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 92A194001A
X-Stat-Signature: eobskowwnjw5hhq5ohkoekhr3p86zjtr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774881190-648274
X-HE-Meta: U2FsdGVkX18r25WGNQ097RPuoanmOshEtM8LlHmSbzYtCWxbo8Guouj2xXyhocRlDVJtDUOSRjm7iswUe4dY1SvAz+BgjMYptCO0D8kWT4mOvlzBpPv+czSucxDDfJvDLedg0lrFxNAQVFWMva/XJsGZVeXIzuYMJJMsLF3TN4L92AUKXSyEmAypIff6w6ovrAcreXWuandooHMpjVvcbV5/B5IFgdrpuyVIsU2KsMVzA3GkRVPqPd3R7VOyVahJeLZGFB8Lc65mHslENrZHpwqkbNl4vKCPittAJg4nAWhZDBZLglx/k4WH+IaZsG+f+nck/JacwUu/qlsWjSDdCCJJ56uY5VTX5X5Mf00Y6eBmPKeb2c6jRkOTa1Gj1k2JYLu0odT9t1xoOlTtnSB+JqLDGoRN8jIq5Oh35HgFfQIK6U0UMVlWdQ7nOXYR9hRpBq4KKtAXQY+OX/DEOQgQRs+5qxb8xBFJfnqHxlG0TD6N+QLZGoDtdKFxypcNOxDE+J5BIOEkB4IiMyNyRWV+q0FIz2rmyc714XmdNURFBBJuJQxtpOX4tG95Q3FWtyWA9oYB1eYNrNktSAXmzSnPbfb804c95IWiu4hKcb2iI3wKVyXS+73uKkTBEO6oKWFwM/cuZQndQA0grZQcciOTlYryJkqLJs662sL5Y7hy2qrWNr9ibojmBYdnoozepJgqeNAOfMVLksuShEB7OEW9GflXFB3vkn4KcIFs+c4z4OiGsZugS+bwtO89BOrrDyZ0QhHz0kWm8Gmri9gUdQicrc6nPitNWZPcHCqr5o+4hMhp+AlAs6X+GD3lQuIbbRUl0TbLSm0JkfT2HCDLHK6G85RkzDZauYBfUgTMNLAWv7GCkNPkRIdBzpLZ5WNOApkKiyZ6KMvaDMClaFPrIng+i7M2Mu/UzbSmnzoj1rqqPbEFxr4JFKZhn364YlLOnqH4Q7sThOhPE3t7CbwlRn0
 gZw5i4EX
 Sp6PbWbYo41oFlLLWQWP5aPn+x4zrA7lJgoL5wR6FZEtgK+ugjTxykibAg47BPOz+PkvlOTZzu8YAkMCzuPqTN4wlkBwvLmWbPNQvMW3rp1xVpyn2Q/19r0D0CaihkWCmUx8esPtzrO6VjI6Zc649hoMy6Q2WzOLy455ZNiaxROUbDBK1TZNkEJqXSKIE5vXPBVjF8eRgfZpsItul867oQP1nL58TTeq6/+hq3dSDFLNOx4aSTlhcI3JgPYrMN3zXRWEbXRcvCaBlk2tCT+VWadGC1aoABGUbDA3R42iwalexE3c7oovupV0iX60N12E3dAG8YGic1N4A77BM9NdYKrNito27mppkSeQD5I6TMGVdYuR/EGjiCFAHEmWlVc2hLGxo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  
> +static void free_prepared_contig_range(struct page *page,
> +				       unsigned long nr_pages)

Prefer two-tab indent in MM land.

> +{
> +	while (nr_pages) {
> +		unsigned int order;
> +		unsigned long pfn;
> +
> +		pfn = page_to_pfn(page);

I'd just do above

	const unsigned long pfn = page_to_pfn(page);
	unsigned long order;

> +		/* We are limited by the largest buddy order. */
> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
> +		/* Don't exceed the number of pages to free. */
> +		order = min_t(unsigned int, order, ilog2(nr_pages));
> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
> +
> +		/*
> +		 * Free the chunk as a single block. Our caller has already
> +		 * called free_pages_prepare() for each order-0 page.
> +		 */
> +		__free_frozen_pages(page, order, FPI_PREPARED);
> +
> +		page += 1UL << order;
> +		nr_pages -= 1UL << order;
> +	}
> +}
> +
> +static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
> +				       bool is_frozen)

Dito.

> +{
> +	struct page *page = pfn_to_page(pfn);
> +	struct page *start = NULL;
> +	unsigned long start_sec;
> +	bool can_free = true;
> +	unsigned long i;
> +
> +	/*
> +	 * Contiguous PFNs might not have a contiguous "struct pages" in some
> +	 * kernel config. Therefore, check memdesc_section(), and stop batching
> +	 * once it changes, see num_pages_contiguous().
> +	 */
> +	for (i = 0; i < nr_pages; i++, page++) {

As Vlasta says, page++ needs a thought. (you have to redo the
pfn_to_page with the next pfn in case the section changes).

> +		VM_WARN_ON_ONCE(PageHead(page));
> +		VM_WARN_ON_ONCE(PageTail(page));
> +
> +		if (!is_frozen)
> +			can_free = put_page_testzero(page);
> +
> +		if (can_free)
> +			can_free = free_pages_prepare(page, 0);
> +
> +		if (!can_free) {
> +			if (start) {
> +				free_prepared_contig_range(start, page - start);
> +				start = NULL;
> +			}
> +			continue;
> +		}
> +
> +		if (start && memdesc_section(page->flags) != start_sec) {
> +			free_prepared_contig_range(start, page - start);
> +			start = page;
> +			start_sec = memdesc_section(page->flags);
> +		} else if (!start) {
> +			start = page;
> +			start_sec = memdesc_section(page->flags);
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, page - start);
> +}
> +
> +/**
> + * __free_contig_range - Free contiguous range of order-0 pages.
> + * @pfn: Page frame number of the first page in the range.
> + * @nr_pages: Number of pages to free.
> + *
> + * For each order-0 struct page in the physically contiguous range, put a
> + * reference. Free any page who's reference count falls to zero. The
> + * implementation is functionally equivalent to, but significantly faster than
> + * calling __free_page() for each struct page in a loop.
> + *
> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
> + * order-0 with split_page() is an example of appropriate contiguous pages that
> + * can be freed with this API.
> + *
> + * Context: May be called in interrupt context or while holding a normal
> + * spinlock, but not in NMI context or while holding a raw spinlock.

Interesting that we didn't have a cond_resched() somewhere in there.


-- 
Cheers,

David

