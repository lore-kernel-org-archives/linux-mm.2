Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E06EC0495
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23B46B00BB; Tue,  3 Mar 2026 05:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5056B00BE; Tue,  3 Mar 2026 05:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14576B00BB; Tue,  3 Mar 2026 05:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D24396B00BB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85C2F1B7849
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:22 +0000 (UTC)
X-FDA: 84504339444.21.251D59F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D07364000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2d7GSce;
	spf=pass (imf01.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paV7n9c+N+qzdogC44rA30Lt5UWfLapqVbmXQ++vrPg=;
	b=XyFXCxFVNazjnEx/Qva63qqgZegiZYgLqmDdh4X+iEAnZjdGH/yxAAJxXfvTTXItY1gGTD
	VnbXCZIVdgibCXRmYVrZf75Zo4WbWBCX4fqEjoiBYB/J17/xbo27fEGG7WIcM64D8XyrBI
	YQ7piTPPDqE5T0ExoomvIgu6bkoZhno=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2d7GSce;
	spf=pass (imf01.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532800; a=rsa-sha256;
	cv=none;
	b=72A/rk6J5seeBShkvyRDM9eobO3b/n7AMzLgRriyXxZjjw9Xuoi5AEmw37y324zk3LcY5X
	fyCHZPOJFkwoprWU1ju1JXajgvYDWDJ9B8iFYtmYYcobyg4xZiQRB2WKLYNVBe2IfA0UL+
	fdqQcUv/VfUhK8viauwBNrdqZ3nIuEw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2017860053;
	Tue,  3 Mar 2026 10:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B84C2BC87;
	Tue,  3 Mar 2026 10:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532799;
	bh=9Km9m0AXCUr/a6vgKJn4EecEuoKphraVZQe3lTzETlY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=D2d7GSceo2GvP+dNzIPEP4ShcHqDj1mZkp1iu8UOhrVMZYMWVxIbp/uP0T8ZscKi3
	 lngmQRRXkWN8GJJy1USDTQDtf4yW1r8QgxmoRtmMSaYOPXIKSFgss9LpbTJ5Yg0rTD
	 pNTx7dsao1Ox1bbzxWwaJFwXR2f3AKEmTvFHdc9JfPH9cX9guJskLgK3FnAMbA7p9C
	 EA+gvFd7dwRHQPOsaXjGXpS9PunNElnwDCZOjYjLtxqiFDzE9tvzEs8KsmR2jjLyQK
	 tksUQmnOgbG8ky7g+hY6Zy0WOGt9+MUFsBzRcYsYcsHPadDecoBXGFN1M7kuPi5ISq
	 H3NYMxITNv3dw==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:04 +0100
Subject: [PATCH v3 1/8] dma: contiguous: Turn heap registration logic
 around
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-1-24344812c707@kernel.org>
References: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
In-Reply-To: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5204; i=mripard@kernel.org;
 h=from:subject:message-id; bh=9Km9m0AXCUr/a6vgKJn4EecEuoKphraVZQe3lTzETlY=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtphcSmn/y3jh6D3phd9vaE3RX6ltOKNy1+XtUx2OB
 Tzt5GRt7JjKwiDMySArpsjyRCbs9PL2xVUO9it/wMxhZQIZwsDFKQATYVFnbGj5sJbFUM67h2PH
 hA7JXQ4z0h+aWR8X9knqjfgoICOf3Rd59O4CUxXT8//n/nUI+bH5HGOdAscG6Q8rXDcVixxdFl+
 rmbC/wcZwQ/9q8xWqW1wND084VFlcvqCpM9r12sRjkvc+M2sBAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Queue-Id: D07364000A
X-Rspamd-Server: rspam07
X-Stat-Signature: bsub9eue3ecc8xeb7o55xtpfgekm639q
X-Rspam-User: 
X-HE-Tag: 1772532800-161336
X-HE-Meta: U2FsdGVkX18d58jOGG2/sSSjf/Kj5gKeVg7iIBgY6YnWyzeCP3FespdPE6lY3mxhqJbN+FaQmqWBCiDylZKgDpZX0WyQeuNMesN2ihggF+ea3wJY1//QU0aetoSxomfP/uRB/9v5cn+r7cNix9dp0WFFOqW/5IMYWpwz9UZgYmSoveCwWEZbz7UWNRh5NsXtN6v/Wm09VSidmayV/SupNzej8VVz1XO7CElXWiq23P+tgHlKbZalO6TOo2EkputkfIkccf215Er2dRNK5jHYEZvEo/nZbD9TkvqMbcJjhdh/cv+FJBwpbGddYpYcThrr6Dzjgf9t9VcTHwdJp9Ax6X6lVABUr5Vtjxf/6f3CCOD3ihDh614IHgaRkjtWpONeH8+mwUG4LURbpeoLs0firyKLQgsQk06ziMi3+kgpILZ/bJ/BjcdSbkRRDHSn54loyyaMNxZJCPQeL6To1pOCN1kyL0MTs+R0+142qK7NTAwG0uw0WCjp4+z7BKQ3VO6cBRbGhG3jAh1dE97SqJEArwiL2wDQFC/g77UsQV2L636dezWWtaUpKZ/n8WjLdONGOTmAGOHCl9L/2F08TbtaqgCmOy+RsIH+h0vMq6A/CuKrOm53odlzIN0kgUvncrUFluDtsMgglTO50XeIOrib7EGu/fnd4oYs8LsvjcJVIB+lp79dOhj4etCoRpoLGPCiSkxM0Vl4IHRYkAcGPLT04eK87kGE8WF9Zh/9sn2H0anccsS18nCgMVbDTJHeLHTpzY1nmmocvsBXpkG1PUy5NPyzv4+/RdplNzsz8/lOYxfnWEaUh1NFDL5bE4nuRbZpbV33jPC3Ro+V4b+q+Nl19YeIUOf7H5bbR+3stH+TWSTH9JQ0f7swH3/Pjsy+xKD0+CakdrUFO8/5VwObDgIcILXZMua+f7A48QmSCSgDL+3P6E6Qvj7/+qXmZaWDI8owA4dN3jCySSU+OkiiAfJ
 cuBdDXrc
 nWAxkjaPuRo249JyiqYopkT8Z0R9p6YnfW+ZjchGHS4GxA5dq/5UGjPOgSj2O1nXMQpPGGECFoo1gXuWlAZCNDe5gMMd9gjiclyjpkBRbhI2+edzgvJlw5kj4xSGdi2/YgBjpeyVsxaU8mfi6JSyvgixqmR8w1lY75fqn43RIKJDQ4NDzruK01+uYrAI1LOQ6t87rTQeQiueH6UP7Oci+KkSb9VFBoxOAgSSqb7aXpbqzHONHXsxn/jeN0IIJKPjReT/p3AyyNNgdPRbp1JoRTToA8sKI1KRVCJQs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA heap instantiation was initially developed by having the
contiguous DMA code call into the CMA heap to create a new instance
every time a reserved memory area is probed.

Turning the CMA heap into a module would create a dependency of the
kernel on a module, which doesn't work.

Let's turn the logic around and do the opposite: store all the reserved
memory CMA regions into the contiguous DMA code, and provide an iterator
for the heap to use when it probes.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Albert Esteve <aesteve@redhat.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/cma_heap.c | 18 ++----------------
 include/linux/dma-map-ops.h      |  5 +++++
 kernel/dma/contiguous.c          | 26 ++++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index bd3370b9a3f6d4e18885a1d0e8ba3f659b85ef47..f8a3d87f3ccee9630383ba28502eb40b10671cc2 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -28,23 +28,10 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #define DEFAULT_CMA_NAME "default_cma_region"
 
-static struct cma *dma_areas[MAX_CMA_AREAS] __initdata;
-static unsigned int dma_areas_num __initdata;
-
-int __init dma_heap_cma_register_heap(struct cma *cma)
-{
-	if (dma_areas_num >= ARRAY_SIZE(dma_areas))
-		return -EINVAL;
-
-	dma_areas[dma_areas_num++] = cma;
-
-	return 0;
-}
-
 struct cma_heap {
 	struct dma_heap *heap;
 	struct cma *cma;
 };
 
@@ -412,22 +399,21 @@ static int __init __add_cma_heap(struct cma *cma, const char *name)
 }
 
 static int __init add_cma_heaps(void)
 {
 	struct cma *default_cma = dev_get_cma_area(NULL);
+	struct cma *cma;
 	unsigned int i;
 	int ret;
 
 	if (default_cma) {
 		ret = __add_cma_heap(default_cma, DEFAULT_CMA_NAME);
 		if (ret)
 			return ret;
 	}
 
-	for (i = 0; i < dma_areas_num; i++) {
-		struct cma *cma = dma_areas[i];
-
+	for (i = 0; (cma = dma_contiguous_get_reserved_region(i)) != NULL; i++) {
 		ret = __add_cma_heap(cma, cma_get_name(cma));
 		if (ret) {
 			pr_warn("Failed to add CMA heap %s", cma_get_name(cma));
 			continue;
 		}
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 60b63756df821d839436618f1fca2bfa3eabe075..3007c68a8ec5b85990d1938d04a2f05c1a71acdb 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -110,10 +110,11 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
 struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp);
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size);
 
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
+struct cma *dma_contiguous_get_reserved_region(unsigned int idx);
 #else /* CONFIG_DMA_CMA */
 static inline struct cma *dev_get_cma_area(struct device *dev)
 {
 	return NULL;
 }
@@ -148,10 +149,14 @@ static inline void dma_free_contiguous(struct device *dev, struct page *page,
 	__free_pages(page, get_order(size));
 }
 static inline void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
 {
 }
+static inline struct cma *dma_contiguous_get_reserved_region(unsigned int idx)
+{
+	return NULL;
+}
 #endif /* CONFIG_DMA_CMA*/
 
 #ifdef CONFIG_DMA_DECLARE_COHERENT
 int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 		dma_addr_t device_addr, size_t size);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index c56004d314dc2e436cddf3b20a4ee6ce8178bee4..14bd54fb758537f01a6fe27318e7b683964e20b1 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -456,10 +456,32 @@ void dma_free_contiguous(struct device *dev, struct page *page, size_t size)
 #include <linux/of_reserved_mem.h>
 
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
+static struct cma *rmem_cma_areas[MAX_CMA_AREAS];
+static unsigned int rmem_cma_areas_num;
+
+static int rmem_cma_insert_area(struct cma *cma)
+{
+	if (rmem_cma_areas_num >= ARRAY_SIZE(rmem_cma_areas))
+		return -EINVAL;
+
+	rmem_cma_areas[rmem_cma_areas_num++] = cma;
+
+	return 0;
+}
+
+struct cma *dma_contiguous_get_reserved_region(unsigned int idx)
+{
+	if (idx >= rmem_cma_areas_num)
+		return NULL;
+
+	return rmem_cma_areas[idx];
+}
+EXPORT_SYMBOL_GPL(dma_contiguous_get_reserved_region);
+
 static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	dev->cma_area = rmem->priv;
 	return 0;
 }
@@ -504,13 +526,13 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 	rmem->priv = cma;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
 
-	err = dma_heap_cma_register_heap(cma);
+	err = rmem_cma_insert_area(cma);
 	if (err)
-		pr_warn("Couldn't register CMA heap.");
+		pr_warn("Couldn't store CMA reserved area.");
 
 	return 0;
 }
 RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
 #endif

-- 
2.53.0


