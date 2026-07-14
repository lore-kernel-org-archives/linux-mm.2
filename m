Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D230C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7BE6B0093; Mon, 13 Jul 2026 22:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A9D6B0095; Mon, 13 Jul 2026 22:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB9C6B0098; Mon, 13 Jul 2026 22:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 015DC6B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:45:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71240C01E2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:45:23 +0000 (UTC)
X-FDA: 84985840926.29.D1D736D
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3462840004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:45:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OMJ2w4Zw;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783997121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nb7XE0WKxPNCmW2jzzoEfyvfKdOTIP2EGQX42DdHNL8=;
	b=Qkzf8QxdV8MQmmUkxQlNewaa4aK4ZaU5pTD+SfgqqkUp+ystSm3n6SYphoyTOfCnGEUUAI
	oNbqMS4pyrIubVDP/ytSE268HLV8PINQM7KrvxH3dPXV0L3Ih9ifzDV8lPi+SaObJSlqup
	o3c7I/NUYsXghd1Gnz2BCNSPURPOmp8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OMJ2w4Zw;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783997121;
	b=u8dEDuTrhZoNAlKy9yPCKeEQt3+sJysUQO1V2hKlIGQguAstiqoLs1FxSH8CvR8J3rr3rN
	ppQKtjknEelE1pFd/9Bjsfdfo65+ni4sfAGK4VsWB4nOKVle/sSQPsxFj4NmK36ippvJNK
	1lbngbxfRDUhqB3BBKjsxBrWO5RfnwA=
Message-ID: <993afd58-e503-46aa-acaf-19243b0d147c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783997117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nb7XE0WKxPNCmW2jzzoEfyvfKdOTIP2EGQX42DdHNL8=;
	b=OMJ2w4ZwurgTTryrGfFSYG399nNWFddIFP0IbpfcqzSmC+cengYkbS2Uj3xx2QK/1Pozab
	5yb3IX4IJBBcgNeFk2ad9gLwpxighNPp65I9K7S8C9OjYD3sMQZWQJt/T49WYCKGx5++Qf
	JOHHqjCt1680A1SOSdk8++/jXsNzsRw=
Date: Tue, 14 Jul 2026 10:44:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/8] mm: factor zone-device page init helpers out of
 __init_zone_device_page
To: Li Zhe <lizhe.67@bytedance.com>
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
 david@kernel.org, kees@kernel.org, mingo@redhat.com, rppt@kernel.org,
 tglx@kernel.org
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-3-lizhe.67@bytedance.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260709112520.24857-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3462840004
X-Stat-Signature: 4p7kdutten4qwnq9qwhwie69cmsy7sdo
X-HE-Tag: 1783997121-658982
X-HE-Meta: U2FsdGVkX1/4gapGOz7BlwUkGETIhJXMQHkvjlOw7gg4wA9CaFEkfxfAY6JNgSzY1yxBiE6huFIgBjoxvIujJ9+KFalh9w98VL8j/+1wSKwCy/1RaCdh50fAdlYI4bSsNouIYwkBv6e5mTAqc07eY1pYlMW/Hj/eotBdQxSiJucKH5UN0yxL6yd8r4yQmmql6/gQdmZfj/mewqjizpScjJtnO5Q7Gw2Q8+RgkEioF9hd5JjEL5MTspaGrNcvAxKCn63cwtUnJJgxV/NLqbToarPKZ5Mt+Qc9r0WQtx9zmkE6Pi7a1WTXRy5mgTWTMrXFsamMhy0h7/5rAgCOs6zdM76xZkG0+eoiwVR49DMGmxyANpmJLVGD5+kR8r6CuBldi/AgFCR6iNGDFhK7jDkyzT4wzLH3zq6d3Ks6QHApUFmi3KiW/3bg6b/pn4iKhMnI1UsoHLlX3Ob6JqR75O8tUYuOlyJXJwSq5Bcbyl8IIut3JyGkMTN3h1cp8gh2YGjtkJNmcWUXnuXJdo4kYIk12RIFGlNXpr4k0QPU5w5pe+W2qgCUunwn4An7dNUmnk1qXTNP9xsF36GnxMwb/PWOFZdcurCbuC22Me3Iqq979xoAZYLeQDJPj573zi0J+WQYOlz8G+8L2Ty0Df85mAIXQ4VFzU2Jf0RRahB+DrkARsVcjh/2G+v976zc9jGJqKah7s9MDPrjtLQvB9OLgLs/2iHWEXN1A7V9+/A2CNEvo+s0HoaHPOw5LMYYoWem4ihU6PzatQanRy0APZ9fPparZWPgtHYM6QpeNRYr98KJ63EARTgfjFtxHj9EHhZXHg7Xy88utiZ/YR8//MTM0mot01Rv/DWdjtHRAVbPkoyzRBmLujPUGUIrEY5H4pR3o32UDJ7wnKS20QzwtseH6TTtj5EPkRnPjxEpieSc0H7t7IztqHj9+GRnYmEQMgeL5cROR2Yt/Fu5Wd8rj64X/zh
 ZzOk7NBd
 4rYEJ3JZeQiWzK+CP5SpG2QuiOu34BI52vzRzZrrzksDEKNu29biEBfY7Ht00E/HpY6cl9sOtupv4gY4SbDJWOaSQXVOk5EpOhB2llJnZnL4w6YkURoP4a38Q+cO8c6v6nsDVYVyDQfD8qx84MeoMutknl8hWVG2hw4uzbIrU6eiCUOwpEDXr7kOjr7vzSnwoqRoBrx8ftBfStVjNqJo74CoVS7Y4mXpw7QoyPcPCT8wvdNe+s4qYkfhSABIm/EaNmYqxiVN0qjhOe/C36tzcYaX5KF7lu/NyfyuF5nTgQK7qJd9GH8P6EwqrSZBYhCoEMLsUzSEV5OFhpMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/9 19:25, Li Zhe wrote:
> memmap_init_zone_device() currently mixes refcount policy and core
> ZONE_DEVICE page setup in a single helper.
>
> Factor the refcount-reset predicate into pagemap_resets_refcount(), move
> the common page initialization into __zone_device_page_init(), and wrap
> the existing slow path in zone_device_page_init_slow().

Hi,

Sorry if this has been discussed before, but I'm still curious—what
is the significance of the 'slow' suffix here? I don't think I quite
understand why this is called the 'slow path' here. Is there also a
'fast path' for initializing struct page?

Thanks.

>
> This keeps the slow-path behaviour unchanged and gives later patches
> reusable helper boundaries.
>
> No functional change intended.
>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
>   1 file changed, 37 insertions(+), 19 deletions(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 95808ab5cfdb..5fccfbacf855 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>   }
>   
>   #ifdef CONFIG_ZONE_DEVICE
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> +/*
> + * Return true when the free path for this pagemap type restores the page
> + * refcount to 1, so memmap_init_zone_device() can keep the count set by
> + * __init_single_page(). Otherwise initialize the refcount to 0 and leave
> + * it to the allocator or pgmap callbacks to raise it when the page is
> + * handed out again.
> + */
> +static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
> +{
> +	/*
> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> +	 * the count again when the allocator or driver hands the page out.
> +	 */
> +	switch (pgmap->type) {
> +	case MEMORY_DEVICE_FS_DAX:
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_COHERENT:
> +	case MEMORY_DEVICE_PCI_P2PDMA:
> +		return false;
> +	case MEMORY_DEVICE_GENERIC:
> +		return true;
> +	}
> +
> +	return true;
> +}
> +
> +static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
>   					  unsigned long zone_idx, int nid,
>   					  struct dev_pagemap *pgmap)
>   {
> -
>   	__init_single_page(page, pfn, zone_idx, nid);
>
>   	/*
> @@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>   	 */
>   	page_folio(page)->pgmap = pgmap;
>   	page->zone_device_data = NULL;
> +}
>
> -	/*
> -	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> -	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> -	 * the count again when the allocator or driver hands the page out.
> -	 */
> -	switch (pgmap->type) {
> -	case MEMORY_DEVICE_FS_DAX:
> -	case MEMORY_DEVICE_PRIVATE:
> -	case MEMORY_DEVICE_COHERENT:
> -	case MEMORY_DEVICE_PCI_P2PDMA:
> +static void __ref zone_device_page_init_slow(struct page *page,
> +		unsigned long pfn, unsigned long zone_idx, int nid,
> +		struct dev_pagemap *pgmap)
> +{
> +	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
> +	if (!pagemap_resets_refcount(pgmap))
>   		set_page_count(page, 0);
> -		break;
> -
> -	case MEMORY_DEVICE_GENERIC:
> -		break;
> -	}
>   }
>
>   /*
> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
>   	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>   		struct page *page = pfn_to_page(pfn);
>
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>   		prep_compound_tail(page, head, order);
>   		set_page_count(page, 0);
>   	}
> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>   		struct page *page = pfn_to_page(pfn);
>
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>
>   		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>   			cond_resched();
> --
> 2.20.1


