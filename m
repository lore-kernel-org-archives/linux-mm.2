Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C68ADC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67CF6B0095; Fri, 24 Jul 2026 08:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B192B6B0096; Fri, 24 Jul 2026 08:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A318F6B0098; Fri, 24 Jul 2026 08:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D40E6B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:34:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DD52A036B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:34:15 +0000 (UTC)
X-FDA: 85023612870.28.493F8EA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id D63494000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:34:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fwRUj95j;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784896453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHb3eG+eg47H5YO0KxXiu0C9/zV2I23bNqZBVHabCyw=;
	b=BIAsUZhrqtEJ69t7nOf4Qp0BiPCxeSGymyBc8OZY1ZlbKqCeBOOWDoTHYUM2P/wqsOCmAK
	rx48z2fjn3Kj8a/x4C4jEr+wfKX1bGgeURYcv2/UluThoNgWLLW7JPjMN1wWXPoNRMSWVI
	incEltXNJMrI12R/fxvSQFw+Knpb9Pk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fwRUj95j;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784896453;
	b=MOnTvFzsBUFblSsTtXP/w8t7YUyhNKpGifdhdRzHnBq+s2C9YfcYYUslCqvvPZ56pEAA97
	Emx9WrZ9Xamgb7q4x6cRJzOBdPKrGJRRL7i/ihjNKM2sNQCsGHuygm8iJvKTDEsojCAdMl
	S/waKVYu6As8WeQ1SMrFhw+5QtqlECM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HHb3eG+eg47H5YO0KxXiu0C9/zV2I23bNqZBVHabCyw=; b=fwRUj95j56RO6lhoEW7vqtAWZv
	mEWA2xgYkx2aWUlUxnnpDRxIKfWJMPvFf9Nhk/0Xc8FT0h3zKA/UTsp867EW8Tpj7jMA6O+2QLDZL
	X8+wfV4wz45J5iGq5eUPdjr0v/UHwDHCwF6OpiE79ZgwuW0csjd6813dfXTy/MW67drFOANZ4AYRK
	sxiKWtAIXn8yFbMjXL4xHj4ndiFPXuBBzLy6pnRyJ9b3uf4F+C5G87iGF3tNTrA85lA2cdI9PnjFX
	x5hvdrYUJsbX/CrslwdqOd4pahYzAJq14M1ng65HN16yQ/i7cEwL36yHoq9r0KaY8YT2zZW7wdAS6
	ixNbRn4Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnF6Q-00000003Sfq-1Yqa;
	Fri, 24 Jul 2026 12:34:10 +0000
Date: Fri, 24 Jul 2026 13:34:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 02/14] memory-failure: Test the page is hwpoison
 before taking the mutex
Message-ID: <amNbwmd6mV9Fte3V@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-3-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D63494000E
X-Rspamd-Server: rspam01
X-Stat-Signature: 591jzqcbn3u4ni6jgzod36z6fjdigxxp
X-HE-Tag: 1784896452-243753
X-HE-Meta: U2FsdGVkX18x380sKDA9azRwahofpVF7d4JhjoRpJ4M7agnO8MEOoR16bvptHFcAtHsxdTIcY4EsE7QBJhpTA0vpwyfOV4vptjmXPxMG1T8vwyAQm1l9foDIVnaaO3aN3u77zZmUQtlE7bI5JIYswk3/2pRTJ0jcD0mnFYsN7cI4lcMuburDpOTvldbd5hf7xb5kilvAZRhrZfkNNTqYPo6qx/TfflqFJpLXxSmQydVTlDXcEYSgUEp1NA/nShwRRH53tNVn6bASLRmeslSPsxb7yAMM1qwjseWMPHjRVyeuaKjLovtWwSvkRB7Ep8+g7TbxRcHkRzQXSOVrB0+MW4cECkJmGiUPUXlCo1/p2cQJjvBndo2CevQyO01lgzffz6DXFBWiJAiNv/vaz5xdpqWmFCnktxpPVj/UwtHXs8+D/P+x8JWnz9UuIadKQMGyzAqn5imCLccE9FuwJzBz0W8FNJ3ZQ1NipYzhqdw4Jy0h69eC0tr/RvmbtFlKwNgqAz3m+Abnf/yzgtfg3ojKEj+qaG+kDfLc2CSOSLrQGRdDHU7/zeRo38hTWL0QjnAGtMd71hijt5G25G6A3BzSC9UDdvszBSzYljXUAXV1nS7idGlYebDuifg2NMs3eDpe9K9sgBoEnRwc/+JTpuJfalZHK+tesgFRZatLaRLaGLKZByfsoLQF7gGTEn78eiMXfR7r0PI0I40DqJefdqTCI5646bvnGvPkZ5jLfXpiXMwsD3QCBNW1uWeK1WvtMhMUflQohSROe5Kc6/7p9xgSd42FvuDxgdR8W6gRQdZJxmyjUvly5AQhhlV7hScoetq02JkQwaCTIM70HolMIA78GYlxo6fQU2NmA4WKHW0DmTEtgn8gRWiUL/oVdXk3SV78EAdUVZrfIYHsJGfC+KtxvZzbZO4YxAwK5yu7MtBY+pTfWtcmKu2xbUEVLf2DTkh3o3ZnxgVZN8ThB+CvS9u
 Fef3h/bU
 6JDWoa13gRswAD5vQNb5rSpe9FZhF9VYkDtHjcSZ0TZiDq3bDEc/uwuC7gtEyLNwXrHsYhcCz6hKZ1xOkm02KULvaKUWvF9QCN0fcUIchK/6ZJkfG1tTweaRqvGplFIZtTuHSP+2c+DTGlRzP5RVAU4N5KoY96l26QUH1SF3rGAbSfgq/zVrbrZ8MNRHEOBN7U0wLG6Jnb6giKhC0NNeHmI07WiXBxIGvvSbd+SbJsRGx13lBzzMhH7jC9Ln9BNwhVn2Me0iiFn/qJhLQ+r911LzB5RCV/ftfIM8al+QUfPqgxNo4FVujblY9bJO0kwwaysQyL3IftCt9mm5i3iJlCNFUlfgei8gaFNAdMYfvilGOBXv6ojpaOeJDrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [2]: [PATCH v4 02/14] memory-failure: Test the page is hwpoison before taking the mutex ---
> commit 1cca344401408425fcfd4ca129165f85229f9227
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> memory-failure: Test the page is hwpoison before taking the mutex
> 
> This patch moves the is_page_hwpoison() check in unpoison_memory() outside
> of mf_mutex. This avoids synchronizing with memory failure just to filter
> out pages which are not hwpoisoned.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 944e6e1d49719..3615ced0a11bc 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2677,7 +2677,12 @@ int unpoison_memory(unsigned long pfn)
> >  	p = pfn_to_online_page(pfn);
> >  	if (!p)
> >  		return -EIO;
> > -	folio = page_folio(p);
> > +
> > +	if (!is_page_hwpoison(p)) {
> > +		unpoison_pr_info("%#lx: page is not poisoned\n",
> > +				 pfn, &unpoison_rs);
> > +		return -EBUSY;
> > +	}
> >
> >  	mutex_lock(&mf_mutex);
> >
> > @@ -2688,6 +2693,8 @@ int unpoison_memory(unsigned long pfn)
> >  		goto unlock_mutex;
> >  	}
> >
> > +	folio = page_folio(p);
> > +
> >  	if (is_huge_zero_folio(folio)) {
> >  		unpoison_pr_info("%#lx: huge zero page is not supported\n",
> >  				 pfn, &unpoison_rs);
> > @@ -2695,12 +2702,6 @@ int unpoison_memory(unsigned long pfn)
> >  		goto unlock_mutex;
> >  	}
> >
> > -	if (!is_page_hwpoison(p)) {
> > -		unpoison_pr_info("%#lx: page is not poisoned\n",
> > -				 pfn, &unpoison_rs);
> > -		goto unlock_mutex;
> > -	}
> > -
> 
> Does removing this check from inside the mutex introduce a time-of-check to
> time-of-use race?
> 
> If two threads call unpoison_memory() concurrently on the same PFN, both could
> pass the lockless check. Thread A takes the lock, unpoisons the page, and the
> page is returned to the buddy allocator.
> 
> When Thread B acquires the lock, it will now proceed without re-checking
> is_page_hwpoison(). If the page was concurrently reallocated as a compound tail
> page, the speculative folio_ref_count() or folio_test_slab() checks below
> could trigger a VM_BUG_ON_PGFLAGS crash.
> 
> >  	if (folio_ref_count(folio) > 1) {
> >  		unpoison_pr_info("%#lx: someone grabs the hwpoison page\n",
> >  				 pfn, &unpoison_rs);

Uh.  Yeah.  I wasn't thinking about two simultaneous calls to
unpoison_memory().  I'll just drop this patch; it wasn't important.


