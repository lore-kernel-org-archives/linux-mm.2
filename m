Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34729CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4096B0092; Thu, 27 Nov 2025 14:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBE86B0098; Thu, 27 Nov 2025 14:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808CA6B009B; Thu, 27 Nov 2025 14:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 705CC6B0092
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:43:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33424B7460
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:43:29 +0000 (UTC)
X-FDA: 84157411338.12.D51DA63
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3F14160003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:43:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="bLoT/Fgl";
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764272607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQe+g5ZvR6KeivPEwk1LBLbeVJ2/39tSJLB6nZ8TM10=;
	b=jfKV837bJx6shPj1joy1Y0BYRzJWf/tN65UV7jkDW2cPv+YF8MZPx93rFf/oDhBRdqnYzg
	tANQmtJVdFSICAo5k6M9rItA6m4TylwkOeCAcAxshhGBovw3hRK1oW4fqsvoZn9DDXxdEy
	ftUf5vMXrDoxQfGdfG+xvQgmHd+QzB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764272607; a=rsa-sha256;
	cv=none;
	b=JqxokRhQ1h+lBu6cEbLXSItIHP/P6np+mPIeUHgDye2fjysIsdnlBqRnMJg7OPCb2WlxKg
	Oo5K/Oa0oavdaXd58aKhNfqHEWjp1p3CLBPSX+VRzBVs2GykIi1bWZ4nIiTYJic9e9sWoK
	ot1xCbhe2LRfYU/Fp6tRxGFUQ13IFv8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="bLoT/Fgl";
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=JQe+g5ZvR6KeivPEwk1LBLbeVJ2/39tSJLB6nZ8TM10=; b=bLoT/FglVGFQTp6ZQ56Yle6fs8
	ptqzHTWL95KXuhjuxl7XPt2gLgIOgk1wweluHsPyQ38cpDssH97HG3X9erEgS+i3X/bNy+BrSNtZX
	0Nx+1/7AoEl05gpR3MVH+L9M0aocNk7ibz8QPD2KslaJzakC7Ok8gfVaNO2YEVazZb2xxnmCHFpPF
	IGRfMUCoFpNAy2XF/qaFP5T/vm4M4wGNn6/Yp6Tnduny8zxbeHx1WOFYhR2vZjAP7vXkPR/loRBbS
	yrzAGHclbg4deP4UOsDu2voNxG+3XLZD1UdKAL75EZWsX6Dwl59DS2irr+1duhO8HSc3s96oSDErT
	Uno8xeEw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOhti-0000000CBWb-3MlU;
	Thu, 27 Nov 2025 19:43:22 +0000
Date: Thu, 27 Nov 2025 19:43:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
Message-ID: <aSip2mWX13sqPW_l@casper.infradead.org>
References: <20251127011438.6918-1-21cnbao@gmail.com>
 <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F3F14160003
X-Stat-Signature: 44yftf9ndygfy8mmbwez9tezhtatzta6
X-HE-Tag: 1764272605-10890
X-HE-Meta: U2FsdGVkX1+iwS1iMxB+lWL6cXZrQZwS4/9vakYmf4i0VFc8YVEBWXao0LjTiAa6imDsU9cxMOC2udC97PvMWoUufx1TplA5Wqy2+hFFOAfec0zJlfJ1iba5Or5wEbQuVQ3JWkXdjxJHRheH9xkNwZmgJLxWuD+NxRNwwa40QcdPO0d7ADwxh/EWp3toEErsXr0LCtJaiDTVtQANjR6d+nMipBK7vQnHIdvUfWVGkJbVCq2TC/caYBiL5ZZvYxt+yBdoG26KLLeFiQaPmoOP9fN8LBHEf6VqbShzHgzhwzCJna22TfmTVfcMtcqm12Mr8ir/BF0kW23kIn9oC1I19jjqi/gApIVA4xFESDsW4NNOt78vN96KrPq1q749ByReSNKblemaK1xJPj/3dxhy7JAo0g5noKyPYkOrArh4v6FFXfcvEaoknHfLifSfRuDmszQxzmC3ejZrRkcZX6tQHfvTlTQtlZliWCYLHw5xsx4b9ILE9D92nRi0tq5fPj7w6qAjR124XfPN/b0ZVidT6zrshNezP9hxVcJz4qyy8p9Rqclbp1/LxwlHF3t0TZY+0SJf22tVe8RCNwzZ+Cv1oeomORzAQPiQMWzdXMTiw5opFn3BPTIaSnVzQuAEeKKUtPjJqviKZMSdq6FEThWnothypBBD4V5xHsIoST8zt4A0V9nRY8riFjQhH6ElqTKyXJMmzRoYhVx0gNDLg4xXHwLn/zgNwOTpJJuYNKU1ZcOwSySej3Pwmd3mYV2LDceMS/9r8ECmwWpIvK91ltDQHQAwB/lG78jX83FzuG1ZYX5LJV+HDVJOi+rHlC92FUiRHpJEfnKWtEKMdZo9X0Wah7X2hlxhJs9vKHdOdIPFnVMrF3z74l5fpIS5ZcFz3Ih3QERiIPWKUYCDjgwteBNYu/idQf0PDvJw+hGq/RKtXfeYU5KkmbQTXqiqpYKSIgXRxIno/u29r4FfDoZBvVg
 tKJfkOIt
 Yk94Tla5BqsJGkobwHDvPKPG1YeDJjgLUDUvsPtW8OAPRhmgxWWMe1FA2SzRtZr2+IP/KrCFLmUJcsYQqfIgJySFKX1dUyYCDpsIxUkGZkE3XoAMEBqCnaGb/ZiPVNWNacn3D7wpAOR/aCAFnK0ojd6qCmSaCqY0i2QebQuPx23BItogyAb3j1V6zRZUCQJ+L4adC+jVXRka1mlOcdSFR3vi9Ws909X7O48WJzSmUtEwRu8Bs365Y9lGh4taIClffBWN7KrMtVF3SQD6aw+lFH+KCXjw8WU0ZMEfJ8nk2I1OAAeM38XNLtGTAIiFhx3yJvP8rNw2nNSPMX2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[dropping individuals, leaving only mailing lists.  please don't send
this kind of thing to so many people in future]

On Thu, Nov 27, 2025 at 12:22:16PM +0800, Barry Song wrote:
> On Thu, Nov 27, 2025 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > > There is no need to always fall back to mmap_lock if the per-VMA
> > > lock was released only to wait for pagecache or swapcache to
> > > become ready.
> >
> > Something I've been wondering about is removing all the "drop the MM
> > locks while we wait for I/O" gunk.  It's a nice amount of code removed:
> 
> I think the point is that page fault handlers should avoid holding the VMA
> lock or mmap_lock for too long while waiting for I/O. Otherwise, those
> writers and readers will be stuck for a while.

There's a usecase some of us have been discussing off-list for a few
weeks that our current strategy pessimises.  It's a process with
thousands (maybe tens of thousands) of threads.  It has much more mapped
files than it has memory that cgroups will allow it to use.  So on a
page fault, we drop the vma lock, allocate a page of ram, kick off the
read, sleep waiting for the folio to come uptodate, once it is return,
expecting the page to still be there when we reenter filemap_fault.
But it's under so much memory pressure that it's already been reclaimed
by the time we get back to it.  So all the threads just batter the
storage re-reading data.

If we don't drop the vma lock, we can insert the pages in the page table
and return, maybe getting some work done before this thread is
descheduled.

This use case also manages to get utterly hung-up trying to do reclaim
today with the mmap_lock held.  SO it manifests somewhat similarly to
your problem (everybody ends up blocked on mmap_lock) but it has a
rather different root cause.

> I agree there’s room for improvement, but merely removing the "drop the MM
> locks while waiting for I/O" code is unlikely to improve performance.

I'm not sure it'd hurt performance.  The "drop mmap locks for I/O" code
was written before the VMA locking code was written.  I don't know that
it's actually helping these days.

> The change would be much more complex, so I’d prefer to land the current
> patchset first. At least this way, we avoid falling back to mmap_lock and
> causing contention or priority inversion, with minimal changes.

Uh, this is an RFC patchset.  I'm giving you my comment, which is that I
don't think this is the right direction to go in.  Any talk of "landing"
these patches is extremely premature.

