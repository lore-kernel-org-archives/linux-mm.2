Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC7BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02A06B00D9; Fri,  3 Jul 2026 10:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAC96B00DA; Fri,  3 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4066B00DD; Fri,  3 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85B6C6B00D9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:06:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1652A140140
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:06:44 +0000 (UTC)
X-FDA: 84947641128.06.2C50301
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8475940003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:06:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lp3q0TXL;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783087602;
	b=HcZz7bV+aUH3F64Twr3JvWwgJjo4rmsivKlLo4EoO9g23V1t2CjbH1chCIw9Mj+bbLWvUS
	MmfUeQvFpfpteIEBxvMaevlpVlVN5IDSD7yHTDrC1SabJorjxt9EC2Wgqc1WWvgwfMpiEo
	/bZzz769g08EbjDZE6dAmqCG9ibilHM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783087602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pl8AC7qRBIEwlkot9AQuVgRYA3lF+ufbzrcbLLYwh0=;
	b=6E5W+ldUhL2e50tvJOtpvnql5tFC5a0GjeJBmXlsuNfPHFT13+2u4UzpUwYVJlK0jaHO+c
	zKjrO8durpXeH6vurdg/3BrYQzWCFne/5ibrh0rMGlWgeCKh1s1aX/0JvGj8A/V/sNMSBP
	Ot74MUHXmwKg9FDP4HbD3J0/ap83NRk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lp3q0TXL;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 101CC60051;
	Fri,  3 Jul 2026 14:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBB11F000E9;
	Fri,  3 Jul 2026 14:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783087601;
	bh=1pl8AC7qRBIEwlkot9AQuVgRYA3lF+ufbzrcbLLYwh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lp3q0TXLLJy3nqhzUHsU4dOWZjR3u2CraFKtZKVK7JOnHWpZNEOORVkR5AtEaoVFM
	 MkTqvcZg5727VjDHeVl1YFCJ+3Eh6f9QwEG1vKfxvygkdN9iwE8a44mkwbGhqGqqe6
	 geLge/IeNx9EBV3kvleMaIzjDDmfQ6Ts9RLrWzv8e+buz2IIbyzHrwNCd/rzxxjNM7
	 5YKkrzcyxrkzhjc8p6ZKxGvDO0RWIT87fhA5220Qm2pDZtz7A6L8Kmset3rjQQ6Kvb
	 psVhW82tgtKWptTPfTnTgtI0EQMyWDRmm8oTr6fFHLebyTc6qDhBrJ8OHNqqdbaNmc
	 oWXodFLtCI9+w==
Date: Fri, 3 Jul 2026 17:06:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org,
	kees@kernel.org, mingo@redhat.com, tglx@kernel.org,
	linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v5 4/8] mm: add a template-based fast path for
 zone-device page init
Message-ID: <akfB6Qe-jKDEMUxz@kernel.org>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
 <20260701090553.62691-5-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701090553.62691-5-lizhe.67@bytedance.com>
X-Stat-Signature: 4p37dwjri9yw7kmzgii7xuuousm4135h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8475940003
X-HE-Tag: 1783087602-578516
X-HE-Meta: U2FsdGVkX190Y8yr6kHgIlXcEhRZOuiCp55UOjhTi4Ky7qDUuswx5128jKLfLaM220AJFrUnVRa1EOD7v+O1Oc3Ov+O4S6ZhhVdCdIRwMBzzZInm7fk8uQSym8xcp6HYrRjC/+ZEVs6VuwZ9c+FEM2m3PgJY2rDyazZk8oi5qQ79xBY4M2FgAzeZSQMKXdY6zGWZVSX+jlt8tgWItcP2oog/BpkB7oClI7t2oSPBcbxxsHa85nCkwut5DXnhluQ4HFKm9BCjv11axyCGEwjOKPtB898cIcBLThw/NozBQbrQn2wT7DDc82YdD9gXjnu0OY/RVJzW7Y2XdEzvuI+BkTXJqMjFRVliryzaC3+ZYzieDIBNKnjw40LqaUJ89F9Vraeq7PEd4KDm6QDovLMW2UGQJN0PH2fEIN919tJ+Mn8nHle3zGCSSEPxxuW1yhAVRCS9UFJIW/5LLzvbcWj93UsRb8M1L6yxMsQawz/IzKh0TmyMIgOAhZFQBjOeMkDzD6a0KjCEQ36UVdeUHtMOlxQOHvvw8m6B+MKsY8ggHRNJ7a+YaeTuvBC7wobRFWyhZdz8tzFTFZFAMNrMLBJIt3i4X3sd2nIbzGk3MI5lYJ2tb8zKkvWkMYv/luvO9oQKo+IfgMV1j1R5AfckYmE4X5lftttoU/Kl7Ho2J4z+MM9/bKNe1xIV50iVP5jTbNAj0+oJt5CBspEkalonki56LgjWmO35x9YW1fjNoRNMZEtQfCe04nEgk+koZxlA3qGQsx0Zklox+phOX8SlE8oSKwVqW2w76cSMxdqVj+ZhLWarApD1sR4zYAhMjA4Qm3TnDPyD4HlwXWM6sHK7vQO3lJg2h58OuKuwbFDVsB17CJ93Fs/im+QQx6gJGvix6A9DbXdZCr4c6GYArh4D/8GJixzQLuZrdUX+3dwsXSWbKOpnnyEovBy+PjQ3GvHTV3tBaABZQP9Z3c9eU0jnjNW
 MnPjiRrE
 hJiuf52oiLB2I9YNnN61/3mla6DvN4ge2jyBXzx0bDeZVpipo4Psbkeo+fPMTS/yjHRgYSu9N+mGrdRjC1YQEQB4WQR53MMl7S8XLYBE1YhZAgNiQqUwTweuJa+rPZcxiBDPfyjcxSUFTSDJqwItdHHsmE5HDELemE8M9geYtBPP3Pkv4hKIdscDjKPg/hQ+8plspczmkVOytPHzZAIna68dtbn8J/BNyl+LFyGrcMsiirVy0wn6kot4QrOlS2SNzPsE+8UdtbsyoZ31M3n6eZJpXUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 05:05:49PM +0800, Li Zhe wrote:
> memmap_init_zone_device() repeats nearly identical head-page
> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
> template through the existing slow path, refresh the PFN-dependent
> fields in that template before each copy, and memcpy it into each
> destination page.
> 
> This reduces the average rebind time from 244.28 ms to 217.19 ms, or
> about 11%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 4c7fad440c2a..cc8417951467 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1066,6 +1066,50 @@ static void __ref zone_device_page_init_slow(struct page *page,
>  		set_page_count(page, 0);
>  }
>  
> +static inline bool zone_device_page_init_optimization_enabled(void)
> +{
> +	/*
> +	 * The template fast path copies a preinitialized struct page image.
> +	 * Skip it when the page_ref_set tracepoint is enabled.
> +	 */
> +	return !page_ref_tracepoint_active(page_ref_set);
> +}
> +
> +static inline void zone_device_template_page_init(struct page *template,
> +						  struct page *src)
> +{
> +	memcpy(template, src, sizeof(*template));
> +}
> +
> +/*
> + * 'template' is a reusable page prototype rather than a strictly immutable
> + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> + * the current template, but section bits and page->virtual may still depend
> + * on the PFN. Refresh those PFN-dependent fields in the template before
> + * copying it into @page.
> + */
> +static inline void zone_device_page_update_template(struct page *template,
> +		unsigned long pfn)
> +{
> +	set_page_section_from_pfn(template, pfn);
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(ZONE_DEVICE))
> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> +#endif
> +}
> +
> +static void zone_device_page_init_from_template(struct page *page,
> +		unsigned long pfn, struct page *template)
> +{
> +	/*
> +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> +	 * page. Update the PFN-dependent fields in place before copying it
> +	 * to the destination page.
> +	 */
> +	zone_device_page_update_template(template, pfn);
> +	memcpy(page, template, sizeof(*page));
> +}
> +

The whole bunch of template functions look like it could be useful for
initialization of the non-zone-device struct pages as well.

As I mentioned previously, it's interesting to see if this approach speeds
up normal memory map initialization as well. If if does could have a single
set of the template functions.

-- 
Sincerely yours,
Mike.

