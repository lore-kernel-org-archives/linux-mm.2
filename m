Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300C1606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=DTiLToBd
Received: by kanga.kvack.org (Postfix)
	id 14ECA6B06C5; Fri, 13 Nov 2026 06:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100BA6B06C7; Fri, 13 Nov 2026 06:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE39B6B06C8; Fri, 13 Nov 2026 06:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1EDB6B06C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:07:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54551A83D4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:44 +0000 (UTC)
X-FDA: 85429820448.20.B5E168A
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D9D940008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=DTiLToBd;
	spf=pass (imf12.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qmgvs+MrefA7FJ6nAwlPPgi92BHFCm4YxrzJnGirF4=;
	b=ybNicrzwho1vm2LUlAFv/EJo5tOCH/zxRuqCjYZd9R2lV+9r8efen2TkdeWUZPMMgciur9
	4jIlvVzEivsX4BJaWLciss+GX9AzDvcN+Yf+Sz6S26Uf9M37l4SVafGa60m5OY9h9YbhXo
	mT/NROxhM3b2qPl4GdgJc7Z87ADKwLU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568062;
	b=OOUk1dcnwgumT1LnQRl10OZae4o4sjJQK2pzngEYkCHhGAM8NDmEbBJtvUVlfY1B1d7SIR
	Ko1WeykHZiTdCNyvze3ogPrMfnowTsIbskIY6latQBCx2pNVFyQLFGweqv4uMAZYda9fWh
	KBtk4tgYEOAm7BDGUEr1Gsa+M6CI5tE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=DTiLToBd;
	spf=pass (imf12.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568062; x=1826104062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9qmgvs+MrefA7FJ6nAwlPPgi92BHFCm4YxrzJnGirF4=;
  b=DTiLToBdYojNQUy8HDBMxHOvszbJ8nRuZfnfkRawdtlXLP9P+7sHBDsv
   EDsqnu8yJ1vRpZC2h+KX4q5FZzui/Jn4IEYWpAw48t4d5mWlkuIyfyRki
   jIYiVDXlZXmF7/wIPBdq9Hgy46ZnpfkDiFS+W1wFUL0RwEHPjj0AS1AQe
   dG49xoQB63v3sC0NWI3rP20K2igeFVl85Lkf+fXUPqoY9ISyPk79B7ytp
   UP/ZgAcSy/caMB4NFTPf7F3aQJ6/pCn13jflgXVJFeWaVZY7v2PCG5LWX
   IFVJIv9ASC3QnHDQoHh2eXKXM3BBfdNp1hCMcr7UeFc+nf3DoxrxcOd7A
   Q==;
X-CSE-ConnectionGUID: bsaUzmBBRvCdEbmsTWTSIw==
X-CSE-MsgGUID: UDnJV56+T16eVdik2CMQ8A==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33792833"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:07:37 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:31823]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 9802ae81-8efc-477d-b9ac-0159f9be57f4; Fri, 13 Nov 2026 11:07:37 +0000 (UTC)
X-Farcaster-Flow-ID: 9802ae81-8efc-477d-b9ac-0159f9be57f4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:07:37 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:07:36 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.6.y 1/3] mm: page_alloc: do not give all non-blocking requests reserve access
Date: Fri, 13 Nov 2026 11:07:22 +0000
Message-ID: <20261113110724.2920455-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110724.2920455-1-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: r3o59j63txrncou97wyueqreboiqb89a
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1D9D940008
X-Rspam-User: 
X-HE-Tag: 1794568061-13051
X-HE-Meta: U2FsdGVkX1+MCS4xq6VV4Ekdx9VHzb61WyqYZ0S4H7TMk35s7JUJYTCHL8doTlcSKTNtUWd4lB4Bw+M7M9yldzdAXt2sahAkPE9oVwKnMag3WUkrQppLdi0DPcVuEZRGlw4XZpd5t3TD6X9TPVrcXn0LoQb4QQqQlloG2LrhG2kxyjlZBgLl/Q25oV9R6MGoGZeR5ZntyAaY+Lo0FvNUD8ivHm8AdwFVElZxvqZvHEMdn6j6eselYJmvmqQxZmTYgJwqRPWx04okAvXCisxFKEHvuoFqgdDwH9lQ4WGpN59NsuokgMypvHQoJ26oDRxA2pz3/bUe/6ixw+COobZD+1FbP3gK2VccVeLGX2dZe/eU0zOtGfC7BoH19NB2gbdfT/VQ5tBXauI7eciDnrqCTp+/PpTnTJl9ftXZLi48vTy5dROmgQ6Eg4XKv8U3oZyVv3C3Y/EXcwu52aAnPWnrbB3u62Xv35IvLY4pqOctdJ/RQ8jb06YLonr4XXwdAKMRgZ0Dj5uHeBPiUWq/C15N8PXJ1OZSMU3MFi6hR9UTDSWpfhlxvw3KZlwV6bySjTyt13OrpvqZB/0QPWnPsMtBFLPPle/K/srwSxuS20fDw5/DGkk9I5vO+zQwx5pRduCvwWU0ZWuhGbNPf94niBF6dp+GRdlgtwaeJIdIqQ6Z09EALBGlBXNmkzve9GXos3t4g7W/pjna/VZap42niy5H+/dmLMlfpovwJSWdyF7NFn+YTRIPt7NCRoUx7u3eYu1S0ScUq1koYgrrWdp2oOEyqVdZCbl62jNZDGxhAKCF9QZlTLT4wXwEDL/e4erZQ7nK0ubPVuu8AusJ57QbtN4ykEOs065eH/3uRwoS5C7Plln606IOH4AUskQyOuXPQaQyqBf+QMusnXa4O4M4jjbdvvl7epckaz21iK7X3WBxImp6awHVp0Kdgyk1P9CAQjDzUDIwC8+asXO7yJocid3
 aKYjZNFy
 hx/0sDMdGsNaIEi3Qr+3T4wDL2ZhndgbuTIwytki5W6JQzAbW7kPslTO0s5xbz1EhTBp+6s5r/r9fpACchxy80hqCYmfJ5umYJnY1LjnJjWZQkxfuhZzKsmN45DI+RKlWnfxDDgUd7Q5FgJ0zWMpiUoI8ykNs3XZYxMgDoiglUoI0OFqmyEqu1ZK0q9brXWw8yNrI8PsS5srz9BqYsidq0O7EhDygiZ6IWm3niKMpIrzInOKy2PkS4hu6u9MACXWXxVfy+s0V+INmrvcIgIeVrjBlN2m0mQTyUTZqrXGhBVIGh1Yu557cMapqXqcO817GjA8ztJjediKvu7jissSgobYqb40ucAJxzszTpeba3Fc837r+57zWqlqV3cQBPcgnqjTFPBT/23RVMVmZotxwg+a49B4nBLrCE90Fe9SUnGrdvtOl7AAjBJq8yrjU9z4Rldkkhk+4yquzKSuLctQPTuHfs3PMWZJEDqkB8/x/xjPdDzdWcKRT/RRJy3Bz5jjGJaCzPlQkc9COQ7IZk30oNRp22q0dBwXsp6TfRBZAxVRUYIVRi+NgnUStyoovJSksCBszjqPmfv3wdjW124/jTs0dKnXJF+oo4YXryniByyx0iylOb+xmHbdOkz8tghlDUqUcsYT0ZQ15fVSx83LbxOOnrB155v/rr92pL2D8yE/rpoK53wXbpZ+OPN/PmrWk+Vt/+cHHa+UzmtKfAmUB1yegki2qiYvR3/i8//HVxSHwWmyfYT82848qxpx9pqswl1ejdclvWFVEp7YH7GwKEs49H7KCgTMofd7QaqGxkTy3h8kQbbl46KA521srcF6BWcgTs606Xm4CYKZArvJ8X8GVyXwEPo0jmWQuCgZhO9daEps9Fo+INJiPrS+99Bqnq/6hijURwmdAXwrrKg/j4U8hRlOhuSTT/mDYwz/unpojnviF4QWVTI6G4D+Qbi5Phug7/+5viHd7Uq8KoDsTPvfu6nVd
 N2TovaiX
 CPjnspSGpcNeKVtG9OkCunUegd+Y/Qff0ZDTJ1hiie/piV9a0jVsKNQNrA55onOCR6z4u8C3GkNkyJFzd1gf04vugV7RwmfvuFLxsiSmOZMxoIGBCV4hL3JxLo0ri1Ht8AURmDrLJVcStqxXYpmoMIlrt6g3UgCpsN1yfDY8kIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 6ee3d87b940848aaed5d4e8d005c5f674bf2637a ]

Patch series "mm: page_alloc: fix reserve access for non-blocking
requests", v2.

Two fixes for how non-blocking allocations interact with the highatomic
reserve.  There are prerequisites for Salvatore's "mm/page_alloc: avoid
direct reclaim and compaction for costly __GFP_NORETRY allocations" [0].

Patch 1 narrows which requests may physically take highatomic pages,
patch 2 narrows which requests may count them in their watermark check.

Both are prerequisites for Salvatore's patch: it clears
__GFP_DIRECT_RECLAIM for costly __GFP_NORETRY requests, which turns every
large page cache folio allocation that reaches the slowpath into a
non-blocking one.  Without patch 1, those requests may fall back to the
highatomic freelists reserved for atomic requests.  Without patch 2, they
count the free highatomic pages in their watermark check while being
served from regular memory, so they can consume regular high-order blocks
below the min watermark by the size of the reserve.  GFP_NOWAIT requests
hit both paths today, so these are existing problems worthy of their own
stable backports; but Salvatore's patch would widen them significantly.

Patch 2 reproduction: a GFP_NOWAIT burst under memory pressure can drain
regular free memory to zero while the highatomic reserve sits idle.
Measured on a 32G box with an anonymous working set, swap, and a full 290M
reserve, three synthetic bursts drove the 28G Normal zone's regular free
memory to 28M, 0.8M and 0.6M against a 60M min watermark.  Swapout failed
its swap table allocation inside reclaim, reclaim scanned 13M pages to
free 200k, and page faults stalled for tens to hundreds of milliseconds.
With the fix the burst stops at the min watermark and nothing else
happens.  This was found in review and reproduced synthetically; it has
not been observed in production.

GFP_ATOMIC order-0 requests have a milder version of the same problem:
They are entitled to the reserve but are served regular memory first, so
the fix there has to change the watermark check and the freelist order
together.  Salvatore's change doesn't interact with this, though; fixing
that is left for a separate patch.

This patch (of 2):

281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access
highatomic reserves") accidentally gave all non-blocking allocation
requests access to highatomic reserves, which includes GFP_NOWAIT and
other sites clearing __GFP_DIRECT_RECLAIM.

While this improved atomic request success rate, it's unintentionally
broad and can actually worsen highatomic requests by squandering the
reserves on requests that don't need it.

There are concurrent efforts to clear __GFP_DIRECT_RECLAIM altogether
for costly order __GFP_NORETRY requests, which would then also fall
into this exemption and deplete reserves even faster.

What GFP_ATOMIC has over the others is __GFP_HIGH, which
alloc_flags_slowpath() translates to ALLOC_MIN_RESERVE.

Narrow the exemption to contexts that have both ALLOC_NON_BLOCK |
ALLOC_MIN_RESERVE.

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it [0]
Link: https://lore.kernel.org/linux-mm/arFBWvzXPYrKuIYi@cmpxchg.org/ [1]
Link: https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/ [2]
Link: https://lore.kernel.org/20261028171719.2043421-1-hannes@cmpxchg.org
Link: https://lore.kernel.org/20261028171719.2043421-2-hannes@cmpxchg.org
Fixes: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
[ Salvatore: backport to 6.6.y: mm/page_alloc.h does not exist in this
  tree, the ALLOC_* flags live in mm/internal.h. No code changes. ]
---
 mm/internal.h   | 3 +++
 mm/page_alloc.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 03cfd9f73659..ec8868828989 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -917,6 +917,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 06c493b908ed..8ac6556d19c1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2706,7 +2706,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page &&
+			    ((alloc_flags & ALLOC_OOM) ||
+			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




