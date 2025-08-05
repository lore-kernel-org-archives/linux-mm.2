Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6D1C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607AA6B00A0; Tue,  5 Aug 2025 12:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFAC6B00A7; Tue,  5 Aug 2025 12:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5E16B00A8; Tue,  5 Aug 2025 12:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403026B00A0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:42:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D98A1C01B6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:42:21 +0000 (UTC)
X-FDA: 83743271682.26.822AD53
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B8EA1C0006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:42:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JU5PD4dR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754412139; a=rsa-sha256;
	cv=none;
	b=2cRIjzj5CizYh1l+8n09VJXpBXI4Rk2DCXd5yXki88qJ5S0rpgqSUDEr2VYyWNpWhAPX68
	epkVU0U3hDkgzmp9/l0RxSE7eekl+I2ONv8kkN6oeEcpY9AODXCo1j0H7LGfPn1Z2PlBUK
	L0EYkFyBH7ZtfG+3YSupflYE54Pdi/Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JU5PD4dR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754412139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EcZ/fTlyps62ZbrmNumN80pfeJzHmkLMM1FXyVKWXg=;
	b=V7xCYyrvPDUr2CW1Szo1WUJ++IuwB6LAlXokEj4ZENf3TIqSsRY0UkBcGezVqiaTEp9XGk
	CEBjkT/tYvTlgt85pAlw+gF5oSGRHd9ePsoRLS2CRtfpI2M+4Lmng7P/PURNubBI0wrnO3
	8FurVbuIOskbewux6Trd5N+vVUvQnLU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754412138; x=1785948138;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NI0Pa52pJjxiroyoTscQkPI/Lrl+7gR5IHOHQEg0uqA=;
  b=JU5PD4dR5nZ5HCFtwK16SszmsybiDIKmJQJNU88yckvBYvsOcX7bIMSh
   7VYKDKY6pWzq6X+3exUghdCLPYXkF7SdKFxUsYr+jde7/+C/eaFnb5zEW
   Z3j4xxRXjRIQ+KpgZEvUt6g3ZJ5yOcsGUho0CZt4+ZZhVjaCiVLb5s2Aj
   8nuWR+O6zAcNbAi6VsWuecsN62MryExfu2hR/lZrdMinN/1opfgy4U+2q
   dfCHtwAHHup1ZJJRdHLc9HTXgsrlX5pUlhFUpJB0xNBts6ibsxlDQ854D
   x2vJNLuXCyMUeWF3DpN8yIPY64VmKinVoJaVpEmHHHrxiF+uYOc2EV5ts
   Q==;
X-CSE-ConnectionGUID: neiX91voT4WhDQxBXaPWtw==
X-CSE-MsgGUID: VnFeJo3/Ts6vVzPH24D5hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="44309764"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="44309764"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 09:42:16 -0700
X-CSE-ConnectionGUID: 2zo8793CR+SS/fNQvNF4lA==
X-CSE-MsgGUID: Waiv5Ff0Q8u+GwM8Ts8yjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="164905002"
Received: from inaky-mobl1.amr.corp.intel.com (HELO [10.125.110.106]) ([10.125.110.106])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 09:42:15 -0700
Message-ID: <b810103c-ee95-4cc9-8b59-4dc6b1847d1e@intel.com>
Date: Tue, 5 Aug 2025 09:42:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: add largest_zero_folio() routine
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
 <20250804121356.572917-5-kernel@pankajraghav.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250804121356.572917-5-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B8EA1C0006
X-Stat-Signature: rp7oijg71zmhxds86sua1iogpgs7p5jm
X-Rspam-User: 
X-HE-Tag: 1754412138-939853
X-HE-Meta: U2FsdGVkX1+z527msIweih5y1veu0e4NxVxI2geBuH4jYWzZO9qUZhmRslLUBRlWhSjl/62c546C8mCQfw1kmohjf892JcSLzLIWfkZqO2MmMzzkD/gw9rlrFlocp69yiazaQWaXD+BQeo2aOFhgPFM4rFgtzUPD03jxpgngMb/T8cw3QZrXtb61HltafAyHn1xipCssKTetFYieeS5CyGfXY41nD5eM7X5yJo8jxZjrCSQIASAkCXegAVFNhCBuQpPRJqkEkAIWSBgd2HBMbQRzRMy1VrWl59qwjv+cFuQmKr4snZ0PaDMIbEc2KQlNGY1WAffczGPeL7Zwxq9WxHk6/yAU3neVOM8VdlUegc274ZLyQ8TzwEomsYMi1lb8yqwogrTmAFfdcKtDEiMlTUKT6Y9V/IVepoIhvj6TzyoBeAiPxnPg/TFBwGVXPSFa0OTEllP7N95gXjZRZIBY1uHrYCJ04bXEsCGhXxro2T+i8GDvrY4Q/u2/c7xlsBRfCbTQZ0oRnx00g1GA5wS1xS7hc/LjezvOajIBahL43m9ykbcPZqwFzL3AclFT8E0+JhS+Gzf88TFD+XgssRKr3orvR3A8N4GEBusug1rGZvbYsxWxTKqSOvhFIRbvDebOngbHOAQt0WuNyNuNU0it1Rgf0xXiJ/XatuCGmF/2JSHF0sfpsVfKxRbwvth3Rbyewk2j8k8/gDBJxu++SPfGwvxjTKImshS7QL0CaHsQZf80wnfD5v3+nwyULvMu9iIRsFU1friXyNG5lkquAh7I/RU9sfjhvw1PLSutXXQVFNj4MjIEGAD3FJT27ZhmSD2P1LKFXnnmja+LgEkhWfZXBYa+pcYo81Gel5dHLePx2gfSCgw/CYcC+lGyToo5qkvvQ4rpKpJlhZDjCXYzc+P+Zci6G6auC7v5akVtcgqWUJtwu+EHt0dUW0Zl++v8g7WxHEsNRwuO7rft4bvVFEn
 lHnCL20r
 Rz5kaycGs+hIaBDkk2+T3nceKsnkO51JDFGVBJQAW+OQFztZnEK7G2ukYC1mSnv14kmz+rKO+2qjYEWI7mlyX2y/nqJF1FROuJtJaj+nQfqSK+RBYYe8Ilz7q6Iu2KAG+5b8ImpS8jaFd5SNcK78jhv7Opr3fw1LPuuqXpEGuyklp9dK8Lu6dhVyBvngwzZ5mdzWpJRwciVG1y4rV62AVy9yYsX9dXxSrl+QXX8ZDRYMFNLxqzxjzKZMxYR4RLNSf2fvbgafez27/SUDz2/YvIJWbmJ8kvaPPkiyucO+wyaeYYsv9Q2qsZbrJ9HH+50UizonOIDyQ+AlQd8G0V1esNpD2SmCuHx2Q6wNdZwiU5O+j6rriNepk4MTBZSWN9kfTpIjx
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
> Add largest_zero_folio() routine so that huge_zero_folio can be
> used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
> return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
> if we failed to allocate a huge_zero_folio.

This changelog is telling a lot of the "what" but none of the "why".

The existing huge zero folio API is for users that have an mm. This is
*only* for folks that want a huge zero folio but don't have an mm.
That's _why_ this function is needed. It's in this series because there
was no way to get a huge zero folio before the permanent one was
introduced in this series.

Can we please get some of that into the function comment and changelog?
It's critical.

> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 78ebceb61d0e..c44a6736704b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -716,4 +716,21 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
>  	return split_folio_to_list_to_order(folio, NULL, new_order);
>  }
>  
> +/*
> + * largest_zero_folio - Get the largest zero size folio available
> + *
> + * This function will return huge_zero_folio if CONFIG_STATIC_HUGE_ZERO_FOLIO
> + * is enabled. Otherwise, a ZERO_PAGE folio is returned.
> + *
> + * Deduce the size of the folio with folio_size instead of assuming the
> + * folio size.
> + */

This comment needs to get fleshed out. It at _least_ needs to say
something along the lines of:

	Use this when a huge zero folio is needed but there is no mm
	lifetime to tie it to. Basically, use this when you can't use
	mm_get_huge_zero_folio().

> +static inline struct folio *largest_zero_folio(void)
> +{
> +	struct folio *folio = get_static_huge_zero_folio();
> +
> +	if (folio)
> +		return folio;

There needs to be a newline in here.

> +	return page_folio(ZERO_PAGE(0));
> +}
>  #endif /* _LINUX_HUGE_MM_H */

The code is fine, but the changelog and comments need quite a bit of work.

