Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9E0C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7601F6B008C; Thu, 20 Aug 2026 14:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7111B6B0092; Thu, 20 Aug 2026 14:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9126B009D; Thu, 20 Aug 2026 14:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3354F6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:20:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FF20C025E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:20:45 +0000 (UTC)
X-FDA: 85122463650.04.0399EDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9ABD180007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:20:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7szFDus;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787250043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grZZPFG3qYocshzAz72EwkjewwHcCchmZKuap7NwKY8=;
	b=h/JlWRcOEDqpeSmROlILoeD8Q2slwP3zg78La9FK/26mG1av3PSN6CZx4UoFr0KAkl4B07
	v8falIagU7NUzORtp5gtMAiXAJH1Z1VVIvnO/U8Q2tkxlua1mNVA6ilORsvrDg8s/8K5oA
	fLvoAc3Tbx6KddiMQ2yB7ta3NKSZI1Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7szFDus;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787250043;
	b=UPNlJ3Sd4mJHWcRuN9+shjWQk14sIKsExQ02zbg72vovsoC6Pcgr5Q11Qlpg623jU2VBlW
	Chp4GgJekZ3N9bmvZ1wTQZtZoHQKUzNYXvz4RB6CfdLhWZeuj5u8Rbi3H0OpPA6kIzwQNG
	/6ZlZRvOz3LaAXtR5dg9Ux5tGtCej0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFF5A43D5F;
	Thu, 20 Aug 2026 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AB41F000E9;
	Thu, 20 Aug 2026 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787250042;
	bh=grZZPFG3qYocshzAz72EwkjewwHcCchmZKuap7NwKY8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W7szFDusAd+xh3I5g0seFehaG4Ah5wZutQ9LOO4H+lZXAYFyYGDgVhv04PCPobTN5
	 cixjsBedDRZQ1XZHEX+UwcbJYjJtnq6adtjGkCa6iPGs6RYEnlKHUwlzVOu/k/kfgY
	 Gj4MmJPaMNhC6FZbAHTrWh4FkkxW+DzFnMVTrNszCUyzh+kgmlQUDOCzxSLfN7OxUH
	 79PWnK7VUM6iMmMLo3/v5xqh098XLnCsSCvy4K/tb4OOgju1s1BNLCdj4x7hgfGzl7
	 pOkfJncaSJRChOod4OJyyPuCGyc9LeisCLefHzPBzJMa6mHkmSH3ZK9lwzmvWSchKO
	 UyNyEp9kxgo2Q==
Message-ID: <51b025a4-7da8-4b50-9ba3-1c25eaee7b04@kernel.org>
Date: Thu, 20 Aug 2026 20:20:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
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
In-Reply-To: <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9ABD180007
X-Rspamd-Server: rspam07
X-Stat-Signature: t4mjyw6s9fuy1tcpijeo8eh9axz5owto
X-HE-Tag: 1787250043-869765
X-HE-Meta: U2FsdGVkX1+uCJ4ZgO3zV2irDEHUJIVgMNmAOUiCRdMjojITHlWik24RuClpflNm7twd8DbCttTbNPjQEStK3dValzp0h3aDFYal4jkk9gSmMnbbTPe2L9BH6YbtZ4oBisbh2WFHZ3I5sRKNroNr8yDueNlTadsCKmHlCVNFhymNcBSONKW2gfPvXON+WloTA0+h2sTYLykN2UtLgtd8yWov3n8XucmqUr07iNzPY4yPKnUjzkMHtlYWtBGxRWeZpHhPONBOsDX9Fk3HFN20F81497JdosrLAt9j8gftFme9p/fSEkNFIvhrGl4xs7oCO9g8HZprU3fzWhqi3rb43rOzViC2N5b8LUYLEVglY8/8d+2wLu5Hq2I960PTwg03tbOar2CNOnkhrBoMFUvlgQFDrD+ig85O+HGJAXgBPy7HCCzP4W51P1E0lwUHD7t2CkImxQy2G8WpEPr8NVJGXrXnH2wu0SBZjjXShUEbZ/J0e2GAGyBUcQBTLMgzBDQRN22MiWNyw3POGpfxeFMqH3udvpYYPlS3KSEi+eN9UwqsyiCUJKvMqQWvXnEPtKJBOYUTJIunkmAN8PjI2GQZj+4Mv3XsNKIKYkmQlanC9La6gtN/DPnXyacNFf+P57UHwcHl0xhkD1VO4cws+wGk65ugWWE5S5+iNULXRzxXsev1ju2ljiuczEb5gn3Mm5lp/Wj48+2ZlyFQg3vUZv5jvKtCa0WJ2jdfgetqYE+V7AaIrxCYzZxFnK+dNpMAyx8tbm1zgUCkc6/2INIXcE+qBaf9uqSghl5hhzpvIKNWuvzBuUCEOdbM1hUhWu9Z9QPUl0N5zmJDhR7YeCyT/RCuWZzHE6K9lUKHoM4zL0wbRzFPy7AYi9RND4i7pMFmlaxgTOddrHG/DA8nAhiQVQ7H77inHTReABoVNkGgWQotm3Wlsf7YA1k5Rg1LnHH4BKJq8+HvxfnGizuEHEzOcDq
 5Z6Lq0wB
 i7Sy3lBnAq/PXT88dmnp71iS574edWLekrdmqjYrkqOrclSEtiS21Vq47/YMVBMhS2BP60QH0m0/N4gpVbIMphd18zLRqjNJnVhvzr4I3uSu1HPwrvdleqmGzy1cdCqjjDdrAbmOmdN2BtRSEjD+85JvISlyei99vItyHvONCfLXmoLHZs4+r4xFqtebxr/JQCs4VEG5Aa3pB/lmJ78qbEcpINJH5i4KjJ5TbPc1OIiKAeUOzOHVSxwWryw/QnfywllrgvuYk8J8/+Q8gOyQMCVixucTXeUUN3s8RLM0GXAVxygNCSiaS+yceSZYbE234F6Z/LI0pOVOG7R4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 07:38, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately, while
> folio_migrate_refs() copies the rest of the reference state. Make
> folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
> the MGLRU refs counter, in both LRU implementations, and drop the
> open-coded copy so the reference state is transferred in one place.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 16 +++++++++++++---
>  mm/migrate.c              |  4 ++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 93bf3fa221f8..df62daaa2ee7 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return true;
>  }
>  
> +/**
> + * folio_migrate_refs - copy the reference state to a new folio
> + * @new: the destination folio
> + * @old: the source folio
> + *

Man, that function has a confusing name (refs vs. ref_count). :)

"ref_state" would be clearer (just what the description says).

Or better, "folio_migrate_lru_refs", because that's literally the name of the
function you use: folio_set_lru_refs.

Can we have a cleanup patch to name that consistently?

-- 
Cheers,

David

