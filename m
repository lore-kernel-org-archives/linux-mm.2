Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99480C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2916B009E; Thu, 30 Jul 2026 10:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893046B00A3; Thu, 30 Jul 2026 10:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782476B00B5; Thu, 30 Jul 2026 10:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACCA6B009E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:17:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C752B1A01A9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:17:42 +0000 (UTC)
X-FDA: 85045646364.14.8BD1E3B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id C047E8000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:17:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=amLY6zm5;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3SvnYZJHl7NYWj02zj6wL/RU9i4h+L+WYLXP9dU708=;
	b=c/zDgogGfjTRpLRZAvYtb2VX7AKmC7yZL4B4YtXPDyVv7LYRLj3MiE9J8NPKyhmVA4lozQ
	jq0hpSdZgaDwTtc9ioHKVHJCfC4MecR0pVXNMvZci2vwFqiGY9L2dkwFXGNidAOaEVgOB+
	oxmAnzv/uCBIVY5DVgq2eQSrfEjMCv4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421061;
	b=Bm387ozXe4n6tnXnckWwB/GQSrNMMLCZJMzk8R6dYTnKD8/4DsufrkKHtP+TRVJez8vxii
	2jny4Ir+hU/9aphuWajrNC1Tmsz9oAtsnoyBIQ1FFUiaY7JCu+//sy3xtsTpN2XtTcY+Lr
	peMhfurj9e/kkhDMWbweCHSfvFFOE48=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=amLY6zm5;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U3SvnYZJHl7NYWj02zj6wL/RU9i4h+L+WYLXP9dU708=; b=amLY6zm5tP2ZxX606LkgQ+F4SN
	sj4k1qzLtSyTZ1yjosAgi4YDRF3psU2AvEzsNry9rfF6Y7ul1d+YtWS23yVAWXAZyIo5fPQwyPa0l
	7VcfSfieRpxys4dP722NIk8egiND/5WV/3qGNfR/REJgknhSAXhG0stTm2FCQPUMEscLwMNeenum1
	Bbk67sbrctfTjKx3tu8FyJe2sQ491W/Ctlixty5VWICWXgio7lD+mENESX8B1NrzmTJA38alGfMst
	Ch/Xnjv36A4QAK5UyCxMVDm5uwQVBvGIxcoXjPesWYLu8jRB7UQ5fZVVGNRnMDyiylUTFwPD/nRXS
	j9Nqc6jw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpRZe-0000000H8yg-3sxW;
	Thu, 30 Jul 2026 14:17:26 +0000
Date: Thu, 30 Jul 2026 15:17:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: Use invalidate_lock instead of fault_mutex
Message-ID: <amtc9t0kbt0XsmeT@casper.infradead.org>
References: <20260730131431.3613545-1-willy@infradead.org>
 <d4f87684-7727-4c74-95e9-159196fbb16c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f87684-7727-4c74-95e9-159196fbb16c@kernel.org>
X-Stat-Signature: 4w49b6bdyf6bxzqgttmaxzb1ftkfa57g
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C047E8000D
X-HE-Tag: 1785421060-599250
X-HE-Meta: U2FsdGVkX1+BFRZPaeRzJGLlRl1VecacJEt5FCSqqXh0FOVG/2KriqdWQH/t5ixof+29nYTFnzaP/fh9AZwxI86Fjzc5iudBngin2dsDscL0Z1+SALlDFCD9ZYyDFamrxllWeJmPg9rpD4VV4Z2Vs9Z59oO70diGwj7TvtRYBUfp5XSuPkpSwcGQMsk2o0Klx+vtqHWRoYjhDbnG0oCe5HOKCG0/IkCM5X0zfubencLdBjIr/SSNSKOKVOyrAPREaXshx+Hx+86QX9GgLgzF8uXJ07nCwK1ksviaR6b7saNOfbScIpHBlaV6qfTA7GoA3hUUj+0HpefU6nKHa3Qs3AKkqiD8IehC9/OrOiqGvpR3Dz3i+eCoXu47zCaw65nk2mwPf/NL5J6kVwL2eC/R8wEOYGYray8d4OyN61I3kPBvVtuvZS4TzlJOo8nmFRDJYVz+QytRd4ncC3CRg2A6YMpOfEJdZgViZoWxrak3WKHtqw1yYPUiYMhdscATgbszcTd6o+mOYMThj+iEXhYZyC0RgWFikyeBT8NQFdNKpRmmPjhxXOvFQpiiWp47B0sabaPv1UY0iCMn7Zh8VxfdWit2nT3b6tGpFyAK8+sZpwoKfh8fVHiDVJcAOHFEEm5m2ZT5G1yhdx5u5nTU64G2xCRvyrl+/QmzeoFmELsO053kW8W9N+FAHXLuwqcqEQQcYMdXo0Nbj6o7Z8ml3AlQA1QiYbFgPIASLwaUkPBz0LfLQsCo37w+XcPaOObB0YjJF7PpvlbIqPqikmh52fzn4QDH/aqjHOhuXSmibJSStALJtINvj9+4OE5sjyEGckcJWYlvryflXKIWu7M8AtxMF3zXpl82okfBcin8YV74v5z5vvqmvam5HKyoPr6KJrF+Si+gkMS+WSDJOwKd6zCQZigGoM8geE+l+M/r+yR9xYkwqfTeLlvwiFvXLGtl0uohAPEhlWVkWbmNiB/27Gt
 r4ZLMP0V
 bIAyI+ZtduuQVYIh/ze1a6xiwg1qoNdUCWUC1JgljeCA70KqKlfVLhRhjNRR/yPFj5JEoJZdXzG+FwiTIVQZGlpRgrGNSngZJ3GYE3s/iw/gIEubEgokDx3oNGx7w1uuSQLcgLpj8r/BQZZ9skJtYATLg1kjPE4BB8hyNvlwJK0GwPcZenCg52wIq9Vr+WZ7/+X0xktPORKqW3vkT9iOAWXM1iXTPM/qzDOlK6/thMMVDBZi1vIsPAhmfNV9rFCqNXPL6Z++C2iZDdnKgdq8RzVhdCpARa2hOGIwUpnYdjsvbQXOvl00h1Y+HSSyKs6Ywn624CGcpdmZ6x7pUYWnJPfFnaDw8lWg9gQNEJKSVIEVTVTRHY4bzfVWYYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 03:57:23PM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 15:14, Matthew Wilcox (Oracle) wrote:
> > Since commit 730633f0b7f9 in 2021, we've had a per-mapping
> 
> checkpatch. pl likely wants this to be written as
> 
> commit 730633f0b7f9 ("mm: Protect operations adding pages to page cache with
> invalidate_lock")

I could ... I was just trying to add some information for those
curious rather than trying to do something like Fixes which wants
a properly formatted tag.

> > invalidate_lock which is used in much the same way as the hugetlb
> > fault_mutex.  This is a fairly naive conversion; all acquisitions
> > are in exclusive mode.  It may be possible to relax some of these
> > uses to shared mode, but I shall leave that for a future patch.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> > I've run the libhugetlb test suite against this, and it includes
> > a test called fallocate_stress.sh, so I hope this works correctly.
> 
> Do we know why we ended up using this hashed locking instead of just allocating
> one for the mapping?

Before my time!

Davidlohr added the hash in 2014 with
8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")

That replaced the hugetlb_instantiation_mutex which was added in 2006
3935baa9bcda ("hugepage: serialize hugepage allocation and instantiation")

> Almost seems to easy that I wonder if we are missing something important :)

I suspect we could have gone to a per-hugetlb-inode mutex but never saw
the need.  Possibly there's a use-case with a single hugetlb file being
mapped by thousands of processes, all trying to
fallocate/fault/holepunch at the same time?  Let's see if Davidlohr
can remember.

