Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DDBC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC896B0088; Fri,  4 Sep 2026 07:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D576B008A; Fri,  4 Sep 2026 07:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5733F6B008C; Fri,  4 Sep 2026 07:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F386B6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:57:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F9871A1015
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:57:11 +0000 (UTC)
X-FDA: 85175929062.05.E2CD59A
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C67280002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:57:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=EGyOQaH5;
	spf=pass (imf02.hostedemail.com: domain of "prvs=700cc9d1e=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=700cc9d1e=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788523029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SOjD2ZTgpTZf/InCnmcmr36L5a0mZycSlAjIYBy93Ps=;
	b=PBe0IsJlwPrV74I5IJwsOV66F0X+34E3rH372KZzN5ZV5yldyHx9W9mySJ80JNR0do8F3X
	esd4MW+6ovYnHrp5BYmy4QhIOLM/JNW+Ap7RYcCs/+A0dUp6jlPirrewLxHklNkatXAY8u
	NV3dsSwLb9tRqPPilQO4we46FtjHv2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788523029;
	b=dV3wAC2H5chfG1bqt83vLhV0lFnkXQP7x1SIV6hvbf+iunzwoMMZ817FRA5Ph+ARbFQ6yS
	nivdL93Qj22mtYfox2OSGnBUwWqTN1yt/ZkjMGCeP7o8FK2Mm5Yyaj9v6mZPcDdqzKzlHN
	DSdv7+jrRNiHXz5arvbu+4iaP6NdsbE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=EGyOQaH5;
	spf=pass (imf02.hostedemail.com: domain of "prvs=700cc9d1e=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=700cc9d1e=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1788523029; x=1820059029;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SOjD2ZTgpTZf/InCnmcmr36L5a0mZycSlAjIYBy93Ps=;
  b=EGyOQaH5GsxI+30PGR2qV4fOk2zuwAhYbXPyzTCS7GgddKcqiAJzRm8o
   qHvv5uk8DFPy7lKj/XdnArgXICrN0rr0z1yOVahrG4FApC/nwaPEJ0JDR
   6+fgiSqtLzGPYln2B9xUQ9+Cg2f2ZxWIwjOOEVcUN6/5fRSTxPf7lQ7yY
   hCdUlHgyU4s3C7W7ZhwSlm90ziCL6Uf1AGGfk/necNdvm4o+lTzfcKVxy
   737241UKrikG1hlvp5ea8zEDiIgWuEXd/abQionXR+IWeBTnzf6IEh/FQ
   rV4sG97QfyjTf/DBB5pJRBnE9jo2DOpX6IjmSyf3rrjRqx8LtB4RKWpXG
   A==;
X-CSE-ConnectionGUID: iAXNTirhSJaOs9v4vT772A==
X-CSE-MsgGUID: O4XTqRyDTUOIEtI3JKf8Ig==
X-IronPort-AV: E=Sophos;i="6.25,262,1779148800"; 
   d="scan'208";a="27847546"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 11:57:03 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:15535]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.115:2525] with esmtp (Farcaster)
 id b4a5571f-f245-4ceb-b67a-51094f9b8089; Fri, 4 Sep 2026 11:57:02 +0000 (UTC)
X-Farcaster-Flow-ID: b4a5571f-f245-4ceb-b67a-51094f9b8089
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 11:57:02 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 4 Sep 2026
 11:56:57 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>, <hch@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dgc@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<hannes@cmpxchg.org>, <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
	<surenb@google.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand
	<david@redhat.com>, Christoph Hellwig <hch@lst.de>, Brendan Jackman
	<brendan.jackman@linux.dev>
Subject: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 4 Sep 2026 11:56:28 +0000
Message-ID: <20260904115629.3993331-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C67280002
X-Stat-Signature: 1nzoy918gcxaocz6wexnc9yfhi4fmhnh
X-HE-Tag: 1788523029-146098
X-HE-Meta: U2FsdGVkX1+jtCG9R7J+KPO/0vev7hpLD8W7spGN4+OJPTonC/KWAlT1O/omL6GEXwuLTcAEAJRsDSdWI12Vh9Sf1bynXORjqQ2biBas3b97BtoiDD88iLqxXzSDU2lh08UbI2ZzP7zx5EjRkJq5EUhnNRMV7CwuFfz2+Tp3sJTUl8GE5Pp4ZBQb0ffVQe6r+APJ7c9+VvJ3BOGKoL6RzjIQRAI9K7Otcp61yQYHwY0Q7S0VIEvJZXXXbp7595Pa5TfKu9cbu9kPCMKy/A/TVX4zyorncoGLsF7ZG0JX/tn/kMO7jb+TmPo19O/MAzOO77Nwjy2awt5+qibWRTvmYfEfTQzrREY86W+aNskUnnMMOxsJkSiyT7Wuy6j3oOJ8fztNioMvWiy3qItIkRfOWdQmUoWvL4VyRqa/Vj9LswQvzjKG8ZKBevzpO2yrVueTm+9/XY14My1I8C441lwySP9eec2oAq50facm5XwiD0mRprU+Zs+NDJdlhvHKA7f69eSORIfIlGUt0DgzoM1UNldHp4loQ7hp5ULxy+zmIQd4z6LURZkN3b/Za1mXtp3kIutzZG4oI2+NpNWVnacgXFfCswPGxJqxv2/LxRBD1YMAXtNIAp7FfHkAXczt2pk4nyxR/nKtb/b8xw2sKUJF1SPa0aYbkNi2D5xfcJyZGV9ua2cHYfgWGvE2d+CCm0SBTT65revSqlc4cIRep0REcF1bK1fDPuFECzXhsBqXQa7tlc272dyHEn17nQCIiAUlUuJPbtgz2VY3d9VGVMynSuLSYMql8kYoBQBq+cLfMaPqg0790jfmJNWdGfphNEtQV4kFAa+Z9owhoUzqqgrrV+LN77zL83FR2WQm2zY++foycNugfUGfg9eYtMcB+mPrmdDaY42k0vTnRNlzIaT7Q6IWuYFjkwWk35hQDV0o2H9m9Hm224DZg3f8lAtwJo8XnarwtHGX+PNc/ONlz58
 nC11Arpx
 2LpKpZ8oX1g3qX6Qh3UBInMRcFvmM7ozLP8Vm+DJpnx4OMgF4woXJKvRGhR0Lna950DZA0yZ8AJYXFz6oBfD0t8cup5p9YkVzXUDUv+Wfr1L89ZI5LgCBJ1pSztvpYUNg/zTjKJ8Ap/m0UUAeFYRBGmYA490xkJQAUYrf4PvisFhnFrgloUDUrBPPRuKe5/SSagXfgsvdkv3s85176agh1BGj4RBfmdMQZx/sYFkriCYRpNCtIJc9sXhlO/32SG1fNVAyAJcwYx/3MfrCdgsL73QlLfs1BLfFq2vXhtA2qQww2ROqHhpjCMJQeEib4l27sNAn3DlV5sdZlrfMBSSSih5YkBrjJOYZLHaN0KhZbXTTbM/RbV18VMfQC4jsQvOHQE4yL6sf0DElcnSiWVZWC1RwYhaqBNchlSsfxa4lZZDWKw/z7eblBt0ePev+ZDU65Pstq5j/iqY50/kwO8Bk8pclv3pJ/6vS46bwUbnfQxEK9cP6OLBrlMEgA1kfPMfENu+p7MQ0GgAyEnLdep9ReCVR80Icd9mqs+p1sxSPk87cpGJfTheQ7pQA1/XMz5HMAJCh/RKkBC2h/IiqcufVhAPCEiS+WU1Xi8iJ56a+BztpONbLpE8QMWJlmyDUvFxHhJKDc6lKtxGsbGru1RoM5f2Atesj2lF+TIy+d4CWRzWVm52J8EMjKJ0eQaKXMFBrfC72MBLUL+Xh5f+e2lu8bjl+JtMT9gfA+FiWM+htJXuyRYjbcwIlZV+co9zdKoo4BmT18ngLoDA+3lGrJjYqGYhqh6bSoAIk8N4QqGRM7vRkG5m68OUOMBwIfZkjYyND3TQM9jBVBE/+GDBfudSNjsDlPpNWqriDJ6Qg+2bKVdDu+roGZaYU5gG7f3eRvStZPHSDXO66Q0xYAQ/4yVsvVWtbdKo5GLOu6asd7iiyMtC9TQ2CZ+dp99ufkAja15ymTJfdGTlXOv9JskQaI1CCbGuPzgkx
 Tj5q+RMe
 ISF/M1iUFLVsRFygoT2vq+EavRKxJeEC0l3OhdNH+twnFYuEpFQpRtkRUDxcBg8n
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

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.
This makes the entire slowpath treat the request as non-blocking: no
direct reclaim, no direct compaction and no drain_all_pages() IPI
across every CPU. kswapd (and in turn kcompactd) is still woken further
down for background defragmentation, so compaction keeps working for
long-term system health while being removed from the latency-critical
direct allocation path.

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
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
    __GFP_THISNODE so THP attempt keeps using direct compaction
v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
v1: Avoid compaction in iomap folio allocation

 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..542c2ec31061 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
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
@@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




