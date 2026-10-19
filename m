Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A5FCCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCCA6B00AC; Mon, 19 Oct 2026 00:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F4E6B00AE; Mon, 19 Oct 2026 00:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A31D6B00B0; Mon, 19 Oct 2026 00:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 718E06B00AC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:23:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E69A0C05E2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:23:40 +0000 (UTC)
X-FDA: 85338082200.23.C642995
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1876120003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:23:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EoopDytz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792383819;
	b=PqjDpeWEFu7LseG25/fy4uhf+1OAbEbFTBWJvLUe5vA6J9wT5tthFqg6iRyeLvAd+C4S1i
	+nAxdJPwzMBHtZmkfmjuXYvot7Me8wlpDQIaSeLtGhriMfwqbEboTfV37iKsHrt+h+p07z
	3vgy/fd3LBvyXa0dAM5hoEH25xzY+YY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EoopDytz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792383819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NcJDfwUROqyQiff/cnKcRQcj58oG2NeTIWz0yBYKFU=;
	b=FeZZgFfZDAEvlJwD6J7hFtjVnQJsAJbThUPoEmjqHTHEHO1iQyAZt7n5ECLVATCOtJrZ53
	w+gPLcuMOIUgJwuQZmDWVmguJu3EB2x6Shjfc4La3VUYLX0nLRPXrUgn9SnaZ8gdixkEJB
	5mfRwoEMlopHb2gmyXilEuSt3K2ElYo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7Fh4oWhpxYf6gDp8+ypvgmOJyH6o3AMY/5a5fCOp5W8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383816; v=1; x=1792988616;
 b=EoopDytzBZyCkdjuIvTJsIBxSLsCMtXEHUw3ua8S6L/ejm6mHsDqcwoP+aHjxlWoGl5Z/ycR
 sLM85E4sendGztrmFulCySA+sdjUD/w9aGEjkujTqkQn6RqoCeoQaMD05b1HjG0mAVYgO/4WYEz
 eaWAfTjOW6y06g2J2H18MIXQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a50a931287826443;
	Mon, 19 Oct 2026 04:23:35 +0000
X-Mizu-Trace-ID: a50a931287826443
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 6/9] mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
Date: Mon, 19 Oct 2026 12:23:05 +0800
Message-Id: <20261019042308.2372396-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 1876120003
X-Stat-Signature: myxiwf8b69makjs3bgn6whwhoge1uxbt
X-HE-Tag: 1792383818-132704
X-HE-Meta: U2FsdGVkX1+EmssVSM9XtGhW1zNoXZ2O+peibTb8bifeJjx3al5C8cX0D7y+uOM7zptsXINNSWA95DQv6rJGe6xqziUsLZy82BzOT/VdjwWfAYvrT7HEj8JXMj/i51M1Ed2m+yMmlCPoBvEKUIwRyrIg0mvz3z2kD+vEZKD0Ztdf4WRFHGRL2IL3Y+yCi3ePosQuiqGbHVbleHB/r/HZV/t8NZUiFl8lA12yLVVVpRxf+mzUCMMt6i0O6BuUVKAcuMOqiE7AUPn0+TJjah/LeOzx07Ym9clXQbCIFQY3skDDgvtzPPw+oNV2TFEqVstRKVOWhWBLMAcuOw/7gwEOchhiH4DFXY0QxzEkMbLrtM0z3nuLE14Q8fbP4aiy8ov60EXvbPj/6iewiwcTiqWX9RuwF1f8E7s4EWdrtwZvOuG/pYfne0D6tzru+YlCpzg5emon8AqqwnegsD4jQVGiNxjlr5QoB+fIPIo3wRK4kbS4XDFgSpB+wlfFp3aFSJtMXlSP7tw/DZQ7azaG2o6zKaBzfJIVzL2xRtqL6iuWhm3mjta2sQQ1lT2rNat9ZZC46qIgWk358sPVaO+0D69bvglMuBnrFdau9GoSH1k8Ia+mFRLVIuyI431n8QpcbH8KFit0NQTpH5+kgUrLl9V9tmlnE0nlmB88s/FQdTO6MZM+FNjeJjqwMRKPPcYMczzejO0oHGndRmiJWpgINFuI/gjkCEMRe2Qp0kDWW2dFSP3E8ha1nHj6k8wF05TGbi6a1rIdUBtFg8USNYei8OWvZK4A3jqCOXCDZLUKni51vQ2uGUaGaL0chWL6yF4IFpDwqJjS9GAPCxc/sp0AKcpMgjxjzuWnO2twWWVgPx4B4l/VotDv9fgAsbsuINyWySwYRF92s8gzywz4Xbi7gJ/Gra2yQZYlI7mmmyRK12TQjP3pnOxcCbUGxz4D67B1APhtuGYe5jyLdmDAFjgop9a
 Yw9ONYLi
 iheVDFvsO6IfzZxDbIyOGBqUdZ/m3xKfjEx+dl4YfSqb8bExvVpbB5QHZxCbIMvY7n0xafPCAlS0fTrtsJcv9HbtH5bqPKJhwkO8jP4XoxPYgHxrtebLjIxUCN0vfp7uvi5/joxTrwXSYt15xZlyhQSSSbPUcQjc3WwM1mCma2cwgR51bp3wYuI9g8KkXzJzPwNhnpZolrrzCkQCytrfKXx02RuPj12JukGhybjvkTiDIhtuOIFm42SYXZ6LheVu71oGggmug6C9buipIztEtcGS1ob2ONPntHSxMOqKLSn1BahM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

reclaim_folio_list() passes sc.nr_scanned to mm_vmscan_reclaim_pages as
a bare argument. Pass the enclosing struct scan_control instead and read
nr_scanned out in TP_fast_assign, consistent with the other reclaim
tracepoints. nr_reclaimed stays a separate argument: it is the return
value of shrink_folio_list(), which does not update sc->nr_reclaimed.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 10 +++++-----
 mm/vmscan.c       |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index b1b329039e14..54168ad45f6e 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -418,11 +418,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
 
-	TP_PROTO(int nid,
-		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat),
+	TP_PROTO(int nid, struct scan_control *sc,
+		 unsigned long nr_reclaimed,
+		 struct reclaim_stat *stat),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
+	TP_ARGS(nid, sc, nr_reclaimed, stat),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -440,7 +440,7 @@ TRACE_EVENT(mm_vmscan_reclaim_pages,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->nr_scanned = nr_scanned;
+		__entry->nr_scanned = sc->nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
 		__entry->nr_dirty = stat->nr_dirty;
 		__entry->nr_writeback = stat->nr_writeback;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5d5eee757c61..4bb00371a67f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2178,7 +2178,7 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
-- 
2.34.1


