Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEF5CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B636B0093; Mon, 25 May 2026 08:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBBF6B0096; Mon, 25 May 2026 08:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1A66B0098; Mon, 25 May 2026 08:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC296B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:23:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3604907AC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:06 +0000 (UTC)
X-FDA: 84805856772.07.5A361A0
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id E57398000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V/hkcYMe";
	spf=pass (imf02.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779711785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtMgcDN043IrMH4z5Dydpux33DpRRQAjJ0E9E7yR9Fo=;
	b=dPtnfdy4Bu/MDRH3qaARGyOjG0eVx/RhNAgi5fE0egrMdkx66tszciGgVMRp92RjwjBpiR
	eofPVQayKugyOE2XlKJMa6d8lJ+sVs+59oYgVfRVdbotD/N8WJkSQc+HSfAqg48fk4y7+m
	g3RGWerjyzQBLZF28sG7+XvJuaZwHRM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V/hkcYMe";
	spf=pass (imf02.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779711785; a=rsa-sha256;
	cv=none;
	b=KVBkV4z8ApqPwqFZmsdjNmaZwIOcqrzr9nQiQmydfPLnTSD/RUv5J1qNvfn3neOHnttgX5
	EF6aaRvXX+7afKdXZ5TbvMBympvKGpq5SvOE7E16J36F5DXB6XU49UWkZYk8p2H/OhsQ/y
	jGKfQfTD0gaTIWSEj6wpBtL8kKdRunw=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36a35e4eefeso2977018a91.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 05:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779711784; x=1780316584; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtMgcDN043IrMH4z5Dydpux33DpRRQAjJ0E9E7yR9Fo=;
        b=V/hkcYMero7q3zGpoKiSWE3XsOitxfCUKN3BNvzu+kQuPYRB0wQn+NDJMh35u5u0hj
         gghe+NlX+pi6GH668rt3JZMHilGvmjuH6Pu8CjNXEAn+N3CBBwNOi2M9VH+qe64v5ejp
         es3YOOBvtgz2HO6fj93Kgporo+OWK062duA4bDGsr3lEt9DAejwxlzpnjZvQMDhfmWaX
         CHu870mizRYoj+qQuGnMQlHt0epXcQxteATe9oMK9A/DEYvyAsHYzw6e1SnkglMh/ppX
         9Y431BC6zDhnyk3X+ROaz8d9+6MKrsptM5Pu7jhzVLBJA+xCh3DRqievuvKUMs+gFRew
         iBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779711784; x=1780316584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QtMgcDN043IrMH4z5Dydpux33DpRRQAjJ0E9E7yR9Fo=;
        b=Dhx2eQEBOicZ0s/C7dJsT1A4+uPwW9594T7A6FNOlkKl1ot8c0Av8wVIZ70DG5KSR2
         ekymZsfKNyH+n3MlY2G5lkmP6xrDd+1EhZmmxFD/Q2fFVD0H3eZqCkvxO/+DJn2sH2Yb
         cCiXEW1EK2IUliGaq6/338Nt/cWTsyobw8MdkDmFax4RMluvX0XAcPoOUDzJWI8LG+pY
         DO5qgJICpDKOFSA05Zua7nlHX8XZBzff0CB7uYJu1g2jYy0UgFulbHmF5jFTbyTAgzSv
         g0zqZPT5+WDV9KA1krvIHhrWi8oCMls9RsHRsXansZAeCB3Gj2/pVxL+JovJA6R6yp4P
         g7FA==
X-Forwarded-Encrypted: i=1; AFNElJ/PLOLAsw4IU/zaREI22gQNYbtUArthEEFszQBa0SNvdX0cqnxa5oFJlX0UcOOaSx0uVV6biO8Pdw==@kvack.org
X-Gm-Message-State: AOJu0Yx7tdeDeYlIpji7ODN0GIeGVJHZnpLzX1qUF3cB087d7X6x7Ftb
	VDuMJkM66LoZip78lCaKWjmjS3sJ/ZQjNpJ2jzyN1I71fVdKYsXypsKB
X-Gm-Gg: Acq92OHkqSqgA/St4skm3H1q4dtNZZ5bibs97rEVysGROtQ4swxsKAdpNPWnB70JCSP
	2IIqTVBRmyTNf76mYvgkF+rMUvlNvmuqSbVUDsENwJwyEJplbc/yuzlU8h2Su13YzSngEUUCwor
	3c1Jrz9sGZ6F7DZ+P5XEb1Sr4bJrFeNKp5+DyLKZX1EdMrTBG+IGUixNZslF6d+v2kcn2i1GvYh
	RNXRYoPrgAfgFEFi4VN36+rXITiNqRFd5h7BmJI7polSGpijlvEOe85wcJ5YyuoV88O71G/0jg4
	MygWgX6P8lvkhgb+wzdIYIMh49hcG7P5tjyuiKWFDTT6QqFvhxHDA/AhcEalOUoAoQQp3AX/wkr
	u83J7RcULgFuGDfVPNAtoauSwEfn/y897MsdT9q9aGLG3fULSJoil0Nxhb95t2P2qBG1SbQKibN
	gnHeiA0xbeAzTZJnKYguEdR7ZMiLcA4PJ4xA6lNTNLju5nR/NT/f96nqS8g98JVA==
X-Received: by 2002:a17:90a:d44f:b0:368:763a:17b8 with SMTP id 98e67ed59e1d1-36a6741dd0bmr9210428a91.2.1779711783550;
        Mon, 25 May 2026 05:23:03 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c913a1sm8999131a91.15.2026.05.25.05.22.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 May 2026 05:23:03 -0700 (PDT)
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
Subject: [PATCH v2 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
Date: Mon, 25 May 2026 20:22:39 +0800
Message-Id: <20260525122242.36127-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260525122242.36127-1-jiahao.kernel@gmail.com>
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E57398000D
X-Stat-Signature: ej587fdrjm4z7ygdi1y9t5pnkp9napsn
X-HE-Tag: 1779711784-158338
X-HE-Meta: U2FsdGVkX18V5GyoqO33EJGA9xy+wv3YF4inKkgOGr+2wWS+SHr79n7nmUy2YlBljLLLi1jhcXbtH2R5oVX5M6TVtmKGR2XY6QSJl4lQUBaXzb+1GB6dJRTAq4OdW+OnBxIsPPKULKaHOK9RV7sdlWmaxdY0D60S1DgQE4Ux/5ZH+qOOj4qH0HYyTzQeHITonJiocRY90giEL/lC6exzHKr7Csiik9w+zdOFytAOXPyY8QgvRUFRYVPG1/4Fm1do1JE9bEZi0Ax1458rMjuMjzx1Zg+OqJ6HHwzs0/LqnTPjdDD3ruqIqtuS71V7mgm4lhKqbougucQs8emp9pyjYWRlXpU8XC7ZCdGE5kli4ZUmosCrCG3KEbRPwBKsIE9ScH0RM3f5wC5hxk2pwRkC4yEJ0NtwAIBqytOJpeuQkbXCBEB8DNocPQdj+41GfpHHGg73oYA9IRoN4111HXH4ITAbdWjfDUPqN9GnvRjI4a2jtQfXF3FhumuOF9pFS1ZeG047ktFo/VICe4jb7R0wVNLqV2d3yjO459m6yM8WJfPomxJzKjnpmeu3htqTF5heObpOshiClXQ21HUi/eCTMCCMbo+sQ4QMdl58Ngebs21MVjlr0Y1uoGy5B9sSKo3qa1irhc5b05Hz1AswQsQwLSnf93rA8adGIaIXZah6CmJrY62J/daGYNlhIRJ67EEgRfRC3RBxsiCBPTNNXqowRLg0UWTG/DiajD6LB3ywm6aikwOtsNIlQWHgYWv5+jhGEZXrASi5WVmIwAj3TfH0e28uS7S2a8t6IMb35pDCmF2XPI+vjzxypEb3Ek24K6Wu0gEYupFuW54+OFJUugFzq/pa+ugGev5Ba1y3Dzqql/BJPmqU7+gKXZ/TnfMoJS9GzdgrIejbGHrNYHSCNlZ6Ql+DUYw9MeHMZCW74dT+bzU4G0PtgG2Pr+rwAGUz8gucPC6ijRbASM5fqcO1PBQ
 U0/qNjK4
 6k1nMbLt73Ey0FmNj9xfNXQdatOXeArjt7LxLsAwFBt7mPcav+rxiXT4WHdEe7IvnGL97sW44llTXjWgoL7u3TylEE/E85oT44jb4H9czgySN98Whp6l0yRcK2FvuClwNJd4rBZd4eNMvG2mWfKJNTds+NqVIVAj5yTzW9pmC0rZscOS2OT+9P37KF7tAjDra9JNSR3j4CXEEq+//mjwCgBo5KiuaB9Y8N7HQ1Zt17a0e1SkkdjmVui+p40DNVIXfhBFLdQgIyZDyBvhWT9tx40j5XQGPpiq0H6r4zwbsl4LcQLlV5HhygTXZckxcZ4hZKoi4uNwnCAyAhj+hJ7Emjaj0aQBltkz7N8f/IhMOaftW42u/SzcYakuyQeDp3vF/E0FkN9eVxeqWStnqhDRMlkIBypenjqpVbv6iPUB8ExxrQ2hF5niLRX7y7JTrlNkuFxZruJdE1vbei4xbmTwu8vuofC//FXjL9iB8u0NMLfp0lRTzbOIPTKax5v7unl+UjlFIn3JLFrxh7PoHtxUmIdIN3yMG+cUTbT+8ZWq1Qix9JzmJJ0lcyNzD13/FjfD7agnCb1o/2VnAozDC1pNxaP4fQsbtHuxBM7/yXc0HLazoG1s=
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
index dc3fa687759b..b8323c8d6565 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -228,6 +228,9 @@ struct mem_cgroup {
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
index c03d4787d466..409c41359dc8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4022,6 +4022,9 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
index 4b5149173b0e..6519f646b496 100644
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
@@ -1328,38 +1385,28 @@ static void shrink_worker(struct work_struct *w)
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


