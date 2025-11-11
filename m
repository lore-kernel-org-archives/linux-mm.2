Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8A7CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D548E001A; Tue, 11 Nov 2025 04:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634FF8E0002; Tue, 11 Nov 2025 04:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A738E001A; Tue, 11 Nov 2025 04:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 458BF8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14B31160422
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:20 +0000 (UTC)
X-FDA: 84097875960.13.5C6C81B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 44FDB140004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5KiTPgK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uM+RKnG6jEvlRiricLMqQXWfDhYvNwJY8dmK9ZmD1Y=;
	b=TLnpLGicspMFst/nndkMBgojVLGNXBukqGhe3O19Fgy9R6J7vTUzwH+zSEuGW9Sr7G3KUn
	IH7wy+Z6VRgXaAAt8QayvxEn0gBIYXdYKeTAlVgM9Bckg45loGEoZfmPE1WOGYJP3DQz+N
	N4bOvh53BQYXnWfrHO/ps1mVyftU8Zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855098; a=rsa-sha256;
	cv=none;
	b=gOkaJDVPtTzaMAeHAUODQnDLLQ4D/r17skxD3DhkkL0/RhTh/K1+xWNbNmFHtF+GHQMWYp
	Gvp1pQzdYqciROx1ls5aoYMOe5LVrBtOacLG5RSsDjqTpWHCc/NHGiBTuNJjGB7zhHv2on
	NCE4+LYlq8uAozovF+U5s+ZQ0T7M+Ew=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5KiTPgK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CCFD41B1C;
	Tue, 11 Nov 2025 09:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1259C116B1;
	Tue, 11 Nov 2025 09:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855097;
	bh=4vyjtJSAmX+VddHW4t3VG/HuvRuBP7tWtC+cspVcQ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5KiTPgKf7oBHSXqf+4COQRL4VNBI2vxWD1AZfMFj7blDwefHXLzzniQlBT8UePPX
	 7V3GkFWw9+EW65uxbLLOtSGvmO5QBrPWKyN0hmXZ9xq6piXuErWHpWAr3gYmS047Gt
	 eppCwyePoMgflTyYO/zi76fP5mnVr8smkX5zYkSGCJTEsEYmv34rMf2mZUm82E2NhK
	 OCWtvaQcGMimyU0NALhsxyRv7P7dmkgno1iCxhgigPHSMAJ6N+y8d3pRTsQEpJaVWN
	 VSsIrR4X0bQ0YkVwSSsm7RfLv5MnXIxNOdn2Ao/i/0TP112yQ0R1r/3L3N1rtJl3/j
	 RvBZwAs6T7fYQ==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v8 03/11] PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
Date: Tue, 11 Nov 2025 11:57:45 +0200
Message-ID: <20251111-dmabuf-vfio-v8-3-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ifcojwjbje3tk5xm7g4t6iucya4ckx4x
X-Rspam-User: 
X-Rspamd-Queue-Id: 44FDB140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762855098-373546
X-HE-Meta: U2FsdGVkX1+QIDNK5u2LEVfjdopl/IA3vgOm3onhkDTunA2pEDJ6vmypTOdfEZ4iIoQ3f30isz/5v/r0Vf7d7+AVUVfSoigdFGjqAAK7N3g0L2XNdfKid4uqEXCwvDxO9raP9zLtQBtatdJ+jyesZtTrEVRR1nfBxZR5RqMfhtbQdVUBA14N9jwJkUUZ/k0SnEfIWIJ9AmQgah+6Yr17BYO963HFvS5P/TfQ4ummr365/vf0vpuJh3S7LKKSHIsbFUQ4dMW6NjUSNDVPhD1YABg3wje39ZBtrqM6l+K9MY0SBW31Yebck71HufFbLBNHfBnvGf3bXrhEEZGYGmWB/TCr04Ki67KnQ80tRRiY1BHmxpWnkqxs6YUjED+Ezeo0TewMIssO6q+JoaRUvWwsqNBxC6v0TgCiBY6DQNNu+E5DZ9dhCO4uq/vNdW6bw8k4XI923brI6rFe1awCYTLT69Afjf211WELeRk4Ha1tS0ctIgvixzWZGSAV0KholhnqSTk5mEsJPT6dhp/f3OK1cfdHOxdenN1mKq/To1JwS+arVt86jsjch34pbUiqDv+fnGpFTCbhk8JHUAXF4BZxcGm7iZsxhbNlNCdTiUZhkiOV04CSv094B/L1gpu1OeX7aBURyRmYkN36DsNfSC9PtmbxDt7FZUErd7ZJyOYIEUMf1GmuR80YYFvevnJ32P0TlLv3rglnF3A23SDRXBY5BP6mxCOHXJHlGQMF2iUeTKIXsAQy47o+x/W28ATojUzfNOswuCG7sqrkVYJDQ8Kv7L30RdOf8phigaxVZc7yQedEhEjAEYx6qtPza+bjcWihmkOo/WQPDrQ4cg9uy+lNnhf2aAVw5SXbqri85LBljnOHNu+3UoRvBPMHG6xjJGuTw3ZLmBlreC8qYpGFNyKFfWVmeqEkqq7MuqkFLXLAZ7ufhIpeKU1KsDj0f/vhawQNIsoWxvFmZ0hrCDAJRGs
 3YelCTja
 wteSdKkI8Jfuhl3aNOVfGcbLz6trBMn7HwD1xmHlDX0CfM8WRvv5Pcnzbmvej8LiZc4qkESLqlb0vz/c6Umdt15E4ud0WiRNYbV/S+zZdJNJoRuPv3iomUvtU6DYPXSSSLzuHZV7RNxP+MOtXKG9AXiYclmIOZnxZQV9TkM52BPsrLJWW7LTE4oJOKxEIqGvnMLX8rjQT7GNhNFVMdkajSl+ImMdCaWiggNxA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Refactor the PCI P2PDMA subsystem to separate the core peer-to-peer DMA
functionality from the optional memory allocation layer. This creates a
two-tier architecture:

The core layer provides P2P mapping functionality for physical addresses
based on PCI device MMIO BARs and integrates with the DMA API for
mapping operations. This layer is required for all P2PDMA users.

The optional upper layer provides memory allocation capabilities
including gen_pool allocator, struct page support, and sysfs interface
for user space access.

This separation allows subsystems like DMABUF to use only the core P2P
mapping functionality without the overhead of memory allocation features
they don't need. The core functionality is now available through the
new pcim_p2pdma_provider() function that returns a p2pdma_provider
structure.

Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 151 +++++++++++++++++++++++++++++++++++----------
 include/linux/pci-p2pdma.h |  11 ++++
 2 files changed, 131 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 59cd6fb40e83..855d3493634c 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -25,11 +25,12 @@ struct pci_p2pdma {
 	struct gen_pool *pool;
 	bool p2pmem_published;
 	struct xarray map_types;
+	struct p2pdma_provider mem[PCI_STD_NUM_BARS];
 };
 
 struct pci_p2pdma_pagemap {
 	struct dev_pagemap pgmap;
-	struct p2pdma_provider mem;
+	struct p2pdma_provider *mem;
 };
 
 static struct pci_p2pdma_pagemap *to_p2p_pgmap(struct dev_pagemap *pgmap)
@@ -204,7 +205,7 @@ static void p2pdma_page_free(struct page *page)
 	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
 	/* safe to dereference while a reference is held to the percpu ref */
 	struct pci_p2pdma *p2pdma = rcu_dereference_protected(
-		to_pci_dev(pgmap->mem.owner)->p2pdma, 1);
+		to_pci_dev(pgmap->mem->owner)->p2pdma, 1);
 	struct percpu_ref *ref;
 
 	gen_pool_free_owner(p2pdma->pool, (uintptr_t)page_to_virt(page),
@@ -227,44 +228,123 @@ static void pci_p2pdma_release(void *data)
 
 	/* Flush and disable pci_alloc_p2p_mem() */
 	pdev->p2pdma = NULL;
-	synchronize_rcu();
+	if (p2pdma->pool)
+		synchronize_rcu();
+	xa_destroy(&p2pdma->map_types);
+
+	if (!p2pdma->pool)
+		return;
 
 	gen_pool_destroy(p2pdma->pool);
 	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
-	xa_destroy(&p2pdma->map_types);
 }
 
-static int pci_p2pdma_setup(struct pci_dev *pdev)
+/**
+ * pcim_p2pdma_init - Initialise peer-to-peer DMA providers
+ * @pdev: The PCI device to enable P2PDMA for
+ *
+ * This function initializes the peer-to-peer DMA infrastructure
+ * for a PCI device. It allocates and sets up the necessary data
+ * structures to support P2PDMA operations, including mapping type
+ * tracking.
+ */
+int pcim_p2pdma_init(struct pci_dev *pdev)
 {
-	int error = -ENOMEM;
 	struct pci_p2pdma *p2p;
+	int i, ret;
+
+	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (p2p)
+		return 0;
 
 	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
 	if (!p2p)
 		return -ENOMEM;
 
 	xa_init(&p2p->map_types);
+	/*
+	 * Iterate over all standard PCI BARs and record only those that
+	 * correspond to MMIO regions. Skip non-memory resources (e.g. I/O
+	 * port BARs) since they cannot be used for peer-to-peer (P2P)
+	 * transactions.
+	 */
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+			continue;
 
-	p2p->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
-	if (!p2p->pool)
-		goto out;
+		p2p->mem[i].owner = &pdev->dev;
+		p2p->mem[i].bus_offset =
+			pci_bus_address(pdev, i) - pci_resource_start(pdev, i);
+	}
 
-	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
-	if (error)
-		goto out_pool_destroy;
+	ret = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
+	if (ret)
+		goto out_p2p;
 
-	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
-	if (error)
+	rcu_assign_pointer(pdev->p2pdma, p2p);
+	return 0;
+
+out_p2p:
+	devm_kfree(&pdev->dev, p2p);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcim_p2pdma_init);
+
+/**
+ * pcim_p2pdma_provider - Get peer-to-peer DMA provider
+ * @pdev: The PCI device to enable P2PDMA for
+ * @bar: BAR index to get provider
+ *
+ * This function gets peer-to-peer DMA provider for a PCI device. The lifetime
+ * of the provider (and of course the MMIO) is bound to the lifetime of the
+ * driver. A driver calling this function must ensure that all references to the
+ * provider, and any DMA mappings created for any MMIO, are all cleaned up
+ * before the driver remove() completes.
+ *
+ * Since P2P is almost always shared with a second driver this means some system
+ * to notify, invalidate and revoke the MMIO's DMA must be in place to use this
+ * function. For example a revoke can be built using DMABUF.
+ */
+struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar)
+{
+	struct pci_p2pdma *p2p;
+
+	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
+		return NULL;
+
+	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (WARN_ON(!p2p))
+		/* Someone forgot to call to pcim_p2pdma_init() before */
+		return NULL;
+
+	return &p2p->mem[bar];
+}
+EXPORT_SYMBOL_GPL(pcim_p2pdma_provider);
+
+static int pci_p2pdma_setup_pool(struct pci_dev *pdev)
+{
+	struct pci_p2pdma *p2pdma;
+	int ret;
+
+	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (p2pdma->pool)
+		/* We already setup pools, do nothing, */
+		return 0;
+
+	p2pdma->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
+	if (!p2pdma->pool)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
+	if (ret)
 		goto out_pool_destroy;
 
-	rcu_assign_pointer(pdev->p2pdma, p2p);
 	return 0;
 
 out_pool_destroy:
-	gen_pool_destroy(p2p->pool);
-out:
-	devm_kfree(&pdev->dev, p2p);
-	return error;
+	gen_pool_destroy(p2pdma->pool);
+	p2pdma->pool = NULL;
+	return ret;
 }
 
 static void pci_p2pdma_unmap_mappings(void *data)
@@ -276,7 +356,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
 				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
@@ -295,6 +375,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			    u64 offset)
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap;
+	struct p2pdma_provider *mem;
 	struct dev_pagemap *pgmap;
 	struct pci_p2pdma *p2pdma;
 	void *addr;
@@ -312,11 +393,21 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (size + offset > pci_resource_len(pdev, bar))
 		return -EINVAL;
 
-	if (!pdev->p2pdma) {
-		error = pci_p2pdma_setup(pdev);
-		if (error)
-			return error;
-	}
+	error = pcim_p2pdma_init(pdev);
+	if (error)
+		return error;
+
+	error = pci_p2pdma_setup_pool(pdev);
+	if (error)
+		return error;
+
+	mem = pcim_p2pdma_provider(pdev, bar);
+	/*
+	 * We checked validity of BAR prior to call
+	 * to pcim_p2pdma_provider. It should never return NULL.
+	 */
+	if (WARN_ON(!mem))
+		return -EINVAL;
 
 	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
 	if (!p2p_pgmap)
@@ -328,9 +419,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-	p2p_pgmap->mem.owner = &pdev->dev;
-	p2p_pgmap->mem.bus_offset =
-		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
+	p2p_pgmap->mem = mem;
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -1007,11 +1096,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(page_pgmap(page));
 
-	if (state->mem == &p2p_pgmap->mem)
+	if (state->mem == p2p_pgmap->mem)
 		return;
 
-	state->mem = &p2p_pgmap->mem;
-	state->map = pci_p2pdma_map_type(&p2p_pgmap->mem, dev);
+	state->mem = p2p_pgmap->mem;
+	state->map = pci_p2pdma_map_type(p2p_pgmap->mem, dev);
 }
 
 /**
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 9516ef97b17a..15471252817b 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -27,6 +27,8 @@ struct p2pdma_provider {
 };
 
 #ifdef CONFIG_PCI_P2PDMA
+int pcim_p2pdma_init(struct pci_dev *pdev);
+struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		u64 offset);
 int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
@@ -44,6 +46,15 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
 #else /* CONFIG_PCI_P2PDMA */
+static inline int pcim_p2pdma_init(struct pci_dev *pdev)
+{
+	return -EOPNOTSUPP;
+}
+static inline struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev,
+							   int bar)
+{
+	return NULL;
+}
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
 {

-- 
2.51.1


