Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5911125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29B56B0093; Wed, 11 Mar 2026 15:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5DE6B0095; Wed, 11 Mar 2026 15:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23ED6B0096; Wed, 11 Mar 2026 15:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2C516B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A79C139DAB
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:04 +0000 (UTC)
X-FDA: 84534828168.03.3150D0D
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE81B100015
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=asW2FQgH;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVMnNhXg4JHLBLwKWI7WYc2GrcGR/wasu1xpRjHo+OU=;
	b=IZggTUqI7q/CSpFQEsy+xpV99y6PgR+6wyMR4OhClD0uEWYZ+w6elADnzFVolfM8YvMxZt
	HwRECbHD6dheEsAaggZIwDKyE/dPtGtpP/SR0IeHeqlVAg9lGQX4EAC5BeNZ6FNWbF3TKM
	FEaT7/YvZLhAhgDsgKwROmUlO9mX4Vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258722; a=rsa-sha256;
	cv=none;
	b=EC90zmKLHEeN5aG+VjdLoyrqm3rktb7hmTI+4EvrCQIqpP+L7O+znmNgedy2j/9GuzJ0fa
	iGMNbwfeli+oiQLBvQ834Hdwzlk9GaX3K3ggqEN7RzlR2wM48NBcDVZF7LUiRxG6LFTu86
	M3ZDHPqQBr3CkCO7S7iP0E79HIfVYnA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=asW2FQgH;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-46702742c99so176291b6e.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258722; x=1773863522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bVMnNhXg4JHLBLwKWI7WYc2GrcGR/wasu1xpRjHo+OU=;
        b=asW2FQgH9lsJwCZUStygy9NAMM4mxbFfM2HcKV8/1Y59QDgMnMAELSQtwM7Cd+t6qp
         JifQNL4OSp21ZBS3tipL/BvPDCTJOGn9orKHVjONzBNHSn9Gxbwg9XBPf3wF/AWtegeo
         fW3zDW7UZz39F/iWSmZ74bWFN9JSwOW3pZtA/aAoNw6BVnt/FcJypLmBq9ieaU/JyDO+
         5++aubBnFPYBt+xR+OMIbHBxPqw12Ik8/3AAfHX4JVPpIB0aS6B4Me8tLlbGZiFy5UsX
         RGuv06ZI4X4lkhaJfaqTo6uNjD96FNkvYDBUMRnnGgSI9nEmCiQmrjWZCm6587eKeHZq
         k7Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258722; x=1773863522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bVMnNhXg4JHLBLwKWI7WYc2GrcGR/wasu1xpRjHo+OU=;
        b=MN7r0sTbrowYgCDFWmnWi/vBaKEF4SnNtQnputBJMIcEKaz6Fl6Yi+20H2uB0/twGS
         0uWEAJstaw15NhLh5ONXRBKTMog0dTxrQaj6U4K6Oa1IyPHaq7IceMPbH1IaWm/PM/d5
         kLg2pHp0K2eVMHV90+qRrO8CZ3/Z0XKK+JZX0agqkYC9HG4uRIkApqUQVUegRQ8VpfSQ
         GLNugQvNDhW7I/JYrgx8gKEnTBTupwMGzGoZaCg+X0W4b294sQblCAMNlUzG48ulR9IM
         DxE7dOPAzdqr1QJm3hgxJVE069u4gEW078RmF6FSGxcBA7hG/lm/QYeNJjtwPflewece
         7yEA==
X-Forwarded-Encrypted: i=1; AJvYcCWf1OLwksPj6BUQ37p3OPmKf6rbt0Vau4yHwi++E5uXyVvobQQzBOPhotOgMWgZ1MKjrMtcgoY4vQ==@kvack.org
X-Gm-Message-State: AOJu0YwQN4ReKrM24WYn9/mU44RUbHEPwyEOPV9RvUmu5u/YoAx9NUGb
	fQIJj9ssnYUpervFzM+pXwwylt6+v0qNF+JNMiSi4GX+xVjVDIAPieiI
X-Gm-Gg: ATEYQzyJNKK2Ki/EqV2Kq78qv1r0NhFW1TezvwP0v1hvDKfpi/CiZe+rRg1Qy0o7/jO
	N7NPnvrC0EyqUEhsoxCyJWfo/ClWRLCFGIzv6LOsUmB/o69kreqfgJyC8XzZ6Q1SIObozM7Pvdg
	9AQH950z62DiZPtclBZ6X5Kcxc2XWkXdUr5gFS2PaJB6GC3ptiAHW7owREpdn5n5FTTida7/EPt
	tvuua6YAVfK7cV0cbx4QWEbapG+n8sVDxHCiLxsKfHbjJhYzRbJFNJZmOg4hTpm7x2S1nhTCXho
	kvYJWm8iJTUlGkohJF76UYnWjeb5aVfDVbTOvpPNApWhkdDwqUd/NlD0zyYNnbDjiHja54iIGNR
	nmGxJ9Zr8dUm0YiX7x1B4kAu1de0eBuqWmmMY49U8dOSSKLS+O6bs7Ldk07XlNewl5YDSSXc7Js
	/nkALTvcx2OBugzGSckALeAMCZVtML
X-Received: by 2002:a05:6808:1b1e:b0:467:baa:ed5c with SMTP id 5614622812f47-467333f24demr2109453b6e.12.1773258721631;
        Wed, 11 Mar 2026 12:52:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46733f23116sm1835915b6e.0.2026.03.11.12.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:00 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 05/11] mm/zsmalloc: Store obj_cgroup pointer in zspage
Date: Wed, 11 Mar 2026 12:51:42 -0700
Message-ID: <20260311195153.4013476-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9rt7hipyfymwnuksdprznxguwa599rix
X-Rspam-User: 
X-Rspamd-Queue-Id: AE81B100015
X-Rspamd-Server: rspam12
X-HE-Tag: 1773258722-548390
X-HE-Meta: U2FsdGVkX1+3AhoCT527ynlQujl3CFwz4aAjynbQkTQCqySlvilfjVKoHzHBTTYDr8UuZhAgLFuXPDT7F/EiYITaY2qgpHqczS8jzMPDOApagz8f/KH5tnjAgapMvbQprgpdfPEKC7R1Iwc+1ml+3A8PMM0YrIT0gq/SPckuxXTU8WK35RYRlC5NZD37qpbd7grCcqnAjz/PZzX4TC4AuiQLMLL070x4Ts/yUQNMXZNhuz6P1sWKZb57g4NFaQvimfnNQAOnejLWKEIPppeEIV2IB8BfckBnVhZM6I7jM6vjDFMAxH+VAUzTx+dIJxXn7ZHldIm2ReAUJ/l3yXTiHHkc0nQpq58sgJhej/rVZuXN4shEqRNuh1sciE+vB3NAtMZ1/SmDPBagHsYZMj7QFTD/JY3j5HlZjtEcaP2gJm/dPHWIDgxGhZQAApHVI6E0LfaUmLTqhBexPo5uE19nLVTSCP6/iQHVTHQV2KkIQ8VYQ2FV37+SGAwlEr8v7+X97MYDJJkP3vCo4ynp6+qkgm3Fli5hRqqa5YrTmbKJEy4nV2Uk9rntsBiGej9pyrZ+lSUMmy/6NqKwtgYZnJqPh72/pFQEF8BJyFTMAZliC6YXTlp+8OP0CqO6gj5LY3Kc8PYb/M9qUSg01+EzuhwOLsF3CQMLjnX/2tQRfk655EoVrVYSedsasBv96xyvt7xFpEe2jj9c5RDi7tXZoiXqbb6I6jJe0h6kXjCTE6GJgJIM71yqYkz7Ncb3tDqWzkxCBqKHCRFGxG6CDnpW38R5/aQv4pA5pOZBNMbUj9DPLDO9lNhoC9igKKu1wciu3UXyAFzGd0tM4low0LTqq4ClH8yhAmTtGgjFRY+PAtqUi0/g2OxO/nyn07WM1QHeFuI+pojdiNGpjp5RsHFKns+wSmh/L/Ql10Xcu1eGDhJVvHqj7ncqpsb7Za/1DhhDdsNyY0ksCZlKthGxP4rZ1/y
 u6puwJws
 md2bZqC86DdUX2zAkY8qUEixxMfb/XCQLZ4KXZqsm6MVDlo02g3XXonZREDzirCAU3bK79S/ldYgJP42ZrMotCKHDN24Zhglvl7a3UTdJHsC1kg60Cx0Kr2dbpj8PUlbNUR2JoAhJeiJ7fNZODjE9d9z9gfdwG4jIO8FhYC1SbRC0PyGKw27XpbK2wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With each zspage now having an array of obj_cgroup pointers, plumb the
obj_cgroup pointer from the zswap / zram layer down to zsmalloc.

zram still sees no visible change from its end. For the zswap path,
store the obj_cgroup pointer after compression when writing the object,
and erase the pointer when the object gets freed.

The lifetime and charging of the obj_cgroup is still handled in the
zswap layer.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 drivers/block/zram/zram_drv.c |  7 ++++---
 include/linux/zsmalloc.h      |  3 ++-
 mm/zsmalloc.c                 | 25 ++++++++++++++++++++++++-
 mm/zswap.c                    |  6 +++---
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d1eae5c20df7..e68e408992e7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2232,7 +2232,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	}
 
 	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
+	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE, NULL);
 	kunmap_local(src);
 
 	slot_lock(zram, index);
@@ -2297,7 +2297,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 		return -ENOMEM;
 	}
 
-	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
+	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len, NULL);
 	zcomp_stream_put(zstrm);
 
 	slot_lock(zram, index);
@@ -2521,7 +2521,8 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		return PTR_ERR((void *)handle_new);
 	}
 
-	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
+	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer,
+		     comp_len_new, NULL);
 	zcomp_stream_put(zstrm);
 
 	slot_free(zram, index);
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 24fb2e0fdf67..645957a156c4 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -23,6 +23,7 @@ struct zs_pool_stats {
 
 struct zs_pool;
 struct scatterlist;
+struct obj_cgroup;
 enum memcg_stat_item;
 
 struct zs_pool *zs_create_pool(const char *name, bool memcg_aware,
@@ -51,7 +52,7 @@ void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
-		  void *handle_mem, size_t mem_len);
+		  void *handle_mem, size_t mem_len, struct obj_cgroup *objcg);
 
 extern const struct movable_operations zsmalloc_mops;
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index dcf99516227c..d4735451c273 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1195,7 +1195,7 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
-		  void *handle_mem, size_t mem_len)
+		  void *handle_mem, size_t mem_len, struct obj_cgroup *objcg)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1216,6 +1216,11 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
+	if (objcg) {
+		WARN_ON_ONCE(!pool->memcg_aware);
+		zspage->objcgs[obj_idx] = objcg;
+	}
+
 	if (!ZsHugePage(zspage))
 		off += ZS_HANDLE_SIZE;
 
@@ -1388,6 +1393,9 @@ static void obj_free(int class_size, unsigned long obj)
 	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_zpdesc);
 
+	if (zspage->pool->memcg_aware)
+		zspage->objcgs[f_objidx] = NULL;
+
 	vaddr = kmap_local_zpdesc(f_zpdesc);
 	link = (struct link_free *)(vaddr + f_offset);
 
@@ -1538,6 +1546,16 @@ static unsigned long find_alloced_obj(struct size_class *class,
 	return handle;
 }
 
+static void zs_migrate_objcg(struct zspage *s_zspage, struct zspage *d_zspage,
+			     unsigned long used_obj, unsigned long free_obj)
+{
+	unsigned int s_idx = used_obj & OBJ_INDEX_MASK;
+	unsigned int d_idx = free_obj & OBJ_INDEX_MASK;
+
+	d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
+	s_zspage->objcgs[s_idx] = NULL;
+}
+
 static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 			   struct zspage *dst_zspage)
 {
@@ -1560,6 +1578,11 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, dst_zspage, handle);
 		zs_obj_copy(class, free_obj, used_obj);
+
+		if (pool->memcg_aware)
+			zs_migrate_objcg(src_zspage, dst_zspage,
+					 used_obj, free_obj);
+
 		obj_idx++;
 		obj_free(class->size, used_obj);
 
diff --git a/mm/zswap.c b/mm/zswap.c
index ff9abaa8aa38..68b87c3cc326 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -852,7 +852,7 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 }
 
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+			   struct zswap_pool *pool, struct obj_cgroup *objcg)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -912,7 +912,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		goto unlock;
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
+	zs_obj_write(pool->zs_pool, handle, dst, dlen, objcg);
 	entry->handle = handle;
 	entry->length = dlen;
 
@@ -1414,7 +1414,7 @@ static bool zswap_store_page(struct page *page,
 		return false;
 	}
 
-	if (!zswap_compress(page, entry, pool))
+	if (!zswap_compress(page, entry, pool, objcg))
 		goto compress_failed;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
-- 
2.52.0


