Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F42606B180
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=jGwVEgvv
Received: by kanga.kvack.org (Postfix)
	id 8E9F26B05FE; Mon, 16 Nov 2026 06:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AF56B0600; Mon, 16 Nov 2026 06:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B05F6B0601; Mon, 16 Nov 2026 06:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 165F76B05FE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:22:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94AA01408BE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:03 +0000 (UTC)
X-FDA: 85440742926.04.22D305B
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4873312000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=jGwVEgvv;
	spf=pass (imf29.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsRwtpCZUTFpb8/EAyVAvI8tGTV76jSMOJuUDiUTgdg=;
	b=MVu4VKWlRHm2Tf7gWi2yMw/zN6pZoXoawxB/6bUpbPJo0zp/Ph6g9nMz+A0WmmyB22W7xQ
	Lah+vyD0Y8QiLFEiJD/MWJI0ZpG5HX8nkUg9yH6RsAYTwAen0ukgPIqIEYNwa67wJFORf5
	USuSKOLTenW4mPHOHTKdjLGKTprzqOY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828121;
	b=qBUhU5kZSI7hST40NRa5huzk27WTZEYLDSzDdKIbnUfZzpuYQrDk9POVG72RKimSGk/GkO
	Gi9TjGG/M7zUUS0gTfjsIi74BJGE+IxH1wsCrp4UG0+lnX3yfOzLyWk2GuFApmPJM9GlpA
	0utDRU+BpSn5NusDCIyPQFv/4hlKcs8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=jGwVEgvv;
	spf=pass (imf29.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794828121; x=1826364121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GsRwtpCZUTFpb8/EAyVAvI8tGTV76jSMOJuUDiUTgdg=;
  b=jGwVEgvvrmlH7SF971eXUD8cAk9yMcyZro1JSvUjAaW2m5iPbGLySG/v
   ys1iuTGNDjhzd2Ws7hkzI9dqm8WZBEyJqqAr7dBkwybiY6bOwTytng2KT
   /Imes1HKr7r8mak7KABJON/SRzYmi2uHjziXw6zbthJUAYEcKYSWxqm9o
   k9qr+tg8US71r0VCgNb8ijBAY78d1UfmLAEAZYM9bsWN4oM6GHvvG7Qwh
   WsmR+WD6QrjIwv60Mm4F9v5i8PjTgQ7Nw6d31pBAgnWsrY0xVNtojE46P
   fmnsLKKx6PpegIq0JC5y6z2RzFtb2syyd1io8A/OcbIh5BNMOHS48FcyD
   Q==;
X-CSE-ConnectionGUID: aKAy+ATKTFuPD6/VvyiM2w==
X-CSE-MsgGUID: bbRgb1oTSx+n1h1SHDFFYA==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34147543"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:21:58 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:5680]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 9d22e469-a616-4713-90e3-e29451ea3ef6; Mon, 16 Nov 2026 11:21:57 +0000 (UTC)
X-Farcaster-Flow-ID: 9d22e469-a616-4713-90e3-e29451ea3ef6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:21:57 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:21:56 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Sasha Levin <sashal@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.12.y v2 2/2] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Mon, 16 Nov 2026 11:21:42 +0000
Message-ID: <20261116112142.3813013-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261116112142.3813013-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
 <20261116112142.3813013-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rzjp6swnj9r5dp5zyd1wq3p48bk3iqwk
X-Rspamd-Queue-Id: 4873312000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794828121-557577
X-HE-Meta: U2FsdGVkX18GVr2fjXYW+Q5PU1rKoqc5ysuQsAZYakCjQXWIVqhk00i/9MSsuJFwMC6xH6uTwvRAPrmk+ScDSJaAnE0winALdWGur85OVMv3foulGbUtRwfkZzbB4H+LKdilhNsv5F6p1JAy32SuW0PtsNquBSJvy0IzNbl5GNJ+lQu8wcGHN9PWvzYagGoabhBCuK+eR6544mf+mqpSG7Lpkjp7g68xdMs/5YgaulHZU5ycO3yLhfPyC4FkNhuued7usMD6nEHxJ2vqnn8xXczbA0JvPPCkexzo2X1uU6awiHb38sQq0EaHmZSNDK5/1hLpc+U1TYgbBvx+psiqY9Wv7fxBWpDZ+G61GgpYttZ54epXvKMehPKMbAiZh7Q/no+hvlGo7fAv7D24qv1BGyQNoeRgB9PZNXzTqNi0qncClr8fYGUL2AtgeZs8mfa73eh5cOfuGiWyjk6ZsFT6gOju9tI935YyDUdzXIsZIjCj7Q1ZUbCUrjOvN60YF3Mih8ziOLs+gLbjXFdsuMavoms1K55lTFipfULg8yCzS3Klwxlxz/j97VIgQ8jeFcwL6ZCnRpkWfN8b0d/+0Yp4xy8e5wemufhHHpviqydbghNToZ+BH3LwboJO4HGGSEi6asqsoDQrJcqxJyPEu4SNAEwI9vGu00vcIDe+N1fY8IkneWksaTvguRIvl4H7Riq+ETDMRJ/SOmb6CoawrHbaVtqm/WE4jeqD0imTGbqLAIW+oF72bmS98Av0PIv+j6PgjUYl5uxOwfdxx0kYIhoDQHuUPPrhYI0Pl3Zzx3DDV8dwmh4r5mm/mgEuiJF08jjkdaSSdxV899kL1FknX2qOO77mNfSuQ6Zz79TSIY1CWyc0mXp/qLVVKwQwmFETqpwx1nkiDbgBNeVB2itsYOSpSZBW3cGMMkKj1q81dNLahnv6iuQ+R/rH+jvL9cxITMMnDAEtu4Zju3wZOCwb1th
 jYqrx6vX
 acawrwRx8AJATefqi15MVEBWv2PL0yBl6bbKMRigQzSjLeEtNYChkKsDRrZiTNQxcf839xZp9lXMOQ8c+9TmzYEU78wp+fGfueoQPlce5SUb/Um43KCbP5SHhRyINte5wAwrxBouxWyvM2A9DG2eanaDxCfFIIP4R3YHje+HaGCWef47BOUDwSJ5NeenuI7ufziDQSOBWfJFqGNi4vxOR+d2jy8vJ3xvpFg7p2FU9pI7txDzfRm0Scgn4euhvevyH4XgxIfkAYL9xmndlZFVyF87MBvBv5cR+Pb1ykmE6wrMUCG/JAlaaaVdJNg9PlQUaVHy6Wb+s81S+gfeK/XVjispGFn4E4AFSX+/bzyJ2iIpVIVB/ke3k9Jm9jE4nTP4qxzayZgiUPXjumpLjtSJbkDV4O5Q1HwZ3bI/HjOJljZvu/6tFT5dkj1WrF+jV5nmouVMMCVGXXSkcAbJoNw96e2lZCqjdomxHhuO8LSN1Z/rrNwjCkVrXyMl+VAWzVxNWmg0RqHNWdDF4ArOvQYgj6JNL5I0lLuMv9pwPDDjYi35Hr5CPo4yrXjhmI6vS1S4hTWyjPTEUmaCHIH9ly9zJ5gtsAu65pbq9IggZTBnW6PyX3XQn4BeKj2GtnioTtok7GwbUiJW2Sj24NrbRvXFCK79fL7HJyEz5WKClyhEw7AnWdlL0WvTH9uYCpjSZyhMVWceVcTbcC3n+g1Cbthlkf0DhHBgGHnynkGHqRzSQfp4BRcnJ7nCkfptrW+fBh9Ak9pIyCqY6sx6kBoWN1zPUKBNRbT83zmJB1evidIhprhyk3EUQPBjyOiT01y0Sjv4V+c0csyT9A2qUPI1FTKl7ZhRfaDi6RnbdLNFyrfegcA9c9foBdGvpmaLLnI25gi5Nn0h3ziDGry5OSJJT7u+xX9+CHx9fkrq5e9MfoGYJpX1StN/SwxKmj6t2oNqDST7L2U30kQUnMjSwFp+oFOQ7j2m/V9P9
 xh8A1sS3
 6lerXqMh/xw/G2TkHZl/yeP9ovrNvc884rh5Ybt8ha2GLQf/UpOgFGSth0M0/Mg/+TMXBFu/aJ2tasmofdXEnFZaq9JebrVYSzSVosStTPLTiN/PK5KV0tEePbi4YarN
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
[ Salvatore: backport to 6.12.y: can_direct_reclaim is initialised at
  its declaration here so assign it after clearing __GFP_DIRECT_RECLAIM.
  Dropped the defrag_mode hunk: defrag_mode and 4c0ed883e051
  ("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") do
  not exist in this tree. ]
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 44578e149a54..75e67f7ff4b0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4288,7 +4288,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_direct_reclaim;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
@@ -4303,6 +4303,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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




