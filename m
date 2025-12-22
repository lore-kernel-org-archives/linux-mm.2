Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C79E6749B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 11:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D846B0088; Mon, 22 Dec 2025 06:47:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB1C6B0089; Mon, 22 Dec 2025 06:47:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C926B008A; Mon, 22 Dec 2025 06:47:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9823A6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:47:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49048BCDCC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:47:58 +0000 (UTC)
X-FDA: 84246933036.18.0A1964F
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BD96140017
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:47:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UOg4tbNx;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766404076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/foXhPAufi6uRtrLX7dAC2wGmj4Wzh3PyX8slXMF67w=;
	b=vOxO0K73cv2i9lCNvmycdA4K/u8EE6E4tIQRcFrHR6DfQuKGRxjhQnYjxRqVtSYE1Ik5rS
	9sbhddPHwPucMnxIkSY384utX47jvHmwzjKXlLIsolJEsoLbjVurvAqfRa66NtIlaJcGT9
	0IMf3o3EHVBaXhsGzOR60q4ko8KVt0A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UOg4tbNx;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766404076; a=rsa-sha256;
	cv=none;
	b=Lk0E8ULKr/165y1tKkURHOTf6jsdov0GHjUoIygFuiXru3icu6QU5+JXjCzm9d2tfaMDCA
	cqcH9j+5HBuNslcWduYorBTcxiXyd6ANDhcomxZDTkPxzenNtwr7QBIk50jBdUQxLflHKA
	XTjIxzI1zZWeWucnAHe70ReS5k4Z5W4=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-594285c6509so4167919e87.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766404074; x=1767008874; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/foXhPAufi6uRtrLX7dAC2wGmj4Wzh3PyX8slXMF67w=;
        b=UOg4tbNxeXQy9TiRhvFdAhhZqGSaVtfBKJ6sub2wnpiXvhtuvV4w4teRBbwrsO16l0
         VZ1EUnOrzb2+GbclvmFh1NB0b4T/23jG8D9ApY1KzBvMXx+kA4q0PQwS4tD0eIImcjdv
         NUkNNfbLd1dbCzCXBK/KdNcERrdYnbmMAm+kmsBhfU9AqHqm63DS9bABYpKzS1RNE4BI
         XCFkgpzGAoyk+UyQaSpBFv4fZN9ufS+OpMXcgyPdZSrF6fYXKegVTpBGk/mupVFfSrx4
         MCUW0GcfWQMDG4nAY3ZjucV1TOU/34KxEH52Of1nIAkRQ27E2AWbUFqxNsgT1yS8sqoW
         v8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766404074; x=1767008874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/foXhPAufi6uRtrLX7dAC2wGmj4Wzh3PyX8slXMF67w=;
        b=iIQT7zVEzByERF5vBXrFGNSyrvHxLwDSgNwGG08hCS3NbcfXT3zciSxhrlZ1vofkgq
         YwOhZsT234/lap1GU4zHbv64BvenbJhY+OdGMPnx+qXO/eMiott7XbeEZhtw7gjT8Q9l
         c4rg1rxdsEbjbjpodSlZUysyOsE8OxlGW2JazjCHycAgPtzroIvSq/Ts/mt0UgOwl6Jh
         uZj51COyUJGUPWtALoR7q9mFuJQdGpGeJieK/vLwpLqol+vdNFDPJ/XVa+Cjv6NiSFcj
         CCTCZvWq4TnRWP2Twe7dia0Tw8nPHEosBE6iB6VGzVlx4djbSvGVdmN3xCIU9dUDTH4q
         vmCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaYin25k4B6RVLaA9VnPeil4txzwwli+h7wHw/zzDwH2hntVT3Edz2hvweSpxdVUB0FFDcn5C+mw==@kvack.org
X-Gm-Message-State: AOJu0YydqVqBKmLaGaTbcxsmG/GOus2Dx3Pqet12scZdwcxlLuXc7gFX
	gwXscFm99XfN/oCPenottlSiGa+C5JgY2OLwAU+gsZnFXxBKJVQ2YY71
X-Gm-Gg: AY/fxX48x7TYl0cCAxvZBgE4Vwe/SSVCCuIUAbQJDrpmhAcRtS3z/rDYIRog+BBBcY+
	JLVJPAeW7SpmJafT1YQpB2aoD2iV552XbVejTlMQ430SAtzaHOPZ6qwlA2bp5NyCtYBHWpSShxB
	O66/2dheuINTqxt7Iui39BAq99dPanx0/HvMzVZ5jcrq+l/6jxjpCyardzE++g17U6/grDz24bM
	gj7XdCyj/qzL7SkXJuRB4CE+wJiDJCqgkU96aKKRDGwvWY5lsoSnf86E5WDTtrwLKJBUeHeENqS
	b/a3+fe+7vHbDrLyIJlhStKCAQmWzUQ3JY+5psZZ/i7FaFtRDNoqcN27zOptTegs7YeP90majn1
	+9hzvyBlHhGCXJt6B+zRjFROGGRLRtng3Mx1aONVjWmPJsFybBn3D
X-Google-Smtp-Source: AGHT+IEsiLInHUpO0B9wn6rIRScWVJqdnac8pFBEVqqQC42l41Q+lmgzVoCpWhWhGmaRmpj1YynoXQ==
X-Received: by 2002:a05:6512:2388:b0:595:7e8e:3bc4 with SMTP id 2adb3069b0e04-59a17d5a4f1mr3593333e87.42.1766404073974;
        Mon, 22 Dec 2025 03:47:53 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a185d5eccsm3157947e87.14.2025.12.22.03.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 03:47:53 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 22 Dec 2025 12:47:51 +0100
To: Dev Jain <dev.jain@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
	akpm@linux-foundation.org, tytso@mit.edu, adilger.kernel@dilger.ca,
	cem@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
	shijie@os.amperecomputing.com, yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, npiggin@gmail.com, willy@infradead.org,
	david@kernel.org, ziy@nvidia.com
Subject: Re: [RESEND RFC PATCH 1/2] mm/vmalloc: Do not align size to huge size
Message-ID: <aUkv51yk8lgzW9jv@milan>
References: <20251212042701.71993-1-dev.jain@arm.com>
 <20251212042701.71993-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212042701.71993-2-dev.jain@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BD96140017
X-Stat-Signature: ytiier1as698gnrxy4g93bhsfxcfgshi
X-Rspam-User: 
X-HE-Tag: 1766404075-158399
X-HE-Meta: U2FsdGVkX19tLO1v3eBsahFZkT+fjJxzUR/gmuFgLQf2CRTKZAHewPXyBmseJWBEm07xr0OxQeN/D+P5h/JSN6oWKgLZn5B7pixu9aV+M8IpKExO66Eebf6IASgmPVos5VEMXMCNTXcAc1khXQyjuSDVU+yCFqO46gUtGwCBhabBaeAAi0VzRt7OfsAbakUPJ+hP0aYBJJKRYfXGOomWOsoKqYEXGhstKlUeduPf7Ey4FqgWS/43rcf+5LMAr+ZaacO73odeFcmufFkLdVwBwGncY7eCzTTcKGxCGYosPbZ/8yZrIIiGYWmIYO4HYMtTGM5XYsD9CehF2Oxd3rjFQCmAMC8+GK6mzi0B3sW7d4HJWSe6Net7jEobUBIXTFwCo7XX0AM9BnAn7601KhSELa3rRzirc2OGU4UJdrqui/mOHUKTSIwxJ6P7V1s5ZRyTcxhU6CM/IjYjjhTxNj61uQsLeNnNv/7mnDFdnQR/MPhthCc/xVjSv961wJpxnm5uI1+JyGyl/Kxu8YGH4fCXKTNLNU0Fn5p5+nT7OcoQkfMi4LOENl6+YBIu70pv/cerWYNtmTCgRqClCGdZbXkYzticRDWDgahzFGTCXIY1Pz2HsVT3JhxGWnL3H51QldPf0TgQsB/rATZERxym2MMgJNHzH7wKEJPtexdzsv/Eh4VG9hT65LtMM+cz4f/rjurkwXKD/lITXfaoB0nsrQ1HbYivgvQFTnpupDQWL01Q8FbrtYQiN8p7DcNZhzI28nxqO34l3V7tmd9cWq0r2Li6/fULkEmNWZ4+tVzThdWurt3FKj4emTOyaut3NlsBAHp4RKIhyU3gYiSYXiW/VbOQlskfSyx/LBOfr1KuqNJ2U2CLCdiC5+3NuDHlioM85E+JdyVRDtGWaH+2bXZjvld7JlU3Hx4SWiz9Ox0GBPx5FCejvxkrD8MxQv5YJNsWyUAO3AxYvFZkYVyhlPWaxA4
 pAqVLcHO
 eIOND00iFomSCKKZdyZENQfgc31Tyv7G0fIP3vUKuuRV+0dOQndcsLY8riC37ip77WZBnotFaGHS9Wo02HrgqegjHr5CB/fHGZMa5mvJdO035MtLWwrwAuIk1ZqyTHAH1eDwVgwa8+EcDO/OW0DlqsRVMtWzExUZuZoMJyv2ye5rE3oC1OS79qT+ZwjK7Vz1zhI52k31LUioZe5OAKe/xdae7F81AdAv/mad7MyuQ5Rq4lZsrt1iLUlK09QlPVBCUiwJpIDewj2gIAjORj4DO0EjwfjzXq9dI+XQ2VTAG99sZXCI1EnkyXOFNog9CrznO8y3iN3zzANEbZ6slsKdttEvoffSh6ZoBD0zOaVA7j6oohHpz7U7ik/t2Bv3uvpis8dlpMDSMe+KMkMg+kwJBQhOZAJEsI+kjAnhecRYsThj80+VHqz/HmpErwL4hBK6N+JeV+yk3jwCy1ojVb2pmcIIOfyEjKB19fAth4I1cYSmpupoZs2iKwuW9Q40U6i9+bJkdwj9fGKzkoktafmtPqUAMKKnqflp/TMOY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 09:57:00AM +0530, Dev Jain wrote:
> vmalloc() consists of the following:
> 
> (1) find empty space in the vmalloc space -> (2) get physical pages from
> the buddy system -> (3) map the pages into the pagetable.
> 
> It turns out that the cost of (1) and (3) is pretty insignificant. Hence,
> the cost of vmalloc becomes highly sensitive to physical memory allocation
> time.
> 
> Currently, if we decide to use huge mappings, apart from aligning the start
> of the target vm_struct region to the huge-alignment, we also align the
> size. This does not seem to produce any benefit (apart from simplification
> of the code), and there is a clear disadvantage - as mentioned above, the
> main cost of vmalloc comes from its interaction with the buddy system, and
> thus requesting more memory than was requested by the caller is suboptimal
> and unnecessary.
> 
> This change is also motivated due to the next patch ("arm64/mm: Enable
> vmalloc-huge by default"). Suppose that some user of vmalloc maps 17 pages,
> uses that mapping for an extremely short time, and vfree's it. That patch,
> without this patch, on arm64 will ultimately map 16 * 2 = 32 pages in a
> contiguous way. Since the mapping is used for a very short time, it is
> likely that the extra cost of mapping 15 pages defeats any benefit from
> reduced TLB pressure, and regresses that code path. 
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/vmalloc.c | 38 ++++++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..389225a6f7ef 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -654,7 +654,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
> -	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> +	unsigned int i, step, nr = (end - addr) >> PAGE_SHIFT;
>  
>  	WARN_ON(page_shift < PAGE_SHIFT);
>  
> @@ -662,7 +662,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  			page_shift == PAGE_SHIFT)
>  		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>  
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> +	step = 1U << (page_shift - PAGE_SHIFT);
> +	for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
>  		int err;
>  
>  		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> @@ -673,8 +674,9 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  
>  		addr += 1UL << page_shift;
>  	}
> -
> -	return 0;
> +	if (IS_ALIGNED(nr, step))
> +		return 0;
> +	return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
>  }
>  
Can we improve the readability?

<snip>
index 25a4178188ee..14ca019b57af 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -655,6 +655,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
        unsigned int i, step, nr = (end - addr) >> PAGE_SHIFT;
+       unsigned int nr_aligned;
+       unsigned long chunk_size;

        WARN_ON(page_shift < PAGE_SHIFT);

@@ -662,20 +664,24 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                        page_shift == PAGE_SHIFT)
                return vmap_small_pages_range_noflush(addr, end, prot, pages);

-       step = 1U << (page_shift - PAGE_SHIFT);
-       for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
-               int err;
+       step = 1U << (page_shift - PAGE_SHIFT); /* small pages per huge chunk. */
+       nr_aligned = ALIGN_DOWN(nr, step);
+       chunk_size = 1UL << page_shift;

-               err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+       for (i = 0; i < nr_aligned; i += step) {
+               int err = vmap_range_noflush(addr, addr + chunk_size,
                                        page_to_phys(pages[i]), prot,
                                        page_shift);
                if (err)
                        return err;

-               addr += 1UL << page_shift;
+               addr += chunk_size;
        }
-       if (IS_ALIGNED(nr, step))
+
+       if (i == nr)
                return 0;
+
+       /* Map the tail using small pages. */
        return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
 }
<snip>


>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -3197,7 +3199,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>  	unsigned long requested_size = size;
>  
>  	BUG_ON(in_interrupt());
> -	size = ALIGN(size, 1ul << shift);
> +	size = PAGE_ALIGN(size);
>  	if (unlikely(!size))
>  		return NULL;
>  
> @@ -3353,7 +3355,7 @@ static void vm_reset_perms(struct vm_struct *area)
>  	 * Find the start and end range of the direct mappings to make sure that
>  	 * the vm_unmap_aliases() flush includes the direct map.
>  	 */
> -	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
> +	for (i = 0; i < ALIGN_DOWN(area->nr_pages, 1U << page_order); i += (1U << page_order)) {
>
nr_blocks?

>  		unsigned long addr = (unsigned long)page_address(area->pages[i]);
>  
>  		if (addr) {
> @@ -3365,6 +3367,18 @@ static void vm_reset_perms(struct vm_struct *area)
>  			flush_dmap = 1;
>  		}
>  	}
> +	for (; i < area->nr_pages; ++i) {
> +		unsigned long addr = (unsigned long)page_address(area->pages[i]);
> +
> +		if (addr) {
> +			unsigned long page_size;
> +
> +			page_size = PAGE_SIZE;
> +			start = min(addr, start);
> +			end = max(addr + page_size, end);
> +			flush_dmap = 1;
> +		}
> +	}
>  
>  	/*
>  	 * Set direct map to something invalid so that it won't be cached if
> @@ -3673,6 +3687,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	 * more permissive.
>  	 */
>  	if (!order) {
> +single_page:
>  		while (nr_allocated < nr_pages) {
>  			unsigned int nr, nr_pages_request;
>  
> @@ -3704,13 +3719,18 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  			 * If zero or pages were obtained partly,
>  			 * fallback to a single page allocator.
>  			 */
> -			if (nr != nr_pages_request)
> +			if (nr != nr_pages_request) {
> +				order = 0;
>  				break;
> +			}
>  		}
>  	}
>  
>  	/* High-order pages or fallback path if "bulk" fails. */
>  	while (nr_allocated < nr_pages) {
> +		if (nr_pages - nr_allocated < (1UL << order)) {
> +			goto single_page;
> +		}
>  		if (!(gfp & __GFP_NOFAIL) && fatal_signal_pending(current))
>  			break;
>
Yes, it requires more attention. That "goto single_page" should be
eliminated, IMO. We should not jump between blocks, logically the
single_page belongs to "order-0 alloc path".

Probably it requires more refactoring to simplify it.

>  
> @@ -5179,7 +5199,9 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>  
>  	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>  
> -	for (nr = 0; nr < v->nr_pages; nr += step)
> +	for (nr = 0; nr < ALIGN_DOWN(v->nr_pages, step); nr += step)
> +		counters[page_to_nid(v->pages[nr])] += step;
> +	for (; nr < v->nr_pages; ++nr)
>  		counters[page_to_nid(v->pages[nr])] += step;
>
Can we fit it into one loop? Last tail loop continuous adding step?

--
Uladzislau Rezki

