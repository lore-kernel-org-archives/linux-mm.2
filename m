Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5106CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175638E0009; Wed, 22 Oct 2025 16:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D8C8E0003; Wed, 22 Oct 2025 16:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BAB8E0009; Wed, 22 Oct 2025 16:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E77EE8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:17:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B96B11A0947
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:17:31 +0000 (UTC)
X-FDA: 84026860302.02.B91CA53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D9C9180007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:17:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G84uVTAE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761164249; a=rsa-sha256;
	cv=none;
	b=RplVafSg1tEsHJMj0H1SIhrn9RjpU+aRR/iWnyBCahICanaVd1zgMNpPShM/vjjvcy/bno
	ybU8F5MjbwUoX6RlFtUjqpSK1urNeNy8qEzOYBcYm/2ORWlE5qvj6dt3WrdjpoSnKC7AU7
	IiSTf3+wp4UVCjxOpXvTUvY8F7echSM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G84uVTAE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761164249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vC+s+xeMprR+Ip6ri6xLPS37We7Gp0CsGRiTv6yqlJw=;
	b=Pm1TLIpTIAkPr6doA20MqiPyMSn3+6Y0och0v9amsGtuaE6K0bup5eC9F2dvrkdEnRga69
	ODn3DBvJO8DSMOOzzJKxl83GDH8Y7rZh0B12KU0OtNoMRGHcJca1VDc8++1qrgDE0Z7IVt
	I7r67TQoOTmva2CBFqBOheFd+YIgJSo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761164248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vC+s+xeMprR+Ip6ri6xLPS37We7Gp0CsGRiTv6yqlJw=;
	b=G84uVTAEmGRrun0Kgr0j8emfIGG/3wEqInMrDTYwcVB2semBqaq8zfDQrLnz1Bwxll3zGB
	z2dwkUTVwL1ohFtom/JIexnw4goa1wD2R8zDzMKekn/EyARfTN35uV9xevGgeRIN9Fkfxu
	Rl02cAGYQmx9A9ByEN2RL2WxYLNbWzs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-yBK4mDCMPIuEagDpQRLDjw-1; Wed, 22 Oct 2025 16:17:25 -0400
X-MC-Unique: yBK4mDCMPIuEagDpQRLDjw-1
X-Mimecast-MFC-AGG-ID: yBK4mDCMPIuEagDpQRLDjw_1761164244
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47111dc7c35so81315e9.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761164244; x=1761769044;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vC+s+xeMprR+Ip6ri6xLPS37We7Gp0CsGRiTv6yqlJw=;
        b=VgtgWAcVvNXj6dW0VqMi84yLqS9lWkgaGd9nzbISvR6umRWWJbR6iW/XJpzE+ZAJeq
         7+LA9g2yxO8JwwwrSW1lAl3fjxDdmsf7eqaWKnVRqTCp8VEm+4zyDdybUGYd1F+Nd5um
         eAe1EEMnsfD0ZG8wv6plB2wOJH/QmudV1eAm9yGoBqbk0UC2b9gAnZ95h2R4w59x1n2l
         r5jf+1lzrIVXSgCkRKHYeFql8CgtYKAPLXqESvC1e4GUOf9wOhotYj9EHgGF34/8f4vP
         Ub6nBZpCHfa2/2aO9+Q9Xtprvl82VlyLw0z5Grw6xQisAIwSTt7LRFhP8LGleTfaemr/
         ClLA==
X-Forwarded-Encrypted: i=1; AJvYcCU0GJNElcgUvdP69NhE6RVixQuNVcRMQgn3imY1O9DSW4dxUvHKv6BVfTkI2Ha0jkKe+UmuO9iPVw==@kvack.org
X-Gm-Message-State: AOJu0YzHOjGf0TVzLTL+bhCiEVLyTF595sEtjpGTwFwfojJrQR7D9zT5
	uD5GerQqVgyn7E/tDdOCHto5Jf3iKTCtCOHBeNl2kMFYmEikeU05+kMYrSmnQMr1RleXgtWQ/by
	q7EP0cD7h3pHQ8Svz0zdYD0AYor6kaVrssIl5lQtgg9raAyAKBynV
X-Gm-Gg: ASbGnctmCkD7D38Hm2cxANo/TE+B1k74GOsJODy2BM4hiLtgPDKEdZDZsDkpv2K4nTk
	P7U1GpuxqdJrYeJvd13LaefwfA5JbpD/RMGQyOvEdr34EftUDsJ7E8wpmOI3MjIFEdJU7I8sgR0
	uF91aJfwmk5dPba9wB/yC1P6p99Fx4mUOgb1S0rkJ8OS2tjW+yaNm6f1yfHM0cluQPrq9u3WQZ5
	mn/z+zUhxHmA1MPlUXNagGbesXEIFp6whfuioxBwYxdvQ2VUVat07Vog7/s+bM3CwQEPYxr5AnP
	PG7jByypyOEfvTwV421bdyMOOoR7hQev0eKzg7DYkXTts++xz3YcyXVI9yxXRS2AA5ObbfFPmHo
	Q1+axdejjaE3m+45yH5nroBmni5p0m0AGgMx6G5dxNus/a+CBqYkSDaMprbjxSUjCXoxivUSoWq
	h5Gko9OKzRN2mw6WhndNQnwNRKdpQ=
X-Received: by 2002:a05:600c:3e07:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-47117872663mr178764525e9.8.1761164243924;
        Wed, 22 Oct 2025 13:17:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJhFihxtaIrVrrQyehfH2+8Qrs+EvwAFrqmTS6AiWmlrhAWqEm6qvu5GsS/mZ0b6O2CjvX2Q==
X-Received: by 2002:a05:600c:3e07:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-47117872663mr178764385e9.8.1761164243518;
        Wed, 22 Oct 2025 13:17:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c43900e1sm68385365e9.17.2025.10.22.13.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:17:22 -0700 (PDT)
Message-ID: <6279a5b3-cb00-49d0-8521-b7b9dfdee2a8@redhat.com>
Date: Wed, 22 Oct 2025 22:17:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] mm/memory-failure: improve large block size folio
 handling.
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, jane.chu@oracle.com
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-4-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022033531.389351-4-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EiOTzZQbWxDF9h0mVcHHu0ik23i6DUtzaTdMu2tp854_1761164244
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D9C9180007
X-Stat-Signature: jggo3rf7ifmh4e3i84ycdeeetgh7keo5
X-HE-Tag: 1761164249-49837
X-HE-Meta: U2FsdGVkX19F+qeJcpsg6YXq4mMA3wf2szx/NFDTEYAS/9OJeSgNuR1fG082bkZjmbgGqIrPvkZadD8FKIQecTnD58AzO8/yC4GMWCqRVPu/GK7EALL4yVslTvVxjVgmG1da1lZX4LAiWeeEO6B/KcxL2kej/xaQNS+7geCcL4eet7Sla98VhtCUHJ+Z/p7qo27RaYaI+ukBgcdOIVh2evTGOw/y3z48gMMloCT0+Z2j6Z8hb4mYV1vCvLDU46qHKz5XrWR4a4bthgjNbPGLVpNjURMNCJ6KyS2tl3/vyCNFE5grWJjUkrzAQWsegHhIfddzWjwa7jQme2rKsfORnfi8u8RYmI2uqnQY+S/IbZTGRTx3Zi2MQDftl41Z2PlBUKzZee/WOlTrHLGleDChAC8E4WvIC0LIvM9rld1m1Pg3ruKvzPC9NF2Q0ZVBOluzR6kkwOnPKSm7n5JHSn55oaN7fwMfDBgkd4huZD3W5ihbzTFf11772Kht/z5ds8ufpU4IpJ0ar+Qv4u86Gbmj88csLVqBzTKlqzcvPjb8KDhcp31AliPjzhC5Y/D6PppS+JxJ9k5ojoI5XNKV/JOB7CnufIOxNy7zcaJUnObjBU5ni+GaJ17QEbi3sLirVpW/cjoALcUx/LQHjhbqtgIji6YyzywQ59AWU4BlUWcVV3zfMjCvFCeiQ2NwC0BAtPPkc1oTVE2wdbrwGnZTychBykuI3ByPgS3srdiNi5uRaMjrPOisXudSbWuPT7SqtTvSG+gdUHa49v7QrtPX1wBstltcLE5Ajy7GQkjeYkgJrLlTib52lg/NoboYYlwd7DUbY7WmJWtx2i6OVN714tPFLAMf3xWVqu5b7z90/v6ivPeXrbNaKNBk13iGbY75/9YgetrPDNzOrL1US6ku27dD2UMRdb1vr4NQOby4HwDjz9MOCSRGbs8K/V0Wthg5AQIyM3R3lyl97TrhfVNNEx3
 MiSIR6vB
 +z9PJWbPMK8j/a0iSnnx826OYBa205hTsGlRdv5NH+oTXr5Pvi1w9kd9+Ye1XKW0R5FlHaCQXmNEur5MRFWviH+Wxycj55LN1f3cyOenpykI6QhdZlPf9ebKUkKfKYjlCeMxP+ifBo0ccoXKxUQG5ssr8BvIxCYO059qC9L5VA+klByOH2GhZGG6emyp4nw9lsw/FlHN9d9yFavPogrvkqZ4DGdVpiSKJJGcV6AakXGP8KKFWwER6IO4tkcQQUu0f6EpTOaRQUNx/8Tl0qrG05sNiDFAwD/yFtJofFe0zH/TyxpQHRXUvBsmxVJeMqnaAae1lwzGrClYg8PuJXyi8TngAPONadlLxJHIYGTa2lfELC0g3Id7d6ZbnKq+FxXRPwYRSyEB0MwGJ3mAoNNjhBkm8meedap0h3eVMHNK86P0aUz1m1vRDhfmHK5e7gQyez/pnkWZwTie2CFdSRAAQ3T5TpTIa41i/vihw/iaO+VMm8lRL3bx68elaSZdJBw+JP3p9jFH1nEAjHzqtwFvLtF3XKVOPTn5t2Xb8m4dBCcNj9zwzh1EyVUvn0+2rKIMIUKtSphsd+fijP5ZZu7whIyiFQ7bb+y7pYcAvR52bRlP+vQE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 05:35, Zi Yan wrote:

Subject: I'd drop the trailing "."

> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
> 
> For soft offline, do not split the large folio if its min_order_for_folio()
> is not 0. Since the folio is still accessible from userspace and premature
> split might lead to potential performance loss.
> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

This is not a fix, correct? Because the fix for the issue we saw was 
sent out separately.

> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   mm/memory-failure.c | 30 ++++++++++++++++++++++++++----
>   1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f698df156bf8..40687b7aa8be 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>    * there is still more to do, hence the page refcount we took earlier
>    * is still needed.
>    */
> -static int try_to_split_thp_page(struct page *page, bool release)
> +static int try_to_split_thp_page(struct page *page, unsigned int new_order,
> +		bool release)
>   {
>   	int ret;
>   
>   	lock_page(page);
> -	ret = split_huge_page(page);
> +	ret = split_huge_page_to_order(page, new_order);
>   	unlock_page(page);
>   
>   	if (ret && release)
> @@ -2280,6 +2281,9 @@ int memory_failure(unsigned long pfn, int flags)
>   	folio_unlock(folio);
>   
>   	if (folio_test_large(folio)) {
> +		int new_order = min_order_for_split(folio);

could be const

> +		int err;
> +
>   		/*
>   		 * The flag must be set after the refcount is bumped
>   		 * otherwise it may race with THP split.
> @@ -2294,7 +2298,15 @@ int memory_failure(unsigned long pfn, int flags)
>   		 * page is a valid handlable page.
>   		 */
>   		folio_set_has_hwpoisoned(folio);
> -		if (try_to_split_thp_page(p, false) < 0) {
> +		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> +		/*
> +		 * If the folio cannot be split to order-0, kill the process,
> +		 * but split the folio anyway to minimize the amount of unusable
> +		 * pages.

You could briefly explain here that the remainder of memory failure 
handling code cannot deal with large folios, which is why we treat it 
just like failed split.

-- 
Cheers

David / dhildenb


