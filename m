Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8811C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B9D6B00C7; Mon,  4 Aug 2025 09:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5CD6B00C8; Mon,  4 Aug 2025 09:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD40A6B00C9; Mon,  4 Aug 2025 09:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98DB56B00C7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C7EF160340
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:17 +0000 (UTC)
X-FDA: 83739085794.13.6CCA8F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BAAE680017
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BSb+/N/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312475; a=rsa-sha256;
	cv=none;
	b=gX9eonnvn05H4inCs2Z7z70BIUQccv3hSHrY8B7WdYGX+n6pslgyXlDlVNHBXrLF2K1Ccz
	/p6UMcBzgPX7kOvy3hMUuqPfhZkskObKl1RHO+uTEWwUhnVsHk1Hs3QV10kRwgJbazE7xL
	LiqXb0lMTy0bcBfrG1+rUAlpD16cMTE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BSb+/N/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvX7y7fISsbAKTM1qRKKPgaZhT3KWPLsdPb1YYGnaWw=;
	b=i/rkNT808t4Ts9NyMNMy76ILaD40xvhLCpyTET5tv86xwANMDOEodlzdUaobdlRZQHhmtu
	ypQFBc/+xv2qmkqQzhBvYPr6WglL2h94p2KLRhs2Ux599PTxJtNzpaG0+gS5k/6Re7/xdR
	ufiaD++XQsnhHCUudA/vyVIFNbqBRm0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5B3661138;
	Mon,  4 Aug 2025 13:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5962C4CEE7;
	Mon,  4 Aug 2025 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312474;
	bh=9+ULuqPLLBXPgbHLXOPPCMvRNGtvNj8loKfxgbdD5Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSb+/N/auBoNeE0ABgzET5irnf1yxzaV2jqycRTIY9uSY26Xojp6pcdt2fYsHBR62
	 NhhOMdzczWKXgEWLOUDSZqvkCPLWEtTbTePU4iFUWxT/u7NH1zqH34SesIH+TNjYDl
	 sxTY1HFoxjV6Pidr1+i+aN8Lx+sfDun4UuSXJlLlNc/MvvE4LpEuPESCA19atSOG+c
	 NJcRoVsvAXpsJgQo1s+Kig4oPRAxJTL515mNQTezRMwXnnKJxEyz+H9MvzpXm5L4Wh
	 BL//RZhNZxS8sZcD/bj0R9LCXKrlkVXrDIQMBbsyvNb0B1TuBkpvRugiUByizRCESe
	 64T8DE9SPbRUw==
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
Subject: [PATCH v1 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Date: Mon,  4 Aug 2025 16:00:40 +0300
Message-ID: <e8ffcb3c070df8a6248014ac82d33b1e07b8941f.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAAE680017
X-Stat-Signature: inpwz9eo48h6u11i4btkcub9z81kgeq4
X-Rspam-User: 
X-HE-Tag: 1754312475-165766
X-HE-Meta: U2FsdGVkX19c3Eql7MiWe5jQFN8oTHOxf9SOf2iCJypapBYtoHYUyfJlsYccdT1k37EFnvYNA/EMgAnI0nwmbYaExEFCpBR5zEiYngL4MiNY5SZEnHD+Iz9bw3BarNfI5q3WZ3PwJpZ2TtI9+laoGw3NJGNmfQeLw9RJY0e2AYE3WVZMMLYUKL+15jwZAHZkWrq0iVTody6MEy+EEAZrq+M3QhOtQLXZ16qOEwV4NscXlBwzeO8jhY+3fV2u31caNIK8Tslwr65lQoe/g54CT0gEo+wRqoH8UgLo1Zx9pKuAWItbw1Ji6uK6Co+MbucuTvgHu0N9De8hT2E7qnzAXgo+L/ZhPxNNlhxgWthtMq5Da1+QrSC2o5nNZy209x1+aq4dTfnHZnZjziMEhZHeHGWBD+6jzJJJXso0IkQfzMm8vw+JLprXuDgrY/tVv555loNa6H31tCxWJNYo1+j1lfl8k96uLug9LEefp/9en0OZEoxRRmK3aj6vZp4TX6Gb3YsjpSL5oz4wdh6ZsY3lPAuiKagpcYnmGiSs7rxHaG1wgngVQEy/UvPS2VeNidne7u24MVkZjPdcz5W5N5P6fFYOxpJR/HzVaHCmKMgE7B6BfCZyzXhXMbnRCB9YXudKfsVttCVq0qL8eWZa5U3QGnyqXt+4KVNQaWMjHFx9EyhQOAjLHBt8shNbWA46rGFBrgopZ6NODqZUdFFgqZcp/Lv7Lem40he6pX6O9sn9f95GsQga1IrZzUj0K4RZbIi7Yy/eKv/ZodNgudWVZAxkrzCW8906+EsklKUpRxIV/BU8rrCv8P5JK/xbWdQ2lpgnF3DnGJU5DSqvBDR5ICn+DO/H+gkefKZASqIIpAqq+p+BHws1QXcmyrVst4FQyOUZZoOPM/sX1qjw4vLeMAC4RJmC4EvlzPrq+wLpSclSSgurYN8VuxUhy5XeERfzW8XkBDeGqMMyS23cOdjhrJt
 DwJP1MwK
 GuvayIpTXeC2k8QX20N85yFzL5GAuJEDnIlIAmnXv2O3aDZbG0nOjGdIdkJUhPchKt6XLSWQl4DiDTxTondc4eBh5bL7uLG8RHioeAdKagFLBXhbLuz9PVQsM2qm6sMeWrgy3qtikCzxgLO/YuvWVLWXc/4cB3ueT8EgrEvyA3CpOybUHqtlJw8BCzzt2tcJKqGZ0D2P26aRftgtlzu22wnoMYKJ7BDi8CEEwI+RW/NkSl1T9/crNnh4wp6NjmpwhB8Pwx7Ic90S0rBfdW21hFKMLkg==
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
index 24a6c8ff88520..3fa1292c8d917 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1022,8 +1022,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -1052,6 +1062,7 @@ pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 
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


