Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B591CA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2763B9001BF; Thu, 14 Aug 2025 13:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2252F900172; Thu, 14 Aug 2025 13:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116949001BF; Thu, 14 Aug 2025 13:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2121900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C40A5BB28D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:42 +0000 (UTC)
X-FDA: 83776113204.03.A736B08
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3273710000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8LGJqu+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194081; a=rsa-sha256;
	cv=none;
	b=hFSGaLUpUWZheU9PoWD6OwqHHJOFITZZadSHaOwIRPe0w4/tCYRhGqQl4UeJT313k8K4Ms
	aiiaRhOrSF5W5tXA9lNGsNTl9MmH+DILgnU1NF5yg7PRWz0B+p79A3129E4If08dAkZfMu
	zX+sFqbQngg7Uoz8Ybp4+zxQi1AP2n4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8LGJqu+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrbvw9rOWoWngXahJIZ+jx/PMyl/cB74JnS12q9ePqA=;
	b=O9BeMVD5sEN8ja5RG7oAqkkaPDum+cVd6FC0GEcvOHaZsseyVXb370kv4/nJ0tfVjE9b2S
	2UG5lScaLYzpwlE1Vq3/Pm3a1P0jBQ6yQVoKiLG7gkAMyP18Fl+APm1G292tcLURFpAQ5Q
	75pTbnNs77PWdGnCvxxAlhoPkMsXf9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3B05E5C721E;
	Thu, 14 Aug 2025 17:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39032C4CEF4;
	Thu, 14 Aug 2025 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194079;
	bh=vOnEIp8ay7pVjNUnKwOoXsO+91/AeyefXChuEBTVE5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8LGJqu+DZN6N8tja2j4y/HEVoIOR0CZMHqy4m3LzlYqq5xImycGK/2Y4YT8bniPG
	 sPtHNVs9IQrDANf6jN+Goaps+cFyMEgAS8AUtBqvz68pr4+UK/mIciN8zTQNjlw7rv
	 VZzHwtnevpJujJ0fbLrAsrcY5fh5ryrzCMNxF7kk/RppsprXCriYpXtwICnTqnTE1X
	 O1hvJ4io1gg8Lxn8sfw3WbqunbEm6vYfxIUKrId7Gx9s8OLuP3HisrSj4l89fkuf3v
	 +RutPVha9afaNWYAy5o2/4i3CJQuZAPw2GBzK30xdwrfser0QnF8gQl3D+QGY7LLr8
	 lfEb6x2yaP/SA==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v3 07/16] dma-mapping: convert dma_direct_*map_page to be phys_addr_t based
Date: Thu, 14 Aug 2025 20:53:58 +0300
Message-ID: <3faa9c978e243a904ffe01496148c4563dc9274e.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3273710000F
X-Stat-Signature: wcoqk1yyxrdt8pwekd5fohmcsyb45e39
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755194080-691862
X-HE-Meta: U2FsdGVkX18ZDAB4MwSs6+p3NGTJo+7O0FxCzV4AnAhzZtZUvMxFg5uW+lkSWXOkKRMb5sJOgQ982Vd7X3J23+1ZAOB00uc9+8rZpn+3zMqwu38/mgZYJbM6SU8/LugJtbHdSeB+s25t+iMuu9t8uNIhJ5Ob48da5IM3w5qDVjGJXro/PwGGYBFf0Slrez5jOqgULF+gK+8Z6QoE9G8sFNA3V/tZiLJq91NBJtMssS7G+4J8rg3oisJINDmcQL3C2WQ2Y08R60cCVL0wpq7WeibkCQysN/OJDOgLrQwuZ4UCaMoUON6ppvnacV/EL3VXX2rNbEWIsL9j4/esmy5+XJ90mpNVYokjq8m2bs626FTbef95tE005IzTgXHd4dbUTqUZozokZbXxYdVIWTMJ1fGhPDSTPNylMj5jIprTXg1FUwTmI6JxryRHzkoemUisWxtrqlH625ltDO+Gid4smqhhGFvAg+DYcJ0hzhtMcZv+XILcqhxRbumDhPEI05cQYwU28TkfFyGGP7IXo3PkGkP1FmFNP5Mq7ubtlIU1VcXn3iSpcgaMj51uzzwmygQcz9pUY+fs7lxBiw68LmCRnXYOcm0XmxaydFxZuZgGvTTq/ts8dbujXNxzHzRDLbhiWTDIO4zL24UMVNQ+5kG2ap9kmHVGwasHtlOsvjjh8DJfqTxcGJMrK2D1ZpxIrWDDzMkT5pNNeGkH4k4cdOnwA79lSgldiDOB0YV7hRaYlYy2l797y7pd8aUB6VBkbmCxEi2fBa6cwjV/TQE1eKr+YAPwgkyFGIDfhOrJOHP9mKyz1nHn2cmK2GGUttkUSLDzH3666HCBnmLTpuTmyJaGx3ePLC/EINBdrr8+1NuSNrqdX4Ss15w4gpzJ1MAJbPCUqExLocbAuIe7EGj0LN41lvZMcb8hyfFFdtiTHL1bWwvj88HOJ0YuiHOzVONLRXYOHTFHebLmkf053zL/QuQ
 5gkmav5f
 YkiLyj9RQKZDSMBnxmpO5QSppUZUAhRtN/5llE4OeKkxMwqJfVbsGchADd0AM3q6uzQC8FQ6l3biaP4UzBDGCItDMvySAsM+O9qMC48judVxZHLX2/Ascf8ypw1ue3MqKvP6KDZxQcl3u39QfvaOeaGhyQYO/TZIUOi1RNHDLe/ZipU/hqxxKQvo8FuhPkQ56u+4p0xXQ8QJTUqIw7MLDSm8V3ddNSVtxuHrV9TYylOSX8IVRmgdPcxzd2Fn+u8dXoZWZrPKnFMmrjlFoMtyo2mkjeZBaklG7yfI1rlVmvFLU3wH74+AAtUYzO8O0DW0hFJVxl0YKAEpVjtdmtpZG/y4XeJ7cHqVcP0lR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Convert the DMA direct mapping functions to accept physical addresses
directly instead of page+offset parameters. The functions were already
operating on physical addresses internally, so this change eliminates
the redundant page-to-physical conversion at the API boundary.

The functions dma_direct_map_page() and dma_direct_unmap_page() are
renamed to dma_direct_map_phys() and dma_direct_unmap_phys() respectively,
with their calling convention changed from (struct page *page,
unsigned long offset) to (phys_addr_t phys).

Architecture-specific functions arch_dma_map_page_direct() and
arch_dma_unmap_page_direct() are similarly renamed to
arch_dma_map_phys_direct() and arch_dma_unmap_phys_direct().

The is_pci_p2pdma_page() checks are replaced with DMA_ATTR_MMIO checks
to allow integration with dma_direct_map_resource and dma_direct_map_phys()
is extended to support MMIO path either.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 arch/powerpc/kernel/dma-iommu.c |  4 +--
 include/linux/dma-map-ops.h     |  8 ++---
 kernel/dma/direct.c             |  6 ++--
 kernel/dma/direct.h             | 52 +++++++++++++++++++++------------
 kernel/dma/mapping.c            |  8 ++---
 5 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 4d64a5db50f3..0359ab72cd3b 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -14,7 +14,7 @@
 #define can_map_direct(dev, addr) \
 	((dev)->bus_dma_limit >= phys_to_dma((dev), (addr)))
 
-bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr)
+bool arch_dma_map_phys_direct(struct device *dev, phys_addr_t addr)
 {
 	if (likely(!dev->bus_dma_limit))
 		return false;
@@ -24,7 +24,7 @@ bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr)
 
 #define is_direct_handle(dev, h) ((h) >= (dev)->archdata.dma_offset)
 
-bool arch_dma_unmap_page_direct(struct device *dev, dma_addr_t dma_handle)
+bool arch_dma_unmap_phys_direct(struct device *dev, dma_addr_t dma_handle)
 {
 	if (likely(!dev->bus_dma_limit))
 		return false;
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index f48e5fb88bd5..71f5b3025415 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -392,15 +392,15 @@ void *arch_dma_set_uncached(void *addr, size_t size);
 void arch_dma_clear_uncached(void *addr, size_t size);
 
 #ifdef CONFIG_ARCH_HAS_DMA_MAP_DIRECT
-bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr);
-bool arch_dma_unmap_page_direct(struct device *dev, dma_addr_t dma_handle);
+bool arch_dma_map_phys_direct(struct device *dev, phys_addr_t addr);
+bool arch_dma_unmap_phys_direct(struct device *dev, dma_addr_t dma_handle);
 bool arch_dma_map_sg_direct(struct device *dev, struct scatterlist *sg,
 		int nents);
 bool arch_dma_unmap_sg_direct(struct device *dev, struct scatterlist *sg,
 		int nents);
 #else
-#define arch_dma_map_page_direct(d, a)		(false)
-#define arch_dma_unmap_page_direct(d, a)	(false)
+#define arch_dma_map_phys_direct(d, a)		(false)
+#define arch_dma_unmap_phys_direct(d, a)	(false)
 #define arch_dma_map_sg_direct(d, s, n)		(false)
 #define arch_dma_unmap_sg_direct(d, s, n)	(false)
 #endif
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 24c359d9c879..fa75e3070073 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -453,7 +453,7 @@ void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sgl,
 		if (sg_dma_is_bus_address(sg))
 			sg_dma_unmark_bus_address(sg);
 		else
-			dma_direct_unmap_page(dev, sg->dma_address,
+			dma_direct_unmap_phys(dev, sg->dma_address,
 					      sg_dma_len(sg), dir, attrs);
 	}
 }
@@ -476,8 +476,8 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 			 */
 			break;
 		case PCI_P2PDMA_MAP_NONE:
-			sg->dma_address = dma_direct_map_page(dev, sg_page(sg),
-					sg->offset, sg->length, dir, attrs);
+			sg->dma_address = dma_direct_map_phys(dev, sg_phys(sg),
+					sg->length, dir, attrs);
 			if (sg->dma_address == DMA_MAPPING_ERROR) {
 				ret = -EIO;
 				goto out_unmap;
diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index d2c0b7e632fc..92dbadcd3b2f 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -80,42 +80,56 @@ static inline void dma_direct_sync_single_for_cpu(struct device *dev,
 		arch_dma_mark_clean(paddr, size);
 }
 
-static inline dma_addr_t dma_direct_map_page(struct device *dev,
-		struct page *page, unsigned long offset, size_t size,
-		enum dma_data_direction dir, unsigned long attrs)
+static inline dma_addr_t dma_direct_map_phys(struct device *dev,
+		phys_addr_t phys, size_t size, enum dma_data_direction dir,
+		unsigned long attrs)
 {
-	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dma_addr = phys_to_dma(dev, phys);
+	dma_addr_t dma_addr;
+	bool capable;
 
 	if (is_swiotlb_force_bounce(dev)) {
-		if (is_pci_p2pdma_page(page))
-			return DMA_MAPPING_ERROR;
+		if (attrs & DMA_ATTR_MMIO)
+			goto err_overflow;
+
 		return swiotlb_map(dev, phys, size, dir, attrs);
 	}
 
-	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
-	    dma_kmalloc_needs_bounce(dev, size, dir)) {
-		if (is_pci_p2pdma_page(page))
-			return DMA_MAPPING_ERROR;
-		if (is_swiotlb_active(dev))
+	if (attrs & DMA_ATTR_MMIO)
+		dma_addr = phys;
+	else
+		dma_addr = phys_to_dma(dev, phys);
+
+	capable = dma_capable(dev, dma_addr, size, !(attrs & DMA_ATTR_MMIO));
+	if (unlikely(!capable) || dma_kmalloc_needs_bounce(dev, size, dir)) {
+		if (is_swiotlb_active(dev) && !(attrs & DMA_ATTR_MMIO))
 			return swiotlb_map(dev, phys, size, dir, attrs);
 
-		dev_WARN_ONCE(dev, 1,
-			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
-			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
-		return DMA_MAPPING_ERROR;
+		goto err_overflow;
 	}
 
-	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!dev_is_dma_coherent(dev) &&
+	    !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 	return dma_addr;
+
+err_overflow:
+	dev_WARN_ONCE(
+		dev, 1,
+		"DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
+		&dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
+	return DMA_MAPPING_ERROR;
 }
 
-static inline void dma_direct_unmap_page(struct device *dev, dma_addr_t addr,
+static inline void dma_direct_unmap_phys(struct device *dev, dma_addr_t addr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	phys_addr_t phys = dma_to_phys(dev, addr);
+	phys_addr_t phys;
+
+	if (attrs & DMA_ATTR_MMIO)
+		/* nothing to do: uncached and no swiotlb */
+		return;
 
+	phys = dma_to_phys(dev, addr);
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 58482536db9b..80481a873340 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -166,8 +166,8 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_page_direct(dev, phys + size))
-		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
+	    arch_dma_map_phys_direct(dev, phys + size))
+		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
 	else
@@ -187,8 +187,8 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_page_direct(dev, addr + size))
-		dma_direct_unmap_page(dev, addr, size, dir, attrs);
+	    arch_dma_unmap_phys_direct(dev, addr + size))
+		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
 	else
-- 
2.50.1


