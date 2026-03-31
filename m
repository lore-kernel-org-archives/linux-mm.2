Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31115FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F51F6B0095; Tue, 31 Mar 2026 06:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC0F6B0096; Tue, 31 Mar 2026 06:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6957D6B0098; Tue, 31 Mar 2026 06:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59CCE6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0473A1B8ECE
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:27 +0000 (UTC)
X-FDA: 84605913336.02.22BF4B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22764A0016
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KSo3fkb1;
	spf=pass (imf15.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FezJzULdoQbPk22pOginhl2WYIxWclyY8Ve/oKjHpyM=;
	b=OHDkz6g5UHvWLFM/cBAHo2frAFboczoXMx799vz9acmrVY3JL8Mi/ocUoUTDZxEG8pzEAW
	6zqsb8Pd4IQf7rm5mIXP4HVR4B694/FPUdVfjnR23MIRHxzccevN/BcesWTq4mRrpKhrud
	8xatvacYEcRNBGZ4eHvjA3TwnD/rIDs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KSo3fkb1;
	spf=pass (imf15.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951226; a=rsa-sha256;
	cv=none;
	b=VG6Cet51848Fv267kzp58QUsH+8Wl8ZjjJYEfD+i71m+Y9MJSAtSEnBbEwjHZLFXfAOS5n
	sFr2jvCQZsYLHxfH5uRT7DvY+rmFWdOmeHd71qAGszYqUoqR25+sTiu2rWM73YfbcHl3YX
	k3tyo6/E71xIUOxuISggmZQCrwtVol8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA85C4405D;
	Tue, 31 Mar 2026 10:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58671C2BCB1;
	Tue, 31 Mar 2026 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951224;
	bh=2RziEouTjtQzhvFU7nMRdzuP59YmynilgplJsjF6ais=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KSo3fkb1PtQO8hBEs29qrPHni57waTli1pc16dvDGP+vruzJBqN1b/Mh3z2gbXY4b
	 pLynpkymbHiKKFVCBpy3ReB0qBGpkKz3SdgJs/Z5Nvqw51SWTwsR+7U9rOA7CqAvKq
	 3p7+6dOMFrCx74lnn681dpIGoKxRac5Fgu35SxSCUbGcY1jluS/ORRA7Q/A4axey+Q
	 dyJfE6Wy+10LeISxd2Ookz/wYd8yyj38bOM3lpdjooExi7ctWdqCIc9i9mxSOXQvHc
	 U/Epv9rqd1WhzIiG6IIgc0rKuty0xmv8ycqx8pEnOvXHAInamKZsyHhXAXdzbimkzu
	 zaDi7jI+kaXFQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:10 +0200
Subject: [PATCH v4 1/8] dma: contiguous: Turn heap registration logic
 around
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-1-e18fda504419@kernel.org>
References: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7747; i=mripard@kernel.org;
 h=from:subject:message-id; bh=2RziEouTjtQzhvFU7nMRdzuP59YmynilgplJsjF6ais=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZ+tdXmoVdl/5vPUvF1WllgixQGGdU26r9Q6cajC+7
 pGo5MLXMZWFQZiTQVZMkeWJTNjp5e2LqxzsV/6AmcPKBDKEgYtTACZyiJWxTlf828uPbVLSm25/
 KUw7ffPbI8kanqSHr15/z2SOEAhVzy6+dlsmQVfox95dW30u6ptlM9anXzkuncl0x2mu4sHTHN8
 OPqyQP6NkIMtv/2GV8Ubtur95G6LKXpsWNqyKTJSdwy+vYQUA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Queue-Id: 22764A0016
X-Stat-Signature: c4yfj7pj1o1qjmzck4pnkomq54u6ct38
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774951225-160037
X-HE-Meta: U2FsdGVkX18mMoOX9djzuzN9uLhKMA3bTKgwGSuRiTFZqR1ql6CjT6X2gMGlHZ0bHKCeIibHl+sthnH6jtPM8K3bRsh1BcO+QnBiJEDeix3clViqY9Ck4kzeIjJITeQOzNnG5bYEoUjs66dQOH7k81mQRk2PJSneE5g+bu+8JH4+T41cO+rN21qjNGjLOF3rHPUu3ElLfLrv8a68RuYBHwvdR1RU4PEWum6LjZG44efjVWMHQD5hLL/yv2CpNTFaHhz1ELNVdlkasxURgOuZcGLdZ4rPQDllb7+x7Wgl6vaEcUhHCNv9XCpdxmNS695wra3HYXgClvmBnMoLFShTKgr3fPiwr2TMWoXi0f+Cup2UXDatpYrTmGwcmOPfTB4SuTWVUh7WE+PbtwOw/xUfxNqpkT/Mj/DQ7RSlEoaoFw9iPgM42ORHClhD3PkOjdzQpUgU2DI4L/f+VnIK4423NnIPxwLolDTda8rI4dCsWN9qsvc3YAqxypYiXyFdVyBhe0QWMrJSBwx9+fg71ORbrffG/DMaYZbQpMJS7KYnVDeKJuvWorqKK+Zp/5rg+qv304Kngyc/XPrGLTJGq0Wek/BngCGZyXfEtrJ4c2Mrj1YIhoXqHcTna5dgFAr3lGQlCjlfbzMz8UVR4N7mWZb3p3bUtBjRzyXyxQnAx5GlsJJP0imDckloQfoiJRiRaef6GYImvHCNsWTRHQ7HQhVHKDd7zST2E4pwJXslJc+JW4h5gCHC1vO6W63lGlTQdcEixgdJz6/RBwu1ClvurGGoRbeHD4DOuxVulTeORd2A2oImCQCEwbuVWBoOmthrF/vZk5Y+2eEATmoqD5hTXqaregP62PYFNQ1DxhNgKVK0lPfDRuR6qyNkcP9vkHy/kDS/m/JfN6wXllJubhhz+Lz26pLw/1MUOPi5qzsENmK2roYamfgHZ4N/N9c7QLqGw5thSuq3FSEUtC0GjU6fzOu
 eYLanf9P
 KknFMWhMHru3u0RZ/WrhX35iHWsfZGuHcYmUguG8LDpu6uMk47ln29bUuiYEDbL1B3uvpSkwcAToCYNrF0w0WYebYWjaaIzz4xQOuv2dI2J1NnkF4Tf9+IYHm4K5DcXowlqD6qba1g5yOgAgCXdK3ejuPfPIjtFtnOnFmHrY8OF4CJTmmemtxgFpjpRI/118wyGmmDm7vIRi0BU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA heap instantiation was initially developed by having the
contiguous DMA code call into the CMA heap to create a new instance
every time a reserved memory area is probed.

Turning the CMA heap into a module would create a dependency of the
kernel on a module, which doesn't work.

Let's turn the logic around and do the opposite: store all the reserved
memory CMA regions into the contiguous DMA code, and provide an iterator
for the heap to use when it probes.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/cma_heap.c  | 19 ++------------
 include/linux/dma-buf/heaps/cma.h | 16 ------------
 include/linux/dma-map-ops.h       |  5 ++++
 kernel/dma/contiguous.c           | 55 +++++++++++++++++++++++++++++++++++----
 4 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index bd3370b9a3f6d4e18885a1d0e8ba3f659b85ef47..33cac626da1198e3c4a1cdcd562223c1924b6ceb 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -12,11 +12,10 @@
 
 #define pr_fmt(fmt) "cma_heap: " fmt
 
 #include <linux/cma.h>
 #include <linux/dma-buf.h>
-#include <linux/dma-buf/heaps/cma.h>
 #include <linux/dma-heap.h>
 #include <linux/dma-map-ops.h>
 #include <linux/err.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -28,23 +27,10 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #define DEFAULT_CMA_NAME "default_cma_region"
 
-static struct cma *dma_areas[MAX_CMA_AREAS] __initdata;
-static unsigned int dma_areas_num __initdata;
-
-int __init dma_heap_cma_register_heap(struct cma *cma)
-{
-	if (dma_areas_num >= ARRAY_SIZE(dma_areas))
-		return -EINVAL;
-
-	dma_areas[dma_areas_num++] = cma;
-
-	return 0;
-}
-
 struct cma_heap {
 	struct dma_heap *heap;
 	struct cma *cma;
 };
 
@@ -412,22 +398,21 @@ static int __init __add_cma_heap(struct cma *cma, const char *name)
 }
 
 static int __init add_cma_heaps(void)
 {
 	struct cma *default_cma = dev_get_cma_area(NULL);
+	struct cma *cma;
 	unsigned int i;
 	int ret;
 
 	if (default_cma) {
 		ret = __add_cma_heap(default_cma, DEFAULT_CMA_NAME);
 		if (ret)
 			return ret;
 	}
 
-	for (i = 0; i < dma_areas_num; i++) {
-		struct cma *cma = dma_areas[i];
-
+	for (i = 0; (cma = dma_contiguous_get_area_by_idx(i)) != NULL; i++) {
 		ret = __add_cma_heap(cma, cma_get_name(cma));
 		if (ret) {
 			pr_warn("Failed to add CMA heap %s", cma_get_name(cma));
 			continue;
 		}
diff --git a/include/linux/dma-buf/heaps/cma.h b/include/linux/dma-buf/heaps/cma.h
deleted file mode 100644
index e751479e21e703e24a5f799b4a7fc8bd0df3c1c4..0000000000000000000000000000000000000000
--- a/include/linux/dma-buf/heaps/cma.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef DMA_BUF_HEAP_CMA_H_
-#define DMA_BUF_HEAP_CMA_H_
-
-struct cma;
-
-#ifdef CONFIG_DMABUF_HEAPS_CMA
-int dma_heap_cma_register_heap(struct cma *cma);
-#else
-static inline int dma_heap_cma_register_heap(struct cma *cma)
-{
-	return 0;
-}
-#endif // CONFIG_DMABUF_HEAPS_CMA
-
-#endif // DMA_BUF_HEAP_CMA_H_
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 60b63756df821d839436618f1fca2bfa3eabe075..c4c93c72ff6ff3ff5c59b7161970805422e9dccb 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -97,10 +97,11 @@ static inline struct cma *dev_get_cma_area(struct device *dev)
 {
 	if (dev && dev->cma_area)
 		return dev->cma_area;
 	return dma_contiguous_default_area;
 }
+struct cma *dma_contiguous_get_area_by_idx(unsigned int idx);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
 
@@ -115,10 +116,14 @@ void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
 #else /* CONFIG_DMA_CMA */
 static inline struct cma *dev_get_cma_area(struct device *dev)
 {
 	return NULL;
 }
+static inline struct cma *dma_contiguous_get_area_by_idx(unsigned int idx)
+{
+	return NULL;
+}
 static inline void dma_contiguous_reserve(phys_addr_t limit)
 {
 }
 static inline int dma_contiguous_reserve_area(phys_addr_t size,
 		phys_addr_t base, phys_addr_t limit, struct cma **res_cma,
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index c56004d314dc2e436cddf3b20a4ee6ce8178bee4..afa9fd31304051d200cd4396dec26dd50becc375 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -40,21 +40,51 @@
 #include <asm/page.h>
 
 #include <linux/memblock.h>
 #include <linux/err.h>
 #include <linux/sizes.h>
-#include <linux/dma-buf/heaps/cma.h>
 #include <linux/dma-map-ops.h>
 #include <linux/cma.h>
 #include <linux/nospec.h>
 
 #ifdef CONFIG_CMA_SIZE_MBYTES
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
 #else
 #define CMA_SIZE_MBYTES 0
 #endif
 
+static struct cma *dma_contiguous_areas[MAX_CMA_AREAS];
+static unsigned int dma_contiguous_areas_num;
+
+static int dma_contiguous_insert_area(struct cma *cma)
+{
+	if (dma_contiguous_areas_num >= ARRAY_SIZE(dma_contiguous_areas))
+		return -EINVAL;
+
+	dma_contiguous_areas[dma_contiguous_areas_num++] = cma;
+
+	return 0;
+}
+
+/**
+ * dma_contiguous_get_area_by_idx() - Get contiguous area at given index
+ * @idx: index of the area we query
+ *
+ * Queries for the contiguous area located at index @idx.
+ *
+ * Returns:
+ * A pointer to the requested contiguous area, or NULL otherwise.
+ */
+struct cma *dma_contiguous_get_area_by_idx(unsigned int idx)
+{
+	if (idx >= dma_contiguous_areas_num)
+		return NULL;
+
+	return dma_contiguous_areas[idx];
+}
+EXPORT_SYMBOL_GPL(dma_contiguous_get_area_by_idx);
+
 struct cma *dma_contiguous_default_area;
 
 /*
  * Default global CMA area size can be defined in kernel's .config.
  * This is useful mainly for distro maintainers to create a kernel
@@ -262,13 +292,28 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 						  &dma_contiguous_default_area,
 						  fixed);
 		if (ret)
 			return;
 
-		ret = dma_heap_cma_register_heap(dma_contiguous_default_area);
+		/*
+		 * We need to insert the new area in our list to avoid
+		 * any inconsistencies between having the default area
+		 * listed in the DT or not.
+		 *
+		 * The DT case is handled by rmem_cma_setup() and will
+		 * always insert all its areas in our list. However, if
+		 * it didn't run (because OF_RESERVED_MEM isn't set, or
+		 * there's no DT region specified), then we don't have a
+		 * default area yet, and no area in our list.
+		 *
+		 * This block creates the default area in such a case,
+		 * but we also need to insert it in our list to avoid
+		 * having a default area but an empty list.
+		 */
+		ret = dma_contiguous_insert_area(dma_contiguous_default_area);
 		if (ret)
-			pr_warn("Couldn't register default CMA heap.");
+			pr_warn("Couldn't queue default CMA region for heap creation.");
 	}
 }
 
 void __weak
 dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
@@ -504,13 +549,13 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 	rmem->priv = cma;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
 
-	err = dma_heap_cma_register_heap(cma);
+	err = dma_contiguous_insert_area(cma);
 	if (err)
-		pr_warn("Couldn't register CMA heap.");
+		pr_warn("Couldn't store CMA reserved area.");
 
 	return 0;
 }
 RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
 #endif

-- 
2.53.0


