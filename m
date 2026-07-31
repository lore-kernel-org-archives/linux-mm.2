Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D743C55165
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 00:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6006B008C; Thu, 30 Jul 2026 20:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C005D6B0092; Thu, 30 Jul 2026 20:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B436B0093; Thu, 30 Jul 2026 20:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 704726B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:33:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F14BE1402FA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:33:04 +0000 (UTC)
X-FDA: 85047197088.18.96CECC7
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2FBB34000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:33:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mOzkbtEj;
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785457983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBargylVPH3S+42bvmeBrQWNnoArflrjGcYv77Fa7sQ=;
	b=wSmcKuagX0A/lhaDWUH3y7u8zYn4E2vIlmzciPmylZB5AEMvgAs8CXmu+aBoawA3Vkw/Uw
	z5UBhNuntdp/JdVWWq9ykdrf5pPXBFyrerRAbWk52SzbOhgSyayoasQU5FZx2BZ3YnnLKY
	sEYbeWghK9c5sx54pfWfTsShdi37UU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785457983;
	b=S6KzGI9x28OYmsamC33oG6Gc2cEtIf4ZSgNWo6LYuHyiDnn48apqhDNOmMzsUudQEZ3uIV
	ErrKgPpJ4qwclnlLmOHVIdMRPGH+lz2WBLC9i/XSDX3CGWqaq1boGmMMILB8VrJRsdJayO
	PO2dwNHAMll8w6QxdzeKsX3UbVioDT8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mOzkbtEj;
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso248701a91.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785457982; x=1786062782; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jBargylVPH3S+42bvmeBrQWNnoArflrjGcYv77Fa7sQ=;
        b=mOzkbtEjWao2C9Vgkwfv6IbzKVBBrnyorwrrW0DhjBD1sv2N733X3wSDP59LVQu16f
         yKWnJAhGeZGWWJGQbRmKnEeRGABMDZSy6cYFGnjpCiTexA0lZ1yZVKp1WLY3yUJSkqLM
         6xrqfsMnZw11Oqc7yDbJKJyzgVjdzD/wAcz3NXfW6VgHSnLGdjDxIjtstIKBcZWA/3HJ
         mq/NzS2oMEnYZoTr0P74e379GLZ/HJkfhEOjDdnbKQTB8qxjGtnj6tHuCmGbD1ocWCa1
         q9Lm7NlG4Nebv6Wb2Hhvrwx0oVdMHDjLUBC3jKq8yyAZbh2HKoWPtY8URFvJ6anH7HMc
         jNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785457982; x=1786062782;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jBargylVPH3S+42bvmeBrQWNnoArflrjGcYv77Fa7sQ=;
        b=nTfkyAZQs7HGv8gpJLf3OxgraabVpww8FsNNsYnv5AmOCWY+x3GVMbTSEApGJoZYPd
         0FwokpURtZhVzSCAK/X/u/3Ql5WvAwjj9VOX1llpqEHGNYW5JfpLWDA+/VEq0zMI2qfM
         gUwtUEM2CTEGEjq/Bza/8sjPrEf9PTGxdsuxuKcDt+nYYWNUkc+Ht6Q+/Ypyi2vVWC3O
         TyTaI/a82ragEMA7tAB+sheWfqXwAO8McVvApuz+yQwPrWcRB9Exm7yab6CgknuutSUP
         Cp0a+cQNklDH8z7WIFQfwHQRnAW2op8nj/Eiu5BH2UWJ6DrfnUpHGxrk8uC5KWLXsTGm
         kfxg==
X-Gm-Message-State: AOJu0YzrQ32ryUxSVDjZkkHvBlahz93vthRwlbr6SOmLUrJMQosnVe+4
	bcvLqWsPY+aY1KCPZwQY2sIDIpc4msqoNXQIch9ONFOtSb2fIiXVMmbG
X-Gm-Gg: AR+sD11kfVkq2/QImrAnxTkyPm4HRrMKoxijJKVTl/vMCEiMt2RduBbMOXPEoii5o3o
	TFeE2mCfbcQccvIhJx9m4IUQ7O6kEYW9jFrBpi/s6uQ3WH16n3/xzty6+dTYVQTpCJT0ElWU2Gx
	jQoIyZEmAi+4J19OV5E2tN/a3SIOpekiRlwsB1knIsuVjXiqRvPY9gIy80ejomtOWggEU0JesBR
	/p8i7wXd4pfCR5vvS6IpYvbPaMRjkGJW+DhnmtceIlliex08KgPdIcBgUM0gM1+vmqjvFy0fXSB
	GDTndF/BvsDck07kXYsgTNA3HHmWt2WzUwur5KtZrFCS/PKzqjWhoLMytHfpPJkIVXIGzIckzlX
	//EXunDYqVihoW0DOaMttWmItdRbOdIy5xgIOKC8ia0G39gCL38QdHQbNVzyI0URm6fquL2mq8n
	JVCd6vAVzHM0HG5INPhWHkFjQNBZ37rD3IyETb6fXdAg37HKZ8n8N3KJwzKh2R7tLqtQIrsV89i
	TV+QCSbfHj5W76f+3zXLa2YhBfjFh7a3Hb3Y6g=
X-Received: by 2002:a17:90b:4e87:b0:37f:9e21:91d6 with SMTP id 98e67ed59e1d1-38fa76ee9b6mr1342576a91.13.1785457981944;
        Thu, 30 Jul 2026 17:33:01 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b42d6c8sm1636301a91.3.2026.07.30.17.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:33:01 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Fri, 31 Jul 2026 08:32:48 +0800
Subject: [PATCH RFC v2 2/2] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-shrink_zswap_entry_v2-0-0-v2-2-e72083aa8734@gmail.com>
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
In-Reply-To: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: ahrs6qprgfkbzsnwu9pzc9knrcr15cx1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FBB34000C
X-HE-Tag: 1785457983-530801
X-HE-Meta: U2FsdGVkX1/aqgsPF20RDhidDD6wHWVs8VR2DQk7Xq6yMWNhBvODa4elx368pEpvoBXRXi6MJMaNK3jhIJlk4bSoj4+Yyf13P+276re0KcxhVrnqmJry4Z887f10uOX8+UbuPOQz2Ee4o0L0q0WteTrP5glvI6Up0QVFibSmJvgOyEjkj8xZLdxTI+OJVMc0qJm87sZI8RDjXhUM/n8fGjNifGshwYzVXVfKvcH+QhC4jT1ba7tyvDWCdTQv+yOCkGaka65xdvIgmYdg4xYClvz9MiUiSYAJcik5JKHqbHuxXd+GhFjKudVuWOeNR9Yoj4k5z6XaNqCmYMHiCsmQWnyT5tyou7zoj4oG3nljR7Q1YSzzIBfdM07vMYvc9704ehg4P7wEHTrLUp0Z3wQBXTR6Ac2Y1LbAJpkbbAvK18CwEFOSs+Fzb91717/JbHWzNwtYE/vFq0Fvxp9aPlRaxq6f3n8sRtAhkL/K69IV5K+PjYpFPBt59krvPT4AnjojKFnhn9FxWGiWsMmwN2NoZHiosFZUJh2JR2y6K34SMXyGP+yt31CL3nxSEUOgPKh3sNSqsgG+rwYe9tz5ewZ5Jlido8hBvyJH9pBvMtNHNn3m4pMoeNc3q6FPvWvryLViXp5NgHj/5hb7CKhF5vtlB0PSQkJOXWl+cMsjbx7dsnEqhDJY80d4RBOzJxl1SxMSn1jLwkCTTLJ00zi6vOXzyjw6lx38fgWluT+FFlIc0HGtNOkN2rpbYLUVewSumdQh1eHU277ip5cY+x+o73sJu0HMRxwYoC5KFO5aN7jdtDviWe8NAuWSr1IEQ8jXQSVQn/v70SEbDT77OrREqI8lp083B3BHsae7crVCmq1TIqbROvg4Kp5Ehtw1taRKa1rh/1O3LiFpZQTkXCnBIImKaDGVkbXvDYsLSanZ0FVBJDm6flaZXlL+6ddMPYRla/IbKKUwwl4fnDmGGMkJVfp
 e8hx9Hdi
 LqTORKw/sUYfvkDsZeVU8A8EO4zQDLhdZGiJIUUTOvXMTHHDGgog/l8CAOCjcum+NdZ28Cxyy8+8bcYlQac/8QjMijI2L5P4LBPivwqHT2WEVtBMCjbdVXwgHB+NDNjlbcEy51D31xoUrf8rClpEh65gL7TECt5jHK3a1ZA28j0JzyPyJdBU167DzuqeghacfF5zimCj/H3Ir0/DTdAfa9ZeGCBXtqM2deX+/kGa+X+zqogMMyvcvDM2Ow7SqU8D6I8PLXxKBp0ZoncpzSBriU2oy5PMpb1jUTI6E36B6NThVhw6FAnJ53UqpXJsltEoRNEUBanioyMjm8a6gSP4wl9rFesF5TXjk31ksYUZf5dfU5t23qCVjxfl830Dj9dQ1+sHNRrvJRykMpH2dkLv4oW8WwCbmc1u/KgubDqb51VfJa328Fh/o/qqH4NbtSlJeGI7V5tWs0sqlfAskJbqVZopIJIpXe7AOyuV2nFKws8U2OO+ji/4bxU81wIOhURFyUmXlADiLGnevAsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct zswap_entry is one allocation per stored page, so its size is pure
overhead.  It currently embeds an 8-byte pool pointer, even though the
live pools now sit in a small fixed array indexed by a u8 slot number.

Replace the per-entry pool pointer with that u8 slot index and resolve it
through a zswap_entry_pool() helper.  A live entry holds a reference to
its pool, so the slot cannot be reused under it; the lookup therefore
needs no RCU read-side section (rcu_dereference_protected(..., true)).

The u8 fits in the padding after the bool referenced field, shrinking the
entry from 56 to 48 bytes on x86_64.  This raises objs_per_slab from 73
to 85 and saves about 2MiB of metadata per 1GiB of data held in zswap.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b203934d3be8..d4f4db2999f2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -190,7 +190,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - slot of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -199,12 +199,22 @@ struct zswap_entry {
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
+	 * A live entry holds a reference to its pool, so the slot cannot be
+	 * cleared or reused under it.  This is not an RCU read-side walk.
+	 */
+	return rcu_dereference_protected(zswap_pools[entry->pool_idx],
+					 true /* entry pins pool */);
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -807,9 +817,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
-	zswap_pool_put(entry->pool);
+	if (!WARN_ON_ONCE(!pool)) {
+		zs_free(pool->zs_pool, entry->handle);
+		zswap_pool_put(pool);
+	}
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -966,12 +980,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
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
@@ -1007,7 +1024,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1500,7 +1517,7 @@ static bool zswap_store_page(struct page *page,
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
+	entry->pool_idx = pool->idx;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
@@ -1806,7 +1823,7 @@ static int zswap_setup(void)
 	struct zswap_pool *pool;
 	int ret;
 
-	/* Slot indices are stored in a u8 (pool->idx). */
+	/* Slot indices are stored in a u8 (pool->idx and entry->pool_idx). */
 	BUILD_BUG_ON(ZSWAP_MAX_POOLS - 1 > U8_MAX);
 
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);

-- 
2.43.0


