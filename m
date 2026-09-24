Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB09C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3966B00A2; Thu, 24 Sep 2026 06:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3EB6B00A4; Thu, 24 Sep 2026 06:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB366B00A5; Thu, 24 Sep 2026 06:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1008B6B00A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:07:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A48D1602E6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:07:33 +0000 (UTC)
X-FDA: 85248228786.10.9D36442
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 08B3D4000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:07:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LuTvXw7z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244452;
	b=08aaoSakGBKInhruP3umFoarOV70jjoi/lyBHdvZPDqxh0DfT6U+cjmCwTp2R6qanqmzEQ
	BhcJtT2EwQhikk8KJamGJeVwRzN/16z/Oa/lBMW4QqZFTaNnU98WcF9AjhwYTi2oOdc9MU
	1OPOt8OZZAFIPx6eS6z5+WVXbW7cSuk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LuTvXw7z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaYIuvu7EWcx0kiHd4ySablfum8pI6JmFP40gOiNsBk=;
	b=p1ZvpjUH9mHCeMm3euZtQwUcmgK0RcEJEZ3UFpICtT0o/PXoe6EzUuBUh503y7uHPW9KkB
	DMzSq9Wm9Bk8LFcbV2V8mI62dZvSbnkemBjJM2ygUSv6KASbL5kFPLMCieM0oZbGQJj/G/
	KM1ijt+hCV28S9hiPBsFBOEslCqN78E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A31EB6020F;
	Thu, 24 Sep 2026 10:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E981F000FF;
	Thu, 24 Sep 2026 10:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244451;
	bh=RaYIuvu7EWcx0kiHd4ySablfum8pI6JmFP40gOiNsBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuTvXw7zqVNKQ4skqgavCDiVE8G/hbg2xCHYgmDtdbNSGuedcAsJXDvTuoJvyFscS
	 EHVopMYcPM3szQABVqcGXam6pvpupTAuxZJ5OMb/ysSAaeYV5x2sPEAmgrokBcz319
	 dYSINIICwuHmGPzZo3FdmCMFjyVzDSjWZ7/OQPsSlFJtRW9vIYgiTi/RiOlSe+YkOQ
	 a6oWvGFwJmhfYMS47NNaAbzFqfggPNWxhdZfbqWkcuua5X93I6ziIP4/QopgOCw9K3
	 JFpgHCo+ancimgLdB8OhxnkKJE1n9P4JeqUiS7vwniTX/Xfbe/7jZotMYGaxHKbxjB
	 CGmucjMSnw+VQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
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
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 06/14] dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
Date: Thu, 24 Sep 2026 15:35:21 +0530
Message-ID: <20260924100529.1398790-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: trrnzazhimaa8zx1kfzs7z3f1ixokfrd
X-Rspam-User: 
X-Rspamd-Queue-Id: 08B3D4000C
X-HE-Tag: 1790244451-654262
X-HE-Meta: U2FsdGVkX1+Yn18qbY5E2AOCaTSAsTEwumP3Ds92wc3Gi41zPFhiwXc+WF0DmKmYs5/J7Neldq5YlaSfQSkzGaSZNmnepPCtw9eLWRPo/crUGpRRmPVwFdEk9bc1tVMzxf53HgO9bEzw+vRGQ6FgiiJlRlMC7AiB1tFSKt83z0sXPusJRvXsjA9rlD/oZ8/MCTgJu6JYRUeMU6txYlm9C40EtINgKEDLLaZ9GxD+GiZaivKBNSFeuVCYSorhT0sREcU0si7te38O9tiiP93qr3YQpK1v94MPWVXQDwZdU/ArY6Y/phcMn8mCzrekBqfI0f4AI6CugqsaIW33X7UBn4rnyuGBSR09FepcMLsbNFogciij9vVxUWXAxCzbYhga5tUYPnlk9F4VhUQ15OFE3OnH/ehDl5fnd/yptpvzvXNk+ixf/EC2qxgFGpuXlwbJ6hio9hQivF10LM0Ua8Ai+vfWYZDkyNlxbfhkSC8KTxzC5MDZHD9zRbah8p9urQ+SR7oJnqWZ7LdxXd0nVwArEFly1zGOiomdTsMe80LOg3e1D6BeCMYyaRNomr4FDFFAooJHrBB2O9lquONq2KHa9U3Y8o1DB+RAanj8tXN0ISuHfAmwuOCLxsRK0gqbIJWgryH2UiJ6TWKdkoCbp6LHqK7O5SZIOZFBy4gweBaVvzC/OJBGTlhjaptP+2PcHu+Yh1JEm1/OVxxkRuxamrNDCnEXGm6kmzMuPVAZ6vt2KWW3aJrm/buJ0Wwt9gzV+Tj2sXR6274r5ZdMBfWbF7CuC8Ju+UXILu5Oq/B33YMredq2MNvGhz84WaAItMipnbLKbwHuEvZzbsy9rrIcHu48zLWKoeYx10fthtI5obYdQ17eiqOuCAwxZmegt3Jwo4RXLcZlQ/l2XGYehFbrLc52hvm/mt9X6Yqd06csjzGyUlpVSW8fyoFfF4kSewnb1upBp+R6ZI2GQd7ly0qyURk
 C23+dUvr
 UUZ7dl5cjOX6lX78BgG36p+tk+/CqT91seFtCFk3kpZmxbJQebHNgMVgT2jG+/w8ssXGsNX6PG0MyftZaObYWxbRu6Bl39S82cqx48M9qzY3MMKCExFggn63Riwc2aUDn/lwKBPXbiw+5sz1YwGM2+MOvJ62+sXe8AM0US3rlz2W+cOxkAax5UgM1L1oWgK0bn1iko1nNHuP3ZN3wEF7oQluIMdPJ6ahbP/i0gVKBV/aceZfvWOHBcMAM7n+6yMCN0NfOkaK6AWXNEMV0p5E/qFyhtII9xSUM+wDJP6+xGABT8gzS2rkK5bydnf4J7G4SZfvFIatpoxneseuPvYiPX+UYgHz8OGyUCfYNlXT3P/oCOBCSPya8yaSiDlIl0xnzrOhL/JzNnlyWJiU=
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

For pools marked cc_shared, round the requested pool size up to a multiple
of the shared granule size and prevent allocation fallback below the order
required by that size. Pass __DMA_ATTR_ALLOC_CC_SHARED to
dma_alloc_from_contiguous() so it enforces the mandatory alignment. If CMA
cannot satisfy it, fall back to the buddy allocator. Non-shared pools pass
zero attributes and retain the existing CMA alignment policy.

Use the cc_make_shared() and cc_make_private() helpers to transition the
backing allocation and validate its address and size.

Individual atomic allocations may remain smaller than the shared granule
size because the backing allocation remains owned by the pool and in the
shared state.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Assisted-by: Codex:gpt-5
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/pool.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 70b7f64b17ab..f059312c15aa 100644
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
@@ -85,6 +85,9 @@ static bool cma_in_zone(gfp_t gfp)
 static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 			      gfp_t gfp)
 {
+	struct cc_shared_layout layout;
+	unsigned long attrs = 0;
+	unsigned int min_order = 0;
 	unsigned int order;
 	struct page *page = NULL;
 	bool leak_pages = false;
@@ -92,6 +95,17 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
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
+		attrs = __DMA_ATTR_ALLOC_CC_SHARED;
+	}
+
 	/* Cannot allocate larger than MAX_PAGE_ORDER */
 	order = min(get_order(pool_size), MAX_PAGE_ORDER);
 
@@ -99,10 +113,10 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 		pool_size = 1 << (PAGE_SHIFT + order);
 		if (cma_in_zone(gfp))
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
-							 order, 0, false);
+							 order, attrs, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
-	} while (!page && order-- > 0);
+	} while (!page && order-- > min_order);
 	if (!page)
 		goto out;
 
@@ -126,8 +140,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	 * shrink so no re-encryption occurs in dma_direct_free().
 	 */
 	if (dma_pool->cc_shared) {
-		ret = set_memory_decrypted((unsigned long)page_to_virt(page),
-					   1 << order);
+		ret = cc_make_shared(page_to_virt(page), pool_size);
 		if (ret) {
 			leak_pages = true;
 			goto remove_mapping;
@@ -144,7 +157,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 
 encrypt_mapping:
 	if (dma_pool->cc_shared &&
-	    set_memory_encrypted((unsigned long)page_to_virt(page), 1 << order))
+	    cc_make_private(page_to_virt(page), pool_size))
 		leak_pages = true;
 
 remove_mapping:
-- 
2.43.0


