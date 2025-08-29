Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057A9CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 17:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFFF6B0023; Fri, 29 Aug 2025 13:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A356B0024; Fri, 29 Aug 2025 13:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F766B0025; Fri, 29 Aug 2025 13:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E39FC6B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:30:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FFC91A07FC
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:30:30 +0000 (UTC)
X-FDA: 83830484220.27.2975AC3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDEB818000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:30:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tZqIHtUD
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756488629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCnwi7hBdTi9Lh8Gb61zJHK72gik9Mk0jx0n/mFZRn8=;
	b=SY8NQHQfVMVv6H+zqvqEYXUeaxAodFe0JjAhACLf4S60FdaBbILFHVqf3CFKqH4puRYy9W
	fnkPll5pWwOV9mI3e/YrI4ay9ylvbPW9h3ueoA5t9AryrQ+SZElqF17qwVsfqE9EW7LCrz
	CIWT197sBqXErgclwIqVRzBaOK6dxyg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tZqIHtUD;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756488629; a=rsa-sha256;
	cv=none;
	b=q3JAFVJvqlIhRr4I0xfx62HEbN14L48OOtC4DlJZKZ+3OsE2zGRh8GgtUN1KrQtaVpoG1Z
	JscfZ3zgeyya2Aa3NcB65iDoOnaucpAaTTYu2vq9rapkSmpB7APyDWfoTH5bE/+cJJg7za
	hBAGPZuPYOO/7So8DSJLZlcHYl7znBI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tCnwi7hBdTi9Lh8Gb61zJHK72gik9Mk0jx0n/mFZRn8=; b=tZqIHtUDsO+w1hA2Jdo98m5+K7
	rq6eko7lbspXOIW+5wFBiG7lC5ZAbeVUsn/YhWJA4Q1j9l+wFFeBsM9m6XQB8e4ehQ8YpHPuU4a6E
	WOqkI12SgMWzvdeKNJ1VR5QpN6et0ZPaX7+Z+o2hWTsw+RxKFeInoZ2GRsj95mLIhYl+vdCg5v2Po
	C1MxRTxTG4M0ldr4PIR84A0TCMLlAUzkoEhFJsA9papr4P6koHIGHY2OQkPDdYr19Kni9iiT7LttL
	IcnQZNk5ag3OfNguyVnNOXGfT7iBOb3gAusjmevcZ6VfHA4++g4DWhsDJ7LWsPdRq1oCtCdYd1D7Z
	GMaiuFwg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us2XS-0000000FFKr-3XDx;
	Fri, 29 Aug 2025 17:05:22 +0000
Date: Fri, 29 Aug 2025 18:05:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH 00/22] Prepare slab for memdescs
Message-ID: <aLHd0rvwawctlHzH@casper.infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDEB818000D
X-Stat-Signature: wdw8h9zf8sg4nkfm1mnmjdw49fboyqg6
X-Rspam-User: 
X-HE-Tag: 1756488628-997291
X-HE-Meta: U2FsdGVkX1/WYFf+vTXL/baQa0tiRJY3uLN2lNp/E/AA63rXiFdezAtYLcemjnIEeu14W+4zU+LoJRYIJ/yTzaTYUDOWG+K0ZKRkWllANrc7RFAc07xOBekPtCJIV+fK55sQzM4EVihRaDZcmhE6kidnf3gfxPfM4qRAzPSkRJor6G6UDBcmJccXAqNe7qjNhp6DHDQF52mdMXnUEqfLt94V1Jb0oltrWbTqXqvaAu+fFEZeylWx0m0sKVov+ChjYEFv0QrSjDhBlWUL/A2QhNaI+mZRn7UufHEeYB7Hj7/g5z4iAyhnDW6s7t8GHBDypqra0apodvBv7W6XyanTM7055r2Cq7O7Q/wCR1SRW5kTDQ1MDh47M0HiRfHbzBDYKdTloYZB8JGKyxtwYrIG1ukrgLNAf2K+JGbUUCc/X4hhVYwuccasUUQg/vJzQjGi2GC7/YdKHUOJfo5kRmZniDhmrb9LztjzzLl2FDCJgV1lhCBHS18BfjJExcHtwBxYJACB9hVA2kvx/vvRKKhkeex0TS1F1m4ZrUmKrc9SrbOYxAdFFYf6q0ElZhowaOZMj4wNexLGSF6iICMDeMmgbMLZhTafsCDKZy3fN1MJyF6qcECA3sW0hvrK+nTTTmPRk085hkNShVYdqBuShsmJrojTJFUrPcu0KFnWZRjX18MbJCiPSflDy6QNfPYJD5hMToZmUOrfJK78J3PFAjvR6IJDA+ZHGqJ7RiEj6hr+mAMDUpaZa8jnuim1XhJPPjaqlycQXb8g7dVoRDa6+OPIQHMBqvr4KnXJkVGRTBi8My7G6yXSSIRHKOhODGVFiNAmvix4acGNdpZfan5UPx3NmdvtKhNzFbjOWZlNVGy4gRBNEDbI/y0PvQIQIaptaTVga9jq4MsNyAaz8qJiMkpRGtx4zw5HkoaTHrDNk1dJJCMT7U/kuuGQx5vVqpNnS2BZ1XznHBwjheAbSYBtXNp
 iLfm0now
 /9/d6RXROQcCeIa9HE2SJD7CkKJw5ii8Gz+qQ5xJBEAi6XoJXgu9KOVICFg40vRblePbzzmnewfi5j+/mw560WrzQTy9jfzQ6UGqL0AGHIb0xFj3NhBOyHWt66M4xnR6shnRsafWTz/VpGppAMRzfxf79pAJ9G3tBuSyI4BhQ8FfouskwhGysP4yufLH1V1shYpbXYXySCjM/n+g0rZWocxsqsRDITPQnUWloMnWFDZHrYXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:47:04PM +0100, Matthew Wilcox (Oracle) wrote:
> When we separate struct folio, struct page and struct slab from each
> other, converting to folios then to slabs will be nonsense.  It made
> sense under the 'folio is just a head page' interpretation, but with
> full separation, page_folio() will return NULL for a page which belongs
> to a slab.
> 
> This patch series removes almost all mentions of folio from slab.
> There are a few folio_test_slab() invocations left around the tree that
> I haven't decided how to handle yet.  We're not yet quite at the point
> of separately allocating struct slab, but that's what I'll be working
> on next.
> 
> Based on next-20250829.  It has dependencies on both the memdesc_flags_t
> conversion and the sheaves work.  Both should be trivial to resolve,
> but it may be a little awkward to shepherd into Linus' tree.

Email is being ridiculously slow today.  You can find all these patches
at

https://git.infradead.org/?p=users/willy/pagecache.git;a=shortlog;h=refs/heads/slab-future
or
git://git.infradead.org/users/willy/pagecache.git refs/heads/slab-future

I'll wait a few more hours and resend the ones that don't make it to
the archive.

