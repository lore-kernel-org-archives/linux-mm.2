Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1907FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40C56B00A3; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0E36B00A7; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8826B00A8; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6E7E6B00A3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90598401E7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:38 +0000 (UTC)
X-FDA: 84693612276.02.804E4EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9E4491C0045
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBSDW6+7;
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWEXSrrgjPTyHH5bo3swFCpb1c0/pP1nPBJ405dRV74=;
	b=H5rYe23zN4Ar/mNZV05jPJGokyCFgFMtki6MZ3wy5UH9zgWjkT1dwMbXxtoSSBy7G/D44H
	54JNuPqMObAMR4Xtn+ZbIbNz2KwoIRA7HGEPBq+3RcSv3YyxtoPs7s54PDUz6u2ufMvh/z
	IJVoK5tkAC6WtSUK6R/oVkt5TjKca9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039291; a=rsa-sha256;
	cv=none;
	b=IKKmSGsTczvRl6XzRPsA/RFb3Q1dxlJOtu5rtQyt3ObnjkSEkLeQSa5bupP6TYZsyfSygc
	v6N6zuBqvGCkShhRSMAfm+Ozn2GNUukaZ6COOKWxV33pTa734I3FS2MpDmYtzhRBQnf4MA
	p5VUo2QPLoQbY4KPvJERMLh++dv5cAY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBSDW6+7;
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7905240C05;
	Fri, 24 Apr 2026 14:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F1FC2BCB9;
	Fri, 24 Apr 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039290;
	bh=2y/qJ7rBs64ooX/1bvrjs/dZgg1uSC/mWgnTi28gXUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBSDW6+7Vi2Cc7APkzmfTr+0wXlEOeiHYpKiq0go50uYLvH3Bf9CaSxciXpC2/o5P
	 +rnSpIjvgAbBCv1qOHj8FTjemiFbkayuTod2iuJBXxR3ySZ6ROqjlMyNUkLsA5RG8Z
	 TVEvBZW3SRQ+DUjATvg5giL6SNMjSBKBHj06pAR7EqB9Nnzlhkab1xj/P5FD+DSD3V
	 xHRiyyFjI1NPqhvuTT5B9+9iub5jgRXj4x+pi/ldTKoB2/7G9w4JvVIsecuWCfPXgc
	 oFdTNXffHxD37p4LHl7JOAsbuunKSRCFwmtqZlA5tm1XsjL1og2STjxF0wznjsJw4h
	 l9VEajX0l2NlQ==
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
Subject: [RFC 4/7] mm: add page consistency checker implementation
Date: Fri, 24 Apr 2026 10:00:53 -0400
Message-ID: <20260424140056.2094777-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 45ouujq6bb5ct9o6uir8tg8gfhtc3t3w
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E4491C0045
X-Rspamd-Server: rspam05
X-HE-Tag: 1777039291-318517
X-HE-Meta: U2FsdGVkX18qkfYu3PS706DiBLxU1VlN2XkotR1LDTLQUNVec3LsiaF0CmoRh8JX/dP9DpHQo6NuAMNCnApZ9zjRq+3Au7QUi7jvpbWaHGcCa1StIyUnGbuf7NtINB2/em97P8NqnDfPR1aC+IAVKjFoO8UZnbheSXa9M2wSukDOR0CmnyLMlwkDQ/853K9h2Kk+Yf8MYus7VXmz7FfQyndWTDUsMSb6jGbtgqegczwX/PBHUPWVRLRb6DGrdATMsU9zMkaq2qGsHwxbmJkgrgyo70lmT8LAfeQ4EiYMY4UIcBcCBRspOoTATqIbsQEdFNFIclatQsm4YQ85LV1FTrJayCw9dxz8WJerya/uJNXP1UXjJSXKG6MJrUg5lIHSVEllD3fhRI3MyYo9WIQR6CcUaU8YmsliPDTT0KIFD3TeDm6w15OGRTsPxQ27HLch4xJENT+VnkKNrDAyPwKA2w1QAAt6vqV+oRVuSZ68vvP9/w/luHLmsMDbnTyuCFqFic0Fvm6PestfIWCqTDVfso23TMsJD9JY3kcJZ/SG8Ux1ICfUXuz/HDExpKsKPgFXoWipJewt1FouRq/L7SpSncd+sHXFXzRt3lK5Ft7C3u7De0Ol/JypsnzQWtB63pX8wZ0gtZI1ENPPazCFMM6eR/itrT0OVAqA0zCnlFadgyVME6cmBgLh9GwYnXv9O3IgL56lzveYBX3fPwPol/rEbhwGAz6xIzETdhxnR7ZeCBsDIyZN3YsjBBOb4OvupNVOIeYBYUz6JjybENE0wocKTsuGJecRInHn+tMhe7bUIU1CtKbXUu9jSyKge5QU94zqCkPXyWDAD/oJaPSyIGcLiV1EPdg/M2ChzIrgpY/obRxzQAa/FixcZe1rJG8A/ZTkozHVvojjdQa/2g14CFXR31NAXHEXj9xGvHinp7y0HCcT9ibm9sCKtZ4NToVNh0eNpSeIMoZvfqi2DfDuwMj
 OONKwZWX
 SSVayn3BaAE3YLqNJvYXLbm1jFQTOBSG2saBBUPHEWLtaGvFZSYRB5ioalLhGzAfXf4cnxRcXcgKddXfVCfp9Tj4ZSlS/PA8TdrZbgoPFskeHsl6N+/68GpCkHNJlOEsnuiqPHmzxM+m/LmpgHmpBdoxrrevO8B3OFs6+Td6cIKpDbNNiTQVKbGH2AjbKWZcu3YImAn4tOC8JyUs6rhv81r3hUNiIl7oFQXDzzPP3wOY9MYGfmEQ0KXoDjugGxL1gdHzWBE7qPbkjtJ6vT4Yf9h/AC1NbvnvMiWbZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

This is the core implementation of the dual-bitmap page allocator
consistency checker.

During initialization, two bitmaps are allocated covering the physical
memory range reported by memblock. The primary bitmap starts zeroed
(all pages free) and the secondary bitmap starts filled with ones
(the complement). As pages are allocated and freed, both bitmaps are
updated atomically using test_and_set_bit / test_and_clear_bit.

The mark_page_state() helper is the heart of the checker. When
allocating, it sets the bit in primary and clears it in secondary.
If the primary bit was already set, that indicates a double-alloc
and triggers a panic (or warning, depending on config). The free
path updates the bitmaps but defers double-free detection until
after boot completes, since reserved boot memory pages are
legitimately freed via free_reserved_area() and free_initmem()
without ever being allocated through the buddy allocator.

mark_page_state() returns whether the bitmap state actually changed,
and the pages_tracked counter is only updated for real transitions.
This keeps the counter an accurate reflection of the number of bits
currently set in the primary bitmap, rather than a signed delta that
can go negative during boot because of the reserved-area / initmem
frees described above. The same property means post-boot "freeing of
untracked pages" (e.g. a driver unloading a region it received via
memblock) is detected as a real violation; by construction this code
path remains a very small surface.

Initialization validates that the spanned PFN range fits in an unsigned
int (bitmap_bytes and the bitmap APIs are bounded by that) and disables
the feature if it does not; a zero-span memblock is treated the same
way.

A debugfs interface is provided at /sys/kernel/debug/page_consistency/
with two files: "stats" shows counters for allocations, frees, and
violations detected, while writing to "validate" triggers a full scan
that checks the complement invariant holds for every bitmap word.

The enable check at the debugfs late_initcall uses static_key_enabled()
rather than the static_branch_unlikely() hot-path helper, which is the
idiomatic form for a cold init path.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 mm/Makefile           |   1 +
 mm/page_consistency.c | 360 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 361 insertions(+)
 create mode 100644 mm/page_consistency.c

diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..2ee360001456 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
 obj-$(CONFIG_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
+obj-$(CONFIG_DEBUG_PAGE_CONSISTENCY) += page_consistency.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_SECRETMEM) += secretmem.o
 obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
diff --git a/mm/page_consistency.c b/mm/page_consistency.c
new file mode 100644
index 000000000000..f98059a1dcc0
--- /dev/null
+++ b/mm/page_consistency.c
@@ -0,0 +1,360 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Dual-bitmap page allocation consistency checker
+ *
+ * Provides corruption detection for page allocations using complementary
+ * bitmaps. The invariant (primary == ~secondary) detects any single-bit
+ * corruption in either bitmap.
+ *
+ * Based on NVIDIA safety research.
+ */
+
+#define pr_fmt(fmt) "page_consistency: " fmt
+
+#include <linux/page_consistency.h>
+#include <linux/dual_bitmap.h>
+#include <linux/mm.h>
+#include <linux/memblock.h>
+#include <linux/bitmap.h>
+#include <linux/atomic.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+
+DEFINE_STATIC_KEY_FALSE(page_consistency_enabled);
+
+struct page_consistency_stats {
+	atomic64_t pages_tracked;
+	atomic64_t alloc_count;
+	atomic64_t free_count;
+	atomic64_t violations_detected;
+};
+
+static struct page_consistency_stats page_consistency_stats;
+
+/* Internal state */
+static struct {
+	struct dual_bitmap db;
+	unsigned long min_pfn;
+	unsigned long max_pfn;
+} pc_state __ro_after_init;
+
+/**
+ * pfn_to_bit - Convert PFN to bitmap bit index
+ * @pfn: Page frame number
+ *
+ * Returns the bit index in the bitmap for the given PFN.
+ */
+static inline unsigned long pfn_to_bit(unsigned long pfn)
+{
+	return pfn - pc_state.min_pfn;
+}
+
+/**
+ * pfn_in_range - Check if PFN is within tracked range
+ * @pfn: Page frame number to check
+ *
+ * Returns true if the PFN is within the range being tracked.
+ */
+static inline bool pfn_in_range(unsigned long pfn)
+{
+	return pfn >= pc_state.min_pfn && pfn < pc_state.max_pfn;
+}
+
+/**
+ * mark_page_state - Update both bitmaps for a page state change
+ * @pfn: Page frame number
+ * @is_alloc: true for allocation, false for free
+ *
+ * Updates both bitmaps atomically and detects double-alloc/double-free.
+ * Double-free detection is deferred until system_state reaches SYSTEM_RUNNING
+ * because reserved boot memory pages may be freed via free_reserved_area()
+ * and free_initmem() without ever being allocated through the buddy allocator.
+ *
+ * Returns true if the primary bit actually transitioned to the requested
+ * state (0->1 for alloc, 1->0 for free), false if it was already in that
+ * state. Callers use this to keep pages_tracked an accurate reflection of
+ * the number of bits set in the primary bitmap.
+ */
+static bool mark_page_state(unsigned long pfn, bool is_alloc)
+{
+	unsigned long bit = pfn_to_bit(pfn);
+	bool was_allocated;
+
+	/*
+	 * Check the complement invariant before the update. The dual bitops
+	 * below unconditionally write the secondary bit, so a corruption
+	 * confined to the secondary bitmap would be silently erased by the
+	 * very next alloc/free on that PFN. Primary-only corruption is still
+	 * caught via the was_allocated check; this pre-check closes the gap
+	 * for the secondary side so that corruption is reported symmetrically.
+	 */
+	if (unlikely(!dual_bitmap_consistent(&pc_state.db, bit))) {
+		atomic64_inc(&page_consistency_stats.violations_detected);
+#ifdef CONFIG_DEBUG_PAGE_CONSISTENCY_PANIC
+		panic("page_consistency: bitmap corruption at PFN %lu before %s\n",
+		      pfn, is_alloc ? "alloc" : "free");
+#else
+		WARN(1, "page_consistency: bitmap corruption at PFN %lu before %s\n",
+		     pfn, is_alloc ? "alloc" : "free");
+#endif
+	}
+
+	if (is_alloc) {
+		was_allocated = dual_bitmap_set(&pc_state.db, bit);
+		if (unlikely(was_allocated)) {
+			atomic64_inc(&page_consistency_stats.violations_detected);
+#ifdef CONFIG_DEBUG_PAGE_CONSISTENCY_PANIC
+			panic("page_consistency: DOUBLE-ALLOC detected: PFN %lu\n",
+			      pfn);
+#else
+			WARN(1, "page_consistency: DOUBLE-ALLOC detected: PFN %lu\n",
+			     pfn);
+#endif
+			return false;
+		}
+		return true;
+	}
+
+	was_allocated = dual_bitmap_clear(&pc_state.db, bit);
+	if (!was_allocated) {
+		/*
+		 * Only flag double-free after system is fully running.
+		 * During boot, free_reserved_area() and free_initmem() free
+		 * pages never allocated through the buddy allocator - these
+		 * are not bugs. system_state reaches SYSTEM_RUNNING only after
+		 * all such freeing is complete.
+		 */
+		if (unlikely(system_state >= SYSTEM_RUNNING)) {
+			atomic64_inc(&page_consistency_stats.violations_detected);
+#ifdef CONFIG_DEBUG_PAGE_CONSISTENCY_PANIC
+			panic("page_consistency: DOUBLE-FREE detected: PFN %lu\n",
+			      pfn);
+#else
+			WARN(1, "page_consistency: DOUBLE-FREE detected: PFN %lu\n",
+			     pfn);
+#endif
+		}
+		return false;
+	}
+	return true;
+}
+
+/**
+ * __page_consistency_alloc - Track page allocation
+ * @page: Allocated page
+ * @order: Allocation order
+ *
+ * Called from post_alloc_hook() when page_consistency_enabled is true.
+ */
+void __page_consistency_alloc(struct page *page, unsigned int order)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned int nr_pages = 1U << order;
+	unsigned long last_pfn = pfn + nr_pages - 1;
+	unsigned int i, transitions = 0;
+
+	if (!pfn_in_range(pfn) || !pfn_in_range(last_pfn))
+		return;
+
+	for (i = 0; i < nr_pages; i++)
+		if (mark_page_state(pfn + i, true))
+			transitions++;
+
+	atomic64_add(transitions, &page_consistency_stats.pages_tracked);
+	atomic64_inc(&page_consistency_stats.alloc_count);
+}
+
+/**
+ * __page_consistency_free - Track page free
+ * @page: Page being freed
+ * @order: Free order
+ *
+ * Called from free_pages_prepare() when page_consistency_enabled is true.
+ */
+void __page_consistency_free(struct page *page, unsigned int order)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned int nr_pages = 1U << order;
+	unsigned long last_pfn = pfn + nr_pages - 1;
+	unsigned int i, transitions = 0;
+
+	if (!pfn_in_range(pfn) || !pfn_in_range(last_pfn))
+		return;
+
+	for (i = 0; i < nr_pages; i++)
+		if (mark_page_state(pfn + i, false))
+			transitions++;
+
+	atomic64_sub(transitions, &page_consistency_stats.pages_tracked);
+	atomic64_inc(&page_consistency_stats.free_count);
+}
+
+/**
+ * page_consistency_check_page - Check consistency for a single page
+ * @page: Page to check
+ *
+ * Returns PAGE_CONSISTENCY_OK if consistent, PAGE_CONSISTENCY_MISMATCH
+ * if corruption detected, or PAGE_CONSISTENCY_NOT_TRACKED if outside range.
+ */
+enum page_consistency_result page_consistency_check_page(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long bit;
+
+	if (!pfn_in_range(pfn))
+		return PAGE_CONSISTENCY_NOT_TRACKED;
+
+	bit = pfn_to_bit(pfn);
+
+	if (!dual_bitmap_consistent(&pc_state.db, bit)) {
+		atomic64_inc(&page_consistency_stats.violations_detected);
+		pr_err("Consistency violation for PFN %lu\n", pfn);
+		return PAGE_CONSISTENCY_MISMATCH;
+	}
+
+	return PAGE_CONSISTENCY_OK;
+}
+
+/**
+ * page_consistency_validate_all - Validate entire bitmap
+ *
+ * Performs a full consistency check of all bitmap words.
+ * Returns PAGE_CONSISTENCY_OK if all consistent, PAGE_CONSISTENCY_MISMATCH
+ * if any violations found.
+ */
+enum page_consistency_result page_consistency_validate_all(void)
+{
+	unsigned long violations;
+
+	violations = dual_bitmap_validate(&pc_state.db);
+
+	if (violations) {
+		/*
+		 * violations counts inconsistent words, not bits. One word
+		 * could contain up to BITS_PER_LONG corrupted bits.
+		 */
+		atomic64_add(violations, &page_consistency_stats.violations_detected);
+		pr_err("Validation found %lu inconsistent words\n", violations);
+		return PAGE_CONSISTENCY_MISMATCH;
+	}
+
+	pr_info("Validation passed: %u bits checked\n", pc_state.db.nbits);
+	return PAGE_CONSISTENCY_OK;
+}
+
+#ifdef CONFIG_DEBUG_FS
+/* Debugfs interface */
+
+static int stats_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "pages_tracked:       %lld\n",
+		   atomic64_read(&page_consistency_stats.pages_tracked));
+	seq_printf(m, "alloc_count:         %lld\n",
+		   atomic64_read(&page_consistency_stats.alloc_count));
+	seq_printf(m, "free_count:          %lld\n",
+		   atomic64_read(&page_consistency_stats.free_count));
+	seq_printf(m, "violations_detected: %lld\n",
+		   atomic64_read(&page_consistency_stats.violations_detected));
+	seq_printf(m, "bitmap_size_bits:    %u\n", pc_state.db.nbits);
+	seq_printf(m, "pfn_range:           [%lu-%lu)\n",
+		   pc_state.min_pfn, pc_state.max_pfn);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(stats);
+
+static ssize_t validate_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	int result = page_consistency_validate_all();
+
+	return result == PAGE_CONSISTENCY_OK ? count : -EIO;
+}
+
+static const struct file_operations validate_fops = {
+	.write = validate_write,
+	.llseek = noop_llseek,
+};
+
+static int __init page_consistency_debugfs_init(void)
+{
+	struct dentry *dir;
+
+	if (!static_key_enabled(&page_consistency_enabled.key))
+		return 0;
+
+	dir = debugfs_create_dir("page_consistency", NULL);
+	debugfs_create_file("stats", 0444, dir, NULL, &stats_fops);
+	debugfs_create_file("validate", 0200, dir, NULL, &validate_fops);
+
+	return 0;
+}
+late_initcall(page_consistency_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
+
+/**
+ * page_consistency_init - Initialize the page consistency checker
+ *
+ * Called during mm initialization to set up the dual bitmap tracking.
+ * Must be called while memblock is still active (before memblock_free_all()).
+ */
+void __init page_consistency_init(void)
+{
+	unsigned long spanned_pfns;
+	size_t bitmap_bytes;
+
+	/*
+	 * Size bitmaps to cover the full PFN range including any holes.
+	 * Holes waste a few bits but a flat bitmap keeps the indexing
+	 * trivial (pfn - min_pfn) and avoids additional data structures
+	 * that would themselves be subject to corruption.  This matches
+	 * the approach used by pageblock_flags.
+	 */
+	pc_state.min_pfn = PHYS_PFN(memblock_start_of_DRAM());
+	pc_state.max_pfn = PHYS_PFN(memblock_end_of_DRAM());
+	spanned_pfns = pc_state.max_pfn - pc_state.min_pfn;
+	if (!spanned_pfns || spanned_pfns > UINT_MAX) {
+		pr_err("PFN span %lu cannot be represented by bitmap APIs, feature disabled\n",
+		       spanned_pfns);
+		return;
+	}
+
+	pc_state.db.nbits = spanned_pfns;
+
+	bitmap_bytes = BITS_TO_LONGS(pc_state.db.nbits) * sizeof(unsigned long);
+
+	pr_info("Initializing: PFN range [%lu-%lu), %u bits (%zu KB per bitmap)\n",
+		pc_state.min_pfn, pc_state.max_pfn, pc_state.db.nbits,
+		bitmap_bytes / 1024);
+
+	/* Allocate primary bitmap (zeroed by memblock_alloc) */
+	pc_state.db.bitmap[DUAL_BITMAP_PRIMARY] =
+		memblock_alloc(bitmap_bytes, SMP_CACHE_BYTES);
+	if (!pc_state.db.bitmap[DUAL_BITMAP_PRIMARY]) {
+		pr_err("Failed to allocate primary bitmap, feature disabled\n");
+		return;
+	}
+
+	/* Allocate secondary bitmap */
+	pc_state.db.bitmap[DUAL_BITMAP_SECONDARY] =
+		memblock_alloc(bitmap_bytes, SMP_CACHE_BYTES);
+	if (!pc_state.db.bitmap[DUAL_BITMAP_SECONDARY]) {
+		pr_err("Failed to allocate secondary bitmap, feature disabled\n");
+		memblock_free(pc_state.db.bitmap[DUAL_BITMAP_PRIMARY],
+			      bitmap_bytes);
+		pc_state.db.bitmap[DUAL_BITMAP_PRIMARY] = NULL;
+		return;
+	}
+
+	/*
+	 * Initialize: primary all zeros (already done by memblock_alloc),
+	 * secondary all ones. Use dual_bitmap_init() for consistency.
+	 */
+	dual_bitmap_init(&pc_state.db);
+
+	/* Enable tracking */
+	static_branch_enable(&page_consistency_enabled);
+	pr_info("Initialized successfully, tracking enabled\n");
+}
-- 
2.53.0


