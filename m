Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F76D68BE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03EA6B0089; Thu, 18 Dec 2025 02:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1F16B008A; Thu, 18 Dec 2025 02:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADED46B008C; Thu, 18 Dec 2025 02:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A157F6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:36:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 473EC13BEF8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:36:32 +0000 (UTC)
X-FDA: 84231784224.29.052F139
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF64B80009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:36:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbACSOIE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766043390; a=rsa-sha256;
	cv=none;
	b=CphdvXGY6cfeSRkXmJo2iUcMG0qUFbuITlzZL+daOnw+Ces8FLoZrsVkWYNNQ/82cnThCi
	Zdf4AgoCCr+pML7jOR5pkQZg8DwtwngW6xjGTb+JC3qXdNI33pvcXDOpSTIm3sc3JPZ6bd
	f7Eu7C6UPHgAQlc2BnEFFztyKuCIySM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbACSOIE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766043390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6+HCebxkTT+cIemeg0kx8IMXACGfxasZMIysmNgvE0=;
	b=Z9tvU8dFYMsZKCCbZ3SiuKLuBB4jIisCNP0CtON7ZUQIZ35bJKHfuP5aFy4lH5g0OrXV0E
	wMJb2pBN9sxz4lJSpeLkWYL7Cd/z+z0kC4lrPOj51zLIQUepnaWVgQ7fUvF4/bjDcxQTq0
	g2SGBQ4tq1ahhkosBJVtScgvTU8cvVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3643E60121;
	Thu, 18 Dec 2025 07:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE602C4CEFB;
	Thu, 18 Dec 2025 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766043389;
	bh=JzSi9JpxmDdhy98aPhaBgGSZwBxDB4T3bBzV6+TcLUM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VbACSOIEGoszmQd/mkjZfbPlwj3kRyrwzQgG6n/lQt1SFzo7luoWe4X02tCLjuzca
	 ELs5yVoX67kEHOgyN1k7McV87tvTnRa17agKN56xJQGhSAqmd1Qov85scRYWulz7Wc
	 4/V+w5XUi2EgezT/U7dEhUq89xoK6E7d+8qIckDdfHBia4HHtiza+Y1BPkwUiBcEO3
	 YLNJ8XBuz8GV6P/Yr61F7/zEmNALvBYzxa9j69ahcXrgDmnXW5TOo8PFy9ALpi1SQK
	 zkT+ILLn++speO5DTn0Qt3Pphx6FUmYsvFbw6uY9XDi8rCOOewSe12dzMwBlBReuQs
	 KPZnBmOpj4S1Q==
Message-ID: <9ad1ad81-67e2-4274-afe3-5b9bfb5c7ad1@kernel.org>
Date: Thu, 18 Dec 2025 08:36:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-8-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215204922.475324-8-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF64B80009
X-Stat-Signature: wrs5yf68fokafcf39hsmqyxdnhbrm36i
X-Rspam-User: 
X-HE-Tag: 1766043390-243688
X-HE-Meta: U2FsdGVkX190I1IqOGLPLr/QbV6lbdjERdJmZ9eRvVMEILj5AJl0zIrsvmDAX8PLA8K6jsunMR7TNHRcnPEXK7U3wzNiQctXS6XYVIXgbVjsrFOuW8h04XJMSrbU4ahiwqwrNJQ2od9OPqtkAA5tzSMvkKqRdrVn41qyDFToVIQXPPapseWjo04chPclD7ZgnNzGtBoCduPVVGnTUdHtjbkDkoSLJuVFTyXRU0l16YtjJwA6FzryPiSFsLpKNM8se+d9p/saz7l5msKkcrDpL92NUZ+bn/PVaUIXvoAcigLxICY6bCbbbXa1JbuYb0bYth8w4HzFw/3JVAVrBLE/jRVsyKvlXdHXaiKqRYAk8n7JPvlOGp1vsl2gGQZBMSb5DK8EAaQqMUzF3O/h2vmtrBwHpaSmbBBtLe/waD6kfK6XQV9q3Q0lmxFdoyz3zzjXmJeqIjtkUdk0xo7QthcdsJSJFkjA9EavbfKlVEF8VSThUeQb7qnBk70DJeWHihEqYtmxwpO4cVxzojGEO8FaDHc6qlMT4jix2a8GMaYeXTZk7bJ+f26EopLAT7os/sMLPUN07X+9e9X3ssj/18TcHB+pXPhnl7wDJadYsNoZ3ObR1ERnPwclx8Ey8XEcVVJLMlA6PXfg2zp8bZxQ0Ei6F3miC0EZ2I7LGceLbRXR+6ArY5UxkTRhKVSGF9CJkCnZ3Qufmhuf/58oCkq6H9Oy8DJMOvxBprmqz+8OcVSasuF/duI55qdMrOQ+0B2HYK+FPP3/8I4pblsjjUuwC3AdTj2ug/VBhzTYcOEGJlhQP2aNGec/ByduWtF3hIEOiDZTOMPPfwf54KyZenB0XnTEH3HmTW3rq+IS+Bsk8tU83sCk+lrQjFsESPrnEy4XIOgdR+Y8v7Aohceqabw+uJ6M1w2ysAxpRFLh/X2sRbvWn+JSjhI+ZTIbE9Gzwef3f804+HFZY6GXJIXbRSbvCiX
 37rmJOqi
 sgjk3KJ/16mRV4ILkKH5Jz01ax+RXYXj/uMpY1HPotGD1xdM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 21:49, Ankur Arora wrote:
> Clear contiguous page ranges in folio_zero_user() instead of clearing
> a single page at a time. Exposing larger ranges enables extent based
> processor optimizations.
> 
> However, because the underlying clearing primitives do not, or might
> not be able to check to call cond_resched() to check if preemption
> is required, limit the worst case preemption latency by doing the
> clearing in no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.
> 
> For architectures that define clear_pages(), we assume that the
> clearing is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB
> worth of pages. This should be large enough to allow the processor
> to optimize the operation and yet small enough that we see reasonable
> preemption latency for when this optimization is not possible
> (ex. slow microarchitectures, memory bandwidth saturation.)
> 
> Architectures that don't define clear_pages() will continue to use
> the base value (single page). And, preemptible models don't need
> invocations of cond_resched() so don't care about the batch size.
> 
> The resultant performance depends on the kinds of optimizations
> available to the CPU for the region size being cleared. Two classes
> of optimizations:
> 
>    - clearing iteration costs are amortized over a range larger
>      than a single page.
>    - cacheline allocation elision (seen on AMD Zen models).
> 
> Testing a demand fault workload shows an improved baseline from the
> first optimization and a larger improvement when the region being
> cleared is large enough for the second optimization.
> 
> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):
> 
>    $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
> 
>                      page-at-a-time     contiguous clearing      change
> 
>                    (GB/s  +- %stdev)     (GB/s  +- %stdev)
> 
>     pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*
> 
>     pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
>     pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy
> 
>   [#] Notice that we perform much better with preempt=full|lazy. As
>    mentioned above, preemptible models not needing explicit invocations
>    of cond_resched() allow clearing of the full extent (1GB) as a
>    single unit.
>    In comparison the maximum extent used for preempt=none|voluntary is
>    PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).
> 
>    The larger extent allows the processor to elide cacheline
>    allocation (on Milan the threshold is LLC-size=32MB.)
> 
> Also as mentioned earlier, the baseline improvement is not specific to
> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
> improvement as the Milan pg-sz=2MB workload above (~30%).
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>   include/linux/mm.h | 38 +++++++++++++++++++++++++++++++++++++-
>   mm/memory.c        | 46 +++++++++++++++++++++++++---------------------
>   2 files changed, 62 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 12106ebf1a50..45e5e0ef620c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4194,7 +4194,6 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> -#ifndef clear_pages

Why is that change part of this patch?

Looks like this should either go into the patch introducing 
clear_pages() (#3 ?).

>   /**
>    * clear_pages() - clear a page range for kernel-internal use.
>    * @addr: start address
> @@ -4204,7 +4203,18 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>    * mapped to user space.
>    *
>    * Does absolutely no exception handling.
> + *
> + * Note that even though the clearing operation is preemptible, clear_pages()
> + * does not (and on architectures where it reduces to a few long-running
> + * instructions, might not be able to) call cond_resched() to check if
> + * rescheduling is required.
> + *
> + * When running under preemptible models this is fine, since clear_pages(),
> + * even when reduced to long-running instructions, is preemptible.
> + * Under cooperatively scheduled models, however, the caller is expected to
> + * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
>    */
> +#ifndef clear_pages
>   static inline void clear_pages(void *addr, unsigned int npages)
>   {
>   	do {
> @@ -4214,6 +4224,32 @@ static inline void clear_pages(void *addr, unsigned int npages)
>   }
>   #endif
>   
> +#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
> +#ifdef clear_pages
> +/*
> + * The architecture defines clear_pages(), and we assume that it is
> + * generally "fast". So choose a batch size large enough to allow the processor
> + * headroom for optimizing the operation and yet small enough that we see
> + * reasonable preemption latency for when this optimization is not possible
> + * (ex. slow microarchitectures, memory bandwidth saturation.)
> + *
> + * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
> + * result in worst case preemption latency of around 1ms when clearing pages.
> + *
> + * (See comment above clear_pages() for why preemption latency is a concern
> + * here.)
> + */
> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
> +#else /* !clear_pages */
> +/*
> + * The architecture does not provide a clear_pages() implementation. Assume
> + * that clear_page() -- which clear_pages() will fallback to -- is relatively
> + * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
> + */
> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
> +#endif
> +#endif
> +
>   #ifdef __HAVE_ARCH_GATE_AREA
>   extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>   extern int in_gate_area_no_mm(unsigned long addr);
> diff --git a/mm/memory.c b/mm/memory.c
> index 2a55edc48a65..974c48db6089 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7237,40 +7237,44 @@ static inline int process_huge_page(
>   	return 0;
>   }
>   
> -static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
> -				unsigned int nr_pages)
> +static void clear_contig_highpages(struct page *page, unsigned long addr,
> +				   unsigned int npages)
>   {
> -	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
> -	int i;
> +	unsigned int i, count, unit;
>   
> -	might_sleep();
> -	for (i = 0; i < nr_pages; i++) {
> +	/*
> +	 * When clearing we want to operate on the largest extent possible since
> +	 * that allows for extent based architecture specific optimizations.
> +	 *
> +	 * However, since the clearing interfaces (clear_user_highpages(),
> +	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
> +	 * limit the batch size when running under non-preemptible scheduling
> +	 * models.
> +	 */
> +	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> +
> +	for (i = 0; i < npages; i += count) {
>   		cond_resched();
> -		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
> +
> +		count = min(unit, npages - i);
> +		clear_user_highpages(page + i,
> +				     addr + i * PAGE_SIZE, count);

I guess that logic could be pushed down for the 
clear_user_highpages()->clear_pages() implementation (arch or generic) 
to take care of that, so not every user would have to care about that.

No strong opinion as we could do that later whenever we actually get 
more clear_pages() users :)

> -
>   /**
>    * folio_zero_user - Zero a folio which will be mapped to userspace.
>    * @folio: The folio to zero.
> - * @addr_hint: The address will be accessed or the base address if uncelar.
> + * @addr_hint: The address accessed by the user or the base address.
> + *
> + * Uses architectural support to clear page ranges.

I think that comment can be dropped. Implementation detail :)

-- 
Cheers

David

