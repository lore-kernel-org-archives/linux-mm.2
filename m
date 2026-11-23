Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8149F606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=an7Onk1C
Received: by kanga.kvack.org (Postfix)
	id 319386B05BB; Mon, 23 Nov 2026 11:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA096B05BC; Mon, 23 Nov 2026 11:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191CD6B05BD; Mon, 23 Nov 2026 11:24:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE1466B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:24:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 554488091F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:12 +0000 (UTC)
X-FDA: 85466905944.07.A2D6306
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 97F2520007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=an7Onk1C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451050;
	b=aykcYcGZ1sk/d3+drPzA8ZQO2SC4LulW4cbEQ2f2oeB3lCnJUy5rC4epV2bOYbBVWZCOCz
	Xa5RjAS+Hqx9MdZWFJWZODE/UwBIxr1TIrJntxsVKGAETtAGKwoL9o5CCI8yHZ1dtPjLSQ
	tVeQBviUFk26K8o18Bqs4OAdLtvxuHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hocg6r2Db135JYLEsNalRyOeUZY+BqePEKepI9oMCMo=;
	b=IvnEivE5fcD3MAfzDt+6tErCQCz4lO3D9F4o3L9EnwKrtyWjd66n7fLqPAKEOpOqPmtQ+F
	+BjQcnzym4bzDpigQevQKPVekvLEg6zxWvkfs+lx4LnEO6rBt219279mcoGQ3Fl3ZCtrLn
	sYx6A5H8Pmd+ZX5NpfpmMRbItqJsqGo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=an7Onk1C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10D3D61F01;
	Mon, 23 Nov 2026 16:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E474F1F000D0;
	Mon, 23 Nov 2026 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451049;
	bh=Hocg6r2Db135JYLEsNalRyOeUZY+BqePEKepI9oMCMo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=an7Onk1Cc1CfpDsZVEB0wsZo8ksvn56rk6glWjghs4Mqhpzjh2ULjAGa7KlmnAydN
	 9RX/fmvdU3Q+TaqO5VoO1ggXJOglJCuDTV0GZER32mC8FZFbME2NELBQ5uD4wJP4Ca
	 BcNQF1IvWsPRbhEKf1BA7QMisPP4xZqtB/kOdUk8HxzVOipdBT7SKd3vMz2dLnEnI/
	 dRbhp7hgVvNFDyfsAi8NSPmMNNhQLcjUAD3nbTPsYtIKFfPAEjtV2r48RaV752gkDU
	 SiZLJyhYTshqoJqDhr/u8sYkiHTcm7U57vBuLtt4myexUN+p+NaxfjsdITdo6p+vOn
	 fWSQW2qFvmKOA==
Message-ID: <7639d5f0-3dfb-4446-ab04-51317f604a69@kernel.org>
Date: Mon, 23 Nov 2026 17:23:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Borislav Petkov <bp@alien8.de>,
 Ankur Arora <ankur.a.arora@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Bharata B Rao <bharata@amd.com>,
 Hrushikesh Salunke <hsalunke@amd.com>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>,
 David Laight <david.laight.linux@gmail.com>,
 David Rientjes <rientjes@google.com>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Teja Vojjala <tejavojjala@google.com>, Huan Nguyen <nhuhuan@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 97F2520007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: nshg156b3rj75prpqdiu8i6rcnbk9omr
X-HE-Tag: 1795451050-975858
X-HE-Meta: U2FsdGVkX18novSpk5QpJeRM14jCvLsltJUT7rmzpQrlcHIaLR6ZDvoDoRP4su9bxval5x7p+0ogGc5KOsxmHy58jzRhk3ApFgrSMhpX/RDdoB6KBi8mdeg267DxsqsiEXKWKDYL5kYGrQWz34DaJ3kEXeMVmp/+W4etojyQIGX0CE+5j81zhx1RFx+mexidvtbj1ZFKJd2h090GEMATmUHFekx2QM92wQ40P/Iqvtcqu1HbECEaVMsY4cHWBjxenB9MnORjy1cFYm4AOPpfLcRaH0psXVlnDlQAO+6sLppW+SrHXb9vJxSxpJ6zYfobnF8ARHgDS3cLiKIXvtG8cvIJqhzqZNqpvd+nF3iJmVPIo+tbkEoKy0zRmePCgSfwMiwloisnBVUWh3Bu8v9bh54AZGdm+X3XqGaO6Gq/nj2KJpuFNZkbsUShYP6pB947TrGPBUMQdpFXjlQ65BjyeLO65+OxJI1Sx4BXpZVpWmm6tw3ccFnxeKRThEaTY68NBS5yaOtdxtnJLXxG5dT1VwZAK802t+3aDLovtBnvmHMlPcKqkkZNcOcI1BiwcsYuUXnx1c0stKHPdWyyeADppP5riqwUvnE3w549+D3g9idGEdepPOO2qoG71ezR4K0weFloGSNJaIIRx2aO28FKre6ghqwv9zqqglBowDnuv2EcOvKjRAyLSSEnaCZSr6NBH4YGs+8w7WXyqo8aN+v/+nd8OJM4CuxL0mzfgHqTmaB8rC83yrG9VJb0PmUaABozQlFXLeqXMwDmrI0jfX/p8cZ44v9OFL5OQDt7iwH5cqVELllqlatSMgvTXyNMtSrsgRz5wi5e2iPltLQ7rjK8aQ1kIBJPMxyTM6dS8b/kKEanZkNEGXNG1MQ7AF0B+IMPEpsWKJJ/bJg+rxnNkeNUYAgp8aki5R7cB54jdNg7aAJcZYiMQRDpc0dfcNdux9OvG5gCrzU30YZNbprrXTl
 6mMGnmZM
 vqEV+8u7MfOBV+dCLhogH1gn/U4pe0XGmPw+HTTxv1tllcS0zEHrCq5ulhB4UaqJluAHKtIrNQMdov3N0vs3Wh4p83ucE4I06zSXNViGg8X+PbtXZQOaeA5t216uMBsLswXYf+8lS/UGM75/USf6gVF9MT3bc/7Kh+s0n+eu9ME0io7bJ1KoZzaDRYZM6P6OvWig1Ea2WMIHKjmWAp87fLdnuXv0xPUjyldYqV1HsSANmim8dvWJs2SUDNz54fpyvVZAuO6a+594WfAHQ8Z1dVFhlX8rI0edhdwnZbFhcLEFv19mm8MCyjZw3Zv4OTCK6grVizEiMJnQ4Qazdkl65r5XM0+vQbKhUQ2ztWsft/3YyZKQjxEo2PF242HjXs7FvH1txhDaDbDiTO+TkYEOsO7+gHqsYmbcOhvhzDbNVmlQBOwhtgU96V6h/zN+F82zhEKSTYkT2+NDyNyaeA2+RSxSiuuIRCxXAu1R5j/5qPtK64as9nQZj3yT1uY7C++Km+3m1aGlFavJGxtrcbDv3OvIYmwtkRfNSVL9PErpT5o4Mc38tlQ9y1Rpl0Pkh7erHuDWyF2lI3kFGgzCgEcxIwPpbwOuo6lYPcgjwvgVF38s/RXN64/mLfMK8XjiCxhKCNRTTLznZZanvxbCWUV/bxWuptdPAuxsaPqtarsXgFg+XUyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 18:09, Shivank Garg wrote:
> folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> so a 2MB folio makes 512 separate copy_mc_to_kernel() calls. Each page
> pays the startup cost of the string instruction ("REP; MOVSB" on x86
> CPUs with ERMS) plus a cond_resched().
> 
> Introduce copy_mc_highpages(), the page range variant of
> copy_mc_highpage(). When copy_mc_to_kernel() is available and the pages
> are in the linear map, copy the whole range with a single
> copy_mc_to_kernel() call, so the CPU can optimize for the larger extent.
> Otherwise, fall back to copy_mc_highpage() one page at a time.
> 
> On a machine check, queue the poisoned source page for memory_failure(),
> as copy_mc_highpage() does, and return -EHWPOISON, as folio_mc_copy()
> does today.
> 
> copy_mc_to_kernel() cannot reschedule, so only take the single-call path
> when CONFIG_PREEMPTION is set and the copy can be preempted. Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes"), x86 and
> powerpc, the only architectures that select ARCH_HAS_COPY_MC, only offer
> the full, lazy and RT preemption models, also with PREEMPT_DYNAMIC, so
> they always take this path. The per-page fallback calls cond_resched()
> before each page, as clear_contig_highpages() does. Other architectures
> keep copying one page at a time.
> 
> Switch folio_mc_copy() to copy the whole folio with copy_mc_highpages().
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for
> 2MB THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).
> When demoting to CXL, kswapd uses ~31% less CPU per GB demoted.
> 
> Changes in v3:
> - Copy the whole range with one copy_mc_to_kernel() call only when
>   CONFIG_PREEMPTION is set, otherwise copy page by page with
>   cond_resched(), following clear_contig_highpages() [1] (Pedro, David).
> - Handle the machine check first in copy_mc_highpages() (Pedro).
> - Rebase onto mm/core.git for-next.
> - Link to v2: https://lore.kernel.org/r/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com
> 
> [1] https://lore.kernel.org/r/20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com
> 
> Changes in v2:
> - Drop the folio_copy() changes as there is little to gain here.
>   On architectures without copy_mc_to_kernel(), copy_mc_highpages()
>   falls back to the per-page copy_mc_highpage(), which ends up in
>   copy_highpage(). A batched copy_highpages() could help there too,
>   but I haven't tested it on those architectures, so that is left for
>   a follow-up.
> - Add COPY_MC_PAGES_NON_PREEMPT_BATCH to limit how much is copied
>   between cond_resched() calls on non-preemptible kernels.
> - Rebase onto mm-new (2887e63d2e8e).
> - v1: https://lore.kernel.org/all/20260427142036.111940-2-shivankg@amd.com
> 
> Test setup: AMD EPYC Zen 6, single socket, NPS2 (nodes 0 and 1 are
> DRAM, node 2 is CXL), with and without this patch.
> 
> move_pages() throughput
> -----------------------
> A single move_pages() call migrates 1GB of anonymous memory, as 512
> 2MB THPs or as four 1GB hugetlb pages. Mean ± stddev (10 runs each),
> in GiB/s:
> 
> 2MB THP:
>   direction         base            patched         speedup
>   DRAM0 -> DRAM1    19.57 ± 0.17    27.51 ± 0.78    1.41x
>   DRAM1 -> DRAM0    19.44 ± 0.12    27.33 ± 0.27    1.41x
>   DRAM0 -> CXL      18.66 ± 0.18    26.90 ± 0.51    1.44x
>   CXL   -> DRAM0    15.38 ± 0.59    16.60 ± 0.24    1.08x
> 
> 1GB hugetlb:
>   direction         base            patched         speedup
>   DRAM0 -> DRAM1    20.34 ± 0.13    53.88 ± 1.48    2.65x
>   DRAM1 -> DRAM0    19.10 ± 2.65    53.78 ± 0.55    2.82x
>   DRAM0 -> CXL      19.53 ± 0.08    44.10 ± 0.19    2.26x
>   CXL   -> DRAM0    16.41 ± 0.07    20.89 ± 0.06    1.27x
> 
> kswapd demotion
> ---------------
> Node 0 is limited to 16GB of free memory and demotion is enabled. A
> single thread bound to node 0 writes 96GB of anonymous THP memory, so
> ~80GB has to be demoted to CXL. Median of 10 runs:
> 
>                                base        patched
>   kswapd CPU time              4.25 s      3.44 s     (-19%)
>   kswapd CPU per GB demoted    63.6 ms     44.1 ms    (-31%)
>   demoted by direct reclaim    14.1 GB     0.46 GB
>   allocstall                   7427        370
> 
> With the patch, kswapd keeps up with the writer, so the writer rarely
> falls back to direct reclaim.
> ---
>  include/linux/highmem.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/util.c               | 14 ++------------
>  2 files changed, 53 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a..a79e9d68359c 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -484,6 +484,57 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
>  }
>  #endif
>  
> +/**
> + * copy_mc_highpages() - copy a page range with machine check handling
> + * @to: first destination page
> + * @from: first source page
> + * @nr_pages: number of pages
> + *
> + * Range variant of copy_mc_highpage(). On a machine check, the poisoned
> + * source page is queued for memory_failure().
> + *
> + * Context: Process context. May sleep.
> + * Return: 0 on success, -EHWPOISON if a machine check was handled.
> + */
> +static inline int copy_mc_highpages(struct page *to, struct page *from,
> +		unsigned long nr_pages)
> +{
> +	unsigned long len = nr_pages << PAGE_SHIFT;
> +	unsigned long i, ret;
> +
> +	might_sleep();
> +
> +	/*
> +	 * When copying we want to operate on the largest extent possible to
> +	 * allow for architecture specific extent based optimizations.
> +	 *
> +	 * copy_mc_to_kernel() does not call cond_resched(). That is fine on
> +	 * preemptible kernels, where the scheduler can preempt the copy at
> +	 * any point, so copy the whole range at once if copy_mc_to_kernel() is
> +	 * available and the pages are in the linear map. Otherwise, copy one
> +	 * page at a time and reschedule in between.
> +	 */
> +	if (IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) && IS_ENABLED(CONFIG_PREEMPTION) &&
> +	    !IS_ENABLED(CONFIG_HIGHMEM)) {
> +		ret = copy_mc_to_kernel(page_address(to), page_address(from), len);
> +		if (ret) {
> +			memory_failure_queue(page_to_pfn(from) +
> +					     ((len - ret) >> PAGE_SHIFT), 0);
> +			return -EHWPOISON;
> +		}
> +		for (i = 0; i < nr_pages; i++)
> +			kmsan_copy_page_meta(to + i, from + i);
> +		return 0;
> +	}
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		cond_resched();
> +		if (copy_mc_highpage(to + i, from + i))
> +			return -EHWPOISON;
> +	}
> +	return 0;
> +}
> +
>  static inline void memcpy_page(struct page *dst_page, size_t dst_off,
>  			       struct page *src_page, size_t src_off,
>  			       size_t len)
> diff --git a/mm/util.c b/mm/util.c
> index c9c3dc4b490f..1277daa3ccd6 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -776,18 +776,8 @@ EXPORT_SYMBOL(folio_copy);
>  
>  int folio_mc_copy(struct folio *dst, struct folio *src)
>  {
> -	long nr = folio_nr_pages(src);
> -	long i = 0;
> -
> -	for (;;) {
> -		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
> -			return -EHWPOISON;
> -		if (++i == nr)
> -			break;
> -		cond_resched();
> -	}
> -
> -	return 0;
> +	return copy_mc_highpages(folio_page(dst, 0), folio_page(src, 0),
> +				 folio_nr_pages(src));
>  }

What bugs me a bit is that we are not tackling copy_user_large_folio(). So this
looks incomplete.

There, we still have this. That keeps this process_huge_page() machinery alive,
and a special case for gigantic pages (copy_user_gigantic_page).

Meanwhile, folio_zero_user() moved to a range-based approach and abandoned that.

Can we clean all that up as well while we are at it?

These look like excellent candidats for using copy_mc_user_highpages() as well.

-- 
Cheers,

David

