Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A97ACCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4878E0006; Wed, 15 Oct 2025 04:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85388E0002; Wed, 15 Oct 2025 04:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AB38E0006; Wed, 15 Oct 2025 04:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5F6C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:23:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3555011B322
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:23:27 +0000 (UTC)
X-FDA: 83999659254.15.EA8B7FF
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9AC0180009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:23:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eG3WEqi2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mf/kC+OIjNsVWQTW5KyvVpDANmQ6eLIZpAk+yfTTfM8=;
	b=h3SCoABkdMYKR5n5EHOQ5O+5rk0kYoQP39PnKZ62s2ZJZqIxFRCpuDaAxsdwuIuDVa+uwT
	NH7Ht8caL0/6FpZdA6FIX7mH+rUCG3Mfq769nUmQKpYWm0TtNQvRmw48lEbxYZhchG6SaY
	Q6z17hoU9EsD63DRgHvwNxeEC3rVQzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516604; a=rsa-sha256;
	cv=none;
	b=QZQGv+Czbk8GyG7BwZ4PdpgLaNKAmFGRQO8riRpfTmtTbAe/xKG9gJRiItqNescPY0t8eQ
	a30aE+Ju/HexRgjNw7F82tYuLAwHwLwIaspM4oURrpk3eJZIJjHk4WweUPY2aIMTVRZfBw
	tpyr3/OPs7OlYUXidAAqpH3Y4Ez2pXM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eG3WEqi2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-367874aeeacso63401241fa.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760516602; x=1761121402; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mf/kC+OIjNsVWQTW5KyvVpDANmQ6eLIZpAk+yfTTfM8=;
        b=eG3WEqi2VFRu8exNV8IgaSU+Evr2uxVG5058SOwKD0jHP+UQ23Y6FQN2O512T+kAHj
         2yc3pftwyz8UUo15/eNWYszdijbCoex011rCY7snYKU/a+mU0dTpg1GnkOWGnCnk6o0f
         ftO1DBLaj4FicLe+swXIEgXrMO2nqgskkmZb8/xfrUA49cVhLiJMx8kTVlMFzW9DI0c/
         zJsrRz2+3ptM7Vhl1C/u1O7WS+0AHFualM8lQV0ZAfwjJS+mauanzv6pgsCEhFiHZocb
         OIpTQU4MYFpRi+4T73NfhcVaPl+DIoAjoH+wGqTXl21GkIq+sNHqBtxLeT3FDoPTasbt
         97Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760516602; x=1761121402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mf/kC+OIjNsVWQTW5KyvVpDANmQ6eLIZpAk+yfTTfM8=;
        b=A2vZeC+1y844U5B87maXy8ycNGhE9YeuN7bw9o+ofUZhohuEMpWUZq3VzhNB9rHWfy
         +inf8x/FdXFT43Ibj9L35jc8Oo5nCGiBF9dzZ7L6l6LqySjHd1HC+vuORa+yEzgWbwby
         wpLD1MvSUgb207G3YD0qN3EjsStXTwFIXYPns3pKGjWlXn7911OHYY1DZd4TrEwXz6Yh
         /qksIeic2l35Vo7vIgDGHHUlvQj8kb9owF1QNslWdgLmDnvgydO8ei2T9xIpuJhOeZcm
         P8fXqMfPHJUKDo5ApSHvDne8Hs31Gdgqpn6O0pmx9qVU8juW9U0DDkorEo6dXdMkQHzm
         UN5A==
X-Gm-Message-State: AOJu0Yy9qjtZDAF+s4LsDU2e6fyg7iqf6RIrCdy6wmLJRlovot3n9rod
	eRRpBf+o80BhUQxbMkvBG2FzwM4dVzGQzUiqm0PeUCqBec6/qUmHHUK+
X-Gm-Gg: ASbGncuDYwBLqiFOZrC84SiaTcRjv2ACBNfAsbYaAo42rqhuvbm0qoSuUgsI+Swrwvd
	RcIAtxFPoUwYtfEdPd6WpEGWsw5pbG4X+HLKjXsT8fP5jFlWvI8kndIWhsYo37IxFMQ6s11opST
	iBZn8/zDdQvBm1g8u0R7nuDCL5npkqudwX+/1VEAOLLu0a8pcufL7ujEOeQfelCO9vbobP4UcZ+
	3T+WcLfJTq9Irzt94je2cTjyNxqUIptFimyPUDcq1LaT0NgJGuauVJuYIiUa3fCvykidDVvxLRB
	Y/TlyuakI64Be4IdVoe4fibHRaU1fGC1Vfyso5nXnrpsX7d5k0QDsEgvAT2O6UQidKKoRs8DYlO
	iLTjjKDbx
X-Google-Smtp-Source: AGHT+IEDfPLZF1XUkUC6PKH6VKbUwMfZxNo1JP9Fexm8vGn0nDS/kZEDNU2PautB7TCBU/85QBFQfA==
X-Received: by 2002:a2e:be86:0:b0:377:7ca5:7997 with SMTP id 38308e7fff4ca-3777ca57b3fmr2778641fa.44.1760516601525;
        Wed, 15 Oct 2025 01:23:21 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3762e7b461esm45980461fa.16.2025.10.15.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 01:23:20 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 15 Oct 2025 10:23:19 +0200
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aO9Z90vphRcyFv2n@milan>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014182754.4329-1-vishal.moola@gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 8os9oog14qmmdnhkptckuiwtj4qi49rq
X-Rspam-User: 
X-Rspamd-Queue-Id: D9AC0180009
X-HE-Tag: 1760516603-797617
X-HE-Meta: U2FsdGVkX1/eMWFl5DhT70jX4Ljs7TfKk+oyodhW4OTrF5yVddFXhDKi8usZ/gDyzleDdNm5ouUGyYctjYEMkXAtliODVOfg+6we54nLlgyAKvGtcPIlkBn7EJ0cAvwat3YSL6dsxd1NvdklAoRJO3bcC3FJqJRQOMfPptIliZdaVUq6jL98pVbdW/Dg8NADm0F7OS5suPz5X+viDbA353nzzVySlUgGQ74KL//vA1JF1k7nOqRfRtt2ni/AjtroEZYrclj5FSurcujcYXgK64euw4fWRdm1Qe8buIK+PXMZIX+E4p4rh+WvjkbhcgjuLyOU9cDRVHI1q0gmPuaPKONdCtzOsKEZ6rM/OduzLIL2FmhjfcYvW+PMFDRNna2ZxStksM5uf9krGlFnOWlVDnyq+NhnuaB5Af15kTdxqlH14Z3X9UyRAQQsBf7e8k4PYMEJgPJfTZFj94qdhoeeUc5f71fyUmjCtcwgO8jDPQ/dXAygbbHvvb6vW0QROiMPF+Fp/Rr03brUYupkocHYWy1aOMYuj0yqsFk36p02uD3gH/bZTXiJVICFQfofmH98y5rTGTOv/kEte5d/Kz4+F83VD4SJ5JuT/ujVKFX/ATulP+VvdTlTAxkfhBe4nmxBO6iMTqCSc/NZjUO7CyMOp+cmK1298KPrvxKRDK9NX+/LAHl8CiH5+4tc0w/gjkin/TCO0tW+f2iLQ1y2/naH5uDUvbBAmgCo0hkaJYrvh/Wwc0CB4fcQ9W/pExQsQC25M7LvZR6wS7S1GP1bJXVBP1SZMlhtmFWzdXsqJagya+M/ZMpjnNVVdaJdeiznblnmob5sC3eXDYxAyifsdj8mWJC7I5kRBU7kEd4Lygm4jqsfIZAk05jHypLD936jS1+/EjNwnQi6KUIWUW7KJ3ERekMMauveWxXZG+Kfp4CnNwH+g6fT6gJHlO1HVkKj6RX74+DFxxYycDprHWnRtkb
 6MyHnavF
 /YB138+kTk0nze3Tv4nf1EounIuUbvN97bEpBVw+SXVRnbX9ADdor5z9OjGPNRzFBJnBqC/mqMBkg1CCXIMr3bkyyEXjdPpo4rPPeTvgH2jQrNGeWdSYG0mFuWaOeuMArHVBJHx0IOXEydu62PjctRkdgHeVcGKSNRc9kzL+BGxMQcXLwYaLXjshJHSNoW0JRf32UPcysZ0k+LPZPlhwNBLeVtmEeHFztrKFINIuPMcup6p+bs1TcJIsEn7SmWKPyJU7U1XnpnFcDZD2PUuUQCzqUVgRmaDBnXkjParNtWo7zP8PeS3IlXsRwaFR2pyOLjsRsjNd9OGjGviMhR1HVkuR+f6u1Z+m9mGO5xwzIxmqpy/JQjWq+o/4E6IBaCqMb6t45TM1rvzrUnb93FL4WiIr5FFW5PwxMPJl7H5k7NReplDxkfOrZn5yoD6ryZtlK0geMeRIGEEuax0eMwyR84ufqTtfUz7j3VJNFx/5/42QUKcYuqNjQw4RZRFB8TR4o2L7B1nIj7kgMt6UZ3sdfMuH1oA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> allocator. Rather than making requests to the buddy allocator for at
> most 100 pages at a time, we can eagerly request large order pages a
> smaller number of times.
> 
> We still split the large order pages down to order-0 as the rest of the
> vmalloc code (and some callers) depend on it. We still defer to the bulk
> allocator and fallback path in case of order-0 pages or failure.
> 
> Running 1000 iterations of allocations on a small 4GB system finds:
> 
> 1000 2mb allocations:
> 	[Baseline]			[This patch]
> 	real    46.310s			real    34.380s
> 	user    0.001s			user    0.008s
> 	sys     46.058s			sys     34.152s
> 
> 10000 200kb allocations:
> 	[Baseline]			[This patch]
> 	real    56.104s			real    43.946s
> 	user    0.001s			user    0.003s
> 	sys     55.375s			sys     43.259s
> 
> 10000 20kb allocations:
> 	[Baseline]			[This patch]
> 	real    0m8.438s		real    0m9.160s
> 	user    0m0.001s		user    0m0.002s
> 	sys     0m7.936s		sys     0m8.671s
> 
> This is an RFC, comments and thoughts are welcomed. There is a
> clear benefit to be had for large allocations, but there is
> some regression for smaller allocations.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  mm/vmalloc.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 97cef2cc14d3..0a25e5cf841c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3621,6 +3621,38 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	unsigned int nr_allocated = 0;
>  	struct page *page;
>  	int i;
> +	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	unsigned int large_order = ilog2(nr_pages - nr_allocated);
>
If large_order is > MAX_ORDER - 1 then there is no need even try
larger_order attempt.

>> unsigned int large_order = ilog2(nr_pages - nr_allocated);
I think, it is better to introduce "remaining" variable which
is nr_pages - nr_allocated. And on entry "remaining" can be set
to just nr_pages because "nr_allocated" is zero.

Maybe it is worth to drop/warn if __GFP_COMP is set also?

> +
> +	/*
> +	 * Initially, attempt to have the page allocator give us large order
> +	 * pages. Do not attempt allocating smaller than order chunks since
> +	 * __vmap_pages_range() expects physically contigous pages of exactly
> +	 * order long chunks.
> +	 */
> +	while (large_order > order && nr_allocated < nr_pages) {
> +		/*
> +		 * High-order nofail allocations are really expensive and
> +		 * potentially dangerous (pre-mature OOM, disruptive reclaim
> +		 * and compaction etc.
> +		 */
> +		if (gfp & __GFP_NOFAIL)
> +			break;
> +		if (nid == NUMA_NO_NODE)
> +			page = alloc_pages_noprof(large_gfp, large_order);
> +		else
> +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> +
> +		if (unlikely(!page))
> +			break;
> +
> +		split_page(page, large_order);
> +		for (i = 0; i < (1U << large_order); i++)
> +			pages[nr_allocated + i] = page + i;
> +
> +		nr_allocated += 1U << large_order;
> +		large_order = ilog2(nr_pages - nr_allocated);
> +	}
>  
So this is a third path for page allocation. The question is should we
try all orders? Like already noted by Matthew, if there is no 5-order
page but there is 4-order page? Try until we check all orders. For
example we can get different order pages to fulfill the request.

The concern is then if it is a waste of high-order pages. Because we can
easily go with a single page allocator. Whereas someone in a system can not.

Apart of that, maybe we can drop the bulk_path instead of having three paths?

--
Uladzislau Rezki

