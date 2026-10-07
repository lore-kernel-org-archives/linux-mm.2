Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57354CA5FED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CA06B0099; Tue,  6 Oct 2026 22:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7F66B0096; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF336B0098; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0F6B6B0093
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9982B1203D4
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:18 +0000 (UTC)
X-FDA: 85294210596.24.F4C63F4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 197D2160007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kTfrxL U";
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791339257;
	b=hXr1gw5Xk5OfLWXKMMOAeT+wbYLUwhslornPvgIXKV9CLDON1RkQa+cay/FESk56eNy83F
	NUwS5e1mwwpoaNeDtsVHQ4uwC4iJiohiyfFAsiiLhTI/NDwQFx49Nnq5JfRZYt31i6gnJS
	m7d+OEU7PrXIU64DoI70LjY3fwSyBz0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kTfrxL U";
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791339257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKyw0L1oOLHL45ZtO7jJ4XCZaQCX2P7sIOr8B24Tems=;
	b=wCe9Lkp2tu6eyLcaqT0hWWcmLYijCKwYSvfKOJe65jTLYge/475d88h2Ij5O3bZl+j57zw
	kpGt2GOgWg1W8lq18cV1QraQsZo7su74IK3z0ozVyKpEIsaeAFOkrhBT1LUaxjg9E+nhly
	/15TX/u4xZMYlFHfpwtD7u8wtcPpWmU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=nKyw0L1oOLHL45ZtO7jJ4XCZaQCX2P7sIOr8B24Tems=; b=kTfrxL
	UBDwBQEGO9S2TARCSZdV8q9uIuyj2IS1GEUGdjr07LqQ0eZgV2BS/OWiuy/ufx7+njRJ6xCjICpmh
	8EekvkoHdgHFThrKZlLCLsY48YqvfwwC2l67s2Uhc98fsoZX+5bHvbPFxzPHyxGZjSNR8CvuTtj17
	HdB+bfL7jKFXmWJA+UmyHvvs/SZgN18U2kL1AXqLmw4vForEmXmzAWtDmxefEfeTKfBdEPOR9pj3G
	3Ad52lvUJf1MZajtfdgq/OOue/7Xr3A2A/wr9urZ94a140ELUg0iDheK5uk4VeIavOc4zxhrt7h79
	YrrUEALOnID4Zf0fo6Kou8fjb/KQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEH9N-0000000B2cT-0IZQ;
	Wed, 07 Oct 2026 02:12:57 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 5/5] mm/page_alloc: claim blocks captured for non-movable use
Date: Tue,  6 Oct 2026 22:12:50 -0400
Message-ID: <20261007021250.1665929-6-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007021250.1665929-1-riel@surriel.com>
References: <20261007021250.1665929-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p96gwupq9wrefkajz3814cs5xbh8xid9
X-Rspamd-Queue-Id: 197D2160007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791339256-811429
X-HE-Meta: U2FsdGVkX18IlGXGFh8u5nrjm8gq1NAGxsUZgtUw2ye9sE5dZ2WC2ycrLauBspcgTdgf7kdnAR4fcuI36Pav8SujNffC6daETwMUj4KXdo0gfqX0R9fwqK/Vhqf9BSqIQTSXwtsRwpzA3DTeFx7fcHPnAxGpNh+WTLmImUowhvDVHhLZHcfF+QvajU6K9MUm/pxud9b16+JwMDTJkxEQpkYzWCnCCTGs/f+8Mj8MYNbDojPpKs0satPC2jxNBv7lJ2x6lX9TSal+n54l5ESYrkS+FnZCX83uIu4IP4slNH9+CMT8PfKqqAZ1zONZ8f7AbplBD00OcCLkYeetUyM57UKHN3/iMDYYgD9Pcs0HuTYhDUQu1lESTINqNb6pS71oosR8LCx/Z8kuUhNVpKodnFSCR1cz+xvdcEZFZPPsTaMb50JiaHgvGUr9JatKOe6Gvg30fXa9RJb58qaXpZ4V6Ht8JDvLfKep9xZNVNdtWwEoDvKy7L3iqmvPf5AUccdKzruDbuWo3k+T+YhlbC2u6CFW4z9tnSSqVrLsEtBu6Ivz3LjxUFIamNdbx5kyqGooGwazHjA4Ker+BUc/TrpQ/F+vVug7mukkQ9QH9gIkPFz6S8yeLulaQUIWedbGGYk+og+URBm2pfr1qNFJQhg/CpQmm6c3j0GOH2UNBJVi5pSHw2iFr3qb67HJ2UMIZQSyyHkaIN+K0ofe4075QZwHLSo7mELkKSd5cO3gRIdaWOwuKCwFMlUlWfsoukaCDc+UvjKvfrriHL1TUbXiP79lcJo+e1fc7ZmCLU2lssHjdKXgpbbAjTdEZU8eta76WwkhUPdU11XGcn+tNMiOSWALP8+giyvOUICMScyM4pj2C03z7hREnIwszeYWEj0B1lQwyS+IGg/+RBKyVqcTCeFb1jPyIAO/UGRXocIUzRXYwGwZ20IGEvN3rZaowMMVXasRbqDpFAc0smAeUdAfjpe
 I/ByQJ4P
 nrbMItjdAZTnu0V6FssXqNNjaUnFmrkkdLleMOhVvcIdKJNCa4udgqisQwBzQkyhhTnr3iKJEmAprKCWlwjO/JUxiwS+LYc11rKq9GP1EG+2ID0M3odXqeqqwxas0FZ5q/EfFERIuVLHbBEUW4Bzyvq4l51oQhlZFzF7Nw8cJ9hoUlFB71HBMmNdPsYf3XRkR9WtLjVkb3D/oglB/VQoUHrvraM77yXanO5II8bTg9viChPDl8ZFQcqO5u7FIs1UC4VgEthCelyCo09NmpAl2SRgyqBS/kiJBeScGGg1xpOufjAunn9/ryNz5pnG6av/uNMfS+tMPQ0enhMV+Gp6VVy34o9KKzGa5NK9dnTZJunK1OKhpzq2RFtw+rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

compaction_capture() hands any merged block to the compacting task
with no type change, except it refuses a movable block to a
non-movable request below pageblock order. A non-movable request
capturing a whole movable block leaves non-movable content in a
movable-typed block.

Make a non-movable capture claim a movable block: convert it to
the request. A partial block cannot be retyped, so the refusal
below pageblock order stays; reaching the conversion means a
whole block. A movable capture steals: it takes the pages and
leaves the type alone.

Assisted-by: LLM
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/page_alloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 16d3594d913a0..edb69d8a74c73 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -728,6 +728,9 @@ static inline struct capture_control *task_capc(struct zone *zone)
 		capc->zone == zone ? capc : NULL;
 }
 
+static void change_pageblock_range(struct page *pageblock_page,
+				   int start_order, int migratetype);
+
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
 		   int order, int migratetype)
@@ -751,6 +754,19 @@ compaction_capture(struct capture_control *capc, struct page *page,
 	    capc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
+	/*
+	 * A non-movable capture claims a movable block: convert it to
+	 * the request. A movable capture steals: take the pages and
+	 * leave the type alone. Partial movable blocks returned above,
+	 * so reaching here means a whole block.
+	 */
+	if (capc->migratetype != MIGRATE_MOVABLE &&
+	    migratetype == MIGRATE_MOVABLE) {
+		change_pageblock_range(page, order, capc->migratetype);
+		/* Converted whole, so no fragmentation to report below. */
+		migratetype = capc->migratetype;
+	}
+
 	if (migratetype != capc->migratetype)
 		trace_mm_page_alloc_extfrag(page, capc->order, order,
 					    capc->migratetype, migratetype);
-- 
2.53.0-Meta


