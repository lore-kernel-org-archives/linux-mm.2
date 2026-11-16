Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40394606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XvXzC9G/
Received: by kanga.kvack.org (Postfix)
	id 58E626B05BD; Mon, 16 Nov 2026 04:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565E66B05BE; Mon, 16 Nov 2026 04:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47DE66B05BF; Mon, 16 Nov 2026 04:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E0E6B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:13:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAE058059D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:13:31 +0000 (UTC)
X-FDA: 85440419022.19.E37A7E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1465740003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:13:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XvXzC9G/";
	spf=pass (imf07.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wp4OrTiwenmqlPziYX6n9mBW2tsSmcV548D5rvQG8BU=;
	b=uzFKVzk0zMm1KKOpnZDR5xJMa2LD3YvyVvIGOLCDEX4C7qUzp8w44gZGIhFyVGsSIOkxuP
	sZa062OZQJfaQYS9kxrzIto5UTb8HLkfXDQXC8d1ouEod2REiPS9RmhzpJxQ+xfM3KIYGN
	/ysc0YbWmLcfjihgI5AfCL2SKMYNBvg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820410;
	b=pmwgiBnJ51mbh8XI0EihH/kX0UC/2t82TVMw/ELARZkx4rq7r4L7V/gG6slquegIPmfPXA
	oyAIM6VzhVUkzoZJhACcWhs/gl6KHNQS4oIbEDHG5UiJq65VL3djX7YoGy1tKFTOQB1nBH
	GvY5rUpkPfKWo3+vBlSY4Wn4gtNtK78=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XvXzC9G/";
	spf=pass (imf07.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D1E160E05;
	Mon, 16 Nov 2026 09:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DD91F000C4;
	Mon, 16 Nov 2026 09:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820409;
	bh=wp4OrTiwenmqlPziYX6n9mBW2tsSmcV548D5rvQG8BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvXzC9G/jiuBYWUAixkir74C1Q4yp5X/dt24tJRLFbDKbpmIyiD13Jpqo6GUIIpN8
	 kV3CWvckkgquOOFKpeIv/4DOarMyUv6kC94y3gzZHl/MZXs5IufRfOizd2ZeH/FF6D
	 4/G8zyURxbFOxk9lQf3/r1C8MJqUYzj1PjTmBxqinPDgTduKhOiso1GBXqo61oXO91
	 34Qgd0Hf0jv4tIJXRlJPoUA+NUDaxoWoCcxyU9H897oKK3kjrnWmZ3dTvoHDprP0jP
	 xD0fmzGlEvWYxgV6C+jIWfD1we21vWRgLxrqJDILrR725d/R0IQOydFrYxUOWVTnKi
	 7V3WoExu8G3MQ==
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
Subject: [PATCH v10 05/13] dma-contiguous: Derive shared alignment from DMA attributes
Date: Mon, 16 Nov 2026 14:41:28 +0530
Message-ID: <20261116091137.94252-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1rxeqii5ptz6k9cf3573htws7kqtoh8w
X-Rspamd-Queue-Id: 1465740003
X-Rspam-User: 
X-HE-Tag: 1794820409-684205
X-HE-Meta: U2FsdGVkX1//rQY42dDSJKLw/ecu7/Jk1lLt2x8spH0zK6ycrZI1XrmFxJHW4xx/x0GHtNHFA4XF/i8xsqjw4AXHsIk5OVCqi4Osi/JBxFdAImjn7/9N3RWiRLkofjajetOznpv6uU2V0yEvf89AuO7o2Pq6ZA01C/oemmzgVn7MvJ4Zr/gxk13jG3Ac6z8oNzsbHC47NWvXYs1jE+AZMXH3u+s3YmKekNlRYX13OAUMDwkFfZBs59gy29r+e//YLKwiUtpKNckbkTmuDmCsYcM9vT/3L9wx1W7uRPKS/GzYUjF6EQ8K2bFd97Q64J2bJ0dB0XPvmwtVmLoWmRVkQIi4j+QuBiC+jEmC3CHEwcdOhzK2odR4kU0FmT05ImZMzRf9aJQXLA1/5YbUN0kTXFtqLfQD64JcOl2QZrnj0p0rzZ3SasmqEOQqcC2fn6xenXNQ78/b3VrY46wtHXb5hPnVPtAmSTsk67k4I93/9i61YMMFInAwyRApmcm5EtbRWCnV4yNktUEcdzONRCapvEHBKBRmY2VRr+HoFYI20dFCe9UtNEJ6iTtEEZyMi4P0CKkbIGDEaKSqlwfRtARLFLtVfOwUin4vT9c2D9cPN8tEVwoMMl7PgN9xtaLrI2qA/K643pWOJ4LgZj89YbElY1hmBHbQu1myyNXoNdUU6esODNcw0Fmr/MYv6/yurTN7XV+l+0jUPTmdHocRS+Ne1yKdZdJ2sY4yUrojF5nKCFGxKgaZXpz7hyP9wmzvP2+BeVM77f5ti3G3eZRX+v296g5T5tFgGSiOzSqlgQhUq0taoo6PjelRwmPZRH/1q3+Cd0SPcqYNFGwh3MbOKQWiSHP5A5CUma6JFrjvnWUyo0ZJQ8oG1OC1tzRjgihTRU/dQrLMUsBfQblF+tIzl4WHt4Be4ulhKh10wqCzTO0WkG1B/ErfKS+es3bcXmMFZ+vdtj3BUuBt9F46nq0p0P1
 r2AJEtFF
 2dJxDn9eIGMJadPDNgrxdk+QxCmIziUoPWYoPeb8AAHIiSdJO6bmN8C7LrTavh5kCFeDsIC77oOPHltO/pQhENVCp7ZMZd4UydcpJuJWv3buZ5Gdc8TkFYQ9JzAfJMUvfwvOPnjz3xRgXy2ogTf6FzI8oT9B863sKuiAQ6qM47Ge+5KbRc7c+E+7F9/iN7PSX4jpCvHQHTMuelziScOIfanWExTqiQbWfQIutFNjzzvzhV8whDfCkmCWEwJTftbbf0WCYAjkdikbJ8uYU4zpcsfvfv09nG/KYoHGiSw6NgY7gQJvvk0YqlBaveqlbAaDbF3Szq/l/WOfIUXSqfD/lWXy31yvwMs7VTKQjONZ93QDDBEc68wCp6kq6kWkACLEhkB3K0RwloHfIfGsahVNHijWf8qz/17dfymOEMYrBcLuzGWF73R+wd6x5mrB4gS/vskxiAWriLwQa0H188ysM14cvkbxaHw3W/DU9SpFBjC6gBvO39dXuvgUsrYqx+lK6c7JxCHPO4p44wf1/hR8oFOKbKHguvWozZnAszdMVtMhGZmixsRH72PztA4n6/qJ+eFCwPIZCMtmBWjjZFO7MPomeNxCdZuXTAZtBo8PqY9sPwL1DMTbzGgxtBawvojPNa1QScyt1idFU0oQikpbgYTlDKrJptSrSTfXY4FIByzfJ/cvQgRrJnEREGnk2wvCQkgASZdPKpu0IGyt/EjUnADo9UrY7iYPESD4u7tFb2pLMDrU=
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


