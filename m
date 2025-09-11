Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2378FCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856CE6B0012; Thu, 11 Sep 2025 07:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806F06B0022; Thu, 11 Sep 2025 07:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8326B0023; Thu, 11 Sep 2025 07:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58B286B0012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:33:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0650313AAB2
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:33:56 +0000 (UTC)
X-FDA: 83876760072.03.247D886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F0C61C000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:33:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XGE9VT7K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590434; a=rsa-sha256;
	cv=none;
	b=MggIYuuQVrvT5eYef629ke1uTH0/1husXAEQEGxkZW1nb8rlKYNxq0FWtyuEsUkuqePX+R
	cwQ+I3cL9SchlAZlDWwQPjvcIFzqDjLVEKypf3MzJLHsoW2FCwBlrCVj21oSR6gC7wIUvX
	k/7zeqdSCb62T8HcQZ3uWvih4M9Wc3g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XGE9VT7K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcmFXf9h6GfSx7xIfCE3Yvo8x4xD71rLjYCXx0dQnDA=;
	b=7BI9cMzxhiau+uDCtJNBgbmMTGbBAO6LHfzd19vSWCkUFlasWNGTCWsL0VRIYr5M3dqs6s
	lJAmNlux8o8fXA4lyfSPhGM9LV+u6ilAsKQI7Ll4LuMieDDRI5EmSRHo/8Shw1V60GPwkI
	5QGtmDMVXzFarVkxEXC3Cu3N1NWpmaM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E57660254;
	Thu, 11 Sep 2025 11:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96608C4CEF0;
	Thu, 11 Sep 2025 11:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590433;
	bh=/jWnckJcyHdF3R+tvIGXmaDkojDLmzwRv9Qj7ZAK2Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGE9VT7KJjAu2tRs6J1Zms4gR3Ujryz6sFXPRbUg1pZJCkSold7ED7XNZVQYxkyN7
	 KNhmVOvpQv/xZcDdU1sLYJ9bP6EjsRVu2S/zBqecECEehCEUxCzuyg5/7R3A2Intaj
	 ZECk3YarsNGSXJe8Kg4U985Ph453wRa+y0A2xI4f0KzXi43sTQUUT/e6Ea60wubMc9
	 VBbeDnZ98U0zsVtnV9tGCi2rMA3eTWtqevZCgWOpqKcEhN8Cn2YDcMtkcHveJ3KFGU
	 7blZktY5W10rpc+XFQXEDt5nnDWj9kH8s5Rw9LmZjtllc+u4rX6Jys6qxLfH8ZvgQ8
	 aaeEgANRUGKRw==
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
Subject: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
Date: Thu, 11 Sep 2025 14:33:07 +0300
Message-ID: <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F0C61C000E
X-Stat-Signature: eumcn8epjhshngdaru1bjzpof9p73yaw
X-Rspam-User: 
X-HE-Tag: 1757590434-340401
X-HE-Meta: U2FsdGVkX1/hX82/7c2iETOkLFnxe+9zrXoo7wqZ4qwBbxTT7vzmrqwl0M0+PlAGO/xts7rvu4UOi4cP8reIqgUGHw7pjABVgj4pPTDHmnCPjpcFGVIMF5O3UZ2AG6kcN7+GTKZ3T1T4MxwA97Pqtcz9Duh/JOg8Vkr1EgodP58VeuNOkIEx7gU+6uTTxNhQ+ZoYE+3EZnqyg1E2aICMkDqs+hAyleTaekZzJRpjGTj6zbVWCN9Cr6jZxG/mVFYtEvvBH3Sm8G6ez1NZx0XO3h0uKYoPFeJ7e2pOYk78o5+UaS8FcWgISzs9b3tLEpCz7Q6/VZiO4swD0GxNND21A2LY76lmYuyS+PxyxLOK00mBFLwSFYdTuAFIveO2VKR0HMEU7Ordnq+lWMzccnSL+2jvQCMRhnizaLv3aNjGOc/EQGnlLB3nXPElR3+J5SiuNJB8i+Ak8F6h8w/lY6NUsznTTYrssWY9TgaKHRLWLHyA2gq7Ad7ZFGzjH/winCSZiOPBQiBdrDd07rJ/ZxV1zWKg3rNZn7l4EyqjhJ/JKonDRKLKoxp6p+W+Ws2eJjzNFoPDAZycBdoQArP1fa41Day+Q7/558bORvz5lj45WrIozfvayBMbtDjvTh8LAa8NAEBwoaOjm17zsq6SQl5kL2ldcNuypM01ooPqR1W5XHwsI5rgXPfWzcNxseVJrucCdeez4X1fiUtYjxBo41vkTX0ubbemVRTzXEHnFdyfn4Qvl1QqiPCSt9In2zgandigwD8/eX/hSmlSdSXp2FI3+i1bamlCppjMVbdj0MyHiVSfNYT+xWFe79gUjd6lVftBHQHgyKVTs4a79cnd/ba1UMh0u3+MWvEZSBj5O58JV+cs+YwCfUe6/+SjsvlsfAH9SgLFgaF0IGfTbKHcdPIcbPLtPAHzuduxFeoqkAmG1iaZEa4hg8derkJXrywGIwh7V/brcpfjp6fw1PzJt5g
 W9Idvfgg
 Db1kFpXQeY5Txe9GsXCAEG+eF1ryjQK0Xay72A8rtT5azYojQP1NQKjA5E8GMD+e3oa08AMTFx0XkW8c0bA1XhEO9pV1z8mwUgA50CMgNrlOe5hJAeDqsy4WG/RKNphi78iyhnBgJ5/Aeuf1ZbbXNc292UlE21LRs3yuWuujlKY9J77bh43vJz+rCu4EoNxbSsEmkwOHboT06xHCdBWhhLL1yEBwuzELuwItzHBIGpZ7T120=
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
 drivers/pci/p2pdma.c       | 129 +++++++++++++++++++++++++++----------
 include/linux/pci-p2pdma.h |   5 ++
 2 files changed, 100 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 176a99232fdca..c22cbb3a26030 100644
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
@@ -227,44 +228,93 @@ static void pci_p2pdma_release(void *data)
 
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
+ * pcim_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
+ * @pdev: The PCI device to enable P2PDMA for
+ * @bar: BAR index to get provider
+ *
+ * This function initializes the peer-to-peer DMA infrastructure for a PCI
+ * device. It allocates and sets up the necessary data structures to support
+ * P2PDMA operations, including mapping type tracking.
+ */
+struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
 {
-	int error = -ENOMEM;
 	struct pci_p2pdma *p2p;
+	int i, ret;
+
+	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (p2p)
+		/* PCI device was "rebound" to the driver */
+		return &p2p->mem[bar];
 
 	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
 	if (!p2p)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
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
+	return &p2p->mem[bar];
+
+out_p2p:
+	devm_kfree(&pdev->dev, p2p);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(pcim_p2pdma_enable);
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
@@ -276,7 +326,7 @@ static void pci_p2pdma_unmap_mappings(void *data)
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem->owner->kobj,
 				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
@@ -295,6 +345,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			    u64 offset)
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap;
+	struct p2pdma_provider *mem;
 	struct dev_pagemap *pgmap;
 	struct pci_p2pdma *p2pdma;
 	void *addr;
@@ -312,15 +363,25 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (size + offset > pci_resource_len(pdev, bar))
 		return -EINVAL;
 
-	if (!pdev->p2pdma) {
-		error = pci_p2pdma_setup(pdev);
+	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (!p2pdma) {
+		mem = pcim_p2pdma_enable(pdev, bar);
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
+		mem = &p2pdma->mem[bar];
 
 	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
-	if (!p2p_pgmap)
-		return -ENOMEM;
+	if (!p2p_pgmap) {
+		error = -ENOMEM;
+		goto free_pool;
+	}
 
 	pgmap = &p2p_pgmap->pgmap;
 	pgmap->range.start = pci_resource_start(pdev, bar) + offset;
@@ -328,9 +389,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-	p2p_pgmap->mem.owner = &pdev->dev;
-	p2p_pgmap->mem.bus_offset =
-		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
+	p2p_pgmap->mem = mem;
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -343,7 +402,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (error)
 		goto pages_free;
 
-	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
 	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
 			range_len(&pgmap->range), dev_to_node(&pdev->dev),
@@ -359,7 +417,10 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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
@@ -1008,11 +1069,11 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
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
index eef96636c67e6..888ad7b0c54cf 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -27,6 +27,7 @@ struct p2pdma_provider {
 };
 
 #ifdef CONFIG_PCI_P2PDMA
+struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		u64 offset);
 int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
@@ -45,6 +46,10 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
 #else /* CONFIG_PCI_P2PDMA */
+static inline struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
 {
-- 
2.51.0


