Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5B1CA0EF7
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9D08E0025; Tue, 19 Aug 2025 13:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E908E0005; Tue, 19 Aug 2025 13:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54498E0025; Tue, 19 Aug 2025 13:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C86288E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:37:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 665C01A018A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:37 +0000 (UTC)
X-FDA: 83794214154.30.C376576
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8A62C0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRK2iAcw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfxLLKvH/DpVc2NbZowrmc3+FoU4H0K6l6sYGFFyH/0=;
	b=YKavnqDie/7Q+zCGtaChrXrI+RumALQ7cOqoIWhf7Q9qoU8qGIoK4XlxhRE/247Ipmeuoc
	fqOkD9QHPPk2M+u+5a++nVLKLMMKg2eiypEjxNUTGS+IHeFhc405EPWZ0gHlx5gQoaahiv
	zhVSnXnykCt1zIquZrbd3PUnPnSW9J8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRK2iAcw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625055; a=rsa-sha256;
	cv=none;
	b=6CRMsD+tGSw9xILh2Whvc6oDY6vOKsjl14yKbihkZyd/Xg12Lpeb5BSBsR2yXBPEDjVQ4+
	gi0Lcbh/RUv6y17C4fKWjsPfE1+9JQS/h725JCtfgMJuMmsohe8ut91frm9f7uz33/KrP2
	EB/EQ9hRLdGC/9rkxqMoWWju0C5X1FI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A6B125C647F;
	Tue, 19 Aug 2025 17:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBFAC4CEF4;
	Tue, 19 Aug 2025 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625054;
	bh=+6SuvKk/7U//cW4wXi0ADVlYqazqjfxTWHubS42t1as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRK2iAcw9naXxqVCwrZYTg0L0tJVO6Z8uYDGDwR7RfbMKGUm6C1t5jhQLddy+0Enj
	 nh3J3isWu7Zd6NLSnDbBHV9WCIoJ+nc0jxpVf8VSDaWdIXAnmpF5ICK0WXbRS5d8cv
	 8Vrlhstq8V9i+QaI/1n0oXTMXFX0BmUBAQxY2YwE9ujB5cQHDGmVxVpwXuHElC5fEa
	 Y5GtQScvK8ImAhambk4WLChGvqvr9FrlV8TMmlZ4IwV6koBzxY/i+8uGhj3kbJs4Gu
	 KVpki2bklNgxb/LEU2SZVxE1nNnUsBg4ZjpcimliacFY+BJFISpyvgWuUeq0efkjN9
	 BVZdeXsQkCpzQ==
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
Subject: [PATCH v4 03/16] dma-debug: refactor to use physical addresses for page mapping
Date: Tue, 19 Aug 2025 20:36:47 +0300
Message-ID: <478d5b7135008b3c82f100faa9d3830839fc6562.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8A62C0007
X-Stat-Signature: mc5nz46tchhktzfswa4p5itbgad4hwrr
X-Rspam-User: 
X-HE-Tag: 1755625055-860484
X-HE-Meta: U2FsdGVkX19kAFFHZwvmFjGX1bQkaj4pweJpXRjo4f+X826tvhnrDhv5HSZqnPmah05KP6MVDcLFYuie4DsffAdShl+HBLXJ6Pwu6vntO3i+1KkkS9RXrogTkeLI9+qhWgJEwSn+JFu7af8moktlFBPDQM9oQJMYC/UI8ReiyILYHovSUGBN3qu6hy/7G6D+Z/XvXqPpMmM5e22M64yjklDwk/XfXxSZ9gnxdgGrmBNDyc5eDnFFqxFnujzGvNM3xS7HWCtjo12EQp0MxyDQVmvPPu2BnNCMlNqyMcKD+kYb0ipX1wI9pvt1hP9pLCxzQjet4odoI+JJgtoMCgZxjvJ5AxEpQZvhEEXCZbUh24LxKUeJJyll7HoGR49c45crroUdtCwp2U/rK8L52zUHkMlO8qeWYj8KsX4V79UjTrjsQGd+up9esNM7Z0tFYQ6+vrE64XNxJ0sXDUOB5EVTe9XmztQ1Uve8+sivUzkXC8Kcd49ax5laMAk6qZX7KW1Bvv00hfBKYwNWVLozC2M7BxbDAOKWj6Y4cPjD254z2EvvIJvZFTWYH2ClH6WxMg0Aqt5I3pSda4yZERMJ5Zg/ebG5C3s2283lXWKsOqsUF/U/ZC7E9k7If7q6eYImZGALHephk2QVI0HB7lmTa7Xe8ihYOqRHtu+erZNUQO/JkoYfDFO6A2toK3mRwlVjYWXAN2N16jTHFo7CF2kyhRQYjksx99DOkVtDUoF/HecdEZnp68SBoamTkmTYn5igL2JnZExxhYblyFlwwVVWQ584i41XbzNAJuWOpQossXD0jRVjitHLjO2uZsET4XptWEP+5uxu/AlpH/Gjfe/NK0nhGrDTnjC/xGAUg0Zz61qehYAMuyZL6aIhR5PtyoX1Y5UbykJ9tOvzs7j6Z0mTB1bJ8v6AJBP4USnj4x8jn8lUATCljB0ml0PcJhyj8OTLrTdWGo6hBesK5WIot3hgbtf
 FX5OpBjn
 nUyWqWbSzKmJzRGwtMY9NFNeemmyxV2VKVHxuIhmQpCAxadQXL3cD/VgzIg/nfBNPortt0RAscfaiZZAbbTvOAwLYHDYm+ToBbMRVcTKE6RVWTiLNXMdS0qwt5Z28Hi2rQDq0TVv3k/Yl11UO3bdK+ta3hk9BRxsnYVrUdljsARAR5YNkzfqvWOR6mgOC3tHiGFpPm48zLlYgA+kGV4NJGKKbPD/o98A4SeWP5lsoeY2XSV8o4ycskt+YyGQza3DY7qvHN7mUpg1Aqyanmm2QkG91AxxgxgNIjOMLWDZC01LX03BuWRMvNH+UcQ==
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


