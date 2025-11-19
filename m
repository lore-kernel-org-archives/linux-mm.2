Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88359CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B546B0030; Wed, 19 Nov 2025 10:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73316B0093; Wed, 19 Nov 2025 10:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C628C6B00A4; Wed, 19 Nov 2025 10:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B30616B0030
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:47:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BA8D1A054A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:47:00 +0000 (UTC)
X-FDA: 84127785000.13.BD2E2D2
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9317080018
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKRJa3uC;
	spf=pass (imf02.hostedemail.com: domain of shiyn.lin@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=shiyn.lin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvPsLnJlaWu2F6OT5JjzCMnTqASfwe9lxO3A5pGz61Y=;
	b=KWbFCFCNzMy1d1UNo1vzCCqGu5eoAuXfHu0f2DIdGxa2Ia6LwfhQ1hGPQQWY/u7CZoLaWk
	Smu2y8INf9Iepq2WH2hi/OGzEpX4zC8yqPiEbSMjkhnuofriz4mKFfGbbmagMiKx+zO5Px
	La8Vf+Y3AqyJ3MOC6HklJfO1qkIQQzw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKRJa3uC;
	spf=pass (imf02.hostedemail.com: domain of shiyn.lin@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=shiyn.lin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567218; a=rsa-sha256;
	cv=none;
	b=XveA6ej3vzH7EPqeuyRWILYUfa8wFU9uFNJX+jhb/ud2KRcxBJsSAx6OCVfixcT0nrzBfm
	sec7euMwsXV2l2+5+kElrCGj83oeMnNttYGICRhwUXwEbpDIS5rU7KvDTpGwVhU8hwwx32
	LlFoHChT5SWKsKMsj17e9PVNcA36vlc=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78802ac22abso68307087b3.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763567217; x=1764172017; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvPsLnJlaWu2F6OT5JjzCMnTqASfwe9lxO3A5pGz61Y=;
        b=cKRJa3uCmtz51QW5TweEY6vN0pkYyoWyYOro6UNDWp3x7+JeUV6E096SfiA5UN/GWY
         ZlkjgDSfBKkaw/acBCWH1KaAiKGMHEuRkcGuYNv1IdL1kmv3To7LJDiI2iTOEKHwLybH
         IsFMJ0di5VG+g4GQanVGCMS9tTyyfVUPeIc37wAHXRGroZk4b0bvEIITLzSG/jWnkbxz
         u7oZdSw1A/n+QMFmwRx/vTtxrxFalWr8JmmrHAc7QtFa+h/F8wqgkPyPQY41rk6a4Uwq
         wJOv//1Uet6jFTYXic3maWUy1WzfwKgyXseDxrmeZa0KMnkG8BEhit+x5BXACEwHCKPv
         M8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567217; x=1764172017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UvPsLnJlaWu2F6OT5JjzCMnTqASfwe9lxO3A5pGz61Y=;
        b=uV4ZQ9eR6g51V720Tcgmfkn6cIF9ebEW13HlqvzYPODRhXPNkTc/Y/al2Pzqj6ykH+
         5bv8Uws02+6cEKjFvuoBfcXU7itS1Bl1Gd6mLKaIcicIgDs6HsCEzxbVy3iIpIiOEoob
         tKp2XOQSYQ1ocF30dcISUAorRiG7gENGvJlu7OgEMTt7Mzz2IwY3w+6Z30gp80CZ+gf7
         e2ABnKvqY3YxymEOJs2tuSO4BnOQQgF3F7kH4lFx3AHWGASMkkYqrY0S9K8JI2BhJvrh
         W6P/5DRN3gNVZ8aPumOlC81+iCMYll1KS67Q4BzeMoeot7BM1LtnZCdstBfzE7DiHYeI
         H0NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfZnZMxOXzW3rjEm0/VhiqKE+tzV0KwuOkuv7oYLeGvOzax7JQHGS0KJgNvWJW91hma1SdcOmLjQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9BAFWhAeUJHewQ6gcCoWorfAgVdo2abUI1yXlKhe3/E+lKGcy
	udrLyOcKvPJhVQi92J8WCLRK3t+Hwt7wOFpP7AGk9ivdUoTU1589BAMf
X-Gm-Gg: ASbGncv+cohFbpnQxFqKQUWCdSnOBwpQ+1hQmx/UF9RHQOP4pZlMLgC3E8QNyLHsczb
	KseP2TuxiBGj89Nv166IRqZjRbhVoSs01DFctMSIi0F2YUflX0vlP4+fObhz7RK0voWO7+QRLE0
	wJ+BdXpo/xHyFb/CYtOJwagR0x0hgeBASAjMuiu13DqQRJ6nf+4OoMMNpPSfc87qmUNzI4aeJS1
	liK/JwOrxVZfh6BGYHe8NXqCi0EM29kyegvWEtCzgZl6cZAvB+bOwgsJ8EMyiduCiJfcGU+h2i4
	s6vAN4ULSbrcXcHdsv4funAkR4JORmK7ZsFLYKo8QAx2l+BkYUbgP49jxMjuHm2OP7F0iIj2DZj
	wRM9KOO8cYlODJ23VgIGS7jXeu+R1cbYGcO38aLJeOE4mhPEytgaf/r/O466mtHFg9jXCsAHXz/
	08VXd3TDzpJ9GMQJCoufj/jUN+AEOeBh+pNJHpN9N4npl1NhIsUw==
X-Google-Smtp-Source: AGHT+IG05GIiLIv3UdlKS1ewmXNIY0R8fuIAahGHrnF2gMHxu9TpZ2X58PzW/tVB0e0EFfkc3w8aHA==
X-Received: by 2002:a53:b11b:0:b0:641:f5bc:69a6 with SMTP id 956f58d0204a3-641f5bc7272mr8517444d50.84.1763567217487;
        Wed, 19 Nov 2025 07:46:57 -0800 (PST)
Received: from gmail.com (pal-210-106-61.itap.purdue.edu. [128.210.106.61])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e9e964dsm6988815d50.5.2025.11.19.07.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:46:57 -0800 (PST)
Date: Wed, 19 Nov 2025 10:46:54 -0500
From: Chih-En Lin <shiyn.lin@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <20251119154654.GA606021@gmail.com>
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113140448.1814860-2-willy@infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9317080018
X-Stat-Signature: g18mtk1odwohajg9nghhf43bdw7i9mfk
X-Rspam-User: 
X-HE-Tag: 1763567218-915427
X-HE-Meta: U2FsdGVkX185KCCIlRG/55GTp+o4LLF96CRmcvJMLGXrU9k0v7D8NfGleqBvLilgvQ0Gn3+9/J2wsQ/ZZfqo3RUxqKqMAeVQpVVF28WsWT+HcdWVTOSgH6WXIll3Chk1uib4kkHOaOpKucHtn2RIbP+juWlZdwD3dDBQ/wZEPZmSuM94E0jF1oxccHp8GMmvCvFD/WPus3Vvm0sA619XzJZE0ZdymbmYtXhJvEWvrAPJGC31b9DCIsVvhnrsdUfaoG022aumXiSK0Vx9E8otwAT4Fr3GULD1mx7yoAD3McSJzau8ijHdyym2GIdkJBORZ5TlcLHZHlT2RAhMJsOZF1lWM6wS/EA6EXkrRSid7wla5s51lZcUOW02CSbhN3F6NJ1s+3aRkWCEr7JI8yot0k2g/qiV4yBZMR06d/VGC/K/dbxjq62W8+X9278jFJbdmTXKNWEZr6K4tJJUIc5UbVi4pHExc3cdZl+pZLdNQbhmnjwB6MXXEBp0WJ/TW8Sh/UsFt2zL3LUEttyPXbucXtNVb7fw+bB/HspC0vhIKHX+rG9OUpAYfTKur6SVfpkzGV0gx/bp86LpNFFZcZJ0EL0izi9EbD/oW+H9VQ2Jz6tYxfamylRl/CHZb9RMxvWC/lLjempuFguMMXimw6e4cptnBWdhwMiZnJlNIV1vEAADtDUbRCbAxBqPJonrO2tLfACAcreWQOHQyYjVL+OLWwKD25Daab/kUXpdFjn2VkwxrOZ9vJ7NaVAcmzRyPdq6G6O6EpipsfDQY24N3Jyu7bCxGuKJn2cPXbQvim3Uheromh+O2Fkx9VhFCctpZ4TvRiVMY1A2h0nw5O2roiAdeAIs60uy1lXw2uC+sHzojm5q5429eTSwnO3rNhDWvh6Xk/5TXab4+7yEHO3CrlpXz3Zx/Tj5IFrKvdus+eoZKA7Fu2xXiIC4rDDzexdQ2Nu3xUFxQ+1ry8xeTbLS9iE
 MBHr674T
 eJauamKbhaeuD/+MuHkPCB5L9WYdXSKlvbL659AhqvqgiQeT9g2DHJcn0dCvi1mL1O/lcIIktpdisqxm6mzUmZvf8tftb7ZylFg8Hen7rFu9JzpCr+WIB0qqJKQxjKwhhjFPxZ1+qnlEuOIx06DNWC2eCITC6p5sytWhWJridFoE+Tc2cj90ukLlwBRBFsxmvbgbnJvq33kMggu8ZadCicqk5dUG8MTxY90+BsKYHVoEy4nEDkyowmXwthTu6ZmnEARLtluYN0Nq6hi8Uk85VvtSh8Oa1FjjNTJ947JVcyzxj5++vJYlzG3pYHvq0KTaCalobi2Rd5PYNvEE6wFjbifpWBfTjWMd/c3gp8oAZwR75WkvVhdsUKeMrlpe7sPAuNt4PjCQDoEMzGwURNjoLvnJal31sGBDuVmNAwRrK6pLAZox/6/yJA9WhcEhCEbNqzlmPBCUAia6NnQ/tmVX4LnKhmFv7BKn0yaxhfYLe1KfkytQ4xpOFFhiKqpyEk3FqBX9fQwHPq1XSj0LaQbe8dR1YKsPFME/+wlmttP4XjlI0c/0D2d5+Q9DPKdNcQ52hXw4kYZ7/1O/EIp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:04:43PM +0000, Matthew Wilcox (Oracle) wrote:
> Page tables do not use the reference count.  That means we can avoid
> two atomic operations (one on alloc, one on free) by allocating frozen
> pages here.  This does not interfere with compaction as page tables are
> non-movable allocations.
> 
> pagetable_alloc() and pagetable_free() need to move out of line to make
> this work as alloc_frozen_page() and free_frozen_page() are not exported
> outside the mm for now.  We'll want them out of line anyway soon.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h   | 53 +++++---------------------------------------
>  mm/memory.c          | 34 ++++++++++++++++++++++++++++
>  mm/pgtable-generic.c |  3 ++-
>  3 files changed, 42 insertions(+), 48 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5087deecdd9c..e168ee23091e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2995,58 +2995,17 @@ static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
>   */
>  static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
>  {
> +#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
>  	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
> +#else
> +	return false;
> +#endif
>  }
>  
> -/**
> - * pagetable_alloc - Allocate pagetables
> - * @gfp:    GFP flags
> - * @order:  desired pagetable order
> - *
> - * pagetable_alloc allocates memory for page tables as well as a page table
> - * descriptor to describe that memory.
> - *
> - * Return: The ptdesc describing the allocated page tables.
> - */
> -static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
> -{
> -	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> -
> -	return page_ptdesc(page);
> -}
> +struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order);
>  #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
> -
> -static inline void __pagetable_free(struct ptdesc *pt)
> -{
> -	struct page *page = ptdesc_page(pt);
> -
> -	__free_pages(page, compound_order(page));
> -}
> -
> -#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> +void pagetable_free(struct ptdesc *pt);
>  void pagetable_free_kernel(struct ptdesc *pt);
> -#else
> -static inline void pagetable_free_kernel(struct ptdesc *pt)
> -{
> -	__pagetable_free(pt);
> -}
> -#endif
> -/**
> - * pagetable_free - Free pagetables
> - * @pt:	The page table descriptor
> - *
> - * pagetable_free frees the memory of all page tables described by a page
> - * table descriptor and the memory for the descriptor itself.
> - */
> -static inline void pagetable_free(struct ptdesc *pt)
> -{
> -	if (ptdesc_test_kernel(pt)) {
> -		ptdesc_clear_kernel(pt);
> -		pagetable_free_kernel(pt);
> -	} else {
> -		__pagetable_free(pt);
> -	}
> -}
>  
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
>  #if ALLOC_SPLIT_PTLOCKS
> diff --git a/mm/memory.c b/mm/memory.c
> index 1c66ee83a7ab..781cd7f607f7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7338,6 +7338,40 @@ long copy_folio_from_user(struct folio *dst_folio,
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>  
> +/**
> + * pagetable_alloc - Allocate pagetables
> + * @gfp:    GFP flags
> + * @order:  desired pagetable order
> + *
> + * pagetable_alloc allocates memory for page tables as well as a page table
> + * descriptor to describe that memory.
> + *
> + * Return: The ptdesc describing the allocated page tables.
> + */
> +struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
> +{
> +	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
> +
> +	return page_ptdesc(page);
> +}
> +
> +/**
> + * pagetable_free - Free pagetables
> + * @pt:	The page table descriptor
> + *
> + * pagetable_free frees the memory of all page tables described by a page
> + * table descriptor and the memory for the descriptor itself.
> + */
> +void pagetable_free(struct ptdesc *pt)
> +{
> +	struct page *page = ptdesc_page(pt);
> +
> +	if (ptdesc_test_kernel(pt))
> +		pagetable_free_kernel(pt);

Should we use test_and_clear_bit() here to prevent the double free?
Or it is unnecessary because the caller will guarantee there is no other
thread that will free the same pagetables.

> +	else
> +		free_frozen_pages(page, compound_order(page));
> +}
> +
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
>  
>  static struct kmem_cache *page_ptl_cachep;
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index d3aec7a9926a..597049e21ac1 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -434,11 +434,12 @@ static void kernel_pgtable_work_func(struct work_struct *work)
>  
>  	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
>  	list_for_each_entry_safe(pt, next, &page_list, pt_list)
> -		__pagetable_free(pt);
> +		pagetable_free(pt);
>  }
>  
>  void pagetable_free_kernel(struct ptdesc *pt)
>  {
> +	ptdesc_clear_kernel(pt);
>  	spin_lock(&kernel_pgtable_work.lock);
>  	list_add(&pt->pt_list, &kernel_pgtable_work.list);
>  	spin_unlock(&kernel_pgtable_work.lock);
> -- 
> 2.47.2
> 
>

Thanks,
Chih-En Lin

