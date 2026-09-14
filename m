Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 466D8C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412186B00A1; Mon, 14 Sep 2026 09:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2936B00A2; Mon, 14 Sep 2026 09:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9DA6B00A3; Mon, 14 Sep 2026 09:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFAB6B00A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:18:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5B371C0071
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:17:59 +0000 (UTC)
X-FDA: 85212420678.02.DC9827C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A324100004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:17:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kGLG3Uvc;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryZp+b5lHOOaK71b8cOGv9AYhxPgaCA4kh5MhWC7qHk=;
	b=tgqUzRPOyMgcncD27wISScylds0abjs/KMFJ+4/OUqR1grTItQE7YUFWZyUPy+dKZWQw1g
	hd3qSpIl7WEyb/FKVF9lvQGPPFZ7edaX92HtRaIeOT/vr8Ps73sgFW9fm4C2RIs71QT34T
	LM2H4Tca2MOPLSB1FHKsH4uDSLnbbHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391877;
	b=a9ZqBIOZ3NWopFUQ2ynaKxCrViWki9qbqe04wcvNpBQZsB+u9myv8UFGDEBagkbr5OqYhM
	614XZPUMMTKfPGAYnrbkv/B4qW3d01hMFPknuar23yIlMMEKlYnaNaZwtKgw7PUciyLgm5
	7ece+o2NXjLn9XrqnNZmNUKOsw4COVM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kGLG3Uvc;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ryZp+b5lHOOaK71b8cOGv9AYhxPgaCA4kh5MhWC7qHk=; b=kGLG3UvcpYO8+lGCRivjKcmegB
	BhmxwnHmmBjpUolfMaDyfdXhr4eGG8HSIERA5Izpd0gzF7vwO0KgNvFhrD9YkjLbm8khQQ6ZoQ5Zt
	92KY/U5PY7MVR5pEAKEze83DpWxm4Gb5MAz/DE2U0OXMBkjrGJ9brJkzjxgYh+RiclECcB8nkJMMI
	/fKqfp2Y8wWoJg5DCDi+bcflnE8GtalfmjeEgTZXqeW6wLSYwgjFeZv1ArHvwZKkr4FrKHI7N0LZ4
	TfjeJ3iEpF5NuT5P0tDZ+T1Gdv3yAj/ElD3YLuvuWQUAe8xdZWG15J8RmjLzGxAVs2QHbFwP3Tylq
	FtwXOsJQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x66ZH-0000000B6lP-2eHt;
	Mon, 14 Sep 2026 13:17:55 +0000
Date: Mon, 14 Sep 2026 14:17:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, linux-raid@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] md: Use folio_alloc_buffers()
Message-ID: <aqf0A22W4MHXD9wG@casper.infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-1-willy@infradead.org>
 <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ui5yzogatzegq7axrg5d8c1ji4ncu6ux
X-Rspamd-Queue-Id: 9A324100004
X-HE-Tag: 1789391877-673652
X-HE-Meta: U2FsdGVkX18VZJAnylKFnTp8ij/DdfkOfBW37WXj6v0wb0L1H9mnBl5xkqhpGKOrBR6eJyDvyUZCtklRaIO9ae0fTY4Qgx+vZO46ZMUFgjBtoWjb/3iVtxlRJPCnru+GazMWvxvAImz7rHuvgpG5XiQgijLQPSUPW5Xray7y/0IHGfUHG6b9VcwTcXSz4SavQAnw+ZbHpZCgBJALLL066fQWGAQNSbkgEP8gWCIC0AZAHpNVEG3pin5546Obf08NMtqbmldHk5LEK4yL/ep0ZHxHj1acvT/ZQBObHBaToNua9pwDbVpqU2lr72s3T9fUUj8nXgNqy59A5DZST5C9Edr5lWDKJyTQzlThvJvyPrSw4K11MWxuCihqAIntjX2u+0/Z0rq+C7iPoi1cpIn584Wk6i+XxPSZo6Dy5Q66VjWPOyBIi0XzEQQ8JsAEeBPEbmLqd3yMILQLrTPnLgd94UP2QlAhaUqHtneA0b9C+KwN3FVa5dcTXbgknztUftqh4DhYcRQ0Vos1SecZPO8NAm0iULpN8jpHOqV1Ft+YN9ERBu4+UopNTdGOLlseJxPG4tztjJS29obSbZ7ZWIwfQaTt3ZWrzYjjYWyVOm14GTlqhslz4UO7PFe2NE7gJQHpwXdv3DLPTdvG/80G5DSTWkso/fK3xdsCsQw3/zJGeC/+nsQDosknIaG4bfzyIvtLy2JiuOYQwBS8KAgHPlA3UFT3NXv9M6tqvYPQ58LdYHXrsSky2TUHxTMhIAuYvdYTj6Gh9H+gjLd4N4AmdOmDV7KvtbFpGHT7Vev2QVVJVrXmcOveufMdVVB6366jqCAOMkT8JPI42Iz4KiXbwlwDk7pEfKuU8I6KpF7Ds6wphbQnxPyg77jPdpqa/4TlrzaOiI7J5YpSW2HsanWbWQ3X5cA5OTOK9symt4LBu+wcERyH7U8GTlhiVm1an+MbjiPjMgDYbjmljvX2OXIV4L4
 FhPWsV6T
 x8L0ItpJICT5xDIi8Q/1AS2zMuW+3jJHcqR5/t9rbXVYJiTs1aWRMCkp6//3lOq3URG81Ee5Glmb56lVKG0MBSeb/Rh7sVmK0EvRCr7ZQSMvqovGkC8LS3/EYlHBSCWXHO663HvxFl6B6YS3PZZxvyjWY0t5n7FuF7fZxqdE46zCnPRzMJqkFAffIbGB3JHP2cfUEdX3+AR4jTuSO+3u++ehJ5RCTmLBlrgg24bvfH0JxahA/2lJGbUIZF5I7r5ZfWk040iye/rDS491QgBebvGzFvQrV7lgxlxw2m1+A6e+TRZS1DlxgWWKnuKVpasPphbGY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:12:31PM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
> > Remove the last user of alloc_page_buffers().  This isn't _great_,
> 
> You should tell us "why" this isn't great.
> 
> Because we're allocating folios although these things are not actually folios? I
> can only speculate :)

Well, we actually aren't allocating folios in md-bitmap:

        for ( ; pnum < num_pages; pnum++) {
                store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);

and it's not clear to me that we should be allocating folios; they're
internal memory to the md-bitmap code that are never mapped to userspace,
nor enter the page cache.  But they do have buffer heads attached to them.

The md-bitmap code probably needs to be rewritten to not use buffer heads
at all, but then I hear from some people that it's scheduled for deletion,
so don't spend any time on it.  But I can't find anything official about
that anywhere.

> Code itself looks good.

Thanks!

