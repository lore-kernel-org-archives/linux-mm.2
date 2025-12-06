Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31420D3ABC7
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 00:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761856B00B8; Fri,  5 Dec 2025 19:25:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712226B00B9; Fri,  5 Dec 2025 19:25:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627956B00BB; Fri,  5 Dec 2025 19:25:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 526AD6B00B8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:25:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0168813AAAD
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:25:18 +0000 (UTC)
X-FDA: 84187151958.22.0B8FA24
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9B1D100008
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:25:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TFsXA+Va;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764980717; a=rsa-sha256;
	cv=none;
	b=Bbx8rFab8vPdkl0HGRWl0L/+DI3DKkY0TN+a4otpAJxvdV5A+Zzmde9bFmu5tEAiBKuKz5
	7rpftzq+5CABWGTLoKiRhgXavsr7RUIEWUb94OQDzCz6b5nDVmDdbCMLcrYO5ObRlhU0XP
	/aBRm8ZuapLZEwLJ41BnFHuTwXDvj6Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TFsXA+Va;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764980717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Are7xGB9aLuDwLpzYAyGdd0D/mGvP/om3sIgmOgR1cQ=;
	b=zbbOqrs8dG7XQX9BZ66o56opdqqoBKiIXxH8dQARP/pfHFgqLxlPz3o9u9LgPtLtk6hWE6
	AV7KTgdV98OWsYhCNrF6T788M6eWHpnjfM5sda1Q9yz/jKmQzWp3HA+QGPCumdATVqQp1b
	z+gRzlwiJp7OUlLNpNRcKTvS/qnSu0k=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so30313815e9.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 16:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764980715; x=1765585515; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Are7xGB9aLuDwLpzYAyGdd0D/mGvP/om3sIgmOgR1cQ=;
        b=TFsXA+VaSMsHCSHtGdW8mru3u4ePKMT37IhXV5fG03CPZFVPqCZoy36I1i62vEldmG
         rFJtG45yIslyEhuA2JTGKH+cQeafCi73azyyhzEL0QqqVcorCD04fnS6uHTXKZ7196p8
         an+7fsRBzreNuNsnhCvjcxUe0CeLoPI18sJPPJk4vod+NwpNRjh3GYjFP5t6Xf25PDBt
         e1ibujaKPfmMP2S6/qoH3F6gV0ONhR02jOnjU2KzJlxXJMtuqqMTNLIGPS6yijg/Cnuj
         AnBu0RQHvbkZTgC2YEPxiQElxJ5UPNNFsAxEeCva9yEV9utOpiNPZ/OgyHDjpju/OZ+B
         kL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980715; x=1765585515;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Are7xGB9aLuDwLpzYAyGdd0D/mGvP/om3sIgmOgR1cQ=;
        b=SuVZEhTns8eD5BnrD5sNkhHKg/alROQpye1q8vW256RZk5rrsyPIiNN9eXnEdxq79i
         RX8Rq6wWzkXbxTG+UlLJXJJhSiv579yXgBHdM+yOHkkELsMUZ61/CanhztbdVq+pLbOL
         21PgCG7OoKw9vVoToBWw2Un9l11TI+6hjJDgBv2g8T6aK9XY6XAlLks4Hkn2JTGW/o6I
         fbHZKMMw7vYY3Uf619UfKWUdYnvvSkT9FRrSsRKlT5ATQLtReXjT/Q5wpdbfMCFHrcMQ
         sC7Os9GuY/AwSmtn3hKbLUUNE82bzkjHjjjSdLoEKueg0BvPAsLAGMItx4fPtAYVSJpY
         8wew==
X-Forwarded-Encrypted: i=1; AJvYcCXLDnVvT73TEj4kVp1szliUulEarFGeO25sd1KtHgqqpCNyOrwnqfoHX1evsbEgQmhWj4yLPXaZ8Q==@kvack.org
X-Gm-Message-State: AOJu0YxoStL/vTDaSHzM++Ymp+UjWvp9zANhZMB/e8Uj362KaijO6/CK
	xFMSKMZeYC9ZcHIbb8vNs9sJeF3rz0oBe1+aa9mPyFT+gyX0RY1nkco+
X-Gm-Gg: ASbGncv7hsgh+/TYEIPVOb25NlhQOGZblrbWrnQObFTWwvO8pvWM4u4rYEBEq20f6b0
	zZHE7aZcKEUTQuRwe/K0bctx2c6QOFqGbbXBEwlEfcp8JIhc4gkHCz4g4y6Dldd3602TRRx3Y0k
	QliXbc4wQOXmVZJYcMgx8BwYib1hQ2O3vQvo1cOesQfUbPR8pZNkPpdpEgzxevt+ZPUqEqffZvL
	9fYx7brZQVbQvSv3oOdltKsll6aEzvQbqIBPELc0fv6VY4gqhQG42kJp37jQpdDZtv7luBht/ks
	ODr28svSa6ygFzztNiGT3fQPp9V2eRwsFf3VPPhobaC3pVNYzHvMKuImMh8vJaK9Ww8VG9UcYYb
	f6IRJUCtORsJY9BgrLzVsXw8PWj2btlds+IFCTBial+2wFoXeh173XOXUsaFyyVBlmxsicFMPNJ
	L2jNW0ZubwhW/bj4kQXbUeTWd6oxubYQxtbONiGPqSyzqzNoKzM06FjFiC5Sb8sgLKxx1ZDUl3k
	Li6yZHlh+fm
X-Google-Smtp-Source: AGHT+IEG5z5OFfCqSs3UOWXKpnum9NIRAHoICjCwbIml/RX8FyOQJmvNmQOOCV6GaGDvNVOUizI/ow==
X-Received: by 2002:a05:600c:4f15:b0:477:214f:bd95 with SMTP id 5b1f17b1804b1-47939e3a6dcmr8652175e9.23.1764980714999;
        Fri, 05 Dec 2025 16:25:14 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b0d5e55sm112555095e9.2.2025.12.05.16.25.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 16:25:14 -0800 (PST)
Message-ID: <22609798-e84b-46ca-9cb5-649ffba4a2a4@gmail.com>
Date: Sat, 6 Dec 2025 00:25:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-5-kas@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251205194351.1646318-5-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9B1D100008
X-Stat-Signature: f18uupp31iitxstbmsx4h6b8qxx9iym9
X-Rspam-User: 
X-HE-Tag: 1764980716-830248
X-HE-Meta: U2FsdGVkX19wUwt246NwcXxMv3VlT5EYmu4NZktCjIXeICoIkKrP+LQsfS+2ZcZ3lkZ4AUMS8qU9X2mtccdb7p3EtXALyIaUTxkqiVyOqntnR1KL9zu0/+cqFeN+ym5Ztcu1uVB1W5eLpKC1kRPYsICoIJ9pcF+Gbeezz2rQk8FHJHIHG/yC9wsniY2I4yxkkZ5eJ3hde8wRn1/YbZ+WwfWsgJn8+FSnDcgWMl2iJTNdXUSpg2D5j9YosmDxpA58/l5ZpD9STxWwwi2W09IsGcr9LlvmRL93u68b3ZBegvBVEQr7bKgp58OVgHXb2vjJajRKqG1FXG2ZDllLhxdVS6j1zwnBLBPd9S0+ObUGiwJUBj+MQT5FCH2T949Y+n5kAIA1y0rs3IayPLKhCW0oNTQ+vbueAMceq4ejLdnd/nIgl2tbaQotp9LGK3+dLpeJ0Vq7z6WSXpxTC86h9/mSgl8/ezWlq20xeM87OdMy5uOXMs+0EFNogoSXu14k3Kpu+bC/YF8d2Y2NvSSogvGO8Hgl/ck7KcuYla8UtB+WRc9dEbyz+/l+cKDiovGFAAqS2QYfDVqNYOKTZz2hi0mM/k0y6p7MYGMKKNgKoneAY/nVwj8a9XhFuZLIljZkITkOJsmJYUvmcYdDHYNvLoPE4yQeFDS6BwkTcZ3Q+UASHKkubnY1XgRULQgXjZcfKeSx7D9n2VFpUfeKFUQGUO8whuCn2HYiQ439qX5RJGehgI/O7l1lb174WSwEvvsEhSiofckOjlAKm+mH0Ro9AmVrDcxo+iwKphEsqx9HoqO4M19+gGKZa49L7ERFSuz9WBiVpC6uNpSj5EKi71kJVZepkmuQbp1tJRn096lk5tu1p7YO4PD70X/TuefOoB7gAOXBLT9BMP2gNZHwBzEeIU/pnrfkZy7zMq6kIRurfF0NMlZf0yqkrJ1eQ/tbTIsth18CJ0x4cV7ro8WvqE2OKQV
 RJiu4jKL
 170HSNwUF9o9KcflgdpzilFr5BBbI/RYLx+pqeKA1PIEtWyO9L+NArciYDPrLV1dGm2VPN5kX/qmrktTi1q9aVso05vm8q3SQ2kf1NwpYTpelWRJGewLY5SCygFXojwOSgK8hSrYeIaFyAjzT2Zs5IoQ0/LYdcZZAz0GZ2AtX0E3tRsQ7LHLRqCy1DyXOoyTeD3Pp2bSrXawKwernXnCkKEVawSeLDNEhaHNhLbYsATEBCfx6P7JzmjhmSBthlnHOd60rQibUp7IROMnPRzDcUyX0NT66n2+tw75wpi8Y5Atp+rQvXTvSpNi1V+vWnnBjcdcdc/KrLUf5QMqJCmcpxRVAG7xA0PNtdM3GE+oChFs+s2hFmzS/wzXrXlDEOEXHurIDM1T3tzrW0DHaF4Cq/Rb2CPOuKSMOFr/i/HQCiPhCE5LN8on8lAnTF52XOlohO3wW1NYT+xIoH83Yr0sDtqx11NNC453Q0ACVsoryQVhBWH3WhrRDyQxblco9/52zIDZhV991ziFZ9MAB7u5Y8bCadvaSWRCld1sZ1LlWH7ndfsDyZsSXeCUnYb9eu8flJPdmHs5MbpfUmylmGrSjTm3wioxWjPX2nks62EM9kJz5HmY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 19:43, Kiryl Shutsemau wrote:
> For tail pages, the kernel uses the 'compound_info' field to get to the
> head page. The bit 0 of the field indicates whether the page is a
> tail page, and if set, the remaining bits represent a pointer to the
> head page.
> 
> For cases when size of struct page is power-of-2, change the encoding of
> compound_info to store a mask that can be applied to the virtual address
> of the tail page in order to access the head page. It is possible
> because sturct page of the head page is naturally aligned with regards

nit: s/sturct/struct/

> to order of the page.

Might be good to add to state here that no change expected if the struct page
is not a power of 2.

> 
> The significant impact of this modification is that all tail pages of
> the same order will now have identical 'compound_info', regardless of
> the compound page they are associated with. This paves the way for
> eliminating fake heads.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  include/linux/page-flags.h | 61 +++++++++++++++++++++++++++++++++-----
>  mm/util.c                  | 15 +++++++---
>  2 files changed, 64 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 11d9499e5ced..eef02fbbb40f 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -210,6 +210,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>  	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
>  		return page;
>  
> +	/*
> +	 * Fake heads only exists if size of struct page is power-of-2.
> +	 * See hugetlb_vmemmap_optimizable_size().
> +	 */
> +	if (!is_power_of_2(sizeof(struct page)))
> +		return page;
> +


hmm my understanding reviewing up until this patch of the series is that everything works
the same as old code when struct page is not a power of 2. Returning page here means you dont
fix page head when sizeof(struct page) is not a power of 2?

>  	/*
>  	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
>  	 * struct page. The alignment check aims to avoid access the fields (
> @@ -223,10 +230,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>  		 * because the @page is a compound page composed with at least
>  		 * two contiguous pages.
>  		 */
> -		unsigned long head = READ_ONCE(page[1].compound_info);
> +		unsigned long info = READ_ONCE(page[1].compound_info);
>  
> -		if (likely(head & 1))
> -			return (const struct page *)(head - 1);
> +		if (likely(info & 1)) {
> +			unsigned long p = (unsigned long)page;
> +
> +			return (const struct page *)(p & info);

Would it be worth writing a comment over here similar to what you have in set_compound_head
to explain why this works? i.e. compound_info contains the mask derived from folio order that
can be applied to the virtual address to get the head page.

Also, it takes a few minutes to wrap your head around the fact that this works because the struct
page of the head page is aligned wrt to the order. Maybe it might be good to add that somewhere as
a comment somewhere? I dont see it documented in this patch, if its in a future patch, please ignore
this comment. 

> +		}
>  	}
>  	return page;
>  }
> @@ -281,11 +291,27 @@ static __always_inline int page_is_fake_head(const struct page *page)
>  
>  static __always_inline unsigned long _compound_head(const struct page *page)
>  {
> -	unsigned long head = READ_ONCE(page->compound_info);
> +	unsigned long info = READ_ONCE(page->compound_info);
>  
> -	if (unlikely(head & 1))
> -		return head - 1;
> -	return (unsigned long)page_fixed_fake_head(page);
> +	/* Bit 0 encodes PageTail() */
> +	if (!(info & 1))
> +		return (unsigned long)page_fixed_fake_head(page);
> +
> +	/*
> +	 * If the size of struct page is not power-of-2, the rest if

nit: s/if/of

> +	 * compound_info is the pointer to the head page.
> +	 */
> +	if (!is_power_of_2(sizeof(struct page)))
> +		return info - 1;
> +
> +	/*
> +	 * If the size of struct page is power-of-2 it is set the rest of

nit: remove "it is set"

> +	 * the info encodes the mask that converts the address of the tail
> +	 * page to the head page.
> +	 *
> +	 * No need to clear bit 0 in the mask as 'page' always has it clear.
> +	 */
> +	return (unsigned long)page & info;
>  }
>  
>  #define compound_head(page)	((typeof(page))_compound_head(page))
> @@ -294,7 +320,26 @@ static __always_inline void set_compound_head(struct page *page,
>  					      struct page *head,
>  					      unsigned int order)
>  {
> -	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
> +	unsigned int shift;
> +	unsigned long mask;
> +
> +	if (!is_power_of_2(sizeof(struct page))) {
> +		WRITE_ONCE(page->compound_info, (unsigned long)head | 1);
> +		return;
> +	}
> +
> +	/*
> +	 * If the size of struct page is power-of-2, bits [shift:0] of the
> +	 * virtual address of compound head are zero.
> +	 *
> +	 * Calculate mask that can be applied the virtual address of the

nit: applied to the ..

> +	 * tail page to get address of the head page.
> +	 */
> +	shift = order + order_base_2(sizeof(struct page));
> +	mask = GENMASK(BITS_PER_LONG - 1, shift);
> +
> +	/* Bit 0 encodes PageTail() */
> +	WRITE_ONCE(page->compound_info, mask | 1);
>  }
>  
>  static __always_inline void clear_compound_head(struct page *page)
> diff --git a/mm/util.c b/mm/util.c
> index cbf93cf3223a..6723d2bb7f1e 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1234,7 +1234,7 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
>   */
>  void snapshot_page(struct page_snapshot *ps, const struct page *page)
>  {
> -	unsigned long head, nr_pages = 1;
> +	unsigned long info, nr_pages = 1;
>  	struct folio *foliop;
>  	int loops = 5;
>  
> @@ -1244,8 +1244,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>  again:
>  	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
>  	memcpy(&ps->page_snapshot, page, sizeof(*page));
> -	head = ps->page_snapshot.compound_info;
> -	if ((head & 1) == 0) {
> +	info = ps->page_snapshot.compound_info;
> +	if ((info & 1) == 0) {
>  		ps->idx = 0;
>  		foliop = (struct folio *)&ps->page_snapshot;
>  		if (!folio_test_large(foliop)) {
> @@ -1256,7 +1256,14 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>  		}
>  		foliop = (struct folio *)page;
>  	} else {
> -		foliop = (struct folio *)(head - 1);
> +		unsigned long p = (unsigned long)page;
> +
> +		/* See compound_head() */
> +		if (is_power_of_2(sizeof(struct page)))
> +			foliop = (struct folio *)(p & info);
> +		else
> +			foliop = (struct folio *)(info - 1);
> +

Would it be better to do below, as you dont need to than declare p if sizeof(struct page) is not
a power of 2?

if (!is_power_of_2(sizeof(struct page)))
	foliop = (struct folio *)(info - 1);
else {
	unsigned long p = (unsigned long)page;
	foliop = (struct folio *)(p & info);
}
	
>  		ps->idx = folio_page_idx(foliop, page);
>  	}
>  


