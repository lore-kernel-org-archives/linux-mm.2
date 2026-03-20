Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCAD1099B34
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CAF6B0088; Fri, 20 Mar 2026 14:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276536B00CD; Fri, 20 Mar 2026 14:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161286B00B1; Fri, 20 Mar 2026 14:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECE566B00CD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC2221DA7B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:51 +0000 (UTC)
X-FDA: 84567265062.10.CD6D67F
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5D95A0012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VnEwbF0E;
	spf=pass (imf25.hostedemail.com: domain of 3tJC9aQgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tJC9aQgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WoeG/ZuUSN8okdcfkvX8H8rOAlcPJMzezDraYSY2lo=;
	b=6zbsMdc0Blv5SiI/t2yWAnOQDDrZuT2UYiPAU0znFR6iWcyz2YTEu0LkG5FIAcfxdphGY2
	+kBj7LV0bBca+6hH+f7oKIn0VszEA/ZQ3vJJy+lL17ieODiE7A1Hgh9sBR8PSmsMLD+KID
	9Avc94ynOZJXi4obByLsjVFxl/a7FFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031030; a=rsa-sha256;
	cv=none;
	b=uDiGlJISaPKpXE0BMrfmrCw5TCn3RFNKT6wn/pqIWvFz7E5xmju9gy5Xr1ZCQDJJUqyRCV
	MClyUnd8qEl096y5g1SxMKBAfbtYu3sB9GXVp/7xauvvD/XpRmXszhP/vW9DZS5pfxDCRk
	iup3ntW/jRBPTOUxQm0YOd3nwfLzvcU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VnEwbF0E;
	spf=pass (imf25.hostedemail.com: domain of 3tJC9aQgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tJC9aQgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b42fe9031so2389677f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031028; x=1774635828; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WoeG/ZuUSN8okdcfkvX8H8rOAlcPJMzezDraYSY2lo=;
        b=VnEwbF0EJbRxFrUn9rqVDYK2EBCoz+pJ3vhdKkpC8B/yVudtgLdqPGrOYVhqF/c89d
         Mz4flWj4/tBWd9HRYAilcur1eJOJgZDoyWJEqpwUhzX1z2IWJkDzF7UBCMpEiK+z2dRH
         PQqgzwpe7UBLFHigTlpZzc2SF+OV58rMUo79C1RkXz5L1zKo/daStuFezHGBSQWrWcav
         VjVOnmKkmtApiK/fCxUIw0e6AWtfWnFi+aNCiJ0BmUVW+5h0YAhvIKUpSLBS3rHeYjup
         Gz71t4ccjNNFxRq/RT7SwaNgrgaSPr+nXyBm7pgK+RpeISzJmcmFgcr5ybM0btS3YfCb
         IV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031028; x=1774635828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7WoeG/ZuUSN8okdcfkvX8H8rOAlcPJMzezDraYSY2lo=;
        b=fiC/IuNCqpekPxcahJcAd2VF9mmn7WLsRguAJwZtIdPsdhQNRz01VEv6XDop/e7nhC
         JSMU/TPVPOPm2QatCLGQYKmKmT5wyGsK7mZ7/vL9LyBe5D+RM8mnZR7vj2+wvSMlPhDr
         XGHtbkA48hieYBnLhW7ZqEyrvkHPgOz19SKOzbHP7mhG7euzcKoQbVVJdD+8Lh5YYumd
         O9liHFS9pmE3lV2VN0cgHvvG5b7CvxIq8MEjdzeMRq+IPxDNmceckLI2jyo85f8L4aZW
         lJyUAhXOzYQIcJBtXB2jkPpVza3jSh5etsWrwQG+6dGiYs+2RNaBEP1jnABmu/vxUnQx
         gV2Q==
X-Gm-Message-State: AOJu0YySbE13d5RshXQ7cMxMQJpGJiGkeXyNTMVVNJ5lzmam+hwcoLzA
	JXbsHC9e/vDDVHXbeZ1Nhbiwc8MhJ/vbCFGBvZu0/SaqftFuDRTVXDuvBmglvjde/OnvSpWfVc3
	TIqiy2KssKUrnqA==
X-Received: from wrpz9.prod.google.com ([2002:adf:f749:0:b0:43b:402b:468d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c8:b0:439:bcb8:54b7 with SMTP id ffacd0b85a97d-43b6424b9eemr6565674f8f.15.1774031028223;
 Fri, 20 Mar 2026 11:23:48 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:31 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-7-28bf1bd54f41@google.com>
Subject: [PATCH v2 07/22] mm: KUnit tests for the mermap
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: xuwau3dkyfsbacitzysqoo6ch3777g4z
X-Rspamd-Queue-Id: E5D95A0012
X-Rspamd-Server: rspam03
X-HE-Tag: 1774031029-209497
X-HE-Meta: U2FsdGVkX18iShzoutge8Zou96I5/1+3KNWwMZlYpwJZuKYEwsIIJrRrlfyExX9y6tgtCTKzZqclIiSiVGrdhUNskNNM5FqJA8gJH3gOVXmOPOF8pHncjhPjjmmfFMgHGZHLRFDEsB69dSK/GSBX+UbCPPz84ppV6D17NL4WEk/fN6AaLphaCPwpEvnShdnwvnHLIkerBd6L1r1WCNHC44PVYCCtcJyb4NApop25nr1CPae+A8kY0flDR8shGyTF8EIh4A7xNElKzRfX1PmAdrRjCLfWI07JjC7JzoEHwWOUOQijiXs3oDIhJOhNLgVLKbj7xd2xnRIqP6eT+2aO9BZwse6zmfU6wAn5NwCTdDLyWSTi4oAkbYOTTaa1NjZn0fIw9EnNf6V2loomm8X02+JVlYsuoKKc8CHnF+s13ykz5vKOQWAp6Wk9knjmY0uTFO9/rwvaVtC0MsnuV3VTWEvHxgqKoIY2+yrY9gzt3/LQU+T6AMB/SUWKWMV7jt8oYnndckLZZUmpxiNJhl9MNziv1PPQIvIYook81vkMcioUj3ckPkK27jMTZ4AuVaPnt/ccHs6Yw1g4xDQbdKplxTHVPjWA+mv/KIt/6QZPzOrMK54afbLNXe4zS+lbbQw0d87y4xNX4pMgmbpY/lR6WG26dgIAsBztOkSxcrPHxFzUQeqel7Xa86AP+AqUv5ffVsb2qGQpypDoRvl1hgyCHACOtKShKxDnqtlisH+MYG412UHrDlr7NFodbxi9kxYQkmSVBkVqMBWa6I2FncUsZ1C8EUgVh9YbfFid3Dff1WdX5PfIiWl9Y9mtuRM9OFYl39pyxKAWsLqT/cRW3V1GoAfz2ECkwD8i7PczWyHgQKdpdBHgQZAYxaRc8pJs/vXdRvEfODGclfsh7kXBntJYww1e2fklr6qbe6zCKoqGCDjzJ4cmHQZnRiyWGZGEAyNh5X1WApSgEsqxkKcsHI0
 grATpvwr
 knc6NSrYzRActccktBs+kZW/EBl6KA+ZYURMkALkWm4Wx4KqqHdhaO8sHMpWQ0xkM6RwG3m7lv0GRJIIhho09jx8EcCNc2w+sDsLGIZkBH/A9k2tmJVrMHPU+2hZMgRv2gP/2XZmjOLXZ9SdECwXTh8+1sfJt1f32z8bfFGYu43SvM3rBI8hmVavsrYnJEhALB7q363HJNeXBdXHaBlsIjXY9eQ07pPzGW87tI07EUPUfRKpsZWQWFUiGKQDiLUjN8ROONULStc/fhpp5+xwAM+yDmAHZZNGQK/ScGSvH0lCdFy4la8xETyNgAl3qCgWQOKiNU7SfY41R5838OBnRRb961YGuoR7lDmikHUHmTXzlHHRqE9h98Sfgacl3KPQ25OI6Bk8I5ZpEUpz0ljDGaO0xitC7Ok+Lu/IHMMmS4NG8yUc3iF/B0+Gsx9c6coccHWFZ9K4syfsWBpWUFN7p0UnNPzLK2mRpv/THU6wfHeUW1+j6IsMWoAJgtaUr170FXR8y6kmI9Hz8Jd8ybbksTPJMlW3zPHQSW5LBW1ZLe5P4UOxMfzrA2FLR2XEM13Z/anTlYbE6pCuViwIMmo6N5Hrq3Q==
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
 mm/tests/mermap_kunit.c      | 250 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 265 insertions(+)

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
index 2bf1dbcc8cb10..e98db58d515fc 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1494,4 +1494,15 @@ config MERMAP
 	help
 	  Support for epheMERal mappings within the kernel.
 
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
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 0c45677f4a538..93a1756303cf9 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -151,3 +151,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MERMAP) += mermap.o
+obj-$(CONFIG_MERMAP_KUNIT_TEST) += tests/mermap_kunit.o
diff --git a/mm/tests/mermap_kunit.c b/mm/tests/mermap_kunit.c
new file mode 100644
index 0000000000000..4ac6bce2d75f7
--- /dev/null
+++ b/mm/tests/mermap_kunit.c
@@ -0,0 +1,250 @@
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
+	migrate_disable();
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
+	for (int i = 0; i < ARRAY_SIZE(argss); i++) {
+		unsigned long base = mermap_cpu_base(raw_smp_processor_id());
+		unsigned long end = mermap_cpu_end(raw_smp_processor_id());
+		unsigned long addr;
+
+		argss[i] = __mermap_get_wrapper(test, mm, pages[i], PAGE_SIZE, PAGE_KERNEL);
+		KUNIT_ASSERT_NOT_NULL_MSG(test, argss[i], "alloc %d failed", i);
+
+		addr = (unsigned long) mermap_addr(argss[i]->alloc);
+		KUNIT_EXPECT_GE_MSG(test, addr, base, "alloc %d out of range", i);
+		KUNIT_EXPECT_LT_MSG(test, addr, end, "alloc %d out of range", i);
+	};
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
+	KUNIT_ASSERT_NULL(test, __mermap_get(mm, pages[NR_NORMAL_ALLOCS],
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
+	migrate_disable();
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
+
+	migrate_enable();
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
2.51.2


