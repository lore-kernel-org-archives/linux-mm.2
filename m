Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1556AC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936FE6B00BD; Thu,  7 Aug 2025 12:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7976B00BE; Thu,  7 Aug 2025 12:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDCA6B00BF; Thu,  7 Aug 2025 12:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECF86B00BD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:06:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20671136E57
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:06:15 +0000 (UTC)
X-FDA: 83750438310.07.1CFE71F
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF240140013
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:06:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lu3OvJb+;
	spf=pass (imf26.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754582773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJBjqu3YD7XRAedLpR3J+C+OqUxVoJiaJAbOSselMEQ=;
	b=UVdm9PJ2vJ3GI5l2tjp9w/cVLfJvZruGk1/7ODEyyTgAxrMZSN8raEf8V7Z3xT+9VCQ74E
	Kw23kt5UcLHyg9I2j9F2/VUpd/4leqUqE2J3LgmG1s8ye5KauNrPEdzzSw/RBXgHQTzA54
	rCYdcFF/+v7mxnI0PBzIdzYNsCMg5+4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lu3OvJb+;
	spf=pass (imf26.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754582773; a=rsa-sha256;
	cv=none;
	b=Ytx8LH4/4ULLzko3oXYASi1U41u+6fZJ3PCgIg8gvn6mmpP9l6xnLcDGZc0Il63KSV2ItC
	p4LrpfDmimaJ/UWI/PAqT0bwlCEBSxVON4/B4SdcGdZfvv/sjfqf4F2+xGeaUAX8p1MLzn
	QgJib5PhkjgwDy8A8YwwS5z7BJmg5JU=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-332211b014dso1376561fa.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 09:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754582771; x=1755187571; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yJBjqu3YD7XRAedLpR3J+C+OqUxVoJiaJAbOSselMEQ=;
        b=Lu3OvJb+YiTXiIUbV/BmijkSqL3oDUVNbFwynKiAEQnQjPLxW5ZSuEUZZ7YFOi99nk
         vg1eHtAAv5tctjgXvaPwt8PVwWoXm8v1Kj1CLW6cozEfRTmcBlO738B0TT24VPkPyJBI
         0h4Y5lsdVjiBOt7O2x1TJIBOgpBLFxtC4sXil8XuE4AVkN0sUoF2TncCsBvv3jkusQ44
         2RNDsTTeb0b2hGf32Kz7Cc475rLM6bqFrnurzsSInoPQaZysvcKjpYqMOe5eHGW+bwid
         Fy1mCz+c9tvCo9LPwmrTHYE0P2g6HRoTIJSr//Fm+5P1wy5gJYVeQ5ucmDTWPW1NksKG
         U5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754582771; x=1755187571;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yJBjqu3YD7XRAedLpR3J+C+OqUxVoJiaJAbOSselMEQ=;
        b=jmZ5I0ZJ5i+CJVX8AxZxkkuCGqK4NYTnA5eaml7tClE9sOHm4T/71yrLGd62pBQChH
         6TwfxxbbjANF0CodTO8pFv8rUpEEqy2SE7sz2sSzXOp5sGoCRHyWC/v8BSz/7wLLkksE
         uI+Z5B5ggfuFmg78ctu0AZkZrARhqa7EdOWHHSdWCSjR1VDmvSugZ6O8u2H3CJI65c9j
         tpG+PMs1YziNygYRbDPm2AgzqcMa9UKSiNZmt2kXEYsL6IBxLsmaBxu+Jszbv5mE7vyn
         jM/AlCz1sSavP+lU/t4yW7r7mgK9uuPiiWAOxC38A4vwtcb8TMWupNnECdZdYS+TDjmR
         6Rjw==
X-Forwarded-Encrypted: i=1; AJvYcCVeSfbLCicL9NbG9+F7Cd7H41fSqOEyinFMKV48DSSJ5+tFmMEnCGEJeh62nr7aedFp4tg3r8MBHg==@kvack.org
X-Gm-Message-State: AOJu0YzLjtfx4zlQLCs5Ip7fwUTl5lg9F7rgwO92EWvdTnXCwoRKP55W
	9f1I/uhvL7cRQ8Jwi6HktjGQdnnfjedtDUf+4AYslS+QMrssxQg17bID
X-Gm-Gg: ASbGnctZjZV157+E2xkPGxaascr9/6uJwgagyDBfOlosHKxvoSAQIpev5dUHFiecbTN
	cEWjyUqRZfJLBhXk4TCmj4Vx0Io7SEt7ORmLjCOywTuUG3Fs+EwZKagfZhYcE7y3xZo8SqBqKkR
	c1w78K8DGVerx4D/aAbH8J8Z12PEgghRNpaZfitO1uNDXE+dmJgon+j9XTEq14TKAAxaaqaHxhx
	+YbIlRwZufUG7aYFa7aNEnt+HZW8SEOyeSDH00OwEMPrHVHowG4pSvGWrwBvpKs3aOtw+InDwJs
	qnEGuuxx0/pmHyt3mseRzkYDGYHmbgLclpLq2do0x8Zmkrc6bEowyR5Ul5zH4KgKlloEyIhZW1h
	4sXdtYWR/UQTZt12ul4rvwNAlMNpe
X-Google-Smtp-Source: AGHT+IFHF81LeQAj8VhkvZSN48lQMwN14izUC9rPxv1TIYTDZL9tj4CKnu9CWhEAPd3obwD23VnlvQ==
X-Received: by 2002:a05:651c:4112:20b0:32a:714c:12c4 with SMTP id 38308e7fff4ca-333812151c8mr5823071fa.1.1754582770692;
        Thu, 07 Aug 2025 09:06:10 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-332388d87ebsm26736341fa.55.2025.08.07.09.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 09:06:10 -0700 (PDT)
Message-ID: <0d24f6b7-0e4c-4879-87f2-e31ad988baad@gmail.com>
Date: Thu, 7 Aug 2025 18:05:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/kasan, mm/vmalloc: Respect GFP flags in
 kasan_populate_vmalloc()
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 Alexander Potapenko <glider@google.com>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-6-urezki@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250807075810.358714-6-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: deprfan5fit9z5sijxyg86i7sujpxwe8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF240140013
X-Rspam-User: 
X-HE-Tag: 1754582772-491316
X-HE-Meta: U2FsdGVkX19EL83CwXpEvD6oUiC5s6UT/3W63uU7K5VCigzMFOVcV8arW7WemFVCOyTD5bTkt5bHDaGmxf+neBO4LOj4yKTbC5/zef0MCn7/d+9HD/gHxDQGrjMfYw6L1UKRXD9kd73srtxDWRcIeRUNdqQa0mkDhILvIyX5oOqKXttnTFizGagMC7xeyogtANl4Kwf5uiWMOJDwA7FPb/uomwj3Kcha9rBAY5Mbic24nudqrHqZLGnmyuoN9QLSYWldcJwkH3X9Pz8E1FksKFFg/mnDhXs+ZHANn9AMWB4pdmOjuMFkMXe1dSK7/XbIxiT9g14R5Oty76L7gyNN3KuXmecuJi6b3tQ74dido2l6D9/eaz3sqsQMjeWcf/hPx4oF1F6oPb9XiLqnkyqVZXw59uunVEMv3GWbvNJF90T+FM4BItBHBwZpttnifmy3yl7OJgNz/pvfGaINg+DyUHPYw5J1SeD0AvWmfVLK0K188wBG77X1UmGdtsxQz8o6UZesmo6Z9+urnfeN1hV5U4lsQFlAmIgHOCv2kYp/vADDGiyNneErOoRKnNT39FpbTNFDBQbspGmw+HXIuxB6P30khpzh8Xjg/RVKcJcCnxEVwm/r2mhD0wVq+udqYJcq4VHS/GYzqCzQUusS65Yb++q0xjhQdSxGfcUxJ+JnIF7eUUKaH6pulT9nijiu7awHIw93crSzwm9eDO+JD7wOPlxHNTogCgPCMM3MrlEQn9+4CKKFJsytdNBvzqYcXlVKUJurC1g/TXIFZsNEU5P0UTakzK9LAQiVqSRGFcBUeUc++BlG9EfZM5fV5uTpvJoCzlq/rQ/j+dp+Q64hDUAp4ro/LDbMvV3FXLY6lreUo8lhJv2vVUAzYOtboAn81AnOAOySayx1jcmt/r0U60Zna/6QsxqoDGBYM3cktTb4GGNxMtWSM8COS1CyIDeKt/L8DB24NQKDlcZUZCcLTdX
 Y5INn/Rx
 cdE0rwmvDKVLzXshJeIG+YDOUUwEZ16QVe3/FPhBaUNlUQuutNHYnQU73zNyA0GyGfSqewpHMmJ4C5z/QBN5br1xsQnn1HAJOqrFcP0Hs60nl9xA0rRR7wAFayjYEIVcWopZ95jX7yzPAph4HljdYiuoA2RJHHURl4xP8cPIvqQPH9y8RSLGaplEIFj/8JXfFyNXUqsgux6Ib/ZsdLpRVpDQSExvrUMSgV0GMIj5qih1IJLPKSswpi9UpGBuWVuT5Fq11/JObw+ffqyK4Ssqkuq6DU8Qx+BHaX0ARAgvOnsQwZg6QV5yTvW9YiB1VPt5QC/dcrJH25gKeM2DmwxFuc+ws1Ar/u/uujbneItvYLSe/N47jqULCa1y9micmAiEdmFIbx+I3U4ZWow+ssYcekmipiSYiIh0zLIKzucRfRGCDnTsZc1M8zjM3hmDOIHtRHnXAIbn36co1PZ+1FzdsvUSkRlDK55vtUF1iziWZZUyx8FimodCdL4QULyTNxJlt3V6yoTwCUd9q0j0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/7/25 9:58 AM, Uladzislau Rezki (Sony) wrote:

> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index d2c70cd2afb1..5edfc1f6b53e 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -335,13 +335,13 @@ static void ___free_pages_bulk(struct page **pages, int nr_pages)
>  	}
>  }
>  
> -static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
> +static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
>  {
>  	unsigned long nr_populated, nr_total = nr_pages;
>  	struct page **page_array = pages;
>  
>  	while (nr_pages) {
> -		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
> +		nr_populated = alloc_pages_bulk(gfp_mask, nr_pages, pages);
>  		if (!nr_populated) {
>  			___free_pages_bulk(page_array, nr_total - nr_pages);
>  			return -ENOMEM;
> @@ -353,25 +353,33 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
>  	return 0;
>  }
>  
> -static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
> +static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
>  {
>  	unsigned long nr_pages, nr_total = PFN_UP(end - start);
> +	bool noblock = !gfpflags_allow_blocking(gfp_mask);
>  	struct vmalloc_populate_data data;
> +	unsigned int flags;
>  	int ret = 0;

gfp_mask = (gfp_mask & GFP_RECLAIM_MASK);


But it might be better to do this in alloc_vmap_area().
In alloc_vmap_area() we have this:

retry:
	if (IS_ERR_VALUE(addr)) {
		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);

which probably needs GFP_RECLAIM_MASK too.

>  
> -	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> +	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
>  	if (!data.pages)
>  		return -ENOMEM;
>  
>  	while (nr_total) {
>  		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
> -		ret = ___alloc_pages_bulk(data.pages, nr_pages);
> +		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
>  		if (ret)
>  			break;
>  
>  		data.start = start;
> +		if (noblock)
> +			flags = memalloc_noreclaim_save();
> +


This should be the same as in __vmalloc_area_node():

	if (noblock)
		flags = memalloc_noreclaim_save();
	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
 		flags = memalloc_noio_save();


It would be better to fix noio/nofs stuff first with separate patch, as it's
bug and needs cc stable. And add support for noblock in follow up.

It might be a good idea to consolidate such logic in separate function,
memalloc_save(gfp_mask)/memalloc_restore(gfp_mask, flags) ?

>  		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
>  					  kasan_populate_vmalloc_pte, &data);
> +		if (noblock)
> +			memalloc_noreclaim_restore(flags);
> +
>  		___free_pages_bulk(data.pages, nr_pages);
>  		if (ret)

