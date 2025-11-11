Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68230CD13D2
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51248E0018; Tue, 11 Nov 2025 04:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA3A8E0002; Tue, 11 Nov 2025 04:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8878E0018; Tue, 11 Nov 2025 04:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B31E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62EF51604C1
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:16 +0000 (UTC)
X-FDA: 84097875792.07.4CD48EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 95D452000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sxF/BlUi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855094; a=rsa-sha256;
	cv=none;
	b=4vIqmNfEdwlUmP/fVHO6u4ld7hP9eOfNsckbSYeZqH2KEL/ybGeBHhOEcvEVj+vPkXb1S+
	V1EGCs2UR612bUKayAN5nFuJQwJtPN2OgkNlY8ka6nq0XIvXGOQJc4QfRQQZYroQe5T/c2
	GNqcNYwKt2eB2bHzcHEj6M/DqM+3q9U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sxF/BlUi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+3n7XSVn7sNxPilS+/nNUe+tO5LojdQ1A2SRjY4DAs=;
	b=honjEe6N5tV0oRzTt/czun0lw2mq0q1jCsS4ZgiNWZjzmc5/Y3UvVnsdvSdlijoQd7YEif
	etNuAvGw6V45Rco2B8Vpg79EJQKzrrOehgEYfklXmf/8O1yJfyW2ym8xVdT51S2TH/Lavb
	T34r3kJEXwP8ll1qt+A3aGqMNwCIkdA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2BD5438A9;
	Tue, 11 Nov 2025 09:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9581C16AAE;
	Tue, 11 Nov 2025 09:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855093;
	bh=YOBmH6S//DXRu4PTlrpxk+MAeoPk3c+z1pImIBy97r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxF/BlUivcSgr0UchrQD3NZN1NzryVj5D57TDLX72j3ciB3zj/Xy+30+IAm0H/6Q/
	 Dpyo2TmjhympRfJ5TvKMDboucvHqZTUkhLHXswJIKgVFECqhXPVLleep1daNCPATXs
	 lMatmLw0lvWIGEV/SPAM8NeArV8A9YN2Ymmia800JXWD3RhTPM3dFPyTNcNmJrrZk7
	 rW9cSj158cD7kXuvrb3rGnyKRbbbtprLWy20nUtQ58NCKgWrLxWr8aiTJi8XMI6tkW
	 nI1q+hxk04HWQVsLSkZtuzeGfmSfaGBLOoii7kNPzO5/a+SU9P2RA9fZjype3pNoam
	 IzvbUGNsmBNWw==
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
Subject: [PATCH v8 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
Date: Tue, 11 Nov 2025 11:57:46 +0200
Message-ID: <20251111-dmabuf-vfio-v8-4-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95D452000F
X-Stat-Signature: t83sfkce8gtoymk7wyn1fwpazf6soahm
X-HE-Tag: 1762855094-821058
X-HE-Meta: U2FsdGVkX1/4LBUwJTXRKhN4KYST3AhW4wwwvauluVf0Ftharr0363Nj6jXWFLap8f1TFC+YCg75RbvH1FjmlKbYCEqWrT5jTt+c7aruXxYW8GudrhfaPdk7WgutO7MM7R+FiCnWxK8HIMDBKPvr0DRFbDAOoa95NwW+ghO3cuCSOc+mYqOK0Iq/t3KskDVgDZW5xc1AHZ5+MNE969JbQ46M4qsoKFYQZeSq+BwMGIFUmF3WpSdbTZd8mzJshWoClc/aM8JsKBDwzYqfRvNLt9MK42esMIhJP5M+91r2qTyY7zn2FcHljzTKVFLB90zrjySGBQtvMLeDx/ialFgnIZzOan0ccmMXAFyIIwFdTxqBJmVREaXZYaqXTPbT+vz9YvAfWqo0CH88PxqXyXGizW9MssSO4RAAx7vujMFAziWxzyfOdR3lQan8Z4mYNjkbRFu4yI4T1tCjQD+YHQkTbkVQoZvaZWteEa3P5oV+BDkkPws61MEIF8+z5ERmPwAQ4Lqs3RiY02++pJQaN/7A92lWav6lfDNmDdmuDbO5wHmFi4g8sdsY0h22me9dQPeVcAtUsg/1X8WokA2fW+hhSR3/tneoo8h/koJV+29+tUKZCfuTl5+78Ymrtc9OJBSR3NtHygheZz0nkNK7LNsafLTfzCUUD0yi4/y3H6RLMYmLHPzsBp48dScROBWNsslsgm3o6sxe3gqpAiL8NqcLnNNVZpdRkmWQV5/k7IuURE9pce1RR6iOgEaUdvTGMFmwVuiwI2xjzdEmZd0ItU1cff4VhNaFcVDxFRglCHRfQXyArqwPx+wzC56nCsBKkIOSrcwTLyOGFrS+viT2RabSWN6QLq+tjrYzYxUuYJaL378ssQ8uQRrIUheM3tY/7JYKwPl0HZjk951Npt9SSCvTvvpEa6sfWq1+J8M3TVj3TUsdn8O/eHH4/XhqV/hwghuz19PR0OZZCbWQboQsII+
 lADZakRF
 RVmCpTCm8yFnZD2PSr83sTffedlMfM3vaIZcMHiHECZipEW2F73RrzuLRaIUBMUf7q8mzGkZPqA5Hjp1TnMwuiLScXVjaTGDcqOfITCuzNI1YKGw7ZbhySOarbzPlxg6ijO6XbRhHt32T+JmI5vpVjGNMZUfCNTvtXi9tmzhwySdJE+2KbTMWfXBgfA7M5Xp+R05VAIQJ1W7DHIM88zbIqM01CHZtXwKi8GhzyEFx4IJqk0t68hxpR1sKfTJwJVNuIHy+4wjzDepqusb2sDbLAzr0XwA/IWh1RJ1cuVcX3RcP6uJQlIZBVFYqx8UivxqnytBuiFWFBj+sUmtjC2UTJCxD2cqnVm1APX4yH2hzt2I9Ja7uh/2AVI7pBXqrpr1ccdCtl+0cWoReD6k=
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


