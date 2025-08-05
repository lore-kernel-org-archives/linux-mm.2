Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9947EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2716E8E0014; Tue,  5 Aug 2025 12:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222A78E0001; Tue,  5 Aug 2025 12:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA8A8E0014; Tue,  5 Aug 2025 12:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE97B8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:33:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2CA2B5F5C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:33:17 +0000 (UTC)
X-FDA: 83743248834.27.DBD3DE5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51F92C0010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:33:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XmuvziGu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754411595; a=rsa-sha256;
	cv=none;
	b=bk5Qbi4ckFIPVxUcVHugbQFv4t1gNgY9CwRv7pqYhkPHStqxZ45zlLBj7DdgXzhahhf0+f
	rBBt6EI/HhKRao9vHqvsBkSlAMiNPmXlywS4pgg4z9VZ4V0KNc9x+OMUt4tUb2j0WnqCxY
	b/AM7SjluSmMojT8YQU64f4KRNq1PaM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XmuvziGu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754411595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lriI1j35rnImBcCcU/LMAiVp5y+m+wBPCw86ZLRCXg8=;
	b=ujZS+Ee0bwUzLmyivYzv9Xc3wa11X7D93oJcOI4RDFVGgwSOK1/vmxvz3SbbB0cVDgu428
	zjpy0a/thDvqWLuFjxCtnRtU8srCcg5G1PEp4V75PQinef9QCFa35mWVVl8ReeoS0FyFT/
	bH0UaFa/r1ICx4XgAl+h/oegOYVF9oo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754411596; x=1785947596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XlIUZZSTRcuLHdWy+RPpcgyNKVOAIfsokczyJGQ5h4M=;
  b=XmuvziGu26trkd5H0fqu8TG1RuGsmhE1vxBBloVuOCnu1v4+ifq+5UtP
   xZL0WuNIexkOJg0Iwy17AZzc7JKtJm0PpV6eKpf4hleZjFeIoD16nOQxf
   E3diHagFcOJl4KAOL4oTIpSQamqKsLZcmdL7WUb+K7d9+90DuNfTIxcJl
   rkSzf1gRwy8qmXNin9oUI40smvNSa32rgxiolSz8/5FGxHmPIVB2fS0sF
   oRPh+U9PQP6LWwYQ2Ij4zsN4raum+t4nAy+KjSyse1sxZrwz3dg60xYA2
   WUYg1aHOWZ1eYFFZF6oRJfK/OfmaeScSsViooGGFMYi0OO0T/g8EElUk7
   A==;
X-CSE-ConnectionGUID: /e4dhGmGThusUx8qH6bYNw==
X-CSE-MsgGUID: aVPSdGILQ9yLipsPCw9J3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="44308309"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="44308309"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 09:33:13 -0700
X-CSE-ConnectionGUID: U+kcStHjQo+Rs6I62bQmeg==
X-CSE-MsgGUID: CRRYWzt0RiiDjWLIQ8F5Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="164902203"
Received: from inaky-mobl1.amr.corp.intel.com (HELO [10.125.110.106]) ([10.125.110.106])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 09:33:11 -0700
Message-ID: <558da90d-e43d-464d-a3b6-02f6ee0de035@intel.com>
Date: Tue, 5 Aug 2025 09:33:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 x86@kernel.org, linux-block@vger.kernel.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250804121356.572917-4-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gs153dnabowqcw9ua4xdngbo3ziknjzm
X-Rspam-User: 
X-Rspamd-Queue-Id: 51F92C0010
X-Rspamd-Server: rspam02
X-HE-Tag: 1754411595-330553
X-HE-Meta: U2FsdGVkX19Nyfu0ipVJ60SVMA59z/4yIGXJTnUZukF/XokamnwwG3jn80xuqhK23xbCUJOV+PT1Qu2gdtUy3ljhLe9buFTF7XHxBCuLAusg+Teb1lL9NzSc3iLX5rrdOKv7FN+uB3rG3L1Nd7KW4QbubAMpSdTIKz+mDm+wzTMwrpJSGQdFFrl/CYeRV53S1rhRwUr4d0shskChOHU1Ro6ki6hG22wneAv9KBrju4ewSRAJMz5ydGHhTkZMpS4V/mjq6HJdDamMXe2z5JLrdytwY1uEvGGcL1d6mKlieTyB52CcgnUG1FSDNttRIl67yrLHI55DJnIx4Uvf3OIfDUKAN9pOw8SXkWC0DD/LC+KQmVKU0JpzatJi8sG0w3miPsY2jlgd0AudzhZ6DVayFZ6Q0W+L6oy2GkpLzu57NRF1iLf5zRQcdrSMw8Dook1CeN0aHnwR1LfyrRQvRUYtB0sEiriLYcqwCmZaRv8RiFe+miI+AICU3Hos75vssEwypfG/yzdoQ/L2QHmanEMP/sYSafNg74Sj93MvipKYdS2mTeWD+IY85aMpudGKobGF7fWEboh0rdwpzpBWM+ui6WO5InUDQ5le2hLDUbgjTVd2nyX6qrtcS6syXfNO0/m/MB6KCbAQXQhD9HE6Qe4HCZB6us4EuH5H7q35STZ7C7IKXLpUCtkpvP8xx9eE0O+wf2UNrWh5a3cakjMKOZnqZvhnI6m7GRVN0tP2uJoeC5G3+w5ge/XXBfqz/C986tZaLxbR1rBPso+d4IpX/fMJfF/ASl4Vt5GKhg85EM6cKz7rNpQv0PFlmennkPJ6BIzXBQlFMA3B0i8xDz/OYyWYiUqfHQ90ZFwAlCamHeCo4f7UB/+WEeS5/ADTVS/ljM4w6mKaRRZhc0mUu35wkCO+0pJ5Dp0Lm3NleFj3HXlItzqf+/a/9r70wRmaBugOHrbXRo+UI6k8Q7M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/25 05:13, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> There are many places in the kernel where we need to zeroout larger
> chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> is limited by PAGE_SIZE.
...

In x86-land, the rules are pretty clear about using imperative voice.
There are quite a few "we's" in the changelog and comments in this series.

I do think they're generally good to avoid and do lead to more clarity,
but I'm also not sure how important that is in mm-land these days.


> +static inline struct folio *get_static_huge_zero_folio(void)
> +{
> +	if (!IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
> +		return NULL;
> +
> +	if (likely(atomic_read(&huge_zero_folio_is_static)))
> +		return huge_zero_folio;
> +
> +	return __get_static_huge_zero_folio();
> +}

This seems like an ideal place to use 'struct static_key'.

>  static inline bool thp_migration_supported(void)
>  {
> @@ -685,6 +698,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
>  {
>  	return 0;
>  }
> +
> +static inline struct folio *get_static_huge_zero_folio(void)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  static inline int split_folio_to_list_to_order(struct folio *folio,
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd6cf..366a6d2d771e 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -823,6 +823,27 @@ config ARCH_WANT_GENERAL_HUGETLB
>  config ARCH_WANTS_THP_SWAP
>  	def_bool n
>  
> +config ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
> +	def_bool n
> +
> +config STATIC_HUGE_ZERO_FOLIO
> +	bool "Allocate a PMD sized folio for zeroing"
> +	depends on ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO && TRANSPARENT_HUGEPAGE
> +	help
> +	  Without this config enabled, the huge zero folio is allocated on
> +	  demand and freed under memory pressure once no longer in use.
> +	  To detect remaining users reliably, references to the huge zero folio
> +	  must be tracked precisely, so it is commonly only available for mapping
> +	  it into user page tables.
> +
> +	  With this config enabled, the huge zero folio can also be used
> +	  for other purposes that do not implement precise reference counting:
> +	  it is still allocated on demand, but never freed, allowing for more
> +	  wide-spread use, for example, when performing I/O similar to the
> +	  traditional shared zeropage.
> +
> +	  Not suitable for memory constrained systems.

IMNHO, this is written like a changelog, not documentation for end users
trying to make sense of Kconfig options. I'd suggest keeping it short
and sweet:

config PERSISTENT_HUGE_ZERO_FOLIO
	bool "Allocate a persistent PMD-sized folio for zeroing"
	...
	help
	  Enable this option to reduce the runtime refcounting overhead
	  of the huge zero folio and expand the places in the kernel
	  that can use huge zero folios.

	  With this option enabled, the huge zero folio is allocated
	  once and never freed. It potentially wastes one huge page
	  worth of memory.

	  Say Y if your system has lots of memory. Say N if you are
	  memory constrained.

>  config MM_ID
>  	def_bool n
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ff06dee213eb..e117b280b38d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -75,6 +75,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  static bool split_underused_thp = true;
>  
>  static atomic_t huge_zero_refcount;
> +atomic_t huge_zero_folio_is_static __read_mostly;
>  struct folio *huge_zero_folio __read_mostly;
>  unsigned long huge_zero_pfn __read_mostly = ~0UL;
>  unsigned long huge_anon_orders_always __read_mostly;
> @@ -266,6 +267,45 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
>  		put_huge_zero_folio();
>  }
>  
> +#ifdef CONFIG_STATIC_HUGE_ZERO_FOLIO
> +
> +struct folio *__get_static_huge_zero_folio(void)
> +{
> +	static unsigned long fail_count_clear_timer;
> +	static atomic_t huge_zero_static_fail_count __read_mostly;
> +
> +	if (unlikely(!slab_is_available()))
> +		return NULL;
> +
> +	/*
> +	 * If we failed to allocate a huge zero folio, just refrain from
> +	 * trying for one minute before retrying to get a reference again.
> +	 */
> +	if (atomic_read(&huge_zero_static_fail_count) > 1) {
> +		if (time_before(jiffies, fail_count_clear_timer))
> +			return NULL;
> +		atomic_set(&huge_zero_static_fail_count, 0);
> +	}

Any reason that this is an open-coded ratelimit instead of using
'struct ratelimit_state'?

I also find the 'huge_zero_static_fail_count' use pretty unintuitive.
This is fundamentally a slow path. Ideally, it's called once. In the
pathological case, it's called once a minute.

I'd probably just recommend putting a rate limit on this function, then
using a plain old mutex for the actual allocation to keep multiple
threads out.

Then the function becomes something like this:

	if (__ratelimit(&huge_zero_alloc_ratelimit))
		return;

	guard(mutex)(&huge_zero_mutex);

	if (!get_huge_zero_folio())
		return NULL;

	static_key_enable(&huge_zero_noref_key);

	return huge_zero_folio;

No atomic, no cmpxchg, no races on allocating.


...
>  static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
>  						  struct shrink_control *sc)
>  {
> @@ -277,7 +317,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  						 struct shrink_control *sc)
>  {
>  	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> -		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
> +		struct folio *zero_folio;
> +
> +		if (WARN_ON_ONCE(atomic_read(&huge_zero_folio_is_static)))
> +			return 0;
> +		zero_folio = xchg(&huge_zero_folio, NULL);
>  		BUG_ON(zero_folio == NULL);
>  		WRITE_ONCE(huge_zero_pfn, ~0UL);
>  		folio_put(zero_folio);

This seems like a hack to me. If you don't want the shrinker to run,
then deregister it. Keeping the refcount elevated is fine, but
repeatedly calling the shrinker to do atomic_cmpxchg() when you *know*
it will do nothing seems silly.

If you can't deregister the shrinker, at least use the static_key
approach and check the static key instead of doing futile cmpxchg's forever.

