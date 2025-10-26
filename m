Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D71CDCCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21E98E0186; Sun, 26 Oct 2025 16:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BE78E0184; Sun, 26 Oct 2025 16:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FF68E0186; Sun, 26 Oct 2025 16:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 674958E0184
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29BE7B833B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:35 +0000 (UTC)
X-FDA: 84041423550.19.2B97717
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CEB11C000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mKfguIFw;
	spf=pass (imf18.hostedemail.com: domain of 3UIb-aAYKCKUXZWJSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--surenb.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3UIb-aAYKCKUXZWJSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldBBc2e1dfbyRaOTMu7xgu9ZtisaUPfuPL5Tr5iIwBM=;
	b=CATobxl3d9Ru1bLoYCHhzt02eBfLzcVU9mrcjClF6ga5cFZBnnWN0Q+2yPb1Zt61wNQ9Ek
	5DFgTOU9ADwFjRvX9xXZp5gTCf23Cgfa/sT5ahwsRgDZXu0vrznO1RC+y0G2BMRfbF/4TX
	iP2jpf5P7Dh/n8IN8a6cG5v7+af/GSs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mKfguIFw;
	spf=pass (imf18.hostedemail.com: domain of 3UIb-aAYKCKUXZWJSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--surenb.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3UIb-aAYKCKUXZWJSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510993; a=rsa-sha256;
	cv=none;
	b=Db9C0PNEDD/Bd2ETqoDPR4Z/xkOKp35Z/KnVkMhdKSIXEkpq5t6ZRAKpG8eg/LwQoYK6It
	rVGps/3ncjykymBgqwtpaIpURldi+U7urHsWymb63mIQxgmOtaj6+1t83XP9ECgJpxr5pi
	F/KiVFqztAJ8NbzCgiSSige1RmS2tK4=
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-7849f67aa1cso49514527b3.1
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510992; x=1762115792; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldBBc2e1dfbyRaOTMu7xgu9ZtisaUPfuPL5Tr5iIwBM=;
        b=mKfguIFwGmvHAjOOcB+OqHcSeKYBzUiehDLge6wqqtHRzgjI18vNJOQudpwBmTAbvt
         UnydSqBvgtPxn2oJaqZpqS2PHVi5AOJrlyJW2lS8sL4I1ZKuWFJB7ipW1v/RdBQdFujr
         VJvpOPal4MZS3r5ssMs5jutjcHKOgdFlk1r3sHyKyjAPxlJw4yVvtAxsn92dLS9xj6x/
         jxAGkBNs1JYMRBj4FP9cUV5ZFNvi9ZLvo0ocQYsOHDwcUVtNL/W8Q4vLD+qrzsjnuEhj
         hhbl8QdYFQu00fX/3W+XvAUxRLZTiaPri9oRi+lOLLPAHYxElx2nhbKuEjs4vOvyNTMt
         kIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510992; x=1762115792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldBBc2e1dfbyRaOTMu7xgu9ZtisaUPfuPL5Tr5iIwBM=;
        b=H5yqsrLCW1vdCIElDoaBwSE3VXeVe1RU+TSR73790MMcU7jfGhzFQ5MpdLBHCgLyLm
         2k4ap2ZzKXr8a/hGj9qI6StxJ1dW3+Qb2tgO1OOycfcJclVc1IQXIHOTnBIEE2Ja0E2z
         B62svAOuQlApcws2rkrakQxjrnqzbErJ899KdDJopiWOu57aSK9Ydwe+IV9YKAAAIdi1
         aCoZV6Wu2ikH8/Edl3mNbdpZApN+9qAvIiDBlFrmsAl6OxYGb63TG2NavGeH76M2d9mH
         yk5nvQof6/jBvPnqq9Pv7qhiPQiF4px+2GKATsIf/mZRe5e4iU/KEyRXVwSCbpihh114
         k0Vw==
X-Forwarded-Encrypted: i=1; AJvYcCX0lpqwmHFGQL187RiDDswa9ycubw6xjh8JFPz8NJPWFygD5AGhx1OPq9FTdnAtQhBAHY81ftskbw==@kvack.org
X-Gm-Message-State: AOJu0Yz9ju64HfCEkLzPYLpu9RHs2yvXzNEFFrgvzUoJbvDQawkuN2NA
	k4jY1fkROx0zgDVPW3JneiNhab1OPD83qP5f+fYHsk3dveTJiEdYCevRcDhaBAtb8KP1Za/5P/1
	6Wb3mjQ==
X-Google-Smtp-Source: AGHT+IHTjjYIfLTQVYwrbFnLFzysSRA0cI7//o4uCjgZD63uA+e+/DxWUL27OlXKaVk1obVSWsBkcP+KEyM=
X-Received: from yxf19.prod.google.com ([2002:a53:b113:0:b0:63f:2d9a:6526])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a53:b118:0:b0:635:4ecf:bdc6
 with SMTP id 956f58d0204a3-63f435602d0mr7203026d50.40.1761510992511; Sun, 26
 Oct 2025 13:36:32 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:11 -0700
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
Mime-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-9-surenb@google.com>
Subject: [PATCH v2 8/8] mm: integrate GCMA with CMA using dt-bindings
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jhtm7z191u3puhwotu8xnz57gwm5u4f5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5CEB11C000A
X-HE-Tag: 1761510993-502145
X-HE-Meta: U2FsdGVkX1+0UzPuXegWyrZt2XHhzNqZ9EhYrM97zNPMz52lxQPwYOJeIt93WUkO1JtjyT/C/rnhJzmIsDgm9sDu9FM0IXppExD7V+lv1W25E5mUMooG9szu6rG/1TsqJN/7LbTCxTmuOK2A7Om2i3rpn0rlhdohEaDGywMb4lOT+GsYDXg5dnhVVhZhd/GkcoSdg1MqdZPH1q51n8jEGG9NMBI9R+OS1/FitoIThH7YEm2KzNRfnimQ/Noc7b6dMx/qLW5IzQjQosfnIviYSWVzUZ99fymoOUJ+a534FNbMbPTMdbghYOfxu7E0iFBz7EksZU12C8JmCYMU9+plg0B2JdEDridjKzKW4eEEVh7g449K5cAmg75V4TqflWM3c+6B0ZBumCw35CD/puULpZ04YHZU2EmGg1gbZNe7704v9UO906JHYIe0WwY/jEByvWL9ZKiycnkkTtnsKpiR14UEER76hv75EGUCPhGDmXfK35kR9xIHOiCn1Yiu+VP8mPip55qtz45pKoZhcW3mvhbXhLkprJE/vt3grLz5sOX6xLb+wCns9mVcOn49M53TYpKYboXpUsgSLWQ/y7+mu4rXlvbwRGVjIbi8Yh7EJfwW//ku9xlgJfVH8scJY0jUhkPhu8ZGTR3PL6J1txpTWWZ6g7+uOpm3pUqph8tRckalUigtMgvU5cgTRzs4iLztMLx2QOD7Kr7XX/XJMpQFQvA2NtHKuRmWsm1MJdDvXLli0HhhwnfoH5nkYls9qhosaQrKe4/RIevWb7zhy56Am7HLxSN8e3GTqyeDRUamumvOTA+OtZJ1Uk1N+np8Z2aRi2w7Yp6tIdv7eNTxKuzFNOJYvJvsFJGiFpJr9duZ4nfV5TFh/UGbQBryc/Mo9SooCnSohdht5Ag1vomHcEIZ1WDNK8TQqX/A+I2FEqKXzfTIQLkZ73wNyZo5LYmupK2Pry3Tvs+pVIWfYnIJ5t8
 xNh1RFPU
 CXIdrmL0Vys8LO+SpZ5xLxVoF0sE5VDgbjFeqX3bZ7MY7VutdqWRqrXphBlejkpvFOEjSnmcyDKCYhEMpteu52C8DZq1QeHM2qRY7B2tTr9VymbXtNmi2WBJ3SS8pEqavwxqUCpRvaBlk/z38TrNbx+80P5r/TGNxHc3C5ko+aZM9ulC0HWWbBcGiCs9ZYmGaq3K+qZGZm7gxSCe9k7VKLUHXKvR8Ok6H0Rr8rfmW07cx5Vfwlsa2R1hwOcBCe+ojVII6YPa7dbLsfH4TBLsd+C4DCQAhEIf0HefktPnClpBjSQucN52syxVztgZDjlWCRucxDaFbKKRgVjts0j5a2FtY8bfNevlyfIU5vHNZUdaKx6909lswouB8si0KGwMlOOXRFOO63eheb9p10QBKRlObFlJC0ovOhVCUKMqegpEW//RdXQuerula7wahuEVkQl69ZeuuZPUi/HlxUSXoXYbWVBeBDcqb1BOvbWoOkv18dyb3fSFOfIJAB0OLfKsXk1D3ndJuCpuCDY1FCrUeFo3eeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new "guarantee" property for shared-dma-pool to enable
GCMA-backed memory pools. Memory allocations from such pools will
have low latency and will be guaranteed to succeed as long as there
is contiguous space inside the reservation.
dt-schema for shared-dma-pool [1] will need to be updated once this
patch is accepted.

[1] https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/reserved-memory/shared-dma-pool.yaml

Signed-off-by: Minchan Kim <minchan@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/cma.h     | 11 +++++++++--
 kernel/dma/contiguous.c | 11 ++++++++++-
 mm/Kconfig              |  2 +-
 mm/cma.c                | 37 +++++++++++++++++++++++++++----------
 mm/cma.h                |  1 +
 mm/cma_sysfs.c          | 10 ++++++++++
 mm/gcma.c               |  2 +-
 7 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..3ec2e76a8666 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -43,10 +43,17 @@ static inline int __init cma_declare_contiguous(phys_addr_t base,
 extern int __init cma_declare_contiguous_multi(phys_addr_t size,
 			phys_addr_t align, unsigned int order_per_bit,
 			const char *name, struct cma **res_cma, int nid);
-extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+extern int __cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					const char *name,
-					struct cma **res_cma);
+					struct cma **res_cma, bool gcma);
+static inline int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+					unsigned int order_per_bit,
+					const char *name,
+					struct cma **res_cma)
+{
+	return __cma_init_reserved_mem(base, size, order_per_bit, name, res_cma, false);
+}
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
 extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index d9b9dcba6ff7..73a699ef0377 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -461,6 +461,7 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 	unsigned long node = rmem->fdt_node;
 	bool default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
 	struct cma *cma;
+	bool gcma;
 	int err;
 
 	if (size_cmdline != -1 && default_cma) {
@@ -478,7 +479,15 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 		return -EINVAL;
 	}
 
-	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
+	gcma = !!of_get_flat_dt_prop(node, "guarantee", NULL);
+#ifndef CONFIG_GCMA
+	if (gcma) {
+		pr_err("Reserved memory: unable to setup GCMA region, GCMA is not enabled\n");
+		return -EINVAL;
+	}
+#endif
+	err = __cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name,
+				      &cma, gcma);
 	if (err) {
 		pr_err("Reserved memory: unable to setup CMA region\n");
 		return err;
diff --git a/mm/Kconfig b/mm/Kconfig
index 3166fde83340..1c8b20d90790 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1099,7 +1099,7 @@ config CMA_AREAS
 
 config GCMA
        bool "GCMA (Guaranteed Contiguous Memory Allocator)"
-       depends on CLEANCACHE
+       depends on CLEANCACHE && CMA
 	help
 	  This enables the Guaranteed Contiguous Memory Allocator to allow
 	  low latency guaranteed contiguous memory allocations. Memory
diff --git a/mm/cma.c b/mm/cma.c
index 813e6dc7b095..71fb494ef2a4 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -28,6 +28,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
+#include <linux/gcma.h>
 #include <trace/events/cma.h>
 
 #include "internal.h"
@@ -161,11 +162,18 @@ static void __init cma_activate_area(struct cma *cma)
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+		} else {
+			count = 0;
 		}
 
-		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
-		     pfn += pageblock_nr_pages)
-			init_cma_reserved_pageblock(pfn_to_page(pfn));
+		if (cma->gcma) {
+			gcma_register_area(cma->name, early_pfn[r],
+					   cma->count - count);
+		} else {
+			for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
+			     pfn += pageblock_nr_pages)
+				init_cma_reserved_pageblock(pfn_to_page(pfn));
+		}
 	}
 
 	spin_lock_init(&cma->lock);
@@ -252,7 +260,7 @@ static void __init cma_drop_area(struct cma *cma)
 }
 
 /**
- * cma_init_reserved_mem() - create custom contiguous area from reserved memory
+ * __cma_init_reserved_mem() - create custom contiguous area from reserved memory
  * @base: Base address of the reserved area
  * @size: Size of the reserved area (in bytes),
  * @order_per_bit: Order of pages represented by one bit on bitmap.
@@ -260,13 +268,14 @@ static void __init cma_drop_area(struct cma *cma)
  *        the area will be set to "cmaN", where N is a running counter of
  *        used areas.
  * @res_cma: Pointer to store the created cma region.
+ * @gcma: Flag to reserve guaranteed reserved memory area.
  *
  * This function creates custom contiguous area from already reserved memory.
  */
-int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
-				 unsigned int order_per_bit,
-				 const char *name,
-				 struct cma **res_cma)
+int __init __cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+				   unsigned int order_per_bit,
+				   const char *name,
+				   struct cma **res_cma, bool gcma)
 {
 	struct cma *cma;
 	int ret;
@@ -297,6 +306,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	cma->ranges[0].count = cma->count;
 	cma->nranges = 1;
 	cma->nid = NUMA_NO_NODE;
+	cma->gcma = gcma;
 
 	*res_cma = cma;
 
@@ -836,7 +846,11 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		if (cma->gcma)
+			ret = gcma_alloc_range(pfn, count, gfp);
+		else
+			ret = alloc_contig_range(pfn, pfn + count,
+						 ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -1009,7 +1023,10 @@ bool cma_release(struct cma *cma, const struct page *pages,
 	if (r == cma->nranges)
 		return false;
 
-	free_contig_range(pfn, count);
+	if (cma->gcma)
+		gcma_free_range(pfn, count);
+	else
+		free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..3b09e8619082 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -49,6 +49,7 @@ struct cma {
 	char name[CMA_MAX_NAME];
 	int nranges;
 	struct cma_memrange ranges[CMA_MAX_RANGES];
+	bool gcma;
 #ifdef CONFIG_CMA_SYSFS
 	/* the number of CMA page successful allocations */
 	atomic64_t nr_pages_succeeded;
diff --git a/mm/cma_sysfs.c b/mm/cma_sysfs.c
index 97acd3e5a6a5..4ecc36270a4d 100644
--- a/mm/cma_sysfs.c
+++ b/mm/cma_sysfs.c
@@ -80,6 +80,15 @@ static ssize_t available_pages_show(struct kobject *kobj,
 }
 CMA_ATTR_RO(available_pages);
 
+static ssize_t gcma_show(struct kobject *kobj,
+			 struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%d\n", cma->gcma);
+}
+CMA_ATTR_RO(gcma);
+
 static void cma_kobj_release(struct kobject *kobj)
 {
 	struct cma *cma = cma_from_kobj(kobj);
@@ -95,6 +104,7 @@ static struct attribute *cma_attrs[] = {
 	&release_pages_success_attr.attr,
 	&total_pages_attr.attr,
 	&available_pages_attr.attr,
+	&gcma_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(cma);
diff --git a/mm/gcma.c b/mm/gcma.c
index b86f82b8fe9d..fcf1d3c0283f 100644
--- a/mm/gcma.c
+++ b/mm/gcma.c
@@ -119,7 +119,7 @@ int gcma_register_area(const char *name,
 		folio_set_count(folio, 0);
 		list_add(&folio->lru, &folios);
 	}
-
+	folio_zone(pfn_folio(start_pfn))->cma_pages += count;
 	cleancache_backend_put_folios(pool_id, &folios);
 
 	spin_lock(&gcma_area_lock);
-- 
2.51.1.851.g4ebd6896fd-goog


