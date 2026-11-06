Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFC4606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=USsy+meQ
Received: by kanga.kvack.org (Postfix)
	id CBDA86B05B1; Thu,  5 Nov 2026 21:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A886B05B2; Thu,  5 Nov 2026 21:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B818D6B05B5; Thu,  5 Nov 2026 21:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3226B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:48:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F04D8C08AF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:48:38 +0000 (UTC)
X-FDA: 85403161116.06.9B5D1E2
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF50B180007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:48:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=USsy+meQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fxf58g0TgGhF1yT/rrtFZDRdTjLoj8v89GwaFQtO71M=;
	b=eUMXiaG32ArK1DUIYhn/KqfyBjIWfAqbVJ2L2p6zdDGKlcpXY8weIMwsCk8g0sejIjF9mZ
	iTLSMmKAP8+IGi1bHOH/5nNBJJkIDPKZZvndKox1oloyZqdU3J1G9cAm3HZIdWdcFX84ae
	R0cz9+pzUIl21ARCFFkwn5rTTxNOl6k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=USsy+meQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933317;
	b=x5dwaKC+yfKZW+2c55V+TmCXJC+k0x5whAyqJbS40KKjdXvmv+1HyJ4AnncLj1kZYLmCS7
	en52vhp6dvbZHg6XK6NIjjcSn8qXnXRUksVWSmu5/CJA7JVXsXbj6hiHA8LAWBwB3XK0du
	pYyeYqyIdNvEaCxAelwrrrsAD6+1GaA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SM3myxb12+rHgjUddvdUVXaCWkzw2vEprAopNzsf1mo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793933312; v=1; x=1794538112;
 b=USsy+meQGGymywHJIcKkg07aAROaLc67sdGjL7oZM5jmiUVtHMGmQkqKJpAxcA19JJQmWvwk
 Id6LO1M9Te+e3vOZg4E0sjblxYIX3ELkJFktAtgwWPvOU0eLsrbTNgezndKS35PwE+2iJBd7SkE
 +ZzLz4bwf1DG/c4F4RJOzwFY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 63fa14448a3d1f35;
	Fri, 06 Nov 2026 02:48:32 +0000
X-Mizu-Trace-ID: 63fa14448a3d1f35
X-Migadu-Flow: FLOW_OUT
Message-ID: <39b7ecd4-e5a1-48d9-8d34-4bf8f8ad4ca2@linux.dev>
Date: Fri, 6 Nov 2026 10:48:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org, azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
 <8F5F930D-A05E-4255-8E70-2567921A92A0@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <8F5F930D-A05E-4255-8E70-2567921A92A0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AF50B180007
X-Stat-Signature: d163ro8xzpx79po4ubc8z37usegdgkz6
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793933316-321285
X-HE-Meta: U2FsdGVkX1+M9ulmRnb5/zECbA22ruu45x9cbCWk4+c+yadJ7PkPz/HvmAeHt/cwf4Zz35m8Ak0BXRWSefsUzYRQpYcZgZCKekzHqJZMI9m4VtOHAcwnn74U6LHrtXUud2HZMfYl7UzJAsZkmy7F0YKlkF84mIpMNGOy34e0/6GQwVXerOKZimD38klzF8GnUiWUQ2sxo/40wYWPrHpaHle5dayX+wq/k1uXt9TFGwzl9E5yviILtarAVXYquUzaed6rze2Zt/yCYY8FW/zT/22Lez4R8jtUJ4U6iP0f2izux98fle4PWgnLIOah75HooyXKVqf3nF3ZpNzVcUzKWWZtjrzAxIL2nfvKliJ+hpcA3bCsg1PVdAbyfAcRBr0L2T/U9fmB7P3A3pfChHuUUAuG71aL3XmWbirFwftaXkKcs2PHOxRZ4fs+Kqoac0dbiHRnkGK9qO9K1vANRSyNliolt2rEHbZn0UDCG+mQDM/A+Wn8My/L9pcQRbTtpJWzi0YBonBytOxO1/VyhhJyTEkHsGfzYZ31NoM9i/JXUuBaVZpPwNKCqAWlOaNO/QvDMygpCx0fZ+29oaR9BGloGgsvmqd3DtypysKeq35FPs4HCiYkKOr6jyppt/iAd4DDWLBkAE4bcA76l+Qs2eZ48I+dkZ/5q8/rIuxDUmLeNsVIdr2LnV6UCIIeoCmmSm0tpJipw3pYTOPd5vM1I4wW0vIdrBaNhTL6UXObt468iwss5K6d54lcq42yOPrxuQkB7GE6zPqJ6XzQrnZWqh0JYBxnCT9uVNL4LKlhw89kxV1cStYodCKScN+t5Lnkg2x5hkieRkGNF0sP0pcHiIgWa2menpNe8J0uzXxTzUZZm60iG5/V9WOzgP6/6GLDxh+W6CHkFm6+O3e9T4OCNYUbln50gV1ciHc5c81N5e4fJn8pqnAmEByMB0k/XXlK286cmrkPlvrcXKgOLuoy1et
 w/VhNHe3
 Sg3SJB6EC+bRPTKYBTIrm/8bP2hY+UCbX/vz5LjGK83Q51Cz8qHnL7xb/q/Up/UO14q6Wv02a7KRxvbx4n41EYXVCCld/wiZmTs5Zf0KgqW2g+y7W18ZmHZGCpp8ui0hESVeeFIbZqk8TuHln7RS2qUesTlr45BfY8AzZMGKd+A0icDi08SC8Vdt2JD5XolM1+HV1lKEXEiW7I2Hjd1TbRV6siCGk20tlb4KfEdyLB6U28N2MID/e7/JvEnU0v4Mj4x6xnQVZfQ4EQDW9RzZyHAith0x2ojQIlSSBNPsKwJbJ45VYcOrkCNg0dqqOQ8m/DqCS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 1:13 PM, Muchun Song wrote:
> 
> 
>> On Nov 5, 2026, at 12:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>> unpinnable, causing unnecessary migration or pinning failures.
>>
>> These folios already own their CMA bitmap ranges, and memory blocks
>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>
>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

> 
> But a nit bellow.
> 
>> ---
>> include/linux/mm.h | 29 +----------------------------
>> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>> 2 files changed, 32 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 2d0b8a4c9974f..75dd40265d3f4 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct folio *folio)
>> 	return is_zero_page(&folio->page);
>> }
>>
>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>> #ifdef CONFIG_MIGRATION
>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
>> -{
>> -#ifdef CONFIG_CMA
>> -	int mt = folio_migratetype(folio);
>> -
>> -	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>> -		return false;
>> -#endif
>> -	/* The zero page can be "pinned" but gets special handling. */
>> -	if (is_zero_folio(folio))
>> -		return true;
>> -
>> -	/* Coherent device memory must always allow eviction. */
>> -	if (folio_is_device_coherent(folio))
>> -		return false;
>> -
>> -	/*
>> -	 * Filesystems can only tolerate transient delays to truncate and
>> -	 * hole-punch operations
>> -	 */
>> -	if (folio_is_fsdax(folio))
>> -		return false;
>> -
>> -	/* Otherwise, non-movable zone folios can be pinned. */
>> -	return !folio_is_zone_movable(folio);
>> -
>> -}
>> +bool folio_is_longterm_pinnable(struct folio *folio);
>> #else
>> static inline bool folio_is_longterm_pinnable(struct folio *folio)
>> {
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 2b405cce2ca5c..e8503141bb275 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
>>
>> #ifdef CONFIG_MIGRATION
>>
>> +bool folio_is_longterm_pinnable(struct folio *folio)
>> +{
>> +#ifdef CONFIG_CMA
>> +	int mt = folio_migratetype(folio);
>> +
>> +	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */
> 
> The description of "bitmap ranges" is weird, making me think what's the meaning of
> bitmap. Please use more generic description here.

How about this:

/* These HugeTLB folios own the CMA memory, so they can be long-term 
pinned. */

Thanks,
Qi

