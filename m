Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A102FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83536B0088; Fri, 27 Feb 2026 08:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A036B0089; Fri, 27 Feb 2026 08:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FB36B008A; Fri, 27 Feb 2026 08:23:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2496B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38912160646
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:24 +0000 (UTC)
X-FDA: 84490303128.16.29F33C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF6BB20003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ep8QG9Jw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198601; a=rsa-sha256;
	cv=none;
	b=XaiclaopsDbrEF7RARmrwt/eeRpfnhkLtQoq76LgbbNSTh7hNc60e7eUOH9/NQ1eNe/mVm
	OrhcheddWdWPGDeINsA1RA0e0FXt40MYiujcaE9BuLZbWoCNYIPRuceyy4/yXMq+aR9MXH
	h+zv7gpwQjxKyKBgw7I/OiYgdDMNqB4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ep8QG9Jw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+DI1OGylX5oc2ls3JemmmVTjCVMpvBzpPc1UbFTw2w=;
	b=r7/mc44tu2rlWVaG3RyEAUIfPtR9a165FIlQGsP7YtPoxpC1xCeMGYhyHQEK8WzQiyVSKr
	ujNZyl7qp+BrxjOXIAprmuKV7hUmRFHqa2tdViZy/sPJ0N6vWZWlBZa+i8p77mm3De7gKn
	BXzevXZd3Go87pv5PnNsnl1iXYrduVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA25541A0B;
	Fri, 27 Feb 2026 13:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B44C116C6;
	Fri, 27 Feb 2026 13:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198599;
	bh=3nkigmqj26MiaB2hrjIoaEchPKanWq9PIyuPV01pGW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ep8QG9JwZhst67AO+YrR9CD7vN8a2Q0/SvF7GjJ1AJRdN8amF6qrQtsrtjsPM/os6
	 jq7h6SKaZVSq5kQ5Dk2OtQd6WOoxu2LglQkpe/IhJU+F3cnv+UJagUHeQJbBWjIQJs
	 pChxUqUVVnx1ScPP1DP5WrsSfsdnqkx72VuU6Wg61+v95Kq6RLudN19qlT2IPxo2Ik
	 PHDT+ZaIgIKjUBVWQcplwELu089x8mY0Uyp4sDIOAVavKrqNaY11takn6c0DB4u0QC
	 fkwXmDwZzDAz3yXJtDegrVMxOTeGBoNmjm3PqZfod981ExtPO75+qEv7WO+vM+oFho
	 54Mh8NCxGaBMg==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:40 +0100
Subject: [PATCH v2 1/9] dma: contiguous: Turn heap registration logic
 around
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-1-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
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
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5155; i=mripard@kernel.org;
 h=from:subject:message-id; bh=3nkigmqj26MiaB2hrjIoaEchPKanWq9PIyuPV01pGW4=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+14wCSwWetCxePNRjzWT5eynlx0u+Kw4t+kD43v7
 He/7/B82TGVhUGYk0FWTJHliUzY6eXti6sc7Ff+gJnDygQyhIGLUwAmIvKTsYbzdlm6p7+41j7e
 BBOeHHN9vveOL0Q1TjqnxTQF5Rv53HxdmZC5p8zML/1tkwPrg9JCxlpJQeG512WDL054qdxWaxf
 lNNVAZPGFk7kqB46k50zUPr9kvu9Jpry8bYI9dyZc3s8u/BcA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF6BB20003
X-Stat-Signature: 7fiaorgohb1djj5p4skf5desyk9nswma
X-Rspam-User: 
X-HE-Tag: 1772198600-284496
X-HE-Meta: U2FsdGVkX1+EjOg4joJLa7TJ+Vm5o/XqYA4CEfPwa7EeY/bO4RNFcbnSYzqwNr0C8xcEdLtxv42GRlM6XvubV+XXeex4IxInp8bfZvvTFzYdi78SvfaV2yaQu6qgPDXvvhXji2bwuE/RLy0gCE+xVO7+WLRstbfcCt39ltZMwnjhe13iRQqqxM0pHP0y1u+w7w73wY3Ju5ZFcpAfvuWu5xpV+IJutoCHo6yrEoRJySqEbe2RjKLDveiShcgiey6cASE3gVO0oJslnut811IZLjskGzRXsFFYQ8q0MNlryVHjat3eSMwMvlPnruVEThxYHX5h9IDBiPzyyfdU1yKNRGVhcswrBx4pX9QSJ378rvvc2efhht2YB+UwDLik3jqAUkB6ot6aM8upfMNjAcExhHLbq+e/Bw2AFThb8n34tYln9zoe9RJvgFeOvw/cjoGMrGdKr1bVX0muvdbnQBGcVuRdQ0mjIidoqmtMTjB0MNp+5Wjh7g3kKyPeDhYvRbLvLh9midRyqabyk8noUSPnc2ou5bMBU7NY/2T5KaWsIv0PkOqRZWpOsX3um0cqVnWf+hO8nKHDdNmChqUufA8ce/iw6rzBIbLda3iWm37g+cwbko39FfLsvK8NglvICURn1mTzdnudH3E8UAMysWnaz0hE8X9BpJeOv/k29pcJrMmIX4nPWvCaiwyeuwcTmmnTC99VQXA/Oi//1E572P2aC9E26Cmmv1ONG9qDLQ1kfgCSdSfTQNL9y2gx3cCf3Tg7sy6rH//Uu8/fXmPhbxOvCE4TQwCy5GPGtLdXlJqYVHoaQSFDf4MdRfq0Z9RnMFywkf1wBqYdUcY7stWh8v1BmRF+O2y+Y0fVIknzk79gbZLibf9v3ELC+oMmUp9vsCB4o4lc1oxiKc40kSahvDnOvHVuj56bdnWYGhtgD4dcpRat5/STeLuOBcfklQp6oboFKnPPOTdhmf/JYk4bAcI
 wrKOJT/b
 GpoHCQ479CluuKuesjJ2yidySdGxFGPpDEx0uRs7wboG5ZQ5oh6I4sMpw/4VsNJW2bCTKa3OVxhKCFpoXoWj/aa5tghSUmQMRi/NySLopggRPaL1zaCo0rBFGjdCPmGzLVrhru5g3z1RBvfHJTgi3jr8pFZqsyg650TWjO8CaX/PQLKd9d9D/Qwre/iawRz3DvZ/8hpuPiul1nPQwwv9YqvaRMAzpmSRjP+r/CnicmVAMYYa+REp+L1EkeboGntAi/b95dUjyoPbb4MA=
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


