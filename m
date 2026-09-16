Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F58C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4A96B0092; Wed, 16 Sep 2026 18:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D2A6B0093; Wed, 16 Sep 2026 18:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71BB36B0095; Wed, 16 Sep 2026 18:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 439D36B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:35:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65FEC1C0FD4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:35:44 +0000 (UTC)
X-FDA: 85221083808.13.3BE0FD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6BF0C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:35:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="S//aGnBP";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789598142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGLJYjgnhN5BomAgi3vT5WzHyjvAyhNIqlfJD73iIU0=;
	b=h91YCdDAI2OSdy3PpJ6cKOLxY/bt3RUA6+vIwUWAd++UydAEOSdlGoKE0Y0G6wojgH0Q1c
	1RWHTPnZtD2g1N5K1jYe2Rdgw0+9vWHOvWEX8hC1EiS+qeRwiZoWvg2jLyam9Q6UnBxy4+
	ccsdwwGaOUxln8NSHdUHo5x4J0k2rMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789598142;
	b=UuVy1QZRqI6w/sQroxFIeRvcEVtvvF/AgIuFLqQnUvni/oF56r2r31j2ZpekdmPgWYEdsN
	+GRcJIrDYZ3cm2JUJROOlzqS0Gl868dagE0spaRRDyc9b5tyaPBPK3bInv1zHYPO9GtHYU
	Iuj2QGgvWuQTY4MOrmY2Xzm+cyjL/Tk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="S//aGnBP";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8312C6022B;
	Wed, 16 Sep 2026 22:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBD51F000FF;
	Wed, 16 Sep 2026 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598141;
	bh=HGLJYjgnhN5BomAgi3vT5WzHyjvAyhNIqlfJD73iIU0=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=S//aGnBPPGeBvhxSLtAXQy6/qOyf3BT9C340KFYopN6oDtBd14Tli6B4DgxKq7cBM
	 YZV79cvnVzC0ZvMTpy+c2DlqK9OCO1pz/YigbZ7uSxpbddpyvIMMNlFv9rSuQYv+Py
	 Q7DiEaE1wLjJ0f1IvOvNV7f0DFOEViM7CIQYiW74=
Date: Wed, 16 Sep 2026 15:35:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Salvatore Dipietro <dipiets@amazon.it>,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260916153540.9a3fb449f5b3fd481ca1b544@linux-foundation.org>
In-Reply-To: <20260916153426.3265e2e152cebb6a8d66373d@linux-foundation.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
	<aqQlUr-1h07G8JWM@cmpxchg.org>
	<8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
	<aqq8pWI0u1IZNWHT@cmpxchg.org>
	<20260916153426.3265e2e152cebb6a8d66373d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hjjaccx9c5pjchyqi4k5joe1sagd4bqw
X-Rspamd-Queue-Id: B6BF0C0005
X-HE-Tag: 1789598142-573975
X-HE-Meta: U2FsdGVkX18YgBBJrZPqELFns3WcdZ7mFHFehNYxvjO4AMzFBfmKqGPD+3dsT+0j9H3WdI2JhJhaNcYLSccpqywuuKaRP/UC7KX+m2pafMoTBSJfa5rpQy/F2VMgxUmHTy+R4SsRcbMflz8ZgkbV77+Pt9U/vyWfzvjAMZgxTfqV74kOYGwOp8ofvsiGSpomQbbr6Xu8D0vefWSWgtDC4h0i/UCXv/kJfAYFPj24uzZpbBs4G4rRFhOK9r41AD/124iI8qi22fyuLK06uo66tc5gRBzYjGIM5JMMpjZoSRvKLJ2/aqOHVqFsnPm5QFs8q5HA7M5lQP9CIzlHbk5oBA1xl9TuVArQOrOFktP9pPYO/cx52EOnA02FiFrdji3TdgNxjSpY4luj+kxpHNDPg1wt0ChzogWAIPxO83XvrAdFKsZKFW+MLlpnJbR02Ec+0QfmBvuuzbANUuRXb3jSFLioZoCv96kAppJ+ESaVPQTDjvNGvlmxYDP7D+SmlR6Jgy6yenply663tBzqYHJSYwRP0nhdYw+GFr72Ij91z5ymVVVQud4Tw++J1DWPQy07Hz7mPfygqJsinzi+nf3FYN3Js6noL8ahwnMFkC6mVXlodCcB1ealPA+hgx3kEePZVgEAVph2O+2rMyKqFZtnMZtzb4GdUuXOQ4UdsefCFpH40PORNCGH0sVLKnjmmg4kXiwAM3mMfkh1GUNqQWugSqBokwwFUmTttRD6yqXDC0mzafGYZDfvvgMy1gWjREP0dxBtHhnvb263dT5oQSJh8ZDJ3GubFBVO/DEyGyIsSiKDVtervlBPycPjZQGeTVbMlJKyWSK5qCXeW38EDDxCm+WJbP1cEDgeodOVBH7mWFXLp5xhmn1aCa7+B5BNkUPI2ahAqZ9du5DCgL8ROkv062Xe4N6I/QVN2YHWn0qdRrYo9njnA2m1fDghsolB1hT7g3SXK2aRvzXzlWvsAHL
 wUWmvZiK
 QMcQIpFO7+y05/xYsjn6/uAMyzNJ20Kc0SgCCsGiR2dD2GcYqH2wXLKysT5dDjELO2j3dfn2IwR3r9bX0+5h1aJUpKH13lHat/P5gin6Ok32lpkjM1JjwkIRwkukWf7Vj2WSUEZCtdHfd/r3adt4I1Exh4gpy70X29Y60H99HhVtgVzzuj3W65bOO0EfeWi0foMSctaEN9U+qUFJr3kh8MOHhGHqCtw5WIlhXW3lEMR3l3pSIiHPFhdc+GnL3TCj+eWVI+yMLQcm9IohvMPje/ekNV1m16oPge3SUiz79lHEeSMxhhkjk3PvWGW0I1OXVeiWXxKusPbE9H55c6qFSDgrf3Be1J62uH/cJofke6ogLyTN59VWS3qd55Xkbv/Nm2BF+8QhZRMGVAMxcQ4SkvKBwJoqs+T/gdu4yXvS7JxLvLTY6Uf2VIKSfnEdYLY5g7jS64Z5YKu4u9b/egGOfr37vZHG/bGnkugMQt3WLXMhSa8xCA4uIrXY+XH0bB+SZ9haJ55pa0dRObFj8WiFSm+pKIqxY2ouuPrPEC60P4ngolOBO370RNfbonhSLZMu9N1vMlxRFnOLrBzCcISgdqEFRyWNx25jBMhMvQuIMWhMWk2wl9pY7NbJvQfROE9VuV4nIoaxNKO67+T4PAFHm6UnTlWwMUfkHo8E5cq5PaFy69cNRmwxenxXx6KKLR6d1zzSL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 15:34:26 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 16 Sep 2026 11:58:29 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> > > concerns can be dismissed and then indeed v4 is the better version.
> > 
> > It looks like a real issue to me, but one that already exists
> > independent of Salvatore's change.
> 
> So I'm hearing that I should drop v5 and revert to v4?
> 

v4:

From: Salvatore Dipietro <dipiets@amazon.it>
Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 4 Sep 2026 11:56:28 +0000

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path. 
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct compaction is too expensive for hot
allocation paths that have fallbacks to smaller allocations. 
__filemap_get_folio_mpol() already marks higher-order allocations with
__GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
failure.  However, the page allocator still attempts full direct
compaction for costly orders with __GFP_NORETRY, which is unnecessarily
aggressive when the caller will simply retry at a lower order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  kswapd (and in turn kcompactd) is still woken further down for
background defragmentation, so compaction keeps working for long-term
system health while being removed from the latency-critical direct
allocation path.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                   Avg TPS      % vs Baseline
  baseline (no patch)       59,408       -
  With this patch          155,409      +161.6%

Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/20260904115629.3993331-1-dipiets@amazon.it
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4784,10 +4784,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
_


