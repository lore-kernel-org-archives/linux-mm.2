Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A5AC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DD16B0152; Mon, 13 Jul 2026 13:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E1C6B015D; Mon, 13 Jul 2026 13:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDFA6B0174; Mon, 13 Jul 2026 13:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72E536B0152
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:04:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DD57140174
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:28:24 +0000 (UTC)
X-FDA: 84983832528.15.9E0E1F2
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 622C02000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:28:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IbpaFlKp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783949302;
	b=W/M4l0RQ/f8CswzdmACAcaH9RNlB6nCB1ksHzf53c3yGhWkTmSobNo1OKotGhNJQJieAUx
	qFjuG80QggQPQ5n62NhyroWZSrT3MLSjfBxqK92+cR6VaL7bRQuQDarugb2fm5Mgt9+n9j
	yuV8UrOtn5u9FtYbGTFl8vggfFz5oAM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IbpaFlKp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783949302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCZwaMJokj8MvB23i+KgfL9s2fF07ZtloHz25nGxCcw=;
	b=iw9X+K3lTUq4KyeHB943rOttI1udkZ7x9KylkMkmdqLmcSQnSK+KIisu7U0/zEjEJuR43B
	GqSipiodYag9khPWaVLRTH2SwAgXyzbqn/nOZpwGvdBTy+PTzT6xMSWAkRscSZtxMfbSKy
	u3P+gZNLKKtRe/+39F0bUETtOzeO9zI=
Message-ID: <03158ab2-94e0-4a48-94d1-df2eedbc5545@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783949300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCZwaMJokj8MvB23i+KgfL9s2fF07ZtloHz25nGxCcw=;
	b=IbpaFlKpeA4JFZRTs7k4EM9meHM8rqNlkc7853eC6eHUK3DbIhaVDMxQ+fem+c4f+dtDuE
	y6OhZo3KMkn3mClYnfAZ9QXDmpNSTEDhd/MA7LJ4NycFEh2iQTAefbclmy+AYROQyxRBxf
	ornndC/2/V47wWEUo6ZTo1CKDrkwRGA=
Date: Mon, 13 Jul 2026 21:28:10 +0800
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
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 622C02000E
X-Rspam-User: 
X-Stat-Signature: 17ee4uqxnzemtqtfoygkm8reepqj8ady
X-Rspamd-Server: rspam03
X-HE-Tag: 1783949302-773091
X-HE-Meta: U2FsdGVkX19dvsm5BTNCUyYaNGsRcr1taIY0TT7V5lspTn8oHEN4Zf/2xS4NLqEwfBdH07T1ioAIz1zckpq63XCxgqSuaHxjnJ5JZae0zPDdRqrQLW4SMF93Ecane7dZ7J69as0MxLffs9D6Hmcdm0Ae6LyGNYnHTh47KNJG1BOxwWCB3xoeOpnLSglD04YQuMFEKMzlqjakZ8wgWVLtmk5dMijOFjiobzBXTA73PBWIa4WhKlJzyK/E1+3TpV0Nnc46QljElRrX0nyWul3J406F49sxClnkpXV2+XA1ZTsDMZ7KrAvQsr6Z3raHQQeEIVeuzK6L6IFNaY/WKF7T6VYGiH1uy+CaNgBxx41z+iyIxYJqfFfiXlnUArhZUmvP0JMfDPt6l3Xl6ZI2KIz4D6ROz+MZ9QeZtJnhsyyiE1jp+DEnLYZxgzPeyE6Hfb2wHrpG21FvgyUxeKCYL6vTs/ScPD9zsiGXPaX+A7Sr4iWiIWLoizTzG7KPotqTBXnGhylI4YQEO4KxNC+LuaBZoNE69SvJAMi4+9Hf714Kix7MRE10pBb4ZwMJTjzGKYBatJsQgNVvauxZ9czArC/Xgdq72EVFkqtXj0tnihpvXgkXy2NnZQJIYnuSqbuvxDrMYI0xr5iMcWxoBZF11m357bFAfz7BhwYtuAA6W83EgaXScb6+yNF4bD3EuM3MWx6oWQfGOvh3Rlyu/JutpbYeh8Zw3JWeYHePt+dHLvXfCuDHDfPb3FcKGz98NJYERbATYiWF6XPDHKnP/0eY3mq5FeO4ApEUwlRfHWaHfVfXPZShaC/d/3lSaNSqrzKu1x9GKbzopcpR5fqR7y4mSU4/YnbW4salsNavE+mKAoErIl3uYKO9u0ITyzS1jsBjJkUsnd8j4Otsm0zMAUxxH5P3lNH4TGwbX43QAiTjVSCL8zMprPijFQM3Hs7W7gLhKNFhRRInp5L4NFY9jA4aIhU
 Ce/FQOXF
 AEv1M2537THdr2mA2D2vNBvBRwQSFX4PnaOwvCSBTD//vHWYv8y7wl/hZBsnx6CDuFAWNL0CRjXRgMssgi6vWH9fBXRLDH3BCNnTWfMcs44akXuZorwSwOrTyX9A3tg+izaYoIqLQWhKqZjYcUqClDpFaCu2gJvbubFDUqiQQnv148de4YEav/lrIxrNVQPF5XctwPc7nd92VS2ZIqDWJ/Y28rI9uS6Eszl0E9gNzv+ywboPY/l/wErfI8ZWPK0S9N031PZz7qR07dxs=
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

An 11% reduction is definitely a solid achievement. While the
absolute gain is in the range of a few dozen milliseconds, I’d
love to better understand the compounding impact. In which
specific latency-sensitive scenarios or workloads does saving
these few dozen milliseconds translate into a major breakthrough
for the user experience?

Muchun,
Thanks.

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


