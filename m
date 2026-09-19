Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C98C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 04:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B536B00A1; Sat, 19 Sep 2026 00:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533256B00A2; Sat, 19 Sep 2026 00:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4709B6B00A4; Sat, 19 Sep 2026 00:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22D6E6B00A1
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:13:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60F021401A4
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:13:30 +0000 (UTC)
X-FDA: 85229192580.28.A48B78F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84C33100002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:13:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="KxkbrE/m";
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789791208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiO0TWZHHNWwqUMW8uqL6nQVaMHOdCC7NYfz1C+CayY=;
	b=TFwQnp6bAI/DLJqTYcmF264jua+8JjajCnhroeCpVWVOW5MVFsOfZDHeUeI7NdYZB3r86N
	9ECovoPCbmpbYietCOA6K2LBLykZur+oCmm/wo/IdVRrCQ3Bry0zVBO42BTwJktu+O46J1
	fdc7DO0RH1bL+tq9V3scKS4PQtGJ9Q0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="KxkbrE/m";
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789791208;
	b=K5CR8Ai20o/f9IJzmc2f8xcvUNDhsLS2q4q18r1t+wOvzjhiwoS2pUwBiBcrwR//jvI37x
	OOWLgmueajejOvmUwPoQdJHkTSps57KNveTxl9+XW15RIXAYOy/7r+PpYnVFjW+5/m7tZq
	vIF/OoO2W9pMfvx6jrIZsIFxIIQqRwE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KiO0TWZHHNWwqUMW8uqL6nQVaMHOdCC7NYfz1C+CayY=; b=KxkbrE/mupwUjixXuC/T+0QTHP
	srTEmVpGo+8KQF1rvUPvCMBhUDd5E8wsBaB+9ZCczfbODXNECvKqZFViCBVOjFlcgfnLtDQvXj4zN
	V/pFmBx+GB2e3UT7etpgWZxDouLRNogvtXROMDjp+A1cLXu31VhJvCIAo0MzQCr2g3wj4nOu1fKNF
	m3tsJlryFoxGyWL9XW7Il6NfCGBUixGYuSEqgKIfUnm00oWSyqpxO71m33SjjPkvFZ1lh1DMwgW7Z
	HnkpuUodJPdTUefimjjWZ0wOdxDJ2+BvJGRjHlvNbwgUnb5cKBTvV1LIt07IxqnyOUyac1fPXHKoM
	EvP2h+zA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7mRv-0000000BY9m-2fNU;
	Sat, 19 Sep 2026 04:13:15 +0000
Date: Sat, 19 Sep 2026 05:13:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Salvatore Dipietro <dipiets@amazon.it>, abuehaze@amazon.com,
	alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
	brendan.jackman@linux.dev, david@redhat.com, dgc@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org, hch@infradead.org,
	hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aq4L29SBCYwvKrw2@casper.infradead.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <20260916153426.3265e2e152cebb6a8d66373d@linux-foundation.org>
 <20260916153540.9a3fb449f5b3fd481ca1b544@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916153540.9a3fb449f5b3fd481ca1b544@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84C33100002
X-Stat-Signature: s3m9cwojpy5bi138qfjwtdf8w3wonxta
X-Rspam-User: 
X-HE-Tag: 1789791207-322903
X-HE-Meta: U2FsdGVkX1+KnslZ9KCfLZDiDs06pJ1r6RD5NRRk16IslX17y4xEZqBlCOHP2GtfCMriYnWDoGLwHLUHOdUF2nxhROuCE2ncgrR+D4BCuWAJFJ2bifCVRc+E1Ao15+TeCy0PTmjZwPWyfRFgJGGjydSNIk5INFtdC1RsRz5AgV9EEAnaCWwigWktbsx5kP+ds1WjTtr3v7M+bSIq0i2Dm32qE9IJljSdDVNcoWWFD68EwDhqrxlcwVB6voT9/bcLSJ2hSet9ZFa8aNqyEscaJlGO3+G5WH/4/dKnb6ge+pvppt8KNr8lJ3jBmqXQWpQR+Z1g6n+0rYH7eXH6eU5I0tEAOHu4Ov8tKXJa/K1PKO4+wiLNtBBm0lhaRPvo3M7z+nz1hdWEwJVECb/fnJ97YOdxU9HSwwZK+VNp1znXQ14anzdzXYsbS9ORIGr24OvC7unMiirhj72irMnCuW58GFiY1wUzndV3HdVosONFF1EDRVH0HZIt2vTe/QAbh6dzYKwqpVn47UCpUN7qKOJy/3f9hpwomO+JGnM0+mQ4i3jvNBA6D5L+V1sTcnoK8TQ7i1kAMC9fuQOzh4n2fTTPaPoFmFZBHH7fkhqrkTL4/u+2JM28QVVZTRFmEfBsU0QdAhIUY2K2yglfVFlTFFcSovVvzOfkLwW7afFgljs+ivKY+2E04LZnxWbtiLpakeVK2sPuWZ25a7HqIBaClQSX+zgk6cIBc74ZO40V/CEXC0c8JdgHJcvfHdaT2u/rfKUyKeDq2WRSmHmwPe2JeSrevXzix0sH66XUSKJcKcIYdOZkmNQnJUjUhNvGbZB5yZNVkAGUt5S4YJO6aKDxGS59mssPEzGEfA+xpcw5nvQ3v5y1fFkd4GeG4HqDjZk2EDfa3XTVdzujC2nPbkoGWZHAHX68QdtCdtyeiwkv4mhHZ40UPjLR9CMMFyxV3qhKR0ZleQxAo97wLn69cBkXAmz
 L0SdmpZq
 rPpHaTMdUP4l155iuRa9OJCzMhSRUDtVKNBiPe0xLIjynkcPc4kN82h2I+ZpBoFLJnIDYLd1+OcU8qbDwMRNiAGXU/Tq6llmxlUKV5jsaNh+wk1KcDiKdFxvK+IeuWYUzVyaH6TIcEh9Wp2lhkn4L9yhgdYzejRaFCxVX2P0pr3bsr4jkrqaCkw8EQRt2vx6Klr4VcHc8rGKovooG/QWcK0hNJegy3A3GhjtWfhB7YBLpBCGv4wIiaZhsHUGroqjrmI2WqIXqfV7eijJbyqJtDqToWzj8oaCa7TdQO/BiKiFrZX5vfRcReMvIThuZH9DhfCX0XC3G7qkOisTehmrE0SiD3AebEKdsr99XemVnyzRoR6aPDYZzoJK2Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:35:40PM -0700, Andrew Morton wrote:
> From: Salvatore Dipietro <dipiets@amazon.it>
> Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
> Date: Fri, 4 Sep 2026 11:56:28 +0000
> 
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write path. 
> When memory is fragmented, each failed costly-order allocation enters
> __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
> (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations. 
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, clear
> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
> can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
> makes the entire slowpath treat the request as non-blocking: no direct
> reclaim, no direct compaction and no drain_all_pages() IPI across every
> CPU.  kswapd (and in turn kcompactd) is still woken further down for
> background defragmentation, so compaction keeps working for long-term
> system health while being removed from the latency-critical direct
> allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.

This patch is still piling hack on hack.  We haven't made a serious
effort to understand what's going on, we're just adjusting flags until
things stop sucking.

What we know:
 - Doing compaction every time (which is what we currently do)
   performs badly
 - Doing compaction once at the requested large size and then not
   again until the smallest size also performs badly.  So it's not
   that we're doing too much compaction, it's that we're doing
   compaction at all.

But we don't know why compaction is performing badly.  For example,
we could specify MIGRATE_ASYNC or MIGRATE_SYNC_LIGHT if __GFP_NORETRY
is set.  Just as a reminder, here's how __GFP_NORETRY is documented:

 * %__GFP_NORETRY: The VM implementation will try only very lightweight
 * memory direct reclaim to get some memory under memory pressure (thus
 * it can sleep). It will avoid disruptive actions like OOM killer. The
 * caller must handle the failure which is quite likely to happen under
 * heavy memory pressure. The flag is suitable when failure can easily be
 * handled at small cost, such as reduced throughput.

So the callers aren't doing anything unreasonable when they say
__GFP_NORETRY.  It's the page allocator (and apparently the compaction
side of it) that's not living up to the documented contract.

So that's one approach which has not, as far as I can tell, been
investigated.

The other thing that icks me about this patch is how complex the
condition is:

> +	/*
> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
> +	    !(gfp_mask & __GFP_THISNODE))
> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;

So basically we're saying that __GFP_NORETRY means don't do compaction
unless __GFP_THISNODE is set, which is just special pleading.  Surely
the right answer is to remove __GFP_NORETRY from the one caller which
needs __GFP_THISNODE?


A slightly unrelated critique of this patch is that it's far too
complicated for what it does.  We could achieve the same thing by doing:

 static inline bool gfp_compaction_allowed(gfp_t gfp_mask)
 {
-       return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO);
+       return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO) &&
+               (!(gfp_mask & __GFP_NORETRY) || (gfp_mask & __GFP_THISNODE));
 }


Something I've been noodling on the past day or so is cleaning up the
GFP flags for "how hard to reclaim".  We currently have five
possibilities encoded in four bits:

1. No direct reclaim (__GFP_DIRECT_RECLAIM clear)
2. Light reclaim (__GFP_DIRECT_RECLAIM | __GFP_NORETRY)
3. Normal reclaim (__GFP_DIRECT_RECLAIM)
4. Extra reclaim (__GFP_DIRECT_RECLAIM | ___GFP_RETRY_MAYFAIL)
5. Reclaim forever (__GFP_DIRECT_RECLAIM | __GFP_NOFAIL)

Clearly we can save ourselves a GFP flag bit by encoding those five
options into three bits.  Some of the code that manipulates "how hard to
reclaim" will need to be adjusted, but it shouldn't be that many places
to change.

If we do that, we can insert more options into the mix if they're really
needed.  Like we could have:

0 - No direct reclaim
1 - Light reclaim, no compaction
2 - Light reclaim with compaction
3 - Normal reclaim
4 - Extra reclaim
5 - Reclaim forever

and we'd still have two extra states in case we need to add more
flavours.


