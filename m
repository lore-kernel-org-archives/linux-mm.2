Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FEB1125854
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57546B008A; Wed, 11 Mar 2026 13:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F5D6B0092; Wed, 11 Mar 2026 13:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941B96B0095; Wed, 11 Mar 2026 13:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 814596B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:33:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24E595800F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:33:17 +0000 (UTC)
X-FDA: 84534478434.09.11766DE
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5D471C0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:33:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjaM1mVP;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773250395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32P43u5/pepmI+c39ykZxDjXGtV6qTvip6R4B95J07g=;
	b=ZamlyFhj1xXHtS77zR4fSrMmHrzQ0SB8nK7IvPIGTNaayST/HMhXCKxQEArrlf9EbeaZ3J
	qkIozVd8nP4vMsN+VzI+fYs7b3PoRzFQ9AvtYJBT33Dsx9wjxCFjBWwyQg20gtOelBhG1R
	3Zv0Igw292wbIIDL0yu+g1FkPh2gT+M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjaM1mVP;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773250395; a=rsa-sha256;
	cv=none;
	b=xgDNuaBdqSV5XP0PZFoJXKOj2n/k5C1+YycWGWx+cowqlR629v/50zOSfjkpguw8f5MDOI
	9VzIsOL39WCCX/seeNzj+JBWJoHpS2bBqbEjirYm8d1ropeTFxgG3ZvFwvSNLOSUTMvd6s
	Sm03nv40ZLMiZWPwdYqTEyqSoyertao=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38a3066b68bso1751251fa.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773250393; x=1773855193; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=32P43u5/pepmI+c39ykZxDjXGtV6qTvip6R4B95J07g=;
        b=AjaM1mVPQhe0bGWucf5DrdxMRLE7bXjMxRuuxDttvVbC+GPujwWx2oJXziF0e0fSuB
         yjP+nNowvWJOQ/iJu00qqGYYcUKN3Ji7xs9uUfRXJUJ0WNrTfjznLYp2dqmkaZH0FXsj
         ffAgAPBEfPula4gP35ckQbGy3sVUWZz6s+QCHYLrO61I2bKfXmb3J81fju6dawGoh9fE
         /j0+Hjx98dnfnTaxA1xDUu/HHh5F4aH2YAov5ffCpT4yGIA7R9OWVUyhW+5RztGMQ314
         rzIzgB9Rno+3XskjoMO4GNL8k3xY7+wybPw+/YpW3++3pxALx33AREYqhseDG7pr/dqZ
         gZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773250393; x=1773855193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32P43u5/pepmI+c39ykZxDjXGtV6qTvip6R4B95J07g=;
        b=V0iu/XrCvkDq8K7SolIKZ5pIuA4EaxGiFs9LmAkw/cCV5nLJuGhEWcFKr73cmQ0JIl
         bcFTBeMsaTNzxW/EdcOVwPHPRlzTAzqvlQYusOkN0VLjQOcTgTNjjCTxJK0Dyprvb12h
         mObmNfQYPjWGBAxkn57tTBMT1hlT+E7Z2IY+32ya0Xaep78aEqHE4NfCdQe5NMpsUcNS
         +gQNyMb9WfEMzVgARq4/yP9U44K34NdT8cGkJhsbc01lKHRrnI/mtZu2vqLuvT8UJ0ma
         WTj4DTo35A/n3XD8kw5NWybwUN1Wf6Ui+Hwv7L7IxVV26Dj2v43zFSQzIJIOvlEcbBFO
         mfVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm66n/LTsSaUqcRRtpO4jE+Yyac1YQQEbZwhI7w6Mk78PPglwIWeczPhsvPg4Il83g67b/MoK06Q==@kvack.org
X-Gm-Message-State: AOJu0YwmcM89IXhjKrI5g/AoqZABor0hFRgKcIhHj0pihAGv2IwtH6it
	EmUsIjEnu/GPFFwRvDmcB+mdRSDiswHIIqPu16k8kP83B1OZlPdI90B9
X-Gm-Gg: ATEYQzwseHBcUk/+BEhYJt94mXrKfCJ2dtWBHKm5nTsTAWIdDqoYzprEfBl/ysczgdA
	Nma3JPytuaLdyMWgwBNW/dchIpphgzCWbZ2Ki4ej2YKdHqNBlqFcaIAR9cjpO5MKStgKa4xdPIc
	Jj6fvWcVEYA4mN8Wu44Y/e0LDS91xCqB49Fgox23fFdLWTpQf5L9sm2lRW0ZegUtjsWp0sGhpTb
	Dcfz6Kb1V1opaY1sdnf+b0t3Fd8jcHVd8qxo7dq8r0UTF1xrsCpW2CPXKkHzkgUp219t1DO0ZIB
	B0qd3E2OivQ3zABoB2zd+RzhQQ5H+AduAVB2yEPk65TdlNiry3elPmXKwW2x2tdtbQJcJKyaMza
	LnF10fGV3OEhNVPqc4IDKExaSv2O9KWtkdPzFch5yxE0s7dO01kllXtX19QjWanpbRwTNcDfYuF
	c=
X-Received: by 2002:a2e:bf02:0:b0:38a:3feb:d2ee with SMTP id 38308e7fff4ca-38a67e68170mr11805311fa.32.1773250393105;
        Wed, 11 Mar 2026 10:33:13 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38a67d61851sm4620541fa.4.2026.03.11.10.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 10:33:12 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 11 Mar 2026 18:33:11 +0100
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
Message-ID: <abGnV0Nh0rVB26sc@milan>
References: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
 <20260304-vmalloc-shrink-v2-1-28c291d60100@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-vmalloc-shrink-v2-1-28c291d60100@zohomail.in>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D471C0009
X-Rspamd-Server: rspam08
X-Stat-Signature: eanc1b715kiqhewh18r66ib8xifyc8et
X-HE-Tag: 1773250395-59471
X-HE-Meta: U2FsdGVkX19Aht6F/38xy2pYij0Oq5nMNrCi4cUPJHTei2xBvkmufOuRUXoqroY8w952lAAEEpJa19WzhLWdMNP/2yqETE+b/09EIy/AmVi1Tt+aJ7qkl04lLKNAFG+REXju5XrvrcQ9tpp+rolkoJMjzSxWJzEXU/5GHPFyF/FlRkNBvkoc09LKjzmbE10SWSSJj0D5ONvcsU9MuvKI/jyUG0/J1K1Fak8cuvQuPVGMk8oUdP5LbTs3DhX+3LzeoqXZ3ODA3Yk2I/cAJGV2PrK/X/DZxvUl3+En9HVEusg0abzUMZlnwZW88rSLo2akh4PzVrnM+zQbk3HlW3jexW+YTa+cAu+uxQMMmVuQtNOJWSO50i1du2/cYYkxkpUzJLA0qlcvH1D5diCncTtg0LbuJdeyPwuroci2LOGGKcF8r7bx54AfNlkfHWoQNcNWULOIuLHmiGu6hY28s7LxZ6uhzVQgqid7ovtb4ujLqMc6I3uYq6RDGYnWwVDdia45zFhHXg5nMzKnkfZ/28DL0EM5aEXVo3QdVOofTSpJiM6Xyhs0W9cagYwvFUw3nIUMd8js6aJCD1TAg8hCYbx2HNcCJbimsvVyVFb90bX38xalwtD2V0gFH0TeXM6Sv4XKTO9FpBoSHS5Lg2y+Nt9INbRlVf9Hpz6Ny8i0jKTwX9hMefaDDa4PFfp3pkf/EB8L1udo2lzX9m+v4K7ZLa00JNJnedINuItUTm8PlUeAqfsghG2jPrtt1ssoqUwOkxZe3W2Hrgi9Agtwpl4v6Ik1Nfu4V5tusKS3VmiesqLd+vfnZulF9KhqSjg98lHaOFm3LSlCb3t0y7qYxjMGe+nr+bKMJ7aAnYdxW5U2jKgyEmin4PfCzRQopCKt0K+RrgjXAQLZrkAWlRvR9t5ssKMFT0lH1ZSClKzz7HacQVn1MZMftjf4d+uAnM0WWM0kd7ZoDzCMW74tW+wR++woFbs
 393mZfem
 nXbvfwShSk11+QehdZOlLWC6wbZ+S2MV1Mt/pZ4IrhXjsyqOSuwqg+fAMbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 08:23:15PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vmalloc_free_pages() helper. The helper operates
> on a range [start, end) of pages from a vm_struct, making it suitable
> for both full free (vfree) and partial free (upcoming vrealloc shrink).
> 
> No functional change.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a..e2aef0a79f2e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3416,6 +3416,32 @@ void vfree_atomic(const void *addr)
>  		schedule_work(&p->wq);
>  }
>  
> +/*
> + * vmalloc_free_pages - free a range of pages from a vmalloc allocation
> + * @vm: the vm_struct containing the pages
> + * @start: first page index to free (inclusive)
> + * @end: last page index to free (exclusive)
> + *
> + * Free pages [start, end) updating NR_VMALLOC stat accounting.
> + * Caller is responsible for unmapping (vunmap_range) and KASAN
> + * poisoning before calling this.
> + */
> +static void vmalloc_free_pages(struct vm_struct *vm, unsigned int start,
> +			       unsigned int end)
> +{
> +	unsigned int i;
> +
> +	for (i = start; i < end; i++) {
> +		struct page *page = vm->pages[i];
> +
> +		BUG_ON(!page);
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> +		__free_page(page);
> +		cond_resched();
> +	}
> +}
> +
>  /**
>   * vfree - Release memory allocated by vmalloc()
>   * @addr:  Memory base address
> @@ -3436,7 +3462,6 @@ void vfree_atomic(const void *addr)
>  void vfree(const void *addr)
>  {
>  	struct vm_struct *vm;
> -	int i;
>  
>  	if (unlikely(in_interrupt())) {
>  		vfree_atomic(addr);
> @@ -3459,19 +3484,8 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
> -
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> -	}
> +	if (vm->nr_pages)
> +		vmalloc_free_pages(vm, 0, vm->nr_pages);
>  	kvfree(vm->pages);
>
probably we should move "if (vm->nr_pages)" condition inside the
vmalloc_free_pages(). 

I think, the function name should also be renamed to something like
vm_area_free_pages() so we align with vm_area_alloc_pages() helper.

--
Uladzislau Rezki

