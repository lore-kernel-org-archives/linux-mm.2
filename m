Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DA0F589B6
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41DA6B008C; Thu, 23 Apr 2026 08:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC146B0093; Thu, 23 Apr 2026 08:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08616B0095; Thu, 23 Apr 2026 08:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A4C936B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:48:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48FA4A0148
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:48:56 +0000 (UTC)
X-FDA: 84689800272.12.62F51DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 80DEE80004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:48:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcFSPB7C;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776948534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckdkPfNNYNQ7clDMPEugUQwJkqwGKh9LhLO28GcctCQ=;
	b=N6iqIHaiEoVHZ0NZ+eLOO8eEztufEP6TNso+fHd97dpCQbP+u0azQCpeFsvnN/yOqS4Dts
	pcuIH9bA7iVJ4Jbyt+30nb2e8wh+ma09Il04GJuTKdLmj9SKD86DfIlMv/K/n5kgshtQna
	EC/YwPzpIZA80gpquXNOvAutJWGKvLg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcFSPB7C;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776948534; a=rsa-sha256;
	cv=none;
	b=JRjIOnQZISpGdNckT3acRJtko3koRFOwpnBg+QHG/Jswm5qYTfLZjUNUhNArK9s+K8SJuG
	LB7/1AxcgO4wvFtcLXQXaedV5rYv49V7JMciA+WEKTcbiiRNtTOSXfTKAPNRvCrSfRdSr0
	j/8TDQOxcq9i568WJjsHnB2dHxkxflQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7569C418E1;
	Thu, 23 Apr 2026 12:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DBDC2BCB5;
	Thu, 23 Apr 2026 12:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776948533;
	bh=3SulGgN6syejyR5DSaOUn2aLn8Rpzv+efGh0UUrNjqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dcFSPB7C9SR5oYCDdBRbZyRDWvx8C7coSPJgSXK4GFVU7hAILKsyR111pw4yK7vRy
	 A8iUf0RE+Ub+nWRbQp+8ICIQiBuZddTq1FDANp2EEcWCO9ksP04F6SuWgov5wcnNxO
	 lKu4zgsMsZq91Z7CjOW1OY75o3y7dVbhDPS3BTmIliqtFYje+T+7lplIYqudp/b8IG
	 4/PZL/3voyuUCj1vvlViifNQ+FCP9pJdWtw/rxXZdomz7qqkFSGtIt/fGPDREnT5kg
	 PQxl7qtU9A9RwQQKT5Xoi/jL6M40v8P+DHgfa5rpJh+wR+SZy6o5TTZOdlbxUaZcLw
	 YyEuEjvZee/Fw==
Date: Thu, 23 Apr 2026 15:48:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kaitao cheng <kaitao.cheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Chengkaitao <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm: Convert vmemmap_p?d_populate() to static functions
Message-ID: <aeoVKLcuS38wyGSM@kernel.org>
References: <20260423101441.7089-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423101441.7089-1-kaitao.cheng@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80DEE80004
X-Stat-Signature: sxucqa7ha7rbmfo5zw3h89um9kimao1m
X-Rspam-User: 
X-HE-Tag: 1776948534-86372
X-HE-Meta: U2FsdGVkX19R6vB8EbkqyYcmXTghLnC4g1m4iNen6vMzRrGys+73+GaD1PGaiNJ5eRXnCYRuda1CvJOb7jD5e+MSsg6ECs4BYNNH5fFkb9yQZNVFNIwt/u7iw4FT5gkXx9vgk/5QyK2/5DmCRFaEFqQ0yAR8b1RjaAXDFQSYKy75xCVspb8eaek+3TE8C0dMD7NXio8dbo+d3zqRjcOcdugX/qSnBqfLlGVBD4AVFmJGwV0Mo5tXNWrL71i9QPFz1bHI6NKgt5tehVNyaRUaLh17wcaT8bzFCRkzXpVvD1lSyE3stT1/YHj2i22hUoJOkR5fJmLfp/LAezJokM9Hx8jK1WGtXbi90E2BPabyCBV1WTcLUeQxIQTZC7Afx8v11Vum0WbSC77Y6zpTHgMs4p9PFE7fA4HJsA8bttdVOS/gUauLA4VLsZeqIFZOQLGFiNQr6nae42gAqkpnH9Wd/ShI4RHP5EJX65OykvSO78+NlCC5T2e+JrJQ1vXbTdfRH7uYkraYcV8Yi1K9kcNVze5GfXUzAWKxFHA91OE2HEwS3fJ4Dsaa8AQ6ThePPayeVG7/kl7q/kmOBn9WgqKJEv803bMv84mRawJAX2wItnPpvp1MoDUnRYsn3qZfdT80j3/4UYMDrw9jyJp7Jv2hanktCCqhJTTBBzIG2VPoKtuFtTWafxwnHXYFCe5T0QEkTzEIH+lufZYQ9pz2Hv7oG1M1D6V61aM2KJ2mUR87QMvn7iv3HAwiY6iqaDnXfKzURzQeHs+iMkaCzenE/Gk/rtmzszn/HIWroZktciSaTHTXcgX2EcRTyCVDCY2f/scxKv+YrPy+W5ZFdKM+7J/2o8UzXDM1C04iTqbHreuoP0qyIXtnheFMSovEHuthefF8/HPX89vqNvhZTgWHF/E4sFoQwa3GLjad7ME/EivxnY4vLGl9wRibCcO/Ghvlpal7G4UZv2vAKsxg9L1nvvZ
 E1zCVQ/6
 zxV4cJC5G/18CoiADyy8IIqZ5Ubs27MNdRSAYVMOIHDDkIQ/hK4gN5UTzjTDLQsBoD47nmni/20gizxlNivEEw/yN/Z54wc2XIbSoksB5lFCSP9srGDlsi6YEPYEdbmCWYZPaGapgTb2wprEF87HNXBwt+L9DottRI5evS7phacpeSwCxl5/9+0KTS3eTrjfrI/jlhD06dxikk25bV0BFgvKgwWaIyOfW3wR6qadBfRk9tKEgqh3hmdSfcMJ7UKFoJR2yH7kx11x3KwQbYnw9TL9GS0R3DSHdZzsyHNU5TiCOuzGCTiDhD6Z0cdJl8xiud0r0WZbj37YiLAEP56hIpxu/08Pf/Vx2ekpzETNKIfj0upbjp40/I8lMmFa7DyF//DnSJMpWyMBviHl7o8lf8CpEe/Gc0sCUs5Un5VTwgPbZLhJUGSpj8OojvIJvHOr2uFLZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 06:14:41PM +0800, Kaitao cheng wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> Since the vmemmap_p?d_populate functions are unused outside the mm
> subsystem, we can remove their external declarations and convert
> them to static functions.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h  |  7 -------
>  mm/sparse-vmemmap.c | 10 +++++-----
>  2 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index af23453e9dbd..1d76da6e0791 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4860,13 +4860,6 @@ unsigned long section_map_size(void);
>  struct page * __populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap);
> -pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> -p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
> -pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> -pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
> -pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -			    struct vmem_altmap *altmap, unsigned long ptpfn,
> -			    unsigned long flags);
>  void *vmemmap_alloc_block(unsigned long size, int node);
>  struct vmem_altmap;
>  void *vmemmap_alloc_block_buf(unsigned long size, int node,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 6eadb9d116e4..3c35d2303a61 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
>  			start, end - 1);
>  }
>  
> -pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> +static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>  				       struct vmem_altmap *altmap,
>  				       unsigned long ptpfn, unsigned long flags)
>  {
> @@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
>  	return p;
>  }
>  
> -pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
> +static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  {
>  	pmd_t *pmd = pmd_offset(pud, addr);
>  	if (pmd_none(*pmd)) {
> @@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  	return pmd;
>  }
>  
> -pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
> +static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  {
>  	pud_t *pud = pud_offset(p4d, addr);
>  	if (pud_none(*pud)) {
> @@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  	return pud;
>  }
>  
> -p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
> +static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  {
>  	p4d_t *p4d = p4d_offset(pgd, addr);
>  	if (p4d_none(*p4d)) {
> @@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  	return p4d;
>  }
>  
> -pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> +static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>  {
>  	pgd_t *pgd = pgd_offset_k(addr);
>  	if (pgd_none(*pgd)) {
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Sincerely yours,
Mike.

