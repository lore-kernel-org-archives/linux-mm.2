Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040A6C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB496B009E; Mon,  7 Sep 2026 00:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABEB6B009F; Mon,  7 Sep 2026 00:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73E26B00A0; Mon,  7 Sep 2026 00:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A68B76B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:25:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2712812068E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:25:29 +0000 (UTC)
X-FDA: 85185677178.02.6DBD7A7
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0DC5380003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:25:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=byVwoUCh;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788755127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhMacZaPAUDleMq0d0Dq4BhWzki9fT+ENe5c97bPCYQ=;
	b=2zdBwdvr5fyM/rPopoJE2vHFoU3ikDR0dDQMaSkpbybsUc5ItavRrsi5tunoNk0LHBPm2I
	hTg6PTDAqbu0scrtiXWY9WKQjSY5dXY69YpS0dYf3u2+32jcpjdqCh08YMJcifDMgxdaNI
	WN0tvGAbGOS0q9uOoVT6laYKBhTTRVk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=byVwoUCh;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788755127;
	b=Yn0ytk03WMefrRRXizWCvGhIMmhlWnfQwfB5BEkgkYGfUDOWa8PwlPwk5Crva1+pTCvVgJ
	rYnagc4fmgGJMua98x5Lgl6u7RJQabXbj7hpgGhmtZQI2+eN2i1xLv7guXgjRnv8qFSMpD
	7jyKWCVLrNOkzzGADcEs6F3A8H4XIVs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fMRMz0ejBh4DpIRYS+wm2oHU4pJhDLj/9tGMxFwRUKQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788755125; v=1; x=1789359925;
 b=byVwoUChGuNvb/pGK332+rp7H2BfVy6PrzCxkKSH0XnVKtTMKV8WTnuA6Z5tcCHtaazO3bUR
 OsmmVWivmAsPO2v3F8RgB+UVcw8teFxakftumJWTE3Q4NgPOZ1TYJPc763E95D5fxFN2/e69giF
 Z+LSVuRGi2b5eN1zl7AiFjNg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id acc1ac3b5cca2887;
	Mon, 07 Sep 2026 04:25:25 +0000
X-Mizu-Trace-ID: acc1ac3b5cca2887
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC 1/2] mm/mglru: add tracepoint for folio isolation
Date: Mon,  7 Sep 2026 12:24:46 +0800
Message-Id: <20260907042447.2450663-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907042447.2450663-1-ridong.chen@linux.dev>
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58snuhp1jtxj3nheqndutk9h634w8hjo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DC5380003
X-Rspam-User: 
X-HE-Tag: 1788755126-100513
X-HE-Meta: U2FsdGVkX18egR7h0EsaqbSt8g8djZ9M5lgij5uH8TJS5CLOhCrzqGQF5fDSmrC8YRQBKW7QicZUEDGyUBHkX35Jyn7c8FdbAbb4/20sUMD/WR5q3SkrIHZAxDdgaGAK4NxtWAIZNM1vDnXqM6a5Q8NyiV/gqiKKzK/kYWpqhLNk1QK8Z98z6AvXp+6BLnL4iWy91031Bz1N8yakTUzjvgHi1MBjZ36sb3LG3Dk60ShmYqPWFf+GhG02Pe4yoAht/k1evgCc0sD45Ubr6r/UXwh6NPPyTIUmoO6PeEGJuyzvQn51kIG42QNE4+8rk77K2iulqJObyWi1iVrXWDcaCyx5gL6+Gi/LjtT+GGhYJ6peDab0ZS/OG4FTHNKwj+FzP97LVGBUpYU8KNNvIv2aSMm2wal7OixgAFUKDnFFPGSRvzZc+T9zoP2+psV1Kf/NOzkdSCjkjDRxU0VQeyL/u0ZGNs1f4JBfohE7NwMjGZEQplRvbJQ65ABAzPXW24BbIPhPSOVunYsisTAO+1Rj6telY7mea4nTvRnp6Erpf4aYCebSV1qCWxKgTZMrmFz2wr+toV29xtWORBbrvYTfo7fR6pyOv0PDE5IjlrYXFG8XVwsP3sPLVgkVrAyZAT7MlUgPq/ZzXEF3uMBM6GY6nMA+X5HY32JyCSiN/rE0EWohlCSsCBD7asS9raaoH5z3GcaEO1rmDhak6nI4NzDvwKVa+upUk6dsKzPU1/a7Ns+cMPMKdVUaJ8pLjvfpu741leIj6EikmwsQvV+QPEQ087Z3CtAKMftFmxHxNN3cB//tBwJppG/BLHyXUm9lqlNr8OvHugjAGxHp9I/yNoz7OOWo3fqdi/6I4En1UbbxReIaYHVwnYG2mJVCJPW4eyNkbslUXft85Pus6qEaGu+e7MPW+ydvaq4+MVWwRQa5xgJMwBdELZPpIXccCAPPlRWiTg+P9DgYfV+zAoSqHr6
 JMbEVxM3
 t9M26OMafctEc3zamvZB0AMXZSeiFX6mKKejPdWfwk+uq39lzkl/Y0arz6hcGaPlc96HbGmJUeCPwOgRwA2q42bS8ey0sdvNcNDXKdvKIqpLvwxdW/84VK9wHQBSKl8YzLF7YjbchhGKAW7r9S3x72ExDqfHxbzIb5uRhQwF72rqc4OlWTUt3TgMxmU+w6HR5m41d+JNJGhrh3j6HizvLW2LAgzRrsyP9a2nt8j2Sb7n7dd0l+UhRiOTckgHN3tcjBAky
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

MGLRU's scan_folios() and evict_folios() emit the classic-LRU
tracepoints trace_mm_vmscan_lru_isolate() and
trace_mm_vmscan_lru_shrink_inactive(). Those predate MGLRU and are
indistinguishable from the classic-LRU path: they carry no generation,
sequence, memcg or swappiness context, so a trace of an MGLRU run cannot
tell which memcg a given scan/evict belongs to, nor how far reclaim has
progressed through the generations.

Add mm_mglru_isolate_folios, emitted once per isolate_folios() call with
the memcg id, the type actually scanned, the effective swappiness, the
scanned/isolated counts, and the anon/file min_seq and max_seq. The
min_seq/max_seq triplet ties each isolation to the generation layout it
ran against, which the classic-LRU tracepoints cannot express.

This is emitted at the isolate_folios() layer, which is MGLRU-specific
and has no classic-LRU counterpart, so it neither changes nor duplicates
the existing scan/evict tracepoints.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/trace/events/vmscan.h | 47 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  9 ++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 8a872990b4be..a0e3cf75294b 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -392,6 +392,53 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+TRACE_EVENT(mm_mglru_isolate_folios,
+
+	TP_PROTO(u64 memcg_id,
+		int type,
+		int swappiness,
+		unsigned long nr_scanned,
+		unsigned long nr_isolated,
+		unsigned long anon_min_seq,
+		unsigned long file_min_seq,
+		unsigned long max_seq),
+
+	TP_ARGS(memcg_id, type, swappiness, nr_scanned, nr_isolated,
+		anon_min_seq, file_min_seq, max_seq),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(int, type)
+		__field(int, swappiness)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_isolated)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__field(unsigned long, max_seq)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = memcg_id;
+		__entry->type = type;
+		__entry->swappiness = swappiness;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_isolated = nr_isolated;
+		__entry->anon_min_seq = anon_min_seq;
+		__entry->file_min_seq = file_min_seq;
+		__entry->max_seq = max_seq;
+	),
+
+	TP_printk("memcg_id=%llu type=%s swappiness=%d nr_scanned=%lu nr_isolated=%lu anon_min_seq=%lu file_min_seq=%lu max_seq=%lu",
+		__entry->memcg_id,
+		__entry->type ? "file" : "anon",
+		__entry->swappiness,
+		__entry->nr_scanned,
+		__entry->nr_isolated,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__entry->max_seq)
+);
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8409ea4bbf37..771fe6827939 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4843,6 +4843,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	bool tried = false;
 
 retry:
@@ -4854,7 +4855,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (*isolated) {
 		*isolate_type = type;
 		*isolate_scanned = scanned;
-		return total_scanned;
+		goto done;
 	}
 
 	/*
@@ -4876,6 +4877,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+done:
+	trace_mm_mglru_isolate_folios(mem_cgroup_id(lruvec_memcg(lruvec)),
+				      type, swappiness, total_scanned, *isolated,
+				      lrugen->min_seq[LRU_GEN_ANON],
+				      lrugen->min_seq[LRU_GEN_FILE],
+				      lrugen->max_seq);
 	return total_scanned;
 }
 
-- 
2.34.1


