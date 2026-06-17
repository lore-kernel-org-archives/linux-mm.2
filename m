Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89908CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639E96B0005; Wed, 17 Jun 2026 08:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9CF6B0088; Wed, 17 Jun 2026 08:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8B06B008A; Wed, 17 Jun 2026 08:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13C966B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:00:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 928AD1203E7
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:00:03 +0000 (UTC)
X-FDA: 84889261086.26.75D97AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD6ED80004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:00:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzugZWjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781697601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pB4Abb2UOhjdAhAHuvf3a1nJJ405s5Ch33hn7iCDN/o=;
	b=44M0Vhxr33MvB2jUSGRmvsalBn/fwDNygOHVYPR2wXaGIeBrP1TtRNrTSPOzz0h45sXjQi
	kbS+lpJ518Xy18DBs9DO9clhPIbfL0WX/qcHDY2UQKJ0nRsRzqdNsIe2qCZUp00JQB9b7u
	/Pzpy/XaX6fpq8KZzsutOclpKiaD89k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzugZWjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781697601;
	b=Gtfj6JJO8LrlC2JZDMSIab+6To6TyU6BxThw4/WqSru0WfjKP0+YEWW1nJC6zIUJRExqOm
	OZOT65/MoQsmFwjO8exeu4SKxskWQ5anNtmErAV1JR+lynx1wicQalyoiVxMNUg/WVAkO9
	Nb1ddnWrvHEKcyjZsHQDAa5hiMTrGuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 564FF600AB;
	Wed, 17 Jun 2026 12:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB031F000E9;
	Wed, 17 Jun 2026 11:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781697601;
	bh=pB4Abb2UOhjdAhAHuvf3a1nJJ405s5Ch33hn7iCDN/o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bzugZWjjZadfXWZKAbRexvl2j+QC3fgPmjWU+IdcOqaSJOKm/uIo+Jb91BmQ3t7e1
	 aWrHm6HFM99ta8/H45a6g/Jjoxebz3uM3CkvXYm+u07cGhXdTSbP9V2tLWhEQGIgLV
	 3Qz4zk3dVYY/iF+2K+AxnqLx8RPFrsS89GtyMg5CI3NP/pJPG1pyzSmgVHNqSQ+83y
	 Q+9EpQOiJ7rYhpNJyM/7COaY1L3MJLxws1KIPfrzrL/csluSGk1ikLAr6YzkjnIxU0
	 9f+IbVi8K98e1eq3oFOGoGrsIU3Mv0srQnxmr/5jZJwgXriYIOd5qadOcelzxAaimO
	 vzNFmYLcTcVhA==
Message-ID: <8a8240ad-049f-4bf8-af65-d5bab2c19024@kernel.org>
Date: Wed, 17 Jun 2026 13:59:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm/vmscan: introduce folio_activate_locked()
 helper
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
 Zhang Peng <bruzzhang@tencent.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
 <20260525-batch-tlb-flush-v4-1-83789d6abc00@icloud.com>
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
In-Reply-To: <20260525-batch-tlb-flush-v4-1-83789d6abc00@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD6ED80004
X-Stat-Signature: 9hce3way89q4s5ny58n116ygf6gtdr61
X-HE-Tag: 1781697601-318105
X-HE-Meta: U2FsdGVkX1915TIGC2R2fvcG8Mo06Cn9P3w8IfunEF5LGEXqsEtbY93leOK8lZfYEm/16B37DMDgrf/OVHUdldsBwwCIIitpkVPsxAqnauA2jrshjx22AWKPgLYODNNC0KEANB0EWkVP2jnSxGGUROV24WBCDFCWt0UwjqvyWY4abH3SKhBbz6nHy7EIcETp+iHZFB3wHxFK0DUQyIpY+VqzqzEYIJcHxWoQbfuB/UjAm8w76rTEKqvUaSepctYwuu+FZ739Zi1g5HRfKwqKNHpkQ3rGJSEOwnDVrLLb5DNzlQO64UuWYSPRRPhcvluW7iRE16lU5rUmL3c7hDCYuZbHEyKUfvAn8LYj3sgo8tbgF1nBfMRUMTKqrN7bRrVXpl5BRStPMaZ2PGgIic1XE4HCTIsv9YS3S8FGu10bcToMeJEhQd9j4eO5+ZjT71onAl5EzWAGM6uRpF4FJlxB6pBHWdcBCZXd7GZG+kUnDloA3amZ4rHUskkyeYCtD96/K7edFN0Aoa0KDECOl/2L7Tk1InhD3pUXZ+PXHmnlD3U2HnRIfUkAOiQkEBb9mo7IQckGwPSs7CCkKd9sYcKaUn+bvWYmSnIrJz5iadKp+mL3pqmForf7EoZZGOWLaBT/rlRUPvRlbN/Ypat9SfvD7DzYCcqDRCi/FVcsw5L5stmQd9vpvoyTiDYqFkoSMjlgTKKZp1Jnk2WZCViFNmxQIis5Ap6yytlFQ/8D3jgTuVwo3/U3DJE9G2SQxYUJEg+8mHKcU1Y9G5ZJmOM+VeE86j59Y+DNp6g0Y1l9HWyZm87KDaLiuihf7wc6+J52l6fd7x4QxfYh1U7ZvURGUdodfJVKe4uap2sL2dQ1hLFxGO9uwxMsrIXljxImNUKCS3Z4uqDFyD+1RTh8NcHJbYmDNZ44cPd7QO3Tohy9bH2KOc21SP1eilTcKHP17yIUkUPYJDr4bvwtnw7TpfhDkLr
 uY23aLV9
 DLCz5swRn7AhoqPYtiYaGLcmSl5B6rF4stBHpsd+GCJ4axHgSkaNkb73/PDVlLWPeq0QyFmH4B3lrLTgbROQGbpL6J7ZezUdx2BrlDDRySD82nKAV/F7x4kX0M6+hFm7BurnDMbjgQj+LAXoR1RlMEySKFn1nv1bqEU2R/UbrWPMNy9CPuaTGD35pPMgcFqNF+J4VesYq8bDcK7bZojVerwRkkzKad/DLibx7KY+rzjmhbFfXjoiiMGtj1wOQw2pS03MlwI1RxPACC5wSCb1Gy2lmfZaB+oSSnq5s7vDXkozqamakqzfPA5Ld/Q0UKPQoOfASXSZF9XaomrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 16:57, Zhang Peng wrote:
> The activate_locked label in shrink_folio_list() reclaims swap cache
> when needed, marks the folio active, and updates activation statistics.
> Extract this block into folio_activate_locked() so it can be reused.
> 
> No functional change.
> 
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ca4533eba701..886d8b4843aa 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1050,6 +1050,28 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
>  	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
>  }
>  
> +/*
> + * Prepare a locked folio to be kept active rather than reclaimed.
> + * Reclaims its swap slot if it will not be swapped, then marks it
> + * active and updates activation statistics.
> + */
> +static void folio_activate_locked(struct folio *folio,
> +		struct reclaim_stat *stat, unsigned int nr_pages)

Passing nr_pages to this helper is rather questionable. Just use
folio_nr_pages(folio) here and make the function less weird.

> +{

Do we want to add a

	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);

> +	/* Not a candidate for swapping, so reclaim swap space. */
> +	if (folio_test_swapcache(folio) &&
> +	    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
> +		folio_free_swap(folio);
> +	VM_BUG_ON_FOLIO(folio_test_active(folio), folio);

While at it, do we want to turn this to a VM_WARN_ON_ONCE_FOLIO?

(and can we move that to the beginning of the function?)

In general, LGTM

-- 
Cheers,

David

