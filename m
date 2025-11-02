Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36354CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937C38E0008; Sun,  2 Nov 2025 03:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90EFE8E0002; Sun,  2 Nov 2025 03:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825918E0008; Sun,  2 Nov 2025 03:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 724A08E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:01:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DA55140877
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:24 +0000 (UTC)
X-FDA: 84064922088.03.2E79779
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 570CD4000F
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuflBfKf;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762070482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVHNehZdaXcLSJq5++smFyi2z7z291xWFmW+xHDxQXM=;
	b=g97Gh6H+mJYUy8uRKgm3r7dz0O9OFu9eanRXP3OIr0QpaRnSxkHegB0OSTd1Q53WTUj0P9
	XwnMXsKqrkwGB0iqJKJLtiKWui90Gc7XUyDUPrBY+l9aTVKkt8w8f3qfqRoDe8da0ioYvM
	Nhx6f4RaQwg0flR+f1T17dz1CUcyVPg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuflBfKf;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762070482; a=rsa-sha256;
	cv=none;
	b=O5NEjeFvcZFqMzoTfgZlQUN6ukhZO6I7De95TlTjN6TVS/hpkchzTFuJmCYJS50dFihdFK
	1hncTmHHMSulNxuZ7rULT4neL+IJwpZcJhqTe01RV9/zyT092o3TRYFGY7JVjT9Td+13P2
	F9+4d3eosw35EaWydzMbGo0wu8c6jyI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFCD7601D7;
	Sun,  2 Nov 2025 08:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F8FC4CEF7;
	Sun,  2 Nov 2025 08:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070481;
	bh=kcDi7wbq7v4M+6lRfPK9oLbWHSPVHLGSC2rkT6RBtbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuflBfKfctUuOG+NWT6M6nVTVw9JGYW/wzQdxxaVy61+uKcERkbuv6HbDVEY4rTAP
	 lmkNyWtWGZluIvxofKqDA0rT/Y63+QoPHukIA3r+TKERU2+890H0/5gGzR1iYu6CH5
	 bFv4A7b/+bGs2hlTzoKHyARRLuAq50jeMENoLeiD0Q5zBzXu8ETdSD4vqiUD4ZbTXz
	 T2sNExKAH4Q7CS0t/CYERqdMvCxU8Cwy/5/VXRZwGet9mAo1t9nj2uaRbDzmrG6Rpj
	 EziubJMCi35AFPVJFJFjJ0LcbDJedAczJD6LiH5Sqbiw6+zF6Tt3n3yw6zV0ie1Nba
	 l72KtMqlrd82A==
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
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
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
	linux-hardening@vger.kernel.org
Subject: [PATCH v6 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
Date: Sun,  2 Nov 2025 10:00:52 +0200
Message-ID: <20251102-dmabuf-vfio-v6-4-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 570CD4000F
X-Stat-Signature: yipguhfo9rz5k63t3t9cut8cic581qpn
X-Rspam-User: 
X-HE-Tag: 1762070482-752845
X-HE-Meta: U2FsdGVkX18u7nb7aUyZSbFXf9GUo9c4JMJxkDcMKMihpE9K4oU99iNL48rfeat/f1RRh4DTNuH/CwZHee2iRFOkXuU2fnNY0n68LacUhn3USwLlQbGlalJBwLlaLtwuGsqiu4AA/gBdd69tpNwReB82uSM1bcIFW/KNQ3C2u5Z+bUcbXHM3qx+ios86+0lnze2J6hEmP0GG9J12LGoorOgyChO1g+7lYaaLD8G53D51cr3lejVZLzTepWWicXczs0Wyf9O/mzEY1m3GLmG9lWUw2w9tCP/uqL0/uhIvipTsnDcBiLFQzmz6M5LqHIaD3UOzUGYs+56dKTn1F+a34KAkjtHsPkIfZqBcy5dOdQWFnM97VNFirXzuViRWZ3OcfEKkCODejm6GYTxssdIwQ+jayn6n+iYz1iwJLm3JF++0ReyxJm7bmEvHPY2pIHXhh9qP27Dwmq400D5mmnrcK14xeuAoMcAvPH+IjMDrG2GsyaqYj+84nHg2FJXKkkmT3ewUPcp0KsWwTviAsraiCpMpl+qo8h+Rm9kyz2smldU0WC4manW4kNJJ4F1e/50/UHGpzVfhTytd9K1SwqGvryk8+WScfsYJidyaS4nd/fr8Zex5GhKU8cfUqKKJ99+wuaXwD2PhzYFhdvW5kvQXDOad9gBiq6rdqWaC+7gQqvpk2gyr40BL93jwIaIDK0uGxlbK095vx5zlpOAn4rQgenPtfjBXdN8BMajJkdnKbarHCh6hvDhsWcMzvYOwm41ZHQdKOBwKXW0KMlIhZDTqyUkZ47TJ3aGnqWOCc1sE9gat850voFnDs/TJ5xUp3BbwJjFAtzAWBVXORYW4IadWZXr7JKX3dBK2i3sDjnJgZbnKyJN0LU6TN3q4Wgmnv9FQmolABGXZZMg2akD52TcThNJckVS/c6PkAkXrm9vNA0PBd1Fp+urBWapv56o1/AHLyixD10HiVtbWVmxFPBl
 pKfWfJQM
 rClCMZx0XpgG5OxKKe03o2Ly9t1k3R+3zflFyemfQcO05JkPqMrUR6Q1FltKgyT7IQbEukp1HtVNWboRWaJYXusB3hCNdupCbPvvwtAlI0FFhqY3xGZEYmIBQ52Wyzxs4oLT4w0VuOprNC9OiEunXxgMhylwRt8KTbL4U+WMgHy4jAP1Vyoy0dEFwGB9xaFyxCERWVmU9ii5pmGtsjLDbcadiV/XGUTkwQnbkoKVb5FSWqVADsOkhNf9rYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Provide an access to pci_p2pdma_map_type() function to allow subsystems
to determine the appropriate mapping type for P2PDMA transfers between
a provider and target device.

The pci_p2pdma_map_type() function is the core P2P layer version of
the existing public, but struct page focused, pci_p2pdma_state()
function. It returns the same result. It is required to use the p2p
subsystem from drivers that don't use the struct page layer.

Like __pci_p2pdma_update_state() it is not an exported function. The
idea is that only subsystem code will implement mapping helpers for
taking in phys_addr_t lists, this is deliberately not made accessible
to every driver to prevent abuse.

Following patches will use this function to implement a shared DMA
mapping helper for DMABUF.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 14 ++++++--
 include/linux/pci-p2pdma.h | 85 +++++++++++++++++++++++++---------------------
 2 files changed, 58 insertions(+), 41 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 664ea3272d73..11526e3c83fc 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1056,8 +1056,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 
-static enum pci_p2pdma_map_type
-pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
+/**
+ * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
+ * @provider: P2PDMA provider structure
+ * @dev: Target device for the transfer
+ *
+ * Determines how peer-to-peer DMA transfers should be mapped between
+ * the provider and the target device. The mapping type indicates whether
+ * the transfer can be done directly through PCI switches or must go
+ * through the host bridge.
+ */
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev)
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	struct pci_dev *pdev = to_pci_dev(provider->owner);
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index e307c9380d46..1e499a8e0099 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -26,6 +26,45 @@ struct p2pdma_provider {
 	u64 bus_offset;
 };
 
+enum pci_p2pdma_map_type {
+	/*
+	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally as an initial state before
+	 * the mapping type has been calculated. Exported routines for the API
+	 * will never return this value.
+	 */
+	PCI_P2PDMA_MAP_UNKNOWN = 0,
+
+	/*
+	 * Not a PCI P2PDMA transfer.
+	 */
+	PCI_P2PDMA_MAP_NONE,
+
+	/*
+	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
+	 * traverse the host bridge and the host bridge is not in the
+	 * allowlist. DMA Mapping routines should return an error when
+	 * this is returned.
+	 */
+	PCI_P2PDMA_MAP_NOT_SUPPORTED,
+
+	/*
+	 * PCI_P2PDMA_MAP_BUS_ADDR: Indicates that two devices can talk to
+	 * each other directly through a PCI switch and the transaction will
+	 * not traverse the host bridge. Such a mapping should program
+	 * the DMA engine with PCI bus addresses.
+	 */
+	PCI_P2PDMA_MAP_BUS_ADDR,
+
+	/*
+	 * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE: Indicates two devices can talk
+	 * to each other, but the transaction traverses a host bridge on the
+	 * allowlist. In this case, a normal mapping either with CPU physical
+	 * addresses (in the case of dma-direct) or IOVA addresses (in the
+	 * case of IOMMUs) should be used to program the DMA engine.
+	 */
+	PCI_P2PDMA_MAP_THRU_HOST_BRIDGE,
+};
+
 #ifdef CONFIG_PCI_P2PDMA
 int pcim_p2pdma_init(struct pci_dev *pdev);
 struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar);
@@ -45,6 +84,8 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev);
 #else /* CONFIG_PCI_P2PDMA */
 static inline int pcim_p2pdma_init(struct pci_dev *pdev)
 {
@@ -106,6 +147,11 @@ static inline ssize_t pci_p2pdma_enable_show(char *page,
 {
 	return sprintf(page, "none\n");
 }
+static inline enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
+{
+	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+}
 #endif /* CONFIG_PCI_P2PDMA */
 
 
@@ -120,45 +166,6 @@ static inline struct pci_dev *pci_p2pmem_find(struct device *client)
 	return pci_p2pmem_find_many(&client, 1);
 }
 
-enum pci_p2pdma_map_type {
-	/*
-	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally as an initial state before
-	 * the mapping type has been calculated. Exported routines for the API
-	 * will never return this value.
-	 */
-	PCI_P2PDMA_MAP_UNKNOWN = 0,
-
-	/*
-	 * Not a PCI P2PDMA transfer.
-	 */
-	PCI_P2PDMA_MAP_NONE,
-
-	/*
-	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
-	 * traverse the host bridge and the host bridge is not in the
-	 * allowlist. DMA Mapping routines should return an error when
-	 * this is returned.
-	 */
-	PCI_P2PDMA_MAP_NOT_SUPPORTED,
-
-	/*
-	 * PCI_P2PDMA_MAP_BUS_ADDR: Indicates that two devices can talk to
-	 * each other directly through a PCI switch and the transaction will
-	 * not traverse the host bridge. Such a mapping should program
-	 * the DMA engine with PCI bus addresses.
-	 */
-	PCI_P2PDMA_MAP_BUS_ADDR,
-
-	/*
-	 * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE: Indicates two devices can talk
-	 * to each other, but the transaction traverses a host bridge on the
-	 * allowlist. In this case, a normal mapping either with CPU physical
-	 * addresses (in the case of dma-direct) or IOVA addresses (in the
-	 * case of IOMMUs) should be used to program the DMA engine.
-	 */
-	PCI_P2PDMA_MAP_THRU_HOST_BRIDGE,
-};
-
 struct pci_p2pdma_map_state {
 	struct p2pdma_provider *mem;
 	enum pci_p2pdma_map_type map;

-- 
2.51.0


