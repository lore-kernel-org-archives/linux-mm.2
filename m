Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D25C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651C36B0088; Mon, 20 Jul 2026 05:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629AC6B008A; Mon, 20 Jul 2026 05:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519176B0098; Mon, 20 Jul 2026 05:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 223BE6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:27:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DBF940768
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:27:44 +0000 (UTC)
X-FDA: 85008627648.20.EB074E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1547140005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:27:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XuV8jZMv;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMdIU9vjdAuXur3wP4WnM9rv00wH5avletuGlMTkduw=;
	b=tyOPisRoo5a9qnMm+FXcQWsnzsQjO4WYiE7Rn1uQFtnBnTGuO9XfAj9BiFpMdjZxFU1uvU
	uHQi/9I30wfoV3qG+pdgAGsU/5y0YWtRL2DfZ+natCGBtyjf2m/V0Br9FOkpfe1EpyCVVh
	MJ7eCcqQwIC+N9cNgvncIiOWmzl0mHM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XuV8jZMv;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539662;
	b=BL185yADgt7rn5mF+15ZQIgAaAGTfvGSxT7KtyW5QCGTqCpKQRV1RbCnKE8bJWYVIstJ2h
	SfJJvrVdxAkhrkiUKkk6T0VkdeqcmabzVpVThImlLpTGnBBKbYfH7jPY304atUEckaoZO7
	/pkPI6ZQ91h+6clAK5M6GnEx8XlB8d8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B2A160A78;
	Mon, 20 Jul 2026 09:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5391F00A3A;
	Mon, 20 Jul 2026 09:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539662;
	bh=oMdIU9vjdAuXur3wP4WnM9rv00wH5avletuGlMTkduw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XuV8jZMvZxGVHiWywg3YQeXAAxcigg/RKM9NE9u/NkLCc4Onure10tgxmPAwK0eFX
	 wn/b7NMViYPN0XiJF2yXdokNHjZcpVmoJqljTGZBb8kGjV/+zrQczxc15nj3knwdTC
	 3mnDTQMUOYIIGt/OkhUhRxNV3b/kJQYfN3eL9q8pZv3V5TPfCLm+xA1UpTIHAA2WIf
	 O6FGxui/7S08CAyRfhSqIVaT/cUf5rKqhE3VNHmS3nDgU0KKbWb6CKSRv6sMQohlip
	 qTLaZRrVUgSNG7e3ZOUJDkU3AsF9qtnPUixKi2BblxRVYxYwQHUpClZSnveYr2zZBr
	 24OnXRebDjJBw==
Message-ID: <133f3f9a-bd3a-432a-afc7-ccecc57d5099@kernel.org>
Date: Mon, 20 Jul 2026 10:27:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm: mincore: improve mincore_hugetlb()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260717091347.1144789-1-wangkefeng.wang@huawei.com>
 <20260717091347.1144789-6-wangkefeng.wang@huawei.com>
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
In-Reply-To: <20260717091347.1144789-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1547140005
X-Stat-Signature: bj8mjekqqyrzkcufizac7xf5p46ys9w9
X-HE-Tag: 1784539662-107558
X-HE-Meta: U2FsdGVkX19XvU53iVqTJzGnPxceU9cXPfeMhfI6XAETDCf5rUzTkzQrMgaAK0pLRvFjxkTlOJjYJfsb2VpDoxgYyR0c2fRbLz01F1fj65ocKa28b2LiyM83Rz+koFKOUjEl5c8dbeigErviIlw0dGwkZlMsSWI+AASA0aYf+xQJqhpLWroW3npn0HXHTqpLp3L39a1rn2TDeeokO69VJEdbsNltjGUUIhW2o6okN1X28nDBLbONvHskQKrBenAEzeCdPjoFP4gaMYFGT66U4FgOyNOg39YDcvVyMteyKCQtXcrGnu5ZqTOCTPvdJwP6KoXofqM4mxCQ+haRyQvt/L3ohUj1FsAH+28ibdzKg+xD5HaiMtCfaIa5zucEyJ04vz/eRq2NrkV/slui9RZfwYr49PXnAkBfZGmVZmfbDwJKBlsiRFhFL9ztIpQVPSudVQuhYQkYbjbGUnhPHIoRSEpuy0qE9L5kMV/Ya/skOhBEy9LT1m01RzCwF9ZnY1ADuZXuiDZc0vT8rtUWr+Re6GC+i5Z/0GVpB02YHviE/QLT/wIiTufwFcJotO0grGRppfrWHziSnCiLcwnEoQFYZ2lVQNjZBtX/ykYNNBdILeAOxQQwjXj3yguOEU0JmTyRI9FUiH/RMBvSS5ztrwDU+k9Jq7WNmugjTs/+FwR9bQtYjWynhtOPWfTbVmT9U0YUHZ4/zXnW5JAGRPxLKpB3n5M+Vy6YddHTtYIwTGUuMwoyZMhoQ/1826yn3oqy04jFAWbtdxr0t3CMLp9FnjYpcfC3/f/nggpOrMoatbpcXUvjCTQfloFL+xb9jzq2BfF6JYKYK5tyOl8BWb7OncpXhBvCejTY4xanrumtHV0QkiWwfQ2/KhsBBGFTf19lVaUaiUkr9trVKxMl8IxXfkUXU28UCGF+bp9giYib4THpdQOZOxd5J2otfmaqBCi8B8UmHDy4lPj69Q5Mv6g+WMB
 oLEVNNZ6
 tl4uTgv1DjT7yVHst/qb1mJKfdDdv9vEO+Lp4fJiE9s+32tBgRCUHlYkFI28lzOxMpalRmTdginIFPqs8tLVhYY98OIvEHgP5eWCFQyrZ0BsVQLx8wXmSoUaBkCIeiAK9j0Nb+Gx0H/Pyb/QivfvTSIJFc8GePRP7gI0BjgQ9DfPcGx/Ibm05vlJqnoUemNmzE3EhPkEUJMaWStD+EjeerdnezTu1vZ87Cxd2uenEAQyihLiTLyuOfa/FJ5gT9K4ENj7KinEzxbf6SsmHCnky+sYvamUwEXWv0wwjjq9CXpL+VBeUSMoPywbM8HLFwk0djYxbd+ahfb8yxstLk/bU6wGAF0qEs3FzvgSl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 10:13, Kefeng Wang wrote:
> The walk_hugetlb_range() always passes a non-NULL pte, so remove the
> dead NULL check. Replace the per-page iteration loop with memset()
> for better performance.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index ba7d1fc320a3..e825d11a7c7e 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -28,30 +28,17 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
>  			unsigned long end, struct mm_walk *walk)
>  {
>  #ifdef CONFIG_HUGETLB_PAGE
> -	unsigned char present;
> +	unsigned long nr = (end - addr) >> PAGE_SHIFT;

Can be const.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

