Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC2B60A262A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jQBBi8sk
Received: by kanga.kvack.org (Postfix)
	id 7647C6B05C9; Thu, 12 Nov 2026 04:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715866B05CA; Thu, 12 Nov 2026 04:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604CB6B05CB; Thu, 12 Nov 2026 04:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 301F26B05C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:04:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28A731C3CFF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:04:41 +0000 (UTC)
X-FDA: 85425881562.01.0D8F22E
Received: from mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
	by imf31.hostedemail.com (Postfix) with ESMTP id 054EF20002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:04:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQBBi8sk;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.24 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474279;
	b=q1nDMjeKklVdcT02qpS9wI+czrhpO0RYKtCf5cObpZDCZhr/Kh5zwjbM81FKFA+6A+X8OF
	uDH5CG4XoluZP9ytV9lhs6Z2kALO5E0xotd4XtozCksplYpY/yPKQJti7fT4M35AK3yzEY
	6Aa3HwvfQP+NaHQguMiI2KyWLtPUvE0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQBBi8sk;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.24 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QXd43+9YkcDdqXRXfijDPFLngipxJU07bnf2rvgj7k=;
	b=JYMv7w8cRJ1pai4qqAUmeB1p6V5H5s6XMk8XMSy1JF5zHPFRmikW4LAuzl8gJnOILe/I4r
	7EFE7OPSUcwLpEQr2iqi4PM99VAX0tRzdTaLJaD85DMjjAjEH2kpkG14evuoAZWrXbn4E2
	qI8+l4WTnMjbH36zbf4i+fToRkwqTog=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8Qf+LHzFQU7sWVDR2P/LLaDSEFd56f41ktqAEc9o61g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794474277; v=1; x=1795079077;
 b=jQBBi8skxsUmEGg7hgwl5JSxXg48EUwvnKFRaYkIg+/x+bn6PT2Qf94ueriElqvJRdjbGXL+
 wAX1gW4SAtXCwlINFhQQPaa269TqOTKCTLqthogsTDg00QhNrVzKBeJpwWIfrwVQksUNfQGsuSt
 AHo7FxKOYP5lSWWFzv9ZK1Xw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8b0e325b35ab9706;
	Thu, 12 Nov 2026 09:04:37 +0000
X-Mizu-Trace-ID: 8b0e325b35ab9706
X-Migadu-Flow: FLOW_OUT
Message-ID: <cc8c4c79-e7b4-46f7-b8a2-b5564b3cc85a@linux.dev>
Date: Thu, 12 Nov 2026 17:04:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
 <80FED512-77D2-4D49-BAE5-745CE1F711CA@linux.dev>
 <1116fd15-a927-4f6e-a0ab-084bc36a90aa@linux.dev>
 <ceb2ef49-69e8-425c-9582-ba6fb872e0cf@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <ceb2ef49-69e8-425c-9582-ba6fb872e0cf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hrizus8w9gwn9i87twsq1dz3fuu584mg
X-Rspamd-Queue-Id: 054EF20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794474278-5391
X-HE-Meta: U2FsdGVkX1+SY5cbBFguYVxyVbg4hppF/5js7V+CWeVrbMEzkhDcKDaKisjAXNQswjaiM+ZIXgqnp2UTGtD0YZKyN2rJcQyn+Bmye7+mZD84qRghF/GVRvG+AJUeKPntaUTk5WoWFSlA5DbiYOyXUN7r3lcs7cffSgYNTsTaZ152JMXsl70I8eSJiR6ua1m8wdshZjgl3pmO/lageKtoCmEso6h573SsGVR8ExN2dQRG0RA3osdV5fpMvoD4smp9hYJ95etn/dC52YQDKh79lcuId2gTltd/y2NuWZHWUmqF9317QEXIKOsUSFzMmMENO3NQ+X7Q9abfSniua2t7gP1ll5SeZ+AgKRoPROrHiRjq5Aw2VOA5gc4+rTQXzhFFHta6uza78Vnjux8y+H+0TEoO8C3M4T8yS//vS+eWugKwQsJ3GCHO0ldqv9jGQjV2ZSmPuZc+8CDcI72JRhNQkQbAO7oAQ/p5/ZdweOXwCP7PUPXFq2ATZjzHmhFAvGwHvJjPgLUmihx4Z53f6sZckLC9GF1kvBrHpnyhZXrl61mFm3lplc1gcVgTgUGmKcNDpS16m6dF+rd44CH2H11bUL9Ia1Xcydf2OePqFoTK2ctOoZZ+B/pjDgCYtLtGQ9QHb+gj34qt81iMfmlaxme8K6F00hgst51n0/yWEwkkR3MPelRh3PRWAKngaWOIFf18n+hV7ySItVJtdrmiBHMEgkeY2m/BM0TFy8eXlILC9URIrRsMuAI8n+C9l32fzizkYxiX85dkVf2LQqLNb5w1B53m72tc0voMTX2vuwHuxDhv8Pn3cskqIAVmDFgX8GizFFrbo6AckNLGEYcP3X2AbDdeta4qCQZAJx5enDyb1I9QwQrW88cyO0Wv7lA4EapY7WsVB/1qRH+tVAIGI3jr2Rq47n6boiGy24xyH71i8qkv+SoJOU/rvGJKVyHv7Z9P+v5g9W4V/aV0y8Ubtpo
 GgtqpgxO
 6yVrPsinMWKmisi33LsBp9rODQkrPdHs5clOEThWpAEziPpWEZzYMvB+vZR9a1nJdFMlRwXLgjgrzd1zldyPyhl55L+E/dtOl+ccmKWZkmXbO42sEgH018DmQEsWTDfCyMmkNZx07je3pLcqDfsDaQSDzO29bEeu4ePL5Pk3R38zY4fq8zFchYMnLSaX2hRWzQDn8CIQXhl2peaOd5cH4rDHsuu4pRKGbfwcAaF9oxaR2X1iEOLFMVw6TZKpK2BPkBa35xBV4ZmrHvvFMUvdL4xqdyrvTbVeKtAkBQW8FbRiDP75AH16DOzaXP40F/M1QPRmLcz4dg/I23gg87DWhD2CfHu7rIoE50Rk4FKS/IVPCZ2pjOVx1YN8HOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 4:49 PM, David Hildenbrand (Arm) wrote:
> On 11/12/26 07:13, Qi Zheng wrote:
>>
>>
>> On 11/11/26 3:42 PM, Muchun Song wrote:
>>>
>>>
>>>>
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>>>> unpinnable, causing unnecessary migration or pinning failures.
>>>>
>>>> These folios already own their CMA bitmap ranges, and memory blocks
>>>
>>> Commit message needs updating to bitmap as well.
>>
>> Will do.
>>
>>>
>>>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>>>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>>>
>>>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages
>>>> using cma")
>>>> Cc: stable@vger.kernel.org
>>>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> Acked-by: Muchun Song <muchun.song@linux.dev>
>>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>>>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>>>> ---
>>>> include/linux/mm.h | 29 +----------------------------
>>>> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>>>> 2 files changed, 32 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index b0da9be413098..47d1d96bfc7fd 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -2954,35 +2954,8 @@ static inline bool is_zero_folio(const struct folio
>>>> *folio)
>>>>      return is_zero_page(&folio->page);
>>>> }
>>>>
>>>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>>>> #ifdef CONFIG_MIGRATION
>>>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>>>
>>> I think David prefer to move this function first, then fix it in a separate
>>> patch,
>>> right?
>>
>> Hi David, is this what you mean? If so, I will split it into two patches
>> for the v5.
> 
> Let's try something that is more future-directed: cma should deal with
> cma details. In the future we might implement something reasonable there.

Aha, that does make more sense. Will do.

Thanks,
Qi

> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1a..d829fd0355bae 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -21,6 +21,9 @@
>   #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
>   
>   struct cma;
> +struct folio;
> +
> +bool cma_folio_is_longterm_pinnable(struct folio *folio);
>   
>   extern unsigned long totalcma_pages;
>   extern phys_addr_t cma_get_base(const struct cma *cma);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6af3b7008f1ad..5392e225cab9b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3,6 +3,7 @@
>   #define _LINUX_MM_H
>   
>   #include <linux/args.h>
> +#include <linux/cma.h>
>   #include <linux/errno.h>
>   #include <linux/mmdebug.h>
>   #include <linux/gfp.h>
> @@ -2975,7 +2976,10 @@ static inline bool is_zero_folio(const struct folio *folio)
>   	return is_zero_page(&folio->page);
>   }
>   
> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
> +/*
> + * MIGRATE_CMA and ZONE_MOVABLE folios cannot normally be long-term pinned.
> + * CMA may allow pinning folios explicitly allocated from its areas.
> + */
>   #ifdef CONFIG_MIGRATION
>   static inline bool folio_is_longterm_pinnable(struct folio *folio)
>   {
> @@ -2983,7 +2987,7 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
>   	int mt = folio_migratetype(folio);
>   
>   	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
> -		return false;
> +		return cma_folio_is_longterm_pinnable(folio);
>   #endif
>   	/* The zero page can be "pinned" but gets special handling. */
>   	if (is_zero_folio(folio))
> diff --git a/mm/cma.c b/mm/cma.c
> index 9ec1d1fd5dff5..b3bf0014a90f5 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -27,6 +27,7 @@
>   #include <linux/log2.h>
>   #include <linux/cma.h>
>   #include <linux/highmem.h>
> +#include <linux/hugetlb.h>
>   #include <linux/io.h>
>   #include <linux/kmemleak.h>
>   #include <trace/events/cma.h>
> @@ -38,6 +39,16 @@
>   struct cma cma_areas[MAX_CMA_AREAS];
>   unsigned int cma_area_count;
>   
> +bool cma_folio_is_longterm_pinnable(struct folio *folio)
> +{
> +	/*
> +	 * Explicitly allocated CMA folios own their bitmap ranges and can be
> +	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
> +	 * For now, only HugeTLB tracks these allocations with a folio flag.
> +	 */
> +	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
> +}
> +
>   phys_addr_t cma_get_base(const struct cma *cma)
>   {
>   	WARN_ON_ONCE(cma->nranges != 1);


