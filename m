Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C60BCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6765F8E0054; Mon, 13 Oct 2025 11:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E2E8E004E; Mon, 13 Oct 2025 11:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B1F8E0054; Mon, 13 Oct 2025 11:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 455608E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2E8D13B325
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:34 +0000 (UTC)
X-FDA: 83993467908.12.4731EAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 20DDE40014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YttuaUVj;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N31jpsxf0JWkUptzcq4c8fvy8/o/2Rg4o0o+O/w/6ng=;
	b=InYAkZFPmjTMC+c4/YtrQeP/8MXKdbuhSt7docLDJtjIzgv98VAE7UQ5Arv83TEFgvFeID
	UmQojT/8HDaO+nWdwPm2aFJzSWBq4VrPv+Pwrh1Fev656DFBItOsfzwUFSMGFGWVvYG97f
	me3P/POUs1cp/xdBO3ccDh7aDj6zc9k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YttuaUVj;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369193; a=rsa-sha256;
	cv=none;
	b=HFDpuWW5UUi18a2fCJ23JKsiD9jcRhkQHPlX439F6ugdKLbGo9BCkBuc/7/k6KgjDT6r/a
	zDDBNwy/KmQjSoczx5/c2HyPHf9bGVr4xAbVZ3HzwFHFAfbY6S9vEIUFH8woiIX6MSxBKe
	2vkYQK0T/FAjULbtwIOLZqI4WgAeUR4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AB0E48B12;
	Mon, 13 Oct 2025 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844F5C4CEE7;
	Mon, 13 Oct 2025 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369192;
	bh=nDcAY6cfJF+Hz/RDzBDDYPPxaUyhkXABHvgRNxvqTpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YttuaUVj+Kp9Af1Z/wOmzqR4x6u6MKQoxsIMYnkRbbYgEmRoCGzLAnLZ8udyX3+Nj
	 fbHvebL0J/revALUa7eNsii3rFnEF/H1FJS7IDEAjRJFFBCbS0Z7DiQ4HFwJx2pfiy
	 5kltRqFbwykOv4pNIESnT4GACAyFkqxIDZ1vnJcAFikQT0VKqYLp5lH/8XM3+J/T0j
	 I7LnUgPKS8O6T4tnF2v/I89rZGyKSv+sv44qeoxlig01HaC9vpwRzbr4NDAj0F0qH9
	 ske2ZxLB8xL/DHHOBUalLCImj/dreE+P0o8GWO2gOx47UIgYlr2eZnxqOn5kaoyjof
	 Vt4E9qGd5TdqQ==
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
Subject: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the core logic
Date: Mon, 13 Oct 2025 18:26:03 +0300
Message-ID: <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20DDE40014
X-Stat-Signature: u3pfe8odn5tu37s5aeb5xhsb5xkwmini
X-Rspam-User: 
X-HE-Tag: 1760369192-976517
X-HE-Meta: U2FsdGVkX193jJkLOWSWevDk8pB/Azcqey2OLlcW8vnztSf9iJd+TK+Lqn4VwtS08AjEg/6lFy/XO/0M1VK18126fx89dQtAATGc1OiDOlEhk7P9PCKaERFnlNIdhgWYwnB7Jm4sRSOM38yIBO917vJ18E6upt0cPGWDciLH3OgxY9OexzsQDUbjt6c09o2sykBq959l7lblqx182i1eqtTOBE+6epjbGAbN9mlgiDUEFk1uZ35VDcOHx8ANNwwybEh43FhR2joFBR4OD7ke0MkM1zNfynKUh0Vx5f97UgzFF00/9vy2borMVtKM/jnLcEyNG0qAvI7xuaw9SYLC763kum9RnBSbN+PLAH50jry9IUalKMQHeIx9bIzNNGAeYMXoLZ9G/Ch6h122pyaJKMyitdEvM4xVkgz+AkDnDWoUyG9P+sz22O/x+ANNpIi2rCyAx+Pzw5ovDmZJ0nJDmkp2QMuAMrIb4CNMACLktTGXU6MAhAXU8GZ/JhlgwKTryEdRy0BNv4DX4dkUlYoF4R4lpG46VsTTKdCxsQrDJI2FHaqD38srdmuAlhK6B7wkVs95fLSNJWteVe7KFDjXBjKIQersY+sEEAdJtVIVHUipXpEEaifAtOoM3pKGubdhuA7alpTfVLJ0AU6H0CAb635V5UZ+dfTMVcBbOI2O/P5eoq9c/ySEndo65QjrO/vQMqI7My7YkT2P3KaZpk7788ZWDn1J228TIIA1Pm3m6raiupZsGGKCsrwPEtMxkvFErwAkdlm++zHJFDp5jQuIAF5YXmeYfCnhlfvemp30CcG3MLEziPTlopThK/14vVXns3HLocp66ZvvRRgAshEuuda/yxe4QpJjeoS3y5nkQuPNb1l9A24UPpcFZz+PdYtqqb4/cHB+elFtGMUIBiHG/VGK1d024wx/wpyrOXhfqMT3YOxT5Kh6pJHpTcf8kiptK15oZjLsG59HK7foJLL
 8MCrrRaG
 79ODw44I7/SeNj1qfIrAT3P/ijS3mk+8I4YnbIMR7xjsEtA5s2/PDlXJFvdV/yjKjwKs271OGn6cO7nAS0KGe2UA/VbSe/aCoin0/H5G90mXLf0U99ZDFG26/ALLTScFnfMXL0ZECbOPO6mu9yaAKW/iTPeALHZdb9+4iWE+Ns8fcV0QT7AEWoeYV5KQH8pHl3u7HnpJWTelIjwiMztqmzisUAHN4VX29+qGdQzjVSZnGQOk=
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
index 78e108e47254..59cd6fb40e83 100644
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
 
@@ -972,16 +971,16 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -990,7 +989,7 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 	client = to_pci_dev(dev);
 
 	rcu_read_lock();
-	p2pdma = rcu_dereference(provider->p2pdma);
+	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
 		type = xa_to_value(xa_load(&p2pdma->map_types,
@@ -998,7 +997,7 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 	rcu_read_unlock();
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(provider, client, &dist, true);
+		return calc_map_type_and_dist(pdev, client, &dist, true);
 
 	return type;
 }
@@ -1006,9 +1005,13 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
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
index 951f81a38f3a..1400f3ad4299 100644
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
@@ -139,11 +149,11 @@ enum pci_p2pdma_map_type {
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
@@ -162,8 +172,7 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
 		struct page *page)
 {
 	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-		if (state->pgmap != page_pgmap(page))
-			__pci_p2pdma_update_state(state, dev, page);
+		__pci_p2pdma_update_state(state, dev, page);
 		return state->map;
 	}
 	return PCI_P2PDMA_MAP_NONE;
@@ -181,7 +190,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
+	return paddr + state->mem->bus_offset;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.51.0


