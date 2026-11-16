Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E24606A89B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ewQE3Et0
Received: by kanga.kvack.org (Postfix)
	id A8B2C6B05BC; Mon, 16 Nov 2026 08:40:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62A06B05BD; Mon, 16 Nov 2026 08:40:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950746B05BE; Mon, 16 Nov 2026 08:40:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6009C6B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:40:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B93951608F2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:38 +0000 (UTC)
X-FDA: 85441092156.14.7FA1605
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01CAD1C000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewQE3Et0;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjHiFFvvFNAhd6hsZhlyO8HyxfJvIN7x4O0H0nfgRlQ=;
	b=CmxkFgsCavZoXmibyFaI35XkBytIcJVAUCQbrp9hTCQFiRDwBwgdr3f2AyYyTJywG9P80d
	GDabAkxl8iYfcHHX2IKDTX3g0PXB12nPYsvOhuphq4WGyV+Ox2MuVjXGrgAJPLq1bsGf7h
	juxceV/UKSk8nqmr3SaIQyB/kP5WMqQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836437;
	b=UHauxlRwjyz/JREvTWvS5Y2NXjb/0vTGbxrRy2RWZDsvN6QmU5xRN5KSK4NU/9JWNAeTzL
	wf0OBKbqY7KfTFy1Jj67iI+wjdGZbn0pTbJU1rpa+dnPhfXgsU5wNV3vrgPkyB26Hy+xAq
	wGbiEgzLaiaq+oVJZBs1gjW3B2SdJ/A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewQE3Et0;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51BF64636E;
	Mon, 16 Nov 2026 13:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41001F000CA;
	Mon, 16 Nov 2026 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836436;
	bh=kjHiFFvvFNAhd6hsZhlyO8HyxfJvIN7x4O0H0nfgRlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewQE3Et0vx1bLUUy7VVx1KCP59w9k72op8MVgz7xPbzHAeo0sjdDQRNcpj9WrD8ME
	 j98lEm2zFMzrxz4m1cJg8Z/jsRmmCEbQ1GlK9peJWE7/QqAsYlRROdn8QiPiGhnQ2Y
	 3OossR1myZQeOQ56biegAuBm+HN1PGdBbm4WbIoieJREPmiqd5RrMC8B/UrHIoz8ys
	 wsiTpe44h//0ES7OyeYvzoLT7Lk0ebSv6wPZZ7mruDaHnM8sE6n8h/X+AJ5iZ7BzaV
	 YWpC+y6y49ZAfMp3yy9z/TQDc6jhB3ftm7Dh8U60ZBLuFbXR8F2cK/YqvxX0js6W7E
	 d4F47I3KlRLuw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tarun Sahu <tarunsahu@google.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 4/5] kho: test: add KHO map test
Date: Mon, 16 Nov 2026 14:40:09 +0100
Message-ID: <20261116134013.1636689-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
In-Reply-To: <20261116134013.1636689-1-pratyush@kernel.org>
References: <20261116134013.1636689-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 75oo8qp1nesay7ndof676hqgxmw71s7q
X-Rspamd-Queue-Id: 01CAD1C000D
X-Rspam-User: 
X-HE-Tag: 1794836436-497089
X-HE-Meta: U2FsdGVkX1+YGaj3a7kteVIvj3i42xrJZSpjO+HoLDVLN6Y/n9ZLtpFHazbZPV6EniLQSXKrCAc12w+FTOmmuPStIMJN+g9BHdsy61U2bsBKW5jq5VphPKzOAkek550i1yomveQYvvgdQgOpX4lPIcvS0pyOaernBkqyhjdXiPUgHgNCVDvmUah8DyOFVGri3i7j+sAFjCaE8PVlNTUzbbAEqc6VLQVxIyIp+Fukb2PfbXelOHOUxPOdVSAJcdrLfiviZot6cCHC8TqlnirEVipHgzthyNrf084A0RF4II6lNw1koOxBDaX3+GkGjX0NlPUgpoOURc8gh0YPMvAddmDPPkg8Oj+vP6zQ52E18pbZKXX6+Wnj7zzGCal59tYTPVCBujt1YVJePXRk4wXq3mtJu7espwx1YSWfGE+vMhuqycvn7JNW2jaAPXkH8LCA3iBaiL6KXaII/Ntlnu1CMIKgluN00KMg6Fhp7oQQEdVyXYEynhjIrE011QC3J9Xc17/0PwY1KGXDbMvgaY3/Mhzy9GE10Cz1BYha+5pWWKzaU7VeQWgaNE+QRMu8ZIPfKXRPLPRZ59x7JkrdRJsgFj6xiwDbnms/3GmhHFhXu/TabvkGYdXWgZjU/SxQAL2jey9bRciL7p2GwWQwLyPvjtXS49Fu42C6zvZX80xe7Gy1u/8iiIGnUaAeWnsQPvNNAr5msDAJyv8y2p4gOIc4auJefvSxOu2tXPQbfRt3PYowL/AsnomcNfE+UEhD/1vvA0Vy19Vo1JqMDrfD2/3bGyZEdPZLD//xqDIZi8XtNosg8uqzYGf0yRBUGj/7qvwme+nzyww0VqL4EPPwVR7V9OW4isxbNz5XsXAHnFV4IuDXdz+fr9bPLk95cuIZ5uaPjCxpmro/HLq3FSA1JdZHXj6ApIuMs69T3D/pp/EN1COTFBzqLCeqUGQBXV9yqQnZ5hn9UlBC9yyR3UssT8n
 zS+FnfBe
 daM6xVVJ1zQGNdmQAZPRHPdHi8Q4PiKBcvlhFqCAj0zED3ZuGi5RYk+oyGNnvj+A20yAXgyhLM1muuP8QcsXDhchpEMW1jDtUHPBnyJZOCnP+7JhfC01rq3HQgQkqr57SYDr2xDWaKQhHvS2jESmS8EbiFpKFKH8dyHuz3//S0oUoWEHLYC6OrqcUEjqvWP+1eEm/cig6X9vv710YAmw5bdeD/O91Nvnu3oWIA9qb5p5/WkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add a test for the KHO map, built together with test_kho under
CONFIG_TEST_KEXEC_HANDOVER.

In the first kernel, the test runs functional checks of the API, each on
a fresh map. Every check runs twice: once on an unpreserved map and once
on a map preserved right after kho_map_init(), so both the plain and the
preserve-on-alloc/unpreserve-on-destroy paths are covered.

The checks use different keys to test boundary conditions, and exercise
lookups, iteration, overwriting and clearing entries, and destroying and
re-initializing a map.

The test then builds a map and hands it over. It preserves the map after
adding half of the keys, so the handed-over map has nodes preserved both
by kho_map_preserve() walking the existing tree and by kho_map_set()
preserving new nodes on allocation.

After kexec, the next kernel restores the map and verifies its contents,
and makes sure modification of the tree still works.

Also teach the KHO vmtest.sh to check for the KHO map test result.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 lib/Kconfig.debug                     |   4 +
 lib/Makefile                          |   2 +-
 lib/test_kho_map.c                    | 575 ++++++++++++++++++++++++++
 tools/testing/selftests/kho/vmtest.sh |   2 +
 4 files changed, 582 insertions(+), 1 deletion(-)
 create mode 100644 lib/test_kho_map.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d22638ec13a6..39e65b8a5290a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3442,6 +3442,10 @@ config TEST_KEXEC_HANDOVER
 	  the first kernel and restores and verifies the data on the boot of
 	  kexec'ed kernel.
 
+	  It also tests the KHO map: the first kernel runs functional checks
+	  and builds and preserves a tree, and the kexec'ed kernel restores,
+	  modifies and destroys it.
+
 	  For detailed documentation about KHO, see Documentation/core-api/kho.
 
 	  To run the test run:
diff --git a/lib/Makefile b/lib/Makefile
index a2afe954805cb..d3ab3f239e3ac 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -105,7 +105,7 @@ obj-$(CONFIG_TEST_HMM) += test_hmm.o
 obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
 obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
-obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o
+obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o test_kho_map.o
 
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
 test_fpu-y := test_fpu_glue.o test_fpu_impl.o
diff --git a/lib/test_kho_map.c b/lib/test_kho_map.c
new file mode 100644
index 0000000000000..16db26e380d50
--- /dev/null
+++ b/lib/test_kho_map.c
@@ -0,0 +1,575 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pratyush Yadav <pratyush@kernel.org>
+ *
+ * Test for the KHO map. The first kernel runs basic tests on scratch trees,
+ * both unpreserved and preserved, then builds a tree and hands it over. The
+ * next kernel restores it, and checks its contents, and that it can then be
+ * modified and torn down like a locally built tree.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho_map.h>
+#include <linux/mm.h>
+#include <linux/printk.h>
+#include <linux/sort.h>
+
+#define KHO_MAP_TEST_NAME	"kho_map_test"
+#define KHO_MAP_TEST_MAGIC	0x4b484f4d	/* KHOM */
+#define KHO_MAP_TEST_MAX_KEYS	32
+#define KHO_MAP_TEST_KEY_MAX	(BIT_ULL(KHO_MAP_KEY_WIDTH) - 1)
+
+struct kho_map_test_ser {
+	u64 magic;
+	struct kho_map_ser map_ser;
+};
+
+/* Never 0 for valid keys, so every generated key is present. */
+static u64 kho_map_test_value(u64 key)
+{
+	return ~key;
+}
+
+/*
+ * Fill @keys with sorted keys that sit on the boundaries of every level. With
+ * span being the number of keys covered by one entry at level l:
+ *
+ * - span - 1 and span are adjacent keys whose paths split at level l (last key
+ *   of entry 0, first key of entry 1). Walking from one to the other has to
+ *   cross a subtree boundary at exactly that level.
+ * - span * 3 + 5 skips the empty entry 2 at level l and lands on index 5 in the
+ *   leaf. This makes sure iteration correctly skips over empty subtrees and
+ *   leaves.
+ *
+ * Finally, also add the largest valid key to test the path that takes the last
+ * entry of each level.
+ *
+ * Return: number of keys.
+ */
+static unsigned int __init kho_map_test_gen_keys(u64 *keys)
+{
+	unsigned int l, n = 0;
+
+	for (l = 0; l < KHO_MAP_DEPTH; l++) {
+		u64 span = BIT_ULL(l * KHO_MAP_TBL_SHIFT);
+
+		keys[n++] = span - 1;
+		keys[n++] = span;
+		if (span * 3 + 5 < KHO_MAP_TEST_KEY_MAX)
+			keys[n++] = span * 3 + 5;
+	}
+	keys[n++] = KHO_MAP_TEST_KEY_MAX;
+
+	return n;
+}
+
+/*
+ * A key under entry 2 of the root and entry 7 of the leaf. None of the keys
+ * generated by kho_map_test_gen_keys() use it. So setting it needs a whole new
+ * path of nodes.
+ */
+static u64 __init kho_map_test_new_key(void)
+{
+	return BIT_ULL((KHO_MAP_DEPTH - 1) * KHO_MAP_TBL_SHIFT) * 2 + 7;
+}
+
+/* Check that @map has exactly @keys, in order, with the expected values. */
+static int __init kho_map_test_verify(struct kho_map *map, const u64 *keys,
+				      unsigned int n)
+{
+	unsigned int i = 0;
+	u64 key, value;
+
+	kho_map_for_each(map, key, value) {
+		if (i >= n) {
+			pr_err("unexpected key %#llx\n", key);
+			return -EINVAL;
+		}
+
+		if (key != keys[i] || value != kho_map_test_value(keys[i])) {
+			pr_err("entry %u: got %#llx = %#llx, expected %#llx = %#llx\n",
+			       i, key, value, keys[i], kho_map_test_value(keys[i]));
+			return -EINVAL;
+		}
+
+		/* Direct lookups must agree with iteration. */
+		if (kho_map_get(map, key) != value) {
+			pr_err("entry %u: kho_map_get(%#llx) = %#llx, expected %#llx\n",
+			       i, key, kho_map_get(map, key), value);
+			return -EINVAL;
+		}
+
+		i++;
+	}
+
+	if (i != n) {
+		pr_err("found %u keys, expected %u\n", i, n);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define KHO_MAP_ASSERT_EQ(a, b)						\
+	do {								\
+		u64 __a = (a), __b = (b);				\
+									\
+		if (__a != __b) {					\
+			pr_err("%s:%d: %s == %#llx, expected %s == %#llx\n", \
+			       __func__, __LINE__, #a, __a, #b, __b);	\
+			return -EINVAL;					\
+		}							\
+	} while (0)
+
+static int __init kho_map_test_populate(struct kho_map *map, const u64 *keys,
+					unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		KHO_MAP_ASSERT_EQ(kho_map_set(map, keys[i],
+					      kho_map_test_value(keys[i])), 0);
+
+	return 0;
+}
+
+static unsigned long __init
+__kho_map_test_count_nodes(struct kho_map_node_ser *node, unsigned int level)
+{
+	unsigned long count = 1;
+	unsigned int i;
+
+	if (level == 0)
+		return count;
+
+	for (i = 0; i < KHO_MAP_TBL_ENTRIES; i++) {
+		struct kho_map_node_ser *next = KHOSER_LOAD_PTR(node->table[i]);
+
+		if (next)
+			count += __kho_map_test_count_nodes(next, level - 1);
+	}
+
+	return count;
+}
+
+/* Number of nodes (including leaves) currently allocated for @map. */
+static unsigned long __init kho_map_test_count_nodes(struct kho_map *map)
+{
+	struct kho_map_node_ser *root = KHOSER_LOAD_PTR(map->ser->root);
+
+	if (!root)
+		return 0;
+
+	return __kho_map_test_count_nodes(root, KHO_MAP_DEPTH - 1);
+}
+
+/* An empty tree has no entries, and clearing a key in it allocates nothing. */
+static int __init kho_map_test_empty(struct kho_map *map)
+{
+	u64 value;
+
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 0, &value), U64_MAX);
+
+	kho_map_clear(map, 5);
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), 0);
+
+	return 0;
+}
+
+/*
+ * A single key can be found again with its value, by lookup and by iteration,
+ * neighbouring keys have no entry, and it takes exactly one node per level.
+ */
+static int __init kho_map_test_set_get(struct kho_map *map)
+{
+	u64 value = 0;
+
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 42), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 42, 0xdead), 0);
+
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 42), 0xdead);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 41), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 43), 0);
+
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 0, &value), 42);
+	KHO_MAP_ASSERT_EQ(value, 0xdead);
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 43, &value), U64_MAX);
+
+	/* A single key needs exactly one node per level. */
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), KHO_MAP_DEPTH);
+
+	return 0;
+}
+
+/*
+ * The smallest and largest valid keys work, keys past the maximum are rejected
+ * by kho_map_set() and ignored by kho_map_clear(), kho_map_get() and
+ * kho_map_next().
+ */
+static int __init kho_map_test_key_range(struct kho_map *map)
+{
+	u64 value = 0;
+
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 0, 1), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, KHO_MAP_TEST_KEY_MAX, 2), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, KHO_MAP_TEST_KEY_MAX + 1, 3), -ERANGE);
+
+	/* Out of range clear is ignored. */
+	kho_map_clear(map, KHO_MAP_TEST_KEY_MAX + 1);
+
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 0), 1);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, KHO_MAP_TEST_KEY_MAX), 2);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, KHO_MAP_TEST_KEY_MAX + 1), 0);
+
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 0, &value), 0);
+	KHO_MAP_ASSERT_EQ(value, 1);
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 1, &value), KHO_MAP_TEST_KEY_MAX);
+	KHO_MAP_ASSERT_EQ(value, 2);
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, KHO_MAP_TEST_KEY_MAX + 1, &value),
+			  U64_MAX);
+
+	return 0;
+}
+
+/*
+ * kho_map_for_each() returns keys on the boundaries of every level in sorted
+ * order, regardless of insertion order.
+ */
+static int __init kho_map_test_order_all_levels(struct kho_map *map)
+{
+	u64 keys[KHO_MAP_TEST_MAX_KEYS];
+	unsigned int n, i;
+
+	n = kho_map_test_gen_keys(keys);
+
+	/* Insert in reverse, so the order can only come from the tree. */
+	for (i = n; i > 0; i--)
+		KHO_MAP_ASSERT_EQ(kho_map_set(map, keys[i - 1],
+					      kho_map_test_value(keys[i - 1])), 0);
+
+	return kho_map_test_verify(map, keys, n);
+}
+
+/*
+ * kho_map_next() finds a key when started exactly on it, and when started just
+ * after it, skips the empty range up to the next key, across subtree
+ * boundaries at every level.
+ */
+static int __init kho_map_test_next_from_middle(struct kho_map *map)
+{
+	u64 keys[KHO_MAP_TEST_MAX_KEYS];
+	unsigned int n, i;
+	u64 value;
+	int err;
+
+	n = kho_map_test_gen_keys(keys);
+	err = kho_map_test_populate(map, keys, n);
+	if (err)
+		return err;
+
+	for (i = 0; i < n; i++) {
+		u64 next = i + 1 < n ? keys[i + 1] : U64_MAX;
+
+		KHO_MAP_ASSERT_EQ(kho_map_next(map, keys[i], &value), keys[i]);
+		/* Skips over everything up to the next key. */
+		KHO_MAP_ASSERT_EQ(kho_map_next(map, keys[i] + 1, &value), next);
+	}
+
+	return 0;
+}
+
+/*
+ * Setting an existing key replaces its value, and clearing a key (even twice)
+ * removes it. Clearing frees the nodes that become empty, and only those.
+ */
+static int __init kho_map_test_overwrite_clear(struct kho_map *map)
+{
+	u64 value = 0;
+
+	/* Set the same key multiple times. */
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 10, 1), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 10, 2), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 0, &value), 10);
+	KHO_MAP_ASSERT_EQ(value, 2);
+
+	/* Add a key in the next leaf so it shares every node except the leaf. */
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 10 + KHO_MAP_TBL_ENTRIES, 3), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), KHO_MAP_DEPTH + 1);
+
+	/* Clearing it frees its leaf, but not the shared nodes. */
+	kho_map_clear(map, 10 + KHO_MAP_TBL_ENTRIES);
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), KHO_MAP_DEPTH);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 10), 2);
+
+	/* A leaf that still has entries is not freed. */
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 11, 4), 0);
+	kho_map_clear(map, 11);
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), KHO_MAP_DEPTH);
+
+	kho_map_clear(map, 10);
+	/* Clearing twice is fine. */
+	kho_map_clear(map, 10);
+
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 0, &value), U64_MAX);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 10), 0);
+
+	/* The last entry is gone, so the whole tree is freed. */
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), 0);
+
+	/* The tree can be populated again after it was emptied. */
+	KHO_MAP_ASSERT_EQ(kho_map_set(map, 10, 5), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_get(map, 10), 5);
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), KHO_MAP_DEPTH);
+
+	return 0;
+}
+
+/*
+ * kho_map_destroy() frees every node, after which the tree can be initialized
+ * again with kho_map_init(), populated and used like a new one.
+ */
+static int __init kho_map_test_destroy_reuse(struct kho_map *map)
+{
+	bool preserved = map->preserved;
+	u64 keys[KHO_MAP_TEST_MAX_KEYS];
+	unsigned int n;
+	u64 value;
+	int err;
+
+	n = kho_map_test_gen_keys(keys);
+	err = kho_map_test_populate(map, keys, n);
+	if (err)
+		return err;
+
+	kho_map_destroy(map);
+
+	/* Re-initialize, and preserve again if the harness preserved it. */
+	kho_map_init(map, map->ser);
+	if (preserved) {
+		err = kho_map_preserve(map);
+		if (err)
+			return err;
+	}
+
+	KHO_MAP_ASSERT_EQ(kho_map_test_count_nodes(map), 0);
+	KHO_MAP_ASSERT_EQ(kho_map_next(map, 0, &value), U64_MAX);
+
+	err = kho_map_test_populate(map, keys, n);
+	if (err)
+		return err;
+
+	return kho_map_test_verify(map, keys, n);
+}
+
+#define KHO_MAP_TEST(name)	{ #name, kho_map_test_##name }
+
+struct kho_map_test {
+	const char *name;
+	int (*fn)(struct kho_map *map);
+};
+
+static const struct kho_map_test kho_map_tests[] __initconst = {
+	KHO_MAP_TEST(empty),
+	KHO_MAP_TEST(set_get),
+	KHO_MAP_TEST(key_range),
+	KHO_MAP_TEST(order_all_levels),
+	KHO_MAP_TEST(next_from_middle),
+	KHO_MAP_TEST(overwrite_clear),
+	KHO_MAP_TEST(destroy_reuse),
+};
+
+/*
+ * Run the tests that only need the current kernel, each on a fresh tree. With
+ * @preserve, the tree is preserved before the test runs, so nodes get preserved
+ * on allocation and unpreserved on destruction.
+ */
+static int __init kho_map_test_basic(bool preserve)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < ARRAY_SIZE(kho_map_tests); i++) {
+		struct kho_map_ser map_ser;
+		struct kho_map map;
+
+		kho_map_init(&map, &map_ser);
+		err = preserve ? kho_map_preserve(&map) : 0;
+		if (!err)
+			err = kho_map_tests[i].fn(&map);
+		kho_map_destroy(&map);
+
+		if (err) {
+			pr_err("test %s (%spreserved) failed: %d\n",
+			       kho_map_tests[i].name, preserve ? "" : "un", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int __init kho_map_test_save(void)
+{
+	u64 keys[KHO_MAP_TEST_MAX_KEYS];
+	struct kho_map_test_ser *ser;
+	struct kho_map map;
+	unsigned int n, i;
+	int err;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->magic = KHO_MAP_TEST_MAGIC;
+	kho_map_init(&map, &ser->map_ser);
+
+	/*
+	 * Add half the keys before preserving the tree and half after, so both
+	 * kho_map_preserve() walking existing nodes and nodes preserved on
+	 * allocation are exercised. The next kernel can only restore the tree
+	 * if every node got preserved.
+	 */
+	n = kho_map_test_gen_keys(keys);
+	for (i = 0; i < n; i++) {
+		if (i == n / 2) {
+			err = kho_map_preserve(&map);
+			if (err)
+				goto err_destroy;
+		}
+
+		err = kho_map_set(&map, keys[i], kho_map_test_value(keys[i]));
+		if (err)
+			goto err_destroy;
+	}
+
+	err = kho_map_test_verify(&map, keys, n);
+	if (err)
+		goto err_destroy;
+
+	err = kho_add_subtree(KHO_MAP_TEST_NAME, ser, sizeof(*ser));
+	if (err)
+		goto err_destroy;
+
+	return 0;
+
+err_destroy:
+	kho_map_destroy(&map);
+	kho_unpreserve_free(ser);
+	return err;
+}
+
+static int __init kho_map_test_cmp_key(const void *a, const void *b)
+{
+	return cmp_int(*(const u64 *)a, *(const u64 *)b);
+}
+
+static int __init kho_map_test_restore(phys_addr_t phys)
+{
+	struct kho_map_test_ser *ser = phys_to_virt(phys);
+	u64 keys[KHO_MAP_TEST_MAX_KEYS];
+	u64 new_key = kho_map_test_new_key();
+	struct kho_map map;
+	struct folio *folio;
+	unsigned int n;
+	int err;
+
+	if (ser->magic != KHO_MAP_TEST_MAGIC)
+		return -EINVAL;
+
+	n = kho_map_test_gen_keys(keys);
+
+	folio = kho_restore_folio(phys);
+	if (!folio)
+		return -EINVAL;
+
+	err = kho_map_restore(&map, &ser->map_ser);
+	if (err)
+		goto out_put;
+
+	err = kho_map_test_verify(&map, keys, n);
+	if (err)
+		goto out_destroy;
+
+	/*
+	 * Restored nodes must behave like normal: add a key on a new path and
+	 * clear an existing one. The restored tree is unpreserved, so the new
+	 * nodes are not preserved.
+	 */
+	err = kho_map_set(&map, new_key, kho_map_test_value(new_key));
+	if (err)
+		goto out_destroy;
+	kho_map_clear(&map, keys[0]);
+
+	/* keys[0] is gone and new_key took its place. */
+	keys[0] = new_key;
+	/* kho_map_test_verify() expects sorted keys. */
+	sort(keys, n, sizeof(*keys), kho_map_test_cmp_key, NULL);
+
+	err = kho_map_test_verify(&map, keys, n);
+	if (err)
+		goto out_destroy;
+
+	/*
+	 * A restored tree can be preserved again, which preserves both restored
+	 * and new nodes, and kho_map_destroy() then unpreserves them.
+	 */
+	err = kho_map_preserve(&map);
+
+out_destroy:
+	kho_map_destroy(&map);
+out_put:
+	folio_put(folio);
+	return err;
+}
+
+static int __init kho_map_test_init(void)
+{
+	phys_addr_t phys;
+	int err;
+
+	if (!kho_is_enabled())
+		return 0;
+
+	err = kho_retrieve_subtree(KHO_MAP_TEST_NAME, &phys, NULL);
+	if (!err) {
+		err = kho_map_test_restore(phys);
+		if (err)
+			pr_err("KHO map restore failed: %d\n", err);
+		else
+			pr_info("KHO map restore succeeded\n");
+
+		return err;
+	}
+
+	if (err != -ENOENT) {
+		pr_warn("failed to retrieve %s: %d\n", KHO_MAP_TEST_NAME, err);
+		return err;
+	}
+
+	/*
+	 * Run basic tests first. If they fail, no point in doing a handover
+	 * test.
+	 */
+	err = kho_map_test_basic(false);
+	if (!err)
+		err = kho_map_test_basic(true);
+	if (err) {
+		pr_err("KHO map basic tests failed: %d\n", err);
+		return err;
+	}
+
+	err = kho_map_test_save();
+	if (err)
+		pr_err("KHO map save failed: %d\n", err);
+
+	return err;
+}
+late_initcall(kho_map_test_init);
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 1e86ffcc3a79e..03a1a1f55299f 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -119,6 +119,8 @@ function run_qemu() {
 		  -initrd "$initrd"
 
 	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
+	grep "KHO map restore succeeded" "$serial" &> /dev/null || \
+		fail "KHO map failed"
 }
 
 function target_to_arch() {
-- 
2.56.0.611.g1030f0b940-goog


