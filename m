Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E72CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150706B0088; Wed, 30 Sep 2026 11:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101766B008A; Wed, 30 Sep 2026 11:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31B26B008C; Wed, 30 Sep 2026 11:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BABE36B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:05:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55E7C1C394C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:05:29 +0000 (UTC)
X-FDA: 85270752378.26.FF56A79
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 600D340012
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:05:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CQHe4kO+;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790780727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfRtojeauzUhQb4SePcX378h8gySuQTk235TQqLiiHA=;
	b=27uIZQCqOWCzPz0oa4+/+nvKF14+w8SMOw20i2GF1TCdHQrSAOkICbgE+0r2C8XRVi5llx
	sQjGX2J7N/6lNdWt5F83Ty03iETEjwMQ1gTTmmZ8l4GOIctMI4O5TLqkcxWQYsqLUm9G4l
	VzFxdG+p91KO7tySkihO7fG3677dzAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790780727;
	b=OurpN0sFyTtiB6ToOYuIHnM620tHcsaGKN7HWChph+Nv66d+VMIGR6adLz9g7jkDyYDO1e
	0cShMqx8hLQcm4Ucf1Q0i+yexTrsVrJ/mMLLXY7vKx9Y0o/LdyPBagEKrHr0G0ctMWmu5C
	DLnTaDgHVEQYO/hJlzneA4vQycBOgCE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CQHe4kO+;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e17363b97so155278766b.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790780726; x=1791385526; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jfRtojeauzUhQb4SePcX378h8gySuQTk235TQqLiiHA=;
        b=CQHe4kO+duwOYbAR80r7PS/oKvV22f4c0P9eYt21anpRKs73V2TmUgQASKVC8CeWuL
         gcvsTkJssHJAWfHxyjEd7jWSy+n1ELpWBUBSPY+vQfvpgy7eLYTdGsKctU++4EqOCTYX
         m4ia5aSMu3gDDrqjJQrbJoCVUbmNyU8xTY33V2kD1saUzeufj8Z6L31wg2B2XAgMZPw1
         gaZFgjOEAXcV0e58YN6rk4GUzU6JV0qJR+dDGOes9ZveoTVYRZ6BD+64PK0PshpHbfEP
         g/B3evRr1a3Erv3d/JNrIUvGwNEm2TFKomY8uROZ9W7ltCF7wWaP8F5NEwVYVLo9IbeW
         UsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790780726; x=1791385526;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jfRtojeauzUhQb4SePcX378h8gySuQTk235TQqLiiHA=;
        b=WwaqzrAGyG/rdOixCa1KhFVbjIMul1UldBWU735ZC75tCIzXnpSr5+gmouVoLiAMrZ
         g29LwBTsIBW2rAX7VwpoO42DtgN7IM5q38o69kfT4I3NR3U3LXCDC5zluDbu0PadsPkB
         PpSahf6uZwFCMUq5K7ZvmVDp+K46/yjnLdasQOg2+pSuXULAqvLUcEXN7vfmei2O3gMh
         9R9DIkS5CQUQ2AK0okfGXUw30mr1JpDy/Pk9PJAIjoJeskX8yOsQ/SyXTevg7787FFsv
         JX172SjRrd+cc9OhLKWLLGJAnLk0Ig4uvp6VIFmhUxfthz7w0SJItKdxTugRztAxK+1m
         VJKw==
X-Forwarded-Encrypted: i=1; AKwUvBwzPGEj22SMARluPaF+w8P68+vYmZo2F1pDv9SaXmv565le3Cs2pBec+MSZdfN3PL26FHFBDwcUFg==@kvack.org
X-Gm-Message-State: AFq9FYLIrLaOpkNWcyqXP0+f6M0Sr4hMx1krartOlcc5WLAKbyA/NMoq
	xQxIlfE3ESooiXup29o9Y80uFimpbgO6/PG77iElkeH7pT3m9ClPbSLfiSoq34pSBzU=
X-Gm-Gg: AYBFou1mnweioDbp+AeDPFbqiDLd1zcTY7dbEH8VTG+e1zCz9+xzTxkjbpWQfDbdh+k
	UwVaauwtuRrGJe9gV0GsDH3SFAMEgamWRsWtlOsCVZrIvsL7Sh78qbvwZ5TlddQEbIly5MI1qhv
	3AtSyYBiUMUN52mHWzlyC2zXJ9YkqORTcSA7ZiZuEGFY3HEo4avbzbbA8EH4/MO0CROZI0vxN9V
	Ar8wwW73AF8HOZixYspjNJi6V0nPN3Ssm74ZrMMWCSZcxD3hdIidxwCLoZiWmmo/JuJVrc8+DEQ
	jkZE6T9wefkCy/GbzS1q9QZXMyIWWpme7hfX7z/NoS8JF6OB1RKQ18fVPtvh/kK70HFOdjB7/Jq
	tflbX2akGNAGR2cD4YMyrahzqKK04nFL4WIVM13hc0khk7gFHPcSorfZWrrbnWIjy/Gi/e4vTGx
	uCufRCaIqyMteg0nG3Tj7h
X-Received: by 2002:a17:906:ba89:b0:c2d:a4ef:64ca with SMTP id a640c23a62f3a-c2e23e39566mr171362866b.42.1790780725514;
        Wed, 30 Sep 2026 08:05:25 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31a3cc87sm20827866b.6.2026.09.30.08.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:05:24 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 17:05:22 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v9 09/10] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
Message-ID: <ar0lMkKxugZV7xyw@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-10-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260923062832.479455-10-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 600D340012
X-Stat-Signature: dy79zispfnttpe4u8g8zqxao6sppdxna
X-HE-Tag: 1790780727-814678
X-HE-Meta: U2FsdGVkX1+7bTdDBnlHSQYtN7bIRGxVXNkmuAxxmA2A7zJw4HsgDf7h6SNGW0ol1KThUJrUQQOlnH0frocqnLIsZyFjCgwXhAGraCE8GysRgXED9kLrP3CV8sRHMSjCmYDATpqntDFcodQ19NycZYlCUj6/fFlz6mwz4oOsZnHtdSVsStZTUrFuWxYVlcrPIMNnGqxTR85gzIn2U7bMHlxYCAB7f2ohawBkp9xgWD/517skOGi9mWLZzYQq14h5CZIJP4jycKIves+HdPl4Y2R/d5HZ0kaIVBoGOonQKzwvh5/f8jIyW2xzGFqS5IppX7rlQZuBwjZY9rUD7GwkQ/2QjZrSq8pSIOBvXEaIdqdHNlVgHIaR/wJPubylyt3+ZlDZ+dK/1De1u0Bc1W37oG5P01+BnYZx6ymn3XoptfW2P8DvgHjQgVyY7KxDbVAKcncOz3uNGURpHRlc6MH4vDMIdvwIcZ9NkwGwdbcoeGMYd2qJvYLYlySbtKzhcAS4cQuXVdFo5kMppOcZClX1Ls1euJYdsgIvn0juEY6gEMX+kmoeNxvmgCFEBkdlT7ooBf0RQkOIpbUoFiIxSzcXTYSUHK8u7IL/BbKDqWNJkscaMtjj/KG4dGWGybQNRu78yU1On3dpPVu87kfHP9Sut1VQzPK8EVFNXknFoYKdFMweJ/HQjuIFlcCtQMxCZNkcq6KIMad1fI9fkhP//TAHpboKNIAeAlVlXi+qthpLQirmQ7sy0lJzJOu86EHLCH/xIRhWYmHiH2/bIaAg92NOb3RPBRIjuRC6FZyHsR/tv6mwC1spqyi4ighWklV6mN0TrzUwRaGSXzs6cFhwWZhCJUkFN797LPIs5HMW85+Oy/j/8na58kERyAwrMdDW/mqwrOVY+sXYU2nwHGpDaNVAbG8N4RX1M4iXmogeAl/ZJt1+jEXXNs/lE7yM47lGq6DfSDO4qasBlETAJ45CSlM
 tupQRvZq
 TZHBxlS3G6O/dlc1wJLRBrZb9Fwf0gsDIsT7AHN8wtN+Ib1qFTHvgDIFqBNcGLZOgWYfh3B8pJqoBmHXymcn2BArMhss16E/pQgGmZeeHX8AGCVN3Z6VKZ1kZg0eXfr7lcgpc22RNG3EPyeZtQyyGgGkdrIqUpApiyCdU0NqMW+wss9wNslmaSQALyv3MA2QGW8vTdrH2vkzGTBowwkERxXIzhEJigl5zCBEWk5a3Qpw5lq9EYPjvcMJMF2BOQp1kVVON8VGNoZsta+3efIFi3C9oadH9+0QlkGQaMF1GdMMaWYpPTiGNGuUCjOEbhBwYxVY+di9nUfvM2uyOOctWJnK1AJX3EVHLLpNNFb4vhvVSXgmjk1hCMXkcCDESOvvWRk6JOhgMa68fF5gvTD6mt3A6ok4p5I0LWBWT11/ndfK2SebrXjh4ZDPe1DB+2TiJ+q8htQ7q8e9GTNeG+SwzaGcYMrTWzVSFwDnD5sXvTe/5R2Z2oV1mc0MB4EDHZBUOO/YbrXAvao/LFqH/VVFu64t+yIXlq/dWC1zc46hv4B2YUshTq5eVeBYuDZ90ncaH6oyVEWD4R7jOiMcb0adf+TV3WLU9yw0vQwrfdhH4kssR+h9lPAiSlzs1sq8HSD2LH3uo3RJNWbMC2btPy44Q3L9WtxCMpHFoZDxy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:28:31PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> In many cases, the pages passed to vmap() may include high-order
> pages. For example, the systemheap often allocates pages in descending
> order: order 8, then 4, then 0. Currently, vmap() iterates over every
> page individually—even pages inside a high-order block are handled
> one by one.
> 
> This patch detects physically contiguous pages (regardless of whether
> they are compound or non-compound) by scanning with
> num_pages_contiguous(), and maps them as a single contiguous block
> whenever possible. The mapping order is determined by taking the
> minimum of the contiguous page count and the pfn alignment, allowing
> graceful degradation when pfn alignment is less than the contiguous
> range.
> 
> Pages with the same page_shift are coalesced and mapped via
> vmap_pages_range_noflush_walk() to avoid page table rewalk.
> 
> As users typically allocate memory in descending orders (e.g.
> 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
> for contiguous pages since subsequent pages are likely order-0 as well.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a43965016eb4d..37cddb7f45a4f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3576,6 +3576,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
>  	return arch_vmap_pte_supported_shift(size);
>  }
>  
> +static inline int get_vmap_batch_order(struct page **pages,
> +		pgprot_t prot, unsigned int nr_pages)
>
get_vmap_mapping_order()?

> +{
> +	unsigned long pfn;
> +	unsigned int nr_contig;
> +	int order;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> +		return 0;
> +
> +	/* Limit nr_pages by pfn alignment */
> +	pfn = page_to_pfn(*pages);
> +	if (pfn > 0)
> +		nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
> +
> +	nr_contig = num_pages_contiguous(pages, nr_pages);
> +	if (nr_contig < 2)
> +		return 0;
> +
> +	order = ilog2(nr_contig);
> +
> +	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
> +		return 0;
> +
> +	return order;
> +}
> +
> +static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)
> +{
> +	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
> +	unsigned int prev_shift = 0, batch_idx = 0;
> +	unsigned long batch_start = addr, batch_end = addr;
> +	int err;
> +
> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +					     PAGE_SHIFT, GFP_KERNEL);
> +
> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < nr_pages; ) {
> +		unsigned int shift = PAGE_SHIFT +
> +			get_vmap_batch_order(pages + i, prot, nr_pages - i);
> +
> +		if (!i)
> +			prev_shift = shift;
> +
> +		if (shift != prev_shift) {
> +			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
> +					prot, pages + batch_idx, prev_shift);
> +			if (err)
> +				goto out;
> +			prev_shift = shift;
> +			batch_start = batch_end;
> +			batch_idx = i;
> +		}
> +
> +		/*
> +		 * Once we fail to batch pages, we expect to fail batching
> +		 * for all remaining pages, so just give up.
> +		 */
> +		if (shift == PAGE_SHIFT)
> +			break;
> +
> +		batch_end += 1UL << shift;
> +		i += 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +	/* Remaining */
> +	if (batch_start < end)
> +		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
> +				pages + batch_idx, prev_shift);
> +
> +out:
> +	flush_cache_vmap(addr, end);
> +	return err;
>
On error, if kmsan_vmap_pages_range_noflush() succeed you do not do a
proper cleanup?

i.e. to cleanup KMSAN metadata: kmsan_vunmap_range_noflush(addr, end);

> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3619,8 +3698,7 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	addr = (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages) < 0) {
>  		vunmap(area->addr);
>  		return NULL;
>  	}
> -- 
> 2.34.1
> 

