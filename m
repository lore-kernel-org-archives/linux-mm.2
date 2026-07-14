Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68006C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6860D6B0093; Tue, 14 Jul 2026 04:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636AE6B0095; Tue, 14 Jul 2026 04:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CF56B0096; Tue, 14 Jul 2026 04:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0506B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:15:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99F921C022D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:57 +0000 (UTC)
X-FDA: 84986673954.20.2E473D1
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id D7CE240007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l8ay7+oz;
	spf=pass (imf12.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784016955;
	b=WFV9I9IALrEyv+7iMo9GAb49q5IDdJXTgwERlHkjJQMpweSHR45uHZ+Asj/OJKurs/S0uA
	+BbPvBO7CdQT/EFOtLbYon5jrX8d+5f65IwEdmzquQIdXKlgMO3UZnFBT66peUR2OVPLLH
	toXsbjmXAxw5U9oXdpFXIqoRbkstZ7w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l8ay7+oz;
	spf=pass (imf12.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784016955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UXPYiyfSEkWVl+cC8sK2nhliwJgX/ylc+YW6RL4x9c=;
	b=eZpVOWPKdKUHre82KFhE6mExa1xFYEld1pyN3x9cqhZYhq6i+/LHJvN2NMlzOuRKSsDgJV
	nk0ZUcoLKbcQb3qp10i1/xTLoQhGGwcIuEY8FdgU6Rpc5sGPLan1wXkwSvbXlilfexUlea
	RAxfNeJqYj4R1NJOWkxRvK3edcYhOv0=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dcbade417so2403165a91.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784016955; x=1784621755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8UXPYiyfSEkWVl+cC8sK2nhliwJgX/ylc+YW6RL4x9c=;
        b=l8ay7+oz8Vj0eMZVfyUys5zQF4zWsPD3d0rUyOPiROkbMOYDno+uhkLhM2YApST4Nc
         98FNSrCoZ6p1kkDB+HP6jA0+zA+29CSjJv5WgZ83YEZH86NJMenSC40sruWZB/AeyVFm
         hDgt3SNI0cFM1ICyQk0C7FF+wCenOegRkmTqrKVoavg9r61nPAGi30OFV4Y+RHgNEAhC
         Zv/8JBgFiHlEj8jT4q7gvrl0oEb3ptgDS5RKbz36x+nGdU9XpFcBywiCttdCQDSjUWhZ
         n992Bp0YW4XV5LCcxyF/buv2eJrHNCGViAnDzoYEmtew4pTbvvbDHigvjWe9xhluphEW
         OJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784016955; x=1784621755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8UXPYiyfSEkWVl+cC8sK2nhliwJgX/ylc+YW6RL4x9c=;
        b=Ho0R6qanYhorGtRh6ViCFKZ0nUfpnBkOxFO16u6DIaRJAvGuZVzTl44N/XdywDq/8v
         rF7WjdXv7IMnqFS6tTiou+siXanIbO/oB3PvAzkCKZhoC96ivQoqqwWMVD0sjvPaFN+4
         cFsnGouN3HsWj5JntFEXN3OIno+PbeXbe6DF0IWpcM9w4Lc1CSoHvFbeh6RBJOFDoJH0
         ECTVW30Y1fGWOm0BTQTpgp0iYkUV7mEZCNq12qVfrD/Jy7MSE4zMkIqJIiNir5zJ3XFM
         oJJo/eNqTx2Lh94ydgwMI4ntIM2+shABxn6hetpIETR4aAcdnVnWPfQMHeI5y4hj7K7O
         JFDg==
X-Gm-Message-State: AOJu0YzhyBd7o6Z+3Hlu/Lccc5LVPuqO0Tkz76zTSFBGzFfps+Y1XkjL
	GUHCmyuwZxOtkUZwcniAcp2G/qy8FpoQk/FxihCCxmWapVXM666CBf7Z
X-Gm-Gg: AfdE7cnMvSEsT1warLP8ABBsfCmc4YT3mXiqF6cBA0zCfGd9i2ankYpjIw5MEHk/15a
	mE+r4/6fWiLAe1ogiEG8o29CdzaDQOuHCY2UuMfNjNpCu25AzKXe3tibB3IGYNPfhFZedDa9wpt
	OEHxJbEKhxVJoqv8qDEDcI64ufOdkVZffmOBHoUwUcv5EifKHofXOt1uONVs4SWVCD+vr/QOnjH
	vu73OXEfmMz7WmvtE/w8uEomjg+w2pig0ezptbgnS0YqqiXwhQAECNuErM5Kt4dl5QkOBbhgq/g
	B+NE9m0rnP32FSKQ5ZtKFid55RWRM4w7HskhcLd6TdZFtMtrJGAPHSttBe5FiX7U4MEtieYv8C7
	OhJjUWrwV1K1llrbLpTWTN4FB2U8B4Eto7nGFbI4McrFL+f06P90wSPkogzsJbqzIUNykRSSVbt
	883F66NGhLTVXiUSONtJay2Dc7b8GYhFRlayH20f6v
X-Received: by 2002:a17:90b:28c4:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-38e17db7bd5mr2555852a91.10.1784016954644;
        Tue, 14 Jul 2026 01:15:54 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e17443f4fsm1091008a91.11.2026.07.14.01.15.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Jul 2026 01:15:54 -0700 (PDT)
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
Subject: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
Date: Tue, 14 Jul 2026 16:15:10 +0800
Message-Id: <20260714081510.16895-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260714081510.16895-1-jiahao.kernel@gmail.com>
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7CE240007
X-Stat-Signature: 3uckmmaiuu43o33dhtm6h4khrn3ohaot
X-HE-Tag: 1784016955-353286
X-HE-Meta: U2FsdGVkX1/xpVXQYEk36R0gfUG/c5ZZvr1Z01XxKVyNzwf501Verh5+xv/nxlTA1RFsbgrswlNm758EZAhTGamorzTZa/eZntW9arJBCTu33VGLTnsRYI1omqvJuwdIUH/7Arunv3MtzoCD4aX1F/wPmh+zlH66tT2E1wOQPcFch5jo0fwNu8MVthrjgtdUbVvBsDvYxpLZp8pPeE4LYYlK/Lij/Dfn05Ug73y4kDQRPRFHrlGhHseFkbsyNM8YfYbDqFsI+1/y6fVxQrMSj5VweQihX2SmnICJI8nUeWp3stZDpPQ38ngBGI192i1TOGpdZBIPGyNy/edahPqNMYTy9ZUMPGxgOvvBwhUXxuTWphdCuDX8cU24Xqa0/6/NtsMw47Z5srAvXdnWb8Sw1NBu8Y+cbT5dmwFI8PlvX2JpnM5AE4ZVk5I7x8k7N9dFnbnI/sm1cz/GirCI7RvjLnLE/JAWLdDJ6AdXYq71UAgC7yLhVXvoUtMxfIT4kt8WPh+tUfWQAs7Gndg/zFe+hrAO/ub1xkF/N11XUToHNlg4MqcRmcesZ7ily5gCkOdaA/HB59hwEwiLP8wuWqpBz7TfbNxPlm1Bx0oOuutaXXmSoez5akn+GqFHtoSNQMpyUIBno4/wm1ZhikPp34+1xKt9I2VXCOvnT1SqAdjVLI7aLweFc8WE/qrAGJxS0VkA7IfmmvPlxq8TW0HV5Ghq9PL39PJwo5pPlAfKAV4obHqP9DvPnsMK4ShFRMTmZDzHrDzt9BIz1m/wGF9C40m62o42C4sG+BHw0B5UABVJwnl+gRuypfQzUF9yJ2o59Eki1r5/sCyPkSq9EqNSkeWsjFWGBZJpsUnNtyF0K36AjZov7e8xmYgyjc8IXNQZgeXpyVNTxwzY8AJMZ46ficIR2n/s8LXGRaasEX/4FYWGNBahqoPdwleX8BBiHp/X6HsYTth1GogLF6VWZAEyPQI
 KfsE7K3Q
 23Bg8tZnSK99YhltSjy8F02gKlAihqmyyO+b8PJm2SRVRKBOE1bO98Ygj5VXL5veNNqWpvWB9wwkwYO/vdQhcF+N1CDQR4YNWASxNMfN6zLqb18wjSxki3rAidPmUn4IawE6yHwmWjrCYFYVU835pJsn5n/IzqA63rvgBak9K0rgbDXT0jjyLHfC98Hx4TggkiY+lzwNg4XteznvjdXsdhSf6pAN6WVszr5FYpRcmFzbEUajr2Bt7yDIs03vvVuWo4nlTnRah08Hy2Q8G47Ph/eJ8heAWek/ZfUKwS6iXrew6mzfNPdiIGkyWpsaFoLGN/27LjPzlnwhW08yi37RR/FCKla2K7tZoqTJfoCsGHnKXWiBTzwPGNUSooNV8vOuAKpZEMMADVFZEJ2JlmyCDj/vq01tRAAsSg6w5ke7Wyz2PUUVAUPB1CQYm1OZXyQWqfI6Ga8BfHnlwkJckHCKKHqYsqzDeGRMJPcUjnOmFJkdzKixMVrubI53d2z7Y9/Gjo17jBHPk9Mcvat47rY7hHYwiG/NQ8Zi3hSPSieA1Sd5szKTADOJxXHLc+Q==
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

To address this, extend shrink_memcg() and rewrite its LRU iteration logic
to support batch writeback. Introduce the nr_to_scan parameter to bound how
many pages are scanned per call. This enables batch writeback in the
shrink_worker() path, while maintaining a low scan budget in the
zswap_store() path.

Additionally, to prepare for future proactive writeback, update the return
value semantics of shrink_memcg(): a positive value now represents the
actual number of compressed bytes written back, 0 indicates that candidates
existed but no writeback succeeded, and a negative value represents an
error code.

Test Setup:
Total memory: 32 GB.
zswap settings: max_pool_percent=1, accept_threshold_percent=50,
shrinker_enabled=N.
Allocate 512MB of anonymous pages and fill them with random data (to avoid
compression), then use cgroup memory.reclaim to force a large amount of
anonymous pages into zswap. At an interval of 2ms, allocate a 4K anonymous
page where the first 4 bytes are random numbers and the rest are zeros, and
then trigger a reclamation of this 4K anonymous page through cgroup
memory.reclaim. When the pool threshold is reached, shrink_memcg() will
be triggered.

The test data after running for 120s is as follows:
                           Baseline         Patched
shrink_worker wakeups          5363             85
shrink_memcg calls       11,345,012        188,264
written_back                  40214          40275

Conclusion:
Under the same workload and run duration, the patched kernel shows a
significant reduction in both shrink_worker wakeups and shrink_memcg calls.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 89 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 20 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3d697a1a5365..6d492762957a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,6 +160,11 @@ struct zswap_pool {
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+struct zswap_shrink_walk_arg {
+	unsigned long bytes_written;
+	bool encountered_page_in_swapcache;
+};
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -1089,8 +1094,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	struct zswap_shrink_walk_arg *walk_arg = arg;
 	swp_entry_t swpentry;
+	unsigned int length;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
 
@@ -1133,10 +1139,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 
 	/*
 	 * Once the lru lock is dropped, the entry might get freed. The
-	 * swpentry is copied to the stack, and entry isn't deref'd again
-	 * until the entry is verified to still be alive in the tree.
+	 * needed fields are copied to the stack, and entry isn't deref'd
+	 * again until it is verified to still be alive in the tree.
 	 */
 	swpentry = entry->swpentry;
+	length = entry->length;
 
 	/*
 	 * It's safe to drop the lock here because we return either
@@ -1155,12 +1162,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			walk_arg->encountered_page_in_swapcache = true;
 		}
 	} else {
 		zswap_written_back_pages++;
+		walk_arg->bytes_written += length;
 	}
 
 	return ret;
@@ -1169,8 +1177,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
+	struct zswap_shrink_walk_arg walk_arg = {
+		.bytes_written = 0,
+		.encountered_page_in_swapcache = false,
+	};
 	unsigned long shrink_ret;
-	bool encountered_page_in_swapcache = false;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1179,9 +1190,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&walk_arg);
 
-	if (encountered_page_in_swapcache)
+	if (walk_arg.encountered_page_in_swapcache)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
@@ -1275,9 +1286,31 @@ static struct shrinker *zswap_alloc_shrinker(void)
 	return shrinker;
 }
 
-static int shrink_memcg(struct mem_cgroup *memcg)
+#define NR_ZSWAP_WB_BATCH	64UL
+
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
+ * Return: The number of compressed bytes written back (>= 0), or -ENOENT
+ * if @memcg has writeback disabled, is a zombie cgroup, or has empty
+ * zswap LRUs.
+ */
+static long shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
 {
-	int nid, shrunk = 0, scanned = 0;
+	struct zswap_shrink_walk_arg walk_arg = {
+		.bytes_written = 0,
+		.encountered_page_in_swapcache = false,
+	};
+	unsigned long nr_remaining = nr_to_scan;
+	int nid;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
@@ -1290,24 +1323,40 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		unsigned long nr_to_walk = 1;
+		unsigned long nr_to_walk;
 
-		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
-					    &shrink_memcg_cb, NULL, &nr_to_walk);
-		scanned += 1 - nr_to_walk;
+		/*
+		 * Cap the scan at per-node LRU length so each entry is scanned
+		 * at most once per call.
+		 */
+		nr_to_walk = min(nr_remaining,
+				 list_lru_count_one(&zswap_list_lru, nid, memcg));
+		if (!nr_to_walk)
+			continue;
+
+		nr_remaining -= nr_to_walk;
+		list_lru_walk_one(&zswap_list_lru, nid, memcg, &shrink_memcg_cb,
+				  &walk_arg, &nr_to_walk);
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
 
-	return shrunk ? 0 : -EAGAIN;
+	return walk_arg.bytes_written;
 }
 
 static void shrink_worker(struct work_struct *w)
 {
 	struct mem_cgroup *memcg;
-	int ret, failures = 0, attempts = 0;
+	int failures = 0, attempts = 0;
 	unsigned long thr;
+	long ret;
 
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
@@ -1369,7 +1418,7 @@ static void shrink_worker(struct work_struct *w)
 			goto resched;
 		}
 
-		ret = shrink_memcg(memcg);
+		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
@@ -1383,7 +1432,7 @@ static void shrink_worker(struct work_struct *w)
 			continue;
 		++attempts;
 
-		if (ret && ++failures == MAX_RECLAIM_RETRIES)
+		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
 			break;
 resched:
 		cond_resched();
@@ -1493,7 +1542,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg)) {
+		if (shrink_memcg(memcg, 1) <= 0) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
-- 
2.34.1


