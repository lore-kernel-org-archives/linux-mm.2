Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3753AD26D7D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 19:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904E36B0005; Fri,  9 Jan 2026 14:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2346B0089; Fri,  9 Jan 2026 14:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7940E6B008A; Fri,  9 Jan 2026 14:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 682C76B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:15:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F78E13BC87
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:15:29 +0000 (UTC)
X-FDA: 84313379178.19.755117F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id C57AD14000F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:15:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zyLM9QGU;
	spf=pass (imf23.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767986127; a=rsa-sha256;
	cv=none;
	b=PTulRysm/OBpUrKx8NX/qewNYfOW8sDDScliLHouD451kG9ezIOkrM0voPudlcackF9TK2
	CKutwGDTxqiRnweGhRG96xmXwgx7hwI+cU4sIzm1TFCkuvmJ9MJY8llUKLevGETSpFY5l2
	Qp66QtZL6Cu5AaHgfgCWnz3jrL/kLTo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zyLM9QGU;
	spf=pass (imf23.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767986127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zIYiJ3AeStpupvGSL4Hm+WwwUI7TJ76QSjzNdMxPRw=;
	b=lbszKdQCiTsJo7oM66SzOhGHRVtKTo55xn+GRKAVYXnjNvkGPOnemF8AoAU7rM+MJEDVqV
	RVOXy6iGnDOHdBSVJ/gOQA1n6iVsn09EBmU4VOEs0P9Efjf0R/6lqcJFOvKwq+LulXyw89
	ydJMorDY2oBrIyB3WfHuToySWu8Xxfw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d06cfa93so12825ad.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 11:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767986126; x=1768590926; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1zIYiJ3AeStpupvGSL4Hm+WwwUI7TJ76QSjzNdMxPRw=;
        b=zyLM9QGUhrAJFylAVmrKnGFiwEuRqG0ou/Nbfi8AdWC0IyMiBLGHcdhygp04nTEelb
         GP6h7ra76RuhdOwe+fEHoBfhho31URn0BvwOZXi3A/4mlxSHctp/ZVQt3fgIPuqYNEvx
         zyxWZk4ns/WHvdWTbkiXtCDoUFz7pNsQGQ2bHPvKzqIkP6JW6KUwNOqISjKEZj0wLdB1
         NBfwhSy5GP3fG0D+GrqwTyMBJkWBLhHxJyulk9jBpG5bnNSJTv5NTiVy5iaEmEK3EU90
         Xha0FN5X94R0dfQamIoZzNFbSltTnUU/3ZvZH/uzEzoHmkUUZvA7Y5gZltbFZgkxpWRD
         RooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767986126; x=1768590926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zIYiJ3AeStpupvGSL4Hm+WwwUI7TJ76QSjzNdMxPRw=;
        b=f1xQQaILZdVH0nQ0mf1EXlxrEviMJxMnPrKmBt9kbyz2sSC9ZCa67BOg47El5by5CR
         OHpDTFmBWV3cCMu6Mi0cie9qhNYFeAuWDee3OTPQa2U+W15ynlMQVmjZhGyrkgBK/4eB
         +Xe8ns5jhpFa6DynbA2/F8WQmoJIOr2OnfYup7q/NKnXUgANcjdBQpYCzNZwrDVaUR1E
         ng+/d1gTmHuH4hdoGcrlMpeuROlhVrDPJCCxw3l8xTw/sL7y3gpzOZUL/psWdg5Rks67
         GPVIhPhSZQbPQ6ALJiKiflzrw1TT5WTz67kRNnF1qExk+oos6VyOBSQraX7zUC3oB/0b
         E7gQ==
X-Gm-Message-State: AOJu0YyzTroFGgy95msfObWaVBh2WrWH575BVEWhgHDsvtB9dAK9NfRQ
	vpedR/45gsCD+ScrCkNgDDmnLi7N1sHULXQTmOgtaAyrxjuiNa3+NCEIZZVzwTFPLw==
X-Gm-Gg: AY/fxX4xRF5hHq4SZ8hKCuMbcN5LkfWPjsRop3mDzWQNEE5J8QcagE/UkeqVYBXfCrd
	dyaAjVUSWcYx+rv5/Zgwki5krJTsBGStGKV2eYaHPeu+KLbnmbGM9Auo02q1PSj9On3ED91gVf2
	aZShR8cNK7OLpYw2p7TN93+k8NeEal2K9rftuBcMPRQ8FywSu+ionS1es7EwJR4MWfbLphR6Fm2
	nxFPwfWQEJyzasvl8b1olhLmms2/1VAVwRmc3Snr/0MZKYhh+wwWwWiJvQ2OB53bZtvSDYvuJjN
	n5WVxXYqe0JiV7MCC1Lnor9T1ZP+VrXOxbZRu61zOzkiD/Y2vLJpgB7xVDVrFWYw5ylILkJvS4B
	yEsGghtbocT6pyJUO3jLghM9Zzm2w0rUlgDurqoLpoW0Sj0/YNOecX2KCZY1MyLtn7A4nc9tF0H
	aq9gEsmCw4c8y8BwE1KeCalQ+3SeVNW1MfCSGNZs2CY5N+1k6C
X-Received: by 2002:a17:903:40ce:b0:292:b6a0:80df with SMTP id d9443c01a7336-2a414932d4bmr384275ad.10.1767986126281;
        Fri, 09 Jan 2026 11:15:26 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a2ecsm110215965ad.6.2026.01.09.11.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 11:15:25 -0800 (PST)
Date: Fri, 9 Jan 2026 19:15:18 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <aWFTxlaGWy23R-Qs@google.com>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109171805.901995-4-smostafa@google.com>
X-Stat-Signature: eonkhdqgbj7bkcwjhhpaw6r5pyeojw5d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C57AD14000F
X-Rspam-User: 
X-HE-Tag: 1767986127-538127
X-HE-Meta: U2FsdGVkX19Hggq4eJ8B6VEUkl/sugTf+XrQIsuwohKSyqlypqzBcbljywVlsw4S5BFr1jYj6RA9NCPPyuCu681IJWeOp1QL4j8vfgCydAmjTnfN0nSMnV4sMcVJ0ilO88KzSTyn7ACbxP/1S3AlKRJwOC96iaJhNqWQ41QxiGYySIpGHFyXsx1e6shD8F1IhESOOtVr9qZQiPEFl0NgQ7uqPB5Xt1bFrWTjk8uB3sq7GgFdys9OX9FeBZgBCRCaB+yQB9ooKB57oKcWESMpACuWMHMQXcZ09r164OlOxSa9iQdsudH1gj0L5gVeKxN5C0lKYlE7LKTmWZtzHSXhF/0YNwyyzSRqWIEajlLtfMc/ND/0T6dsEZJesJ806de1rH3kKeQt/YhZ6+pKxX/ftMo5YhhuEjGH5DdT94omSCY33h9ZK9vEIhgGEndxAaNG00dnCQMeAl0EOKUtZwsC1XSw7zB1sY+gZ3k5q4omnLdwE6Zt/3KYUMf/DSLF8zvUWV8DgO6mK5RWjq+J+F8a5SHYyjjVMqaaE1Fy7/kq9CbsD0s3GO1W3Zr6jDsvOVqdCwxyg5mdYBkR4Nki0/U4VUWkKk6KfnX/D4XOjh69bdRDNqT09Uc0bI2Y7/KFNfBvm/lq1TJTnNhGgv7QaEm43f7r8PPGwkccMSTXcAjtRGAv9VBT9jZYqznGYTcbSgG2VuqiL9VwZJlM+b4T7kMimeiqxVO6h7iYiCBByGil91AYlKmthfdS2ik+jExRjDGM/vkUFJxfm5mxWa0jSyARduqX4y4kGaAWBr4BJ4uplY7W8Omku3sHWpZwi2ChAhfyPtarlC3xM3JF+yMRbZtWM5FxrJfJG6pRaLdI/9zIkYOnRMXBgiJP/Wi/VjX3Th8vmr5HgQ9OJmqnYuH2NronVq1venKITT3ipUnJe3bKB2HD6knrvWmRF95l1/G3fJqwcXv7j8XiRMGYx6+wCZO
 25note4x
 XeZ9Q7YjIVc4+2hcESeuJI6hI7kV3DhYC5z3P3OVy3sE3wmfUgpaNk5YYFPSa5iOdHPlBkD/Ac0YZYnzN1xAyEIjDD6ZgeasfVSHq1LpyPMgaENVUU4nYf3l0ShyeS0oULOEL5wRQX3v4cqJz1tED7+QmzHS+6r2rZf8SVgRYiDtA/g2+j4vME/R01HAfCWuUq5Nmuq0YPY8bMGqWwd3j4j6jBq7o338rBLk9J4ny+8wn+eJETdiu67wUOTZcGbr1M5twMnwj9db8qiy/gxTBSjvOc7x3HHdU8NeAVIXJ9QkAh2SFUyAhd4kYrwW7+w3fXklwd4xi9K2qO3dK2b0t59AuTrUUIjCeBRE4y8bzMIk4Vdlll95EZirLdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 05:18:04PM +0000, Mostafa Saleh wrote:
> Using the new calls, use an atomic refcount to track how many times
> a page is mapped in any of the IOMMUs.
> 
> For unmap we need to use iova_to_phys() to get the physical address
> of the pages.
> 
> We use the smallest supported page size as the granularity of tracking
> per domain.
> This is important as it is possible to map pages and unmap them with
> larger sizes (as in map_sg()) cases.
> 
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 84 +++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 1d343421da98..9eb49e1230ee 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -29,19 +29,103 @@ struct page_ext_operations page_iommu_debug_ops = {
>  	.need = need_iommu_debug,
>  };
>  
> +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> +{
> +	struct page *page = phys_to_page(phys);
> +	struct page_ext *page_ext = page_ext_get(page);
> +
> +	return page_ext;
> +}
> +
> +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
> +{
> +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> +}
> +
> +static void iommu_debug_inc_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
> +	page_ext_put(page_ext);
> +}
> +
> +static void iommu_debug_dec_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
> +	page_ext_put(page_ext);
> +}
> +
> +/*
> + * IOMMU page size doesn't have to match the CPU page size. So, we use
> + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> + * That is important as both map and unmap has to use the same page size
> + * to update the refcount to avoid double counting the same page.
> + * And as we can't know from iommu_unmap() what was the original page size
> + * used for map, we just use the minimum supported one for both.
> + */
> +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> +{
> +	return 1UL << __ffs(domain->pgsize_bitmap);
> +}
> +
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
>  {
> +	size_t off, end;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
> +		return;
> +
> +	for (off = 0 ; off < size ; off += page_size) {
> +		if (!pfn_valid(__phys_to_pfn(phys + off)))
> +			continue;
> +		iommu_debug_inc_page(phys + off);
> +	}
> +}
> +
> +static void __iommu_debug_update_iova(struct iommu_domain *domain,
> +				      unsigned long iova, size_t size, bool inc)
> +{
> +	size_t off, end;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	if (WARN_ON(check_add_overflow(iova, size, &end)))
> +		return;
> +
> +	for (off = 0 ; off < size ; off += page_size) {
> +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> +
> +		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
> +			continue;
> +
> +		if (inc)
> +			iommu_debug_inc_page(phys);
> +		else
> +			iommu_debug_dec_page(phys);
> +	}
>  }
>  
>  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
>  			       unsigned long iova, size_t size)
>  {
> +	__iommu_debug_update_iova(domain, iova, size, false);
>  }
>  
>  void __iommu_debug_unmap_end(struct iommu_domain *domain,
>  			     unsigned long iova, size_t size,
>  			     size_t unmapped)
>  {
> +	if ((unmapped == size) || WARN_ON_ONCE(unmapped > size))
> +		return;
> +

Looks good!

> +	/* If unmap failed, re-increment the refcount. */
> +	__iommu_debug_update_iova(domain, iova + unmapped,
> +				  size - unmapped, true);
>  }
>  

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks!

>  void iommu_debug_init(void)
> -- 
> 2.52.0.457.g6b5491de43-goog
> 
> 

