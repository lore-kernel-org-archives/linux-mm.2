Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11912606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=BWw2sk/E
Received: by kanga.kvack.org (Postfix)
	id 234E36B060A; Mon, 16 Nov 2026 06:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE996B060D; Mon, 16 Nov 2026 06:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6746B060C; Mon, 16 Nov 2026 06:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C17846B0609
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:23:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EC6C1608DD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:23:00 +0000 (UTC)
X-FDA: 85440745320.13.141B2DA
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14CF0160003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="BWw2sk/E";
	spf=pass (imf08.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tj5nHubjLP8uzG/exwx3uV3M7v5rho99QeiBJcIfkMs=;
	b=GFgnNu+zKxXQ/6I03w0Yp8J5FJFHa35qeZ2aaHHI53eJP28lY1oszFqD0HSZLkvaeejnR6
	X5RoFpY2+sEhpWHr9CD6gQ4F+xAAxVerfofecjSNA3lOC3GSPNaZvRmLXqyBROl0iGmeMO
	Xlm8LhXM0AGX2PkoP0xyohCDa4Yg7Zs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828178;
	b=mKFaAxKIN1fnUKJfernHjS4AihdD4/cs+3eVHDYdNYe+amwpRbYWVSExC0wNGP9kBvBtkX
	AqeDHE8UPRjEIdZfadtkum1nia7OkF7wMFisINfhcMnXVz4NY5p3gh+nG4NqqWpf+67JjQ
	xrrntcW+W+kgsID7odq7lgIkvCgceyQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="BWw2sk/E";
	spf=pass (imf08.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794828178; x=1826364178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tj5nHubjLP8uzG/exwx3uV3M7v5rho99QeiBJcIfkMs=;
  b=BWw2sk/E8yyCiGMlN7JSIGZUAOECNR7Y4v2KbGf11WlnyrHZYsu+KTpQ
   +UzjDL9G10t8NacFTpWipLLGg/dRUUP5XfGpxJI8UhZp6AD7TjGPcv8/O
   UNK87zaurqJExUEZBpnDkr/GsfcxpWrYT0Kn0fZuMmGcUzK4q+AueK9tf
   Pc85j2gqd/Qq3+Kp3uRjku2schVgPDjPJ0opa6LZVdVAOrXbzWqF9c9Ur
   edByuVkIc/jGB/WfaGlHQV4xxPfvsFoUMwAbDHB11MvvRpofVNpvfAexa
   ibGUEj0g3kPx32O0EDO9WH4DIBkxhjhK0nfkU2lAuSLtg0/0CINvAGVjU
   w==;
X-CSE-ConnectionGUID: 2+5vqnH5Qf6C57H1f0Ss0w==
X-CSE-MsgGUID: 5zQmqUq5TPCXxy7Plig1dg==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34212747"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:22:54 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:17470]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 8fe27ed0-8753-4fb7-bc55-4f650c90c039; Mon, 16 Nov 2026 11:22:54 +0000 (UTC)
X-Farcaster-Flow-ID: 8fe27ed0-8753-4fb7-bc55-4f650c90c039
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:22:53 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:22:50 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Sasha Levin <sashal@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.6.y v2 2/2] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Mon, 16 Nov 2026 11:22:29 +0000
Message-ID: <20261116112229.3815501-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261116112229.3815501-1-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
 <20261116112229.3815501-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 91fq6m4kqdkw93ynuksz7x6m5yukbwyu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 14CF0160003
X-Rspam-User: 
X-HE-Tag: 1794828177-72885
X-HE-Meta: U2FsdGVkX18Kw4lJH0zQBLRSbfTY2WtWU0/IRrpxBsRMETHSLWV+V/TDKC0se6SiIuEg5lT45Fu+GP/K97sdA/EbmFhNgTnVRZKFLpTbDI0ZYVY1keOmyE1hP/lZx0w1vSuER1VUTA4s0fKiwIDkvg9JePNkfxkHssiLJqlT+OdTJozuySwGl/zsV0qiatC4kzIDLR4vUba1XNBko3pakfEmMNQwwq9qi6Jjy/pjiOXEF52MmMANV4M7vWof/ntK0OzbgMcjqFm9Q/e0YM9VQSnvdewXFmPc7YUYeP4W9JJANAWhcmZTYwRixeb5iLc2syFqKYzbH7YHfcPKwwcgrCU1wrYrJf8e1XyrxWSdSgWLVnVf3seOnZTSpj15dCyFyRfzpkQrkV/UPzws05IrNgS+SNSH3WGf6FKhwWUrkm1/M8+Y44hvqXLkorCrjgwhoxW6Oh30drNfrpzqIGddvSay1ybqi6GAPxsexbWAljUKeRYX36syRu/VIc50r9+3YNG8F1oG3Auk730hsZWzGzZCjXeFzX17GxE88lwXAuM/tyeoGCs/O5neaEE1qLXyEbTHjAihWDQp4h/pvMxr29kBZg2lh1Y3By1c9Z9Qdyv7dEZe1uiJo0WNR4iPOShtq7Ltjpu6AtfBkLW5xCWri10vD5JlOMF+aHBRFfo+1Z6a13nPdYY30WFCX9RaRiONHipVcHHKZomUbycF7L2mHWf9T7vhUddYFhkn9+0Vyzi91FZKvGlsEdnKS8h1NylLqIBIOE5HkLPEOxCiv4WfYEKWo1FiaiMHuzXAHEcIgldXFaX+G9WjLNXd0s9pBkpC9WqESMjSfPc16baI3mQXUXTd83KFu1yuqbpw+4VIiirFQKaV2ww3bbiMizaMMxFLNTRXXlBGK02ESrQOfLL1RDW29vypXXk6z1IS9IZvseHOxfjI3F2boZDrA6iJST5lCP6XW8HEgiwoIj3zASs
 hayQgWaP
 2aVykRdQOy9t0wUL/fUyWd9KBmnt6frSI1tlhBMy5Ox8A58FHIIF/B7peL4jsQNzMCPGVwu+lUDoDFl51zFP6sHnvwgIhhk+avCy+2fCCNfxmtgWFfjuZUlVR5A93SrciKsJ6yKTw91OD+JVVeAKakQUxSg7um9+t/VvPdoZViv4eo7lBllyOQQeWhVj2vDRTtk0HU2qr7sBBL55V2Vr2OsN9nbAeR/5k58XpP3cVtQwm8x6Ho7ZuGmHu0QY3UfTPft96VKR4/t4pYB/E1qlPbS3mBM0NUdTksZMqRz4MC2yEaxT1zuiNVVmzWADLDqhUoOHm5fXHZIKnB2K7EDsj+voFG1A2Xp7M/RsMvQ0Ix179+FO1fNMrr8B4c+lr+NOTo3cH9667fGceVaDEzpM4MiTWrQjFLwv28UAx95B29gX9CRk98muS5rVFZ3oqwu0MnL5Hwk65ssIYv9c4c/kqcIoHni3kx2jxDdLsicnsmdWEF4XnlzgAhyEk0jov7AoSf/hruMTFjnJd9fSboezu6cXmus406lW2M6VoWOIqELgrKFtx67gJXe+f4s5TYAxJ8zDdrVaL7BqC9qqPa5OAhmjyh6iOvIUC7zepBFisqlyMqCmlCoZyQ7cgXqUm5jH23th4uph3LC7py04R39AaFsRqmq8kQQFIljQ1CC3ypx2uRMh4sA077JnDiHnORzDsBCHGdnpQnTITZ/Db4EAsd/9Bwvy7pHAO1BJPEqMMVPG08mpqooQbfmvXw45KYS6S5LiK4Y8YuFxj4LbK+PRl7FuiYWKqrIKylyVxXmSaWDgCSuN4g/rdcWzQLcUstX40OWUmBN47jT1sJ/Khs1A8DxkhokGe2NW0zY91Aoh8Io2MPfCfrQ64rME95UTbnQdHhhG27xlC8E2JCHId5hECKnZUnlb0a7DpYO2yUaecQ+hX9oh75tFrTtEWNI+ejs8vzSDhOAWQ8/DAiQ4GZovoBqhA1WmB
 sOp73iHk
 haO3C12KRGbwFXh7tN+4/dxPDSrCawdkJQKog7h2l0X4EIIwQnhR695pVVa+I0eBYpqm2dOGsCvkcb0SYvorBNYy8r8PUxbC1+cd0h2ahEAazjNVLO+pq5eBqpihfLw/
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
[ Salvatore: backport to 6.6.y: can_direct_reclaim is initialised at its
  declaration here and there is no early __GFP_NOFAIL block, so clear
  __GFP_DIRECT_RECLAIM and assign can_direct_reclaim before the restart
  label. Dropped the defrag_mode hunk: defrag_mode and 4c0ed883e051
  ("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") do
  not exist in this tree. ]
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ac6556d19c1..02993879aa23 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3950,7 +3950,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_direct_reclaim;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
@@ -3964,6 +3964,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




