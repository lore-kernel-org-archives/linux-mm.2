Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2499CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 17:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64CB16B008C; Tue, 13 Oct 2026 13:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6237C6B0092; Tue, 13 Oct 2026 13:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5394B6B0095; Tue, 13 Oct 2026 13:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 222F56B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:37:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5A151A0120
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:37:31 +0000 (UTC)
X-FDA: 85318309902.22.E3785C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E85F180002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:37:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZYKzWQP/";
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791913049;
	b=QtZY3wvIpYf+j3ldex0Jwav3V0yeAxNGdLNFgu5b2EbcIdalb9cn3uDoNUM9qyYGM7s1CG
	d69fXgS3Kp+GhHxuhXwFdy1TYC7FtB0F3eq9wmezBUumhJNnTTM1Qn5J54haWQ6H7B1hd0
	Qno1oSwLIK09AQvdof6AC3Qn21O4KvE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZYKzWQP/";
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791913049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItHOFurF0GFQRA6It6dM40DD3xfzAvazWxmgf/BUmBU=;
	b=o5CQFXox6gifegfTFIDWzFSBtpD2pRb97uildzHkY3GVdFK2+yU/w0T2QrNQx8oDwdek/r
	Vn2OuutpCFtBKQYOVhohgTOyo42Yy5LzJCBxjf+y+VBMTDKpJYeye2HmQrH9K+SSPKKXUH
	LITsnK6vKQMJzZSFiTLnz6B4ry9rIno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEB1160A5A;
	Tue, 13 Oct 2026 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAA01F000FF;
	Tue, 13 Oct 2026 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791913048;
	bh=ItHOFurF0GFQRA6It6dM40DD3xfzAvazWxmgf/BUmBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYKzWQP/TIQAZNuFvYlE3KC36JFXTs2ktUyKeVWKtIieEOmsEiHYg0ahihLsSVvY6
	 laVe4LsKmCdNc45nUKXZxwldRp/RlOUFCRufvmDNqARo6VAl0TI9Zpsz3pIOWYY7MR
	 oOHBruWUv/3F7gTn7/+lOoQRWAW3am6a5QtkXa/OsL6JLVpl84k+c523hG+YPu9ejC
	 +ZGG8PwwId+JJ3eioqI3/mOT7aoYq2FYTYlFFdIFn+peMAiL4FNwq1RntUrTZ/brDG
	 nT8gOX0/BP4/NDrm2KI/oDAfeyp217l4qTCT5iYiCQI0G3WP4EYMmBHlEa4wTLHY+8
	 auYJhGmUxd06w==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id BF8D9198003A;
	Tue, 13 Oct 2026 13:37:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 13 Oct 2026 13:37:25 -0400
X-ME-Sender: <xms:UmzOaiscHIsycxuF1Wgm8ZaCIteYieOUZxx2qBIeUFwvjzJIrUFHHg>
    <xme:UmzOavOTcG266AF0GEm0tljePNOQnfAYo-GxygIBpgUcR1QjwTle9lLOpm8dL05_x
    o1L9lV8VjmtGlYRtyWsdS389s1Ogv3IO4P--i9KpZ45O7NsHZplris>
X-ME-Received: <xmr:UmzOasV2Ub_zmk6MreDrMSuypAACJRVX4r2d8r-dQaogmy6-R86O5y3UMKc>
X-ME-Proxy-Cause: dmFkZTGaSLSNEdrEpWVq/xgKAXbkXcancctTX10+wEWv7DMcsnFyMgu9+pSYpo0VGFOySV
    moqua97KZBEfcR4gAqYaCIW/dVL+HGutfIxnyM/WMpKSFNOwWBAosBp80UQh9QHl5/YiY4
    MOtQzMc+1xN/31ohrlOj3YBYtA+TqEjCBxfGTbFh21jxr7Gfuzku5fTiethsnYdr9GTMBM
    0j+646XIMSxbqATS/8JFZzGxEDYizeMzj+edNYuEE8SF4x38s/H5eKD9u/XfKtOq4KT0TW
    HRw2Z1fB7+Gbs3+g6ytGsmBu7/RUOPsrbzRBZNdNopaeoLebR+yMz4uidOcDXUemElOroY
    cMo+bboCvjwLN/OgFggpHevhsSrTU17pItrWJv+cR6fRbzmYLgfQTwPH7nSjLTCjyCUS8B
    CrnMWvmxK2qg2aswD+/4jY/JDhHQY0+uqbMOSJdvVs/l1h9EIR8zHZuuFlGCjVIXMntNzA
    x7zLHGJouJeFyPlhRZIJc5pNPSuIKRhaOG51CDwitW+DZP2tLc+JdAizl/wICHphd9Hr55
    BZQvdYNnAc/MdPGGSwJ6JuX5zeH1WQHdiRszkoIOIFwqEg4W/o2L7oV1Ey1ZS5WlcErIZV
    2lrXKG4/abPTJzXJxCkoLPSx19kBwJjVFQzDY1ltisveB/pLiUyjn2yVWdMA
X-ME-Proxy: <xmx:UmzOaniRk_PRwRPKssrP03tWmo06v0Jmva8PSTxl3Dbl7Hrnk1Vh-g>
    <xmx:UmzOam1r5wB-rj3wVqowbf7-wI5AIOC8eEVMyJYwhDxwq0ot4dPqDg>
    <xmx:UmzOap20-xyq6k_q61RuwrWhyJWqxbVMTsl2T-s2LjKTvyb_C-Zm3A>
    <xmx:UmzOanwk8k9iBfBICuvaAaD-5-biwfJgSiE0W0HCf0RcBZQIusG-6w>
    <xmx:UmzOavuGzwbHJz7CGTbgaicls3plNiHfxHdT0MTm_JKBVn28rqELrNWd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Oct 2026 13:37:21 -0400 (EDT)
Date: Tue, 13 Oct 2026 18:37:20 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <as5q14OsbK2CmOrh@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
X-Stat-Signature: ms4oz7szsceik98bt8si8xxo5d4e4xpk
X-Rspamd-Queue-Id: 9E85F180002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791913049-213548
X-HE-Meta: U2FsdGVkX18AL6gdvPP+DAMeV4eDwOHO/nPodUJi2/AuyLxmVl5Rfh405il0/S0bEViyRDJzmwy3EGffRz8k2NFnRBe3zp6oBWwk7qvUGr3XBxqgTDxqJHe2eoaCbuE02ST4vGCuy5y6MxyvCJlocSTtckCtUUQ+EVM7VrzSGgOcztlpW1oH9DNzNNPh6wQ8EWbPKJGAcZdgmaeUjB3m3OKPaDe+3O+MEsPG+Wkm/02I7tBK81dp58K1R9fL6OBaSbzd1vAl8plyVKEi4etgM3WGvBi+ZH+TXvadt3JZy0OtW93jl5T+BgQ830MOYYAsI0CVgs6ozsl/JhJDrLL1W6qaqOY5hcHZLVijGoUy3Mwyj/swhXl02Lw5G0i4tka26ZcR5KGxHyezHgwVLv5WXoOV0ynsOQlOYBIGf5KloBFZNsO4sCiauQUDP/jE+brtz5COFdTtf2X7GbQ0bqd4ojRAHs4gofH3mdY9hDtL4EqOWskZByRhn3GnkPj/CWAdYb63qFUBy5f0odvpqhXcvuS88jW3pqINhNuS/wkLrmppg5czq4SKIltEAdY1Y7VfaEXo9SEO800UXhHHMUK017xm8vPOQeK8Akt0XIyW/aWHQD4WCvDuXFlgMjH4OeOTEjKTj6THkiYpkiQRqr+a/sgyrUDi/jM6rOYVxwjQ/hbeSp6hPef795EZ5dAxAlZsos7U35g4H4mp90j/UsNF3sIbzo7t+2iGJc6Y5vG7fqBT0THIPU6SjD0Ua+Dd+gZ+uDre+p3fAOmgx26pNiQszXjUjpukcCz3GUou5EoF+Vla07Z/O4/68O+pKvnoNmObW80x76yBABiXEaRbyjrjAPPuiHvFu29EAFnfp44kZUSbuLXboTnaXEP7dsTcPDxkE0yTjytLwkV/Wn7Pqz7Xzv4tBurX0WSvRD5vOz0YHrC6n/xYW2pG4g8A3nFnUqAb6BDLHMHrTzqwQQn6FTq
 nPPUhMTF
 FV0dGh+e789R7MIsdPXALaqVS7z8WupGmoMPvcq6XMURMRVlyNly4csAdNRUlly/SXZziZBzpjaxVoIhpCWGUiprzdDYO2IPB9/fWlDjETjxTSyiFSY9G8Ey4mAikt5Puq8SQs0tPiXyZc+LhD08f5fboosaUiBxWpKUAuJizo9RXZEnMycB4IPOPRiWYk3WsDtdcNg592a8oygmzM0kgBl2EudrGVdN8qYnahs5vdD++jDiGCazf/5KZqgiByfaOBKQfJ6VEJtFPyDTRN+/nAmjF7XSwepOjBcIRlh3P5U7tIv6zJE0IX8vthtUsj/xnE6toEP3p0Zanm/QCjYCd13GE/vWdFN3wArvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 07:28:34PM -0700, Andrew Morton wrote:
> On Mon, 12 Oct 2026 13:40:36 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
> > > In a VM reproducer (32G, defrag_mode, inode churn under memory.low):
> > > 
> > >                                         before    after
> > >     should_reclaim_retry() calls           63M     293k
> > >     peak memory pressure (PSI some avg10)  99%      12%
> > > 
> > > File creation runs 5.7x faster.
> > > 
> > > Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
> > > Cc: stable@vger.kernel.org
> > > Assisted-by: LLM
> > > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > 
> > LGTM, but I think we could simplify and get rid of all the function
> > parameter additions by adding a field to alloc_context instead? We could
> > call it e.g. reclaim_compact_order.
> > 
> > The function nofrag_promote_order() probably doesn't need to exist, given it
> > has just one caller, could be just open coded.
> > 
> > What could be useful instead is wrapper for comparing order vs
> > ac->reclaim_compact_order. E.g. something like bool
> > order_nofrag_promoted(order, ac) ?
> 
> I'm concerned about the sheer size of this patch.  It fixes significant
> issues, but it's not going to be a simple or safe backport.
> 
> So for now please let's optimize for simplicity and backportability and
> defer cleanups for the -rc cycle.
> 
> Of course, if the changes you suggest achieve that then go for it.

They do. The patch with Vlastimil's suggestion is below. It is shorter.
Behaviour is unchanged; the reproducer gives the same results on both
versions.

Vlastimil, does it look like what you had in mind?

> Perhaps we should defer this change into next -rc?  It has cc:stable so
> it'll eventually end up where we want it.

Do you mean the next -rc cycle? I hoped to get it into 7.4-rc1, as we
agreed earlier.

----------------------------------->8----------------------------------

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v4] mm: page_alloc: make defrag_mode retries follow the promoted order

Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
storm in defrag_mode"), direct reclaim and compaction for non-movable
requests under defrag_mode run at pageblock_order, to produce the whole
blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
still use the request order. An order-0 request can therefore retry
indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:

- Reclaim at pageblock_order gives up after one pass as soon as a zone
  looks compaction_ready(), and do_try_to_free_pages() then returns 1
  even though nothing was reclaimed. It returns before the retry that
  would reclaim memory.low-protected cgroups, so when most memory is
  protected, the pass that did run finds next to nothing.

- Compaction at pageblock_order fails or is deferred.

- should_reclaim_retry() takes the reported progress as progress for
  the order-0 request and resets no_progress_loops. The request
  retries.

Order 1-3 requests loop the same way, and should_compact_retry() also
checks their pageblock_order compaction result against the request
order.

On a production host (64G, defrag_mode, memory.low covering most of the
workload), 95% of direct reclaim runs were order-9 runs that returned 1
with nothing reclaimed, at up to 60k runs per second. Across ~200M
should_reclaim_retry() calls in a day, no_progress_loops never left 0.
The spinning allocations were SLUB slab refills for inode and dentry
caches. The time spent registers as memory pressure, and pressure-based
OOM killing takes down both workloads and system services.

For promoted requests:

- Reclaim progress does not reset no_progress_loops, as for costly
  orders.

- should_compact_retry() checks the compaction result at the promoted
  order and does not retry COMPACT_SKIPPED, since the request can fall
  back. The compaction priority floor and the COMPACT_SUCCESS retry
  limit stay those of the request order, so a non-costly request still
  gets its COMPACT_PRIO_SYNC_FULL pass before it falls back.

When a promoted request takes the fallback, reset the retry counters,
so that the fallback attempt gets a full retry budget before the OOM
killer is considered. A request whose reclaim was not promoted spent
its budget on the request itself and keeps its counters, as Usama Arif
pointed out.

__alloc_pages_slowpath() computes the promoted order once per iteration
and keeps it in alloc_context for direct reclaim, direct compaction and
the two retry helpers, so no callee has to recompute it. Harry Yoo asked
for the promoted order to be explicit rather than derived in each
callee, and Vlastimil Babka suggested alloc_context over new function
parameters.

In a VM reproducer (32G, defrag_mode, inode churn under memory.low):

                                        before    after
    should_reclaim_retry() calls           63M     293k
    peak memory pressure (PSI some avg10)  99%      12%

File creation runs 5.7x faster.

Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
v4:
 - keep the promoted order in alloc_context instead of passing it as a
   new parameter (Vlastimil Babka)

 mm/page_alloc.c | 65 +++++++++++++++++++++++++++++--------------------
 mm/page_alloc.h |  2 ++
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..c593913a14f8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4127,6 +4127,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+static inline bool order_nofrag_promoted(unsigned int order,
+					 const struct alloc_context *ac)
+{
+	return ac->reclaim_compact_order != order;
+}
+
 /*
  * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
@@ -4149,22 +4155,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		.order = order,
 		.page = NULL,
 	};
-	int compact_order = order;
-
-	/*
-	 * If fallbacks are not permitted (defrag_mode), we either
-	 * need to reclaim space in a block of matching type, or clear
-	 * out an entire block to allow __rmqueue_claim() to convert.
-	 *
-	 * Reclaim by itself is primarily freeing space in movable
-	 * blocks, since that's where the LRU pages live. So this
-	 * works for movable requests, but not for others.
-	 *
-	 * For those, promote the order to help make blocks, instead
-	 * of spinning in reclaim alone unproductively.
-	 */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		compact_order = max(order, pageblock_order);
+	int compact_order = ac->reclaim_compact_order;
 
 	if (!compact_order)
 		return NULL;
@@ -4257,7 +4248,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
 	int retries = *compaction_retries;
 	enum compact_priority priority = *compact_priority;
 
-	if (!order)
+	if (!ac->reclaim_compact_order)
 		return false;
 
 	if (fatal_signal_pending(current))
@@ -4266,10 +4257,12 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
 	/*
 	 * Compaction was skipped due to a lack of free order-0
 	 * migration targets. Continue if reclaim can help.
+	 * Promoted requests fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
-						   gfp_mask);
+		if (!order_nofrag_promoted(order, ac))
+			ret = compaction_zonelist_suitable(ac, order,
+							   alloc_flags, gfp_mask);
 		goto out;
 	}
 
@@ -4468,11 +4461,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
-	int reclaim_order = order;
-
-	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		reclaim_order = max(order, pageblock_order);
+	int reclaim_order = ac->reclaim_compact_order;
 
 	psi_memstall_enter(&pflags);
 	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
@@ -4648,9 +4637,12 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
 	 * their order will become available due to high fragmentation so
-	 * always increment the no progress counter for them
+	 * always increment the no progress counter for them. The same goes for
+	 * promoted requests: their reclaim reports progress when it backs off
+	 * for compaction without freeing anything.
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
+	    !order_nofrag_promoted(order, ac))
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -4934,6 +4926,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* If allocation has taken excessively long, warn about it */
 	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
 
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	ac->reclaim_compact_order = order;
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		ac->reclaim_compact_order = max(order, pageblock_order);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
@@ -5015,6 +5023,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* Reclaim/compaction failed to prevent the fallback */
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
+		/* Retries went into making blocks, start the fallback afresh */
+		if (order_nofrag_promoted(order, ac)) {
+			no_progress_loops = 0;
+			compaction_retries = 0;
+		}
 		goto retry;
 	}
 
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..2b1017a91928 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -93,6 +93,8 @@ struct alloc_context {
 	bool spread_dirty_pages;
 	/* Only flags that are global to the whole allocation go here. */
 	unsigned int alloc_flags;
+	/* Set by __alloc_pages_slowpath() before reclaim and compaction */
+	unsigned int reclaim_compact_order;
 };
 
 /*
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

