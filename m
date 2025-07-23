Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AD8C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C671C8E001C; Wed, 23 Jul 2025 09:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F188E0002; Wed, 23 Jul 2025 09:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BBB8E001C; Wed, 23 Jul 2025 09:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A86EF8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 681BEBAA6F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:23 +0000 (UTC)
X-FDA: 83695542966.06.7D2DD50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6A1CA0009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lnZbBneV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3q5WdVAulHodGIwpQFr9fSq0ST7laYv2hDJOKZi3vyM=;
	b=RHScP7wFnlysNPjaLzIyddUdNJSUPX6Wa/boYUlgIRLJ1lRXi8kZ097SF2zY8NAfZY3b85
	z1u1b8IDx1/CzorgGv1RtYBbIGwcUcpeaS7UFHKw83Vug89yd8gbb6iv4OPFfSY5OgtM9A
	gplg4vzbSgCJiVD64pbD0WePRqUdz7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275741; a=rsa-sha256;
	cv=none;
	b=slpxkjVd5pWWMHSNjGYSRUkeUf6jvQnV2Hooi9QSyvNjTYKYGQqNm7ptf6YS1UywNkcd/l
	QNoYYQOOatrSjQLsbiShAqbD4eNCf8AlPT45qCgb7uSIowxEaoo5ef4dzj48RBLUKGlP2x
	KGY71rOw0crUFkdzgcHxVU5g54qLNXE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lnZbBneV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1953462FD;
	Wed, 23 Jul 2025 13:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA817C4CEF5;
	Wed, 23 Jul 2025 13:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275740;
	bh=nlUJ1hQe0rB1BLNxXOxhzCPvBdRkQwroi+XicJov0lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnZbBneVQfUXSDdBql+EZe6zUPnDCYl40gxPGQaQTpTisdj7QdzBIfdxeIS9iqGf5
	 6puO+R1/00D4satUiVhf4j97G1kDFuoNFKSoXuoQqzvIY0CT2wGNSAsqOGN6P9vTrP
	 zgoCsH624S2mClgyibPDHZkjWn1v/u+99YU31N6M1oUyu6dq/jOIIU7fY+rNI8uNdk
	 aVeid0uxsaaxYFwZecPCjTct9p66eTfDPOdhPl11oR1Ivj87NdTex/7PH36QXDPkLh
	 zDxMqqF0YDhJFnjasAZJfayzwGKvYlBvIZpwQ4n6LdpzK1TGYThmZ+NAQDx33bCMpL
	 RCwOpMO9Ex61w==
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
Subject: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Date: Wed, 23 Jul 2025 16:00:06 +0300
Message-ID: <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6A1CA0009
X-Stat-Signature: esuqrcz4nd39ihzf4rtbu5dy6wg4gfdh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753275741-484740
X-HE-Meta: U2FsdGVkX1/pIqPdkAeJr3sxb1My6zRaVO2tJwMJ05/pl9db5RSwUU/MNP19719Pg7IkwIgdDojfz4VgmoXp5Ua8+mqjDrAfbu9RTCURpl1mB9MCCbLmiVo1u2VDV7HwSxehMLxm7c3tIdDGI7oIdTPEOe++Md29dWfFjJMqLdXV1/v6EpZd4rqOeL4blGxq2f5nlJKwAqfG0IaziAP2qKzZYS++P9TxUdpEZMn+/5upabSIZvAFxTgNIBBz/BD/hFkS2Yo10uWQsVdqOKTuoGTS0g0iQPhq5LUcyI/3JS6D1eF0HY20OXzTBNBmRvpbaqbf7AVtzg0CE+NTl7+9gd8w2UQchQS7VU8PB8pJ/xytho0mGutdsCu6VtRdBBFzWUiZsw48dko5pkR4mKzOHkVQLRChj6Hi/cHECttBSH5FWWc0lwRrmItNEl4yngW8kCfvt+aAVQJ2G/htJ22H1tIG6RFX8MKJHSZnRcE+kLCDOIlMoRkxzX9XZXJG6CgTw0d/NjD7XtMsQvmCSHN2DrBeDm3V8QBw35bg2NSp8uttagC8fh36EBIO8l1O1hq1w1GsxLzte/5HrrpazZ0WzGDSX6RjZgkBt0bAMfSzhsF3PXgSc/SmonCHaWlImETRaBZWly00hKEaphWCoxKDnhy3XHpdcRscHVW6aV44emwl58zpMNUJLafpmke017aabTdBa++9J8MlVcFWRTb56C60151RLC7tARdVWo35jU67Rb8yB0e1OtJT/kXrk/rx4i/2lzxo5Ca2mRP7mXP/r4kfCn/2XebjKmS7ARYUj/pz7w1ILSYpvdD+twieJupwRLiFZCE7GDEW6GxwoM7lL8NFJ2nJQkq+RG43yBHLofHa9tYZFZYIe/n0GvCJFTdeYqKNjHs7JqfDI3ym0/GGomRpg/9vCLUMZrHEo65G1CNkL4wlVkDi8KiC84+AtX0nevwl6wxhBew9Z5xO/I4
 HbJvZSTe
 NFk5/v/pXtxBeanBk2ryr6yNGq8Z815s7Gn743FUyvMRgqjkqz7JydbVYSYo+bb7cwfkcGAdCvqFQQyVDI/Z1cQZgZK68kaF+2t7zlWygadlP5hgB5cbijbqM9a/uM+LxvHF7hGpCWR9pe1rHOCabmt6kuikQ3y3oxD7tn/dL9/j1BaUAXxHWrXSbvb6EphZE/D3cJsrf1kWR10M+zrr+KNEKxZN09AS7UekFWMehrtOHbsQU2ViETShVNA==
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
index 8e2525618d922..326c7d88a1690 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1014,8 +1014,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -1044,6 +1054,7 @@ pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 
 	return type;
 }
+EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
 
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 83f11dc8659a7..dea98baee5ce2 100644
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
 struct p2pdma_provider *pci_p2pdma_enable(struct pci_dev *pdev);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
@@ -45,6 +84,8 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev);
 #else /* CONFIG_PCI_P2PDMA */
 static inline struct p2pdma_provider *pci_p2pdma_enable(struct pci_dev *pdev)
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
2.50.1


