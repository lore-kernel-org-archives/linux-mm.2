Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AA6CF8575
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D562A6B0007; Thu, 20 Nov 2025 04:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DC66B00A2; Thu, 20 Nov 2025 04:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43C86B00A3; Thu, 20 Nov 2025 04:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4AEE6B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E8C54E807
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:02 +0000 (UTC)
X-FDA: 84130461324.05.5FB0C1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C3570A0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUZx6oBp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630940; a=rsa-sha256;
	cv=none;
	b=It+AXH5LX99oVvQ0oyr1WiWuTwLADqIuW96lLpYngnbkQZpkWmCArE+Lw3KySY6Ya1BtAw
	4k1vAkpIRztoIO5f4NxVHkRssm7ZyvYm733u1DrdBGflfEEgCYrYc7KCKW1AeOrARpMQtD
	N0KeJYUb9zNq5pSqomyKz4RnBsrpBCc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUZx6oBp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+3n7XSVn7sNxPilS+/nNUe+tO5LojdQ1A2SRjY4DAs=;
	b=3opRhbi4m3WE390IhuZK62JWwjn+j13L/s2OmcgYHoQTozLS3udPbFOllJvMgCXaPWiaZE
	IozVpbzXdQn/PI/kNa/khsRg3YvxJUe7H/O6O62UE/jclyn1exPwd4G4EFtp8Q2H+zOa9D
	S1o0zsbcEWJQhNHqB2ZvCIwUgSIht/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20EB660152;
	Thu, 20 Nov 2025 09:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAA6C4CEF1;
	Thu, 20 Nov 2025 09:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630939;
	bh=YOBmH6S//DXRu4PTlrpxk+MAeoPk3c+z1pImIBy97r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUZx6oBpClJYqRDXvy2XOibu6JQPIFUQGX+8xWw11uwOJbD1JJS5Lu/NccWE2YRRb
	 qXS0Gax/tH6oKOVu5sIEGr9phthl5A+gBeOd4O3Z9GEBf9fEsnE8JIyLLCodKPVSl+
	 Si93e/14L70SAoC0q/R7RX96E3MgbpLBSB+2zWpp4ZnWsOlKUJl0eiuROO6nojVGpm
	 JiiBRhtTau7vtYBiv/J47iuLhuHMf2TcyR1VfK9cp+iEzvG9UnhkQMer4vXz5dg8zG
	 XhnReQWaDxby1ZjVU2nryiHDbATmWX9qbmS7M07Pk3r45c8exjZkyaSt8TM7PmUlyU
	 KpgvAlG8Kap+Q==
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
Subject: [PATCH v9 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
Date: Thu, 20 Nov 2025 11:28:23 +0200
Message-ID: <20251120-dmabuf-vfio-v9-4-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3570A0006
X-Stat-Signature: 7pfxtr9zf6hy3d7rnhuxogp8ksshpaa9
X-HE-Tag: 1763630940-902637
X-HE-Meta: U2FsdGVkX1+VYsukxqsNypAGqGQpK73cJ/zkeP06+qG1cZUA36aiwzqtWEfOMD1mduh70ACv8RTGhPh0Lbxx0NQETvmko28q13GJT3FaPSQBxgEpFoxZ5iDEmQzakT63cSo3eaGCfZheh12jkzdSKaaWwW3RuWA9BBCBknFWZrEFRJGFvFGM2axwADQ71LK+Okdt35E8k4FyBJxnmuRaJAi7HbP/sB57fJJCPhdGWWrQUAUiM2tNGtHZpMoi0ov0xvVpFoD9Y4Wi7Fy9gtCnQV5WozSM1AUQE+/dpCAs/vODnqcqkv8RjAcEc6Lv+63Fb37Sxtf9cN3L+Ex+WUZINDpkxn1ffUr3b+0r0TkOn3fMST6o+hD66qAGG98t1vEDHFiSQlFqQBPz5x5JQSH5IiWmU61pPg2mkYiiEf3Rx1EIIao4Y/oIDi6wir2PRNfG/GfVKWKA4KGTtJ5eQBBcEtOP2TdyqG4WCuy8lcPfGxYehb489HBnISMyNVo/BVLjIXtwGW+AmZxjjpJBZ47ETzj5ZcAd6WH8HlYz+ESNXGGhythudeGrPvTXMl4uIUk+0nJZAMsA9sFTuihtg0GuPRlThaLcnd5pExK8D1BL4QGnYaB375XOTv00d1xp0RwD2djfpBmnoziwEG/y7gJi85Qrf0AUqqYXlv1V3FqSRLptSGMMcySI0qPtfgOC59Hd9roG0DyWbz9P27eexr+FDD17TkyxM+6SY92BddUjkxgPG62sZppiCsxCOCKpwFWbzKptz7HOathJnfKLeFPOU5ZKSjXtgh8ZPaNUYPizThwr+smZAOzio1PQZRIfv7m/s0+FkQvciVnaS3cVGG177r0VOjeqyT2ZaQAGjsGECM4OoltzckjWUEEhYbe4WdOL+ZsayaLsO/7vSzR4CDYBEuzigkxghaKrvUTnxTXpUzITKDzOtRlsSBy7thxCoHI69uHXbZ1qSbTa0PebZns
 CTm5/491
 QJOKQ1OQfUSXEzL23ufSrieCKptE1ys5SBm7JLnjCjBtAwK8PtkahnHCvXZaWjP+GTSWxehhSft+M4QyoJS1HDXzwwpU76mul/RBcma2waztTOoSK+iyD5vUIWidIvXd98GPDOVfCgZAo9IeUTvFxDNYkWBkqluvmvGaZpB+AfEuaIxIsUQ287gdoE+nVFtPTdo6chOOf+Mt3dd5gQmASAYDjj2TfgM71D6NUHjcZrN9BaeFeEJ8L25XuULT4Tml4Ggpn7Cib7iiPze/Qvu1DGSyJRQ==
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
index 855d3493634c..981a76b6b7c0 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1060,8 +1060,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
index 15471252817b..517e121d2598 100644
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


