Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3788FA1FE7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ACAE6B0088; Wed, 22 Apr 2026 15:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D4C6B008A; Wed, 22 Apr 2026 15:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B606B008C; Wed, 22 Apr 2026 15:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7F2C6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:12:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A5E81C00B1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:12:23 +0000 (UTC)
X-FDA: 84687137766.26.CA4DD7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2288C000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:12:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/r2+Oco";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776885141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGVKYKKpt3fqUJPzWGuT7XPO04NRkoaxLUpzTEEjFIQ=;
	b=fvjZH8LvplYoTDu9+FD+cLccsuDc2Qin5bRV42mFBOLbJAuabuA//3DOmF0LJ/yEN5NA7T
	gSttfvI440TDx4R7Rp6nDyck01UXsL+dkqZ2ZMll+Ernaw415e/NlTu8Pk3SREfTEBMAEO
	Oyyy8P1mTO+SJAqMn2uA6rZR3MJtA1s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/r2+Oco";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776885141; a=rsa-sha256;
	cv=none;
	b=iGVHCKcwkFwr3gx69gTPT1vZuCUqZh5s1mDbV3+Z2xsyIBBvJDVo1xEPI85LDiWkMNlZjR
	Io6yrls9sbvYuFYOgWD/pBjQiiXcGg05HIH/l9S6Xv+jtH1erYpeIz6In45WnbffgIBkpN
	TJAcP5rPr3AOk8OZEnwMvH7RYXEKKs8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2559C61863;
	Wed, 22 Apr 2026 19:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41490C19425;
	Wed, 22 Apr 2026 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776885140;
	bh=soo6QUGKM77sfvtH8onoPyYjoKLrihsrqjzIxYqu+FA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I/r2+Ocol0HVb6piUtmzScYnaDu6PTEfqHd1Ph8H0LIzUEXxcGrm3jONjMYaoW+x7
	 VlldFwjZWbZwe+dwXs2BmDRzMib1sV0yrkmpbtg6h7xK1U5TQfkY8F/OwcSiO2Hdcz
	 gCYCcs0m+kIBWh70H5m/ELxl8dpZxrIV/PwPXtxKbGhtCiVtqV5cTVj8nueQTprsLM
	 7+CazLdNqTpMdp4HI+VArEHAncvIsQ9OctzbWOxDFRGgQspQCtklZw8XX5vI+rCwhH
	 9wH3U7OK/0H5ADnjadagi2LpyhIaIM88uWjtb98kVuRwiu9Ci0DGr62tqCPhiDHbpj
	 CcK6cXwu0e87g==
Message-ID: <229d2191-afd3-4206-8ccb-002f93d2c4c0@kernel.org>
Date: Wed, 22 Apr 2026 21:12:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] mm/mm_init: Fix uninitialized struct pages for
 ZONE_DEVICE
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-6-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422081420.4009847-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2288C000B
X-Stat-Signature: nfr493cjfp4aipaei65bd9fhdrexw5tg
X-HE-Tag: 1776885141-858540
X-HE-Meta: U2FsdGVkX1/5vyiCgerLu6iojMkb5x5eSakuKYAGoTYsB6Gv1MZwqMg1376MaEzvfEr3bXldUc6j86P7jxrTXYXMli/iDLxrl9fPCfsR1j0pCMc86Gb6t+xvSpzcTZVpMlr9glXZIjCJcD2PNcE4izqAVH4wM9VsyUVVfwQo92OzxYL1IYOLrGYR4a9rYnvfEAgKBOqfxU2uqWr4OeL6yACs4UrDM3XcdH17WzYjuL176dsz0X+RuVxIwL9kAfiQvh3YnFpWU+fbU0+CimNg5dgbQV/kfyT25fu6DX+Qn+AdolIWtMU9Fv5KyX5jv1CvMbZoVGvDFJouVM+Mpzs7fReW0tL5EhPelKHMDX83peli3mpmyaYP9crG/2tiMvC6bB+/Af6twm4+uZxwegkSeCJ9jMdIZs7sYUVVCFvBW86n96dTMiWkfRknV3xopVbyCfpFT7oVG7Ik8aMT2VsZCtfaubEgeS3XNBGD3IrYcM6/sRWjI6X2WaEQVBhu5ggvWQvGWMONXvEqytEbMnMn8HM5anufnG6rT0pW5JZDFe+X0uE6q3KBXbg/hF4DdB2o3XJc7C15LryfFkypMzBZcpujpgRWgNv0gnhmlme15JYYSZeEH0ULiCUFkyn/MOKPYyAbNl2Ch/Y7IpT0Dxe+cecm5K6g8Q9El2H3dMyfNBGhwyiOm+S9ly9jX1sKY7HhIkBTcVCl+tIv3YBYLDXL1r7EpfG/cUxT85v58ISulAYW8f76O571OACxq2VO61hbeUcsSfs8NTi6lWEtRKtc8wXnmrpaN1jNUgy/Q0KcBLVqHD+/ZzDmfpHQTmbN4t+Qt0GItc8zQ73mQR0NEAoc5ALLHa/dLExj3jVBiID1ilaqvVqPXPobFvhz4vCzEmmQL4VX7+SHQQoavW9v3Yob9qWMX8x6gOiJTCVq9pYQi5y7Ad4IjHHR/TekfV2RTkcz2NhEasxsey9Pi8h71j3
 lasrxAdM
 mPjjTozuMgSFd7F3UMjt/mxoOZVGBYuwjapmXy9uGtVETiZ5sIMAcWtPhx6eYVELyeNHIem7AC3uUfvb/SPZ8tgKu4KW54G0KFC5lSVswaRUA4EMr8BBTkUsMyHZTSxIJKniidVgnGH5d71ePUiD4dWUCPa1cCoGrrfCE9FBq+xcWLdi6Wt+8vAfIAbYg0LPNSoKnoQcwJa+J8kB8JTEP0sGj+NTCraKsyE3mMWoGdG1f/+g00pUhJIRyRG3Cu9/y4n53KM/TmF11uDdLGp7xjDUqHbT/lMSjowjVThV51jIISjeW+ZmSby2SIbS2PnSWX/UD8IhosCiysIcyOg5cOJEarVuufKvOngjQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:14, Muchun Song wrote:
> If DAX memory is hotplugged into an unoccupied subsection of an early
> section, section_activate() reuses the unoptimized boot memmap.
> However, compound_nr_pages() still assumes that vmemmap optimization is
> in effect and initializes only the reduced number of struct pages. As a
> result, the remaining tail struct pages are left uninitialized, which
> can later lead to unexpected behavior or crashes.
> 
> Fix this by treating early sections as unoptimized when calculating how
> many struct pages to initialize.
> 
> Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/mm_init.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 9d0fe79a94de..3d5af40d0943 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1056,10 +1056,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>   * of how the sparse_vmemmap internals handle compound pages in the lack
>   * of an altmap. See vmemmap_populate_compound_pages().
>   */
> -static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
> +static inline unsigned long compound_nr_pages(unsigned long pfn,
> +					      struct vmem_altmap *altmap,
>  					      struct dev_pagemap *pgmap)
>  {
> -	if (!vmemmap_can_optimize(altmap, pgmap))
> +	/*
> +	 * If DAX memory is hot-plugged into an unoccupied subsection
> +	 * of an early section, the unoptimized boot memmap is reused.
> +	 * See section_activate().
> +	 */
> +	if (early_section(__pfn_to_section(pfn)) ||
> +	    !vmemmap_can_optimize(altmap, pgmap))
>  		return pgmap_vmemmap_nr(pgmap);
>  
>  	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
> @@ -1129,7 +1136,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  			continue;
>  
>  		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> -				     compound_nr_pages(altmap, pgmap));
> +				     compound_nr_pages(pfn, altmap, pgmap));
>  	}
>  
>  	/*

Nasty, but yes, we cannot really optimize in that case.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

