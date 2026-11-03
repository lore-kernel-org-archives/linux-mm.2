Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B6A606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sh3Z7f4Y
Received: by kanga.kvack.org (Postfix)
	id CCD686B05BA; Mon,  2 Nov 2026 21:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DCD6B05BB; Mon,  2 Nov 2026 21:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DA46B05BC; Mon,  2 Nov 2026 21:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 943C56B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:57:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FAF5A021C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:57:36 +0000 (UTC)
X-FDA: 85392297312.25.03F7BF7
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B7EDC0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:57:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sh3Z7f4Y;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793674654;
	b=sIZTrB5nA6g2IE3Aukyt08zPSAzM9AxvNjvNUeWFinhCs3qrr3C3hXvSwYAU5lvAQPQgqA
	lyE0+dPP8aIkxZS43wkQ1+binTUWviKn2HOdyQ6bc9tP6MesUsBmpogoDrwoq5ozbh9JVB
	aFbKlb9sKJa4MSV/GtOKy9Oqa7e+33Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sh3Z7f4Y;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PU94Mtq5y2jfrWNzTTXz2hKQJlADRro9ghWjEf4hyI=;
	b=AFyAbgii4gpbqkH0wyQ3HjdH6eZAFQ2reVxeHagDaRIIifyuaPtWii+Bs3E1AzQf8A13vS
	pZfA1bymrsPp1qPUGrX9Mimz6Cw3dP5Qvgbt7TCIQ8xeetodWidBdrGR+ETfDxx8B8HPf5
	0j3Qsl28kw/ZqkkP5+59l9Cif2vq3iM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q+dvcKKj0mIW3aumvJN6ron6Z+0VLRCZBIIddebUpDE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674653; v=1; x=1794279453;
 b=sh3Z7f4Ytk1TiTaWSJa5Hn5qre75h8aoP0cRSiJlcO8JeMILXfaGO45Clj5NIG36xZxczU2r
 cZmo9IfhksyML7ue9CdFgkxl076XN+riveJcTzK6k2EuJFVlSjR1FhGYywuDDs7dz3FvS6JzwK3
 TUBWCHIMBj4TpSkdl/KBYj94=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9d15e9a4ed6a39cb;
	Tue, 03 Nov 2026 02:57:32 +0000
X-Mizu-Trace-ID: 9d15e9a4ed6a39cb
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
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v6 5/7] mm/mglru: add tracepoint for scan_folios()
Date: Tue,  3 Nov 2026 10:56:08 +0800
Message-Id: <20261103025610.3738894-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5jbrqah8iicxtan3sx9fg19ffy4mjhpo
X-Rspamd-Queue-Id: 3B7EDC0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793674653-245131
X-HE-Meta: U2FsdGVkX18kD84aiCvucw3uMqVIJYuA3GN8QhFmsJhz+BetgftYFhuE2D5mFtvnE1zZKzrc82vp4uAwGo5iGtCDNm9lifnHOs9CYIEPzw0rMUIK/uTXhKkZVEEb1zgYy+ByktFUh681zBtYqWbs0BwEzevxxAptM6mNT7fHuvKFWdG5WsqkxL6Tv78VpayYVbghL6dszo7ahtZ4a4IAnUVN2vKp1dQMrm7Z6wdxHHusfKVcHvutt1pdZ4WrOEoVuB2cgbp4/KfB7aF5EhFhy2VLvFuT4Jsuf2svswBSsxFWoSoegzvAh/7/cVBExylXO/AphlU1RB+GlaWKIEFT8t4WEfAp1qyh4YM+hgKKX+LbUYZSmG1+FyywUbbB3m82omiYeH3lGsYI0Fnr2EtgdRt6gHFLg0eJylc//fr+lSdvuYbt6P138FaQGOpPwTrHg3jmQmGvcIMX2vVyNPJV5B19f3/PYFvQUnOtrEppXEsJFc/NCgZvRWyzgHyun+B53jUVfQOVEcXhSoUniJaT0ACjPXJiHdlByM9uppcinz3uxC9cy5tCXwmQ9/3hdzdpfajeK2bwJrayqEP5yVtTFDKPbKICTl7cL69+WH9fS5cDTYXApDXLK9cKflBWhkKAXSCzMlasbzpS4G3uRB5JNTL4xNcfsxwY/8hMkIyQkUR6Dm1vgZNR1HCpFoQfSRnOJFdt9nE/egcag/yzr5RQGPXq6Ct5QMsTjLotFQ77/NE2FJh+16etN8QIqB48Uc5jlSuHS5DSqZv0veH8XgtVzNsoGPCUpwT20Bwoufcv9DXHRpfxyZE8WdN7iygMyDPXeOZwhvaa3U8AcrtIvCM+8KPcngZcSzYYMI9j96CuQvXaL1xYXIX2T+JPA08nfaCbjz6oJS46JYajNxmjobzpwZ4ddYTLn/HQoOAtSRRlQ19ZLIi8BawbO3Vhw++RQHQZgW+bjFKniorJ0W99fEW
 hUL9Yawg
 5wxaehe0u9027uFWKWSMOztn2tv4P16ZVNUle/fa/mJLBtWKIwy3J3k1E+cgLj2jWjVCAFUB6tkR5NKejFR3v354VG+AxxMLGenWrjh9ZDcvAjGiK2nPviARWqH8bguCk+sudXi4NuFLutgIcnCvThMKU9vX6V9plUIjxccZTi68DYr9MdnDFH0hXtBEmqx3jxQzTs+O6F06XpfXE1l9MJcNiQ1Nh9gxEd2pFJ4EZiUXKBluIBGoRYVkjg8jHiLhisID83O11KZCk3Q1TweqMH4hSrmE3Tzmpe5/sHXtFqEaNgld5d3rA3dRlw1Vsb+ZxDQEO
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
index f3ec19352e6d..3054175717ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4833,6 +4833,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    scanned, skipped, isolated,
 				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
+				   skipped, isolated, type, tier);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.34.1


