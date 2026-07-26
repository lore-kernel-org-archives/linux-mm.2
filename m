Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A294C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3D76B00A0; Sun, 26 Jul 2026 18:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D416B00A2; Sun, 26 Jul 2026 18:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1940B6B00A3; Sun, 26 Jul 2026 18:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3BF56B00A0
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4071A405B2
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:40 +0000 (UTC)
X-FDA: 85032355800.15.2801DD4
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E13A14000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tFd8AC/v";
	spf=pass (imf09.hostedemail.com: domain of 36YhmaggKCO4ZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=36YhmaggKCO4ZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRmKMCTmLt6AK1jKePrzTm1mCt1DLyi3k62vpYouu48=;
	b=RXISHlLiTRnSRHre+i0CYf1Oa5bSPoSxyfNlEHejMVO7lDM9bLxQ92N4KUkdTHCudOm2GB
	TskidDaF4LDVJKDvIX/tQ7w/XzOj0PtlA7Hv6lkMiqa9cz2OQiY6jZhwDEcq0Dv4ec2Ez7
	kFSgJZshBZCm4meJbk/tRWyp7jaPNoA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104618;
	b=qzPW/JuiL+nWeJ1Kd+N4+Jb5mJImBTGzG0ZgafBHFV6weRjSYrPQuTF6P1GHtdpXg8NFmT
	Neqel0+7wUfFATiO2qEDOr4/ioBMjcjEa735scjHLZQLaz1WVfowGHbUGuG271QYsunWfj
	ZIcx1Vgdz4BSVTL71N1b5cXPtzEhZ3g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tFd8AC/v";
	spf=pass (imf09.hostedemail.com: domain of 36YhmaggKCO4ZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=36YhmaggKCO4ZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-496b61bd846so11863825e9.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104617; x=1785709417; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xRmKMCTmLt6AK1jKePrzTm1mCt1DLyi3k62vpYouu48=;
        b=tFd8AC/vdxYSt6AimSR5VzP5QeErCq355uHe6F+5rHSmf/KEXWonXLA3+tIxnHxGKl
         VclkxDgBUD77Bgdn8GtCxNQuab9uiQx+RIrl/mMwpI129xwyTCTbIrK0c8CyafBh80N8
         yUYWDROmsfOGHg1o1IDxKTEsUkrlyk3nP6kfjVUgYfXcTChdcAxipTxjznCoyAp3/ioE
         IjF/DdwMffEx5GDrwXkV4r6/9LcKvM1EjXtK/syUIzv/jaEYXN+j6WmARnjTpslCCaZP
         XU+LuLWXrRpmGBHeTaXxxKfkW8ZC/p9s8Eh6HBSYulImop8XKjWOtRGGfNpILGNNYplH
         2PAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104617; x=1785709417;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xRmKMCTmLt6AK1jKePrzTm1mCt1DLyi3k62vpYouu48=;
        b=nFNGrXdVVAIayYmaUiGNRrMEYRUZ43+FwAjDynkodlwCyZIVTwEd+2srjyhjf5DM6f
         9XS1xTUaZHDIqKINQsyHlxWiB4fH90mqkwcCGXkDOni3uUtf0ol2z2mA+IProf974Ili
         S7tHq7EPMV7yRX1Z12EsCXf1QTtys+fJj+rCuO56MxDoTk3SisTRGP9pTvL6N7QVr8cL
         exT/BfyRtoziQkmUda6BnnDInCLcbUnMlfqg4kQfuoDeUNOOiiev9U385pkpw2534Ciz
         5bHYIDuniOCoX9IKm2NFaiCPYT767dLLyDxCr/9IkVviG/z6SeWpqY6cRsUhIAKf6rg6
         oWPA==
X-Gm-Message-State: AOJu0YybgzcvduMOeGzEsqDCdgjIAYCQIXR1+h1fbpHubaXzndBr3Rk2
	tO0WGVnh+cEPt6AihopvXHGzibtWqIG8Gzl1+d816XHqokEiM0KgBTJfP+3sC7zL/4LePzC993E
	px1Oa/2w+fyArMw==
X-Received: from wmoy18.prod.google.com ([2002:a05:600c:17d2:b0:495:7a24:18e3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:820e:b0:493:e365:ace9 with SMTP id 5b1f17b1804b1-496b56e6603mr73576495e9.11.1785104617159;
 Sun, 26 Jul 2026 15:23:37 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:45 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-12-6f5729aa9832@google.com>
Subject: [PATCH v3 12/26] mm: KUnit tests for the mermap
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E13A14000A
X-Stat-Signature: zssdskiasn93asrfjbwfge9x7jd16gpk
X-Rspam-User: 
X-HE-Tag: 1785104618-663378
X-HE-Meta: U2FsdGVkX18d5H/LtlnEHr5j36YfSBrVLkfv31jn79xjQcxyqnPjWVN6t0hwTA3eHxo8kNp6I7gDIoX9PidvLUO8KM3VNHjstESn53oq7OUtGe/qTbwaRC+hjb8ghVvoIIvU6u27MLQdeoNKCa+1Sjaj7zsYl4vzBt7sDkCCx/GaaLzkWMNqHbtTLZ7RPUz1QvzLh/XWTMDKkDkrUTrt5wY9Pv1hU1DUVEJpS6UU1KvhPZsx26x+QlLvKmWZy6TZre104bV5mTV4QvkpO9zRXx+jnALKw70ihPPxGaiGlLkIR4yJUd/aU7pZI0Up1FCsB+xRnKagNb+xkLUucDNmZoV0X6EnsODRaCPTkg2eMFj0qWmk2WmUjkvyMjbIg6VdflNJMW6H/ohPqfhk28YyNXV/TF3Sj5ydK3p8lA7UwtugEDtMflFnMClAg1oAQHeVHKfft3zMkmWDkhUapkfG+6UYElQ53IxKHkNxvX9ad0N7BKh7qRUIvKf187oVg3H4p+QMjrQw0lqgJ16+FFiaUsKGQ1PULM63+N/+dFQnrsT8X7NBBlX+iyGVa4N4uPnkwL17tTMktnNiy5aR7FjZ+xKAjlKVumsarc/fOglt9PLDzt9vG1E3goel29PX2ItPxQ/huzZ3E2pJFyLSyLSmXAaUCnNuHrJdgCvtLojEQ7IF2AGUWPZoyF3k9YFOBu5kaEd2l7bI2CEXrRYQpNkkHu5XexcgTkNln35CN12vddJlCjZ8ODNZA3zQw9zZx0Qc4zIntAIlDR2htZSsMFHCRY6BsTqaZ0unsDLSi0vatxFDyLzTqaQtqgybtlTjosIcbLBrB3W3I9DrQMWa3TFJRpgT9R9StvTcj3vaRvdLxZ20lKL5gS4x3fSEcVZN+ky7qDOqddanFZICjIA9v7cDf13X6t/JKRIQQHKZBdIxWR8fora2wOqlYchwtStIJlucWmUsA6HKrHvM2Rxn7jK
 IA/AhKST
 wayawoRZnudlY0vxrmVomti9QIkIlXS9dGNweuBCMMShvKuC3k2Wobx703ba3JcUUu0fzv6Yh59kzizfKqS1RdqxdSZhm2yk5hwQ0GC3NUlB4jd6MU+gox6xbKbS9LZ6X5zoBSkXI7s8swOVqbQxJsfauxe/2odMTOeSqrOeUDKpgU56wlzWwdoShXVTolkDzwvdi/i3qY8qVqAZc3Bl/jfrJUcARKCyTvz8isMR0kjNAAy/Yn8OfAldlk4DQoBY8fySQyBN5qRHsvKxphsZQs//jeScXJrYLf0FCvllBAyB5mxZnWYJFL/dMH9EqKEw5Kjiev6WvlQJYtdU+xNtpVUMlHIlNWW5Qmczz9CTAtY0akjAMLyxw6qG8PTY/uffXvehsGOktU5zuqhh6FZ9Z/BhMSUBHMS2b/nMv0M7EJarCYxbhVBNinEFAZgqMdqbEQsFtjWwkaZhmvBWk4yHXaL0GhSw+CAQ1oqupC22mXMjrNPqtuNMJSN1vRwrtN+7iZC3u+xSW8Ep+1FFsN6CMURTR+IIn1MjhKzc6gKCmyvee9q+7fA1jtclH2rIFXMbV6sjoy1pdauoG96PxXMTIKvw6Ht6+tD93hJgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some simple smoke-tests for the mermap. Mainly aiming to test:

1. That there aren't any silly off-by-ones.

2. That the pagetables are not completely broken.

3. That the TLB appears to get flushed basically when expected.

This last point requires a bit of ifdeffery to detect when the flushing
has been performed.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mermap_types.h |   3 +
 mm/Kconfig                   |  11 ++
 mm/Makefile                  |   1 +
 mm/tests/mermap_kunit.c      | 258 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 273 insertions(+)

diff --git a/include/linux/mermap_types.h b/include/linux/mermap_types.h
index c1c83b223c28d..13110fcb4c387 100644
--- a/include/linux/mermap_types.h
+++ b/include/linux/mermap_types.h
@@ -24,6 +24,9 @@ struct mermap_cpu {
 	unsigned long next_addr;
 	struct mermap_alloc normal_allocs[3];
 	struct mermap_alloc reserve_alloc;
+#if IS_ENABLED(CONFIG_MERMAP_KUNIT_TEST)
+	u64 tlb_flushes;
+#endif
 };
 
 struct mermap {
diff --git a/mm/Kconfig b/mm/Kconfig
index bf8c4c6264c73..adf71788971a2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1516,6 +1516,17 @@ config MERMAP
 	depends on ARCH_SUPPORTS_MERMAP
 	select MM_LOCAL_REGION
 
+config MERMAP_KUNIT_TEST
+	tristate "KUnit tests for the mermap" if !KUNIT_ALL_TESTS
+	depends on ARCH_SUPPORTS_MERMAP
+	depends on KUNIT
+	depends on MERMAP
+	default KUNIT_ALL_TESTS
+	help
+	  KUnit test for the mermap.
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 9cf282c154104..3507cb7ed6a9a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
 obj-$(CONFIG_MERMAP) += mermap.o
+obj-$(CONFIG_MERMAP_KUNIT_TEST) += tests/mermap_kunit.o
diff --git a/mm/tests/mermap_kunit.c b/mm/tests/mermap_kunit.c
new file mode 100644
index 0000000000000..737df7d84a340
--- /dev/null
+++ b/mm/tests/mermap_kunit.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cacheflush.h>
+#include <linux/kthread.h>
+#include <linux/mermap.h>
+#include <linux/pgtable.h>
+
+#include <kunit/test.h>
+
+#define NR_NORMAL_ALLOCS ARRAY_SIZE(((struct mm_struct *)NULL)->mermap.cpu->normal_allocs)
+
+KUNIT_DEFINE_ACTION_WRAPPER(__free_page_wrapper, __free_page, struct page *);
+
+static inline struct page *alloc_page_wrapper(struct kunit *test, gfp_t gfp)
+{
+	struct page *page = alloc_page(gfp);
+
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, __free_page_wrapper, page), 0);
+	return page;
+}
+
+KUNIT_DEFINE_ACTION_WRAPPER(mmput_wrapper, mmput, struct mm_struct *);
+
+static inline struct mm_struct *mm_alloc_wrapper(struct kunit *test)
+{
+	struct mm_struct *mm = mm_alloc();
+
+	KUNIT_ASSERT_NOT_NULL(test, mm);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, mmput_wrapper, mm), 0);
+	return mm;
+}
+
+static inline struct mm_struct *get_mm(struct kunit *test)
+{
+	struct mm_struct *mm = mm_alloc_wrapper(test);
+
+	KUNIT_ASSERT_EQ(test, mermap_mm_prepare(mm), 0);
+	return mm;
+}
+
+struct __mermap_put_args {
+	struct mm_struct *mm;
+	struct mermap_alloc *alloc;
+	unsigned long size;
+};
+
+static inline void __mermap_put_wrapper(void *ctx)
+{
+	struct __mermap_put_args *args = (struct __mermap_put_args *)ctx;
+
+	__mermap_put(args->mm, args->alloc);
+	mmdrop(args->mm);
+}
+
+/* Call __mermap_get() with use_reserve=false, deal with cleanup. */
+static inline struct __mermap_put_args *
+__mermap_get_wrapper(struct kunit *test, struct mm_struct *mm,
+		     struct page *page, unsigned long size, pgprot_t prot)
+{
+	struct __mermap_put_args *args =
+		kunit_kmalloc(test, sizeof(struct __mermap_put_args), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, args);
+	/*
+	 * Grab reference to mm_struct/PGD to allow mermap_put() from the
+	 * cleanup kthread.
+	 */
+	mmgrab(mm);
+	args->mm = mm;
+	args->alloc = __mermap_get(mm, page, size, prot, false);
+	args->size = size;
+
+	if (args->alloc) {
+		int err = kunit_add_action_or_reset(test, __mermap_put_wrapper, args);
+
+		KUNIT_ASSERT_EQ(test, err, 0);
+	}
+
+	return args;
+}
+
+/* Do the cleanup from __mermap_get_wrapper, now. */
+static inline void __mermap_put_early(struct kunit *test, struct __mermap_put_args *args)
+{
+	kunit_release_action(test, __mermap_put_wrapper, args);
+}
+
+static void test_basic_alloc(struct kunit *test)
+{
+	struct page *page = alloc_page_wrapper(test, GFP_KERNEL);
+	struct mm_struct *mm = get_mm(test);
+	struct __mermap_put_args *args;
+
+	guard(migrate)();
+
+	args = __mermap_get_wrapper(test, mm, page, PAGE_SIZE, PAGE_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, args->alloc);
+}
+
+/* Dumb check for off-by-ones. */
+static void test_size(struct kunit *test)
+{
+	struct page *page = alloc_page_wrapper(test, GFP_KERNEL);
+	struct __mermap_put_args *full, *large, *small, *fail;
+	struct mm_struct *mm = get_mm(test);
+	unsigned long region_size, large_size;
+	struct mermap_alloc *alloc;
+	int cpu;
+
+	guard(migrate)();
+	cpu = raw_smp_processor_id();
+	region_size = mermap_cpu_end(cpu) - mermap_cpu_base(cpu) - PAGE_SIZE;
+	large_size = region_size - PAGE_SIZE;
+
+	/* Allocate whole region at once. */
+	full = __mermap_get_wrapper(test, mm, page, region_size, PAGE_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, full->alloc);
+	__mermap_put_early(test, full);
+
+	/* Allocate larger than region size. */
+	fail = __mermap_get_wrapper(test, mm, page, region_size + PAGE_SIZE, PAGE_KERNEL);
+	KUNIT_ASSERT_NULL(test, fail->alloc);
+
+	/* Tiptoe up to the edge then past it. */
+	large = __mermap_get_wrapper(test, mm, page, large_size, PAGE_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, large->alloc);
+	small = __mermap_get_wrapper(test, mm, page, PAGE_SIZE, PAGE_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, small->alloc);
+	fail = __mermap_get_wrapper(test, mm, page, PAGE_SIZE, PAGE_KERNEL);
+	KUNIT_ASSERT_NULL(test, fail->alloc);
+
+	/* Can still allocate the reserved page. */
+	local_irq_disable();
+	alloc = __mermap_get(mm, page, PAGE_SIZE, PAGE_KERNEL, true);
+	local_irq_enable();
+	KUNIT_ASSERT_NOT_NULL(test, alloc);
+	__mermap_put(mm, alloc);
+}
+
+static void test_multiple_allocs(struct kunit *test)
+{
+	struct __mermap_put_args *argss[NR_NORMAL_ALLOCS] = { };
+	struct page *pages[NR_NORMAL_ALLOCS + 1];
+	struct mermap_alloc *reserved_alloc;
+	struct mm_struct *mm = get_mm(test);
+	int magic = 0xE4A4;
+
+	for (int i = 0; i < ARRAY_SIZE(pages); i++) {
+		pages[i] = alloc_page_wrapper(test, GFP_KERNEL);
+		WRITE_ONCE(*(int *)page_to_virt(pages[i]), magic + i);
+	}
+
+	guard(migrate)();
+
+	for (int i = 0; i < ARRAY_SIZE(argss); i++) {
+		unsigned long base = mermap_cpu_base(raw_smp_processor_id());
+		unsigned long end = mermap_cpu_end(raw_smp_processor_id());
+		unsigned long addr;
+
+		argss[i] = __mermap_get_wrapper(test, mm, pages[i], PAGE_SIZE, PAGE_KERNEL);
+		KUNIT_ASSERT_NOT_NULL_MSG(test, argss[i]->alloc, "alloc %d failed", i);
+
+		addr = (unsigned long) mermap_addr(argss[i]->alloc);
+		KUNIT_EXPECT_GE_MSG(test, addr, base, "alloc %d out of range", i);
+		KUNIT_EXPECT_LT_MSG(test, addr, end, "alloc %d out of range", i);
+	}
+
+	/*
+	 * Read through the mappings to try and detect if they point to the
+	 * pages we wrote earlier.
+	 */
+	kthread_use_mm(mm);
+	for (int i = 0; i < ARRAY_SIZE(pages) - 1; i++) {
+		int *ptr  = (int *)mermap_addr(argss[i]->alloc);
+
+		KUNIT_EXPECT_EQ(test, *ptr, magic + i);
+	}
+
+	/* Run out of alloc structures, only reserved allocs should succeed now. */
+	KUNIT_EXPECT_NULL(test, __mermap_get(mm, pages[NR_NORMAL_ALLOCS],
+					     PAGE_SIZE, PAGE_KERNEL, false));
+	preempt_disable();
+	reserved_alloc = __mermap_get(mm, pages[NR_NORMAL_ALLOCS],
+				      PAGE_SIZE, PAGE_KERNEL, true);
+	KUNIT_EXPECT_NOT_NULL(test, reserved_alloc);
+	/* Also check if this mapping seems correct*/
+	if (reserved_alloc) {
+		int *ptr  = (int *)mermap_addr(reserved_alloc);
+
+		KUNIT_EXPECT_EQ(test, *ptr, magic + NR_NORMAL_ALLOCS);
+
+		mermap_put(reserved_alloc);
+	}
+	preempt_enable();
+
+	kthread_unuse_mm(mm);
+}
+
+static void test_tlb_flushed(struct kunit *test)
+{
+	struct page *page = alloc_page_wrapper(test, GFP_KERNEL);
+	struct mm_struct *mm = get_mm(test);
+	unsigned long addr, prev_addr = 0;
+	/* Avoid running for ever in failure case. */
+	unsigned long max_iters = 1000000;
+	struct mermap_cpu *mc;
+
+	guard(migrate)();
+	mc = this_cpu_ptr(mm->mermap.cpu);
+
+	/*
+	 * Allocate until we see an address less than what we had before - assume
+	 * that means a reuse.
+	 */
+	for (int i = 0; i < max_iters; i++) {
+		struct mermap_alloc *alloc;
+
+		/*
+		 * Obviously flushing the TLB already is not wrong per se, but
+		 * it's unexpected and probably means there's some bug.
+		 * Use ASSERT to avoid spamming the log in the failure case.
+		 */
+		KUNIT_ASSERT_EQ_MSG(test, mc->tlb_flushes, 0,
+				    "unexpected flush before alloc %d", i);
+
+		alloc = __mermap_get(mm, page, PAGE_SIZE, PAGE_KERNEL, false);
+		KUNIT_ASSERT_NOT_NULL_MSG(test, alloc, "alloc %d failed", i);
+
+		addr = (unsigned long)mermap_addr(alloc);
+		__mermap_put(mm, alloc);
+		if (addr < prev_addr)
+			break;
+
+		prev_addr = addr;
+		cond_resched();
+	}
+	KUNIT_ASSERT_TRUE_MSG(test, addr < prev_addr, "no address reuse");
+	/* Again, more than one flush isn't wrong per se, but probably a bug. */
+	KUNIT_ASSERT_EQ(test, mc->tlb_flushes, 1);
+}
+
+static struct kunit_case mermap_test_cases[] = {
+	KUNIT_CASE(test_basic_alloc),
+	KUNIT_CASE(test_size),
+	KUNIT_CASE(test_multiple_allocs),
+	KUNIT_CASE(test_tlb_flushed),
+	{}
+};
+
+static struct kunit_suite mermap_test_suite = {
+	.name = "mermap",
+	.test_cases = mermap_test_cases,
+};
+kunit_test_suite(mermap_test_suite);
+
+MODULE_DESCRIPTION("Mermap unit tests");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");

-- 
2.54.0


