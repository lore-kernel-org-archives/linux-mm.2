Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001F4109878D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4871C6B0159; Fri, 20 Mar 2026 10:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E136B015E; Fri, 20 Mar 2026 10:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374626B015F; Fri, 20 Mar 2026 10:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 283136B0159
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:42:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5A311A027A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:42:24 +0000 (UTC)
X-FDA: 84566707008.04.82D525D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2AB9AA001B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:42:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9P8c5j5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HH6Sxvqt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9P8c5j5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HH6Sxvqt;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9VUzKgMf5hNdrzdVMsfw7bOId+n7lQuC+5prwGhXeY=;
	b=vQI5QP+j+l5oBQ6Xkb2Xgh4Do/2MQkdEwWgs/UIHldIu+8vCxk8xaliiOZOdCNBeCb1OXO
	F6ehiYYUOlzGeVLQcfGOOAgySuLaJZye+TYuiTTS7Bk+/CAFQcygxE3tawj2Mq4KFhPkNJ
	1m8mH7L5lmLVH7rbzinXMKv9YDlFpyM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9P8c5j5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HH6Sxvqt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9P8c5j5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HH6Sxvqt;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017742; a=rsa-sha256;
	cv=none;
	b=ThFHQTyZoB7bFJ0dqdxgIr6c92H4PyGoxCG8vmiplAoD0V6aV4v0IDsONfT4Jx59nsBADm
	zfRripdmVquNSyyz8z8kGYy0UuMWVp8/a53NaEvxDFX8MiPpOQdDXwv4gmO69G8ORwyu/S
	tgABlS+Aspyg2WYbHt323UlmrajhL48=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B6CF5BDDF;
	Fri, 20 Mar 2026 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774017740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9VUzKgMf5hNdrzdVMsfw7bOId+n7lQuC+5prwGhXeY=;
	b=K9P8c5j5NeE3nZT/QeFabtQCdAeEYNOJe7rdWMgMxX1SH7CydbSDGlxgTCvA2I0pZecwdL
	I3oDatS8dZeW9UBb146AJjojdUWy9sSHRw79fN1yTzX88OjkcbBe1Y+0qh/nxxzLWsMCu9
	81FS/l6Xf071zw5l8JlHwKsuVjtdo0s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774017740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9VUzKgMf5hNdrzdVMsfw7bOId+n7lQuC+5prwGhXeY=;
	b=HH6SxvqtwWwEXfookhSTKVEw/oisE53rm0nNzkZHFPQLSeoTUAeN5hsZDe2gOFBdg2jwsi
	BlujbfenUIb3vOAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774017740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9VUzKgMf5hNdrzdVMsfw7bOId+n7lQuC+5prwGhXeY=;
	b=K9P8c5j5NeE3nZT/QeFabtQCdAeEYNOJe7rdWMgMxX1SH7CydbSDGlxgTCvA2I0pZecwdL
	I3oDatS8dZeW9UBb146AJjojdUWy9sSHRw79fN1yTzX88OjkcbBe1Y+0qh/nxxzLWsMCu9
	81FS/l6Xf071zw5l8JlHwKsuVjtdo0s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774017740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9VUzKgMf5hNdrzdVMsfw7bOId+n7lQuC+5prwGhXeY=;
	b=HH6SxvqtwWwEXfookhSTKVEw/oisE53rm0nNzkZHFPQLSeoTUAeN5hsZDe2gOFBdg2jwsi
	BlujbfenUIb3vOAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AC7042853;
	Fri, 20 Mar 2026 14:42:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3KonAsxcvWnxRwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 14:42:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BDC32A0A81; Fri, 20 Mar 2026 15:42:15 +0100 (CET)
Date: Fri, 20 Mar 2026 15:42:15 +0100
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org,
	r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@quack3.kvack.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm: replace exec_folio_order() with generic
 preferred_exec_order()
Message-ID: <k45xs6btmt62uerbglqe665jozrtkeoklu4rek6odgxjdj63ni@ftw6ef3ug33x>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-3-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Stat-Signature: npucfo7a7hcdng8a7enoi47399jyj4bu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AB9AA001B
X-HE-Tag: 1774017741-931472
X-HE-Meta: U2FsdGVkX19U682FvBwZfa60QgkXI67uJ3KM6OtRAfSBtnOwrbE4MgVyJwHfXWiM4tGCrE0PZsr1hyjO6LnYQPxjNvuqGWGERJhz7XH1MTRgSdzOzeEuoJGCwKQHe0OzqAa0jTEx9fmS5VCk75FxAv2Zgpu6n0Bvrrfkz9G8Yntfn0A3MPRGJ6SKNdd2nragV6HsdghLsOtPFhFigGU0rzLMyR582SRQRzPqouY327u1ZSNw0U/viJTMJFhOM3iC5MRGhOhuRKnyI2zsXhUd9sq3PxEIaKgu65tDcbmXN0nLf9Fe/q9cdroK6gb6jLJkEF1cicmGZegYCnIetfJ/gPiCDlxg/X31w5WCwM9q4becqYIS88WuWxrUSLlAIfaSPnBdmp0bMhG1N1adQniNY5yw9ghc9yYqVL0qO4jVKi6hWdvnXKigBSz347EWHHmmq9DbK1pmQ2mR2Sd/R2vvarqwUn8K1t3rKTesW8zPWKm8Ylp3wzm09zrK+Wg/uRvRCT7BOiCNlzDc9yL9Mxgw51/k2ek6a2e3AcKPdVH48bF6a71837jF57rVbN2zkyCp3pSDYbbBoNKvDna+q+4yS1xDxQfNIG5W1T3qVlKS/N5qSW4lRJ0D4Zs2KddBd4gKMSHVXxe1RaX/KO0Z5+0CurytrZVdnXrkNuUZN2ceLKmprxS8FZtSatUHkB/oUSLxTCyWx9BgcnObSJyioMl2+XEfBdt4hYS0u5wlrH5LxV95RxyUPFvIpDNrOBxLl3s4KP2TQe99tswKCOw6VXyTXfpX/M7/zTbLcm5jE7yghtGHv5c0xl6vHrtaFjzf/6V7k1KWRFcyBK0MvDZjuOzylyQb4aMiiLTvYVvES41ZGJn+pE8efDYeY0eSbanPgURhJphGjgr/MDyZAC5zy+YK5cKHk0N0UL4vSwuDbRgzjDWpxBl5EqsGBMV1J67iRj8FyR9gI9b4cDD6JEcQGRU
 +Ci7roaG
 kthpQGER+i9NBipqyo5lkR/LZVDa5K5P3Js7NtjbJqjnJDD031n2RH3nH4N0qsa5LxiJLyBo5BDXgaxno8OyjuMsZRYw+LD1hxwpDnm3059axUaftx/uSPp6av9H48MrM7+OpB1E6ZIwQ7zerdVTUAKvxw3W0lW3yFKAeXuj4cP8LicN7dQhsKYhikzEoIWtIVtnaY0qCRmLSqYe/3Bbq6Zmlhyahl1BbQhLVd+jhikmjlnNUtM0WCLweMlDAhOGpZeZbU3mTIiVqwY/zrEBXBzV5E6H3igzrZIyb6k4AvdPtfKQncA7Sdoqu4bwzsCYlmpRYyeO4Ig24TuIbmAIPVCh04M7hHKHPaxVjRT/ZuEEdoAJa1wYBy+l+uLnj83+6LC+Li8fwe9Jlb4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-03-26 06:58:52, Usama Arif wrote:
> Replace the arch-specific exec_folio_order() hook with a generic
> preferred_exec_order() that dynamically computes the readahead folio
> order for executable memory. It targets min(PMD_ORDER, 2M) as the
> maximum, which optimally gives the right answer for contpte (arm64),
> PMD mapping (x86, arm64 4K), and architectures with smaller PMDs
> (s390 1M). It adapts at runtime based on:
> 
> - VMA size: caps the order so folios fit within the mapping
> - Memory pressure: steps down the order when the local node's free
>   memory is below the high watermark for the requested order
> 
> This avoids over-allocating on memory-constrained systems while still
> requesting the optimal order when memory is plentiful.
> 
> Since exec_folio_order() is no longer needed, remove the arm64
> definition and the generic default from pgtable.h.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
...
> +static unsigned int preferred_exec_order(struct vm_area_struct *vma)
> +{
> +	int order;
> +	unsigned long vma_len = vma_pages(vma);
> +	struct zone *zone;
> +	gfp_t gfp;
> +
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return 0;
> +
> +	/* Cap at min(PMD_ORDER, 2M) */
> +	order = min(HPAGE_PMD_ORDER, ilog2(SZ_2M >> PAGE_SHIFT));
> +
> +	/* Don't request folios larger than the VMA */
> +	order = min(order, ilog2(vma_len));

Hum, as far as I'm checking page_cache_ra_order() used in
do_sync_mmap_readahead(), ra->order is the preferred order but it will be
trimmed down to fit both within the file and within ra->size. And ra->size
is set for the readahead to fit within the vma so I don't think any order
trimming based on vma length is needed in this place?

> +	/* Step down under memory pressure */
> +	gfp = mapping_gfp_mask(vma->vm_file->f_mapping);
> +	zone = first_zones_zonelist(node_zonelist(numa_node_id(), gfp),
> +				    gfp_zone(gfp), NULL)->zone;
> +	if (zone) {
> +		while (order > 0 &&
> +		       !zone_watermark_ok(zone, order,
> +					  high_wmark_pages(zone), 0, 0))
> +			order--;
> +	}

It looks wrong for this logic to be here. Trimming order based on memory
pressure makes sense (and we've already got reports that on memory limited
devices large order folios in the page cache have too big memory overhead
so we'll likely need to handle that for page cache allocations in general)
but IMHO it belongs to page_cache_ra_order() or some other common place
like that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

