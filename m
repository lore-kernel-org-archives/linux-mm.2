Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3482C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91936B008A; Fri, 10 Jul 2026 10:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B6C6B009B; Fri, 10 Jul 2026 10:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3856B00AD; Fri, 10 Jul 2026 10:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6687E6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:34:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F378FA0417
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:34:53 +0000 (UTC)
X-FDA: 84973113666.16.433EA26
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf10.hostedemail.com (Postfix) with ESMTP id C163EC000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:34:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=DEiMuH4Z;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf10.hostedemail.com: domain of "prvs=644c5a87c=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=644c5a87c=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783694092;
	b=bZtIFZkrfJRsgptc22edEcp/otiSat4T+lMllSH1xFOEUN4DDctJG91sGXn6Vd7o7IRDv+
	qI3dOtRreHdBNfXCXxjZ9qma3A3Q612wUyvQufasEgfCWVfVGpqgujhLvu8lTOl5Ash0yG
	72d1Fmo/C4beRrDou2jKAAfHvy7M6J8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=DEiMuH4Z;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf10.hostedemail.com: domain of "prvs=644c5a87c=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=644c5a87c=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783694092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=17wN6bI8K7p4bpbOPomGtPmEnN2JA1DpTrObaGoec0I=;
	b=h5qCB3jsyVLCCnMJ9/aPYSZVPfLkpzRh19DEqvC2mcbHd+VEMfLMOq7nht5QLn0IqF2+oS
	EfYu/elWNX8ljWX+paDZdtK3o3L5EpUWbElMmQljwEEsUwZcGKufwVrqyEX20XbIRfyjja
	xNAHcbMgndPhE+VgqJdol5as9xgLk3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1783694091; x=1815230091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=17wN6bI8K7p4bpbOPomGtPmEnN2JA1DpTrObaGoec0I=;
  b=DEiMuH4ZIs5KUcY22shQw4+NE22gJ8GU58HlF8gXwCKY7xKXtRXzxajz
   4fBmgwMyWUsn0ZIgXXPxt6P3DLXLBmdJ/mpTll5Tb10x72EvyOkQSK3W8
   sTHNJqNbD5HnTEDbt6tzTtLKwA/DuXvmQMs3DkeGxRiNM0LmBwXuXERy/
   Qk5m/qhoRHboQSy3zQWKzesKajKjZarW/mJBS+S4xzR8krvx4wNSFC1Xx
   JzYJcvyvpS+DF+lpmTo1Nd/eAHDy6AwHdE21hH7aQn2ZCEDHo5TrfuptF
   mlu6opgk6VMKAjy3nTjWVwCd5J5VQrwZZR7ipcf0zfqG+jXHCphdcHvHz
   A==;
X-CSE-ConnectionGUID: qoQZ4hc2TiOj5y7MNgzhAg==
X-CSE-MsgGUID: GJ86N9zrRr6DpC/VgnKiDg==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23425232"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 14:34:48 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:26245]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.115:2525] with esmtp (Farcaster)
 id 120982db-2d0e-4772-9af7-73c84f425e33; Fri, 10 Jul 2026 14:34:47 +0000 (UTC)
X-Farcaster-Flow-ID: 120982db-2d0e-4772-9af7-73c84f425e33
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 14:34:47 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 14:34:47 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-mm@kvack.org>, <hch@infradead.org>, <willy@infradead.org>,
	<ritesh.list@gmail.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<dgc@kernel.org>, <vbabka@suse.cz>, <djwong@kernel.org>,
	<brauner@kernel.org>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<abuehaze@amazon.com>, <dipietro.salvatore@gmail.com>,
	<stable@vger.kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>
Subject: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 10 Jul 2026 14:34:37 +0000
Message-ID: <20260710143437.12379-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D033UWC003.ant.amazon.com (10.13.139.217) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C163EC000A
X-Rspam-User: 
X-Stat-Signature: nz18obc7q3fnfaec7t98juh1a1x8p7ow
X-Rspamd-Server: rspam03
X-HE-Tag: 1783694091-209822
X-HE-Meta: U2FsdGVkX18mHzcHmImj5t8Po5RsMcJhuucT8NujhHKZ0l94y3yDqzoZEe3eZ0pLyR/SM+qzJlt+D3yU4supoiTO0ye2zM9NZknjtEw3LWiOkfXoXTCGaB4QTdFHMd9yzzBMurcEcF8rdlGjPHnUHV0nqKDfDsw8/DnNfnLM4RJuXap3vTcypJ/ZE5KWHcCFIWo9t7ZmncRxSClaLuGYFTMSQ9gArKKC0cVYv93jNf7bx5FUSyqoadHs7tpUJHGGWEUSyKnwlUhQ/nK25j4D8MrzVdZOZDMlm3sAubZcSYN2fkBG8sEa3+4z4jqxMZJ4NqRTH68/AB5TCXm0cGsUSwwQ0Gl/9ZveSxqyLtH5vGPdW2HqMczf0EDdo20ehsDtUKQh3aNg7VajQxQ5W2YylZ4kdkrnNY8kHfP+tGTjoPb58JQiBdYolTD6tp9I02Je8LiqN0GL/f0mQJhnsiZUBqcfptgGmAJzTWk8br/i8NqgvgGS3a9eCUY7eL9uUsS7TwHjQZLeQkK/Z1QJQJsjs4tQ/wPlywmq1LyyTRYTIo3RUniFMvNhnb7lOGvO+GMMP4j8u0Le/P7RSitCjn08y+tZ8XQuGWj3kE0KbxnnWzC3xE5KSI881KqnvURDptksio4KSJVtPKyX6Cz3Bcl5Fzacko70XjGeYQPhAHc4nQdltwtZvCrbAWACB2dLuncz17XCSoZNnMRDJnfwj23kB7Iss3tF+a6V0MLfhRCGV/tLkU5QE1XR9rHlLWR7Gr/05Fz0tcB15K5AKSN03ro1XL70syCcxJpXm8N2zwCeEV67vd8M6vH/8MHlhToZsefyoyewnUe2dOhNptPGEkhbNcVi9ipRvfPxz5B4arLYx0WP5g+SPsCo2lGcX799yGS6Fn76XXsBS8sULSIafXKzSuF1KP6/eiZPer6gkMCW7kF9DtsRxkhHZaW0bVk1QYjEFcRJ0U4d39FGBp5gksF
 njv7pQ3X
 Sexe7WwyhXqhEjBBJiIZoG4cT1y3QgfiIHukJP9TsZMSjPT/lerb0RuosZvpxcQPodJ45sOVl7fmAoHmn9SoiQl+XuLJr5+u6W9QFLgR0GcrHsZC0r/mYe0adViNwUgv92C7hEQoPvrUjsb9K0acCOMFDxGVp+NU1riXqqO//1wLctS58DMSdHzxXPayiqUZyIMORcWmiLJJEmCw0znf1vxQKcu7OWv0qF9jK9L0RK3nysrfGzl0TQ7O4N+9HSkQCAvW2D0zx+rSOu9OzG9XSDhPdUjJVywxuA/w/mlGhVzhxHq+LDSObTxKd6TxCN46ZuHwbeAQnfMTNI1hqHsQJI8WYTk4zoIw5P9mapLi+2OMHfB5wjElxIQZeesvyZPFgbKDh/jqOoSa3+D5UESoRO4UNjPU6bE5oi7wLgIzpORx67xBEgzqjPw52CerAf8I4ODb4kqmyRSENAyrL8XuF/FvwqrLlW8kz/rjINTCBdXbBeW8tBkx9K2VCenKLXbbGBibGxoi2MuQz7FR0La1l01+60U2/98bV5Xe9bdKo7o5htsExf8eBA/LOMTvZ+yGtIJ7l71FibVf5yBCtnVEsP6mMSB3bQchJV6bfKd71pySBP02ATqAI3kaBqGgDqL0ttBrcHfq0XfB818QFw4qFXKmTe6w/T2K7EUTDaab3simHLffAAjVgEdJBPbUy9L51VgWp
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
drain_all_pages(), causing a 0.45x throughput drop on PostgreSQL
pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct compaction is too expensive for hot
allocation paths that have fallbacks to smaller allocations.
__filemap_get_folio_mpol() already marks higher-order allocations with
__GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
failure.  However, the page allocator still attempts full direct
compaction for costly orders with __GFP_NORETRY, which is unnecessarily
aggressive when the caller will simply retry at a lower order.

For costly-order allocations with __GFP_NORETRY, skip direct compaction
but wake kcompactd on the preferred node so that background compaction
can defragment memory for future allocations, and return failure
immediately so the caller can fall back.

This keeps compaction working for long-term system health while
removing it from the latency-critical direct allocation path.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    next-20260707
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                   Avg TPS      % vs Baseline
  baseline (no patch)       70,389.24    -
  With this patch          154,977.02   +120.17%


Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
v1: Avoid compaction in iomap folio allocation

 mm/page_alloc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659..2d02703d8f0f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4883,6 +4883,26 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* If allocation has taken excessively long, warn about it */
 	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
 
+	/*
+	 * Costly allocations with __GFP_NORETRY are opportunistic - Don't
+	 * stall on direct compaction or reclaim; instead, kick
+	 * kcompactd on the preferred node so large pages may become
+	 * available for future allocations and let the caller fall back now.
+	 *
+	 * Direct compaction is way too costly for hot allocation paths on
+	 * large systems: each attempt calls drain_all_pages() which IPIs
+	 * every CPU.  Only wake kcompactd on the local node to avoid
+	 * cross-NUMA interference with unrelated workloads.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY)) {
+		struct zone *preferred_zone = ac->preferred_zoneref->zone;
+
+		if (preferred_zone)
+			wakeup_kcompactd(preferred_zone->zone_pgdat, order,
+					 ac->highest_zoneidx);
+		goto nopage;
+	}
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
-- 
2.47.3




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




