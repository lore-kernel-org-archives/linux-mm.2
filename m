Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A94CED25C
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34B96B0007; Tue, 18 Nov 2025 04:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5A26B0011; Tue, 18 Nov 2025 04:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22476B002F; Tue, 18 Nov 2025 04:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C499B6B0007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:35:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F3634DA44
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:35:16 +0000 (UTC)
X-FDA: 84123219432.07.AF93DD9
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D060160002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:35:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZG6o569+;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHMdZCOCGbX2O155/NUOCcK4115xr54Ob6gQNzq7blw=;
	b=rC3MREP2L1iMLxNE2mPw90VRQh2/jDbDBPhKEZPYYcOhEjbtwZZd6M+9weViII3gUB4vV3
	EPDIvxEYHu3LRaKb7VDvbdBibJ3GfXJeq621xY185VVeeaMwkyUBvJbUxUxUj4bPF07rZG
	T4dupZsXmpDclz9GtRfz+GwdYPLmrIo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZG6o569+;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458514; a=rsa-sha256;
	cv=none;
	b=Rz/LYjwQlIPlMpRl9LG1X1vSNPXFwcAv/izsRUqkYTzugjB9lHUfZJ4hzwt1kEJs7av85l
	/CoyQXhzC7kTcQvS4ovCr7xcPAjdvizW2TyG0g7y2EKVTH8iHzoyWqKlmGCL8sRlMhnG8a
	qDRsFIH4bCIVxLmU+zdY3VhUHKfgegI=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5958232f806so5083270e87.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763458513; x=1764063313; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aHMdZCOCGbX2O155/NUOCcK4115xr54Ob6gQNzq7blw=;
        b=ZG6o569+T85/nmtit342HamjW7/uk0O3TpPhl4oWR04tbf3jHphnkVphfX4IMzwqsQ
         sv03rhjetrH6MjhQgvAHO3TjjbNSBZz3bp5j/BNGFTyWSBmTAQnAAeD3ZEmzie0QIv3A
         1lzL5H+rSWQjz0fTix1w4Fa8LOG5UGj1cV1Rxze8q+HyrhVgSSh5awlmZyT5/wOymGmm
         f4VFhcroeq+SUkZMWOkWC3SDIk4W8qO91CVg+6E60EOKhhvC457kFWdqNjUF5+GoC7G4
         +x2JFtHGooTmsvdqtG9BLBhCojD1/UktA0yHj7EeQFvD6+Ucr4QPV3cMi8Uph7MZh7q+
         mVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763458513; x=1764063313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHMdZCOCGbX2O155/NUOCcK4115xr54Ob6gQNzq7blw=;
        b=F+1YuB6kdI9hv0RQu/DpDywidnGGrV8MuUB58NROHS7xYeT5HK3EJuqJr0oayQVugC
         +BJyPyV5V6McH0dUP9qTSJj40x/7huB0OYju9NAdvi0WuS/mONoBzjMZNav/kHtGcdR+
         GKM34V1YJs+vo3KXP890mXZYQXEcZNFHPEAOIIO5IIm6baqpgmQtzJyUmdCkuvqNYmkp
         oIhdvQcekcQOSnRm8JI8o+mP+f3Zo1kHNHdZ2ZZpYn8q12hFeus7aZfJyW11WH7J82Yn
         Xos36VVyDZHMFqjeQ0MEYeu6g5Sdn9OhwoqBDGJBpchhpgSMZ5TSwSCFL8dRSOSXYnA3
         dqiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGimCuR/5x5QRwMsYh6yTrA3MoIM7COn/XJ5Ou8NuTJN+l8ZQ3RtBtUf9Z0YcRljmEH1Pz44HEVw==@kvack.org
X-Gm-Message-State: AOJu0YyanM2oWv8FEnZzqYOAve6EwYte6xS8/jfCHzLgELFMsyj3LzjP
	zNXoKApquRpwoHWPZKp7o70Zyho/GwqpHZcv2TGwmakgs+i919YMV0Mf
X-Gm-Gg: ASbGncvxwXyZjwyBL5Ytn1qjUrGaOaeHd1C46oYjuHlsNtKwMlSCUgfgwIrTUNDq7gg
	eCQg1WBkO591tEUpARmQpu2zRGsknMdbP4ryZizcIm/uPqBPHU+mMRrC8wFC9RbZW1+Q8WejO5w
	jrhz/nD8O97HODgG9nRwhP+L6EZv3NBjDQ+z5l+cp9AZcyECDpsAwA8qTNoojU1x88JTtOGKFLE
	mApYKURX4KHlTgY665qBUzASqJat1lALs7jhX8CYnsEbCl7HMIn0aEJm6kwNogJRI2S+qPdoek5
	7Pn+slVlrrkJguOEUiLbpujO3wSE+5SyardtvUhyLS/emteEJOAUWq976v56kNhiwOmx+LDz7aR
	cA9fRGmd0IEy4aPfyqK2Bv0sG6ufZFv+bJ4eTE1pwYQV65MKijLzEhhGe2gYke6jOewaw7LLoJU
	A/pcZ+FzdmnB3IFSCutCLZ/M/CUpZHOw==
X-Google-Smtp-Source: AGHT+IExm5aC89xgarQdyothH+dB9CzoUQ8H+p8Qx06g62Zn9Tjz5qsjq3/+2wKJFAz0pDGkZ+oHrA==
X-Received: by 2002:a05:6512:3d21:b0:595:80d2:cfda with SMTP id 2adb3069b0e04-595841b4e1cmr4374691e87.13.1763458512596;
        Tue, 18 Nov 2025 01:35:12 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803b3050sm3774175e87.27.2025.11.18.01.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 01:35:11 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 18 Nov 2025 10:35:09 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2/4] mm/vmalloc: Add a helper to optimize vmalloc
 allocation gfps
Message-ID: <aRw9zbfD6Jf9_M2E@pc636>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-3-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117173530.43293-3-vishal.moola@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D060160002
X-Stat-Signature: wf5xd5rukem7f7k78b6bob3td83ar436
X-Rspam-User: 
X-HE-Tag: 1763458514-954465
X-HE-Meta: U2FsdGVkX1/SczqxccXkYGgDOWFixRFi3P5g8656+Zisjz4K7ovHwD/vPg3INJz3tZWj49YR67AUMbhtzhsfHOehhuulhD9Z5lr3FL/YsRQkZWYR47vJgsF+ETyaobO+mslX0lpHh1lkgGndvqFKZh9jk3bPV5IzpRBaz3ebpjPi0TIiBqgh5/nljOHQWBO+Yn+/WAj5yplnYQ4jWg+BYAu6jyTH1tLpy0OOxF9oxbDNDaj3aArhW+a3IiXVdczjz2pepX9Av06rSPvJm000slQRfbV2UqSd5dK5dHCvYIXhZUjs/Cv7XYe7ezkl4KnTQvMYNFPiqCXw6iD/szmoyR0XCAiFOhlX3pwMD/JlKxxfz87g3OLBZz9IKLAvdbputvHid9ozVHEERJboJ4rJrM95kr7RYDUA0xUQB69g1rmL8/H8iARXy7vn9cHGiqPDGfh0zngJJZuxTTkqyEX+ubIdMdDNfoEcNHYprBAVPuaGMsu4PXBQ4hyalvA8t/PX+PdkIYerSnXmAv/2dT4ZhNXJ4asNRH6vtLHR7FcU2bsoXSLtKpvZD0nSGr77ee14daD7R1kJSnhqforMgDFaaybGb53ti72MextyGjZENivJgiIy7WJlAM2N78HSJWEfQ4ajDk4ZtW6GikuqiLgDAPyMs0Ih72lQRftAA9I/TsBkQQZd6xLNnQZj/rJ1wQKoj31N1RpeJtX5+qTZzXn8St+107xX6Yn/B5TrvGqedHDm/303g4xuNxwXlE3cIOELmIHvXPLJTRzKHaW6tdGYGzPte58FiN2Glh6GcOGm1/QUtrUkF7CGr3JcHJ3wypBB2XsOeErk3kYy69EduVfrXsMrbgd6T/HqYEaAUtp3MngkX7H1lucf3J/7m+EyVxtDhnVQymAF0VAIvq0mQPNaQPWV1fRbREa1NeHP4mJB+D7FUxp8PYjkB+ZMcqAqFpAW1odNkJf3YS0N1tdU5E3
 +CLmWIxc
 BDHhaKOdfcBkEol2uQZ3HhaE3yj8kG22TpTqs5jA2lSrwKNp9K1t2C9hOtjttDDnLgGq0QamPY1pnaIyJ2QzHDfyj6NqgsajLXFLJOp/AZAgNUx0vsmxYl7AiY8HW+BKramoBovDVpwXJ7CfntoU6B3IUqtQRqEF31GdZ4S7jW6IEx6DPjkEPVd+UJzdRQn/U6Ax2AA7tByD8uBa25pYHpRo3DKIuKSy6yu1EhM1/CviADMt0f3eARpNqOqFulvzbc2IhXs6O4jLfNFfudFGgoKl4k4ODfeFnl/gmyloA/kohnIBKlwefBOiqoiRNlbHSh/LjqQ2hCI5vYI1uuh8EA2Dtx46+BgiZa0NV9pFWBaZVzav9ZWehccRhbCCdgQWy+e9oUcrY9W1qldMJbh/oRrVtpbc78AM8OXJq59GF6DENOB4cjDaRyGD11d/3QjxiQzQY3BqfX4nvWJysm7s7FZE97zpObYHJfPBxa8IInMOCR1c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:35:28AM -0800, Vishal Moola (Oracle) wrote:
> vm_area_alloc_pages() attempts to use different gfp flags as a way
> to optimize allocations. This has been done inline which makes things
> harder to read.
> 
> Add a helper function to make the code more readable.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  mm/vmalloc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5dc467c6cab4..0929f4f53ffe 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
>  EXPORT_SYMBOL_GPL(vmap_pfn);
>  #endif /* CONFIG_VMAP_PFN */
>  
> +/*
> + * Helper for vmalloc to adjust the gfp flags for certain allocations.
> + */
> +static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
> +{
> +	flags |= __GFP_NOWARN;
> +	if (large)
> +		flags &= ~__GFP_NOFAIL;
> +	return flags;
> +}
> +
>  static inline unsigned int
>  vm_area_alloc_pages(gfp_t gfp, int nid,
>  		unsigned int order, unsigned int nr_pages, struct page **pages)
> @@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	 * Please note, the __vmalloc_node_range_noprof() falls-back
>  	 * to order-0 pages if high-order attempt is unsuccessful.
>  	 */
> -	area->nr_pages = vm_area_alloc_pages((page_order ?
> -		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
> -		node, page_order, nr_small_pages, area->pages);
> +	area->nr_pages = vm_area_alloc_pages(
> +			vmalloc_gfp_adjust(gfp_mask, page_order), node,
> +			page_order, nr_small_pages, area->pages);
>  
>  	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
>  	/* All pages of vm should be charged to same memcg, so use first one. */
> -- 
> 2.51.1
> 
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

--
Uladzislau Rezki

