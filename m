Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E894606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ymnes9hU
Received: by kanga.kvack.org (Postfix)
	id 722376B05BD; Mon,  2 Nov 2026 21:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9276B05BE; Mon,  2 Nov 2026 21:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638976B05BF; Mon,  2 Nov 2026 21:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 418606B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:58:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D794F1602DE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:58:03 +0000 (UTC)
X-FDA: 85392298446.27.371CC0A
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF9921A0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:58:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ymnes9hU;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IRpsKB31ZWOQ5n/UsohIDOoT7iKXviBSO161ss/1dE=;
	b=OSIxHK3bOVHArh2xB9SH9mAPsUDD3KUivj4kUHK+SGMt2YLpyaseIJerz8JmHi3JDVVjZa
	AmO/7sibzGaF2kzRg1ddzrBM8Zz6anOSWNhHVJiA3jc9Cv+6cFTPnJgnFKuQAycaFbOfLt
	Tvd7pQigWSfh+0K1ZMa2qGf+fQRSA/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793674682;
	b=doJV/yMZt0n+P4w4QJO/e88JhHKXKe7aIRDLWLKjTHek+T3tlmn+uKb8rAuirJupXTAJ4h
	wWPbVNSMkIt8dlYZiwp5YBQBb2HJkwWMbYonQTg0DZOzIjT7QmnFwiGUi+/5EvA9RhNFXW
	LNfbrONThl7TLy9Styk+tVU5F34sF8o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ymnes9hU;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lyrb92uDQUPbkiBltZi1bjdhjSGbJYzJNmN2CpAeRBY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674680; v=1; x=1794279480;
 b=Ymnes9hUueYcoUxGz5QwDS5GUw1Qmnr7X/K2zXmtGUWjBAqldu6yJuJArKlNuSWuC36/5Kw5
 BCkiEyv5qn7dI9NQNbJMqcVEVyyNlWsdwcoMUU9VOtgUcRweQ7FNGpdbwVe7hR2frOOLJNuqDOu
 ValsYvN1tCUXXv1UX2u6Uwn8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 595423ef5b9c1195;
	Tue, 03 Nov 2026 02:57:59 +0000
X-Mizu-Trace-ID: 595423ef5b9c1195
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
Subject: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
Date: Tue,  3 Nov 2026 10:56:10 +0800
Message-Id: <20261103025610.3738894-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wpg8ms6mauueiw64bwt3ss5dpz6bxdnn
X-Rspamd-Queue-Id: DF9921A0006
X-Rspam-User: 
X-HE-Tag: 1793674681-628113
X-HE-Meta: U2FsdGVkX19Dvd8/ZX99QSHI2vLIN50/lYvgYmMBvqqDsQm0eRyG1wNQYtkInPcWGcip6+kMZZgfgu/aWInBMb6IzgKqY4iZZtt5FwZiJWxU2NFtErQ5TxjlU3K+G8d4qoY5YL57h/wssZOvVzWkyizr4hhVbIpujgwaHXRHVk3RBDsIAo2HPkUnb1Y/KfU7RBvaadVM6PUGNhRJe9reX2SPDSvvvj/08YWjmNpfJ4Q1gTcRP+ETuObtPiUWz/0qcZmd7bZ3CwFACf5/zgoaWdGiA+9Bl0nvpcZuT+J1/C2WOYRR+v1aeFx24pVAvSzXHJskieNzjan+GWj8LOqAM2TXnb3eIjVUTjKUl2nUzC+gn4J4WFjt3+tEDbiy4G0X4VocPkf/5ZcPMX2LYvbMBu5gGMRncavLXcnwycqq638RuoTHD4SqpPd4q31UyWa3L5dHf5NESmfMMrdad1u9I6tbuEFvlZk5g/QjtSX/ahbwLHK+Qbpr+2g6Ag+sLh+AiNP3OP6cQ7ptzX/LwvrUYkVKbLd3TwkPk7yyGKEXUvKWkNmH0I5tG73xF0gocPbOx0caq0FwIbM5e0zDW436iwgn6aEeAuaQiJyLSIB5Srs4//ooUhY1OnJfOhrvVBRbFqZjzlCoAdyzV0kGg9gr7Z4hwCMfYH/2rDeqZO8QHpm3W+WGgOr4R3hbFonGSuRBI3XFgcbfzATAKCUJ8ZNLtnB5jt8kBq3kTn0/heCogwANWOj5/N+hN1XDJgwPIrYdWVtEc+rxEMcdcoSupTOdm33DwY/WqoRlJracKl6pEuTSb4mOOQ1Q91oBEW7OYfD1bUuxAulhqJIRpzkk8QdEoP8zCqur1LtBWw2UuQe+Yb5HPn+KVJWdeg85wf9jYXaUIJLpYpz9d2IgEbIOBEtzeaAQyBAdVNJGnll6spLhBm57bNw67fEaRd86Q9jVJRjEeKrO6osJp5YNFZy6O6i
 tNH5dIA4
 rgPgohw81EyoWXwIgiq4yQXAvQ0Hdy/7fxfkNdd8j1r6RlUIxFX/b4FRd4bmgKU/QK+H3HIcdplNwThy7hgg0EpiH0SRXNnjGoKyFFOyd2CjmCgodhbBPF7/HVpL7IUfFrQXTrnPzTwW6NyUyyPMeDfYBqMbRia0cdoOjkJtv1RgjK5VGZJ/elHR3i9VgCMd++Gz7IiTL2wfAWnJwosacEvyBHBGsbkJM2YryrqTa8bbC57BM2ewp1VDS1q56dPN04XoIK5nDtn9xESxAcP2D+g1h9ofZThcNe3AbP2CfwbbpsL6hs0HomqCcJa1mdflGuArZ+U/EAIeaM4YB6hQEeCYxGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
the lruvec lock is still held, with the node id, memcg id, the new
max_seq, the anon and file min_seq, and the number of pages in each
generation for both types, as computed by lruvec_gen_size().

The nr_anon/nr_file arrays are ordered by seq rather than by generation
slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
they go from the oldest generation to the newest, the same order as the
debugfs lru_gen file, so the output can be read directly without mapping
slots back to seqs. Entries for seqs below the corresponding min_seq are
not in use and normally read as 0. The arrays are printed with
__print_array(), so the output is hex and its length follows
MAX_NR_GENS automatically.

Only the lruvec is passed in; all of the above is collected in
TP_fast_assign(), so inc_max_seq() does no extra work when the event is
disabled. Paired with mm_mglru_scan_folios it makes the full
aging-to-eviction window observable per memcg.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..40d6d90f1d7a 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,52 @@ TRACE_EVENT(mm_mglru_scan_folios,
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
+		unsigned long max_seq = lrugen->max_seq;
+		int i;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
+		__entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
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
index 1581b73aec56..841fefa68d1f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4115,6 +4115,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_mm_mglru_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1


