Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7226CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87986B00C6; Tue, 26 May 2026 07:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E5B6B00C7; Tue, 26 May 2026 07:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A759E6B00C8; Tue, 26 May 2026 07:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97C386B00C6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:46:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 677FF1A03E3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:32 +0000 (UTC)
X-FDA: 84809393424.28.4DB8F07
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7723714000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sKn5GoFX;
	spf=pass (imf23.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmT0l+ZeGCAjbHFitrEBWwyjPsHUbJhDumkOpCJMGgM=;
	b=B2hIMCVy872+CdSLECOmd/vFMKXz3Cjopxn7GZAi/ITLwYWV04apR8QXmEjrJYvJ3n1NQC
	2Kim5kXz3eUhuH7xPsmU/av4+cYvm41YrIbRhSpG3VmgGNy+R8Pau+LZpp+3RnsTrGh7TE
	XoN5GJS4xiar36ZunBbXkPm0SPXkn34=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sKn5GoFX;
	spf=pass (imf23.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795990; a=rsa-sha256;
	cv=none;
	b=r4nahpStoahWyPfxdaE4W9JafXcfQlNUoiah6bXX6tgA3NhPe0+Ozwtcj3npCOiCXIZuA9
	UjksYocKGC15GAN2VmzFCD/ENTFUGGH+T5vKO72cffar3mTRw2lgQK8dgBFraZPRnlf8gM
	nmYTpdr6YxtlZmJpYMgeBQMVquUdiBY=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c8021c8c42fso4185814a12.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795989; x=1780400789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmT0l+ZeGCAjbHFitrEBWwyjPsHUbJhDumkOpCJMGgM=;
        b=sKn5GoFXYvTBw472mX+yGSBSzKYwuEwYJpcBOQuHahcer/lMxbZAgH6sP+HgbZPa5d
         p8zcaoiUavUq21tOfHDhTW4zH0ivim7t3q8nXo82ZTSX1mHUFhqg93SvM5MQ8kflcDto
         trxoADoMKQlz9zTxmFQgMuEErn/SAt9xomb0+RKCROoEuv6vwb98QPl3/1Xvuwhg2pXR
         xrH6bXeJ2YBj1lnE7iHjdTOyZGXhlzZ3ZE5owjIE9zhSfXEMSA4n6wCEICl/6hJvvQbe
         oLQEHUhdsPBfLh9bdtty9scllC9PjK7xmfv5pq/Y3PFP3WA4UfRh9x//ml/6wkR1hCvE
         Hsrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795989; x=1780400789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bmT0l+ZeGCAjbHFitrEBWwyjPsHUbJhDumkOpCJMGgM=;
        b=GGbxT6D+j+RU91bEqrJPgkOElhf3e9idbnOtvtPr3dH+L5OWRQrLSvfPLWUsgkhjdH
         jr0DgHue6QGQlttQzqEPjJ4krA1Tx91x4Xydup9UfN5s1eC+6wG4lHT+nJfTyJ+Wlv1N
         48hQI4GbAkhzGpq/zcfHZhQ8D+HfMLJ3lCqV5SN6cCSUQRtdd0VBLwhd2y4X6p/mF0zL
         j09MNWLaz8iPPTLXDFq8WW4madoENuYLYME8xBQQJOYPZoSbRywkqyAc1ooL8+Z09FbF
         iycpF3n2jXOg097J3muacKiBPYDxPWdsbSn/swT2HCnV5cL3KIxqM/Z0p42aXns/IFah
         nNsw==
X-Forwarded-Encrypted: i=1; AFNElJ/uh99/XuNnwi93nxKWgzrSF8Ps/KuzOI2uySGttPSLSa6IZvsoccldfqyve4HO4wt/vbE29GKYAw==@kvack.org
X-Gm-Message-State: AOJu0YyU2fPFPniSXy7dXQuJQyGnLV8eVOw0hRJWIXyIcqgI1REzTXdJ
	sf+TXQt5gGo88m/LJzIoTVvbQRz/jyV8vGqj3Rco3t/JFCQWImglMd2zjRxIrQ==
X-Gm-Gg: Acq92OF+wFyQFjkxYwbi5j+ObcRDOHaNFmpssrJZ6MwK05Er+hdcaLsfpeDWYJWxaEa
	ZCASySQkD/4/R3THXiCL7XOtrHXlYEDnNQClu02k4dgc6ocQb6eaQa70eJviutdhSuXfwIf/Vs9
	a4km+2s/U5C7QA/V0umxUkgmtx5QukxVpAOpZJo8WngtvEBEbOkTXpQ1LFRBjdT73E8PkF+gm/F
	zU2FOywRFwlxCwebdDbTv2KaYUQmDQt7kBGwJW+sWGCPSCPs57WkQW8zdYEy8p/Sp29knANMdHW
	rWu22eJoz2rycUgBLs4RFqad/BQRfrzbEDVe8oEdSrmQk28ENbGeN2/sZHtRrsU4YaYPFeaKrLI
	b6f/dubw6nARqZ0O0HS/wnmpyokVhCVOGGOrTn5c8Pt08BvHo2rxzy/meD0GdqBR6Wo3VcmSXtj
	0jipmeldCZKaADGLpNjFB64kNxtL93/2bIPaTuJ79Ym3XOiq7ajcaOUg/sR+rpDw==
X-Received: by 2002:a05:6a21:6113:b0:3a8:2339:24c4 with SMTP id adf61e73a8af0-3b328ed61d9mr17349804637.26.1779795989211;
        Tue, 26 May 2026 04:46:29 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852028fe99sm10304341a12.4.2026.05.26.04.46.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 May 2026 04:46:28 -0700 (PDT)
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
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
Date: Tue, 26 May 2026 19:45:58 +0800
Message-Id: <20260526114601.67041-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260526114601.67041-1-jiahao.kernel@gmail.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nesyz88f99x4irwzhga6qht1rw8gsxpq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7723714000E
X-HE-Tag: 1779795990-328674
X-HE-Meta: U2FsdGVkX1/xpsGOWOVKF3jShiGaKGwAa30wEGPjaE4gRMJR1f0yBaO8idngZldbJcQeiHVJWMuXriQWEp/WYsiPZMeTEL99+YkmesIMHCinfl2EYKmFi1QdfYTdOex3EQXU7yQYK2MIAF6O8Crqew6TQiLLPJbwonYDqDS1bUcBn0EFYkqsTsSgGZzdah0CKhD7XQuJpdZ2030h50rcEw7obH9K23DphfANp2xuRAl6ejdGX0LwgGpH0jNJgP7n4KzN95CEQD6ZvlzCoSOFCsIZ1uJJEvl0aS8DkZ5DlIyVchsM/rsYHOtaEvf27tHOvfJgt0z/8NAsWWtD9EdG/yYPrUSjRzKHxI2pK+RxYB6rj/5yCwNGIKRdtoU55uoYIjRBebePoZ8/VfhuluTZLiRCPBGMxsb6k2uX6A97QgyS6oz6zdM2QciluhcSAlRSHrO+RkwY5fXkcZpgDRI5kvPLxcYMtyNK3ZwAEMEpKD5ewPC0S4US/NJnMeg3QoSYCH21iSS5XFQ4PyBHhvENcmeDhxED5sq8ndhA4lcFPyvBdFhpPKQBoT062LFZ9pBdi2hy6teO6NQKDWCCVEGDFooTpvddJSEYhaKx8qu28AIJlA+1ban7m7wgWVpzhws5Ib59OFCtjFnVak6e9aoIQsZw4RZV8UccoMerZjsVXK9DV+beKTv3NbLXX3xolbClwnyqf0bIT5MqXKvtuAMZukjxv92PZSMMPJMJeBKpYbASNx1U8FFxbZR4w25oHoAoX9BdZpTDvRBERE0+cl1evPtfGN6mCWCGwbbTMaeMtonspE9UnKFVDNLUXL4hnYFT/8S41Gmnw1CnexKG+ouc6MVvlNOt35k22sXB3CigiDPtdK/FX4Y4ju/rQRXwY9t4V+X3QdijLeBM05CmZCFGg4DhsrGUiaqjapScTW/4I0p/4frgfnGfEiZwJtqu5MQXAtJNBfBR4its4T4Cq88
 aXd0fEG5
 U986UUV8uzVFeBKSoQfLWbeu3D5R7EuE2Oc0gXVkfmxfG7kOzRsW4NHSynqxRoHEPFrLvoQvezE6m50KlgB/S4GlHNy4gYx1mUWx5fcKe/v4wQOSqJAPD33DIDwv0Yqc2WfjuQxVdzBGo8kSrdfJ8b9KfsfXKh6hKfJKUrY8WdR4IzWOz4iAmNB71ivk0H8vlM/VDKi3w5AiP1Mcfe1/wfOM2vUOpoXE7zvAQOCD+3UgDKF+T/V/FfvN0tGC+YV/ykzU6oLJWcq5Df7/WX1uwV4H5JYDTEYCL6Aja5JmyIemNWSywR+zHMMfufpTomaCITAn61JYS1Z3s4W/OurhMRAdixWYDT52Su7p0SQTDs/pRFh+rtPDs2wVAlkS2VIasIU+MuLub8XfhTVuQD64S2Hx4SI2ZTfKHOP1sqtFZzU3lEVjkuiSmxOO6h4TUgKjgz9D4HT/7ffLRsLQHjvyaPeHt1vGRvfVgeRkuoP9BKpK1rQoVuVpxGA/zCYZCZtMEPaStjDHJ66pmL+VLpp9sd4wRMxBpT+YDwETnum0D7q62Oi6lGWE+NIf8rSg4Dy5Ob2ai4wkOfWyB/O0Q3Of5caEVzez/SCfTrEDCphahfa9QlQ9sxeZU/JTI1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

The zswap background writeback worker shrink_worker() uses a global
cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
across the online memcgs under root_mem_cgroup.

Proactive writeback also wants a similar per-memcg cursor that is
scoped to the specified memcg, so that repeated invocations against
the same memcg make forward progress across its descendant memcgs
instead of restarting from the first child memcg each time.

Naturally, group the cursor and its protecting spinlock into a
zswap_wb_iter struct, and make it a member of struct mem_cgroup to
realize per-memcg cursor management. Accordingly, shrink_worker() now
uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.

Because the cursor is now per-memcg, the offline cleanup must visit
every ancestor that could be holding a reference to the dying memcg.
Factor out __zswap_memcg_offline_cleanup() and walk from dead_memcg up
to the root.

No functional change intended for shrink_worker().

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 include/linux/memcontrol.h |   3 +
 include/linux/zswap.h      |   9 +++
 mm/memcontrol.c            |   3 +
 mm/zswap.c                 | 119 ++++++++++++++++++++++++++-----------
 4 files changed, 98 insertions(+), 36 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bf1a6e131eca..5e29c2b7e376 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -229,6 +229,9 @@ struct mem_cgroup {
 	 * swap, and from being swapped out on zswap store failures.
 	 */
 	bool zswap_writeback;
+
+	/* Per-memcg writeback cursor */
+	struct zswap_wb_iter zswap_wb_iter;
 #endif
 
 	/* vmpressure notifications */
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..efa6b551217e 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -11,6 +11,15 @@ extern atomic_long_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
 
+/* Iteration cursor for zswap writeback over a memcg's subtree. */
+struct zswap_wb_iter {
+	/* protects @pos against concurrent advances */
+	spinlock_t lock;
+	struct mem_cgroup *pos;
+};
+
+void zswap_wb_iter_init(struct zswap_wb_iter *iter);
+
 struct zswap_lruvec_state {
 	/*
 	 * Number of swapped in pages from disk, i.e not found in the zswap pool.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 13f5d4b2a78e..e205e5de193d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4024,6 +4024,9 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
 	spin_lock_init(&memcg->peaks_lock);
+#ifdef CONFIG_ZSWAP
+	zswap_wb_iter_init(&memcg->zswap_wb_iter);
+#endif
 	memcg->socket_pressure = get_jiffies_64();
 #if BITS_PER_LONG < 64
 	seqlock_init(&memcg->socket_pressure_seqlock);
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..73e64a635690 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -163,9 +163,6 @@ struct zswap_pool {
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
-/* The lock protects zswap_next_shrink updates. */
-static DEFINE_SPINLOCK(zswap_shrink_lock);
-static struct mem_cgroup *zswap_next_shrink;
 static struct work_struct zswap_shrink_work;
 static struct shrinker *zswap_shrinker;
 
@@ -717,28 +714,88 @@ void zswap_folio_swapin(struct folio *folio)
 	}
 }
 
-/*
- * This function should be called when a memcg is being offlined.
+void zswap_wb_iter_init(struct zswap_wb_iter *iter)
+{
+	spin_lock_init(&iter->lock);
+}
+
+#ifdef CONFIG_MEMCG
+/**
+ * zswap_mem_cgroup_iter - advance the writeback cursor
+ * @root: subtree root whose cursor to advance
+ *
+ * Advance @root->zswap_wb_iter.pos to @root itself or the next online
+ * descendant. Passing root_mem_cgroup yields a global walk.
  *
- * Since the global shrinker shrink_worker() may hold a reference
- * of the memcg, we must check and release the reference in
- * zswap_next_shrink.
+ * The cursor is retained across invocations, so successive calls walk
+ * @root's subtree cyclically in pre-order and, after %NULL, restart
+ * from the beginning.
  *
- * shrink_worker() must handle the case where this function releases
- * the reference of memcg being shrunk.
+ * The returned memcg carries an extra reference; release it with
+ * mem_cgroup_put().
+ *
+ * Return: the next online memcg in @root's subtree, or @root itself,
+ * with an extra reference, or %NULL after a full round-trip.
  */
-void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
+static struct mem_cgroup *zswap_mem_cgroup_iter(struct mem_cgroup *root)
 {
-	/* lock out zswap shrinker walking memcg tree */
-	spin_lock(&zswap_shrink_lock);
-	if (zswap_next_shrink == memcg) {
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	spin_lock(&root->zswap_wb_iter.lock);
+	do {
+		memcg = mem_cgroup_iter(root, root->zswap_wb_iter.pos, NULL);
+		root->zswap_wb_iter.pos = memcg;
+	} while (memcg && !mem_cgroup_tryget_online(memcg));
+	spin_unlock(&root->zswap_wb_iter.lock);
+
+	return memcg;
+}
+
+/*
+ * If @root's cursor currently points at @dead_memcg, advance it to the
+ * next online descendant so @dead_memcg can be freed.
+ */
+static void __zswap_memcg_offline_cleanup(struct mem_cgroup *root,
+					  struct mem_cgroup *dead_memcg)
+{
+	spin_lock(&root->zswap_wb_iter.lock);
+	if (root->zswap_wb_iter.pos == dead_memcg) {
 		do {
-			zswap_next_shrink = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
-		} while (zswap_next_shrink && !mem_cgroup_online(zswap_next_shrink));
+			root->zswap_wb_iter.pos =
+				mem_cgroup_iter(root,
+						root->zswap_wb_iter.pos, NULL);
+		} while (root->zswap_wb_iter.pos &&
+			 !mem_cgroup_online(root->zswap_wb_iter.pos));
 	}
-	spin_unlock(&zswap_shrink_lock);
+	spin_unlock(&root->zswap_wb_iter.lock);
+}
+
+/*
+ * Called when a memcg is being offlined. If @memcg or any of its
+ * ancestors has a cursor pointing at @memcg, it must be advanced
+ * past @memcg before @memcg can be freed. Walk the chain and
+ * release such references.
+ */
+void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = memcg;
+
+	do {
+		__zswap_memcg_offline_cleanup(parent, memcg);
+	} while ((parent = parent_mem_cgroup(parent)));
+}
+#else /* !CONFIG_MEMCG */
+static struct mem_cgroup *zswap_mem_cgroup_iter(struct mem_cgroup *root)
+{
+	return NULL;
 }
 
+void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) { }
+#endif /* CONFIG_MEMCG */
+
 /*********************************
 * zswap entry functions
 **********************************/
@@ -1323,38 +1380,28 @@ static void shrink_worker(struct work_struct *w)
 	 * - No writeback-candidate memcgs found in a memcg tree walk.
 	 * - Shrinking a writeback-candidate memcg failed.
 	 *
-	 * We save iteration cursor memcg into zswap_next_shrink,
+	 * We save the iteration cursor in root_mem_cgroup->zswap_wb_iter.pos,
 	 * which can be modified by the offline memcg cleaner
 	 * zswap_memcg_offline_cleanup().
 	 *
 	 * Since the offline cleaner is called only once, we cannot leave an
-	 * offline memcg reference in zswap_next_shrink.
+	 * offline memcg reference in root_mem_cgroup->zswap_wb_iter.pos.
 	 * We can rely on the cleaner only if we get online memcg under lock.
 	 *
 	 * If we get an offline memcg, we cannot determine if the cleaner has
 	 * already been called or will be called later. We must put back the
 	 * reference before returning from this function. Otherwise, the
-	 * offline memcg left in zswap_next_shrink will hold the reference
-	 * until the next run of shrink_worker().
+	 * offline memcg left in root_mem_cgroup->zswap_wb_iter.pos will hold
+	 * the reference until the next run of shrink_worker().
 	 */
 	do {
 		/*
-		 * Start shrinking from the next memcg after zswap_next_shrink.
-		 * When the offline cleaner has already advanced the cursor,
-		 * advancing the cursor here overlooks one memcg, but this
-		 * should be negligibly rare.
-		 *
-		 * If we get an online memcg, keep the extra reference in case
-		 * the original one obtained by mem_cgroup_iter() is dropped by
-		 * zswap_memcg_offline_cleanup() while we are shrinking the
-		 * memcg.
+		 * Start shrinking from the next memcg after
+		 * root_mem_cgroup->zswap_wb_iter.pos. When the offline cleaner
+		 * has already advanced the cursor, advancing the cursor here
+		 * overlooks one memcg, but this should be negligibly rare.
 		 */
-		spin_lock(&zswap_shrink_lock);
-		do {
-			memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
-			zswap_next_shrink = memcg;
-		} while (memcg && !mem_cgroup_tryget_online(memcg));
-		spin_unlock(&zswap_shrink_lock);
+		memcg = zswap_mem_cgroup_iter(root_mem_cgroup);
 
 		if (!memcg) {
 			/*
-- 
2.34.1


