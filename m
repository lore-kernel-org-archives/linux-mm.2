Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F72FB5EAD
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C262E6B008C; Tue, 17 Mar 2026 10:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7566B0092; Tue, 17 Mar 2026 10:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED6E6B0093; Tue, 17 Mar 2026 10:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC396B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:39:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 428DC89612
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:39:08 +0000 (UTC)
X-FDA: 84555812376.15.7CECDE0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7222780008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:39:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DHAO2bjc;
	spf=pass (imf02.hostedemail.com: domain of 3iGe5aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iGe5aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReWBU8Bc/S6OUN3h3h2h1ud20QtQ0sSv8RvGJ9uBmaI=;
	b=TeLuz384R38bVi5wq3LI1sPfI8E3HlNyZJ1PKNo2oops0Nf7fH+Cq0jJ6EAieSNeN5M5tj
	wbU8Sl2u/GFA3NBG/T3ZmRef3tfdTCbzw16uzXK5NFifHp0amRWwOP06iCkdQbTRkdk+kG
	9URiby5WenGwx81NszDmY2NtBRISPqw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DHAO2bjc;
	spf=pass (imf02.hostedemail.com: domain of 3iGe5aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iGe5aQkKCJEv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773758346; a=rsa-sha256;
	cv=none;
	b=F80+MmIrQ0f5t4e4zJsdfi9rYRw1lZLQb6XAEsbuYRsuhZnfMgdra2xo5MyTopi9bROX1i
	13TnAmuKEBnq94bPLIFz14tZc3NeTS/ZOhospcDv1SKBAYTS2UbO1TlUiaQYorwQwdC4ZL
	Xq3LTaL94URo9yLQIsAmmnnOtacQXLk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48553fdd03dso33810995e9.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773758345; x=1774363145; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ReWBU8Bc/S6OUN3h3h2h1ud20QtQ0sSv8RvGJ9uBmaI=;
        b=DHAO2bjcN2+1WKTJ3dS170wDvT7dxozHaWPTtn7RbXLKZKv14E63ncdfYDoLSMOWYu
         550QBTgtiNwoR55rc748magJjQZicStHkybh3RXBgkGLNPQsliu5R1bFmrGVLmJD4Apj
         N3KgEVOA9J38NPUg+jWC2GP4vLik6kuOgrHkd58pcSXC+ikpgGQPJopG8/lQvab9NenZ
         pokI3Hs+vE8CXbFCyaePCvRQY9WjssETkACs0at3+3eq1hxV+XzYLYyn2EqSDgbqqtb1
         sUBoeRVnWEslzfZBmwsbCs3HXJ5GDBWO7fwerT77HRZ0GnVFYuRf++7rAJDNPDFggpb0
         nOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773758345; x=1774363145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ReWBU8Bc/S6OUN3h3h2h1ud20QtQ0sSv8RvGJ9uBmaI=;
        b=IPeGkX1Q4321prd0Z9NTwmRSYnu+qu5ThKXZJdPEFFgQg3zYJn1wPHAaC7HiT4FKgz
         l7D7YLegKar2qjDl8WgRzXOCvEYCK+ogt27qNEL8ja7DxxAaRbG+xb5ZnEEtYr52/93U
         nKENW37rr4RFaLl4kgq5WQxHPYWrXAHQliVED5b0wXdmZAYAuc2H2glIvRfDpnwvwEUq
         BnUT21s7PI/k3CRM1Dj9npMLlc+TS5sObEsz8VgACt7kG+Dhsu2sjhIOZnlJQZ48p3rL
         3grjJEWj2e8IyXQaLYpKsblrn1WMacz5aqPdCph4cyu0SKQiZD2NP8ft+wa8naT6JuRB
         IzZw==
X-Forwarded-Encrypted: i=1; AJvYcCU91IRjfaoYC0Pfjdn3eVAieZ06+fbIO+y2Qq7aAxrQ0NhFKepot1lmLaTi5km/m7PX7BGSIW5RmA==@kvack.org
X-Gm-Message-State: AOJu0Yw2kwh4O+MO8wOfMGWAvvT2rcVHLj7Yg2P2nc+SU60+NK3OxYeF
	Sg+A7Xq0oMGXI7rh7j+Lz+elMNCUnrJ3nyMpdcu+PtQwDYN4OI+L+E+Yf+hG3ZiqWGGiKk5vu62
	ugM3vFE8bxm04eyuRcQ==
X-Received: from wmbgz9-n1.prod.google.com ([2002:a05:600c:8889:10b0:485:3a14:a74e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b16:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-4855671e83bmr294659805e9.24.1773758344794;
 Tue, 17 Mar 2026 07:39:04 -0700 (PDT)
Date: Tue, 17 Mar 2026 14:39:01 +0000
In-Reply-To: <20260317-vmalloc-shrink-v5-2-bbfbf54c5265@zohomail.in>
Mime-Version: 1.0
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in> <20260317-vmalloc-shrink-v5-2-bbfbf54c5265@zohomail.in>
Message-ID: <ablnha2sgGUMO96d@google.com>
Subject: Re: [PATCH v5 2/3] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7222780008
X-Stat-Signature: 8ac4za8kzw7qtyhkexy4uguuyidmtcti
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773758346-12278
X-HE-Meta: U2FsdGVkX1+ZT/9s9BUPtJWfoHjWKNSjQztR6V50mF9PjABtYKrDgYWzUXTreCUPJnhK8kpHI/B8vYQzTOF4CPaAcqPgsdNfv/MU3MdYiln+8ti/uV3HjkX/lfYmpXEsreTxU7dOGAWSbzQEh4efmh0F26xMK0VXgo6YLmL7NkTmNM2kDCIhpU/x0YK6IEGbh26L982qBYoXdc6sAwlmBFwMprlAdvv82zuWm6IrN07+lY8jpmOTEaUxQ8RPVadz01zKkNymaEWfD/PSjFqCOhFXTLNrG//wv3Sxz0Wi+wbQIIYYfIqCDnKnCKoe5sr8HZoPsJhw14LvxUsqOWWnZSWSpcn43CVpRDx59CVt3fMmwt29eylu308zedoACsh1ODu0NxPu73AiCkXU5mnieak6LZGgBiGK0MVaOTFG8vOUYab+b7RVSqg8pVH+swwAPsds+DJ2ASW5uRfcwZPw9xvOdvzf5wttn4Mgs8Hr+L4qkPED0+ZO99ZeqLim4AQuoF/w9kHEw5XC5HPfcdamis23c2UMVoLFs1BktxCs0Y0dOdaulaV0wusLFF/cww/2EY1gSS98dQt+WxIB4Py7g4CUqd3TwkL74iL7IHmQ2slLxuqIjicZa+c49hyksBfOrIga1Fl7rGNQvYPgWPuyoo99bMYRF623Cb0a0wRKupxdghgbOEW/Ryj6a09NglVomKNJ3Uzn9RJoY2rRmLsGxRTbZaIN7HNCoR0Oldpo+4rwQN32ALSM/UM+PGzBUYKuXse5LgRAVy50iySn9jn9D62Xlk9e/1ysJhVD/L/wEN0wzBdPpZMK2+ZbEa8d0EpY73V8NvII1CAqYY9in/C7xZf5/drF0xmGKw2E4JWVe3DIve2YabjsKKbaesL2kuvTK4PSKV2T6jl99RmEdu23b+51YtTbyOq3CyNsenIfGC/SoWpB3KF3w/xP3k/3+SzVN6FIx9TWRiOTIfoANvs
 UhwTaFE8
 dKOzTfPcKsQXZRzBimXc2ZvqP8tlncthPUNttQycOd+zwR6G2Bf3w+IZAOW56JOP9Q+/xle/R/acqnTYaRITEGr0b5SPMEP6yDhy94FpQRViVQ4d3BSMyTuP4V9r4WzNc7fJXL01ExN6Hx0GREWDecZcJiY0NVBdhK2SYZkggdvRVhdqo7hiIDTOj9VluZdrWJ0wvmVWBVJnd581m0pR8YpX27oM4qmQvL07w87XVeK5BoZbSOPaLziCwRNURVnYZvyQOTaCE8Rrt4ecb8ff1RM99+5cV2kV9Tz5xc72Cpavu4tMgDQyxirEBhkYFv9g/DW8R3O1cFOSOJtzWtZF03UkNXkutAtmYw4IPb1YYK2j3bslDwe7psrThogeC7CuwSaPDkDuV5cOc4iWU1sjFV01e9ZCRo2uwwBEXECu54IdvQ9/7GaRZbol5Sj/UmAmMdpmEcNeqkxklBobaRfHso/yLb5L0RsgHOLX/oXhubQfd4WE42y3qOFytjRkzE72avDdAZtiTN0UJOMKle54aJHHZfFpvnbWFi2IdhB9gxat0HFwky34hS3g9TIcuSXpt7rMu5qXW0fCGC90KJtNvN09xIPrIqbY8D5h/NXCATJvsR/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 01:47:34PM +0530, Shivam Kalra wrote:
> When vrealloc() shrinks an allocation and the new size crosses a page
> boundary, unmap and free the tail pages that are no longer needed. This
> reclaims physical memory that was previously wasted for the lifetime
> of the allocation.
> 
> The heuristic is simple: always free when at least one full page becomes
> unused. Huge page allocations (page_order > 0) are skipped, as partial
> freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
> are also skipped, as their direct-map permissions must be reset before
> pages are returned to the page allocator, which is handled by
> vm_reset_perms() during vfree().
> 
> The virtual address reservation (vm->size / vmap_area) is intentionally
> kept unchanged, preserving the address for potential future grow-in-place
> support.
> 
> Fix the grow-in-place check to compare against vm->nr_pages rather than
> get_vm_area_size(), since the latter reflects the virtual reservation
> which does not shrink. Without this fix, a grow after shrink would
> access freed pages.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b29bf58c0e3f..f3820c6712c1 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4345,14 +4345,24 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  			goto need_realloc;
>  	}
>  
> -	/*
> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
> -	 * would be a good heuristic for when to shrink the vm_area?
> -	 */
>  	if (size <= old_size) {
> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
>  		/* Zero out "freed" memory, potentially for future realloc. */
>  		if (want_init_on_free() || want_init_on_alloc(flags))
>  			memset((void *)p + size, 0, old_size - size);
> +
> +		/* Free tail pages when shrink crosses a page boundary. */
> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
> +		    !(vm->flags & VM_FLUSH_RESET_PERMS)) {
> +			unsigned long addr = (unsigned long)p;
> +
> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
> +				     addr + (vm->nr_pages << PAGE_SHIFT));
> +
> +			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
> +			vm->nr_pages = new_nr_pages;
> +		}
>  		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
>  		return (void *)p;
> @@ -4361,7 +4371,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	/*
>  	 * We already have the bytes available in the allocation; use them.
>  	 */
> -	if (size <= alloced_size) {
> +	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
>  		/*
>  		 * No need to zero memory here, as unused memory will have
>  		 * already been zeroed at initial allocation time or during

Hmm. So what happened here is that it has previously always been the
case that get_vm_area_size(area) == vm->nr_pages << PAGE_SHIFT, so these
constants were interchangable. But now that is no longer the case.

For example, 'remap_vmalloc_range_partial' compares the vm area size
with the range being mapped, and then proceeds to look up the pages and
map them. But now those pages may be missing.

I can't really tell if there are other places in this file that need to
be updated too.

Alice

