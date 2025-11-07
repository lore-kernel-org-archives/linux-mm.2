Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20745CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 08:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78CB58E0009; Fri,  7 Nov 2025 03:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765068E0002; Fri,  7 Nov 2025 03:59:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0A58E0009; Fri,  7 Nov 2025 03:59:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58F518E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:59:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 014401A03D8
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:59:12 +0000 (UTC)
X-FDA: 84083211786.14.5C89916
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51F541C0008
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:59:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KZnpX6ml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762505951; a=rsa-sha256;
	cv=none;
	b=0xBQ/wr4l16D/Xr5+2Ckja7JaTYd0vsyrRtqmole0/oW69XrYibM0/my48bfTi3aQhmslz
	X8JA2NV24axrnnIXaIF9R82mUhoeDN3PAYcEezeksaczQy37cbZztjCtetBFh96zA4mKc9
	rr5wRGi4U0uyaNXCTTOtYwro3Jjnv48=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KZnpX6ml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762505951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfIQNcmmjzVzF5pn+YEpsb4Wg0IgIl9gKH3sYHaJ64g=;
	b=sD9Nr8aYbudsmgeywJclpCtRAQNlZGbzonlnhjqqGdtFGukHqHCPfT7rKVIy+tR0OKlqOM
	yWIsTFmbCuc81+Pqt5hVO8K+eXdvzEboD3wo/SAjmv3BUHFfXXUZwNVUhHKR4hbikh+Kso
	tsgVXEOeXR2b1MfopQnPmFm1trJJItY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 985CF618FA;
	Fri,  7 Nov 2025 08:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0809CC116B1;
	Fri,  7 Nov 2025 08:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762505950;
	bh=FGs9k1s29rarNJs9NqYrMfUHU4lrNN1E8lsc4dNVyTo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KZnpX6ml6uRRB2JFyzIFBDCgIXhESmUP/cxrsm49i/lOlJ+Dmr7s61hw/h6N29KPe
	 lMw4g1mRCChOX+R7kmsd8VEpF7Xpuqmpiylml1zoJtrjPAMQJGAyt1/5lJ43p1+LrA
	 x9lGupxQ25fO4M6xU6hEKchg2YzbKMbqlgMzcTsV6/QDYkAwH47Qx4+1A/kK2JPC5m
	 43KPjUkR3sCN8c2sVaQ38P5t0sq42rzYDjo71UUeq4UtHeEenI/Xi/iXHK3fdaptMZ
	 2s0eaGEtUmzmo96Lll4REI1O/zG0vAueoBa+Nxnop+c6QyGdcgc49z5zXKnEAv6Y0g
	 3b2+qmUpdw5+A==
Message-ID: <77b2ae9c-2700-4c7a-ae45-323af6beaff3@kernel.org>
Date: Fri, 7 Nov 2025 09:59:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/7] mm, folio_zero_user: support clearing page ranges
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-7-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251027202109.678022-7-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51F541C0008
X-Stat-Signature: zm1n5sqt8h5s4rknnb474wf3dm4jb16g
X-HE-Tag: 1762505951-695547
X-HE-Meta: U2FsdGVkX19BwGkiePrTEvKsn7wQXYKwk02ty1t18G+tspoPpdxZSIKkr9u5ZnMMjVdFIQuIsQbtFEqXDhuoJ3DlJ624kuzNbFfd2LmTXe1XITwZi0qHZltl5fZpx3IMGVwR/KOK0FYEmyp+F8G+QGe56CDSzdNWOkkLK0ZZGKL1mWeMEasR0nf0KUynTFNOUvhTJKKtOTV1hdjY6JGRiGwqP6ub+PfAbb6SjVHOc16EGw/cB2djMHigrOKSRXke91Stic1Yxyx0ngWZPCN8Ni+WJ4RnTwvtqM1d2sTNN/du8Jgox3ucuucSIFupzADK2xS1YY60M/ASrNNotnjPZLb1MjymFZjZeFrihyVtBMrR89ceapFNRKqs12rsbqr4wqfRufdjaLna75sXT4ESO6O7vlv0EmR4r5DVRmKaGKv0PxooJMsiM0nvtsJMN403N+CxRbhJB5DUDeBrWx2WHPRAASoqx50RLNblKiY+H5fBcJO8vyIqzwI/MqbxuSLa/e3e/+UqLtVJ21z2NyABNIyMEj75/gj0m7mgLl6oBjaIgtEiA3espD3n7xh9fNhTIERFckFwC1K8I5Z7+ocars1is8jsARiquAMV7RuhR9B7s275H/PjYNdbCBWPji7FfiRazW3i1G8tUmOVi2ge4OjP9KX1+xl8aDSG66ekR4fr/Af5zPbruBqYWHV1N2ivU4b//nLJMZ/vzseU21Bhgg4Et5CCtgQn5LN9eY73tLfBWLvyb4rMli1nNefwkI5BpFFYZWhfUzwV9etGywMy6GWZD2QLglQbyqfwH54VFRsN5wrxJ3RS+SPboGpRzlBW9eP6PLzjRkaz0eNTOonJeMRXUTbajdcjezBiQWmQVE97HXO6AsS+DO69OvVDIJmyXbIxPFV8uS6K88tzxJavbTuPtS1KX1ISWHGhjnDy9V8BCXmn6qZL48QUdOjJuVsZDoQJPQ6Mu8ybkSkGFc/
 hOxf59Jk
 u0nH9WOOqzxs1uGS2J9S94qMJKQ5c1ZOWPtzn4zb/CtydA+gToXxoy80oe8+WvBoycK6s2xvrJgXbqR7KozveGbSebmHgiDRuyQ30/lLr5S2xHkGBFCB3XyUp4ONzj0pga1bop2Dy4N5LbJiEGuycsXaU2nEFY/dcI+Zbl2qMYDZ5UYG1wM4ulJgjWx/9vuncUexVuqRNtCC22eaxlyEKkx9YVo9Mx5QvOHAZnuBd8ld4T6AH0PTq1uxzOK9/5y1D+55t8Z2Aot/jV9KlAeyf9+5FjbCslSpkXS82WfisNDFUxJc5C2760X9uQYx/rxjjNgTtVKF9aVeVTR0misENfhG0qK/fbYmnjFvu1EMpXtTiSvis1h2dmw48Rw1nLa+jXc+P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 21:21, Ankur Arora wrote:
> Clear contiguous page ranges in folio_zero_user() instead of clearing
> a page-at-a-time. This enables CPU specific optimizations based on
> the length of the region.
> 
> Operating on arbitrarily large regions can lead to high preemption
> latency under cooperative preemption models. So, limit the worst
> case preemption latency via architecture specified PAGE_CONTIG_NR
> units.
> 
> The resultant performance depends on the kinds of optimizations
> available to the CPU for the region being cleared. Two classes of
> of optimizations:
> 
>    - clearing iteration costs can be amortized over a range larger
>      than a single page.
>    - cacheline allocation elision (seen on AMD Zen models).
> 
> Testing a demand fault workload shows an improved baseline from the
> first optimization and a larger improvement when the region being
> cleared is large enough for the second optimization.
> 
> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):
> 
>   $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
> 
>                      page-at-a-time     contiguous clearing      change
> 
>                    (GB/s  +- %stdev)     (GB/s  +- %stdev)
> 
>     pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*
> 
>     pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%	preempt=none|voluntary
>     pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy
> 
> [#] AMD Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
> allocation, which is larger than ARCH_PAGE_CONTIG_NR, so
> preempt=none|voluntary see no improvement on the pg-sz=1GB.
> 
> Also as mentioned earlier, the baseline improvement is not specific to
> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
> improvement as the Milan pg-sz=2MB workload above (~30%).
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>   include/linux/mm.h |  6 ++++++
>   mm/memory.c        | 42 +++++++++++++++++++++---------------------
>   2 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ecbcb76df9de..02db84667f97 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3872,6 +3872,12 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> +#ifndef ARCH_PAGE_CONTIG_NR
> +#define PAGE_CONTIG_NR	1
> +#else
> +#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
> +#endif

The name is a bit misleading. We need something that tells us that this 
is for patch-processing (clearing? maybe alter copying?) contig pages. 
Likely spelling out that this is for the non-preemptible case only.

I assume we can drop the "CONTIG", just like clear_pages() doesn't 
contain it etc.

CLEAR_PAGES_NON_PREEMPT_BATCH

PROCESS_PAGES_NON_PREEMPT_BATCH

Can you remind me again why this is arch specific, and why the default 
is 1 instead of, say 2,4,8 ... ?

> +
>   #ifndef __HAVE_ARCH_CLEAR_PAGES
>   /**
>    * clear_pages() - clear a page range for kernel-internal use.
> diff --git a/mm/memory.c b/mm/memory.c
> index 74b45e258323..7781b2aa18a8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7144,40 +7144,40 @@ static inline int process_huge_page(
>   	return 0;
>   }
>   
> -static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
> -				unsigned int nr_pages)
> +/*
> + * Clear contiguous pages chunking them up when running under
> + * non-preemptible models.
> + */
> +static void clear_contig_highpages(struct page *page, unsigned long addr,
> +				   unsigned int npages)
>   {
> -	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
> -	int i;
> +	unsigned int i, count, unit;
>   
> -	might_sleep();
> -	for (i = 0; i < nr_pages; i++) {
> +	unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
> +
> +	for (i = 0; i < npages; ) {
> +		count = min(unit, npages - i);
> +		clear_user_highpages(page + i,
> +				     addr + i * PAGE_SIZE, count);
> +		i += count;

Why not

for (i = 0; i < nr_pages; i += count) {

Also, I would leave the cond_resched(); where it was (before the 
invocation) to perform as little change as possible.

>   		cond_resched();
> -		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
>   	}
>   }
>   
> -static int clear_subpage(unsigned long addr, int idx, void *arg)
> -{
> -	struct folio *folio = arg;
> -
> -	clear_user_highpage(folio_page(folio, idx), addr);
> -	return 0;
> -}
> -
>   /**
>    * folio_zero_user - Zero a folio which will be mapped to userspace.
>    * @folio: The folio to zero.
> - * @addr_hint: The address will be accessed or the base address if uncelar.
> + * @addr_hint: The address accessed by the user or the base address.
> + *
> + * Uses architectural support for clear_pages() to zero page extents
> + * instead of clearing page-at-a-time.
>    */
>   void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>   {
> -	unsigned int nr_pages = folio_nr_pages(folio);
> +	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>   
> -	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
> -		clear_gigantic_page(folio, addr_hint, nr_pages);
> -	else
> -		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
> +	clear_contig_highpages(folio_page(folio, 0),
> +				base_addr, folio_nr_pages(folio));
>   }
>   
>   static int copy_user_gigantic_page(struct folio *dst, struct folio *src,


-- 
Cheers

David

