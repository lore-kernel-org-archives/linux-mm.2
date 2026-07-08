Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9AB6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06DC6B009E; Wed,  8 Jul 2026 19:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A7E6B009F; Wed,  8 Jul 2026 19:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894C26B00A0; Wed,  8 Jul 2026 19:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49A126B009E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAED21C81EE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:06 +0000 (UTC)
X-FDA: 84967252692.05.9BF01CE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0D89A0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tTR226bq;
	spf=pass (imf25.hostedemail.com: domain of 37-FOaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=37-FOaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvwcKqkHQyZ2uoR9E1ljTn+X3nC24ulgVhMt0Kon6RQ=;
	b=Sa8lvS3glMvlgJ6NG+EZMweIKkyyhp8rwH1KBmRtCE4ok1AeULdVDEw95GKaLoRLyyoncO
	rz8ul9VtKW+qSQqRPQL40V9cZPUHN8FPyU2BoTlyp6LwE0RiV5WSsxLU4kUQ5UlD49cHdH
	Ek/F/MUwlKxCwyntuemfpvydjLeqsls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tTR226bq;
	spf=pass (imf25.hostedemail.com: domain of 37-FOaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=37-FOaggKCEg2urk6ktkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554544;
	b=v76fxLcqTmMfh2+szKZX5XN6oQMorluaMzdcWpiQbRJW6gI5wDIUKM9qHdmCSk+XRMBxTx
	G6f82cpCBk3BxuVEDmXPNoeiYnLr/nvmZ53Y6XDxuOIgjOPLBQYIFZ6MjvS/minEx9pcxi
	ESud+37maJtdA2UNsShBJZAP1fFQyH4=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2caf4173b1cso26605015ad.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554544; x=1784159344; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KvwcKqkHQyZ2uoR9E1ljTn+X3nC24ulgVhMt0Kon6RQ=;
        b=tTR226bqSg8b+661tHb0wAAhqe0ZIGroDX/CrDh4Lwj0JmTO3k1MebxaaPR15i0EZj
         b4K6s3pMa/VCaW2iqXMvR/W04tIR+dXqsMhGb91DeFBNCAyude3l/O8yO9PZto3AKq6O
         qeiTbjBw2muJhXqSJ4yrNMtEFnfTK9gGOy5o992fuqvQrqXfvuMoNT3zE5q2c9U4D4c8
         /CLIMQ29IgkoBkZJICZTOC68XpFjEr9mnjjAVTl4WhaS3lUprL66Pzn+0qdAnyx/hsOb
         6umq/HIXXmsNgw2QY/ZRCVs+giAE4THpNT+9afNK13iUL8kU4oPbVF23jRIQuH1X6SwP
         ahaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554544; x=1784159344;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KvwcKqkHQyZ2uoR9E1ljTn+X3nC24ulgVhMt0Kon6RQ=;
        b=AndpqxgASGbHO9FtGi79jYKvbn0QchtetnX3QvTd9K3/UaMlPcA1GwoyWDAWE2g/+K
         3WJhOrNqaO/X4fctwg2AeJ+SDoyt5xMVP/BMzXtPPmIPOR/qaO/+VOTd/qXApz4kcD9j
         0A6Y6DunnQpR0kfL5LkZ2k+CZM9mu85Or03xvcPJMSVw2KjEDMp77R+7H97EO2mPan2s
         w7kamMagp+7itjPafh8wzLPew67tukpLyXXsBnZqrI1igd9T+yypKWIJDsCPj83esI8G
         8qhAq9FAAnmx/hUPft5KplkFNWg3BQAadRNNQGoWlzBl34jzS+dHv6y9pbCDu4RqDXU/
         DCjg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7eqjTyxSytdoeNjGFDN/ZZ9hiob8jSVwjIJvIInN41k/tOc9iRyrQVywJBHfGElJXtiS5NAQqMQ==@kvack.org
X-Gm-Message-State: AOJu0Yxk/nlYK9xfkL2DxKMc7WOuOXQE5HtnP/gSmLy2s5b8NOs5sJra
	kemFOr+zPIFPV2GmmnZvfhEvjSMetK89wqEexZLoK4VrfEtAj3JiUiLXzcpdpZO0FiTyA8KuFTH
	a4CKGrCQ3gk/O9w==
X-Received: from pgh2.prod.google.com ([2002:a05:6a02:4e02:b0:c93:e04b:d9ad])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:9191:b0:3bf:6c08:284d with SMTP id adf61e73a8af0-3c0bd294eb5mr5386341637.60.1783554543571;
 Wed, 08 Jul 2026 16:49:03 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:54 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-11-skhawaja@google.com>
Subject: [RFC PATCH v2 10/10] dma-direct: Add KUnit test for liveupdate preservation
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0D89A0007
X-Stat-Signature: 9dqjnqhe8t7byc7qyr9oisx4w53q3cez
X-HE-Tag: 1783554544-628513
X-HE-Meta: U2FsdGVkX1/5Pe5t5VI+U/EuT5HBAkuQ3FVnQIhU7Hd0bCvprLf2l//hbarEpYP5/Kb1wezbGM3NO7a5BMWubjKkYaHc6r8zaTA3jcdNQVj6BPv0dHBLHrbzRczpwvMUzer9/4FtTbhuHXsam7wEBiOyv16CmCnhKV5Rlj10fL91pavdwzjwAmZ3YGMzRe338KEa1PLZdPHkCHOZkculvxDMv/+wsKqIBjIza4ml6D+fbidqD+92fayH1qCYTJYOg52cYss5iYAaYNTedzQmOxHGaCVR2IVi77djfXrmrWBnW7WtTAwUDpeuCvxtM6m9+8GwAz0FXe9Vs0q/xn8aTPsdJR5E1w8IAbrs1Atndha0g5z/E8+GSIGC9ryRdueDizhaQN56vu8lRUpw2O2Y/0M4Xpl6X1xSNl4whYpGX+Xu5xM2E9F+4kE+DBKdXxB6IKxhTgqCJ+z4qnx/VGkAT4aTLcNyjbCYxp/u0XfNUCUP+R2yTHSdgMZtqXS50xI6INhDyP5KCjPD6TJrOCb/g556s8h0A/bnHipa5YeHjZw1J4I1o1NVxZq+SZAr2ENW7HYGG2dU/uzeVXac4nUj8AqJV+Lv5JF6JmlF4WR3mhTm/0MYcRvPK0EoHvG1FBW+rr04/4o3+SvuEFCbgXadWNb9oQw7Fm0YqYBk+z1L/0ez98V4ULO7Esff9wrg7oOH9NoMAfvX0vSlWAYpKfazIEJCEtrGBJte4/rZ8K5pS/bfEkaoOux2l8nT/0MIdD4BYpwaLbTws4MP5D1P4kzzSWbljTXux6fhQKBcVaaw/VZF18Pk4+86ILls7kOIrURpuLNqPoRjdVPkuuwe09VIP1yqU+eFLa9S9h76+wL8Ndu25tY5016YakX8SEdn75pRCv05VHhk/V2ZuczORSIf02pfCNppk161NprOvCZv6hSEy9oZXYmkwnpEafW9cAAx5OS7pl0d1VC0bd4czsT
 nzy4aVjW
 vS8hDJji0aCb51rHwj5JOK3uscHC5pWlbwTA5wYU3UtO5G3pJbgn+X8GNLVSGPCpmy7k3YEvIZbzTIWDICpX0r4IWQ7EuuvdGC3K0yEF2qc72BVD25BIXDQmWIbkA25arnkq0OgwIOv6iFc1PwxFemLkp0lOEhfrCqAfXBGlt2a9tUPMQ+96MZ+1HVQttbpJQlaINVXpHQBRO32XEDZ3Kpv2hEAzhGYX6gbJRae4rwuVWgKCJTxsc2pzg7heGkITo7OsNfkbn3YB0q/O4BxhBVaQloc9XQNk76HZ4GHp+MWrTuFHb+2aEkDX9b7+IZwUqC6n7mN0CRKhwQx2AYWuVtznar39LYHLy7IzxKQ3pmNc5ilgjxkupKSNC1mOZEIkW4yufHEEtw/DIQzOfT2pTn+xtrjro/0LU/mPKmTTVZxPrdHEa38jKF1i9FrjPHF4X/41YaWcRWGMBnKu/JM48xzRef5PLPijwSvwIEa+L8vyt8eWYx+/ul76qNGudJMe7lTsv8tdo1AvSZYQL/CdQ7o03d9q2yEGEK4iD+qkq/+kZqEk9oxPZh4599jojaqdpTwjJ02vqGwpmwS5UbXiy5/E49eae2+VEvemd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the KHO kunit stubs to mock the KHO preserve/unpreserve/restore API
and tests the preservation of DMA allocations with,

- Device being coherent or non-coherent.
- Atomic or non-atomic context.
- Various allocation sizes.
- Managed DMA allocations

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/dma/Kconfig       |   8 ++
 kernel/dma/Makefile      |   1 +
 kernel/dma/direct_test.c | 208 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+)
 create mode 100644 kernel/dma/direct_test.c

diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index d93958931303..48bc74af551a 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -269,3 +269,11 @@ config DMA_MAP_BENCHMARK
 config DMA_LIVEUPDATE
 	bool "Enable preservation of DMA direct allocations"
 	depends on LIVEUPDATE
+
+config DMA_LIVEUPDATE_KUNIT_TEST
+	tristate "KUnit test for DMA direct liveupdate preservation"
+	depends on KUNIT
+	depends on DMA_LIVEUPDATE
+	help
+	  This builds the KUnit tests for the DMA direct liveupdate
+	  preservation and restoration logic.
diff --git a/kernel/dma/Makefile b/kernel/dma/Makefile
index 6977033444a3..03703542ee79 100644
--- a/kernel/dma/Makefile
+++ b/kernel/dma/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_SWIOTLB)			+= swiotlb.o
 obj-$(CONFIG_DMA_COHERENT_POOL)		+= pool.o
 obj-$(CONFIG_MMU)			+= remap.o
 obj-$(CONFIG_DMA_MAP_BENCHMARK)		+= map_benchmark.o
+obj-$(CONFIG_DMA_LIVEUPDATE_KUNIT_TEST)	+= direct_test.o
diff --git a/kernel/dma/direct_test.c b/kernel/dma/direct_test.c
new file mode 100644
index 000000000000..f8403ec47807
--- /dev/null
+++ b/kernel/dma/direct_test.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for DMA allocation live update preservation.
+ */
+
+#include <kunit/test.h>
+#include <linux/module.h>
+#include <kunit/static_stub.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-direct.h>
+#include <linux/kho/abi/dma_alloc.h>
+#include <linux/kexec_handover.h>
+#include <linux/slab.h>
+
+static const size_t dma_test_sizes[] = {
+	128,
+	PAGE_SIZE,
+	2 * PAGE_SIZE,
+	3 * PAGE_SIZE,
+	8 * PAGE_SIZE,
+};
+
+static void dma_size_desc(const size_t *size, char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "size=%zu", *size);
+}
+
+KUNIT_ARRAY_PARAM(dma_size, dma_test_sizes, dma_size_desc);
+
+static struct page *mock_kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
+{
+	struct page *page = phys_to_page(phys);
+
+	if (!kho_test_pages_preserved(phys, nr_pages))
+		return NULL;
+
+	kho_unpreserve_pages(page, nr_pages);
+	return page;
+}
+
+static struct folio *mock_kho_restore_folio(phys_addr_t phys)
+{
+	struct folio *folio = page_folio(phys_to_page(phys));
+
+	if (!kho_test_pages_preserved(phys, (1 << folio_order(folio))))
+		return NULL;
+
+	kho_unpreserve_folio(folio);
+	return folio;
+}
+
+static void test_dma_direct_preserve_restore_common(struct kunit *test,
+						    bool coherent,
+						    bool atomic,
+						    size_t size)
+{
+	unsigned long nr_pages = 1 << get_order(size);
+	dma_addr_t handle1, handle2;
+	int ret, expected_ret = 0;
+	struct device dev = {0};
+	gfp_t gfp = GFP_KERNEL;
+	void *addr1, *addr2;
+	u64 state;
+
+	kunit_activate_static_stub(test, kho_restore_pages, mock_kho_restore_pages);
+	kunit_activate_static_stub(test, kho_restore_folio, mock_kho_restore_folio);
+
+	device_initialize(&dev);
+	dev.coherent_dma_mask = DMA_BIT_MASK(64);
+	dev.dma_mask = &dev.coherent_dma_mask;
+#if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
+    defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
+    defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
+	dev.dma_coherent = coherent;
+#endif
+
+	if (atomic)
+		gfp = GFP_ATOMIC;
+
+	addr1 = dma_alloc_coherent(&dev, size, &handle1, gfp);
+	if (!addr1) {
+		kunit_skip(test, "DMA allocation failed (unsupported configuration)");
+		return;
+	}
+
+	if (IS_ENABLED(CONFIG_DMA_COHERENT_POOL) && dma_is_from_pool(addr1, size)) {
+		expected_ret = -EOPNOTSUPP;
+		kunit_info(test, "DMA allocation using pool, expecting -EOPNOTSUPP");
+	} else if (dma_is_from_cma(dma_to_phys(&dev, handle1), size)) {
+		expected_ret = -EOPNOTSUPP;
+		kunit_info(test, "DMA allocation using CMA, expecting -EOPNOTSUPP");
+	}
+
+	ret = dma_preserve_coherent_allocation(&dev, addr1, size, handle1, &state);
+	KUNIT_ASSERT_EQ(test, ret, expected_ret);
+
+	if (!expected_ret) {
+		KUNIT_EXPECT_TRUE_MSG(test,
+				      kho_test_pages_preserved(dma_to_phys(&dev, handle1), nr_pages),
+				      "Allocated block not tracked in KHO");
+
+		addr2 = dma_restore_coherent_allocation(&dev, size, &handle2, gfp, state);
+		KUNIT_ASSERT_NOT_NULL(test, addr2);
+
+		KUNIT_EXPECT_EQ(test, handle1, handle2);
+		dma_free_coherent(&dev, size, addr2, handle2);
+		KUNIT_EXPECT_FALSE_MSG(test,
+				       kho_test_pages_preserved(dma_to_phys(&dev, handle1), nr_pages),
+				       "Allocated block still tracked after free");
+	} else {
+		dma_free_coherent(&dev, size, addr1, handle1);
+	}
+}
+
+static void test_dma_direct_coherent(struct kunit *test)
+{
+	const size_t *size = test->param_value;
+
+	test_dma_direct_preserve_restore_common(test, true, false, *size);
+}
+
+static void test_dma_direct_non_coherent(struct kunit *test)
+{
+	const size_t *size = test->param_value;
+
+	test_dma_direct_preserve_restore_common(test, false, false, *size);
+}
+
+static void test_dma_direct_coherent_atomic(struct kunit *test)
+{
+	const size_t *size = test->param_value;
+
+	test_dma_direct_preserve_restore_common(test, true, true, *size);
+}
+
+static void test_dma_direct_non_coherent_atomic(struct kunit *test)
+{
+	const size_t *size = test->param_value;
+
+	test_dma_direct_preserve_restore_common(test, false, true, *size);
+}
+
+static void test_dmam_preservation(struct kunit *test)
+{
+	dma_addr_t handle, non_dmam_handle;
+	void *addr, *non_dmam_addr;
+	struct device dev = {0};
+	size_t size = 128;
+	u64 state;
+	int ret;
+
+	kunit_activate_static_stub(test, kho_restore_pages, mock_kho_restore_pages);
+	kunit_activate_static_stub(test, kho_restore_folio, mock_kho_restore_folio);
+
+	device_initialize(&dev);
+	dev.coherent_dma_mask = DMA_BIT_MASK(64);
+	dev.dma_mask = &dev.coherent_dma_mask;
+#if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
+    defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
+    defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
+	dev.dma_coherent = true;
+#endif
+
+	non_dmam_addr = dma_alloc_coherent(&dev, size, &non_dmam_handle, GFP_KERNEL);
+	if (!non_dmam_addr) {
+		kunit_skip(test, "DMA allocation failed");
+		return;
+	}
+
+	ret = dmam_preserve_coherent_allocation(&dev, non_dmam_addr, size, non_dmam_handle, &state);
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EINVAL, "Preserving non-devres allocation should fail");
+	dma_free_coherent(&dev, size, non_dmam_addr, non_dmam_handle);
+
+	addr = dmam_alloc_coherent(&dev, size, &handle, GFP_KERNEL);
+	if (!addr) {
+		kunit_skip(test, "DMA allocation failed");
+		return;
+	}
+
+	ret = dmam_preserve_coherent_allocation(&dev, addr, size, handle, &state);
+	KUNIT_ASSERT_EQ_MSG(test, ret, 0, "Failed to preserve dmam allocation");
+	KUNIT_EXPECT_TRUE(test, kho_test_pages_preserved(dma_to_phys(&dev, handle), 1));
+
+	dmam_unpreserve_coherent_allocation(&dev, addr, size, handle, state);
+	KUNIT_EXPECT_FALSE(test, kho_test_pages_preserved(dma_to_phys(&dev, handle), 1));
+
+	dmam_free_coherent(&dev, size, addr, handle);
+}
+
+static struct kunit_case dma_direct_test_cases[] = {
+	KUNIT_CASE_PARAM(test_dma_direct_coherent, dma_size_gen_params),
+	KUNIT_CASE_PARAM(test_dma_direct_non_coherent, dma_size_gen_params),
+	KUNIT_CASE_PARAM(test_dma_direct_coherent_atomic, dma_size_gen_params),
+	KUNIT_CASE_PARAM(test_dma_direct_non_coherent_atomic, dma_size_gen_params),
+	KUNIT_CASE(test_dmam_preservation),
+	{}
+};
+
+static struct kunit_suite dma_direct_test_suite = {
+	.name = "dma_direct_liveupdate",
+	.test_cases = dma_direct_test_cases,
+};
+kunit_test_suite(dma_direct_test_suite);
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_DESCRIPTION("KUnit test for DMA direct live update preservation");
+MODULE_LICENSE("GPL");
-- 
2.55.0.795.g602f6c329a-goog


