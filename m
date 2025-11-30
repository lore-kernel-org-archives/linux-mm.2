Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A72AD111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 05:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54F86B0007; Sun, 30 Nov 2025 00:38:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D866B0008; Sun, 30 Nov 2025 00:38:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69C26B000C; Sun, 30 Nov 2025 00:38:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2A3C6B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:38:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44F5F132865
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 05:38:30 +0000 (UTC)
X-FDA: 84166168380.10.D7C6B20
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46DB440003
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 05:38:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mzyQTml2;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764481108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMFM3mZm3tfpZm9opFnIUzFCaL9Wf3MxVqcMizCNUwo=;
	b=OeODYqXPuWuIWwwRFotLWdxnw5yLOfqhmDLPKVHdCA00skQrx56Gl0sl2zIdqj0pc0+llL
	YWaXbgoOHM67Yco7r8f/DJ5atu66Ub5YYmN6CQmZnebbThCqxQDgNVl319a/AxK1NxneGI
	50dURvuNWxijeVcCZECNFwMtZNLymx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764481108; a=rsa-sha256;
	cv=none;
	b=zBo2B1SqNNKB0pHlgwfMEGhbHltLVPMdfAGIPgc2znAtbvtfGdYKT5YziJVgQVCBst+VHo
	engzkvvjQeq3Wjyy+jK64bOLcOaVOJjjXzCXUWAHDqgueRiFh+w3ygmLeZvw+gX9S/oLaY
	RZlDwjtf+d5cva6dvddezWOvGRWFy5Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mzyQTml2;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 29 Nov 2025 21:38:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764481106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMFM3mZm3tfpZm9opFnIUzFCaL9Wf3MxVqcMizCNUwo=;
	b=mzyQTml2HeLVP/7KkNdTn5q52aTUXfw24UVLKCemUVyERxGGs6BfXps44VPj/aI0p2bjyv
	KMjhAOW0HBu+NVi0mdYKElpoDb/9sqzgpso500188A+9PEXABE1B4WxKsO43Lp+jFHQO1d
	m7bA8X9LFJTjAWdANdBQuTczyx3HC7g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
Message-ID: <6xwf5rtl6ccmeera55oz6xsubsljibxb7gfv63ul4locgfiipd@dhjxr6gqrfvh>
References: <20251127011438.6918-1-21cnbao@gmail.com>
 <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
 <aSip2mWX13sqPW_l@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSip2mWX13sqPW_l@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46DB440003
X-Stat-Signature: jrbjfzgcfinzkxd8g9uoeeh9ijijnugo
X-HE-Tag: 1764481108-977157
X-HE-Meta: U2FsdGVkX18qqy9Pu9L3t8GaEJGUanl4Md+I5/TFjhk0xvbQLFvm3V0Kn/MKmjFmOtLayZLjjVm736TaWkb8bpacOnRJjgZXw+tYEpi7ZdwWAGh9B34OkNPJlVhLk/Uc+on97siXYjpPBLiub3wiNJw7/kgYOTb30yVQv8Xbm4Z5YBzpTkmjRvO5F0deKDNwqzWjQaSjm6nRJ//fupIDB7c4FEvraKoHY1rv3cfK+vYpNvrMBwvSe1gpQwFZisD9waGQpMEpfRMKgdOiQ3L1PjYv7i07NP3TlPx/fgCSXyFxMigKx1eBhnF980euaWV17VsOsZjkIOjtfu7mfFSAk5tZshhf7oXOYQ/sMerjtNTRt4xTal/SsnRd5Dsfn4L3ev9F1FTsRXFzC4agapbQNjTh6Ssxksd9kaRrMirKStHZcIw2kYxBFMiNuO5moLl9BRFOoSnPbAt8kSUlE7mvCvZVZEO4/4JMnOIBbQqSTwK1QRwn9NgQf/40+ZRIYTdBc/bCsGuXGMF9ZlWuPjbd2YvqhpXHncaDbPSnCA9uV8+sG7azPDhxI2vekND4l/Fikw7dYuTtqiOGtNz5g8hTQmGJrSJkQGABFrqlmzuJJT/1XoyDuA5gi3TVWUr0S0tif00EhavBp/bEs61SqxZsBm86sO/TiDtBpuQv4sKWCAgqBWhok0bY4nfCPNd7IuquLZO3iNpwpI80pP60XZUKcAMApc5AYCmTVZpNOHTdUr+CJJDmVUKoJUd1PT2UlcUBX66pGNTdSmWby9pI3pkmZiUCGw6+dETihJ/eAuEqiZn1XNHn+6Bz/siWbD3bJ3HjIBopsOQM+o2O0x6zERrjzA19Ft4EwxOWdhZckaqkMr2MblYTzNonwoOvKnR2gLRTN1Yh11olIeb95LS1cqS3d/gAO9W8hAWOAEyyJev5Dw1pCpaV+pYFGSgl05rzqU+ujyqvMCzRPf+LKqhO7Ui
 LJRer12m
 ZkTCecyZrER+pKXulxhJmEjN982u4sz0uzgjwuyR2o04q2Bnzauh2lhhnzsawQYq/DGlHY7K7HRpSDW5cICtJy5wS9+dJSaJrjKOJDF8ASes0ARBMphyaddB6O9OFK6fYQVp6Z7itpCrv53tx2O709+r0FCL/yl9heUTicYvZZ+ILQMqXT328aJMZxquy3zvA0IC1XA26sNMv6yR/mXWR++mVsbvbhI04X1M0Qh4R1fugpI3wpI5g+UybgA2dxK4RCPckfSjF8b9Edq2d/ZtNqETR3WE25qINEb1t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 07:43:22PM +0000, Matthew Wilcox wrote:
> [dropping individuals, leaving only mailing lists.  please don't send
> this kind of thing to so many people in future]
> 
> On Thu, Nov 27, 2025 at 12:22:16PM +0800, Barry Song wrote:
> > On Thu, Nov 27, 2025 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > > > There is no need to always fall back to mmap_lock if the per-VMA
> > > > lock was released only to wait for pagecache or swapcache to
> > > > become ready.
> > >
> > > Something I've been wondering about is removing all the "drop the MM
> > > locks while we wait for I/O" gunk.  It's a nice amount of code removed:
> > 
> > I think the point is that page fault handlers should avoid holding the VMA
> > lock or mmap_lock for too long while waiting for I/O. Otherwise, those
> > writers and readers will be stuck for a while.
> 
> There's a usecase some of us have been discussing off-list for a few
> weeks that our current strategy pessimises.  It's a process with
> thousands (maybe tens of thousands) of threads.  It has much more mapped
> files than it has memory that cgroups will allow it to use.  So on a
> page fault, we drop the vma lock, allocate a page of ram, kick off the
> read, sleep waiting for the folio to come uptodate, once it is return,
> expecting the page to still be there when we reenter filemap_fault.
> But it's under so much memory pressure that it's already been reclaimed
> by the time we get back to it.  So all the threads just batter the
> storage re-reading data.

I would caution against changing kernel for such usecase. Actually I
would call it a misconfigured system instead of a usecase. If a
workload is under that much memory pressure that its refaulted pages
are getting reclaimed then it means its workingset is larger than the
available memory and is thrashing. The only option here is to either
increase the memory limits or kill the workload and reschedule on the
system with enough memory available.


