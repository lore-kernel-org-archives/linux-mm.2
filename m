Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07410D637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E0B6B0095; Fri, 19 Dec 2025 23:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BC26B00A1; Fri, 19 Dec 2025 23:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E156B00A2; Fri, 19 Dec 2025 23:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB126B0095
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E8A58D1E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:14 +0000 (UTC)
X-FDA: 84238537068.02.AF86E93
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A0CC100002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf05.hostedemail.com: domain of houtao@huaweicloud.com has no SPF policy when checking 45.249.212.56) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204173; a=rsa-sha256;
	cv=none;
	b=D3SQur8lzWtTTohIhce2uoFPjBWqwpF1bsOfZ4YhlkrbFHNwEnU6bIWIBPDNX00o0+uiBf
	2EUAQ9HTHO5IsIrHXOfTRu5VCHUcUkFmzRBFDYPR2GxVX7G68WKi0G17sx9mkVjkGUjEhI
	7AFlW5p0eGqfEvc/cvb0dS+wptAXKUs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf05.hostedemail.com: domain of houtao@huaweicloud.com has no SPF policy when checking 45.249.212.56) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iv02JVtTm+5bdGdvF+X+TuDnCI8bgF2XLDD8jYRkz/M=;
	b=iWjvP3FsCP3zAQae2+O0PLtkvVTUNvr25NGzsCOIhryjjAy3BMqA0S/N6EYOzIqfIokiNv
	JFIh4xfuPcXWiUCWaFOFm4QMEbcNP7bIWDkIC3lMn0pnCtUAh6XRuNGCDKmcK9O1aCPrEq
	gWtUWWJJWPuX6SD4zVWbkx5OzoqeaNU=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dYB0V0CmYzKHM0f
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 32B1F4058D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S10;
	Sat, 20 Dec 2025 12:16:07 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: [PATCH 06/13] PCI/P2PDMA: add align parameter for pci_p2pdma_add_resource()
Date: Sat, 20 Dec 2025 12:04:39 +0800
Message-Id: <20251220040446.274991-7-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S10
X-Coremail-Antispam: 1UD129KBjvJXoWxtryrCF4xXw1kZrW3GFy5CFg_yoW7uF45pF
	yrA3WDGrW8Ka17J34UJa1DAF1Fvwnag34IkrW7Cws3Za43trs5tF1UCFyjkF1fGrWkC3W5
	tFWjyr1ruw1UJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
	kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
	v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
	pf9x07j4fO7UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A0CC100002
X-Rspamd-Server: rspam10
X-Stat-Signature: 8qtt16xpx353kk83qs9oram6djockmxt
X-HE-Tag: 1766204171-96069
X-HE-Meta: U2FsdGVkX1+EklYY6td43th6lYFAPYQiNSFE/52/I628nqNOUTNMS4GuC/avCKO4f6LtNk2vb3KOxuEq32l61NZFq3oFOyqG9Z2qWqTqj5o43UD56jwmimw34U2ECb0Teb7g0yXB2I5FU9zX+IVsZRikhGXwrcmbZFUtPM7M5Xgl+5y8oXyymOeeJK4ZegMkXmRgv27ldSXUolPTbro29OnzlrqCbu0Y8+F/ecKoJMJCGnHvB4uHOj6HomMRHFFaBqgdmTwdpo2byB/bY0w8ZrU3CTndN8H/Ocmt+kDrR/8S2piH/O5XkstiiZawmf5YCl7txPF8V4/SJrZJpNjANYwRRYrGUQbfemyUFf6QxhY3g+6hgsaXsmnUmcnjA7RD2q22ViYseFJE3TYlMPH1sScMHXGOgjnGDmT3zX8altZxHEeasoYbfX+EaAKQT3IdYLXF4QqPHiGB+9fU/kuPvSPv7W94cCWts953JB34LvjyBgTCP1wzvVg0wWQOPOIJdhKwpgKaBjStahXkzAoBpLbvapfBpx+47BoHjYUbuEmWUiiWCQwetzleZBhj17K6UXxLnNC6m8jcyLib0WEiCm8/dGpparq7eUHbPYyCxsYvRE6s9RGlXzFqfvAr9uYuzVO4hJv8wWIRxXO1BrPCq1NufBsP8KUwNxI63tp5SFp1mGKu93hpWotUgzwEetnUNxpOVkRRk9MuDLFcjCvaCkSh1iCjUoXfk/kjkpn/J63INYqJ1NbbFM02V9eTA/W2NGbYk+BP7062qiCaaxnj49k4oFs//SGd2AfWjRL3fY7KgZkR8urGnQIU0DaAoQCY1yoRaRp9bMJXqiNGuFA1xc3XY+KlDoxKjl7POaujhkRG9XMGsBPUm/poQFYZLZ8C8686KZHy9ANaFXigx3xhiPxrYAw1G1ey5hroohsdoVY8zQH37fjs7iDdkpWjEhMIzlThVPovUhhqLfw8YUv
 aKnH35tN
 wbMVpc4rWYUg3wGYG7/QbfgEVGuj5TxmrcxIzWwCLT0JSCJuq01c2V/qkuqezOXyz8XJ8gwlEEI6GHu4ukRxCZVE0pp4mIyj+ingj4KRSbJUVYVzneJPkQ62zBYU6nBKsqElgE8jG3Z5+z5Rvk06P5iZ/Hgvy0FHRW8+0ngAJWiQiIBECMOGjTq+eu5mnvh1w91ChYE56bQInXr+cV3M7qdaII7tBZrPzNQ0RlFx1VoJkWfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

The align parameter is used to align both the mapping of p2p dma memory
and to enable the compound page for p2p dma memory in the kernel and in
the userspace.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/accel/habanalabs/common/hldio.c |  3 +-
 drivers/nvme/host/pci.c                 |  2 +-
 drivers/pci/p2pdma.c                    | 38 +++++++++++++++++++++----
 include/linux/pci-p2pdma.h              |  4 +--
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/accel/habanalabs/common/hldio.c b/drivers/accel/habanalabs/common/hldio.c
index 083ae5610875..4d1528dbde9f 100644
--- a/drivers/accel/habanalabs/common/hldio.c
+++ b/drivers/accel/habanalabs/common/hldio.c
@@ -372,7 +372,8 @@ int hl_p2p_region_init(struct hl_device *hdev, struct hl_p2p_region *p2pr)
 	int rc, i;
 
 	/* Start by publishing our p2p memory */
-	rc = pci_p2pdma_add_resource(hdev->pdev, p2pr->bar, p2pr->size, p2pr->bar_offset);
+	rc = pci_p2pdma_add_resource(hdev->pdev, p2pr->bar, p2pr->size, PAGE_SIZE,
+				     p2pr->bar_offset);
 	if (rc) {
 		dev_err(hdev->dev, "error adding p2p resource: %d\n", rc);
 		goto err;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0e4caeab739c..b070095bae5e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2309,7 +2309,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 			     dev->bar + NVME_REG_CMBMSC);
 	}
 
-	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
+	if (pci_p2pdma_add_resource(pdev, bar, size, PAGE_SIZE, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
 		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index dd64ec830fdd..70482e240304 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -23,6 +23,7 @@
 
 struct pci_p2pdma {
 	struct gen_pool *pool;
+	size_t align;
 	bool p2pmem_published;
 	struct xarray map_types;
 	struct p2pdma_provider mem[PCI_STD_NUM_BARS];
@@ -211,7 +212,7 @@ static void p2pdma_folio_free(struct folio *folio)
 	struct percpu_ref *ref;
 
 	gen_pool_free_owner(p2pdma->pool, (uintptr_t)page_to_virt(page),
-			    PAGE_SIZE, (void **)&ref);
+			    p2pdma->align, (void **)&ref);
 	percpu_ref_put(ref);
 }
 
@@ -323,17 +324,22 @@ struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar)
 }
 EXPORT_SYMBOL_GPL(pcim_p2pdma_provider);
 
-static int pci_p2pdma_setup_pool(struct pci_dev *pdev)
+static int pci_p2pdma_setup_pool(struct pci_dev *pdev, size_t align)
 {
 	struct pci_p2pdma *p2pdma;
 	int ret;
 
 	p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
-	if (p2pdma->pool)
+	if (p2pdma->pool) {
+		/* Two p2pdma BARs with different alignment ? */
+		if (p2pdma->align != align)
+			return -EINVAL;
 		/* We already setup pools, do nothing, */
 		return 0;
+	}
 
-	p2pdma->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
+	p2pdma->align = align;
+	p2pdma->pool = gen_pool_create(ilog2(p2pdma->align), dev_to_node(&pdev->dev));
 	if (!p2pdma->pool)
 		return -ENOMEM;
 
@@ -363,18 +369,31 @@ static void pci_p2pdma_unmap_mappings(void *data)
 				     p2pmem_group.name);
 }
 
+static inline int pci_p2pdma_check_pagemap_align(struct pci_dev *pdev, int bar,
+						 u64 size, size_t align,
+						 u64 offset)
+{
+	if (align == PAGE_SIZE)
+		return 0;
+	return -EINVAL;
+}
+
 /**
  * pci_p2pdma_add_resource - add memory for use as p2p memory
  * @pdev: the device to add the memory to
  * @bar: PCI BAR to add
  * @size: size of the memory to add, may be zero to use the whole BAR
+ * @align: dev memory mapping alignment of the memory to add. It is used
+ * to optimize the mappings both in userspace and kernel space when
+ * transparent huge page is supported. The possible values are
+ * PAGE_SIZE, PMD_SIZE, and PUD_SIZE.
  * @offset: offset into the PCI BAR
  *
  * The memory will be given ZONE_DEVICE struct pages so that it may
  * be used with any DMA request.
  */
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
-			    u64 offset)
+			    size_t align, u64 offset)
 {
 	struct pci_p2pdma_pagemap *p2p_pgmap;
 	struct p2pdma_provider *mem;
@@ -395,11 +414,18 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	if (size + offset > pci_resource_len(pdev, bar))
 		return -EINVAL;
 
+	error = pci_p2pdma_check_pagemap_align(pdev, bar, size, align, offset);
+	if (error) {
+		pci_info_ratelimited(pdev, "invalid align 0x%zx for bar %d\n",
+				     align, bar);
+		return error;
+	}
+
 	error = pcim_p2pdma_init(pdev);
 	if (error)
 		return error;
 
-	error = pci_p2pdma_setup_pool(pdev);
+	error = pci_p2pdma_setup_pool(pdev, align);
 	if (error)
 		return error;
 
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 517e121d2598..2fa671274c45 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -69,7 +69,7 @@ enum pci_p2pdma_map_type {
 int pcim_p2pdma_init(struct pci_dev *pdev);
 struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
-		u64 offset);
+			    size_t align, u64 offset);
 int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			     int num_clients, bool verbose);
 struct pci_dev *pci_p2pmem_find_many(struct device **clients, int num_clients);
@@ -97,7 +97,7 @@ static inline struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev,
 	return NULL;
 }
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
-		size_t size, u64 offset)
+		size_t size, size_t align, u64 offset)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.29.2


