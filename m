Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31AA606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qRmZKOvx
Received: by kanga.kvack.org (Postfix)
	id E9BF76B05BC; Mon,  2 Nov 2026 21:57:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74126B05BD; Mon,  2 Nov 2026 21:57:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C816B05BE; Mon,  2 Nov 2026 21:57:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD6276B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:57:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29019C02DF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:57:51 +0000 (UTC)
X-FDA: 85392297942.22.05A862F
Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A5E1140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:57:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRmZKOvx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.243 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CYw4TJon3a1gyE3IXvNjkyv8y6xkEjfo7VNXh+JX/8=;
	b=F2nVC8VY1mrxMMYK4DTN+53WftoNJQ05rH7P2JPsYMf12OlBCUbH3XyDWAq0ENHvfD4hmu
	fWFa0qntqdCZ1lnufgqyrxXWUdpvaApO7SES3kqVmdDPHtkx8SPHFTwIRL8llZcscCv8+E
	HHbS2BDk5uEqNoIZyEs1Co7GKhugMcA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRmZKOvx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.243 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793674669;
	b=HLqY6K8ZFJRPeIbJGaAksGLCgffirpoLorPEqy61D3UGqZSl217vMugf8/aoiba4AejUzw
	MKVXm9GY8P+iCycH1Qp7iJp/qpw+wpSj7bxj9sxmO5mJCCkk4twXGVlNSyUYL2eOvQqjbC
	Agi8W2owCvrOkO370gH1nJ44bgdIaUc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JI4Fvh2wr8Cnl+a4gBEMEis0OoLVQQsg/DZU5Vjf0/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674668; v=1; x=1794279468;
 b=qRmZKOvxAZzm29pWdZ4p+FiOcdAlOd31TkwZ1mYWu/Aio0acThHVchO6FD9KWaFd/nRjO78T
 e5LBfuH+TgccdMlIR8DpejX0pY34wf/rrevm06HpYXTCB0J5wGvvHe4/wTPC9n+m7nXwVgfTJYX
 53zm5OnXyfcKKE7BNqjbDBS4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 066f37554edb6d0d;
	Tue, 03 Nov 2026 02:57:46 +0000
X-Mizu-Trace-ID: 066f37554edb6d0d
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
Subject: [PATCH v6 6/7] mm/mglru: add lruvec_gen_size() helper
Date: Tue,  3 Nov 2026 10:56:09 +0800
Message-Id: <20261103025610.3738894-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A5E1140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wae35sxgqmant3puy7tf69sh1wbnpn4i
X-HE-Tag: 1793674668-319096
X-HE-Meta: U2FsdGVkX1/y8MPzOirQtXfQ+tq4RsQ0UpG+SOeoNvwvLZTYgpMbfrJC2BcrhZz2AytKJcx+fe8e/Bn3398U6A6cNXCiTjbdLyv0atYl8LM8o86lNncgYoaSL2WleDQDCKWoDmr3dxPaxHhEoAWiHysCAKKcK6IDP3nkzJxEkTRC5rVBFnAMssq8CmjWUAleEDnoabbETgJ96RcWTlE4vntzyNNhOAYOrP78D0J5ZRUn1T6zu7DHqFYTEadIIU8dL58BqQdViUF2S1CQv8bUaqAYh6VJfxEvoXKwhO4XR57/5Q+fPO5gcvJMZB82ekMcmeiQZyV72/miCJ3HRbwohvBOXsxC8C7oTBQkQ3H+0DaKmUPdVjb6oGzhFRPncG4DNuU3ZPly//Ou9uiNNJ0Xad1WqKiLrQVIgPTgCjSghgGH72AhdQSOAarnkt6BIk63Bez85Xao2GplCQc9SThN5jl9Cp0OlvYK+fPSRPR8Rv7KUaWYM1z/2I2LpyQpN/0g34vANpfn35Xtj2/41lAfQvl8ATU8T18P1EXexzSWVjfE7JidxYkURID+uTvAdgmc1O7iQV6o8ibMQk3IGQ+6rrkDgYOCLXJHrXzItQ0FATqvZ3OGWWBxfcpCKwH+n1wAVnrD3b4b0QwMMomlFs7zDvCDWU2B+SYclgY6sakO0mdcHYrw8+o0Hd3LS0w7JRRhDwL6oR4A+v5R/2R1OGcK2iJ7oW8Yd5jgHli6WOa0s/roWzBkPwoPIN7ci7B4YkIJnaryic9gy/455aDuhaT2+5ZpsuqeYSCVd56kdqekaiNmhhO5jL8n75TXI0V1UC0l+mrNORz8W+Pb4/c0ulRsTVzMsfygKqa0RnHD/3sE4zlNtR/xA/oufpS0u1ltpg3vDeKcH8IvG7oAaEe5SC7blmLLQGaE80rFULvY1BQoqchps6NTkE9IfJB39y5yUFkJyKCXvt+sWS432FF7j3h
 WYvTiu01
 8F9XfkT9pjTc51Jdj1yHnV+qqbXi7mrTYCseEk3GvuKm7mXXG/31AFgb8EgQBrRkywFCZfEPQRV11McQa7qHdeFcjZf8BUE1w1XVtwo5/KBwJVzNwjwzBS0yuLs4W4P7sZP82E+8mlVN9VH14M7jYhKXzG5nNawr0KITCgyf/vAU4TrBiqgP28t5uP61MwvgYM8kPVx4ZsiV6nqaXWTJdMXK+Hj4RZkDIod07iuWgdLsujTps9jAo1m56oBPM2r0J+wdI18aqoSQOp2MO6H9z8TpL8onkZOfI2hINxhVqSLmcS7vDfRABoM9qxBzMICJt5li0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

The number of pages of a given type in a generation is computed by
summing lrugen->nr_pages[gen][type][] over all zones and clamping each
per-zone counter to >= 0, since the counters are updated locklessly and
can transiently go negative. This loop is open-coded in
lruvec_evictable_size() and in the debugfs lru_gen output.

Add lruvec_gen_size() to compute it from a seq, and convert both users.
Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
header, can use it as well.
An upcoming tracepoint and the MGLRU swappiness rework will also use it.

No functional change.

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 18 ++++++------------
 mm/vmscan.h | 16 ++++++++++++++++
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3054175717ab..1581b73aec56 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4207,18 +4207,15 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+		for (seq = min_seq[type]; seq <= max_seq; seq++)
+			total += lruvec_gen_size(lrugen, type, seq);
 	}
 
 	return total;
@@ -5723,20 +5720,17 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		seq = 0;
 
 	for (; seq <= max_seq; seq++) {
-		int type, zone;
+		int type;
 		int gen = lru_gen_from_seq(seq);
 		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			unsigned long size = 0;
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
-			seq_printf(m, " %10lu%c", size, mark);
+			seq_printf(m, " %10lu%c",
+				   lruvec_gen_size(lrugen, type, seq), mark);
 		}
 
 		seq_putc(m, '\n');
diff --git a/mm/vmscan.h b/mm/vmscan.h
index adb22e80d760..c6b583fc7493 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -3,6 +3,7 @@
 #define _MM_VMSCAN_H
 
 #include <linux/gfp_types.h>
+#include <linux/mm_inline.h>
 #include <linux/nodemask.h>
 #include <linux/swap.h>
 #include <linux/types.h>
@@ -115,4 +116,19 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+#ifdef CONFIG_LRU_GEN
+/* The number of pages of @type in the generation @seq, summed over all zones */
+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+					    int type, unsigned long seq)
+{
+	int gen = lru_gen_from_seq(seq);
+	unsigned long size = 0;
+
+	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+	return size;
+}
+#endif /* CONFIG_LRU_GEN */
+
 #endif /* _MM_VMSCAN_H */
-- 
2.34.1


