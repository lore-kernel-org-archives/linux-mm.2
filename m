Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8503606FE99
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=akAvvbMm
Received: by kanga.kvack.org (Postfix)
	id 909E76B061E; Mon, 16 Nov 2026 06:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAE56B061F; Mon, 16 Nov 2026 06:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0FA6B0620; Mon, 16 Nov 2026 06:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9036B061E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:18:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6323A86DD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:41 +0000 (UTC)
X-FDA: 85440734442.23.0383026
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8B8EF1C0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=akAvvbMm;
	spf=pass (imf18.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827919;
	b=bzB+IIX9AJvorGA4eCUNKdBKWm8ylCkfqbLxrKkzKIp3b2sOWZIU0RBZD59ZD+kbYTEme2
	JfXQzf9lAOxQ5RRJC9oRWCDtGncN6owwiIGePbaItp+5phav9tUx8joG6durd2Apv4hK69
	vd5ReNrYJqEnZ7bjOoOwYKVSz7GEz0U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=akAvvbMm;
	spf=pass (imf18.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzOsmewHq5GxqIp6HPh2+nYmi69t0o9TXU6LggokPYw=;
	b=DjeZxchs43UG7L9WrpeetOA8MiZYGTEJ1DLdJSn24IeavdieLpHF4zIKMt0AkH2iuDWkt5
	sBtcPi594667Sr9rVRR9ID0j4wBUdBAEYgehZAIMeFq6c00wulMwYa31hFvVjB2ZaC81hp
	5LXKlN80IaT6y33eDJeLDFquOPQXVYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794827919; x=1826363919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RzOsmewHq5GxqIp6HPh2+nYmi69t0o9TXU6LggokPYw=;
  b=akAvvbMmkDwQT1egvS/BF2E85yGVyCII4oPTH2+QwULu2XUMdlnmu4y1
   Hib4jnQIhylDm5L/s0O+I/szwa0thNQJnv9P5leiU33xphoKzOj9z+4jr
   voOIxebjjZe0JTiGGE+tAw2e7tGiqGWj1HC2s3oiSBBxe9XjRg3Yk7hhy
   CFnlzb4v7aIvFwcSEqOowwvy4JlyZRF9ACCAL024ticxaqJwLTO6pCqA5
   xddHdv/z4SIM3xuv2H8b2p66mlgmreJZcVNSPtqqQJrxgWvoDOiwDo2Ag
   dTB8PJb2V3VQBR8eSN5Ikn4uIa/RxirSIqu5rLJCimTTXgSr4gXFWJFzs
   g==;
X-CSE-ConnectionGUID: U6JJ0iKFTWacsVnOOmMHrg==
X-CSE-MsgGUID: VY//jjqFSKCAgy1hFFyksg==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34258412"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:18:35 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:17080]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 9c9cdc5e-b954-4912-b613-157c7b68ab1d; Mon, 16 Nov 2026 11:18:34 +0000 (UTC)
X-Farcaster-Flow-ID: 9c9cdc5e-b954-4912-b613-157c7b68ab1d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:18:34 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:18:33 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Sasha Levin <sashal@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.18.y v2 2/2] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Mon, 16 Nov 2026 11:17:34 +0000
Message-ID: <20261116111734.3798483-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261116111734.3798483-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
 <20261116111734.3798483-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B8EF1C0002
X-Stat-Signature: ojhduki51yigsgrsfn8but1c6cj73xrt
X-Rspam-User: 
X-HE-Tag: 1794827919-249642
X-HE-Meta: U2FsdGVkX1/q2cwUbPoPbxkxKhxHx1uakGJred2obPexi+il+faa3LlUNycgKWwzEIN+XbTQV11Aku8hW37OfB0wNmA/2DHP+D9o6D37Mo5NggR8NH0ZfgTw7YrfsnILR6mDtx/cmPOuple3GoweI7+DaWnCST3sUNBB52/ePzq3CVDhZ8uea82S64/agOcVP+clkDO7yY67BxXkAcQlxbJcTYqtL29Nj8YngwNhw2C1I3l7C+Zah/ShlpAfCr/rEfJsyS4M+bTeTtP4F3NwufdYfw7oLU6PZw7Hl0PWx6ip/fpnRfjzxjqayF2GDsjuEF8vtlYeYBMMm0ZajkN5UXUMBKsGOtPSHTKslvGeZuWBWrm0HKeybm3fwIdS9UxZ7j6aIad34Z8DzZSf/T4DKaZYEz5DchCgRP2e9SSOsZvYxLnyfml0qgS5LiLLMYJHampmjIwspZnxa3JHE0l0KNdX/aGmzHgQEyrCxtSg28+R3+NdG05yjdvmhVbYjszEDbHVVa3koLBp4iE2kLDe+Ly1bUUqOxc9b6XLBQhVQqdbH6+lAw3lclw5speIVmBTH86FHPO5uscnBdKc3mfqnfmJmZR+xADFQfp8yDCLe5aRxdWfcNQzOnvwfnBgH84zRrGvCep+vDzWty7L4FKFnGnctDUba1zK6mupNLTzGrAvsdQnH6Sr78//gSoqAjqCRM7dtzEvMxx8E4O6gNwQaQG4HUdJYo6hTw8czVMezOTG65ZODyja6iRG8nw8gzPUr3A9a9Ld0qOGZxGaQXr8pSwE+gmaMdCM5+FdPf5Ke3SZUB9lEr8gWOGWti2HIBg2mhPtR0IVsJC2Uf60HwGGDhw8HVRWxJ7iiDlVXk2+FFwlylonF+K58l7ef3IUX6ZBV3o8mCFzsTvx6bKt8XEp87+nCgJzkA4XZN0IUJEJSKGwzEAiBf4yybbyUoMOsT0slhLkvxT8Uh1O5MmVMXg
 iPChFiAL
 wZUDICAjbgtzto5x3WXovHUQZL1nmLEyNK1khduAqsIjHj92snH58C8b/odF2YK968gl6QgR9EEqjj7JHaFH1XwILlF7J3c6h6mGE1Ty93bSSSFM1Y2JsHNMQQ1lRTosZRfKeksyj3SxmBGKnX2/iCCkbJ4PVCGDBK3HINIzYHWiP9AZbLTBZZDIs8NQFjxGiPDyhOuynRQ0zn16JXKXqTTVKIOweP6CVDjNcA8dbWIy4WdqcetnngeQViKfmC7t24fD0jheCnNysgSdgzWsw64iY9blKV9b/A2nEUjZ5Uwo+LP1aOmBpP+eulS2eRB9Eduiqq4OVYulxdGfQ6Zw0AanqS2IEOXdUz3iiMP7axDsjIsXjwDgst/itRkBWIJANoFPCEXHORgY5rkwor2UU4OpeCy0rAYmAkU/IoBfHHyas7jCf/j9ckjMwKVWwXr5mqSa8qjnWy5eQQgAJXxiynmxgZIXLjPkgV1+/3V2oBCGzRRwgqKsS5MRa5GpH2VmBR7c7xkQjJAIfAPKPF0aJf2KmDIyaj56aMx1kbGpVKhxheKGMigL1SsGoa2Xe5/jEcFwUjR609jSOIyCTS8K2I5W4a/rUq07Mm/+1qwc6ilPqJ6XBCPN7aZSlnlM8+TxNSK/0d359Xcm8AK+bF/VJM8nYg06aw0p8ga++Y0foUmfO8tcZ2B0h1F9+6puQDBgSz6y3dPK2bTnvp0PzAXZUIz29Ee4jEH5oclpHMq6KNYeZBHGrky/IgoshbFenuX2d6uBMV04rQbT5NIrY5Em3megfpb4/sPlslYexHiupV53P0lAp1y4x7N/xjc1IKq/T8ZA7mQnHORt143aSqrNt6yE1p6+ppJ3I8KdA1ytRo8dD3ip7R+ZTNbpJr5pWSUA2GCoHCM+l0drnsProVFEycA5XUnVyLPOhqINDZXFWmrj3ArFRo3+WFlldoS+KFOLitcHnWWXL7/wLiNz1Lwo0b+7I0ZMp
 Dz8JZspN
 GDqDsAnT9XBbagVuvaU0jhn/JLKzsvS5wD09oOVV3IxBaioLlWT9ftbzTPbq6Bz+Z7+K/+XonHoVo8GOJlDndqzkh2FUa+Nsal52YK/eTPow7kLOWEhuWmmY7d3+L1+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[ Upstream commit 0e05a469c29400eb6e35448ce7318581688a1806 ]

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path.
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on.
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation.
The exclusion is not restricted to costly orders: any __GFP_NORETRY caller
has said it can cope with failure, so failing is preferable to fragmenting
for all of them.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                                       Avg TPS   % vs baseline
  v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
  v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
  v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
  v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Geoff Blake <blakgeof@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <dipietro.salvatore@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <rvvandan@amazon.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>
[ Salvatore: backport to 6.18.y: can_direct_reclaim is initialised at
  its declaration here, so assign it after clearing
  __GFP_DIRECT_RECLAIM. Dropped the defrag_mode hunk: it targets
  4c0ed883e051 ("mm/page_alloc: fix defrag_mode for non-reclaimable
  allocations"), which is not in this tree, and without it the
  !can_direct_reclaim bailout already fails instead of fragmenting. ]
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c1ba49ba51d7..a7aab8dde3ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4743,7 +4743,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_direct_reclaim;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
@@ -4758,6 +4758,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+
 	if (unlikely(nofail)) {
 		/*
 		 * We most definitely don't want callers attempting to
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




