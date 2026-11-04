Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62B4606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uxwrkurz
Received: by kanga.kvack.org (Postfix)
	id DEA9D6B05DB; Wed,  4 Nov 2026 08:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC17C6B05DC; Wed,  4 Nov 2026 08:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF4D6B05DD; Wed,  4 Nov 2026 08:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03D76B05DB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:10:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CE7B806EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:10:09 +0000 (UTC)
X-FDA: 85397469738.27.6DF95B3
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B74C40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:10:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uxwrkurz;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feKxj4rUU1agh9cPsbT01Dhq4roHTkxI/CAewLAASlA=;
	b=VM7SdGqRxpbHyqkcdJa9ZmPhnubeSfzwu8geIUlTdkKIJRa/98pH+hBC358ygnhKpJlUxM
	j0JKyjo60yb9k+ROytGn9SVDxR7GpyhKspbKq9f2tpMYD+TIhbDOZv23BgDfCfyqm2uh3/
	3JYKk94NRcYnNYfbyE//iUdZ6c6LYPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797807;
	b=rpIMpaDp25jE6DC+o+DHpWlTtPpYlXbgPOA8fVuCinJ++/BrgHFywqquJNvLwgWmmxFcvi
	DBCTsk3lZUGHcPBcWfB9jnOM91RhZrSDcPBMD2lpNO+2lbGaWzqwMxm2pF5bW3usTmYoVg
	ebaUPWBFCHgKUqn6nDDXvgEx9WFF79A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uxwrkurz;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Aeo6u39n3YW9ht9du79+b0964r+JpKZmsg93cKbtI5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797806; v=1; x=1794402606;
 b=uxwrkurzJC3VIKA0//3jcrqAaJb5Hq87ckG3BVWf157gvXIaQnRuCNy7WsucyRdpyGa84Qgb
 mpK8oRZjr7wVfRFCmxr9iOIrA4ZEB57hA9XkPyjKlDNXcAIdrryvh3xiT75R1kW2Xcrg04Im7h1
 l0EJDb7+5Ffab75543BAQ5II=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a6fc3d540e2ed3ed;
	Wed, 04 Nov 2026 13:10:04 +0000
X-Mizu-Trace-ID: a6fc3d540e2ed3ed
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
Date: Wed,  4 Nov 2026 21:08:17 +0800
Message-Id: <20261104130817.849089-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B74C40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wf387qczcaxzrk9gg5ey356n9ce7dku7
X-Rspam-User: 
X-HE-Tag: 1793797807-233209
X-HE-Meta: U2FsdGVkX1+9PGYdita1QGlSj8sIU6dgN6fX003mADNT2lREGlOEje7YT/Oy5pzQY3Nnx2gw1PnMgBPTTp0+5/WhKsiY+x/z7lUX8fs2MJhah8y/EjlAb7kSFQqJF6Vzc59VNjCaTkgMNi+HrllpPoficdPdLs6FHjbcR2BIK53uZeJEgw3XdWuqx77Y2K7RRz+BKOYMwXCtB9CP7BbV/XCrTqnRLnvVdafEhJyNALmrQMeCZ8IScHj0JcZCln1CNSZ1uSGqtEg/jBtSIbj0XJKBWFmBaXda6dGXn8RGqMPeZHXqpJ2QCy+OKOlWt96dMi50FZNNOiw393QKtHMFiDCqXydPPxeAVjypeForl7RA7sfnY9vUmPx7pJ4g9KaMK+dNUQy2cQvDhiLNNHxCtXHsnv0xwiILebLPWgmRhuPPTbB0lMEGxyTk/Jexy8E1mp3tShCNQvObH6KLjELAlJ6J7UGj32JFff3HWB00rEYNmnBBx4K35CfHWF0MrQZIAEIFWSxwkXpGsn2olfZSK4waW/eBMScJI7ookc2Xg/KmUSENt42d7Hd9r0gM9O4eUSKE3opBFPGMfAMjEnU4C3eZ4XkxrONGhWRvSVvVD0ewBSxZzY1P2sasxaBVjZOVNnOq3Qg16JZ+hrtZ0uJC862B1PEZArgpN2rvkO74RLvrfwiMhVRRKZz5KzXeX2RnUHU03JGSRb49rFzY7w1Afpnn3tHrUjcHwkMVEQ/xspsr3yIcyT/RDQ1RFxIXLGAxFhNbUvKIA8W09z9xNkb+JSouDj9+ksShqp8Gydmu++sOXdcKEKnbmIbVVJNjmJ98AgDc+tuYNURqUz7nb2h4Ct4L9n4MDiJlp4d69GSErE/xB+8CJsLHO6Ok1hHxKGNitUclWNO8G2nX/57eJP7XCOT6GyV+d6xeeset0KliFMZsBzC2SKq0DI5NqeU5ZHwRq/F7dFQJ+apX3k6mHwO
 NcIPI1Yp
 hMK8FB2jG+Ck8LzYx52bGKymnmimZP2BvO1t52edqLwd9sChvvbN+FMF4BNxtqT5J9eXhIb7iaNtRBv8oYaGDlUYn6TrIITzpSIEB7TC+aPgBwtYpNDaUrmPoomKgmlzGpBKSdYKP/JrRMfcxy9EsN54xQAJfp1vcpEvNoWqmyDgizuLvRk6ve26rCYzV+Tc8+DKe8ZTRqRRNsRn5062/FGe8lk3mqYnODd0hNmqfOoL2tWg1mV3VSDQ7e0hCFZHNdmgodgBGOSGYYiJiWgWyDa4BZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq to create a new youngest generation.
It is triggered from try_to_shrink_lruvec() when should_run_aging()
finds that eviction is no longer possible, or that it would be better
to age first at the current priority. There is currently no tracepoint
on this path, so it cannot be observed when and why aging is needed.

Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
swappiness, max_seq, the anon and file min_seq, and the number of pages
in each generation for both types, as computed by lruvec_gen_size().

The reason for aging is not reported explicitly, as the logic in
should_run_aging() may change, e.g. for imbalance-based aging. It can
be derived from the generation window and the per-generation sizes,
which are taken before aging, so the youngest generation is populated
as well.

The nr_anon/nr_file arrays are ordered by seq rather than by generation
slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
they go from the oldest generation to the newest, the same order as the
debugfs lru_gen file, so the output can be read directly without mapping
slots back to seqs. The arrays are printed with __print_array(), so the
output is hex and its length follows MAX_NR_GENS automatically.

Only the lruvec, sc and swappiness are passed in; everything else,
including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
does no extra work when the event is disabled. Reading max_seq there
rather than using the caller's copy keeps the window consistent with
the per-generation sizes read right after it, should another reclaimer
age the lruvec in between.

The event marks the aging decision, not its result: the following
try_to_inc_max_seq() may find that aging is already in progress or
done by another reclaimer, so concurrent reclaimers can each emit it
for the same max_seq. Whether max_seq was advanced can be seen from the
following mm_mglru_scan_folios.

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  1 +
 2 files changed, 53 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..565c56428364 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,58 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_aging,
+
+	TP_PROTO(struct lruvec *lruvec, struct scan_control *sc, int swappiness),
+
+	TP_ARGS(lruvec, sc, swappiness),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+		__field(int, nid)
+		__field(int, priority)
+		__field(int, swappiness)
+	),
+
+	TP_fast_assign(
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		unsigned long max_seq = READ_ONCE(lrugen->max_seq);
+		int i;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = READ_ONCE(lrugen->min_seq[LRU_GEN_ANON]);
+		__entry->file_min_seq = READ_ONCE(lrugen->min_seq[LRU_GEN_FILE]);
+		/* from the oldest generation to the newest, as debugfs lru_gen does */
+		for (i = 0; i < MAX_NR_GENS; i++) {
+			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
+
+			__entry->nr_anon[i] =
+				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
+			__entry->nr_file[i] =
+				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
+		}
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+		__entry->priority = sc->priority;
+		__entry->swappiness = swappiness;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu priority=%d swappiness=%d max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->priority,
+		__entry->swappiness,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d05050ac49df..bcb229cc320d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5098,6 +5098,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		}
 
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
-- 
2.34.1


