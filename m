Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59725C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1D46B008A; Tue,  8 Sep 2026 04:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073776B008C; Tue,  8 Sep 2026 04:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB366B0092; Tue,  8 Sep 2026 04:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2F766B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:20:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AD21A028A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:20:08 +0000 (UTC)
X-FDA: 85189897296.05.8BD3799
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 22BB44000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:20:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xg67lryN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788855606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rULyjEYB8jc20wwyAECU26R5DmQW+vLixPMPPn/ka8=;
	b=Q0R6SMhD9zNNSJE63D85rG9dboYh0sSucEzBLiaNAVXZmcmnO+Ok40QVKQW3/TioFXw4wk
	zmaMESUB7ocamZHG71JMJcnRiUucg9vX4lsnnxYQl59Ko/0yf5V5pZ/5/BiM8dRfKTTOhs
	bAolEUFsghc5Dx5fGxJojJIO7S4wuek=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xg67lryN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788855606;
	b=hnGI9k2W9XZjjR5/cV4IOzZXtys0D85+ZgDI9nAZntE9dkk/EwEvTCxl2EQmExU01UGDCE
	bgmSZ6BeN4XFnzkwJmG+Ml48z+/dJm6KPXxZlMDCCnHCKRVmGnlz4YiydsAFtc83WxqjRB
	3+DEzlYdE+7wO7i7xOzV951HSplZ64k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QMukAefZfPUgbpBQK+irv5yH2EpRpWK4MHebJsSatzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788855601; v=1; x=1789460401;
 b=xg67lryNA+Q2GIQcWChikiwvGDVB5I/S93Sd26sq96BTE/kh8Rzxg/uGEcWxjtJJy7gQuO0Z
 6xh21eSrq0e+k+xIAZ/gtYqzg0+08NwhNoIF5ongyhDH1TtWg4V6NuWZVFPVq4033Ah9vbQj5KF
 1w/5fxtvwaUdKVlmf6c+WHic=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e3be1945dc93c990;
	Tue, 08 Sep 2026 08:20:01 +0000
X-Mizu-Trace-ID: e3be1945dc93c990
X-Migadu-Flow: FLOW_OUT
Message-ID: <99aac41d-a68f-451b-ae10-f7132bb7a291@linux.dev>
Date: Tue, 8 Sep 2026 16:19:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/11] mm/sparse-vmemmap: move HVO helpers to a public
 header
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-8-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260908030335.96549-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22BB44000E
X-Stat-Signature: j1ppsexjfebbpfjpuy4mkuhzz41wsrxn
X-Rspam-User: 
X-HE-Tag: 1788855605-996831
X-HE-Meta: U2FsdGVkX18xWNw38oHZdNZRaLPDLtOP8maljVzl+tGeX9gzP4rlc4Ue0/EvKKrX+7k+mLwGo++xh3WSUFb0Uc2jIvp5cVOL2ZNXUl/yJKTIFTebN3Eu4x37/toa3ce+27O2DvkUG8TZL63wfti2kg8RQ9U6yHkJ5Ur8VwSoKgCV1CeZWNBP8HrmdTvZbtUkufdSmzoNpS7TYE8QQWz8MacnEKhuIaJ1kWOk87rt1muHucc/rGO5dn/eUEnQPW6b2+OBu2s6jt0VvSEWK6SORuRhRyttIieZOHyE95LH25mG8RIYHn0mzUr15Mxul5T63pSKtu/KhyqdNob9PZhfVr65pIkDO1Y+wDucqMiMcAIzxPnKnhHoHh9fuj/NJogGaqHdV6UB13WACcaRmW5Ir4cdJax92Tci0kY1IpYG7d9YfyVi4mKjLYZlIKEmGHJhTrdnHL9cBXq5buzeLFfdRDdTk0r9aQTLK+vwTzlUOktYyyJdjPLLgBBq6ZRikln2V57XJE/cDu4njgJ6OU6zGtSBIrNnvT7f3AhQ3UUwp/bsC0m6wOu595ndIgn2OFQshlV+f3JgOCh6THzvLDMcdH+4uPezLL6vF47K05xHMs9N2OJciqg0xAkMLmc8Ha0NzRYwLlUJdQ23/2LRBU6rx5oiz/uBJae61q77IvK3x0lXqwzBTMLC1EH8DYAZI2ukWwVAPqFb+8PSIswpHPluZ8e3xckKJex7+Y5DtJY+VFlP7nXzarITTU57oJs0/zS8gVZTj0J1YY6ksQa5Tj0f5aaEv8VGTooNim+nTOV3N51JM9YEc5AkchRS/NpDmMJshLiQS6JvlFa0piLKd9eHS6aYi8jy+T0WnVTYTl7vAnW0Wvxa6ajiyx2sckLc4rgs3nD8fpSFnFV9wrgWTJilttHoobLuf75Gt9tLaEBNtBmHJnJ3zwcwd+mUS/83YuDrYrXq1lOKWM0QeSrwRlJ
 z72Y7oKi
 wCF1/Q9E4Tf/DIUTOAndbHkLxsUVkljlIqYmaL+H82uXzY4BR6g6D2ZX3kz3TWu1d8IMLVrr5TQ5sBS9tBGQb8k/91FsOgV2YxvyP59jtl2AZfJanxmMbdUiROp81KqTjU4UJ5brvOFTTA1qqEMuQ/ddyl6WEDjiXv5SZYE5Yq3VWecTu4bN7j22A4GZk6O9hmfxdBXMRJR/YuuIN63HOVkl54NXxxL0bukNLybatAC8M2qzMpEUUgGFhiAqwWgTE8MyGVj0QdZZrFfgNcdqnyrVqVgOeC/Yue7G1RnwRFI1g4nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 11:03 AM, Muchun Song wrote:
> The vmemmap optimization helpers currently live in mm/sparse.h,
> which is an internal MM header. That works for MM code, but
> prevents powerpc from using the same interfaces without including a
> private header.
> 
> Move the declarations and inline helpers to
> include/linux/vmemmap-optimization.h. This is a preparatory change for
> powerpc, which has its own vmemmap optimization implementation and
> needs to use the HVO interfaces from architecture code.

Make sense.

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Fix missing header dependencies.
> ---
>   MAINTAINERS                          |  1 +
>   include/linux/vmemmap-optimization.h | 91 ++++++++++++++++++++++++++++
>   mm/hugetlb.c                         |  2 +-
>   mm/hugetlb_vmemmap.c                 |  2 +-
>   mm/memory_hotplug.c                  |  1 +
>   mm/sparse.h                          | 73 +---------------------
>   6 files changed, 96 insertions(+), 74 deletions(-)
>   create mode 100644 include/linux/vmemmap-optimization.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c7aaa2e4790e..2985286cbbbf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12096,6 +12096,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
>   F:	Documentation/mm/vmemmap_dedup.rst
>   F:	fs/hugetlbfs/
>   F:	include/linux/hugetlb.h
> +F:	include/linux/vmemmap-optimization.h
>   F:	include/trace/events/hugetlbfs.h
>   F:	mm/hugetlb.c
>   F:	mm/hugetlb_cgroup.c
> diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
> new file mode 100644
> index 000000000000..492dc662aae7
> --- /dev/null
> +++ b/include/linux/vmemmap-optimization.h
> @@ -0,0 +1,91 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * vmemmap-optimization.h
> + *
> + * Generic vmemmap optimization declarations.
> + *
> + * Author: Muchun Song <songmuchun@bytedance.com>
> + */
> +#ifndef _LINUX_VMEMMAP_OPTIMIZATION_H
> +#define _LINUX_VMEMMAP_OPTIMIZATION_H
> +
> +#include <linux/align.h>
> +#include <linux/log2.h>
> +#include <linux/mmdebug.h>
> +#include <linux/mmzone.h>
> +
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
> +static inline unsigned int section_order(const struct mem_section *section)
> +{
> +	return section->order;
> +}
> +
> +static inline void section_set_order(struct mem_section *section, unsigned int order)
> +{
> +	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
> +	section->order = order;
> +}
> +
> +static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
> +					   unsigned int order)
> +{
> +	unsigned long section_nr = pfn_to_section_nr(pfn);
> +
> +	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
> +		return;
> +
> +	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
> +		section_set_order(__nr_to_section(section_nr + i), order);
> +}
> +
> +static inline unsigned int pfn_to_section_order(unsigned long pfn)
> +{
> +	return section_order(__pfn_to_section(pfn));
> +}
> +#else
> +static inline unsigned int section_order(const struct mem_section *section)
> +{
> +	return 0;
> +}
> +
> +static inline void section_set_order(struct mem_section *section, unsigned int order)
> +{
> +}
> +
> +static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
> +					   unsigned int order)
> +{
> +}
> +
> +static inline unsigned int pfn_to_section_order(unsigned long pfn)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION */
> +
> +static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
> +{
> +	const unsigned int order = pfn_to_section_order(pfn);
> +	const unsigned long nr_pages = 1UL << order;
> +
> +	if (!is_power_of_2(sizeof(struct page)))
> +		return false;
> +
> +	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
> +}
> +
> +static inline bool vmemmap_optimizable_order(unsigned int order)
> +{
> +	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
> +		return false;
> +
> +	if (!is_power_of_2(sizeof(struct page)))
> +		return false;
> +
> +	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
> +}
> +
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
> +#endif /* CONFIG_SPARSEMEM_VMEMMAP */
> +#endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index fda525bccf50..dff915e6c48b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -38,6 +38,7 @@
>   #include <linux/mm_inline.h>
>   #include <linux/padata.h>
>   #include <linux/pgalloc.h>
> +#include <linux/vmemmap-optimization.h>
>   
>   #include <asm/page.h>
>   #include <asm/tlb.h>
> @@ -52,7 +53,6 @@
>   #include "hugetlb_cma.h"
>   #include "hugetlb_internal.h"
>   #include "mm_init.h"
> -#include "sparse.h"
>   #include <linux/page-isolation.h>
>   
>   #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 4a57e6c3352c..25c4e7d2664c 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -15,10 +15,10 @@
>   #include <linux/mmdebug.h>
>   #include <linux/pagewalk.h>
>   #include <linux/pgalloc.h>
> +#include <linux/vmemmap-optimization.h>
>   
>   #include <asm/tlbflush.h>
>   #include "hugetlb_vmemmap.h"
> -#include "sparse.h"
>   #include "internal.h"
>   
>   /**
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0db0379826df..d7a59167bec4 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -43,6 +43,7 @@
>   #include "mm_init.h"
>   #include "page_alloc.h"
>   #include "shuffle.h"
> +#include "sparse.h"
>   
>   enum {
>   	MEMMAP_ON_MEMORY_DISABLE = 0,
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 59b825df83b9..e511d99fc26b 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -9,77 +9,7 @@
>   #define __MM_SPARSE_H
>   
>   #include <linux/mmzone.h>
> -
> -#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
> -static inline unsigned int section_order(const struct mem_section *section)
> -{
> -	return section->order;
> -}
> -
> -static inline void section_set_order(struct mem_section *section, unsigned int order)
> -{
> -	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
> -	section->order = order;
> -}
> -
> -static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
> -					   unsigned int order)
> -{
> -	unsigned long section_nr = pfn_to_section_nr(pfn);
> -
> -	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
> -		return;
> -
> -	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
> -		section_set_order(__nr_to_section(section_nr + i), order);
> -}
> -
> -static inline unsigned int pfn_to_section_order(unsigned long pfn)
> -{
> -	return section_order(__pfn_to_section(pfn));
> -}
> -#else
> -static inline unsigned int section_order(const struct mem_section *section)
> -{
> -	return 0;
> -}
> -
> -static inline void section_set_order(struct mem_section *section, unsigned int order)
> -{
> -}
> -
> -static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
> -					   unsigned int order)
> -{
> -}
> -
> -static inline unsigned int pfn_to_section_order(unsigned long pfn)
> -{
> -	return 0;
> -}
> -#endif
> -
> -static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
> -{
> -	const unsigned int order = pfn_to_section_order(pfn);
> -	const unsigned long nr_pages = 1UL << order;
> -
> -	if (!is_power_of_2(sizeof(struct page)))
> -		return false;
> -
> -	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
> -}
> -
> -static inline bool vmemmap_optimizable_order(unsigned int order)
> -{
> -	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
> -		return false;
> -
> -	if (!is_power_of_2(sizeof(struct page)))
> -		return false;
> -
> -	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
> -}
> +#include <linux/vmemmap-optimization.h>
>   
>   /*
>    * mm/sparse.c
> @@ -139,7 +69,6 @@ static inline void sparse_sections_init(void) {}
>    * mm/sparse-vmemmap.c
>    */
>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
>   void sparse_init_subsection_map(void);
>   int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
>   		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);


