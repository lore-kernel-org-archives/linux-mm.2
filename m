Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21717CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F4A90024B; Fri, 15 Aug 2025 11:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926656B012C; Fri, 15 Aug 2025 11:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7AB90024B; Fri, 15 Aug 2025 11:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 693FB6B0123
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:31:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B0B91354ED
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:31:16 +0000 (UTC)
X-FDA: 83779380552.12.8857815
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2893040017
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:31:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKd7OxJC;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755271874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vG6nSpBW8GrI6flwCx2lvOGPZBtdjytP1/oIYvTBz5w=;
	b=tQOFTIucPDqz8gko7dfURY9C56k9CxpEgO1v7F/H5in3qUB83Yb+eVCfEmpqXhVSK8m7Q0
	YKip4Y14z0v0SOyKEZOfcwuda58lKQBNKtcUKzeHPfUgHHkt9mifH0qNeg53vRRZT7xGgR
	LNkGLpX1oxbT+CyfBL1hTS4yW6qXrYw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKd7OxJC;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755271874; a=rsa-sha256;
	cv=none;
	b=vCKdcsq9M/ApVKSgwuFAOeW1QXN7tUMZVhG9LDM3lPd1V2B/g9m6TyU8hVdWLPDpOqFmaW
	z0Tiej0GD8YNyEFBkrlB3+LEHmR9OFTrIVB7cooab7tpS20XrG0iX1KPy5JTrpW8NErKJ+
	/4+unsYm6tiEjo9pg146I2+J8zNAakk=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4716fa7706so1448514a12.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755271873; x=1755876673; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vG6nSpBW8GrI6flwCx2lvOGPZBtdjytP1/oIYvTBz5w=;
        b=fKd7OxJCiAiN3JxM64TryycWg2fUJ1dcMrjd4FaC4BQCqfARoueEZo6T/jITFiJ5DX
         q99X4qczMnnKD1MYcEdwu/zkWzHryf3qbd1WYMFOS4FAQCFjCihrmYbCp7Mf7eaZhZeg
         NeVHLNvR7q00wnVb7DW2ZWlBva5XO3GJlUMi0cuQufwoUTtpRaYYT4P2ir6wr3mjdmjI
         E3wtw+n4odP0xnAnatZ0uIvEuHtiymr9DCfqX+AeKdham69gIifo7RQrMPtHU+C4IYyR
         xW03XYTxklJKYgNe/Iccem11TVLirRVsa1zVeJdQp80TyGJUg0DlARII3Iejal4l0ILq
         jhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271873; x=1755876673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vG6nSpBW8GrI6flwCx2lvOGPZBtdjytP1/oIYvTBz5w=;
        b=Xv3aacepHsnSIYUf6308BKK4ZkYd6HOymSqY+CLccOy4BlAJrxpgl+9xvDcCiqzvo1
         ddVFdbDILeHjm62cegFa8+uYpcIcbJEN9npT7lJeagmZ29hyVEljWAxGTxGqSoeY7uya
         +JxbECpSS0J0KM1tiYl0DTLJGVsJaDnrIBR3Nlu73toIMpm98SknG8es4g+681I/8IAe
         HqWMXWm5BFFieQLy5evLSw94Qyy/1+7P1e9u5SG6DhHlkDlqCwerUroGRlJ8Cc0KD83R
         nzooIwpnzpmrPV8Cfdtf4eVG9R9d4qb28+7G1QRJIwifTPVN8/XCvEGNCVjw+7lDXiTv
         jvXA==
X-Forwarded-Encrypted: i=1; AJvYcCVTZJPeFkmh9Z6S06I/jL/EE7PJRQz1ZfWbSXhq1nhkWsXwyafcC9jLg2lQGW4SXWahco/SkkbFpA==@kvack.org
X-Gm-Message-State: AOJu0YxbWLUY5DW0W6OFp+iRKmNDA1JKt0OqsDSFlnO8FVbAfNMxBpR4
	+7yRk6FDIkUsSlFm9b2sNRXAHiQYfBT4s9GaReHJNlFjJKgB7iXmZF7q
X-Gm-Gg: ASbGncvaWgP9557aE5yQAro2Skb2ujgndGYUOvz1I00Mz38MSS3RD1pKfyEUPTMWB2J
	9HdU9kcaDRRQGkgKIagxOxcBuanfxh/tIx740FLj4Ao2ygFCuKZZxsOUEwBW6Es7clOxshPm6yG
	qK+A57JJSftlaMjxIyKOLe3CTNDHfSFFgTt9v3bnLXKw7Y8VH4MIPFEDFTruCGhFfovz5ICz4BM
	SGhk7xYQ1NoTEy7cwW0q1YZ4mhenGLjUz62qHe2gqE6aWiSzYIcIFavoFNnytfVx+LyCI7mWtCG
	lvfXSiR13FINOL55WtI/dco7Eo4tDX0GBnK/EMYJWpC+22u/YUfvMUh/eaZZyvkQuK2jRwcgTiN
	jedkmtXZpN2I0dOTXwbUR
X-Google-Smtp-Source: AGHT+IG2024fvzeP+d/GT5SQI1pFoeOHDyqnbCwH7pKgNThMneJbBJSXCa0lYaEaeXB1gM3IUDO/Mg==
X-Received: by 2002:a17:902:e5cd:b0:243:43a:fa20 with SMTP id d9443c01a7336-2446d73b896mr47021765ad.24.1755271872816;
        Fri, 15 Aug 2025 08:31:12 -0700 (PDT)
Received: from vernon-pc ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d59a188sm16363645ad.162.2025.08.15.08.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:31:12 -0700 (PDT)
Date: Fri, 15 Aug 2025 23:30:55 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, glider@google.com, elver@google.com,
	dvyukov@google.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, shuah@kernel.org, richardcochran@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/7] mm: memory: add mTHP support for wp
Message-ID: <aJ9RLmuEj4U7JN_7@vernon-pc>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
 <20250814113813.4533-7-vernon2gm@gmail.com>
 <b607985d-d319-4b47-9365-0595f7d87f28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b607985d-d319-4b47-9365-0595f7d87f28@redhat.com>
X-Rspamd-Queue-Id: 2893040017
X-Rspam-User: 
X-Stat-Signature: mke3by5qyit6f7kojf54h3d3kd6p3dj8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755271873-510591
X-HE-Meta: U2FsdGVkX19zmnzTcrYO75DxOxv1z4kpc9735MnY/1IUjXCMg2ngYy5TJMJgfa+DrvwOIfNGMN+4iPWEGyzi0gnR7Ip353N2Zx/DXXAjUSwcaVY1ln7COi58kIZtEfCfggp1muN7StBmW6+yaJoy4JZZcmhBk1IzHrSJUgE61KFVUCi45ViGTKET5Ng9st4ZeehDvLfX1+rG8jrNd9H9Ypk8vlvn+KPIZzM7uluIdyebzwZ0WO0Qd53G0zxylXt9MBHhFCHb96Apt4vhjG971DT0MXT+5d5/DybIj2YzjYeJc56h3jAIbb3Zg+LBS31tXYo0SCaIGIAWkH98VWNDGMYAXsHLCQ7HkfO5deLkK6V8ILFb/wz+2SVIUaGI9FkRV9cr/M+h23dMEfzL1boo+toxPb14l9VdqvAeuIPKX5AJKQGD9Bj8oEox/qTiBMUVGgssl3LPk+7MzcH3BRxLe4+3iuAtPZjXi4IVR0CPTMt3lu0JoB/fDYe1+iFqV1Did1c44M0sHLK6hOSalf2GF3hF05bB79wIjT/rcdeCJmvBtgPiAcn/vWu+fTDBm/5cWdUTZV093XfjfVEhnb/okGA3ripzBjUmPtTBsMKlkT4wIF+pHxdv7XlTzZhW3Sc6xnznKY/vMIKYg2qLh9uMNinHNklqtG0FuP6S3iS/xBItzPz3ocaLDtoT8QWMhH/UwO2fNN7FmexuHJhQWfI8q7wwum+Tbh6kxceJU9+/A6I7hTr7svTfashjuuB//AzuAgoRFoCZnooVdMCJYuY7RbvVwqPjV8BFjxhfx9l6rP8v27HsehvTjhTubSMx4tbMfMqTKi2QynRkN7QKOyOAJyauH3SDNSau8GXuVUchLtHCIiZshULNg3NQ5HStMflOH1TYagZn0CdylCPU1vDmX5B2WcmvB3jF43WULHng9gq1uzsgjBKGLfGrV5iZkjDFu+IbdHUP2Fz0yEGGrpd
 6kOFYfXB
 UTY+JVGNxZ5ehawz4J7K70OGS7EkvwzGptC5EvIQxmzGI1Y3dw7hFk7RgrbzQHzWP4ThhoTQu2J+B1uCwaUi6bYdzKPcLpg1rtddNiYHe6mAcBUCaCHcbccgoFGtVTw87ER7UFiK7rhSjUv3lKVZlTD6oF8vHaxsZ3SD1P/wR3XOiJbokLj4VxBhzz+1JpMxmo/YLDW7AeNbwVMx6Pb1tEOd+uCyj3NSGg8ikV1E2Z793Tf6UitqBeSGfEwAMVu9YlDxvZukvn9WNZDKSDnXxEQokptFPW/8IkMLp3XNK6FptrxK96ZlmgzLjaQqo7r7fWHUO7i8OgL6DR4wiq/QAIylA5qkXPu6jUxE4ZC31hWEAqvxdxGa599vWcwLe+EorcevKL1Gh/+ZyrjEWQVeYLndNsUA8+fcDLWKk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 02:57:34PM +0200, David Hildenbrand wrote:
> On 14.08.25 13:38, Vernon Yang wrote:
> > Currently pagefaults on anonymous pages support mthp, and hardware
> > features (such as arm64 contpte) can be used to store multiple ptes in
> > one TLB entry, reducing the probability of TLB misses. However, when the
> > process is forked and the cow is triggered again, the above optimization
> > effect is lost, and only 4KB is requested once at a time.
> >
> > Therefore, make pagefault write-protect copy support mthp to maintain the
> > optimization effect of TLB and improve the efficiency of cow pagefault.
> >
> > vm-scalability usemem shows a great improvement,
> > test using: usemem -n 32 --prealloc --prefault 249062617
> > (result unit is KB/s, bigger is better)
> >
> > |    size     | w/o patch | w/ patch  |  delta  |
> > |-------------|-----------|-----------|---------|
> > | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
> > | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
> > | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
> > | mthp 64K    | 747333.18 | 855570.43 | +14.48% |
> >
> > Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> > ---
> >   include/linux/huge_mm.h |   3 +
> >   mm/memory.c             | 174 ++++++++++++++++++++++++++++++++++++----
> >   2 files changed, 163 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 2f190c90192d..d1ebbe0636fb 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -132,6 +132,9 @@ enum mthp_stat_item {
> >   	MTHP_STAT_SHMEM_ALLOC,
> >   	MTHP_STAT_SHMEM_FALLBACK,
> >   	MTHP_STAT_SHMEM_FALLBACK_CHARGE,
> > +	MTHP_STAT_WP_FAULT_ALLOC,
> > +	MTHP_STAT_WP_FAULT_FALLBACK,
> > +	MTHP_STAT_WP_FAULT_FALLBACK_CHARGE,
> >   	MTHP_STAT_SPLIT,
> >   	MTHP_STAT_SPLIT_FAILED,
> >   	MTHP_STAT_SPLIT_DEFERRED,
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 8dd869b0cfc1..ea84c49cc975 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3344,6 +3344,21 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
> >   	return ret;
> >   }
> > +static inline int __wp_folio_copy_user(struct folio *dst, struct folio *src,
> > +				       unsigned int offset,
> > +				       struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +	void __user *uaddr;
> > +
> > +	if (likely(src))
> > +		return copy_user_large_folio(dst, src, offset, vmf->address, vma);
> > +
> > +	uaddr = (void __user *)ALIGN_DOWN(vmf->address, folio_size(dst));
> > +
> > +	return copy_folio_from_user(dst, uaddr, 0);
> > +}
> > +
> >   static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
> >   {
> >   	struct file *vm_file = vma->vm_file;
> > @@ -3527,6 +3542,119 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> >   	return ret;
> >   }
> > +static inline unsigned long thp_wp_suitable_orders(struct folio *old_folio,
> > +						   unsigned long orders)
> > +{
> > +	int order, max_order;
> > +
> > +	max_order = folio_order(old_folio);
> > +	order = highest_order(orders);
> > +
> > +	/*
> > +	 * Since need to copy content from the old folio to the new folio, the
> > +	 * maximum size of the new folio will not exceed the old folio size,
> > +	 * so filter the inappropriate order.
> > +	 */
> > +	while (orders) {
> > +		if (order <= max_order)
> > +			break;
> > +		order = next_order(&orders, order);
> > +	}
> > +
> > +	return orders;
> > +}
> > +
> > +static bool pte_range_readonly(pte_t *pte, int nr_pages)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		if (pte_write(ptep_get_lockless(pte + i)))
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +static struct folio *alloc_wp_folio(struct vm_fault *vmf, bool pfn_is_zero)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	unsigned long orders;
> > +	struct folio *folio;
> > +	unsigned long addr;
> > +	pte_t *pte;
> > +	gfp_t gfp;
> > +	int order;
> > +
> > +	/*
> > +	 * If uffd is active for the vma we need per-page fault fidelity to
> > +	 * maintain the uffd semantics.
> > +	 */
> > +	if (unlikely(userfaultfd_armed(vma)))
> > +		goto fallback;
> > +
> > +	if (pfn_is_zero || !vmf->page)
> > +		goto fallback;
> > +
> > +	/*
> > +	 * Get a list of all the (large) orders below folio_order() that are enabled
> > +	 * for this vma. Then filter out the orders that can't be allocated over
> > +	 * the faulting address and still be fully contained in the vma.
> > +	 */
> > +	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
> > +			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
> > +	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
> > +	orders = thp_wp_suitable_orders(page_folio(vmf->page), orders);
> > +
> > +	if (!orders)
> > +		goto fallback;
> > +
> > +	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
> > +	if (!pte)
> > +		return ERR_PTR(-EAGAIN);
> > +
> > +	/*
> > +	 * Find the highest order where the aligned range is completely readonly.
> > +	 * Note that all remaining orders will be completely readonly.
> > +	 */
> > +	order = highest_order(orders);
> > +	while (orders) {
> > +		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> > +		if (pte_range_readonly(pte + pte_index(addr), 1 << order))
> > +			break;
> > +		order = next_order(&orders, order);
> > +	}
> > +
> > +	pte_unmap(pte);
> > +
> > +	if (!orders)
> > +		goto fallback;
> > +
> > +	/* Try allocating the highest of the remaining orders. */
> > +	gfp = vma_thp_gfp_mask(vma);
> > +	while (orders) {
> > +		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> > +		folio = vma_alloc_folio(gfp, order, vma, addr);
> > +		if (folio) {
> > +			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> > +				count_mthp_stat(order, MTHP_STAT_WP_FAULT_FALLBACK_CHARGE);
> > +				folio_put(folio);
> > +				goto next;
> > +			}
> > +			folio_throttle_swaprate(folio, gfp);
> > +			return folio;
> > +		}
>
> I might be missing something, but besides the PAE issue I think there are
> more issues lurking here:
>
> * Are you scanning outside of the current VMA, and some PTEs might
>   actually belong to a !writable VMA?

In thp_vma_suitable_order(), it not exceed the size of the current VMA,
and all PTEs belong to current writable VMA.

> * Are you assuming that the R/O PTE range is actually mapping all-pages
>   from the same large folio?

Yes, is there a potential problem with this assumption? maybe I'm missing
something.

>
> I am not sure if you are assuming some natural alignment of the old folio.
> Due to mremap() that must not be the case.

Here it is assumed that the virtual address aligns the old folio size,
the mremap would break that assumption, right?

>
> Which stresses my point: khugepaged might be the better place to re-collapse
> where reasonable, avoiding further complexity in our CoW handling.
>
> --
> Cheers
>
> David / dhildenb
>

