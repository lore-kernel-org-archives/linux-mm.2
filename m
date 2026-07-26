Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D690C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 15:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5F56B0088; Sun, 26 Jul 2026 11:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D6F6B008A; Sun, 26 Jul 2026 11:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CA96B008C; Sun, 26 Jul 2026 11:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4D66B0088
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 11:18:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88CE01204EE
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:18:40 +0000 (UTC)
X-FDA: 85031284800.08.BAF7390
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD52E4000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:18:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nZ63QHJu;
	spf=pass (imf27.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785079118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=huTial1rj96Sdv5begWanUZ9ltPrtlzp4iPe6g3vPdc=;
	b=zKBlVzobXf3S1aOESRO92oIE2jQkTXIMQ9WI6mKouVeswmEQuKSi4DpXlByqeEsDoTjbXT
	5z7Un/5mSxj7moLuDVSPJHKgW/iYnZbgSc4ISgxmJFJVkyvrtZNGAmvG8HHTMe1hldXJNx
	zbzyAot7Q/9uo7kbspVYPVuNuo2aGQY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nZ63QHJu;
	spf=pass (imf27.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785079118;
	b=C6pspZefegPQZMprh7X0whGxEkM6UIEHodFOeXp29cOeawa1rWo5FCvNIpW+7Enz02dEZV
	QLLiwHejABKi2yiw8AzLF1faU9nTGII7RWls0Iczd5M/eJnj5oAR8z1zg/d0T4IAwqEA1I
	QCE9WqYFsGNSmJfYO6B07Ci04NG+5ZI=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e58034d05so2042340a91.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785079118; x=1785683918; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=huTial1rj96Sdv5begWanUZ9ltPrtlzp4iPe6g3vPdc=;
        b=nZ63QHJuD7HMz1OVKvgxmWCwg6RJKkvS6i1sshtjP3oT9+b7o9Xu6Z5znmjoGBUsem
         I7cG83Z8RTK/CieCzOI04lvxBJo3mmXRLL73GkvupCrD8FoBBbyUhxsZI/2nZZJ9APgD
         GP+3tCOd6Oo/zGryOfRU22jw/BOxnmKv3z31Iq4AZZSJ9y5ZcxnAaH8Km3ZoBGRyDsUk
         fAazQqW6DoGdn90YntFPNwyDvNtKkmbin6W0T8JI29m3ckptBPpOWmSfJ5fQBKEUqb5/
         UYfV1ZOpLSjOqPFjxXCfk0X1LADqwqhbh0ISIzfTsl8zN71C5FdLsCHiUw/xd4BNbw4R
         UDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785079118; x=1785683918;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=huTial1rj96Sdv5begWanUZ9ltPrtlzp4iPe6g3vPdc=;
        b=KGdSRU9gq70jmEth46ztNO4cnpYvC0uWkOsrvTPot2JC1ScS241qInVNRAeNDXxDp3
         3YWV1mc2LwjnDH1yWUFe0hJ6DxHabbspwuUvhAGNObSaqpXoeoAmEky73dwzJ4lJWe6d
         l7EhvTknv4B8p9ud9g/2+Avep+z3JLOfg2wrGEXtIftjrAzYHXEbvNLejv199J1PlRzX
         g9tu+edwv2zoecWcHMuY12Y1GmcLQcqNTd1zh/+EmCSZGir00T/mpVEQFVRcrR6mLz2T
         vyS6f2ZGOLiASypjmfQ27tqUeLvYy+/urLiFF1Lhhn83zeQTfv1NNDJXunXm/GkTjVWK
         ZfEw==
X-Gm-Message-State: AOJu0YzTO5wKdRx5vHmsgEFqQhOegYcndoeTEzne5H6OWd6N8OHwFfYW
	oLWu6eL9YWCj6aLavQJJ4bS2TiEk5lZjZaPX+kZo6Zj3oIR2VkvMfocj
X-Gm-Gg: AR+sD11HFp0IyIdshxcZr7HUqdtFLDyKoh0QqHNSyqZdavIG6oSj0bCfxde+wrYRt3R
	mlFAPFppphFvLwjqhgYGu0JCUJd77ugg46vzhDzC0jVyw7ZvJpFmWAVixDbPzOrdnCl0J7KjZ3E
	/+Qv+Fmd6FUXxeusOY2xr58Ie9zZ0oc8/h7Tg8VfG931yyYykQQ94LHr/ZbRamE8SXDiB2fZVCf
	q4WJF1jq0XtctSRWi4bEFxaYyWB48YyuOseKqNoINuq7UuCR6LGNTL83W0d0Pfec3ta1nHHkNwd
	CM2Lw9UKGn6fr01d544Zb65wEfw5gTL6tWkYx+uV0hGE9RSSQEDFARjCghy4b5QWGnkIUdtJUUz
	/Ui6pTvf94a9jvgFsoA8kj0oI2mQyBNua9oXOVCVTLjkzsVzpxMlwqx4WetQxJdKY15umjspAZT
	XKwH+0mELM3naS97Q2aM9fXkpeZWzC4RAEUKvPrYdi4AUXZsmUN+c=
X-Received: by 2002:a17:90b:1e46:b0:387:e0bb:57f4 with SMTP id 98e67ed59e1d1-38f2978d427mr5639084a91.37.1785079117483;
        Sun, 26 Jul 2026 08:18:37 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f2951f0afsm1861168a91.16.2026.07.26.08.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 08:18:35 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 26 Jul 2026 23:18:27 +0800
Subject: [PATCH RFC] mm/zswap: reference the pool by index to shrink struct
 zswap_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEIlZmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDcyMz3eKMosy87Piq4vLEgvjUvJKiyvgyQ10DIEwzMkw1NklOtjQyNFE
 C6i8oSk3LrACbHa0U5OasFFtbCwCoOl7fcAAAAA==
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1785079110; l=5934;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=9tv7muJdLvScl69Km/ycyQXHUCFfiJBY9mPryxooT/c=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDdxqueZzvQu5NunACF0Hh/1YK2GzEdfTWohouxJb4tU7Qc+aRYb05avbEZYAKtdA9GeJsexXKf
 tPrh4FQWueAE=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD52E4000A
X-Stat-Signature: 1swyphgrsok5ogsns1d17nk7jwkaw1mk
X-HE-Tag: 1785079118-405354
X-HE-Meta: U2FsdGVkX18y3tCMYokSaPkILJb59Ga4SPeFxJnj5v/C1BhpNYVFsA8l4OlPDh4J/DtTojQFrZToiwCqH99EPVmF1TeedJM+tV+7e43hS4yW5atDMTFl1qCjTlYjRLr67qJ2Lqt6As4LRdE6isv/aLCIysmXscqmN9JtTIzGZhwRNpgGJtFf2Pfi13Zuw1tvmSynuuLfmuhbasZ9S8/McfQAdgeKcpTbhbkeNE2qMvFVZx1pjhsK/7uPwB/9o+KBIFuFP01KH2Nw9SZGK7Ic5q7UYXLAR2vLrJggs50huQu4eyswaukuzThoSIfmyyydTLxEO8XMpfCwIc6JXeOQ9jtU50xL1OyszU2tvtBYO1ECOKvtnUMlLgFemuI6FObuHQiJ3Ork1UzwxQ+VXzlzn3jmDhO/9W7Ywz1VWSmRttbfrUrHAYkMB1HpTdimveEIbYQ9uQaqHmy3Emiekod6o5/b2z1AbO6+5iPP2O5nnMwldMbv+Fg5WGJD5KMi3iVtRkbSwgxCWY0uRfOtEPykCRxx/9F3KRZJX+ArerWQtRL5LB0CdsaJ3iZLz5z0AoV40pGVCno6K4SSZPHtQlXfndUenzaSdwGn31DwZ6YJgc3PKhC9p3lD6H5hazjNZBfz7sRjVViJIT8MKKbvR76PDp8/bnkKyc/0WaW0r14oJssEeJqgeOujnF6tuiqjBzFleYEh1ofcP4ZtViwcP7r1Hir7s56hOqGT0sce0fGKnEagzL3uvI2EEoWUySdAfvQN9L3MeUbjWZnoMtCuExUc4NE7L1zXujrkO4SLuieKHBJW3YHfJlhygZltLAbJg/7DTrvFqM33mM1oVizejQByohyN4HnwpDnNskiMV9MHD30/1W4Ojpnnm4O4X5IXSNHyfSdETmGFG3PCgnT0w8/AzrytB+Yb2u1SSY41xad10FJgW48VTMTq5OZklnQTwtn+pdk9oZ+aT5aokHR61xh
 YiGUrtHv
 cuJYume5cG4Eb54rWVT8KDi0u3fyzdoW8o77nOJKwwzYuopQc8MZjtG63XU7W9tZhEJfr56E5Vpn5ncKZBDsGvsteKoyDv1KEx8dxNsAkepTKEQ7J3lPbVUys9kH8yIieKqnZ6/GwE4Xac1n8ImvumHgcsqIW8TJxVmt7eEMnj0lJ/sIspfer3wehuhPRWMri6yzy8O2V9UBPo23STR/xgthTFSKbYybzqQWQy3224EOlPcIwRmRN2/FQJgx5GyqOyqpFoM402OzJFCp8eAnJoaMKmBBI6qiukYfbJZS66oYQyk1eMcCUdcW6BqCKp97b4uS2xVISQx8FHd/Oo683GjCV+qrLVw/MhNMRBcBm8P5HnmQtZxHvIIcRS8KRtx6///1UiKPmKMkG4bhdJcyvhIjm1jfAqLn5KqybZ+3d5EpB2KXxK2nY2OGkKOiWt5lAhe4bNXzT1d2h8OeGdSH1Odw6FjwhKYfWFa+iNl5rRYtLkDWX3oBMHeLSBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every stored page has a struct zswap_entry, so its size is a per-page cost
that scales with how many pages zswap holds.  It currently embeds an
8-byte pool pointer.

Replace the pointer with a u16 index into an allocating xarray of pools.
The index is allocated with the pool and remains valid while entries hold
references to that pool.

On x86_64, the zswap_entry slab shrinks from 56 to 48 bytes per object,
raising objs_per_slab from 73 to 85.  This saves about 2MiB of metadata
per 1GiB of data held in zswap.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
This RFC proposes replacing the per-entry zswap_pool pointer with a u16
index into an allocating xarray of pools, so struct zswap_entry shrinks
on 64-bit.

I am looking for feedback on whether the metadata saving justifies the
extra indirection on entry decompression and freeing.
---
 mm/zswap.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4e76a4a87cdc..6c29098da8d5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -35,6 +35,7 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/list_lru.h>
+#include <linux/xarray.h>
 #include <linux/zsmalloc.h>
 
 #include "swap.h"
@@ -157,9 +158,22 @@ struct zswap_pool {
 	struct list_head list;
 	struct work_struct release_work;
 	struct hlist_node node;
+	u16 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+/*
+ * Entries store a u16 pool index instead of an 8-byte pool pointer.
+ * Indices are allocated here at pool creation and released at destruction.
+ * Live entries pin the pool, so its index is not reused under them.
+ */
+static DEFINE_XARRAY_ALLOC(zswap_pools_xa);
+
+static struct zswap_pool *zswap_pool_by_index(u16 idx)
+{
+	return xa_load(&zswap_pools_xa, idx);
+}
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -182,7 +196,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - zswap_pool index, resolved via zswap_pool_by_index().
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -191,12 +205,20 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
-	struct zswap_pool *pool;
+	u16 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
+static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
+{
+	struct zswap_pool *pool = zswap_pool_by_index(entry->pool_idx);
+
+	VM_WARN_ON_ONCE(!pool);
+	return pool;
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -275,6 +297,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	int ret, cpu;
+	u32 idx;
 
 	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
 		return NULL;
@@ -322,10 +345,18 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 		goto ref_fail;
 	INIT_LIST_HEAD(&pool->list);
 
+	ret = xa_alloc(&zswap_pools_xa, &idx, pool, xa_limit_16b,
+		       GFP_KERNEL);
+	if (ret)
+		goto idx_fail;
+	pool->idx = idx;
+
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+idx_fail:
+	percpu_ref_exit(&pool->ref);
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
@@ -366,6 +397,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 
 	zswap_pool_debug("destroying", pool);
 
+	xa_erase(&zswap_pools_xa, pool->idx);
+
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
 	for_each_possible_cpu(cpu)
@@ -764,9 +797,11 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
-	zswap_pool_put(entry->pool);
+	zs_free(pool->zs_pool, entry->handle);
+	zswap_pool_put(pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -923,7 +958,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zswap_pool *pool = entry->pool;
+	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
@@ -964,7 +999,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1457,7 +1492,7 @@ static bool zswap_store_page(struct page *page,
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
+	entry->pool_idx = pool->idx;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;

---
base-commit: c68210527d235e59afa54bc6aba6ecc532488a82
change-id: 20260726-shrink_zswap_entry_v1-0-0-f21e34cc9214

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


