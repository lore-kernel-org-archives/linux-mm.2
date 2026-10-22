Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D07606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WYdStfuA
Received: by kanga.kvack.org (Postfix)
	id 265B66B02D5; Thu, 22 Oct 2026 18:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235D66B02E5; Thu, 22 Oct 2026 18:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CF46B02E6; Thu, 22 Oct 2026 18:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0AF66B02D5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:03:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EB00A6822
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:18 +0000 (UTC)
X-FDA: 85351638876.11.1B50B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E4074000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYdStfuA;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwy1/E7qFCLKO+qrr+CV7aqdVMAe+BNUVLDdmHlEewA=;
	b=U9q2LUvpm7oJCHZqYozqpiZe0tqPY1wVLI7KjrvN+xnlgJZboJQcN0hvguPQmtK5wDKcCk
	ZzB/7nuPdfM9Xf3uydTcHuhci5SUv3gDbThhMI4zjSMQOckZNORMK9c+qmjz4TEdPcfldr
	OP8B63r5J00tHI6A1HX6u/cnQONA6js=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706596;
	b=c6rpAyCQ+v2GFLbfLmSbrXconOCk/mx8NoM+VycH6qvecU3KjDkOK6qijnTFyju3fr12uV
	CTHDAjvuYQM9xGx39mxHBOQA/JkUSi9BWoT07DtvQe2opLQgfIHAlNgYB1It8QvZTSxwvA
	AdRFw6IKuZmeIroYz1QobLGZJdD7EbY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYdStfuA;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF734144A;
	Thu, 22 Oct 2026 22:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2D71F01828;
	Thu, 22 Oct 2026 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706595;
	bh=mwy1/E7qFCLKO+qrr+CV7aqdVMAe+BNUVLDdmHlEewA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYdStfuAzdas6WBe5uBBKWpJR4w4OwoOyIHE03T6K2D+0UL3VE/1qyXYWTq4oTkJx
	 tHGHpk91MWgG7keIE2/b73rNOYpnd8Uf6paFe4Bt3qlPm6WKiaxl2HFrTiJ8m5dlu+
	 EY/AZcR7Jvt4Vj9JtNmyZBRwHD5qF3YsCVWQ1BC+G7WWQYIJBI5o8XaSqLercQuRI7
	 wL3A8N7H9yqL0rbcRkAa2V8hKRJqgIGk9cTBCw2JvHt2xb/BDHAJDejAFPi4moObXt
	 wSg/e/kiLgC7joTy4KRUAKz3cF0kN2UKDHSWGJah4gjRaeClYJNyxmHjJu397yXJOJ
	 +BHErol9aUr2Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 12/14] mm/mglru: Avoid prolonged anon reclaim with swappiness=200
Date: Fri, 23 Oct 2026 06:02:01 +0800
Message-Id: <20261022220203.91911-13-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E4074000D
X-Stat-Signature: urt68eawwxwsf1faa81keu8rgwsg5bpp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792706596-746895
X-HE-Meta: U2FsdGVkX186VptkoyPRWBGSlt6rpeS4xxlaobghEdq42rx7nPhokVC8PlHiqk4mXVoFbyRbSdDIX0UU7RVNT4eonRHJoTYFyk9Zc3MqO+vo3xUnnjBZKMN3jXKB/CdLbmBnGY8tRXE2lOsHdSiCZlvDG8lfFqXguJTRT5K5rNiwOUiqa3K6UKICLwmauzRLaJd0W7ESoYkWlkDVIQeUr4WCKgywhixHFcSSScxWKtUwIG8COAXHnxwT9j4oFrAJBwrjAACoRO6x6wOHpQb8ElP0cjxX6pzAd/IWTINtYRwonAeFcZals7kuiL373DHx2SrJUWQCOsTfY5shJZBR0jzncY686BETV3YhKJjQ/P/pB+NqZoCZ+0WHy1u0/fg6WZE/n72na1CilHv4mDTgV7QAWB9A7rrOcGju3v4zeGjAFlvazXxvm2Op5JZQubb4oiGCWZ5i4/nKz1UVVQLhN1q1xd+J6AAkdQeLDAjOJsURSVd+8wt3qEPGZxUKyTvdkmQUpZ88S9NVxPomUThV05ny2C5krLDaN+Md8xkEY5mUAKjm5mv0POdeR6zn7e99oWodEbnTD4dFS+SeAulH6ZJwGQZ7pFzAt2NQONgpF4aq20XlnrZ3o2OsKG/0t1nJeK4f3soxmP9yBIGqESjjl6Ct0/Qc33qqm2I42kpiG8R6TdIWCh5FpcoISqVD52NtjaY2eIrqwuZncTtgd6hbm8Z/hXYvINgmGE2BcCAR3JxeKoNYoXBZRCf0nktU6NT3n77o1kSGGQfNRBEHXqa3sI+Tfa8d1re1XQh8/raD1u2oSgq1n8rML6XCAerDis6CoifbDmpFIsmku5aWJGFoqlRD7wXsj8Rd1QlSC0+t8e2AssoJpgT4Usu49r/ywtPbOvknsrMcZkd6WtJlaoSP+7Yf18KTmrvell9w3G4C3OMQpHim6nRwOORX/A1KRowasKciIXpOxvmpW8gGyiX
 LOI/TV3d
 j5930JgqdsDj42wJHng/OV1QsPTl/aJtavIVHyOU8jaYNEVQWLIHwEDY/oTNCkt9JKMdb9ml+tgjh7fJL/NQ1vLkhYMDWP5zdp6YPmMaDSgOCj9iNvO/20Cf30T7rC0wfQBSQDhL29GTCS8SlJWATnUU85Ftth+V9KJ/UZ962sQPgSIVHw7lN/uiuyZ+BbCXvIzp4dOb8OTfNluBLfxDx2F1kQzJK3djRd5HhrQRd0/eoAJmSxrwuzw6NpYmFR4N8b+UrSx+5Udwi8GXyml1rax90jhttipwx9UWUIMiMQpKMyr9kLGTqBAlaqggavGfkJ2ccFo/tSM5bvyNOVn1YfBEdAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: lyugaofei <lyugaofei@xiaomi.com>

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 555359cc0368..81e81d69e67e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5056,8 +5056,8 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
  * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
  * cancel the scan budget natually.
  */
-static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
-		unsigned long total_scan, unsigned long nr[])
+static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness, unsigned long total_scan, unsigned long nr[])
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
@@ -5114,7 +5114,12 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
-	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+	if (swappiness == MAX_SWAPPINESS)
+		file_factor = sc->priority < DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
+	else
+		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
+			      refault_rate[LRU_GEN_ANON] * file_weight;
 
 	/* Cross-multiply the ratio above. */
 	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
@@ -5305,7 +5310,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -6050,7 +6055,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 			return 0;
 
 		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
-- 
2.34.1


