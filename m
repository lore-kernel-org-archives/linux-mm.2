Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B1DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 06:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E796B0088; Thu, 31 Jul 2025 02:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE9B6B008A; Thu, 31 Jul 2025 02:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96596B008C; Thu, 31 Jul 2025 02:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B7FE46B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:51:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 605E680950
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:51:01 +0000 (UTC)
X-FDA: 83723637522.19.FCE0429
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CC7C20002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:50:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H9orBLwb;
	spf=pass (imf13.hostedemail.com: domain of 3UhKLaAoKCO0gXRWPgSnRRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--richardycc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3UhKLaAoKCO0gXRWPgSnRRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753944659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGUE3+fkLdFpOKkrsZLlRFaze4JHwy3kWJ1YQNILIOw=;
	b=tJNlge1dEZ4EopyZwiSKY6SElrvyeLehbQ4cqdS9z4z5yZrLdtkkkyjb/Gt066NyZN8trA
	SVoNAg3CixUryx0eFCmqYBhV+UELj3Y40H24MW29IJIukXEWtK1MYrTm+j6wWINLcFbbAp
	ZI+VJhTIdXnJljFQq05SJa5NXT5lGJY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H9orBLwb;
	spf=pass (imf13.hostedemail.com: domain of 3UhKLaAoKCO0gXRWPgSnRRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--richardycc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3UhKLaAoKCO0gXRWPgSnRRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753944659; a=rsa-sha256;
	cv=none;
	b=6PHMhsqEF9qwJFTB1s5gdvxtufyud9o7SOrQrVQueUKSBz9DBqYAuj8Q0fccwx5AptIafc
	2lpmfVdtLHHcz9xMMZQLljvEx3W1Xpq74IeJVuu4C2Se/b/0ffIQX4XpGcfMECgrifCN4r
	YSWrzfVi+8nb2dx5FLyCyrwVonk7tRY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3bde4d4d5cso461076a12.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 23:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753944658; x=1754549458; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGUE3+fkLdFpOKkrsZLlRFaze4JHwy3kWJ1YQNILIOw=;
        b=H9orBLwbeAantN8MR9Y8QurAFO658y+jqxTfKyXv4oV1QLXTZyZWMsrfutVCMGVgcY
         LZZtDpIQzSgtOvk2St+76vtikDZCleIKeCap/uf7stP9dXvYxViUncWV8TtqcjLWIOb+
         h4d06MilLL52l1+PGzT6vjkS6Ql4xagGeMF5QiWgc08h+xVjXGf1wFkqr3G2xzpE8m3Y
         QffZTpNjXqSV+f+q6MvMmljXVcSl9h7KxhJxJeG6+C8N50264JFUFkfsx4tcL3BkAIPj
         kmdc5z/SPom9YCgSndVJ6ibStyBtcTd5qDRvnTPDWlaOML4AxjSv3I7NB3vwIda+1I9u
         q38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753944658; x=1754549458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGUE3+fkLdFpOKkrsZLlRFaze4JHwy3kWJ1YQNILIOw=;
        b=PFbWluy2tUgL0T88+P62/QitA6NyjNBWraUc48XEb0Ut7SREpNsbTpSVfKpsofOq17
         wCCEcEF2XYujxxn83c1XvGnKAiX/JWdrhoDpu75UwATb0oXmy/HH2qWauCyqmmJ0BVxM
         /ZP3VRFRkhX9ERTay0jZ4gcdq4e1SHviHzZXpo618wXsF8pdtjdE1mdJmFsFvpcSVnRA
         ePpGXeSbe68FuWMkvesCiNoomQ4O6lgpRXuDw7AD1Wx6JWSipziShXwov2srD8JA61ls
         TfGLaWmy6oOj4oyum/IQuChemT2574lUtdnh/pg+7SGTt5MXEzQsYclLGoz4IfIYclko
         DOtA==
X-Forwarded-Encrypted: i=1; AJvYcCUGx7wMl5vZir/L5aACRkoNRU2snkCEI2RFM/Qrupf8bqJ32zebFWhyqBJVtEGJfTsvhlXaev4TwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1OY2FEJf/uYhMSVSq24em1XFaC4KnpgEQQikHey80nGemJdNl
	d2zl+rAOEFwzfjbcZQ8uNiLj0ECA2aO99Fxa5R75Ce7dfX7bUYNJ36QN0IAv7Od13+XPgrGIyAm
	tvxeFn99PzEDI0gzcX1mY
X-Google-Smtp-Source: AGHT+IEgVBWm/BLKTiVc6BPX/+JCFhdiQ8GmUIXhRNeX1+TmocJCuFg4OY1N6Lq5dY3Gt40NAXUyRmKvEykmSYEi
X-Received: from pgah15.prod.google.com ([2002:a05:6a02:4e8f:b0:b42:2a6f:4fcc])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6da1:b0:233:d85e:a69b with SMTP id adf61e73a8af0-23dc0eba156mr9493234637.39.1753944658322;
 Wed, 30 Jul 2025 23:50:58 -0700 (PDT)
Date: Thu, 31 Jul 2025 06:49:47 +0000
In-Reply-To: <20250731064949.1690732-1-richardycc@google.com>
Mime-Version: 1.0
References: <20250731064949.1690732-1-richardycc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731064949.1690732-2-richardycc@google.com>
Subject: [PATCH v2 1/3] zram: refactor writeback helpers
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tni6f597urd7rydsayc7suemp4x1zok1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CC7C20002
X-Rspam-User: 
X-HE-Tag: 1753944659-31028
X-HE-Meta: U2FsdGVkX19/Qs5LhLLOPwH1P/vDoFUfjrlJgshzu3TdNqTk1zK/nBpbEhArtP+UDM3soKcgKwVns3H0z7aOXWgOaJI577EJW2FQT3k9EATp4PFplNOCLl5IcmJbhaJjbQ75xRD4dsTbxP8KlqixA5GktGIKpcCoSQKb80RFfbVqV3APbxE77mCF0suBvEa6z6YcUEzd0yjeLOHWYdcmEDhGULHKczqcokYhd2K5SpHOWk3L5P4g+7JxKg/WM2KUBV9ExErnwF5+r5ZDAzckAbUlfp+Re1bDE3qjlDl96e3VtqyqdOJtI/75HS0xuh0oPRbpAp22A7jD2eLEjIdyknHj/Ux1bvhHs53ziAD4o6XBGbCQpbkVbMOVTbc1n7hroFM58TiUTLYt2UnG9sSeuZZfRgzDLetSjTkNofGPPkXvhGffn1cneMN9jXwOofogK4L9JUTFQ+vBlxFp3krQxToarGHcG9xcO8knjGX0RTZ+o0Xfv0vax0xU1W/FHCOqWQjTFaHw/5k7W5TqqQspjFSMRGhTb4vUhBadEESHLe31cXZECxhRhfb9/cZapapVgTdjs1RPY/zaEaYfl4Yw5Y3OO7myntaQaIkv9STod26YfKSvtD5vXXVDcYNpt2RPrP+h9LE79+uf/tsUfTDHInA0+FtrSjUbgSnv0sL22ZdRuFQ4mPNXxsJp83PFlGaivGdSRvI0iS89FyC1maWfr6ewUbKxLDsuaksQnbL2DzPDm9uszwrk5ljXdxqIdbByVidR3EoMx4KDugmFYuJPdOTK4X3AKHPzLoMnhtvk6O4Bx88xOnEPrlm51LCK2gBYRQ8yjYX5As8j87e/lw1SvFH/W8C+2x/hMdaFGrRwD024K454aexsoefE4C5Y5VpOn4ktQGmGaAZSC5JJYPwBQC3nrgO+aGOib2B8Ib2u39Zl81JQQecsDjXxbM1Hhr7gTIim2m7CXDTyuxoTJSS
 ZmuD24W6
 4diEAwLiIsksgzeLHeXa9I7HA0RLIw7CVDPIyKgdyjPJYIxXFRcBR/FNTqINtckiRFz/8tRXk+PUWwxxe860nXHkhdEcf2PEZ1dV5GzhMwFoKW4jVIH9DmcRqC/8vPuz1FbjRFfRRfyQtvzp+CuumNH5akN4j/ORBmPpWUhMvh4RwmuwEb5zwTbCFVTh3XwBPBspuP8bZud9TcGSv4yPf3+dLgoZ6vTV2vujHoR0dTlLsklHloOozofrLp6LU6j42PMp0qiT9Q6RExdn3zDTJP7wF0uioyNUzL0u3cD6EqdKjd/YvtoVMYmdksLevI998lQGmfNYXNx+dvfquyFhfXpEKktZfgcHYpZon57vbwLSNEC5xEcLrVW0Tplj+Qbhd6G31IL6GNoEV2fC5M/vhguVXWbLJRqs3tjrI49PkPNSstUQ0GjI5n7UI71xbDkFGiGr3xtkM0TmM9wtjeAi3hjemFc/rwZzMXcruk1v2McYzKAxZlnnVzkXpZL9j8R+Q33PAdnCSH//AbJvKEf9u55ULHyB4qHGruMKCLrTg/Vf2ymDsIecEVxd2PldpzZ4WeHrkyzCzQeDWl14EaOV1RrbpDVVVqR818E7qWMWt1oScM3XfABSgKTSigTlV+BBl/G8czdjminda23M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move writeback-related functions and data structures from zram_drv.[ch]
to a new zram_wb.[ch] file. This is a pure refactoring patch with no
functional changes, preparing the ground for the upcoming asynchronous
writeback implementation.

Signed-off-by: Richard Chang <richardycc@google.com>
---
 drivers/block/zram/Makefile   |  1 +
 drivers/block/zram/zram_drv.c | 44 +----------------------------------
 drivers/block/zram/zram_drv.h | 19 +++++++++++++++
 drivers/block/zram/zram_wb.c  | 35 ++++++++++++++++++++++++++++
 drivers/block/zram/zram_wb.h  | 18 ++++++++++++++
 5 files changed, 74 insertions(+), 43 deletions(-)
 create mode 100644 drivers/block/zram/zram_wb.c
 create mode 100644 drivers/block/zram/zram_wb.h

diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index 0fdefd576691..31ee1ed34e17 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -8,5 +8,6 @@ zram-$(CONFIG_ZRAM_BACKEND_LZ4HC)	+= backend_lz4hc.o
 zram-$(CONFIG_ZRAM_BACKEND_ZSTD)	+= backend_zstd.o
 zram-$(CONFIG_ZRAM_BACKEND_DEFLATE)	+= backend_deflate.o
 zram-$(CONFIG_ZRAM_BACKEND_842)		+= backend_842.o
+zram-$(CONFIG_ZRAM_WRITEBACK)		+= zram_wb.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8acad3cc6e6e..ec8649cad21e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -36,6 +36,7 @@
 #include <linux/kernel_read_file.h>
 
 #include "zram_drv.h"
+#include "zram_wb.h"
 
 static DEFINE_IDR(zram_index_idr);
 /* idr index must be protected */
@@ -233,22 +234,6 @@ static void zram_accessed(struct zram *zram, u32 index)
 }
 
 #if defined CONFIG_ZRAM_WRITEBACK || defined CONFIG_ZRAM_MULTI_COMP
-struct zram_pp_slot {
-	unsigned long		index;
-	struct list_head	entry;
-};
-
-/*
- * A post-processing bucket is, essentially, a size class, this defines
- * the range (in bytes) of pp-slots sizes in particular bucket.
- */
-#define PP_BUCKET_SIZE_RANGE	64
-#define NUM_PP_BUCKETS		((PAGE_SIZE / PP_BUCKET_SIZE_RANGE) + 1)
-
-struct zram_pp_ctl {
-	struct list_head	pp_buckets[NUM_PP_BUCKETS];
-};
-
 static struct zram_pp_ctl *init_pp_ctl(void)
 {
 	struct zram_pp_ctl *ctl;
@@ -697,31 +682,6 @@ static ssize_t backing_dev_store(struct device *dev,
 	return err;
 }
 
-static unsigned long alloc_block_bdev(struct zram *zram)
-{
-	unsigned long blk_idx = 1;
-retry:
-	/* skip 0 bit to confuse zram.handle = 0 */
-	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, blk_idx);
-	if (blk_idx == zram->nr_pages)
-		return 0;
-
-	if (test_and_set_bit(blk_idx, zram->bitmap))
-		goto retry;
-
-	atomic64_inc(&zram->stats.bd_count);
-	return blk_idx;
-}
-
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
-{
-	int was_set;
-
-	was_set = test_and_clear_bit(blk_idx, zram->bitmap);
-	WARN_ON_ONCE(!was_set);
-	atomic64_dec(&zram->stats.bd_count);
-}
-
 static void read_from_bdev_async(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent)
 {
@@ -1111,8 +1071,6 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 {
 	return -EIO;
 }
-
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
 #endif
 
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 6cee93f9c0d0..2c7bc05fb186 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -139,4 +139,23 @@ struct zram {
 #endif
 	atomic_t pp_in_progress;
 };
+
+#if defined CONFIG_ZRAM_WRITEBACK || defined CONFIG_ZRAM_MULTI_COMP
+struct zram_pp_slot {
+	unsigned long		index;
+	struct list_head	entry;
+};
+
+/*
+ * A post-processing bucket is, essentially, a size class, this defines
+ * the range (in bytes) of pp-slots sizes in particular bucket.
+ */
+#define PP_BUCKET_SIZE_RANGE	64
+#define NUM_PP_BUCKETS		((PAGE_SIZE / PP_BUCKET_SIZE_RANGE) + 1)
+
+struct zram_pp_ctl {
+	struct list_head	pp_buckets[NUM_PP_BUCKETS];
+};
+#endif
+
 #endif
diff --git a/drivers/block/zram/zram_wb.c b/drivers/block/zram/zram_wb.c
new file mode 100644
index 000000000000..0bc10f725939
--- /dev/null
+++ b/drivers/block/zram/zram_wb.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define KMSG_COMPONENT "zram_wb"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include "zram_wb.h"
+
+unsigned long alloc_block_bdev(struct zram *zram)
+{
+	unsigned long blk_idx = 1;
+retry:
+	/* skip 0 bit to confuse zram.handle = 0 */
+	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, blk_idx);
+	if (blk_idx == zram->nr_pages)
+		return 0;
+
+	if (test_and_set_bit(blk_idx, zram->bitmap))
+		goto retry;
+
+	atomic64_inc(&zram->stats.bd_count);
+	return blk_idx;
+}
+
+void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+{
+	int was_set;
+
+	was_set = test_and_clear_bit(blk_idx, zram->bitmap);
+	WARN_ON_ONCE(!was_set);
+	atomic64_dec(&zram->stats.bd_count);
+}
+
diff --git a/drivers/block/zram/zram_wb.h b/drivers/block/zram/zram_wb.h
new file mode 100644
index 000000000000..c2f5984e7aa2
--- /dev/null
+++ b/drivers/block/zram/zram_wb.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _ZRAM_WRITEBACK_H_
+#define _ZRAM_WRITEBACK_H_
+
+#include <linux/bio.h>
+#include "zram_drv.h"
+
+#if IS_ENABLED(CONFIG_ZRAM_WRITEBACK)
+unsigned long alloc_block_bdev(struct zram *zram);
+void free_block_bdev(struct zram *zram, unsigned long blk_idx);
+#else
+inline unsigned long alloc_block_bdev(struct zram *zram) { return 0; }
+inline void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
+#endif
+
+#endif /* _ZRAM_WRITEBACK_H_ */
+
-- 
2.50.1.565.gc32cd1483b-goog


