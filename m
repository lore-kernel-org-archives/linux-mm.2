Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9A6CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634D3900003; Thu, 11 Sep 2025 07:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4968E0001; Thu, 11 Sep 2025 07:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC73900003; Thu, 11 Sep 2025 07:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 372258E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E59ABB9942
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:07 +0000 (UTC)
X-FDA: 83876760534.23.12D9367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 55B184000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aHuckqIP;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwlqvC2fc4SecRjjUKTuYyeDo2MK/qdSV/YHWgUkGr4=;
	b=ZARpWlzdCFiL/k7c2VTA8Eth8Lv2DnC2U8ioVk0TuDAGidDNmeoOUrEHGfDPunjslCILhM
	PgOFsEcbVH1ndGOxnb8Wz8YBEIOH8c5fkzSdCugvXdgWnztA4sGRU2mQrM6uDBdbWSANYI
	64GagNEK3P0hmg8Ogstyh9IDhzh4wi4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aHuckqIP;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590446; a=rsa-sha256;
	cv=none;
	b=N9NIMqf3+S3LgPPbiTl9mYrU7Rlc872Abnfd8s51TxNV2IsNQDVlnLNKFlAuaDCAzMqGsS
	UtVAYbN8ZIqEalLkELcyw+oNg/JCbcyz3NbyGdWI2lsz2jbBVSHu4ERVwTlOPdp2ixez78
	l+XRp4d3uLJlzjy4Nd3o1xSHVuZDfBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B94B5601B5;
	Thu, 11 Sep 2025 11:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF7FC4CEF0;
	Thu, 11 Sep 2025 11:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590445;
	bh=TgV6C5G8VhidqawynN09s+nxyIE1o95t30Jv8/yt6TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHuckqIPtEIiOWHvNq0NOX2VUROZZq/uA7zGOdbVdxG4Pu3sXEwSkT9szYEIMUgmg
	 BRxCuIoA6vu5RW5uQEkSA0Wkre6rPhzocirN8IxZLlyOeC56xl1jMuRu4WS4G7HT0o
	 tYBmQudeB/a7Uj13GiYWUYHXUkFU2szEXkHMgoDK8LxNqKeZAsi4cyKxbwRjhjXaZF
	 zvWnMOC4O6ppfFfXSIkLw0gbU+TTsuWC5j9lPKIoSKnGtehkmpXC7vsfBOgu6iLbxn
	 eW0H7UAlzIhh2IDF7GLOcEzOXhZRB/ePSwMlsyMCAbLM7KMWT8cBAdmtEzPD3lbMvf
	 2SsFtJS+il52Q==
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
Subject: [PATCH v2 04/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Date: Thu, 11 Sep 2025 14:33:08 +0300
Message-ID: <d017c5ecc53ace9e902c988ce654698f8b8f85e6.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hix11en5hwnb5yebubndaid3nhkhzrpp
X-Rspam-User: 
X-Rspamd-Queue-Id: 55B184000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1757590446-352079
X-HE-Meta: U2FsdGVkX19fEZRPhRWfUpOfJtuZBX7RyLpjGvkS5jwTaKfFKDytG/rWHBM7FFIyxbRW7CFjagCeXGW3aBooPEfbQQKu766XdvpVxrsF7bRh/7xpeEwzdeYcbcEngNsUwj0Gt/p3iqac6lWFCRAJZQXoi6oM4YGHZl7/4JPYf9drifWBvVUlhgVWVZYIc+UNtT0IHuF74waY7cr+guY+Zhm5XRFosXbAOj044GqUur9CV7WfTOGyjEUruduIjmD7Fd9WhewUUKdCyBP8w8uQ5AuS+Epqo1vvOwfefp/sJyPVi7Ws1aqqXz8JeoGzPcomdwIKZ1ABv8VOS11mWREZN7VEJSssOjBIUQ9YFFRrMubKLPlUFykyXsxmTiXHEK/4UciBeki2YP0rt4qHvhwdMvzu0pk12ooICfaEbOLRyfakv1Ik1UUn2hR/epbtBBJRjuCXx7VvCP23UKmal6BSzixzwls4/8hsaOCe7gHOBT4ZngYONPLSWOMlW9dZKNpKSxTM+IQO+DdVD22vI0dEXt22BctQVTzJSdxnNuY/i//fCHg/aPI05IwPrGuapPcTaIddU2UqmR9kEBcHUMYae5EFj5MDNdhcUOEud3EB6eGXEOZwUGWj5k6FVwnnvRuOEwd1TVdWC3bax0vXJq8ZgFO2i/MIJi9OErKivXdBNQgYQHdJv9zBgnrh6wk9i8jjDgIoqbmMXsTOx2J5X5auGSKYljfj1ixldxCytuqU5npsJ5j+SYkRwo9C5OQfkY7A+8R8GB48+WRVHKT7WPmC8dEfR/1fZDKgaFCMjBTJ1dWMsy1ty/NC94OA4Q4OuSs4Lc6PLAI5M7xXzjmhnPVZFttj163k3KaG/NV9hNDlhhVLkBUSP71BAXKOsB9PKdxKnYq5Suk1EndUF4byGEHKy4fpQR1ggYGquguUd6E9fccNCVeOLEbp8kwE1Er+8BMu1HmxlH5eii/o5FZN6T4
 E6MjUMtu
 FX/wVjSybbPT1oQq+NNpXNqYsPwg3n8B/sdcRN7SpP9u6nBcVdZqOUASpAEGwsElqoj0M0G1ffur/x9Vscr/I2DfKSZ/tZJdrtbk89BFCHyAr1I9U/iJk0bTBCBw9zTZgIwa58wiqKD86xPc34DtYCxrcEKtuGAE+VRXXCwDDmPGkT2i/RoI6xbimJ3h9VZL9RupO3S8XVHbIV0pWNzJFSzlNTLmGJvpM4uCUhyZkfXcSy1UIoKnTQoh7WlYY3fWx12n4Yv0F3KhgdkZ1zAnaHpJktQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Export the pci_p2pdma_map_type() function to allow external modules
and subsystems to determine the appropriate mapping type for P2PDMA
transfers between a provider and target device.

The function determines whether peer-to-peer DMA transfers can be
done directly through PCI switches (PCI_P2PDMA_MAP_BUS_ADDR) or
must go through the host bridge (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE),
or if the transfer is not supported at all.

This export enables subsystems like VFIO to properly handle P2PDMA
operations by querying the mapping type before attempting transfers,
ensuring correct DMA address programming and error handling.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 15 ++++++-
 include/linux/pci-p2pdma.h | 85 +++++++++++++++++++++-----------------
 2 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index c22cbb3a26030..7b899e2f82456 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1033,8 +1033,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -1063,6 +1073,7 @@ pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 
 	return type;
 }
+EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
 
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 888ad7b0c54cf..c12500061fd64 100644
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
 struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
@@ -45,6 +84,8 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev);
 #else /* CONFIG_PCI_P2PDMA */
 static inline struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
 {
@@ -105,6 +146,11 @@ static inline ssize_t pci_p2pdma_enable_show(char *page,
 {
 	return sprintf(page, "none\n");
 }
+static inline enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
+{
+	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+}
 #endif /* CONFIG_PCI_P2PDMA */
 
 
@@ -119,45 +165,6 @@ static inline struct pci_dev *pci_p2pmem_find(struct device *client)
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


