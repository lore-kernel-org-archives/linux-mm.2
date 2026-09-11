Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8311C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C0D6B0093; Fri, 11 Sep 2026 06:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A266B0095; Fri, 11 Sep 2026 06:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57E56B0096; Fri, 11 Sep 2026 06:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B67AF6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:30:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F98F8017C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:31 +0000 (UTC)
X-FDA: 85201112262.24.B27388D
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8FE310000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aef1eTjV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789122629;
	b=ASsb4Gw3BvhBC9YB42II6rXJ3X4Myz4OwRAP8M/1ORgvfoMtGnkmeTpE4ZFcmQmYwk/UK5
	a1PBTr9gzEM/Bl3e+Vw7oD/vMpsXavs0vvYCl3pZ83hE2pEF67hN8KJ+tzyMZN1bEBfGVH
	WDEIQG9WL8O84oAQI24vf6almzL2mdo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aef1eTjV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789122629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xf5cO8i1fvbMjYR041dxQ4K7REFcZow2QMXWDWsaMY=;
	b=XH0H2qrrHu3FLEF/13bHOepXbTlMQEpiVCWXZQmEOoubNb4nXy/bussc2TX+5eHK7tvQew
	9zuCSTrdjt/+QtZ3DeAML0zMJi65qWskT/WNf+SdbZxz6aiovkiADN1gyPmfrTff2t/BIP
	uvads8BMsisJ7cm8YWhjjh13OVdK45s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g5xNOknu84CKDZN5IQmWT85FT3qL1QmesKNb79arhdM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789122627; v=1; x=1789727427;
 b=Aef1eTjVrm46A0vgLyFjNEkDfapE3r9tTcoesUBPRE4ALnx1byFWfxRUlT0Z7idyD0MRGNlu
 VBW/7RXTMySamhx9fqttL+wN2l8lZdOMxMIn7j+shOWWoAIZVgu1Pmp1eAzfHuznCyr/sVpuBi4
 wrr0I1CRlX663oDU+kaSWWbI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f4fa41675c0fe4c3;
	Fri, 11 Sep 2026 10:30:04 +0000
X-Mizu-Trace-ID: f4fa41675c0fe4c3
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
Subject: [PATCH v2 1/3] mm/mglru: factor out lru_gen_seq_nr_pages()
Date: Fri, 11 Sep 2026 18:29:37 +0800
Message-Id: <20260911102939.2485750-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911102939.2485750-1-ridong.chen@linux.dev>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8FE310000C
X-Stat-Signature: tj6dppfzmqqi1uwes8ic4eyq3q6sebzz
X-HE-Tag: 1789122628-954269
X-HE-Meta: U2FsdGVkX196MYiRXxjUTnZF4HYrQctgR2kMZHLb8KjylkF2Rm1AQCkTvedPc7fSQSrDpXIlOND9PYDhl/BRaf2HMRL1vwS384vnWXpGx+i85GvcKhXqYYE5qrFdpFAE97/rC0xnzFJm273Mo4yAOmOcwWfW4nxEqIFV+oFng7YNKFWulxMCvmm7FiHUxt4pfm+BKbb440JnKC/7YE1LGioXMS0jg9neeOsk7DKR+go7qHP3jSDx7l5BWU31VYnj/UB50dnCN2H1JrquAl2U9TCx6zh2yNJzJt6VdowTnxOOby4D+2XhNLuAmpHNElkny7bOq4h0QpRZ+tzPMK3QNImMoMh/BvQWQxufNxCDgH1p4Qqt+yL34LtVtFXvh+GQwCrCMvvVlmuVfZhO01KRIxpEiElGpPSz8thfhYyvZX5eypiiu/d91fZEokA6+SZK4MDnrpi9FVaS2/OdaWLDwkWT7f62pxqLN3bn+82S3wbaIdaIj32nMOKSr3ER9oGzwaLK9TmZFeW+tnxg30rWvvw7T8+1oaHTymFyE49zj3cALv4NHy+ZnOCsfR1rzfnomsUosKxVPCcgBJVFOLJm5K6UjI9jufTAiGTmYWNfLFQuTcOcyiAz2EUuhMU5tDXnm39AxCyPKbIKd7wRicLVEHKAx8N5nadn6xQ04iWM7h/pCiU9vugf3z/B9fSBn3E5rFYtXHT4Zf+syF4tq+q4XnkfOL7xAL92V0aLmZEEKmU82cQT2PRUWp27gI3hf9bO5UVccnxOOB1TaBCV7WDSxY3zB0iWqTLZjlm4j9xCzRhCd9uVP/pGFsHeL+6BEavGHxSc19Y5uNTiYE5d7OCffgwxX25P5jRHIXKgdbect5xWzDlu1BJ3q972K0zb5/LfXcZUWnfYtgYjTBJ8nL5AZ6u6tWcPMU6Z4yiNtflf+5p4BiygluPSpaWo4yuX2KaohzvspaqheN32XnBNzNW
 /BNNkb7O
 MxkjvQTz9RYP+V/AE47ZNCV5z7sw6ses0RJeMHKZ8QSEl2niOXY5S0A6DZyMwddV6tv+wPk2r4HcWrqG/fdhEirm09DSpUc4IlF+mBvQy2Az4tlnZ7LYjEZIWgqlhoBsH9NDNN83zhhtaI0a6IHpVU0F0o3I/+pBlM75zOp4o98acCZ49LPyvsXOsdlpy8tAlgR68khnIP2WwGBXgG4LmYf/ec/lRwrvl8qNvxXjt6hanmwnTGe+BdPgk1/sLrRjr+aIY4dtJiYT2xaT6IsMdTZfUW4lzSfguCvEEOOZsytSsxqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Both lruvec_evictable_size() and the debugfs lru_gen_seq_show() compute
the number of pages in a generation the same way: sum lrugen->nr_pages
over all zones for a given (gen, type) and clamp each term to >= 0.

Factor that out into lru_gen_seq_nr_pages() so the open-coded zone loop
lives in one place. No functional change.

A follow-up patch adds a tracepoint that needs the same per-generation
page count, and will reuse this helper instead of open-coding it again.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 40d3f1b48a74..2554a6513aa8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2813,6 +2813,18 @@ static int get_nr_gens(struct lruvec *lruvec, int type)
 	return lruvec->lrugen.max_seq - lruvec->lrugen.min_seq[type] + 1;
 }
 
+/* the number of pages in a generation, summed over zones and clamped to >= 0 */
+static unsigned long lru_gen_seq_nr_pages(struct lru_gen_folio *lrugen, int gen, int type)
+{
+	int zone;
+	unsigned long size = 0;
+
+	for (zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+	return size;
+}
+
 static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
 {
 	int type;
@@ -4239,7 +4251,7 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int gen, type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
@@ -4248,8 +4260,7 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+			total += lru_gen_seq_nr_pages(lrugen, gen, type);
 		}
 	}
 
@@ -5738,19 +5749,16 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		seq = 0;
 
 	for (; seq <= max_seq; seq++) {
-		int type, zone;
+		int type;
 		int gen = lru_gen_from_seq(seq);
 		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			unsigned long size = 0;
+			unsigned long size = lru_gen_seq_nr_pages(lrugen, gen, type);
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
 			seq_printf(m, " %10lu%c", size, mark);
 		}
 
-- 
2.34.1


