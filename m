Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A3EFED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3D26B009F; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFDB6B00A8; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DA16B00A3; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45E896B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC0611A01AB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:39 +0000 (UTC)
X-FDA: 84693612318.01.D9340F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 804F5A000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1SHrCEX;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLjAwZir7SDMyHch5bjWJvoC+zMKV2PqwA1AeudMlLc=;
	b=Bheik8fiqRRMkpsV8WweqfvtDftmO6G6Nwp6ieyDeo6VNlAqG5Gunxn5auNMaOqBZwak6a
	jKk37cb59/R3yNJ4VpGxrfPjWDQGWeByHDr0huIM/iYEbYtuqk+twZusCZ1Jz1s3P4d+eP
	wDCNkMrQ0RL/+tI1utUb0svG7Xbb+uw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1SHrCEX;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039297; a=rsa-sha256;
	cv=none;
	b=oMussea34+TemB7uauizh026e/mHah+ubnSbig6BVvg7CSiK6cxSWbCim9MSyG+azvTsnY
	Amgr/pVDHrIJCVtaRQYqTSp/7HlWIhNXy990/lgI6fn/x4EmNQuXSatMU+H6HT2HdeeHgN
	/L7t4UDdPq7Yw0qYSE/m/qOm0ih3R2o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CA91446C7;
	Fri, 24 Apr 2026 14:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5A0C19425;
	Fri, 24 Apr 2026 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039296;
	bh=gwxMHRj8xZWjbOPpjwiAWwZJt+gKEClkO6VJvO7mI2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1SHrCEXRbPW4i0FC6+hGykEQzaarjMtbE/zFBFVEziiPwgJTwjYdtV/iQBP7pubm
	 9qbG8iE8eXHWezGjh4Jg8AAKoYThApjtNHa/ex5k3hY3flw0VibgOxpOEW+MuO+gSb
	 ncjbv0WpYcaOFCsvThPJ/64n3RNw/kOKlOtsFIy0I7U8PpJ2Dyan7zZyfPtjarevMW
	 pnHup9+o0D/oSQS4CofK5Zsp0Z6LjoRfswjABP3aqqXWDZfhTrWlNDpuAnaX87wOdS
	 PSAhy5olALkX2a/B6tBaf+HWeuQte5UHAWc/NAwqx1x4eDriYDLxGFC4KqRQ1Rb9Fl
	 feb1a3zyL9CPg==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>,
	Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: [RFC 7/7] mm/page_consistency: add KUnit tests for dual-bitmap primitives
Date: Fri, 24 Apr 2026 10:00:56 -0400
Message-ID: <20260424140056.2094777-8-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 804F5A000B
X-Stat-Signature: wjyn4wg6hszqqxfidtk1w9phbj9n1ux8
X-Rspam-User: 
X-HE-Tag: 1777039297-602602
X-HE-Meta: U2FsdGVkX19Z4d4X6hQ71DRxYGRUDFnIN+QgvfVDg/eQ+HrCXppHITHZazcS46vKxaWcSm//OkHQSC51vznK0o7woHWKuKx+0C8DChUqzDWC5xwQW9/FdBCUE9KYGd58kD2u39yei9W/vFGngLxSqXJvimN38PWfbHRaRI22A+iW9n7hexw72ZyomwovPqP465UB4O3IUwQPPCw4U/zszBz6MWHOW+mB5Ecgt9I+M43xLMkqbGbqu3GDXGUHlpmJ3AwegBbUFCT4fcavk4f0BpBei7DywF++/GRiyJznCgFPTZeNY0ZtrLTqDvBG/k/8bcR8W0pTya6QnC2qgmFmD0P15410urCx/qu3FOkHFZ0KRPHP323T+W3n6nOegInbT8+n7dT9iLgp2C1zxd7rTu72I05MMy0EkBl4I2a4QS0UaUfKYA5RjhorsT8QEjtwiqKKJdFSQaVPENPLq5+XtXKmlF3WMSZTVfBx6ARnKwSE8e4/CEnXDG0el26B7ge8d2tAFVFU6gTXSHP2fg0Wyuog0jn9SzV9jSvYV+9fUA8PjCpa97GFru8HeXMjkRb0qJN67P9KQRO9tkaVI1W6se07rl2lKU9t6XV6lHn4Q/xgR6FlWQWrYKhSmr975cjQDBCjC3v0NpaLiKMGOMaW7WN3nrW0pUPZXU3nhB+B9zWZoDpaF+suSV/UQ0hHJkKF69Tjq5Pp+JBmjjFPFcZkgexz9VO+W+XjktEyhxEJrKKJ+71RnfOLZv/lSM8Lxd1yrIBSXlzurASdAa9vtaP+leFAPvmkoikgGQZo2mL0lPVCqNQqqF+iclvE4sgi5iAnOvDUBSTjxa98grg0ngoaI0oMX32XIFybI+EvXfLGI6O+NM+7S6K/dSxha8DPraVLEBOs0Xz8AJbdgqhgO4eQaCHouFeiIrbLE71Zt+/fdf1I2MHU+KWYaxi3+mkgOGH2vPGFcbuq8OkEP3CgkQF
 fWeQG/LU
 4dpw6cKFNzk2g+iDWHwJ+pySeWSEUaU3CqIN54quSBnkrJ3lgTRQDeJiwQs/GIlZMutRT9RNT7lmmgxp4qPaV7oN1iE0bpOe62nIa15P9g7gZz4iOyKVlgCYMSkEyAtNi+Pm0+Zfrvo3jJFH/J//D95tXI8jMYxc56+bDBb3/cv7cadqrcK7i7jkC/ls7yUPU3VLcCHyKDeZhSN76maEWVMt6ZjA2L7/PWZrfhOUGy4L7hgj+R2+3D7PprsTE0e9DdEjStWhvItB0rl8E3FBc6d1mrgUqqKfWOQiMq1WldStW1HmbU4mNKMQXzhbq1qbRZg8JJhmo7UaZ1QK29BS4cUZ33g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

Add a KUnit test suite that exercises the dual-bitmap algorithm used by
the page consistency checker. The tests verify that the core invariant
is maintained through various operations and that corruption can be
reliably detected.

The test suite covers several scenarios. The initial-state test confirms
that a freshly initialized dual bitmap with zeroed primary and filled
secondary passes validation. The set and clear tests verify that normal
operations maintain the complementary relationship between bitmaps. The
double-set and double-clear tests confirm that attempts to set an
already-set bit or clear an already-clear bit are properly detected and
reported through the return value.

The corruption detection tests are particularly important for validating
the safety guarantees. These tests directly manipulate one bitmap without
updating its complement, simulating what would happen if a memory error
flipped a bit. Both primary and secondary corruption scenarios are
tested, confirming that either type is caught by validation.

The suite also includes boundary condition tests covering the first bit,
last bit, and word boundaries to ensure the bit manipulation logic
handles edge cases correctly.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 mm/Makefile                |   1 +
 mm/page_consistency_test.c | 274 +++++++++++++++++++++++++++++++++++++
 2 files changed, 275 insertions(+)
 create mode 100644 mm/page_consistency_test.c

diff --git a/mm/Makefile b/mm/Makefile
index 2ee360001456..7106aeb79cf5 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -129,6 +129,7 @@ obj-$(CONFIG_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_DEBUG_PAGE_CONSISTENCY) += page_consistency.o
+obj-$(CONFIG_DEBUG_PAGE_CONSISTENCY_KUNIT_TEST) += page_consistency_test.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_SECRETMEM) += secretmem.o
 obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
diff --git a/mm/page_consistency_test.c b/mm/page_consistency_test.c
new file mode 100644
index 000000000000..6cd587f8146f
--- /dev/null
+++ b/mm/page_consistency_test.c
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for dual-bitmap primitives
+ *
+ * Tests the dual-bitmap consistency checking algorithm used by the page
+ * consistency checker. These tests verify the core invariant maintenance
+ * and corruption detection logic.
+ */
+
+#include <kunit/test.h>
+#include <linux/dual_bitmap.h>
+
+#define TEST_BITMAP_BITS 256
+
+struct dual_bitmap_test_context {
+	struct dual_bitmap db;
+	unsigned long primary[BITS_TO_LONGS(TEST_BITMAP_BITS)];
+	unsigned long secondary[BITS_TO_LONGS(TEST_BITMAP_BITS)];
+};
+
+static int dual_bitmap_test_init(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->db.bitmap[DUAL_BITMAP_PRIMARY] = ctx->primary;
+	ctx->db.bitmap[DUAL_BITMAP_SECONDARY] = ctx->secondary;
+	ctx->db.nbits = TEST_BITMAP_BITS;
+
+	/* Initialize: primary all zeros, secondary all ones */
+	dual_bitmap_init(&ctx->db);
+
+	test->priv = ctx;
+	return 0;
+}
+
+static void test_initial_state_consistent(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+}
+
+static void test_set_maintains_consistency(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+	bool was_set;
+
+	/* Set bit 42 */
+	was_set = dual_bitmap_set(&ctx->db, 42);
+	KUNIT_EXPECT_FALSE(test, was_set);
+
+	/* Verify consistency */
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+
+	/* Verify individual bit consistency */
+	KUNIT_EXPECT_TRUE(test, dual_bitmap_consistent(&ctx->db, 42));
+}
+
+static void test_clear_maintains_consistency(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+	bool was_set;
+
+	/* First set the bit */
+	dual_bitmap_set(&ctx->db, 100);
+
+	/* Now clear it */
+	was_set = dual_bitmap_clear(&ctx->db, 100);
+	KUNIT_EXPECT_TRUE(test, was_set);
+
+	/* Verify consistency */
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+}
+
+static void test_double_set_detected(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	bool was_set;
+
+	/* Set bit 50 */
+	was_set = dual_bitmap_set(&ctx->db, 50);
+	KUNIT_EXPECT_FALSE(test, was_set);
+
+	/* Try to set it again - should report it was already set */
+	was_set = dual_bitmap_set(&ctx->db, 50);
+	KUNIT_EXPECT_TRUE(test, was_set);
+}
+
+static void test_double_clear_detected(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	bool was_set;
+
+	/* Clear bit 60 which is already clear (never set) */
+	was_set = dual_bitmap_clear(&ctx->db, 60);
+	KUNIT_EXPECT_FALSE(test, was_set);
+}
+
+static void test_corruption_in_primary_detected(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+
+	/* Corrupt the primary bitmap directly */
+	set_bit(75, ctx->primary);
+
+	/* Validation should detect the corruption */
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_GT(test, violations, 0UL);
+
+	/* Individual bit check should also fail */
+	KUNIT_EXPECT_FALSE(test, dual_bitmap_consistent(&ctx->db, 75));
+}
+
+static void test_corruption_in_secondary_detected(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+
+	/* Corrupt the secondary bitmap directly */
+	clear_bit(80, ctx->secondary);
+
+	/* Validation should detect the corruption */
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_GT(test, violations, 0UL);
+
+	/* Individual bit check should also fail */
+	KUNIT_EXPECT_FALSE(test, dual_bitmap_consistent(&ctx->db, 80));
+}
+
+static void test_multiple_operations(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+	unsigned long i;
+
+	/* Set bits 0-63 */
+	for (i = 0; i < 64; i++)
+		dual_bitmap_set(&ctx->db, i);
+
+	/* Clear bits 32-63 */
+	for (i = 32; i < 64; i++)
+		dual_bitmap_clear(&ctx->db, i);
+
+	/* Validate entire bitmap */
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+
+	/* Verify expected state: bits 0-31 set, rest clear */
+	for (i = 0; i < 32; i++)
+		KUNIT_EXPECT_TRUE(test, test_bit(i, ctx->primary));
+	for (i = 32; i < TEST_BITMAP_BITS; i++)
+		KUNIT_EXPECT_FALSE(test, test_bit(i, ctx->primary));
+}
+
+static void test_boundary_bits(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+	unsigned long violations;
+
+	/* Test first bit */
+	dual_bitmap_set(&ctx->db, 0);
+	KUNIT_EXPECT_TRUE(test, dual_bitmap_consistent(&ctx->db, 0));
+
+	/* Test last bit */
+	dual_bitmap_set(&ctx->db, TEST_BITMAP_BITS - 1);
+	KUNIT_EXPECT_TRUE(test, dual_bitmap_consistent(&ctx->db, TEST_BITMAP_BITS - 1));
+
+	/* Test word boundary (last bit of first word / first bit of second word) */
+	dual_bitmap_set(&ctx->db, BITS_PER_LONG - 1);
+	dual_bitmap_set(&ctx->db, BITS_PER_LONG);
+	KUNIT_EXPECT_TRUE(test, dual_bitmap_consistent(&ctx->db, BITS_PER_LONG - 1));
+	KUNIT_EXPECT_TRUE(test, dual_bitmap_consistent(&ctx->db, BITS_PER_LONG));
+
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+}
+
+static void test_dual_bitmap_test_func(struct kunit *test)
+{
+	struct dual_bitmap_test_context *ctx = test->priv;
+
+	/* Initially all bits should be clear (not allocated) */
+	KUNIT_EXPECT_FALSE(test, dual_bitmap_test(&ctx->db, 10));
+
+	/* After setting, bit should be set */
+	dual_bitmap_set(&ctx->db, 10);
+	KUNIT_EXPECT_TRUE(test, dual_bitmap_test(&ctx->db, 10));
+
+	/* After clearing, bit should be clear again */
+	dual_bitmap_clear(&ctx->db, 10);
+	KUNIT_EXPECT_FALSE(test, dual_bitmap_test(&ctx->db, 10));
+}
+
+/* Test with non-word-aligned nbits to exercise partial-word handling */
+#define TEST_UNALIGNED_BITS 100  /* not a multiple of BITS_PER_LONG */
+
+struct dual_bitmap_unaligned_context {
+	struct dual_bitmap db;
+	unsigned long primary[BITS_TO_LONGS(TEST_UNALIGNED_BITS)];
+	unsigned long secondary[BITS_TO_LONGS(TEST_UNALIGNED_BITS)];
+};
+
+static void test_non_aligned_nbits(struct kunit *test)
+{
+	struct dual_bitmap_unaligned_context *ctx;
+	unsigned long violations;
+	unsigned long i;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	ctx->db.bitmap[DUAL_BITMAP_PRIMARY] = ctx->primary;
+	ctx->db.bitmap[DUAL_BITMAP_SECONDARY] = ctx->secondary;
+	ctx->db.nbits = TEST_UNALIGNED_BITS;
+
+	dual_bitmap_init(&ctx->db);
+
+	/* Initial state should be consistent */
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+
+	/* Set and clear bits near the non-aligned boundary */
+	for (i = TEST_UNALIGNED_BITS - 5; i < TEST_UNALIGNED_BITS; i++) {
+		dual_bitmap_set(&ctx->db, i);
+		KUNIT_EXPECT_TRUE(test, dual_bitmap_consistent(&ctx->db, i));
+	}
+
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+
+	/* Clear them back */
+	for (i = TEST_UNALIGNED_BITS - 5; i < TEST_UNALIGNED_BITS; i++)
+		dual_bitmap_clear(&ctx->db, i);
+
+	violations = dual_bitmap_validate(&ctx->db);
+	KUNIT_EXPECT_EQ(test, violations, 0UL);
+}
+
+static struct kunit_case dual_bitmap_test_cases[] = {
+	KUNIT_CASE(test_initial_state_consistent),
+	KUNIT_CASE(test_set_maintains_consistency),
+	KUNIT_CASE(test_clear_maintains_consistency),
+	KUNIT_CASE(test_double_set_detected),
+	KUNIT_CASE(test_double_clear_detected),
+	KUNIT_CASE(test_corruption_in_primary_detected),
+	KUNIT_CASE(test_corruption_in_secondary_detected),
+	KUNIT_CASE(test_multiple_operations),
+	KUNIT_CASE(test_boundary_bits),
+	KUNIT_CASE(test_dual_bitmap_test_func),
+	KUNIT_CASE(test_non_aligned_nbits),
+	{},
+};
+
+static struct kunit_suite dual_bitmap_test_suite = {
+	.name = "dual_bitmap",
+	.init = dual_bitmap_test_init,
+	.test_cases = dual_bitmap_test_cases,
+};
+
+kunit_test_suites(&dual_bitmap_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests for dual-bitmap consistency primitives");
-- 
2.53.0


