Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAAE8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 05:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5B16B0095; Wed, 15 Jul 2026 01:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86986B0096; Wed, 15 Jul 2026 01:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900816B0098; Wed, 15 Jul 2026 01:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64E896B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:08:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC17080576
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:54 +0000 (UTC)
X-FDA: 84989831388.21.89A04A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0988C40006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ae9KqP+w;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784092133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BB3YMrrQsGcIsgFNc9/zDh94ii0Kkov4WxY4a6dKJhU=;
	b=T0d69lzeefD8UsUASJTHSEz8XW61Gr/IBWX8PLIc3fg2Y+ggVEEVUgPvWtEv0OdNoUmFtQ
	UF3/X3NjVOprKiqRanCa805HYYOz8KR5HUSZTx/g1pVeFP8zSGMhpSEcKLaGWw9E+SRg6w
	dSwhzzu10iAOtmPnnRViJ/t+M82dSjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784092133;
	b=zGrQ/eBgjzL8F5BYzsTxbzuPSLLk8V0K79BJNOqFsJMLjd+RHbCGHflqvuVz0M5MMMuHkF
	BkNpx8O9EnqBurkX/Gs/B06fv26oYDZWxsNKhfSYlYKN7iXcdoGSlYCZTvbCFV1NVHHLVV
	1z7UgBuli4j/eazyGnrb69souYys2Us=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ae9KqP+w;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5198643DAA;
	Wed, 15 Jul 2026 05:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C371F00A3A;
	Wed, 15 Jul 2026 05:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784092132;
	bh=BB3YMrrQsGcIsgFNc9/zDh94ii0Kkov4WxY4a6dKJhU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ae9KqP+wtvN8VQUsqUjKmmA+otd9jevIVhJMXbCS+X2lykSd5HBoP/JYF0bVAgv1J
	 MgoBtePj8hCx40pIwNSNVq+PYnqae6dbMAcjHE472c/T2wWvXT6MnCnAvvmcj7zxNI
	 QRWunS0iNgFN4lgbGE2r27zvhDXv99671veKWg6HO+SWiW5ypt653ZDRXVahwALZ6b
	 tvCuJ+x4NVHRNx1LNeCkLWlhsEy8hcOm5y/tZQELwaq0NYIdg2S5YAZ+3t4Kq8+Ei6
	 7u9yNkhxQ3JR5dKZzR1WRY+GdJya/cADdJLqnXCxvshfpsqPCnx97lzWW/TtUE39To
	 d+gHvoWzeLsdg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/17] mm/sparse-vmemmap: track compound page order in
 struct mem_section
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
 muchun.song@linux.dev
In-Reply-To: <20260702093821.2740183-3-songmuchun@bytedance.com>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-3-songmuchun@bytedance.com>
Date: Wed, 15 Jul 2026 08:08:42 +0300
Message-Id: <178409212283.638342.5794416106269994417.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0988C40006
X-Stat-Signature: msm4s1y7x8ap7rw93bfxe8x4of3h4qit
X-HE-Tag: 1784092132-663528
X-HE-Meta: U2FsdGVkX1+gUJAOwQmMCUPLhrRju4WQW8Ddv+t+ARccXbTazgNhgsQUSyeqWLNKcrcbXs5H3ngrcSfA51XhnASzN4WtDnCZ+EV9B1d8DF33T6bJyiwXGe1eoriIO7NjEq54MVGchYvUzEOquHQGeQFmCbbWElXE7zcTHN4mHjn2DJuF1A5F+u46kRDkM/l3TpN8FcnOj5IshbkpcVVLZyVA1SoxDk58yP7ZKEk8Jwzqdvu5vkEGB36qjA7vhHut+3bDfoRmCjQytM/tfGFgceyWAjgM6Zqf7+/aVCb2aM37uJnjpE8HAftiU/T2cdomdCk2RnTVcROoTYEGPmnrwlPFy0IXwxiCHX5V5JzEOylF4yjg8Jbf1ym6exGHrnGYuc56v7r0gVEB5gUIMpK01dxJiGUE9r78EdBq1h+ohAhHoG+yu1aBCITT+LsA+pYYOHd3kjXqvkH5RfxAIwGRAbrEiB/iobguoTKJW5b8eWiLYOYBaOURwQIc4rnB7+0/9LLsE2hfCJme99uUWUmlM9hVUPRfst6TQ0H3CCreWmX6jAUU48X0O6Do3HCVJ7pvMw3ULs2Gsj9a6BVt8tKenh0ev5acZl79yoQw4pqLvBnTgGtpZbjJ1V6fN70lhBLsQUbwCKC+mmK4iFt7vbUcsOl3atjMMXLo+384R59GpKEBlTYMFLjUwNPJdWfYhKPNLJfGpYiInlR7LpHo7VLOa9cMOa0uMAoRNGwqZu9qt4SaZ5DBqWeGWBwuZVMuliNyxn8Iv8Qfg9Sf1+919Vq29RPpCtvNZW94OV04s3Zo22zAWKcV31DbYmJh8rdhoKMBWIPAizBvOnLJXE8kEA22oFt0w+GAhD90PlYN29Q8ARa56EPE2pHZTPAF5OYph86/n8mHkca4+K04l9Hy94ogdXF4bcPAVXAC9jdPKQZNV2a6yOScNHzXqEwMsiggGdRcZAT8UwH0PuYIxUm4ojk
 i7mWa2sk
 wnxTPCuwArIOHDabju8LFvufBsECTNR8U/giVZNAnDOwuenHlMVbHH7doYSTWqcaP/Ef/ucA3CYHcxn12P01jmsDNn1A5UbdVvSmQEeUaQg0Oi9TfQe7T40wEWLCQfCJcd6pR7VzeJGfU+uGg1VCBzs4y9LatzJqAQ/72oP/XCrivg20MXGpw+q4CvpCQgfsZDh3308uHp9YEtegekDl4cIRS6gryELQiw09NkXyCpN0Qn89aWez+HYOYz9yTN5qLUgVTLzNW6bIoVLcNsrgzEKY7VyTyuWlE7uD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> HugeTLB and DAX both rely on vmemmap optimization, but sparsemem does
> not record what compound page order a section is populated with.
> 
> As a result, code that needs this information has to open-code
> separate handling across users of vmemmap optimization.  It also
> prevents other memory management code, such as struct page
> initialization, from skipping initialization of shared vmemmap pages
> when needed.
> 
> Track the compound page order in struct mem_section and provide small
> helpers to access it.  A compound page larger than a section naturally
> carries the same order across all covered sections.
> 
> This is a preparatory change for consolidating vmemmap optimization
> handling and for letting later code make initialization decisions
> based on the section's compound page order.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 1353bcf7b712..bacd89572c5c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2015,6 +2015,14 @@ struct mem_section {
>  	 */
>  	struct page_ext *page_ext;
>  #endif
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +	/*
> +	 * The order of compound pages in this section. Typically, the section
> +	 * holds compound pages of this order; a larger compound page will span
> +	 * multiple sections.
> +	 */

Typically a section holds order-0 pages ;-)

I think this comment should mention that this is for special sections,
like hugetlb and DAX.

> +	unsigned int order;
> +#endif
>  };
>  
>  #ifdef CONFIG_SPARSEMEM_EXTREME
> @@ -2361,10 +2369,34 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  #endif
>  
>  #else
> +struct mem_section;
> +
>  #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>  #define pfn_in_present_section pfn_valid
>  #endif /* CONFIG_SPARSEMEM */
>  
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +static inline void section_set_order(struct mem_section *section, unsigned int order)
> +{
> +	VM_WARN_ON(section->order && order && section->order != order);
> +	section->order = order;
> +}
> +
> +static inline unsigned int section_order(const struct mem_section *section)
> +{
> +	return section->order;
> +}

You mention open-coded handling, is there any open-coded case that can
be replaced with the new helpers right away?

We strive to have new APIs and at least some of their users in the same
patch.

-- 
Sincerely yours,
Mike.


