Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEDACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4B78E0056; Mon, 13 Oct 2025 11:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C268E004E; Mon, 13 Oct 2025 11:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9458E0056; Mon, 13 Oct 2025 11:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D54A8E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E8E81A04E1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:42 +0000 (UTC)
X-FDA: 83993468244.22.EBAC9A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E70818000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HWkQdgI/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAkg6BHrVZQY8BTbekXaeqbs/avdB4/aFQh6SlsKCZA=;
	b=g+ZTl8/9Vbk4B1ZKJQq6f1Pzj8DVGkbNl3qJ1xWZdZVijXKbAkGr39Iv3vDFoCT4z8vRps
	am6Inu5UYxbI4myUkVZ6S+nvHHBUPOejeH4JxE58McF9KE3muJPLqjguj1eCxnqjpU6hWp
	pveWHSmjMqiUWFC2iY28MYogEL0NpIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369200; a=rsa-sha256;
	cv=none;
	b=rN688aM2QrYOQStMO3fWz1k3P5S9qMPSkNQpzNxxdkIz4uFE/Hu9tYZHLdtQqw9o1D1CO6
	UE40mogeiHe13bpgT2JqIWks9Ncv5F+lq7LeGv1v9ZTthVWMNwB89lmht9FM7pIDChVyTD
	5a8kTR3XkhRwNw821YM2leS7xe/LP9g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HWkQdgI/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F3F048B40;
	Mon, 13 Oct 2025 15:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B993DC4CEE7;
	Mon, 13 Oct 2025 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369199;
	bh=uclaj8ShqoK/tLaB4P7K+/dpWuRDftZ4T7FgP3s1Ss0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWkQdgI/DziWme+idGj28bJXR8oDdAmj3pNGrCOPJUATAL0Q+wATUaximxWFzvCmv
	 Q+4v3qJgyuXlFmJGTAR55Eutmj4tRovI/LZw90rPmGPBOseymKm5bakYUMQozUntAS
	 J9V5IHvJvNXqODPT1laUAQx9O/crtvxFMXomJjF8uETvPz/rz/SBOfKX60CUTE/+SH
	 Mc65BPlVgQu/inepQ9/tFdjGsaLwWW6IWgjwzOmuiSVpfIR0wxjrINjvzPLzjE5CYd
	 ap5fRmiW/uVoqtS1Nq/IcSAoDU8uPJzEcF5P3EyQ/oxErKPGpOGQccyoXoN3H1gLvF
	 3SzgC1UDD28+A==
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
Subject: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Date: Mon, 13 Oct 2025 18:26:06 +0300
Message-ID: <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: grz4wd46pgeahrtt5g5drsedfcsu4m8q
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E70818000C
X-HE-Tag: 1760369200-390670
X-HE-Meta: U2FsdGVkX19HNJEqWnaXhaKfuNV/hqAG8OMCdk8NT4bwl9nmeFFySzmpw5jPRt6joO5iQfT7ja6fjNgZ6WLHw75sMIwtO2Aph7cRrOMPImABgAO+eMPntg3kDqyND3kdcHR94n6kya9ym+tpVpMk7kPi2jZaVhyy59V2QRMxUldcC8QmZV6af/S0cyWlQKXY+ycrF19iqVjCmi/4X2SQcuVcUVDSIky6zcbgkL31Zj+ywcDn7nsxXtC4gonyW3yYXxQzsUB6Q7Za6NPJof49GVR1e4aBoUff2xFqlEqG8fp7tquzxhXEgn3Sm/uaTiD1C++u/EopAiPThxleQqJZQELAwzdOjs/5HnhY6w3nYeODnIVlKIPFQ83lC5eTBeluYCJb5GBLOiEggzFfLtE6hp3j1mreNbzXf64ad6qX3OZInmr3qUBtQW1dIHVOCRskLPxtV/K8p/BbAhAnmvsGezaTrvna5wtQHP3mq9m3cJQI5PPL+9LKjk/vl1UI4pceNgjeYWeapBbGr1+ECpMgnrLPMl+BVQ5I9o8Pnh1OEqpzsel11EniJ3zBwByKC7Vcgon4nDu57vsD+C+/ucy6bGkpXc9GXKn4LAFgoDwGF1oL3UNx8wxjU+T0uExgcyWmMQMl3zGyqYHvSqp2rfFQWGq6xn8FeXTgSmNAkNKP4ef0SFyYmLxBCCKCoOnjCFnJ0/UvYIoOSNy3VQTpnlPiSTRXIsrXt756cEpNlJmo0bAk6Vlom+4JYeYBlTFwhuzWWZg0+bGX+yNkHo+M3MEar71DRR1m1CLVLDCPbm54PKM28tL3HOfWiwnpkd48Q1Nc10z+q3OsGqueaGDwq7IonplohhCoXOOCUA/vlyCZhcKZHjVCYeM6w7bA3j0bK/PEqRwAHfpwBNDAziG3AEUa03/Ulrf5Y63shIqEWxszjRkxS0c6hTSrAbzRTGOefPhwT+bPLkfuBQhqljzfhFE
 bQfHKrr2
 4Dmy3js3EQMV3JD1Yf++4Bmn+YNNH83cBbanmgGxGNy+FhH1Hlk39RITyJSd+8uKYXGsyYU4QQ7vCf4ROUcP2G6b2/8Myjq9/sEKxZT5BE+PI6oLcoJT50Md3XtPR/ogUX1e1iuwqAoBEJojxaO33fD5QGiMm1kudexc6Hc1vO3NzyWIBxtOMe2EGB6UwPviQcEKCj+PkYtt0qVzUEevIUuaswaKZRLU1MfnRxAxQJBoeNTkrcBPYFYga1fZZK54eP4dkZXl1Cun010Y9GjBan7Y0qw==
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
index a2ec7e93fd71..bdbbc49f46ee 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1048,8 +1048,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -1078,6 +1088,7 @@ pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 
 	return type;
 }
+EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
 
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
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


