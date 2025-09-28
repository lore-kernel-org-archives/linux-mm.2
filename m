Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B36CCA468
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0578E000D; Sun, 28 Sep 2025 10:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7348E0001; Sun, 28 Sep 2025 10:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E49A8E000D; Sun, 28 Sep 2025 10:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B19F8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C20E8C0116
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:17 +0000 (UTC)
X-FDA: 83938946994.30.8456125
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3A4B81C0004
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="inAaok/T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071076; a=rsa-sha256;
	cv=none;
	b=o18gvT5DmTq4Ss6/LZudLHYb+zEPCNnEqDP6oEF1AVEsNSJ/q70yScBa+iGJTMMneEy21C
	Wcz2NkoLu86MJ7Pk6RaraZ//A6QcEx+4KEIcnoVvsFT9m+IRuU7I1UKZJivLiAd7JnLRuQ
	p/VUMAkyPATnWP82vGJ0qrwCIsF9Pj0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="inAaok/T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2yCeLd05a8tkKdrqDb3NfmMY3GnpKA0pYoUiZ5iR2o=;
	b=Ynioeg6ogbCXrVoOVmPj7i/bvhAg87SwvjdpowBGsbl61VVIOv3dlARAzMlOdU7oQVMHFk
	814YTzJ8HCChrZR6DGs5wrV2Jb+EeQL2yybtbm6LKVZXlmgWnmHclwxCiHftfYT9dFQpJw
	rcHazZhVPL84Pa06n1b6KxvVY4wy0QA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C03966217F;
	Sun, 28 Sep 2025 14:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F99C4CEF0;
	Sun, 28 Sep 2025 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071075;
	bh=67+Dg9AzwF37mf2avq+c5PACILdZR15+Aq9NDqyINUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inAaok/Ti7gruoqWxFYGrrXjftOxUyqccDCb+HoyVK497oWCe5OfcbFQtX5RpdaxY
	 IEzA1kdiJEilS5xwvzC4oR+U1RdcM4sdKbcQ353sFgyOlktKw3le2/0DdkzU3w4AQe
	 Ksfg2EDrCflETrkYtf+tBagWID+/Ja1vq4NfOwWWi5qHufz23VXg+l2Og0AwIdMdU8
	 +K16kbbQGAL0CO+sWZNhWz8O7swUxa1+IqH7o0ZdDdcQvnM4Z+CZqXBNiQEijWf8Vu
	 wjwAn1AueovKRMdubgHtmUSioyucVCTXMs9pTtr3KRvP8lNyGHysyvj1rBwFMwcdHs
	 Cza7ekotL0HUQ==
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
Subject: [PATCH v4 04/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Date: Sun, 28 Sep 2025 17:50:14 +0300
Message-ID: <ad37010614333b95fe4774ea6cc259182993d9d7.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A4B81C0004
X-Stat-Signature: y55x5z15r9anfa5msoci4zex886ojpnb
X-Rspam-User: 
X-HE-Tag: 1759071076-658881
X-HE-Meta: U2FsdGVkX1+/Q2A9+0/3KZeXjEv0AYpGoVfuNULG0x7zpLL+363nuNlcjk+mAyor26a45S8p0HTiOfdOwnHBJCgrUFXsIttfVfR0Z2S9v6YKtrpYSsPGNR61LfPcOoRrNjVkPkxZMiDzFmxuHZpVJDzddWSpoahk172g2pxXOOElNC7dOhdn5JugfFWqyJ0+nNTpcQxSXaPVFk9f3LWaxS1ZRkOSx3vXqS8blS5Pa4PL7Ssft/k6fxWdtjp8GmO+Oc9Lo5W5QQEq7IZBhxYUbR7p9vPgcmoZCbJAsmHsIKJKT2TLP0Zs34DX48sn7EMXtFDmCOvRRY9DOv3il0dnv6/Whxs3qeq7cQBQ0hJycUIia2nwv4OEd+dg4/IVAAhscU5b8qahqzw7V4ugfvQQy9yzKg6NU4rcJviIQHf+IEnakej8mTJKo6z+9gUVA3Seiz4GcIEMRvzhSc4B/cOe7RkQYCj/CVURTVHq2H7i1AGCvrjLswqO360MKLDkDXES/SqK6fLPVU88apofjg0X2raAbRIMPgOYSxMtPd1o23+BWOtI7A4cubYU3FiOZTi3XBFbKQfTdjZZgjMpxi56eY4eYD1u0rgEDyVEWjCaCyD7h//3Ej7ZzgheL2zrD+Ysc7aiPTUXv8i1NDz60Ac2DeYNjlMIR2K/egRmPIKbx1/DcoMAxs28Xo4JngjGnY4Z6aJAqm5I7F7m1eadsYnW/wWZ46iFutBPjwEGmpnckchqm/wijMgx7Cm9fK8q/jY9qNz4FGRiwi0U4s/Eaijkc1Q8jyEgiu9LjJg7ktScICL4GcDR0nfDeUOvf6QKD+U5tz68V+EV+5j6hQ93DKSxcdQvCJJJhl8BhU/l1vi2nvImS994viJbpJWXe/uzDAY/mesL08MGyXpZS4INQcauF2ErbPKcfb1so8vG9jFE03KTMxPRGk5cPYgcfEWtljtcNSMKbFI/h550xUaVqJ2
 OG5MF5z0
 CMBgLxaQ0XkcVrzFfBp5nADrf9GFG5LA1B+jviqXZc6WCCkWl7Ai1c3EgF8o/pK8D4O10sQpH2j+CuSGJ6zvzgbRmqxCSGfC17vOmIrCsmVuTo1o/Tyhv1SJddCVS0u0O16P78UbnUoi5/aSobujU3yxtBkRcW6x6KfG7r7lq+WpnPqtqHJWNTiZ3ga2v4sbKdZulWjuGDsCoD3LfEwxikX0lhNaeHhYWHNb5OOr8+YMhaqz9YVVXY4MdoPyTN97+HOXQWr1hy4MCqSgsDg+bjPtTlA==
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
index b433764dd36d..6edf9a211f11 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1049,8 +1049,18 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
@@ -1079,6 +1089,7 @@ pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 
 	return type;
 }
+EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
 
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index ce0f163e1600..2efbcbcecd67 100644
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
@@ -46,6 +85,8 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev);
 #else /* CONFIG_PCI_P2PDMA */
 static inline int pcim_p2pdma_init(struct pci_dev *pdev)
 {
@@ -111,6 +152,11 @@ static inline ssize_t pci_p2pdma_enable_show(char *page,
 {
 	return sprintf(page, "none\n");
 }
+static inline enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
+{
+	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+}
 #endif /* CONFIG_PCI_P2PDMA */
 
 
@@ -125,45 +171,6 @@ static inline struct pci_dev *pci_p2pmem_find(struct device *client)
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


