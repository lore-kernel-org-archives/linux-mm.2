Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A0B606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u3sT4TQK
Received: by kanga.kvack.org (Postfix)
	id 229BD6B05D7; Wed,  4 Nov 2026 08:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202726B05D8; Wed,  4 Nov 2026 08:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E506B05D9; Wed,  4 Nov 2026 08:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E37736B05D7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:09:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 760D2160730
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:09:44 +0000 (UTC)
X-FDA: 85397468688.18.D35F196
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A92B40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:09:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u3sT4TQK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/skrqwzRK+TZos5jaK0kk6gfuh7AaBo1C+sjf52eRmg=;
	b=dK/6xTf5ejYmlJEvN1MLNkJxOSPNKez4gEtb6SyejkswiaVM/i4O12M3CSM+8GUz8zwVqL
	rmSqUXa/FietqaOCyHlRmw2Gg3DA0FVXoeMvt7L94SqPPUjupoCFwRYfPRI/dl/i54NDS0
	7JrpDAyxOhiGzMrw3riLshjG9qWOCMY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u3sT4TQK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797782;
	b=Rym593dboEUrQhc8BBYyJsbhZtGbGOzjElfLj/C5vCAXRfV3fUC/a4i2t+085/Pb4UWDF8
	6vpax3xpl8yCUOw8QUS70ZdNiYlJ+ki3Jeg55BPMFzXDmFoviTCrdIpdhQ0htT6MDcOW70
	erS5T+5qrqXujjEL4c0FT+lCZPT/nkk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BhhCNdEPFhDh2jcXNzE075CGbKlWzBkBRN9ZyvytWak=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797781; v=1; x=1794402581;
 b=u3sT4TQKLly9ve/kb9PH5h8o7jQanqSgoSF3/6vA8FejFXjhdhl4AfXxrZ0a7qQC1pC74eIC
 8wrKJ8VbAdR+r3yDqxRNa0wA0ozZ07zU6XJQZBiO5rQRFF7gcUl/D7+0QXB61ufM+O6WHMt4z35
 +Unsgyfi273FNmXcSZQF9Fdo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 377ccbf39b602cda;
	Wed, 04 Nov 2026 13:09:41 +0000
X-Mizu-Trace-ID: 377ccbf39b602cda
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
Subject: [PATCH v7 5/7] mm/mglru: add tracepoint for scan_folios()
Date: Wed,  4 Nov 2026 21:08:15 +0800
Message-Id: <20261104130817.849089-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A92B40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7qn16dinsjqdb3tk3ewbc6epjcgequfu
X-HE-Tag: 1793797782-719916
X-HE-Meta: U2FsdGVkX1/II9R587TqOvBf7uHIazEe9tnwlTH+dBSmolXWW9G+Onk74naim7qKq3y4E4g+hbwwYFbcuESTEIKIFDOGqu6lr8D+tZcCComKGIklNmkB0h72Dv9vadc+Ygd/gxR+sSsUTSCKvYVCtR2EVTBsIbZIJLuE0xjIPTqfEScHxyXV3ubtAA80b0noeVS1ibyiQ7CngpjCithY8yYJA3udR8lEXrbTQFuReDYdAIglHN0jmsw+sMuOgRrNfMj7Tdg2kYQyEh1g4xz+AWL+69Phi6s/ZPYdIYosKYAe5DQg/z/5hN/hI3misgd07/MTTV3T2SUAdC7ETzsXugdd3ZVnsVc8rRItdRvl/TUf63O9xT5ydqVWj0vmryORIZ2glfHpn22ZcHdDg8n3lfnn5SNcle9iMAZAc8kByKKAZ6O/e6/kKB+bI7Ozo2/4Q5CFi5Xa5zGgLgKmBzMmiDXGKcscYpXeVn+bnfVSYKrB/cKTR0hAvgv9oiPgthL3LEnZcOE4DSPKadu0+Huuehz9zY2Jd0Uwp3c1Mg7KzjHuuB2u5Pj4d1CMILQJghnvU+/UP8sy/iwktQ76Mv8mN7VuhuyIJr4zMezMPf/Bc8pCG17dSllUXapl1cewZnIrYt06EjwoCbsP/yEHKYsNdnM8RXKe4rIJU3pJlerLObYSlYiIoRoiHhBwfkXDkk+b/qo23XpUWvLm6k9iHBwvIyoD2Q8BXqQuhnxhHgp3D/tzwTtgCe3dD5ugiwsVeCpfCjtJN5TVdenH7I2w1PbGZHvJL1Vyf0hzDwrCKGziIJ1hgI6WRTOkUlu8AWVuayyesCTKn9hEi93YPYkkv5xC6bPSqH2htC723iVxP0nuGGMpnZa446nFiDnwJ0BlCwqzlQ3FG5KiaH0mPWex8UWh2ylTDTYv9SuqeQ3hQNSWgxrzO3iSLOGMX8tT8l/8BjIQJpAnddUerCLxbgHAJtH
 PvW30uoi
 q+RHHDaZelbd++794EUtTUPUSPu8xJYvtkJyPLjhdlmDyTDEEZlFo0S0/eloGUybgI95WT7c+a9M2k19EPhxcQ6nw9x+yUlc2CbaNm7xl1ZkLDEyxU05lLzTLWp5FHGfUhyccbEp/kzy9UX1zDmeMpsJPzzA6zEps9gw9EQQ7FsZcjs2ux09vKvn6uFkKtKYlHRcJtJNY1DncSyfD4JCZsOdtSVq23Bpz6yBMMyfJ5SCt97sHe8B/8SKYz6Bwf56qJ5wLlO+1JGQeSQJIhUR1xUso1FCvIs/HmfOC0FR2hNQ4aX7mFy0buvUuaIMuKxj0LP9+
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

Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
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
index 9fc2399d63bc..379ac3b148e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4801,6 +4801,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    scanned, skipped, isolated,
 				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
+				   skipped, isolated, type, tier);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.34.1


