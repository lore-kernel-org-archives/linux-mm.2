Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA2CC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB676B00A4; Mon, 21 Sep 2026 09:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CC66B00A6; Mon, 21 Sep 2026 09:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299636B00B3; Mon, 21 Sep 2026 09:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 084CF6B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:09:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90CB3A4499
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:09:45 +0000 (UTC)
X-FDA: 85237801530.07.8027895
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 01B8F4000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:09:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e13sQNVB;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789996184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BEi9bnupk2tGkEwUZeOZfddlvvx1uRhC2R2hXlT/kw=;
	b=sHbZS3jnZDqjw4i1H4eTq5212WurYvT072OwXq7nXAVi5uUQxVdmuW2+5WsN6ANAFzZ7Ij
	OaRxeXKTcPxuwBQ8POOGUIL8I6ehOC3oZzAtw2NNSseUHqqOMl8JYGexBV/xZCxUwyle8O
	3ru7jXymCsP3jiBP2r0BGUMYPY4VmbA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e13sQNVB;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789996184;
	b=FjuHjvbuK6cDKGpafqSbXFSIjdUdNEMwYWdesNbgaWr2tcltcJ37CPawxm/+/PUbhVlBID
	NcZ2gr/5AyWICwSpyHbgwlYxquZGxKTwLIRZMtPVnyReU3mS6dEY4OvUmRHN60Qd1deW6B
	xQmqRHLam8GOQWGicAWXwdQVl3TETCY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AEF2600D1;
	Mon, 21 Sep 2026 13:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B921F0089A;
	Mon, 21 Sep 2026 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789996183;
	bh=7BEi9bnupk2tGkEwUZeOZfddlvvx1uRhC2R2hXlT/kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e13sQNVBQ80LOFKn6Ix6ZyO14nn7uPNK5BQjitRo7n3ax1ueKz8MjZiX0bZgbrBvP
	 fG4Xp5Ni9rypjZmCg7K7CGkosry3KmKqDILW1r97oHAD49pakCTY7H8Gwr3ekRb8pj
	 rT9KFIaqi44ROkVlFjypQNYXkpe9f/liIPbG/ks3gnOGLQ5oMSp+jkNNOGaAPJTRXH
	 M+HRGr9xRrl47i3MBwIGAwc9nhhyNvfwQkWGujxMsJIOiBSasO862KfnqxhXQUCjUe
	 exKEzyygUfkJLu/WDJms7Lh7z4TZHd5PsREH4VkR81sfgud3+g1MKCrZH5udQlUbko
	 jcju+hpfy8+iw==
Date: Mon, 21 Sep 2026 15:09:35 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Message-ID: <arEsjy0QwLekLVbf@localhost.localdomain>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-4-songmuchun@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: ka38s8aem7w7kjjaau4jbbeg6xtd6xih
X-Rspamd-Queue-Id: 01B8F4000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1789996183-170369
X-HE-Meta: U2FsdGVkX19F74ullnKQzqdZtTJW6ahkJqumbJXFcsq8aA/XOLunRdVlbaF+mTQNDD2M257Td/oiMc4y8OwI2iRsNkt8IB3NQCqhm5Cce4kspkD16o+KCfMdGAihfIxYIXEZImboKhnTtVqSVhYDEmgQl6VclksKfiFSMu5R5NgPEBzLBxnQZdwCRsvh3n3ATxvxAb7YAE7ZbGQaKvS5IaRrmVc2m8xG26iWBtIyy645MUleL06FUNhQgsLJTbug0IK4k7NWWEVMbVfAx/WZ6vwDzEqolEyTP7kJ1ugdTn6tZfc8QpsTm9x0bajmMiN4NABCThmgmQ0cMGmfRNhy8O9eiLPWskWE7s/dO3VmT2Leyvej6hIWPzW1iK6KKqANo3rdeNX8ToToI6AN/6fS6vfQXjFhayIegPg3U8L18z0mxN9KfwTW4NEkuEm8MkjYEMuw3RzgungIIOW+SzSOsppmSAw5SMXK/cZ3AjvEbulgSZ2o+8jAH7WxgrV3DAhMYlEa/4IlXAu67wKoWx+/1Dir09N1Y/jP+dBKfdyEwimT88p6e2Yngok0OXxa8Gqv6WCDL22MhY3+Ac8Cpv2ZqibWjS+gi+87CV91+Sb2hwMV35vRmT1sjAEPAx7kuxCbFoCLwcu+yI6UxcP0bLzwdZFO5Lg1gnsMQ0ZsUkzPv1Dv6dJBHUxsbbJMYGBvQKG1/ElXTxRDTc4bwfJEAfhHIeXFPXzUMOe2az3dGUB9kshFW8aMDAOYV4Jtpse/3TbLAaPuCg1Lb2WdlUrXuXywfb21DGlJ37sHaqz8g94o8VDPdcDZ3HSOYdLi6o63xCrxZsu19yNiw93WMIfbg7MlU1jvejmV6iza0F27iRMiFrm1T1tDwe+z1449wftrgdiQqEenxipXVzqloxZk/3AAfMCK5BAmUsz4Je+ApUQe4mqrjudfiRpRkINuoOls5BFBt/b6h88l0kxaLY1XRvK
 7oInoBtZ
 1I/pPiEr8BvMKT3LHiVk/bngULxZxePCqbzXy8QtmmmSnNUwLtFn/ChX3K56xZLKO7qAvqlVOh+ziZNOKiwyaTNnLrDa0Ab5Lq2Zq0c2WCHoiXV5IzhNnuKs3ItwxP/9mfnS144MF52gJOx6qyMsiAya45JErtpjiGi8aNox+j9c6AQgmUdOM0buUecaZsi5ZZVYbQyuBumBPVtY3X5vPAE7hwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 08:21:26PM +0800, Muchun Song wrote:
> FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and the
> kernel normally allocates and initializes vmemmap storage for every
> advertised PFN up front. Sparse pmem images and workloads that only use the
> DAX direct-access path may never need writable per-PFN state for most of
> that range, but still pay the memory and initialization cost.
> 
> Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs from a
> shared read-only metadata page. The shared page is initialized with the
> common ZONE_DEVICE and dev_pagemap state, so every PFN still has a valid
> struct page representation while private metadata allocation is deferred.
> 
> This relies on sizeof(struct page) being a power of two, so each vmemmap
> page contains a naturally aligned and repeatable set of struct page slots.
> It also requires architecture support for runtime vmemmap remapping,
> because shared mappings must be replaced with private writable pages before
> a PFN can enter userspace mappings.
> 
> The initial implementation is deliberately limited to a single
> memory-block-aligned range. That is not a fundamental requirement, but keeps
> the registration and teardown paths simple; support for multiple ranges or
> less strict alignment can be added later.
> 
> Provide vmemmap_materialize_page() to replace shared mappings in the
> requested metadata range with private writable copies. A later patch will
> call it from the FS-DAX fault path.
> 
> No caller enables the mode yet.
...  
> +static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
> +{
> +	const struct range *range = &pgmap->range;
> +
> +	if (!is_power_of_2(sizeof(struct page)) ||
> +	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_VMEMMAP_REMAP) ||
> +	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
> +		return 0;
> +
> +	if (pgmap->nr_range != 1 ||
> +	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
> +		return 0;
> +
> +	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
> +
> +	return pgmap->vmemmap_shared_page ? 0 : -ENOMEM;

I yet have to look into this with more detail, but this caught my eye.
Should not this be a best-efford mode optimization? So, if we were
unable to allocate the page, could not we treat this as a normal "cannot
be optimized, follow by-default procedure" ?



-- 
Oscar Salvador
SUSE Labs

