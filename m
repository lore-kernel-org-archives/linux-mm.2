Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A274CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 17:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A168E000D; Wed, 22 Oct 2025 13:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3CD8E0003; Wed, 22 Oct 2025 13:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2968E000D; Wed, 22 Oct 2025 13:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37FE48E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:50:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D103F1A090D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:50:27 +0000 (UTC)
X-FDA: 84026489694.24.57C9990
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD7C220010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:50:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G1795VAp;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761155425; a=rsa-sha256;
	cv=none;
	b=b93s5iynTaxnnU7ODZyI7WpQMd7hgxwswnnLsyOVmI66qspobkBzPzg5jRUxNtAU/yscPZ
	OwK+uCOwYXGHMfcCpomfL0iXpRCCrq4XeG6IM6ZiqeqzfydvXwzaze4NGVf4E/kqnS/mAm
	19sqpyOW4HY9DYVZrtH9Rq7e+G39DPU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G1795VAp;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761155425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gj7KPYHen4iD4FElTa0Z8YdaUj+MGLwuw15fxyPIN/c=;
	b=dmpLMqw5xhziYJIC6Oe81gVE0LnAQ5fwUpOuj7zbQpUA6tDCgFVg/dIi8Q+YPBCSNY1yN+
	UAgasIjZrPOkjoCXUSQTzVnbew98WFhOU3LWVFux207oivGVdQEUd4MSykrNiKec/I3YWB
	0jAauZdiED5DkR1zrByNerty0JMPibI=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59054fc6a45so8252205e87.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761155424; x=1761760224; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gj7KPYHen4iD4FElTa0Z8YdaUj+MGLwuw15fxyPIN/c=;
        b=G1795VApGhorBaPyXW9L+Cc2vWvP7yMCcLo+McMq5rD8ZILrRZXj3pd9eu0Y45QTTH
         w6TMviH6HUMKlsyWXLL2VAubnQ0a01GNJN0e6dxJrdlY+7Iua9/cXeozV+xtKnOxqaG8
         oEj2MV3pIJA/Oxj95drJadJZrSyNoCiKsri0J/Vz+dEKOdv5sjL4n3pu46zDaZVD+7cm
         2NNm/5y+UxV3lTzpBpYlO93HekQl9U/cIrPSJOqyuEova9jJBqxNuw93yG9Qa95lSI8D
         rh9+W9fPeRs/XqJWOuMrVSIdH7pH9QPrr2UTps0NYBz6wPy9KzqhlClqObe7A0CuXEFu
         VSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761155424; x=1761760224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gj7KPYHen4iD4FElTa0Z8YdaUj+MGLwuw15fxyPIN/c=;
        b=mDx7kaYBu0blf1TYcQEKwPyuEClJHBNOTHZXgofLAtWtixnSqYpwaGko3aztYJfCEC
         1Zo9D/P3o5hCmC1SOPvO4/v4pfvB2w7FKWEoNP7lMdFT6dg+dEPjFkrnUEj61ovhzcwN
         CUi9n2qtmH50xGzISR/uhkRKIwRU9W/sLrn/M3QRLC9o1qk/KwFE/jgVfGeMOFysXv32
         c8GEc6MOMjuIpIkZgx2M+QBfZhqy4jlnsUESoRRC2JsWM4qTBw+AoU8fExq33BY4RZdf
         haYZMMt/mqfAb9QXCHsA7DV3h+JHa/p1BlxUjBsULb06sRVynTBdT2hjlOrldKGM4xix
         5N4A==
X-Gm-Message-State: AOJu0Ywf12vWY36Skssmthmg3Lr5ZEv4UcEcRwOT+OTT95tv3n64Wxwi
	+yVv32uG4UrqxECDgKbDOLAbcKgB55BAewxoF/pPrjhOYkPKgoFh4eU/
X-Gm-Gg: ASbGncvgR4XcgPSeavzcsx4RBKMCFaiKKgtohC68zEElZNYjhpK6De1ZBvV+OQKHlR7
	abrtRaVbliLItGsJJnIp2jOgTKgpMQ+z56HgUNPA9WNmfjqxByVNmegeXcCgNkU04WczmoYXn2V
	SFvoHMzzYJPjARU6yKqCUI9oarCqMeYiYbVO7w4+WFq9ouqreaY2bJLM/CaBBmN7OtwX6sshkWa
	lDCKAV8utnmipB3KCpsDdVkQ+ODwy53OiTuZvjoUckGXL0hP15YoWg13kvOxVyhqoyMRM91LPfB
	DhaM7sTIV7eIInsu0po/xX30gaY4lHJoE4STcQFdH5pEycT8tuhAR87rgbYwYPmNOpRNRaisrEU
	1UlJd7EbR+4jRjFnuJv0e2M4Ub0p7hfUURIH0ut/8UYw=
X-Google-Smtp-Source: AGHT+IHWyRJq6tFiZtAn35KR7NImL9zjR4bm4p1s04aULCvEQT/pY7P8N/svSK90+dOJQatGcRCt+Q==
X-Received: by 2002:a05:6512:3f1f:b0:57e:f60:2330 with SMTP id 2adb3069b0e04-591d854accdmr6241116e87.21.1761155423561;
        Wed, 22 Oct 2025 10:50:23 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-592ddc3662fsm1193388e87.84.2025.10.22.10.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:50:22 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 22 Oct 2025 19:50:21 +0200
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPkZXbUON37M59As@milan>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021194455.33351-2-vishal.moola@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 4yw7baoc7k55ny569escfwhnr7fgm1kc
X-Rspamd-Queue-Id: CD7C220010
X-Rspamd-Server: rspam09
X-HE-Tag: 1761155425-649267
X-HE-Meta: U2FsdGVkX18318Q3+OqZebkRwnPPsQM72b0RAjKyPQWksnrlqA65+Zq3sB8+82h4xYwHHbkFbgV1pLW0XQU1ztS8k2eewajhDopXKFWL8wnUppdUI57cWdgErpOiUx3d1Ytv46B4Bda0pGgC4I8kQzb/TKskV5DptZLY23FRCYkjnElPgsDUqIKtHZ+7vlq3JybnhyvFL9Tf54NgqFMcClj9lJdWBAxd/vMBF5omrUJvumhp3xt9yCyl2DDu83qbN2Dbk9hlKN3Cmk3uDVbtG8Dwz1ejKRnh5UgrNHCt+rSLIireqhBwEgfnGjhA1zdIwOaOC5nB3j/NRK4RyKuWk7tyqEI0koJjB9ZNNFU3uVDfxqCRaLl0nPfMb1GFmmLrWX9Fg5DnsuijGQedmmUNUF86t3yCWu1TDkyqAVDSyGdDuEM962Bj4adpjRW+VTe2fo0ZCDzUTqLj0qYo+htSFyCSliQXXJM9fC+7eZ1O5NA/mPoORasOkqGo3PsfPcMGWyquw5uYz127doV6l88NOOVClFZVb1jn5jTgTErUdY2Um1dSFCYFI/AbL6tzhkW+kxztzXwYdSiq030ykqh4hd//MogXDQ9Wsy+UXISueyFiicdtDlfryIVXH2QC7oOTltab5v9AwV4ke1TA832fLGsNZFf+PEdowcq2Em8Zef+vqdWDMuS4fVcgdT1vaSKqUqUCPAfWKryPbggnI43cRjh7WKbNsv/brJuFHMeJd90XzALhVDr444QoVLfvW8/GYj6OiR3vPfiAVIkrohXwtyOsFSjJnOgedv7NNC0EODtqG8r9MyA9e6SEucKEDDXobWqc9zXGbE6eQBiC3xXKb4FTl08qZHsG9FJgdkfhacrP3vjnIdW/UgyOUWPCDab3Kyg7zc0qRrYhwwfxZkqDzEM39qXT+1xHrnZLZhoyTaJ0laDwj4sgDGWKRoRF1lku4/MQf4Meu7oT86ksjy6
 WK/M2nrp
 jP2CBxarhfXbHQevkZn2UVEb1ELRx8wvTy2KOhScqxWfaPve/nEfJG5Qg1bPC4FOq1IX3DbBWEknBczmEF3wpFcmCy0+30s/fE8BUim5MaQrNfyCprcmj9o5CKfKTDqFIhcwnGIog/QbOiD0nm807kt8lv+Qu7L/f8mJrW6YuFOcbMiIkRJ1+tXI2axD6kmxy6jJPEyrOjkQphup8zu64gzQ6MFvVNnZJ7o8JTEg6melDIkayTZ+BMv0jLuXNTrQvHY6oslCs29b0UIjdQj5X12LxXUy3b0QVZhuue4MVwBU2O0jLrvpdmFRIYLIuZcZXgYqH6Iaj+/2/g9+ZEcRaSFwLypfgeLfMdRnMOVMN6hpSJeqc4jmmP9zO6nP4z4a5TzGKJA21WIQpRdKtNGZiDEczPQj0ZU/W/t9VhInH3qfUe3KFL4QOL91X9HO5NOdWAG5dDOg+EUl4HON6yDolIVcw4ao5kzSQYoWmSYHz24+Z6qo1875SWb0tQu6UUNkFZU4Hov9ZUs5FW3TlQzz3RKmPQ7fd+tiDzSgDQjlcBd8+MNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 12:44:56PM -0700, Vishal Moola (Oracle) wrote:
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
> 	real    46.310s			real    0m34.582
> 	user    0.001s			user    0.006s
> 	sys     46.058s			sys     0m34.365s
> 
> 10000 200kb allocations:
> 	[Baseline]			[This patch]
> 	real    56.104s			real    0m43.696
> 	user    0.001s			user    0.003s
> 	sys     55.375s			sys     0m42.995s
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> 
> -----
> RFC:
> https://lore.kernel.org/linux-mm/20251014182754.4329-1-vishal.moola@gmail.com/
> 
> Changes since rfc:
>   - Mask off NO_FAIL in large_gfp
>   - Mask off GFP_COMP in large_gfp
> There was discussion about warning on and rejecting unsupported GFP
> flags in vmalloc, I'll have a separate patch for that.
> 
>   - Introduce nr_remaining variable to track total pages
>   - Calculate large order as (min(max_order, ilog2())
>   - Attempt lower orders on failure before falling back to original path
>   - Drop unnecessary fallback comment change
> ---
>  mm/vmalloc.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index adde450ddf5e..0832f944544c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3619,8 +3619,44 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		unsigned int order, unsigned int nr_pages, struct page **pages)
>  {
>  	unsigned int nr_allocated = 0;
> +	unsigned int nr_remaining = nr_pages;
> +	unsigned int max_attempt_order = MAX_PAGE_ORDER;
>  	struct page *page;
>  	int i;
> +	gfp_t large_gfp = (gfp &
> +		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
> +		| __GFP_NOWARN;
> +	unsigned int large_order = ilog2(nr_remaining);
> +
> +	large_order = min(max_attempt_order, large_order);
> +
> +	/*
> +	 * Initially, attempt to have the page allocator give us large order
> +	 * pages. Do not attempt allocating smaller than order chunks since
> +	 * __vmap_pages_range() expects physically contigous pages of exactly
> +	 * order long chunks.
> +	 */
> +	while (large_order > order && nr_remaining) {
> +		if (nid == NUMA_NO_NODE)
> +			page = alloc_pages_noprof(large_gfp, large_order);
> +		else
> +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> +
> +		if (unlikely(!page)) {
> +			max_attempt_order = --large_order;
> +			continue;
> +		}
> +
> +		split_page(page, large_order);
> +		for (i = 0; i < (1U << large_order); i++)
> +			pages[nr_allocated + i] = page + i;
> +
> +		nr_allocated += 1U << large_order;
> +		nr_remaining = nr_pages - nr_allocated;
> +
> +		large_order = ilog2(nr_remaining);
> +		large_order = min(max_attempt_order, large_order);
> +	}
>  
>  	/*
>  	 * For order-0 pages we make use of bulk allocator, if
> -- 
> 2.51.0
> 
I like the idea of page allocation using larger-order :)

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

