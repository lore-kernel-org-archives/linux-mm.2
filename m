Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E91ECD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890226B009B; Mon, 18 May 2026 02:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866EE6B009E; Mon, 18 May 2026 02:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A44F6B009F; Mon, 18 May 2026 02:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66E816B009B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:51:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DC391613FD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:51:44 +0000 (UTC)
X-FDA: 84779620128.26.B40C939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94F5010000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:51:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPNld9Z4;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779087102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4e32nUUjlgcpQoy1gSiCbsSMcU7Yrozgj5ZXTZCl5c=;
	b=IQFlMg8RftEz9zvFeuVWsyHWSXXX2cMUhwBLVf6YQ5d4mz8D1nRiu8z+zZMpsIN0qHbLOp
	rU9u3yFHZ26CTuENdJ+ncstgvPp4YFd+hgNlj12vismgMenkdTslM58f6awZUx9CBc7SQ9
	ZG0sBKzZ9PN39JJ4nKF3B0dRlTnYYkc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPNld9Z4;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779087102; a=rsa-sha256;
	cv=none;
	b=n7HXoBaUHFQmgJeSWrsgGp3I5cickbzPA2lOql4bjqg/U37eUfRRdC0V1O1Bwx2waMm89T
	RmS0u749wybp24gQRE+hGDPREm4bKhEtfnifW71H/POj3xvR1zlzQDWoU0r84ag2U01Sl1
	UsHCRQVd8UjVP6zAkHf/32ylDxd2U5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA35660055;
	Mon, 18 May 2026 06:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4920C2BCC6;
	Mon, 18 May 2026 06:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779087101;
	bh=pEyIxFagBCELnPW4KcSVXAY+aeER7qyhiWWCCVSH+pU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lPNld9Z4cds8IsWOlBIkgYc3kXkjFaWbcKQr0Wx6TagD433jfmdyGlBVqpyLsUsku
	 dihDbwlYK6l9ooqn1o8aZQ9v+yJkf3/aDJq+PtctLIV8FMn2FD2xQtH54NtzPoQWt1
	 B11vYboEF94jelyJtlq1Oa+VRZONFsrw2WxJIbOihxHu+02JY1UIoiK8rQsiQaSj8+
	 +guQQZmhvz6AnQiwfG4uUaZsVEOBWkTTN28YDEeuKhBNwAhexOVC4ItbJHumUc75dQ
	 iiS7PosOgjnVt3PxZo8dS+KuP0kVlEv31umpAxyR0wCHkm5OHkJCHiyRxOC7+ptOgE
	 yGD1rU2xfIMEA==
Date: Mon, 18 May 2026 09:51:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, arnd@arndb.de,
	akpm@linux-foundation.org, david@kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/4] mm: add a template-based fast path for zone-device
 page init
Message-ID: <agq29raPaAPlM8kV@kernel.org>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
 <20260515082045.63029-3-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515082045.63029-3-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94F5010000B
X-Stat-Signature: xok67xgqch9rt4adizbhm8cbdjrdgbcy
X-HE-Tag: 1779087102-511961
X-HE-Meta: U2FsdGVkX19gJU33uaCju2O+YY6DdeJ8JW+WDEUouuy7ITs+h9OALbtN1SAiG0sT4gAZ+tDxbA66yEewnwTGZ/28/dLln16IB1Lj3JyPVgnH3A5gu8CxpEcJF/a+JC+I56Nb5tXsJzkmFQqGHjkGnyys2gPKCRtP4deJu3x0+tiNgx7v96LiGv0DZQe4A4Psp/P5pDYXPwMcZs71zWnk4o+Ea8nLC0srwRVbTlZYHQWJY1nD/TNooEO2wv4kuns3BCR28se+VDQ8kPg75O+fin7IthzrWoCUOGuRF83TBmD+lHsyB5RXN1JWsn0NgD4jNLd4N65ywf3FMxRe/caC9gxj0gKUc1BbLCMBrIV7GslCVL12CAq+wSR/1ce12seLxohANVsc+y5meIz+8XaHSaVPmA5Hh8I4Qlz0O8hpnAIdI5R0lelBzE3fQs7Ft3S6d8iQF0iS9Ql7SZd+bQN5OMf/v0mWWZavC+Uj857kPnu2AxlMM/PNjzYRDOmyBS1Apnb2TeZmhhH2n2yrCowwjhmPdlOKwYEFv/AHHry+9Cc+paWpfn95crZWrcyw66YCBx5s411XWef++pBDnVeZKDjhnkzhCYXpKp5dX45BCEoNKsvRi+fa3psrR8te3ahjzqXtgX9MleiTqCAeHqrAsges7AHlt3tbc3bboT+rzIzddNKSTSFsziH6+fmpZGPSy8sidBnJrw2/x1L5zB9+g/5rFAh2PH7brsx1focvoyrKF1dWyWgRmkbzsry4rX1SApJC29o/dq8cZJ0qDGJOCv+1z5I//bln9jJBML8uzJyptHuj7oW/RH7q/3AXbFx63nQ24q73UVohcImPYthD19uo1WolvfsjpNABiQUGH+wreGJGokIW7WD3X9vA5VHrPrZiEv2gzClaNMKPg6h76RrUt+uk/NausdZFUNn1YpDs55+o5gmz4MdEvEsDe4z+CfzF5DkPq+wrXLZYZJC
 oWpUfCqQ
 VTO6q9LKsPYJm17BHt/U6Mdq2Q1RTSAjbnik71/KILM5hucsKORb6f3MN3A7zd+a+eq9mITxMrAj7gAgf4Yo5nUlxQkBUZzn2HAxMevFNbRhwNy/qUeP5Kc2u/RAuStT3ONVYDUgr99RMhth4bE8qhCQRyboCOEK5UohNXPOeO0C5V+qtczMDUb2AmhuFgzHPDCeAJgjmVLM2a9dERIhBWNRPgvS7bp2cP0dJmHat3sAErOEyiwvX1Xs0sOmXFHEthcNqSXd/4g/IDaG4lwDkJ2S/tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, May 15, 2026 at 04:20:43PM +0800, Li Zhe wrote:
> On 64-bit builds, memmap_init_zone_device() spends most of its time
> repeating the same struct page initialization for every PFN. Prepare a
> template page through the existing slow path once, then copy that
> template into each destination page and fix up the PFN-dependent state
> afterwards.
> 
> Keep the optimized path disabled when the page_ref_set tracepoint is
> active, because the template-copy path bypasses set_page_count() and
> would otherwise hide the corresponding trace event.
> 
> Non-64-bit builds continue to use the existing slow path.

ZONE_DEVICE depends on MEMORY_HOTPLUG and MEMORY_HOTPLUG is only supported
for 64 bits, so there can't be 32-bit builds for ZONE_DEVICE functionality.
 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
> path (pfns_per_compound == 1).
> 
> Test procedure:
> Rebind the nd_pmem driver 30 times and collect the memmap initialization
> time from the pr_debug() output of memmap_init_zone_device().
> 
> Base(v7.1-rc3):
>   First binding: 1486 ms
>   Average of subsequent rebinds: 273.52 ms
> 
> With this patch:
>   First binding: 1421 ms
>   Average of subsequent rebinds: 246.14 ms
> 
> This reduces the average rebind time from 273.52 ms to 246.14 ms, or
> about 10%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 96 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5244acb96dbb..4c475c71a9d6 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1013,7 +1013,7 @@ static inline int zone_device_page_init_refcount(
>  	}
>  }
>  
> -static void __ref generic_init_zone_device_page(struct page *page,
> +static void __ref generic_init_zone_device_page_slow(struct page *page,
>  		unsigned long pfn, unsigned long zone_idx, int nid,
>  		struct dev_pagemap *pgmap)
>  {
> @@ -1040,12 +1040,9 @@ static void __ref generic_init_zone_device_page(struct page *page,
>  		set_page_count(page, 0);
>  }
>  
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> -					  unsigned long zone_idx, int nid,
> -					  struct dev_pagemap *pgmap)
> +static void __ref zone_device_page_init_pageblock(struct page *page,
> +						  unsigned long pfn)

Please move splitting _pageblock helper into the first patch, so that the
first patch would contain all code movement.

>  {
> -	generic_init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> -
>  	/*
>  	 * Mark the block movable so that blocks are reserved for
>  	 * movable at startup. This will force kernel allocations
> @@ -1062,6 +1059,88 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	}
>  }
>  
> +static inline void __init_zone_device_page(struct page *page, unsigned long pfn,
> +					   unsigned long zone_idx, int nid,
> +					   struct dev_pagemap *pgmap)
> +{
> +	generic_init_zone_device_page_slow(page, pfn, zone_idx, nid, pgmap);
> +	zone_device_page_init_pageblock(page, pfn);
> +}
> +
> +#if BITS_PER_LONG == 64
> +static inline bool zone_device_page_init_optimization_enabled(void)
> +{
> +	/*
> +	 * We use template pages and assign page->_refcount via memory copy.
> +	 * This means the optimized path bypasses set_page_count(), so the
> +	 * page_ref_set tracepoint cannot observe this initialization.
> +	 * Skip the optimized path when the tracepoint is enabled.
> +	 */
> +	return !page_ref_tracepoint_active(page_ref_set);
> +}
> +
> +static inline void struct_page_layout_check(void)
> +{
> +	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));

Does it have to be a BUILD_BUG()? Can't we fallback to slow path if struct
page has a weird size?
Just do the check in zone_device_page_init_optimization_enabled().

> +}
> +
> +static inline void init_template_page(struct page *template,
> +				      unsigned long pfn,
> +				      unsigned long zone_idx,
> +				      int nid,
> +				      struct dev_pagemap *pgmap)

The name should include zone_device to avoid confusion with regular pages.
> +{
> +	generic_init_zone_device_page_slow(template, pfn, zone_idx, nid, pgmap);
> +}
> +
> +/*
> + * Initialize parts that differ from the template
> + */
> +static inline void generic_init_zone_device_page_finish(struct page *page,
> +							unsigned long pfn)
> +{
> +#ifdef SECTION_IN_PAGE_FLAGS
> +	set_page_section(page, pfn_to_section_nr(pfn));

Can we add a stub for set_page_address() for !SECTION_IN_PAGE_FLAGS case
and drop the #ifdef here and in set_page_links()?

> +#endif
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(ZONE_DEVICE))
> +		set_page_address(page, __va(pfn << PAGE_SHIFT));

set_page_address() is a not when WANT_PAGE_VIRTUAL, you can drop the ifdef.

> +#endif
> +}
> +
> +static void init_zone_device_page_from_template(struct page *page,
> +		unsigned long pfn, const struct page *template)

zone_device_page_init_from_template() please.

> +{
> +	const u64 *src = (const u64 *)template;
> +	u64 *dst = (u64 *)page;
> +	unsigned int i;
> +
> +	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> +		dst[i] = src[i];
> +	generic_init_zone_device_page_finish(page, pfn);
> +	zone_device_page_init_pageblock(page, pfn);
> +}

-- 
Sincerely yours,
Mike.

