Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9980BCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 16:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F06C6B0008; Thu, 27 Nov 2025 11:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7CD6B0062; Thu, 27 Nov 2025 11:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD666B007B; Thu, 27 Nov 2025 11:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8696B0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:53:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A5F687C84
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:53:20 +0000 (UTC)
X-FDA: 84156982560.03.D8D436E
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id EAE7D40005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:53:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SJhS0N9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764262398; a=rsa-sha256;
	cv=none;
	b=mGKCqL9DahfDpCrmLxF+1x4qS8c391YH3IJmI+13or+HXL3T5XX0JICzWEMmizMh/Cg689
	6cqHeyNeVKy1IA8OTXU/pFMYXvMXnOHfk22fQsnk+caY0+Vu75FDn6t9OCBb05gJdKepCS
	FfaAy62iFoKtlYqHHUkRGzyY4G3mQcE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SJhS0N9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764262398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4drWKEd4RAmd7MBRAIQVZy+ZqrpPhSLkolh9dDZECE=;
	b=enQPX0s4KDKBv44ZGwbbJH2l/JFjda/l3xZJanBnV9buoHZHRLj18ojPShIbxtZDJDA13F
	8sBLgqcfi8jVocyKLu2C1Omg0o2LEiBrFafhBaGEcbN7E48c1xft7VGBuIUeMyKsmdOHsj
	DY2qsKDazIwDJftfjT+/PYbkKi0dduA=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5957c929a5eso1577146e87.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764262396; x=1764867196; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P4drWKEd4RAmd7MBRAIQVZy+ZqrpPhSLkolh9dDZECE=;
        b=SJhS0N9j0GCXTr5K8DbNa9I/PbHPdeYPBcoKBAbBMzNOKDA/YQJZDS5zUzdWXmQjVz
         r4oaF9LjmcmG+fH1O/59VjwQPehFWT8UVkE4qcfZMi/kAzoUtS7NsbrjH651H18WsCNf
         gbIDfNW9/50fdjU1JAQ763Hn3lGHUUdHtYNIYEhY5iPirFmHKDNZs93fwit2+M08sUPA
         hoQTsRA5kimE6gd3O16dzWkCat1zS53qYdLViFcy3jxoDDP6f/cdRTWmLS/c+9TjOfS4
         n2LkLPw9/e5JXmEFJk/B8xLxQNUp1IpnRTqYxEW1zNTLzNkWKRoiCF+1r1QSKuNI+8Ff
         1AQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764262396; x=1764867196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4drWKEd4RAmd7MBRAIQVZy+ZqrpPhSLkolh9dDZECE=;
        b=UdvKaWIDEvPSQv3hawMZ17BQrjSjYVOfYvJeMR1xqyKro4A4nMEVzCwgDepOZIwsvf
         Ga0CogiEboDJL5/N5nF8Qp+tuHtds3A5ZKTYnocEw/SpLWdB/RBa3Vzt+046R90Xbfz/
         jvjA6ul71HGW/qZ9k8VSrnunM+xDMZxaTTvcCXPjxb299965OeQjsl1GkYswGHQm+Y1i
         0j2rOQ4dXNZGWkRXSZZF6+3+9Pbt9bMGQT7oDTCNR10gcQRZyIGUFxQKIsnv9j3qZWY5
         YKUodTFa/Ps7gn70+cI7lHD4bVmnZFqbsTNTJEHAiSbm/2L9kHD2f8LnPgyQflfEEATF
         nfSg==
X-Forwarded-Encrypted: i=1; AJvYcCWWPJHgEdj8lGiyvQ1DxdfGPZou1otMqcf4eNQfQSx4noVasM7fOTyHdqmnufj9b631KHXWWvyhpg==@kvack.org
X-Gm-Message-State: AOJu0YxFgagp1mD6u6Qk3Tn669DaO87RlKxmHY7r+RWEEpM1v3MbzlM7
	Cb02yyV4VhGi/vJhdZLzZCL8SaN77ml+3KHBcoS5vIBbaAcJJSBUotpU
X-Gm-Gg: ASbGncscWXXGr7B7vM6uxsCUNsB2rAq/Ifwvmss9pur2klCkVKeXK4V6vhi5BQOGpQE
	gXrMPgllDdV//yJNGS4KDusQfvQueElTy1UHcBRzIg53yN2pJjCSLr325btd/vzCdYMYkZkL1MR
	7F6Lw9aDmqaJxQaxEVNwPfTko7Y7TTLlxJHW/cJvqBKkefW/Qxq+o8CW3Z1wdrQnL/eXmiujjPZ
	QB05dktmx5dQYZqUfqJVi4q1qCFNbOBwEfBSxWJVQTlFKsmYZXhRHWUE++M9jpaJSuVOcSBxKwR
	82tPQUAtrOirT+NzA0F8Tjy8D8V21aki5tnkPulk+d9cWW1ka+b/DP0r4j9/PKdtzLGvdIFrCJl
	qNJnt69PjAd2oUqvclWyU5mqhYIKOCuwppKsLf/2xPGphq3UxITfTwA==
X-Google-Smtp-Source: AGHT+IH8j638xjzoDHoozqoJ+ZLnXS1T0OqZepwP8h1W2O745wvjvCM314d3621pAOHVbu+pSPoujA==
X-Received: by 2002:a05:6512:6d1:b0:595:9d26:f551 with SMTP id 2adb3069b0e04-596b529c014mr4240034e87.48.1764262395589;
        Thu, 27 Nov 2025 08:53:15 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa44058sm530323e87.60.2025.11.27.08.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 08:53:14 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 27 Nov 2025 17:53:13 +0100
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	John Stultz <jstultz@google.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: Re: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever
 possible
Message-ID: <aSiB-UsunuE7u295@milan>
References: <20251122090343.81243-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251122090343.81243-1-21cnbao@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAE7D40005
X-Stat-Signature: ufixkuhfw38dhqkr8zc1nqjmfc11zta5
X-Rspam-User: 
X-HE-Tag: 1764262397-707227
X-HE-Meta: U2FsdGVkX1/xOKrjOtdfiTojOtUDW12qgxhZPlu6C/KXDol9LMJWF8+rbHDsIhoUGl0dv6E2lSWqj+qh7sLLVc68FtB+eGZA1qPAJ0t8Y7cGMvA0NrKF3McoqrhMXH86+Yk5+LoCbBtt9549FKl22AI1UUvwFvY8YfSs5GH7owYjWd9yOeN2Om2mnD0tvnRMrup/RFmrK+tPKBoFIYWQC0yWZktLvi1Ow3sLiIjrbfDCHGZcYRYPfgDj5wcC6jinP9wFzBsYCfwkG1rd9pDGivS8lel8K7OObt3HGGRvwjWByqh0nwKnjAnUMdgsyDooTJJMxCCrqfpUVUQjvb/bsr/sdeVbpEjkGvFLuFHLFN4kpzeXdiihI4S3Kg9NbpfI5IGBQgp+6rMrA81WZhFbqCmg3Enf0+JjE/l2KFGnjQSZGoJYCW3yoOc0I6dbSGT9mmdI+Ukomo3VJ8HcsXmmRfoMp4LrGYtydoajxoE6wJghXnM5cNBhgXZmkfJWzUIzwF87a2DL2gqSpO94ZWrq6SwJaEz9FA1SPEc5Rq1vW7gEsBf2K+aW0SkctFyrh/e56yLWvRfidzMO+i18ZgqshGBp1uwZkb1KiNccBxUQyaExJY/r0thOotBP/gqCC6rXUuV50V92/EP/AjtxdoiZ4xrPGtrMcc156EqqkiGe/gpmLiXvZPSNKLAU1QskW3N2MZUukvH9B2jpRY2E75EBCoWzU7iZxuud0j4X1BBIzobyPBWaysgoRqso5+rxWau1tAkObonUIwy/jg43oJ+RRrx/4wqEOM4Bhzeg6jIIucayJBB2qQkOio4i+lczUKYTZNdFEJAwKVln/2NA9Hpsrgw08LiQJBszVmbs9oh1l5MJs82allvWbMoa7LzSdVWu6ONag3zIDx6SK6ti5oZ4wLKyHI7RGDkMRfS4nPJ65VvTFpZMsGVIA7AuIEY1/R/gLpyaRejJwn1LoaSXfjQ
 RDRMbpn7
 L2cQLwIjSYmi9/bBSbXYcwiszFbeaRSfpGFzDS/OIdVAX4pxIT07owkK4q5KY5lAJiUUggM6aNCVWbeRncAMPby0klf4x2765osIw5llG9b/YOg6v/UNzJrNv40U/8zbquVouwZYw8os55Ybd2ZEhrRaISEC70dqOO4K5hH76X7u9AjSf5icxdgKH481tHEIPpgMvNO4wzCT0H3QJz8rQaMgWXtxB4t3NY316YVoBWRyPbkcaY8SEicMHVSFB4BpR3rR/qyrhMmrFZEmoxvoTxWZh9sRSNj0XtX53qu1Rf49QYVooTM2/0EIhvb4N9J7EwWZuvuXz643vbh7WSO5Pn+1eaMyXeEqFsvJfuGDpTOlvC517+0gU5RXhQmv5B583R/SIyT/u9tNMcq6nY7ONntxUdyICCnbxeey1oGt+GaulO1qsLZapDjMcKScy9RjwLNOtJfghrsjJ1ev42CxOy92dJEdHqMT5CsAnBQqPzZV/DoPiVuv1GS99/RJfGorjbP3sRrkhzcThviYJEhXL/KIzlcZwJvrebWKC3ltIllsMuBbm8v1liRJFgu+ENoiEPhHe1k6X2ywYWnnTiU4V1pecZYnQccdCP6oLoqVsKPl4SkpweMZQ7U0PZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:03:43PM +0800, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> In many cases, the pages passed to vmap() may include
> high-order pages—for example, the systemheap often allocates
> pages in descending order: order 8, then 4, then 0. Currently,
> vmap() iterates over every page individually—even the pages
> inside a high-order block are handled one by one. This patch
> detects high-order pages and maps them as a single contiguous
> block whenever possible.
> 
> Another possibility is to implement a new API, vmap_sg().
> However, that change seems to be quite large in scope.
> 
> When vmapping a 128MB dma-buf using the systemheap,
> this RFC appears to make system_heap_do_vmap() 16× faster:
> 
> W/ patch:
> [   51.363682] system_heap_do_vmap took 2474000 ns
> [   53.307044] system_heap_do_vmap took 2469008 ns
> [   55.061985] system_heap_do_vmap took 2519008 ns
> [   56.653810] system_heap_do_vmap took 2674000 ns
> 
> W/o patch:
> [    8.260880] system_heap_do_vmap took 39490000 ns
> [   32.513292] system_heap_do_vmap took 38784000 ns
> [   82.673374] system_heap_do_vmap took 40711008 ns
> [   84.579062] system_heap_do_vmap took 40236000 ns
> 
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>  mm/vmalloc.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0832f944544c..af2e3e8c052a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -642,6 +642,34 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int stride,
> +		int max_steps,
> +		unsigned int idx)
> +{
> +	/*
> +	 * Currently, batching is only supported in vmap_pages_range
> +	 * when page_shift == PAGE_SHIFT.
> +	 */
> +	if (stride != 1)
> +		return 0;
> +
> +	struct page *base = pages[idx];
> +	if (!PageHead(base))
> +		return 0;
> +
> +	int order = compound_order(base);
> +	int nr_pages = 1 << order;
> +
> +	if (max_steps < nr_pages)
> +		return 0;
> +
> +	for (int i = 0; i < nr_pages; i++)
> +		if (pages[idx + i] != base + i)
> +			return 0;
> +	return order;
> +}
> +
>  /*
>   * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
>   * flush caches.
> @@ -655,23 +683,32 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
>  	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> +	unsigned int stride;
>  
>  	WARN_ON(page_shift < PAGE_SHIFT);
>  
> +	/*
> +	 * Some users may allocate pages from high-order down to order 0.
> +	 * We roughly check if the first page is a compound page. If so,
> +	 * there is a chance to batch multiple pages together.
> +	 */
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> +			(page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
>
Do we support __GFP_COMP as vmalloc/vmap flag? As i see from latest:

/*
 * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
 * This gfp lists all flags currently passed through vmalloc. Currently,
 * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
 * and BPF also use GFP_USER. Additionally, various users pass
 * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
 */
#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
                               __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
                               GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
                               GFP_USER | __GFP_NOLOCKDEP)

Could you please clarify when PageCompound(pages[0]) returns true?

>  		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>  
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> +	stride = 1U << (page_shift - PAGE_SHIFT);
> +	for (i = 0; i < nr; ) {
> +		int err, order;
>  
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> +		order = get_vmap_batch_order(pages, stride, nr - i, i);
> +		err = vmap_range_noflush(addr, addr + (1UL << (page_shift + order)),
>  					page_to_phys(pages[i]), prot,
> -					page_shift);
> +					page_shift + order);
>  		if (err)
>  			return err;
>  
> -		addr += 1UL << page_shift;
> +		addr += 1UL  << (page_shift + order);
> +		i += 1U << (order + page_shift - PAGE_SHIFT);
>  	}
>  
>  	return 0;
> -- 
> 2.39.3 (Apple Git-146)
> 

