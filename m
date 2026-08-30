Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63ABAC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 11:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8185E6B0096; Sun, 30 Aug 2026 07:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1DB6B0098; Sun, 30 Aug 2026 07:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6910A6B0099; Sun, 30 Aug 2026 07:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43A446B0096
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4F361402B8
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:48:05 +0000 (UTC)
X-FDA: 85157762130.14.5ED8B60
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id E55531C0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:48:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="H2CrJ/a6";
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788090483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZaMr9PcVum7xXG2P1QWnBBkzHTyXA9Vmtkj6+XCSfc=;
	b=OSTriMZOJw82mOSE9Yx2riBjloLKD9FAgy3Aq1ztMwekNEQnOWpJae5XBApvzLqBQLYw+x
	eu/UKARcEi19JScuWtTxTsEbewkyWDIWUso15TUwyM6u8ktdqI4B7j+yLLbiKooj4xCDGU
	G347TWCxFYnDx1yaFg4jQeqyk0IOi2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788090483;
	b=YfLbOtfTCYwksH/PDlol1oTk5V9nOzdFw6b5hasJVPJ0BOAuv8O6r9Rmd06iK9juEAeXax
	d3oj/Mh77qtpzH+VQ39MNzFL7ZA43+J4h6RgbPgwU27kH4lLyYUAwujoQMmA+1PaUo4j+e
	LPoZSnI+RSqgXW7+DnnQFSsMc8fvBH8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="H2CrJ/a6";
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84e27035206so2461655b3a.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090483; x=1788695283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wZaMr9PcVum7xXG2P1QWnBBkzHTyXA9Vmtkj6+XCSfc=;
        b=H2CrJ/a6B/IHVtMuwG3Zggnr+Rx+9PbTKiukW/7IeLLDbwIxvrp17UnMx3ormT5ale
         dzgRdGNPWFRptgYdlCZ5mHPdS4jP6tVBVyyuJ7ZHMNp2tn6AWOsue7cVrgAFFGRyS9uM
         U8uDVUqt9AFdk1tFr6LiNL5w51K84MK2PwJ85EQJzYllKtOiY7OZRSr95BlMjpuR2PQA
         CdgDzq0KlydZe127zdDeM84tnCvTe3t2uxufDst6GVDrUaYAaZIm8QSgbe7RU09epmNP
         rxfpwn1HnJLxqUqxq4rxXNxO6QuOGtDn7rwlamEjv65Jtge42FJI6jL8UyMBqoy3Hmyl
         y6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090483; x=1788695283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wZaMr9PcVum7xXG2P1QWnBBkzHTyXA9Vmtkj6+XCSfc=;
        b=due6vR4r4EGeuHOc73u0QQZEbGNmu1oEOIlNH77Gr/O9l7NX6grEZ/yQzGPbFBg3cb
         bEi/vTYZF63oPjBt6bY010FAc9PlUWmCQJcZjBxYVcie9hm1QFld9x4mTiAbzBJwV5OI
         flS0nILQWOn3qsZd0K8cHqShNG+pCJLlimfZeyUvHkFhnyfKPxFqeIjmvpLalgCcuASI
         3X+2xNzJi0MhxT628GGbEYc1Wqv89T+x8ewH+9PvKFbBHA6nmPNR6keThHkiELyBy3tn
         vXimaaFjhEhTylol5uh/ZmB24BgFWKs0048OBv0AliiZ02919Tz0/v0Jy7kUXxjJ+hjA
         3NRg==
X-Forwarded-Encrypted: i=1; AHgh+RoEMIUzvec61we7lJWH5fM/iPGMdDJ3VyAjfWs5c8PBLAY3A/RDKOruoh5Cv7lulQFd9YshHO0IMg==@kvack.org
X-Gm-Message-State: AFuF++nB2ObRWBhr7lZ9m8t3gEdq+dSaOHgjFeayM7yeIMGdc5IjBtFT
	PcOMB9AeyXUodaq8JZP7Vczv9hzdQDLpmQyhfQIOijV+5vI3QjaYYnXSl7zSr7up
X-Gm-Gg: AR+sD12rKcsi4GxwcfCycQQ/TWqr4lV05+nfJopLZG7DlVVB1iDgQnkTQtQUfrZJwyj
	oUuz7onXO8l6TPdjlIvq1CDMaCji5XxDMqv4PL9fHq6ejQ1tLHOcbfX2nWpDXlcsysVu1RqLF9S
	zBGIZGCXVDYGx6LtteejJDJ0qQrJdJ+Nvz90C0+rRzhG0OqlpsZUIkp4IKY4fm4A2aPqBswgv3x
	T+WbjteQJjr2q8fCrZHL26iJ2u0em77Gq6lTx6dnxqjDVA6NIV3+HZaVyyt09SZbGfdylHnkCY7
	0IhorYJDxZUB7VWOGBGhILYXy5jgQUwbZDy/hXEA7imENmv3uBqPWYlAOqv5Uw0D3QE1poCaIlL
	uNWsJVQkzIZ/nFAlEXFMcPPjaVT9sTefEXJBOwDvhzZCDqK2igkte6/NGU3+DG0E7gLUk55Sccx
	9MGZUG9jRvRDzFCtKTXYIXv6Vud7fTuk/DomjH7X6FU4X4+OuEimqznP3BHLdLBK1PM27FhItBS
	kqYno4ywCSoN6m3oQaQbMd3bUL6Jr/2Pax+NA==
X-Received: by 2002:a05:6a00:1c9a:b0:84e:9257:d0c2 with SMTP id d2e1a72fcca58-8562a00149emr33552260b3a.9.1788090482772;
        Sun, 30 Aug 2026 04:48:02 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([2409:8929:a7b:121:d0e3:2a32:8ea7:5ade])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a397c0a7sm2395264b3a.49.2026.08.30.04.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:48:02 -0700 (PDT)
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
Subject: [RFC PATCH v4 3/3] mm/zswap: reference the pool by index to shrink struct zswap_entry
Date: Sun, 30 Aug 2026 19:47:31 +0800
Message-ID: <20260830114731.8322-4-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260830114731.8322-1-wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E55531C0003
X-Stat-Signature: eibwjr6hzecjdfiun4f77p3fekdmkdyj
X-HE-Tag: 1788090483-149429
X-HE-Meta: U2FsdGVkX1+jYwbzaT8VG9JZiuzf/yoQMHFwDuZqpyV8PSQomX9AhoqtahzaIBp1K5NLqLZc4JCirPDfzf9y4zMf/qnEbQRCPdSA9Iuh1j+F+jr22vRB439Vd0U/QY1bAjtlj8NzwI6We1sLkdafpeNEl49aTaaNAnTqEb1BkFbZ4fPTS9BOME9atn/aqM8C5Z7U0RMlF4F+lrK0H5rTux1UFskk/lEP299b9+QolRvFMX4ERcQWRbo/OUzqcedigdYvD4cOD4gaUlSK7QKE8Lu6fg45PI20ANaePukHn8/1gxF0lRLXKw/IhIPcOEV2Kytuy5h6O5NqWqybAlududhbzTiXerj3p60lxIj5eybriUOT1mqF4F9lyFgUyek5ZwWCt55i+AR2SgjBscSw4/5YX1v5KDi8Qf39kPCSUu8Pdv2Sj5oXVR2CCMgSbsMhwlJ8D5vhlb+iGfHOplexl/x7fp1ikWvWJo8Hor/vFlq4m1g9mW51FmVT72hxPr9JivVEMOvSKT7QWujh/LEWV7MvXIQcss/zvP8vEVab1fX+4+Qhf70n02Rqx3pYUzX5j5GCCyqZFh3VxgeYotDnzodO2HwA2uMqDfZDTIYiAo4lLxBGNoP1XqA9zAnNlj6Tbt5bCG6borDBVZW0woxCCC5663x9Wwb+E59ZNGS6y7yY0+p33S8ukF+Jx33c0HfCFUc5GIfYTMYzuT1nqoVMAoWLy6lFnRwwBzkEDLhlEgkGXTk8J1oxCQ+Bzm5kR3b0F3/2PF0LipQ7yKDFI0hWJZLyRM1efq48cFhIhi6syXGtKph7niL7zicr5AHNK2oiMtuEwu0EorG70xUD8PmyoyumM3ezAUaEAaP7GSdxSqubLhGkrFNCKgFYIeBXsQpcrpG+6o59D6zByVbntYrlse5L7vEzBXwKq/AjbDZ6iFJ7N5z04LOn+V+JIYC8SrTtYKifhxZ6f3GTWBOwqZ2
 k41FdG0N
 lULZw7HdnRW+Snh4h0RubOcdaCmrGPLYBmbcOC5m6JXS4S5jHJyKCH6bmAu8wjcCDEYzgQ8+v3cDb4hCRzY6KVr6E6q97Qg/V0SNPyRQC/6tmP0Ji2pWZjse1gYGm0p1bdW7knD+e4ex+almtIzheVE6/e8r7HgnFAttHCiS5ikNdzJvhORSoQPeqCtamrkRDSG1LehrxjH4ccfwkk8v2SXdbVUylSQGdy4YUeT6NB5C+BtnQS282V5ucc3fJ+58VJxzzfGIXZbzxkZk5L9khxnXlqBqLcfT6V+mav8UbvsYmvtFy3BrmLugH35B41OUaJZymiN/FKkAORnbhzcDnd78VGrVr95YCbpGstCcHX1P4Gw7181HnSE7w9M+vbMcbKjtH/UByQssJ9EsdQfxSCgOnWgAwYuYJR/tF+7JCxxf1GpOSZl4kf7o/kOWSGla0kJ8PSFdEirVXYU5Hu5f668Jbs3W4IhkGSBefvWY5cUSVjovcjRwUttv5wSOj5VyL+X+xQ8lGQb/YTIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct zswap_entry is one allocation per stored page, so its size is
pure overhead. It currently embeds an 8-byte pool pointer, even though
the live pools now sit in a small fixed array indexed by a u8 slot
number.

Replace the per-entry pool pointer with that u8 slot index and resolve
it through the fixed pool array. A live entry holds a reference to its
pool, so the slot cannot be reused under it. The lookup therefore needs
no RCU read-side section or zswap_pools_lock.

The u8 fits in the padding after the bool referenced field, shrinking
the entry from 56 to 48 bytes on x86_64. This raises objs_per_slab from
73 to 85 and saves about 2MiB of metadata per 1GiB of data held in
zswap.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b3b5e2887c00..521e0187bcd1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -198,7 +198,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - slot of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -207,12 +207,22 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
-	struct zswap_pool *pool;
+	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
+static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
+{
+	/*
+	 * A live entry holds a pool reference, so the slot stays valid with no
+	 * RCU read-side section. The != 0 check marks access protected by
+	 * the reference. A live entry never uses the reserved slot 0.
+	 */
+	return rcu_dereference_check(zswap_pools[entry->pool_idx], entry->pool_idx != 0);
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -808,9 +818,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+
 	zswap_lru_del(entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
-	zswap_pool_put(entry->pool);
+	if (!WARN_ON_ONCE(!pool)) {
+		zs_free(pool->zs_pool, entry->handle);
+		zswap_pool_put(pool);
+	}
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -967,12 +981,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zswap_pool *pool = entry->pool;
+	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
@@ -1008,7 +1025,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1511,7 +1528,7 @@ static bool zswap_store_page(struct page *page,
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
+	entry->pool_idx = pool->idx;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
-- 
2.43.0


