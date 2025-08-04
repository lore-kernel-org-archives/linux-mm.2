Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04CCC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 10:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F836B007B; Mon,  4 Aug 2025 06:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350D66B0088; Mon,  4 Aug 2025 06:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2662C6B0089; Mon,  4 Aug 2025 06:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1730B6B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:41:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9BDA161329
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:41:28 +0000 (UTC)
X-FDA: 83738733456.04.3F22F2C
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5B8140005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:41:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=EwLd8BBB;
	spf=pass (imf17.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754304087; a=rsa-sha256;
	cv=none;
	b=7FKsmx6rnc28z0GJyZ0i9x4fQHpwKsR8KBNfP+uZdYhHvs1Li3zC1rkgXx2qUkUwebUZb0
	JQWHobcozBYgJJIW1V719ymy/jDWNribYU4SpGml8Q6CLJbFOaPnojvSy5c7LK+M+CUIzn
	KRG8AYgYUc9EH72DvLiG+GkQuhFGxes=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=EwLd8BBB;
	spf=pass (imf17.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754304087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9pCjdnFkpARgLiLLxUhk5Y4uqhi7xM89tzgN6X+mCo=;
	b=FgcfCszKWDE/tpEiK7467f+V3lq60MxeC0oRekhYB6DboKDaFAwmQwkMS2BJqhzSmWIyhR
	zqP7Hg5DMBvaY/JlKiA2jj39fGWsCysEG1xBKNc7VLo2HJh9qkdM+iYtOoFYk4UPtzjVN4
	Xir61cHXp7s/Pmefy5Mx3UJ+aEfV9V8=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4bwY4y1NrSz9slM;
	Mon,  4 Aug 2025 12:41:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754304082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9pCjdnFkpARgLiLLxUhk5Y4uqhi7xM89tzgN6X+mCo=;
	b=EwLd8BBBf0Mcwjbxl4UWRmEjeI+PvXFRnOlyAcdlvs7ZCSaD7oa1wWbNkFGMhtgTz/F+yf
	YpWez/5yZ1rV3coIzohJFS5TW0q8NXb9iaiPQCu51aXspnhpo78qvalqTWdhW/nwEsxiul
	nXfgTNrWEQnQyjYHumRXXvtS2Dwpg+EuDY2oCBPKp1UdbGRRCac/+0af7G/DWfxzLehhBk
	bfYFdCQQzYHn9nyS2qXS6Q+srDRc56wjDKnOkTNKHgCjG5Seb/Qsup2XO0DT3n5G3cOjva
	7gjkSnm8jRflzyIEzuQGdBNK3YyOAOORSmcQLJKb70d8AY9tRZlofWRqEhSSOg==
Date: Mon, 4 Aug 2025 12:41:09 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	willy@infradead.org, linux-mm@kvack.org, x86@kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, 
	gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 2/4] mm: add static huge zero folio
Message-ID: <cjlxwzcx57oss5rpmbufywbnz7pha5vueu3vnythp4rvn6bcf2@m7yhkifpqsio>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
 <20250724145001.487878-3-kernel@pankajraghav.com>
 <d8899e72-5735-4779-9222-5f27f8c16b80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8899e72-5735-4779-9222-5f27f8c16b80@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5B8140005
X-Stat-Signature: urz7ibwfnfwhcxuomy91apjfrnq8ayjs
X-HE-Tag: 1754304086-693223
X-HE-Meta: U2FsdGVkX19zl0uWAWnA3LH1QhmFd/wCOWYMwUCdwWavr/A3+xXN4lfn4RJ/NUcFMGHt0kS9w8OGBN4dxT7FcQqjXNF7aSNqinhhAPRjREu4i3qxsP1YpCn3WiFLqXiQ4o+R6MclaOJjsXb6p/+qw8Yjwuf+8bPK5CJu4fBa/SqEGYmwIdvsnXLIWAms8N7IGxNbxdIvTFEvkbSOQ+JcaL5UWNnfLnBjS+AOm84oz+UuTuKTzqfHQudrlrLBnHFCXpwfUclg3CC2hgxfcU5+7CSoUYq3hl1Ioy5pRB43yTtViKQOrJbHkpPIHDpFPY3bJy2BP+FuFcpcHxHmPrpIZYsGus0T4djhRvFv7h3A33MabyrmxfB780OenRCfbACZkQn0eZvynh9T0a0hKeKEcNmCytkLP87usmbD+ks3z+Qwy/3rTFLaLYVVMjcKg4PCS6IKvBtCu+fhHF9oul4jTDY6XIL0QmkXlmjenAIuxOhQ0rF3vGtHEkJ8E/l21ticBbBuBZY33MEc6iC5AoYLGprBiZtdNRG0WVEIWUvr5vfnu2QuE51TPRKbYXSoix7kTgZAZAtJ310mpTanm+uoh5JZRvmMK38NmnzgCxKqYg04hS8GVNIUTWLnq0T2mwKq9uKRPSHYXY3vj6SnFuPx6P0GK+tg61qZB6ZSMIxK/emePrKetm6Y65ri3WG+s5L/EFECMqbW7m6KxpkJn93gKu1szL9B0T/FRVuYspPWH0vSI+7Bgf7fS7Qgso8Oz9tO0MQyfEgHdYmzK64CsPNoJZYNjpceC2lvKZ10JGSqEkQxw7TJXS8RYL6ZYbZRpZ645FzTD2Uck4b6G/z0WIMRIDKk6i29o3h4rRrXaSNXGo8gjLxEVdCWlbhaxHTy2ELHnakJQQ2TUz/DhglqFozn0LwAMtb0+fgcVlx+fQRxnt1C13IsGaEgUidmTEvpa0zUuIJ0OBCcuZglos1d5aW
 s/TFgYG7
 kJr9KDJ8uUiYs7MKv7HmVKu/+yGDR+DeuGNl52FsDlJA676BZfE9ZYZki4SopkhV3teNmXKnvVb16ev0Cw2SNbrqOkH4GAIrtHowTxeirK7w29/l8/yXaLsK+B79WxrDhLsL94X6FRe+HBg8QUa/fcQDW7smJoP3B2/D9XtTruFFCHdINqPO7GRHIhDkrZ1dHWbDmSLz8w9vZFe46UYCYzeA+f5+H91aapIVbPcOXCErFB0ES9nLyasoWFdo7z1grBGBh/gKR/UgQifSpOfNIwKM+Vx73206Q64x+ypiPVZaoITcH09olcN+H/mvescgy33XBx2nF/bGLFM1i+W5AdryKvodALfMrzMKt5RZB3TW/sqgeyTrZcp2roDGL/GRnikjvDpoiWXR86V95FTn/kUdaaV/d0ycYNXUqIKqH277M4ts6PxPjRjmxfNjDnrr9RT7Yzal7NjqKlhuJ2qzN7zinwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 05:49:10PM +0200, David Hildenbrand wrote:
> On 24.07.25 16:49, Pankaj Raghav (Samsung) wrote:
> > From: Pankaj Raghav <p.raghav@samsung.com>
> > 
> > There are many places in the kernel where we need to zeroout larger
> > chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> > is limited by PAGE_SIZE.
> > 
> > This is especially annoying in block devices and filesystems where we
> > attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
> > bvec support in block layer, it is much more efficient to send out
> > larger zero pages as a part of single bvec.
> > 
> > This concern was raised during the review of adding LBS support to
> > XFS[1][2].
> > 
> > Usually huge_zero_folio is allocated on demand, and it will be
> > deallocated by the shrinker if there are no users of it left. At moment,
> > huge_zero_folio infrastructure refcount is tied to the process lifetime
> > that created it. This might not work for bio layer as the completions
> > can be async and the process that created the huge_zero_folio might no
> > longer be alive. And, one of the main point that came during discussion
> > is to have something bigger than zero page as a drop-in replacement.
> > 
> > Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
> 
> "... will result in allocating the huge zero folio on first request, if not already allocated, and turn it static such that it can never get freed."

Sounds good.
> 
> > the huge_zero_folio, and it will never drop the reference. This makes
> > using the huge_zero_folio without having to pass any mm struct and does
> > not tie the lifetime of the zero folio to anything, making it a drop-in
> > replacement for ZERO_PAGE.
> > 
> > If STATIC_HUGE_ZERO_FOLIO config option is enabled, then
> > mm_get_huge_zero_folio() will simply return this page instead of
> > dynamically allocating a new PMD page.
> > 
> > This option can waste memory in small systems or systems with 64k base
> > page size. So make it an opt-in and also add an option from individual
> > architecture so that we don't enable this feature for larger base page
> > size systems.
> > > [1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
> > [2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/
> > 
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > ---
> >   arch/x86/Kconfig        |  1 +
> >   include/linux/huge_mm.h | 18 ++++++++++++++++++
> >   mm/Kconfig              | 21 +++++++++++++++++++++
> >   mm/huge_memory.c        | 42 +++++++++++++++++++++++++++++++++++++++++
> >   4 files changed, 82 insertions(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 0ce86e14ab5e..8e2aa1887309 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -153,6 +153,7 @@ config X86
> >   	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
> >   	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
> >   	select ARCH_WANTS_THP_SWAP		if X86_64
> > +	select ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO if X86_64
> >   	select ARCH_HAS_PARANOID_L1D_FLUSH
> >   	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
> >   	select BUILDTIME_TABLE_SORT
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 7748489fde1b..78ebceb61d0e 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -476,6 +476,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
> >   extern struct folio *huge_zero_folio;
> >   extern unsigned long huge_zero_pfn;
> > +extern atomic_t huge_zero_folio_is_static;
> >   static inline bool is_huge_zero_folio(const struct folio *folio)
> >   {
> > @@ -494,6 +495,18 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
> >   struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
> >   void mm_put_huge_zero_folio(struct mm_struct *mm);
> > +struct folio *__get_static_huge_zero_folio(void);
> > +
> > +static inline struct folio *get_static_huge_zero_folio(void)
> > +{
> > +	if (!IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
> > +		return NULL;
> > +
> > +	if (likely(atomic_read(&huge_zero_folio_is_static)))
> > +		return huge_zero_folio;
> > +
> > +	return __get_static_huge_zero_folio();
> > +}
> >   static inline bool thp_migration_supported(void)
> >   {
> > @@ -685,6 +698,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
> >   {
> >   	return 0;
> >   }
> > +
> > +static inline struct folio *get_static_huge_zero_folio(void)
> > +{
> > +	return NULL;
> > +}
> >   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >   static inline int split_folio_to_list_to_order(struct folio *folio,
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 0287e8d94aea..e2132fcf2ccb 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -835,6 +835,27 @@ config ARCH_WANT_GENERAL_HUGETLB
> >   config ARCH_WANTS_THP_SWAP
> >   	def_bool n
> > +config ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
> > +	def_bool n
> > +
> > +config STATIC_HUGE_ZERO_FOLIO
> > +	bool "Allocate a PMD sized folio for zeroing"
> > +	depends on ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO && TRANSPARENT_HUGEPAGE
> > +	help
> > +	  Without this config enabled, the huge zero folio is allocated on
> > +	  demand and freed under memory pressure once no longer in use.
> > +	  To detect remaining users reliably, references to the huge zero folio
> > +	  must be tracked precisely, so it is commonly only available for mapping
> > +	  it into user page tables.
> > +
> > +	  With this config enabled, the huge zero folio can also be used
> > +	  for other purposes that do not implement precise reference counting:
> > +	  it is still allocated on demand, but never freed, allowing for more
> > +	  wide-spread use, for example, when performing I/O similar to the
> > +	  traditional shared zeropage.
> > +
> > +	  Not suitable for memory constrained systems.
> > +
> >   config MM_ID
> >   	def_bool n
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 5d8365d1d3e9..c160c37f4d31 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -75,6 +75,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> >   static bool split_underused_thp = true;
> >   static atomic_t huge_zero_refcount;
> > +atomic_t huge_zero_folio_is_static __read_mostly;
> >   struct folio *huge_zero_folio __read_mostly;
> >   unsigned long huge_zero_pfn __read_mostly = ~0UL;
> >   unsigned long huge_anon_orders_always __read_mostly;
> > @@ -266,6 +267,47 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
> >   		put_huge_zero_page();
> >   }
> > +#ifdef CONFIG_STATIC_HUGE_ZERO_FOLIO
> > +#define FAIL_COUNT_LIMIT 2
> > +
> > +struct folio *__get_static_huge_zero_folio(void)
> > +{
> > +	static unsigned long fail_count_clear_timer;
> > +	static atomic_t huge_zero_static_fail_count __read_mostly;
> > +
> > +	if (unlikely(!slab_is_available()))
> > +		return NULL;
> > +
> > +	/*
> > +	 * If we failed to allocate a huge zero folio multiple times,
> > +	 * just refrain from trying for one minute before retrying to get
> > +	 * a reference again.
> > +	 */
> 
> Is this "try twice" really worth it? Just try once, and if it fails, try only again in the future.
> 
Yeah, that makes sense. Let's go with try it once for now.

> I guess we'll learn how that will behave in practice, and how we'll have to fine-tune it :)
> 
> 
> In shrink_huge_zero_page_scan(), should we probably warn if something buggy happens?
Yeah, I can fold this in the next version. I guess WARN_ON_ONCE already
adds an unlikely to the conditition which is appropriate.

> 
> Something like
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d2..b1109f8699a24 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -277,7 +277,11 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
>                                        struct shrink_control *sc)
>  {
>         if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> -               struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
> +               struct folio *zero_folio;
> +
> +               if (WARN_ON_ONCE(atomic_read(&huge_zero_folio_is_static)))
> +                       return 0;
> +               zero_folio = xchg(&huge_zero_folio, NULL);
>                 BUG_ON(zero_folio == NULL);
>                 WRITE_ONCE(huge_zero_pfn, ~0UL);
>                 folio_put(zero_folio);
> 
> 
> -- 
> Cheers,
> 
--
Pankaj

