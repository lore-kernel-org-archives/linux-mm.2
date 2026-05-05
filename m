Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFC8CD343B
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877106B0092; Mon,  4 May 2026 20:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84FA16B0093; Mon,  4 May 2026 20:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765466B0095; Mon,  4 May 2026 20:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 606AD6B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:27:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A7CD120345
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:47 +0000 (UTC)
X-FDA: 84731478174.04.74188B6
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 35E2814000F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q2/6JLc9";
	spf=pass (imf26.hostedemail.com: domain of 3fzn5aQgKCC4cURKgKTKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3fzn5aQgKCC4cURKgKTKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777940865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2hjkJ1In2ag1iLE+KuZ3epwvTGInKsCURDrkdhtZDM=;
	b=h3Mv2pI71wNyzxdOYAerN/+Lt1BtcwZg6KxeKB0xCbfWIasozdrM/PUezRPpQScFBuTQY0
	hXwvZ7WTApuVUHCoREx6TN1LtPrwVwFdeTYtux3g56z+D+EWVXTFVstB1m5LaiN9g6Kdou
	CZ3kHaO3ZDvOqCv/0KlzmK0pDJJLegs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q2/6JLc9";
	spf=pass (imf26.hostedemail.com: domain of 3fzn5aQgKCC4cURKgKTKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3fzn5aQgKCC4cURKgKTKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777940865; a=rsa-sha256;
	cv=none;
	b=UpvSdH4ntWSnqStrmb6rKDiq089cVNsisv9DZ9paUDureYGums3bGIqVAvK12LW6oGxgna
	/wR7bEl0cBnRgZBRulGk4c1Gz+3+k6EEvjE5MUgcLMFtO2aQR4mSDHM1ryxSt9ZENPtlTF
	ZHaOL3o4+9RDEPIjfm2gjSTdJJcqe9M=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82d40278103so2750585b3a.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777940864; x=1778545664; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M2hjkJ1In2ag1iLE+KuZ3epwvTGInKsCURDrkdhtZDM=;
        b=Q2/6JLc92vR2stHJ/fP3wjhr8VtXj5s26kgY0xaoARCYacT6dFB0F9zH/aC26J6twV
         ao/mO0QmbaptGXlRMgthuZNo/qOCoWHaZMZjh7JwCDkYGxsm/2JFgaaQ9u0btgSsD1TQ
         7ahtIM2Hzj9rtbQtB4heYjdGUWoGK6SXc9yZ7Sq4TIJ5iTwGcTsjGndjB1xa3IfB1QB9
         AQdJP3z2626TzxH4Qhb/wBnUjlxnUPUp2Zj4LsTWNWWSvndWxiqhgKlnfjAngMpYCJOC
         7yqGR14SnN1K4EkU/meHkdvB2LdunKweB3GP6q6MOYfEvy9jISHyvfWf8pUs7+qz6N7q
         WMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777940864; x=1778545664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M2hjkJ1In2ag1iLE+KuZ3epwvTGInKsCURDrkdhtZDM=;
        b=KEd5HwDXHrgNPuTARcO768ZjJW1kdOD2++qUFRSO38Pe+k/Q65sun6neLu8nCG3NJo
         kBqm6kmQoqb/0RVHrwV9vKSBkcRCd2NjtcAXX7Iqk2pvdeAM2UJ1ZL3XImaDrcJkOQsL
         hCXkP3ec4zMfFWqsvkpIwl+wwep3mJJPNORjqh2pZTDmxI3eU/S8ALN8w5Tevrrto9dr
         AWd36MZoEweKOoJUogxy9BMDtTSeQ7VgXBiYe6uFEkcbC0YQ/sh9YEgmCdVbl2cgvXuM
         7pxhdz5wVwrDLd/NSvl4peuNnGjgUgfzNbQed4TRLqWSICJLLe7XkwCYJoSEPQYIxHBl
         dywA==
X-Forwarded-Encrypted: i=1; AFNElJ+G76oNadkWP5Z3TR+2bo5gBr1LwVWTQbR9KoOJoRLEL/52KJv9bBml1G6Iq1jyum8prWcwZDqoQw==@kvack.org
X-Gm-Message-State: AOJu0YyzcUY89l50lvXDFswIUz55LKJjIwREPuVrqJUIRDM5EmMDwS1T
	jfqdudT+OYF6kof7XhzI+g1TVPG4Zj++85Fudj/+CBYsCF53USKFCJMAQSufW7kfnh6hFia5t5C
	jyEowm+QLLGEI8A==
X-Received: from pfde22.prod.google.com ([2002:aa7:8c56:0:b0:82f:4abd:a354])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4fcd:b0:838:af72:fb35 with SMTP id d2e1a72fcca58-83921ef6ff6mr943516b3a.10.1777940863669;
 Mon, 04 May 2026 17:27:43 -0700 (PDT)
Date: Tue,  5 May 2026 00:27:36 +0000
In-Reply-To: <20260505002737.2213734-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260505002737.2213734-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505002737.2213734-4-skhawaja@google.com>
Subject: [RFC PATCH 3/4] dma-direct: Add API to preserve/restore allocations
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35E2814000F
X-Stat-Signature: u9j3dg488dqbgos55knusqh9kcug9m5m
X-HE-Tag: 1777940864-140195
X-HE-Meta: U2FsdGVkX18mdiL0+6Es/CerFAHh901a5eNw0ACqfb01a1l9TYL1ha7eJnWBG9J3samwgUC8OhFmoOZgmjF4BR8TfEgLQkCoXAa/iTd+pA08vOqB0HSM5xxKLz8frSfsE1kIMFDMolxUHjzcCYzm8dlhMHDaU3pCzUbtmtKsALCk++O6C/yjT6fQ/eAIwT2/ljGEZJtIHAkEcTcpDhC2Nx8sdRvGk/n8OjKeWgdlMl+sGRgPaZCUN7DDDgdEQkClOds4y/cpqE5HEK4YDl3yW4uwUsT4u4XuL00qKfIg7KEX4cKl5bnLqLHt+bbsF/HaA6W3JMrsrIQ5GWSWnG9SD2CKy/VYAKNqPCHRBvGA+8aagXkolptLvDh2P2Ton7coj3ENNWF8DPSV4J6l8reiO95Wo3/dhyTsQoVTLda8CgnePOQ+u+Z+5MwFwOlURFW3AWWLWrC11mB3DbzxOK8iFYcTtc4eCETUojoGwnFsWD0FIDY8PZFUJ8a+rmjkVeEbowYCey6RBqsHS8XXpiNpO3AIr2BXO1l8QcqTKg0hA0ysjTjwyEJ9sMQem6PlLlbRTXM7Cqc/tO96aQbyva3y0NnbtjCkjVZj2y3jr8/wO4LaMZyn5RPT4y9S3Se8wi51d1opMCrM1+wcGaGbLRmu8+FMyQs7xibAXg0UYgiX6/tsuxWanyCAqmSDvIYX90iWpOQ2j6kdUBCMesGbc2cWvjVZV3QZp+ZGGkqJt0mExGnK1o79M9UzKlTDgOyd/EsmoCHvrilUXRiaWeWCSwlbl+MtU0jqCk2dIx8OB0659jX4RrpgKlFcLQhP/dr6SG48JbfotaGMYHASMN6LASHCJQN4u37d5agEgmp+felrgkKKO/iph1mlPqFroOvlj1Eimx1fKLpWJBgVmhV+KnQefAlzvSDEtCvLXf6Qnq8hZagwBa4J6HXKyq7Rk0hyzvBrGlrzfLot6PMMx3EdlF5
 2wTLbHTy
 m2XA+z+gWj9beY5Gb4fVPsZ8fzA0muqXqCqtl91M2jnVyv/mMDd1NnwC/HwfMWC7lP1HLbxijaXyifcWBgrz9td9eBnKxGauU9ylKWO25BAmlmbnLplDR6/83U9KLFzdaRZNoMFYbkKpqrZ8XSUYmUhE4hq0y1U3h82JlOS/T36zi5oEDLMP0ACfCeVCibnftu0M5tqEmGMAzpRiV7n18pa42dnCFDvYi83qOsX/R2piVzR2E1tnJ0zI+6JSoXo0CqqwAcwcwJ2Cm+dXzIBAs9s/5E6JlpMHE1UyL+tVhfj8Sl21Xud1rCetevHpe+1zNS8cMWpEdj89odmV0qo/d86XEGYhZEu6yRlMx9YxtfZYQczYiT7LyZJ2wStpJ9noFggydHW0OSI6FSneybVcPAjjRH9EgGPr1JEN11CMsx8MQiE9+lwhapZ7TGpoSg87R5uOAaPqJCLYLAplYX6/u1S2NYyZmqkOMBtOgQaYzO8qDC5h2p4h3A+oF5La+A6UXcn1CglLjhuDLuJVJhEpbkK4fUxeLaaT2T25NFw8ixReYGy37rR0SlkPaZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an API to preserve/restore the DMA direct allocation for liveupdate.
The underlying memory is preserved/restored using KHO. During restore
the memory is setup based on the device configuration, gfp flags and
allocation attributes. Once restored, the driver can use the usual
dma_free* API to deallocate the restored DMA allocation.

This API will be used to add support in dma_alloc* APIs to
preseve/restore the DMA allocations.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-direct.h |  29 +++++++
 kernel/dma/Kconfig         |   3 +
 kernel/dma/direct.c        | 163 +++++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index c249912456f9..0efe2bc1a815 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -141,6 +141,35 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
 u64 dma_direct_get_required_mask(struct device *dev);
 void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
+
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
+				   size_t size, dma_addr_t dma_handle,
+				   unsigned long attrs, u64 *state);
+void dma_direct_unpreserve_allocation(struct device *dev, u64 state);
+void *dma_direct_restore_allocation(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    unsigned long attrs, u64 state);
+#else
+static inline int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
+						 size_t size, dma_addr_t dma_handle,
+						 unsigned long attrs, u64 *state)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void dma_direct_unpreserve_allocation(struct device *dev, u64 state)
+{
+}
+
+static inline void *dma_direct_restore_allocation(struct device *dev, size_t size,
+						  dma_addr_t *dma_handle, gfp_t gfp,
+						  unsigned long attrs, u64 state)
+{
+	return NULL;
+}
+#endif
+
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
 struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index bfef21b4a9ae..d92852942c6c 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -265,3 +265,6 @@ config DMA_MAP_BENCHMARK
 	  performance of dma_(un)map_page.
 
 	  See tools/testing/selftests/dma/dma_map_benchmark.c
+
+config DMA_LIVEUPDATE
+	bool "Enable preservation of DMA direct allocations"
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index ec887f443741..c2b98f91900a 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -6,6 +6,8 @@
  */
 #include <linux/memblock.h> /* for max_pfn */
 #include <linux/export.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/dma_alloc.h>
 #include <linux/mm.h>
 #include <linux/dma-map-ops.h>
 #include <linux/scatterlist.h>
@@ -307,6 +309,167 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	return NULL;
 }
 
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
+				   size_t size, dma_addr_t dma_handle,
+				   unsigned long attrs, u64 *state)
+{
+	struct dma_alloc_ser *ser;
+	int ret;
+
+	if (!kho_is_enabled())
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_DMA_CMA))
+		return -EOPNOTSUPP;
+
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
+	    !dev_is_dma_coherent(dev) &&
+	    !is_swiotlb_for_alloc(dev))
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_DMA_GLOBAL_POOL) &&
+	    !dev_is_dma_coherent(dev))
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_DMA_COHERENT_POOL) &&
+	    dma_is_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
+		return -EOPNOTSUPP;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->page_phys = dma_to_phys(dev, dma_handle);
+	ser->force_decrypted = force_dma_unencrypted(dev);
+	ser->size = size;
+
+	ret = kho_preserve_pages(phys_to_page(ser->page_phys),
+				 size >> PAGE_SHIFT);
+	if (ret) {
+		kho_unpreserve_free(ser);
+		return ret;
+	}
+
+	*state = virt_to_phys(ser);
+	return 0;
+}
+
+void dma_direct_unpreserve_allocation(struct device *dev, u64 state)
+{
+	struct dma_alloc_ser *ser;
+
+	if (!kho_is_enabled())
+		return;
+
+	ser = phys_to_virt(state);
+	kho_unpreserve_pages(phys_to_page(ser->page_phys),
+			     ser->size >> PAGE_SHIFT);
+	kho_unpreserve_free(ser);
+}
+
+void *dma_direct_restore_allocation(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    unsigned long attrs, u64 state)
+{
+	bool remap = false, set_uncached = false;
+	struct dma_alloc_ser *ser = NULL;
+	struct page *page;
+	void *cpu_addr;
+
+	if (!kho_is_enabled())
+		return NULL;
+
+	ser = phys_to_virt(state);
+	page = phys_to_page(ser->page_phys);
+
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
+		return NULL;
+
+	if (!dev_is_dma_coherent(dev)) {
+		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
+		    !is_swiotlb_for_alloc(dev))
+			return NULL;
+
+		if (IS_ENABLED(CONFIG_DMA_GLOBAL_POOL))
+			return NULL;
+
+		set_uncached = IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED);
+		remap = IS_ENABLED(CONFIG_DMA_DIRECT_REMAP);
+		if (!set_uncached && !remap)
+			return NULL;
+	}
+
+	if (PageHighMem(page)) {
+		remap = true;
+		set_uncached = false;
+	}
+
+	/*
+	 * Remapping will be blocking so return error. The preserved memory
+	 * might be already decrypted in the previous kernel, but the decryption
+	 * call is not guaranteed to be non-blocking so return error always if
+	 * decryption is required.
+	 */
+	if ((remap || force_dma_unencrypted(dev)) &&
+	    dma_direct_use_pool(dev, gfp))
+		return NULL;
+
+	/*
+	 * Encryption scheme changed between two kernels and this might cause
+	 * issues if device/driver is not handling it properly.
+	 */
+	WARN_ON_ONCE(ser->force_decrypted != force_dma_unencrypted(dev));
+
+	/*
+	 * arch_dma_prep_coherent() should make sure that any cache lines from
+	 * the previous kernel, if the device was coherent previously or cached
+	 * mapping in this kernel during init are not problamatic for
+	 * non-coherent allocations.
+	 */
+	if (remap) {
+		pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
+
+		if (force_dma_unencrypted(dev))
+			prot = pgprot_decrypted(prot);
+
+		arch_dma_prep_coherent(page, size);
+
+		cpu_addr = dma_common_contiguous_remap(page, size, prot,
+						       __builtin_return_address(0));
+		if (!cpu_addr)
+			return NULL;
+	} else {
+		cpu_addr = page_address(page);
+		if (dma_set_decrypted(dev, cpu_addr, size))
+			return NULL;
+	}
+
+	if (set_uncached) {
+		arch_dma_prep_coherent(page, size);
+		cpu_addr = arch_dma_set_uncached(cpu_addr, size);
+		if (IS_ERR(cpu_addr))
+			return NULL;
+	}
+
+	*dma_handle = phys_to_dma_direct(dev, ser->page_phys);
+
+	/*
+	 * Cannot free the restored pages on error here as these might be in use
+	 * by a device with direct allocation in the previous kernel.
+	 */
+	WARN_ON(!kho_restore_pages(ser->page_phys,
+				   ser->size >> PAGE_SHIFT));
+	kho_restore_free(ser);
+	return cpu_addr;
+}
+#endif
+
 void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
-- 
2.54.0.545.g6539524ca2-goog


