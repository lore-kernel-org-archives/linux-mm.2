Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB71CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4879A900130; Thu, 14 Aug 2025 06:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4117A900121; Thu, 14 Aug 2025 06:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B304900130; Thu, 14 Aug 2025 06:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11C43900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B952E117A6D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:17 +0000 (UTC)
X-FDA: 83774952954.07.AFF0842
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id F03121C0011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XwmxH0m5;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfxLLKvH/DpVc2NbZowrmc3+FoU4H0K6l6sYGFFyH/0=;
	b=TjZV3EdWCHnCUXGAdczl5T8wOjy6FOs0YvLocrb9hA8k+4nFYQslytZhxDI7ghHQvOoXXi
	wA7iSn8E9b4edk/jnc7Ix3YF6IjX9zK0eNo+mAAWiQMezqYC8Xo4LG/AbCza+QBSJ/M/nL
	LM++Oo92or5n5I6siyTFV76gfS1euNU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XwmxH0m5;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166456; a=rsa-sha256;
	cv=none;
	b=VYY/Hxg4zCetDqedP/ls2noHDVNtncqXXjr7JBqNsMxwq7hNgSNutyQYpaRauOWHYctAJk
	cAi2JIntjNiZjziS3+j8/T3nMqj54sQim+lcTyXKkeKcVOUCHiZBFZD0MtC01MGIjjUN1N
	ORnvpNqbrQVf7sAPwJzjRvNl1rWXm8g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C41D44BCF;
	Thu, 14 Aug 2025 10:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5B1C4CEED;
	Thu, 14 Aug 2025 10:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166454;
	bh=+6SuvKk/7U//cW4wXi0ADVlYqazqjfxTWHubS42t1as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwmxH0m53jnWJZ0ex/XTTOFoM6EBYCbptMpUMMPjfuAXHNhgcUyfbWZ1kypJlXeSI
	 EIs2WTbWSY3XRaCGdc9mc9vYfVKAvXtplmrWkI0bcVQ1eqASOhp64nn347pnJbdex7
	 rFmLkgtZenO43T9NN5T/+DYlZw81jC7UDSxnRG50NO+cnTNHmxSOoYhCKkV/2IRyx2
	 Cqj9eZfH8UAZvmfNVdkr1hCjaIM1K+PfbawmHw/4HcKOtxUDV7skJZHzogfzMq8dPL
	 I6RVqUowCznBU4CKpWrY+8udb0KmimaXaJiePZl3tOw6JJ3XxTLdcij4aULT+W9rtG
	 IOrHqGUZi9i7A==
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
Subject: [PATCH v2 03/16] dma-debug: refactor to use physical addresses for page mapping
Date: Thu, 14 Aug 2025 13:13:21 +0300
Message-ID: <ff3008fd5128ef4221c63716f7e27ff3c63d3350.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F03121C0011
X-Rspam-User: 
X-Stat-Signature: mnk6uz45tnrxrjjpud17w9ftgy3hpsau
X-Rspamd-Server: rspam09
X-HE-Tag: 1755166455-85399
X-HE-Meta: U2FsdGVkX19hipKlB7OskuxT+pS3Cv0PL1deZtVGMeKG4up2JVjKSG3XhSt9ohU00BA3B/Mwfd4lsnPSzvZBRZFoJlU1O5B6X3Nxow3iaDH9Us4p4OX5PbcELHXPDsrOFLC5F22ACsCU9LgQICPbv/YelbpkgJ1Db+jTFSq0JEaYFJ366F2Sb0Dqacp6biR8WEGxuIFfOpI9T2nHUgD9+R9J5SaePbwGWjUXRLvM3eAq1hi5/lRHTjRfs+CAaAQv6sVOsotFC3j1twyiR5hYAzBOzo1v3Uvwr7qU5w9hUg6VyYJjDipWX4aHD/+MEtvZnT3EUskUJB0gofoBxrcSorzi3iyzvPkDV2Xj86VMs6kXt/LMACgbXWjZ4RtgMT46+cVED09mqEOm9WKNIvdpud4bVl9IAvmgI2Yd86JcsQyA1wwV+4x7nPVUW2BHWJ+U7hf84KraQnnkcOCZC8Ry+7SATWA8ziiBOeb7WvqinJz1C9RdzciGYM3uHNl8atuz5Q59VHrntnEw6slud3wZYzLOKEta4gt8NSWy/qROTpzRemO+Tpr0DservqmQndT+OWWjHMWHz00KmyBCfkVwcBnfQgFu4OMFfc/BYkoDC61EHQAeY7FvlqF1SCmiBM2k8qH3h5EOsae/gy7idnR3tyCTpPK1OfCF9iFhTm8TZtzRx/IIXKScDrs3A5hQOJMU8Sv3u2qTkDtKcKwQR4bw6HHs3e+vPj/z348tRaz77x+QgQ5gEYgR33dlZjmxhi6q7GW5KnXGCK1On8fnGv0otX5whiAjsMnboqXgfcRotpoCJi56FZ6ZDepj9QzzLF5IM6nDiw291bnWD0Bhs45+O3jzzZjOEjEm/stb/9I8cRrXLzZZRUOxf+FQCNkdsHtL0n3HIWdmuFkDHzbSWYmf5LEObtmGi/RfZsNNVf3moYlTPkg6PIOWet4CWtew97x9D9pxxLtJkCXmwTt8geP
 KNyVh+sG
 42W84m8/5h5WZ4hBzQOMOEMmgYHd45YNDHUbfznBVB+QU3LZ2PHiHcX5VRmhzRdREHGSZWj8Gn7gZnZGuIDC4yT4NJP5mbnkZ0lTc5VHCEOKFLSoP+QKFZcXT9Ronv30eQXa42zU1IyWClTM9AabrmD/dVvE2KMWQTsBmh7fvYMT+x0S3q1/r4lTa2BnHjxUU9zACL9ELtAkX933odzkKsaqLH97nJ29FH//bW1iR0rd8g4J0YhsSGsEaO9mQRwB48CfBFIEUOY9I3ZXa7cQI0067mOsSs/ypkgZHTd6dmfkMZoX/2xvnqe/ruA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Convert the DMA debug infrastructure from page-based to physical address-based
mapping as a preparation to rely on physical address for DMA mapping routines.

The refactoring renames debug_dma_map_page() to debug_dma_map_phys() and
changes its signature to accept a phys_addr_t parameter instead of struct page
and offset. Similarly, debug_dma_unmap_page() becomes debug_dma_unmap_phys().
A new dma_debug_phy type is introduced to distinguish physical address mappings
from other debug entry types. All callers throughout the codebase are updated
to pass physical addresses directly, eliminating the need for page-to-physical
conversion in the debug layer.

This refactoring eliminates the need to convert between page pointers and
physical addresses in the debug layer, making the code more efficient and
consistent with the DMA mapping API's physical address focus.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-api.rst |  4 ++--
 kernel/dma/debug.c                 | 28 +++++++++++++++++-----------
 kernel/dma/debug.h                 | 16 +++++++---------
 kernel/dma/mapping.c               | 15 ++++++++-------
 4 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
index 3087bea715ed..ca75b3541679 100644
--- a/Documentation/core-api/dma-api.rst
+++ b/Documentation/core-api/dma-api.rst
@@ -761,7 +761,7 @@ example warning message may look like this::
 	[<ffffffff80235177>] find_busiest_group+0x207/0x8a0
 	[<ffffffff8064784f>] _spin_lock_irqsave+0x1f/0x50
 	[<ffffffff803c7ea3>] check_unmap+0x203/0x490
-	[<ffffffff803c8259>] debug_dma_unmap_page+0x49/0x50
+	[<ffffffff803c8259>] debug_dma_unmap_phys+0x49/0x50
 	[<ffffffff80485f26>] nv_tx_done_optimized+0xc6/0x2c0
 	[<ffffffff80486c13>] nv_nic_irq_optimized+0x73/0x2b0
 	[<ffffffff8026df84>] handle_IRQ_event+0x34/0x70
@@ -855,7 +855,7 @@ that a driver may be leaking mappings.
 dma-debug interface debug_dma_mapping_error() to debug drivers that fail
 to check DMA mapping errors on addresses returned by dma_map_single() and
 dma_map_page() interfaces. This interface clears a flag set by
-debug_dma_map_page() to indicate that dma_mapping_error() has been called by
+debug_dma_map_phys() to indicate that dma_mapping_error() has been called by
 the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
 this flag is still set, prints warning message that includes call trace that
 leads up to the unmap. This interface can be called from dma_mapping_error()
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index e43c6de2bce4..da6734e3a4ce 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -39,6 +39,7 @@ enum {
 	dma_debug_sg,
 	dma_debug_coherent,
 	dma_debug_resource,
+	dma_debug_phy,
 };
 
 enum map_err_types {
@@ -141,6 +142,7 @@ static const char *type2name[] = {
 	[dma_debug_sg] = "scatter-gather",
 	[dma_debug_coherent] = "coherent",
 	[dma_debug_resource] = "resource",
+	[dma_debug_phy] = "phy",
 };
 
 static const char *dir2name[] = {
@@ -1201,9 +1203,8 @@ void debug_dma_map_single(struct device *dev, const void *addr,
 }
 EXPORT_SYMBOL(debug_dma_map_single);
 
-void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
-			size_t size, int direction, dma_addr_t dma_addr,
-			unsigned long attrs)
+void debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
+		int direction, dma_addr_t dma_addr, unsigned long attrs)
 {
 	struct dma_debug_entry *entry;
 
@@ -1218,19 +1219,24 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 		return;
 
 	entry->dev       = dev;
-	entry->type      = dma_debug_single;
-	entry->paddr	 = page_to_phys(page) + offset;
+	entry->type      = dma_debug_phy;
+	entry->paddr	 = phys;
 	entry->dev_addr  = dma_addr;
 	entry->size      = size;
 	entry->direction = direction;
 	entry->map_err_type = MAP_ERR_NOT_CHECKED;
 
-	check_for_stack(dev, page, offset);
+	if (!(attrs & DMA_ATTR_MMIO)) {
+		struct page *page = phys_to_page(phys);
+		size_t offset = offset_in_page(page);
 
-	if (!PageHighMem(page)) {
-		void *addr = page_address(page) + offset;
+		check_for_stack(dev, page, offset);
 
-		check_for_illegal_area(dev, addr, size);
+		if (!PageHighMem(page)) {
+			void *addr = page_address(page) + offset;
+
+			check_for_illegal_area(dev, addr, size);
+		}
 	}
 
 	add_dma_entry(entry, attrs);
@@ -1274,11 +1280,11 @@ void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 }
 EXPORT_SYMBOL(debug_dma_mapping_error);
 
-void debug_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
+void debug_dma_unmap_phys(struct device *dev, dma_addr_t dma_addr,
 			  size_t size, int direction)
 {
 	struct dma_debug_entry ref = {
-		.type           = dma_debug_single,
+		.type           = dma_debug_phy,
 		.dev            = dev,
 		.dev_addr       = dma_addr,
 		.size           = size,
diff --git a/kernel/dma/debug.h b/kernel/dma/debug.h
index f525197d3cae..76adb42bffd5 100644
--- a/kernel/dma/debug.h
+++ b/kernel/dma/debug.h
@@ -9,12 +9,11 @@
 #define _KERNEL_DMA_DEBUG_H
 
 #ifdef CONFIG_DMA_API_DEBUG
-extern void debug_dma_map_page(struct device *dev, struct page *page,
-			       size_t offset, size_t size,
-			       int direction, dma_addr_t dma_addr,
+extern void debug_dma_map_phys(struct device *dev, phys_addr_t phys,
+			       size_t size, int direction, dma_addr_t dma_addr,
 			       unsigned long attrs);
 
-extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+extern void debug_dma_unmap_phys(struct device *dev, dma_addr_t addr,
 				 size_t size, int direction);
 
 extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
@@ -55,14 +54,13 @@ extern void debug_dma_sync_sg_for_device(struct device *dev,
 					 struct scatterlist *sg,
 					 int nelems, int direction);
 #else /* CONFIG_DMA_API_DEBUG */
-static inline void debug_dma_map_page(struct device *dev, struct page *page,
-				      size_t offset, size_t size,
-				      int direction, dma_addr_t dma_addr,
-				      unsigned long attrs)
+static inline void debug_dma_map_phys(struct device *dev, phys_addr_t phys,
+				      size_t size, int direction,
+				      dma_addr_t dma_addr, unsigned long attrs)
 {
 }
 
-static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+static inline void debug_dma_unmap_phys(struct device *dev, dma_addr_t addr,
 					size_t size, int direction)
 {
 }
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 107e4a4d251d..4c1dfbabb8ae 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -157,6 +157,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	phys_addr_t phys = page_to_phys(page) + offset;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -165,16 +166,15 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_page_direct(dev, page_to_phys(page) + offset + size))
+	    arch_dma_map_page_direct(dev, phys + size))
 		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_page(dev, page, offset, size, dir, attrs);
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	kmsan_handle_dma(page, offset, size, dir);
-	trace_dma_map_page(dev, page_to_phys(page) + offset, addr, size, dir,
-			   attrs);
-	debug_dma_map_page(dev, page, offset, size, dir, addr, attrs);
+	trace_dma_map_page(dev, phys, addr, size, dir, attrs);
+	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
 	return addr;
 }
@@ -194,7 +194,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 	else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_page(dev, addr, size, dir, attrs);
-	debug_dma_unmap_page(dev, addr, size, dir);
+	debug_dma_unmap_phys(dev, addr, size, dir);
 }
 EXPORT_SYMBOL(dma_unmap_page_attrs);
 
@@ -712,7 +712,8 @@ struct page *dma_alloc_pages(struct device *dev, size_t size,
 	if (page) {
 		trace_dma_alloc_pages(dev, page_to_virt(page), *dma_handle,
 				      size, dir, gfp, 0);
-		debug_dma_map_page(dev, page, 0, size, dir, *dma_handle, 0);
+		debug_dma_map_phys(dev, page_to_phys(page), size, dir,
+				   *dma_handle, 0);
 	} else {
 		trace_dma_alloc_pages(dev, NULL, 0, size, dir, gfp, 0);
 	}
@@ -738,7 +739,7 @@ void dma_free_pages(struct device *dev, size_t size, struct page *page,
 		dma_addr_t dma_handle, enum dma_data_direction dir)
 {
 	trace_dma_free_pages(dev, page_to_virt(page), dma_handle, size, dir, 0);
-	debug_dma_unmap_page(dev, dma_handle, size, dir);
+	debug_dma_unmap_phys(dev, dma_handle, size, dir);
 	__dma_free_pages(dev, size, page, dma_handle, dir);
 }
 EXPORT_SYMBOL_GPL(dma_free_pages);
-- 
2.50.1


