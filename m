Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E66CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD226B00BB; Mon, 11 May 2026 06:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E076B00BD; Mon, 11 May 2026 06:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893966B00BF; Mon, 11 May 2026 06:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB166B00BB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 108A41A05FB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:13 +0000 (UTC)
X-FDA: 84754824546.06.322B913
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26B6FC000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sMehDNpM;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtZHWbxmSq2itef1lwgRS73YF1vAkySaw+AaQooe+e0=;
	b=yz8Wg4boaqJGxMX83uIk78mneOqA6Hj6a4v3gteHyhYtktjpQ9KaWRvGXH6uzojozDX+/E
	perENNWfIriOmzqLeLmhmlmEugMnjmxYD2T2xGp+xjvGm7mAwRVF7rolJqwA01rpkeuqBF
	HCVEWRm4cnfQiPZW5mVvK8ULJI1krNo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sMehDNpM;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496731; a=rsa-sha256;
	cv=none;
	b=dve3m0VNCk9PQlsfkg9du8rOvyoEQ5HTtk8JyawSWycVeacM2AAL8kHHx4IFx1K9aoIWmu
	BNpfww1MMMSvB7uqxG+yPujhvlToZO/SjIApx2PT7FbKfqIdmBqU2Fh1tNS8tWkhbxvxJ0
	ZzIosLpncCNmFXUIlXZ9FbM4ZbhHyIc=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c80203b9d7bso1588557a12.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 03:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778496730; x=1779101530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtZHWbxmSq2itef1lwgRS73YF1vAkySaw+AaQooe+e0=;
        b=sMehDNpMl4+QXjzu8uEKaWz8Xh3+agDZndbqqm+wlat8JkKyGrE5lQ424b48xo/v5y
         BYvWrSxueTCj5HD4of4Py/dvvmvmrrCeOQ8aLg3DBkWQtda6J4CI8pOJnNDzCOYc5LsR
         4GJLS62hbZZx+S9hzOXuLQ60E1ooWKGyN4GD+jLUy2Pp5ynZEbtyy0P6/PIcxeRX92qK
         AEnuQ6YBrrcX+Dy5ZqdnaCaZlsMmQcbbgWnbxOdecmWovDtULbyA3eni3/7xy0C8B92Q
         AIsRH7sHJ4umnz1uJh00Y6QJsm8oUOVNwgoVDDxOijYgGwunQ5BZQve4b3y2A5o3mePd
         xohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496730; x=1779101530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XtZHWbxmSq2itef1lwgRS73YF1vAkySaw+AaQooe+e0=;
        b=jJMi7+UkXoKS6xMq+0k9/MYd9sTsYdwOXQEoTo1WZsLIH4K3NN8ZcRrALzr0x8pljj
         HSEHHRKr2Mx6NomMWxU0fY0FWbD7O+ByaezSR8wfwfeEQ/gZNvapCnm4SKpMXge44aam
         uaTOTyeAm+Spa14D48U5ov/K+RBckUH9/pVFrriPIDK+U/mCFHJKS4H9/RlBVVLtPPUQ
         ZQ7zMqTgRAHKn+KdGhqmOpIu9enbPNfQp5cVs2OqCZyDemySRurMiPeLA0LeI6iKTdmo
         IuW2nFmq6hs36XvQwCV+KhmsPnowRmZEqdzNCUrfPByhXYpmypGiSDQLItVg9hItQw07
         alBA==
X-Forwarded-Encrypted: i=1; AFNElJ+x3vDW97+xJe8E1FYH45A1QcXlU8AyEcFivGjqnjT9C+fNaXxGzvAoX9yTH7PKWp/vGjOSF8kyqw==@kvack.org
X-Gm-Message-State: AOJu0Ywuc5wUhafPc52Nfqk/LcH+hnKCQRBO/Dgx7MRsrU4fvfC5XUam
	1vq4Iwa5ShXNaeI7cEKZxNf0noFFhURqMedv5/lewx2KTt3CPXa7mLse
X-Gm-Gg: Acq92OEcfNIi3IwS3HEIKSDddfJ5WiX6nyCtBAe9PMD8IgMtRrveO1BAQteHiy8jtIP
	lNyDboCpO17UM4A1Leko7jSRu6vy6ujEec1Ozm/2nmGS/uQ6D87VNjGzPqUieE2thDjBkGZ7XnF
	0T2WjW+4sfOiJonI/kmsI1Zb3jVBmgm7Y0HLZVhhSGXqE8MGXl0/cpouvPIzwk2vjh1uvHLaAuQ
	qtWDIYl6LySLu3nkPxoQCA2RRtI/lFsPfgzMA9cYxoQONlAwsWnjopo9XdC9QHgV1xVWzqmeCaT
	ZoaFRn3YnLGyQov5EkEI5dF72JtHjl4zqum+H80H5OKCxtSsDDx1pQw+ouu1qMsM69ZOCpsqS7T
	A9GRkunZvM00udI3whOxbcW9EtHlZzCj+GDbZND1rpC18R4duyPWy6EKpwU1GFFh2195kLWAGez
	O2LFPAZxl9obCjJ3vBYQQym4u6mIkzSwEHl02OTiu47FafZp1rWyaWk9JUB2BjIg==
X-Received: by 2002:a17:902:f78d:b0:2b0:606b:6fd3 with SMTP id d9443c01a7336-2ba78b30a89mr253673435ad.5.1778496729907;
        Mon, 11 May 2026 03:52:09 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d409eesm98571745ad.32.2026.05.11.03.52.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 May 2026 03:52:09 -0700 (PDT)
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
Subject: [PATCH 1/3] mm/zswap: Make shrink_worker writeback cursor per-memcg
Date: Mon, 11 May 2026 18:51:47 +0800
Message-Id: <20260511105149.75584-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260511105149.75584-1-jiahao.kernel@gmail.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26B6FC000D
X-Stat-Signature: yhxoqnw7zrwrosebtwqer3c5dsjsscw9
X-HE-Tag: 1778496730-740657
X-HE-Meta: U2FsdGVkX18hrKQ601AFsdCXd5cIsmP1J/gflxhPH3TNeXjqFXfPPgjOitkqQ5iMGQ4VLwBzSknz93Tf7hCyzqXLtsf84FdD3LON5xjye7QZ3Oi0F3gh3ABb/f46YRKkZDIwe/guWhm5OaYBnmipUeVsbXPJKXQpyAPo2fyePqtt0UkP9vPXyX/xi+QFzBxXgEy3JPSd0eyGZ1EH1qtvD1X0FNQ+damyfhdKjt6WtTUgSYuoeA7tq/ART+i7NazsxzP7S8eOcXnBZLHDZemTEdrTjE4rwCyRLVlAXuDqy05JAIa4PiBz3y8XCBeNvavjgerXHtUsDKBSLLfl+O5bPhgNoL1I1oUV4qz5KldTlUqgmxiPJOn5bZVhWrhthnHGqmyMKUPYXttKlIb3gj5I4NS2zwNFfeC1f+H1MgJq5deVwPlkJ4oYMW0aDtjMwdy7+RKHS9T4LQ6TbvUABCrbPmcr45IF/3IjijOcCvsIAEgXEfjgf43afL6kmCGfg5BvYvcAUhVz9MhKnOzzJgHcxQOPXMFeq5fl0ZWjDjwp2RV4soVVnUbVweEFLFY9G85RlhZYx2bTgteysUUu3W9mn+zxHM2bosH0GagCubHU8+DtuhmUiL9nzqFrbhHbE99DcCFaUutVS2+ohsTsibUjuZmo/2wcpzdMj2xvsEdMCWemUjAQIJdRe48eUlfx9PDtv69NEDxKNNl5gNbSFswpHqtGjCQ8qBJ5PXg99aN/GrodiTCxzxJpR6VTE8/IvvRI5d95YEX/1WO8yyPqkbnw8KTkELjJrpsdbudqYV+6nPXEb96UYO1dQLSU2KKavHyKEF2yFK4pM1A2DIfOJNw2w5dR2W1yTn1Mq9Xe7P/Hahy++WRIC6FoZZ9NOHLteAcVhQZqQtOfFRWFiNhN2D2Ukat0I+UXJozr2suoIqvPvcvOGmuB6TKl0WyGl8djvntzIjXZDEF5PMnaashBUiw
 0xIZzHrj
 3bf1beNyHY0BuCTfGXuHXIQdNWKbEaKowCpoYC4WDyBX1ZHBAywHs4CnwPfKn5Tm/bVT8QpR9HOAsIX16s1TJEbwC2PUemO/gRg3NPFANjKeI3ZULyIjIOk9fOneg9OBk3j3GDBvLJH5lHYx7aPtTDSkpkDyVd7wVAThVwkAsO2yZ4g7/AF0BRBTA9UW1QTX+Y3nIaQepO4qXZW4sQUXx7FeDnFB2DAHV10wawfcG9s5dk2TZLD4/1y2neLqCpBZjGpQRDh9B8srCDtwbz37pMd1nM+kSTDbWBB4QZ1TMBfdLmoL0ukVbH6I/LByOro3QXTvyaRsgvSKRL4cnJsy0xp2DETQmeiPeKRdPo7Bq61ps1dlH83LfrIRGAtFMVCejiR+Rt7aMtBGdz6J4l91VybZGx2jioBngjjK2Y4Vx/q0KXgFcMq+1hqVU890j9uRoKQc2m0RySGmYqu+2aBGUJxaUYTvlx6VP2jInFAOrBs9lR5cbJzZxmiPRolDf8CRK4rQoDwWHg3BEczdFnGmOXN/pe4FOFXTM+15wtSVnsVKhOJj/D7wJpdKzfg==
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

Proactive writeback, about to be introduced by
memory.zswap.proactive_writeback, also wants a similar per-memcg cursor
that is scoped to the specified memcg, so that repeated invocations
against the same memcg make forward progress across its descendant
memcgs instead of restarting from the first child memcg each time.

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
 include/linux/memcontrol.h |   6 ++
 include/linux/zswap.h      |   9 +++
 mm/memcontrol.c            |   3 +
 mm/zswap.c                 | 116 +++++++++++++++++++++++++------------
 4 files changed, 98 insertions(+), 36 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..00ae646a3a15 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -228,6 +228,12 @@ struct mem_cgroup {
 	 * swap, and from being swapped out on zswap store failures.
 	 */
 	bool zswap_writeback;
+
+	/*
+	 * Per-memcg writeback cursor: root by shrink_worker, non-root by
+	 * proactive writeback.
+	 */
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
index 4b5149173b0e..19538d6f169a 100644
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
 
@@ -717,28 +714,85 @@ void zswap_folio_swapin(struct folio *folio)
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
+ *
+ * The cursor is retained across invocations, so successive calls walk
+ * @root's subtree cyclically in pre-order and, after %NULL, restart
+ * from the beginning.
  *
- * Since the global shrinker shrink_worker() may hold a reference
- * of the memcg, we must check and release the reference in
- * zswap_next_shrink.
+ * The returned memcg carries an extra reference; release it with
+ * mem_cgroup_put().
  *
- * shrink_worker() must handle the case where this function releases
- * the reference of memcg being shrunk.
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
 }
 
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
+}
+
+void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) { }
+#endif /* CONFIG_MEMCG */
+
 /*********************************
 * zswap entry functions
 **********************************/
@@ -1328,38 +1382,28 @@ static void shrink_worker(struct work_struct *w)
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


