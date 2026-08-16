Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6E9C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 12:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48DB36B034F; Sun, 16 Aug 2026 08:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E686B0351; Sun, 16 Aug 2026 08:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D306B0354; Sun, 16 Aug 2026 08:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0492F6B034F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:04:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CF4C1C185D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:04:45 +0000 (UTC)
X-FDA: 85107000930.30.A18567E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1813100003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:04:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJnA59Sb;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786881884;
	b=tl4Y0LaVIUYDTOoNkgeUbaNSNfkjbFMrtQ2n7e2s7HnJRCGr1QKxbEfYp9SloDViDvG3XP
	wp2GklQGKEz3fRnNkMT8J3WFQMCRstykJODKSPcXO42AOUEPKBR9TvTVBIo8NN1d7FgHx2
	gwfWVPeTQM2blbDSLlqytcrmjlRKHu8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJnA59Sb;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786881884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcnkBAVEUjmpyOE2W5EPEYw0ee+IwKE8GrSAoYr+M2g=;
	b=FLgGkL6ajKPmuHzAlaUOHXS+2dii/nFZpkdGbqPbblsO13KjMnGo+ny50UZJdGjDuXU/8R
	9Ey/NreJxgFRB3BgX+FXGtRmkI3/d8p98JbXraMtjOhbxSZO38fe+xhzdLDuVVsz42wIWk
	Hf4VmBY0zsiY4Lyg6tT26QjLl136aVU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C35D40DE0;
	Sun, 16 Aug 2026 12:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C6C1F00A3F;
	Sun, 16 Aug 2026 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786881883;
	bh=pcnkBAVEUjmpyOE2W5EPEYw0ee+IwKE8GrSAoYr+M2g=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=YJnA59SbM2V/tctiXXk5aj0gwDKO5k4NwOYPnb3dKchy6Dia81+Z5l9SU2HSqp2Oq
	 3brzwZte3zvXTVzMnIebltAc/hzQ7KBkUNY6n7kZwzr/K/1RP8hX1LCmwO08TT0Iph
	 hXqdbQh8EaJtBQDnelnxF64naJs7ybvmIleWm4pmCt1hhY1XFgM4gbB2PKUGE9gAoP
	 yIOUiFKdGHOB7LNCYvOwoFo/1ZYDz+iMFIvcyHEC8LXG+i5B9dIfAAVd5yaongKart
	 w/J6FnujDLCWlx9wcpngAXc7NmB95J/ZgCv18MkQ6KOcad7w/L0lpuR/PT6Aw4LBfe
	 0rX+Lc0kMaIdA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v10 2/8] mm: factor zone-device page init helpers out
 of __init_zone_device_page
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com, 
 david@kernel.org, kees@kernel.org, mingo@redhat.com, muchun.song@linux.dev, 
 rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260810122057.30447-3-lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
 <20260810122057.30447-3-lizhe.67@bytedance.com>
Date: Sun, 16 Aug 2026 15:04:30 +0300
Message-Id: <178688187038.2799959.7900723270155108493.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: E1813100003
X-Rspam-User: 
X-Stat-Signature: ebybrnmt8714iw3fpqop4ezczwbi9pef
X-Rspamd-Server: rspam06
X-HE-Tag: 1786881883-612939
X-HE-Meta: U2FsdGVkX1/tJ9M/INz0mi5imvz4jHhRFKkI11BvJUS5hwxuUACbdsrBLw2FZbrb//MCb/rRi13PKQe/1B1W/AeZaD76S0vLaQ7ezlYMjDyZz65kPbvR4/QdnsLvSGNjJR2s4/5xa7I+EuG6P2vCYiJe76HTb93D6xEzx++9TjLln3AAmTx7wQ0nC0CXDxr7fg7vsJNWiXcLOc1ULFb3RaM8UVFRvBQUx6qR04td2m5zAPsfERg4oxgfCWxKY/uX+4m/ZC/t+2LgakMjktkFZEfXcAagGo5rdXZV5s9gKC+mIAuhS5/D4rO81c2tFofxyDu7MM/Y7bATZNne9zLklsbJzKIAPuUWQqu/kh27LAu1xy/AKH2/yC4lFpbNPOOFzYCApSDNgJxOJGSpqHSkREitYBloaoH11pbcU2M3unFpXFTGklIkl6FWqqZKpuwzhc1/9Ye6FtlxdW2iw3vbnNhokZPWDJzeCWuAtf0vpxVAhpraAvAbJlTNL/VQ59r/tkb8VkcmqqEkrliSMjQi1vcwVlgg+bD4Dldsp+BaXRF54W7/51w2KWFZctSNx9durRM9wu4COeLj1pp/6/40J0yl97T0xrwZnl/bsXs9U8FHOpCWUfwbIwjIT6/6/vobkPz+WnrePhQUI5qPDo6y5FZo24pAz1gH0BPO7Z2codMpoE5eae5qQOdt6Nel1NE8+qCgzVTs0Uw1TsI6+aZK0W9uvlgmIz0/mInTo2alp2DwF5vS/k5+B5DCbOmmkxbb9dh95DXsRtaROFE0faX3/0C9z7GAcnzYk2eH2v5/BLO2rDamL5ZPeR7Q7jSmj5jj+e9Yg+Kl8sYe/6JwNEvkzcaMSwU9Adeo8kATyh6VSvDkk+3XME2zqH6qX5wgxXXLh1Mc86fcfjTvW1ObSJYYe8zKY1hIDbCvSvSdWQegqBBbIbADEOUBVjAyojxShQQAm1j48uwqKpJwycXLvQE
 3OxfPuzz
 4rdv5g5JT09tWBXGP9dmGtFkbEkvMKTO5zA+eW7AwABpHzJiu4GeeTV+DivXIRe1JejodYCHihL0K9ZNb+8lvxyjF62DUw9+1q0DtFJ2buqBsWE/9wjhrMj9x+GgY9mRlyaPjFD6xG7vlnIckE54A0Usn6RtejbKWicsRU9OPV+ktbjVB7Ld3/CxBf3HxDQvqo90Nbzeer/6C/aJUGC+3WAa+Gt2b+IFbJEBVoArXE6avehHYA0Xkz1j+GrTKl6ynJt2OKVdkNtFoDn0FrUFn6HJQRUOLfdTzkvjZy16l6WgHpG3Zv8eshQM5SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> memmap_init_zone_device() currently mixes refcount policy and core
> ZONE_DEVICE page setup in a single helper.
> 
> Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
> move the common page initialization into __zone_device_page_init(), and
> wrap the existing slow path in zone_device_page_init_slow().
> 
> This keeps the slow-path behaviour unchanged and gives later patches
> reusable helper boundaries.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 95808ab5cfdb..a70acb7431a6 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> +/*
> + * Return true when memmap_init_zone_device() must initialize the page
> + * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
> + * the free path, while the remaining ZONE_DEVICE types start from 0 here
> + * and raise the count again when the allocator or driver hands the page
> + * out.
> + */
> +static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
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
> +		return true;
> +	case MEMORY_DEVICE_GENERIC:
> +		return false;
> +	}
> +
> +	return false;
> +}
> +
> +static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
>  					  unsigned long zone_idx, int nid,
>  					  struct dev_pagemap *pgmap)
>  {
> -
>  	__init_single_page(page, pfn, zone_idx, nid);
>  
>  	/*
> @@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	 */
>  	page_folio(page)->pgmap = pgmap;
>  	page->zone_device_data = NULL;
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
> +	if (pagemap_requires_refcount_reset(pgmap))
>  		set_page_count(page, 0);
> -		break;
> -
> -	case MEMORY_DEVICE_GENERIC:
> -		break;
> -	}
>  }
>  
>  /*
> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
>  	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(page, head, order);
>  		set_page_count(page, 0);
>  	}
> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> +		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);

It looks like all callers of __init_zone_device_page() are now calling
zone_device_page_init_slow() that with series evolution became a thin
wrapper for __zone_device_page_init().

Maybe we can just rename __init_zone_device_page() to
__zone_device_page_init() and replace the open coded setting of the page
count with the call to pagemap_requires_refcount_reset() an be done
here?

-- 
Sincerely yours,
Mike.


