Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C9ECAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A258E0008; Thu, 25 Sep 2025 09:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A7F8E0001; Thu, 25 Sep 2025 09:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A598E0008; Thu, 25 Sep 2025 09:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE67D8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5946A5635F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:39 +0000 (UTC)
X-FDA: 83927827158.22.71252A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 913E340006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uk78CthZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806317; a=rsa-sha256;
	cv=none;
	b=Hf3xaPdncP+IzRRqAmQlbSIxSpGHAoKAcBqqbcTTCYazLfaVduZvADNpFh1vO8QpHGaOUg
	0KZBQfLaIbx01bJ34zp3J+sElDfqfJvgtg/Jz3wRbdbfpHDLFhqAqQCs71sPmD5AjxJFOm
	gbHLuONha/CURXkG5mE0wixWMt4iV2M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uk78CthZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXj8Zhv0n5RHEVClP3MAukqlrKSdBSBzNzDLKzkZxzg=;
	b=McifBsqfoDh7TNAJfhS0AvDOQq4DovikhvQ9pC1FWZkJx5WAKaT7VqZZ2QdiJcf5Y9CpQO
	YtR2XNWjKcOrMgheZnZA2XUDjlQ80eiKZ8bRjYIuxd3PFJAtl+eTmGH4fxyQSEjuUtfMjH
	pxRgmzyLkqtILytltNU7U44W6wU4v+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A11BD43C66;
	Thu, 25 Sep 2025 13:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC55C4CEF0;
	Thu, 25 Sep 2025 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806316;
	bh=bLiFTmXHIlh7nPvGU+BJZLpSYXPsRMfThGRWFETaRWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk78CthZmFsOCifltdwntmj7PtKGdyc/NeK4L6a3nc5EdAhTLPvNMOHdARMN0VoL2
	 4R7TYnpGJo1LON0oR32ibV7ftBfOetF1jmIAe6DOHxGubqw48RwQC6jlBe5ph1AZ8F
	 M+5rubtOOzRh6UdIMXf9+EKKQkJqVRcfYnoLdxTbvZglux/G8NXX8p5jZF11hl+qj3
	 H+znNvLJlxy3AdCrKnS3RKfwC3VWoVM5lMRyWhjPDEIfnIQqyOASPWEizVeHghXcjv
	 Ho9qi9q++83xflMWf5Miua7j0NpEG18iI103f26egQd8/6JHqLm03U10BSR2kmJK/Z
	 2VKmnl3IQEsSA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 01/10] PCI/P2PDMA: Separate the mmap() support from the core logic
Date: Thu, 25 Sep 2025 16:14:29 +0300
Message-ID: <3ae95fe8fd5753cd8394387e6c67611128224235.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 913E340006
X-Stat-Signature: mkc7mo9puxokpswp1xptawojnib5aao5
X-Rspam-User: 
X-HE-Tag: 1758806317-636007
X-HE-Meta: U2FsdGVkX182lLO+k1a7KtXeiuOxlx2trjpA1CgCnNaIllDwLh+6TSVwZL1yNkAofjiXNAtMdfo2/EkB0vn9/xCJEgl52kuONWs0Bwztr/jcUuU/zPF8nv1Jh3mFjL47AE6qNRZh50/x5+yAMRbPAx+J/dOfYSoCN8N+T94GVhnkdEohoJ4rnXdMBgi/+08pwHRJIPKLCmXF6Pxc9pnqUA22Zi54osW/Pt3j/SZ5PmDt/gP3t+tzIEaIRAE45MtFiUyNYOtRdkSz0OB7J7N2p9dg9sdg3ovPOBL9qa5IB6LWOz7oFn0cdJ1usplGAI/LDRtbYnoLEg+0eVadp6S8iKN02i0l3TIWWRk9yQZcKlCM8bVwyAsTiWCtQ6Zsfdz+B3VmidEHOZJcY6lsWNloFFlh4bvGqIOt4iz0tiyqqveGVkP6N2y8RaWTUW/raDO6lzO8eSOH1ozgLGi2VEz+pyyFeaVAAavzx0fZh2pei3krEC0HeV6TgYWbpNQDDvm9nBulTv1NSL0/IKRZ3aeu7V1zy4PLpJHYxhd/FG+w4gtbx0dQUR8FuPyo1AHW+usrGGQ1cY7xFM/9mp/B6dkq+IJgsEyF4QfECzm1iXoX4bzcs9Bf1l4WMhEea5F5jXLHqVRnPsW9oJFTz7IdfM7tSTrmd3ltsbo5lYE0MzMIQlO6rwOXhnkBTxilW8QY+0SdHCzrfHpWSbvyVK42dQEo3Q7zUlhgjmNu7vOAllJx6TLUymHt40W/yo/zs4nwEjOCYbt8VZVx0qmO0rQpMKxX2CsyChXRRFHfD3Bmyx5vJAGYsjNUiUavft7sp7z/VucDkhAOLM17Hn3vZ4cWqaKTFog1PFA6yyGmQMSem/2ocTN3PVE9rp2LJ05XoXxkRa4mueZ7kvB+WpDKG/+26cfRS56gbqAHzNq2x3uUrPa/I6dyZSgRPMhP2QdxvhN2TgJjT7+2UpvhHWh46vFsSf0
 8I3ErrMX
 K4Boh3qDpgunTfoW2zqIIWF3gqCqGMMNSPpLFop5HzTiaEyXYhdTFznRNQVxrKWLtd/E5Xrz/O5NJKpctCimGIYr9M1I3q4OGTe/0/AhkVZwOjkOFllpUNcrfLS/k9jHQXRAmI2Xw38hzZWzpgjUZrD2lcq9ScsfP90chCbQP3/6r+H6FqmS5UPNQ7BkXSbTi6zeAPq3KgYfqsS9ltFxGlY0U3X+IU74u7kOWTU+0xX3WRus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Currently the P2PDMA code requires a pgmap and a struct page to
function. The was serving three important purposes:

 - DMA API compatibility, where scatterlist required a struct page as
   input

 - Life cycle management, the percpu_ref is used to prevent UAF during
   device hot unplug

 - A way to get the P2P provider data through the pci_p2pdma_pagemap

The DMA API now has a new flow, and has gained phys_addr_t support, so
it no longer needs struct pages to perform P2P mapping.

Lifecycle management can be delegated to the user, DMABUF for instance
has a suitable invalidation protocol that does not require struct page.

Finding the P2P provider data can also be managed by the caller
without need to look it up from the phys_addr.

Split the P2PDMA code into two layers. The optional upper layer,
effectively, provides a way to mmap() P2P memory into a VMA by
providing struct page, pgmap, a genalloc and sysfs.

The lower layer provides the actual P2P infrastructure and is wrapped
up in a new struct p2pdma_provider. Rework the mmap layer to use new
p2pdma_provider based APIs.

Drivers that do not want to put P2P memory into VMA's can allocate a
struct p2pdma_provider after probe() starts and free it before
remove() completes. When DMA mapping the driver must convey the struct
p2pdma_provider to the DMA mapping code along with a phys_addr of the
MMIO BAR slice to map. The driver must ensure that no DMA mapping
outlives the lifetime of the struct p2pdma_provider.

The intended target of this new API layer is DMABUF. There is usually
only a single p2pdma_provider for a DMABUF exporter. Most drivers can
establish the p2pdma_provider during probe, access the single instance
during DMABUF attach and use that to drive the DMA mapping.

DMABUF provides an invalidation mechanism that can guarantee all DMA
is halted and the DMA mappings are undone prior to destroying the
struct p2pdma_provider. This ensures there is no UAF through DMABUFs
that are lingering past driver removal.

The new p2pdma_provider layer cannot be used to create P2P memory that
can be mapped into VMA's, be used with pin_user_pages(), O_DIRECT, and
so on. These use cases must still use the mmap() layer. The
p2pdma_provider layer is principally for DMABUF-like use cases where
DMABUF natively manages the life cycle and access instead of
vmas/pin_user_pages()/struct page.

In addition, remove the bus_off field from pci_p2pdma_map_state since
it duplicates information already available in the pgmap structure.
The bus_offset is only used in one location (pci_p2pdma_bus_addr_map)
and is always identical to pgmap->bus_offset.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 43 ++++++++++++++++++++------------------
 include/linux/pci-p2pdma.h | 19 ++++++++++++-----
 2 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index da5657a020074..176a99232fdca 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -28,9 +28,8 @@ struct pci_p2pdma {
 };
 
 struct pci_p2pdma_pagemap {
-	struct pci_dev *provider;
-	u64 bus_offset;
 	struct dev_pagemap pgmap;
+	struct p2pdma_provider mem;
 };
 
 static struct pci_p2pdma_pagemap *to_p2p_pgmap(struct dev_pagemap *pgmap)
@@ -204,8 +203,8 @@ static void p2pdma_page_free(struct page *page)
 {
 	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
 	/* safe to dereference while a reference is held to the percpu ref */
-	struct pci_p2pdma *p2pdma =
-		rcu_dereference_protected(pgmap->provider->p2pdma, 1);
+	struct pci_p2pdma *p2pdma = rcu_dereference_protected(
+		to_pci_dev(pgmap->mem.owner)->p2pdma, 1);
 	struct percpu_ref *ref;
 
 	gen_pool_free_owner(p2pdma->pool, (uintptr_t)page_to_virt(page),
@@ -270,14 +269,15 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
 
 static void pci_p2pdma_unmap_mappings(void *data)
 {
-	struct pci_dev *pdev = data;
+	struct pci_p2pdma_pagemap *p2p_pgmap = data;
 
 	/*
 	 * Removing the alloc attribute from sysfs will call
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&pdev->dev.kobj, &p2pmem_alloc_attr.attr,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
 
@@ -328,10 +328,9 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-
-	p2p_pgmap->provider = pdev;
-	p2p_pgmap->bus_offset = pci_bus_address(pdev, bar) -
-		pci_resource_start(pdev, bar);
+	p2p_pgmap->mem.owner = &pdev->dev;
+	p2p_pgmap->mem.bus_offset =
+		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -340,7 +339,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	}
 
 	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_unmap_mappings,
-					 pdev);
+					 p2p_pgmap);
 	if (error)
 		goto pages_free;
 
@@ -973,16 +972,16 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 
-static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
-						    struct device *dev)
+static enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
-	struct pci_dev *provider = to_p2p_pgmap(pgmap)->provider;
+	struct pci_dev *pdev = to_pci_dev(provider->owner);
 	struct pci_dev *client;
 	struct pci_p2pdma *p2pdma;
 	int dist;
 
-	if (!provider->p2pdma)
+	if (!pdev->p2pdma)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
 	if (!dev_is_pci(dev))
@@ -991,7 +990,7 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 	client = to_pci_dev(dev);
 
 	rcu_read_lock();
-	p2pdma = rcu_dereference(provider->p2pdma);
+	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
 		type = xa_to_value(xa_load(&p2pdma->map_types,
@@ -999,7 +998,7 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 	rcu_read_unlock();
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(provider, client, &dist, true);
+		return calc_map_type_and_dist(pdev, client, &dist, true);
 
 	return type;
 }
@@ -1007,9 +1006,13 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
 {
-	state->pgmap = page_pgmap(page);
-	state->map = pci_p2pdma_map_type(state->pgmap, dev);
-	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
+	struct pci_p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(page_pgmap(page));
+
+	if (state->mem == &p2p_pgmap->mem)
+		return;
+
+	state->mem = &p2p_pgmap->mem;
+	state->map = pci_p2pdma_map_type(&p2p_pgmap->mem, dev);
 }
 
 /**
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 075c20b161d98..27a2c399f47da 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -16,6 +16,16 @@
 struct block_device;
 struct scatterlist;
 
+/**
+ * struct p2pdma_provider
+ *
+ * A p2pdma provider is a range of MMIO address space available to the CPU.
+ */
+struct p2pdma_provider {
+	struct device *owner;
+	u64 bus_offset;
+};
+
 #ifdef CONFIG_PCI_P2PDMA
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		u64 offset);
@@ -144,11 +154,11 @@ enum pci_p2pdma_map_type {
 };
 
 struct pci_p2pdma_map_state {
-	struct dev_pagemap *pgmap;
+	struct p2pdma_provider *mem;
 	enum pci_p2pdma_map_type map;
-	u64 bus_off;
 };
 
+
 /* helper for pci_p2pdma_state(), do not use directly */
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page);
@@ -167,8 +177,7 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
 		struct page *page)
 {
 	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-		if (state->pgmap != page_pgmap(page))
-			__pci_p2pdma_update_state(state, dev, page);
+		__pci_p2pdma_update_state(state, dev, page);
 		return state->map;
 	}
 	return PCI_P2PDMA_MAP_NONE;
@@ -186,7 +195,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
+	return paddr + state->mem->bus_offset;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.51.0


