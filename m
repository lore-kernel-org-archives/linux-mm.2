Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014EFC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC806B0088; Tue,  4 Aug 2026 19:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BD86B008A; Tue,  4 Aug 2026 19:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04AE16B0092; Tue,  4 Aug 2026 19:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA8D06B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:02:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70DAF1C078F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:02:47 +0000 (UTC)
X-FDA: 85065113574.01.599719B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BBDE740003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:02:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b1n/7s+S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785884565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5UncBf9PwoRD0ejcHo6g/DrJr0SQ17oPbMYwAtLhTs=;
	b=Ywf1WbFaeDENm4pEj/VZvcBaL8iCbDJQcRtB23ha73+L/MvcqojhIb5R0dpAJLLItM052X
	bc/E6v8++ZllDhleA4YHtzBhpmLEN0flqq4dYtdma3xqXuEOsjVaOI0YUYzx5XTw7+9DXs
	mXFm+11eDz2DTktRswB4pRKQnh6Y0JM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b1n/7s+S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785884565;
	b=0ShnFcdSCCf0M/lrUBdKEcY16X2FaltBQEi8edR6qZIL3kopGLIEAfRKgiMhT/iC8DC/46
	jAr8LurCPVLTwFsjRqqEuq8eiwgBSmZIq13jxJja/Ehq4090DxrDwHnMWR90LoWcXIJIVL
	E7shuqLJis+wHKEsaOFaEKt6BIKyHeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1562241978;
	Tue,  4 Aug 2026 23:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB051F000E9;
	Tue,  4 Aug 2026 23:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785884564;
	bh=u5UncBf9PwoRD0ejcHo6g/DrJr0SQ17oPbMYwAtLhTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b1n/7s+SUku3EzUeCDV5pq7MAn9cr1oatGCiJRui3LH1bxVXpgnrp1jOzORgPA0f/
	 jvxHc/0YXHAvXxLhwobqqM7Bp60timPVvggk6pD+PEDPmkvQp4q6lbdtQUKuVcJA3o
	 ghTz4EpNp/JjsGf13OXUAYDkV65BeG1vFoTPUGTd/QVysPIoc2YNpwa4LVgKD1cCcp
	 XbFb+ewiW7ssUAKomW5a0SRfnfw717hT9vAsFjVFGLefhyYo50i0MGZPyJxBj+T3mr
	 RWoG+1NRSTkuKj3hgvIPQFRFu+KzsIOMfpCqq87QrHa2uM7cUjxKgKcnM45VKmd4Rs
	 pdU64IKZIEiCg==
Date: Tue, 4 Aug 2026 23:02:41 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
Message-ID: <anJvFVPmdpURs2B9@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BBDE740003
X-Stat-Signature: zinqkbejddaapi6ozrds3homotdrrg4t
X-Rspam-User: 
X-HE-Tag: 1785884565-67974
X-HE-Meta: U2FsdGVkX1+1y7KFClK9F8c0WtLxltiYcuxG4P9sM/8fX9KUIayTJiNsRCoak0ythlLDXAK2QIM5r0//P4GxQsuhsO7J4e2REnDQzGsYuft2bgz2khGWp3q81rdwWD5MxEHbE0rTb72ByGrwr6UwboUPhI8WS5lyCXQXoAAkYbQIaynZeFIx/H6XtIMq2tCk0+ScYWZCCaMJOfDp7MQVCfp0KbBk+bPEiKcbCrnz6dCozqfIGkov6jZZopS4e9Ulfs31+dPnzMortTPt4/qCN2RtM+UTYn2CJze8yp3DGbsFbBXJ7fQcs2b2qrofOnjBV28Rj0SWtCJ5+0QAIiwxZYp7B1Oeyn2kTxTWilaoDxCF6Dy+AsiDsRtSVwNc96+w8n/WZjNWY3rVbW2CHWmZcH1hRB/1DBSMj0cKl49qGVE1dsTot1nhxbfP2SL+y5hYkclWywFMpYtx02WuUAvwAcGp/0lPw/phAKWgNR4N+qpxE5YbqP0h6GWAHeF7o+W1qHvTJiop9FjFwSS9nxUTyJiTtyZBF1uwTwRXBBI7wrgGwdYMe70GH0KdXqX6Kzudx5XeZm7u1uWjkb4ucNqzc6YeDJHTsn3sj5eMJN42T70dC271eE53x1LCTxlkhpSy6aNZ7TwhcRf7C/5e9ljbVfFEjXpPDQ7bOt8biQLU9qQIyOPSDSrqHoPM1YWluHvO+38lDzjtwpigfi+0fA42b0yGWKJLgiWUe/Krb5LAz4lRPI2hNF46gZHmf+zQ1vTsizbiM1TxJqno9R900mrKKyHoUhDNxksB83IeOsXGfwvOnqdG9nwPMqYs9uQmekPBFdWiJ6U4iKEjJ8AzooL+UXc7OpNAbzztkYcHRldrYwifHcBVLMFWdrSvSMTANhTNyS8i2yWjNqnbHfy2Nvq5mK4sdoLcR81YoNKU74wy2cXJClH5SfifGhdn2f9+aZ2HiZWTysCHhgPdH/s8E5L
 uaS5x4JP
 t0r1jQnQVPnA5RfwbftlwEqOxvZYga2TaZLsHaYBnFJ24jCsmryEbHv/1YAF/lDjbausNELCVci80tcTDb298zBFJDh4vKknv3oqXAnnjfCsgzqE//O3kedX9D+gELjtWraNabSoMVMPSOKVAWfNgZXwrQAxwWjuf81cccaFQaOTQpQsD1R1dSXVcBFKXlHMT9WqvlbjauWvO+O7ScGIv4PvY7xSYs9OxPxG2i+KGuVWHpI7ALFNIl1NrmOPqb3qNtg8v+Wn6nUUdhKfaUoaLO0WnpjsCIE4hNOvbJm5h/yxE11i11DOJZMyOEaYckVVQRIbcBpfGlB9abtPTogT8wUDMw/Sg8cslMYRXLn1lFqFzGwO5q0/BMo1Ftw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -3190,9 +3272,9 @@ EXPORT_SYMBOL_GPL(split_page);
>  int __isolate_free_page(struct page *page, unsigned int order)
>  {
>  	struct zone *zone = page_zone(page);
> -	int mt = get_pageblock_migratetype(page);
> +	freetype_t ft = get_pageblock_freetype(page);
>  
> -	if (!is_migrate_isolate(mt)) {
> +	if (!is_migrate_isolate(free_to_migratetype(ft))) {
>  		unsigned long watermark;
>  		/*
>  		 * Obey watermarks as if the page was being allocated. We can
> @@ -3205,7 +3287,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
>  			return 0;
>  	}
>  
> -	del_page_from_free_list(page, zone, order, mt);
> +	del_page_from_free_list(page, zone, order, ft);
>  
>  	/*
>  	 * Set the pageblock if the isolated page is at least half of a
> @@ -3214,14 +3296,16 @@ int __isolate_free_page(struct page *page, unsigned int order)
>  	if (order >= pageblock_order - 1) {
>  		struct page *endpage = page + (1 << order) - 1;
>  		for (; page < endpage; page += pageblock_nr_pages) {
> -			int mt = get_pageblock_migratetype(page);
> +			freetype_t old_ft = get_pageblock_freetype(page);
> +			freetype_t new_ft = freetype_with_migrate(old_ft,
> +				MIGRATE_MOVABLE);
> +
>  			/*
>  			 * Only change normal pageblocks (i.e., they can merge
>  			 * with others)
>  			 */
> -			if (migratetype_is_mergeable(mt))
> -				move_freepages_block(zone, page, mt,
> -						     MIGRATE_MOVABLE);
> +			if (migratetype_is_mergeable(free_to_migratetype(ft)))
> +				move_freepages_block(zone, page, old_ft, new_ft);

While poking at the code with AI, it pointed out that new_ft here may be
an invalid freetype (e.g. unmapped movable). I don't think anything in
move_freepages_block() or its callees checks against this. There may not
be an actual code path that would lead to this, but it's very subtle.

We can add a check to can_merge_freetypes() (introduced in later
patches) to check for invalid types.

But I think we may actually want a check in prep_move_freepages_block(),
which is called by move_freepages_block() and others before moving a
pageblock. WDYT?

>  		}
>  	}

