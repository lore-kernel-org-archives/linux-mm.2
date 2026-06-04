Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CFDCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 06:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442996B0005; Thu,  4 Jun 2026 02:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A136B0088; Thu,  4 Jun 2026 02:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3574C6B008A; Thu,  4 Jun 2026 02:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 281956B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:18:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D49F58E6E9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:18:13 +0000 (UTC)
X-FDA: 84841225266.26.8629410
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8C6B160002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:18:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MbFhU2LC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780553892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uhNb1e5oAaAySIL2wfE6fLLmLDDye9t6TqH0x1C5HS0=;
	b=nQPR6tmoXi0IKORxdNfah2oZ/OitMG2NZcQCcQAWTcYK1w209/WPlj+7xjIcUwB/5Rw4Eq
	iaS6Y8T/8yCab0/ckSFjSNVY0X4j6/IrAUu+K91VYTik8SUS+NLWCjZtes1ceBLOT7jZJg
	cqL2+RnToxB5Bhpa9AciBljCk3cqpJM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MbFhU2LC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780553892;
	b=oNsMgpJwtPoIyIMQcTnrjIrGXsnIABawDniSKZzoq5rIawDn6r7GRq5HYIiVo0UCAE8Keg
	paK1OCG/iTJo7OJQiJyszaWvCjtv8FaA1RyAEZ7ohr+gGamhaXM3j+kH0Efm0LsaEV9To9
	VEUPnGCTJ82oU8PA/HMc/V2IzxRo68s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780553886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uhNb1e5oAaAySIL2wfE6fLLmLDDye9t6TqH0x1C5HS0=;
	b=MbFhU2LCuUY+aSj/13pvSUxdoBFZf2JPQ/rLfTIkJhA7bVQnwsZGbYfROKpc41BvSZWXaQ
	SPbYbfspX/dw9CMZqrnaNbbkk1zL7vA4yzG2s88ko6WqEnyI0TnLLH9HTja6XmALJL+iZR
	sukH8LwIbMOtrnFUAce9B+WLeZBlgqs=
From: JP Kobryn <jp.kobryn@linux.dev>
To: vbabka@kernel.org,
	akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: shakeel.butt@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Date: Wed,  3 Jun 2026 23:17:25 -0700
Message-ID: <20260604061725.13800-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 643359jjkutdd3qraxpt3rs734yjhe5q
X-Rspamd-Queue-Id: C8C6B160002
X-HE-Tag: 1780553891-738705
X-HE-Meta: U2FsdGVkX1/IVL0YB/VP9iErgdYq7+a+AIX6DZQqq33SoKmwPZ0UFzonzIQgMcqcC/w8gOup7ddG+QF8sM0BbXsqKeSq2pHXIEHxcAaawnJnyasrxp7uB0Bnsj+skn6kcASqQ4SciysleUFzZ4yZUqnbGjCc2FU6MxxJ09SwOOGQL8mwYDj0YUxITMhhQpUhEONtigtbhHn1o3tVwMg+50DmNUIUV6MKIDHfqvlACe8wPkY9x2Uz6ixqfLha2oETcH6DuMQ+w9KSZe7HHGwZjXp9SqPUhhMeQvax+DKuXeId3Yk6e2k3HW/Qdirle+UvVTd0YQ9ILaa+IP4FtYejo6PgF7BHbt1zOBqs4ZRI9nMT7dPYJWFHDFXikSh2HUZQFAyLi6NN5iffDamcJRXUB+bhcITnP1mnrPGsTii7ZvsVIcRtSc4BCQEg+dOrY4DHcbfTE2QraG3K7CiqL5fViWS4WV38LqY454BOPVYHgIW7aaunFbv0ZyfNc8TmcqY2hVmTwTdFbf9d6iuYJ92pytKO5IxE9K2w74JLzt1p2JrjL7+e21KNUYT8177h28atEu4xgThuo1z+ue2K1ARp5smX+7JlxlgDNA66/RQB3TlSqWMZk74ygeSA9aDvkLhouWq91bcHc4KOe67sHkbhYnqt8DH7IntpYpFfcTOc3xrWeteN8WR/i92DZwPUcJSz9Vy6gjCz4Q6QYfvyPDhfilZpfgUsC40Ty1Qvar91OJqKIfwPk3xmDbZZ9tunRF9sjoxM8eG6NOrVnQ9RJw4WnFZvC7Q4Q2LeR7gquaO2pcGJO+Hss/ImzP2EMH7x+ndJaexuSSVyw44NFpiMuRRYnRiOZ43hyTiznwSLTFTl3dnayVs+fgblGFu+yV7flgV27a6fZHqmDV4Im4AJqdvhYfGBdytimuhaLmH/RjzKep1tSoXaMhaD2tYbl6arxS6EEk6AeXgV8MoI9tZ9R+F
 lNOSOAAU
 mWm8/N2dk1OdIGwYBTolhAkkiVjucu2yT/ZoGJYmX1mD1vZL/yD60VRcL+Z3vTY2KQ5J9vUkFRAQKc66/VHMgvhGAPi6RX7sPGmKTfyeMyjRUPYxgsBf/E1IiHZZ/3LxcZ0U+glfbGDlo4NAtZ5w/1pO6DqM/C9kLAhz8/jdTYW1ZbgdsSryb3pjSxCydaiktSphphTJ94nO4oLFcVO+O8FQAeKsB7QYsbWd9F23/G9UFGhViCXTDWRiOdp+B6S5U+YlULCOq30dearDQYEqzcPECrNbOBSA2KrI9A255DojB0hongm3WNIaJuZHKP9M1Vw1MMv+udMgHeHoNouWYc5jZD630bEPRxw2lx/7Jk86hvDYFCH9bwk4E4iGwdL0iu7QRHNQNEru5G6R460l+Rj6I+2SULquS5SrWb/m81Q2YV2WlI2mDnFI9jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "JP Kobryn" <jp.kobryn@linux.dev>

compact_gap() returns 2 << order, which is used as watermark headroom in
__compaction_suitable() and as a threshold in kswapd reclaim decisions.
The computed value scales exponentially by order.  For order-9 THP
allocations this evaluates to 1024 pages, but the compaction free scanner's
working set is bounded by COMPACT_CLUSTER_MAX (32 pages).  The scanner
stops isolating free pages once it matches the migration batch.  The
current gap over-reserves by 32x.

On fragmented production hosts, kswapd will try to reclaim up to the gap,
but it only reaches that threshold in 18% of attempts.  As a result,
reclaim continues in the majority of cases despite many lower-order free
pages being available.  The over-sized gap also causes 46% of order-9
compaction suitability checks to fail unnecessarily: the zone has
sufficient free pages for the scanner to operate, but not enough to clear
the inflated threshold.

Cap compact_gap() at COMPACT_CLUSTER_MAX so the watermark headroom reflects
the scanner's actual capacity.  This function is used by two key
heuristics.  The first is when kswapd can stop high-order reclaim and
downgrade to order-0 balancing, allowing kcompactd to be woken for the
original higher allocation order.  The second is zone suitability checking,
where the smaller gap allows compaction to start sooner.

Note that orders 0-4 are unaffected since their gap is already less than or
equal to COMPACT_CLUSTER_MAX.

A/B test on v6.13-based instagram production hosts (64GB, 60s measurement):

Unpatched (43 hosts)
pgscan_kswapd (mean/host): ~1.6M
reclaim efficiency (steal/scan): 83.8%
per-compaction success (success/stall): 2.1%
THP success (alloc/alloc+fallback): 4.9%
forced lru_add_drain (mean/host): ~107K

Patched (59 hosts)
pgscan_kswapd (mean/host): ~449K
reclaim efficiency (steal/scan): 91.0%
per-compaction success (success/stall): 28.3%
THP success (alloc/alloc+fallback): 17.2%
forced lru_add_drain (mean/host): ~64K

Additional tests were also performed using a workload of similar shape and
based on mm-new at the time of testing.  Across three 60s runs, the patch
showed improvements consistent with the previous test: reduced kswapd
reclaim and fewer THP fault fallbacks.

Unpatched
kswapd_shrink_node downgrade to order-0 (mean): 0
thp_fault_fallback (mean): 1217
pgscan_kswapd (mean): 6328
pgsteal_kswapd (mean): 5657

Patched
kswapd_shrink_node downgrade to order-0 (mean): 28
thp_fault_fallback (mean): 738
pgscan_kswapd (mean): 3773
pgsteal_kswapd (mean): 3243

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---
v2:
  - reword changelog and add mm-new validation data
  - update comment in kswapd_shrink_node to reflect the gap change
  - no functional changes

v1: https://lore.kernel.org/linux-mm/20260519200851.141955-1-jp.kobryn@linux.dev/

 include/linux/compaction.h | 8 ++++----
 mm/vmscan.c                | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index c829c48d1c71..f29ef0653546 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_COMPACTION_H
 #define _LINUX_COMPACTION_H
 
+#include <linux/swap.h>
+
 /*
  * Determines how hard direct compaction should try to succeed.
  * Lower value means higher priority, analogically to reclaim priority.
@@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned int order)
 	 * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
 	 * that the migrate scanner can have isolated on migrate list, and free
 	 * scanner is only invoked when the number of isolated free pages is
-	 * lower than that. But it's not worth to complicate the formula here
-	 * as a bigger gap for higher orders than strictly necessary can also
-	 * improve chances of compaction success.
+	 * lower than that.
 	 */
-	return 2UL << order;
+	return min(2UL << order, COMPACT_CLUSTER_MAX);
 }
 
 static inline int current_is_kcompactd(void)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..3f3ff25e561a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7014,7 +7014,7 @@ static bool kswapd_shrink_node(pg_data_t *pgdat,
 
 	/*
 	 * Fragmentation may mean that the system cannot be rebalanced for
-	 * high-order allocations. If twice the allocation size has been
+	 * high-order allocations. If at least the compaction gap has been
 	 * reclaimed then recheck watermarks only at order-0 to prevent
 	 * excessive reclaim. Assume that a process requested a high-order
 	 * can direct reclaim/compact.
-- 
2.54.0


