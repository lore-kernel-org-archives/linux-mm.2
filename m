Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF38606A33D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IBGeydsA
Received: by kanga.kvack.org (Postfix)
	id 5E1CD6B05C0; Wed,  4 Nov 2026 11:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592086B05C1; Wed,  4 Nov 2026 11:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432D56B05C2; Wed,  4 Nov 2026 11:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1340C6B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:48:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83E50A84C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:48:19 +0000 (UTC)
X-FDA: 85398019518.17.EC038AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B8E594000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:48:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBGeydsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wp4OrTiwenmqlPziYX6n9mBW2tsSmcV548D5rvQG8BU=;
	b=dU0FyH6a0umFSzLA9aqGBStwdXqArncTNVGIo+YURGAAfOSxr13Ef7nAdu4oTo4TUati2o
	VWpcnYhGianN3SzHvXSMixIGuj3jJP7cWrTfmWq5LIYmrVBS0n+Iy8N2y+5IRrmVpRFppt
	7Xy7S0A47G1xvbmHu7QGX3ia3f/vmIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810897;
	b=aA2KYh2g2DqjI09xdpVE11tIgcMN6utsjbCDlP86bYl0EYZHoUdGF4q7Fsl3RnEDZBl9Bc
	eqJmp81BTIMYDbbExetCV3WIu8g0X6x7Za8uGusIoAe49gvfVEnBY5Y75SzzM3wUu6F++B
	6wMT1HAP8xspmCyycq5dc0GgP5+tBzo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBGeydsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42A8E6022B;
	Wed,  4 Nov 2026 16:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286F91F00919;
	Wed,  4 Nov 2026 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810897;
	bh=wp4OrTiwenmqlPziYX6n9mBW2tsSmcV548D5rvQG8BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBGeydsAsVK+CMsgYqfGsxQizErebS255AkK4ZPvraHYzL9M1O6rKlPle2PINo0Gy
	 wp0Npc+uLyFCzIsrCGVVbjqIOqADwMBrHIjcbPg+UsY9i26u/6AVtM96xZGBLUF8wF
	 Wd98bccdR4UKdwtRyVK8A8MD9OK00fEf/dpHVtKdoVewyHtlCSWmhsoxnSecH9X6hn
	 byISzou0h3FIytXKfAizQauVP/TgeoPgMiBjzpalrI8UjmiudF0FGezj3NVgUL8v9h
	 /8pbPqtrmgLI6GdBqBj9MiFrSdoi25nBQjXRuP1FGbvytCdPwRZJCOB4l8HP7n/GuX
	 wPKSoB77E426Q==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v9 05/14] dma-contiguous: Derive shared alignment from DMA attributes
Date: Wed,  4 Nov 2026 22:15:46 +0530
Message-ID: <20261104164555.3555725-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hsuzebuse8nmwtunbfaugggh8gbz731j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8E594000E
X-HE-Tag: 1793810897-344762
X-HE-Meta: U2FsdGVkX18faoYiYZdZWw9TxUOCAqmCw6xtdu5LOytx7V36LQMKPItlta2J7Byc1uEMxdeDr+IqE0Yx736FXZTTgSDNyN4QgS1yMIMMsp2Bb/BoAJBgNSbfskAosfhZdI7Hk67kmIwLMZW7ZhBU5UqiRNe5V1Mnt0IoV+8g8RQCQ4picTm+w0+Iwia9u59al5fw6m462GZRmzkFo3oPObKSnI7SKM1nt/j1cDSb68M21co8de2yPBVZT8jU2Lbk/flCA2jn85ea5bFbSRFqJpstA8EG080JLz9E6Xe+GbfWGHY+JfaDnxkQkrMfdQjZ2whz8xdVzVPMjZir1+P+heRP7jFjU9AcannQHBHOjNayL+KhsUR1EiOTt+GaZehw1M3ddTMqao0/3ewZ1wjxpNBCyfMpIVyqpvodUgfU/h/UnqSFaimb9BADdyMnlbcX+dXLY/Hv9V8U/17pDPMQ0qs6vMWtvvJ0BNvf+r0afVwpAyqQ1YcdehFJZqNbAXjbhBFNuBtzxVCc7bK2e1Dd5wVWgIzj17VkPRXZ+NHdmhoMKCrKnk5q5ZWxaXcK9EGeMuGtyxOe0qAd3qUqgG8nshtQQ0zTnRuSiEISnMMtLa2sOqF4PBCcxr7Z4el7vDlE92G42mPmTNVpy3ZbAykMjj9GoDJVIs7ORoDJRePkNm/L2vfgwpjzhJ637SWBRQgtMSw+N60kNdr18gFOZsIitZHBVbyjgh/HIJP0qsIoXGekBka8MzUYJtx9P6G4B5Vwi/ReBcxoxF8SBSPnEmIgDtAPVhwZXrfCaZ82UzrTV70rknjS/qt03iRNxm0/o3Eu68t7BRI+zf3JRaPP0MRV6BO7J1dKZRdgaoJGzMWJXZFcf4aXTctc3ckeZ8I2/Meo5NDcwoD3e08Ssj/kTGp1aKXLuBZFdsL815cMPU6EkgDNex1706Krvq3u59fbkknq5SiUUmYLeJc1MR+GxPl
 4TSlbJfb
 585iYF27kvBdh1qKPe1QMokbxgFBmNxwJ0cRYgILNwiNoASeOskSXfX4rUIHNZznOM5oy4tAoG7r58vBiTJAIrF1WfA5JPpJ312wsCd+DmfN6lQ41QPldJyaJQdHOgXvORWF44rbfduJ1Miw9Q93dx3fRCc+W1BwNrrkOOtDcUBzjezozuWUHmlF55zN3JoKYhhf8j3wll21b4YddY03L/YsAvEJIrNB72qdMf52MZL8Oe0PfkrJ1Yzz2Igh7LXOyU6hweslBvjvoc1DUUQcZnEy5OAy+/+AY02oMqxYqztO2K8iT5UdB6lv+qh+gyhA8pxjSasZvP4aO1I9fROxNDnUUuRcs0LKK/FBkIti7Syt5+2DhMtupWRvXR4RmV5iHz34kf2wV6DubBO3pnUdxaulN8o2GG5fRsLNFZtDaYGgB1PrQeUi7HTce9KDRowRDrC/l19QUnKqgJt68bxXFCrYWw5Dgk3IVNsW73wOJRUokG5HuKBD0cLWRh/I0Cv4oqzfDgYAabn/HM24VN+dXi7W2gIltoVvoK0OWYzLDyfFPFORPoCLoyNliVzCG3BUUwNgDsqOjyyZ7UeMl2VPrZ6YW51X5BMphVNUR0EmNPFp3mMbtayqXLjBjAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Confidential-computing shared DMA allocations require CMA backing memory
to be aligned to the architecture shared-memory granule. Passing explicit
alignment orders through the DMA allocation stack exposes this derived
constraint to callers and requires separate preferred and mandatory values.

The DMA core already records whether an allocation needs shared backing in
__DMA_ATTR_ALLOC_CC_SHARED. Pass allocation attributes to the DMA-contiguous
entry points and derive the mandatory alignment there before calling CMA.
Preserve the existing alignment clamping for ordinary allocations, while
rejecting shared allocations whose granule exceeds CONFIG_CMA_ALIGNMENT so
callers can fall back to the page allocator.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm/mm/dma-mapping.c   |  5 +++--
 drivers/iommu/dma-iommu.c   |  2 +-
 include/linux/dma-map-ops.h |  9 ++++----
 kernel/dma/contiguous.c     | 41 +++++++++++++++++++++++++++----------
 kernel/dma/direct.c         |  2 +-
 kernel/dma/ops_helpers.c    |  2 +-
 kernel/dma/pool.c           |  2 +-
 kernel/kexec_file.c         |  3 ++-
 8 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index fb2eb0ed7bb8..22888880b832 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -398,7 +398,8 @@ static void *__alloc_from_contiguous(struct device *dev, size_t size,
 	struct page *page;
 	void *ptr = NULL;
 
-	page = dma_alloc_from_contiguous(dev, count, order, gfp & __GFP_NOWARN);
+	page = dma_alloc_from_contiguous(dev, count, order, 0,
+					 gfp & __GFP_NOWARN);
 	if (!page)
 		return NULL;
 
@@ -866,7 +867,7 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 		unsigned long order = get_order(size);
 		struct page *page;
 
-		page = dma_alloc_from_contiguous(dev, count, order,
+		page = dma_alloc_from_contiguous(dev, count, order, 0,
 						 gfp & __GFP_NOWARN);
 		if (!page)
 			goto error;
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 78742aeba932..2d2781910740 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1646,7 +1646,7 @@ static void *iommu_dma_alloc_pages(struct device *dev, size_t size,
 	struct page *page = NULL;
 	void *cpu_addr;
 
-	page = dma_alloc_contiguous(dev, alloc_size, gfp);
+	page = dma_alloc_contiguous(dev, alloc_size, gfp, 0);
 	if (!page) {
 		cpu_addr = alloc_pages_exact_nid(node, alloc_size, gfp);
 		if (!cpu_addr)
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index afaf2c12189b..7a83942a10f3 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -99,10 +99,11 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
 
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int order, bool no_warn);
+		unsigned int order, unsigned long attrs, bool no_warn);
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
-struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp);
+struct page *dma_alloc_contiguous(struct device *dev, size_t size,
+				  gfp_t gfp, unsigned long attrs);
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size);
 
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
@@ -125,7 +126,7 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
 	return -ENOSYS;
 }
 static inline struct page *dma_alloc_from_contiguous(struct device *dev,
-		size_t count, unsigned int order, bool no_warn)
+		size_t count, unsigned int order, unsigned long attrs, bool no_warn)
 {
 	return NULL;
 }
@@ -136,7 +137,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
 }
 /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
 static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
-		gfp_t gfp)
+		gfp_t gfp, unsigned long attrs)
 {
 	return NULL;
 }
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627..e593ecbc64f4 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -39,6 +39,7 @@
 
 #include <asm/page.h>
 
+#include <linux/cc_shared.h>
 #include <linux/memblock.h>
 #include <linux/err.h>
 #include <linux/sizes.h>
@@ -357,19 +358,29 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
  * dma_alloc_from_contiguous() - allocate pages from contiguous area
  * @dev:   Pointer to device for which the allocation is performed.
  * @count: Requested number of pages.
- * @align: Requested alignment of pages (in PAGE_SIZE order).
+ * @align: Preferred alignment of pages (in PAGE_SIZE order).
+ * @attrs: DMA allocation attributes.
  * @no_warn: Avoid printing message about failed allocation.
  *
  * This function allocates memory buffer for specified device. It uses
  * device specific contiguous memory area if available or the default
  * global one. Requires architecture specific dev_get_cma_area() helper
  * function.
+ *
+ * The preferred alignment is capped at CONFIG_CMA_ALIGNMENT. The internal
+ * shared-allocation attribute requires at least the architecture shared
+ * granule alignment and fails if that exceeds the CMA alignment limit.
  */
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int align, bool no_warn)
+		unsigned int align, unsigned long attrs, bool no_warn)
 {
-	if (align > CONFIG_CMA_ALIGNMENT)
-		align = CONFIG_CMA_ALIGNMENT;
+	unsigned int required_align = 0;
+
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
+		required_align = get_order(cc_shared_granule_size());
+	if (required_align > CONFIG_CMA_ALIGNMENT)
+		return NULL;
+	align = min(max(align, required_align), CONFIG_CMA_ALIGNMENT);
 
 	return cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
 }
@@ -390,10 +401,9 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 	return cma_release(dev_get_cma_area(dev), pages, count);
 }
 
-static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
+static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp,
+				      unsigned int align)
 {
-	unsigned int align = min(get_order(size), CONFIG_CMA_ALIGNMENT);
-
 	return cma_alloc(cma, size >> PAGE_SHIFT, align, gfp & __GFP_NOWARN);
 }
 
@@ -402,6 +412,7 @@ static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
  * @dev:   Pointer to device for which the allocation is performed.
  * @size:  Requested allocation size.
  * @gfp:   Allocation flags.
+ * @attrs: DMA allocation attributes.
  *
  * tries to use device specific contiguous memory area if available, or it
  * tries to use per-numa cma, if the allocation fails, it will fallback to
@@ -412,8 +423,11 @@ static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
  * there is no need to waste CMA pages for that kind; it also helps reduce
  * fragmentations.
  */
-struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
+struct page *dma_alloc_contiguous(struct device *dev, size_t size,
+				  gfp_t gfp, unsigned long attrs)
 {
+	unsigned int required_align = 0;
+	unsigned int align = get_order(size);
 #ifdef CONFIG_DMA_NUMA_CMA
 	int nid = dev_to_node(dev);
 #endif
@@ -421,8 +435,13 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 	/* CMA can be used only in the context which permits sleeping */
 	if (!gfpflags_allow_blocking(gfp))
 		return NULL;
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
+		required_align = get_order(cc_shared_granule_size());
+	if (required_align > CONFIG_CMA_ALIGNMENT)
+		return NULL;
+	align = min(max(align, required_align), CONFIG_CMA_ALIGNMENT);
 	if (dev->cma_area)
-		return cma_alloc_aligned(dev->cma_area, size, gfp);
+		return cma_alloc_aligned(dev->cma_area, size, gfp, align);
 	if (size <= PAGE_SIZE)
 		return NULL;
 
@@ -431,7 +450,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 		struct cma *cma = dma_contiguous_numa_area[nid];
 		struct page *page;
 		if (cma) {
-			page = cma_alloc_aligned(cma, size, gfp);
+			page = cma_alloc_aligned(cma, size, gfp, align);
 			if (page)
 				return page;
 		}
@@ -440,7 +459,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 	if (!dma_contiguous_default_area)
 		return NULL;
 
-	return cma_alloc_aligned(dma_contiguous_default_area, size, gfp);
+	return cma_alloc_aligned(dma_contiguous_default_area, size, gfp, align);
 }
 
 /**
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 596c90e8f890..7e71f96b6ffd 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -125,7 +125,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp);
+	page = dma_alloc_contiguous(dev, size, gfp, 0);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 5cdf3f60cf47..11453e5ee0d3 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -66,7 +66,7 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	phys_addr_t phys;
 
-	page = dma_alloc_contiguous(dev, size, gfp);
+	page = dma_alloc_contiguous(dev, size, gfp, 0);
 	if (!page) {
 		void *va = alloc_pages_exact_nid(dev_to_node(dev), size, gfp);
 
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 00f422a1e896..70b7f64b17ab 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -99,7 +99,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 		pool_size = 1 << (PAGE_SHIFT + order);
 		if (cma_in_zone(gfp))
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
-							 order, false);
+							 order, 0, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
 	} while (!page && order-- > 0);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index b668ce8d68ee..5bcba818f046 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -702,7 +702,8 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return -EPERM;
 
-	p = dma_alloc_from_contiguous(NULL, nr_pages, get_order(kbuf->buf_align), true);
+	p = dma_alloc_from_contiguous(NULL, nr_pages,
+				      get_order(kbuf->buf_align), 0, true);
 	if (!p)
 		return -ENOMEM;
 
-- 
2.43.0


