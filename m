Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F30DCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBE46B00A4; Wed, 27 May 2026 08:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D166B00A6; Wed, 27 May 2026 08:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2016B00A7; Wed, 27 May 2026 08:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99F6F6B00A4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:15:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 472D51C1CB1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:15:18 +0000 (UTC)
X-FDA: 84813094716.16.CDE12D4
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B34540006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:15:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779884116; a=rsa-sha256;
	cv=none;
	b=a5He3+YwaXBWoRZVY98S+wvEOoLGD2eO9p2imXWzciXKWjGpEzO0ZerUpkogmh4qsvrzmp
	uqygUyNHhdP5Q0t+ieb5NJR/yakvLcN+y/b0iQtH7jlLOV/gw/vnyGGRor/3bRvTBHIqtz
	IUloBkLjRpc/bHXzLuoTx9+KJkhQ3qk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779884116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ynVCpImhyF9rGRsqXdgojuErJNMySgyocsYCRruxA44=;
	b=yhNBta+lz1svqCs2qzyGGjG+PFj58CDhYI1ypG/RioGOSr5XuljtNf/LSaTPdDKODeeZUn
	abwLVH5avGX1qjobWySSUpPD+jIAJJ5HAtBhVorE4fFN0j6vYFU+OuWg/3WL6xHAuHZE7n
	D0Lon/Npm7pto2HKyIP46+pS87EHKbE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6183B68BEB; Wed, 27 May 2026 14:15:09 +0200 (CEST)
Date: Wed, 27 May 2026 14:15:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zi Yan <ziy@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: revisiting alloc_pages_bulks semantics?
Message-ID: <20260527121508.GA6079@lst.de>
References: <20260527071816.GA17632@lst.de> <A68C1B33-053C-4406-B78E-871ECD7293B3@nvidia.com> <20260527080056.GA20040@lst.de> <2759BB06-005F-41EF-815F-C9F96E822DE1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2759BB06-005F-41EF-815F-C9F96E822DE1@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B34540006
X-Stat-Signature: unr9asqunrac5d8zhokjqtdt5inw7tb4
X-HE-Tag: 1779884116-272697
X-HE-Meta: U2FsdGVkX18SquizJ91S8+cLSJBX5uph96vpjXfBQubY1fM2OSteABW6ZrcyahVgQFnLyUVurCzuiOUcUpQUx9gUzaBwNQTJr3DVCzyAYLBwooVPFfTFW/S6Wrc9aptDLTapuBCcEWL3l/hEV8AF73hCSkHsNB2lP0Jx3Wd70X6dI3QYzPa7tFQ0CJl1UNW6HlBO3xyYaRVJMDoI+vMUULM/fK/P5DrQsO2jgkwaszoOBsbSRRvZEXWOVsHiFJ/VsbEg0tTynFW1DePvVoDHkIjmjCMUn+Z284YpHusplvyiiH66I023sRJy6OLnUAHb9YfCd5PUrbzq0PkSZ7Adh+aitq/XO6anzG1IpxOSClOfz3fvPvDn6JlOfvYHllSgHm2NVIerKbfGw7Jd5Ga/bvDVP5FaXGLR3NFCHw2o/tJYI5tp/+z6WeeI+wBMqGIRmB0MIgaHBVt2+lmpYGBdqcJ2//tfCGC8nlso/MVf+O2Fl8mT+q3kgUd6P6b0B/h4szuON0sa/TunZloDNEdxnMA9QzFVba4/zt5fivSkFXx9JENCJLyQ6AcUgLt0lZQMedbEZZz6XzSgGZx81HRlDRfR8sYPBswJ//hH5yYpVMouM32r0AvRJFw62ZA2F8vhHu2ibTqJRGNgFW7t5juTKaTx3F63ufqHddrpHnEIS5fMBO7QJokyDg3gZwNZryc0xBFCuj1MoocCB/1cBnVrET0lofpz9SKXbZSmsJf2uU+HA12azVD2y8temS1waawtfBlO/tPR4+WBP8isWYJuZ520RgsbUn5qxaT+Neh8wFqT6KMdLA2RzsmtEVeeU1+Pn+KTj6Nt0WKIlHFIVCrNj1WuIqncFSbtz9NbKQA1NWNwvrwRDLldnpCzwtrZKkLxFUkiSLzPXc6gwIZ8H7x8lfFNOu7a3MBFeHBEJIZ9RNWNfN/PBlK2Z7iHQO3YPhC9PkHZJ+2sDcAT29oYQp6
 RT+zVCb3
 m98igB0Vw3p98Ol04KnlmpmJDFbWbrO2LantScPcG0kh8cKdW/hG3t3ClOvH1+DY6Y4NeGWJ8YqnpMzK47sylBN/K/TXzuWYHRf+VusKwL+yRVTIG0BQymrZ6XLJQkDR5nOvh4FCtxIJPf11p1NvCXz9ehiRZf88vix+XMPE5FZnRoWh0PQqFsq9oKjWa4uinlnTB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:31:24PM +0800, Zi Yan wrote:
> > Yes, which is really odd, as other page/folio allocators make that an
> > opt-in through GFP flags.
> 
> Based on my understanding of the code, the GFP flags are respected at
> the __alloc_pages_noprof() in alloc_pages_bulk().

As __alloc_pages_noprof is the core of the regular page/folio allocator
I'd expect that as well.

> The loop of
> rmqueue_pcplist() is just a quick try of getting free pages.
> And I suspect it might be quicker than calling __alloc_pages_noprof()
> in a loop, since other preparation work in __alloc_pages_noprof()
> is only done once.

Possibly.  But that means a whole bunch of callers have the wrong
assumption.

> > Well, I really want them.  In some cases I might be fine falling down
> > to smaller sizes, but I also really don't want the logic in every
> > caller.
> 
> Based on your answers above, it sounds like a wrapper of
> __alloc_pages_bulk() that doing allocation in a loop until all requested
> pages are filled might be good enough for your case.
> 
> But let me know if I miss something.

Or just allocate all pages using a loop when alloc_pages_bulk_noprof
doesn't get enough pages from the PCP list?

> > The allocations I have in mind would only require try hard allocations
> > for typical file system blocks sizes (64k at most), while eveything
> > larger is fair game for falling back.
> 
> Sure. In MM, PAGE_ALLOC_COSTLY_ORDER is 3, so pages bigger than that
> would take more effort to get and the allocation latency can be longer.
> So it might take a long time to allocate the last 64KB page in
> a bulk allocation.

Based on the LSF/MM session on lage folios and MM fragmentation session
it seems like we should raise it to 4 for 4k page size platforms,
as this seems to be a proble for 64k folio allocations.


