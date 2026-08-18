Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3F9C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076C46B05AF; Tue, 18 Aug 2026 12:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F0F6B0779; Tue, 18 Aug 2026 12:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA68D6B077B; Tue, 18 Aug 2026 12:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C04386B05AF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:12:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D4EE1C0B3B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:12:21 +0000 (UTC)
X-FDA: 85114882482.30.1E15713
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8EF2018000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:12:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JFey5Q 6";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gf1Pg/UPH/0kBqLveAwdBgpF0kwi0Ihdzo5FLTaazDI=;
	b=dJF7wmlLOD2q8yR6PbIm/s+Q6huO2WzR4HnwbuW4m78xRhfAEU/qi57WaHCFKO9zVZSndH
	G0iYoSnD5ESmfgU/t8i0KTmi9RPm7m1xvz5uk2TLAeiBqEqLFROi9vatQE+5pdr1fNIN2D
	M9qLxq5TFhy3DHahPhUQtXWXWrm0ebQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069539;
	b=auHxQUYV8XXHvvf2e1On/unrRlWvQt1JqM9RAOADWW4M5PavpuuP8RWTet66BhP1GVO4+J
	LVU0LJr92xVLnFGHa3VaIYOGBx2j7++puMmXV/fCBERnFnV82Fm5bzNYjBQlMt2Nrj3bR3
	6Kx5MU5T8ireMhqBoO2rzHyIU6NkoN0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JFey5Q 6";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=gf1Pg/UPH/0kBqLveAwdBgpF0kwi0Ihdzo5FLTaazDI=; b=JFey5Q
	6yUah1vgEUV0Tn7OtIL4PiFKVd44fMbcfmotMZ84bL0ZbpUXc1+nSUEONU0Jhivmw6gnIwAS6hhrq
	WJ6R4GUMbn+viaJb1RPXyruerTHWYfjV+IyrAUX0gB88+wwm17Vj67LteQfQVLgZtsb0WTxZlyj8i
	9y6yrH3sGcauIAAzZbVZgIc8d0uNxjpk5keLneHRKmftUQmib2csqdUOWC3wd/MLRiReKl3g0Q2ch
	4aaC+ac7OAJ8ojk3LROeAiDdGnNQ4PYT3N97bdHp9v/vgg97AvtFhXItMP9MOF84qdDnLdttOY6z+
	AfRmIl20BP6p1MPesFaknrOUAxmQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wwLga-00000001TR7-1gpD;
	Tue, 18 Aug 2026 15:25:08 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	iommu@lists.linux.dev,
	liam@infradead.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	ashok.raj@oss.qualcomm.com,
	jgg@ziepe.ca,
	kyle@mcmartin.ca,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 3/3] iommu/iova: add KUnit test suite
Date: Tue, 18 Aug 2026 11:25:03 -0400
Message-ID: <20260818152505.1057922-4-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818152505.1057922-1-riel@surriel.com>
References: <20260818152505.1057922-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nrsxaqmq9os9tzhk3nxis5hgc6qtzdb4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EF2018000C
X-HE-Tag: 1787069539-524362
X-HE-Meta: U2FsdGVkX18lm418StguimQsMxuaf6624GW5KwHe5tuYlcQwi8tWk6HUHjWZ8Z7hwTYqwypX2T6koSvA3VIJKrw/9qS7/2RlXy4h0/ji5DcC+YST3c/tRL55l2PZBVwVVEEI9XjsWy43bYc1aTk4K5YMGfQX/ghFJ6Q8lguJ71l5Dx/nJr7FfK5Zqefhmnwv6YEinZq2kMbClI+E9TYri+Kg4mp6o8mmocTere3mXdQn0Ht91CLvI8W820P5zttKUISClYrwi0wIMHnYUbtY17abL3v1yLoDetdo9QlNnL39bEi4Cnkvl94ZWAcQWhgwEHTdOt8wmTRWgbKk96eNw+bLcYmWaxDhs5vGTCt2ddXw3Ad2yiOcu5KJ5/iZ/UgbqmR85G8C4QqAZIQ1OyioAYG4XqWBRs8FunfBUfZt9DOYapUfB6yE2TFMvklcfSrhoZcdyRL4Aaxoxs1ZkZdCxgYK2g+dtrr0G0D6pbYxElykarqyp8MbwltKZs6z6p5UhPjTX69T/lyUC2NhRDODfAb8FT5bF1ckBb1Ed1FZPAWIj29xiUT52Z3fZCJ4bTEvN6M/weKlUxTp3F5vf7rDFDghm1wWWUnLQThd3rAwkYaWsqeT6Pr41M3VUT5AGbbfPicdwaSWxnXZg/4qLoDnwRz5G1tmjprf+UDGJiu0cpphhRY6EL+zh7fFaNZevvJ5/wL4d0tYswi2873EhnxqU9CClFBvuxmf76VM7mn+Pkn6wo8XdKAIs/jpbkXx/5ATS79g0k8EKR5mfrEJUI+RSDDVHsaP2pHlo2OQZGxPw0dE5Yk63uNbD14ryCaH7Ftj3vW46WdsEV9yHpykThrlEa4qP5yuxIuqpfFWUb22sVChlnakdtI1HHJvcESP+PG77XAkQgvP5LNvBVY1WJjJ3sz+YSemjo+1iPo5ATKDVY6BWVepxFhbWKKoQI/5CywwRW46abeO858WTFp74m5
 vP3yIp+h
 Ufvv/nUAjFY4RU3Qgh6sTu2ckgkfAUWZpfSaVceNqPzD+TkB0iPFHVCC5uAAg/jBG+Eh3NDYoC3INjk0nufVxojUMjwVweVurgzaErFZmiO8oDotHtk7KQR67VtZ3Cpb7ykn4qO4Uag2jIbX/p+EXPSLFIw4egYf+YXIDsLTI5V+smyoA0P4rNLoEdCTT3Vhw76aQYK9IP1nxbrhaY/z4ziMIQ7SLWB3omKwvWHx3sX3TCMDHchT2Jx1lCNs0d+ZHjDuhG73qKA/yrEXKQD1E3Itlt4OBW6qqxZXK9dya+LhH2MLlxGgjUwiA/rzE0/Xw3xNp1jub4ukLnoc6sT2ZN1QlCWcL4C4y3gbQ3jqtHVDMeKH4dCcKa5+RcXUmRoEjNs8BqCdncNMjW7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a KUnit suite for the maple tree based allocator, plus an
iova_domain_verify_invariants() helper, built only with the test config,
that walks the tree and checks that every entry's pfn_lo and pfn_hi
match its index range and that no two entries overlap.

The cases cover size-aligned allocation across orders 0 to 7, top-down
placement, reserved ranges, a 32-bit allocation in a filled 64-bit
domain, arbitrary limit_pfn values, allocation into a fragmented space,
and the 32-bit-first with 64-bit fallback pattern from dma-iommu.c.

test_stress_random runs 2048 random allocations and frees with mixed
sizes, alignments and DMA limits, checking the invariants after each
operation, from a fixed seed so a failure reproduces across boots.

Two cases fill the space and then time an allocation that has to fail,
which with the rbtree meant walking every entry.

A test hook in remove_iova() forces the GFP_ATOMIC erase to fail, so the
suite can check that the IOVA_DEFERRED marker keeps the range reserved
and that iova_drain_deferred() hands it back.

remove_iova() also relies on that marker store not failing in turn, since
it frees the struct iova while the tree still holds the range.

The guarantee comes from the maple tree. mas_wr_extend_null() widens a
NULL store over the neighbouring free ranges, and the wider store may
need a node. A non-NULL value over the entry's own range is never
widened, so it is an exact fit needing none.

iova_kunit_store_types() reports the store type picked for erasing an
iova and for marking it deferred. test_marker_store_needs_no_node()
drives it over an iova with free neighbours on both sides: erasing is not
an exact fit, marking is, and marking asks for no nodes.

A change to the store-type rules then fails a test rather than reaching a
WARN whose only recovery is to strand an address range.

Run with:
  tools/testing/kunit/kunit.py run --kunitconfig=drivers/iommu

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 drivers/iommu/.kunitconfig |   6 +
 drivers/iommu/Kconfig      |  16 ++
 drivers/iommu/Makefile     |   1 +
 drivers/iommu/iova-kunit.c | 544 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/iova.c       |  87 +++++-
 include/linux/iova.h       |   8 +
 6 files changed, 661 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/.kunitconfig
 create mode 100644 drivers/iommu/iova-kunit.c

diff --git a/drivers/iommu/.kunitconfig b/drivers/iommu/.kunitconfig
new file mode 100644
index 000000000000..d2bb924b1883
--- /dev/null
+++ b/drivers/iommu/.kunitconfig
@@ -0,0 +1,6 @@
+CONFIG_KUNIT=y
+CONFIG_IOMMU_SUPPORT=y
+CONFIG_IOMMU_IOVA=y
+CONFIG_IOMMU_IOVA_KUNIT_TEST=y
+CONFIG_KASAN=y
+CONFIG_KASAN_GENERIC=y
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 6e07bd69467a..904e04aeae21 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -3,6 +3,22 @@
 config IOMMU_IOVA
 	tristate
 
+config IOMMU_IOVA_KUNIT_TEST
+	tristate "KUnit tests for the IOVA allocator" if !KUNIT_ALL_TESTS
+	depends on IOMMU_IOVA && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable kunit tests for the IOVA allocator. The tests exercise
+	  basic allocation and free, size-aligned allocation, top-down
+	  ordering, bounded allocations with various DMA limits (32-bit,
+	  33-bit, 56-bit), aligned allocations in fragmented domains,
+	  and randomly-fragmented stress scenarios.
+
+	  Run with:
+	    tools/testing/kunit/kunit.py run --kunitconfig=drivers/iommu
+
+	  If unsure, say N here.
+
 # IOMMU_API always gets selected by whoever wants it.
 config IOMMU_API
 	bool
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2f05725eaab1..0b533911f25f 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE_KUNIT_TEST) += io-pgtable-arm-selftests.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_DART) += io-pgtable-dart.o
 obj-$(CONFIG_IOMMU_IOVA) += iova.o
+obj-$(CONFIG_IOMMU_IOVA_KUNIT_TEST) += iova-kunit.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o
 obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
diff --git a/drivers/iommu/iova-kunit.c b/drivers/iommu/iova-kunit.c
new file mode 100644
index 000000000000..5c379bf8ac8d
--- /dev/null
+++ b/drivers/iommu/iova-kunit.c
@@ -0,0 +1,544 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for the IOVA allocator.
+ *
+ * Exercises the maple-tree-based allocator: basic alloc/free,
+ * size-aligned allocations, top-down ordering, bounded allocations
+ * with various DMA limits (32-bit, 33-bit, 56-bit), aligned
+ * allocations in fragmented domains, and randomly fragmented stress.
+ *
+ * Each test verifies that the maple tree invariants remain consistent
+ * after every batch of operations.
+ */
+#include <kunit/test.h>
+#include <linux/dma-mapping.h>
+#include <linux/iova.h>
+
+#define TEST_GRANULE PAGE_SIZE
+/* Highest pfn that fits in 32 bits — triggers the bounded alloc path. */
+#define TEST_LIMIT_32BIT (DMA_BIT_MASK(32) >> PAGE_SHIFT)
+/* 33-bit limit — exercises non-power-of-two DMA boundaries. */
+#define TEST_LIMIT_33BIT (DMA_BIT_MASK(33) >> PAGE_SHIFT)
+/* 56-bit limit — typical server IOMMU address width. */
+#define TEST_LIMIT_56BIT (DMA_BIT_MASK(56) >> PAGE_SHIFT)
+/* A 64-bit-ish limit well above dma_32bit_pfn. 1ULL avoids UB on ILP32. */
+#define TEST_LIMIT_64BIT ((1ULL << 36) >> PAGE_SHIFT)
+/*
+ * A small <=32-bit limit used by tests that want to actually exhaust the
+ * restricted region within a tractable number of allocations.
+ */
+#define TEST_LIMIT_32BIT_RESTRICTED 256UL
+
+struct iova_test_ctx {
+	struct iova_domain iovad;
+	bool initialized;
+};
+
+static int iova_test_init(struct kunit *test)
+{
+	struct iova_test_ctx *ctx;
+	int ret;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	test->priv = ctx;
+
+	ret = iova_cache_get();
+	if (ret)
+		return ret;
+
+	init_iova_domain(&ctx->iovad, TEST_GRANULE, 1);
+	ret = iova_domain_init_rcaches(&ctx->iovad);
+	if (ret) {
+		put_iova_domain(&ctx->iovad);
+		iova_cache_put();
+		return ret;
+	}
+	ctx->initialized = true;
+
+	KUNIT_ASSERT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+	return 0;
+}
+
+static void iova_test_exit(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+
+	if (ctx && ctx->initialized) {
+		put_iova_domain(&ctx->iovad);
+		ctx->initialized = false;
+		iova_cache_put();
+	}
+}
+
+static void test_size_aligned(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	int order;
+
+	for (order = 0; order < 8; ++order) {
+		unsigned long size = 1UL << order;
+		struct iova *iova = alloc_iova(&ctx->iovad, size,
+					       TEST_LIMIT_32BIT, true);
+
+		KUNIT_ASSERT_NOT_NULL(test, iova);
+		KUNIT_EXPECT_EQ(test, iova->pfn_lo & (size - 1), 0);
+		KUNIT_EXPECT_EQ(test, iova->pfn_hi - iova->pfn_lo + 1, size);
+		__free_iova(&ctx->iovad, iova);
+		KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+	}
+}
+
+static void test_top_down_preference(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	struct iova *iovas[16];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(iovas); ++i) {
+		iovas[i] = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+		KUNIT_ASSERT_NOT_NULL(test, iovas[i]);
+		if (i > 0)
+			KUNIT_EXPECT_LT(test, iovas[i]->pfn_lo,
+					iovas[i - 1]->pfn_lo);
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	for (i = 0; i < ARRAY_SIZE(iovas); ++i)
+		__free_iova(&ctx->iovad, iovas[i]);
+}
+
+static void test_reserve_iova(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	const unsigned long reserve_lo = TEST_LIMIT_32BIT / 2;
+	struct iova *r, *iova;
+	int i;
+
+	/* Reserve the entire top half through the limit_pfn, inclusive. */
+	r = reserve_iova(&ctx->iovad, reserve_lo, TEST_LIMIT_32BIT);
+	KUNIT_ASSERT_NOT_NULL(test, r);
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	/* All allocs must land below the reserved range. */
+	for (i = 0; i < 100; ++i) {
+		iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+		KUNIT_ASSERT_NOT_NULL(test, iova);
+		KUNIT_EXPECT_LT(test, iova->pfn_hi, reserve_lo);
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+}
+
+/*
+ * The pci_32bit_workaround scenario: every PCI device's first IOVA
+ * allocation hits the 32-bit-restricted path before falling back to
+ * 64-bit. Fill the 64-bit space, then verify a 32-bit alloc still
+ * finds a slot below DMA_BIT_MASK(32).
+ */
+static void test_32bit_in_64bit_domain(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	struct iova *iova;
+	int i;
+
+	for (i = 0; i < 1000; ++i) {
+		iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_64BIT, true);
+		KUNIT_ASSERT_NOT_NULL(test, iova);
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, true);
+	KUNIT_ASSERT_NOT_NULL(test, iova);
+	KUNIT_EXPECT_LE(test, iova->pfn_hi, TEST_LIMIT_32BIT);
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	__free_iova(&ctx->iovad, iova);
+}
+
+/*
+ * Exercise non-power-of-two DMA limits: fill the 64-bit space, then
+ * verify that bounded allocations at 33-bit and 56-bit limits still
+ * find slots within their respective ranges. This confirms the
+ * navigate-to-limit_pfn search generalizes beyond the 32-bit case.
+ */
+static void test_arbitrary_dma_limits(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	struct iova *iova;
+	int i;
+
+	for (i = 0; i < 1000; ++i) {
+		iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_64BIT, true);
+		KUNIT_ASSERT_NOT_NULL(test, iova);
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	/* 33-bit bounded allocation */
+	iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_33BIT, true);
+	KUNIT_ASSERT_NOT_NULL(test, iova);
+	KUNIT_EXPECT_LE(test, iova->pfn_hi, TEST_LIMIT_33BIT);
+	__free_iova(&ctx->iovad, iova);
+
+	/* 56-bit bounded allocation */
+	iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_56BIT, true);
+	KUNIT_ASSERT_NOT_NULL(test, iova);
+	KUNIT_EXPECT_LE(test, iova->pfn_hi, TEST_LIMIT_56BIT);
+	__free_iova(&ctx->iovad, iova);
+
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+}
+
+/*
+ * Aligned allocation in a fragmented domain: pack size-2 size_aligned
+ * allocations at the top, free every other one to leave size-2 holes,
+ * then verify a fresh size-2 aligned alloc still succeeds and returns
+ * a 2-aligned pfn.
+ */
+static void test_aligned_in_fragmented(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	const int N = 64;
+	struct iova **iovas;
+	struct iova *iova;
+	int i;
+
+	iovas = kunit_kcalloc(test, N, sizeof(*iovas), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, iovas);
+
+	for (i = 0; i < N; ++i) {
+		iovas[i] = alloc_iova(&ctx->iovad, 2, TEST_LIMIT_32BIT, true);
+		KUNIT_ASSERT_NOT_NULL(test, iovas[i]);
+		KUNIT_EXPECT_EQ(test, iovas[i]->pfn_lo & 1, 0);
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	for (i = 0; i < N; i += 2) {
+		__free_iova(&ctx->iovad, iovas[i]);
+		iovas[i] = NULL;
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	iova = alloc_iova(&ctx->iovad, 2, TEST_LIMIT_32BIT, true);
+	KUNIT_ASSERT_NOT_NULL(test, iova);
+	KUNIT_EXPECT_EQ(test, iova->pfn_lo & 1, 0);
+	__free_iova(&ctx->iovad, iova);
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	for (i = 0; i < N; ++i)
+		if (iovas[i])
+			__free_iova(&ctx->iovad, iovas[i]);
+}
+
+/*
+ * Mimic dma-iommu's pci_32bit_workaround pattern: every alloc first
+ * tries a small restricted limit; if that fails, retry with the 64-bit
+ * limit. Verifies that the navigate-to-limit search survives rapid
+ * switching between different limit_pfn values.
+ */
+static void test_pci_32bit_workaround_pattern(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	int fallback_count = 0;
+	int i;
+
+	for (i = 0; i < 500; ++i) {
+		unsigned long size = (i % 4) + 1;
+		struct iova *iova = alloc_iova(&ctx->iovad, size,
+					       TEST_LIMIT_32BIT_RESTRICTED,
+					       true);
+
+		if (!iova) {
+			iova = alloc_iova(&ctx->iovad, size,
+					  TEST_LIMIT_64BIT, true);
+			fallback_count++;
+		}
+		if (!iova)
+			break;
+	}
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+	/* Every alloc must succeed (via fallback once the restricted region fills). */
+	KUNIT_EXPECT_EQ(test, i, 500);
+	/* The restricted region is small, so the 64-bit fallback must engage. */
+	KUNIT_EXPECT_GT(test, fallback_count, 0);
+}
+
+/*
+ * Random alloc/free over many iterations, verifying invariants after
+ * every operation. Uses a deterministic PRNG so failures reproduce
+ * across boots. Exercises mixed DMA limits (32, 33, 56, 64-bit).
+ */
+static void test_stress_random(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	const int N = 512;
+	const int iters = 4 * N;
+	const unsigned long limits[] = {
+		TEST_LIMIT_32BIT, TEST_LIMIT_33BIT,
+		TEST_LIMIT_56BIT, TEST_LIMIT_64BIT,
+	};
+	struct iova **iovas;
+	u32 rng = 0xDEADBEEF;
+	int i;
+
+	iovas = kunit_kcalloc(test, N, sizeof(*iovas), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, iovas);
+
+	for (i = 0; i < iters; ++i) {
+		int slot;
+		unsigned long limit;
+		const char *op;
+
+		rng = rng * 1103515245 + 12345;
+		slot = (rng >> 8) % N;
+		rng = rng * 1103515245 + 12345;
+		limit = limits[(rng >> 8) % ARRAY_SIZE(limits)];
+
+		if (iovas[slot]) {
+			op = "free";
+			__free_iova(&ctx->iovad, iovas[slot]);
+			iovas[slot] = NULL;
+		} else {
+			unsigned long size;
+			bool aligned;
+
+			rng = rng * 1103515245 + 12345;
+			size = 1UL << ((rng >> 8) % 4);
+			rng = rng * 1103515245 + 12345;
+			aligned = (rng >> 8) & 1;
+
+			op = "alloc";
+			iovas[slot] = alloc_iova(&ctx->iovad, size, limit,
+						 aligned);
+		}
+		if (!iova_domain_verify_invariants(&ctx->iovad)) {
+			kunit_info(test, "iter %d slot %d: invariant broken after %s\n",
+				   i, slot, op);
+			KUNIT_FAIL(test, "verify failed");
+			break;
+		}
+	}
+
+	for (i = 0; i < N; ++i)
+		if (iovas[i])
+			__free_iova(&ctx->iovad, iovas[i]);
+}
+
+/*
+ * Verify that alloc_iova fails in bounded time when the IOVA space is
+ * fully packed. Fill a 16K-pfn range with size-1 allocations (leaving
+ * no gaps), then attempt a size-2 aligned alloc. The maple tree's
+ * mas_empty_area_rev must determine there is no suitable gap in
+ * O(log n) time rather than walking every entry. The wall-clock check
+ * is a loose hang detector only (CI under KASAN/lockdep/virt is slow);
+ * the real signal is the reported time and that the alloc fails.
+ */
+static void test_full_space_search_time(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	const unsigned long fill_limit = 16384;
+	const int fill_count = fill_limit;
+	struct iova *iova;
+	ktime_t start, elapsed;
+	int i, allocated = 0;
+
+	for (i = 0; i < fill_count; ++i) {
+		iova = alloc_iova(&ctx->iovad, 1, fill_limit, false);
+		if (!iova)
+			break;
+		allocated++;
+	}
+	kunit_info(test, "allocated %d iovas in [1, %lu]\n",
+		   allocated, fill_limit);
+	KUNIT_ASSERT_GT(test, allocated, 1000);
+
+	start = ktime_get();
+	iova = alloc_iova(&ctx->iovad, 2, fill_limit, true);
+	elapsed = ktime_sub(ktime_get(), start);
+
+	KUNIT_EXPECT_NULL(test, iova);
+	kunit_info(test, "failed alloc took %lld ns\n",
+		   ktime_to_ns(elapsed));
+	/* Loose hang detector, not a perf gate (CI under KASAN/lockdep is slow). */
+	KUNIT_EXPECT_LT(test, ktime_to_ns(elapsed), 1000000000LL);
+
+	if (iova)
+		__free_iova(&ctx->iovad, iova);
+}
+
+/*
+ * Verify bounded search time with a fragmented 32-bit IOVA space.
+ * Pack the 32-bit range with size-1 allocs, then attempt a large
+ * aligned alloc that must either succeed from a remaining gap or
+ * fail fast. The 64-bit fallback must always succeed promptly.
+ */
+static void test_fragmented_32bit_search(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	struct iova *iova;
+	ktime_t start, elapsed;
+	int i, allocated = 0;
+
+	for (i = 0; i < 8000; ++i) {
+		iova = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+		if (!iova)
+			break;
+		allocated++;
+	}
+	kunit_info(test, "filled 32-bit space with %d allocs\n", allocated);
+	KUNIT_ASSERT_GT(test, allocated, 1000);
+
+	start = ktime_get();
+	iova = alloc_iova(&ctx->iovad, 32, TEST_LIMIT_32BIT, true);
+	elapsed = ktime_sub(ktime_get(), start);
+
+	kunit_info(test, "32-bit alloc (size 32) took %lld ns, result=%s\n",
+		   ktime_to_ns(elapsed), iova ? "alloc" : "fail");
+	/* Loose hang detector, not a perf gate (CI under KASAN/lockdep is slow). */
+	KUNIT_EXPECT_LT(test, ktime_to_ns(elapsed), 1000000000LL);
+
+	if (iova)
+		__free_iova(&ctx->iovad, iova);
+
+	start = ktime_get();
+	iova = alloc_iova(&ctx->iovad, 32, TEST_LIMIT_64BIT, true);
+	elapsed = ktime_sub(ktime_get(), start);
+
+	kunit_info(test, "64-bit fallback (size 32) took %lld ns\n",
+		   ktime_to_ns(elapsed));
+	/* Loose hang detector, not a perf gate (CI under KASAN/lockdep is slow). */
+	KUNIT_EXPECT_LT(test, ktime_to_ns(elapsed), 1000000000LL);
+
+	if (iova)
+		__free_iova(&ctx->iovad, iova);
+}
+
+/*
+ * Exercise the deferred-erase path: remove_iova() failing to erase under
+ * GFP_ATOMIC leaves an IOVA_DEFERRED marker in the tree and frees the struct
+ * iova immediately. iova_kunit_defer_erase makes that failure deterministic.
+ * Verify that while marked the range looks free to lookups yet stays reserved,
+ * that invariants hold, and that the next allocation drains the marker and
+ * reuses the space.
+ */
+static void test_deferred_erase(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	struct iova *a, *b;
+	unsigned long pfn;
+
+	a = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+	KUNIT_ASSERT_NOT_NULL(test, a);
+	pfn = a->pfn_lo;
+
+	/* Free 'a', forcing the erase to be deferred (marker left behind). */
+	iova_kunit_defer_erase = true;
+	__free_iova(&ctx->iovad, a);
+	iova_kunit_defer_erase = false;
+
+	/*
+	 * The erase was deferred, not performed: a marker now occupies the slot,
+	 * so the backlog records the deferral and the pfn looks absent to lookups,
+	 * while the tree stays consistent with the marker present.
+	 */
+	KUNIT_EXPECT_TRUE(test, iova_domain_has_deferred(&ctx->iovad));
+	KUNIT_EXPECT_NULL(test, find_iova(&ctx->iovad, pfn));
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	/*
+	 * The next allocation drains deferred markers before searching, so the
+	 * backlog clears and the marked range is reclaimed; a top-down size-1
+	 * alloc reuses exactly the pfn that was freed.
+	 */
+	b = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+	KUNIT_ASSERT_NOT_NULL(test, b);
+	KUNIT_EXPECT_FALSE(test, iova_domain_has_deferred(&ctx->iovad));
+	KUNIT_EXPECT_EQ(test, b->pfn_lo, pfn);
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+
+	__free_iova(&ctx->iovad, b);
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+}
+
+/*
+ * Tearing down a domain that still holds an undrained IOVA_DEFERRED marker must
+ * skip the marker (it is static storage, not a heap iova) and not crash or
+ * double-free. Leave a marker live for iova_test_exit()'s put_iova_domain().
+ */
+static void test_deferred_erase_teardown(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	struct iova *a;
+
+	a = alloc_iova(&ctx->iovad, 4, TEST_LIMIT_32BIT, false);
+	KUNIT_ASSERT_NOT_NULL(test, a);
+
+	iova_kunit_defer_erase = true;
+	__free_iova(&ctx->iovad, a);
+	iova_kunit_defer_erase = false;
+
+	/* Marker left live; the suite's exit -> put_iova_domain must cope. */
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+}
+
+/*
+ * The deferred-erase path rests on one maple tree property: erasing an entry
+ * next to free space can need a node, while marking that same range with a
+ * non-NULL value cannot. Assert both store types, so a change to the maple
+ * tree's store-type rules is caught here rather than by the WARN_ON_ONCE in
+ * remove_iova(), where the only recovery is to strand the range.
+ */
+static void test_marker_store_needs_no_node(struct kunit *test)
+{
+	struct iova_test_ctx *ctx = test->priv;
+	enum store_type erase, marker;
+	unsigned char marker_nodes;
+	struct iova *a, *b, *c;
+
+	/* Free neighbours on both sides are what make the erase need a node. */
+	c = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+	b = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+	KUNIT_ASSERT_NOT_NULL(test, b);
+	a = alloc_iova(&ctx->iovad, 1, TEST_LIMIT_32BIT, false);
+	KUNIT_ASSERT_NOT_NULL(test, a);
+	__free_iova(&ctx->iovad, a);
+	__free_iova(&ctx->iovad, c);
+
+	iova_kunit_store_types(&ctx->iovad, b, &erase, &marker, &marker_nodes);
+
+	KUNIT_EXPECT_NE(test, erase, wr_exact_fit);
+	KUNIT_EXPECT_EQ(test, marker, wr_exact_fit);
+	KUNIT_EXPECT_EQ(test, marker_nodes, 0);
+
+	__free_iova(&ctx->iovad, b);
+	KUNIT_EXPECT_TRUE(test, iova_domain_verify_invariants(&ctx->iovad));
+}
+
+static struct kunit_case iova_test_cases[] = {
+	KUNIT_CASE(test_size_aligned),
+	KUNIT_CASE(test_top_down_preference),
+	KUNIT_CASE(test_reserve_iova),
+	KUNIT_CASE(test_32bit_in_64bit_domain),
+	KUNIT_CASE(test_arbitrary_dma_limits),
+	KUNIT_CASE(test_aligned_in_fragmented),
+	KUNIT_CASE(test_pci_32bit_workaround_pattern),
+	KUNIT_CASE(test_stress_random),
+	KUNIT_CASE(test_full_space_search_time),
+	KUNIT_CASE(test_fragmented_32bit_search),
+	KUNIT_CASE(test_deferred_erase),
+	KUNIT_CASE(test_deferred_erase_teardown),
+	KUNIT_CASE(test_marker_store_needs_no_node),
+	{}
+};
+
+static struct kunit_suite iova_test_suite = {
+	.name = "iova",
+	.init = iova_test_init,
+	.exit = iova_test_exit,
+	.test_cases = iova_test_cases,
+};
+kunit_test_suite(iova_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the IOVA allocator");
+MODULE_LICENSE("GPL");
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 255a1cefe8c5..a32413298e29 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -224,6 +224,47 @@ static void iova_drain_deferred(struct iova_domain *iovad)
 	iovad->deferred_hi = 0;
 }
 
+#if IS_ENABLED(CONFIG_IOMMU_IOVA_KUNIT_TEST)
+/*
+ * Forces the deferred-erase path, which a real GFP_ATOMIC failure cannot
+ * be provoked into taking on demand.
+ */
+bool iova_kunit_defer_erase;
+EXPORT_SYMBOL_GPL(iova_kunit_defer_erase);
+
+/*
+ * Reports the store type the maple tree picks for erasing @iova and for marking
+ * it deferred. remove_iova() depends on the second being wr_exact_fit, so that
+ * it needs no node; the test asserts on both, and fails if a change to the
+ * store-type rules ever makes the marker store allocate.
+ */
+void iova_kunit_store_types(struct iova_domain *iovad, struct iova *iova,
+			    enum store_type *erase, enum store_type *marker,
+			    unsigned char *marker_nodes)
+{
+	unsigned long flags;
+
+	MA_STATE(mas, &iovad->mtree, iova->pfn_lo, iova->pfn_hi);
+
+	spin_lock_irqsave(&iovad->iova_lock, flags);
+
+	mas_preallocate(&mas, NULL, GFP_ATOMIC);
+	*erase = mas.store_type;
+	mas_destroy(&mas);
+
+	mas_set_range(&mas, iova->pfn_lo, iova->pfn_hi);
+	mas_preallocate(&mas, IOVA_DEFERRED, GFP_ATOMIC);
+	*marker = mas.store_type;
+	*marker_nodes = mas.node_request;
+	mas_destroy(&mas);
+
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
+}
+EXPORT_SYMBOL_GPL(iova_kunit_store_types);
+#else
+#define iova_kunit_defer_erase false
+#endif
+
 /*
  * Must not fail: DMA unmap runs in atomic context, so there is no caller to
  * return an error to.
@@ -239,7 +280,7 @@ static void remove_iova(struct iova_domain *iovad, struct iova *iova)
 	if (pfn_lo < iovad->dma_32bit_pfn)
 		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
 
-	if (mas_store_gfp(&mas, NULL, GFP_ATOMIC)) {
+	if (iova_kunit_defer_erase || mas_store_gfp(&mas, NULL, GFP_ATOMIC)) {
 		/*
 		 * A NULL store gets widened over the neighbouring free ranges,
 		 * and the wider store may cause a maple tree rebalance, which
@@ -999,6 +1040,50 @@ void iova_cache_put(void)
 }
 EXPORT_SYMBOL_GPL(iova_cache_put);
 
+#if IS_ENABLED(CONFIG_IOMMU_IOVA_KUNIT_TEST)
+bool iova_domain_verify_invariants(struct iova_domain *iovad)
+{
+	struct iova *iova, *prev = NULL;
+	unsigned long flags;
+	bool ok = true;
+	MA_STATE(mas, &iovad->mtree, 0, 0);
+
+	spin_lock_irqsave(&iovad->iova_lock, flags);
+	mas_for_each(&mas, iova, ULONG_MAX) {
+		/* A marker occupies a slot but is not a real iova. */
+		if (iova == IOVA_DEFERRED)
+			continue;
+		if (mas.index != iova->pfn_lo || mas.last != iova->pfn_hi) {
+			pr_err("iova_verify: maple index [%lu,%lu] != iova [%lu,%lu]\n",
+			       mas.index, mas.last, iova->pfn_lo, iova->pfn_hi);
+			ok = false;
+		}
+		if (iova->pfn_lo > iova->pfn_hi) {
+			pr_err("iova_verify: pfn_lo=%lu > pfn_hi=%lu\n",
+			       iova->pfn_lo, iova->pfn_hi);
+			ok = false;
+		}
+		if (prev && prev->pfn_hi >= iova->pfn_lo) {
+			pr_err("iova_verify: overlap prev=[%lu,%lu] curr=[%lu,%lu]\n",
+			       prev->pfn_lo, prev->pfn_hi,
+			       iova->pfn_lo, iova->pfn_hi);
+			ok = false;
+		}
+		prev = iova;
+	}
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
+	return ok;
+}
+EXPORT_SYMBOL_GPL(iova_domain_verify_invariants);
+
+/* Test accessor: is there an outstanding deferred-erase backlog? */
+bool iova_domain_has_deferred(struct iova_domain *iovad)
+{
+	return iova_has_deferred(iovad);
+}
+EXPORT_SYMBOL_GPL(iova_domain_has_deferred);
+#endif /* CONFIG_IOMMU_IOVA_KUNIT_TEST */
+
 MODULE_AUTHOR("Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>");
 MODULE_DESCRIPTION("IOMMU I/O Virtual Address management");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/iova.h b/include/linux/iova.h
index e17bb1e85838..3aef263d0898 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -101,6 +101,14 @@ void init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 int iova_domain_init_rcaches(struct iova_domain *iovad);
 struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
 void put_iova_domain(struct iova_domain *iovad);
+#if IS_ENABLED(CONFIG_IOMMU_IOVA_KUNIT_TEST)
+bool iova_domain_verify_invariants(struct iova_domain *iovad);
+bool iova_domain_has_deferred(struct iova_domain *iovad);
+extern bool iova_kunit_defer_erase;
+void iova_kunit_store_types(struct iova_domain *iovad, struct iova *iova,
+			    enum store_type *erase, enum store_type *marker,
+			    unsigned char *marker_nodes);
+#endif
 #else
 static inline int iova_cache_get(void)
 {
-- 
2.53.0-Meta


