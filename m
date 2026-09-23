Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAF8C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7356B0088; Wed, 23 Sep 2026 17:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4FD6B008A; Wed, 23 Sep 2026 17:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48CCA6B008C; Wed, 23 Sep 2026 17:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 231606B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:42:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2C3B14015F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:42:15 +0000 (UTC)
X-FDA: 85246350630.10.2CB7170
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 938C5140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:42:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vGkmqUjw;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6pK8WWxgAS5aSXBypjoYgNFtTJptEjH9aEN/q6mC+U=;
	b=nPynCwjXrrqt66G4F96DV8DWVWQH4unA2XCxDOq8XAy0n4uJrOJX17KsoyAFNDf4mMd/oF
	VSoV0JBQjzqf6p/TBlnIgvL5J2CIUhGGYRB6OWCky+37wAe7Ce/MvAC8WXwwHuu89cHs4K
	cBsR0Mf6pILfkQwzTKKAA43ePcMjWvY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199733;
	b=WGuKpQInzLsRDMP5HYZddP36MI8CBidG/tXoiV5kdx7WCWdhykO8/XZ6XwaOjnL80k8iMA
	5UIJBGYv6qUUQ0Kua+mQF2ZK+y3h+bdVci9BNX15+MZli/0BcAhQfBJ87l8eVc23IeYNVF
	mBfBaBWSNQGMCLmTxYEXl5wVIc21c3U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vGkmqUjw;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u6pK8WWxgAS5aSXBypjoYgNFtTJptEjH9aEN/q6mC+U=; b=vGkmqUjwzn1tF6XDIzZN/SCaT6
	13tYRqeYwss47O2D0jAm9SXWBz0WBlL8Pu4ON8hNHYjXxQulSUsTywTyZ8G+6YD5wzekT3//lV1vy
	4pK4JkokcvY1F9zNtwYI5xT9cVqJxu+h99NVJG6K5bIkB59kV8/rdEe6fNc9Sk54XWZhr5mCIus/r
	LH5vjqEcpBfkrZbCRc1U8LhDlBnm7GPIuGt1vGJ1EU6kjkQEFAoefAf5PCfp16OWA9LZxNkDDY83h
	EpRUBq+/vc2D6KPau2hVWER+dhlrArBbEBCQiLfywuswSfgGMKI+s/5I7E3s1HfjE2BnUCAb4djYc
	t8bJMk2A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9UjA-0000000EXiK-0L1C;
	Wed, 23 Sep 2026 21:42:08 +0000
Date: Wed, 23 Sep 2026 22:42:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com, jack@suse.cz,
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
Message-ID: <arRHr05gy_eu4WVA@casper.infradead.org>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 938C5140007
X-Stat-Signature: o1958937dcw69671qi4i9btj9971dpts
X-Rspam-User: 
X-HE-Tag: 1790199733-793349
X-HE-Meta: U2FsdGVkX1/WPHiXwU8y29H/sF+4xX8kLaqvOkloQFGcPManrboxiqxrO7C5KxjEZct5E/nMBZV5X2IiEIbOX2h3VbkCSUbmczPmsRaj2imCpMjn2mAg3k/GTN4OxdyuE3MExpdCXiclHY8JRQapV5u6y095SeW7AlOxzibxTdtF/CzfHgFan6xf+UNbsfdPiE3E2aug83o0Lzn2IQDMHhKPq16g9ISos4/FeMJ6krRP1/EZZUhRLA40RiuXPsy2IjawufnvTw2f8GC0Dlz65FqYQJqKbVxDeemPIGwSHHDggy8FixfvRkNLwDhDquewHBm9Ab/xIpwgDT5Thj09noZWZ9Jd8d5yrfhPpqM8xlDteTaVvlNgMOO5Zc2Ew/qql+lh6sWD2yyZxDPXRVwy7vgq3LGELHYpMWOSM7RW6Z7DYDcBxY8a0dNc5vQQpMgPP7H9ucT+ADQLo/2U+1CGS/hNKY8r9BVQmSeNkAtqi2IPs7fgizal+qGcVaCGSBUjPDg9cEK2XvKIDj1dgKXC1/YBLTg3EHrDE23j6VQjS1LqarbXsEZEKD2+klITfDsonb8n1Kav3kIRQOoaNF8D8qSgiw65vO5fm4KnKLoHjEOJUwRxjAslLNfVKeDO0z67AYG89JH3aKpgx0H6CZWTAcCSWGUZC0rTYoyYHo4dHcBvvl/vQVbVlxs7OYa1rEvrzWESaEKkzZGWYRxYvp6KqDfaPvV1SiyxLrh98g7wXsqEgij9jydZStfBDZlaPqQFgftJ5mayL5YOCmiS/e0F69vicc0An0Agxo+atJK4SfPauDjy11QLTTvDY9SSEXSGlNT1FR5B3Ei4MExy19FDfwytcCcsR8OFCM8hOjGbnAD4nBnDZ5yby0xd7Js0fgP2nE68h98iu9ll61zhI/2obB367k/giuSWFZ1Uu0jzTD/UGW1OISj3Nx3gaEpHcZVOFi6zohPXCTzj9K9rulE
 KsSDmH0E
 bibOSIb1E1DO07hmGcNUyCwNfYY9K5u/ZxcyUA14yhnM0tGDJ1xXe0R24bqGHTV8alh972xbrejMKDzqBHVCFBCwhpsacNdAD9P+DtEKi+RkabPuhmQEdoMlAmN5jVVvbzxF2Z77el/7SWMHMESyS2XcZUUajajVrQ09hS2xvupAzFqfa5g/8MX2lsPXuxguM+2DQ8fYybT33nrW99EEChFKQS1P50B2WE+ejdB42KG7LWDkICeA8BmqfvwIl2qKdfwENWHUbZo5ik4MbgXyX3D9JsgNL0axw2kDYdp0TFmid+isrL7iSQIwwy/t0bzAzjbq2/zg+IBONurhCahTXHe7MK9GxewQ5TWW9Q5IHENnwdB3QuzQw2Mkfu+1XkKMYioCBVRBOJmBIALc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:10:34PM -0400, Gregory Price wrote:
> The folio, filemap, and bulk allocation interfaces currently hard-code
> ALLOC_DEFAULT before reaching the page allocator. Multiple MM series
> need to select allocator behavior through these paths, so pulling these
> changes out ahead helps both series avoid conflicts.

I really think this 'expose ALLOC flags' idea is wrong.

