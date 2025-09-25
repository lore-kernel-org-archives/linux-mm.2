Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED676CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526D18E000A; Thu, 25 Sep 2025 09:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7088E0001; Thu, 25 Sep 2025 09:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5A88E000A; Thu, 25 Sep 2025 09:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2766D8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E75A31601E4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:43 +0000 (UTC)
X-FDA: 83927827326.01.6FB9D07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16B16140018
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYDyxepd;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBOIt8kPT/J+Vy4qCivi0BS+/geWEdiOp91uR4uGccc=;
	b=lPNf1spTw1Hd76no5XmNcOFFJut0LfTyuXTU5BjJ7d63YUpVe8F1PkuH8prSJlzBSpV6Ru
	ZcAe9cWql0wJd7U2zg7Y0w/Z6SfsmfUcM7UF9lBamfkHfQNVCxCF1PzT69m+o/IVqMTAz9
	KIOKY4PwnleKj3jqNXq5F9kKpmWR8Uo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYDyxepd;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806322; a=rsa-sha256;
	cv=none;
	b=bgi8Y+8w4MFbBXY/xf31V1x4MfSDRk6MTdiBAhO/ddq1IhsqaBFEQnQXdqDglYx9cR8Tso
	wfF+dhTWP4KOlFUBzr361V9c9CUo+2QZ8fxOHnptQLnO5mkgOXbOMEOtsxz9ivQI7sx42O
	i73/TckD+8lWLXTvo+vOuFuSblnSPo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29B9E407E8;
	Thu, 25 Sep 2025 13:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6011BC4CEF5;
	Thu, 25 Sep 2025 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806321;
	bh=Tdd1VXrM5bIO3utNsCsXIXtcfaKqVCGKamZRBmRVDZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYDyxepdK+vm+8WXUwLaEeADhPIGdeZqIRW2J1O8LoqXjkycRqhlyrw7b1szxLDrD
	 WwMDU/T2lrHRvgt3e7wwq+vn0rA/RImDYLDY0peuXkieOD7SA+slSPV8uW+rmIMFv6
	 Uijf6mR6BomLqBBaapLn1fGvrMzv+QNGrxSMeDpddErQAaXsT6SCA9ji923SeOspR0
	 EqWQwD+EcCiMusIhUT/BpKGvMqc6F0JuVbkGSddRqFiGGrtBtIb5RBab2QknnFgyFo
	 0wFSnGav8RD8m3qmrnXpuEeenqP7+yC5VcvjylmSIt25u+396aapowZybx43uRTuGO
	 H5hCFcxv35rHQ==
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
Subject: [PATCH v3 04/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Date: Thu, 25 Sep 2025 16:14:32 +0300
Message-ID: <d56a30159629f9e25ed5251703bde063bee90fdb.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16B16140018
X-Rspamd-Server: rspam05
X-Stat-Signature: m48mabkrrba56o4bhizq4ei19qyfzp8q
X-Rspam-User: 
X-HE-Tag: 1758806321-305270
X-HE-Meta: U2FsdGVkX18Qu4XSD4D6FC/Nr4WSWY39flKRLHqubxK9BubwfzNaHM7y1UFBINb8QMc5DtflGeo6Q0YAAUB+8SAi25GRbttwYFtGzQGbXsnNMyvgjJQPFe+6V0pkQjmJYbUaT9SADXwQNdpX200teHne9s85tk39mJhbrijUgwlmJBVUBdiaTvP31KMhcTWzndlHXmAq4/W8dPza6k5J9uylf5NQkONTEKf2P/EWPXip2B7c8iXnH5LNKDPRNWm6TmtJZZ8k/7XtcmXfj/qibvnDuo8iAyvQ3o45XaVWgsFWXfVGz0JYvnAUOPmvA112YvJwTflBzxjXEaLWKTPOcSj/ZF3LZ+n/CKZyfnh/YcloomHs8/eo+e/68lezMhRhkPh28vNuiY2vnmvE8NUvSc66E6RHnw2t9l+KUltM109L8UFQ3x0FIHxyUNcxIngB6qMuzwuqpDwowlSh9RhLKscawHmmb8CoSSeTbD3GMz49FqbIhAUXyWaM8L4tfYgtdT2NByGIoJQtgLataHEYPRFI1f8D7U3WJQhhbUlG46BuQzfltuQQcwPqT1sCMzMnN1p2AmmhcSHL61qw/lu09QoiTDkf3nndmHgP3SCBHfpa0sHj/PKN8KrP/Cp/OnTtbEn5/4L1pQnvsMoupggIhAvQBXR7md0Twpm5WYuY5gCFkWuIlQOuUJIJpu82/vcsCtdp7DxHTYlAM1L63dCVkSLY2/CAblupHum4y5ZYCfyteuYsb3vdDHFhyjaa6M5cNoO7DFsQ3ZSxCL4xlvsq5UImiYiYKAdxg9VyWYen3B1O47rhASRDKr7DUVsSDwy/SG9MfwRCDsu6NA3ERkRMXNLI2DgL9qPKsEuOpPZ4H9/o8qEibdnP9e+e6YaX9YXVF2SEJihFrStl1G0HDLHIrmskV/YLfGs+69aWIP3yRcvui1gLC7e5wQOB1j1KGPYMKhQx8qXmDRbypm9eiHg
 +MFQCXXr
 Lpg66d8wdAcVuR/zfcv7Gl/4j/CiDoU1nIWThx0Aq3mXZaynh9bgkPxM0vRN8tY57wGYM1GLOcoW4tORxcxIm3clzUgAcueT8sjukxzvkBDP/0cWDl4A7jOl8ecfDNUhpPN3L3Hy+kWQW4RDIju0kgLJ3zdRe1MVtenjtphj6fQRp/DTf3UwIi+xo03LthAtX/g+Gi0CCrYWg9wmJXIGGIdgvGv52K1p15ikMoDb8ljQvwgBHj4Vvz1hOB171WhcjaUELXbU0DnQUtGWwWaniGK6dlA==
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
index 76496a5ab82e0..3ebe2e8bb335e 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1044,8 +1044,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -1074,6 +1084,7 @@ pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 
 	return type;
 }
+EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
 
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 476650ae8d4d8..55cfbfcba8b39 100644
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
 struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev, int bar);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
@@ -45,6 +84,8 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev);
 #else /* CONFIG_PCI_P2PDMA */
 static inline struct p2pdma_provider *pcim_p2pdma_provider(struct pci_dev *pdev,
 							   int bar)
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


