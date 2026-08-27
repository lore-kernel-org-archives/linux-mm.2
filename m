Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF07C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2776B008C; Thu, 27 Aug 2026 12:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A806B0092; Thu, 27 Aug 2026 12:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0E16B0099; Thu, 27 Aug 2026 12:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3FF46B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:48:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D9CF1C006A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:48:59 +0000 (UTC)
X-FDA: 85147633998.14.97169AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3037180008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:48:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGOhIRPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEdTYejlPEl2VajplsOoGksC/mlaqQTAybKbn6EW/6Y=;
	b=QUcTJIHkr5GVG73HiJZ8hFgmJjyKfra1f5HzENK47fGPf/rG/FKWQFqMJvzO3GBExHrjat
	IV9MXwiXlWD4SfLB4JZjRh7vNk1YSHd6F1r11qaAZw/JUj+w8zyhaCvyqDf3t1j/h3AdbI
	X2lDTe2QAte+pdMeInAmP988o95mCgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849337;
	b=0fxw4i6UWU4hyiW9yjl5J96ECfZCBv7Gvkf0Sq1aR4X8yFs1vT+9TWYuygEhgL86QSBnN6
	cw2KgO/lgX2iCt2PTVJLu+k2sJEcrOAkXo2HQYKddNy/2dOcKE14+wMPIEICHnuKPg1Kz4
	M1S2XDvGN1vQDsAC9fb0g252VuiBY6I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGOhIRPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 238A6600D2;
	Thu, 27 Aug 2026 16:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE141F000E9;
	Thu, 27 Aug 2026 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849336;
	bh=pEdTYejlPEl2VajplsOoGksC/mlaqQTAybKbn6EW/6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BGOhIRPD2lf1vcwYVPVmxYhlzjEAFg6sWgvKxGNR7x66cvNqBT6pBHS5BN/gVjBzS
	 UeiKtsAxb6wZsP0GRiPH1Ea9kh3oYc/Xz7PdkQ1VIXNk07rivC7R5DrnZY/p39YtVL
	 W2uFfUJYDaaeEJEcbajXKOsvnHB9TatK3RqmP62JGCHmRaUVt6fyEj6tsNNyAD8rFy
	 vloi9rt9W88WrJX72Uw0sNMFjVV4TFWL4a8pqY/wwNg8WHo5dh51aAMY54onazJ88O
	 gHYnYUdLrvfC2Bajm8Vy5oaGkZ11L09CybemaeBljLG222937TTDIfyY6j1aJF2bfx
	 cx/0RFZAJq6tg==
Message-ID: <9adcaf53-3a40-4d97-9365-b9af97891894@kernel.org>
Date: Thu, 27 Aug 2026 18:48:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/18] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-14-9b43f5163238@tencent.com>
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
In-Reply-To: <20260821-swap-thp-cleanup-v3-14-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3037180008
X-Stat-Signature: boxbt9an1di5po38arjihw7x5jbrj448
X-Rspam-User: 
X-HE-Tag: 1787849337-349531
X-HE-Meta: U2FsdGVkX1/SUsDcNTaNQrCOwf7qhPbNXV3c0wD4FIp7OTVFKBubla4AAzaDm1tZGUzAr4BA216C5TrtwFwMaolXWN/L7C4uPKuDxhFIzJbIa3PLwZIQ9iCzbPDuleRC5IHuXkMd2nh4Xv+hZPAB+iP/6HgbTqwYh5vjmV7XIwcQkgsB1gqmzOiDma5jY1ubcqVJ5/6nwOlat5Zh2A1Xi7dvZaZHe9ls5jrjAlV/pLJpVon0YNCf0daUEMaaDDmBY1A35fShhXbqtskH9Y20JaXPt3PeJOqQ96TE9/7u0NiPZdPjLYqAMNBlVIPALO46IibAY2Key7fTVjjQ3KWa4BKF1M9Cwo/9uZgjuQUIczCaIQM8gi/mjPRb9tUNGlp2gLy+YGl4RtpopN1LMtYY3W15MoWVrCgrq4eUjIdiqsupIb/DW8z+N1nKZdDO+YUbZp+BQhxsVRAMx8J5pjxkeGMuFpGuUsJKcQJ6Z7G94ORazdtW21eez5s4HEdZSjDue2tphTj3dsv/c6iNiPMvRhTFHGNvijny6kXCmKCMxltbefL53bWjGugwE+EQJ2yI0lszxYmeAJJuOj0JC5VuP+13ERklZKV3vdGOknabO932hvYhNRZjL9ZEpPZWxX8BoSRQWOePP/YT9KS6qcp28gEWSbrzQ7dBS/BWeS2gkFxq0vZF7nxSwlGMi+sjmoZife+MQIydFcpPiM4eflDfqmgfVqES7TjDWRawETiXqOQbH/1E6MmsOyG1x3/OQ4Nxyk+GdbmBw5gPYAq23/Frq2YFZL948xwkd7nGg/rzWAnlmkGJOaBB8/ZqoSzo/nGZk9J862ltwZzi7OWVpAOrfMAEvt6l4mounRNeTQFS7qwQPnsGq6YodV7odnEVMFmz8RqGLcvokuw8ppvUtFSA8GKLC4I0DHB4DVgg679KEHBRsNwO72hKzG6/drOBRWzGhuAdwvM5kP9r4/ht5NF
 bam8Rnzb
 4bdWF1Vv4QOJBQX9vIqSwcY1q0yjbEzU8xkXiWrTC8TjlYzELseA/p9G0I16WU1LfTpMiGQonv1TFqvExbLi5ahAByQ6Q6NyA18EsXfoDvypj61VJxNdSIgrwstBKIWYckVVwsrISi0xFSCHamsUgAM0wWDW7R0I28VnXjUPi+Wues8AM/ycE/DCEyBeJaiQI/vnED8LG+01ufBCCzRjmDbc/u4QaYymThZr+/vSCloUMVYafbcOiW3btqD+mPLg+owOnxs3UB6RHWnEqXtbIfcpkV8R4dibhIHJFcDUvphe8eeXE0JHSEh2NAzrWoH+iPuIazGMMIJtYWsAeDlpqPgAyS7Tb7vj263CS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
> and folio_put() in the after-split loop.  free_folio_and_swap_cache()
> unlocks the folio, then free_swap_cache() must trylock it again and
> re-check folio_mapped() before freeing the swap cache entries; if the
> trylock loses a race, the entries are left behind even though the folio
> reference is dropped.  The sub folios are still locked and unmapped
> here, so just directly call folio_free_swap() directly under the lock,
> unlock and drop the reference.  This makes the swap cache freeing
> deterministic and the reference drop explicit.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 84c6e4bbaa88..113a33cddace 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4337,14 +4337,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		if (new_folio == page_folio(lock_at))
>  			continue;
>  
> -		folio_unlock(new_folio);
>  		/*
>  		 * Subpages whose mapping has been zapped may be freed
>  		 * earlier, but freeing them requires taking the
> -		 * lru_lock, so we defer put_page() on tail pages until
> +		 * lru_lock, so we defer folio_put() on tail pages until
>  		 * after the split completes.
>  		 */
> -		free_folio_and_swap_cache(new_folio);
> +		if (is_swapcache && !folio_mapped(new_folio))
> +			folio_free_swap(new_folio);

But this is effectively duplicating code that belongs into swap code.

Should we instead have a helper next to free_folio_and_swap_cache that consumes
an already locked folio?

-- 
Cheers,

David

