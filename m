Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90F6C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFC48E0018; Wed, 23 Jul 2025 09:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539DE8E0002; Wed, 23 Jul 2025 09:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476958E0018; Wed, 23 Jul 2025 09:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 37D498E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B27FE1A06D3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:15 +0000 (UTC)
X-FDA: 83695542630.05.4CFCE6B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id EFA7116001C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e+o46CZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMPSaS48s2BLkCMh+Te9N8Qy5swPaaarxkcbp0q8HM8=;
	b=JJHkRDLi20Osx/tWQyLSOrM70cAghrjiRAEsGUjWIc4YwO87T6cNhvNQdOJyXWYjhiqY09
	Avv8yRMzuSuw338V/IQTsPd3tl4ghvCTB2crX47IwEsm3zE8+dpI/EpYI3s5mC/AX2AhcK
	9sDq4DHea6wFtGha921r0ZIcgQxTVBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275734; a=rsa-sha256;
	cv=none;
	b=Sh3A6hVBInUQ5MS1oInl7r5KknhBHItpdsKRFXcvYLTdbt/IERIZkYeLU9Y2ZOpJPmbOv8
	YBE4JwIQq36B7kHkPlzoovuOMRSSq+MYrQKZU7KqS/GFIcxh3I6UcdYDmWCQazKwPw0UZV
	9Wqwsi3KBy4NwNe0h4+0+znVjOkCTqQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e+o46CZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id B96975C5F50;
	Wed, 23 Jul 2025 13:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B394AC4CEE7;
	Wed, 23 Jul 2025 13:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275732;
	bh=GXlQnmpexeTqci2NeyVI9G56rXBq53z16W1gp+u+W34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+o46CZ+1BVXjwu+WWdHlJVcgB06PCQN9DTipLM1BXLZibSweX/79i0ktABh5Wsp7
	 WKbql3hFitkoH6uxbDjEwyXruYzw4YY5M6fSdyLtQzznD6f+h9bSbaFlVvYVZossoc
	 m0AFtWGU9sMGGGEVCcD2Lbvp+Fli76ujFDDtB/w0BkVQlxlcs15pAQKSl30k4y9kdi
	 7aG1VmGwS8/feMwD4P3W0v6mLUlPwWheztEcUAB+WsxA7u5cq/tIlZpOZa/QqX3IEF
	 oHfNuID6jKxDBaWswKnKFSNnaBx+iG59Ww1QmDUuufZ8TfQavpmmt4LIqoTDSbknte
	 sekB5LxhhhZHA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
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
Subject: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure for cleaner abstraction
Date: Wed, 23 Jul 2025 16:00:03 +0300
Message-ID: <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFA7116001C
X-Stat-Signature: 8ne9pwu5ij5nqftz776tidydn31jj3ow
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753275733-98280
X-HE-Meta: U2FsdGVkX18Ij5lAJNLRMHF51Rzkl2VKTA2mnGW3MbD8ISaS84ZgjTSbEa2xxMTb5li5eO9i8iSc6Z31hZiZbDmEfNwgQ99pEi9fpPIH9MtUZc7D423NbF/wlLpQNzMAzgBtNV3d1pSdOg3o34iz8ZKFCBi0YtLsVBB70vK4xgRegXNvtNTofT4fT8EPeV3imlPz877veCpnBlbwnZzhM2S77lo9s4E8p4eo4/aeLEe3hMcsspRuWcE9DbcC5MPa9tB8ZMExMRQf3shj56aPFbFmtcNi0TjxssTlpOdQZzJTbufOtRFssjUaG+iUwsRnBYn8JqxXYILPqg0rRV+vVTOBVu75WVeC9bEyU7iD41T5NuPweXBwm6HYMopElOXrEIiwe3U9xPgW0/6GgumbmToFqGvO6vx/DP4SbRscCn0xxF0B32YEO8kfE5AuTBNOcLn5JDgy3vaAN+jdXQGFA1zR7Dz21lIzV4dwLzPE3PN2mac/EraPHeQqsiocda23QrhSRvYwTi+GzzkUXAcygNRd+z40cODayFv24R5y3i78LhAyKrirOagZC+pVtfzQikM57rNwIUEFO1Cbj39vD+yCqIlnE7qPxf41RXlvFjQEWiPRtbVrXdPZpuUx8po4k7Wa6LpdWKxF189htqMLvSJGWE2zp7PCSWpGOgkZ8h5OP+Tt/2l07GUAZQIsJ8UusIqhpR3GSFJEgfBtgOTWEH7fyJcP3l6Q+Lul9aXJsOXfpe4SOg2I/KGpG8yJjSGjf5AnGmsusdm4CFzjs/riidpogeAbIjKH/yuUyBTaf0PIg0WomXKLfzxREV3W5PWzjWv6VVkiCVqU+Gb/AfOSCyfRmRcHzLr0zYBgQ44zaAKoRANw+B6zzxWMASMzGHYv9R3KCv9b7EDV/Z7htGp2ocdJ8sVK6QduoDqJLKTVWqmrXDf3Dv5ddtdccE5E7nt7c1ucRInhbngIIlEY+u4
 2TI3jf0x
 xRWq5VGtIySOu+Ca4cxRGoldB3AnQKdiQ83wkiHlVg5oxKrIqtpc00/QcNIMn5O5eJaySE8UU36S+/7ffKLkjvCTKdMHEya5q1l9mdvXJ426Bm5rs8taO56s8VzGW3bulQilnev+t3eaMjEWRWFQXpdJrVUmrEp1Mt5yUQW+/sGED9oYs1VVmaW2h86SxBABuGkkFYJNDgIkv1TT75LLUnd8yJSQDl6yvpPgyE/2b6tve3zF+ed+oS7blOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Extract the core P2PDMA provider information (device owner and bus
offset) from the dev_pagemap into a dedicated p2pdma_provider structure.
This creates a cleaner separation between the memory management layer and
the P2PDMA functionality.

The new p2pdma_provider structure contains:
- owner: pointer to the providing device
- bus_offset: computed offset for non-host transactions

This refactoring simplifies the P2PDMA state management by removing
the need to access pgmap internals directly. The pci_p2pdma_map_state
now stores a pointer to the provider instead of the pgmap, making
the API more explicit and easier to understand.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 42 +++++++++++++++++++++-----------------
 include/linux/pci-p2pdma.h | 18 ++++++++++++----
 2 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index fe347ed7fd8f4..5a310026bd24f 100644
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
@@ -1007,8 +1006,13 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
 {
-	state->pgmap = page_pgmap(page);
-	state->map = pci_p2pdma_map_type(state->pgmap, dev);
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
index b502fc8b49bf9..27a2c399f47da 100644
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
@@ -144,10 +154,11 @@ enum pci_p2pdma_map_type {
 };
 
 struct pci_p2pdma_map_state {
-	struct dev_pagemap *pgmap;
+	struct p2pdma_provider *mem;
 	enum pci_p2pdma_map_type map;
 };
 
+
 /* helper for pci_p2pdma_state(), do not use directly */
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page);
@@ -166,8 +177,7 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
 		struct page *page)
 {
 	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-		if (state->pgmap != page_pgmap(page))
-			__pci_p2pdma_update_state(state, dev, page);
+		__pci_p2pdma_update_state(state, dev, page);
 		return state->map;
 	}
 	return PCI_P2PDMA_MAP_NONE;
@@ -185,7 +195,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
+	return paddr + state->mem->bus_offset;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.50.1


