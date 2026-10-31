Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C602606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bxoqk+Ac
Received: by kanga.kvack.org (Postfix)
	id 1A6AC6B05B8; Sat, 31 Oct 2026 05:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D446B05B9; Sat, 31 Oct 2026 05:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA286B05BA; Sat, 31 Oct 2026 05:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E133E6B05B8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:01:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07597A08EC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:53 +0000 (UTC)
X-FDA: 85382328906.07.E5B4FE8
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07891180002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bxoqk+Ac;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793437311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4OmGQxsritGUdYbgy/naTEuzzYOIoKE4RkWq95RFj8=;
	b=5nzNkxmHETTigrZHGE5Y/4zHhSM6pOfwEmK1L1S/UqEG5NYncunXQrd75YcjfW/G+83Jm8
	+gi/txMHdhPE1St+Qr+n+MlieZcQ+KXepoJW/vcP0/DrsOc4yQcSTjiq+LfN3zwGq9BnoY
	PMLCAEzMsqPcjDQWE2wALkx/c9ar6Vs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bxoqk+Ac;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793437311;
	b=QtphC0+D7n75p8oWjqxYGPTnbs7XSTuChjxNYkned2dCPzYImYC8oejU2jbA35mXrw3qZA
	FWl/731NJ5M6WR1WAMNk7ARSblFD9/7Tautu6/21zqqNT2yF8QkTgvNcS7cS3yvVvWdiLm
	X7phTgE2fECDslV/RWbm3vgIfXHNl/Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ls8zPAr0DtsaeSjNYl2FTkQyXE0tQvzbmKKSnoHdJ8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437309; v=1; x=1794042109;
 b=bxoqk+AcExeM4CrDXgUqVYesb4iWBXa5MSdaUclXkE2MuThsFFqcpRwHIhcMRvZhy4TW2eMr
 rU0orMLeqowtzGC1Xz+0d8AzyhjKbQ7FtzOR3eocB7dNFm6c5BwwUHpWN7ce3wHrOcQDcj6Gi1Q
 bnqgfwCF/JHkhpfAue+x9fSg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9b188fab69ac5f20;
	Sat, 31 Oct 2026 09:01:49 +0000
X-Mizu-Trace-ID: 9b188fab69ac5f20
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
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 5/6] mm/mglru: add tracepoint for scan_folios()
Date: Sat, 31 Oct 2026 17:00:40 +0800
Message-ID: <20261031090041.58574-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07891180002
X-Stat-Signature: hubtn49mj6brwcq1341bgxo4ay9kye47
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793437310-862704
X-HE-Meta: U2FsdGVkX19WAkc6I+y8HTyl6nORbX+tck7t7ULhIUmV9Q7Hh/RlPdirksQ/0hdjv2TmD0pogmMHXjGJFBWjyYBJQpk3DLqurW4xWqruR0zyJo0P7Mw4nlvpwbleDDvQLvbeynL7rntaP4tPIaiJj4YDt9g5wGw6zai5G/0NctbN81F9pW/0cX9cVEbXJGf/dR2o3pbKVa4DIFqIUgsD76nW5vkh0BSlbm/VidYME/AHPmgxZVdCasT5BqSoWDka/7kIk4egHZCuLxCeJGjCHWoNsgvwdCxfTx8BYUdRDLg56EmhF+Vxc+yGRf6Iq5mWbFtaUxazAnQhWA5fLE81IYDeHRTYIpQcjK1M06OP4r3cbOjewol3sN02BrzHn2MQLrY8HO0S/lW4oVZmBURmWrgWGj5Pj3ezvEiMk17U3+S4Lit86ryEL5JJAw/eEe7s0kZxGIUNyZ9rYb7gQfedS3TsxpyNq323qtAqrz/9wpZTerI6sOWxoHfpiK0H7uyKYmVfYbe8cZ0CeZneaB/lFFV+CEZ58OFWp01kgMJQ7OBuMFsQAllK07YRdmNL4TAPisUA306vfQzhhTUyuxE7cNAjMPHvbYes7lIpDnpokecOywcO2jHVzyOFluXm/gxx0Xr1vg5ZRW/gfl95CTbxeuBCEttehEVCji2m1pE5h2fb7kN/6vnVzUxC6SVEKFINX4llbfcuF8ujXTGptcdAsWMB8G4JJLXuBFVDiueRP127YqMWiQNBClH6hnLNg87oDNoJkI5uD5Ad7XxnOZUaLK9VJg3zdJa1m4IgXuayEI0YlESrn1sqKB7L+tjL1xt3rLdx1ZBnGllNY80n1Dik/dD0AD4kzx1IZ6xV2LzUW6djBqtLNBcHAbHaWT/lj/s4l+BVSAIUtube1TM00uZpBMpFdCT2iHlOkm43EE0s7SE3Zw+zaa3g+isJjI4pFNakjaBkE1XSLc1ag23pyRz
 hDYdxAqR
 MSk5wq9uqNDcqmFbKm+9Nb9hMPZcNplrFrGb8b3M3onXHdxWIL1AkzEttqgLoVD0WNq6OVPvjoX223wQTk9M+aWKjqbZNQTP49HJ7f4wYB1pZkwZdG5byuUz4yOSz1lhFvvKMPiTIEgmzeT1GT6r0GLDBJuMCDyHkKBHTQ3WsgcTSCks7SbuROu7QvuXTVm+iy7ivdCqf6WT3fDWgdoWHkGHH+eaUXUFqDtW9CZ6FpCTYR7AuhapqnjliL0oUk8p8OytJdLGTXP79CqVBBD89qY+9BxWUPmT5WtZXgbvVpReqih8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

MGLRU's scan_folios() emits the classic-LRU tracepoint
trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
scan/isolate counts and the LRU type, but carries no generation or
memcg context, so a trace of an MGLRU run cannot tell which memcg a
given scan belongs to, nor how far reclaim has progressed through the
generations.

Add mm_mglru_scan_folios next to it, reporting the same counters plus
nr_sorted (folios moved to a younger generation by sort_folio()) and
the context the classic tracepoint lacks: the node id and memcg id of
the lruvec, and the max_seq, tier and min_seq of the type being
scanned.

Now that struct scan_control is visible to the trace header, pass sc,
lruvec, type and tier straight in and derive everything else in
TP_fast_assign(), so nothing is computed at the call site when the
event is disabled. The int fields are grouped at the end of the entry
to avoid padding on 64-bit.

scan_folios() is the MGLRU-specific layer where folios are actually
scanned, so it has no classic-LRU counterpart. The existing tracepoint
is left unchanged.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 68 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index b2ad83e5f25e..8148b8224422 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -392,6 +392,72 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+#ifdef CONFIG_LRU_GEN
+TRACE_EVENT(mm_mglru_scan_folios,
+
+	TP_PROTO(struct lruvec *lruvec,
+		 struct scan_control *sc,
+		 unsigned long nr_requested,
+		 unsigned long nr_scanned,
+		 unsigned long nr_sorted,
+		 unsigned long nr_skipped,
+		 unsigned long nr_taken,
+		 int type,
+		 int tier),
+
+	TP_ARGS(lruvec, sc, nr_requested, nr_scanned, nr_sorted, nr_skipped,
+		nr_taken, type, tier),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_sorted)
+		__field(unsigned long, nr_skipped)
+		__field(unsigned long, nr_taken)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, min_seq)
+		__field(int, nid)
+		__field(int, highest_zoneidx)
+		__field(int, order)
+		__field(int, lru)
+		__field(int, tier)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_sorted = nr_sorted;
+		__entry->nr_skipped = nr_skipped;
+		__entry->nr_taken = nr_taken;
+		__entry->max_seq = lruvec->lrugen.max_seq;
+		__entry->min_seq = lruvec->lrugen.min_seq[type];
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+		__entry->highest_zoneidx = sc->reclaim_idx;
+		__entry->order = sc->order;
+		__entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
+		__entry->tier = tier;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->highest_zoneidx,
+		__entry->order,
+		__entry->nr_requested,
+		__entry->nr_scanned,
+		__entry->nr_sorted,
+		__entry->nr_skipped,
+		__entry->nr_taken,
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__entry->max_seq,
+		__entry->tier,
+		__entry->min_seq)
+);
+
+#endif /* CONFIG_LRU_GEN */
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 15e9184a580a..ff51fee872f8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4852,6 +4852,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    scanned, skipped, isolated,
 				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
+				   skipped, isolated, type, tier);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.43.0


