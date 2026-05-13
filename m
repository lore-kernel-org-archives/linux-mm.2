Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E60ACD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5066F6B00B3; Wed, 13 May 2026 13:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7826B00B4; Wed, 13 May 2026 13:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD6B6B00B5; Wed, 13 May 2026 13:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5D06B00B3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:01:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF5521C0310
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:00:59 +0000 (UTC)
X-FDA: 84763011438.24.69AB8F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id AB643C001C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:00:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6cCxd+S;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778691657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hH3VrDzsqu0LO7UXV3Efsn9Ds/vcRa3gWEqo+cBypCY=;
	b=zultDk8UJMFp9+w+cm3nKnVFwF31xNxkB7aDDAFymteVkUdOhnr+zmlMXzP1lKFF5tPKmN
	0d3tPUyBVZSwFO0Xi/Wwx8w0TcDRCO3q6PWrKDf1qq/yk6sPn9RDabLl4CYkafYT+aK7cZ
	63NSFbb+O/sUpY45vDzKMBn6DpO5iN8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6cCxd+S;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778691657; a=rsa-sha256;
	cv=none;
	b=1EL2D2FkJZk5ZMe8rbrB/k6MY9igzUuC9TadS6hJxJkZTCG8814mNaePhuB7rIWgqU7Ob/
	GojUGVEqPc6bo/IcD6o/pdhxvKORI7lITHf9rkvM5tF13uOwO+ickaCO1VPlYSt5wFNHDD
	5Egwk1UmBrW3CWmUgxoOCo9FRs7s6Vw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88ED0418E0;
	Wed, 13 May 2026 17:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BA9C2BCB7;
	Wed, 13 May 2026 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778691656;
	bh=0PgoVkbIJH9N2NoH6XkGPw5C/TAeZ3Yv9+lY6pYTSFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S6cCxd+SxxusCjiRuyArac5qlK/iNc5LrpHJJ7i3t0muizcOZy7bg4MnhRpPUvFCx
	 VzzXoI2Nyuv9WEHzb0tR5VeAaHfnyEgGY4VQI9jUpBch9cEOk8qgBbExafU+EuclzQ
	 GLn0EYb12XUZAp7s5E+lmJhc9CsFwZXc2oVaxXJEaWuznYP7KZ6/OenrO1owA/X0B1
	 eh1M7fK3+iitM41MQMuXq9KmhYS7Q2mYwKyKwd/r4VCUKYKBSEuE3vT3t4Z9gKOdxD
	 BGz/xV/6hjQewzIQ8MWBty1RwjOwQUcx7vyDRwLju4vMD1CMdiae+WpigXbjTEAs8/
	 xI3mqGLcJkdEw==
Message-ID: <3453825f-2bc0-4d63-8731-3eaf9fc716a4@kernel.org>
Date: Wed, 13 May 2026 19:00:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/22] mm/page_alloc: implement
 __GFP_UNMAPPED|__GFP_ZERO allocations
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB643C001C
X-Stat-Signature: g83iqf46pu7oe4s4xwbkygdqbnhx6cxc
X-HE-Tag: 1778691657-444084
X-HE-Meta: U2FsdGVkX18fuEFtdKZvExEpvAuRMw1Fhi9MCoUdsP6LiK+RSicujfaNDNvfEUh8n1KfCWY8xwE/7ycXXw2mULsTz62jf62gdNlSbA0WX2v+0CNA/5SEBRx7E/2BtNgYNlwTAfIhUcWXhWpN29mI/KMpvwTMv2PUAdLHNy402kpy5/f38VRQ/Q3wv1MAy6zSj6V41dOGMPu6ls/UG5YqWAgxkY3fOHSlQ+Z1ourlmqeuvh0N5uW5qDfBWOWj1YLpMrgrHofXIxlTVzNRzQ1lmSIhi/VR+wZ2yHU/hE5/8yHdWMZDAi9uWMsGLjIqIxxKrawGBbaXc7PrhHbtFNtGVYn9LFyTm6GpBeWTGdN37ANoOnswfVrQeAt+Eo1E7B+7WY1xlhZF+/Gpkelp99Nm+lrc7+UUDmkhLyvWYPIhALPqN9QFYxezUui28U7K57p1WCH8DK63dqIoH8xpwgBn3hNm508oe+5Q36k5ckrlCGgQ81Qgwd8hSMRu5qgdTDxEAQ31+q2PQNOpWlwvjoOsnyZkdjn7GloCWSoRmaDqW49VTi6xGYDeXnN3v3xmGwoG3SkmjjJptP/NfBA5x9z03r+9YHh66IMyQmgbdV6bc6acgVlDC2Gas0OJefM/T2DU3GAHmYHo/XOybqQziwymOKDbA3mMzP+n8nn81klEl+rPog11JHFSE+eNP0LZHlzCR2S6pzXVAhehQgqmHPvOylsvKTbDl0wBM8RK8LEq5XMkq1Fl7U/aMPPr6DCgTlMz3/lb1XgL+N0xNNzjvh/NeA6RapGoG4Xu1c4BbTMs9t+BCeHTAXpUX4rf0f3BpbgQB2/fVD+Yz+kyNCrgPnf/nPq3LK06GWxTICG9v6cpWKH5GJJ+u3nwR/rsY48ZskF0gGNjI3QRY5ROTac2FZNF3NHFxXqG2DCDI4BWpURaE2X+3J08LvCJsKIvuhfVwLES6c9Ig7XBVej+N+8HnpS
 E2gaRjfd
 sy2DTVfIZx/oIpP+VPPzlkI8fdKnw0rhmi6PSOqqj6IPKT2oFdicVhDbdzdjd0DjXVmO9jNqSlekzjvVp81VZckbh0RxSZI/PTyMQgrPzIN4geQLMyVBSbFyYvsAMHRVF7MeK870UV+wlCyxyZz9yW5NEegKkZLiGub6MR+HSiwOlwYjkYxOLFcwvgnzcJfkoHVq94W13R+I5QRtmVe0/nulUpJ/kR7+O3Z4ypMGgmiu/JKaG1ou7rvm73mQNIBe4S4Do/TDTDxKCUpVq1TWfIgOuLifwPt0i6D/SPv3mVy4w50IJaodAJbzjKbJDP/m+iTHBiiHfhj3IxipK/jpZbZXax4lEPM2Hcjdy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> The pages being zeroed here are unmapped, so they can't be zeroed via
> the direct map. Temporarily mapping them in the direct map is not
> possible because:
> 
> - In general this requires allocating pagetables,
> 
> - Unmapping them would require a TLB shootdown, which can't be done in
>   general from the allocator (x86 requires IRQs on).
> 
> Therefore, use the new mermap mechanism to zero these pages.
> 
> The main mermap API is expected to fail very often. In order to avoid
> needing to fail allocations when that happens, instead fallback to the
> special mermap_get_reserved() variant, which is less efficient.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  arch/x86/include/asm/pgtable_types.h |  2 +
>  mm/Kconfig                           | 11 +++++-
>  mm/page_alloc.c                      | 76 +++++++++++++++++++++++++++++++-----
>  3 files changed, 78 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 2ec250ba467e2..c3d73bdfff1fa 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -223,6 +223,7 @@ enum page_cache_mode {
>  #define __PAGE_KERNEL_RO	 (__PP|   0|   0|___A|__NX|   0|   0|___G)
>  #define __PAGE_KERNEL_ROX	 (__PP|   0|   0|___A|   0|   0|   0|___G)
>  #define __PAGE_KERNEL		 (__PP|__RW|   0|___A|__NX|___D|   0|___G)
> +#define __PAGE_KERNEL_NOGLOBAL	 (__PP|__RW|   0|___A|__NX|___D|   0|   0)
>  #define __PAGE_KERNEL_EXEC	 (__PP|__RW|   0|___A|   0|___D|   0|___G)
>  #define __PAGE_KERNEL_NOCACHE	 (__PP|__RW|   0|___A|__NX|___D|   0|___G| __NC)
>  #define __PAGE_KERNEL_VVAR	 (__PP|   0|_USR|___A|__NX|   0|   0|___G)
> @@ -245,6 +246,7 @@ enum page_cache_mode {
>  #define __pgprot_mask(x)	__pgprot((x) & __default_kernel_pte_mask)
>  
>  #define PAGE_KERNEL		__pgprot_mask(__PAGE_KERNEL            | _ENC)
> +#define PAGE_KERNEL_NOGLOBAL	__pgprot_mask(__PAGE_KERNEL_NOGLOBAL   | _ENC)
>  #define PAGE_KERNEL_NOENC	__pgprot_mask(__PAGE_KERNEL            |    0)
>  #define PAGE_KERNEL_RO		__pgprot_mask(__PAGE_KERNEL_RO         | _ENC)
>  #define PAGE_KERNEL_EXEC	__pgprot_mask(__PAGE_KERNEL_EXEC       | _ENC)

Should this be part of earlier mermap x86 patches?

> diff --git a/mm/Kconfig b/mm/Kconfig
> index e4cb52149acad..05b2bb841d0e0 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1506,7 +1506,14 @@ config MERMAP_KUNIT_TEST
>  	  If unsure, say N.
>  
>  config PAGE_ALLOC_UNMAPPED
> -	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
> -	default COMPILE_TEST
> +	bool "Support allocating pages that aren't in the direct map"
> +	depends on MERMAP
> +
> +config PAGE_ALLOC_KUNIT_TESTS
> +	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Builds KUnit tests for the page allocator.

This belongs to the next patch?

>  endmenu
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 710ee9f46d467..7c91dcbe32576 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -14,6 +14,7 @@
>   *          (lots of bits borrowed from Ingo Molnar & Andrew Morton)
>   */
>  
> +#include <linux/mermap.h>
>  #include <linux/stddef.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> @@ -1327,15 +1328,72 @@ static inline bool should_skip_kasan_poison(struct page *page)
>  	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
>  }
>  
> -static void kernel_init_pages(struct page *page, int numpages)
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +static inline bool pageblock_unmapped(struct page *page)
>  {
> -	int i;
> +	return freetype_flags(get_pageblock_freetype(page)) & FREETYPE_UNMAPPED;
> +}
>  
> -	/* s390's use of memset() could override KASAN redzones. */
> -	kasan_disable_current();
> -	for (i = 0; i < numpages; i++)
> -		clear_highpage_kasan_tagged(page + i);
> -	kasan_enable_current();
> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
> +{
> +	void *mermap;
> +
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
> +
> +	/* Fast path: single mapping (may fail under preemption). */
> +	mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
> +	if (mermap) {
> +		void *buf = kasan_reset_tag(mermap_addr(mermap));
> +
> +		for (int i = 0; i < numpages; i++)
> +			clear_page(buf + (i << PAGE_SHIFT));
> +		mermap_put(mermap);
> +		return;
> +	}
> +
> +	/* Slow path, map each page individually (always succeeds). */
> +	for (int i = 0; i < numpages; i++) {
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
> +		mermap = mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
> +		clear_page(kasan_reset_tag(mermap_addr(mermap)));
> +		mermap_put(mermap);
> +		local_irq_restore(flags);
> +	}
> +}
> +#else
> +static inline bool pageblock_unmapped(struct page *page)
> +{
> +	return false;
> +}
> +
> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
> +{
> +	BUG();
> +}
> +#endif
> +
> +static void kernel_init_pages(struct page *page, unsigned int numpages)
> +{
> +	int num_blocks = DIV_ROUND_UP(numpages, pageblock_nr_pages);
> +
> +	for (int block = 0; block < num_blocks; block++) {
> +		struct page *block_page = page + (block << pageblock_order);
> +		bool unmapped = pageblock_unmapped(block_page);
> +
> +		/* s390's use of memset() could override KASAN redzones. */
> +		kasan_disable_current();
> +		if (unmapped) {
> +			clear_page_mermap(block_page, numpages);
> +		} else {
> +			for (int i = 0; i < min(numpages, pageblock_nr_pages); i++)
> +				clear_highpage_kasan_tagged(block_page + i);
> +		}
> +		kasan_enable_current();
> +
> +		numpages -= pageblock_nr_pages;
> +	}
>  }
>  
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> @@ -5250,8 +5308,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	ac->nodemask = nodemask;
>  	ac->freetype = gfp_freetype(gfp_mask);
>  
> -	/* Not implemented yet. */
> -	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)
> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED &&
> +	    WARN_ON(!mermap_ready()))
>  		return false;
>  
>  	if (cpusets_enabled()) {
> 


