Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C127CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1290E6B008A; Fri, 19 Jun 2026 10:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100EA6B008C; Fri, 19 Jun 2026 10:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D5A6B0092; Fri, 19 Jun 2026 10:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C35096B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:04:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEE591A049A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:04:50 +0000 (UTC)
X-FDA: 84896833140.26.BF23649
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8950C0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:04:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZO0hMlY;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781877888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcXYQhPIRFsQtxUPChITDbxpiAkS/ucijCaXlahVxJU=;
	b=jDgchyoOoPFj2/6PgswZegcreRpUy+ZRiASO4FH+a1qUVVB25aYTeo2vmkgbOkUF9UowPQ
	simWEBA1nkNyIvei0zVOR9KmleWFr4fxw5eaZW87/eGp4/r8Ati+EJyQ0dTwMrtVxJH+rT
	1poNUDYCoHoXsk5AVCLQRqSbdo0ks4U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781877888;
	b=7ThLWSdRuJp9siBUfHrIg5B7FN8SVEGiMtYgXilHHbmTW00vHQ72xRL11GJA3fwIdRqrvM
	icTFUwX+8PIhZhsZTHOOexfkJSSiCrrVeEgkEvk64x9Hqb6RIwn2z9gW5cWtgZbUkGMIbQ
	tV+sXwQCryq9ubDfh34PSMgqJSeJWx8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZO0hMlY;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AF08601E1;
	Fri, 19 Jun 2026 14:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87C81F000E9;
	Fri, 19 Jun 2026 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781877888;
	bh=zcXYQhPIRFsQtxUPChITDbxpiAkS/ucijCaXlahVxJU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cZO0hMlYPjRn74q3/5UhL0uaKXK1oDX4WSNG8e0fBbv1apYbE+V6fIaeMVhCxQBAx
	 9O05eJiKDj7rOPMyRdVUJPxh+ZQofxNsSsPqe5Jfm8qdfXXX/42wxZxEHjrqGG7uQL
	 9SjVaGzwFeuheeZCY2vjMPB1EqpZpFj72jUnmMFdSMYJpL43WDWnqFRAVQwnlh3DKc
	 j3SD3ih2MMHUIPhSyvtUrVePVAs8SzOMoXSAr7r1ZD3itN5MNRtVLBfHXIU4mb87Ac
	 USD8XcwzsJE0adC3eUUvZ4a2byylWYU9L+3GUDN7p67shS/id3zd6wuQCOzQCSYL+q
	 2VmJy9J8pYP8g==
Message-ID: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
Date: Fri, 19 Jun 2026 16:04:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
References: <20260618221720.71768-1-baohua@kernel.org>
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
In-Reply-To: <20260618221720.71768-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8950C0005
X-Stat-Signature: rx7oyn1a5idg1afa8gj5jk87u43dwiy6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781877888-215401
X-HE-Meta: U2FsdGVkX1/T4poVk/pI2fZvKkQZC3d0Og2Xntw4HcHX31wfTEWl3i7aOe5LAN19UEW0c+a40QAnAgOioSCWFGUaou38nqVzIl/ZE2fADcY6rkkecGkfuHP7Q6zB6wnvF3VvwXLvZQIa3HIagCbZPe52OxP2wqqrhDqJzuL58ctMOCGIR7PpVIIQ4eFkM+cj9CGMS33pEQ9VW9IPBBnIikF4q+MoA/sNKlUEuXvLaLzNGuBRJirGpXFz299++B/vCtSOHk6PDTkYsbp2U0ENKYirbQzk4NOUiqA0p+T8zCo5wH7iF/SEptVFNlQXkDHG7D4SrhnWo8n0nLXaX/3/u+6Ws9Svs4b4tYb3wEtQZzUilkD9+trPmaa3znJ8P7nLLk65EtvBfVxDqbk7mf9NTLOHTT84ed/dOSfkcb7+sLt463UQYWPrqRVKwH+ZV55oIQRWNTdiPH+6G8pcox0Tiho/atdoPErB1HYO9GmNc5/Sj6oSLCEBnRHiCn6EklKf+iAR8kIMWSuuqrTXaU2An7/bUgDPWI+rBGc8rH7LzHnQF2S5t0neG9stRz/e2BGw8NGeYjoLLGOhfJJ56ikM6cHGYjoVrnevCIOHfvQ7GRWLgep358gPZsydP4kPo3X6x3gxveWPDHxN1RjuAvhv/W/agnTzz5AksfR014RWt3OVUW29+pM9ZhEVZjuIvE5SV54IRWdMgM51Snim86WSxqyjJvsOsF0ntmbm9Qt49CJvdqk4rktPnZ8komdijd3oxawpX7NAPK4I9nmy03hb6CuZLfzZlC+7vbDMmm+nsP/fijKitbq8vkcWmu4h2ff70Kj6Ew3GTM2qk8FnMf4lwDhBTFyR25/LPcM0t3yzs9gVm/yggxVZji/0rvNC++3x1DN0sia8TM6s4PxER6boepf6pQwdzIo6qT0J3ykN6dFtD+aoSGH7ap6XdCW0ipVMOJf3tAm9iwJJicRX/Tz
 msK+EmJ9
 LSPAJWMN2z9SiuD7gpfmI7NjSml3T+nhiRDTIqxIhmBTRPN97wuOjlcOMtJCo0lMC60f/lSVbeAi+8g+bOMFVEvvbUwbQcNBUn2hKouJYhZ+6SMRmOUif1ChekB72xrHZhOBI4WOl/KY7jKPnwAUfsx2x9nU/6vbcqXYB/WDBmBk/EhJjQBaRaOi/exaPiVOsoRnKG/KQjKp9Rq6GggTye8tfl9oVQ8XfuYpGrN9OrrqT5fVRumQsM1YkqFSgv6lcmu4nulaoKN2AgIRhq3+RpHosl8N6/5OvqlyhEmbCJ+zSgwq60amrWPBHb75qlVimJ2CFdPcjrFnADQeHMt6hCWFQ/LPnecfThQkbKC9DXbBvfdZNXKJPDwophHZ3J450yjkgVH5Tnwan50IiIM01n8UJP7Agfg+W8t2KpwzBaBvBTREPW60Bfw0ephkyqsEY5+xm81Cw+YekvuGKo4wMoYwgKfTAI9Cyc651jAwPq9W1l2pN+vg1gwePlxoclsLBWB/wKrCBOJfNiMZc4p2qQHQlw59gLkzoYDHG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 00:17, Barry Song (Xiaomi) wrote:
> When swap is disabled or exhausted, swap slot allocation
> may fail during swapout, causing large folios to be split
> into small folios. The splitting is reasonable when we
> truly fail to obtain contiguous swap slots, but it is
> pointless in the no-space case.
> 
> A simple way to reproduce this is to invoke MADV_PAGEOUT on
> a system with mTHP enabled but without swap configured.
> 
>  #define SIZE (16 * 1024 * 1024)
>  int main(void)
>  {
>          char *buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
>                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>          memset(buf, 1, SIZE);
>          madvise(buf, SIZE, MADV_PAGEOUT);
>          munmap(buf, SIZE);
>          return 0;
>  }
> 
> With 16KB mTHP enabled, we observe:
> ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> 1024
> 
> This patch checks swap space before splitting. If there is
> no available space, it skips splitting. After the patch, we
> observe:
> ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> 0
> 
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 299b5d9e8836..33f84a5fe7ee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -339,8 +339,7 @@ static bool can_demote(int nid, struct scan_control *sc,
>  	return !nodes_empty(allowed_mask);
>  }
>  
> -static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> -					  int nid,
> +static inline bool __can_reclaim_anon_pages(struct mem_cgroup *memcg,
>  					  struct scan_control *sc)
>  {
>  	if (memcg == NULL) {
> @@ -356,6 +355,16 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
>  			return true;
>  	}
>  
> +	return false;
> +}
> +
> +static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> +					  int nid,
> +					  struct scan_control *sc)
> +{
> +	if (__can_reclaim_anon_pages(memcg, sc))
> +		return true;
> +
>  	/*
>  	 * The page can not be swapped.
>  	 *
> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  
>  				if (!folio_test_large(folio))
>  					goto activate_locked_split;
> +				if (!__can_reclaim_anon_pages(memcg, sc))
> +					goto activate_locked_split;

Why are we even trying to allocate swap space if we cannot reclaim such pages?
Makes we wonder whether we would want to have that check earlier, before the
folio_alloc_swap().

Any downsides?

-- 
Cheers,

David

