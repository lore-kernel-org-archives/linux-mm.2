Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69975C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589AD6B00D2; Wed, 29 Jul 2026 10:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561666B0100; Wed, 29 Jul 2026 10:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477426B0101; Wed, 29 Jul 2026 10:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 268986B00D2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:37:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77FFE120622
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:42:45 +0000 (UTC)
X-FDA: 85041173490.09.44D9EFE
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC25480006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:42:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rBmD9rK6;
	spf=pass (imf30.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785314563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lW7K1TshKRQwVpxSydSGxpku6XFVIjRdVdgKlx/RWlw=;
	b=ai/lMa2v6CqjOq3hGUFUO5lCsukfaYt0uliHs3xuD3x8xOvmXQjvGveb3sSFmZujxoqsAd
	E/8DCxC8T+GmLim2chT+kftd95isFFzxVnoVQShzdDq8WLhU1/BX5846o18srjMLkyF1lf
	2rRK3JSLKf1K6sSIieFdDtX1bCdbjw4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785314563;
	b=AeooxCiVmzOVvbnZwRZOaSsaINkW3dAaDtTfw/VEX2sYDXK0ICtJ0HXD4zC0yEX0/SJWap
	CAqexqh9Cp9MCi4jUnXwOCOI5T58jZU8nn/LzzAJTbtCF4pv3AOcOC7pN6YerKVkS8a81Z
	hex0lVX4fsTtYNKjVRNTeSg4UPNuhwY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rBmD9rK6;
	spf=pass (imf30.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so550845a91.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785314562; x=1785919362; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lW7K1TshKRQwVpxSydSGxpku6XFVIjRdVdgKlx/RWlw=;
        b=rBmD9rK6NllqDyUQC1B/xAdY2nLmHNgms67icm++vo2QjJ31o/Qi2AeJTgrJWvwchK
         RfKgXF3Nal5ofwjUwsqQBKYGFWqiV6ims4UIsqjlEGQNpBoZKApODAyMasL7eeoiNk+N
         JcxP9QWXMICNAcp2amJSuC79I71JhoH8E+6CC5YVlI38qc5NkQwi9uzqwudLtfToIV4T
         vQ4CpU0FDIOjndItxCOjJtP0VyztM2zIWZUQs5JAeWGaufUAQPkfOh8X582oifqvVWBh
         V6eY2GYduZJ9uOwIZT2AHxbBfbDX9tKxQDGaVL+x/9D0/cYV8rx8hxIHBPylIvOQERyM
         FuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314562; x=1785919362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lW7K1TshKRQwVpxSydSGxpku6XFVIjRdVdgKlx/RWlw=;
        b=ExRf6YIYIoAVEB9GN/Hqp5SwHlCZuzWKaWfPkCf25KZ1PRPIwfc7/LUl01zMyVUK2d
         Nhv0Bs4SEjwPuRiAMbRSzZhu4DbWukoRsx04shJyKHY3+wTeVspYP4Ljl/o9twqG8UdQ
         1QFcS9PRR1vIHbiotLJ/f+YZtftPKXg48fJV0mbpMhvS6a6UfcwTJssJgOogmbWsmH0W
         OKp7gJg2m9YthyweccV4+n4NT9jFvv0ZZ++9cNWUIgasqVYQV6VLQRaBAIl8y0YVycRE
         PvAYDFoPbSZ4la0UCxbZGxZ+mprrSyL2ik/42copnwdnqdZ0+B06SNhKW1jFNNKtH3Xm
         xttw==
X-Gm-Message-State: AOJu0YznodviXqQRoTcu4Imm1AIns8lDOJik+gOAKB0DeAZ6br04jvnD
	ObhDAtyAvaoNq8MBfTFPwUiAn/DJe/fLgI8/BMiK8ZPGCD7t9pDFYxEK
X-Gm-Gg: AR+sD132Po48MVRL5iutWQh3d+vUczCW/8a6iUzrgIZcCTibelh35e7S9boP3P/Rb2o
	2j+TF3fyJ5BbzgyqEYsHmRXJUxglZKRQxpmPwkmWCsIBoEcT9GGAmpsHZWhTpgFRUDRRQHIXDGH
	fnw2Wx4lijwm6c2TXfYdxXrtnOxSltzc3pHn2Wv2fnun8aOg6qc58eIw1xO5oG53r/gX5hEb8Hf
	WdaBdyo5Z89LAeDy+zZ/0u3P/ck+I6RRvDxurnsHKOWbSX6Nl8qADvhQn0efYUF5yMnhzy1ikii
	WfozKFiwE2a3hzP3PwnAAXpE/g7BSntQGMBZF+7QXH5geLlQIqy3xXU6Sl7lskghM2X+Y1dvNdW
	R6q//zWYSUkUApzFVrqaSdP70RxBqOiatPlUrPRAlpWMpbNAjIpliraSuP56mCh7gPIwJNucJZm
	haB4qgPgR0Y4O73BYpnIb11/EP5BSskjF9LWivHlR+ddG8dVxiUaJ1CxM8mtrWOXNcCmECmLnP4
	nMfssSAXIibsKzhyq5YrVICU4eF
X-Received: by 2002:a17:90b:2e46:b0:38e:679f:3b3b with SMTP id 98e67ed59e1d1-38f6a57d6e5mr6107033a91.29.1785314562465;
        Wed, 29 Jul 2026 01:42:42 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f642fbf74sm2447744a91.17.2026.07.29.01.42.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 01:42:42 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v3 2/2] mm/zswap: Support batch writeback in shrink_memcg()
Date: Wed, 29 Jul 2026 16:42:06 +0800
Message-Id: <20260729084206.77793-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260729084206.77793-1-jiahao.kernel@gmail.com>
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC25480006
X-Stat-Signature: 8dk6bhux95akon6rm4wwcc1io7zyjzwt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785314563-884815
X-HE-Meta: U2FsdGVkX1/zMXCJFqU1t0oPtkqXz882YIa0Q2qDVXfJYZn+kDrjo+hXLjVgJmNhC1p0txqtlLNOcWiZTuNXkZwUZPFxr76vR2/4vRjRRpUx1yWDrqCWwNp4QqhPJQHcmIbq3ywexvS3DmzNSWomEvVwTJIcZOdjcD3PQX+70IFb5AxJNjXFUUPC8q4ZU5hGGcvFE9G1ZS3nShDdo+PaIDDGGadoPwp4Kvk0dsGGJLKh0CtVqmUb4o/yfps5lA4rAsfBCfh9Rfwm8HabJwlFiTTDKzYpbsHUC4bNexVeYL1O0uRYRU5IhEIvy32hCsIdbKHBnSrsApQzfNBcb1EWOZlVYRoHxC7IxbJVyyau1gGGnlXw6uL48AA0DisjP1nCVbQ3CUsYNwgXEZsngAsIKBlvA1Bae5uLxb70UXZmq6c8ujmuakNcG7BT3Bw/8DrVVPdMm5qjRmse6M0hVpcnC9Q6y0glgrWKveQZN1l3A2kXHNZfBflI6rnfOEk55QOmq+88RrxWCyH4TvNj9HU61ypv6cpsWbiTijGN6f4TjvRsrSE21xNVVBPAaySu/rPB9o5bKJFO5vTOtF1mTTQ0e8MnC+J6RRXARL/gEpCW5nmcKpc/ahSc68DkJOSOyqRvTPSscHmFg5h6g9P/ITY7q9iC2Fe7tIWYvn2nGSUDuAWyvlEzCs1d80vW2vuX/AWwipFydZNp2TfIW8BKxP+vCSJtpEz0T7oqcsGWMZxodI7kWn6zcbin6JKbXGN0GVPKtd+xoYbQcjGTsqPtRnXeNBdCQb4diuZao0Hs8AxpnNQG+3jAtntdh8aZHtqHvz/3jrQv5k39uzkaK86jZn9uDEbHCy8ub39619mSJ3MPMllqxpkBzwoPOjyhseBUv+urNCrFXCTAB79HOQEQxaXf9U3RjSqFwidXwk+fb3Djl3OWkH4UPaCeiHiVjw2QPSOmIBfVyeMSfwAfWrydQtX
 rehP/txE
 Aq6MTxEaL27FdVqpqdqNxzWgnfIikw1TUEOAzLN2215be3e77MHF4Lkq3ejepRyP1HlUpK7SSWZr+tmKm7yF9JJ1CfoOHs/Qhbx/x1Uj65bBogSJBJu9Ck0xNS+Xqd1Qtq0J4jZoa14WgHCmwOuM0Z18lo93xJiGhJ9tLO4vZILMT0m/PVXkMnDanP+0KyAfdMcecS6DakbPBwqtiqz9K741gM0RbhuRA/4CGa3oCkeIBjoA/OGUYF3ztVCQUE43XbY0adbRwrdPEfPLcDsbNS0rME+1agozVjAuRG7YZsAfqngHJArhbBm1KHCfmXbATyv95V+acFHZ5VoRTQMsEUjSHTfJI5I0IRQvxAyIeSdduJG1lJ4+T2MVeCOXwGfmtpobi4YP2dVZCxs5nqASP+FUBEyrOrx1DjZclvO/qB0xjOeSOHGqd1aMfYLScV6eLpuOslo1j3nuG6LvMwmTMTXCBFL/qyMjXiQlMwRhiq9T/4WLnUiBVYgSd+/u7+1cjJC+FuTxvJcBayXkwESAKMFJF0AII/yydvVn8wWCRouWXjnfVPA7RhGTEMnBohQ4huoZJg/FnbkxLPCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Currently, shrink_memcg() writes back at most one entry per-node during
its traversal. This makes shrink_worker() inefficient, as it must
repeatedly re-enter shrink_memcg() to make any substantial progress.
Under high memory pressure, this can cause the writeback speed to be
too slow to keep up with refaults, leading to zswap store failures and
forcing pages to skip zswap and go directly to disk, which results in
an LRU inversion.

To address this, extend shrink_memcg() and rewrite its LRU iteration logic
to support batch writeback. Introduce the nr_to_scan parameter to bound how
many pages are scanned per call. This enables setting the writeback batch
size to SWAP_CLUSTER_MAX for both the shrink_worker() and zswap_store() paths.

Test Setup:
- Total memory: 32 GB.
- zswap settings: accept_threshold_percent=50, shrinker_enabled=N.

Test Case 1:
Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
with random data (to avoid compression). Then, use cgroup memory.reclaim
to force a large amount of anonymous pages into zswap. At an interval of
2ms, allocate a 4K anonymous page where the first 4 bytes are random numbers
and the rest are zeros, and then trigger reclamation of this 4K page through
cgroup memory.reclaim. When the pool threshold is reached, shrink_memcg()
will be triggered.
The test data after running for 120s is as follows:
                                Baseline      Patched
shrink_worker wakeups              5,363          169
shrink_memcg calls            11,373,201      350,703
written_back pages                40,212       40,241
zswap_store calls                161,190      163,753
   store succeeded (ret=1)       102,743      117,183
   store rejected (ret=0)         58,447       46,570
   store reject rate                ~36%        ~28%
pool_limit_hit delta              55,826       33,760
pswpout                           98,659       86,811
pswpin                                 2            0

Test Case 2:
We evaluated the following two sub-configurations using stress-ng inside
a cgroup capped at memory.max=1G for 120 seconds:
  Test Case 2a (max_pool_percent=1): Continuously triggers the global
  zswap pool limit, thereby waking up shrink_worker() to perform asynchronous
  shrinking.
  Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously triggers
  the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
Command executed for both setups:
   bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
   exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
120s -q'

Test Case 2a (max_pool_percent=1):
                                Baseline       Patched
shrink_worker wakeups              5,640         1,308
shrink_memcg calls             8,481,500     3,140,972
written_back pages                   260       468,216
zswap_store calls              2,742,756     2,011,269
   store succeeded (ret=1)       934,640       947,988
   store rejected (ret=0)      1,808,116     1,063,281
   store reject rate                ~66%          ~52%
pool_limit_hit delta           1,181,310       196,882
pswpout                        1,808,376     1,531,497
pswpin                         4,288,497     3,635,365
Test Case 2b (zswap.max=320M, max_pool_percent=50):
                                Baseline       Patched
shrink_worker wakeups                 0              0
shrink_memcg calls              687,608         54,002
written_back pages              639,176        846,663
zswap_store calls             1,224,222      1,228,548
   store succeeded (ret=1)      992,816      1,208,123
   store rejected (ret=0)       231,431         20,425
   store reject rate               ~19%            ~2%
pool_limit_hit delta                  0              0
pswpout                         870,745        867,360
pswpin                        1,707,823      1,216,814

Under identical workloads and runtimes, batched zswap shrinking
exhibits a significant reduction in both shrink_worker() wakeups
and shrink_memcg() calls. Furthermore, the sharp drop in both pswpin
and zswap_store() rejections demonstrates that batching zswap shrink
operations effectively mitigates zswap_store() failures caused by
hitting the pool limit. This significantly prevents pages from bypassing
zswap and falling back directly to disk, thereby reducing LRU inversion.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 48fc7b575e24..82dddfe74ef7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1275,9 +1275,25 @@ static struct shrinker *zswap_alloc_shrinker(void)
 	return shrinker;
 }
 
-static int shrink_memcg(struct mem_cgroup *memcg)
+/*
+ * Scan up to @nr_to_scan pages across the per-node zswap LRUs of @memcg
+ * and write back the reclaimable ones.
+ *
+ * Since the second-chance algorithm rotates referenced entries to the
+ * LRU tail, the per-node scan is capped at the current LRU length so
+ * each entry is scanned at most once per call. It is up to the caller
+ * to handle retries, deciding whether to scan another memcg to complete
+ * the full iteration, or to rescan the current memcg to drain its zswap
+ * entries.
+ *
+ * Return: 0 if at least one entry was written back, -EAGAIN if entries
+ * were scanned but none could be written back, or -ENOENT if @memcg has
+ * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ */
+static int shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
 {
-	int nid, shrunk = 0, scanned = 0;
+	unsigned long nr_remaining = nr_to_scan;
+	int nid, shrunk = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
@@ -1290,14 +1306,29 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		unsigned long nr_to_walk = 1;
+		unsigned long nr_to_walk;
+
+		/*
+		 * Cap the scan at per-node LRU length so each entry is scanned
+		 * at most once per call.
+		 */
+		nr_to_walk = min(nr_remaining,
+				 list_lru_count_one(&zswap_list_lru, nid, memcg));
+		if (!nr_to_walk)
+			continue;
 
+		nr_remaining -= nr_to_walk;
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
-		scanned += 1 - nr_to_walk;
+		/* Return the unused share of the budget to the pool. */
+		nr_remaining += nr_to_walk;
+
+		if (!nr_remaining)
+			break;
 	}
 
-	if (!scanned)
+	/* Nothing was scanned: every LRU under @memcg was empty. */
+	if (nr_remaining == nr_to_scan)
 		return -ENOENT;
 
 	return shrunk ? 0 : -EAGAIN;
@@ -1369,7 +1400,7 @@ static void shrink_worker(struct work_struct *w)
 			goto resched;
 		}
 
-		ret = shrink_memcg(memcg);
+		ret = shrink_memcg(memcg, SWAP_CLUSTER_MAX);
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
@@ -1493,7 +1524,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg)) {
+		if (shrink_memcg(memcg, SWAP_CLUSTER_MAX)) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
-- 
2.34.1


