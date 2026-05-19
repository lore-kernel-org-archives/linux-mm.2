Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44762CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BAB6B0005; Tue, 19 May 2026 16:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0E86B0088; Tue, 19 May 2026 16:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8FB6B008A; Tue, 19 May 2026 16:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C55B76B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:09:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B8F41C1FD5
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:09:13 +0000 (UTC)
X-FDA: 84785258586.15.C397465
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id C7EFA80003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:09:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfsQvan+;
	spf=pass (imf30.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779221352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HXSYodT8UUoQTetKQdVe9/Pql0Tf/W+31/8rbH/ehJE=;
	b=g30T1bLB0GPn0GRBTscUEIKdFEu+fF6D211gFIFJnLpkPbJ2WUJ+/hzQ3HTFcsgd37Sn8+
	/nWr8DQKgs8Jyo2y4hcU9vLXp6xF1/8kjn0w+jnrU7FmvDHKcP8q53G9EZ+OcfmF0s6vUL
	X3mc0YuTqZDB6DUE8b0NLVe6o5rAEc4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfsQvan+;
	spf=pass (imf30.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779221352; a=rsa-sha256;
	cv=none;
	b=JOk/mHes9qHsi13VbUKngKV3OlBetm2IImGlKUdiPaV3dF83CI+FsS5v0SVGVUctkmUO3k
	LW+0J1zL15NOMPJlJwdskY9gnEJ3GM3HbtymK+tpruvJteMVdyYXkcxd79nZtWakWkeRFn
	X1EOAcmHIH2DLb6QZL06VkB3gD3SOzI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779221349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HXSYodT8UUoQTetKQdVe9/Pql0Tf/W+31/8rbH/ehJE=;
	b=DfsQvan+3bhilGFp5EzcRQf4zy/+Ij0pQkI/O+nwLxTDp6+aBcVaPXb5sQjVy8ZKTuHf+W
	vtlmZO52qZJB0GbUeyCXwyvfAGhe+ZbZzpmUv8qt2aiD9IU9tMPpukVFQ4FqPsa+QZSmZW
	P/6wZAXzTazY6gU5AXYcd/KJTtzeOoM=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Date: Tue, 19 May 2026 13:08:51 -0700
Message-ID: <20260519200851.141955-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 99dotponitf5ko9fy4bm85xqcoqaq6po
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7EFA80003
X-Rspam-User: 
X-HE-Tag: 1779221351-972926
X-HE-Meta: U2FsdGVkX1+crkeoe1HgWSonvNIiCzeAT/3CRycfskH147755o1fYXznQUTe3VEVW0l8HyL3bBgXel9JgpA2/xHrmthpQKHbmzFsyTH88GyuSdNHvjrUvnvFfMa1zbWoL1d1fz2cveAHdySHecEOPyjlN2wWet0JRgAoblU6UCgCxtRU5mh988FPnx7TryRAVT+wSeK4B4rJMr+1+UFNkhjuZaNRPbHV2N3l7FaJCKwmu9vx2OL2t3cYhaU4dtFJ6Tsa4Fn+h6s36pR+taIyGdkR8mbtoOr1+IouIT/6TL69shrRQHuCuB/bkT6EKYtZ6cV48lgqcrgaEWM+Myd11VNUM89V48TJtVoMHEsbNEgCCHoYbr/45RQrqdhAJBH29rU5qdwm3ur5DadfOkZVYdg6RmZ96ttXWdN1VebPy3JRsc+5lmbDcc4J94h/aOKY39Xzhcxgsk6hc5SbifcRkDZPcGlg8WLeYYX8V6BgZwguGyKU+LFjQgqTvARN5EDRGCxwyo8e6nz7E354dFt+up+GTRzx+OJsw4AQBD36wgpusAZzECkjWZnc9fqlUaxfOqjRGV4ih10nitlJSDkEjEEpzRB2T+BMOYg4PU6ixdk8RLKwm/UFPRJ6MJDUp/qWFk2ujgn59SMR4H5DLJbvSE41e/oTBojrE5Vc+cRAUxiDiKzjWv9PdWkwrbUFzw/Qcn+WUxI6pwh6mXAlwxxpI5vl3ziRfRqS1hvSwdnnREFN7gUysplMDaT5MvZvbRgYVSE/5xcQbIWZRh9aIFCAMFyUqeDWq4rqYEDDcloelnV7TYSbc3oY3G+qTttfjKFE9OntRUehj2ZNUJVTKW+JuIuS/B3R1iPHddQxcpy3so5huCjsamQGVHj3tfYbew8WyxDi/GjPqX3ilMLwfnVtYIgUsKTDz4PW5Qo+/qiotMOXx5B23kcSWp+M7+yZ88rC4HBqJcZXMNSgExADXiL
 oAwQtlkI
 Qu4FSzF/aqDz1D1gLwMCBmqn4Wb7yJg1mgsGTHCVXRtqC94gOsKOqa3MEcUp9JQPHGQfCsO09orC0Qw3EAlDPibxj4Pq6DYRfxkbIK6SI2JoXLbLpcDJeYuUEvgJIY1GqB0iteNAT5hZXwLBapQlyxIq5mfQbHWyjEFZ6DtEuxxXYMoQ2ZuvZPn+RBCujy7Deg7Y2etMJYh5bLBGMf/J86piONkAx0ySorfL7llOwrj+8o6lqxqcc5eIQAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

compact_gap() returns 2 << order, which is used as watermark headroom in
__compaction_suitable() and as a reclaim target in kswapd. The computed
value scales exponentially by order. For order-9 THP allocations this
evaluates to 1024 pages, but the compaction free scanner's working set is
bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops isolating free
pages once it matches the migration batch. The current gap over-reserves by
32x.

On fragmented production hosts, kswapd will try and reclaim up to the gap,
but it only reaches that threshold 18% of the time, causing reclaim to
continue a majority of the time. The over-sized gap also causes 46% of
order-9 compaction suitability checks to fail unnecessarily - the zone has
sufficient free pages for the scanner to operate, but not enough to clear
the inflated threshold.

Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
with the scanner's actual capacity. Orders 0-4 are unaffected since their
gap is <= 32.

A/B test on ~100 instagram production hosts (64GB, 60s measurement):

Unpatched (43 hosts)
pgscan_kswapd (mean/host): ~1.6M
reclaim efficiency (steal/scan): 83.8%
compaction success (success/stall): 2.1%
THP success (alloc/alloc+fallback): 4.9%
forced lru_add_drain (mean/host): ~107K

Patched (59 hosts)
pgscan_kswapd (mean/host): ~449K
reclaim efficiency (steal/scan): 91.0%
compaction success (success/stall): 28.3%
THP success (alloc/alloc+fallback): 17.2%
forced lru_add_drain (mean/host): ~64K

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
 include/linux/compaction.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 173d9c07a8952..09aea63b8a89d 100644
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
-- 
2.53.0-Meta


