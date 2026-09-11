Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3167C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCA66B0096; Fri, 11 Sep 2026 06:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DD16B0098; Fri, 11 Sep 2026 06:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BAC16B0099; Fri, 11 Sep 2026 06:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2416B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:30:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B07C8017F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:40 +0000 (UTC)
X-FDA: 85201112640.24.3BAC85B
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DC8CA0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a1i9gxW9;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789122638;
	b=icDKUF8xsCtWaJ64O8MPB1ck7dHu8u4/RDQDUmNbBan/Fg+6W8vmg3VU3iY1iXP7UxTu1y
	3bQzuSl+4PXjrn827sh49avJJbLKR+nlbgmhJSZbY2QhHm9BMa2OduCRE5x8lYMjc+LLYX
	95A2gBvNdDWkI9wdaz84dtzMTe4VbA8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a1i9gxW9;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789122638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPQaQ/7F/sRWk/pGkw5sp3PG72aHZG9iGv7p/zeAo4Q=;
	b=BpjZ1MtzeYoPqyjdsE+YYqQbSlYEMJ2NW6xVy2pOxGjNL3SthcTY1qVaeESS8+kBWVP+7f
	6QeVp6Yq3rfjFnp5e35Yf/mgkil+MhZWT/0n1TRpuqK4yfF0wyGvXKGHS456THymfZsVJC
	gdcgdubSvNFzTRi9NSsits45uU4pejQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f5e278sD3gNZ2nE15RiHlcOXf/umzmsjPSOt99uIDKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789122637; v=1; x=1789727437;
 b=a1i9gxW9iuVtYN3wWZ2tqB50zw/lmzUSnqUg0inrvBsJXHd1htJsAaOTW+PU4OasyviCyKQf
 viEt4FQTpT26qST2EUfNFmWQjIaZXgWeShUGL06wPcg6epVy5/qoe6s/z2PK3h3uI0vsPsQ/gfq
 NqvfkMbOEx97Dm2fgQ8+AZOo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5d4f4926e87c551a;
	Fri, 11 Sep 2026 10:30:36 +0000
X-Mizu-Trace-ID: 5d4f4926e87c551a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
Date: Fri, 11 Sep 2026 18:29:38 +0800
Message-Id: <20260911102939.2485750-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911102939.2485750-1-ridong.chen@linux.dev>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8DC8CA0005
X-Rspam-User: 
X-Stat-Signature: k3ecpf11yu7dc47pymac5a9jzhbmxnuf
X-HE-Tag: 1789122638-506901
X-HE-Meta: U2FsdGVkX1/FaWmNOnSR2qtU/2UHpqqJGJkhLYm3lsVH6dVAS/tPJxABpDXxVkxaB9dgKON2jy7vw2xb3zKpdriOjRiFDYhBQEebpRJEj7irWNV5somH3uEs+iXIDaweA5K3DrZvFBKAZYP+jMsACtRXVaGPv5r7RXwVK4lyVXLn3gXUvORvb4+tVk9gfDdJJvSj+PY1G/Vw5VaR7cw00/j02MRqEGXYr1L6WYjw4DsCMNg2/8if5cu/cL636ObA1nytN5NplTKid1IjmxTYNmpN0iAy0TDENA6K8pTS88AO+fOJUCKXGXB5919pWI4z0IyKrfzeA52Me8AECpcnqq/L4y0HT6yYbJG1B8OtrrIEbkxH6C77Dv35228iK6IXk/udPTnUmfBDWIy+v6AG1B8CzSsVJhU8i2VzkuLcr1wmvDlzcaLvAvoz1V/mXvZ1ZEh7hWwqrxSC1Aj5u49GHigOAUFDU8mh88eJyYCjvlnN1C7bjm0SOGvO+PDWKf0XUbGad6W4DXLrrbZWy7ejKCjP09jOi/Ky9j+6G3/dvHStqZxvOpoMjKaFdpyaottPWAKx+GdLBspAROpYgFpg8UHY2HZde05qMGhK5FTnpBGw/k0Tl5EjhsUxWU+GhYN8mcE+UtHWhD/7WuqEHhAgNlDPh30uyksnaTF7ayP3T2CxFFKvne38sF56JResFIEfG9ULCDojOhC8ZXvEUp23JZI8ErkS3kDP0hlzNRFzuqsjYgtMi0fDZPChToYg9JzMvO7qhRdWO8X8f0ITQYKGqigYEBnhan8zu3BD7EGEi3ayQy5Yx33kN2/ZS0Xdgmhu1q2LQdtmjvgV74EZgcBf8I+y9E6RE67KaqU6KiTGaEkur2ihbS0pJTSGP8KoZ3QLF36x1MEvkIMydRK+Tj73DtBu8KU0/ZlR1f88kScvZqhri6PoiB3Ej3IOHrCzx9l5SMZNdbB+N/nB42RE2e7
 Iny7+Wfr
 raFh+m2cljuV9BhH2X4vHA9LWoSc9v2oD2TGMVTH3WFRoxmg3KY1HNc1hjB9cIQARzMg3jNgQGhtkzbRaU13st6mTGE/wGRqOiqhljc7J+A/yvPomz9wWYD+IW7aAHohazpIJuds9FK+dKVSPh1JlDksbRVCILkVXy1PJFm9F8j43HJmekqdKZ6k8dWmgF7ABRz570qjsXy7qSAsSCRTx4985AS+T98H9iGiFJzEtAq2gEv+wjtN4sMeBlXcjuyy9Lwha7hyjwFswYDMd7oVzb9yPlX1//rA49Hp4XkLCZ3uYJvw=
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
the MGLRU context the classic tracepoint lacks: the memcg id, and the
max_seq, tier and min_seq of the type being scanned.

scan_folios() is the MGLRU-specific layer where folios are actually
scanned, so it has no classic-LRU counterpart. That the classic
trace_mm_vmscan_lru_isolate() has lived here stably shows this is a
long-lived place to hook, and the new tracepoint can be enabled on its
own to observe the MGLRU-specific information. The existing tracepoint
is left unchanged.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  6 ++++
 2 files changed, 69 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 8a872990b4be..5defa8f6719c 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+TRACE_EVENT(mm_mglru_scan_folios,
+
+	TP_PROTO(struct lruvec *lruvec,
+		int highest_zoneidx,
+		int order,
+		unsigned long nr_requested,
+		unsigned long nr_scanned,
+		unsigned long nr_sorted,
+		unsigned long nr_skipped,
+		unsigned long nr_taken,
+		int lru,
+		unsigned long max_seq,
+		int tier,
+		unsigned long min_seq),
+
+	TP_ARGS(lruvec, highest_zoneidx, order, nr_requested, nr_scanned,
+		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(int, highest_zoneidx)
+		__field(int, order)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_sorted)
+		__field(unsigned long, nr_skipped)
+		__field(unsigned long, nr_taken)
+		__field(int, lru)
+		__field(unsigned long, max_seq)
+		__field(int, tier)
+		__field(unsigned long, min_seq)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->highest_zoneidx = highest_zoneidx;
+		__entry->order = order;
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_sorted = nr_sorted;
+		__entry->nr_skipped = nr_skipped;
+		__entry->nr_taken = nr_taken;
+		__entry->lru = lru;
+		__entry->max_seq = max_seq;
+		__entry->tier = tier;
+		__entry->min_seq = min_seq;
+	),
+
+	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
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
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2554a6513aa8..67f59aa73fb9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec,
+				   sc->reclaim_idx, sc->order, nr_to_scan,
+				   scanned, sorted, skipped, isolated,
+				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
+				   lrugen->max_seq, tier,
+				   lrugen->min_seq[type]);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.34.1


