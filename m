Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4EB606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GcXC+zTa
Received: by kanga.kvack.org (Postfix)
	id 51AB66B05BF; Mon, 16 Nov 2026 04:13:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2466B05C0; Mon, 16 Nov 2026 04:13:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408ED6B05C1; Mon, 16 Nov 2026 04:13:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 179ED6B05BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:13:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86267A017C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:13:49 +0000 (UTC)
X-FDA: 85440419778.04.B8AAFC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E8D5820008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:13:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcXC+zTa;
	spf=pass (imf03.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Acdm197U0xK657CGEFs4haruK4G8I1o86W9oW5IkpgM=;
	b=UwmoP1i7HQEcIEs8LXJA+XYZ9WU+n5uoIyoMAJ2HF/PK5mb7sFRL5JDeljBXcapGp1muFd
	ofWZ4nQ7fKYNN8/uqXysMBOXjhky+L263/ZVprRlhSLKlBj1W4wFptdTuNdDXHBUykTBJT
	3OrlRYkTy81kl6AUMwQSVbBqCVdLSFM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcXC+zTa;
	spf=pass (imf03.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820428;
	b=XDvw6+88hPMPMyjlQJJQk16lmzm0ncmUbgLc3NUu+L2mmE7ZvhMF15Dot6478Bqwmob/2P
	+P5DYVbP5pwhnJNwDeTNSROaxpH2S5cDX0vhtrstD713RwCtV6yJfOqN2nKLuyYl4W/pPW
	QbjOP6w5GvFZ/RnUpKoiIF2R+OfH7BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86939625BA;
	Mon, 16 Nov 2026 09:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D131F000C4;
	Mon, 16 Nov 2026 09:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820427;
	bh=Acdm197U0xK657CGEFs4haruK4G8I1o86W9oW5IkpgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcXC+zTasqUB6rZyp40ubqEMD2P5RI8V5mDV45QPKVzlxAigUSw03ias6QPRyLqM0
	 G4bwYwatGjWTsJyY/FRnX+9H6uvcYv0NPrI7EpF4/Ic6diJLNLvrg2Txa9y2G7A+nv
	 JWcpNLdCUL0cO6p5FH2N3GE001X6ofrN03s8FEd0H5/BTYKjiFIDVN4JmNq2ERtW+D
	 jKVtjlpfcCgfIHxgbzs5Sk1bKX+yUpuE0GN4qbMne/oQzqNDhXf5oKrBbNVoi128gh
	 cSgXzFgU2xG+7W0HRdl3wc3UKyqYfcO9H2mL+AEFs6QQsldsl4pqvldtd2rsFs9o+Y
	 tnafUuwMfeP/A==
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
Subject: [PATCH v10 06/13] dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
Date: Mon, 16 Nov 2026 14:41:29 +0530
Message-ID: <20261116091137.94252-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h1mtn1iq3wpedp3ghgdng83qszphdrio
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E8D5820008
X-HE-Tag: 1794820427-972553
X-HE-Meta: U2FsdGVkX1/mXXJAoqYPG3zfuZgEUeQ1j3vsJyouR9Ya10v6eyQU/qLib1rrKd9Oyb0k1ReRcsvEkmpCn7LSnnwxbATebQYNUSz33AmYKV7dBuie64FnoWJ3egvXO6goYyGEvHn6VMIlEgPuRermRYrKdDlhFhy4+dQVzE+uMcbYWaFxXZtnidZcEKMZe2CQfJr2k/Iw5j/X+iXpdZliMI5UA2AKfk3l3UX/Ip9LELFv5wGvR0ggC78IVUNTyMF2hs6Hjm/hCpt0Az6taVO0G/b3k/XEDcF4Lnq+IaeWNwXbtrJaWjhQaaE/XiPpFSgMpBZ/BTycLj/jX2r8SNEYwp92GVovyCfnoXsYoeh4YZHhxwdubmsBkeWG76dRYvL8JTjP4WM1KPOQDvTaR70dI4zRXMj1or05tvaQSC6S6cQxpjhBZTWc1xSDUs95M6YT2JNf/WGMt743vcFW5y0K2UsUdSzcHVGmk3STipLdvTRM9EE0GGmrzp6x6LfgoTpcuR3zecKB2tDNxGdAwgyTwvo1cYn3QXlMp//EVD7DBENwhqYZfkgtdwNIEm9MwYSkh5qIdvF33oShNa2ZSJGnTnRWUqeqmtgHbp1TySMJwllIIW286+aI/lB9jZgdReGj3xsU7WjcOSegoNV+EiWBMwKytf/wKA9o406gWJs4qEMtwvK62KfMGauQcsHJJfU0mNWXC8Fow4IX/SrvhbTutoKitMJio9Z+t0qxlmYhax8YENza1CTGW42NvwumXah8GuxBpt3vCqunYDk730boHDmmrpHXzuUuTuy794ttqySOFzNtMAyqzUoYgvJcrKvMQ+9iFSoUQEBvbvgIrfEwUZMw3G6UtkDezJ58m/HCYC0hTAvN1xK2/hJJJvs3EBQgJfkz3HiV9zUre6guUUYx2wXpVx1g/IETwypAmGzdZfRQSTMko2l/OXVJmV8dk+d9nF/iDaJY23anGwfnbEU
 IgTwH/sj
 9od6+vExXmeyOiuueK/kdeffFnEXAeFuGO824kGKp5uo25NMQxgjmKRiW+m744IzZAnPbti1E9HQ40RzdYNY3EJouebgc57z4ORLxHhMuuv1tDKjuS78rN8MrETmmoBdzOJpOKeAq/9pGrcFJcGvOJ8a8j8ZP07y+HAEYrpLNSvdtB3XIfGPHGoNQcmQzaOKRkKT4jKByCQOvTHl4V/lSp70KjJmHWnRyGxxTTAQ5kBfDcYgiuQ3Zrr69armQ4DHu8GkRJP/lxII8ODyN79hL5tuzNfxlDGoaG704vwYjuB4Mh3PWz/K74Kl4RMqWf+gZXg34OfVkmKOjuMxHTB1l/aWHqcUPOFs75hpQaYtsEy/5pdP1RWX2GpVsl/ZMxNHTc0kr0BFYVd3n4x9naV2x4zRJtFa+8vNIY8cuY2YZp9fByxulmu+oX8OA8HwIJILucdVXSg1HwS1zWbRA7G7Dg227hqcm6Zb2KEFcVUQL3ILKIdeH1AavLln2tBvb/gU2ZZLP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/pool.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 70b7f64b17ab..da487c3f9dc6 100644
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
@@ -92,6 +95,19 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	int ret = -ENOMEM;
 	pgprot_t prot __maybe_unused;
 
+	if (dma_pool->cc_shared) {
+		int err;
+
+		err = cc_shared_calc_layout(pool_size, &layout);
+		if (err)
+			return err;
+		pool_size = layout.shared_size;
+		min_order = get_order(layout.alignment);
+		if (min_order > MAX_PAGE_ORDER)
+			return -E2BIG;
+		attrs = __DMA_ATTR_ALLOC_CC_SHARED;
+	}
+
 	/* Cannot allocate larger than MAX_PAGE_ORDER */
 	order = min(get_order(pool_size), MAX_PAGE_ORDER);
 
@@ -99,10 +115,10 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
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
 
@@ -126,8 +142,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	 * shrink so no re-encryption occurs in dma_direct_free().
 	 */
 	if (dma_pool->cc_shared) {
-		ret = set_memory_decrypted((unsigned long)page_to_virt(page),
-					   1 << order);
+		ret = cc_make_shared(page_to_virt(page), pool_size);
 		if (ret) {
 			leak_pages = true;
 			goto remove_mapping;
@@ -144,7 +159,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 
 encrypt_mapping:
 	if (dma_pool->cc_shared &&
-	    set_memory_encrypted((unsigned long)page_to_virt(page), 1 << order))
+	    cc_make_private(page_to_virt(page), pool_size))
 		leak_pages = true;
 
 remove_mapping:
-- 
2.43.0


