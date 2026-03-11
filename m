Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AD11125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508456B008C; Wed, 11 Mar 2026 15:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C456B0092; Wed, 11 Mar 2026 15:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321756B0093; Wed, 11 Mar 2026 15:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2EF6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5D2913AB36
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:00 +0000 (UTC)
X-FDA: 84534828000.01.329F36D
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38E55180007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ezmEMIcU;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHiXRPU0oj2HIsyVL3yHXql4isoiizU2/nOjnBQn0Ag=;
	b=dgKMtehUXsuA8AVfRQAYy+OhND+sHnRAo3UtK9IPJkVwCQj5nNcVjCGD+WYusQHPG54ZCt
	gLVa0sKXW1fhyNyDuKEKyDtFGDDrg5YLeWjGSfj68EUsZl4edXthrBkNC0Z62jPdxLpeyX
	aoTTzh9lCncuME3B2l/B2UGQHhc+tME=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ezmEMIcU;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258719; a=rsa-sha256;
	cv=none;
	b=NyXYTTLmNiKwy0alsGOtnNnTw9flwbzLNw0iJo0HmtHn8n9nfDBGlXRlWA7zofw5Sm10FY
	gBuwDWn5m+exKqbVLBlwnDmV+dGfIO3Ixe+5sGpPEkYLeNCyUhcIJ9+OEvUEIhZOgv2Zi6
	VlqimiuTR2hMTD4ORJAOd2FzrJ9WCi0=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so194428fac.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258718; x=1773863518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHiXRPU0oj2HIsyVL3yHXql4isoiizU2/nOjnBQn0Ag=;
        b=ezmEMIcU3O9OxGNmjbOTn+78YkxhqOQzF0ZeokCHiSGktxFaXnic5UVjR30cOkUR+w
         RDt5jpd6OFaBonTs6JxGuRbveu5pPYcIVMahX6Pvd17fwWYpGLLGGAwX8j0LRIHOvEOn
         FRmwau25MStmOJLgCxHaPz6Dwv5/OV2IC9EFUfVRtFo1ogH1euzYxhYvRriR7hXTPQS8
         4U09klNfdXL6iDqrH7flZ4cL1N0QDT2ehiiOKQ4xL324TQnDUJ58kMQPFe7fNFLRgaCN
         gZh7LQoYp+FsnDitDhyVmetcQozw1ZSYu6fH9oVjoNuE48S7xPk+CMPNvrmE4le2YC0q
         qEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258718; x=1773863518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xHiXRPU0oj2HIsyVL3yHXql4isoiizU2/nOjnBQn0Ag=;
        b=k+qVECAg3EIkETHDJ1K8ktIu6/kDNikXLIOLp6cj7eXnQLW1om+w4vByhRba+oF7B3
         yESpJ0Q1VABc5PK8VUCb6ykA8RCfWVjVHtiUOsoI6uACNLDVthw4+3Oi3x9nYfe79lEU
         0kYBVfo07JauJnevFnZoYX5FMi60s7F0TZb+CnhB/nUmuKg/ShKKFbsKVKK+NzT1xzYN
         Y/mF8xSzVRsuGaTVFva+JreSxKtBWx9ZUvG95qn7bwx0aOaDXglY6z31o7U0qd4RO3/s
         bicvBy4OWotv9gWACzcaeHsKSQ2xjv29V9fNKpwJHaAjdqIYQOzkM4olFOygpiHIKRHe
         B5ow==
X-Forwarded-Encrypted: i=1; AJvYcCWhOWmbLBeI54zEJzHH9OZCJskVBUkg5dbucFwOhzcaK1lhIgFhFvsWfPq7OtjDK9BdStgHn5CDWQ==@kvack.org
X-Gm-Message-State: AOJu0YyzHXTh04+X+z51KjOeHP377Z5CfdG5K90v2I+VpaM8PbCgcam+
	Wbm2fyPMr8iskzy/edCdSk5EvKOl4Oij7PlH0noI9iv2cnCcKYbDmSRu
X-Gm-Gg: ATEYQzyb65hpiYLb4TByhVeeqjQn6Kx8ISZNmWNTfgJMLq3wakn/8fUEIMRt62SOcJt
	E8KlomySSRNy0dN6axlz7FXuJGBHVb3felVphXgMM7Xt4L7Tc5NxZi04HAKZKcc2gln5JiRINv9
	TBgarJEM9AYdu0Oii+FgHs8UDXcJ4q3w7zihkrv6QPLRgQVTLt51/HohKkxyL5PZYV7Jpk+NxSY
	51/gA+xgzS8ZWNru3/MwdPp1Fglgczl1jFaQpC+N1HFlIuoGptCr0EEiTgKwUfh+6kbgWcCLS2F
	h5NPeMGQU4talvs0kl9n9+xAUPmYj6rovDSCA6rkRrpA2GZItCudUPbFCX4QWH/TQYc7li8WzUs
	sdNNOKDVtwSdBD2W8aRzJiHFohjCx3oh038R0ZxG2ylArz5g7uG7iv5rso7HunJtRDcpSiEZK4X
	iK+8Py5b75Y86ih21zOWMkbOuZuR5of7Nb
X-Received: by 2002:a05:6870:3314:b0:3d9:2fe2:f5c8 with SMTP id 586e51a60fabf-4177c8bcaf6mr2475836fac.32.1773258718211;
        Wed, 11 Mar 2026 12:51:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e64a931sm3100578fac.14.2026.03.11.12.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:51:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 03/11] mm/zsmalloc: Introduce conditional memcg awareness to zs_pool
Date: Wed, 11 Mar 2026 12:51:40 -0700
Message-ID: <20260311195153.4013476-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38E55180007
X-Rspamd-Server: rspam08
X-Stat-Signature: ra4ho5jcom1zkyshp6sfqffhe7778ggr
X-HE-Tag: 1773258719-791012
X-HE-Meta: U2FsdGVkX18ST3AL2y5oZ8qC2eXfVfsK5KwlPwzhdUCufz40U+XgOLntgGuL/M4IrfPk9uz1zNdaT+HiZCnCQQoDGXZcENVmC2ysFEJAUpnzCaoutztMybYT2Kt611TF/4n7UxbPc3tCgS7Fqa28gerOcQukxBarWhAO6nkfAQoUAWg8+lQXILvpoX0peGhUQRmuyNqjgySM3oCXzkTm2dbCBB+cI0aeQmHwOiooC0JkD4vsbetL26LXtTUn8oGi5n2bX5nQRXvoJZy8L1+gNoWZtuL+WzndOWxAWPyEgTIrOKA8RsqP46yvCI+yl89ctUIONBSG59aeKyY2SwtPSTvjA/LHPqbu+w16m6HzAGyLFBCRHxy9AMUyBEoD4pLHfJV9b0jZk136OtN1zq/6ocshJy5cRnA9CpmAXNn6M8Exi1UoVuC14pwIAnyMtfoZDGc+ZASC2yIQe5q+2YosMrWuC7OdMD+BLUWNIEa2qkGCmWyEvCN141ajx1Wyhg9YBLQFiIQYgJ/3q/EUNPA7xsWNZ4fNms6lFGMon5ShhIFKCymd137CcIGgXCYlVSgnngNgnKbs08dcAyiZ7UosQYiQ9axl321QcuLM1ItRjCIwsecr6x6DfZGFNAwF6UFkPT+Eo5IOuLzXNAJGMAJgaWokkBprotFQj4vqGqD1s0YiP8wjfHqptVByuDHztXroY1ftxp/eUumvkT+NSjooOWZK5QFSkRBTS4UkNbrkYj5+bE0Iq54nG5sY8ZxCdafw1CTZnUBYGTXsFMOYL4GPPjsFNYd9v6mnO4B2FLcdUK1nuT5A4W600rSS2dAkP0cloBDYin+4i0dwSfZIUVmEL9F0ZDwckcRWPWj6G1aoSTny4yN4sbPsI6uQkOkjc8lozqBxOWSpaop86phxJn2fStiG6bjbkLbTicTjoM6AIt7PoX9+DkwIVyOZTqqcIMOcY406hsVZKywmh7u1EuB
 pxTdfZwh
 prnzvvsKQbGy+QWW3iDDeB07qi8Bx0y+ZdJKxokJJ7aWFNELPIMwlvFsND1HAxNiRRTgQUZvtGX1D8N7m715/6AT9ghDtOO/8GVZQSQpJo8xuMzHQxxmKs8s6aUUuaeu6zegIBarFX4r/BRizd1+rsN1JWBFeatN9HCG/QUw5LPj/AjBqxcm5jC67Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce 3 new fields to struct zs_pool to allow individual zpools to
be "memcg-aware": memcg_aware, compressed_stat, and uncompressed_stat.

memcg_aware is used in later patches to determine whether memory
should be allocated to keep track of per-compresed object objgs.
compressed_stat and uncompressed_stat are enum indices that point into
memcg (node) stats that zsmalloc will account towards.

In reality, these fields help distinguish between the two users of
zsmalloc, zswap and zram. The enum indices compressed_stat and
uncompressed_stat are parametrized to minimize zswap-specific hardcoding
in zsmalloc.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 drivers/block/zram/zram_drv.c |  3 ++-
 include/linux/zsmalloc.h      |  5 ++++-
 mm/zsmalloc.c                 | 13 ++++++++++++-
 mm/zswap.c                    |  3 ++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bca33403fc8b..d1eae5c20df7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1980,7 +1980,8 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	if (!zram->table)
 		return false;
 
-	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
+	/* zram does not support memcg accounting */
+	zram->mem_pool = zs_create_pool(zram->disk->disk_name, false, 0, 0);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
 		zram->table = NULL;
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..24fb2e0fdf67 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -23,8 +23,11 @@ struct zs_pool_stats {
 
 struct zs_pool;
 struct scatterlist;
+enum memcg_stat_item;
 
-struct zs_pool *zs_create_pool(const char *name);
+struct zs_pool *zs_create_pool(const char *name, bool memcg_aware,
+			       enum memcg_stat_item compressed_stat,
+			       enum memcg_stat_item uncompressed_stat);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7758486e1d06..3f0f42b78314 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -214,6 +214,9 @@ struct zs_pool {
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
+	bool memcg_aware;
+	enum memcg_stat_item compressed_stat;
+	enum memcg_stat_item uncompressed_stat;
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
@@ -2050,6 +2053,9 @@ static int calculate_zspage_chain_size(int class_size)
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @name: pool name to be created
+ * @memcg_aware: whether the consumer of this pool will account memcg stats
+ * @compressed_stat: compressed memcontrol stat item to account
+ * @uncompressed_stat: uncompressed memcontrol stat item to account
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
@@ -2057,7 +2063,9 @@ static int calculate_zspage_chain_size(int class_size)
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(const char *name)
+struct zs_pool *zs_create_pool(const char *name, bool memcg_aware,
+			       enum memcg_stat_item compressed_stat,
+			       enum memcg_stat_item uncompressed_stat)
 {
 	int i;
 	struct zs_pool *pool;
@@ -2071,6 +2079,9 @@ struct zs_pool *zs_create_pool(const char *name)
 	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
 
+	pool->memcg_aware = memcg_aware;
+	pool->compressed_stat = compressed_stat;
+	pool->uncompressed_stat = uncompressed_stat;
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto err;
diff --git a/mm/zswap.c b/mm/zswap.c
index e6ec3295bdb0..ff9abaa8aa38 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -257,7 +257,8 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
-	pool->zs_pool = zs_create_pool(name);
+	pool->zs_pool = zs_create_pool(name, true, MEMCG_ZSWAP_B,
+				       MEMCG_ZSWAPPED);
 	if (!pool->zs_pool)
 		goto error;
 
-- 
2.52.0


