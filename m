Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874D1C55165
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 00:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA706B008A; Thu, 30 Jul 2026 20:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AB46B008C; Thu, 30 Jul 2026 20:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDED6B0092; Thu, 30 Jul 2026 20:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7FAE6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:33:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61D211A02D8
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:33:01 +0000 (UTC)
X-FDA: 85047196962.04.2182D69
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 820B9180009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:32:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcwa6LEW;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785457979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pgl8j6vS3C7bSkoMmKnotkN6vZDR6xO4lGHnrMnaWEQ=;
	b=7DkChAINByC1WkwEERy/D2avefD15So33lBrMPlT2P+yG/ZbAN9Ek0NZWO31K418LwLHat
	FPCw9IJiiQlFisDzaX+o0XMtz5zyeCgpmmeX/tSaDiF1Z545gXkb/2bpJeoabnjhBRdpxL
	/aab7+iVI3lftRQQ3CnwiW1JfFxXhhw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcwa6LEW;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785457979;
	b=eKnG3aN6EuiYGMfJ14d98PGTm7oQeQwiwMWQ/7F3onKL5MYgAwODXsnkFlxcXduzQwNAhS
	uXwVzIjGBiZIEbp839Gg4uSunjwF1Rt/XGxHVbRPZ7HVyiRO/ucUmQGPvBSr6QBtyEJIPO
	pN/FnVdjzZGl8EmV6QCziMHdvrYvTI4=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so335451a91.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785457978; x=1786062778; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pgl8j6vS3C7bSkoMmKnotkN6vZDR6xO4lGHnrMnaWEQ=;
        b=mcwa6LEWzZI8g/BwZ4BU6gyMyrIg6y7uM2AZzzSAk1dTbcp2c2liurCLsgTJAOr4Q8
         mUt/Z6di2GEBk3rJq5a63KPexvVjcmQ4bHBKoMgyA8mY+GPIjtdIHFFWAygRlbHoejQ1
         nlYNh0Lh1nj9CmtV7maKLA7ZFPOECxl8UCWbQ5WUVAC5rIl7AqNg4oci7dxd/4E2aYik
         Zv+8K8BlKtk1m7bQcEFlg/N4I1VuoJIs7dIV8zxC09HW3KHVhj3Uvw//fNC4SEE+77iR
         EZMWPt992vpKAROa2cRzid643BYE/aMrQEduq2Ae5pXnPpil4GxnNqGLAa+JEbD2s3a8
         IE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785457978; x=1786062778;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pgl8j6vS3C7bSkoMmKnotkN6vZDR6xO4lGHnrMnaWEQ=;
        b=NEubnFQDKUTd8Yvt+lU5e7lhNMjbJ9UE1X7Rt/mNa+q6/7Gw6F1AGdDHlQcvz1g8Ak
         ePLYM0PTmpuOgTIXhSJ8c0G6ftBxfYcgAlsHYLQi/iNk7gAP64/9uCFrheGFI2833MaZ
         oOFd+0PAHLrKPsTl3wVL95SrDSLr0p1EKn+UiY7psqpHEG++0TbiCzQJ2tJUUSUDAgpX
         q3tx3GzBAFSLANHDoRf37mfCE4ztYE4xNjG0fcquNoJIhjgOgrXbvz51Cxkk7l7WLmhc
         WBp0fm6PGGc5jcazIBiI6b8nGaqvyVdW9nMlMm5ko/QUqsuhtr7E10XwrwV+d5bwmvIp
         885w==
X-Gm-Message-State: AOJu0YxgsK6BcwF8IbiuxiTQj3pD4wQoAlWPNPaRmlQ72fd8n6NKAwye
	D8i/N2x192vhEcCtH9ko2ChFclRze4sar+uf1UJJWyeu5FAgS6MJVlLM
X-Gm-Gg: AR+sD11VuFdzysPD+nqdfk5avvbpWSFZLL/mHzk/xkgVRIh5Ek+VhhSD1ML+frlaWWg
	WrmolusjUGIoa0x7GtqTSP+thzCRtGVpy1nOybZWZJTdOJgcohNyvzfZX9yP9qeA2xAsLGQ3Crc
	F8hzWbNULE/+WrgEZXwZ85FqIAt16ic8ZmersgZm769rzWhSQCvVsVNOpZ9J24AKUf7DNfyduyZ
	qu9c1kwZh0fx5z6T/0ip0arnLyNe7sE6z7vfo6YTtd7Gx09eExjz1WY9jIv/PaoOg/kbfXpccS6
	kLEtRKfC3VDtBxhF3M+bal8TJSLuguvKcc6Wl/PsjDSTwLvgRup6YUsDfW9AdLTKSYyvYTeJWXW
	8y9hgHG/42x62yL0oNbPp6WAej2fzB4TcKX7WG8+4mlz9QhMnztLh0g5F2US9KnQ7VLI57R5Arw
	0LfF/iGD56yapLk80mElTBg1xGqkAm9XEYMo/xFrSEka0/yYdugmtJ5nbcVapKv2N0YKrxLGLwI
	WNBvbv+L1AUddH5zfgwhY60k+BgXN/p92WWpfG9n0d5gr+dYh8=
X-Received: by 2002:a17:90b:5903:b0:38d:adae:4866 with SMTP id 98e67ed59e1d1-38f9bece6e1mr3994144a91.21.1785457978178;
        Thu, 30 Jul 2026 17:32:58 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b42d6c8sm1636301a91.3.2026.07.30.17.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:32:57 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Fri, 31 Jul 2026 08:32:47 +0800
Subject: [PATCH RFC v2 1/2] mm/zswap: replace the zswap_pools list with a
 fixed pools array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
In-Reply-To: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 820B9180009
X-Rspam-User: 
X-Stat-Signature: aqd1jyeuyehpbmot3zy9w8uwou19kwej
X-Rspamd-Server: rspam04
X-HE-Tag: 1785457979-884453
X-HE-Meta: U2FsdGVkX18E++4oScR/23+CLvyTimrCktCXyaJV9SGG0I3Xz5Mi4qxMAZ9tun/jH3L0X/R8xZUyE9/Ns4XHjeYJ5x0309JC3RFn2Pz6CDU+sLVmKR/VYoakabIrmH9a+F4Th+XAwjhxZ8722GWHstVaU6ipi47FyfDnSgOCBkqm5NArKOyORGcwl6UYBUVmoYLIqDDt54ezJVPWHktm1U9ymjA46qGDDpvjs7wdL/n+wsI1Bi/XeYACqI3WZZS7T2Wwa0dKYFyhouTsID/VL+rHuTmT8p04z8pDlqDjOX0GVjxLcIkvZWQU/b906pgsbfaIsL1s7x3lB/5KUpbO+C+eAzwMdwKmx1ANwMfZBZod3oChxrDlcheH0YCCBQw2xaL7L/KMahK++jD0cn2ZRgvYTj0uHX13WfMm4RfaWvSmCPDNk1jX3EOv4r2uS53IW6/w3z+OAVAZF/2Hy1z4BosbLeEhbjZx8q/bvJ14bRsrs5TOLVW1HP3ySFGEYZBKC4SlYX9bg9bX9Wt/GHKM5OA99SMXltcyBrUf3PcrSX7DCG0NFQnKdHLUPGipV5tX+CyXA6S4As3hFcaTRYp2Io3PLn8nbs4/EQkCYYPKR9PODiuIfxtG7mjNvmZKYe9/uf6s89krOEBBqbnInC2BRBrI8KTiw1/SJlYbNi71bD2d7uFRsrN8gjqah0YKiFwt1zcIVDtN8Q13MQkVFQghcB5MmKTp4CxZsk22gRzsGWZaGv1OBzXfDe4vCtDdHzGuOirc8Ip1S8oOk986fd67Ug7h7Q5FiNlJVFr74b//imBKsj9B6MB/kgIit9Bmmr1zNVZ/iptPWFPFFFW1utMzzyd6lcivinfFZNG8b/WzCvm9yL5tr08nOUBz0WswbDWir+gaVsMQHOGZFI3/YfuNb/4BrYRo22mIHuTL2xUfW+Sq9sfE1byRMs5vP71pQaAGJX14znAqH5FLOoaMBeb
 vaM72Ohp
 0x4c8PLpVpDO2F1iilog3QhzQdew30yoy1ZqWSe1e59AalrNSVXGDCXOv7heCPsTPPhYGmbmcqyHf/AYqxWbxGbux3d70KjGQorIrdjjuKrxtVszsoN7Tgl/e3bW078HNpZpE9aTe2qgy1IcJwR43dVt/EDt9IUwuISw25z1E42touenkdXMBMw38rqraein+zQqWeZbI2jFKytdHhO02qD01+zcHV0/6BSFzb721HSDXoa6XTNVGjseaa+lhLG4Lqq3d7ytfLscbmyi3oy4kXyM6jCgRTpc5tQutcZUSrAtBaRISbsoFbHZ07ji2CxrbRz+ZzPqerLPooIenBwb3K8IeZZg0OjCCJ4hZe/J4p0zpm7OzpoAXdpy9ukZyLvhQG5ChccrOK8KQKDltgnW+wkGtEiGHYzXdGUcEdFjDPgiGPVTLE99nlzfWCa0bQ4IJSGcgC8621tGfpBFnCaVrEDHcH5fmWWl82wucSnl8aZMiEPA3gyCBGTJlNfWGFP127T1A8gndRiMmQR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally zswap holds its pools on an RCU list whose head also serves as
the "current pool".  Only a handful of pools are ever live at once, since
a new pool is only created when the compressor is (re)set and pools are
reused across compressor switches.

A later change wants to store a reference to each entry's pool in every
zswap_entry, where a pointer would cost 8 bytes but a small pool index
only one.  To make that index possible, the current change holds the
pools in a fixed ZSWAP_MAX_POOLS-element array so each pool has a stable
slot number, and tracks the current pool with a separate rcu-protected
pointer.

The array keeps the same RCU publish/retire discipline the list had, so
lookup and teardown stay equivalent.  Newly created pools are published
into the array before they become current, so zswap_total_pages() can
observe an empty pool briefly; that is harmless.  This also caps the
number of live pools at ZSWAP_MAX_POOLS (16), which is plenty in
practice; pool creation warns and fails if the array ever fills, and the
limit can be raised.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 21 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4e76a4a87cdc..b203934d3be8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -154,12 +154,20 @@ struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct list_head list;
 	struct work_struct release_work;
 	struct hlist_node node;
+	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+#define ZSWAP_MAX_POOLS 16
+static struct zswap_pool __rcu *zswap_pools[ZSWAP_MAX_POOLS];
+/*
+ * The current pool (NULL if none): an alias of one zswap_pools[] slot.  It
+ * always holds a ref, so it is never retired from under us.
+ */
+static struct zswap_pool __rcu *zswap_current_pool;
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -200,9 +208,7 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
-/* RCU-protected iteration */
-static LIST_HEAD(zswap_pools);
-/* protects zswap_pools list modification */
+/* protects the zswap_pools array and zswap_current_pool */
 static DEFINE_SPINLOCK(zswap_pools_lock);
 /* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
@@ -270,6 +276,25 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	acomp_ctx->buffer = NULL;
 }
 
+static int zswap_pool_reserve_slot(struct zswap_pool *pool)
+{
+	int i, ret = -ENOSPC;
+
+	spin_lock_bh(&zswap_pools_lock);
+	for (i = 0; i < ZSWAP_MAX_POOLS; i++) {
+		if (!rcu_access_pointer(zswap_pools[i])) {
+			/* Set idx before publishing so readers never see it stale. */
+			pool->idx = i;
+			rcu_assign_pointer(zswap_pools[i], pool);
+			ret = i;
+			break;
+		}
+	}
+	spin_unlock_bh(&zswap_pools_lock);
+
+	return ret;
+}
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -313,19 +338,27 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	if (ret)
 		goto cpuhp_add_fail;
 
-	/* being the current pool takes 1 ref; this func expects the
-	 * caller to always add the new pool as the current pool
+	/*
+	 * After a successful create, the caller makes this the current pool.
+	 * If the caller fails, it kills the ref to free the reserved slot.
 	 */
 	ret = percpu_ref_init(&pool->ref, __zswap_pool_empty,
 			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
 	if (ret)
 		goto ref_fail;
-	INIT_LIST_HEAD(&pool->list);
+
+	ret = zswap_pool_reserve_slot(pool);
+	if (ret < 0) {
+		pr_err("cannot create more than %d pools\n", ZSWAP_MAX_POOLS);
+		goto slot_fail;
+	}
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+slot_fail:
+	percpu_ref_exit(&pool->ref);
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
@@ -388,7 +421,7 @@ static void __zswap_pool_release(struct work_struct *work)
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
 
-	/* pool is now off zswap_pools list and has no references. */
+	/* Slot cleared in __zswap_pool_empty(); synchronize_rcu() drained readers. */
 	zswap_pool_destroy(pool);
 }
 
@@ -404,7 +437,11 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	WARN_ON(pool == zswap_pool_current());
 
-	list_del_rcu(&pool->list);
+	/*
+	 * Clear the slot before scheduling the release so new readers cannot
+	 * see it; __zswap_pool_release()'s synchronize_rcu() drains the rest.
+	 */
+	rcu_assign_pointer(zswap_pools[pool->idx], NULL);
 
 	INIT_WORK(&pool->release_work, __zswap_pool_release);
 	schedule_work(&pool->release_work);
@@ -435,7 +472,8 @@ static struct zswap_pool *__zswap_pool_current(void)
 {
 	struct zswap_pool *pool;
 
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	pool = rcu_dereference_check(zswap_current_pool,
+				     lockdep_is_held(&zswap_pools_lock));
 	WARN_ONCE(!pool && zswap_has_pool,
 		  "%s: no page storage pool!\n", __func__);
 
@@ -468,11 +506,14 @@ static struct zswap_pool *zswap_pool_current_get(void)
 static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
+	int i;
 
 	assert_spin_locked(&zswap_pools_lock);
 
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
-		if (strcmp(pool->tfm_name, compressor))
+	for (i = 0; i < ZSWAP_MAX_POOLS; i++) {
+		pool = rcu_dereference_protected(zswap_pools[i],
+					lockdep_is_held(&zswap_pools_lock));
+		if (!pool || strcmp(pool->tfm_name, compressor))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
 		if (!zswap_pool_tryget(pool))
@@ -497,10 +538,14 @@ unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
 	unsigned long total = 0;
+	int i;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		total += zs_get_total_pages(pool->zs_pool);
+	for (i = 0; i < ZSWAP_MAX_POOLS; i++) {
+		pool = rcu_dereference(zswap_pools[i]);
+		if (pool)
+			total += zs_get_total_pages(pool->zs_pool);
+	}
 	rcu_read_unlock();
 
 	return total;
@@ -562,7 +607,6 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	if (pool) {
 		zswap_pool_debug("using existing", pool);
 		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
 	}
 
 	spin_unlock_bh(&zswap_pools_lock);
@@ -589,16 +633,15 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
+		/* The new pool becomes current; drop the ref of the old one. */
 		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 	} else if (pool) {
 		/*
-		 * Add the possibly pre-existing pool to the end of the pools
-		 * list; if it's new (and empty) then it'll be removed and
-		 * destroyed by the put after we drop the lock
+		 * Not current; drop the ref below.  This frees a new pool
+		 * (and its slot), or decommissions a reused one (slot kept).
 		 */
-		list_add_tail_rcu(&pool->list, &zswap_pools);
 		put_pool = pool;
 	}
 
@@ -1763,6 +1806,9 @@ static int zswap_setup(void)
 	struct zswap_pool *pool;
 	int ret;
 
+	/* Slot indices are stored in a u8 (pool->idx). */
+	BUILD_BUG_ON(ZSWAP_MAX_POOLS - 1 > U8_MAX);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
@@ -1793,7 +1839,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {

-- 
2.43.0


