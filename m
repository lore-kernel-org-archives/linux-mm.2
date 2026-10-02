Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A7FCA5FCE
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45826B0096; Thu,  1 Oct 2026 21:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF9B6B0098; Thu,  1 Oct 2026 21:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897546B0099; Thu,  1 Oct 2026 21:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63BAF6B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:29:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8705CC05DB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:29:46 +0000 (UTC)
X-FDA: 85275954372.18.64987F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C144640008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:29:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=di0yheFH;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790904585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FIg5FXy4zOZML/f78uAixbt9TN0WD896MWP9AFfIGc=;
	b=ehV0aKI1Mq64Osm6KbG18SKdexQx++472Ht85yoIQCaDF4wWHpr+kBDzmUSGOnOCWfFz2h
	7SKVft+BEDWYH7urMzx6Sznd0gdfUvBVXXZwuAzUacfjcTRoEIW9aYWgg8bQJ8jP18n8zD
	CFQFfqrMESNOPG0RbKGFpRtSXd0Wuac=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=di0yheFH;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790904585;
	b=sS4fSpXmp0t+Fgxnwm0Yt4FUFRhmjAtPUKp8xzcquURjPbg8VAebfnlzqaD85CKSksZic8
	MCCDVTrcYsB3VijyPCSuxn8acjzrE9kiabR3RA2ZqFFE4IdjSs7HXdNW+qq1dr8wExMllw
	1vZfxcEjGfyBcO6p3dFmdXEDKOL1Ups=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A43560218;
	Fri,  2 Oct 2026 01:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173371F000FF;
	Fri,  2 Oct 2026 01:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790904583;
	bh=8FIg5FXy4zOZML/f78uAixbt9TN0WD896MWP9AFfIGc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=di0yheFHYCqpLXGt5+MvEWADBIG93td4CBzLsqMSvgr5rKyaRQygTLOsJxj0YDw/9
	 fc6OapNZKx3bK/51wWy42aHgWwQV0KcN44VcKOKjepA58eiVbSWIow+ef0Xh8UrTtz
	 XAbMvWOS71tJlBtZeYV9WzCduDvr8jU1YNO8ufoM=
Date: Thu, 1 Oct 2026 18:29:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
 <djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>,
 "David Hildenbrand" <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
 "Dmitry Ilvokhin" <d@ilvokhin.com>, Brendan Jackman
 <brendan.jackman@linux.dev>
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction
 for costly __GFP_NORETRY allocations
Message-Id: <20261001182942.ce99faa753fb9d9bd2efec1e@linux-foundation.org>
In-Reply-To: <20261001082152.2879289-1-dipiets@amazon.it>
References: <20261001082152.2879289-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pc93jnh9b3gh16dzn6zoijjqjacmxuyj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C144640008
X-HE-Tag: 1790904584-78099
X-HE-Meta: U2FsdGVkX18UqEcW8vpDTo7YuyMM7BJ+paAr22ueJHWvAX+Uu73ddwK6S8aWtVgedTGPuFlGrNHLr27mcrysyQs7y/e6JkCZcwj8WhvGnXdjFbQv9Q76xnFc9nPeblxz/5J1PtOrxPNUzfcNkh7chS3mcfTsK8wizAwd3I5Rd3OnhKM3mMjpzCtjoUUAeE62GJ3XF5EBd54JYoBWN5Hyj/UdTSdL7ZSJTQxJ5SneKt0NP2+Ds54cNpMJ3kAW8mDQMvFrR0VaaIztauxFcyOYvlvew47Z4GrXjs694uMc7Eh+hRh8olvTDXME4Sw9lPwFsHaJgvxGtkDc8xGQm4DsUItlK2Foaa/aGuxYm0LWTFSuXS/yKmZUiWfwm1cjYILJypqYVTlr4QOzFatj1FCLYK8mQuD6ZlSVY6FOPWBMaUo4fk5AA0+rwR1qZrjYHLDCavbGGAaocbZLlIeg3UPKEZbk6MyXeWEKqpUY0NMtkWKXLVwWYO/GhGrByRHBKWgJld/wna96JEICR1Wm8QrgJ2zqjYCLkMiwUusKZyb34FpXr4AQvQ9BWjQnIA+s+Pq8ycO224ein9wrP/kkL1a9rqPtnNN+/plq0suTEiIFqysuCqjUrRzZ+G3vegybc3LfpCOKLzVVf6X2mrl5SPy5/ILJuqoLLne0bM6/y9VOt1I+PqYNk1WCDwIYDyW4iVmz4eX0jR84ctFK1cv6HYOBvN27QqQljYbBONQt4zkwoa3/QFUJb0GnbtX6WFI1cEZE0q8wu4gPdVh+/2jS4/9NvGXa3ryf6k0q99iSKfBbJ7rDrS7mN5FFuxe3yYJAU5D+O6YEuWzPvnAXTiRRS4dRezj0gaDF0URlTrJhJgnxxJOkojaKZmFO0igz6b9du4j2vjwcntlbb1OXI6NuwlV4C1g73n3QFPFpK82bdhd6oEs59UxV+/a0pr77+2pWOL0cbMdsMAjIbAp2KYRRo7v
 zI7x1cXm
 Al5tALuk6z+PX4Rl6X6cl4pVqnchcTKoLxT6ZV8V++bTTX0UyS3GYuel07V3CcB4zB2NId73/Ovjw7/RkB3T1Mq8ATQkMhqf6PetW1xDqKQyeIOF1vqK/aYqJQs4tspWVm1xJZpuDdObg0L4LrfhYBDmgBoDi8qlY8vn4iLI9uQ58klb3HsBlzw5RognONeRLiW8Hs47NmDyE6eDlysaEeH/vmqRJBYlopUxgTIyOm2u/JskLIJ5rcRIseHf33Euhcc1YUCE8E7DKdnalko3tlYBGEfYK3iZoToOHFfyqUnseSpgraNYbD2+3cAq5Ek+WlCFMV4FoIphqmDJpiuKDi7BeH4yhvdfkUji6xhrAlKO36kLMISbaywoNyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Oct 2026 08:21:51 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct reclaim, direct
> compaction and drain_all_pages(), causing a 0.38x throughput drop on
> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
> system.
> 
> The root issue is that direct reclaim and direct compaction are too
> expensive for hot allocation paths that have fallbacks to smaller
> allocations.  __filemap_get_folio_mpol() already marks higher-order
> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
> caller can handle failure.  However, the page allocator still enters the
> full blocking slowpath for costly orders with __GFP_NORETRY, which is
> unnecessarily aggressive when the caller will simply retry at a lower
> order.
> 

Thanks, I'll update mm-hotfixes to this version.

Here's what changed:

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4930,8 +4930,11 @@ retry:
 		 * Reclaim/compaction cannot run, so defrag_mode's strategy
 		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
 		 * fallbacks rather than failing the allocation outright.
+		 * Not for __GFP_NORETRY: those have a cheap lower order
+		 * fallback, so failing beats fragmenting.
 		 */
 		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    !(gfp_mask & __GFP_NORETRY) &&
 		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
 			alloc_flags &= ~ALLOC_NOFRAGMENT;
 			goto retry;
_


