Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F87D0D176
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644896B0005; Wed,  7 Jan 2026 17:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2276B0092; Wed,  7 Jan 2026 17:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F7F6B0093; Wed,  7 Jan 2026 17:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDF76B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:17:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A856859259
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:16:59 +0000 (UTC)
X-FDA: 84306578958.27.AE885C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CDD5BC0007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:16:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkzMPvSz;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767824218; a=rsa-sha256;
	cv=none;
	b=xfXy6CD0tr0PGDFiZCeHmeMuOpLMhP5hLJ1anQxKY0bg950a6NerXFCrCX5TcJDLjalcz9
	SR6QXZFh5DNYc1BbZvi3Ylc6v38r34yRGMBDT+3AnApRiafUO3DFNfeOSRiWRy7nq7dakZ
	TbCV5QhaiY1jcJrpVa53EJ8pCWraec4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkzMPvSz;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767824218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zc6SMegcUqlqouL9yfIWzfApimF1fq83Y+Z8I9wk+mw=;
	b=HB/l3pNTD7q8UHqfj/YcUvzI+X8venbqHQ6LU7l1u9z4cE+IfhbAIPoMuPDTxb03bd8u63
	tf/2acMGyV+Y8IlTbrbtKYampx90XnY5roaToLq9i+rKdW8f57u/g4BEOOyar2lPkg2++z
	k9mhTR/yqavUf+TeTWrj6Swic0J48No=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E6543C1C;
	Wed,  7 Jan 2026 22:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17996C4CEF1;
	Wed,  7 Jan 2026 22:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767824216;
	bh=aRZqO9YxbWBq3dSTiP1Cb9sPo6v9IC3AM60mgYdXrOM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HkzMPvSzHFr8t7h1fCruD/W2o1YDw1Mk5RU1dG+nTOu93f+FhP1kb6pcVZwRdWIiV
	 e6O73Vrplb2SlZE9X41uSyqJk4LZmNBl49h872wTlrRy671sRaFuKblbJK0KcI8NO4
	 wo5LrgXE/mrVcey/HjnVAggJxlD8eJfHILaiSv0fvDUozE68vT8Od97eLZTNqFfu03
	 6ouXfvsb5R2z1bqRj1sTLHVJcah4PRgrO5hmLn75YHgyXg3HUWiSLkxXC1KntEXqxk
	 tPfccslItSGeOjBjvfzbFgVZ1CWWrgJZxlz4AcEu7lSMLb8zHdfqpYxNSgz5AmvjqI
	 pU95Si+Rl1X1A==
Message-ID: <409dc029-ad8a-4f7e-931e-8044b61a0295@kernel.org>
Date: Wed, 7 Jan 2026 23:16:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 7/8] mm: folio_zero_user: clear page ranges
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-8-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDD5BC0007
X-Rspam-User: 
X-Stat-Signature: 3qq44qtj5kr56kszbs3o8z4ubr67i9do
X-Rspamd-Server: rspam07
X-HE-Tag: 1767824217-117415
X-HE-Meta: U2FsdGVkX1/J6mnwCchbUEs30vAfQq8v2+r38M8JPrPyt3GIZonuG97bBUJ7yS6H8jAWQNAnVNt86o0FwjCL6g+XHcqUbO1Hj8PWq4SG2BblxFP6+NTf2TfN+QMNjif31u/DAtVa2sjlGLuizJcClxiibI9le8V3eLz94nhlg0AXZohhncxU6pepNh2sMmb6GL48iUPbQG/iXBWcEP6iRYho2Y6saRQe536IipCYHiM5snU9Xw5dbkHPaqE5TNt0xjiS+CIsYMJ2LBC9aTWMroUNvD5mBIusS14NBr8a4uHub8HqnCu6H7k6CnCBKQDtC46rlrvoy7hKJvHnf3SAG2OUjKcmG1LQrxjR1Wyzt7b6hfJblZTkk6QjvrOgIUdcaGf4oOgWewUALFWJm7sssd9sJn9i9PYWEjhdnjew3nW89Uixvtt2oajKUUOb/+Qr62OmYqf1lDGqf8gry1gs1lOEbTAohzlur4/3mjLZt2UwZv0kAL49c/F5T3CEZRHDGA5EO3ZLKGgy6XeKaBAbIX89SYkGXPqDVneGj9O7te7NpLtt8XhzDxU353y13GufzqHQQuXMkUDtbu7ZF9K9iUuNCBrMkzXYJmIRwVHvIeRbf3XqTFtn2R4CBBlsuvY9GlH6gegwL0vH2yBS48PmqaS1V6Lg9J++2CXrBvEUQ6jbQOOqdHeRYUaPAT+cKClwBkUJZPlqeOvgTmf58R9YnSWbgbC66Y9eADlfPA9P0DVLgwBjuIBNbQbDQl52+domn5ysF82XliOSM6wuEG1skje+xXWo0lkwLtSs9+VyKmKKhe3MnDpGL5egMuon10zrleflGlswO2aNH2UU2G3GeDQ8mN01LWw+goQNrSnV+Y57wL5+qNVKeRSewjM1PZQ88JglZZyio2GGujbPabQsmVe4F0sb/IPLObuguE9QTiwAY3cQsLLIdqPhLmNXFBJMOERQwGirv8laeD0mQEs
 qAQTHTeb
 /uUH38Ch82bXO1CmXBBzzIJrlnmWLltN3wMQ863IOE0T+uaC/57zjtgfHU2gMuVTwR+KVJrIqoMb/5+gGzBg4OpPup+bD2Vw4rqr7yxvw6eDmTDPWUKrc1DAKs7YtsncTzDnJRh3yC+V5pX8R1lpIzr4Ret5p40jl1ak8257KQH8g+SMwvtQMp3J3MnDX0rLLQjgoTt+NdoL1zXt8846S6UX9WsoUcOjEiLJ4YOWWYFAR5Rl1OVzC4aA0uNTqDkXwSUqn/Rb2UE6ye0v0AypGGX7KGuTARI25yQ8AAFwX8NG1LTMy12WqPZx4LOcyBNHLxXtYg1bGIjcPn4pI3Q53+zkmCu4HHbtDYV2Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 08:20, Ankur Arora wrote:
> Use batch clearing in clear_contig_highpages() instead of clearing a
> single page at a time. Exposing larger ranges enables the processor to
> optimize based on extent.
> 
> To do this we just switch to using clear_user_highpages() which would
> in turn use clear_user_pages() or clear_pages().
> 
> Batched clearing, when running under non-preemptible models, however,
> has latency considerations. In particular, we need periodic invocations
> of cond_resched() to keep to reasonable preemption latencies.
> This is a problem because the clearing primitives do not, or might not
> be able to, call cond_resched() to check if preemption is needed.
> 
> So, limit the worst case preemption latency by doing the clearing in
> units of no more than PROCESS_PAGES_NON_PREEMPT_BATCH pages.
> (Preemptible models already define away most of cond_resched(), so the
> batch size is ignored when running under those.)
> 
> PROCESS_PAGES_NON_PREEMPT_BATCH: for architectures with "fast"
> clear-pages (ones that define clear_pages()), we define it as 32MB
> worth of pages. This is meant to be large enough to allow the processor
> to optimize the operation and yet small enough that we see reasonable
> preemption latency for when this optimization is not possible
> (ex. slow microarchitectures, memory bandwidth saturation.)
> 
> This specific value also allows for a cacheline allocation elision
> optimization (which might help unrelated applications by not evicting
> potentially useful cache lines) that kicks in recent generations of
> AMD Zen processors at around LLC-size (32MB is a typical size).
> 
> At the same time 32MB is small enough that even with poor clearing
> bandwidth (say ~10GBps), time to clear 32MB should be well below the
> scheduler's default warning threshold (sysctl_resched_latency_warn_ms=100).
> 
> "Slow" architectures (don't have clear_pages()) will continue to use
> the base value (single page).
> 
> Performance
> ==
> 
> Testing a demand fault workload shows a decent improvement in bandwidth
> with pg-sz=1GB. Bandwidth with pg-sz=2MB stays flat.
> 
>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
> 
>                     contiguous-pages       batched-pages
>                     (GBps +- %stdev)      (GBps +- %stdev)
> 
>     pg-sz=2MB       23.58 +- 1.95%        25.34 +- 1.18%       +  7.50%  preempt=*
> 
>     pg-sz=1GB       25.09 +- 0.79%        39.22 +- 2.32%       + 56.31%  preempt=none|voluntary
>     pg-sz=1GB       25.71 +- 0.03%        52.73 +- 0.20% [#]   +110.16%  preempt=full|lazy
> 
>   [#] We perform much better with preempt=full|lazy because, not
>    needing explicit invocations of cond_resched() we can clear the
>    full extent (pg-sz=1GB) as a single unit which the processor
>    can optimize for.
> 
>   (Unless otherwise noted, all numbers are on AMD Genoa (EPYC 9J13);
>    region-size=64GB, local node; 2.56 GHz, boost=0.)
> 
> Analysis
> ==
> 
> pg-sz=1GB: the improvement we see falls in two buckets depending on
> the batch size in use.
> 
> For batch-size=32MB the number of cachelines allocated (L1-dcache-loads)
> -- which stay relatively flat for smaller batches, start to drop off
> because cacheline allocation elision kicks in. And as can be seen below,
> at batch-size=1GB, we stop allocating cachelines almost entirely.
> (Not visible here but from testing with intermediate sizes, the
> allocation change kicks in only at batch-size=32MB and ramps up from
> there.)
> 
>   contigous-pages       6,949,417,798      L1-dcache-loads                  #  883.599 M/sec                       ( +-  0.01% )  (35.75%)
>                         3,226,709,573      L1-dcache-load-misses            #   46.43% of all L1-dcache accesses   ( +-  0.05% )  (35.75%)
> 
>      batched,32MB       2,290,365,772      L1-dcache-loads                  #  471.171 M/sec                       ( +-  0.36% )  (35.72%)
>                         1,144,426,272      L1-dcache-load-misses            #   49.97% of all L1-dcache accesses   ( +-  0.58% )  (35.70%)
> 
>      batched,1GB           63,914,157      L1-dcache-loads                  #   17.464 M/sec                       ( +-  8.08% )  (35.73%)
>                            22,074,367      L1-dcache-load-misses            #   34.54% of all L1-dcache accesses   ( +- 16.70% )  (35.70%)
> 
> The dropoff is also visible in L2 prefetch hits (miss numbers are
> on similar lines):
> 
>   contiguous-pages      3,464,861,312      l2_pf_hit_l2.all                 #  437.722 M/sec                       ( +-  0.74% )  (15.69%)
> 
>     batched,32MB          883,750,087      l2_pf_hit_l2.all                 #  181.223 M/sec                       ( +-  1.18% )  (15.71%)
> 
>      batched,1GB            8,967,943      l2_pf_hit_l2.all                 #    2.450 M/sec                       ( +- 17.92% )  (15.77%)
> 
> This largely decouples the frontend from the backend since the clearing
> operation does not need to wait on loads from memory (we still need
> cacheline ownership but that's a shorter path). This is most visible
> if we rerun the test above with (boost=1, 3.66 GHz).
> 
>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
> 
>                     contiguous-pages       batched-pages
>                     (GBps +- %stdev)      (GBps +- %stdev)
> 
>     pg-sz=2MB       26.08 +- 1.72%        26.13 +- 0.92%           -     preempt=*
> 
>     pg-sz=1GB       26.99 +- 0.62%        48.85 +- 2.19%       + 80.99%  preempt=none|voluntary
>     pg-sz=1GB       27.69 +- 0.18%        75.18 +- 0.25%       +171.50%  preempt=full|lazy
> 
> Comparing the batched-pages numbers from the boost=0 ones and these: for
> a clock-speed gain of 42% we gain 24.5% for batch-size=32MB and 42.5%
> for batch-size=1GB.
> In comparison the baseline contiguous-pages case and both the
> pg-sz=2MB ones are largely backend bound so gain no more than ~10%.
> 
> Other platforms tested, Intel Icelakex (Oracle X9) and ARM64 Neoverse-N1
> (Ampere Altra) both show an improvement of ~35% for pg-sz=2MB|1GB.
> The first goes from around 8GBps to 11GBps and the second from 32GBps
> to 44 GBPs.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/mm.h | 36 ++++++++++++++++++++++++++++++++++++
>   mm/memory.c        | 18 +++++++++++++++---
>   2 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a4a9a8d1ffec..fb5b86d78093 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4204,6 +4204,15 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>    * mapped to user space.
>    *
>    * Does absolutely no exception handling.
> + *
> + * Note that even though the clearing operation is preemptible, clear_pages()
> + * does not (and on architectures where it reduces to a few long-running
> + * instructions, might not be able to) call cond_resched() to check if
> + * rescheduling is required.
> + *
> + * When running under preemptible models this is not a problem. Under
> + * cooperatively scheduled models, however, the caller is expected to
> + * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
>    */
>   static inline void clear_pages(void *addr, unsigned int npages)
>   {
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
> + * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
> + * result in worst case preemption latency of around 3ms when clearing pages.
> + *
> + * (See comment above clear_pages() for why preemption latency is a concern
> + * here.)
> + */
> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))

Nit: Could we use SZ_32G here?

	SZ_32G >> PAGE_SHIFT;

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
> index c06e43a8861a..49e7154121f5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7240,13 +7240,25 @@ static inline int process_huge_page(
>   static void clear_contig_highpages(struct page *page, unsigned long addr,
>   				   unsigned int nr_pages)
>   {
> -	unsigned int i;
> +	unsigned int i, unit, count;
>   
>   	might_sleep();
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
> +	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> +

Nit: you could do above:

const unsigned int unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;

> +	for (i = 0; i < nr_pages; i += count) {
>   		cond_resched();
>   
> -		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
> +		count = min(unit, nr_pages - i);
> +		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
>   	}
>   }
>   

Feel free to send a fixup patch inline as reply to this mail for any of these that
Andrew can simply squash. No need to resend just because of that.


Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>


-- 
Cheers

David

