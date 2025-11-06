Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062D3CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664848E0012; Thu,  6 Nov 2025 09:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615008E0002; Thu,  6 Nov 2025 09:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504088E0012; Thu,  6 Nov 2025 09:17:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DDDA8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2D61BB3F5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:33 +0000 (UTC)
X-FDA: 84080385186.18.12396F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3B92120004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fzqy63mR;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1un46LJHQdAxRUGkZq9ToTd9hdU9TihPa04OUIRLgM=;
	b=beR3Z1WskxCRGrDg2sOoQ9ZhGtX88o/tOyGBCfXfCs8qBl8iZLwj8gQnUD5j8GNQBfENzL
	huBfLInT+6a8SLqWYO+h5BLPEdfu7TwRO8nqvsXBBmoo2vAzyPxUkhX08ggNXq/Z7IYRk1
	oD1QqRchz22MTXvXINOxyobu6/GOdus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438652; a=rsa-sha256;
	cv=none;
	b=pr23A+1kcnXPx4gr1/SCkDINJRsR4gtaSi1SSzvu9c4kLW/Eabx4EZnFOtA0UoVbzHaqJ7
	HpYC2/Zsv13p2GRVr5gyqR23bcgxVsSS7NwfoiXlh+drjMqJAmHxaoKo3KqlccfrbYa+PD
	8TkQ5SWobCLlKi+FuGX8WQeGegi2Un0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fzqy63mR;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1AC943C32;
	Thu,  6 Nov 2025 14:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EE0C16AAE;
	Thu,  6 Nov 2025 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438650;
	bh=toF5THSZHOeJ/QvtdnZ6Wy9PsXvPdD6mPNagdzYgFMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzqy63mRk0H3tg29gwLTZH/cTlIPmqxphVfyUtq26pZ0XiuN9j75SNelw3hCfgKKh
	 mXWhZJtQEQ/pJnnHfBBjUFMrr8VF/zQwqtrIHAX0RCeQeWUkomRk6U8r8i/BL+9HlZ
	 +TDe1P54EX3GW0Lv6v3fUdh4aP27BgPbqoBaHF3B233+l5jgOHzgTolDNjzI0KOZ/M
	 lkVEpE13znSftvQYnljsIDgAdXL8uXHA7+xrgunTbdj9xRlIEl50uYGYp8F851zS7p
	 T1sEek1LpRUc97A9uUGBFLWozCN4PBFbIOlHx4a5why6KArbuUayjuyLHFTW0omU3c
	 qcQGAUYLfDqpA==
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
Subject: [PATCH v7 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
Date: Thu,  6 Nov 2025 16:16:49 +0200
Message-ID: <20251106-dmabuf-vfio-v7-4-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ckihe8z7epq57ceigkmidtb361soue4g
X-Rspam-User: 
X-Rspamd-Queue-Id: E3B92120004
X-Rspamd-Server: rspam01
X-HE-Tag: 1762438651-448330
X-HE-Meta: U2FsdGVkX18ne+YQ0vNYJbJNExkUrwctxfD+rewkRZXKKrJya169UE3cznrrsqw8BviMmt5E1qf29kz7rzYD6X4iMCQFy5HhuLw6kwRyAzJj6DtKkuGQe9/olWc07BUcdgGuAeDHiz1WoSOr/hwQqj881nq7OAaaOWzkD8G70+pPa9TimqewZUHw6qCElzwfoCkueKWNGrMFD2m22IuLn+fJbHBi+WLVwGcs1mwd7QsOpAaxlW/libC/mYI/TcNHYeVFjFevH7/8XsoJLRnVuvr2lGSrjfrE/iWgGGR/bkpXYgqnxBOZuxJJ5zhSN5cuhEfBkd7pcKKbfMUE5gxYo8kMW4RTxPDMsA1bpWkkUn7970fUBKQ92yh/tlNlHIjzORpu4Mhyx9X68RSQwwE89Rl5MlZf1riY6EYmrRe/2K8j905XgzOGeQq+TD5kcmVlVuLn2zb2mPYG0BStjFpEL8E+V1ubKaCfCbAwb9tH26VgJtG51uwaufhjmZfVglVqfHY0ZJgJnpgC5YGql5i9rp0ET17ydhIfJtrJDwtDmrbLCjwPsYf91ZYZDXxo6vUiAPs1Sm47Dbes/kSby33pHm+XEIc8tBTeWebrRfSwIMnxCZbbFSyTUSsJ6z8a4UvOpnP5jET5nr7P6Obe0hgp9vlG5DZCVN6Odw9mfKOU8FDOx6UdOQir4xEAyeCZbiT5aKgFk76UIm12tITMsXs2WcCopAJTr93dG+8iaZjkO3GcN0f0LIEgUiXG83CyKXb8Mf+JJvQ1Ig55geUAsKSinH3gx/VwIo19NFLRSR5y25EFXKk7p1opSjH04Xw6LYPioChvuy6fFy/2RWlk9vnd62SZc/FCyT6Lyk007UqUyCNwUqni1tVL0oocHlAA4E2560poFg0LG2ETzQ2ViqdJqddpOtmldMuMqpgd7tGlZOUQb32WGbEC6F9KyB1Vg52mUO53AaWHVTQoPekVieR
 deThSQA4
 wGaS2i/aPZUCLyTABcVMzfsUJ0B2UDMplljOBzBSIiFfTY+BvciSxDbXMpeqDd/38se6Bu6a5PCx8a3pGO5WepY2rMvesqXqrZjRCABKLzfgOYQSKygak/pUwSoiVAyRcrCLw8RmLG6Q9A9a6Va/89mtaZM6TifYT55XVTTEPcWEucqGoDRFI+FMRMPRKYyVTZN8tzteP03n2r9abtNqoJDZmQmP7svthx99K9aAswiKJft0r3U3FWeC+hHlWBnzJo/wDWN0QIdOwaR7aGJB6SVD5Eg==
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

Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
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
2.51.1


