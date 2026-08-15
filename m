Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C45CC5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7796B04CD; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190686B075A; Sat, 15 Aug 2026 02:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FA76B07A2; Sat, 15 Aug 2026 02:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78D696B04CD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:54:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAA5EC02F1
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:23 +0000 (UTC)
X-FDA: 85102590006.14.F703E7E
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 119F9180004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jWH7FuZ9;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786776862;
	b=Y+BO4vJZJ0Fsv4Xx5hnvYqg2xICz7pE5CXXqdJRb+0yE8C8QVw413yw4yK4Y8Myh/m9mHI
	Jj50/ED8XdU7/snapxg6Y0JVh1sb2f3iwt9WvVhOkvkTtuiz2hqL6r6ZStF9BQM1ecsquQ
	ocF3ZeprbPUuT6bnEiIUo2tZLWbEyzo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jWH7FuZ9;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786776862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L88HWI4nOnXjNaN6Z4WUAG6hZj/n7nHW2N2BDrBtNXg=;
	b=FGVTHqPA33i4nXuoxb9R2krOMKlvOpTy3PndjZa5IBL7ofLiZMTVIM5fv1Dy7ZJ56somNp
	Z9T06BLJtF4qjiwJ+HrlwHt1kpT6RUyK26H3TeuZxnNVUnQEKpmCM1b/ODAsnuVplI0CDw
	3G7Kc644eDBcT4DCokdxpwqr5thZCtk=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-381b831d535so2756989a91.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786776861; x=1787381661; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L88HWI4nOnXjNaN6Z4WUAG6hZj/n7nHW2N2BDrBtNXg=;
        b=jWH7FuZ9rY04MapN9+fQLVfzXmgZSrKzM1r9YhTnkQkS7GmVjYFRD67w9fa2oyw38/
         osg/GMDH33ZuFohkj7zJDUuPn8Q16kMqFWyAle7WqW9pM77zkhGmg7U2Ls3up8/5Fkaa
         n7GRl4ZbmxbPFFOVTDBHfBlhGZAi9nSAiI9Wp9BvTD7Zn6Ta78HZUwChRm3njA+sq7AF
         ifeyqsBtBqSONrVbSI2KhGBaZKE0zko+k6ud1ZS8IiPgO35KDONMhaycNIz5exH/W6UI
         xGV0V7yNdfpXiUKm2W9Kwx2Y4xMuR1LAoN0g8HKoAY3szNYdXY/hnU757D5GCyH2eyRX
         VNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786776861; x=1787381661;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L88HWI4nOnXjNaN6Z4WUAG6hZj/n7nHW2N2BDrBtNXg=;
        b=eyjOLpA7YsJuqNzBX794iO0wrDmtVjjOav5TsBp+/qcuz6uFYRTBcIzbgYVRHd7kH9
         aitbwnwLhUwTe4l2u/usXdRd5gzmd4bo76WxXXL1/gxsPiBDetMWZIKNB8DIZ9NDAsu1
         wqq5qIm/PgWi8Vy9YxXBW/bGTZY+vOtFKSkr6G8iBrva1kCaCiWsRwBep3UeB2YrYRIb
         bg0J2wuvFs0KsvaXnsN5p1thuxEUHP2X2kyGahkAVvOglKWvPizisWnCMPUbIuFaSm+A
         H4lLOyDx+tn+qRQdqpMXC6QMt0kgOELx5WJgFJVRUxZ7Z16JCL3092A7WObe7LpApXSu
         5VFg==
X-Forwarded-Encrypted: i=1; AHgh+Rrk7iwKttpiqDTL2tMAT9Sxtq4J/1C1TI+Wm7SxC519pmTL9u9dImMZzOj6ku1MbM6y/VF0fY7MHQ==@kvack.org
X-Gm-Message-State: AOJu0YyDLu4M3juo/KAyUs9pKyPUXsIr6R5hMi43Iu1gtODvVEexeB0u
	cS9blrEW4/NsPUaVxeUtr4pyTf3cVdNUGj2/BmYlKVS97wJxYthTGR8VxA2tJB5P
X-Gm-Gg: AR+sD10wFfqkcVrxhs76ZkpyQrPPfKNb8diRN6wkBxUpPBlg9V2LPMBb3VkmtQM9QmE
	6DSQrxM72PmxgxnaXxMOVNTivUtPmOrgUbPRh1Tlx3xGdlbtk2lcMHhNJd/tnCll4RX6O7EQk6s
	IdJXMC4msVyt89Yfs3MafHZTCe6bFYNJXxpgnD5ajXXQFfD7sxNdwTLe/dv2MIVsZMAtuMEKNK7
	j7tA4kFCN6pL/i1RGMlYmGlvFHIXjJPhdWnC3RGsYC5WDM/dV8svOnD1JncEclo+2RhHExq6zxP
	22wJ2uYrzBCcTwYYi/DWPUmuPu48NQ/f723IgRyokz0a89ByrP6VshsJmviP0p87BBRbkPJqmec
	HCpVoXfFDGfnLPs4PGg1h7ARswnnW1k4rzPk0GvvgsSqrMX06NqvUtAjwQSbLPArH7H1OVoS5IH
	/gmWUKoZjknKnUxAI2V4UJfV6CvpBmj4gp/Ib2lZHw3/kZ/Sd+z48afuxX19mlGAq5abVfIWfJK
	VhuBeWH7uIF9brN8kwoWOCPt/A3Pr3o9az38Ac=
X-Received: by 2002:a17:90b:4cc4:b0:38e:101f:c867 with SMTP id 98e67ed59e1d1-3933b927a55mr13212040a91.18.1786776860731;
        Fri, 14 Aug 2026 23:54:20 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eb752fe2sm5691360a91.14.2026.08.14.23.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 23:54:20 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sat, 15 Aug 2026 14:54:08 +0800
Subject: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
In-Reply-To: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 119F9180004
X-Rspam-User: 
X-Stat-Signature: 3mafheqrte44899qekskmgkwmo6g8xxa
X-Rspamd-Server: rspam06
X-HE-Tag: 1786776861-344969
X-HE-Meta: U2FsdGVkX19x5mgzY1Xgca2ocy9YNHFUomuRfwwEiQR6hQ5RuUYPfo7QVLyA3Qgc+Z/9BwGTkcUxvYoMNohCGN0nWtLCWPk29swX1jBrl5Tm5tiaXVKxZF8bYyNtNaC+vF2Mo8wNzZsTWS7MkHK+Xo3rOx+OqaBfo3HAyqHy0AbzMn7VusRoSbTGQEyxWEmhVVYOAjDtGSOTMXC8+cVcBnqKSmgRVFH4R0QKiveuykgV0ZzfBDbesQgNQMVRo2WTwJe5wpO2JfYOTQlRlT8iUvurgqyQFT8sLg6i8SbXSIQa+OPeQglB2gQzqF2WF5sybEiGzP84PQh4Q8mfdWy7BjhvOA6CLCCsBUztanlOTvxTzcd0Ur+b4Uvk9pstGBh3OV3HSuAALUoKlbg3fl5NXGajJj++219R1r5U0gM0FWHPiRBAHrPj2J3V1zbt2fAGKrv/g3XeYy6nSx40LzRro1do89aFH5qdM4Vq2Ur8dcRwjjxWIqoaUfIbRM4Q9uhq6BbJSwWuna3wx9/Ys31iKGnvqWtXmmBOCHwDpGZySjungT0mXb6pFANylZJ/ULQ1sV4RLqZCCKQTJJYcRDnNZiD4kSnMmUD8tkVY2bZXNW2St8A0vs002LrJn+wS9loUgT2mMHnMnimktCiPl4gyeyM/1Vy2upt9AE8TM5J6meheJerTDsA1EW1z0OS7z3Lbssjib2cR0cnMKAUXV5oAK1GqrKb2zPPgbKYSVxqzlG3hI7xbYp5Fm6qLie6MtL7tCBWmbPQTOz5ZpbqNy2dmn8+/YEHh3UpvVJxERIbWOTqWzp5JoTw5xktir7nDvMP00x+MklV8LZFe9Uo4PVerO19tuMztRoSR3ICjigNMbl7q5ktZt+/Sl0laad8h/aAHlZ44EKUeEltEIqafHgi1Eoj2k5kfsWS7/hz80E28YZzvQ90as7Zh+SgTsg4X4Q7m97cxBesMDsePWOafU5i
 tO79yz7V
 B1IUNwjg1dzBzh1CFIX4xT7ZN8m/F5e5+UyXvjGbIk/ucc85WtUkqE7Gl9zyIWIEPbh5+tkR4GTCfeQ++qwqmlLanZ07RLOXRkxg8pn7hJSl1FqQdmbhzEEkGw7qX7wVXlL/twoF+3r7mDwKpZ+OL1EicAgiihQacOElQvPfffEaqgQuRofuoDNhY7oVtBMbBAMbYHWivnvRitpYVNdGOVCsiLF0F37pW/DNexHGwYw94yb+Beyn8XSHPiVGquet1lL9tjjJYrDC6Xrfq6HoDhXz4Qrv8Et78nnJjAdF/GUJHdIjr4/QA9KlwwPfSlEKkfyDHGAisF8/Zf8mhNtqsxMtwWi0ux/9bONxXh/aqk5Ni2m0J5u5qI4PBpQ6MVkZi38PkCLOre+WVSgSB310ToAck29APP3sitmyOg96paqPzsqeTB852b9AP9rZ8VmqURpZCuMP7W3lywEBsOaXj9uMFCYHJ2TwSm+uxSHGpPZJxTIm3D5UjE/3mhbNZoRRRANH+6AW3yrBZ/BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally zswap holds its pools on an RCU list whose head also serves
as the "current pool".  Only a handful of pools are ever live at once,
since a new pool is only created when the compressor is (re)set and
pools are reused across compressor switches.

Hold the pools in a fixed ZSWAP_MAX_POOLS-element array so each pool
has a stable slot number, and track the current pool with a separate
rcu-protected pointer.

Slot 0 is intentionally left unused (always NULL): a zeroed or
incorrectly initialized pool index then resolves to NULL and trips a
WARN rather than silently aliasing a live pool in another slot.

The array keeps the same RCU publish/retire discipline the list had,
so lookup and teardown stay equivalent.  A pool first reserves its
slot with a placeholder marker and only stores the real pointer once
it is committed as the current pool, so array walkers never observe a
not-yet-ready pool as live.

Behavior change: the fixed array bounds the number of simultaneously
live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
whereas the old list was unbounded.  A pool is only live while it is
the current pool or still has stored pages referencing it, and pools
are reused across compressor switches, so 15 is far more than any real
configuration needs.  Once all slots are occupied, creating a pool for
a 16th distinct compressor fails: zswap_pool_create() errors and
returns NULL, and the compressor switch is rejected with -EINVAL
rather than silently succeeding.  The cap can be raised by increasing
ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 114 insertions(+), 26 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cc4243356e21..603fdc418041 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/highmem.h>
@@ -154,13 +155,42 @@ struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct list_head list;
 	struct rcu_head rcu_head;
 	struct work_struct release_work;
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
+/*
+ * A slot placeholder used to reserve an index before the pool is committed.
+ * A reserving pool publishes this marker first and only stores the real
+ * pointer once it is ready to become current; walkers of zswap_pools[] treat
+ * a reserved slot as empty and skip it, so a not-yet-ready pool is never
+ * observed as live.
+ */
+#define ZSWAP_SLOT_RESERVED ((struct zswap_pool *)-1UL)
+
+static inline bool zswap_slot_is_pool(struct zswap_pool *pool)
+{
+	return pool && pool != ZSWAP_SLOT_RESERVED;
+}
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -201,9 +231,7 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
-/* RCU-protected iteration */
-static LIST_HEAD(zswap_pools);
-/* protects zswap_pools list modification */
+/* protects the zswap_pools array and zswap_current_pool */
 static DEFINE_SPINLOCK(zswap_pools_lock);
 /* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
@@ -271,6 +299,40 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	acomp_ctx->buffer = NULL;
 }
 
+static int zswap_pool_reserve_slot(struct zswap_pool *pool)
+{
+	int i;
+
+	guard(spinlock_bh)(&zswap_pools_lock);
+	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
+		if (!rcu_access_pointer(zswap_pools[i])) {
+			/*
+			 * Reserve the slot with a placeholder rather than the
+			 * pool itself: the pool is not ready to be current yet
+			 * and must not be observed as live by array walkers.
+			 * Set idx before publishing so readers never see it
+			 * stale.  zswap_pool_publish_slot() stores the real
+			 * pointer once the pool is committed.
+			 */
+			pool->idx = i;
+			rcu_assign_pointer(zswap_pools[i], ZSWAP_SLOT_RESERVED);
+			return i;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static void zswap_pool_publish_slot(struct zswap_pool *pool)
+{
+	assert_spin_locked(&zswap_pools_lock);
+
+	if (rcu_dereference_protected(zswap_pools[pool->idx],
+				      lockdep_is_held(&zswap_pools_lock)) ==
+	    ZSWAP_SLOT_RESERVED)
+		rcu_assign_pointer(zswap_pools[pool->idx], pool);
+}
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -314,19 +376,28 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	if (ret)
 		goto cpuhp_add_fail;
 
-	/* being the current pool takes 1 ref; this func expects the
-	 * caller to always add the new pool as the current pool
+	/*
+	 * The initial ref is for the current-pool role.  On success the
+	 * caller must install this pool as the current pool.
 	 */
 	ret = percpu_ref_init(&pool->ref, __zswap_pool_empty,
 			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
 	if (ret)
 		goto ref_fail;
-	INIT_LIST_HEAD(&pool->list);
+
+	ret = zswap_pool_reserve_slot(pool);
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
 
@@ -387,7 +458,7 @@ static void __zswap_pool_release(struct work_struct *work)
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
 
-	/* pool is now off zswap_pools list and has no references. */
+	/* readers drained by the grace period */
 	zswap_pool_destroy(pool);
 }
 
@@ -397,9 +468,9 @@ static void __zswap_pool_release_rcu(struct rcu_head *head)
 
 	/*
 	 * The grace period has elapsed, so no RCU reader can still observe the
-	 * pool through the list it was removed from in __zswap_pool_empty().
-	 * Hand off to a worker for the sleepable teardown, since this callback
-	 * runs in softirq context.
+	 * pool through the array slot cleared in __zswap_pool_empty().  Hand off
+	 * to a worker for the sleepable teardown, since this callback runs in
+	 * softirq context.
 	 */
 	INIT_WORK(&pool->release_work, __zswap_pool_release);
 	schedule_work(&pool->release_work);
@@ -417,7 +488,13 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	WARN_ON(pool == zswap_pool_current());
 
-	list_del_rcu(&pool->list);
+	/*
+	 * Clear the slot before retiring the pool so new readers cannot see
+	 * it; the call_rcu() below drains readers that already observed it.
+	 * The slot may still hold the ZSWAP_SLOT_RESERVED placeholder if the
+	 * pool is torn down before it was ever published as current.
+	 */
+	rcu_assign_pointer(zswap_pools[pool->idx], NULL);
 
 	call_rcu(&pool->rcu_head, __zswap_pool_release_rcu);
 
@@ -447,7 +524,8 @@ static struct zswap_pool *__zswap_pool_current(void)
 {
 	struct zswap_pool *pool;
 
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	pool = rcu_dereference_check(zswap_current_pool,
+				     lockdep_is_held(&zswap_pools_lock));
 	WARN_ONCE(!pool && zswap_has_pool,
 		  "%s: no page storage pool!\n", __func__);
 
@@ -480,11 +558,15 @@ static struct zswap_pool *zswap_pool_current_get(void)
 static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
+	int i;
 
 	assert_spin_locked(&zswap_pools_lock);
 
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
-		if (strcmp(pool->tfm_name, compressor))
+	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
+		pool = rcu_dereference_protected(zswap_pools[i],
+						 lockdep_is_held(&zswap_pools_lock));
+		if (!zswap_slot_is_pool(pool) ||
+		    strcmp(pool->tfm_name, compressor))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
 		if (!zswap_pool_tryget(pool))
@@ -509,10 +591,14 @@ unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
 	unsigned long total = 0;
+	int i;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		total += zs_get_total_pages(pool->zs_pool);
+	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
+		pool = rcu_dereference(zswap_pools[i]);
+		if (zswap_slot_is_pool(pool))
+			total += zs_get_total_pages(pool->zs_pool);
+	}
 	rcu_read_unlock();
 
 	return total;
@@ -574,7 +660,6 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	if (pool) {
 		zswap_pool_debug("using existing", pool);
 		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
 	}
 
 	spin_unlock_bh(&zswap_pools_lock);
@@ -601,16 +686,16 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
+		/*
+		 * Remember the old current, then publish the new pool into its
+		 * slot before making it current: array walkers must never see
+		 * the current pool as a reserved (not-yet-ready) slot.
+		 */
 		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
+		zswap_pool_publish_slot(pool);
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
 
@@ -1815,7 +1900,10 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		spin_lock_bh(&zswap_pools_lock);
+		zswap_pool_publish_slot(pool);
+		rcu_assign_pointer(zswap_current_pool, pool);
+		spin_unlock_bh(&zswap_pools_lock);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {

-- 
2.43.0


