Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1B1CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3907F8E0055; Mon, 13 Oct 2025 11:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3408A8E004E; Mon, 13 Oct 2025 11:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230308E0055; Mon, 13 Oct 2025 11:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09A538E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB3C0C0521
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:38 +0000 (UTC)
X-FDA: 83993468076.22.348B1E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DA6BE40009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iCIQ5NhB;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5GAktWj4xEvj7JLKHpZ6uqQpJlC2IBSkABo4CTmsys=;
	b=5AQhoEGnTPIju0nkMrRKjvZoNfOhD+Mp2GVkD+87LjYXFVLDXpFd+H3EUmdmLtuTDcLQL+
	kNXOV4HApJKu9YZhs20Vqaq0d2lwI5GDcj/udKtdRcP4dnoQ69b+lrOPdA8FtlW7FY4yW0
	saOlJf77Eo7Fvm+9u9dKDyXTe3V1OGg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iCIQ5NhB;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369197; a=rsa-sha256;
	cv=none;
	b=mR2Dud9o1J9S4mNf4seJY3UT3agfQZVmr1IGxxC5cZFAavebjKZAwN1Elpabg3BUX8Bpcd
	Ah5ZfPRB/CYz6KdXyRppELOtQ9fU4KSJyDmv/p4rbp2sH6oWk/uwWIZtRuYZKzyT2UEy2Z
	mClG282loGUNcK/oVyWRI+B3GDMpoYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D933948B12;
	Mon, 13 Oct 2025 15:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ED1C116D0;
	Mon, 13 Oct 2025 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369195;
	bh=6NoVxYftLZstefmDxvzrUyEsZC9PZbNrNzxWAJ3vKls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCIQ5NhBE+0cj53UURQt50Hyq8ha7j+RaOsIuiLFLxdUhB+ZCvh45w4N6/kXrQImf
	 aqEWGtSCjJk72TOhjvNi1PBHXPPTuG1zbMfL3iehSDiCar5Q6gVlnpKtbDwFSeVNRg
	 BWvFkNT5Gg3xgNBv/4AiFRgsgLbmrK9C5TRaesoA/1dMH3j0kzjfiA65/2vVZqbOQ4
	 pdfZNbmUiAvIRVWPyEh+Man6lIwJVTxcAP52QuHjDOOWgARYhll02zpznrMYoqwVQi
	 J81HKut4zCdEnmOTX7HDnKVzSqUei+ZcwrTRS9GcIx/ScwqrtAFUbe+xQHDQA6fqnd
	 /O70GJvDuLRpA==
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
Subject: [PATCH v5 3/9] PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
Date: Mon, 13 Oct 2025 18:26:05 +0300
Message-ID: <34ce2eef91d0adfd984b9db7c9b074e24384b356.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA6BE40009
X-Stat-Signature: 69kmewwz9gdze6nxktb7mq6boypr6iuw
X-Rspam-User: 
X-HE-Tag: 1760369196-653530
X-HE-Meta: U2FsdGVkX1/HzcWrHvjVC2bhIW4K1LkXzzdPu+/fqycBJXD8Ncm7Y/CAL23BF9osSTcH9r24gc75MVvTuXigpsIbbaRhC+tM3i2d+2P+/+0l2BlyuVAUMuJUI7JjfGYBPZ8o5E8yZVCwAWWfhq2k5DU78yT9FLcoi6MnC/SwFb7Av7DyyNeoLDk+8lKLSAZhlxQPYPJhONzqeYtdJPdxodokFVwX4T9yUNb2MhNbCjtxmThy2wRFbamrs7Wo4yattmC4r0qrQLo0Q+r1gCPpzdfDvNz/DObnadBS8Y7Jv3c4lnoxNlhkMpoQ1/Dme6tm3ift2dLl8CosZrmDk6R0EMP6Mkv+D9N67ArnQjDeKLBIR7Gml/jfbrlhovXryqbNebfhDb7djP0yYA38X4GsAVl7/lk1klRN7T7ym1OOZcljhRr8BOdEFT2RPDgEVu4N7CkzwzoPFFgHwSyPfEjC8A+Sio34UQZC0tYgaO2fAwNGKwHhHnQEGx8NsmK6oqXngm+6zJHXhCD3MVI7AdU2J933mhOMnMcRVD0LAgcDhKBeZMPhS8rRgqWgcqaseAuOXsxTeyjQuGss1CzQbwWPcErUODusnm0Udxzs6NtW6FHpHyqCUAstl/zZuuy2dJbjzphOgyYuYUL4pf98UAL5RKWL3Rn7lDH9hOSLTmnDEgVk9vZwp6B69QgAOgkiWfC4VA10+DW3KBoTfZWSUufJ8y2V33TDRVrgDwX7qAphTAraoeA7g/6XgPkGhMgzueHLKng3EUyMnVljcHmQkbGnj/t3R2lCrLtoSDMp00Csys/7EYIXYY2GZ6OB/m/zUl400LyrQTs8ETskpCjWhcMAduHQIb5QcUlctoXlvDDYxM6XYZ1GqDvgWaIDwr9QjBhk8CQ0R+Pz2mxfmPfN5yl4b30WnZJ/EkjxoW/TWIuzqQq8/dfqwlKEFLDYe0nKUrJyKLv11Wjpp4vrc/f1FH8
 CEuGNSYN
 TTGygZ43fZSsCid8Pr5wcj1lFNqkQUowFhj4U5NzYt+zP82NpuW2lJFvrAU31bQetPwhykNGsd5Rm4Ym/Hai/aMusyXtr7r4NPU7OhJavYfdKKSzubcV7xyxjRYX2o+t9SyEZVHoyFh64ZOM/CIP/4F3AF4WCP8hWN2qeCY7g8dtldkGQnkVP5xBLd8HbC9EJ6iC4+Y+85tCzDkYDrL3oIdZNvhXejhwrvBThaRYvi3eJHeU=
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
new pcim_p2pdma_provider() function that returns a p2pdma_provider
structure.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 139 ++++++++++++++++++++++++++++---------
 include/linux/pci-p2pdma.h |  11 +++
 2 files changed, 119 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 59cd6fb40e83..a2ec7e93fd71 100644
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
@@ -227,44 +228,111 @@ static void pci_p2pdma_release(void *data)
 
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
+ * This function gets peer-to-peer DMA provider for a PCI device.
+ */
+struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar)
+{
+	struct pci_p2pdma *p2p;
+
+	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
+		return NULL;
+
+	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
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
@@ -276,7 +344,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
 				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
@@ -295,6 +363,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			    u64 offset)
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap;
+	struct p2pdma_provider *mem;
 	struct dev_pagemap *pgmap;
 	struct pci_p2pdma *p2pdma;
 	void *addr;
@@ -312,11 +381,21 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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
@@ -328,9 +407,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-	p2p_pgmap->mem.owner = &pdev->dev;
-	p2p_pgmap->mem.bus_offset =
-		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
+	p2p_pgmap->mem = mem;
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -1007,11 +1084,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
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
index 9516ef97b17a..e307c9380d46 100644
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
+	return ERR_PTR(-EOPNOTSUPP);
+}
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
 {
-- 
2.51.0


