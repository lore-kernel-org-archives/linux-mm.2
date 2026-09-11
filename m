Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EEAC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486986B0095; Fri, 11 Sep 2026 10:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DB36B0099; Fri, 11 Sep 2026 10:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374AC6B009B; Fri, 11 Sep 2026 10:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE9836B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:21:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 220D540231
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:21:41 +0000 (UTC)
X-FDA: 85201694802.08.AB6268F
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id E00C218000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:21:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=X+yviY5T;
	spf=pass (imf16.hostedemail.com: domain of "prvs=707ad833e=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=707ad833e=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gptPpxw0wFk91egaNInUnptSeER0SPdng9bGfnf/tP4=;
	b=NYHp8DWvTCKv9KyFbDkuZNKUfmE2EhkdHsF9TdfVGCRzEs98RSZ10AMxemVQSgnw0eBZQj
	EFbCfNovkFn7JTG+2xqD/MGVPugwP+0/A2sZYEwQh1L0gnMLmjgRCh12sLAHSYI5IzUXPb
	IwV5vTHqMMEHnERDqmSanLkNoqjPp7I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=X+yviY5T;
	spf=pass (imf16.hostedemail.com: domain of "prvs=707ad833e=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=707ad833e=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136499;
	b=T1CMXqWirEYqL/BRx4s/rN9l8IfDXRpmMtQaX1N7zjnJ47AiT2GYm9+nAZpNR8b1QM7q6t
	tF2wCWELKLxJlz/oHlkjtanT5VBwGFiV8i8Jz2/S3rlK7CbHCuyPIec+UXoQMPfEKflAPm
	XEeXcJOEoEYhsHI37U89xWKDVFqClKc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789136499; x=1820672499;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gptPpxw0wFk91egaNInUnptSeER0SPdng9bGfnf/tP4=;
  b=X+yviY5TQlCINEjU0Ig+5TCtM2x1Pk4SrIcMnZB1HsJ3JMieHyvB+0E0
   Q4jXjIgWJ09dAgNOEgn3o/UBb8amTlVjeLNpZ6MRXNpba0oe2VltP2seI
   x4Dj7SMwBDaHEtYsQZqcY+3TZYTJcCClMEg7iKSSq+oyKRDWqiPmsm+yW
   ygIici9ORddbrrqtUM+KdDi0nDswNhynGmItb1rFXJcQPLZt9CnlOhlQo
   HBrN/Vd/aKvRFMtMhKeWgVxTwp9K6dBGh8gXs8bdebN0eSRQWkcf3a9L/
   L/SkxnFLx8LU0cCxEU77m9nC+8h6WKOPeT9jB7ed9mEc5bexjIh33m3uT
   Q==;
X-CSE-ConnectionGUID: I7XG1V8IQNGYo35kGCunpg==
X-CSE-MsgGUID: TOfcsjxZS1+qduGqGhMONw==
X-IronPort-AV: E=Sophos;i="6.27,97,1787011200"; 
   d="scan'208";a="28340119"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 14:21:35 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:24846]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.198:2525] with esmtp (Farcaster)
 id 15edf2e1-39ad-4826-a4a7-d73e88fdd306; Fri, 11 Sep 2026 14:21:35 +0000 (UTC)
X-Farcaster-Flow-ID: 15edf2e1-39ad-4826-a4a7-d73e88fdd306
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 11 Sep 2026 14:21:34 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 11 Sep 2026
 14:21:30 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <hch@infradead.org>, <abuehaze@amazon.com>, <akpm@linux-foundation.org>,
	<alisaidi@amazon.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, Vlastimil Babka
	<vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Christoph Hellwig
	<hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v5] mm/page_alloc: avoid direct compaction for costly  __GFP_NORETRY allocations
Date: Fri, 11 Sep 2026 14:21:02 +0000
Message-ID: <20260911142102.2294202-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E00C218000B
X-Stat-Signature: b8sfr3bwwsei1ok1k3cbhc9h3h3n7ma8
X-Rspam-User: 
X-HE-Tag: 1789136498-463300
X-HE-Meta: U2FsdGVkX19B6mrxEp1b4CGtm8Yw+n94t0sHbOCfS3p+MPmMdrwJqL5+GJ2zj0fSCrBCcqod+2DjTvhyuBABFu7KlyWAW5tBbRdw0sUi7PRnyZm/2KAy7mmjbkBcXmver4jUZ/CfLlXWUMEgyR2SMmxJgsAJkxAIxxUrs0NUweUIoM29gUIZVVYjWDabNtPpi4N0GswoKzt06AEwh2DzR3Ue/kuNLvZSKL+ZiKqVLuP6ifaDiPrkiU+shjUcSjFm7+sploAFGPtfZQkK1J93A+uNU0JqIlt9iUaAzpBSAMVKg+Y9TQ1fiAlwjPPlsZzZKLwht+Xy6dWz4jXnFaaVuiSAJVicU3rxBH2H8FG8K+Fx+PQzawP6Pk7pZxyJ28qfnK/q7Oicph993ge6pilMg7ymUCHfJSXbRAjyoslWvQH+lM6kx+rFAvxI4ffHMDKOfeyc7Y2mBvP1o2iY3Ic8lTzYgnMOviZAUQuZ51JGpOOvXh2319nOXX5VYj0oOzgvbCsH0SkhWqr2bfzCCHDllKljf0RZuZ3wQVzAzXSlqbVlIkhy1OVEoycRUItEuBlCa+qpJyWIyfpyAgmpRf+72X7Py3OHQNbzEV19D8LbLCMpvr4yASnOXr98VJ/tOSyBFMNpIBdhh5zZfZ9LyfxzFd7bbGXybv2p9w0WzsXmK+wtt5y9yhbWprX8EqHDL0uJwOAtvXn2xg8BsAArKzE0a0XI9rFc7ATU4V8o1e4Z7Z6DEq9IDoG+gs/XIsWTlmw6oU2p0thmeTO84jx8YaANiEK6fPXBqExXRZ1RsbA9VxMHNY6zwZXHPfPI5cVzpBjerBBp0RKSZsVIvDsiFw7WvNV9QxDBs59CTzX+YyUBbbhuoiKwUVGkBpCDG6wkSojnlklRhExl4ZzTVK8Eja4WLuqszZP28Jzrv86o6Lr5NCbPBdMxQ7cJajRRMkoIYAJOHYBeF/USFY/y6phh9I0
 EIxIns98
 8lyyenJd3RwZbfxHmoCay8cgZALFCl+9/aShb1K2pdhqJTBvtf9eFO+9pBArN7tPRD0SaQSn0xsITz54JKHtr1n2XApGHdDlbHKQNsQSGL23qCGGnKscvZUaTgE6rwdhhavJNZKPpa5Hztwppcy70mlJ46IoDKmZ1/Dw6vrg39ipUap/FdfYE7tBE53Y25640bLgJaytvqpQWzXTXoZ/rEY3elBHUGdSeg8OPSNjuXUGj0wCB65dPjPTV+McI7hSZL3ISgMf52bXzI77U9Xw2dy9j6NkB9O8nB0iHqfSVi/TUD5VzwawuA5m2cZChoZLrdFUAQm+FbME0iMPaaPovf33axHwFmm6mJUlfaATigf7iSQI7u3jENLDK/HaaODtkByo2wnvJ1wkvsKq6vhGCo7IErfel3B6TaXrRfmk3JWHHC5egbPGYUqFSHZpgpth2y3RCHFDFHgAJWMsNRVUrfbBoK8oS9XGAtupKAOfCXK+H4+5ujzIhQ49ZYTPU/WlLOSJk1ny+gpmZtHXb+9faVq8RzY97z8Kri5V3ba3VIf91ao1JT8rpjs1er/Dr8jC7Mli5uMEMjJ44AjVIWHAa+SBBbRgFytpImr8C3WfucdKqfYXnAdi3mrxbIP0u9poUCSL/FNkU1oaOLa+nwv5u/aE/kwERi04+WyOHikD7HquRc4RhQGsp/jFLSHQ9dK/6gwnI4AnVJ7crV0J1/+hW9lxjSbsCsKqJ+JVvhxsu2Zc/DAl0uw1zyD72Wn8u+8v+hb5mmyUCbHsPC+uJx0InX0YiCwDZ1xfKqP64Ol6qiMHZpsPHGLS3QWNC6C7X3PmsJtJtcea+fwwhEr5k42kMpVR2XANvc5h5doWI3mOcV3yAHOmXeLW3gZtWuO4u0JkjB07STbd5DhVwOiVVlgN2RA8LQy8JmckzzH0TO7DeSm0JyoQly2tV2T8ZJX1wh1ggJsMrpWYl0o0lLIa2BPtU6HXKsM0S
 20OoRPYT
 ETaqEKN0wKl+d2F8oZa3nslMe8mzGSZIQ4VzLgu0unHsp+pcfRE2Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write
path.  When memory is fragmented, each failed costly-order allocation
enters __alloc_pages_slowpath() which runs direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct compaction is too expensive for hot
allocation paths that have fallbacks to smaller allocations.
__filemap_get_folio_mpol() already marks higher-order allocations with
__GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
failure.  However, the page allocator still attempts full direct
compaction for costly orders with __GFP_NORETRY, which is unnecessarily
aggressive when the caller will simply retry at a lower order.

For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
for the whole slowpath by computing can_direct_reclaim (and hence
can_compact) as false.  The !can_direct_reclaim check near the top of
the slowpath then short-circuits to nopage: no direct reclaim, no direct
compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
in turn kcompactd) is still woken further down for background
defragmentation, so compaction keeps working for long-term system health
while being removed from the latency-critical direct allocation path.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
must-not-fail allocation is never made to fail.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):
  Config                                       Avg TPS   % vs baseline
  AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
  v7.3-rc1 baseline (no patch)                  59,408             -
  v7.3-rc1 + this patch                        161,994       +172.7%

The patch fully recovers the pre-5d8edfb900d5 performance, bringing
throughput back above the pre-regression level and well clear of the
~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
directly comparable, but it shows the pre-regression level and confirms
that the ~59k baseline is the anomaly and not the norm.


Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
v5: Derive the decision into a local flag instead of mutating gfp_mask
v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
    __GFP_THISNODE so THP attempt keeps using direct compaction
v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
v1: Avoid compaction in iomap folio allocation

 mm/page_alloc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..be8b0d72a2db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4784,10 +4784,22 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
+	 * so don't stall them in direct reclaim or direct compaction.  Exempt
+	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
+	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
+	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
+	 * change the alloc_flags derived by alloc_flags_slowpath().
+	 */
+	const bool costly_noretry = costly_order &&
+		(gfp_mask & __GFP_NORETRY) &&
+		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
+	bool can_direct_reclaim = !costly_noretry &&
+		(gfp_mask & __GFP_DIRECT_RECLAIM);
 	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
-	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




