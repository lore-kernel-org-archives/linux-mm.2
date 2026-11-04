Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC5B606EE94
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mS1RLrKi
Received: by kanga.kvack.org (Postfix)
	id 85CB46B05CF; Wed,  4 Nov 2026 11:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF586B05D0; Wed,  4 Nov 2026 11:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D836B05D1; Wed,  4 Nov 2026 11:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 309776B05CF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EAC71A07DF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:14 +0000 (UTC)
X-FDA: 85398024348.14.BF27558
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF5E64000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS1RLrKi;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZs/NYrhS2H+yLG3RkfZEwYZelHczFcvNccswVSGXMc=;
	b=NdQu8Gnqm3B226KC9xHXhJltk+6EnoWOhY9VwoQBCm6Tt+0pA/29x/aK0Fb3GIX5G+PR3E
	Gq3I9tffJYdFQLCYxmWAlwLUQ31tbm7Fp8ZKNyaPl2qiCQtU9Ac8QauSQQLm2s3akXDOOo
	CxIOD6rNQuzqHDSyGKg8N69qKCBRWd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811013;
	b=U0EutvfvfGpeUk7hvuIyHrvGwNkN/x0voWFnobmLkorGKd92GVnk4IXWlx8Pu/xghAWtpC
	yKvj6ZypQ/38Wf3oghsBTZoENKMfQmY8cNGUQg/lIDirJn74DclS1Vkx+/FOhClwHRzXwR
	B5Cr1i4UhxI9ZInwZidxPGhUEM/ZLsU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS1RLrKi;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 366DB41800;
	Wed,  4 Nov 2026 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2608E1F00919;
	Wed,  4 Nov 2026 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811012;
	bh=FZs/NYrhS2H+yLG3RkfZEwYZelHczFcvNccswVSGXMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mS1RLrKi88p9XqzdJYEaJ5+IqT6NarwgxSiYwp5vgjahMn2aqsFuiLZvYVd6Ro6G9
	 6da+ooRIfw5qckkt3M+gxSmTp6X3WbvycB4hcOW8RIVir58D6vlqJjx6uRxNR8We9n
	 3cCVBT/RAsbeSdnjYXxhY96zLDzF7V8hy1zN3EoNJTlw1idqnr+La3z7UA5Tw9CgeD
	 i0ozVGAyiaXKxpMjl/pn8Sck74RZ6ylNTTo48KTFnOowPiicz0aau2cUo/esrln4vJ
	 YNiOuLLm6pjwHcmH/wnQn9oiSYJrnKxFAmw5WuNUIMn1DOOQPOtiFnT4YllJXT/N+u
	 S8afOGcw5kdyA==
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
Subject: [PATCH v9 12/14] swiotlb: Make rounded shared pool capacity allocatable
Date: Wed,  4 Nov 2026 22:15:53 +0530
Message-ID: <20261104164555.3555725-13-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4dowqrune5e8zih9urp9iykdzi33hz6n
X-Rspamd-Queue-Id: DF5E64000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793811012-258332
X-HE-Meta: U2FsdGVkX1+VpJJPAW/IUnA7bJZ3B1jszEYnz86HEIiW7kKBPQh8ARjTfIl6jEWWxG3K3af8ngYLe9V/6IpjNrUy18xs/ur+whwHT2M9KcL42meSTjaDhVc7f0GdH5v5ebPIa8EhIvTHFEcVgbwuCgiaW5GzaEOlvmfgJ3gQN8xKAlfgQY/S2pHanTiPkBDGvNkD83A8ld02FPj9BNZUSYfQJzuLpPTL6ndQeNsOax30Uw0wTswcpTYUzdIF4D7iQQU2lCDgomjaxSZAKalUCIytodrDwxO2A1H/XUk34DBOLIFAq1uLOPWlRVn/ZlKYxwi2BZPxywccy2UoZGu18woDgKTP1ofi0FLI1g+qVyV4qJFBMAyoyOs4/MOvDFbBAcCjwjO828jGrDQdpp8g0GB23bOrVnHMZvyc8SCXERDel5oPk8MdCNrG1OnEH44YxoMlXqMLJRraZT5t1GAqdxJ591DDj1muzCHZU20wi7r27ScY+N3hUM9Sp2lWocXnJR0G+BZ6FEbZ4DT05zskdPtvdpeA4I3rbYqinAbicM1vlSTubUk8qk4fi6mvrdkeA5u/TwRI8q0deS+b14U6WwbBE9zJrnIJPqdP+G3MrfjBWHFlVAETPLe7n7CJU7n5NlrIX5uQVdoyz/XH7cdbD8XiyAumxsj8GgCea0dBUK6eKLDMPZ3vSFe3O8KmvNu5dxl+wiwYI//mCwBmb/y6wRladZX5pHfOBGwrW2aA9FDqQQxZyEGPFtzxFVuGOXu/dATIvPaTiGEY0eo2BS0HGZJTFj5UY2n7m7gp58bpgpa0u0bScYo1NNbqaoVxN/cGlzV5FcgSGfJE+3JfOIfPkziPJ3EJ1QqFi6hf0j/rjZ1TFH504pIQcULSSTNYIGeXsGFUWV/Pvx+Fi/S7kFL9WO6+Toz0m3fMpqowUcLVJmPFqd2aXVT3S5qjWB15TCavWSezDLfH9WrVS9pVzBc
 DjfZvwhH
 E2zc4mKPdIEy+WemSDJJ7/MKb0+OjtaUBN+oR/Rd7L1DogcW3VGmHGBlBLrQnn0i/L0ipl2kJ2jpTDVNkkB3oO+0O63YkDVMxJ7ktaEx8YLMU01fMxwL6dcXJVjSJbPYjjtTTPfRcXpSOogXBkLrK7An6NcbVx3x/F7ROUxTBaKxEVmfjLjg5oKyqwPMUJPLWZB71lDmNhDc9t5kPCf0MpNIYZIWUgrrKE0rqaks841pWaQzHwqWDDwryhu5qFlqSmNgaIkUdamG9N4+wyBFOWGnqOX+bjE1UzI76/g06P+O0ccTcTQvK0cPn6UYfLZh9SAyefT3KREc+k1dU96b1o1x02x97knt72auhV3qjtAOc4mCC5bS0dbds5byOErItJN9s6KbLZhHcc1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CoCo shared memory may need to be allocated and transitioned in units larger
than the requested object. Before this change, users handled the resulting
capacity as follows:

  User                         Rounded capacity reused
  dma-buf system heap          no
  DMA-direct                   no
  regular GIC tables           no
  small GIC ITTs               yes, through a gen_pool
  early SWIOTLB pool           no
  late SWIOTLB pool            yes
  persistent dynamic SWIOTLB   no
  transient dynamic SWIOTLB    no, one mapping only
  atomic DMA pools             yes, through a gen_pool
  restricted SWIOTLB pool      no additional padding

Improve the early and persistent dynamic SWIOTLB pools. They already own
and transition backing rounded to the shared granule size, and SWIOTLB
is itself a suballocator. Advertise the rounded extent as slots, size
the slot metadata to match. This makes the extra capacity available
without reserving more backing memory.

Keep transient dynamic pools unchanged. A transient pool belongs to one
DMA mapping and is destroyed when that mapping is unmapped, so its spare
backing cannot satisfy a later request without changing the lifetime
model.

Do not attempt the same optimization for dma-buf, DMA-direct or regular
GIC objects. Those allocations have independent caller-visible sizes and
lifetimes. Reusing their padding requires a shared-granule suballocator
with reference counting, per-object mappings and accounting.

Note:
For the current 64 KiB CCA shared granule size, SWIOTLB pool sizes are
already multiples of the 256 KiB IO_TLB segment size. Consequently, the
rounding does not change any runtime values on current CCA systems. It
instead makes the code express the intended invariant that pool metadata
describes the complete shared-granule-aligned backing allocation.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index a3fc33c54cec..285814387148 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -328,6 +328,14 @@ static inline unsigned long nr_slots(u64 val)
 	return DIV_ROUND_UP(val, IO_TLB_SIZE);
 }
 
+static unsigned long swiotlb_align_nslabs(unsigned long nslabs)
+{
+	unsigned long granule_nslabs;
+
+	granule_nslabs = cc_shared_granule_size() >> IO_TLB_SHIFT;
+	return ALIGN(nslabs, granule_nslabs);
+}
+
 static void swiotlb_mark_pool_used(struct io_tlb_pool *pool)
 {
 	unsigned long i;
@@ -431,11 +439,12 @@ static void add_mem_pool(struct io_tlb_mem *mem, struct io_tlb_pool *pool)
 }
 
 static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
-		unsigned int flags,
+		unsigned long *alloc_nslabs, unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
+	unsigned long aligned_nslabs = swiotlb_align_nslabs(nslabs);
+	size_t bytes = aligned_nslabs << IO_TLB_SHIFT;
 	void *tlb;
-	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -453,12 +462,13 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		return NULL;
 	}
 
-	if (remap && remap(tlb, nslabs) < 0) {
+	if (remap && remap(tlb, aligned_nslabs) < 0) {
 		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
 
+	*alloc_nslabs = aligned_nslabs;
 	return tlb;
 }
 
@@ -471,6 +481,7 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 {
 	struct io_tlb_pool *mem = &io_tlb_default_mem.defpool;
 	unsigned long nslabs;
+	unsigned long alloc_nslabs;
 	unsigned int nareas;
 	size_t alloc_size;
 	void *tlb;
@@ -495,13 +506,14 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 	nslabs = default_nslabs;
-	nareas = limit_nareas(default_nareas, nslabs);
-	while ((tlb = swiotlb_memblock_alloc(nslabs, flags, remap)) == NULL) {
+	while ((tlb = swiotlb_memblock_alloc(nslabs, &alloc_nslabs, flags,
+					     remap)) == NULL) {
 		if (nslabs <= IO_TLB_MIN_SLABS)
 			return;
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		nareas = limit_nareas(nareas, nslabs);
 	}
+	nslabs = alloc_nslabs;
+	nareas = limit_nareas(default_nareas, nslabs);
 
 	if (default_nslabs != nslabs) {
 		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
@@ -872,6 +884,12 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
 		tlb_size = nslabs << IO_TLB_SHIFT;
 	}
 
+	/* Transient pools are tied to one mapping and cannot reuse padding. */
+	if (mem->cc_shared && !dev) {
+		nslabs = swiotlb_align_nslabs(nslabs);
+		tlb_size = nslabs << IO_TLB_SHIFT;
+	}
+
 	slot_order = get_order(array_size(sizeof(*pool->slots), nslabs));
 	pool->slots = (struct io_tlb_slot *)
 		__get_free_pages(gfp, slot_order);
-- 
2.43.0


