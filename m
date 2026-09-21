Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B861C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DC16B00DF; Mon, 21 Sep 2026 10:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4DD6B00E1; Mon, 21 Sep 2026 10:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B396B00E2; Mon, 21 Sep 2026 10:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6F326B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:50:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F8291A01FA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:07 +0000 (UTC)
X-FDA: 85238054454.14.1F51DCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 74D5CA0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbU3J4YR;
	spf=pass (imf15.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0RXC9wgCT9tCmz+jINf5SBQKcG/vPYAJMGd4hap8Yw=;
	b=whIqT3oE5iBOsVzGS9AhA39FiFIDIGssdF6p31gkQnBrmWzSR/9tJ0PVfl8n+gSirIiWCT
	2gdiqaHU84h9fPyyC0ObEcsGcMddGQbKdbusXjBJQulPMaORV+uPo4p4aOzkUe2nbiLfMY
	ZfLSZ7mnSoWFSczYvsKy/dDTB9DDYZ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002205;
	b=Stotvh6nC0mDGFpGl7pOSfG7I6ANiHnPOLJHzux+YUX1IFTPU6lQulZG56dWKruVT10fV2
	MXBHrkFzf5cYOSYiLxQvuuRAU7/m6o/268/WSjzRu6COnqYSoQfYS7tD24Soqve6lC4qpC
	sE7EetCUk6b/sbDMcAihXhJ4aLXiLWY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbU3J4YR;
	spf=pass (imf15.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFCDD423C9;
	Mon, 21 Sep 2026 14:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500401F000FF;
	Mon, 21 Sep 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002204;
	bh=J0RXC9wgCT9tCmz+jINf5SBQKcG/vPYAJMGd4hap8Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbU3J4YRMftmRU3jVFK0P2ygG00J8C4jBu4Ys1tpUN98glJT1tX1ZPswO6N6z6lAA
	 WnjkUlnCLjFKCszyx2pEUTo3+5QIPTCs2doBtoVsBQS5mu/mREAiBQLWiXe4+wSLZm
	 mSsfl5BK3UnuU6Gr3t60HLkoElNHWWH6WjIi93pYYLmUZ9v6tZ2mMB55GX6AZ/V3oV
	 D18fKW95kPaoC7bvZrUyXgSyBqZrS8ScRtMvemwr2xSlV/oeZwfDMlmc1+pQMh3odX
	 R0cR/d8No7rGW8ggtnjhCOriMqycOZC8UOGIZfaYntGncIiFOc+6D2M7lKuHb5IuR3
	 WekYxl0d0gA9g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
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
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 07/13] dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
Date: Mon, 21 Sep 2026 20:18:41 +0530
Message-ID: <20260921144847.501151-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74D5CA0002
X-Stat-Signature: o554n1txf5wd35bgzzoc9mbcyot79tnh
X-Rspam-User: 
X-HE-Tag: 1790002205-981369
X-HE-Meta: U2FsdGVkX18iDEr3tHBeBTz7iHd8tpSlJtm4118T/+ECqc28KQpQHIvCUA4wApWhRvtxH8C1MbRkdjncGRM6qPGJfJ2WapjcxBff1tFCecz5JPsM1TH9haOtkgiMO6QeqisUTJ2LHZGiTBU0cNJ0ldswJm+TGjLr3hYHg+x6fm0sfdHs2/BiBWtyHKTf1gGu97z7wKsSnuyfQzJgi4/unR2hf2Fx/J3OoVkm4kejRW7qVb5WygMhXillewGdN9Pcdrcg+OAyFkSDdz4m8esdgbLvtPIAtHqCYrni4LPEih/VrgPohRY2+sOtUF8Gw5iMGtM2NjAYOF5Pbia0TWmUgrKoow4pGILBu/LxgRmI6x49nzlQ0IgMVKJuCtRiP5DS5Ei5SBKms8Sg/CzCUSItARqkMlA2/mF8CD1KAsV7v7h6iiPEPlpnXwx2Q6aTYM/WBY/D68C5uCWU+7cw73tJyHlTjz0xdQk9ycER+cwX4L71kIn3wXtQIA2shDJ7T32/+BDzqQ1r0d4YNXIoV08HYDRfKHe8rLHFQ2xYxUxE44kEESkxHjgakCQu5369yyvWhJ3MBoSqF0VRRXxwkAP0+ksPBRkEw1kjPXS8AM+p9BhLJhWYrdzDRGYzieBehU1P66KNQR544z7Z44yQv9YFM4UiJ3BOVWiNyl+hWKcQQ5+CjCx0NNd3kHCbVWWJQqk9efBXJ/wsJ/R2Q1P8dEK1B/R0Vm4kjx1VWvqY5rMdpN2OQGzXpiDl5Sf34nDFV38+Be09zJ10InlhB4/1CVxRHvittpKnW4V2Dyh7qhle1WKOkTVibCCsdlTrTxnbzxfmGpUcuahQBE4Pjm0eApv+LP24V+9IKKTaheQM07jKjQjorC5xSP8LOjKiYS8hbDrf/hmi7aVMGmralyk7YeggwDvPasYfiohO2P4aKCc+nDGf/ksUNmlJqJGYkqd3Rw+IcLGlALME4e7R7Coqi/F
 GAQV2qcG
 YRwUinnfJgJEMK2ctpQ6xjJhlsvjCkm+KtYJwFqd2vS5AwMHf5HK3hsrYL0Zz2IHIsD82f3d6ClwJdRLVcc1OxtAxR9zZI1CHlr2dt8ekunt945M4L9zhgiDFurvHVCcp/7z1MfBxtTgxc54vu9x7BvN1ke5Jd024MjBR6sbgJgDyk/fbTzNALkGTP7bIrFV+iQlnzyVe93s6YhLi3UVVUrbPZYLk+n9T50lviUw0sQRh9Mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic DMA allocations cannot perform a potentially sleeping
private/shared state transition at allocation time. The atomic DMA pools
avoid this by transitioning their backing allocations in a sleepable
context and suballocating memory that is already shared.

Architectures may require these transitions to use a shared granule size
larger than PAGE_SIZE. The existing fallback loop can reduce the backing
allocation below the order required by that size, producing a range that
cannot be safely transitioned.

For pools marked cc_shared, round the requested pool size up to a
multiple of the shared granule size and prevent allocation fallback
below the order required by that size. Pass this minimum order to
dma_alloc_from_contiguous() as a required alignment so that CMA cannot
silently clamp it. If CMA cannot satisfy the alignment, fall back to
the buddy allocator. Non-shared pools pass zero and retain the existing
CMA alignment policy.

Use the cc_make_shared() and cc_make_private() helpers to transition the
backing allocation and validate its address and size.

Individual atomic allocations may remain smaller than the shared granule
size because the backing allocation remains owned by the pool and in the
shared state.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/pool.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 70b7f64b17ab..651d3a99c574 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -4,12 +4,12 @@
  * Copyright (C) 2020 Google LLC
  */
 #include <linux/cma.h>
+#include <linux/cc_shared.h>
 #include <linux/debugfs.h>
 #include <linux/dma-map-ops.h>
 #include <linux/dma-direct.h>
 #include <linux/init.h>
 #include <linux/genalloc.h>
-#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/cc_platform.h>
@@ -85,6 +85,8 @@ static bool cma_in_zone(gfp_t gfp)
 static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 			      gfp_t gfp)
 {
+	struct cc_shared_layout layout;
+	unsigned int min_order = 0;
 	unsigned int order;
 	struct page *page = NULL;
 	bool leak_pages = false;
@@ -92,6 +94,16 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	int ret = -ENOMEM;
 	pgprot_t prot __maybe_unused;
 
+	if (dma_pool->cc_shared) {
+		ret = cc_shared_calc_layout(pool_size, &layout);
+		if (ret)
+			goto out;
+		pool_size = layout.shared_size;
+		min_order = get_order(layout.alignment);
+		if (min_order > MAX_PAGE_ORDER)
+			return -E2BIG;
+	}
+
 	/* Cannot allocate larger than MAX_PAGE_ORDER */
 	order = min(get_order(pool_size), MAX_PAGE_ORDER);
 
@@ -99,10 +111,10 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 		pool_size = 1 << (PAGE_SHIFT + order);
 		if (cma_in_zone(gfp))
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
-							 order, 0, false);
+							 order, min_order, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
-	} while (!page && order-- > 0);
+	} while (!page && order-- > min_order);
 	if (!page)
 		goto out;
 
@@ -126,8 +138,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	 * shrink so no re-encryption occurs in dma_direct_free().
 	 */
 	if (dma_pool->cc_shared) {
-		ret = set_memory_decrypted((unsigned long)page_to_virt(page),
-					   1 << order);
+		ret = cc_make_shared(page_to_virt(page), pool_size);
 		if (ret) {
 			leak_pages = true;
 			goto remove_mapping;
@@ -144,7 +155,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 
 encrypt_mapping:
 	if (dma_pool->cc_shared &&
-	    set_memory_encrypted((unsigned long)page_to_virt(page), 1 << order))
+	    cc_make_private(page_to_virt(page), pool_size))
 		leak_pages = true;
 
 remove_mapping:
-- 
2.43.0


