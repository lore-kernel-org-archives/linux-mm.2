Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00536CF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C5B6B00A5; Thu, 20 Nov 2025 04:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601826B00A6; Thu, 20 Nov 2025 04:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA446B00A7; Thu, 20 Nov 2025 04:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF9A6B00A5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1ABBB12FEB8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:10 +0000 (UTC)
X-FDA: 84130461660.01.901F2EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2DB08140007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vLI/mn3P";
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exnBQwIc9q/WEVMWo1HAc37OoF6nAMHj8M02iCZMQMM=;
	b=E0+wfviRcwV0AKXeYYZjrUl7LfGY8bIsQvPSNTEz4iIJmNTEsEBnLBDhTWvR512GndBEgI
	E9eXBX1zMGMyht1Ne05VKAlyKYCBe16ngep2M/4+D5P9+QHKMjGo3xfExR3JWszuKLI4Sb
	Qbws4YMgkFCoo9/SGS/odwV3aRrvqs0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vLI/mn3P";
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630948; a=rsa-sha256;
	cv=none;
	b=N5n21BtcynZ+8Tc5TrpXZ0EDkePvqahN/Zw+E9BPv9CPQx7mujuSDRtUbXSb7cIkUKn5s1
	bv7hGUMprsBerfNCJPTmnUwQoeb5RE7M9GtZsvQrRs+HmtTBPBGbjQkj8daimrxgwHHItr
	RazhrqKxzOVSzNz7J07og1EykEWZnGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E3DB44323;
	Thu, 20 Nov 2025 09:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652D7C4CEF1;
	Thu, 20 Nov 2025 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630947;
	bh=SBVsDvISjD+c62otlLRH6dDzRddJmgAzNE9wh5uZ6XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLI/mn3PVDt4Mrr0Gond+LEMimFwSJ68Nr0svvufIY6zPUhLf1QRsZlhT+GGMqKGe
	 GnhQe5QXyOivu9G90nfRxRhVV4v9SDNBfS8+qyXbjxQiDrKyBxbfFlGpqrALZRrsKp
	 KtD/PpGEr3BVYtuGHBeWA/lPubU05iTwZZw6qOGHsdqEjNrH1lIdkaXiqwnK12yNkh
	 eGyCGBETIPYPzV/Xq41Z461gSafrEB1scGOKg80UQbqYpTiBB1N6IzOne0JiJOSSVa
	 wpaIHLo4pN/w7W2CSItGNwoSPGimp+dHT98QR21fq0PJ73X4qo4f3hlFI4JgBi15Qy
	 TpiCbwwumkPZQ==
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
	Nicolin Chen <nicolinc@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather mapping routine
Date: Thu, 20 Nov 2025 11:28:25 +0200
Message-ID: <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2DB08140007
X-Stat-Signature: t4rk15mejtx3h348ectd7iicabwj5uke
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763630948-470714
X-HE-Meta: U2FsdGVkX19I9jmJZBlvcfF0qSDpnQ52jtxEMUjfmW9FjzJ5vIgzRiVCnd+6caSZPh7b15RwdlTsG7TOOMVdMICksZHEoMam9vQf1aoqIlFF0A4OZrpt10NZu75GwIDwZ/Jt0cehWRPOsACs2WlY4+TATJSogbUWroPC2veWe4fzsO+teFCU9Vy/593Caf+vbdQRCOzeo/T5MNm0UhgVIYSpjCyp30O/9K0msTXRUaLUXnqVDso20wILO61gEK+AJldLCM2VVOyZHUCpHZ5nzsglhNDUb2NJ8a6r0wG0Phw74ACH6KeuHXQB5EjnunvJwSdNlGCM/J1/T96Y/4ym7bhfjIHfEJBiBMRMn9PzmmB0tHqw4RrY7YQtyJN4SX76mjXB8HWcpN51l56sopfg1u6FJGQK2aOjUJQHY666Veeru29hvyLlZfpplZMD3moO8v3cUyvRSMi3uT6dg4YrhAfOYuKKoDmaKOve2fcqfsQGqhOO3twSGWR3wPbh9KriOBrZlBDvwMUtE2dvB75MoEh8kYS6WW2GiOuSbb57COv9LbA5hWq8gvZw03HILw+dduDbf/MPt5ZkS0MDsVO07eLrFAOlK8913LbIoTjCYL6/fQ0MVIM/EnZVYhHociic2fRWiN144txTbn1x8Hm3caNmdByfEGo+7JwvEvVBmCQSgAWuFYwsCrd2qvem4eRrFybcDJIPY4ojV6cliBwFbJ+CdM8XjNcYeiFZ9Y6tWpOmRa8PI4D4S9SXlnUlls2hsgCIOAB50ip94Z9wit/PY4GAy+EB+fKsRqidezvkzdvebaeTUZVnhpshXEVvvkIro1pUWS4zZNxGBFwIEdSfe0HSANeDFb+4MRfDTh6xB7y4p+hb1Hn04UyH+8YjxFH0Uh889jTul+JXIv02Yzjn/ordy1hBczewGTH6xfhJq6lIu9GW5JycWW2ZdYh0BhgdpYI57wl5iy68hi26nLl
 AMGPdPA0
 pbgPjJnSxhF5ZJtHjURd296E13dCpiYFF5OofM3kk+IwFTvn51xh5Yl5buct+Ro2PtLwSqfW/8a9TTGPOWhi5ljdkhao601RRKOifg63UL+dvipfKtINjcN6j5bLk1XdM47oXD3WEgtT4pvYZM40XfJXqbEAmukLNXX3fz9ReyYQqc5jH8h92rJRU1HeWtiXPMk+fJAJ5JRjSNsUnd8kAlcPEHVG2O6lj+4sQBIFCWWzuIhdmQbrXvlHcEwPcYm2zRPmbj3bCU9Id9iasadyXXdXGGalbzr+UhsECqUSj1czCQu/FPuDnyty7Gc/s0okMFzVH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Add dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt() helpers to convert
an array of MMIO physical address ranges into scatter-gather tables with
proper DMA mapping.

These common functions are a starting point and support any PCI
drivers creating mappings from their BAR's MMIO addresses. VFIO is one
case, as shortly will be RDMA. We can review existing DRM drivers to
refactor them separately. We hope this will evolve into routines to
help common DRM that include mixed CPU and MMIO mappings.

Compared to the dma_map_resource() abuse this implementation handles
the complicated PCI P2P scenarios properly, especially when an IOMMU
is enabled:

 - Direct bus address mapping without IOVA allocation for
   PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
   happens if the IOMMU is enabled but the PCIe switch ACS flags allow
   transactions to avoid the host bridge.

   Further, this handles the slightly obscure, case of MMIO with a
   phys_addr_t that is different from the physical BAR programming
   (bus offset). The phys_addr_t is converted to a dma_addr_t and
   accommodates this effect. This enables certain real systems to
   work, especially on ARM platforms.

 - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
   attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
   This happens when the IOMMU is enabled and the ACS flags are forcing
   all traffic to the IOMMU - ie for virtualization systems.

 - Cases where P2P is not supported through the host bridge/CPU. The
   P2P subsystem is the proper place to detect this and block it.

Helper functions fill_sg_entry() and calc_sg_nents() handle the
scatter-gather table construction, splitting large regions into
UINT_MAX-sized chunks to fit within sg->length field limits.

Since the physical address based DMA API forbids use of the CPU list
of the scatterlist this will produce a mangled scatterlist that has
a fully zero-length and NULL'd CPU list. The list is 0 length,
all the struct page pointers are NULL and zero sized. This is stronger
and more robust than the existing mangle_sg_table() technique. It is
a future project to migrate DMABUF as a subsystem away from using
scatterlist for this data structure.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/Makefile          |   2 +-
 drivers/dma-buf/dma-buf-mapping.c | 248 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   |  17 +++
 include/linux/dma-buf.h           |  11 ++
 4 files changed, 277 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index 70ec901edf2c..2008fb7481b3 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
-	 dma-fence-unwrap.o dma-resv.o
+	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
 obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
 obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
 obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
new file mode 100644
index 000000000000..de494bcac5e9
--- /dev/null
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * DMA BUF Mapping Helpers
+ *
+ */
+#include <linux/dma-buf-mapping.h>
+#include <linux/dma-resv.h>
+
+static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
+					 dma_addr_t addr)
+{
+	unsigned int len, nents;
+	int i;
+
+	nents = DIV_ROUND_UP(length, UINT_MAX);
+	for (i = 0; i < nents; i++) {
+		len = min_t(size_t, length, UINT_MAX);
+		length -= len;
+		/*
+		 * DMABUF abuses scatterlist to create a scatterlist
+		 * that does not have any CPU list, only the DMA list.
+		 * Always set the page related values to NULL to ensure
+		 * importers can't use it. The phys_addr based DMA API
+		 * does not require the CPU list for mapping or unmapping.
+		 */
+		sg_set_page(sgl, NULL, 0, 0);
+		sg_dma_address(sgl) = addr + i * UINT_MAX;
+		sg_dma_len(sgl) = len;
+		sgl = sg_next(sgl);
+	}
+
+	return sgl;
+}
+
+static unsigned int calc_sg_nents(struct dma_iova_state *state,
+				  struct dma_buf_phys_vec *phys_vec,
+				  size_t nr_ranges, size_t size)
+{
+	unsigned int nents = 0;
+	size_t i;
+
+	if (!state || !dma_use_iova(state)) {
+		for (i = 0; i < nr_ranges; i++)
+			nents += DIV_ROUND_UP(phys_vec[i].len, UINT_MAX);
+	} else {
+		/*
+		 * In IOVA case, there is only one SG entry which spans
+		 * for whole IOVA address space, but we need to make sure
+		 * that it fits sg->length, maybe we need more.
+		 */
+		nents = DIV_ROUND_UP(size, UINT_MAX);
+	}
+
+	return nents;
+}
+
+/**
+ * struct dma_buf_dma - holds DMA mapping information
+ * @sgt:    Scatter-gather table
+ * @state:  DMA IOVA state relevant in IOMMU-based DMA
+ * @size:   Total size of DMA transfer
+ */
+struct dma_buf_dma {
+	struct sg_table sgt;
+	struct dma_iova_state *state;
+	size_t size;
+};
+
+/**
+ * dma_buf_phys_vec_to_sgt - Returns the scatterlist table of the attachment
+ * from arrays of physical vectors. This funciton is intended for MMIO memory
+ * only.
+ * @attach:	[in]	attachment whose scatterlist is to be returned
+ * @provider:	[in]	p2pdma provider
+ * @phys_vec:	[in]	array of physical vectors
+ * @nr_ranges:	[in]	number of entries in phys_vec array
+ * @size:	[in]	total size of phys_vec
+ * @dir:	[in]	direction of DMA transfer
+ *
+ * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
+ * on error. May return -EINTR if it is interrupted by a signal.
+ *
+ * On success, the DMA addresses and lengths in the returned scatterlist are
+ * PAGE_SIZE aligned.
+ *
+ * A mapping must be unmapped by using dma_buf_free_sgt().
+ *
+ * NOTE: This function is intended for exporters. If direct traffic routing is
+ * mandatory exporter should call routing pci_p2pdma_map_type() before calling
+ * this function.
+ */
+struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
+					 struct p2pdma_provider *provider,
+					 struct dma_buf_phys_vec *phys_vec,
+					 size_t nr_ranges, size_t size,
+					 enum dma_data_direction dir)
+{
+	unsigned int nents, mapped_len = 0;
+	struct dma_buf_dma *dma;
+	struct scatterlist *sgl;
+	dma_addr_t addr;
+	size_t i;
+	int ret;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (WARN_ON(!attach || !attach->dmabuf || !provider))
+		/* This function is supposed to work on MMIO memory only */
+		return ERR_PTR(-EINVAL);
+
+	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return ERR_PTR(-ENOMEM);
+
+	switch (pci_p2pdma_map_type(provider, attach->dev)) {
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/*
+		 * There is no need in IOVA at all for this flow.
+		 */
+		break;
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
+		if (!dma->state) {
+			ret = -ENOMEM;
+			goto err_free_dma;
+		}
+
+		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_free_dma;
+	}
+
+	nents = calc_sg_nents(dma->state, phys_vec, nr_ranges, size);
+	ret = sg_alloc_table(&dma->sgt, nents, GFP_KERNEL | __GFP_ZERO);
+	if (ret)
+		goto err_free_state;
+
+	sgl = dma->sgt.sgl;
+
+	for (i = 0; i < nr_ranges; i++) {
+		if (!dma->state) {
+			addr = pci_p2pdma_bus_addr_map(provider,
+						       phys_vec[i].paddr);
+		} else if (dma_use_iova(dma->state)) {
+			ret = dma_iova_link(attach->dev, dma->state,
+					    phys_vec[i].paddr, 0,
+					    phys_vec[i].len, dir,
+					    DMA_ATTR_MMIO);
+			if (ret)
+				goto err_unmap_dma;
+
+			mapped_len += phys_vec[i].len;
+		} else {
+			addr = dma_map_phys(attach->dev, phys_vec[i].paddr,
+					    phys_vec[i].len, dir,
+					    DMA_ATTR_MMIO);
+			ret = dma_mapping_error(attach->dev, addr);
+			if (ret)
+				goto err_unmap_dma;
+		}
+
+		if (!dma->state || !dma_use_iova(dma->state))
+			sgl = fill_sg_entry(sgl, phys_vec[i].len, addr);
+	}
+
+	if (dma->state && dma_use_iova(dma->state)) {
+		WARN_ON_ONCE(mapped_len != size);
+		ret = dma_iova_sync(attach->dev, dma->state, 0, mapped_len);
+		if (ret)
+			goto err_unmap_dma;
+
+		sgl = fill_sg_entry(sgl, mapped_len, dma->state->addr);
+	}
+
+	dma->size = size;
+
+	/*
+	 * No CPU list included — set orig_nents = 0 so others can detect
+	 * this via SG table (use nents only).
+	 */
+	dma->sgt.orig_nents = 0;
+
+
+	/*
+	 * SGL must be NULL to indicate that SGL is the last one
+	 * and we allocated correct number of entries in sg_alloc_table()
+	 */
+	WARN_ON_ONCE(sgl);
+	return &dma->sgt;
+
+err_unmap_dma:
+	if (!i || !dma->state) {
+		; /* Do nothing */
+	} else if (dma_use_iova(dma->state)) {
+		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
+				 DMA_ATTR_MMIO);
+	} else {
+		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
+			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
+	}
+	sg_free_table(&dma->sgt);
+err_free_state:
+	kfree(dma->state);
+err_free_dma:
+	kfree(dma);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_phys_vec_to_sgt, "DMA_BUF");
+
+/**
+ * dma_buf_free_sgt- unmaps the buffer
+ * @attach:	[in]	attachment to unmap buffer from
+ * @sgt:	[in]	scatterlist info of the buffer to unmap
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * This unmaps a DMA mapping for @attached obtained
+ * by dma_buf_phys_vec_to_sgt().
+ */
+void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
+		      enum dma_data_direction dir)
+{
+	struct dma_buf_dma *dma = container_of(sgt, struct dma_buf_dma, sgt);
+	int i;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (!dma->state) {
+		; /* Do nothing */
+	} else if (dma_use_iova(dma->state)) {
+		dma_iova_destroy(attach->dev, dma->state, dma->size, dir,
+				 DMA_ATTR_MMIO);
+	} else {
+		struct scatterlist *sgl;
+
+		for_each_sgtable_dma_sg(sgt, sgl, i)
+			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
+	}
+
+	sg_free_table(sgt);
+	kfree(dma->state);
+	kfree(dma);
+
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_free_sgt, "DMA_BUF");
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
new file mode 100644
index 000000000000..a3c0ce2d3a42
--- /dev/null
+++ b/include/linux/dma-buf-mapping.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * DMA BUF Mapping Helpers
+ *
+ */
+#ifndef __DMA_BUF_MAPPING_H__
+#define __DMA_BUF_MAPPING_H__
+#include <linux/dma-buf.h>
+
+struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
+					 struct p2pdma_provider *provider,
+					 struct dma_buf_phys_vec *phys_vec,
+					 size_t nr_ranges, size_t size,
+					 enum dma_data_direction dir);
+void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
+		      enum dma_data_direction dir);
+#endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d58e329ac0e7..0bc492090237 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/dma-fence.h>
 #include <linux/wait.h>
+#include <linux/pci-p2pdma.h>
 
 struct device;
 struct dma_buf;
@@ -530,6 +531,16 @@ struct dma_buf_export_info {
 	void *priv;
 };
 
+/**
+ * struct dma_buf_phys_vec - describe continuous chunk of memory
+ * @paddr:   physical address of that chunk
+ * @len:     Length of this chunk
+ */
+struct dma_buf_phys_vec {
+	phys_addr_t paddr;
+	size_t len;
+};
+
 /**
  * DEFINE_DMA_BUF_EXPORT_INFO - helper macro for exporters
  * @name: export-info name

-- 
2.51.1


