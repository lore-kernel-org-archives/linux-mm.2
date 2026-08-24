Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2648C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBF16B009B; Mon, 24 Aug 2026 03:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93D96B009D; Mon, 24 Aug 2026 03:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9506B009F; Mon, 24 Aug 2026 03:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA5D86B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:38:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FBF212045B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:57 +0000 (UTC)
X-FDA: 85135361514.01.88A803F
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3E37920002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557135;
	b=FYKlxIH3+wTvYyQS3ED3m1Dr1Q9KvldWRotcQHMApNYvqD+4kpNwvJ3F2T8yhdNv0qqb+T
	q0g5C5rkM+SPW+BxxVxOv9Xd1Zy2LUGmWcIPGd42zS0pExHoOVO/wdChZ4oPI5eYp+opja
	QKhB6tIXzNBf3ABJkKGRvBvFYV31+AY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJak1R3/lkKKw2FaSToCWDL+nXS0R1301oPKvGxK0jE=;
	b=Wf5ueDjmO0hVEsvWnBiWPOxyMjRBwAQy9rv/jED/rK62IDRiEYccEhG2rW2EIAQ6t+xx50
	2r5kgjpMSgLY2sSmYs/kGDGOFU2FOspsNcP634pxcJKM9admP848X+9MXBFgdWPlMqr5y+
	TB0dWmSpBX56YVAAgaa8fsh24YsOFmo=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id eb8ed803028bc018;
	Mon, 24 Aug 2026 07:38:54 +0000
X-Mizu-Trace-ID: eb8ed803028bc018
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 5/9] mm/mglru: add PUD-level Bloom filter state
Date: Mon, 24 Aug 2026 15:38:02 +0800
Message-ID: <20260824073806.629593-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E37920002
X-Stat-Signature: fc5qtzxgo3fqpabbxq5yssueoear55tg
X-HE-Tag: 1787557135-410750
X-HE-Meta: U2FsdGVkX18n3z4ImEH1iLNHRgt6wHujSmk5UsWFQsBxA+D6N9nsivy7TIeJzaHVogyVfk9wFCitq+YVHgCjswm9IMD55o7j31ac5vjG5F2WXkbSNdncDI/KjDOXKQP7FUCaBewAowd5X1G4bfBhvh1/hYmHM2YKqupk9oUYG13ZEsascw5dq9TeMupTO5Bk6lQmotTKzMosvAk1DrVGK+hUH6sd40C4rc7RVZLo0EuYPcq1PyFqZ0ebLjYhwQbZWnCIdi0/WKwkwhncSXx2j3XsBBXmqytrogAOO7ue/UrZp466a6vdoLCTbwBVjl2/jTcK0py75V/+pT1BVhItmU6/PVZ0gTLgjfiK13cK4btDIIkxDgnr7yokmMjNFK3rnkap/zghm+jkd15uzA1cMr6KY5kAwseZStX2pIRPDbOoJOL0j+CjOPSwsBcEORPvstC/IcZZAHDwvh3Z0OyLJYK/HlxbtKnznDoN0xT7zG7vzFU9t9hg+u2imscSr2FPXW691GSi0OuQJpl3VE6Zzy0c2cyouhRQ+a7SJNsCl+i9XxS3/tH7Kb+MR8Xjc/Bun/v3TdXc6NCH0y8oldhQnrXEqMQKDqVldTOsv6vkaRO6PT3ZOuheDcym8GoywsOFqgMN4B2mRpwS4fAhnEmaCWMPyWS9KCIjPoWAdbJ3mZYk9T+sXQEHr4aK5PWfKYSBeoZ0iUBdXG9iDC9WY/CIMSfdlXVWJpwLJyqmLuGzudPqkY1KUlvb6BfrT3rdW/w9svhVs2WhB8zDcHEbMK6qKhb4S96kYSW4K82JX8eVw6FmLKep0K0xjgnBR3Gy4NJWXlFR1IRVPeJihIZSILkIWKsuB961o5lH5q3iZj4WHHTKTr+bEuddKi7q/+9pVlduPA13T+rVBCpzutyZsbngqiGUR0kux/8Q6dgkkyTQJFKeJFKKs9pAL2sx67mn3bT+bFqKSsLMrCgd8suhmsS
 vjgbBWF0
 Y8JQILfui+hPDJupjQ05J2IvAPzqgB0LowOgZzDFNhOqGofXB7yk39XtaIFjcX87X7+04DH/TLQk9ev+a6tBit7FF8XPxm3oeQYlx7p/MVn0ev5YfY2fxDfId8QqfIn/wsAeg2l1P1v0fWjH99XgC/txupb6dSDYYfBges4vtuLU0Hcfeb5A+0iA5IRG78M0JOcx9jd1jYDLO43baQ+eo2tANiSZ7bPQdLGybbRv2QCJ9rf1b4MVlkhI6HghldyiY/lJlnqGV3N9LLQchBBzKBidbviA3kCeVFsDhLItbRxZLsS6TzzdCQhdSQfYM2cW+QS/Cixy7+jz0iJ8HJjO8IIzA+03wlt9ouX6w7DoBDmJQS24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a coarser double-buffered Bloom filters to struct lru_gen_mm_state,
one level up from the PMD-level filters. They operate at 1GB (PUD)
granularity, whose 512 PMDs would all fail the PMD-level filter - a general
suppression of unnecessary page table walks. Cross-node empty walks are the
most visible case: a foreign mm's PUDs have no young entries for this lruvec,
so the entire PMD iteration is pure waste.

No behavior change yet; the filters are populated and used by later
patches.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h |  6 ++++--
 mm/vmscan.c            | 12 ++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 30213a880db0..64eb010624b2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -612,8 +612,10 @@ struct lru_gen_mm_state {
 	struct list_head *head;
 	/* where the last iteration ended before */
 	struct list_head *tail;
-	/* Bloom filters flip after each iteration */
-	unsigned long *filters[NR_BLOOM_FILTERS];
+	/* PMD-level Bloom filters flip after each iteration */
+	unsigned long *pmd_filters[NR_BLOOM_FILTERS];
+	/* PUD-level Bloom filters flip after each iteration */
+	unsigned long *pud_filters[NR_BLOOM_FILTERS];
 	/* the mm stats for debugging */
 	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f592f04fe1bd..912cbf86c7ff 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2849,7 +2849,7 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(mm_state->pmd_filters[gen]);
 	if (!filter)
 		return true;
 
@@ -2865,7 +2865,7 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(mm_state->pmd_filters[gen]);
 	if (!filter)
 		return;
 
@@ -2882,7 +2882,7 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = mm_state->filters[gen];
+	filter = mm_state->pmd_filters[gen];
 	if (filter) {
 		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
 		return;
@@ -2890,7 +2890,7 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->filters[gen], filter);
+	WRITE_ONCE(mm_state->pmd_filters[gen], filter);
 }
 
 /******************************************************************************
@@ -6010,8 +6010,8 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 			continue;
 
 		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
-			bitmap_free(mm_state->filters[i]);
-			mm_state->filters[i] = NULL;
+			bitmap_free(mm_state->pmd_filters[i]);
+			mm_state->pmd_filters[i] = NULL;
 		}
 	}
 }
-- 
2.54.0


