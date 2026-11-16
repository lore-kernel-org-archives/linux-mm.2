Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0CB606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iti3eb2x
Received: by kanga.kvack.org (Postfix)
	id A004E6B05B3; Mon, 16 Nov 2026 04:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D82D6B05C5; Mon, 16 Nov 2026 04:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE406B05C6; Mon, 16 Nov 2026 04:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7A96B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:15:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9A2140933
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:15:37 +0000 (UTC)
X-FDA: 85440424314.22.05BBE7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 279821C0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:15:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iti3eb2x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUD0zGvsKdu3zcOD5zlTuN8g1sBTSA2EazIJOi3ONjA=;
	b=RC2N8eRT+f8MOWd9ALeCgyOiP6TzupwId2GdunztJEQtfzTA9S7f/4f+zp30ugjMgNsptG
	SHaJO2mPkWOcrb2B2726rHFc8/6cOaQnbPLsDY9UKEAoWYiR2LQnCV8c4mxyfbL+YdjgN1
	yvCrua/9zmHd7qZIicqc3Pmus4Qk1G8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iti3eb2x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820536;
	b=Swn3n8PsIpSBczxTyiavGGH/kj4rFaNSabwRieHzLxA+HQj3QBYGtpAO/yWl68YeddJUps
	ajAgquSIVsIwPqPO0O1GkGJZWSAzo1MjaB8DktBbCBNzjwwJM5+J0eK2xjD+GQEO7sRvAY
	5oDy5tnbBb5e2dOP4/7vS5S9mL+c5Xg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BEAF262788;
	Mon, 16 Nov 2026 09:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205B51F000C4;
	Mon, 16 Nov 2026 09:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820535;
	bh=KUD0zGvsKdu3zcOD5zlTuN8g1sBTSA2EazIJOi3ONjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iti3eb2x9l3uC7iAUO/qk6aC/3ijuwvDgqSujOaVwMhCxDfkHsA/yeUxufDGnQv2t
	 RYAIDdBUin6OACLcpfH8H4L4l+H6vRw7vM01FsnjWz3QsmsKMzPuYQzvgEYBs9jERm
	 scVMBZ9arWuicvpZehYQnwkKmcu3h+cFgc74vKjIbFqAGdXsRfNPdPSY6s0i/sExxy
	 v/XiYxGvSTSMxnGsoqQIKFio/6w/lKxreLjwj7wA54j5dvdq6+WmGrSmkSeHBsHNSe
	 KsYGwpPNRffHROPnBHj2m4ymXrtff+WfLFb215uhRLZ83U+gB+dFPyunVsHBCTa7rH
	 TsteO9LkFpO9w==
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
Subject: [PATCH v10 12/13] swiotlb: Make rounded shared pool capacity allocatable
Date: Mon, 16 Nov 2026 14:41:35 +0530
Message-ID: <20261116091137.94252-13-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 279821C0008
X-Stat-Signature: tc558hoef4wknowm6yw3pq65h9e4jkpx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794820536-528878
X-HE-Meta: U2FsdGVkX1/SBISjJH2wd5l46ATxCpO/vUIX1ljvBu601DNEjpuB3DZV6yOZWjCUd/sIJDjufIS1vkN6VbxkCrLcf9gIbWJZy+edGv8BOG7g7xeu7sEomG7HcUyhbAyywBdwTBnTUrzl0ozS79WM7rhtyKxb4V7dOVqLqyjBxbP7UmLIPEEUsvRnFMtbuw/4SIzqKVq+cC8LycbXT/WzSn7E+8vvcVjqWRR9kSNmNj4AGJcsqK3HVRFcD6JbS+/cq+MLuGsOuEVxx+tmonjFAFWWM5QW0wzeSpLkZdO8Sx8Lv9Onl1cje4tR8AaGj1gcX/cn2yB+zseg1+616L2nb1dKQ0Q5h+gpZDh3yKirAOAx+mRUlcW2/3G99GnaHrRnstfc2/ihdurXxL2I8psRW3oZa2jyl6x5eKzYfssvZ2JnmfIJQy18ktj5SPuber//g+sRcbs1xP6zIdg7JDjrTQJFLjmDOYSi/OP70yAhftd+VdaIHLioKtyylmKo8yJvMZREg4jGutZWWSP94MAtxoO7npqeO7pQJChUA93Wg5bgojq7THlOFa2wULBMN1mDVdRuv+pVkDkCqE1U5jirwGdrDILKoazwb8CvH0Y1uDSsgrkCiTT9wSVyi8Gt2K+Nz0Sf3Az8mOeK5vkjjmx9Yfm+mPQTJmWnN8ar/s6LTvZrJH1idlS8MPqd5dMuo02wZh/WVUJlR/RwJzEhdd+Imdh0yGwqbZv1rXktor/8U6hcncC5CnKQOTPD10DuYyGJh5oRKJkHit6cDRlebC5SVtExbaJzOf3JTeL3liLXxUU6+bQZrpqRg3NZnnVOCrjt9UlJpPFQjcRP3NXPT/7Tr0NWQDLOiP4irMQZ4LMdKUhCrwIsnflVhrNEcoIHTAhhocyFryLDpZOvYXEYUKIazSMvz6856doDX6r43y4tsBYmUigAbgl+b8yrl9hv7FK5yRnpa52RhRFPUqowanI
 Lsv/Vz1P
 N6JcXOYKOIil+gpi6aQ8ZVpCs1XXuFa68xxkL8Y9GcKbApkTbPd98FSkVmv/awoAaYijO507Y+74qfoSSU4JoJ6iQjGet+drVXnzeQez3FaXai4dDkwSc5srARWgqsXtA2BZ9cPsQ72l21iqxDvV+RpXzr6mH4hyNZoxuVtRnCNuQQ7+5JRBNb6+ZDPCnoRHSPPKwN22gBN91+43jlq5mBfnmnbGIIghRpm48H8qziwqKmGMQVXm53Rdku9fwRaMw4Cz3FrK+NRPjjRSf471f3zv+7zbWqeaqtYZtvQf/OT4/LiYaIVR4QhdglH8IRaM1kag4CnuuofRghxe1Arn6RBsWWg59N4wRrGqYBu0E4G2wN+lVw3FCNLuDg+w5BPzHn9Tjc/PaKQ4emzlbxJjCchbCUk2EyJUhMkLale4OVNaUmx2clRReLipynkFGxXfDF1YmNInep5Q8T836s3UBlhnG2qssIjPrcEI74jdp8/6pL18DDvbj7ygADdPdgkPt1ko5
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
index 24366038dfd3..a245c508fb3a 100644
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
@@ -867,6 +879,12 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
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


