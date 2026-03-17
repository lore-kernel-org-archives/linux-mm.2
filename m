Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05F9F33830
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3569D6B0088; Tue, 17 Mar 2026 06:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307AE6B0089; Tue, 17 Mar 2026 06:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6E36B008A; Tue, 17 Mar 2026 06:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9FA6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:01:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0DB61C874
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:01:07 +0000 (UTC)
X-FDA: 84555111774.11.B465B9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1F3DA001F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:01:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9eGZhk3;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773741665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8UH3Bk0Ic5hWJmXKrN433H7mHbkNFNkv165MTuyRAE=;
	b=lZsZxyUdhiPpEQWx8u3Mu3xaT7olz+5nkb00yBp7OmiOLDzf0QRZ86uG+Zs24p9bZ7GWE3
	SzcJjR2VdcGf4YNp4F4cyiyci2GiiG+23E7SLAn3BSpB6qiFRtlr+KlHis1AqIpqAqkA+N
	i+UmtFIjVvK0c+X9XzCNkddANt/5mQg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9eGZhk3;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773741665; a=rsa-sha256;
	cv=none;
	b=loTDWskc7T27BDfTToPOo38ajtnxTymmmfoukoPiNCDFRQmkJyt5+RDAmlx8r4Aj87OHaV
	96ewzEtnEerIG5LQC8YeqcUQAJDiARb1B+/jqFb4LmrSLmplqkMmtt1zKGdmhym6YJcOq9
	qr1XSpgCvzzPeqCVeHYghoPwfnQ2xdo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB4AF43A0F;
	Tue, 17 Mar 2026 10:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4571C19425;
	Tue, 17 Mar 2026 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773741664;
	bh=W38i8vvjbZN+AiiGak0qWDXsJsrvETCfz1WLCCPZXO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g9eGZhk3fTtR6+ndXqG8kvzQjFIhzRp1E02ekngW2oB7e2cNJRw5T6WNOrYwgjwUa
	 n2nWulFFA2n25QOq4h4JFnz92S2ensxUIAUVhqalaYgleAaOv6n98uO4winsqIss4p
	 0kGgaW/LOfVXWvEQ2HWA66B4rmUhCNCVEVz4J/2ubAgVxeIUXh0CWsJ4kROyNMnAfB
	 PXbCjDcLH59b/0rxH02rj9TOgRva8ffZYt0/gq7AWrY9lUOcRaYIiUQT51YQJcppC0
	 ZUZvmgm/E5+w87mrAa7TqPHMW4daxIRnJxcdgFN4CTtSbvWyS54pOs6kBGt//F5K9Z
	 h/RtSHVLwZ3jg==
Message-ID: <46d9173e-98cd-4f59-b0f3-e477afd5283b@kernel.org>
Date: Tue, 17 Mar 2026 11:00:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-6-hannes@cmpxchg.org>
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
In-Reply-To: <20260312205321.638053-6-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1F3DA001F
X-Rspamd-Server: rspam07
X-Stat-Signature: cgohdepm9ej4huk6h764187jih3xfoo5
X-Rspam-User: 
X-HE-Tag: 1773741665-351612
X-HE-Meta: U2FsdGVkX1/0Fc4EMsx8IwCyqIkvozJ/v9fGv6uaLiUaJuL6odP3Ru+jK4bg2P3obJZvgwZp9rbvKMQi3lrFC35HI+b9Z/3NbaPs6C84Yajf2DhIexZ29f36Q/U1xJmFV9K85PuXESBz+eoBgeb6nL+oS7hwOtGxHG67lOlRj96X2E0O8uI5XqRNdmDN6+GErNt12gjc8xtXXBIhyoVfx7UQsCuXPU+m2FQZzSV2SKpISbW5h3S4rgyzOUnAgTQ8iQQCOB3hkg37Xlotr1lhbbM4jONIM6mKFA8a4h936kIk95YLexR5Ca/dXIJVcbo+ZAkTP7e0i/rzYFRslJM/Ov/vgs5soWyaImEWmcgdDjFLbypInO/uyUF+ZoZ15GIVVyWVRpGqK71RuLKsv3eC05VE1a8IMu8aiByBmxUZbKE99DIie+pRWaXy9WpCTPMlnDdcGo+tYbNKlOPX67SwZPmOkg+MFtfZ8dSkdw2wl36KDyb1VUF97wqZ4XILHVRvEk7XIJL3Avzb7PAT3GndbsAJpNep9W1zdi44d6has+f12i5W/Fv4lyC49uJOYju71YhqVp2pA62Huc9sL2nEBpLIgeR5SR48LhC212qcWnBlmW+Lr2HYTmyPJlRsM7gKeMrNgkSPQUwj5umdLTBeXWFzJTkjSpQ7RKGoNEQsm0AXiN15kF0GVd+Km76tIlEq4eOjGLMtaRCVA6D9gFlza0UeQqEILstACHL8pDt6sstZljPgfVJXjAykxFyxMx+kKJkZ/JwJBGryRWWy7CuQgZV+1j/zzpYlAKpJHYOoeLcySCdff8qUkEiUVYFEmAFKHignlx4kxsaEPenTn1GlNbxd0X91pxtxJQyw2VQUY0Wahf/33CigdiHEcTtr38dimUKm4ij4TMMjzHUrdk1+e9sl6UMABI+jh3oIY5B9Ky7+699JsyaErv9EQwwZYVg/lzSndryWJbfWYjjVphx
 1sxHbIf1
 hXct9XEbPBUCbA7vZXSB+pqhL2j+KSQoYeXPv46mG9w3OvLxLRZQK57faO66crUv2wnDO336ZKCYjVWcrpyYTpYoYs1Ceg641zUtAqnRyO9sgcgzv9Lq/ws+e5HwB5jxJPRArOFyKDcWT9NfmCgZbVzcPOahydkmfi+jyJ9AMBP5jxvaxQDk3hu5NV37MToPZS9CykR3myQx6xA6P+Fj+E9ZnKmztH0ktSVtWibgYoA6ufPMg8JeNV9RM0K9YeOvTExG+BdC+L4VQAcr9Dc3sX8UdZm6wqNaYr9ZHdwO5+yvckJ+6vx+yA+YIKieLB6d6Os73I/4ZQ3Kh6bTQLLLEMjZ0zdKS15zAXMtEcQXBiwjog/lIEc3btbyfRcMiocK4ooLAqcUvtO9XMnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> Locking is currently internal to the list_lru API. However, a caller
> might want to keep auxiliary state synchronized with the LRU state.
> 
> For example, the THP shrinker uses the lock of its custom LRU to keep
> PG_partially_mapped and vmstats consistent.
> 
> To allow the THP shrinker to switch to list_lru, provide normal and
> irqsafe locking primitives as well as caller-locked variants of the
> addition and deletion functions.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/list_lru.h |  34 +++++++++++++
>  mm/list_lru.c            | 104 +++++++++++++++++++++++++++------------
>  2 files changed, 107 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index fe739d35a864..4afc02deb44d 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -83,6 +83,40 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  			 gfp_t gfp);
>  void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>  

[...]

>  static inline struct list_lru_one *
>  lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
> -		       bool irq, bool skip_empty)
> +		       bool irq, unsigned long *irq_flags, bool skip_empty)
>  {
>  	struct list_lru_one *l = &lru->node[nid].lru;
>  
> -	lock_list_lru(l, irq);
> +	lock_list_lru(l, irq, irq_flags);
>  
>  	return l;
>  }
>  #endif /* CONFIG_MEMCG */
>  
> -/* The caller must ensure the memcg lifetime. */
> -bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> -		  struct mem_cgroup *memcg)
> +struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
> +				   struct mem_cgroup *memcg)
>  {
> -	struct list_lru_node *nlru = &lru->node[nid];
> -	struct list_lru_one *l;
> +	return lock_list_lru_of_memcg(lru, nid, memcg, false, NULL, false);

The two "bool" parameters really are ugly. Fortunately this is only an
internal function.

The callers are still a bit hard to read; we could add /*skip=empty=*/true).

like

return lock_list_lru_of_memcg(lru, nid, memcg, /* irq= */false, NULL,
			      /* skip_empty= */false);

Like we do in other code. But I guess we should do it consistently then
(or better add some proper flags).

Anyhow, something that could be cleaned up later.

> +}
> +
> +void list_lru_unlock(struct list_lru_one *l)
> +{
> +	unlock_list_lru(l, false, NULL);
> +}
> +
> +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> +					   struct mem_cgroup *memcg,
> +					   unsigned long *flags)
> +{
> +	return lock_list_lru_of_memcg(lru, nid, memcg, true, flags, false);

And here it gets really confusing. true false false ... am I reading
binary code?

I guess the second "false" should actually be "NULL" :)

> +}
> +
> +void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
> +{
> +	unlock_list_lru(l, true, flags);
> +}
>  
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> +bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> +		    struct list_head *item, int nid,
> +		    struct mem_cgroup *memcg)
> +{
>  	if (list_empty(item)) {
>  		list_add_tail(item, &l->list);
>  		/* Set shrinker bit if the first element was added */
>  		if (!l->nr_items++)
>  			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
> -		unlock_list_lru(l, false);
> -		atomic_long_inc(&nlru->nr_items);
> +		atomic_long_inc(&lru->node[nid].nr_items);
> +		return true;
> +	}
> +	return false;
> +}
> +
> +bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
> +		    struct list_head *item, int nid)
> +{
> +	if (!list_empty(item)) {
> +		list_del_init(item);
> +		l->nr_items--;
> +		atomic_long_dec(&lru->node[nid].nr_items);
>  		return true;
>  	}
> -	unlock_list_lru(l, false);
>  	return false;
>  }
>  
> +/* The caller must ensure the memcg lifetime. */
> +bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> +		  struct mem_cgroup *memcg)
> +{
> +	struct list_lru_one *l;
> +	bool ret;
> +
> +	l = list_lru_lock(lru, nid, memcg);
> +	ret = __list_lru_add(lru, l, item, nid, memcg);
> +	list_lru_unlock(l);
> +	return ret;
> +}

Nice.


Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

