Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D437DFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D626B008C; Wed, 25 Feb 2026 11:42:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D776B0092; Wed, 25 Feb 2026 11:42:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F4F6B0093; Wed, 25 Feb 2026 11:42:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23A006B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFE1559695
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:02 +0000 (UTC)
X-FDA: 84483546084.25.29C6F12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6AD9180006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kjYM/oRq";
	spf=pass (imf06.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hIJ9Nw/a+LFVOH7+WWc6lbptC/R405sTnM2cVm+mHE=;
	b=RqpXigJ7psWdYCU+DVM6TNu9wtMT5tC063O5EF+4tEaUAidrQg74w5kr0VxO2SBEJne4I7
	4vXM+eRzRhCjLyOmomEaWzFhEsO5COoFQzogYbbAzT/rmdgpXQeq5VxaHDTt3Mpsa0k/pX
	CY3pw3kCrnUrjcQUmPr22u5ikGzrN7w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kjYM/oRq";
	spf=pass (imf06.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037721; a=rsa-sha256;
	cv=none;
	b=4F4yERvk18rOAId9OQU7ilygGLN8Iq+807Le6gJoJKysAUsCZBGF+iXiE+K67YWRxTlMK4
	aeOS53hroWR0yN0bTnMgBRwA8EpRNVLkp3hMlnCXewT2jb9ObIUS3eqqBWpiw92oFjISd9
	CfePIi+eQg61uGkgA4RewdeOt+tjsBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF29D4443F;
	Wed, 25 Feb 2026 16:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A67EC116D0;
	Wed, 25 Feb 2026 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037719;
	bh=S+k5aZk2XIseAV9Wvl5Zz4Pjv6J8tbwAJicn9b11RGY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kjYM/oRqWTCFOpWYAaR7qB2CxDqbOc4d2NSkx7kJW1AyvJGaoXeHFv9NB5qYWJEyc
	 guiFSN+aH7+JOjy8rFEvxtCjNejKpg4lJKeUoTCNFr0CkY21h4qSNSv7rRygTpbX0u
	 fz16yPF1yTDMtpApE8UlyMLdMPZ5JIt9A0xsHdo51IURmSUWm/pWU+yuV8HLWJcPiF
	 jLo7Kbm1fEPCCesx00gy9MJtnK+ecV147CxfZ35RGGRv0Eoi6U5YiVkSIJhMQcddht
	 SstizuRyCCD20l2kl/PzOc+vk7wwi6nTCAte7mk7oKD/V5EfEtw6Gp+n4peGTJC6hM
	 P8Q2CZpQuMrZw==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:49 +0100
Subject: [PATCH 1/7] dma: contiguous: Turn heap registration logic around
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-1-2109225a090d@kernel.org>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5105; i=mripard@kernel.org;
 h=from:subject:message-id; bh=S+k5aZk2XIseAV9Wvl5Zz4Pjv6J8tbwAJicn9b11RGY=;
 b=kA0DAAkTJ1/OGaI9vnYByyZiAGmfJk6ihLbhEMuJPzeXU9eg1VT8Jav/rVS+TpIKp59dXH+QK
 IiVBAATCQAdFiEE5BxWy6eHo3pAP6n4J1/OGaI9vnYFAmmfJk4ACgkQJ1/OGaI9vnaslQF+NGgt
 IQ2A2YC9vsdwoCFKEi7e8jCPsJY/bonDjmPKLOJQ+a9bsxz6krD5FkASx/KKAYCK13uRwlEp5i1
 CXyAzGhjdQYJ5kvzoDH0Aa8XRWn1oAlWJdfJORYc+EIzBX7quE2Y=
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6AD9180006
X-Stat-Signature: 9mm91p4zecufbxfguhzgxi8539n4snxk
X-HE-Tag: 1772037720-61630
X-HE-Meta: U2FsdGVkX1+ZjTyAxIe4xYoL5pev+Nq9V74S/97Auf95NthmLJc8epr3DZnN2qSe+z+JaDFLUZsjZCUw0j/OK8BeuALqdYjcCrfcJGRJbn7jn9x6FyPpHaK5RIi2Yoh97ZWMDv10bn67LyVSLIKFMCbI/uwp4iR90dGTI/IaMfELt9NmpHjZn9ZGacj40fMMttVzMEutWMaYwTTTODjw+0xy98GHa7asW1zQReSK3EZjA5eVNzjnAEiZSsOJiQgztYmsMIF5IM94g05IYeyXRU99gm9r35MXs/H20EMQOzecsgDyv17uZRV59ixLCrYkoUQnUP4hGxYf+3SzyzBxAsH+EuK8Q8tCHo09/KBZuX6K4k2WM8Wcz6ii56Dk7V3zG5AzsyS5/38bdRGZsLQWi327CK1Bd+q4aSTB2aj/tr7heoetH1ygJ3OLMz+Q0MiRdULltdCH/UcKaSzrpvuz7xDfymTQylsV5tKvc2YXO4DLyrEBqSrGlUlH7ebPq+VjwzLDFDcnPI4eoUdJAqOc03x2qDE6BtAp/yt3Z57gDJzC5QXZv7nXpLi1rp43LUWH0im5nkPBGUtK6l4TTDaMWwaI2Jw5CB+69OQKeXtHZfcAjQxTjG9f1oYCQFLh9OPUtN4q1ifdzLwt7qmglxjbKCEgqv3ScGkKxJM9/kqeyoQA1aGtvjifppYH5b1iR3omeMCFsoiFbcIahqqclHPt0LHuD2pzqVxzsIdFlgqfobqtUvcZX9CGus6xaMXTjjoI+4LGh0VRTNfvPQppF8DaX643vITd+GqMoBtuqZrnVakfHVMUCBBQ2Q9ZfHma7FPYu/Pbx56vII0Bi+6vPhQlLkVAJVtNUe7EujH0KydsCurhzZgDECAEnN6Zk3lW+nydhgoKfoSHfbNuSCe9on2h5/wOGqGtxaZFpNccFm2pnOh383PiQtmgw5kvN5oVLjfMgq1cl0B1Al7egSNTGAa
 zijzY3LM
 um4azPqqJY7CETJJzLQihyVSRnz75uWCkzO/PuzXFH6Mvg6q6jUXmUHTLHLvqlvsXVlCQNCQV4r9+x5AVMi0u9Hktr3ZUdEX+hkQQs6tSksRiI4xy3ZGlmceniyjy7KDR30OGW2mZs75AV0+Tno6lTh1sVfzMzhRlCOsOS9WV9skS5kcpFJNjwfcy6lDoFdWX1sx+x+h+4BhA8XXJwch0u87Di/GjKKSI0egCdKS4iug6c7SWJaxqJFPt3Q==
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


