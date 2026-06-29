Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A626DC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6ED96B0093; Mon, 29 Jun 2026 07:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C461C6B0095; Mon, 29 Jun 2026 07:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C946B0096; Mon, 29 Jun 2026 07:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1686B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 051EE1C368D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:05 +0000 (UTC)
X-FDA: 84932708490.11.B54B83E
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D8A640007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ihE6gV7F;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732063;
	b=ocLzTeRnm8x6Esy7Y/mM3dq/dNFeS8fAgVmJ95PnugMeCxCKXpreEoetbjVKN/5clKo/tB
	T3DjV9cPiPZv1Opu+6DzV34n8DhOOcok5ld/q55j1LuGYQhWcNkUDzQSj2LT20lhhxDUYk
	15kKnOpcXvLgFomxnXSSHNUWl9Zvle0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FietH9U8kgJBALOyGZ+5s9r+QaNo83d8QuAuH167UTI=;
	b=6Pnw1o5znjuU4ngGc2rfzqzlVyKMk1UyF9VDfz8WvZEPVEx/M3yjpOV9Xb3Vud/oa5Q3T8
	5K6plPy6tgNMOFzePJFdsUiELkmBZVMIhPX+LvegIw4SBNU0Ej6wI2DP/TdFaPlqouumi3
	NE7UzUbOnIrpvucxLDOs4zrL2mkOsF0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ihE6gV7F;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c80879c36eso17779095ad.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732062; x=1783336862; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FietH9U8kgJBALOyGZ+5s9r+QaNo83d8QuAuH167UTI=;
        b=ihE6gV7Fzg73tdPyvYFxDsxKzkBajQQZpWGT43JJMiYxpITBeZJs39d52m9wHshH3G
         KASJcyu1rnJ6UdEoz5y3igg3uoLwdNeIKyjRmjszh6BQsflehE9PQ9LI5rvHi8RiqY+p
         mghOgQtMGAw0UvnME2XMFIu/3gbgsNd7OPuvfyXqTOObfAjAj+v16Dvc7IdldxHJKIaM
         JAEBoaQYIFTFj83FJ6d5wTEs/ZryxyHtmRn6osAmRfQcn7jhtD6gGujoGb5ZzAWMjFL1
         uLglWylPDPoBbzq/zzMMRmhmzwdoFkDf+VV1/KI4pW2cfo2sRdLPr66mKbt/lS2eJSgQ
         l1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732062; x=1783336862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FietH9U8kgJBALOyGZ+5s9r+QaNo83d8QuAuH167UTI=;
        b=Qt2+8zOZ3rxb8kh2LGyjfATgBmBalA0dbx+cxeIYyXXC3aaYgsQdT6cOmyNiUMmV7h
         37BAdEjG4mtc68PRxfnbwgrdJqwndpsuhv6Vo7uM+X+5fMwBlWa521M7PZ5XOf85NRy/
         TeyzHQk6K4jWRAuXbGyVbh9Psg02M4TRvgD3acdAOYiQksutOgGMnCQpKkuBT7Pe/WLh
         /ied6Y22jKfW7AI/6Qm7lG3VT7N/wRG7A5zsfm8JB9ZrLTIezctatulpKMaKbwYj/6L7
         txWWKaLDmusycc1R+/mBSUGQOXU7O9smWYgVBUrtoKc+dTj7wbKIYYk8oqOVclbqnUqU
         ONzg==
X-Gm-Message-State: AOJu0Yz1CV38IeJU9LTSzrXUAVE8l/8zPlOrWQP22xh2EVueCtkH7vYa
	piz1lppEWuQ2u4eFwt6Q08r0+iaTpFWtGRqQ5L4DdoItlZ3JQ2cIseUDUx3J/w==
X-Gm-Gg: AfdE7cn4RvAE+x6pP+JlXBvAfj9HU1X4uvr6FT27sp8LO8Vq9XgXkK2WGdDQ3xDs8uo
	PL7wNAV7o9uu8OHd3WnQQIi51CmBxH1FLBfVARVPlc72c9BMxZj2D37cu9dM4kCYs2VIHkeamoR
	pvolZvz+/pLnw16EPVs+dvXkcbAFh4P0a2Z4tpfkU74eH5p/g3I939spzGo/ADUAp5sZtMz6Hmt
	R7WizPPHnh3NoO0FMbLkkZG0FnBCye2xoElnb3Ab/iG+LLjlklrLd3Hhj21UimJu2mYhmEVqLML
	dVPPdKydZI8nxr0kKCTSj4PYlerD4YHPogeXxx16fHe1IYdqaJ6rdpCBwohn6FAXxj5+7WLqOBJ
	LdFTmsTH7RGPxlfERz7cTvE4S1/Gifg8mg1KL4ozM2+Fim8VSZ//GBUN1XP/IgA4j1XRKFEe0Qn
	mxgevOEs9fpXHjfZSR75KbXqQeC/WhiDtvIYtjQFlV
X-Received: by 2002:a17:902:d510:b0:2ca:e3f:6a44 with SMTP id d9443c01a7336-2ca0e3f6c59mr15492975ad.1.1782732062077;
        Mon, 29 Jun 2026 04:21:02 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.20.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:21:01 -0700 (PDT)
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
Subject: [PATCH v5 2/6] mm/zswap: Support batch writeback in shrink_memcg()
Date: Mon, 29 Jun 2026 19:20:28 +0800
Message-Id: <20260629112032.20423-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260629112032.20423-1-jiahao.kernel@gmail.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D8A640007
X-Stat-Signature: p4tkiawjrm4ykuwae8d9hbz6b5iiij71
X-HE-Tag: 1782732063-459630
X-HE-Meta: U2FsdGVkX18lTdzreKmSZ0MUhCHreX3zfFUOtzDg/szTEzFzyQ2fyB7VhfINpkZEF7U36t3S3cp9CV2G46EBl2U7W0L3tQSWwtpi1esEieUowq+lXNbckCtoKwvuwgZs2Q4riCRscuGkEEe5aHPb+DMTmZsdbqZI/8AQRDjiQ1OnDMds3k7QhXXxB2u53Pz86KxPbbaWNlr9jil6pptZI2ww9GU21t1+QY6v5bPE8zLPjRaKvvnmLcWeCICpLpCwqizi46f0lJHeg9V+Pmoo5aHSxhNaqQs7nytU6OdO4IO9PDnALaQYFN7vc4PkqBUlDiNzmPd6nM72NgEgs+fLrtjhaCXUSJzVp1tVbCc7Ije2/byNoZ8/0Zfr4kl4VR5qyfm9ECnFe3zwbKxHfc0euq5wEbxKG2iyGeYrLit4WWrU+ki4fg2ywNApeNjIxSDwA5ADyAxwyxwtfbF67g37fYs8TGh6sdzIb0acu3kSiArwmOe8tXiH+I4Taj5jt4EShFgj3+asHevNcZqkN/F9RgmEcKQoxqPXYl7tfpXFIDCsHGor1AYThxMaNWSvi0xpMZBCBQ+AWajVvFBHBSfm0AbMOZujR0pAUy9oY1Q8PL3UqBkjmVcGSR3p6K5rxFwZabTU4gxHuqREwiGH24RWF/x0BMnY+eebYGNJ2z+jYuajdhq73dlFTRNRIUX38l2ViLdogr+RUWLOtqbP1lZsrM2vOdKg70sPB4+ABXqq1wBHsePBk1ma8+Mlq1DwsZra2Fjf7IV88nj0+kumuGOgD6oss2Vi6mLOn/4GTlnhzLfrsSVfluvhdxS6kDZ71XeUefILbiYfnnLv1RcINfYSxyHQXA4cyPRmPT9NhFyspGy77I80xImImcm5Hyx6eexn+X/IKOpHG/LuW2ubnKuHTCVNs70Yk0pu/xBks0Kc9CPRKQMTxsdFmMTvlULtkK0gOk6KzbDyt/zqCpnY/5V
 a3qK2SLS
 rzmXQmVCkLjU18j7DVuaynt9RHwAr79XwWLWJraXguDDGmKVgdYfBSoHVQ9Y2pJNXioPhX513HZ+fDqWsCGaqS7CLsd6BGOUM3QYV9PUgIQWRG/uIys3SbvbS8xJGemKhddeZfZ60WzFH4AQ4cZ1Bhat8DffjMqx1c/JCAFdvVI/QTHqzjUeBg/yhFkZ9pM2ZZgmwEoljUoXrfT4zIBc6UrNldiqj/r8Nkg2GhTudXgz4YmFLZAR876CGFoI6cwQE0At6yPaVLgCTQFYX902CCrYkzqUksgWzH2uc5SVHr/JLpYFo6iG1WN97qKaTHzE9hQYd9I5Bnkz3L2EuzgiAV9hF7X7VNtVcxlymCNxvhHTkva0CY6nQloStk2Kp/AGYPR54SvB0jwo3HnYPkOgP+ol/0ep/P3ToI2ARr/I9w3Mly1+25a2NwGF3Y04eTeu7UENkjjWLE1q2X68G5sIhY1Kuj3qnNv1B+gWslO9mS1y2C7m8ZTotjsFCQgarl72B3PPnCZBPKAg2F7R1wt3CBuZhditn+w6bVlrq6UN/l/mY5SSKB/3vJuG2dQ==
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

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 89 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 20 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0f8f04f22888..e2c2a3f1e061 100644
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
@@ -1373,7 +1422,7 @@ static void shrink_worker(struct work_struct *w)
 			goto resched;
 		}
 
-		ret = shrink_memcg(memcg);
+		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
@@ -1394,7 +1443,7 @@ static void shrink_worker(struct work_struct *w)
 		}
 		++attempts;
 
-		if (ret && ++failures == MAX_RECLAIM_RETRIES)
+		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
 			break;
 resched:
 		cond_resched();
@@ -1504,7 +1553,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg)) {
+		if (shrink_memcg(memcg, num_node_state(N_NORMAL_MEMORY)) <= 0) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
-- 
2.34.1


