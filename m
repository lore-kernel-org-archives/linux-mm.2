Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5E7C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE886B007B; Tue,  4 Aug 2026 22:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5416B0092; Tue,  4 Aug 2026 22:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB0C6B0093; Tue,  4 Aug 2026 22:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96CDA6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:46:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 302CC80213
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:46:03 +0000 (UTC)
X-FDA: 85065676206.15.EF38962
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 974F640005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:45:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ntaXuvkZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785897961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vszTdmI/6U9C77/hLmYs62w3OXYnIeDOydJXj5JIneM=;
	b=U1gEvxEUdVBy3DhJ3xAux6njO0i0eY6mB4q4LcCMRDjMq/IDp8ew5VaMorWqZovmRS3ROX
	CspT51IMTytgbWtmU4SZnpEIuhsUrZLatskfsvVeNy5NElYCyCFWzRVI895ljdaTjlejHt
	5ZODCqYQMNxQ2CU403LGzs/zjzywANs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ntaXuvkZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785897961;
	b=rPhRZPDIVcaGiJ1HxgWp+zf0OCjL3TXZWzkDfgVh9FoUd6F5MqGprJsvf2MKELiXKj2Z1c
	ywMiuE/JFfGZ1HBYUAdYG28Os/4Z26SjCPhC+U03IHUJ7mlI5jXGz8IIz9LrpHrBQ7bDNM
	6jgp2Sanv4tvmmkjllQ8PbcmvqDul+E=
Date: Wed, 5 Aug 2026 10:45:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785897957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vszTdmI/6U9C77/hLmYs62w3OXYnIeDOydJXj5JIneM=;
	b=ntaXuvkZoNlKM7NwMSgL7XGFJ8lc16GoJBjWuE+5FV0pq9PB5m5eCsuqk0r8uRmGWyIHuN
	V24qb7qV6/L5ub7x8y5DILgU3JC6iejwVaIQCZbFarJTSTnSZAYfEnFumS7CdLWlsE7y69
	gaoiU/swPiYPmhGjVicJ+w2nJJfJBIY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Message-ID: <anKj2u9jT0WwNO8N@MiWiFi-R3L-srv>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 974F640005
X-Stat-Signature: pw4cqge7bjz1i5qy7mmoat7oyh5tewzr
X-Rspam-User: 
X-HE-Tag: 1785897959-940781
X-HE-Meta: U2FsdGVkX18sdb4knlj2pCKMPZ1JSb/BCkqMDfyZj3insiDlnDdz8nhBB6IwmReRJcjUX6wSPVIOQ+J4fIBBLrt3A+knYFsTWXN9iGDhoAvXZ/3qfbJtk8PT+hmX6nlP3Pf3KYyVMEyqNd4J6ecHaV5yeMIbeQR3BG+nGK4fJDAs6C8b1iUQRIqYHIfqq9d5AMkcryaUni7+k48bf5veqEBd74QlyjTNDX8suv2vJKmoFlIrFzClUYMWtp0xXHk+D8a7aHJw2ockGK+wUCJ7rSKg0r4FrTEk5DQMxCUoobcrg1EsbrwWa6iFrmYLnPdiiVLNcf7o+VJ04TnUC4e4ymrAZg/ka+uStrfZEh2mrqO4UXlXzcIhB6PqZ/SFV+MaOGbDhZobPdUehHIRNTk1co0AfZk/0c9dAGo++nr/m4AzWCp8m9O/z76O4DUMF1vHFE2KixP1CUa3wQfFPImm8Uh9GBAxJfamJG6PVSvQnUz6QyWJ09LONjbspswuhCf+V3DBMbqlkb5n0NkrtuBayrI7J31nwdgWQkOps1JxgyRDvEhYRnls9UNnAZR44LN9ddSQ5Zq7HfYtYOzU1uObZn5O35Kq7EJDUqeYVAKn+bxeLeOCsMiYz50rkIS2pFoVHYsswo8a++JNX90ipeSf9OHLuj0iq6oaaoKiVsrpS0LuDZWz6y+cOkP/41U8Dh4kp4ttYeGXq2yVsmYGz8Q0GfRpjF+qS0ONY7v8kUIfE4fG6BRBgqUn2R0+GWFzRpMnLn9aY3VThr+5Fr+i27M5K5ixrHmxwGP1CjNKPM3eDM7Cb6QztCYKWiS1IuifwNGFBI3jpCdgGIIoE4FlfzIIcu4nbZGrh0pdPtmA+uNb9ZpuRw90gCT/9NPjtXS+LIJbQ2SFn93/p0cUIEPqRel8e1HVTGvFEdTVucBEbMYQWV+gdDPJY2ANlhyI0YIrbIzvxaB32T0z4brTKkF6VD2
 hPPrqF41
 81Jpy1KhtKV20zO8MGYNtX07fnnwxwAnR8wFD4DHg4yNtfBUpE2IBfdqWO9dIkCrduTZRJoxvVH2PTa6fRhxEhIttuk4oLu43FRVfo59j9cXTOxzWdE0MCrzr8QGdN+T0qa3WlxVFSCcn5+u8doPq98j7NYXaYB0fCgh4S0SXMR9W4oW8r8khEf4YT6WbyNvSKG6+GEX/CtjECTJC59TDolU82BpqGG0vTMW9tmB+AkEJF3Lad4tAinuVbDYP0rmJ620lb5pLGHmV+vEZHjVlYkbveiajCcTrdVI6ooe93bsKaOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 at 11:08am, Lorenzo Stoakes (ARM) wrote:
> There are a number of internal headers local to mm/ which reference
> functions and data types without including the relevant headers.
> 
> mm/vma.h is a special case that intentionally does not include additional
> headers, but the others are not.
> 
> This breaks tooling like clangd (which is where I noticed this), though the
> build is OK due to the C files including the headers happening to include
> required dependencies.
> 
> It's better to be explicit about dependencies anyway, so add the missing
> includes and fix clangd as a bonus.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/cma.h           | 1 +
>  mm/hugetlb_cma.h   | 2 ++
>  mm/memcontrol-v1.h | 1 +
>  mm/pgalloc-track.h | 3 +++
>  mm/shuffle.h       | 2 ++
>  mm/swap.h          | 1 +
>  mm/vmalloc.h       | 2 ++
>  7 files changed, 12 insertions(+)

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/cma.h b/mm/cma.h
> index c70180c36559..ab6d39898ea5 100644
> --- a/mm/cma.h
> +++ b/mm/cma.h
> @@ -2,6 +2,7 @@
>  #ifndef __MM_CMA_H__
>  #define __MM_CMA_H__
>  
> +#include <linux/cma.h>
>  #include <linux/debugfs.h>
>  #include <linux/kobject.h>
>  
> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
> index 3aa483573d17..730b2b4965b6 100644
> --- a/mm/hugetlb_cma.h
> +++ b/mm/hugetlb_cma.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_HUGETLB_CMA_H
>  #define _LINUX_HUGETLB_CMA_H
>  
> +#include <linux/hugetlb.h>
> +
>  #ifdef CONFIG_CMA
>  void hugetlb_cma_free_frozen_folio(struct folio *folio);
>  struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 0f703f239c80..1e394269c613 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -4,6 +4,7 @@
>  #define __MM_MEMCONTROL_V1_H
>  
>  #include <linux/cgroup-defs.h>
> +#include <linux/memcontrol.h>
>  
>  /* Cgroup v1 and v2 common declarations */
>  
> diff --git a/mm/pgalloc-track.h b/mm/pgalloc-track.h
> index e9e879de8649..1a6de1358a21 100644
> --- a/mm/pgalloc-track.h
> +++ b/mm/pgalloc-track.h
> @@ -2,6 +2,9 @@
>  #ifndef _LINUX_PGALLOC_TRACK_H
>  #define _LINUX_PGALLOC_TRACK_H
>  
> +#include <linux/mm.h>
> +#include <linux/pgtable.h>
> +
>  #if defined(CONFIG_MMU)
>  static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
>  				     unsigned long address,
> diff --git a/mm/shuffle.h b/mm/shuffle.h
> index 61bbcddeeee6..11bec7521ab8 100644
> --- a/mm/shuffle.h
> +++ b/mm/shuffle.h
> @@ -2,7 +2,9 @@
>  // Copyright(c) 2018 Intel Corporation. All rights reserved.
>  #ifndef _MM_SHUFFLE_H
>  #define _MM_SHUFFLE_H
> +
>  #include <linux/jump_label.h>
> +#include <linux/mmzone.h>
>  
>  #define SHUFFLE_ORDER MAX_PAGE_ORDER
>  
> diff --git a/mm/swap.h b/mm/swap.h
> index d077e5893a42..ec580c713204 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -5,6 +5,7 @@
>  #include <linux/atomic.h> /* for atomic_long_t */
>  #include <linux/mm.h> /* for PAGE_SHIFT */
>  #include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
> +#include <linux/swap.h> /* for MAX_SWAPFILES_SHIFT, struct swap_info_struct */
>  
>  struct mempolicy;
>  struct swap_iocb;
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index dcfe30eaa80c..8866ddcff668 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -5,6 +5,8 @@
>  #ifndef __MM_VMALLOC_H
>  #define __MM_VMALLOC_H
>  
> +#include <linux/vmalloc.h>
> +
>  #ifdef CONFIG_MMU
>  void __init vmalloc_init(void);
>  int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> 
> ---
> base-commit: e47602c51d20a93fa1711ed896dc9480de4374d9
> change-id: 20260804-fix-some-local-headers-0ebc15f34c72
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

