Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFEECCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A246B0115; Mon, 19 Oct 2026 00:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F228D6B0116; Mon, 19 Oct 2026 00:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FCA6B0117; Mon, 19 Oct 2026 00:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DB06B0115
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:24:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40DCB8060D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:24:22 +0000 (UTC)
X-FDA: 85338083964.23.A41191B
Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41B678000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:24:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UtBOYQeT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792383860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DoIPScRpT8SXGGe/PJzGKShRLgpvrZfOm5GeNZv05k=;
	b=zEE/2gnL9pmjRe++gTV6H9BgEk5d4JFZDEJtiJg8v8rtxOrpuc47zLbHzC4ftdrBqBU/mC
	EUV3ACdKm+Prcea9rxzJJ5D7AbAlQfrpt/qFIHjpADSViS+0GkmiGjnFupLXJZJyWROnmm
	L852KhyRRi14HjBFoCbkEbhmKTFXa64=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UtBOYQeT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792383860;
	b=YL+VTUABFxQVV4cRXQnykS+FjDDogNY6od4uDJSMVIcz4aq2naE0BT9azrlChtV/s4i6gh
	utWWVSBhLWMWX9YgIJ/+TjUeH7FpsPT0Z8UhB/UMplrHD2u+fOWe+0fHoiucVfhqn9vvoA
	wacIh8pq/3tgtXgAmxHGO/1ZnfmpNmE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rgCPstrZqNeEdMXP/SoDZYcPpE8lXWIHRU+cnN2B2DQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383857; v=1; x=1792988657;
 b=UtBOYQeTvAeOkvPL5rT9MKUJj+4fbyTR8TCfgiIxaugA1ujuINo44eeFE8CPilvw/nTrVV4d
 NqAGKiob+r9yWe5tHwsfsWu9WQpCOQeI+ViliJuNYGUIyIJY37KkYUlpgbIgV6NX9kQVGPpvHx8
 BJFiHTZmfc28ImkgRKVdSKEo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a7533987bd4880b4;
	Mon, 19 Oct 2026 04:24:17 +0000
X-Mizu-Trace-ID: a7533987bd4880b4
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
Subject: [PATCH v4 9/9] mm/mglru: add tracepoint for inc_max_seq()
Date: Mon, 19 Oct 2026 12:23:08 +0800
Message-Id: <20261019042308.2372396-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41B678000A
X-Stat-Signature: s66w9yef3soud7h1nnx7yqph1g6kzhse
X-Rspam-User: 
X-HE-Tag: 1792383859-56356
X-HE-Meta: U2FsdGVkX19kn8g802CDnlfFPYX7QnOjz07CjRzjoTmy8+Now1B7cVHe30rhz4FTJ8J64jTgdHMgG+JX9XBIhAxolPaRL6yzMqU7+M0cm0eFegtTNQ5TVRFIBVPrecpWUcxZj+AG3yubP06tJ6vDLsYtKy/+guabszgEcfFXLWKpp/DmMHF+uFCo+loYlQqAk1eMMTRaDWRJIf0V/pLPbBgeCB2FHkdb10+3/nXeaOzKexvrj2XfiIF5tVBm7MC4/ch6gZ+6AXExHGBHU6FnNM3HnN1EhpcIg8sod7dnUiuiLEDWBuSH32wSJzgq8iQ7gueDFE0/4NTd8FXn/JQbuH6GiJwHBgqlj1WSnBFoI3mO9hDSazGeQXKTjWqjpPWgtqzy/zCpfQkbeSo8WpkCS0jRKQxgUcCoprehhuqgYuaAEpuHXvzmJP9lFArTw7EQ0vp092aNrGmbUBbv44kv76Fe9CU9tG8COjfuRrIFpSZ4L4Z6xzz9tx4XYM3IciskHIFOOKHxkpbxcbFCb2As/cw+HbnzCuv22E9z6MPoSvf5znLM9QgMN1ErFiVCdDwy+537eEJbXa2BAIs3TH17qgF7xCBUeq7qSN1FJ7XDeoAsy/E/lnyv5XZuCTXy7gELZaJtQr3P/w8jhQXNrkLFHuwdDEqxipel2Z2+/E+57+zpZqhA9uC/KYp58vE3cXEonPyZA0XaBfQ8G82XyNlVQn4z/DP/gORegBSUQ6b4xsyNVwu3kU8kVGvf+Xh6Jcw7V8RmtmY/mgDMQ8GWVBC3J6Mh42bzF56bTYnykONLXFU99THC8xHnTI7CcQcuvVkjNcLSTXi0+w6N5fQ8gjPIQcKFGhegyrAopN0pRvPiEsj40V8CVesdy+AEJRAxc9QJDccon1uWrz5jsydztfLFcKy/HOZj2Ps6uL1kwqf9+oe+UoHsbgwhBmFqNuQR0ayHrZq6g864OQ3KJngKQyS
 /fJYwU3V
 Cp9cRBhq0FCJbbLCWQ4K8qWSUp0lg1JeqAzB3FWLhP2UpAeiVfVNfaVuygtGbp8OFXUJnLzGxovyfAAmejhVpoUgdrgotQIcSJs5VSY9a6NcZ4/B7kRaJsO9zAjCIaF1kJ1R2/1KxHHkbYE1GUQ7zLJTrt0vb4WAn7XaV+hb2HCSHI6OivzR9TWTMsionuVvMbtVPLjz58oJd2hPNVWUjJRMkGsdgApY/JM5s5r8Kvrt2oO13YWOYnBYWvvbiG1eR0MkLLwAz3xR0hI15NLTbPCQ9ucYBD12Eg7NGLzynFdfDWTusDBI5A/oc7IIfqFNROxnoeS7HxQZspcYxfbgcEWijKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
the lruvec lock is still held, with the node id, memcg id, the new
max_seq, the anon and file min_seq, and the number of pages in each
generation for both types, summed over zones and clamped to >= 0 the
same way the debugfs lru_gen file reports them. The nr_anon/nr_file
arrays are indexed by generation slot, so the emitted max_seq/min_seq
say which slot holds which seq. They are printed with __print_array(),
so the output is hex and its length follows MAX_NR_GENS automatically.

Only the lruvec is passed in; all of the above is collected in
TP_fast_assign(), so inc_max_seq() does no extra work when the event is
disabled. Paired with mm_mglru_scan_folios it makes the full
aging-to-eviction window observable per memcg.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..cddf42b5849a 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_inc_max_seq,
+
+	TP_PROTO(struct lruvec *lruvec),
+
+	TP_ARGS(lruvec),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		int gen, zone;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = lrugen->max_seq;
+		__entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
+		__entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
+		/* summed over zones and clamped to >= 0, as debugfs lru_gen does */
+		for (gen = 0; gen < MAX_NR_GENS; gen++) {
+			__entry->nr_anon[gen] = 0;
+			__entry->nr_file[gen] = 0;
+			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+				__entry->nr_anon[gen] +=
+					max(lrugen->nr_pages[gen][LRU_GEN_ANON][zone], 0L);
+				__entry->nr_file[gen] +=
+					max(lrugen->nr_pages[gen][LRU_GEN_FILE][zone], 0L);
+			}
+		}
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d459678c5ee5..7b9b1aca5c88 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4129,6 +4129,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_mm_mglru_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1


