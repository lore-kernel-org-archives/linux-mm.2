Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AD7606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a46ujYo1
Received: by kanga.kvack.org (Postfix)
	id 31AD96B05B6; Wed, 11 Nov 2026 06:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4186B05B7; Wed, 11 Nov 2026 06:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BE76B05B8; Wed, 11 Nov 2026 06:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E21686B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B30E40295
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:31 +0000 (UTC)
X-FDA: 85422564822.26.C68E900
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id A204B120008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=a46ujYo1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fepHfB0plBo6LzhKi5imbPgE2fv/KA+5u7RqYYS0Pqg=;
	b=wN3+rnEim9MuRGJoAlt8Qd4y9b5HGPl9N2/MAdbRC7EdSawpgASXBVOU3OxPZ1u18sdGpK
	53MCzZ64BaFEU8A/sb4kLBWVis51LoK5FZGpV6pZXIyGcgK7oDTW46NqdAfZ9BCdi/NodW
	NMuTLoybL6mjWjwV1CHq8ATgeL6TrHI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=a46ujYo1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395309;
	b=paEGlfxizFN6qGYWyscdKNBfquQDVfjrm4b5nr0J6JPJILJ/IdpF0bwDjnKKX/5mDk2kCR
	eEEg/q30qaOVyu7XWL2JRiKIpNMqI8cw+iK8YFNxAKSfrbhFHU/f6ZuABgqQk3nh8cj+St
	5rXEdQ1jSFwnDFJ1ZUbbPv52BRpLIw8=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso25377255e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395308; x=1795000108; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fepHfB0plBo6LzhKi5imbPgE2fv/KA+5u7RqYYS0Pqg=;
        b=a46ujYo1y647xdI2wOAfKxKARqkxinh7Qm/Zwdx0KitZtBcQS/P+BZqTLMD1foG8zl
         j2Je15fdN0daSDQ8YMgGu3FyVVMdWiNoa1HHOk65JmY6KZvZxdFcQkqdrCsVsS76vek1
         xVsTqKMf+7vVrScQQy2gTAEXuxtX2DgU/jwDPzYvty6B3Iyf4f471Ua5VsrHOSJ+8Lur
         mPnE0jk+qoQcgOoQM1Ux8BoWDpAX9CWLEK/RHTO1XfYd8DTza7Ms7ENXQAoYo4fqOJHY
         EybYwQRPEAl/BWTHI7Xu7Fy8Usw5Xv038g+7HlTPu4jpJ1Ya3ZDZeNWViLR4GMRdc8fl
         zpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395308; x=1795000108;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fepHfB0plBo6LzhKi5imbPgE2fv/KA+5u7RqYYS0Pqg=;
        b=qbB39FNBjxp38WiWjSisPe6jKaDsVlgnJCRIvlnisSP7u0mW0Bv3IyEDpCTWS3okeZ
         nVMQOBXSYF5FgLw4mHhhiRe/AZ9FPeHsK3+rlKZXWFx0TAgd72iC1XeZ8Azjt0XqBBpk
         INODQ3CPqqgUb9WLk/kqjlL5q80TaVDPr3v6vxGV4Lvamv2FulN6j8YEYpAMOA9xn57B
         qdV1PCEiIytM0nn9PFWlHtCKfTSgh/cBUmsi7Q8r9CtCzrHLJprA93Cr8Xlwua7zVi+N
         zLTUEZNmNHkUZYuCF/dSL+/2TxfQRP8RBgW/kKiUYudN7lSMs13pE44B5AnwHcuSZtrc
         dgzw==
X-Forwarded-Encrypted: i=1; AL+hErExC9dIDuZ0MmBPqxwihltMvQKH+nidme2he/y4WiIZUfZ6oa2up2RuuGwnrdtNm0o6xZ/2fYjw+Q==@kvack.org
X-Gm-Message-State: APuU4Z9BTcaeIX7MaQ28Rl1JXLXMBKr5AUtQ0vZDVNaElHIFkb+VPeFt
	U1O7EyuHGx/iaSFlKWgLoC1pHfNMfRmwTEz76pWGVQrU6MYFQMfSPpu8mCPs9M7Tl/8LAOXGNNZ
	9/Gww4lV/wNmj2BclVVcEQg==
X-Received: from wrtw18.prod.google.com ([2002:a5d:6092:0:b0:496:45d:6be1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c167:b0:4a1:a6e0:4ce4 with SMTP id 5b1f17b1804b1-4ba093acf6dmr33023215e9.33.1794395307950;
 Wed, 11 Nov 2026 03:08:27 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:35 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-6-vdonnefort@google.com>
Subject: [PATCH v3 5/8] dma-mapping: Introduce lendable-dma-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A204B120008
X-Stat-Signature: 6aiqgqr7x7grn9at8nuy6ndon4bpjsdm
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794395309-861163
X-HE-Meta: U2FsdGVkX1/KxMQgVPYt9IiCp6YevcaxzQXp8e/OrkfRtgUTCDXIUr3VJnxsMyuMpwc93fxzVHDxACr1or0gjsioXV2f9vthfeCYZgWPhHUm4BubwIzuDc2GJpx2rXKvB2kcDBTQcIOH7tmiATQ8ydp7I3lZIZ0YdzQmj1zCbwMXL82RfrFs5y2s+l4ObzSOC7HzoI0xPwXiEbCgkUScm2YiMIGuqCJ1N5VtgD/UEo1/dD3ERN9uDij+XQxlNbnAjTXlDZgUAHd4M5kt6YvovASC3b4mOhwJQAPrbY46yCPKti8bCcMzwueU1RnBkD13TfV5ZeY4JFhK+Kjp8NjHJ/ihgF4z3xi86AlM342KNp//TCsrdpafNXcLnc5uPee1lzE+WB0FIhFvR56td2IhUBWxhn+iDFTrudoLtWP9OSAWbcd0dcveKK4+LYjfwrxvxBboXThFfYro97jeFqKGZ+S5YrBVv0WgV5WFzQTXyxxoirsXVoK0M9GM52Ct3FSSmPqI3uO6G3oqe8u9RRjQ4cF/Efx+ZNEfZgZMyUx3M47Ipeh928EkLNyhBrHhYfr2AfOONwO5kfX7Fws1iWjB/cafdqmTAbhwhquuem74usqZFIuVUgr26mbdRBkSa+MLo/PIXBkYYpNysbon5HhxoxDXOzrGiXyW5hnEWnGV2jH27x6fNSvCBmTNSmJ1qv40CKZHz7U8XAycTSbkjGc6Capk5JuDMMdDN6ENbZgyYo7v6WOF/TdeoIZfLsJpYTvXEMXj3ZVYItyX7aBAZk+iyu/onbP0zvpKubksnP76BAZSAV1u1aHNlPr3PcbTbYYfeTPV0zA/4eDUK0iF67yx7ZBW/SSpiFqjvfYHinaFWvy7u4G7eF94nUPYhXkJQgfDjUwyR50cHzjuRaTDjPqx9HBxD5ZYPZhDwhIccBfrS0s7pGt3SbQSwWcHbKElzhuRyI5QtCfhmOgpYl3PNxj
 0zYvLLeP
 EUI31tnEJafND2J1LddFpqbnzPb4lWe1dT27tvmulwUVog5Q092/ZTsjZIFTPd6JrZTi1miRrij+vfgn4cE96i5TaBaOWU1zOI1ZbwgEDaLSOus+n6sKWmVn/go2ZhqAn63VHuBTp8rMbEaNvoS3z0l602r/pbMGChoLtIJokAqDzmZqtZvXk/tlRxf2NtcZLDyWdt9+hcKWGK2qLhpvUm5UAiU+WsIVtM+ydUYorDWwboNTIYPa6pmX18ze1716zuckJpHz2hR7n2SBZS6xa6wBRcR6utsCqcra5cOfJKpXfG8feqOBPc1ZrTpkoSeOjglc+NFdZjm5YJmzhxhQWUP3erXp6BpYqCua5RETZg8s7CPO13NQjeZ7wkYcRzo9vAd1ciidaYRTYHcjLaI958oN8jjFY4rg2K1QWn7HvOvLqs3FVZ3ZTmW1Vc/dgRY8Sf8BVBDx+1WuttdcVtnYIJA7rSMbaT0iBsV/iPeER4TTngfahZIDIClbDzNFP/ekx816J7fM6n8xSgcFQV6U2c9ERuLh1Lot5y5kET7oN7MHTLljYQyVRXzqsFQQUbbDDBAMH0ZLxn4qaNhYsNQl551P5Gu1H6amWfn4VzaPeaCOxmJGxpne7L3OyCrZ4QgqMNaFUKVsiQMCeMn3plJizWZRNKYxWZ4UaxADGTeP/IW6CN4xMUE39yrqcDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On arm64, when memory is lent to secure world (e.g. via Arm FF-A), fatal
CPU speculative reads can still occur while it retains a cacheable
direct mapping. Introduce the "lendable-dma-pool" reserved-memory CMA
driver with dma_zap_direct_map() and dma_restore_direct_map() to unmap
pages before lending and restore them upon reclaim. Devices use the pool
via "memory-region" or "linux,cma-default":

  reserved-memory {
      #address-cells = <0x2>;
      #size-cells = <0x2>;
      ranges;

      linux,cma {
          compatible = "lendable-dma-pool";
          reusable;
          linux,cma-default;
          size = <0x0 0x4000000>;
      };
  };

If no lendable-dma-pool node is provided, the API falls back to
can_set_direct_map().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 include/linux/dma-map-ops.h |   9 ++
 include/linux/dma-mapping.h |  16 +++
 kernel/dma/Kconfig          |   3 +
 kernel/dma/Makefile         |   1 +
 kernel/dma/lendable.c       | 243 ++++++++++++++++++++++++++++++++++++
 5 files changed, 272 insertions(+)
 create mode 100644 kernel/dma/lendable.c

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index afaf2c12189b..e1d1e8d70855 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -379,6 +379,15 @@ static inline void arch_dma_prep_coherent(struct page *page, size_t size)
 }
 #endif /* CONFIG_ARCH_HAS_DMA_PREP_COHERENT */
 
+#ifdef CONFIG_DMA_LENDABLE
+int __init arch_dma_mark_lendable(phys_addr_t base, phys_addr_t size);
+bool __init arch_dma_is_lendable(struct page *page, unsigned int nr_pages);
+int arch_dma_zap_direct_map(struct page *page, unsigned int nr_pages,
+			    bool from_lendable);
+int arch_dma_restore_direct_map(struct page *page, unsigned int nr_pages,
+				bool from_lendable);
+#endif /* CONFIG_DMA_LENDABLE */
+
 void *arch_dma_set_uncached(void *addr, size_t size);
 void arch_dma_clear_uncached(void *addr, size_t size);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index efde0e5a58dc..24239599505d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -511,6 +511,22 @@ void dma_free_pages(struct device *dev, size_t size, struct page *page,
 int dma_mmap_pages(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct page *page);
 
+#ifdef CONFIG_DMA_LENDABLE
+int dma_zap_direct_map(struct device *dev, struct page *page, size_t size);
+void dma_restore_direct_map(struct device *dev, struct page *page, size_t size);
+#else
+static inline int dma_zap_direct_map(struct device *dev, struct page *page,
+				     size_t size)
+{
+	return -ENODEV;
+}
+
+static inline void dma_restore_direct_map(struct device *dev, struct page *page,
+					  size_t size)
+{
+}
+#endif /* CONFIG_DMA_LENDABLE */
+
 static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
 {
diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index 3830a63ae032..8d65e2daa7d2 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -192,6 +192,9 @@ config DMA_CMA
 
 if  DMA_CMA
 
+config DMA_LENDABLE
+	bool
+
 config DMA_NUMA_CMA
 	bool "Enable separate DMA Contiguous Memory Area for NUMA Node"
 	depends on NUMA
diff --git a/kernel/dma/Makefile b/kernel/dma/Makefile
index 6977033444a3..6b257d82bd9b 100644
--- a/kernel/dma/Makefile
+++ b/kernel/dma/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_HAS_DMA)			+= mapping.o direct.o
 obj-$(CONFIG_DMA_OPS_HELPERS)		+= ops_helpers.o
 obj-$(CONFIG_ARCH_HAS_DMA_OPS)		+= dummy.o
 obj-$(CONFIG_DMA_CMA)			+= contiguous.o
+obj-$(CONFIG_DMA_LENDABLE)		+= lendable.o
 obj-$(CONFIG_DMA_DECLARE_COHERENT)	+= coherent.o
 obj-$(CONFIG_DMA_API_DEBUG)		+= debug.o
 obj-$(CONFIG_SWIOTLB)			+= swiotlb.o
diff --git a/kernel/dma/lendable.c b/kernel/dma/lendable.c
new file mode 100644
index 000000000000..85ac3ad10df0
--- /dev/null
+++ b/kernel/dma/lendable.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Lendable DMA Contiguous Memory Pool
+ *
+ * Prevents CPU speculative reads to DMA memory (e.g. when lent to a secure
+ * world) by unmapping it from the kernel direct map. This works if the
+ * architecture allows modifying the direct map globally (can_set_direct_map())
+ * or if the memory belongs to a reserved-memory CMA pool compatible with
+ * "lendable-dma-pool".
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#define pr_fmt(fmt) "dma-lendable: " fmt
+
+#include <linux/atomic.h>
+#include <linux/bsearch.h>
+#include <linux/cma.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/set_memory.h>
+#include <linux/sort.h>
+#include <linux/suspend.h>
+
+#include "contiguous.h"
+
+#define DMA_LENDABLE_DISABLED	-1
+
+static struct cma *lendable_areas[MAX_CMA_AREAS] __ro_after_init;
+static unsigned int nr_lendable_areas __ro_after_init;
+static atomic_t dma_lendable_active;
+
+static int __lendable_cmp(const void *a, const void *b)
+{
+	const struct cma *cma_a = *(struct cma * const *)a;
+	const struct cma *cma_b = *(struct cma * const *)b;
+
+	return cmp_int(cma_get_base(cma_a), cma_get_base(cma_b));
+}
+
+static bool cma_is_lendable(struct cma *cma)
+{
+	return cma && bsearch(&cma, lendable_areas, nr_lendable_areas,
+			      sizeof(lendable_areas[0]), __lendable_cmp);
+}
+
+static bool cma_has_range(struct cma *cma, struct page *page, unsigned int nr_pages)
+{
+	phys_addr_t start = page_to_phys(page);
+	phys_addr_t end = start + ((phys_addr_t)nr_pages << PAGE_SHIFT);
+	phys_addr_t base = cma_get_base(cma);
+
+	return start >= base && end <= base + cma_get_size(cma);
+}
+
+/**
+ * dma_zap_direct_map() - Remove a DMA page range from the kernel direct map
+ * @dev:	Device that allocated the pages (or NULL for default CMA pool)
+ * @page:	First page of the memory region
+ * @size:	Page-aligned size of the memory region in bytes
+ *
+ * Cleans and invalidates caches and removes the memory range from the kernel
+ * direct map to prevent speculative CPU accesses. Must be paired with
+ * dma_restore_direct_map().
+ *
+ * Context: Any context if allocated from a lendable pool; process context
+ *          (may sleep) otherwise.
+ * Return:
+ * * 0		- Success.
+ * * -EINVAL	- @size is 0 or not page-aligned.
+ * * -ENODEV	- Direct map cannot be modified and @dev has no lendable pool.
+ * * -EFAULT	- @dev has a lendable pool, but [@page, @page + @size) is
+ *		  outside that pool.
+ * * -EBUSY	- Direct map zapping is temporarily disabled (hibernation).
+ */
+int dma_zap_direct_map(struct device *dev, struct page *page, size_t size)
+{
+	unsigned int nr_pages = size >> PAGE_SHIFT;
+	bool from_lendable, has_lendable;
+	struct cma *cma;
+	int ret;
+
+	if (!size || !PAGE_ALIGNED(size))
+		return -EINVAL;
+
+	cma = dev_get_cma_area(dev);
+	has_lendable = cma_is_lendable(cma);
+	from_lendable = has_lendable && cma_has_range(cma, page, nr_pages);
+
+	if (!from_lendable && !can_set_direct_map())
+		return has_lendable ? -EFAULT : -ENODEV;
+
+	/* Provides full ordering */
+	if (!atomic_add_unless(&dma_lendable_active, 1, DMA_LENDABLE_DISABLED))
+		return -EBUSY;
+
+	ret = arch_dma_zap_direct_map(page, nr_pages, from_lendable);
+	if (ret)
+		atomic_dec(&dma_lendable_active);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_zap_direct_map);
+
+/**
+ * dma_restore_direct_map() - Restore a zapped DMA page range in the direct map
+ * @dev:	Device that allocated the pages (or NULL for default CMA pool)
+ * @page:	First page of the memory region
+ * @size:	Page-aligned size of the memory region in bytes
+ *
+ * Restores the default kernel direct mapping and invalidates caches for a range
+ * previously zapped with dma_zap_direct_map().
+ *
+ * Context: Any context if allocated from a lendable pool; process context
+ *          (may sleep) otherwise.
+ */
+void dma_restore_direct_map(struct device *dev, struct page *page, size_t size)
+{
+	unsigned int nr_pages = size >> PAGE_SHIFT;
+	bool from_lendable;
+	struct cma *cma;
+
+	if (WARN_ON_ONCE(!size || !PAGE_ALIGNED(size)))
+		return;
+
+	cma = dev_get_cma_area(dev);
+	from_lendable = cma_is_lendable(cma) && cma_has_range(cma, page, nr_pages);
+
+	if (WARN_ON_ONCE(!from_lendable && !can_set_direct_map()))
+		return;
+
+	if (WARN_ON_ONCE(arch_dma_restore_direct_map(page, nr_pages, from_lendable)))
+		return;
+
+	WARN_ON_ONCE(atomic_dec_return_release(&dma_lendable_active) < 0);
+}
+EXPORT_SYMBOL_GPL(dma_restore_direct_map);
+
+static int dma_lendable_pm_notify(struct notifier_block *nb,
+				  unsigned long mode, void *data)
+{
+	/* Prevent hibernation while unmapped pages may be inaccessible */
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_RESTORE_PREPARE:
+		if (atomic_cmpxchg_acquire(&dma_lendable_active, 0, DMA_LENDABLE_DISABLED))
+			return notifier_from_errno(-EBUSY);
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
+		atomic_cmpxchg(&dma_lendable_active, DMA_LENDABLE_DISABLED, 0);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block dma_lendable_pm_nb = {
+	.notifier_call	= dma_lendable_pm_notify,
+};
+
+static int __init dma_lendable_init(void)
+{
+	unsigned int i, nr = 0;
+
+	for (i = 0; i < nr_lendable_areas; i++) {
+		struct cma *cma = lendable_areas[i];
+
+		if (!arch_dma_is_lendable(phys_to_page(cma_get_base(cma)),
+					  cma_get_size(cma) >> PAGE_SHIFT)) {
+			pr_warn("Ignoring %s: not lendable\n", cma_get_name(cma));
+			continue;
+		}
+
+		lendable_areas[nr++] = cma;
+	}
+	nr_lendable_areas = nr;
+
+	sort(lendable_areas, nr_lendable_areas, sizeof(lendable_areas[0]), __lendable_cmp, NULL);
+
+	register_pm_notifier(&dma_lendable_pm_nb);
+
+	return 0;
+}
+core_initcall(dma_lendable_init);
+
+#ifdef CONFIG_OF_RESERVED_MEM
+static int __init rmem_lendable_validate(unsigned long node,
+					 phys_addr_t *align)
+{
+	return rmem_cma_ops.node_validate(node, align);
+}
+
+static int __init rmem_lendable_fixup(unsigned long node, phys_addr_t base,
+				      phys_addr_t size)
+{
+	int ret = rmem_cma_ops.node_fixup(node, base, size);
+
+	if (ret)
+		return ret;
+
+	return arch_dma_mark_lendable(base, size);
+}
+
+static int __init rmem_lendable_setup(unsigned long node,
+				      struct reserved_mem *rmem)
+{
+	int ret = rmem_cma_ops.node_init(node, rmem);
+
+	if (ret)
+		return ret;
+
+	lendable_areas[nr_lendable_areas++] = rmem->priv;
+
+	return 0;
+}
+
+static int rmem_lendable_device_init(struct reserved_mem *rmem,
+				     struct device *dev)
+{
+	return rmem_cma_ops.device_init(rmem, dev);
+}
+
+static void rmem_lendable_device_release(struct reserved_mem *rmem,
+					 struct device *dev)
+{
+	rmem_cma_ops.device_release(rmem, dev);
+}
+
+static const struct reserved_mem_ops rmem_lendable_ops = {
+	.node_validate	= rmem_lendable_validate,
+	.node_fixup	= rmem_lendable_fixup,
+	.node_init	= rmem_lendable_setup,
+	.device_init	= rmem_lendable_device_init,
+	.device_release	= rmem_lendable_device_release,
+};
+
+RESERVEDMEM_OF_DECLARE(cma_lendable, "lendable-dma-pool", &rmem_lendable_ops);
+#endif /* CONFIG_OF_RESERVED_MEM */
-- 
2.56.0.542.g3ef89b7020-goog


