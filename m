Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5043C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 11:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6076B0095; Sun, 30 Aug 2026 07:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9774C6B0096; Sun, 30 Aug 2026 07:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866436B0098; Sun, 30 Aug 2026 07:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0A86B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:47:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D66CB402A2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:47:58 +0000 (UTC)
X-FDA: 85157761836.15.7D4367F
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1A5E7C0009
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:47:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i7lRo7G+;
	spf=pass (imf22.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788090477;
	b=gc4h2jUkVHnhJsgF3yWZb5nKUlXpjPSqVcxfq8hY8NuiVhouDSEkXsv8NNH6oR6+eKfQ+B
	fQACXrMJEyX+fV+tWTtAPjfp2ebQacV3tImEiBkQv7C9Uu2eQkzJEtfvpUHgxpl63hZ2j/
	PVNWKRyqSKwr91eu2tjVWWjZh4VgwP0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i7lRo7G+;
	spf=pass (imf22.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788090477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzS/CUfq1CG/W/aMP1Q7L3GLy6yqyPsMXhDWwjppSfA=;
	b=I9UIvKGEoZXZCzIXCG8BBacThpLCiD5hjz5OxuCksW4tufqwTnWJ7NUeesXjDXDWASKo9r
	affFBQGqbx8u6weaYlNgphh3me+Q7LF4FsRKriDPyMVE4EdNPmCE8w8TKB4C0o1YkQNH/K
	sBx+XcZ1Py6DAifTSvJwwl+NTs9z2bg=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so2602353b3a.2
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090476; x=1788695276; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KzS/CUfq1CG/W/aMP1Q7L3GLy6yqyPsMXhDWwjppSfA=;
        b=i7lRo7G+7B2GaHXkwWwMlNWBq6QLGYFNuCLAWLM9I3yFChaTPxgkVFgN9q9fc3Eqch
         XqUtrEhh1LQF/QqrFe5W4QnSigdEIiMvQ0PBZnor3ycDOsAprCGcAJzCUIXMOeHmd9j1
         vIcNpNhdCGGqkQ/Q8S/Twee2/cV8T/w8al+2o96Z5/v2QE4e1qImRTa/VXmn+EjuKeo2
         fT8lSuutYKBX8kXIEv4iL7MvA5hKojCzWtOAiTSp1LUdSfbLs1HcDmaQ+hzwM/3Xe2UN
         Rsp1i4hDFdGBU+3/Z2q0jpgP0ugdc7vJgiPwXL3xct9E1Trm6acWHwi691ICI4+XB3ow
         /f7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090476; x=1788695276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KzS/CUfq1CG/W/aMP1Q7L3GLy6yqyPsMXhDWwjppSfA=;
        b=M6JG+zakxRyauVyphS0Ue8dTO5jrFilFP9DYV4IgU25I637iHkd5mI86PdtzyOhpKN
         OJCML67gXT2ksFLPlVDj2vhtqwF0n/lh+Ak2gcBw92RSQHtnvmQqVLqqBonUbD3QMuro
         Sy+FhcCWzqfsW6mw/PHiixIC2+Bz6J2kGGNLeCsCUxozfDuoB/9uRGxeVUSAwUvLmx3N
         ZsULffvikXZ8Zs+lpDpzvLCQz/HzMMIBoNHUAnxGBqBtKGrxIYYD5Jd37hl5r1O+ujot
         VYTVsg++KK5iXS1iCi70AeHgwruSr4tyviTpJ55wAbQV14iBk77s1tGJIXokluQcM68J
         +HDg==
X-Forwarded-Encrypted: i=1; AHgh+RrgMiQZwuXlq1wu6/AUxDtGvEa4MnlmKr5eMy+gECmN4A9d/eZVS9hed89yGf+t5hlr16Dn3dt+oA==@kvack.org
X-Gm-Message-State: AFuF++luZ+aOvUddZgwWguHFaK6J32G8Le+tEawwbl8xt8D1eQnOkPbI
	REkrmtfN29Y4aQt3Ud3A94g43MVB1ayXmiKY7lFfEl0FrY29XOza1Qjt
X-Gm-Gg: AR+sD10AlMEAVNP53YQ1ptM2zOSqs3s0wNo/0Ig8gUWIwgWZUL9O3e/BDrS2MJwY2/c
	vTcdjM+Xr3e2lSGIb2gmQaEgKGC32FWtIRLATCPnaHEsWmDd5u7mXfV9DypQ6QC2U0aHV1ojnhb
	nOct/hw8MLhz/jboiKBULuyAHvcq+Bfca5VP3atX64JY94Rjdd3rynlVnIg/g5H+Ujqc9pQ8cPk
	GzEE37bFEvNaV/l2Ft7HhymXsDq0L5DhB3ngzLcinys792P9Z2nqj/57DIuJoH25Wpy6mPAnJK0
	4aQwBfQoD/hepe59EBm5JdpX8aplQrxg+yc0YSuXDeDmR2Kxh+3hYc7Fn8f86yWQMjL3Cj+ECWD
	1XRITcix19R3lHFfStgjflSfjxKqyKdrYfBrrz3PZp1Y3DeZNFMgJDWf6XjF+kVInL/SMeIOfBb
	hSLf+NHYzzNUs9MNxiNSPAeXWOe07qNOFFbGIGETTHv4+jf1PyhJlHy1xM75bFOTbCRoXsPwjja
	nVK7KbYjRQrqnpjI83KWtXAPBQt1fmNwlrl/7hx0nV6ZBPm
X-Received: by 2002:a05:6a00:3311:b0:857:72ba:ff0a with SMTP id d2e1a72fcca58-85772baff9cmr19441422b3a.18.1788090475923;
        Sun, 30 Aug 2026 04:47:55 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([2409:8929:a7b:121:d0e3:2a32:8ea7:5ade])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a397c0a7sm2395264b3a.49.2026.08.30.04.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:47:55 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 2/3] mm/zswap: replace the zswap_pools list with a fixed pools array
Date: Sun, 30 Aug 2026 19:47:30 +0800
Message-ID: <20260830114731.8322-3-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260830114731.8322-1-wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A5E7C0009
X-Stat-Signature: rss1x5zhj41z9kadidggy8967e8wwjpr
X-Rspam-User: 
X-HE-Tag: 1788090477-457663
X-HE-Meta: U2FsdGVkX1+O/TpOhLRcc/6bW7QlkHJR2+B3+jpx3tFptroMrX/KBHm4gzWQpZXFiOA+6R4aNjnJ/Mp5maQzhaGWwYzN7bEYjGvDmGwyDCGhb1+Vn24MpqYL4EfPY71+j8hGBeot+M+hFakWnC14+AhIJKzmzsclaE8PwkyP1luBls8FYxKHpkzD60NTZu/ac6Vy0SRNhGG2j12OSosLJQ8kYL6QpMSlIr3DdmvZviG6/wnBeJNDB+Oy9PywXWlE3FyLFGJ8B3VkA/Ej59SjsVLxm7U/Jqqn0Ju9ujKZYSKrzLPVxLrv8RU7DIe5L3HJ1BwbVJ35uInEGxy9YF/vIkqLiEMMgxA1/YsM3fo+gVcUxx1hBRoOrkdLTP/4mY9eKpfzmWnBwibGwKj9It1EKvJpkl3v7GKZtZIvNGRYIoJF2iLsdZM7KBCASxrBjw7eT2ispoKEljS5VX7Rr/wnAUtaKtCMc20BQ69wnHIRrUzBKIasQedDDD+8PZn+HzIelqbAzAu3vuv95RTbMt4JHiTp/q3uBpjolfpcP5H5lEtKDzVUuAn1Hcr4A1HLmDzjBLnKpjHrhL9UtHUTUllgdwLrtR07TRvbqMRPOl/5jZP+oJG3HbGRbqE26PZpmXzrwiI/gC7ojiaoFw8BZu/QBnkpoOna3oKJqdp+M7g0ApIKqst9lEh/Fg8M5I49e3GEYtKA9RVFfjaMzXaUB33npL/ktH9pqG8N2+jwKjBfrQ/qEPeB/J7y/vkUmDb0pk/jtQ5RBQxt7rzwIXw01ElD+pb8gFFQKQOsg4L1Qm4zOfWSDz0arWXruWD4bIJq8CtW245GsE9CQSFpJetizIpjGSDHvDLjqyDwDZl5MLvWmSzX0h+bo7bJR7B3APN6i4McU3qQGnSHcfEdT337b7MRpiOgmzwGFZQuipihlROu9qb3o5u7TAQcQUvrtJcansVmw+v4D/49B5ful06BQp8
 8CiLFD4D
 tHhzR5tntp8ojnTeuCi3oG8bKbPqlPlghthT6QjISWiHb66Tz7z3qDYdQ8FGNSQdzllkADJJvwJSIBj3oo1CwXvvwZpUPGN0vGG+sZ//xno7RBX3HsWmOJ5ymRzWG/ss9ad1EMbI4P5rcJKRmGKZ/oR865GIfABEDzD6oJEonfO8Zpx6tu+bQxYni9SFD2LbqP8IOkAeOu5AZqoozlXWTAXnpvCGNISIA9XnSZVw+D3emnw18tZOxcnmgoK1+KyrDDfIdlnowHdTgZrxDYw8xp5fzYomYGPNQJn8NifZi0Ou42Rn6OczoQWJksgNeEwEqnY+Wk9KJ/mF4SGdm1Ik5D/WbKeNHO27p6ifzh7a5n7di4t2Wh0hlC6gvPutbxZ8CIXo3dH8QBlqd/GhfswIAUb45gxetpuVNgcPziXbDAqJl7XH+PWvPYko0xXVxw8dVDaWOfEbnho2shjzezSx3W1q8Q7O8HGmopNF1OIo+FcsGPo4PbK1tCoDpi+Opxz3lqpj0fV7XiKpVeY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally zswap holds its pools on an RCU list whose head also serves
as the "current pool". Only a handful of pools are ever live at once,
since a new pool is only created when the compressor is (re)set and
pools are reused across compressor switches.

Hold the pools in a fixed ZSWAP_MAX_POOLS-element array so each pool
has a stable slot number, and track the current pool with a separate
rcu-protected pointer.

Slot 0 is intentionally left unused (always NULL): a zeroed or
incorrectly initialized pool index then resolves to NULL and trips a
WARN rather than silently aliasing a live pool in another slot.

The array keeps the same RCU publish/retire discipline the list had,
so lookup and teardown stay equivalent. A fully-constructed pool is
stored into its slot as the last step of zswap_pool_create(), so array
walkers only ever observe a NULL slot or a ready pool. Pool creation
is serialized by the module-wide kernel param mutex (all built-in
params share one lock) and otherwise only happens during
single-threaded init, so no two creators race for a slot.
zswap_pools_lock still serializes the store against a retiring pool
clearing its slot in __zswap_pool_empty().

Behavior change: the fixed array bounds the number of simultaneously
live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
whereas the old list was unbounded. A pool is only live while it is
the current pool or still has stored pages referencing it, and pools
are reused across compressor switches, so 15 is far more than any real
configuration needs. Once all slots are occupied, creating a pool for
a 16th distinct compressor fails: zswap_pool_create() errors and
returns NULL, and the compressor switch is rejected with -EINVAL
rather than silently succeeding. The cap can be raised by increasing
ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 97 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 25 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0bb30e58950a..b3b5e2887c00 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/highmem.h>
@@ -154,12 +155,27 @@ struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct list_head list;
 	struct rcu_work release_work;
 	struct hlist_node node;
+	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+#define ZSWAP_MAX_POOLS 16
+/*
+ * Slot 0 is intentionally never used: it stays NULL so that a zeroed or
+ * incorrectly initialized pool->idx resolves to NULL (and trips a WARN)
+ * instead of silently aliasing a live pool in another slot.
+ */
+#define ZSWAP_FIRST_POOL_SLOT 1
+static struct zswap_pool __rcu *zswap_pools[ZSWAP_MAX_POOLS];
+static_assert(ZSWAP_MAX_POOLS - 1 <= U8_MAX);
+/*
+ * The current pool (NULL if none): an alias of one zswap_pools[] slot.
+ * It always holds a ref, so a pool is never retired while it is current.
+ */
+static struct zswap_pool __rcu *zswap_current_pool;
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -200,9 +216,6 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
-/* RCU-protected iteration */
-static LIST_HEAD(zswap_pools);
-/* protects zswap_pools list modification */
 static DEFINE_SPINLOCK(zswap_pools_lock);
 /* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
@@ -270,6 +283,31 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	acomp_ctx->buffer = NULL;
 }
 
+/*
+ * Publish a fully-constructed pool into a free array slot.  Pool creation is
+ * serialized by the module-wide kernel param mutex (all built-in params share
+ * one lock) and only otherwise happens during single-threaded init, so no two
+ * creators race for a slot.  The pool is complete before it is stored, and
+ * zswap_pools_lock still serializes this store against a concurrent retiring
+ * pool clearing its slot in __zswap_pool_empty(), so array walkers only ever
+ * observe a NULL slot or a ready pool.
+ */
+static int zswap_pool_assign_slot(struct zswap_pool *pool)
+{
+	int i;
+
+	guard(spinlock_bh)(&zswap_pools_lock);
+	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
+		if (!rcu_access_pointer(zswap_pools[i])) {
+			pool->idx = i;
+			rcu_assign_pointer(zswap_pools[i], pool);
+			return i;
+		}
+	}
+
+	return -ENOSPC;
+}
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -313,19 +351,29 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	if (ret)
 		goto cpuhp_add_fail;
 
-	/* being the current pool takes 1 ref; this func expects the
-	 * caller to always add the new pool as the current pool
+	/*
+	 * The initial ref keeps the pool alive while it is current. Stored
+	 * entries take additional refs so a retired pool remains alive while
+	 * any entries still reference it.
 	 */
 	ret = percpu_ref_init(&pool->ref, __zswap_pool_empty,
 			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
 	if (ret)
 		goto ref_fail;
-	INIT_LIST_HEAD(&pool->list);
+
+	ret = zswap_pool_assign_slot(pool);
+	if (ret < 0) {
+		pr_err("cannot create more than %d pools\n",
+		       ZSWAP_MAX_POOLS - ZSWAP_FIRST_POOL_SLOT);
+		goto slot_fail;
+	}
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+slot_fail:
+	percpu_ref_exit(&pool->ref);
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
@@ -386,7 +434,6 @@ static void __zswap_pool_release(struct work_struct *work)
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
 
-	/* pool is now off zswap_pools list and has no references. */
 	zswap_pool_destroy(pool);
 }
 
@@ -402,7 +449,7 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	WARN_ON(pool == zswap_pool_current());
 
-	list_del_rcu(&pool->list);
+	rcu_assign_pointer(zswap_pools[pool->idx], NULL);
 
 	INIT_RCU_WORK(&pool->release_work, __zswap_pool_release);
 	queue_rcu_work(system_percpu_wq, &pool->release_work);
@@ -433,7 +480,8 @@ static struct zswap_pool *__zswap_pool_current(void)
 {
 	struct zswap_pool *pool;
 
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	pool = rcu_dereference_check(zswap_current_pool,
+				     lockdep_is_held(&zswap_pools_lock));
 	WARN_ONCE(!pool && zswap_has_pool,
 		  "%s: no page storage pool!\n", __func__);
 
@@ -466,11 +514,12 @@ static struct zswap_pool *zswap_pool_current_get(void)
 static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
+	int i;
 
-	assert_spin_locked(&zswap_pools_lock);
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
-		if (strcmp(pool->tfm_name, compressor))
+	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
+		pool = rcu_dereference_protected(zswap_pools[i],
+						 lockdep_is_held(&zswap_pools_lock));
+		if (!pool || strcmp(pool->tfm_name, compressor))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
 		if (!zswap_pool_tryget(pool))
@@ -495,10 +544,14 @@ unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
 	unsigned long total = 0;
+	int i;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		total += zs_get_total_pages(pool->zs_pool);
+	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
+		pool = rcu_dereference(zswap_pools[i]);
+		if (pool)
+			total += zs_get_total_pages(pool->zs_pool);
+	}
 	rcu_read_unlock();
 
 	return total;
@@ -560,7 +613,6 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	if (pool) {
 		zswap_pool_debug("using existing", pool);
 		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
 	}
 
 	spin_unlock_bh(&zswap_pools_lock);
@@ -588,15 +640,9 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 
 	if (!ret) {
 		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 	} else if (pool) {
-		/*
-		 * Add the possibly pre-existing pool to the end of the pools
-		 * list; if it's new (and empty) then it'll be removed and
-		 * destroyed by the put after we drop the lock
-		 */
-		list_add_tail_rcu(&pool->list, &zswap_pools);
 		put_pool = pool;
 	}
 
@@ -1801,7 +1847,8 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		/* zswap_pool_create() already stored the pool in its array slot. */
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {
-- 
2.43.0


