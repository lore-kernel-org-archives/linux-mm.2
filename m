Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A828DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7DB8E0012; Tue, 11 Nov 2025 03:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0583F8E0002; Tue, 11 Nov 2025 03:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED71D8E0012; Tue, 11 Nov 2025 03:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBCBE8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:59:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 894511A04A3
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:59:53 +0000 (UTC)
X-FDA: 84097728666.17.0022052
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9BCCE160004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:59:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ylrv4gl7+C8Suhfr7XCvJiCKcDkTqrNjLEn+8wEGBVM=;
	b=o/bVhIwPkJkziXsampMlAC2LLlnFgetwE9uGfZMC4OGSgmnxntykCF16wXBs6atQ28eTJl
	NpR7gP92K8K+64hu2v+pyle7jhkY6LMS35ihUUK/wdyJsrCCuJ1HF//zbghN52syRWt9at
	wyMUantewYFOVzwudlm+QqX+OX7cxdA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762851591; a=rsa-sha256;
	cv=none;
	b=vyyUNRTuOtiYvQAPU1g8WER8QHof86/+A0k4A+ZFDvpQjUzOAOsMNmkA3RnY6qMGKxdLwf
	n6rfHF8Vrleu5E/cWoY84L6O8MdvpA9Ez+tdstsyvFRM4MzG5iJfr+Mf3ONX2VqNYWc8gw
	mLGp/w/HggnchSutK8/O2VJI8M7dwG0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD4842F;
	Tue, 11 Nov 2025 00:59:42 -0800 (PST)
Received: from [10.163.74.35] (unknown [10.163.74.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 803293F66E;
	Tue, 11 Nov 2025 00:59:48 -0800 (PST)
Message-ID: <29319ba1-9093-4ec4-b84a-3c60d2b00264@arm.com>
Date: Tue, 11 Nov 2025 14:29:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
Cc: Vishal Moola <vishal.moola@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-6-willy@infradead.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251020001652.2116669-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9BCCE160004
X-Stat-Signature: 9aagkrph35aqxbroyu15ere6kcxd3op8
X-Rspam-User: 
X-HE-Tag: 1762851591-176300
X-HE-Meta: U2FsdGVkX19fdUwRjJ5nzArrCNJKwNgw7zp/6FbUHBj4qxtg5sYfh5cFp1uhM9GC+E44oNwVthurK7HvP8oQf9ewtGCsaMhJT6OFqyzytXIepidkSjAHDSxDbyCy23moALWRF53jkNMDzgfeJ4E4VxgWly3e+JsdUbAOqF2ZBGaH0iC7z2rAruHQdzi8V6hamSpx/V7p9/z580ngkZmS8BA1lxXot2FyzA44c+EX//lo8cJOy2c/2Pzq5lBGYUysAOQsjMiJNafo3kPy6x+iyC0NXacOzMA8iYa1/PpCub8pgl/y+gAuMVSnWz6BiBQCGIkgyitn0CqCoOqJnWW0YL6MO5o2tX8hOZuC8RRtGKnjFVIg8cRxVwSKMysNWz7VQozoTQyBm2e2z/xmQHWU3ZlfHP1KPNkrasUMtQy6Xed/zt9LcR+NTb8JOKs197F9YQDnsfdhS29diiY1wDU467hi0Pwuaa9w2X3JsYM/f8+GjIwfxWfZArayBBAiAsV/WVslmjFaLAErZew08wcZVhfgquI3d/32meLVKhCYvfzReYYxsDWAvVvzhZcII7jcnFWBvmlQgcz3BkPg2tpEdkUBKr0qV6OZ34h1nv2djOXTtoUySpXEs8y41dhUUEdzKeL43OMdxqs4E8SkO80qlG4NonFdp7O75yI9awfGXGSAWNlHzkFjH5RpZJJLUpRc3IgvrbGIE+BEFhJlyFjq9Ld6COxwbB8ghqS63XoSf/GO6C1+Slh+7DPqMuHGWfvk3PCOHM3pRcvos93t6o3IvFYziMGujDxNERJHNGZ5jnLGyzi/j3/bvh2pp1ghio6RFt3BZbPBLUm4XxX80rMf1S+IK86LpC5052FpTELlSniIAERR0FAYMTIqfKN4LDZHIUK0iURvfse67Qh5cB59AGixG5KcqOS4r/ip3UUhjMJprQnZsFK4MflRSNCRq7EOAXmrlQrXt2l6ELsHz00
 vHm0ng4Y
 BLRlgsPkrq0OwSPKTnGR1JV6YyovA9IRrI7PEA9W7Y4ikqkIvoJzFV5PepkqclLwkrYfQc6V8mrLt2zpaTV/SGhv3iZZhrC+DkVvBsFLuHh0LDyXq9+hK+kXmLkRSoqjDiGyY8STkpOB560UUgQz1XSlXKbODnzSBxqqSZ9ZwFdY+R7YFbl/LUM4RhvVA0w+7vCHC5goytn0DngfTT44RZfUGbqGMw8P2PynyJDrnzodVJzat5kjE9ifUxqG3nsRt8rbtvptR9NO8Jyw/pdp3OepEvko7FFJXLykT7Kvd75orK5ySRHfHoWY6Sei+DSzzAUXT1NuyBoAo19RLbIM3vjmTAmjOTsEkEuAH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/10/25 5:46 AM, Matthew Wilcox (Oracle) wrote:
> When separately allocating ptdesc from struct page, calling
> preallocate_vmalloc_pages() from mem_init() is too early as the slab
> allocator hasn't been set up yet.  Move preallocate_vmalloc_pages() to
> vmalloc_init() which is called after the slab allocator has been set up.
> 
> Honestly, this patch is a bit bobbins and I'm sure it'll be reworked
> before it goes upstream.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  arch/x86/mm/init_64.c |  4 +---
>  include/linux/mm.h    | 33 +++++++++++++++++++++++++++++++--
>  mm/vmalloc.c          |  2 ++
>  3 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 0e4270e20fad..5270fc24f6f6 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1322,7 +1322,7 @@ static void __init register_page_bootmem_info(void)
>   * Only the level which needs to be synchronized between all page-tables is
>   * allocated because the synchronization can be expensive.
>   */
> -static void __init preallocate_vmalloc_pages(void)
> +void __init preallocate_vmalloc_pages(void)
>  {
>  	unsigned long addr;
>  	const char *lvl;
> @@ -1390,8 +1390,6 @@ void __init mem_init(void)
>  	/* Register memory areas for /proc/kcore */
>  	if (get_gate_vma(&init_mm))
>  		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
> -
> -	preallocate_vmalloc_pages();
>  }
>  
>  int kernel_set_to_readonly;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index edcb7d75542f..e60b181da3df 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1160,6 +1160,12 @@ static inline int is_vmalloc_or_module_addr(const void *x)
>  }
>  #endif
>  
> +#ifdef CONFIG_X86
> +void __init preallocate_vmalloc_pages(void);
> +#else
> +static inline void preallocate_vmalloc_pages(void) { }
> +#endif
> +
>  /*
>   * How many times the entire folio is mapped as a single unit (eg by a
>   * PMD or PUD entry).  This is probably not what you want, except for
> @@ -2939,9 +2945,32 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
>  }
>  #endif /* CONFIG_MMU */
>  
> +static inline struct page *ptdesc_page(const struct ptdesc *pt)
> +{
> +	return pt->pt_page;
> +}

pt_page has not been added as an element into ptdesc and hence
the build fails upto this patch.
> +
> +static inline struct ptdesc *page_ptdesc(const struct page *page)
> +{
> +	memdesc_t memdesc = READ_ONCE(page->memdesc);
> +
> +	if (memdesc_type(memdesc) != MEMDESC_TYPE_PAGE_TABLE) {
> +		printk(KERN_EMERG "memdesc %lx index %lx\n", memdesc.v, page->__folio_index);
> +		VM_BUG_ON_PAGE(1, page);
> +		return NULL;
> +	}
> +	return (void *)(memdesc.v - MEMDESC_TYPE_PAGE_TABLE);
> +}

Ditto - these elements have not been introduced.
> +
> +/**
> + * enum pt_flags = How the ptdesc flags bits are used.
> + * @PT_reserved: Used by PowerPC
> + *
> + * The pt flags are stored in a memdesc_flags_t.
> + * The high bits are used for information like zone/node/section.
> + */
>  enum pt_flags {
>  	PT_reserved = PG_reserved,
> -	/* High bits are used for zone/node/section */
>  };
>  
>  static inline struct ptdesc *virt_to_ptdesc(const void *x)
> @@ -2957,7 +2986,7 @@ static inline struct ptdesc *virt_to_ptdesc(const void *x)
>   */
>  static inline void *ptdesc_address(const struct ptdesc *pt)
>  {
> -	return folio_address(ptdesc_folio(pt));
> +	return page_address(pt->pt_page);
>  }
>  
>  static inline bool pagetable_is_reserved(struct ptdesc *pt)
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..9b349051a83a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5264,6 +5264,8 @@ void __init vmalloc_init(void)
>  	struct vm_struct *tmp;
>  	int i;
>  
> +	preallocate_vmalloc_pages();
> +
>  	/*
>  	 * Create the cache for vmap_area objects.
>  	 */


