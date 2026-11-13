Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01F8606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=a9C6sq9g
Received: by kanga.kvack.org (Postfix)
	id 3961D6B06BD; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FA26B06BF; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174846B06C0; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D079C6B06BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:06:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56A26407ED
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:45 +0000 (UTC)
X-FDA: 85429817970.18.9E6102A
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 271C5100004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=a9C6sq9g;
	spf=pass (imf14.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmyuIbr3/EmKz19/YPopb6J3Aa3Wu6FFj+RTt7N8bE4=;
	b=kxICEU/sz/PvB6WkkIA4qeYFnKPdcOT08RlbSim6S/bhgji6QwGG9iKDcdiEbPr/sSOr28
	pcyW8hMvXelpmF+2TCrlurXaM1/DtLErJMmuQ6ZMwV18tfAujvGFP/caoyIR0dz03bw74q
	J9+CApprDgJJxTFzLgQpQUunXuVgOdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568003;
	b=0vNBt3rTHkgh79l2SHEiX92h5OTlztZUgRLJMTZXH/yj0t2IKejzXFNaQpwlialMupV89c
	gh0O8KE1R0eSSU9ngCWN6S50bKQK1QEurcFqsNJH/axmnqxYgoUFqryFZVGtoECffTLk6e
	k6MajKIITXi0r0TkzXkxvyzqgx/rw1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=a9C6sq9g;
	spf=pass (imf14.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568003; x=1826104003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UmyuIbr3/EmKz19/YPopb6J3Aa3Wu6FFj+RTt7N8bE4=;
  b=a9C6sq9gBKnNhKFl6w6TPWi2V3cYLVgJGEXsNDUER0NGw6i0IbrHPq6v
   cqCcsjcV99EeGkzdjFcWg/Ao+4Mdgi0Gx9ZCMg1Tj0+vBdxEXtcmEyJQ9
   qKkApxAh4pB5sDERRktF7lrwhZ9GlzV/02EADJVJ2ulpDS/u6KLCJ26SR
   a5CKdwHCYGJKA0iak9RigIULCz0j97y8ksTgVTDY3yQctPnRCSP+x1yO6
   2fqYrkmNQWL7UXKBUJIxxtrvDC7yvYGNn91jWmTOrpK/nh9MFqo96MP5S
   lezNUM0v4P/Ksg25PIb/0cxwmA9wrtUp7DapM/goDXHZGEYKdyeak5+DB
   g==;
X-CSE-ConnectionGUID: WS5SkEv+Sxyf/QNZNJDOtw==
X-CSE-MsgGUID: T51kXTZtRoGcqT4gRP70eg==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33649448"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:06:39 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:5971]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 9b67f0a9-eb39-4379-9acb-898a6c75b4a2; Fri, 13 Nov 2026 11:06:39 +0000 (UTC)
X-Farcaster-Flow-ID: 9b67f0a9-eb39-4379-9acb-898a6c75b4a2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:06:39 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:06:37 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.12.y 1/3] mm: page_alloc: do not give all non-blocking requests reserve access
Date: Fri, 13 Nov 2026 11:06:09 +0000
Message-ID: <20261113110611.2915381-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110611.2915381-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1j9aeae4qt5t5fm969ahf478z8two3az
X-Rspamd-Queue-Id: 271C5100004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794568002-655633
X-HE-Meta: U2FsdGVkX19Ac7DrHEkUprFZzBfJbhJi4c/xUhDL/1I1DkirlN3NLL3DMqqfLcQr6AURG2pHBejIM5NjHTwRkZu2BBrPoMCSPaJRfZYA9ecyDhBsyRB3cxK2v7EkgjNGC+nswlviVc3MCzEjKaXoarvM/FzleNstSnxNJtSivXKbZqeJt4Umko6IIT11svNMtVkNlAq71R8emctfUsZJ5vqSJcwGwjjYDJ+dkLF7jGgr8PsduA71e6arv1T9O8zNiBvSQJUWTNd6JvIZedtBE75ZJ0a/+6F+9MBwmDcM8d+YyOgson5WM4kwO57uUfp9n3D2ckW3IiaOlpeJEpNMs3UBBpl/iAQZJPxhUr0pSnGvURPPrztY/+FuBVreObQEXlMW4Kf1nXMiTXsCjj4xQjvc5jY3UHiDYy+iiQuMmHbvCe5dP8i3ByWpm75Y7WZDSp95MH1t6IEYdx9PDRdTae4dhyDcgFZOk0HnpTAUnYUWV9NwTrw2YTGMw/NBVrNobPW61VzOlBnbpYW5ILQK6fKWCYfAg+uyu7WdhpHgMUghaZeXIelO1J5d8BgX0WOmUX17q0FqQ0rPHDGAIZaTvqJ5o75Bcx6iriLdDk1aNvRlMP3/N2siwyvQxj+Qx2OpsXgs2iOEDhToFC64PNsCJbiPPSDKRCBZN0PO34e59TbOfPk5PzOFV3Q1sOWR99kIaAtTp+BD7zgru3ngXeQ200YPjayx1/yw/Clpl7ZHx+aoiOA+PO1bwLUqOcwm1Ei/m+LKldqLhVLSQdXuUO7jv2O51HPnIwg+6W16xmR1S3c4fp4bIrjEFe4PpD4WqjEJdxGQJp2ZMOME4PIGcil3UGVioy7WtrSCRIFZZTUgxxC1ZrK8oKbIv7yuRgcimsJ7rqL0BnV1ICxxcbtRd5//pY2I+DIiwi4MG1HcxvFqHyXXTK5OI3aMsSTW9qmmj7IID60FevB8z8I6EOgYTBY
 Q5cPEbiO
 iSAXOAF2c64LC7DWS3eQYEkGRlejAax63sEfcXUS1kOGFt7cdDUYiIkeYkhOLygIJ2zAJ+g6rOTMfaDnEj6OtbJCgbCg+xL9KbUWVWJnnh3ci+TfiSYaE5L/NZP7eZCXvcRov4a1Y3+VdolgA0fe984/ot2+Pq0+fB3JglOhMzqX8JhO7rbroNMFjZzbnSTcuxwuqFZKy8qw0WA3OrFuiWuQHjeHVMTMCOJn15MsbroNP8p2a8bG7nwYd4vNZfw/ZCmFW2XDMX+trtZCosS0AhxAvOjNrR18oOa+dqnar2UGpw1rFdY9cyeM05ffZU4+kwwTN5/dLiRX3cjaQ1irIUJP0tYJThP3ObDadiU3yyyMUdQZQkaQG5aFEbUb+pRuMvtCyBQb1rJgm5YxfYEzhNGfe/mjT+IS4FrnrY0FzbFI1+fLSIToFI5m3mwBsrK04DYU34hZzU1qpSSjiC7yC2F391Y9fQ+AhXHce01CuYwSshu+L+2HDPoBwUud3ZfLFGUo00SA+hyvd2ec/b008aeYQCxcGYjR8ZujUNd56WmElT6qBJvGHF8V7Yj6vEoBqi5iqWMpWsBT25RWSw1ErwGWORbXUfAyi8fzVA2MTnVvB9YuOtPSKQoxjf/zuikCklr05onBz8+vaKZC1bnyNf9DGmbqTLeqd+tmvWZ76so99Ic5IeNMxc9XRs/h/I4lJjtfKtyI0ptaipuyGslMJwPNe9h/bh1DFZ7OwPojTjuxyCy2TRZwuy6Q8C1GHql9STs2kygp/jSWsaGGOpJ5sLEku5fuvLOdjid/YXnGj3CHdlk3b4vsnBReqf/H25ItA9zGVtQF4EXxxKhK3qewIW+9MkSk5h6nUKPA3MQTjFV8hd7n8pu74yxrO5KZLa6hIACZaHNWGHyjgwbtq153/FcDNXswQ93jumj0SVV9649/G+baxCD9JiHHdk5tCY2wbYOy6U1YqjYddW3NuQ+YMwNCrbA20
 A9JFeYaC
 TeYuaw7w6IY94lIgXmZr/BDnNSSuiljZhC/u/gESLUnnCULlAcOG91RBo/5hocHVwmBLGIZ70T4ULZIs3EytAg713YVD+CMuIiFdzoT5Ixyly0jKa8EfQQdF3FVmc9DNb+b6DLCQucH3X42o0C9VN6TqKxn7FgSf4Hl9yuGaY+o=
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
[ Salvatore: backport to 6.12.y: mm/page_alloc.h does not exist in this
  tree, the ALLOC_* flags live in mm/internal.h. No code changes. ]
---
 mm/internal.h   | 3 +++
 mm/page_alloc.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 7aca909c5405..9fbed032a9c1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1230,6 +1230,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8209a512019..3ecd3fd76cf9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2988,7 +2988,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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




