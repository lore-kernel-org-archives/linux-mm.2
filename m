Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C227C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817FF6B0005; Tue, 14 Jul 2026 04:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9626B0092; Tue, 14 Jul 2026 04:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE906B0093; Tue, 14 Jul 2026 04:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 417846B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:38:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9BD71C0274
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:38:22 +0000 (UTC)
X-FDA: 84986730444.17.4A8B134
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EDA8160003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:38:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOzRF47s;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784018301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/TOVltIv8GPU47lxpzdPKdqcZK9SsP+TbwAvBawLlM=;
	b=FoKg8Q5OWNTIM5dNbjGHFeoMnd54iD/qDX22xzMj6HAePrWdIj0uleVgxxQNeN0Vuc37Ba
	ZURYh6+gpXFTsNxElexzJysU2uKncytf1/pB1OqmrQCt12nZnx8Kh5bSJYzW2bHuNgXgNm
	ySjbtxSD9PKInLIA8SPoXOFnasYXDY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784018301;
	b=epWgtGqD2XzfZpQruw+ZmGyNXreNHC5a5aDJrFirp2RxhwmKaRx6VxJLIw7fcYOw+Pq+iX
	yvo8AZiWdemt3uLs36ZcegND01OCxA0nu247c/wqhl/eO/N76InZaYTEWEw9L9SSyVJM+x
	mjXYtCuvr+ih5EDOpparIMTDcmjGWow=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOzRF47s;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <08d40cad-8f61-4aba-9556-5a84067c6494@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784018295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/TOVltIv8GPU47lxpzdPKdqcZK9SsP+TbwAvBawLlM=;
	b=mOzRF47sNowHOJv3Ro+2smpWgvrVnbtSu3znbZPaqdsX6mmf+8GdvZV1Zkf0KgboqBb50T
	7OfeR5BfkHTmCzLsBIuvgr8rSzkNhxNDVXkqb+Hamf+qTxglcbNAHfp7RgdWvsUby3svmk
	Dd5ffzXrKaoxqfVWxQYV3Adw8KX/wZ4=
Date: Tue, 14 Jul 2026 16:38:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 4/8] mm: add a template-based fast path for zone-device
 page init
To: Li Zhe <lizhe.67@bytedance.com>
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
 david@kernel.org, kees@kernel.org, mingo@redhat.com, rppt@kernel.org,
 tglx@kernel.org
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-5-lizhe.67@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260709112520.24857-5-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7EDA8160003
X-Stat-Signature: 8xrehje9gzd55gdftu64tjej91s9uknn
X-HE-Tag: 1784018299-782824
X-HE-Meta: U2FsdGVkX1+4Kxe+shANACMNPfQjJmxREFl3pDUP1SMujsprOmaauiq/q/pjatq82K/W+UBkhl8Kh8mLTXUWyn3tkputfShiM21+Ih3xj0j+SAVM0rF/2gG/HuDR6eza5VkT7pznVar838SMa5bEtbvP4Qxh+jeVKa2FRY/b4UVPFArPS+g33vxD+IZMTm4EM+ub7OEDPvO/guurZB0E8B5veIZRf8vcMFmM4R6bqCwojXlCsyZNVA+8SEOXZI+t8e03hAxOQqj8SWL4/6x8IouaQyo8CcBnkPJNiQ58ngMwrdqfaPQC/Bie87PiDkUr7D0zHWKU7m9VFU5t/YoZbLKqlKi4TIKxOxKxBr3fxiKdw8il2aAofBEfri6XfiRUkDcMUd9I/Sf/b7h1/ye8ZGEC32j60KpmM/Xt/1qiNBDY9w5F1EfPUsEUyQSHixvTdDm/IjADpPH2HGJJ8244RuxM40FQkp42UWUbBTmaAdJuzly5GKGtrjc7V6QlIsqksypDRfobTvFaD9QrIaof1QHSkDRNnjLWbFHbIbvDhQn9hky7UMSf1fb4+yogyzCaZ+SMX7zpcB/ExRntPl5mzOuMqJVwXYvHSAbJeqE9yyS5NrWvPLFi94L31PVlPiw5Y6nU7D07mljH8ihnXYByb5TUJTam+ErXMHLpZyyttNyBiFLMRB+87pO15rCQSh72mJI2JHWUHNV1nfXIn3PTkExpGsLTYfE6OnL3gwbJ+tOUvRnk90pwQSseaPfpeFkDQE95ntK7sRtyYy/gLZ6CSyCLYuWm7BarBlQ0UR5QY63zYEekkTF9Q5m637uiFQbFL1fyd0rLyuSZ2TEdigrSEuJxGdL5pa8EOS1Ey0/7p8ES1k85F4rJgGHK9a/hO1WxgezsbiLUtWeyyd292Yr3pfa1sD5q6N+WVdGJ6T0FG6ugKSYb+6wyMEvqTUGKgJoLm5hptdiiFoY2jNYvt7t
 d4AbN5Aq
 lcLtd876NxTo21ZMeWsAshdl7e74HdtIl+Rdaxo66mxGjyXqusJVXkBYr29FexIM/jV5dUzgDPeXYp40Uvr0GE9XFTU6foDctjk2X28FHCpWbuxOeQR99W67j8PyptCZ16uPfK2Zfdv42Ub2/Z0maClPCgyAGusG9Mg2krPe1pwEWDLaHr6SUCgNsfUJbZlgSSZfbR6FQYC9m6zWKAQGUB11GDyu+TruxfLU96+3ru7ZmqcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/9 19:25, Li Zhe wrote:
> memmap_init_zone_device() repeats nearly identical head-page
> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
> template through the existing slow path, refresh the PFN-dependent
> fields in that template before each copy, and memcpy it into each
> destination page.
>
> The optimized path assigns _refcount through the copied template, so
> keep it disabled when the page_ref_set tracepoint is enabled.
>
> This patch accelerates head-page initialization. The pfns_per_compound
> == 1 case gets the full benefit here, compound tails are handled in the
> next patch.
>
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
> path (pfns_per_compound == 1).
>
> Test procedure:
> Rebind the nd_pmem driver 30 times and collect the memmap initialization
> time from the pr_debug() output of memmap_init_zone_device().
>
> Base(v7.2-rc1):
>    First binding: 1456 ms
>    Average of subsequent rebinds: 244.28 ms
>
> With this patch and its prerequisites applied:
>    First binding: 1440 ms
>    Average of subsequent rebinds: 217.19 ms
>
> This reduces the average rebind time from 244.28 ms to 217.19 ms, or
> about 11%.
>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>   mm/mm_init.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 58 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5fccfbacf855..170021e182e0 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1065,6 +1065,44 @@ static void __ref zone_device_page_init_slow(struct page *page,
>   		set_page_count(page, 0);
>   }
>   
> +static inline bool zone_device_page_init_optimization_enabled(void)
> +{
> +	/*
> +	 * The template fast path copies a preinitialized struct page image.
> +	 * Skip it when the page_ref_set tracepoint is enabled.
> +	 */
> +	return !page_ref_tracepoint_active(page_ref_set);

I'm not sure why we need to make this. I think we can go ahead and
perform this optimization unconditionally.

If we look at why the tracepoint was added in the first place, it's
clear that its primary purpose is for debugging, particularly regarding
why CMA memory pages cannot be allocated (see commit 95813b8faa0). But
at this stage, the struct page hasn't even been initialized yet; we
are currently in the middle of initialization. From the perspective of
the page being initialized, the user doesn't need to care at all about
how the reference count is changing. Therefore, I don't think we need to
include these checks. It would only increase the complexity of the code.

I suggest deleting this section of code to keep things simple.

Thanks.
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
>   /*
>    * With compound page geometry and when struct pages are stored in ram most
>    * tail pages are reused. Consequently, the amount of unique struct pages to
> @@ -1120,6 +1158,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   				   unsigned long nr_pages,
>   				   struct dev_pagemap *pgmap)
>   {
> +	bool use_template = zone_device_page_init_optimization_enabled();
>   	unsigned long pfn, end_pfn = start_pfn + nr_pages;
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
> @@ -1127,6 +1166,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   	unsigned long zone_idx = zone_idx(zone);
>   	unsigned long start = jiffies;
>   	int nid = pgdat->node_id;
> +	struct page template;
>
>   	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
>   		return;
> @@ -1144,7 +1184,24 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>   		struct page *page = pfn_to_page(pfn);
>
> -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> +		if (!use_template) {
> +			zone_device_page_init_slow(page, pfn, zone_idx,
> +						   nid, pgmap);
> +		} else if (pfn == start_pfn) {
> +			/*
> +			 * Seed the reusable head-page template from the
> +			 * first real struct page, because the existing
> +			 * page-init and pageblock helpers expect a real
> +			 * memmap entry rather than a stack object.
> +			 */
> +			zone_device_page_init_slow(page, pfn, zone_idx,
> +						   nid, pgmap);
> +			/* init template page */
> +			memcpy(&template, page, sizeof(*page));
> +		} else {
> +			zone_device_page_init_from_template(page, pfn,
> +							    &template);
> +		}
>
>   		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>   			cond_resched();
> --
> 2.20.1
>


