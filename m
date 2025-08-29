Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CDAC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 06:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9D06B0008; Fri, 29 Aug 2025 02:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1A96B000D; Fri, 29 Aug 2025 02:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7356B0012; Fri, 29 Aug 2025 02:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6A56B0008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:41:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2D3BBA1E2
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:41:20 +0000 (UTC)
X-FDA: 83828848320.24.43028DE
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id DAF3E1C000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:41:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NHY8HHYU;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756449679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtxEKMLsj3BJjqsAEZBWzNWvadtCwMY5ynf5Rrf8/UU=;
	b=sJ4mTWt38cQVoELdJtYBGJFxFZusdeXazF0RwdAinaQJrFoKyQBEGQKByXC67iDGb40Ljo
	bPWtBFNIY+pnCdITBuvgXe0R+DeSvXxyCDYQ/ZKr/GXV4drHBKtYfmEdOPGgor4tMn5qKd
	geahVsfOvq6a8bUAfwKb28Gnp0mhYO0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NHY8HHYU;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756449679; a=rsa-sha256;
	cv=none;
	b=v2vB9+2cpS3jljvPxvmziLfDA4EwXGO7Xx2P6fEJJbDO6gJq6qlTraFMq69Z571y/bLfWo
	G9CWv3J80Fx5f0a9MWit+xtkuRnUKR7vPbk54qehGR1g+vyOV1lsZMyfKKEKGfl4WMBMiM
	511ITJBHGSt1T1cBd1PwCGnCyFmImeY=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b7d485204so9642155e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756449677; x=1757054477; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtxEKMLsj3BJjqsAEZBWzNWvadtCwMY5ynf5Rrf8/UU=;
        b=NHY8HHYUSe9D3kr1s2kv5KNJiO2K95m9V3xfAZE5yVmXu8+oAaRVzarJEmRV0EhYj1
         qpBxpLxeej6e3mJdrdeLkGNGRVet7MhnT93myunb+njNwZ7wpXI0AOjlvv6FuIuNk314
         BfpJX0kwzA5B00/FOyVdAy87dl65VxLT/hBk8ZtCWO3X8XPqTD8QJeFI116CtWuoPFHG
         RNNZtWdUNmiAeCHEDN3g5gEzpI3+QRYOPNAN5GeOygBty0+3ixXKU3LfZ06aUe4T/32d
         qjDi+1k34hnGDGOOihoo+680RmF2IJjnMRPFBQ3n44tBFSuk1qnZa4Q5VqQU4+MxAQkh
         LMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756449677; x=1757054477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtxEKMLsj3BJjqsAEZBWzNWvadtCwMY5ynf5Rrf8/UU=;
        b=cqXSrDxytWmFZ4xEteW3iGuU56peQUYPCLriQoDgMiLdZrkgBt+kwL+VE9u8wb+SQs
         LSim5+CZaPTL/hDC54sA/TVGQKlc/TMcXAMRIURs3iEn6n7zqtcF1dcAfOuYEnlEo8uA
         krxy89BwcmUE+FKG7MAi+nXjESbCLWw0SNv9ckLWH7cYWNe05CxplGHIzxh3tREWRbjM
         jk1+IdkHWAEfA6ukm47t/GNw1VrpN0RnYbq8lIeq/bmyee+fdfdtM9fPjBuQYE1yzGtx
         pIUuWL96gAPC7Ppb9tUnmm9rJUmSmCooDaus1+h7MU/HjzMC5lYVlFlFsKkw++q0Yu9w
         qxVw==
X-Forwarded-Encrypted: i=1; AJvYcCU3xP9zZdjlEjQ7c9WsRneXy2GWDf1Lai/GN58HoaVpi7RGi0RRysnubpM2yw/+nQtAp2lEleBgNg==@kvack.org
X-Gm-Message-State: AOJu0YwTAz8z0TaxrU7L01s3pma5U30D9xE/z0Qsg3+lYzKVNntMb0C/
	ludcwgP03gKFDcc+0XzcZZO+IRqpIn/HKlWt8AcOZDAO/5MN6Abj4K3t5DgFV8nSL7Y=
X-Gm-Gg: ASbGncvo7BL978dlBHjdmf6ugydPaUCqfCkKJ2XZVMGbwuGmIYkLT2Kt9NDgNLQ4mYq
	vIZ1cBxrHXZJHqO0DkywK4qj9N4kFlk86voIEosSWMdAIgExyAMPIirScydkX3+MRboViP/vDQb
	31ro01Ed4YSPCdrQwKHNVbP0Bb9Nes5lhQBtL/ldw30kO9Dp5IwPp6SMALiK0v6lGdgHbIuLi23
	vYMuG1cMFTLcn6yNSI4jrGABo0vfxtLjKP4wuFPH99Qljzh9RrCCyeB5hWdlIMwiPlFYsHj/Mah
	aBi793+H4ByNrroMRF64W9EifQ4csXx1r4voB5PZkesUqN1/JG2V9GkpsDLoAB9y6wcGrtu1jOb
	ElBqlhZbfzPsXiTyBzzE22/YdN0EsIQ3Ed3M=
X-Google-Smtp-Source: AGHT+IE0hHze9wkthqzJK2uktPvYHUKC/p/KFjdPRhXF7UeVVigicm5+RRf0+8vpXcyjUnGU8Of9lA==
X-Received: by 2002:a05:600c:4fc8:b0:45b:7be1:be1f with SMTP id 5b1f17b1804b1-45b7be1bfcemr30585535e9.32.1756449677281;
        Thu, 28 Aug 2025 23:41:17 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e8966acsm25768415e9.17.2025.08.28.23.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 23:41:16 -0700 (PDT)
Date: Fri, 29 Aug 2025 08:41:15 +0200
From: Michal Hocko <mhocko@suse.com>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>, kernel-dev@igalia.com,
	Helen Koike <koike@igalia.com>,
	Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Message-ID: <aLFLi4B5smIMY4u8@tiehlicka>
References: <20250814172245.1259625-1-cascardo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814172245.1259625-1-cascardo@igalia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DAF3E1C000F
X-Stat-Signature: 6pzterecak53w3dyzifr9eumyqcixo5i
X-Rspam-User: 
X-HE-Tag: 1756449678-784046
X-HE-Meta: U2FsdGVkX19DOMnx9zhntPQEHsSmZVKBiGp+gHhu+w0+d+JEWIqVI9HmywEIUsxiql/BescRJbWltJn5CZfkCaRZqzT8wGHruQ77qyr2ROQt1MvbkkWMX+IR7UbvPR5zL5f1Mt6CX/yesSuxY6mHvEFdQhTfxvkTrui118yCSY6WIkrntc5qhGl2q83QIckvI8IZjA/C4nb7YIZhWttrTck16xkqJZVI/Yhl8HwEDizFuyYV96S9l9kcIE46TYWpHGyom0Y5oHSCn7/iej2GyWokTaa1K5f9AuOsXBOlWtzLKQh+v4upOzkxg8p6A+2dtOuFwT64obrLBdpnPYiynbQJ65T6bTtyrE2pZD2WVbHbg04Vmx59EY5X0aoTzJMkXtUlNT6RkC/BnywWeGDn+uPJflUdkgXMbtC7vaFfp9SukTjweN1BJ+PADBwSLhkLEhBtdYcuOZk+SfYowy5jvUA7/juPHXIcIsfK5oQl4ga1pcwq5gZNFSOXpjnXvIkmcY/2yXlmXkSTQfG4BwOanaqLbni2wlrSsVypLD3pAYgS52d3b/gvvt7XgKtOldq0rwqCWRfGJabzX72109qLz9ftgQY6DRRZYgPONZV2lsTzxnqgaQzCMmN2hD2sCp1T67k3j1ono6bEdk5+p33GTZipje2Zxa9Pajad/wm3MQ1GUdzhh+DbCA4v7VAzI0HUlISAglkX1vhSV/eY+j7fJ4iSrAgBaI9qoeVTsLeCHp32jbF6YrUCE6tr5xbOTmlO3Zu1u2HPHqjzJk68g2RpJvC7ayzPHDRjWtDvvAvQnV75rNO8Z9kZthXoxBiIB4CXC6Tpf6nd6hbP1G45VCdQNvQRdrH3VuALKW/NqRA9lSbv+jbR6ZDT/nuymCgZ1TUE0Z5UttZK2WePSUZwFGMMr7NTt3JfbO1MREaVIpDl2cSoNyGPDFpwzLxtM4rmFgflMXYQLtFSbtsjmE+n0Za
 Qnf8NanF
 9dNB34ncls+eRU6Si9bI7zeal5ZW4y0Cqlkc25n516Vy8PqRPF7fWrBJFsZ6Yl9CA2cqNM4/iZ7hbcHSWZbW3J3ZZ/ymx/4tFQLs9YHhWkNk/vL5QEbEwZDfH8dZtGSyGzhG4lQo3kdWNcLFOhnXHI4Um3Uoa4JXosQVcWobd5c6Ci+CtKIpxp/8N6Rdw8oUOgf3okmhYVFfrNCcD/b3pdw58gLCBs0zqweCrXhwn2XAQFZNNN52mzyCPEg3dQs0IIzzUml3NVv1m/uKHyRj4D79J2GOdjIO2/Q8yGU0hap7QjXsH+AywSnfieM0+cpWEy0yRmSMSDtucduAGi1aKM9KJYyFN3roU8g/nZSXTr9fT2cMpYeImb8/aFmYRwINfhUK7m8jJwKibmQqA3lehPfg/8j71z0/18LO3TDZxGfXwB+0Y2kVQOKC4izAEPH9lCS2nq6bL8EZnWK083Kl+0oYyoLGZqXgLmKJLR7q4OsLcorB12yfh3zrAtYvs4sxuxdybbhBBb31Lr5znuTqg890448Ch1tfrMIcqrqaUsLMAyFbk7hXCYTRdHd1zrKYVn1NyYoj8AcXXtigB1JMYnM56QN7iplC4hdunad6aK1H6LAnAaegDi1ZlXMR8+XVZr8biQPotuyYyVMVLsn9zKoNW1q8iEdbuDTsPMvKq4959jNF92U1Joipb2q7PCJuTmxYz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 14-08-25 14:22:45, Thadeu Lima de Souza Cascardo wrote:
> Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
> ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
> which implies ALLOC_MIN_RESERVE, is going to be used instead of
> __GFP_ATOMIC for high atomic reserves.
> 
> Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
> allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
> allocations of order higher than 0. It still used __GFP_ATOMIC, though.
> 
> Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") just turned that check for
> !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were expected to
> test for __GFP_HIGH.
> 
> This leads to high atomic reserves being added for high-order GFP_NOWAIT
> allocations and others that clear __GFP_DIRECT_RECLAIM, which is
> unexpected. Later, those reserves lead to 0-order allocations going to the
> slow path and starting reclaim.
> 
> >From /proc/pagetypeinfo, without the patch:
> 
> Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone    DMA32, type   HighAtomic      1      8     10      9      7      3      0      0      0      0      0
> Node    0, zone   Normal, type   HighAtomic     64     20     12      5      0      0      0      0      0      0      0
> 
> With the patch:
> 
> Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone    DMA32, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> 
> Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> Tested-by: Helen Koike <koike@igalia.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>

Yes, this makes a lot of sense to me. GFP_NOWAIT allocations should be
opportunistic and quick to fail rather than dipping into memory
reserves. We must have overlooked that during the review.
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2ef3c07266b3..bf52e3bef626 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4219,7 +4219,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
>  			alloc_flags |= ALLOC_NON_BLOCK;
>  
> -			if (order > 0)
> +			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
>  				alloc_flags |= ALLOC_HIGHATOMIC;
>  		}
>  
> -- 
> 2.47.2

-- 
Michal Hocko
SUSE Labs

