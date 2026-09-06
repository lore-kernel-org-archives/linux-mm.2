Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C928EC79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 07:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8BB6B0092; Sun,  6 Sep 2026 03:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFAE6B0095; Sun,  6 Sep 2026 03:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E8D6B0096; Sun,  6 Sep 2026 03:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECC866B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:47:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7965D160495
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:35 +0000 (UTC)
X-FDA: 85182557670.23.191DF52
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9234D14000A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lM7YeZZT;
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788680853;
	b=1Gw0cRS9lFW66VZmw/6vB27GYdSpuAMWCtG7ZfnzOfhci+EsOdifN/RxZVqiZ1VYiO0f4v
	/RsmZIjVJU6/UEKXIkPhWhS25eSa2hctW9Bk8bZrh0gG6or5WCxOfsPv4LRYYcGTBIvyaq
	tnwCXxCHTZCyyqP/Wg9cwwAtuOhnf0o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788680853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSsjcm7x9xAs+BmsWITo2dM5yWR0ym8L3hhdvVcy4pM=;
	b=bW1gbU6kwnGHrPqcsa+Q/lkJ4jFu08qpOZq2jdj5VE/jF70pRsc1LKeHFsxpzUQnFzRJLl
	wUKiZl2wEYomnF/YZAo2dSc6fjlVaS/LL8OvNEcz9lI4YxJe8uOnt9QGTILbUsiZFIyPI8
	+LBpYwRy0psFufFrBgp7lkXKu2nYBO0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lM7YeZZT;
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39b52169dacso360948a91.3
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 00:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788680852; x=1789285652; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MSsjcm7x9xAs+BmsWITo2dM5yWR0ym8L3hhdvVcy4pM=;
        b=lM7YeZZTTiEn/eZEVXw/lJwa2avR5/LDfhz6SCCX9jySu2AziEFQbR7qhId6XUlQGN
         5HHhYDh8u6Dhpy+ko6av2UzdQjkccg0a7O6quFPIwYLeteoBhTqYkgdR/ns+hOisLoo5
         pMzF7qkjhfs9IPLoNDJMBe7uQVqxy9xQRwdQ0JB8jnbNb6fpFgTQ1Regjp3Hm9y7KQ28
         McnZRM6YS18exnFVgtiANgOGGIPrCzJX1ljUXhiXTvSwco5Kl1brI/G50psCVxTcmP8s
         XhMv3ILhRdZWlFYNSUt/hhH5CuEB3jYTvYy7OBE5z/5llsEIE0lZj9UmKIirZ2SnOYw1
         NReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788680852; x=1789285652;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MSsjcm7x9xAs+BmsWITo2dM5yWR0ym8L3hhdvVcy4pM=;
        b=fPumfuZvkpaxjeKW0orhTDAbAPAByBRe37uVldz8rQQSpeJ1wX0tWXlH5O7OU+4LRp
         ad392Wvf6rjPT/OLtgcz1P4TzPC3uH/KnXffN19B3VuZ/WvK1rAPhiYAaj8rIuG2DuGI
         yOIrv1+wwhjpdQTBJ5ynp1I3D++D8idSKs/oE7kApXJWMiI/urEiMoNjwMvEUK/l9+Bc
         xNX+rIWUJ13287QuSeun3yVe8a28a4T8BEb0WGxj9UXTNOBhQZE4hmPaXmtA9y+ab+eb
         +LJ0xb9o4g8cNz6jGwwVapHpJ7+U5P1Q5qHcfBtHrkr9dUK8lyacsOESwL9dnlqpTanV
         wPNw==
X-Forwarded-Encrypted: i=1; AKwUvBzk7GMJcjrnBlpBjiAwgMKNDtxlUMWc2VVYJZ89vjpUKvaV1D53kLG2chYPP0zvbYWVbGusS8b1kg==@kvack.org
X-Gm-Message-State: AFuF++nOLQLGmHeOWnSGyHrgauO+FCY3hBQSmHNywS14Wi7e+pKBbBhj
	ME5pRTjNgSTAi7aJT43lRO/MCxdBq0HVkKg7+mERJSBpwrgUpzmos8rZ
X-Gm-Gg: AYBFou3hvD00OhIObVlDD0uOw7Xc1C0V/Af4ts0RyFvfcLTdquTivUB1e2MdQ66G/9x
	Ouzp1wGTCDDrvq68TIfrIgkxKR7FOvA1OyxH1hDNNq0v39/tXvweAnRLb5k+JrXSopKODF9KaxZ
	Bs6s7BXr1GNb2KatjkAaXZzNg6RJMVE3uytKmBAQOvL0faUNurMGbggi3Tbq0EOdT9fVOn/oltf
	BZqRD7s3WCZEzZXuv36Zz/AqgJPFc7ikl0fLyljuxgx4lAfnC/8U8t8L5Vx36601a5aUPYncOFi
	uG7tvw6N59sHCI4B6/ZNa2pNzetR40RLbrjkUfu00uoNgf+pkJHKUcTTQ7ckfBekyom31EBDPpZ
	/23c+JM+hgfj/vPmyxiSEwj0Rj2czlKJAfB04mcBYU/SER263kzNBEZuVFDhAwCLqDhhTPFcGLY
	+49Yss2J3j8EUfcWerWGlNsdcyCXxZqKZoRxkjxQf2iTBSX4eY5IomCDMZskf/jZ6c4UOQWpaZL
	OGqtxv5l3Qs9oaxMqkjukfjqA7Kkoq4Orx//Jw3pOpoeYK/IA==
X-Received: by 2002:a17:90b:258d:b0:396:4c63:7193 with SMTP id 98e67ed59e1d1-39b261323e0mr26485339a91.11.1788680852316;
        Sun, 06 Sep 2026 00:47:32 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm21138905a91.16.2026.09.06.00.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 00:47:31 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 06 Sep 2026 15:47:18 +0800
Subject: [PATCH v6 2/3] mm/zswap: replace the zswap_pools list with an
 allocating xarray
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-shrink_zswap_entry_v6-v6-2-ac4cf61565fb@gmail.com>
References: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
In-Reply-To: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1788680840; l=9534;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=oQTcMqmcb2ykFzgNObCXJvjBT9oiNdBbL6CkFLTxCy4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKM3EjzeMxLVbtS5O6J8JsvkhCt4itR5BM71w/fYDp6FCcf8nTgvx/WAI9XZAZDDZi450SCQKHM
 J1JIWeuEL9gY=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9234D14000A
X-Stat-Signature: 5hnnc34ge58tewkjs9sbiweptt57y6k3
X-HE-Tag: 1788680853-846565
X-HE-Meta: U2FsdGVkX19j6aiY4i94ISpdjoP0dnpZIjPbiFSEBXB7BfBABTulOCZqpSbO5QQ4vxbj7vwiwFi5EFVhLnwkibAYdGnYRw/ODL62dlBrlf84cnf/bhlKSm9WJ9VT4eb+6b0c2+JUyxCFPuuXA2+bkNrtEMOwcqKXvD4hki+uAbCRIicrJSdmMxAvBceHQw0imUM9sRbeRYust2YfCnnbMa6uy2kV7FLXEVqID9QTAL4EsezsmLHCtmVBw7pROpxqIlgPyzwAHr90Obculc77L7SKunrvqcOKQEe/ZZ7+XTNeliSQuUP9/kLx3ewsk36uWbOkPpK3vS6AnolwqXk8TJzgnB8ESJ0tgmSQsRdK9Qt8BZ++L6opf4yzEa4bEzX+DMt7ZUn1vi0pRK4Rd3vHcB0Z5jxVMsN44g59IMoUWSO45ZKpIRfSOmr1luGbPAlICpk9HMZEZdCTjUAV0lLKosC/vgzPRm+21b6WfxeeKlmw+QJlKPL/Pz212MlFwwj0SFOb4+Pho+iUeQb6R38CvyZsLtKh38cYeLhpVN+nFyODqOxjiZM9lDOxu7rxvZSayeSBSk5t/MMsnm0qIp7bJfm2SOzCPNxQ1Vr5uPAaYir3A6VMu0e3zYNB9fXGgzA1+dcXgriCayeszN5gDX4YFdjm2Y9GwP8jOAtHHxHzFN5phGVJM6/yV083hNj4O1zQVpZekonHe7vf/v0y3J1NJbcxhA7IDq72hQ++NHaHNzLG+lpNDgI3Bwkln1tB0Ka90wIBtURdzQQF7d8wVhYkW/9MeMhuR6Fk6nvrYOXOLAE08jhIVZZcaRwoiLUDSPm0rHf+MGcxV9Zw1fCaRDImXjqDePAcoTH2gvC9mJ/Xt4dojR9opD+73kOCS+RArGNETg5X+5qHAUZis+30zC4r6EKOgpklQjAqDuZcni4cBVsOJQRN7t8MBDIod2F8HmGHjqKek9dWL81o7/BfHxr
 dcZHc9EP
 aAjwvb98JwLEG91RGbq0A+2DDG7wIIqcTkvIwYPByV6tF2aXe0LUJdep1rrN9ZtI1uB0/CVahUr2+mZiVx16zxBfLdPQG7FgHh27Whsf5/YHgy9Rdv99iJFg+TKSDrOiUu6g3Fm9sEIOUTP7fQVcD6Wv7h1CdQkg5XJ8WsXyf37GKoYPZE8Lib8pV4NDwooHPC94YF+am3kVE9XzkSv1xatpxGf+hVAHbhk3wOUU2DIzL05c32Tt2PeFrpbpj8D4wuxgaZiT9ySxskcDVEz1IUp9dW7rVwsqfdE4Awd98fQRh5bhczkBufqZvwt71SNGmQMz2hVjTn3vnRUTQTrTotsdlv6qXqU4ZC5VRFZOGnMIQ62HHzbFPHmkvAK66PRf672kKUh9fXTGLeczScNccD0IxvtIJEriUnOAgD3bJ4TiXlGcDFLzNvili9JCQ/vhU5HgpynqTUOXE7nfrIFxswJOOaVXjum/JEfEqyZZjvGt3rAOqyiRuc/Ytpdy2dopLi4l/K/mcvIkAucqwxOPWqYGd7Ltgp6Qd1yaVYUNB+9wswZPoK0hfh/aXj99wvgCWKTXSdeDPz0fgvW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally zswap kept its pools on an RCU list whose head also served
as the current pool. Convert the pool table to an allocating xarray
keyed by a small integer id, and track the current pool with a separate
RCU-protected pointer.

The xarray gives each pool a stable id for a later zswap_entry shrink.
XA_FLAGS_ALLOC1 starts ids at 1, so id 0 remains reserved. The id range
is bounded by ZSWAP_MAX_POOL_ID because the later entry field is a u8.

Keep compressor switching close to the previous flow: look up an
existing pool with xa_for_each(), resurrect it if reused, or create a
new one. zswap_pool_create() allocates the pool's id and publishes it
into the xarray as its final step, so the create call either fully
publishes or fully unwinds on failure. Publishing makes the pool live,
so a caller that later fails (e.g. param_set_charp()) must still kill
the pool to erase it from the xarray.

Compressor switches update zswap_current_pool with rcu_assign_pointer(),
serialized by the module parameter lock, so no xa_lock is needed for
that update. The pool walk above is lockless under RCU. xa_lock is taken
only to allocate (xa_alloc_bh()) and erase (xa_erase_bh()) xarray
entries.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 122 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 66 insertions(+), 56 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e456e5080531..86db023d63ed 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -34,6 +34,7 @@
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 #include <linux/list_lru.h>
 #include <linux/zsmalloc.h>
 
@@ -154,12 +155,23 @@ struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct list_head list;
 	struct rcu_work release_rwork;
 	struct hlist_node node;
+	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+/*
+ * Live pools keyed by id (1..ZSWAP_MAX_POOL_ID).  XA_FLAGS_ALLOC1 keeps id 0
+ * reserved so it is never handed to a live pool.  XA_FLAGS_LOCK_BH makes the
+ * xa_lock softirq-safe: it is taken from __zswap_pool_empty(), which runs from
+ * a percpu_ref release callback in softirq context.
+ */
+#define ZSWAP_FIRST_POOL_ID 1
+#define ZSWAP_MAX_POOL_ID U8_MAX
+static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
+static struct zswap_pool __rcu *zswap_current_pool;
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -200,10 +212,6 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
-/* RCU-protected iteration */
-static LIST_HEAD(zswap_pools);
-/* protects zswap_pools list modification */
-static DEFINE_SPINLOCK(zswap_pools_lock);
 /* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
@@ -275,6 +283,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	int ret, cpu;
+	u32 id;
 
 	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
 		return NULL;
@@ -320,12 +329,29 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
 	if (ret)
 		goto ref_fail;
-	INIT_LIST_HEAD(&pool->list);
+
+	/*
+	 * Publish only after the pool is fully built, so lockless walkers
+	 * never see a half-initialized pool.  The _bh variant pairs with the
+	 * softirq-context xa_lock taken in __zswap_pool_empty().
+	 */
+	ret = xa_alloc_bh(&zswap_pools, &id, pool,
+			  XA_LIMIT(ZSWAP_FIRST_POOL_ID, ZSWAP_MAX_POOL_ID),
+			  GFP_KERNEL);
+	if (ret) {
+		if (ret == -EBUSY)
+			pr_err("cannot allocate pool id (max %d live pools)\n",
+			       ZSWAP_MAX_POOL_ID - ZSWAP_FIRST_POOL_ID + 1);
+		goto xa_fail;
+	}
+	pool->idx = id;
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+xa_fail:
+	percpu_ref_exit(&pool->ref);
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
@@ -386,28 +412,22 @@ static void __zswap_pool_release(struct work_struct *work)
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
 
-	/* pool is now off zswap_pools list and has no references. */
+	/* The pool is no longer in zswap_pools and has no references. */
 	zswap_pool_destroy(pool);
 }
 
-static struct zswap_pool *zswap_pool_current(void);
-
 static void __zswap_pool_empty(struct percpu_ref *ref)
 {
 	struct zswap_pool *pool;
 
 	pool = container_of(ref, typeof(*pool), ref);
 
-	spin_lock_bh(&zswap_pools_lock);
-
-	WARN_ON(pool == zswap_pool_current());
+	WARN_ON(pool == rcu_access_pointer(zswap_current_pool));
 
-	list_del_rcu(&pool->list);
+	xa_erase_bh(&zswap_pools, pool->idx);
 
 	INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
 	queue_rcu_work(system_percpu_wq, &pool->release_rwork);
-
-	spin_unlock_bh(&zswap_pools_lock);
 }
 
 static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
@@ -433,20 +453,13 @@ static struct zswap_pool *__zswap_pool_current(void)
 {
 	struct zswap_pool *pool;
 
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	pool = rcu_dereference(zswap_current_pool);
 	WARN_ONCE(!pool && zswap_has_pool,
 		  "%s: no page storage pool!\n", __func__);
 
 	return pool;
 }
 
-static struct zswap_pool *zswap_pool_current(void)
-{
-	assert_spin_locked(&zswap_pools_lock);
-
-	return __zswap_pool_current();
-}
-
 static struct zswap_pool *zswap_pool_current_get(void)
 {
 	struct zswap_pool *pool;
@@ -462,23 +475,28 @@ static struct zswap_pool *zswap_pool_current_get(void)
 	return pool;
 }
 
-/* type and compressor must be null-terminated */
+/* compressor must be null-terminated */
 static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
+	unsigned long id;
 
-	assert_spin_locked(&zswap_pools_lock);
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
+	/*
+	 * __zswap_pool_empty() can erase from zswap_pools in softirq while we
+	 * walk.  rcu_read_lock() keeps the walk consistent and each pool alive
+	 * across tryget().  xa_for_each()'s own RCU does not span the loop body.
+	 */
+	rcu_read_lock();
+	xa_for_each(&zswap_pools, id, pool) {
 		if (strcmp(pool->tfm_name, compressor))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
-		if (!zswap_pool_tryget(pool))
-			continue;
-		return pool;
+		if (zswap_pool_tryget(pool))
+			break;
 	}
+	rcu_read_unlock();
 
-	return NULL;
+	return pool;
 }
 
 static unsigned long zswap_max_pages(void)
@@ -495,9 +513,14 @@ unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
 	unsigned long total = 0;
+	unsigned long id;
 
+	/*
+	 * rcu_read_lock() keeps each pool alive across zs_get_total_pages().
+	 * xa_for_each()'s own RCU does not span the loop body.
+	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
+	xa_for_each(&zswap_pools, id, pool)
 		total += zs_get_total_pages(pool->zs_pool);
 	rcu_read_unlock();
 
@@ -554,20 +577,13 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 		return -ENOENT;
 	}
 
-	spin_lock_bh(&zswap_pools_lock);
-
 	pool = zswap_pool_find_get(s);
-	if (pool) {
+	if (!pool) {
+		pool = zswap_pool_create(s);
+	} else {
 		zswap_pool_debug("using existing", pool);
-		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
-	}
-
-	spin_unlock_bh(&zswap_pools_lock);
+		WARN_ON(pool == rcu_access_pointer(zswap_current_pool));
 
-	if (!pool)
-		pool = zswap_pool_create(s);
-	else {
 		/*
 		 * Restore the initial ref dropped by percpu_ref_kill()
 		 * when the pool was decommissioned and switch it again
@@ -584,24 +600,18 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	else
 		ret = -EINVAL;
 
-	spin_lock_bh(&zswap_pools_lock);
-
+	/*
+	 * Compressor switches are serialized by the kernel param lock, so this
+	 * is the only writer of zswap_current_pool: no xa_lock needed.
+	 */
 	if (!ret) {
-		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
+		put_pool = rcu_access_pointer(zswap_current_pool);
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
 
-	spin_unlock_bh(&zswap_pools_lock);
-
 	/*
 	 * Drop the ref from either the old current pool,
 	 * or the new pool we failed to add
@@ -1788,7 +1798,7 @@ static int zswap_setup(void)
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


