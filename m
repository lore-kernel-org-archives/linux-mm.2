Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC12606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Un2sRjEs
Received: by kanga.kvack.org (Postfix)
	id 7419A6B05C2; Wed,  4 Nov 2026 11:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2526B05C3; Wed,  4 Nov 2026 11:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BADD6B05C4; Wed,  4 Nov 2026 11:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36F0F6B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:48:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE16D1407C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:48:36 +0000 (UTC)
X-FDA: 85398020232.11.0E94A88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D5C84000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:48:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Un2sRjEs;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Acdm197U0xK657CGEFs4haruK4G8I1o86W9oW5IkpgM=;
	b=2V/SH8aRNpyYIH90R5fLHO2f2EuqefTt+GGWfqceacNndXBDnEjV/Gbn6Yb7TZzYLcbGvx
	QYySEFXruqETO960TcCGkBHoCvUotVUfkkJe16ZJGLmKWVEiYdE1w4Tp1OFGCkQWN3yt5K
	6Zxk3/+sqj+pP/yWERaZmGFU7Fk1b0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810914;
	b=boEqk/fQHHMpMRgBGBuzjcbBn1H2HgM9H1MhWZ33bQfUYhGNiqDwuDYNyB7POSv6eDWuFL
	nnfraLaDoJ5ipfDmCvcPdJwtcw/WHV+MkRhDWtQ8jOy7hbt7oqkO1tvQ/ejv82L5Sl/Qi4
	BQhrd8l+AeE+n8t4FyJUTzqHmFp4ihE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Un2sRjEs;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1696022B;
	Wed,  4 Nov 2026 16:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9280B1F00919;
	Wed,  4 Nov 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810913;
	bh=Acdm197U0xK657CGEFs4haruK4G8I1o86W9oW5IkpgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Un2sRjEsMx2lXPBzcH+6zTEErrf4cJx9UxUpGrHyF/cCVaGBrCmN6it9Pjy9c4BI1
	 2YIE/I7cBTn1l5elMAHUBGh+uOBidax0JBjzhWKWD2+S0dE6UuH6kLBkkyqb64YKgl
	 0OJj0O6ld0mGD064jP8QweFe6TJ/krU4wtYDD7XgYK+9uOKYPbAs4EqitZWJjL/OBO
	 Jd5yag5GmvpYj0vHxRflY69KBIuZ6TaHE2ypaNFC05sQGXgdhzXTeKL/nZuzUcx/Qe
	 /JTuGPs2gu7j29t4Eq0urOPwy24zqQ2sQJQ2q691rZEzc0cD/bJB/fH7ejY9spCqUM
	 12HtmtSaN4GVg==
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
Subject: [PATCH v9 06/14] dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
Date: Wed,  4 Nov 2026 22:15:47 +0530
Message-ID: <20261104164555.3555725-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hb99pc9sab7demxz8wocaqox8ek348pr
X-Rspamd-Queue-Id: 0D5C84000F
X-Rspam-User: 
X-HE-Tag: 1793810913-112088
X-HE-Meta: U2FsdGVkX19e4bRdqhFajkj7XKRWlgFvl6TQzsdq4KbCEfMTQALbZVF6V6JIEWmZGTAUdFquMT2KulrLf/bI+rycxduCHy5T197E/nI5FdxHw/PBx5iBga89NkANqvDHk/wkxpeGOO+ZP/XLVw/6pmF2fyNxjoJtFTaY4LkSARlyNFScBFnW8273N1Zml+IcKiPu+BqY9trMgWpSffVCbZbxv0f8y/rRiW5WG2BiVLt4dmOMzZmUgqv4XvwPXRxXQU3iQBopEQuCcjJt5Gz4Zh0hDyuWKynxzKGIbtyJt0qwUb1hmJ5cnVOvY661bgy8sDdn4zcloa4XTyJi+Udb/k5dqp2t/KHmsTBE73GQ16fJV9XjLgtd2DOJ9QqzlFYXD5u9l6uxZFzeSvuobzCks2kSzO3orM2k9tG+fN++zfVVLLYbi7UZmHW+nuFbDB179QHwwX2dwbyQPtErMSN10Q0FcP3q+bfnp50aU0570IwbCRudQXt8XmlZA7qqfgtRJw0IawhaUxUf6rMnThXfETefDW0DBTdusS1sG78CnRTVpxrnFhtLNK4ng7XyOsYNTnZhnyUB64OFoQoalUP1wytLT5y9bHOuYFFYpvq8PlxQ1gWqmyZiXURR7kq7Kvhe+ZmOstyZPbgBD4sD3Nf1Nmo6lGoMuWQ9i7Qfe149YVZqICqqhS7+ek82TuxKWdhTy/AHd10iYwNcPIXTKd4EWk3pj6i8XKFP83HPhm0EJgtj7bvr7dgzFl9NMw4UhaHEMlQY8xm4K6Wi61vH+GVcYgDRLjd1oT+8aS+xQ/o/s94tG8ktlg65Epz5gxO+i+c1Fh/Xo9O3KR28lEd05G30W5fyyLPgGFrdMOAL5cE/CRFTUtbtQSrd/y87/qsCMw3WPbSqY8mEjiMKkcrbosEIArSeEl/JXeUFnkDjjPYahMzFuDs89gvG6F5LrplEgc4PkqqXGceig+87FAhzlfX
 YtjE634S
 +hrc/tM7RblNwGGF7sn9x/F/ReCLBNq28P5YXxkPTFk2RB/weR7UMcGSaCpbfzZAZIQ03k9z7yXG/4A0VmaZkN/pmWSWCZlYzimEiHmmv1BcpgHl9983udO+NUcr6quwqP5UEKHyY+39MuiuUHYUzVMsNQLa21J37T+9gEPgmm1MQ7iyT6e07UEEIAFYw4w1taZVKAFGpiK4Ix00PFYdlpAdH3ERCUKss4mtKxSYQBlMYwuXrIPGwHvkY4/uAORnK4LcLmLrch0PEul5NV+/RKbb/SYn1/dxx9ReKho+GpZOJHKzaxxbqoaKTBJXpjcmGrtx6OWvWs0d5W1FVNdfhrzUYvlPqoBggf11ygwLyCXQRx4tk7wWD9GNTvJy9bmkIalnNS5qtEBdC9Ps=
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


