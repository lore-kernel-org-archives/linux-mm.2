Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC073CCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0396B00B2; Mon, 19 Oct 2026 00:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7616B00B5; Mon, 19 Oct 2026 00:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADDC46B00B6; Mon, 19 Oct 2026 00:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90EA66B00B2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:24:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3000A1A0639
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:24:09 +0000 (UTC)
X-FDA: 85338083418.23.D620949
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A33F120004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:24:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tltVn2i+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792383847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5d04PPwl7iOTGRk1VvtVOOC/4WbIJxs8MFeTOu0ZFQ=;
	b=DbKJqIPrrML9CPVnLAwh5YNHq5yvBqF5tbw7HUig1l72LvVn1CE1zJeG8nBxf9AXtyvwb0
	kMU20PxpJWyqAixmWHi+axba3kBZHCKhN2gnx7JPIpw0wVvYdXtGGKl5+YMrFxgrJWX29h
	Aqz+dHP2YZJy7X4sawGbBLOQSTvmbzQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792383847;
	b=tdXcG1cCFKeel2zBdhdhfSaaN3QKFBY802fD8JJu4m6/AwCDStO0G60W3fPMoYUeQIjl6v
	4XJOOLJRVpYjPl8dWOX5vDSynjslM5ydMZCiq2oET6W3VyZUDyKpRl5NfK0sUv4cOyOuCL
	9CUOKWF+2tJqQR4cp2mZ0dj1d4vwUC0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tltVn2i+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sJuXFmGJeYUYsmp3M6RZmn5KdaBGmBz41TFuVzBcTJY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383845; v=1; x=1792988645;
 b=tltVn2i+pxNA/b6kxY8IwLND9bpDflqZGrbOdphRF+68K5UHyYCeotOfs38EmhpBVUN61piS
 6tnWVojHtA2MtH3tjSyuXVjDrF2htx40KCXgsWsnwQlNz/z8g2kUqjpOOmrdgDmnlGpSrLWoIer
 3WTnOU0TxKx94QCPTwDVwq5o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 84520b29f8bc6005;
	Mon, 19 Oct 2026 04:24:05 +0000
X-Mizu-Trace-ID: 84520b29f8bc6005
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
Subject: [PATCH v4 8/9] mm/mglru: add tracepoint for scan_folios()
Date: Mon, 19 Oct 2026 12:23:07 +0800
Message-Id: <20261019042308.2372396-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A33F120004
X-Stat-Signature: upxzm6dyrtpmy3pyib8s7rpndugrkh4t
X-Rspam-User: 
X-HE-Tag: 1792383846-155137
X-HE-Meta: U2FsdGVkX18MoIsuuvLPp5xhsKr8bT/UDrMOIVLTB7wwGTQqskVgg+ik5aRYMgs8lHG9jGkEQAJKVKQ8sdSwkth7oar6zdw10fQKLo7ePADT4sMKb1elXh4GJe4HY2QIaBMEEQ3MbqMkeOdNIUCKav5D6GWpCkXifyBTq5WBtw4QvoIrArCMxvqbcm45RVp5AZmJYPW3y+2r4droWxLgJeRsbC14PRKsLg3+gSvf3KO+cwgtF9GNGyH+bia1L86sStgRm49Ctw7EUaHCxZXmfPs6Obb7+9UYS980R3FxevFjOxgImZi5LZFzTql1gfjwOVcF3GsuqSH17b+ickMYzAOPLK6WQwaYYPEVDynl8yHNM1t4jHyWFT3rIAbGZ8YJfGuqLpCZyVIhPLwG7eQtLvA2pNxvRdaoVIRWHvAMQl+yO0IhuHg9UL2ZFNfF8UftU/gQmEcbDtL63sCJY4sUBU5PatDDguYKrnoebzBUfQym6iBm126RGoHhC6cleuktV6+kJUsltwl7z4sG62OuWqz1LTYlczYGWHqmbRYkTlU/2eHNZ5xBtSNo035VgogL67Z4mhklHu5fsFjYNhD5CBiUcCK53YTw1A4K6ij3A1iOpCClweztg3weFN5RHW8VKIQNnucCKcR+vtp4pp2OqD8SS1T4DQjUm8RKq24jG9jAP2ymGc3bazZQJTwgrFJzbsKrUbCv2GA18/y+ZDA9UHN5ff3/57Qo2PzVv7eco7bNAA4IQkuyvQ2VVkLn1jnarcTQam2rz3o4oPU2mrPF2QocvMq86bMmvDwMdrCVjIsoOPTZxQ+gdE3ynF3sRNtwCi8vWsjC5V8paULk/mik9f6s3bz/kuFoe8gmCp6smjaOyyh3H46MYfEcEFQRm9xeG2rnSLhtE47yleIhTwnugDkDDJ5cBcpAh3HEmewLxxOaSf38kmufaAsynQ1K0726iCF3T/b/m0vdM+ckP4H
 WWkzYIjY
 VjxCuAV1muinjc72WD6jxzLR0cC/A6ZABa0R5Dpk4TTm1bSaxhxvfRLzYr3X1elJpL4Pt8HdPWpmY4+5oiSJt5TT9UVCrBd6eKXn5dEZG0ZSXR7RaAkqqU55w/ZHB8q+UY2Qv2GwsnoRlJs1c/V5vs15B0MUmK88/e1XDZaOELZB00fbysRB5vdGPvM7YjHCFkkX5tLerdCZX+SmVkrs3HuGb44buDg8hcKuAa4zjW7Cwl524iFAtwty+rj8t6YGb8hIV8pkQ9y9VfpQVi66WhdUyUv+/4mEmRSlLBbmiq378TT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Assisted-by: LLM
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
index 5d699decaa28..d459678c5ee5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4847,6 +4847,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    scanned, skipped, isolated,
 				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
+				   skipped, isolated, type, tier);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.34.1


