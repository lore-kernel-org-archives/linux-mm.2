Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB9BD64090
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 08:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2AB46B00A3; Wed, 17 Dec 2025 03:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4CC6B00A4; Wed, 17 Dec 2025 03:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E6C6B00A6; Wed, 17 Dec 2025 03:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE2AB6B00A3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:27:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99FB7C0935
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:27:07 +0000 (UTC)
X-FDA: 84228282894.12.623AF84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 940D22000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:27:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765960026; a=rsa-sha256;
	cv=none;
	b=aq94d1t+xyZTMr4oKsr65RuWBVE/ki89hrSfhtOXjBALlnjo6AGxJ2F9SVwIv2WGbQGzWI
	joTyKMrderjt0hd/5FJbGC7Xb2hsqygZ+oav4bFrSrKRmAeqp1griCppuJEUqEeA0LR+CL
	0QfCW9gPoGp98tRnScEe7/b11Nu7iBk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765960026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y21Hf7GG0NbDEwKYfAnVnpGoKIKbRj/kXWT+mP9xsMY=;
	b=cTrYcXl7DgSk+wrqG3ayoMuhRYpiiqRuA87a+EvaqBdTpZbUwXDoFd/QBDRM2UDuh60KzO
	mT3liRlBE52oXGtHcL9+TrXS/DCY7QDff4OHl7oVzdn6XvjzYttWUWxHEFwZg9ZuehEo77
	qWJatf19j842pT51Zgc4KD5R6mRECEA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5760314BF;
	Wed, 17 Dec 2025 00:26:57 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3337D3F73F;
	Wed, 17 Dec 2025 00:27:03 -0800 (PST)
Message-ID: <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
Date: Wed, 17 Dec 2025 08:27:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251216211921.1401147-2-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 940D22000A
X-Stat-Signature: 1wpx6iwsjhonn6wb59gy7zuyczyi8zto
X-Rspam-User: 
X-HE-Tag: 1765960025-842217
X-HE-Meta: U2FsdGVkX1+RQYbFXKC6KW50khAhJWVZAHw7QLVRCNFEfpE1XNRmVOIslKclxXV0z3p9d6NlbESWJXpPgrKEHhd6O4MYCNG+P1UUp0sEKO2XkO4XIAlKbrvIv5ChjSC8TuU3MN4vdixak+iGlpRKiJ98x2cRVobDYC6Sv5ZBmINGKxP1r4sMNThhylX3anRclk/nmTuEnrLAe1aLDF4Cws1AhtG1NY0zumdXyqDbVaC7jCqdVNrKpO7oMZoHAFEunV1wHw5+sdcLRfhMp+/4cD3FM8Wbc8FdDmgNjVPV4UpP/LVwd1937AEy4MQSizO4VXynfmUnpHnkDdIhkfAiXbU+q5b0LaN9w4aR5S/q0kN7h6enzJfQWeohKbH4oAM6HdjrV1Cbxl3jBcTfGErf0myS5FvAAdpxb9BeJvZLj1UiwN4U32/ou2ZYd9vpGQc8CLin3vJphcKbT4b2NvGBpBs28YOsxM6RbE5g+mpawH7hsW3CN5RQoy4eh+Df7L2MoWaCfHYLS73kkri90Mxgkc1l+UHp/zFO5+4G681Xlr+5uVlsXcK580gi2bD69kWoOo5iWti589x8+SAcw27kIzfINW7K9bzj32WIvHl/BuBV5NVb4v2slW8d0sMqxeCMUhF08k+F60USwCK4HWoh1xgV4+E4keQZaWIwGWAH3b6CooAKooOZmER4aaRKv2dVL5ZGvA46jKl6wIClaQyfNPiJEgxP1TzxV5j3eeCU0SuHJOCmCInnWVPYOTQpcdaP/oj+W/YGrEUIMYChendTbg1IQpBAkJ100oVVkrJ5TmejbPBGGSHcCFgk2UL7pQlx/WIDPCG8XncymsH7MINZDVLdN7fpQGYtrWY6RSewgXgfzuRubkUllAgPa7rCIdH98psAGtjyr2gMxxXD5GbfJIynnnGgJL9a2TW0+UjxthSsTGKIjYgZ4l1iYLzhRMSUXIxJsDI6qEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
> Introduce a module parameter to enable or disable the large-order
> allocation path in vmalloc. High-order allocations are disabled by
> default so far, but users may explicitly enable them at runtime if
> desired.
> 
> High-order pages allocated for vmalloc are immediately split into
> order-0 pages and later freed as order-0, which means they do not
> feed the per-CPU page caches. As a result, high-order attempts tend
> to bypass the PCP fastpath and fall back to the buddy allocator that
> can affect performance.
> 
> However, when the PCP caches are empty, high-order allocations may
> show better performance characteristics especially for larger
> allocation requests.

I wonder if a better solution would be "allocate order-0 if available in pcp,
else try large order, else fallback to order-0" Could that provide the best of
all worlds without needing a configuration knob?

> 
> Since the best strategy is workload-dependent, this patch adds a
> parameter letting users to choose whether vmalloc should try
> high-order allocations or stay strictly on the order-0 fastpath.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d3a4725e15ca..f66543896b16 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -43,6 +43,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/shmparam.h>
>  #include <linux/page_owner.h>
> +#include <linux/moduleparam.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/vmalloc.h>
> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>  	return nr_allocated;
>  }
>  
> +static int attempt_larger_order_alloc;
> +module_param(attempt_larger_order_alloc, int, 0644);

Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
Y/N as the value; that's probably more intuitive?

nit: I'd favour a shorter name. Perhaps large_order_alloc?

Thanks,
Ryan

> +
>  static inline unsigned int
>  vm_area_alloc_pages(gfp_t gfp, int nid,
>  		unsigned int order, unsigned int nr_pages, struct page **pages)
> @@ -3679,8 +3683,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	struct page *page;
>  	int i;
>  
> -	nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
> -		order, nr_pages, pages);
> +	if (attempt_larger_order_alloc)
> +		nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
> +			order, nr_pages, pages);
>  
>  	/*
>  	 * For order-0 pages we make use of bulk allocator, if


