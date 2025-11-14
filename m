Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305F1CE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89CC68E000C; Fri, 14 Nov 2025 14:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874718E000A; Fri, 14 Nov 2025 14:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A7C8E000C; Fri, 14 Nov 2025 14:43:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 624BF8E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:43:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15419B98A7
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:43:54 +0000 (UTC)
X-FDA: 84110237988.08.45BB7A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5CF8140012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:43:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kl3XkPFc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763149432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WE7OlafaKyP96402VgeY55yzAoTAjvVTtmvCVmIIt4U=;
	b=OXzIBGeMyoOZB+5J8l+J78pOEttq+zFYtK26T9q2mV1Ruh8fh5Cq7Nt6eIPUrGr+k4Y9CX
	0moR6H8HYh0xWkNQ5Z/EVfuDLCh89vyZIjpx9Ko+X+PrZB/q/SARO4R0UWV2LMetSmuFFX
	U9wDlRIxgNDZwWGIsvJS+F0voYfn5c8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763149432; a=rsa-sha256;
	cv=none;
	b=LHx+1aoZQ3UwsLH2sXHJb+zoE8HLleWKhLPMAhsK+bxFt3mWZCoY4kiQBEd7hiRda8cVVU
	d47zmjTIu9moGSo2s2ZjWd5lKq7J2c7f63dYLItkLR0DGJAcT0DLOtP5NHdLb6WwSwgezD
	WtBuD/XwYYWq+3WQRwxUaBu6E3zdTuI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kl3XkPFc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1B9D60192;
	Fri, 14 Nov 2025 19:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E7BC4AF09;
	Fri, 14 Nov 2025 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763149431;
	bh=5T9R+DZ0cAE97xt1xNOrZCDnV4pc9v2U3yy+1/Gkztg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kl3XkPFcbdBd10maRIJsdzkZj9uqLKeoMdgjb9QvwLiqK1GHQ1WyX8ptgPfUApqlB
	 R89cQ3goj7w10u6RbmRNqHz80ZdiC3QMdR7ZKSikW4Y2FCMxYwXSwFy7rztSUSf5wm
	 9wFb0/zwsCrwoMkBi8vu0VCDCTuNDUbwgJjcKT5iwmD6gq0DcNH+ZBWmYd1L60vCuf
	 VwbnDczWUfVWCmBnHL19/wu6T5v/eeABlCsMiQxUHFey05wANwZpdHjdgTVCrdfUg2
	 3leNoyRrmD8QPFO0W1bQbG+iOJyAdW5Q51EWaKlWfnH2lBASCKIKWwBle5PjtIk+it
	 eQkz48MRpFi+g==
Message-ID: <9c86c4ad-2659-4091-9f2a-d166c5e8daa3@kernel.org>
Date: Fri, 14 Nov 2025 20:43:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Donet Tom
 <donettom@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nathan Chancellor <nathan@kernel.org>
References: <20251112145632.508687-1-david@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112145632.508687-1-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5tm3btbz4rwgxj4batoqmze8q9qmkegy
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CF8140012
X-Rspamd-Server: rspam01
X-HE-Tag: 1763149432-686180
X-HE-Meta: U2FsdGVkX19zO2ik5dkv9D9vd31/RkJLb7vxMZyq1Qo7Jf+m7VFRWcrxE/VpxO7Jpjt5V+6qKEx1t4iSZltUpQVktwc1PPFwy/Ani4oiBzMh2VHvzwQjZG456JO+Pz0n0qNshkjQ9X4ULc7VCyEgQHFT7qT9c0Kcv2okVopUNwILbPbqRDFORerpcGX8BpJuplkM9sF3QVkSp9VhUyoJzp1y0cK/Wcw8V/xSDbIj170HZPCX3LGiLck9IQsnVrO00hc9YXIPEmts/SGdgngYauO+bsQDbbv0xwVedT+FVAjATpciUdrTxbgmXfShVa/1ZDaxeCYMzEeMf/Ou+5enpwXv3HDhFm3u3MxB4+pH+wW8qScdJgEs6Llg6G6QRmsM3fulFnmmdNYQexKo2Ky0dE0ij3w4ZSOdt4H9JMeYfjgOD8NlXG3HfS4itLNJi64k0SvwUIVUV+/yZUPpIyIMwtuCqObpNg8riF+dMKtjKI27SONDBnEajRlpxo36Idu8VSkzWjajwdzWr6ROt3miS+XKqdFAlZTmD4qeg+PZoQEfN0Rf5gIBB8Zgcv36PYls+Ay1HB4fL5j+xkpj0kCadw4o9RcptgicuTv0wCmb6qJNl2950clQACkmPWRMUN4lClWHFm3zLtueBDNS97X5IavdrCUVeonMjCSbFCPoOvJt5aLoFI/w3xJuxYsGaC6SZJBcalgmM05g+i/wVTmPNVvbp8wObha55Rrsmj69HuVrJirVvZgJUFJpa0NmSEzcaeNlq2hnG9ynGX9PMKasu4MBITMVn1p33hA4TIRgm327ZxYCClw0cUxNiicikgHR+n1zuYgLcFMtxaNDPZ3cNGffl/PTrHq95pdIlmNnwyn8eSvJOIy9TcJ0ccLC6ZlfKy/xWpDx2/U1MdI5HVezU5GcwD4fIcmsQ5aD11bmLz7vQus2Uelm14B8tPd6sLNps3gv6KnN6sAZuHN10Da
 6oZ/ecVm
 ccHtZCpzdIKKTzU7ZhOq3mtUxykEShf2lzbpnhNuoGIcbuUpO+WKSEhIyGrAQhxc42XKeB+9n/C6oGpHe8bAR5p/iEkrUkaRhCn7ICpO1NCrUIwcoYHKlq/CpYVk7a1nMm9kTRqqcDdeXmtGlrebb9zWKdL3dxno24lDK8ersUxAUgsJo/vRWuSVbCzW9CO/GXJxqYa32+A1+yubiGkd0AvEiB6FfVngKgU1cgkPF1E8xMpPXy3pWE/pvYW4LxVj9Af8o+z8s5eeSuTX/So9ZYdO/Gyyrlfh/mKJEbLHBf6DR0c2svn25XdV6JKd+Fx+EhR1GZEYvpaVPbH7ClMoMHcTZvcZ8GB4piZYC7SQHUnFQWU4yiP943909bwU5/i0vA3ZBOlaw66ctmYHFnZLqkXT14Lauv4CesN6DdHu2HQ0dZVDjNg6S6Fs3+x88AQ/3TTDOhknYd18Kko64U/4ClnNOMQW/FUYOBvyUzfL/wp8N8maABVePe741yGNl5HNOB/XE5KWbo8QsbAXhZGbV2LM+jC4QJv00i0r5goj3ub1K9dHA+AfRgkBapjNvF9yI9rGh9HV88TqWJdf3SoMoHUfc2EdaJ7z9vIxEh7Oaqw49NwWMz1zJfvbnvBEboQvUEF5f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 15:56, David Hildenbrand (Red Hat) wrote:
> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
> into a generic way for the architecture to state that it supports
> gigantic hugetlb folios.
> 
> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
> have folios larger than what the buddy can handle. In the context of
> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
> when dumping tail pages of folios. Before that commit, we assumed that
> we cannot have folios larger than the highest buddy order, which was
> obviously wrong.
> 
> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
> when registering hstate"), we used MAX_FOLIO_ORDER to detect
> inconsistencies, and in fact, we found some now.
> 
> Powerpc allows for configs that can allocate gigantic folio during boot
> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
> exceed PUD_ORDER.
> 
> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
> GiB (possible on arm64 and powerpc). Note that on some powerpc
> configurations, whether we actually have gigantic pages
> depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
> nothing really problematic about setting it unconditionally: we just try to
> keep the value small so we can better detect problems in __dump_folio()
> and inconsistencies around the expected largest folio in the system.
> 
> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
> and detect ourselves whether we really end up with gigantic folios. Let's
> defer bigger changes and fix the warnings first.
> 
> While at it, handle gigantic DAX folios more clearly: DAX can only
> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
> 
> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
> HUGETLB_PAGE.
> 
> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
> also allow for runtime allocations of folios in some more powerpc configs.
> I don't think this is a problem, but if it is we could handle it through
> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.
> 
> While __dump_page()/__dump_folio was also problematic (not handling dumping
> of tail pages of such gigantic folios correctly), it doesn't relevant
> critical enough to mark it as a fix.
> 
> Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>   arch/powerpc/Kconfig |  1 +
>   include/linux/mm.h   | 12 +++++++++---
>   mm/Kconfig           |  7 +++++++
>   3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index e24f4d88885ae..9537a61ebae02 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -137,6 +137,7 @@ config PPC
>   	select ARCH_HAS_DMA_OPS			if PPC64
>   	select ARCH_HAS_FORTIFY_SOURCE
>   	select ARCH_HAS_GCOV_PROFILE_ALL
> +	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
>   	select ARCH_HAS_KCOV
>   	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
>   	select ARCH_HAS_MEMBARRIER_CALLBACKS
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32b..63aea4b3fb5d9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>   	return folio_large_nr_pages(folio);
>   }
>   
> -#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
>   /*
>    * We don't expect any folios that exceed buddy sizes (and consequently
>    * memory sections).
> @@ -2087,10 +2087,16 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>    * pages are guaranteed to be contiguous.
>    */
>   #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> -#else
> +#elif defined(CONFIG_HUGETLB_PAGE)
>   /*
>    * There is no real limit on the folio size. We limit them to the maximum we
> - * currently expect (e.g., hugetlb, dax).
> + * currently expect: with hugetlb, we expect no folios larger than 16 GiB.
> + */
> +#define MAX_FOLIO_ORDER		get_order(SZ_16G)

Turns out that's a problem on 32bit builds, because it won't fit into unsigned long. Grml.

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 63aea4b3fb5d9..f595565bdd113 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2090,9 +2090,10 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
  #elif defined(CONFIG_HUGETLB_PAGE)
  /*
   * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect: with hugetlb, we expect no folios larger than 16 GiB.
+ * currently expect: with hugetlb, we expect no folios larger than 16 GiB
+ * on 64bit and 1 GiB on 32bit.
   */
-#define MAX_FOLIO_ORDER                get_order(SZ_16G)
+#define MAX_FOLIO_ORDER                get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
  #else
  /*

I'll resend the patch ...


-- 
Cheers

David

