Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA938C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC63F6B0095; Fri, 11 Sep 2026 03:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D456B0096; Fri, 11 Sep 2026 03:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7336B0098; Fri, 11 Sep 2026 03:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDD316B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:29:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B134A237E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:44 +0000 (UTC)
X-FDA: 85200656688.30.1CC0C16
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id 227DA40002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C1tsNtNW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789111782;
	b=rBrB+qVPPtdFY1yZP8RqhKyH2giQaXehuQ6WlathW6H8hMk7CnuTA8vg8Vz206OQxsieYZ
	7lp11SYfGVaOsyF9+/Z6Cg5Ovdar6dudGgduYKdDmA+fsbiYTezc8DHwWBgJZGnH7efXEc
	9oPcfG9oeOX2sqkGeyxZCNr9tyRDLbE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C1tsNtNW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789111782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vD/tj2AK765Epc4HikjrXJ8GD38Dy7fB2gFIaSZFtAY=;
	b=e9g4fI+XPdd3LGN8V8dBp3EqE3nwbnz6+l/mBUti5basMyPyHozObLENZcm/YR1vkvb+a+
	LayOSAYtDXXp+Rkyp/RHrlbYg8BK/mUVPneA0alQ6J2uMtnQSaS6RtdpDK0pASjOHpPOXP
	Tx2Mo6gNpvSt731qTD3McsfyYOir0aU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FpcPo83nhWnkkp6me6q/GY/YfYdp1OKd5imnFWeXBLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789111780; v=1; x=1789716580;
 b=C1tsNtNWOICb2y94PHvNp02pWal59w3l81qylbVBR7bTe7+LLoYcYZ1F8VZzQy6v58XjJ2CL
 k9hi5qfwXgetgx1sSf4ZPncgPj+gwXOPaE3HASs7mATvmk6knR2yHDwhHgDvR/7/MSJ4JKo0+Kg
 Izks7hAkpt4xfZ8c9Zqbqjkw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a8b9bafcc2d8f444;
	Fri, 11 Sep 2026 07:29:40 +0000
X-Mizu-Trace-ID: a8b9bafcc2d8f444
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
Subject: [PATCH 3/3] mm/mglru: add tracepoint for inc_max_seq()
Date: Fri, 11 Sep 2026 15:28:48 +0800
Message-Id: <20260911072848.2346073-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911072848.2346073-1-ridong.chen@linux.dev>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 227DA40002
X-Stat-Signature: qctssunmxykhmwtg35b19fyboadu47j9
X-HE-Tag: 1789111781-690095
X-HE-Meta: U2FsdGVkX18GYgC69Tq/x+uufyTZV1Lzw0E5Y8LjUJO6L0s5kwGxg1y62bnq4/IeDNCVKrb8XBs7tCqwo5ZIghHuG1l3tjOKRoY7eJb0xktYePMmlDCoUuHio3sTmWtNeARFMDErXJGzTlEqmw/4Pxu0crNE0pMweydyYvLfWHaYEPgrNr1biRdTzVokrlGOyupZVwOUVK1mR+I6ZuyK0m1OBwjyXA+TRj9hqq8cQL33usrWomm/rYHr6nfylbvQzbYs6jko0Ptla+P8/g72o3cM4eUviQM5MUsyWJTuvRIfxhgNaVI3v75p9X+a/qeoDXS2R4FddiUafAIB8fZkz8RbmwXVuKtqIpTD8pHiL7dW4BcE2pmNMdaV3zMS22+Gvv7Ntz7mH/uqXo/uvh1WuS+E9dbO+QNSx2Ev6JhSMBsU43HdhbqR6qohv3Cvr5RKgmuwR0MHqH1U9JhZQMYI/2iQOj190CkIFiFw9vYzmpC5bJGRQEZl9HyIn3lEI/jtEtxQ+TBrzVd0/EJCuqVxcu5QWhdVnBH5TussUqIH0O7vX0bf4yHX0KLLy8UIMTkXPNRlRIO/S2LwrfNLk7gJ5Me3+Wnfctih9lfi9qQCNnRPYEmYNOo/StvSKorZZJC70bvMzEeu5Cxs1WRLXmoC12QpgubbYR8GcYZyWMnxh5G4zf1s2fJk3h/bjv0o2zLLNEYGDUS5YC9keQFKxEYef0m7O8l95sn/R+JmC6Lj4f5VoqQz3w3O5gvPIa/3DYnB5VNkCzB0Uqm4xGOso5SylaMWyVrHlpRXbLN1qu1pdAn4ChwX8OS2QpG3MWHiDi9rrbyhxo80TRqNhB8sBOclDWIQLqlslcDWmUQdo6wUISPlftdkBhEGG6PRTh0F9zOdTiFl9mOhBvWQvqK/CWlIGuTp5v/cvdqjF0wqdiWS/TBZ0PAmky9oICKEJbsLNwyOrR7AO9zjYbrjOGMIaiI
 uDydo1Xb
 TFzD3ZWaqHHeJeh3ipHlPRuvN0nbHoG74O5uzUzB1s5U1N0BK7Xbj+FpopJooFj6Hulygxz1Bm+vapjcDgt3KAjB8vhQjte/ZjKoTaWT4TZSD/IrCSsxHaMaQyJJT9G+EYmGPlfPjAZvheLDAxC4+dghUOTHbnXhQ2B/yJHXCmSWqnbAmY7N2UpRy78vbTZLQ+1uQlZ8Q+s67Vqmm6X5Cq5UkK7ykTIiiBn5cBRSlgRFA17c3MwH7elhqJ4S5u0b1GedcqCv8spQ9F+bKVrclZxWaxVviy5MfN+MO6ftEuR5s9FA=
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

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped, with
the memcg id, the new max_seq, the anon and file min_seq, and the number
of pages in each generation for both types, summed over zones the same
way the debugfs lru_gen file reports them. The nr_anon/nr_file arrays are
indexed by generation slot, so the emitted max_seq/min_seq say which slot
holds which seq. They are printed with __print_array(), so the output is
hex and its length follows MAX_NR_GENS automatically. Paired with the
mm_mglru_scan_folios tracepoint it makes the full aging-to-eviction
window observable per memcg.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/trace/events/vmscan.h | 38 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   | 22 ++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index c39dfacef033..9cf3f4564afb 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -455,6 +455,44 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_inc_max_seq,
+
+	TP_PROTO(u64 memcg_id,
+		unsigned long max_seq,
+		unsigned long anon_min_seq,
+		unsigned long file_min_seq,
+		unsigned long *nr_anon,
+		unsigned long *nr_file),
+
+	TP_ARGS(memcg_id, max_seq, anon_min_seq, file_min_seq, nr_anon, nr_file),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = memcg_id;
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = anon_min_seq;
+		__entry->file_min_seq = file_min_seq;
+		memcpy(__entry->nr_anon, nr_anon, sizeof(__entry->nr_anon));
+		memcpy(__entry->nr_file, nr_file, sizeof(__entry->nr_file));
+	),
+
+	TP_printk("memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->memcg_id,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b9ecf2e84..d0e59baf5d5c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4100,6 +4100,26 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	}
 }
 
+static void trace_inc_max_seq(struct lruvec *lruvec)
+{
+	int type, gen;
+	unsigned long nr[ANON_AND_FILE][MAX_NR_GENS];
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+
+	if (!trace_mm_mglru_inc_max_seq_enabled())
+		return;
+
+	for (type = 0; type < ANON_AND_FILE; type++)
+		for (gen = 0; gen < MAX_NR_GENS; gen++)
+			nr[type][gen] = lru_gen_seq_nr_pages(lrugen, gen, type);
+
+	trace_mm_mglru_inc_max_seq(mem_cgroup_id(lruvec_memcg(lruvec)),
+				   lrugen->max_seq,
+				   lrugen->min_seq[LRU_GEN_ANON],
+				   lrugen->min_seq[LRU_GEN_FILE],
+				   nr[LRU_GEN_ANON], nr[LRU_GEN_FILE]);
+}
+
 static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
 {
 	bool success;
@@ -4159,6 +4179,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1


