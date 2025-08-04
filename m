Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD98C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F7C6B00C9; Mon,  4 Aug 2025 09:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619A36B00CA; Mon,  4 Aug 2025 09:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445526B00CB; Mon,  4 Aug 2025 09:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9E46B00C9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F398FC02FC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:21 +0000 (UTC)
X-FDA: 83739085962.08.27F71CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3EEBC140007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHmPkb2Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312480; a=rsa-sha256;
	cv=none;
	b=NrM1Fq2K06cJGVdr5d7Lo1TshhAuBSKJBZwGhO+qYbDnkgpRmh0ZnvO4mkpKlYbDct+GFs
	hSfr8+LnodqUchyP2fRc9vTK6gFGPm8LsJ2BNPexZKUj5wnTUiPDYYDjVW8eCFGSiZGLj9
	uCD9V2X+tXK1ZGFPEMKgZhYoRszE0WA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHmPkb2Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PAu5PMZ2Wj4O2P9fJeMbw64RuWf3c6OGltriBaEARA=;
	b=EuS2rP6Kvs5ynMi1ACaAs+SX7HflJgL/6u+d6W2kaCY42kvNVtzLKfh0c3/58bd1/TcgqM
	BgloR6Xe8+Wn9+7fBlkz+tDQyzMDSgTt7BX0dUT4APfRu6QKE9dl3q2IZ9UCTI6yIdA40i
	Jl2ioYE5uK9U1r5egYhA3V2djTx2HcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EF2F45B8C;
	Mon,  4 Aug 2025 13:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D208C113CF;
	Mon,  4 Aug 2025 13:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312479;
	bh=shbFCrguQ+Q62Ap9hJLmw0h65suWHRyjEkM0F3UHxeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHmPkb2ZICu7msk3ndQanlf7QcWUOtGgBVP0pneUrz1+uplUFzu5/35hMyi5h/09M
	 lsE8QZMnzav84z3yLwgxwEgIhJYZxt1EH6Yq3J6RG588PreH8ElFqe+t8wGupxx5+s
	 i8/zWRs5Mvgsm2z98ra6oEp2T29Df+SkribQsO9eFg+aD28XQp5BuCePYxiB9p1Vqp
	 HXWMYF6w6FniFFbTwkxOCnKyuWbwCumpteZi/5QGoMoLxP1kbAFszBnv/1EjpZOYP5
	 xbr5cBN0XKEghu8pVfuo6ZVqoPAmOLycgu9CUAk7VkJkgaXHsRKJ81JVRqOd+oS5Lj
	 u98Wc4xdYV8yA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 04/10] PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
Date: Mon,  4 Aug 2025 16:00:39 +0300
Message-ID: <cab5f1bfd64becafcc887107bb4386f2c8630ef3.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3EEBC140007
X-Stat-Signature: 83ea4seqt3k8q4zco6oi757h6rdarbk3
X-HE-Tag: 1754312480-841952
X-HE-Meta: U2FsdGVkX1/MxwDv6jgs8OosCQY9vI8OqhBQTDRac1ZqVbM3ZPqgXUs5pMJ2/fwKZ5e3lA85K/rQ+meZa6uBW1ESvVKVgbzGJgenKLJIEYpHXG1WJxGdtUV+c64EqgY4ZaB8l+1+m3IhUxhZeOoiv3Ja/WxmOeJhwmbYoPSMh1TjgH7Wdt0ppTNN78M0an7Zz3+KHCoAMsROyvv8yrajyRUr0XgnZ0LN8E3713LkWIBHqGwdcyhRH92bwftCm5n+r+ZGgJUY5yOz0FZ1PvHFQ7uHavPGzMWq+5QjfAJ40wxQCRFzdkdA8TurnY2AnK6rH3uC4hA1EIbb/zNoLortwexIlLcPP3gwKs9GBShIvJxOMzKw4IhIrH6fBZBPy34SaOFk8Ae6fV4yUNKwOHMN9LEHmLrGfrGU57F3jLCR7PwKKtWNB7rtObN/NhRwyzXlX5NMAmWHvDnr5CT4cYwRdNk4Xi/LtDhmilD9JC0jLWAY4Yj2mUo9b9Huu64WCjEJ7AjBBCz8hFnIgxAPPBl9CGZaIoFoR9HsGW+2ejsDVeA1zbb3+gdXy/CXxtbaqzYCstYy6Qu3DzYbbqSApKkaDgghA/EQnlyRz76duw4Ty10sVBCqLNGQkKX7XkPdYPf2NkGA5Q/a/5+tB1hQfDnWjdUPwkRi+96yGltHEeF8ALMZW7pzQEWAmH3sTHfj60d4atyJC/ikAOPzU23uFjvocgaFe3N7LWlpFCmvL7CtTROMTHAIRXgk2Mo0wjkr64r5FBSd6tMxLxhR7ETz6eFkp+0oM9+gDIdB6XckAWpGefPQVxfY5eS5gIx9I8JQ81Njk946VvlroqzRd8cDiUfLrdrZPiH7B1FVvRs1eFjYewGTPJL1krgrF1h+53cFxzsRzngcMkWPBAOF6XhQXxs1WC3B9GqiPGYObXLYxZn58boHC2rLWISSeOWgUXOTgKmZYDJSiHIIk8eSv914A3C
 41ATTPVh
 dHmg1PtrlWZxX5k6hkD3+1RSm6PSe8fCKU+2uRpsEDmE31y3Pni7bcO761cQ4YfiRrfA9X71IGUBG6Xgaheh41b9KU7rcukXa2uUwd+9HvrjauJNiEz0Arz53xCcHn8UHV4lyzh59zdM+nWPec0H7PCzHzDELRNDk77Fnu1sAi7bGTN9o+3HK5/j9uxBDxL40yXbmFnngOWdPoC7rW/BpFeVdFzXXm08B2NkvRQFhZ1fiYTE=
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

This separation allows subsystems like VFIO to use only the core P2P
mapping functionality without the overhead of memory allocation features
they don't need. The core functionality is now available through the
new pci_p2pdma_enable() function that returns a p2pdma_provider
structure.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 118 ++++++++++++++++++++++++++-----------
 include/linux/pci-p2pdma.h |   5 ++
 2 files changed, 89 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 176a99232fdca..24a6c8ff88520 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -25,11 +25,12 @@ struct pci_p2pdma {
 	struct gen_pool *pool;
 	bool p2pmem_published;
 	struct xarray map_types;
+	struct p2pdma_provider mem;
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
@@ -227,44 +228,82 @@ static void pci_p2pdma_release(void *data)
 
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
+ * pci_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
+ * @pdev: The PCI device to enable P2PDMA for
+ *
+ * This function initializes the peer-to-peer DMA infrastructure for a PCI
+ * device. It allocates and sets up the necessary data structures to support
+ * P2PDMA operations, including mapping type tracking.
+ */
+struct p2pdma_provider *pci_p2pdma_enable(struct pci_dev *pdev)
 {
-	int error = -ENOMEM;
 	struct pci_p2pdma *p2p;
+	int ret;
+
+	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (p2p)
+		/* PCI device was "rebound" to the driver */
+		return &p2p->mem;
 
 	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
 	if (!p2p)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	xa_init(&p2p->map_types);
+	p2p->mem.owner = &pdev->dev;
+	/* On all p2p platforms bus_offset is the same for all BARs */
+	p2p->mem.bus_offset =
+		pci_bus_address(pdev, 0) - pci_resource_start(pdev, 0);
 
-	p2p->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
-	if (!p2p->pool)
-		goto out;
+	ret = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
+	if (ret)
+		goto out_p2p;
 
-	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
-	if (error)
-		goto out_pool_destroy;
+	rcu_assign_pointer(pdev->p2pdma, p2p);
+	return &p2p->mem;
 
-	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
-	if (error)
+out_p2p:
+	devm_kfree(&pdev->dev, p2p);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_enable);
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
@@ -276,7 +315,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
 				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
@@ -295,6 +334,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			    u64 offset)
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap;
+	struct p2pdma_provider *mem;
 	struct dev_pagemap *pgmap;
 	struct pci_p2pdma *p2pdma;
 	void *addr;
@@ -312,15 +352,25 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (size + offset > pci_resource_len(pdev, bar))
 		return -EINVAL;
 
-	if (!pdev->p2pdma) {
-		error = pci_p2pdma_setup(pdev);
+	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (!p2pdma) {
+		mem = pci_p2pdma_enable(pdev);
+		if (IS_ERR(mem))
+			return PTR_ERR(mem);
+
+		error = pci_p2pdma_setup_pool(pdev);
 		if (error)
 			return error;
-	}
+
+		p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
+	} else
+		mem = &p2pdma->mem;
 
 	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
-	if (!p2p_pgmap)
-		return -ENOMEM;
+	if (!p2p_pgmap) {
+		error = -ENOMEM;
+		goto free_pool;
+	}
 
 	pgmap = &p2p_pgmap->pgmap;
 	pgmap->range.start = pci_resource_start(pdev, bar) + offset;
@@ -328,9 +378,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-	p2p_pgmap->mem.owner = &pdev->dev;
-	p2p_pgmap->mem.bus_offset =
-		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
+	p2p_pgmap->mem = mem;
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -343,7 +391,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (error)
 		goto pages_free;
 
-	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
 	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
 			range_len(&pgmap->range), dev_to_node(&pdev->dev),
@@ -359,7 +406,10 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 pages_free:
 	devm_memunmap_pages(&pdev->dev, pgmap);
 pgmap_free:
-	devm_kfree(&pdev->dev, pgmap);
+	devm_kfree(&pdev->dev, p2p_pgmap);
+free_pool:
+	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
+	gen_pool_destroy(p2pdma->pool);
 	return error;
 }
 EXPORT_SYMBOL_GPL(pci_p2pdma_add_resource);
@@ -1008,11 +1058,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
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
index eef96636c67e6..83f11dc8659a7 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -27,6 +27,7 @@ struct p2pdma_provider {
 };
 
 #ifdef CONFIG_PCI_P2PDMA
+struct p2pdma_provider *pci_p2pdma_enable(struct pci_dev *pdev);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		u64 offset);
 int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
@@ -45,6 +46,10 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
 #else /* CONFIG_PCI_P2PDMA */
+static inline struct p2pdma_provider *pci_p2pdma_enable(struct pci_dev *pdev)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
 {
-- 
2.50.1


