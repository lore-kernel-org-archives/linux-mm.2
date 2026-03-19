Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 323E81075279
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AFB26B043E; Thu, 19 Mar 2026 04:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860EC6B0440; Thu, 19 Mar 2026 04:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F666B0441; Thu, 19 Mar 2026 04:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6313D6B043E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:49:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CE4613ABBF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:49:42 +0000 (UTC)
X-FDA: 84562189404.04.2190E47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4011DC0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:49:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VSAluQ55;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhfPu3qnAbA5MPoYZ3CgPIhswmpi6WtzTYz3fzA2Ki8=;
	b=cX7MgsiHKlGoSRVNNsyVbQ7rsXEjEdiHvHoLUcL0cTHV2nNGKiiByWJj+m9MQOpFgjdO+E
	DlP/uyorGk7nmN7d9eIZsuKxphq9ozZ+v7MKkT5uQI+L2vvwYfaS5862C9jkgD4+1+N17u
	1hEQpk3MUzVevJXaCEhC7hzFAdZU0bA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VSAluQ55;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910180; a=rsa-sha256;
	cv=none;
	b=kX9TSx/v/uBvEWKZA4zGrs09iLW56zrBcExWbdZAIegRAUFPZq6kA+cRmV6qg1DmCOJI5m
	SP+Kj/6xhMdIuJKQsqXvpPfOSXszTd2Ew05uFM/iTwOoj8Py0GIXSA4jav90cwdPkvlJjW
	moc2gbIwzmOkLonbP/VJWXnqaLV7jpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4673C44474;
	Thu, 19 Mar 2026 08:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB6DC2BCAF;
	Thu, 19 Mar 2026 08:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773910179;
	bh=Ifz9SBANyiJwa/uIE9HB99AY8+id+zpQI5spFPN3LTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VSAluQ55HJaUtEG1IsJ5NWIOkQbWebceW3r1y0lVAN1ze5DOwc8hy9yROLrEGLdBM
	 2MSALqdm602Mb3a36SCUcQFeoMJ/f25tFxICxTaPLU6hMm07C/PQgyV1K/2Gj8OyvP
	 eESt4Wuc6GXc1se05GfxyikSydHlpXChUNz9igLQ5mI69KB5t6AFBJdt32dazC5bQ5
	 wS+F5hmlJcryXi1DyHdAyLrNSPLLo4gdbtvh9+QL/RQ98nFvRor5L3Hnpedglld0L0
	 VdptgsNVO5Tb/Qz/qbGf+sbGhIVr37CKmT3sLitwCEJEthI0nKSSp1a70gIj/xTKqo
	 NbNqGef5zVqBw==
Message-ID: <acfc913b-c635-4795-b75b-ab8b04e7e83b@kernel.org>
Date: Thu, 19 Mar 2026 09:49:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, baohua@kernel.org,
 ryan.roberts@arm.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
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
In-Reply-To: <20260319012541.4158561-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4011DC0005
X-Stat-Signature: efnhzjmmmtfjnbig3g3y53ech56qhe64
X-Rspam-User: 
X-HE-Tag: 1773910180-798343
X-HE-Meta: U2FsdGVkX19hiXQUmBBnnPoBSgLUbcBRDYR9uHk2klNW0VhyO7f9hXsV3oA6UU97CSDhaPT0sYMq3jLEnXqfFbbFyAn7rBYUN4dRxayRlVnVQrzs4HbClE9N9b9cokaB8+uQm3F7cH7C1ZBSbXV4FqEfVlKjV+ZzPT6ihifG+d9cRwvZ2GoGHtLltTqZnkVOXdOK0Nxg4rj9x6oo4NU/gclZAZ0GhWiBFxioX09L4TBumllIJ0rDiVinIxXUdisoYi51n6x2OX4S0FC1b3XIOGsz4h7KP7/znLmbARHNkccEiILfpPtVT3GtyOJzPNzkzwnNJEyWDW5igb8BAbj//Zx+LnH7Ik+FAffncFhxwDK56yuwRqveo0j7B5A/Npz5JEysJ39OOWzYBZS/dTAAdkexFSMqOeb4+RoI7B5Iqj6YFTux7DSrcFfH3nB2NlwDr5i6j+MRpzfKeT/8aD9xAvELEWPuPzbLcHY5gq/yD4aOeTldcLUtk4VPySqxGqCA7H6tBGg81opwLCnlasmA3ycJiKj/0C9y/B3ko2HQqVq45fjwK8hSHtObj4DalSRLGL1RbhY5ijwlXAvDQcQw8HMUU0T//krrRt93gPDZBGfTsgvFCrcGYFyfPYfqvF6Zbvz0HrtW232WfcXLyeApCZsv79AyFYrc/CzD3W0AiUbmd9ulfTEzExEXVjiDSvCq03II1l+zRuxMLJIjfNy/vdIJWOCcZKnGLK8/BVoFo7EAWF8/Kh2jIOAVsEpT6dnhKnf4Ew8jS4DQfBoVnbGpmioPTqVjTRjj8IV9bTtXdOJr/C73R/P1AM3nW2jHZ6GpHroKKNAtsyK53oTkf+zX8ziwgqX8eGdYnM/Xz16s9ryyZgU0UGnVjjb3yYnEL+gk1cA3S4Fuw6eryso0yW5KdusmXvECFtwKWEMNw/Hl2Rla6NmnoJKAxe8IB5zg3ogiSGTTHt9rKBHDxXnGeGF
 oNxpwMFD
 vcY9KZNySdf2bDONcPJP2Pcsd/nPvQ3HxUD0Pk/eVn/WFNhCVg6oc5nPb4n19abUq/zlilk3kw6NYVwPp3KDK0IePzLcId6LmRu2tjxmhunPhq9rgxJW7iLC+RjAeZiJE/kVDmTyNW5/57qjYY9vomYE0F/OoZ4tpgT9fs9yqi8wB4itUS0eZkb6v4zF3XIp70M1njb1fM7c3YW0sl7QSyolSSO/6NIyTVdR/D8hSaTlcT5RHJADZrsCOa1075Kj0GnF6+AiZ0rmgtK0mEWbgR0AUu/rLy3cLAMRVKBCJwHwlb+XMK+gMHA69FxgCg2AW9Atv404RhhlfSJB3Tl8fFL4/xN7xdNZGhLqH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 02:25, Jinjiang Tu wrote:
> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio(). This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio(). The race is as follows:
> 
> 	CPU0                                             CPU1
> 
> deferred_split_scan()                              zap_nonpresent_ptes()
>   lock folio
>   split_folio()
>     unmap_folio()
>       change ptes to migration entries
>     __split_folio_to_order()                         softleaf_to_folio()
>       set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>       smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>       prep_compound_page() for tail pages
> 
> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound. smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores
> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> page before page->flags.
> 
> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().
> 
> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> 
> Change in v3:
>  * move softleaf_is_migration() check out of softleaf_migration_entry_check()
> 
>  include/linux/leafops.h | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a9ff94b744f2..dd4130b7cb7f 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -363,6 +363,19 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>  	return swp_offset(entry) & SWP_PFN_MASK;
>  }
>  
> +static inline void softleaf_migration_entry_check(softleaf_t entry,
> +			struct folio *folio)

Nit: ^ should be two tabs. Likely no need to resend because of that.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

