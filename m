Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A393C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B1B8E0009; Wed, 23 Jul 2025 09:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895248E0002; Wed, 23 Jul 2025 09:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB0E8E0009; Wed, 23 Jul 2025 09:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACD98E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 144215AA88
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:11 +0000 (UTC)
X-FDA: 83695542462.16.112065B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28522A000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bbL7PJy7;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q55ClcKlls29gTKh8r0TuuSubKOTcZ0SyCakyMo0dew=;
	b=MmcmWTllXXixIeq70HkEWL5z2piuGeeMiUWHfGKDpVpx0YAL9N1yupCHK7kziV64E/LJxz
	9z9zd5qz5TSe0e6uTdWwXeDIhY8BV8y/W89CkftJnawa1shAr24JeqroNf2mCkrIJKU46r
	GFnX6xUnAQbkEaFFaa25Ujn1Um+gLoo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bbL7PJy7;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275729; a=rsa-sha256;
	cv=none;
	b=MSlk3PdjCJ/fK15vavMwoZBH6c5mxYTdy0C+vC8FEEWxmkKAY2fGgWTxKt4fnpC1OE6FkH
	rsyWxyfTCjGUwQS/6AOkPzwfNPzryoZtqCSUVEPEcHUJ+WBg7m9WARBJ04eQUcaufbJjOT
	KGAdlwZXNjfounqY+4TQadaoHlj3IG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BFE462F3;
	Wed, 23 Jul 2025 13:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C6BC4CEE7;
	Wed, 23 Jul 2025 13:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275728;
	bh=QlCxMBTRZAiP5c3NMYNkdFJpkHArvyU+1xEwTfBZhP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbL7PJy7z/i/XYjufuxpMmeDaHyyR3daAHP5he1hjDMcrAag/gp4J2o2k/v8skMr3
	 R25bAkiEdPLj98TYfsFae7gsqoML6FEk3vEK6KtB7tf4gyjSQzojNS8lNOskp4bTx9
	 9Qoq8aK9CGCvELFh9o6r0NtfFvwpoxyIKNem5uT/B2PHJbhWSYi/smgEYkXOPUd31d
	 vxUdLB2JEvLdGfC2iA6AH0Y8RDM3aJ830005MyHWxiRE6KVxWhQzqrkgM1j6ZL9yGm
	 LYqSUfpT2Pb9LrpTlSakKBN8oyEUIMe/SmczIAeN5jjmtgOuY9bm7baIuqvXRLjOVA
	 s3xLDVtvj6HzA==
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
Subject: [PATCH 04/10] PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
Date: Wed, 23 Jul 2025 16:00:05 +0300
Message-ID: <fde513e6135516368fa873cdff9144c1b29a477f.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: maibik1jx577zsnfr64t7k5e6g3i9kfd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28522A000E
X-Rspam-User: 
X-HE-Tag: 1753275728-259454
X-HE-Meta: U2FsdGVkX19CmH0lwoEBpZQ2BOd6tEnsvjfvIJVLNsR2gsMY+MVkcWpT7O46whn6by4iISuTcq3gqtjAjtr1DtcJMPCu2S1Hdf72Ulucw3x9njSGhpqhxgoBg/7J1ApfLkbOJKuBNTN5l8RJelFu0v/22LJ58qKkKud+vj5kTe1ayZd02cKUu1aUIQJkMGzHj7dSVhHEjZ4YoVE7TglligtDDhC/htOL9YzqKPG3B0G7HgS8RYu4uUoDfRRZrnSkWwH0ctS+6+uA75d7guIyDhkROkD5Um8R2ZNmIOGkolI7e0zCdo3x6QaRRUG5/iJ2/N3PS0jU64n7dmO4yL9aG1B2ausRxgisN/BSW7cMAoyIpGLfirbBkFj40ek5ev5UFjm1LPE+2Jh9v0wCFAGnnjhXpRGOlSgUVEHVXNQekqaAvZo9LUA/+6bX7hRIi3dP9r4Gu3I/x4NdIUbRiob1OcJAeALIJa0URxTaHneAjC12YN00S1mAgc+q6DYex0Pz0ZKVpVkIUVSemRXNqdZjH/c2nE8OksO4cRGauq8Cb8IRo1D5llTg3MhzoVZg9jCVJJLVb0oNL8TNIzcZ9r6JdqQ8gk4dZbuhwsL6A70Rc2Ai6jNt5cf2Er1JsvJEAqWdTieW/KVcUe9eeTuxYascm7nnobBs3toyM6X46BIRwdNHSGwM2C+yAo4P4Zahk2VqPtfV4/GC7C6VJPz/w6RnSVgiFSjs3ZDB+aqbwUudR2Ye35VPKSIukC7hl3ltlUKYkeHwoAVYzhZFD6/I9Il79aUjbiPvqMIWeo3J+ndtFvOP5ar6zGdAtRrS7x3J+deBI2a00nu6D5I9iesG8ALrV8o4FSj1aWeMo6AhDY4TNwz1UTeIqBOpsPGlHa0i44ey+RV/O9ntyO+IbzYvw9ZnOnh+Ucff9UxhBRSxu7WYO0lWguJEZtRa5gmw+aZoF0yK3Z8iYUSt+MVnYOEEpNA
 Xmp/YYM5
 6AIcUWmjj/cgQPZGGYhVxLHCdyHl9vqXiiQInVIbRwZ4zsuXFUVXa/+fx/IkL/RWhmymdToabnZ0grwSdJaiJOLpxMWelfre0UFn34G8asTtzdzY+QRFTBmQS1wAQKDMsUPJ6TFUVtWjcgvsIbekOw3KFzdk1+CsWtx09akEtD5WySl+/Q331krkLvU3Vr9u0B1lU
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
 drivers/pci/p2pdma.c       | 108 +++++++++++++++++++++++++------------
 include/linux/pci-p2pdma.h |   5 ++
 2 files changed, 80 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 5a310026bd24f..8e2525618d922 100644
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
@@ -227,44 +228,77 @@ static void pci_p2pdma_release(void *data)
 
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
@@ -276,7 +310,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
 				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
@@ -295,6 +329,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			    u64 offset)
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap;
+	struct p2pdma_provider *mem;
 	struct dev_pagemap *pgmap;
 	struct pci_p2pdma *p2pdma;
 	void *addr;
@@ -312,15 +347,22 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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
 	}
 
 	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
-	if (!p2p_pgmap)
-		return -ENOMEM;
+	if (!p2p_pgmap) {
+		error = -ENOMEM;
+		goto free_pool;
+	}
 
 	pgmap = &p2p_pgmap->pgmap;
 	pgmap->range.start = pci_resource_start(pdev, bar) + offset;
@@ -328,9 +370,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-	p2p_pgmap->mem.owner = &pdev->dev;
-	p2p_pgmap->mem.bus_offset =
-		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
+	p2p_pgmap->mem = mem;
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -343,7 +383,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (error)
 		goto pages_free;
 
-	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
 	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
 			range_len(&pgmap->range), dev_to_node(&pdev->dev),
@@ -359,7 +398,10 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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
@@ -1008,11 +1050,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
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


