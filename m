Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99173C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF8B6B0098; Mon,  7 Sep 2026 07:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80206B009B; Mon,  7 Sep 2026 07:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9967D6B009E; Mon,  7 Sep 2026 07:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71C8C6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:51:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFF1FC0133
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:51:27 +0000 (UTC)
X-FDA: 85186801014.10.4529B30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A22E120009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:51:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHSF+NiD;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788781886;
	b=hxgAwQ7pQkZQOgZTJy/IWNsTjNnQp68ax3FlLrWeDtf7+/3FSd6bgZWaD1JweRyNBnyOyE
	Phr0YpFKoJTQ/EzV4ZvrgX4JrZ094Wekp/EVNTxSkBz4wubXb2qC5tZ+EKlpDR/uaAFP3s
	QqKaAIARDVaPmTjcCFJWJMutyscCvdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788781886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+aPhc/SqhJ7JSMC3ivXbbYiLBKgxE4zPMSB4aVyP+8=;
	b=oA53n9l7IpgVqbct2/U5dpGesw/Zi+H5/9WcgAsRJpacavvwg1HsHk+ZaGEDubIHZhReND
	HE/uXYocBQggFWQPV/QVd16fq86eUAaKGXr3iqxWVKpQ87fNzAa7shrpGJIiW8RMhRAIbC
	mqgetb55Z5K3lwyJiOMdd+DaTpI3OxQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHSF+NiD;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D0434167E;
	Mon,  7 Sep 2026 11:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96911F00A3A;
	Mon,  7 Sep 2026 11:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781885;
	bh=y+aPhc/SqhJ7JSMC3ivXbbYiLBKgxE4zPMSB4aVyP+8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nHSF+NiD6uq7sSUj9YDZ36amjTyArKCHbqydgbhqrn7tOJpTXs1l04YLotUgTb0hO
	 Ckhkl66Bqh9dJutppBBoVi6eA3IkONRUlRoOJapdpZtJorG5PFfwnggyU1u2W9rrgk
	 CjkjBiP2I4Gp88q43O04If5BhwBZHoM9abcQpRSON/ZRVxLrmgLOub7baaxvz4NFmN
	 MSJnNgxhU7iUwBAhlBuhsiBQWwMUFGCxLAl278BiyIa9q6EEfB69LerlaLQn4AFN/E
	 KDG/V7ZSYcJq8MSe9RW3Z0SDC4pGGZC0XjkvhVzirwdNcy4JbYjiXqWkFq3ecDCUTi
	 ISujGXYthbxPA==
Message-ID: <5930324d-8252-42e1-ad50-aab796e41550@kernel.org>
Date: Mon, 7 Sep 2026 13:51:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net> <aprjOxDy3JCPb2oa@gremlin>
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
In-Reply-To: <aprjOxDy3JCPb2oa@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A22E120009
X-Stat-Signature: 8swk1wc3jomcthbtyisrdupg45u9sdb8
X-HE-Tag: 1788781886-41562
X-HE-Meta: U2FsdGVkX1+OVYonrI/l+gavwaTC2AnEiIEWzkqDps/WOPFt35q0KeD3riPbYIdjc6d4X0yhy2OJ4DSBX0Y+OLne6k1enLczZAqjr4f2am77GwE6+6pK2DUOPMEW6F4mXP80PLtQ3eZtuzO9/7gBTA9Ys8AjrghjuM0Sh8/LO5X7KV/ZRw50zgi+prvaU5DY4vO7SUn+A87gRf2z74cx9ZiRm+smoYzEz0pgbLlhfxOXqdxbT1F1uOEmXgcJFopaFSTby/nyIXtIkyTdl0h7mZq7ac/uf88bOpS8X3bR72+vLBv1xBeSvNVHJamPFK2V3yikEys4HkGCie5hfVIs0eikDoTD4OmcD4XG/2JFJktQVf78YhKUegiiiTB8WgwrSc+Z2aeyx2ZhFkSjnvS6krgIpWa/eXzIk4rLT8bcOKFO8Kh2IfHXxm6ZNR/ON765EQVmL9UUY+qoad++04Dur4TgxULys+cFgm3fLKp8aGkzlJDpqhP2+E/3eDyWq0MyY9+6fcaOZiB+1lk7k6NAHpsjs7QRnUSKZrKXRFjA4069mo3vEpardFfydbz4f0EU4z9Q1aZlQCPKw2Iq4fq2ZIQXg0GtLbRzNXO9+Qr2Q8tsa8ImZor8ekcIsxXbW8Wguc79hcvS4kxUPLtehR3H/8/QFME9sC+4nQcIBPQf9AYdc6hqe/HOYbjn21BMJcwFfwq5GEDuUKkKUojdnMm8vR0Se3A44IcHpyXWSyat7F+kuIjgQ5kiWv14HNgbkon2j2M3WJNqc57Gro7qnTanX8wumybDXTDJU/Pd2EwHoaMD2afaQeLkbUOEaY1EpuM6Tte9fM6y1ONSNZHty7d8FTh7+krxlS5fKY+Lfii0R1PwYEiA/bnPi74eRdkW7jytMBkAO32Jdu0wszdbV+3521NGCGy9Di1V/A0M8/4EBmT53rIeSHmX3d9w7vhbJNBzfYyn/N6LKmVu/9hIO67
 XLxyitJd
 KJQkUe1byhdNTvvN1WOpSoyze0PCHOj01/JPeiTH0plCGe8cDC/oi0KoTM1CYCaGEML15ZpnVaugYGES1jHc3Gg6rjsyYkfrtdbTrzIdPzWJ0MS+CGwtSrHY7ATqc/a/JG53HKCohypHjkioT0gAmEO0O4suzUz0dWSdQSiF2esWdL56fPUNIi7TGmc4kXP/VsidRpU19iW3KcxiGpGGPyk+V+vm0wR8iOAGxpwSx+M+infagvV26xuDJSblh+ohp0iiOwYB88WoDyLE7Iu0uzpkyYwy+mobgfi393lficTrq3gePthCSiN5RVLT84i2Pjq8BuZPWUofeFIMpAWNt38py/z/JgPbyFchw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> And it's a real improvement to have unfaulted anon skip...
> 
> But I find that version is documenting what's going on a lot less.
> 
> Since both anon and MAP_PRIVATE file-backed are CoW mappings we could just
> reference that.
> 
> Andrew - could you swap the patch out in-place with below? Thanks!

A proper v2 would have been nice ;)

(and would trigger sashiko and friends properly)

> 
> Cheers, Lorenzo
> 
> ----8<----
> From a706374a1186b6b4409a0e760e8728bcadba0c96 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Date: Thu, 3 Sep 2026 20:08:39 +0100
> Subject: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
>  MADV_WILLNEED
> 
> Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> for the former and a tree walk and swap in to swap cache for the latter.
> 
> MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> as if they were purely file-backed, meaning any swapped out private pages
> remain swapped out.
> 
> Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> mappings and performing both walks in this case.
> 
> Since the logic checks for vma->anon_vma this means un-CoW'd
> MAP_PRIVATE-file backed mappings retain only the single file walk.
> 
> Reported-by: Mike Kaplinskiy <mike@recall.ai>
> Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/madvise.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 73c2901b9adb..963337f93a7a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -297,11 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
>  	loff_t offset;
> 
>  #ifdef CONFIG_SWAP
> -	if (!file) {
> +	if (vma_is_cow_mapping(vma) && vma->anon_vma) {
>  		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
>  		lru_add_drain(); /* Push any new pages onto the LRU now */
> -		return 0;
>  	}
> +	if (!file)
> +		return 0;
> 
LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

