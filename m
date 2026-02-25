Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86306FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDFD6B00C4; Wed, 25 Feb 2026 11:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02346B00C5; Wed, 25 Feb 2026 11:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A117F6B00C6; Wed, 25 Feb 2026 11:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6666B00C4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4644359FC9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:45 +0000 (UTC)
X-FDA: 84483527730.13.5DA818F
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7B8F340011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yfim9KCQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3oSSfaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oSSfaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037283; a=rsa-sha256;
	cv=none;
	b=CeZq+ZCXTPrgrwiZxTkJ4YpNLD42xUxv7NHzUUzV9/OCiYbB9TYnGeHWX84L61KCJZ9OqV
	Z9D11QanTISf3O5wmmSDjdummI3DiQ7XhVidftVSK0rxO+Fk6DMt90tx+Jos6CAO3IPT7t
	CMV32K0SxsKuwBkC1IRvZ8zLnf5IUvs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yfim9KCQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3oSSfaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oSSfaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxmjLUm6WeIdQIBVxvaEI4PIO0FRY57U8dr5HAgJ3pU=;
	b=uN/WFpL2bv4m2ojgrXg5OXQmlB4uy4nvtEaGPYYV5WZcvOKSp2HxQyyHwfPKXXmKgdYVE7
	U2cVvzOOG1taJjQjKUVOpsDm0PAt8GgG+o4PxEnmn6zkuvKc+RcMDA4JNH0A4kawfsGY78
	GaPfx55AjhTzV124Hct6mLpnd667n8A=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837246211bso71968865e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037282; x=1772642082; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CxmjLUm6WeIdQIBVxvaEI4PIO0FRY57U8dr5HAgJ3pU=;
        b=Yfim9KCQr3fBxHHJlvTgIZPOZLNBl0NxfWlXdoKMzcN4YmIYBtqS94KRaki5KZXPKO
         izQMLImX3Qy+J8QJoAQMjKHCSvtje+vSFCf5GO6pQWdSSJTBFFXeGVGrdvHFVxST6lwT
         3eNnLdNQ7XVdt3i8TaZnegoJ7CVlWUKaOHonRLmSe459WdntOg0VjaWo5gpnP8JZcT6/
         vqDgD/CWhEdlQ/MNEckTM3Mma8S56OffGWi6duJxhJuAdvjrOIXZYnZJaubCbGZiV7FZ
         DotQq5beBYgci8keZKNjp2gP06zjAsU3Pikns7Gx7TrDpnvNzK7YENAj3icDuNgu/SBk
         YNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037282; x=1772642082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxmjLUm6WeIdQIBVxvaEI4PIO0FRY57U8dr5HAgJ3pU=;
        b=g/01zdBvMU7LbLPx6YCoWT7Mtp+YF02a5tsVct8+3zRVQySpY+VE5XVJDtM7VRHDO5
         plo1urGHMnIgp/WaDEifL1TrhDnG6Uc2/3RL8N6a5pHij1jtfK1D/h1J8apgZzKLkRog
         4NXjsreNZXewvMH5EOFURWsd0352am5P4QdTj1CipbwJ2EWVSQMT/jsNhjEnNGq6jPX7
         wfpp4FHcDNXzBhlEtJKv1+UPxsgECEBVYPT/MKMNPFKl8///JGITOmdlfs545QqFbafZ
         8pzuxHYc9DjeDThXTpLXaeMemGGKSTMKlRz2+LycwYSgOdMx1S4WsHQ4/nSRkDMKSf/V
         +YEg==
X-Gm-Message-State: AOJu0Yw60AYk2A0/L2RGSprHRb4DwOZLvikOUI1CVrXQKwYdoCA0XmFA
	N2Hq54Sp5NX2ytZyfXlVizO6bkeH+LUmAZcQF14yT3W/cBWR0BN4jGQUWyqW4115KkjMfmayuwm
	BOiXtLKOo9YFLRA==
X-Received: from wmjf8.prod.google.com ([2002:a7b:cd08:0:b0:477:9b3e:67e3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a016:b0:477:fcb:2256 with SMTP id 5b1f17b1804b1-483a962e470mr289370365e9.17.1772037281848;
 Wed, 25 Feb 2026 08:34:41 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:30 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-5-e8808a03cd66@google.com>
Subject: [PATCH RFC 05/19] mm: KUnit tests for the mermap
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7B8F340011
X-Stat-Signature: syt55jh7afxsezebxywe6h3mhmwi8eg7
X-HE-Tag: 1772037283-322493
X-HE-Meta: U2FsdGVkX1/EMxTWMBBw+TBbH/kPlqrelpwZanYLpQCZqW7nyQx70OqOzsDkRQUtg56hbcg6Vy36h7N5KRMysT28y0vrtieQxxBw20pONiTrLAnLAIRV7nhpVJVlgGGvhLXluFA8igBucf0pKnWV7+ZR1H86X+r4x67V4XdB3j/+r6vGIX+XXfoW2Un+dNSVXBeML4uY2lQA77F9yJsBLHc7S1Hc6eobba3KiXdZQzcuakQ8ElsUe3J0xiHLkeQ/jxt5iJLMRqquNMQNxjSrHn+gQxPik/bI9xRs2XD09VcrPZy1udjL47C7QCYD4SjYyzdAhFpWvXe8IZGURGrP6wGRsFhgPdsjcdClz2tiarQNTJq12rWrJSYSJo/7UmeVTpaR5yLb7mars6aqyfujy9gaeanFduh/fHr4TZCZJ8YSbH4uaGLG5g5lVeccFre4OGE8sIRQ605K5DcgxUYpwVwymwPZUG1zbh7L/lfIVApfpmeE5LATKrU/yLzGgAa9XyKuMF38Qw7Us1oM7PaBpx5SErhNII09k2WY3Nu2Z1sBqi5bV1iWD310sQNGz2IRCmCr7JQ8+DcX1TR1+KA49CIAZYxx1v9vLrS0pnvlfjgGXfeO6rmWiZrbLHZNPUUfBr7bJvxqIgYBIPMK2zF2ARRUNwZDNHds1qzg3JJh2nMIIP0l7S5I7NpgJs3zOmWhzt2DNeomoUTT6C7DqcHgexHVX4i5NeYziD8WybtW7egLclEwHEd63rb/c4wqjOuZv8yQ+pvpd1rj/s3HPrgJBkgR3TbjQ4iLTqwYyCnK2auMGMB3/aOEemdxTZ8cuuGMIz7d0GWe/IdkpmF9foETSWDVmdvDvTV7vyB0LPcaoISOap0jEyhMlC0nv4V3lAC3Dvw6g/oPtwgALEK1chs11qtBRE6IdJN2wYJEYaMqn7gJnq29JHwmxwrDHa0V4Y+NosKNfNcPuDsU1MKecTH
 DM3dpyPQ
 INIgeaOH/lgVvGswjXIm+sfclwduybX52ry364djxyl+ZEXBeYYB1GjTzev6Eybyb6r2m/fDXhYmmHnHIP6K4k4FAghKZWsNvYzw6GPFEOTC4RVIGU6k3FqTbGLx8fOowHr4AqJiHJjIe4Q/cmfDiv1Ji7FF2rXdmPz7u4CVav3jqrCYm/4T46TX45RREjUo7OA23+tq6FLnumLF7m7/fpZKOMhEWoopNrFyng1za9vEK/77cu4NlKm8rq3X9HoHkO4iUCOeqSLsjG0yvolXqgJSZE5EudYrmG3gw69KlWoeMPrhtLPQ3FiqEO5BxNNSxYmqeS4fhy13KCYk5X8hMEMk1xMY+5I9hKVaWcZ+DgMFEWpXb6nxAotEYcr4/zmb9jXM5/KE0hkBanvrsrXArzuqWrlZIgR6Ms11Qg6tlBPgVdw83vfbwLXvo9LgwXu4459IjO3vJzl2Q6cGTKLb9CVKoAYh76SdkoJjLXAx1guhiFwlWXk7qBBfVGto+Y8sdHMWS6RP4o/iolJceJ02lmlZVBPO+8mQT7hUborWeEqIGSAVRODX6UHTohUgZSzZPw50d6dfc80jFYCrWDgEkhyBgxa4szHtpeNDuZ59c/K63wjXPdEQjoWD1HMxJdbDr8ky49x53sY6/cKY=
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
 include/linux/mermap_types.h |   2 +-
 mm/Kconfig                   |  11 +++
 mm/Makefile                  |   1 +
 mm/mermap.c                  |  14 ++-
 mm/tests/mermap_kunit.c      | 231 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 253 insertions(+), 6 deletions(-)

diff --git a/include/linux/mermap_types.h b/include/linux/mermap_types.h
index 08e43100b790e..6b295251b7b01 100644
--- a/include/linux/mermap_types.h
+++ b/include/linux/mermap_types.h
@@ -23,7 +23,7 @@ struct mermap_cpu {
 	/* Next address immediately available for alloc (no TLB flush needed). */
 	unsigned long next_addr;
 	struct mermap_alloc allocs[4];
-#ifdef CONFIG_MERMAP_KUNIT_TEST
+#if IS_ENABLED(CONFIG_MERMAP_KUNIT_TEST)
 	u64 tlb_flushes;
 #endif
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index 06c1c125e9636..bd49eb9ef2165 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1491,4 +1491,15 @@ config MERMAP
 	help
 	  Support for epheMERal mappings within the kernel.
 
+config MERMAP_KUNIT_TEST
+	tristate "KUnit tests for the mermap" if !KUNIT_ALL_TESTS
+	depends on ARCH_SUPPORTS_MERMAP
+	depends on KUNIT
+	select MERMAP
+	default KUNIT_ALL_TESTS
+	help
+	  KUnit test for the mermap.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index b1ac133fe603e..42c8ca32359ae 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -151,3 +151,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MERMAP) += mermap.o
+obj-$(CONFIG_MERMAP_KUNIT_TEST) += tests/mermap_kunit.o
diff --git a/mm/mermap.c b/mm/mermap.c
index d65ecfc06b58e..d840d27cae14c 100644
--- a/mm/mermap.c
+++ b/mm/mermap.c
@@ -24,7 +24,7 @@ static inline int set_unmapped_pte(pte_t *ptep, unsigned long addr, void *data)
 	return 0;
 }
 
-static void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc)
+VISIBLE_IF_KUNIT void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc)
 {
 	unsigned long size = PAGE_ALIGN(alloc->end - alloc->base);
 
@@ -37,6 +37,7 @@ static void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc)
 
 	migrate_enable();
 }
+EXPORT_SYMBOL_IF_KUNIT(__mermap_put);
 
 /* Return a region allocated by mermap_get(). */
 void mermap_put(struct mermap_alloc *alloc)
@@ -45,22 +46,24 @@ void mermap_put(struct mermap_alloc *alloc)
 }
 EXPORT_SYMBOL(mermap_put);
 
-static inline unsigned long mermap_cpu_base(int cpu)
+VISIBLE_IF_KUNIT inline unsigned long mermap_cpu_base(int cpu)
 {
 	return MERMAP_BASE_ADDR + (cpu * MERMAP_CPU_REGION_SIZE);
 
 }
+EXPORT_SYMBOL_IF_KUNIT(mermap_cpu_base);
 
 /* Non-inclusive */
-static inline unsigned long mermap_cpu_end(int cpu)
+VISIBLE_IF_KUNIT inline unsigned long mermap_cpu_end(int cpu)
 {
 	return MERMAP_BASE_ADDR + ((cpu + 1) * MERMAP_CPU_REGION_SIZE);
 
 }
+EXPORT_SYMBOL_IF_KUNIT(mermap_cpu_end);
 
 static inline void mermap_flush_tlb(int cpu, struct mermap_cpu *mc)
 {
-#ifdef CONFIG_MERMAP_KUNIT_TEST
+#if IS_ENABLED(CONFIG_MERMAP_KUNIT_TEST)
 	mc->tlb_flushes++;
 #endif
 	arch_mermap_flush_tlb();
@@ -173,7 +176,7 @@ static inline int do_set_pte(pte_t *pte, unsigned long addr, void *data)
 	return 0;
 }
 
-static struct mermap_alloc *
+VISIBLE_IF_KUNIT struct mermap_alloc *
 __mermap_get(struct mm_struct *mm, struct page *page,
 	     unsigned long size, pgprot_t prot, bool use_reserve)
 {
@@ -207,6 +210,7 @@ __mermap_get(struct mm_struct *mm, struct page *page,
 
 	return alloc;
 }
+EXPORT_SYMBOL_IF_KUNIT(__mermap_get);
 
 /*
  * Allocate a region of virtual memory, and map the page into it. This tries
diff --git a/mm/tests/mermap_kunit.c b/mm/tests/mermap_kunit.c
new file mode 100644
index 0000000000000..ec035b50b8250
--- /dev/null
+++ b/mm/tests/mermap_kunit.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cacheflush.h>
+#include <linux/kthread.h>
+#include <linux/mermap.h>
+#include <linux/pgtable.h>
+
+#include <kunit/test.h>
+
+#define MERMAP_NR_ALLOCS ARRAY_SIZE(((struct mm_struct *)NULL)->mermap.cpu->allocs)
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
+	struct mm_struct *mm = get_mm(test);
+	struct __mermap_put_args *argss[MERMAP_NR_ALLOCS] = { };
+	struct page *pages[MERMAP_NR_ALLOCS];
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
+	for (int i = 0; i < ARRAY_SIZE(pages); i++) {
+		int *ptr  = (int *)mermap_addr(argss[i]->alloc);
+
+		KUNIT_EXPECT_EQ(test, *ptr, magic + i);
+	}
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


