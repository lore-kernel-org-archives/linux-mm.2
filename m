Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F63C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79ACA6B0093; Tue,  4 Aug 2026 18:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771866B0095; Tue,  4 Aug 2026 18:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663976B0096; Tue,  4 Aug 2026 18:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9EC6B0093
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:23:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FDDB1A0327
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:23:46 +0000 (UTC)
X-FDA: 85065015252.30.D33B62B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9FC2140009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:23:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOhYh+q6;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785882224;
	b=cHagU6wsyw8j+LYJjGsy2sTqxSy3s8Xp+Bx5rUSMK8f0E4stLI/D//F7+bZ1/ANYd7UuON
	ZuvVu0fWeSnDyz2H14Gz8A1cPCfCi11OygfuHmRiWtWJLoSmPg/DDm5v2dAwjNPhd/HMxk
	xWU0j4Mr/ZkuC1TCohMw3mAHa7H5Qpo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOhYh+q6;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785882224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDuligrWm3GQ1Hajj0YRyyRR0KMoYVN0stn9doAF0/0=;
	b=ExqTRpgROEEtSU5I5v8WZK4YbeHchmbnVcBNt1ZrRgo3SP01d/IO/wuKBYfLnwJ0ecBI45
	WDItlDGUdQJz2lSggPs1gAvhdotxIzVk0imCwbOvd3pqRlFG/QCp/31B3q6+TGQHDwTyvZ
	4dmtSpg/646X97BTBtzceXqc2TJnymk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AB67600AA;
	Tue,  4 Aug 2026 22:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62A81F000E9;
	Tue,  4 Aug 2026 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785882223;
	bh=YDuligrWm3GQ1Hajj0YRyyRR0KMoYVN0stn9doAF0/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOhYh+q64mgLa9mE9b00qnIiZUBxEnuTjNasZESqshmBlJAbsbKwmaJ+HinFaGema
	 +CZ4odWQIsG6Rjgey50luzivYAivATdovO59sXCxF8tetSYLdbwyzdtzFHiZLmBPnt
	 iiQxpRJ7vsYyMSKcx8Ll1OHbZiWOJm2qRm8eSmxSiVYOuAmXdO9zxMND9tinSfOxG6
	 v4Y0mrFrQNeslxU9zisxnqjDRTXtsJNh4NvVU9Gl5rHdq9PODuJlc4i+RKpcuqBv09
	 LBq+R/Z2WMsMwX8stlPy/ajjNGMHOHGjO/9Y1gdU0DtOw0b2a9X+GMSL4iGFHfB1by
	 mJcs3HM0tBIow==
Date: Tue, 4 Aug 2026 22:23:41 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
Message-ID: <anJmOMqCVugycC9x@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9FC2140009
X-Stat-Signature: fskgabja1iunewqf64b8tn3kgfb7igq5
X-Rspam-User: 
X-HE-Tag: 1785882224-294929
X-HE-Meta: U2FsdGVkX19BW2/doYksDRJOvgbsg1VmjAA9nrOp3MFwr4+nI0zol+uKpdL5H77tckZcQLdtc8S1CVtupF8wig+T40/0aOEYzqJhdOEfEEvv+mpWO/9Q8S/M5r5ncdfNuDMIuMjf+JVKKkkyNqE75webWlCprbHSFzi9UmBAZ0oZ9PWdjqkt7KpZ76cQ//dfOfrDwWij+w3oxs9F03l0KoE6EfHllHkcnaIhf7zDzWlahm+VnCzGDcVYeSA2zLOpyqQWO99/Q7wWmiDqZSGj0/qHan3YrWfdv5lXF3jdp9pVGxpDfbKDhcRtnMN/nKilj8p7PfHvUDdWhLZjHhmg7ONH4+Pm2WEvqAjo6BJBJh/JpPAqKmxUubZUnRbILWm+Gl0Lc/rMx730FGG50ioYrXexYnyMFbWnbM5hyBgNHDUdqVmNzbFUbJm6B7EpoTKXBLNd2/sWh4/IL6A9XCueo1vLp+tLfUvim+qwriGdYyfqXZh4XFzVZhGNZishfZSDJi/2T6rxxP+RXDIqJpOsTMUZFFWd26+Tpo4UXz210in0nnJvRx2i/z5KCBnxMaSRzTBJ+tIaF7L1sVFZgOeWEQtK6DgPstlUvdquyv43L/hf1DXQjaprJz93leu3a6RkevZTcX+B8XF+bpFvkd3JJjC9HooO2prbwI//59GnElBFwrWViP6Q8NbuWk3dEky8K0t7dAM2PZj2l5UdwoeD/ddJMzldw984dsuwa7esCVkgSZZtnk5dsYF5+JGR165rXx5lU5YTDXvOkrGXUozjgKLDH+dsC41p7JAu5ZslMj5+KGsjDVQ48ouWb5NB3dfXbFYIu0vM5kqGNAaD4in5XV0FUc4EMR51Gx/aZ058ae1i58ePMjL6aJvuNCyVlap4g5XpkeTu8O+LDzYnIyi9szXdU2fZgjo0o1nCRM3qnok9hK4VAUQKENJ03gmc9QAvw6bwdfe9JNW6YDzfFcS
 ADWS+cxC
 kBnL2GzP8NiU/QmDyzLpZqz+RZepWOHd/cY3vqCwvngY4xsKVi0aD13T1vHk0LEMl/6GqBhcuYauDoZkGPLHJbqtq6TXJnceRwrUgaN1tcKAURzmBY19cKRkyhysdVNkUaWvpbo30lVcnhxVcHCF77GBmudfdb20oFHXaOOR+D+oJ13RN+St4Gab2d96wh9a+/8I8fIo2rutixMGW16xjYy2hTi2MuhgcWVnjK8HLWqtd9TxMC0mvwU7BKpZqKSwwkUcf4Zqe0WJrmb0W/SVGpoSdRKZGG7utrmz2/5S7ruSg7Mg+S5SrDIHyFUiTMh37hJy21xpPZxowj75QhVQ8Ds+CaT8XVFzl5u0j2cuNNHU3L6cIC+H0e95+xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -179,24 +180,62 @@ static inline bool migratetype_is_mergeable(int mt)
>  
>  #define for_each_free_list(list, zone, order) 				\
>  	for (order = 0; order < NR_PAGE_ORDERS; order++) 		\
> -		for (unsigned int __type = 0; 				\
> -		     __type < MIGRATE_TYPES &&				\
> -			(list = &(zone)->free_area[order].free_list[__type], 1); \
> -		     __type++)
> +		for (unsigned int __idx = 0; 				\
> +		     __idx < NR_FREETYPE_IDXS &&			\
> +			(list = &(zone)->free_area[order].free_list[__idx], 1); \
> +		     __idx++)
> +
> +static inline freetype_t migrate_to_freetype(enum migratetype mt,
> +					     unsigned int flags)
> +{
> +	freetype_t freetype;
> +
> +	/* No flags supported yet. */
> +	VM_WARN_ON_ONCE(flags);
> +
> +	freetype.migratetype = mt;
> +	return freetype;
> +}
> +
> +static inline enum migratetype free_to_migratetype(freetype_t freetype)
> +{
> +	return freetype.migratetype;
> +}
> +
> +/* Convenience helper, return the freetype modified to have the migratetype. */
> +static inline freetype_t freetype_with_migrate(freetype_t freetype,
> +					       enum migratetype migratetype)
> +{
> +	return migrate_to_freetype(migratetype, freetype_flags(freetype));
> +}
>  
>  extern int page_group_by_mobility_disabled;
>  
> +freetype_t get_pfnblock_freetype(const struct page *page, unsigned long pfn);
> +
>  #define get_pageblock_migratetype(page) \
>  	get_pfnblock_migratetype(page, page_to_pfn(page))
>  
> +#define get_pageblock_freetype(page) \
> +	get_pfnblock_freetype(page, page_to_pfn(page))
> +
>  #define folio_migratetype(folio) \
>  	get_pageblock_migratetype(&folio->page)
>  
>  struct free_area {
> -	struct list_head	free_list[MIGRATE_TYPES];
> +	struct list_head	free_list[NR_FREETYPE_IDXS];
>  	unsigned long		nr_free;
>  };
>  
> +static inline
> +struct list_head *free_area_list(struct free_area *area, freetype_t type)
> +{
> +	int idx = freetype_idx(type);
> +
> +	VM_WARN_ON(idx < 0);
> +	return &area->free_list[idx];

Should we return NULL here if idx < 0 instead of an out of bounds
access?

