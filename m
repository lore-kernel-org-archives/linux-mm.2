Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5791606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=epwjgrs+
Received: by kanga.kvack.org (Postfix)
	id DCF966B06B5; Fri, 13 Nov 2026 06:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C6B6B06B7; Fri, 13 Nov 2026 06:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A9C6B06B8; Fri, 13 Nov 2026 06:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 924B76B06B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:03:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A712180726
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:22 +0000 (UTC)
X-FDA: 85429809444.05.74381DB
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DDE5C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=epwjgrs+;
	spf=pass (imf28.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567800;
	b=CJ1bqKtNeJMWZqHO4qel8BqckgoBMBCDw8v9jwB7tUvNlB1Y1lgnDJMEywWT3uK8JyeJqu
	iC7yN2JbTNv91dzYP1BHPyoVMe9SMsn3dh5Ue79iad1b/fU2rYmfzsrMsNUQpT+pu4zUoX
	HrS7c3k0N5FofuZTgRmDtKCJDlb3Zxs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=epwjgrs+;
	spf=pass (imf28.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gg2iQ8Ldl/YjGV92Mm06+mugpy0zpbOZOU00Kc6cFQ4=;
	b=T1PG4oOAvpcIhw3q0ac56QFEMAsHwoMdiUJyTLrVENwRTG2rPc0VwOsf/8zwFNbET2StfU
	UZmfQ0YmFWTj3oltugCrnUV+SjWCtYw5QpwMdkZjrCllKm0yNCKNp2v+VCOAVZOZo/yZ+u
	5+WzUgllTP+CTyEKGETaVhlZPTZLSaE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794567800; x=1826103800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gg2iQ8Ldl/YjGV92Mm06+mugpy0zpbOZOU00Kc6cFQ4=;
  b=epwjgrs+gLC/8GQWiq3yvOW3uk6hiUtXintnpxqIpFRK0RCqdJ8eRD7G
   301H4OGAIiw8egdNExytb7esv4ddwW1Lh4kTUSNJR5GDU5wwQoxOH+w7A
   /pPNmCyN028sho2PJpq3434VVkHOBsFgIcMfmo0JaM3iRZcblG21yFLc5
   G88+iYMe+oq70b+f9wjOJfdfyGIHmN1ZPW/HRj3yc04GRv1Ym7Z1SkypU
   Ya8LPDigfbfJ2YY+Hj02Ho+o2TH3uhCox6K/Loyfqczm+JYFpG637BbM7
   wBwYkBtTNjG3PHEZtrO6Rn5cxHO6ewUro6aTv2uiUx9eyW49/Px2bhr8x
   g==;
X-CSE-ConnectionGUID: +woqGSfiRaOI3jeataTuCA==
X-CSE-MsgGUID: uLL/VtKZQUG5xCnEqsk9uQ==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33872375"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:03:16 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:21461]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id 98ccb8bf-fdeb-404a-a489-7139bb6c4362; Fri, 13 Nov 2026 11:03:16 +0000 (UTC)
X-Farcaster-Flow-ID: 98ccb8bf-fdeb-404a-a489-7139bb6c4362
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:03:16 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:03:14 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.18.y 1/3] mm: page_alloc: do not give all non-blocking requests reserve access
Date: Fri, 13 Nov 2026 11:02:57 +0000
Message-ID: <20261113110259.2901456-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110259.2901456-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5DDE5C000A
X-Stat-Signature: zb5hbz6tyk6om35686e5hu3wdkt48tgr
X-Rspam-User: 
X-HE-Tag: 1794567800-504826
X-HE-Meta: U2FsdGVkX1+adPXh0u3/482gcMxr+hR3guh7BtgatAY5a3Q+o5PsEDzQ8mtso1mWhd0lqKO0EVG5pOOkGosfwKuNOgl0a/AZMe5/n1CXiBIEp/Mm3BkyAX351OfS9x9Q66UDTPVVWgY0Abah77rcTU9UPeM1P43btTbBJiL/df/kUfZU3afBRZQQfN3JicxDfi0Oki7j3+JUnjWt0tcShppyz0/lk9MRkOkXS6ViFAy4vwTXul4aY54sWV6xA8eJH1HZvHlFprLaXQKJxbT+yoOLhmA5JLwt3Qj7DzA8h6k4qO/srPigVBIvJtrr6oNMuSRV7mRgxzKJZfo/9FK23urMcwxhjsTf4sFzDd/itTSrOfin01buL0egSqaWZOIe0vyDBo3uKK8zHrdFEfrvXakRzub3eEna5AQ0mHWxa8PInlvttCTQGdJ/3ERHHKsqqwMqaIf+FAiaeDQmu6yXvzJdVJXwex1Fox78zTQ9F0SC5O/UN0+Qv45U/jQwE0Irfyn0Pc3Gb5k+2S9/SqYdOmFT6RP5yvdBoS8xU7Wm//oDN578vLRrapP4Awy+XwkYcyvehF4XzYqQNowD4M5KTwJZ3LazlpTtOF4TU510SMAImqi8W2FO5MUwo2t1EwvtUGZltV/To0a/L/pO0EQxyahf4SzaKuRWMzp3kt9Alu0MQkJ/vBVGwbhLYdW6IZsxBE+6gN6+fwwUScCcsZwEqVd2i7Qe9Zcai3aFCP4k4YM94ll+2FxOerCmCtq2pB8IqRSi4WdgIhm9h9rd4T5iX54v/ytPiblUEn6xk52j63tWP6IYqBAnFteO9TNyqWhainI69wArQEd/Z5S5MCmQL7T2lLQMruY6D1ECms69yJSTuSnJbXUOaE25IyEYK/39EKqiC2UyLZCwCx2g3mAGQvFI+u8OHfEXNAavGZ2VDG6If86nhW52v6LGmtjZensMy65Wx3nG4oc3+KUFct9
 LuhBsnr4
 CuH2D9fA2lug89+Di51iNrxFF+VQmxu4c+SV/S/LXtCDIONKA8WI/mgQjWogHhY+eewz5Z9YbZBtBnKfmBp7y3yMrHx65fFw+i+ZWVPKAWZ9BWhXTUxpAC50bZAWFEk6Imynk35WUMBy4Pu4laHiSlc5A5C0+VwFMga7AFUR2Pq++VW4PgDGvJXt5NuuQdoDftrGoBhFoYSW0RlgkCTjSd2dzm+q8mzkYKey/nRRBT+4tLU6tXMBS6GBaunmTjbRucpHcfxcZlotP7Peosdl+zQIpiM3VDfQujG/3p/7hBqdrzHk/mGIHE//z4RT5MjkNhypYGYCwWDJ57Ux+yEklRVCMWxWOaswq4+PAeUriQ4eQ1oP5lmwG+NtIPa8PQyMxBpVStWu9RWmYrhEYedSebFAUOb9GkT2cL8iDmM1uCDpRFTIoj6ByCkeo8v9xaRuKRXSUK6loApdUT5cKWMF9O+KYu2WM4lxPBTw6mIxZ/61UJZwxt4J22FsAl30QHQmlbKlCmZ6azQ4v7sI15MJYSFso+NhsnXAGUs2kskU2pQScMTzQn+SbylQ8+gFLAhCFxZBMQjZc/5M1gfbLJIsGF3fIs98Ke8sN0/vWZvvA4529CsNPa+XOg3Jo1VKowhJMNJjqgw04s1uRgiYWD91SxNPaSQcu1E99dzL1YMJI0L1FNzNcW8yHi+GV6JTWQqUZIWSWpxZ8WClKCxghf6nQZ9mFFTtXjOSvI3H+arW5pyW2RsKUI5Bsbo+vdXU49wWI6LsI3tyzWa+afXWHuWVl59bfVFrTAAJ/gr/WjIr8idMZrevin0ETWKKkYk9A/1DsFlBsdLxQpCd3pdQv/YMUMakstCdzNlUDjRFlOW+kRpxoO8UrTcC3QGqRYEMLiHlbFC3rEPwWgxP1T8UfaVVvC9m15KxyqTcrw3Vd5skabjUjLj26x8pUsv+xEJJrh3RdIsph/eS/bZFJ9LNyvaM3ZAaBlw7W
 DnymuzRC
 m6ou7e8SthZR35P/y0lqkP/p0ke753o342o9+Ebbm+WUcVAtDF56iVV/ZK/3z+EHFhB5K2BKbyKI+35DQSP3CMDAZIPLSuXWuwl87LFJHUKOWnvffVPvSNs11kUGrjFn30wqm9garuh50l4H9BqzxuojGwddywwTUjoNGjmhmI8=
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
[ Salvatore: backport to 6.18.y: mm/page_alloc.h does not exist in this
  tree, the ALLOC_* flags live in mm/internal.h. No code changes. ]
---
 mm/internal.h   | 3 +++
 mm/page_alloc.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index ef42eee87c7b..47f16afa892a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1313,6 +1313,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff863a87f2b8..fced085ae4a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3228,7 +3228,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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




