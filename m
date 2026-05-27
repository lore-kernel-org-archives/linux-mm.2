Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5C9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B396B0127; Wed, 27 May 2026 11:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3BBB6B0128; Wed, 27 May 2026 11:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04176B0129; Wed, 27 May 2026 11:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC1F26B0127
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:55:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D812A0639
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:55:47 +0000 (UTC)
X-FDA: 84813650334.27.859C696
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C06640014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:55:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M9+8hgT4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruse92HxVZF3tg/3Ui5GdXdiuEAzTNq7ogLAZFLqaO8=;
	b=q8LGS1ZTBNxHqbD7/5IEWuac54ow02W9JUCkEuIliHKYs7KJgiSzyyv8uA+9+mQurGw5wi
	drXgAoeH5wL1XW4PgM9TiT9ceR2+g/vL8iDPVifpLiS0yCxtkdqfjCZ4s8oYxYLmRP9ned
	iF/lzaKWRh9ijSQOy/EkraY1JoS1T8o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M9+8hgT4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779897344; a=rsa-sha256;
	cv=none;
	b=ihAiCK9Dc07F0ipif5TWWnO8XzBT0b/8Co2qVVq405245obMsmLa3gbrb/er+xXrtOGmKu
	BzONmfUC+so1ITwGJYyQkqhVvhcWy7NdSnrzi5QEVoIslVKzTJ+OFEha11yOXIqt+8B/z5
	UiyvTZQUf2u4+8hLih5s+2WloPn4ZsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779897345; x=1811433345;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jyha0Bmo39q8I4y5hQNOBsElC+nbgVzd3+V4v9r6FLM=;
  b=M9+8hgT4iVTLCtM0Dw6eC93uWLz7DSIYMN/BOpAxthf4fxJqrrRAvzit
   iWF9yHFjQ2QciTI+EduKHo+OgJEbz0VFeEM4RInJeDXGEOWCGRvLO4Nhe
   Jwpr5Y27VrEUbBMbwvsxCXZaQBU9zT+UdzB2xtzuWEIdBdCH/rrv7af56
   Bi1S5EcgSE1P84lPm+tPVGolnyKtjZExld/QfMYih7iM5+WaEm+A0Vx2L
   jdy/VTMPhWO1kPwGZCs2psZOjyM4FR1XbV3d2wsqNfYs+fZ8W1Z0QCiV1
   4gPeo7hqrciW0ksHJfNUENgRLCB4aFwfi2VDqhiPRZx6S29OeCEpXOLB4
   g==;
X-CSE-ConnectionGUID: lQbvldy5SkCuucIFWzPaww==
X-CSE-MsgGUID: 8fkcl4HEQBmry+n0YMF8Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="92206951"
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="92206951"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 08:55:43 -0700
X-CSE-ConnectionGUID: 7m+ylDAET0a9fVsYihiZMw==
X-CSE-MsgGUID: UAoPuixzRUyLGu7nrdfhxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="241441695"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 08:55:41 -0700
Message-ID: <4e0696ee-895c-486d-aacc-71146f0e9047@intel.com>
Date: Wed, 27 May 2026 08:55:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
To: Xueyuan chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, yang@os.amperecomputing.com, jannh@google.com
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
 <20260527035607.14919-2-xueyuan.chen21@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260527035607.14919-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yynf9i4mx4geunsypyjhsxsmooetshgr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C06640014
X-Rspam-User: 
X-HE-Tag: 1779897343-276085
X-HE-Meta: U2FsdGVkX18aSPYU4cKF9VuFuo/tYoQhFuMojWIxzqXtUYV9gPs0XKaggT0jw3kR86gHBD+JFOOc7x+/LbKTln0oJPVOTUy2rRBQ76D49kw6jal28AQtUF1U+YjzP3MlyVNoQywX17weIV1IfzSNUFEvczFItRVJLY8WHGFV7Q9RhZwszY3AuH3OlVuksV//dhCCh98fv5o1Tg2/1HJquiOBAVk/H7wpV2XJI1s4K6+KP/O7c5JHeBDN1S0FiqeJYQTlpewkjlhNsmcQoXooPKYBa4sAjQwRabIfMim7cmBslJ9WsWAiFbCaRhllDm4TywvlsjGWJaef/sBvSkpUaTS9jodILEXUheoadVzecnxN1ZT6e/Xjte7Nf7uRP/RzepoQgWCrTFjlvB8EIvMhfdkWvdt/II2ZgSstTiYigYAkQkCJrenzaLjxEuuUZwcmGsLA1TilwFe8Jo/M3mDO4er0b+EcOhNOoFVLthn/V+SFLiP1khRbdBiD9ZZ7uFxWa6g5cBR3NpqxHG3OgYzFPFmDCvTNmS5bA2tkDDV1YNkQOPRn+t/tTpuzKDxXd9adBFqo+JBtIF2MgFXbdoWC5eFDzkfqQwcT/QJnFUciw2IbBK8RcQFKYKtwHE3GFYZF92bXXZLF/HiseW84Ae4Jao5gj/lf354JBu+GtELaXnKaqE2SjLTBflG/vmK3dJIMmJgE95t/1SH3cVhp4NEBfmvCv3Ksb8S75w367+XdHq29cvAHajpuCekeHei9u3fn9alcLW7EFKKShPNza89LKFvmgyGPyQ0wzX1MiXaV6tz/lMpG3TQ2cnktqLE01YdXafPUfzZuD7Ld78skgqVBGYsw8bgVBWE4lhnvYGtOUyvo9h0aoEUYfBAUcAgoNqJrc1siyGRaR/hpSgrWVty7B/GZpJ1bON90zB8WHq4vwHY7We+quv3QY+UA3oxIZFoU3W9FfV5HW+vjc8GnOY9
 C6FDIciF
 OxdyIJ6weDsoJkStYR1eM2q800a7PQ8QrpxtIVJSJmi+owbCasXJFHsfm8tAGouPxlwDpU7LL+KNXJudFSltKtTwmnfSB2M17NKh0EluhSoLu57GApmM5Hi7zeSgkCZR6jDNBLphyrIhCHw3d4he9AdSnUsi4P4xsgCaKNu+Iji6N0EGH8K7y7okklwPtFB5LkgTg/TcCWWYC65XKOd+a5FsOOecF6SsZOdVlXYtD5JmGw0kMfop+FTAqBF1BuurhVYfHz1wWlaVAkwVzGEbhx4CQ4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 20:56, Xueyuan chen wrote:> +#ifdef
CONFIG_READONLY_HUGE_ZERO_FOLIO
> +bool __init arch_make_huge_zero_folio_readonly(struct folio *folio);
> +#endif

All of the #ifdeffery needs to die, IMNHO.

This function is also a bad idea. There is nothing "huge zero" specific
about it. It takes any old folio and tries to make it read only.

Just make it:

	bool __init arch_make_folio_readonly(struct folio *folio)

Make it a weak symbol with a stub in some mm/foo.c file, and then the
architectures can override it if they want.

>  static inline struct folio *get_persistent_huge_zero_folio(void)
>  {
>  	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 776b67c66e82..f31200816646 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -787,6 +787,23 @@ config PERSISTENT_HUGE_ZERO_FOLIO
>  	  Say Y if your system has lots of memory. Say N if you are
>  	  memory constrained.
>  
> +config ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
> +	bool
> +
> +config READONLY_HUGE_ZERO_FOLIO
> +	bool "Map the huge zero folio read-only in the direct map"
> +	depends on PERSISTENT_HUGE_ZERO_FOLIO
> +	depends on ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
> +	help
> +	  The persistent huge zero folio is shared globally, and nothing
> +	  should ever change its contents after initialization.
> +
> +	  When supported, mark the folio read-only in the direct map so such
> +	  writes trigger a fault instead of silently corrupting the zero contents.
> +
> +	  If the permission change is not supported, the kernel keeps using
> +	  the writable persistent huge zero folio.

I vote for no Kconfig options here. Why? This adds "security" with
_basically_ no extra runtime cost. The runtime cost is, what, usually
one kernel TLB invalidation during boot?

If you desperately need one, you can add it without a prompt so folks
need to edit .config files to change the values.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf9b480bb3b0..c568755dd58e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -75,7 +75,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  static bool split_underused_thp = true;
>  
>  static atomic_t huge_zero_refcount;
> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
> +struct folio *huge_zero_folio __ro_after_init;
> +#else
>  struct folio *huge_zero_folio __read_mostly;
> +#endif

#ifdefs bad. Bad. Bad. Bad. ;)

Seriously, just pick one. Lowest common denominator is more important
that being precisely correct all the time.

>  unsigned long huge_zero_pfn __read_mostly = ~0UL;
>  unsigned long huge_anon_orders_always __read_mostly;
>  unsigned long huge_anon_orders_madvise __read_mostly;
> @@ -305,6 +309,18 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
> +static bool __init make_huge_zero_folio_readonly(void)
> +{
> +	return arch_make_huge_zero_folio_readonly(READ_ONCE(huge_zero_folio));
> +}
> +#else
> +static bool __init make_huge_zero_folio_readonly(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  static struct shrinker *huge_zero_folio_shrinker;
>  
>  #ifdef CONFIG_SYSFS
> @@ -965,8 +981,15 @@ static int __init thp_shrinker_init(void)
>  		 * that get_huge_zero_folio() will most likely not fail as
>  		 * thp_shrinker_init() is invoked early on during boot.
>  		 */
> -		if (!get_huge_zero_folio())
> +		if (!get_huge_zero_folio()) {
>  			pr_warn("Allocating persistent huge zero folio failed\n");
> +			return 0;
> +		}
> +
> +		if (IS_ENABLED(CONFIG_READONLY_HUGE_ZERO_FOLIO) &&
> +		    !make_huge_zero_folio_readonly())
> +			pr_warn("Making persistent huge zero folio read-only failed\n");
> +
>  		return 0;

The IS_ENABLED() doesn't do anything from what I can tell. This is all
in one .c file. The compiler can see that
make_huge_zero_folio_readonly() is always false. It should optimize out
the pr_warn() for you.

