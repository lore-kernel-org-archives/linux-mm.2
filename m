Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9513E606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LSTVSQ75
Received: by kanga.kvack.org (Postfix)
	id B09786B05BB; Wed, 11 Nov 2026 06:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1826B05BC; Wed, 11 Nov 2026 06:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F81D6B05BD; Wed, 11 Nov 2026 06:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768B76B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B19FA7AB2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:43 +0000 (UTC)
X-FDA: 85422565326.11.9153FB7
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id 476E314000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LSTVSQ75;
	spf=pass (imf09.hostedemail.com: domain of 3t0z0agoKCIAzhsrrijsvxksskpi.gsqpmry1-qqozego.svk@flex--vdonnefort.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3t0z0agoKCIAzhsrrijsvxksskpi.gsqpmry1-qqozego.svk@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395321;
	b=CSmN6QLp81Xz7acH+z9xy5wSwD6NXY4XgupjHyqmvA0QL0OKrpkxn55N89mIQJDZdXEF6t
	O93gTOjp+1XdA2I8EMkOatMQNtWu6z5kHv52TDos0zJaHP6aHS4YDNX1Dk8AHvUNMdHDDC
	FpEehwZf56bNpOwzvewK1oqgwy8KjXE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LSTVSQ75;
	spf=pass (imf09.hostedemail.com: domain of 3t0z0agoKCIAzhsrrijsvxksskpi.gsqpmry1-qqozego.svk@flex--vdonnefort.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3t0z0agoKCIAzhsrrijsvxksskpi.gsqpmry1-qqozego.svk@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k28NXrt+XbqyfRaacENrrFfeZjq4XEJuuf/YvC8HY10=;
	b=1JBnpxd2YJ+fDd2u2ojE7OnXd8fpb4/I3WWsc2EjphWiKBWOJyYdDdmfeRs21pTi1Zbygr
	NxCxqJliQ7HC359cIayk3wsKbV4oo9oYGivG0Cc9nRDYe1SG1IbtIRTzBkba94obepyIqh
	m09UXrBtp3bqXmG1dA59fMUCHL9jHCU=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c4d4d132bbeso351135166b.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395320; x=1795000120; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k28NXrt+XbqyfRaacENrrFfeZjq4XEJuuf/YvC8HY10=;
        b=LSTVSQ7558q26YkneYer7f3zlJQLXlzg/fKfU2lmxig0TmL8QhTh7rrEA0pBttEXBs
         2TJngjem2kh0vy1njIvf7zXAIJ3c2Y1JkjOjPujLlcRwwDdzs7uof4an0BRKNITJxmMf
         WyU+i4ZSzFFPmlxXJj7IUFXOU/Xr2FEzwWbvLYFx1wwa4JKBd8v2gU0XZnQWTUAiVbJm
         kZ5WhIG+CUgSQWoSIyTkzc5dCBg/ne/UdPOjzwMMYtcBcjNjinL8qCET2uUZ86fbHFDi
         cqXXT9yY66+hYc0VOiszlh6kkw0/rqyNHI1m4dwduduFV4TGDdLeJAS3bvMl/qQcpETl
         prbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395320; x=1795000120;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k28NXrt+XbqyfRaacENrrFfeZjq4XEJuuf/YvC8HY10=;
        b=WtuZtmWhEu/Jbw0aoY0bB1Dc8e8pZIbUV0/5OrpLFNCVcbNn5uoVJXVACBjVIOSrOD
         r5lxNdamcLfFvSnwEaRnW3N6pPcPWv0QokzeNUX5ZqUPLimnXVtYKk7s9XQsrVdPMjL4
         b4nxcqpC+RXZaRv8QL5S82On8y3dHrHkq45bwt1sw+RX30GqaH3lmfDATol0YlsCcISc
         hq6PcsqRwEhCOUbrZO+TVqO+pu8W3S1S5bCnNzmxLWJ8S/CguQ7ELfnxFsDaInaHiA9s
         MskFfrERNybwOJfZiyiKlREPuGJdZOERmKKkjEptP+rThdo5nay511GRiASjK56up3ML
         LLJQ==
X-Forwarded-Encrypted: i=1; AL+hErHe6+Bra4ghzqAhwmvhFIVmFTDc9wXQ1KfxqohQfgcJCJkWbekU/6TV++QAit9MAzBOpfQZbLoa4g==@kvack.org
X-Gm-Message-State: APuU4Z8t3J447evL6guK6HOyPXxEQnfED+B0mmE41kpq26jnfLkadXdf
	KkPRdrOZnPeoJCW9yoP3KhI2a91UWPVMbyueEqSR2MYEAq/2xSyGUt7J5ePTwzoDeoQlYAzzCcZ
	Irzonaej5Yimuq+g16sRv9A==
X-Received: from ejxe15.prod.google.com ([2002:a17:906:81cf:b0:c3f:75a:4837])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:2d2c:b0:c50:6222:7b1c with SMTP id a640c23a62f3a-c5066cc68c2mr168857666b.23.1794395319574;
 Wed, 11 Nov 2026 03:08:39 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:37 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-8-vdonnefort@google.com>
Subject: [PATCH v3 7/8] arm64: Add support for lendable-dma-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 97auui5kzg3atgfsposzy4ki8eg7rq7w
X-Rspamd-Queue-Id: 476E314000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794395321-128222
X-HE-Meta: U2FsdGVkX1/ey0xdobqNNgDGkKmk1t/f4EdS5jcqINgyk1uWKCcmT+WQ9BqPaxI5mLeTt0FpJZwhL5oxGC/i/ngnaL/Ipmz7fKsmybqOOsV2bXOPx/ZBRokZYRATQHODsyDXwbD309UtX5mDpIqHqYW0neXIEZJX9D5/nwr/a3+OUeOM+OPWBYnXokHrg3ADZOmw9R5IDY4O88l2zhSvTGqm8NHDPCp5qNXFxlrl8JVl8xCdn3IfRwXB+Wq/iAwxwGEAOGh4cUJ3uaDK84M34CiaWvN2uh+GMbh58eLTDZ7V3kTZot7IkrGcoYDfX3RlBuqQn3Dcxdb/g1AUxSFXoZYMIkPyzRDlY3GXnV5z3b63AMYKpqnUzifjmpRJ2jMmsEzNtbcIMDf9UE1Y+ttTgfl20JokncP/LYDzkacyDhAl8pDG9vty2GyqlGlPr2cQD/KDsGKq09nCqSYAL2brEQHm6VvVNZBZgUWG5Oc9cPLQp50/fmE7zGKlBWkFNW/LqYoqyS1ByEIWYqODP4JRGdjMa+Hf7Q9/dosgJKsJY32IJ1ewJFbJRwpDxnN0fysxwpX9WCWtFLnr1bscFiwc5CKf/GXRFXqIi00zDNp6EAJcrQhodxQglsYW5pRPNQfCY7uyCeEbGPoKJG4FNACWyycidROEcaQBzX8znrordN7fDsIza1sWZK8p/IYUHNjA42A6pSg/QAXTB5W/a3SgL97VAzvHpQ9npoiE7+TV0rMDzwM1Ah4n5xNs9hxHqfzHejPJ9D40h71HqQAWvkpqR5pwLWxw+W11Ar3xbSrQwNLEs6NDsbBq6m9KCQBvI/60aInsxJeP8Ld86XfGyhNtJi18D+DZoX0mkeMGYflguXB7BubQi27BoiiEPFEJ52Do/FRPPyE4AjvVl2m6ythxwpMxGSSvhF8gOci0gRbhe9TnyYz6QgidHyUQaYbQMzBJ/goDLi6wc9KZOZiJx3b
 O/xmmgcR
 6dTUM9LkLj6n8D+vTN+mjscqI9xR4hnPXvHSRMvKObeMPOXo0XiBQbVMq64sNIlpyLgajqpo4kDYyj+cGwbkPS3hLQGFVxGvCjQPkbzMGONrFU7UJsG0rLeacsZM1F+KeSk9QC5Q0qDbumRqmtNcFKC5+M6hp9nJWsGJqXUtYjDSmy2hCdGlxzsndxCAZwQU3HX0PQQAsbdbmK728P3knoVFmCu28HEWC9ofDYOSHvY7tmCzmviyPyqO1O9n2Mtp+QWEu/dXEZHGlcieBQZPWy9IMF4Ern0HeanY08+tcxsChbICe+Ph8xaNwtoKXAGF4hJsLZ9eoZkTZTDB2sPE2P8NPsz5VS/MOv8xsm+wBPCSnISVX39msUgr9dFGetoP0Z4gT+JRsx9Rj7fUZwNgqrZ6vy2cG1Cj3V3hiZc/OYb0uflwOKvgEAPtO/wyZoVPhL4dkrh6mQ+CMANEulguD3GHbFweEeCl+OuV5bE9LyhEdBBS71DZAJHy+wHQp2N72Cse8S7Qc/8o61zabTHOaGUhvzhAe6WcBMU8A6QcRNQeXSm8RSDgId4FLNJ5JY9WijHPmT+jnwMMVS3nPWANulz+Pvq1HVfDlayw8/BuTxsdAS1VxMnnUhARHefNRPBzFWbn1uKabj9lzh+WvMSNEFpQBSW+qt11Ea9ZEvrb2/duPWf3w1Ch9LiPkLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Even when the linear map uses block mappings, regions marked with
MEMBLOCK_PTEMAP are mapped at page granularity and can be modified at
runtime. Implement the architecture hooks for the lendable-dma-pool to
force the last-level mappings, validate ranges and update the direct
mapping.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/Kconfig                  |  1 +
 arch/arm64/include/asm/set_memory.h |  2 +
 arch/arm64/mm/dma-mapping.c         | 71 +++++++++++++++++++++++++++++
 arch/arm64/mm/pageattr.c            | 56 ++++++++++++++++++-----
 4 files changed, 118 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1075bc661833..34fe7a7eea82 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -117,6 +117,7 @@ config ARM64
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
 	select DMA_BOUNCE_UNALIGNED_KMALLOC
 	select DMA_DIRECT_REMAP
+	select DMA_LENDABLE if DMA_CMA
 	select EDAC_SUPPORT
 	select FRAME_POINTER
 	select FUNCTION_ALIGNMENT_4B
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index b6ec938703d6..ec8bbb59e51f 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -17,6 +17,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
+int __set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
+int __set_direct_map_default_noflush(struct page *page, unsigned int numpages);
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 7f6f2f40dba2..c324e9826ce2 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -7,9 +7,13 @@
 #include <linux/gfp.h>
 #include <linux/cache.h>
 #include <linux/dma-map-ops.h>
+#include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <xen/xen.h>
 
 #include <asm/cacheflush.h>
+#include <asm/set_memory.h>
+#include <asm/tlbflush.h>
 #include <asm/xen/xen-ops.h>
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
@@ -38,6 +42,73 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
 	dcache_clean_poc(start, start + size);
 }
 
+#ifdef CONFIG_DMA_LENDABLE
+int __init arch_dma_mark_lendable(phys_addr_t base, phys_addr_t size)
+{
+	if (!PAGE_ALIGNED(base | size))
+		return -EINVAL;
+
+	return memblock_mark_ptemap(base, size);
+}
+
+bool __init arch_dma_is_lendable(struct page *page, unsigned int nr_pages)
+{
+	return direct_map_is_ptemap(page, nr_pages);
+}
+
+int arch_dma_zap_direct_map(struct page *page, unsigned int nr_pages,
+			    bool from_lendable)
+{
+	unsigned long start = (unsigned long)page_address(page);
+	unsigned long end = start + ((unsigned long)nr_pages << PAGE_SHIFT);
+	int ret;
+
+	/*
+	 * arch_dma_prep_coherent() only cleans as normal DMA buffers retain a
+	 * cacheable linear-map alias. Since that alias is being removed here,
+	 * also invalidate to make sure they can't be evicted later on while the
+	 * memory is secured.
+	 */
+	dcache_clean_inval_poc(start, end);
+
+	if (from_lendable) {
+		ret = __set_direct_map_invalid_noflush(page, nr_pages);
+	} else {
+		might_sleep();
+		ret = set_direct_map_invalid_noflush(page, nr_pages);
+	}
+
+	if (ret)
+		return ret;
+
+	flush_tlb_kernel_range(start, end);
+
+	return 0;
+}
+
+int arch_dma_restore_direct_map(struct page *page, unsigned int nr_pages,
+				bool from_lendable)
+{
+	unsigned long start = (unsigned long)page_address(page);
+	unsigned long end = start + ((unsigned long)nr_pages << PAGE_SHIFT);
+	int ret;
+
+	if (from_lendable) {
+		ret = __set_direct_map_default_noflush(page, nr_pages);
+	} else {
+		might_sleep();
+		ret = set_direct_map_default_noflush(page, nr_pages);
+	}
+
+	if (ret)
+		return ret;
+
+	dcache_inval_poc(start, end);
+
+	return 0;
+}
+#endif /* CONFIG_DMA_LENDABLE */
+
 void arch_setup_dma_ops(struct device *dev, bool coherent)
 {
 	int cls = cache_line_size_of_cpu();
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index c7662fd2fcb2..467a420af0f5 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -167,8 +167,8 @@ bool __init direct_map_is_ptemap(struct page *page, unsigned int numpages)
 						      NULL, NULL);
 }
 
-static int update_range_prot(unsigned long start, unsigned long size,
-			     pgprot_t set_mask, pgprot_t clear_mask)
+static int __update_range_prot(unsigned long start, unsigned long size,
+			       pgprot_t set_mask, pgprot_t clear_mask)
 {
 	struct page_change_data data;
 	int ret;
@@ -176,10 +176,6 @@ static int update_range_prot(unsigned long start, unsigned long size,
 	data.set_mask = set_mask;
 	data.clear_mask = clear_mask;
 
-	ret = split_kernel_leaf_mapping(start, start + size);
-	if (WARN_ON_ONCE(ret))
-		return ret;
-
 	lazy_mmu_mode_enable();
 
 	/*
@@ -194,6 +190,18 @@ static int update_range_prot(unsigned long start, unsigned long size,
 	return ret;
 }
 
+static int update_range_prot(unsigned long start, unsigned long size,
+			     pgprot_t set_mask, pgprot_t clear_mask)
+{
+	int ret;
+
+	ret = split_kernel_leaf_mapping(start, start + size);
+	if (WARN_ON_ONCE(ret))
+		return ret;
+
+	return __update_range_prot(start, size, set_mask, clear_mask);
+}
+
 static int __change_memory_common(unsigned long start, unsigned long size,
 				  pgprot_t set_mask, pgprot_t clear_mask)
 {
@@ -316,28 +324,52 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_PRESENT_VALID_KERNEL));
 }
 
-int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
+int __set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_INVALID);
 
+	return __update_range_prot((unsigned long)page_address(page),
+				   PAGE_SIZE * numpages, set_mask, clear_mask);
+}
+
+int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
+{
+	unsigned long start = (unsigned long)page_address(page);
+	int ret;
+
 	if (!can_set_direct_map())
 		return 0;
 
-	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE * numpages, set_mask, clear_mask);
+	ret = split_kernel_leaf_mapping(start, start + PAGE_SIZE * numpages);
+	if (WARN_ON_ONCE(ret))
+		return ret;
+
+	return __set_direct_map_invalid_noflush(page, numpages);
 }
 
-int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
+int __set_direct_map_default_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
 
+	return __update_range_prot((unsigned long)page_address(page),
+				   PAGE_SIZE * numpages, set_mask, clear_mask);
+}
+
+int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
+{
+	unsigned long start = (unsigned long)page_address(page);
+	int ret;
+
 	if (!can_set_direct_map())
 		return 0;
 
-	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE * numpages, set_mask, clear_mask);
+	ret = split_kernel_leaf_mapping(start, start + PAGE_SIZE * numpages);
+	if (WARN_ON_ONCE(ret))
+		return ret;
+
+	return __set_direct_map_default_noflush(page, numpages);
 }
 
 int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt)
-- 
2.56.0.542.g3ef89b7020-goog


