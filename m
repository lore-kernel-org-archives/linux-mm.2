Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E94C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4BB6B0088; Thu, 24 Sep 2026 06:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBAF6B008A; Thu, 24 Sep 2026 06:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883346B00AE; Thu, 24 Sep 2026 06:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2EA6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:09:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03B72802AD
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:09:14 +0000 (UTC)
X-FDA: 85248233070.16.3B2B121
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B53120009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:09:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AO84OOU6;
	spf=pass (imf13.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjLv3i6JJ122LJ7wUfvpGm0WJbMJkppUMfbaqHtvr8U=;
	b=vWacmc6A+zAdEUA4vXUvND6KK6qX+EDqSQW7wudD7jATg++pOdTQXLP60YNCT78qkZzOwF
	7Yawg7MYwGshRDKJ+n3ZYY6YSI1ourffnptTK/LIc9Ipp17DLv5xRNm+MJTTtQQhlcMcxr
	XrPCUuS2WmnVfitw6Y0V0zKlZRiuUPs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244553;
	b=xJhuODwY7Bi3Lump9vBkCxN0va3M2n/LYRjGce71T2Kvm10U3OQRfCdlHUWqnaybvx8Orp
	2vnOakh8Lyz/u9PrXnPCJCAQ/1upjQmljfgcBy73SZvz3Vqnu8KQtVfK8LeG3J0YplPfaw
	DrkfPAngtujDiRPQoxxkePIjhRDv42w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AO84OOU6;
	spf=pass (imf13.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0205160216;
	Thu, 24 Sep 2026 10:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3321F00898;
	Thu, 24 Sep 2026 10:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244552;
	bh=FjLv3i6JJ122LJ7wUfvpGm0WJbMJkppUMfbaqHtvr8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AO84OOU6N+eaEkLdLQBjyQ/t1HP1RG2S2enaWx2C+z4bHKjzh2wO9UHy+bjDug10m
	 qqpDXV03jBDwD1QvXv6r7BGWk1YxbBM77iHGeE1PuNEz7eZq011ieT3+ptwXy1/01f
	 mRcAhqBbBLGPtfoyZji6bRl6UCa4FPjUFvBuyBNLXNf0FljNqb86DW9nAs2mhaVKwt
	 71ieV5+ZFfHUU3s+hcb8awOchCzEpLPuRD44lMHFYnXqkdQOkNUfAYTSob85+18+sT
	 uf5uYl+M706JqXG4oAF1584cr54KQZrL4+V5Q3r2oj5mY/ie1Afu34xkkrghnL8SU6
	 jX3DHt2ADqFTQ==
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
Subject: [RFC PATCH v8 12/14] swiotlb: Make rounded shared pool capacity allocatable
Date: Thu, 24 Sep 2026 15:35:27 +0530
Message-ID: <20260924100529.1398790-13-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6B53120009
X-Stat-Signature: dr18gbm4n1srenbdafb7oxsi3re4o6do
X-HE-Tag: 1790244553-863153
X-HE-Meta: U2FsdGVkX18oF9Lq/RjKvXV3sD6UxiliZKaFHqoBu8JmaTgWUUekdSjWYFhbMAd4EfX41sOmlqKk8Kz7/l/TY0nB2lrKZtt7ZUko301w+P0SjNr/3v5ipckZ3n2yFRbafA6EJhfzY62m1Yhi1e07CdfxBDNJXA/Ah3dZmNKnneowZDVxvwrDQFMqAVFmR8Vdzz1HAXqR81ryGvvrKJcZYGAy7KJ8uIbr+8AUpOda1Ac1cmn1wdKc7cp1zpxktf514gNU4z2MJxXph+YYX6LqkZW+L6UoaI9xTbeX3QSpgEXMfVqTvCmhLo1OT5TvchU5J4tL1dSYRDjqtpMRwaqx5YLCDwVrvVZ17tODwjodLAEFRpV8ZJ6w2D1nkhQ33hbCc1ibSmyDIlcJChzl8ByVgazxRMYrtzH4yADMpTbIpllNUrC2UJCjpets7CwEz4aMS9bdYV+6YpfbhTUfMFYa/iAO23fmVGyLhg1UFFQyepnzp+8UuZMN/mjpVnRUS7HPA/dwSkWzqOtHM4YqSnLfcx3szbRGAEYi1ogo/15N9nSnZWd8+xDFwDGTQBXpAIkg6F8ufevoaFl4OqHkv7DuMpgbEKggjVWvajO3C0JCzKoE01yA/SYa2OwgfzRjSJE0nOMl3wejAwjg13dYPbp4C4vQALdzfy0bshu2J9++qNCpETFhcDF4MEDwt1ohWUrW0SBdaGhWZ4DA2xsQEKj1KcGuWmT51anAjYfgzzv6Ons73ZA3qbHNi4HDOm8Te+48tsBPyQQaLJAG8PT2JWgFYZAngESWElwXe3ahIK4w6tBxPOwOHFhFFA3nt/Tcmd2gBkO2+OT3OAXoffC/0xa1cNe6wqLhIhQbnkOtbkzAj/U0GbjD9/UFli+TKU+jM0OR5NUu3fAF5YhmCd5/jCfiff2cgd79rqXbo/BYuJVk+kRdlm6AcVcbM0UzO+gJvslrZVUFoTM65FMvvErQY99
 BFoUqX0I
 TyLE3mOrWSCkSH96sbrfreiFaYUrFR+lZD+IGAt+HffcZwC0PL/dzdvjtPxxo7AtnALH3fpiZ1Ls9iak9YH00qI9X8Cq0GG1/kn9NzD4vKrXRz/9I/fvZwt2kzmrGm53Zbfwtxl7CBdN08yhSGUKDHBgOr3HQAY1e7X0wCiuCbfgrQ2fLTGX5VmaoKe8GRtqDTUz4TjbNzQv8ho5rlfb9ijLbtZrhlXb2+NMZdpIuPeJxytZBQ6xJ+/JjLxhbTBQs2Mg//v6bSCciiQ34kD0i6Sbuuyt9F5zKj2tF0tYZDiann0A2kuuE4g0kyejp+cvntbbhL+x6OESbXYQVkf/cwXwEWxlK5Xmf/u7CxvMf0yB89YS/6+AI3QQxfp96aJUMjdoIWjcTbyQy7VQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 5f65b11260e0..8d71f2e0fd85 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -330,6 +330,14 @@ static inline unsigned long nr_slots(u64 val)
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
@@ -433,11 +441,12 @@ static void add_mem_pool(struct io_tlb_mem *mem, struct io_tlb_pool *pool)
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
@@ -455,12 +464,13 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
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
 
@@ -473,6 +483,7 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 {
 	struct io_tlb_pool *mem = &io_tlb_default_mem.defpool;
 	unsigned long nslabs;
+	unsigned long alloc_nslabs;
 	unsigned int nareas;
 	size_t alloc_size;
 	void *tlb;
@@ -497,13 +508,14 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
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
@@ -869,6 +881,12 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
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


