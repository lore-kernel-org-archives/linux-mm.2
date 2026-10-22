Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AB7606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGfY8uhP
Received: by kanga.kvack.org (Postfix)
	id 9940E6B0993; Thu, 22 Oct 2026 12:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D836B0994; Thu, 22 Oct 2026 12:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C386B0995; Thu, 22 Oct 2026 12:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7256B0993
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:33:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B26BC1C0457
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:33:48 +0000 (UTC)
X-FDA: 85350808536.20.F7BF4DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21681120008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:33:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGfY8uhP;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792686827;
	b=xlzkEUFZ6EeDprY/qtfNwPVJJu6aXbMzmX8YDVByMTVruMXB5i+namrad5GA/xADVtXos4
	6ZJokPVONmB3QQ13t63Bx95V2/YtMxWqwd5QhlaAJFRDnBy72m9uqRO2RQM+Rh7ea3Xwcs
	GCfGkOXrvE9v1swfVCgZsCBNrxuh7JI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGfY8uhP;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792686827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpR8WjbHXVeMxwxDz6y1I6beOL7GiQQlFjax9WUKfwY=;
	b=bQZ4tYVcud9H5NVdupsnNZUVT8JnV7xL+W/hpcOsdBX4tmEOxojd1SoGOfgqRH8wTVylbD
	Cc7/CBOeWIpCdyRL+8A9C87elCmpqVjkpj5WFOJV7jWUL9+c0SWOjYIecBpjSR+lnRU3S9
	MaH+l1aTW/QoRoc2QE/NIj9N+P1EY3k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DC5F60A8A;
	Thu, 22 Oct 2026 16:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B02A1F01829;
	Thu, 22 Oct 2026 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792686826;
	bh=LpR8WjbHXVeMxwxDz6y1I6beOL7GiQQlFjax9WUKfwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mGfY8uhP+J1OJ9zOd5vQO36o8Wtj2BKL2APMuWGIC1cKOoGyd3aiCDYeTt4Gsq3tC
	 9wXhZz0su8A5X+82eVyls0J/MGt75DSJppM7sPC+XEv2TLKOuaTikGmV7QgdraLnGZ
	 vkAy2Fmk4wbXqQXys4jSqCBoGBqDYPRFLG0ZepiY3Lnu19OpQu08AT4M3IuLe27XCR
	 BbEDwunBo5rtR/xnN9r7vgcCmuo5sQWEOm/p6+ZoGp4jxVpmkpZVCI25CS++SfNELW
	 VKhWfwvhgrVX+NzJMZN0QCs+G3NKs39w3UCmsAOcZRC5iJrmYi621k35bc8gy9X9Qz
	 IeqViBIxxtuzA==
Date: Thu, 22 Oct 2026 19:33:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
Message-ID: <ato62palTbNjLwN7@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
X-Stat-Signature: js5ekz3uqhwy4up783xhwhw3no3noibh
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 21681120008
X-Rspam-User: 
X-HE-Tag: 1792686826-198779
X-HE-Meta: U2FsdGVkX1/7c0XEdP38We60NLGdDpsaanQ728CIBDBbbPGdGwkG3Et9sjGuPLT+SkrNulwVyc4kLrEwcNpvUTF3zQtA7IodJqIjyzmJgSiPcv1a+SvLjgGQpAcr7qGeALBJOLjgvzXOiHFVV1ZChqjjVHIglbLPIqeqJPyMBUVhknW2NTr6C4Ayy1oJQN9kJLLgkc8SXD3dZacldvKxYYorj8rh7QqXzDE3WFOp8JasM79C3o1prWGJNblpAA1XULLOHbyVfpBuB+Cl9YsN+cfrn5wGYIPye82HYCAqN2Fcqp//w/S9xrafMfrSDKY9IxuLpStZcYio94NWl8X+zijsUMGNhvCsR8tmJ2m+tpSANWsLAQBbtyLfIguBvFMKYV2mnEBoNZ9Vx6YIOriTG7tnPfLi5MNLf8wfjAK3CvJSUSpiTtMF1TPt0qgUd7UsQQj8UiDO7TPul/PhyKLnkDhvoNwr7woYAXCEd5VlOcQV8CGUitgK0j9oMX0rvhMnzs1F1Qe1DncVakO74hCRZO9YsOzt2d6OkZQv3oJAGB5DgZYMxlIJKNiR+6v2BNcX2iN5iy/VIGcgZbIqknrgrGTeZcR+0660wuvmfJkW2/w1euiIkqU7k8Gsp6sPfuI40XrRfsF26g9OeiEjjO6i5gb5vkCSBXtBthghb6sGmuRKEO6stmd1Wbyo0aiNRYKZgExqoXNz7ebtZI/JKkS2WCW9EzIOr8WTzEu+zq2iuTxTrp0FI5IH/Lt+6fpNgfEDexP4cXarwpCOV+IijG82R5Znvm1oi2lfdwiecRA0y1gd2CNFVTzLtTSGxg4P+3dq2iy7pUapCRjLtSiKLwWzIvymL3lu1crUX7gidySUmGh1npD1jOZjwxsGsLS6Is/+LLcTn9/6RUdfKTwStGjNQS+aoL0mMAzbp8wuyc3syxXDscwft3uD0k060q8oSMPCMxqjh+JtLWT7ofFAHHz
 lCRvIygR
 PjkoBWmjvht7iRUC6VsJ261QJGUs6bxRSALdTqIN84DZBFjJFZ5UxN3x4lkKUpqHgSPysRAhxJSCRGNthNKoUhNXmT5hc4xkCdS3bf9vSAQsWeMrhYZToC0v8j7pCrXV+AuosoLm0ISZRWL5CX/NrCWtxNN3lEyPuqK++7ZMJ2A09epCxsHMs+Rot6k/2FXtwlStIl+GBVvKWMXFxBHEA5pjDBdWaECUHMNEeWgXI2PhDU9JawrkJr7x+jZllqS6U5c62UmYNrAr14obiRTSzB9XCXiXenZiuZsMJdgKdNut9E4flv82MIoDLfuSMT2HdV0xg+u8D6aT4M0euRTjfOc6Vr12avAt+OkjB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Breno,

On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
> memblock allocates from and frees to buddy whatever is not reserved, and
> knows nothing about frames an earlier kernel found hardware-poisoned.
> Such a frame can back the memmap, a page table or a percpu area before
> any hwpoison code runs, and otherwise reaches the buddy allocator like
> any other free frame.
> 
> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.

How much this would fragment memblock.reserved?

memblock is not very scalable, to say the least, and each new flag
increases the size of memblock arrays which obviously hurts performance.

Do you have some statistics how many regions would be created for the
poisoned ranges?

> memblock neither allocates from a flagged range nor frees it to buddy.
> memmap_init_reserved_pages() initializes its struct pages like any other
> reserved range, including above first_deferred_pfn, but flags the RAM
> frames PG_hwpoison instead of PG_reserved. That is the state of a frame
> poisoned by this kernel. Holes in the range stay reserved.
> 
> PG_reserved is left clear on purpose. page_is_unmovable() treats a
> reserved page as unmovable but skips a counted PG_hwpoison one, so a
> memory block holding an inherited frame can still be offlined.
> 
> memblock_reserve_hwpoison() is the entry point. It is best effort. Until
> the reserved array can be resized it keeps spare slots for the
> reservations that must not fail. It flags only what no earlier
> reservation covers, a kexec segment for one: that was placed around the
> bad frames, and memblock_add_range() would warn about the overlap. A page
> shared with such a reservation stays with it, so no page is flagged
> twice.
> 
> It returns 0 only when every free part of the range is reserved. If any
> part cannot be reserved it returns an error, even when another part was.
> 
> Name the flag in the debugfs flag table. MEMBLOCK_RSRV_HUGETLB gets a
> name too: it has none, and would be left as a NULL slot below the new
> flag, which memblock_debug_show() passes on to seq_puts().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/memblock.h | 10 ++++++
>  mm/memblock.c            | 80 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 89 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index aa845f488327f2..86755be249666d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
>   * kernel that we know is good to use. It is the only memory that
>   * allocations may happen from in this phase.
>   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
> + * @MEMBLOCK_RSRV_HWPOISON: reserved memory region holding frames an earlier
> + * kernel found to be hardware-poisoned.
>   */
>  enum memblock_flags {
>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> @@ -63,6 +65,7 @@ enum memblock_flags {
>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
>  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
> +	MEMBLOCK_RSRV_HWPOISON	= 0x100, /* poisoned by an earlier kernel */
>  };
>  
>  /**
> @@ -142,6 +145,8 @@ static __always_inline int memblock_reserve_kern(phys_addr_t base, phys_addr_t s
>  	return __memblock_reserve(base, size, NUMA_NO_NODE, MEMBLOCK_RSRV_KERN);
>  }
>  
> +int memblock_reserve_hwpoison(phys_addr_t base, phys_addr_t size);
> +
>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
>  int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
>  #endif
> @@ -295,6 +300,11 @@ static inline bool memblock_is_reserved_noinit(struct memblock_region *m)
>  	return m->flags & MEMBLOCK_RSRV_NOINIT;
>  }
>  
> +static inline bool memblock_is_reserved_hwpoison(struct memblock_region *m)
> +{
> +	return m->flags & MEMBLOCK_RSRV_HWPOISON;
> +}
> +
>  static inline bool memblock_is_driver_managed(struct memblock_region *m)
>  {
>  	return m->flags & MEMBLOCK_DRIVER_MANAGED;
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 31961ed628b0ad..d20d99972a4db0 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -36,6 +36,9 @@
>  # define INIT_MEMBLOCK_RESERVED_REGIONS		INIT_MEMBLOCK_REGIONS
>  #endif
>  
> +/* Reserved slots memblock_reserve_hwpoison() leaves free until a resize. */
> +#define MEMBLOCK_HWPOISON_SPARE			32
> +
>  #ifndef INIT_MEMBLOCK_MEMORY_REGIONS
>  #define INIT_MEMBLOCK_MEMORY_REGIONS		INIT_MEMBLOCK_REGIONS
>  #endif
> @@ -1015,6 +1018,55 @@ int __init_memblock __memblock_reserve(phys_addr_t base, phys_addr_t size,
>  	return memblock_add_range(&memblock.reserved, base, size, nid, flags);
>  }
>  
> +int __init memblock_reserve_hwpoison(phys_addr_t base, phys_addr_t size)
> +{
> +	phys_addr_t end = base + size;
> +	bool reserved = false;
> +	int err = 0;
> +
> +	while (base < end) {
> +		phys_addr_t next = end;
> +		struct memblock_region *r;
> +		bool covered = false;
> +
> +		for_each_reserved_mem_region(r) {
> +			if (r->base + r->size <= base)
> +				continue;
> +			if (r->base >= end)
> +				break;
> +			if (PAGE_ALIGN_DOWN(r->base) <= base) {
> +				base = min(end, PAGE_ALIGN(r->base + r->size));
> +				covered = true;
> +			} else {
> +				next = PAGE_ALIGN_DOWN(r->base);
> +			}
> +			break;
> +		}
> +		if (covered)
> +			continue;
> +
> +		if (!memblock_can_resize &&
> +		    memblock.reserved.cnt + MEMBLOCK_HWPOISON_SPARE >=
> +		    memblock.reserved.max) {
> +			err = -ENOSPC;
> +			break;
> +		}
> +
> +		err = __memblock_reserve(base, next - base, NUMA_NO_NODE,
> +					 MEMBLOCK_RSRV_HWPOISON);
> +		if (err)
> +			break;
> +
> +		reserved = true;
> +		base = next;
> +	}
> +
> +	if (err)
> +		return err;
> +
> +	return reserved ? 0 : -EBUSY;
> +}
> +
>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
>  int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
>  {
> @@ -2394,6 +2446,27 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
>  	}
>  }
>  
> +/*
> + * Frames an earlier kernel found poisoned end up as a frame poisoned by this
> + * kernel would: PG_hwpoison, not PG_reserved. Holes in the range stay reserved.
> + */
> +static void __init memmap_init_hwpoison_range(phys_addr_t start,
> +					      phys_addr_t end, int nid)
> +{
> +	unsigned long pfn;
> +
> +	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		init_deferred_page(pfn, nid);
> +
> +		if (memblock_is_map_memory(PFN_PHYS(pfn)))
> +			hwpoison_boot_page(page);
> +		else
> +			__SetPageReserved(page);
> +	}
> +}
> +
>  static void __init memmap_init_reserved_pages(void)
>  {
>  	struct memblock_region *region;
> @@ -2438,7 +2511,10 @@ static void __init memmap_init_reserved_pages(void)
>  			if (!numa_valid_node(nid))
>  				nid = early_pfn_to_nid(PFN_DOWN(start));
>  
> -			memmap_init_reserved_range(start, end, nid);
> +			if (memblock_is_reserved_hwpoison(region))
> +				memmap_init_hwpoison_range(start, end, nid);
> +			else
> +				memmap_init_reserved_range(start, end, nid);
>  		}
>  	}
>  }
> @@ -2874,6 +2950,8 @@ static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> +	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
> +	[ilog2(MEMBLOCK_RSRV_HWPOISON)] = "RSV_HWPOISON",
>  };
>  
>  static int memblock_debug_show(struct seq_file *m, void *private)
> 
> -- 
> 2.53.0-Meta
> 

-- 
Sincerely yours,
Mike.

