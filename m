Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AE260A3814
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kjq79ZIY
Received: by kanga.kvack.org (Postfix)
	id 7C7536B05B1; Mon,  9 Nov 2026 13:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F506B05B2; Mon,  9 Nov 2026 13:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9F76B05B3; Mon,  9 Nov 2026 13:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 325E46B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3000A0696
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:41 +0000 (UTC)
X-FDA: 85416408882.26.78B56C4
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF7F21A0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kjq79ZIY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3IhDyagYKCGkSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3IhDyagYKCGkSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHhmhY6cRdeQR3uTF+o2IxUToxKZc/w8lJFloEvagjc=;
	b=yL6jDboKQxJFOs4MbAwC97mqPQp8ptGFO5wX9ePaCHCB8LS3wcjB9ReE8ipMnHJ0BJGSB6
	bWP0hZe6l9do/kpfQcb728iUn2Nzy8ml2FODwkSQSf4kc2tuwIBYhYkADTlE7eNNVe8880
	+Rn5WjdOA2YYZJIWsS9SwgQsFM69GqE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kjq79ZIY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3IhDyagYKCGkSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3IhDyagYKCGkSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248740;
	b=tD4MqHwhs2kNDvxADJfZniQWWCDM8f2jfqD3JLIjU7Pe/qXAnfIWa6TPDCMWL0Gid2ULYp
	lxE0Dic02INzWvxYMxvltkXLJhoKDM+F/84tiEc2RY1Gq5KeQQ5zvHeCxB9unHV0hb03zf
	2x4jtmql9cGu3LqtHYejpCCH0VfxUcw=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b582b355eeso1147343a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248738; x=1794853538; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wHhmhY6cRdeQR3uTF+o2IxUToxKZc/w8lJFloEvagjc=;
        b=kjq79ZIYEf4wMnxoRP3li8bkeBnEhxO79TJ9g4SVjBP2BdFSklXrYr5SfLiQIBo9o2
         /vacrulHWMI15fZa5MYpoq0HGsWY2y3KJw6sqxhlArCaSaSke5KV4gFctR0hA5y0Bd6n
         oi3MVQfXhE/XvRBf2nLa0bCkuTVgCazT6ZDn+BzikeHfLM1NodRkQL3NBmaKf72DUIZs
         5UW8PEN48D0vM/Qb8Zree9yHAbR12tI6+iNr64Y+kdtbgSkzdV6gIsLYxodqHEiShfFQ
         9sRnzN1sXVj3dY1nHu6wP22HOwbOhFNKngBHGTjC5YBLWkv9ouLecbutJS00OxqBHmYp
         dijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248738; x=1794853538;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wHhmhY6cRdeQR3uTF+o2IxUToxKZc/w8lJFloEvagjc=;
        b=okNRrfU2Vm3JOALXkF3cqKQwbomc3qTuC86bEkf0TO+yj/iZdzc872Ym1ueBDmH1Yk
         AcxHEIzNAKPRubrOKbHONflgYCFa/OcnsG4BzpHojugbEaOVD93fwBP5OY8zjyWG+XzS
         ue0rqlikeca9zuEvd8SwWuoQ7WkUWsTZOqNO8u5XtHXqf0SXZICEdtKX8NHGWnnaF/80
         CV8uy/mavNXYsFlkvgpiEtePBCm+M2yhVi6wMmtLk+b0yeV7j9MLC9mCapfMdyQxQTe7
         DeO4e6bYPxAF5aQbFjtetSWrAYS9nKG+FNmP1u93FxRX2Pb3FlmUlVR1wdvoq4ps2Rfg
         PFTw==
X-Forwarded-Encrypted: i=1; AL+hErGtQYNmEEb/imHRdcKLNqowB4mQ/iqYTDMJS3zSPkm6oT7W3BDP16lVvbEWrFUI8/5Xu2A1dNBcow==@kvack.org
X-Gm-Message-State: APuU4Z+YQej2XI02xawbvFnoDXQaHhT/ZqeIQyGgqC0NIFBkx2rjeIWL
	8wmGbci4wRx900cQqWvg7w+lKd8JA3I4VJsS9dt+hIeeFf0UkJqFR1zxbgJq3/rjIa4zPsnk/M1
	hKkh/0g==
X-Received: from edag25.prod.google.com ([2002:a05:6402:3219:b0:6b5:70a4:c77d])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1ed3:b0:6b5:6116:e333
 with SMTP id 4fb4d7f45d1cf-6b756ae9459mr377929a12.31.1794248738070; Mon, 09
 Nov 2026 10:25:38 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:09 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-2-lrizzo@google.com>
Subject: [RFC PATCH v2 01/25] iommu/dma: Introduce CONFIG_PISA and metadata table
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF7F21A0006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ooxwm6myh3jdya1mhi4qz9r8yap4irdm
X-HE-Tag: 1794248739-402050
X-HE-Meta: U2FsdGVkX1+T+41zOmzPDl3gyz34oHApkeJBz1g8QPem+RtWl+6ILpyH4f0juvp6NJkpofbGT8TRCkManELIbOsvhcHFs/lhIhPY4KcR3E6k+Wxr/auk+t08tv3yky+KfvriEO0lV39Px65t6J/kT+bGx2Ew8tZfgwHDm06ZVjxijCKTVk9uzhNitONLO5nMWg17+VFpQF+fTatARnS1iN6D6bqAM0d9wTLKNBfgv9fjh6EfwMoiP0hzvmJN1kCtxcy0JN0bQyV4RzRxdsuGNsU65YsawtuyaMCz6ji2ZiIiQWKchOuSq8ZPB/odGlzbb9P9CMK9qnzmbE3A+QXLth33DyMhn8vMbS84nu4vfcV/swzXLg+wZsybuoDAKCf0bht+CpsARNu98TkxFZP1S58nne3/dKcs/tzoGMNkVRXiOBISlSULO+ze0UKpv+4lQDfcxxzRu8HGJ1KOOna389FTzMi8XiTARaZ9lE9LJJdSchZHQBmLyUsPeH/WmQQGu23lbZvFw0JR4kVm0od4MIGznGHqeiBwfyQd1ZKIFILr0FjMG6/VWi4vZN9WB0RNEq+BhhBq8+xYjriljYgdQE+o7jq3wQH4SoIY+2bwiVFAyXQHaKPdf6VrRD+hJ/aXqIF2OdWCO+F3QSl4nWFgn9zYRqgtNt+svTONITI3OnRAyb7yTzWmS2CCSe2XthIYEZYAjsIsVX+/3wFT0k6zYMEcUmhU+4K4Gjc7pztNnzECHmlRi1/2l/taVjr4+3J7kBtcY9VGmVeyC2FBPVc53UENR6pkR8co9/1Q6QJHE8LjBGrumAL3qn84UKDtUReiYZs/FYQd7VYU14K9LUc9rxUESD+RGDvGW2ppxh7oQsuFA9uwT3FwsHSCy4BmFl7pfRSl2ixylnEeFEafkGU4Cn05nTDWapqZDaUrkIeXyESInnpJSr2MJTn+3lmNWnQ6tw8MUHnu2uuyaNPATIf
 NRqvfATl
 RF3T7Mimop6vfSJEDnrdPCwJ/2li+ere1BY2szBuKri1oB7RUHb8070Lf4AEQzAoElffPFE0elxReBcTT946wQZyoaEICfMGHJ4hMlCAkZr6HRJVLL+VhfzYq+MIZt9INGZj6qjai5gT9D6PPHHTCVc/cgUqCkIjMshV5/Mblc2bJSOwXQkeU8uUExvj2HMiN4GsM40r8H6DyAu1EHLa6g2hobLjHa4uxvbvV6b9szSrW/UCKgnARDoXweypFTChPYs3qkGhhNz9f8dMiEFfbe8hP2d+RZLFXDsCIx30fnHduE4pQ5qEgbWgHIIDYK+9w+V1yH24GcaoWS7Ht5R9Dcc0yGYsZpqxCCrqLh27kpLwFQgrI9pean8dqQFmbhOpA7hqJeoanFcDTnKMpeDS0/7U4eUOD6qiXvgkh3tb3cfQpv8UqoJ+jCTUK/ESPgbc3cH2fhs0kuF6jFWJ9RcKDDI6AQ4ut3Hzg+E2fEkJuTQWjXnuCAbGGuAGJwyRDliW8qT4oKEu1uhfeSU+Cq4VjdniW9ITgraFSecX5hPiYSs98riihUSerEpht9jE36VmHqO4zxwY2ylem16Qox/FWBRqD2JNJ9txkQ6TbFAKvN9AzfcnZNTnRyAa2KM0Yr8hVDh+EZL01USzSnepCnIg44toLmjAvzNU2zfnA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PISA ("Pre-mapped IOVA Superpage Allocator") is a memory allocator
that provides devices which opt in with DMA-able memory backed by large
physically contiguous pages (typically 2MB, but fully configurable),
and mapped by IOMMU leaves of the same size.

PISA has the following features:
- greatly reduces IOTLB pressure by using fewer, much larger IOMMU
  entries.

- greatly reduces DMA map/unmap cost. Mapping only happens when the
  first block from a 2MB page is used. Unmapping is a no-op for the
  caller, and happens in a separate task when no blocks from the 2MB
  page are in use and the page should be returned to the buddy
  allocator.

- much better security than DMA-FQ, because buffers are not returned to
  the buddy allocator until the mappings have been removed and the IOTLB
  flushed.

- removes the cost of copying into bounce buffers, e.g. for
  overcommitted or Confidential Computing VMs.

- fine-grained opt-in selection (each device can opt in selectively for
  descriptors, transmit and/or receive data buffers and headers) permits
  choosing the correct security and performance tradeoffs.

- default is to use the base IOMMU mode (DMA or DMA-FQ) of the device.

PISA is integrated with the main IO APIs (dma_alloc_attrs,
dma_map/unmap, page_pool, TX socket buffers and disk IO buffers) so that
no device driver modifications should be necessary.

Add a CONFIG_PISA option, enabled only on supported kernels (64bit,
!PREEMPT_RT) and introduce a sparse metadata table to hold per-2MB buffer
state (similar to pageblock_flags).
The metadata table is initialized on first use, consumes 4KB of RAM
and 2MB of virtual address space for each 16GB of physical RAM.

Also add a built-in KUnit test suite (CONFIG_PISA_META_KUNIT_TEST)
exercising initialization idempotency, PFN/physical round-trip lookups,
out-of-bounds physical address handling, and PISA membership toggling.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Kconfig      |  33 +++++
 drivers/iommu/Makefile     |   2 +
 drivers/iommu/pisa-kunit.c | 102 +++++++++++++
 drivers/iommu/pisa-meta.c  | 286 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/pisa-priv.h  |  31 ++++
 include/linux/pisa.h       |  79 ++++++++++
 6 files changed, 533 insertions(+)
 create mode 100644 drivers/iommu/pisa-kunit.c
 create mode 100644 drivers/iommu/pisa-meta.c
 create mode 100644 drivers/iommu/pisa-priv.h
 create mode 100644 include/linux/pisa.h

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 85a8d7fdfa30b..15e06eaed0924 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -423,4 +423,37 @@ config IOMMU_DEBUG_PAGEALLOC
 	  If unsure, say N.
 endif # IOMMU_SUPPORT
 
+# Pre-mapped IOVA Superpage Allocator
+config PISA
+	bool "Pre-mapped IOVA Superpage Allocator"
+	depends on X86_64 || ARM64
+	depends on !PREEMPT_RT
+	default y
+	help
+	  PISA is a specialized memory allocator with an API similar to
+	  alloc_pages(). For devices that opt-in, it provides DMA-able
+	  pages backed by 2MB physically contiguous pages, and mapped in
+	  the IOMMU maps with a single leaf PTE of the same size. Mapping,
+	  unmapping and IOTLB flushing are done lazily to reduce CPU overhead.
+	  The large mappings greatly reduce IOTLB usage. As in strict iommu
+	  mode, pages are returned to the buddy allocator only when any existing
+	  mappings have been removed and IOTLB flushed.
+	  Uses 4KB of metadata for each 32MB of PISA buffers, allocated on demand.
+
+	  The config option enforces requirements (2MB large pages and !PREEMPT_RT) at compile
+	  time. Other constraints (e.g. dma-coherent devices) are verified at runtime.
+
+	  If unsure, say Y.
+
+config PISA_META_KUNIT_TEST
+	bool "KUnit test for PISA metadata table (built-in)" if !KUNIT_ALL_TESTS
+	depends on PISA && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit unit tests for the sparse, per-PISA-frame metadata table,
+	  and PISA page allocators in drivers/iommu/pisa-*.c, verifying metadata
+	  lookup, allocator recycling, and coherent block allocation.
+
+	  If unsure, say N.
+
 source "drivers/iommu/generic_pt/Kconfig"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 29a26d2a3af12..b5d3be1df3eda 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
+obj-$(CONFIG_PISA) += pisa-meta.o
+obj-$(CONFIG_PISA_META_KUNIT_TEST) += pisa-kunit.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
new file mode 100644
index 0000000000000..0633f3238e012
--- /dev/null
+++ b/drivers/iommu/pisa-kunit.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for the opaque struct pisa_meta table API.
+ */
+#include <kunit/test.h>
+#include <linux/gfp.h>
+#include <linux/pisa.h>
+#include <linux/mm.h>
+
+#include "pisa-priv.h"
+
+static void test_meta_init_and_roundtrip(struct kunit *test)
+{
+	unsigned long pfn, base_pfn;
+	struct pisa_meta *m_pfn;
+	struct page *page;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+	/* Second call must be idempotent. */
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	pfn = page_to_pfn(page);
+	base_pfn = ALIGN_DOWN(pfn, 1UL << PISA_ORDER);
+	__free_page(page);
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_ensure_pfn(pfn, true), 0);
+	m_pfn = pisa_meta_of_pfn(pfn);
+	KUNIT_EXPECT_EQ(test, pisa_meta_to_pfn(m_pfn), base_pfn);
+}
+
+static void test_meta_invalid_phys(struct kunit *test)
+{
+	struct pisa_meta *meta;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	meta = pisa_meta_of_pfn(PHYS_PFN(PHYS_ADDR_MAX));
+	KUNIT_ASSERT_NOT_NULL(test, meta);
+	KUNIT_EXPECT_EQ(test, pisa_meta_to_pfn(meta), ULONG_MAX);
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(ULONG_MAX >> PAGE_SHIFT));
+	KUNIT_EXPECT_NE(test, pisa_meta_ensure_pfn(ULONG_MAX >> PAGE_SHIFT, false), 0);
+}
+
+static void pisa_meta_set_active(struct pisa_meta *meta, bool active)
+{
+	WRITE_ONCE(meta->flags, active ? PISA_ACTIVE : 0);
+}
+
+static void test_meta_active_toggle(struct kunit *test)
+{
+	unsigned long pfn, base_pfn;
+	struct pisa_meta *meta;
+	struct page *page;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	page = alloc_pages(GFP_KERNEL, PISA_ORDER);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	pfn = page_to_pfn(page);
+	base_pfn = ALIGN_DOWN(pfn, 1UL << PISA_ORDER);
+	/* The buddy allocator returns naturally aligned blocks. */
+	KUNIT_EXPECT_EQ(test, pfn, base_pfn);
+	if (pisa_meta_ensure_pfn(pfn, true)) {
+		__free_pages(page, PISA_ORDER);
+		KUNIT_FAIL(test, "pisa_meta_ensure_pfn(%lu) failed", pfn);
+		return;
+	}
+	KUNIT_EXPECT_EQ(test, pisa_meta_ensure_pfn(pfn, false), 0);
+	meta = pisa_meta_of_pfn(pfn);
+
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+
+	pisa_meta_set_active(meta, true);
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn));
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn + (1UL << PISA_ORDER) - 1));
+
+	pisa_meta_set_active(meta, false);
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+
+	__free_pages(page, PISA_ORDER);
+}
+
+static struct kunit_case pisa_meta_test_cases[] = {
+	KUNIT_CASE(test_meta_init_and_roundtrip),
+	KUNIT_CASE(test_meta_invalid_phys),
+	KUNIT_CASE(test_meta_active_toggle),
+	{}
+};
+
+static struct kunit_suite pisa_meta_test_suite = {
+	.name = "pisa_meta",
+	.test_cases = pisa_meta_test_cases,
+};
+
+kunit_test_suite(pisa_meta_test_suite);
+MODULE_DESCRIPTION("KUnit tests for struct pisa_meta table");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/iommu/pisa-meta.c b/drivers/iommu/pisa-meta.c
new file mode 100644
index 0000000000000..5ceea91e4d5e8
--- /dev/null
+++ b/drivers/iommu/pisa-meta.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA sparse per-PISA-frame metadata table.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/cache.h>
+#include <linux/cacheflush.h>
+#include <linux/pisa.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/memblock.h>
+#include <linux/memory.h>
+#include <linux/moduleparam.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/pgtable.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+
+#include "pisa-priv.h"
+
+static_assert(PISA_META_SIZE <= PAGE_SIZE);
+static_assert(PISA_SIZE <= SZ_2M);
+static_assert(PISA_BLOCKS(0) <= PISA_MAX_BLOCKS);
+static_assert(PISA_ORDER <= MAX_PAGE_ORDER);
+static_assert(PISA_SHIFT <= SUBSECTION_SHIFT);
+
+/* Enabled by pisa_meta_init() to activate fast-path hooks. */
+DEFINE_STATIC_KEY_FALSE(pisa_key);
+EXPORT_SYMBOL(pisa_key);
+
+/* Parameters are pisa.<name> at boot and in /sys/module/pisa/parameters/. */
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "pisa."
+
+/* Physical address bits covered by @pisa_meta_array (0 = max_possible_pfn). */
+static unsigned int pisa_max_bits __read_mostly;
+module_param_named(max_bits, pisa_max_bits, uint, 0444);
+
+/*
+ * Metadata is in a sparse @pisa_meta_array[pfn >> PISA_ORDER] in vmalloc space
+ * (256B per 2MB frame). Each 4KB backing page covers a chunk of 16 entries (32MB)
+ * and is tracked in @pisa_chunk_bitmap, 1 bit per chunk, 4KB per 1TB, 1MB for 48bit
+ * of address space. The total address space is @pisa_meta_nframes, all the variables
+ * are set and memory allocated before enabling @pisa_key.
+ */
+
+/* Sparse per-PISA-frame metadata table, indexed by pfn >> PISA_ORDER */
+struct pisa_meta *pisa_meta_array __read_mostly;
+EXPORT_SYMBOL(pisa_meta_array);
+
+/* Number of PISA frames covered by @pisa_meta_array. */
+unsigned long pisa_meta_nframes __read_mostly;
+EXPORT_SYMBOL(pisa_meta_nframes);
+
+/* One bit per 32MB chunk, set once its metadata page is backed. */
+unsigned long *pisa_chunk_bitmap __read_mostly;
+EXPORT_SYMBOL(pisa_chunk_bitmap);
+
+/* Shared sink entry returned for unbacked or out-of-range PFNs */
+static struct pisa_meta pisa_meta_nil __read_mostly;
+
+/* Protects init and page-table allocation */
+static DEFINE_MUTEX(pisa_meta_mutex);
+
+/* Return metadata for @pfn, or shared sink @pisa_meta_nil (flags == 0) if unbacked. */
+struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn)
+{
+	unsigned long frame = pfn >> PISA_ORDER;
+
+	if (unlikely(!static_branch_unlikely(&pisa_key) || frame >= pisa_meta_nframes ||
+		     !test_bit_acquire(pfn >> PISA_CHUNK_ORDER, pisa_chunk_bitmap)))
+		return &pisa_meta_nil;
+
+	return &pisa_meta_array[frame];
+}
+
+/* Base PFN of @meta's PISA frame, or ULONG_MAX if out-of-range/sink. */
+unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta)
+{
+	unsigned long frame = meta - pisa_meta_array;
+
+	if (unlikely(frame >= pisa_meta_nframes))
+		return ULONG_MAX;
+
+	return frame << PISA_ORDER;
+}
+
+/* PTE for @addr in the array, or NULL if its page table was not allocated. */
+static pte_t *pisa_meta_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (pgd_none(pgdp_get(pgd)))
+		return NULL;
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(p4dp_get(p4d)))
+		return NULL;
+	pud = pud_offset(p4d, addr);
+	if (pud_none(pudp_get(pud)))
+		return NULL;
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(pmdp_get(pmd)))
+		return NULL;
+	return pte_offset_kernel(pmd, addr);
+}
+
+/* Back chunk of @pfn in @pisa_meta_array with a zeroed page and set its bitmap bit. */
+static int pisa_meta_back(unsigned long pfn, gfp_t gfp)
+{
+	/* Protects lazy installation of backing pages into preallocated page tables. */
+	static DEFINE_SPINLOCK(pisa_meta_pte_lock);
+	unsigned long idx = pfn >> PISA_CHUNK_ORDER;
+	unsigned long addr = (unsigned long)pisa_meta_array + (idx << PAGE_SHIFT), flags;
+	struct page *online = pfn_to_online_page(pfn);
+	int nid = online ? page_to_nid(online) : NUMA_NO_NODE;
+	pte_t *ptep = pisa_meta_pte(addr);
+	struct page *page;
+
+	if (!ptep)
+		return -EINVAL;
+
+	page = alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_NOWARN, 0);
+	if (!page)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&pisa_meta_pte_lock, flags);
+	if (pte_none(ptep_get(ptep))) {
+		set_pte_at(&init_mm, addr, ptep, pfn_pte(page_to_pfn(page), PAGE_KERNEL));
+		flush_cache_vmap(addr, addr + PAGE_SIZE);
+		page = NULL;
+		/* Pair with test_bit_acquire() in readers. */
+		smp_mb__before_atomic();
+		set_bit(idx, pisa_chunk_bitmap);
+	}
+	spin_unlock_irqrestore(&pisa_meta_pte_lock, flags);
+
+	if (page)
+		__free_page(page);
+	return 0;
+}
+
+/* Allocate the page tables for the entries of [@start_pfn, @end_pfn). */
+static int pisa_meta_prealloc(struct pisa_meta *array, unsigned long nframes,
+			      unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long start, end;
+
+	end_pfn = min(end_pfn, nframes << PISA_ORDER);
+	if (start_pfn >= end_pfn)
+		return 0;
+
+	start = round_down((unsigned long)&array[start_pfn >> PISA_ORDER], PAGE_SIZE);
+	end = round_up((unsigned long)&array[((end_pfn - 1) >> PISA_ORDER) + 1], PAGE_SIZE);
+	return apply_to_page_range(&init_mm, start, end - start, NULL, NULL);
+}
+
+struct pisa_meta_range {
+	struct pisa_meta *array;
+	unsigned long nframes;
+};
+
+static int pisa_meta_prealloc_ram(unsigned long start_pfn, unsigned long nr_pages, void *arg)
+{
+	struct pisa_meta_range *r = arg;
+
+	return pisa_meta_prealloc(r->array, r->nframes, start_pfn, start_pfn + nr_pages);
+}
+
+/* Page tables for memory about to go online; failure keeps it out of the allocators. */
+static int pisa_meta_memory_cb(struct notifier_block *nb, unsigned long action, void *arg)
+{
+	struct memory_notify *mn = arg;
+
+	if (action != MEM_GOING_ONLINE)
+		return NOTIFY_OK;
+
+	mutex_lock(&pisa_meta_mutex);
+	if (pisa_meta_array)
+		pisa_meta_prealloc(pisa_meta_array, pisa_meta_nframes, mn->start_pfn,
+				   mn->start_pfn + mn->nr_pages);
+	mutex_unlock(&pisa_meta_mutex);
+	return NOTIFY_OK;
+}
+
+/* Memory hotplug notifier for preallocating metadata page tables. */
+static struct notifier_block pisa_meta_memory_nb = {
+	.notifier_call = pisa_meta_memory_cb,
+};
+
+int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block)
+{
+	unsigned long idx = pfn >> PISA_CHUNK_ORDER;
+
+	if (!static_branch_unlikely(&pisa_key) || (pfn >> PISA_ORDER) >= pisa_meta_nframes)
+		return -ERANGE;
+
+	if (likely(test_bit_acquire(idx, pisa_chunk_bitmap)))
+		return 0;
+
+	/* Memory onlined before the notifier was registered has no page table. */
+	if (can_block && !pisa_meta_pte((unsigned long)pisa_meta_array + (idx << PAGE_SHIFT))) {
+		int err;
+
+		mutex_lock(&pisa_meta_mutex);
+		err = pisa_meta_prealloc(pisa_meta_array, pisa_meta_nframes, pfn, pfn + 1);
+		mutex_unlock(&pisa_meta_mutex);
+		if (err)
+			return err;
+	}
+
+	return pisa_meta_back(pfn, can_block ? GFP_KERNEL : GFP_ATOMIC);
+}
+
+/* Reserve the sparse @pisa_meta_array and preallocate page tables for present RAM. */
+int pisa_meta_init(void)
+{
+	unsigned long top_pfn, nframes, nchunks, size;
+	struct pisa_meta_range range;
+	struct pisa_meta *array;
+	struct vm_struct *vm;
+	int ret = 0;
+
+	if (static_branch_unlikely(&pisa_key))
+		return 0;
+
+	mutex_lock(&pisa_meta_mutex);
+	if (pisa_meta_array)
+		goto out_unlock;
+
+	if (pisa_max_bits)
+		top_pfn = 1UL << (clamp_t(unsigned int, pisa_max_bits, PISA_SHIFT,
+					   MAX_PHYSMEM_BITS) - PAGE_SHIFT);
+	else
+		top_pfn = max_t(unsigned long, max_pfn, max_possible_pfn);
+	nframes = DIV_ROUND_UP(top_pfn, 1UL << PISA_ORDER);
+	size = PAGE_ALIGN(nframes << PISA_META_SHIFT);
+	nchunks = size >> PAGE_SHIFT;
+
+	/* kvalloc() to avoid kmalloc limitations on large layouts */
+	pisa_chunk_bitmap = kvcalloc(BITS_TO_LONGS(nchunks), sizeof(unsigned long), GFP_KERNEL);
+	if (!pisa_chunk_bitmap) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	vm = get_vm_area(size, VM_MAP);
+	if (!vm) {
+		ret = -ENOMEM;
+		goto out_free_bitmap;
+	}
+	array = vm->addr;
+
+	range.array = array;
+	range.nframes = nframes;
+	ret = walk_system_ram_range(0, nframes << PISA_ORDER, &range, pisa_meta_prealloc_ram);
+	if (ret)
+		goto out_free_vm;
+
+	pisa_meta_nframes = nframes;
+	pisa_meta_array = array;
+	static_branch_enable(&pisa_key);
+
+	pr_info("pisa: %lu frames, %lu KB of KVA\n", nframes, size / 1024);
+	mutex_unlock(&pisa_meta_mutex);
+
+	/* Register outside pisa_meta_mutex (taken by the notifier under chain lock). */
+	register_memory_notifier(&pisa_meta_memory_nb);
+	return 0;
+
+out_free_vm:
+	free_vm_area(vm);
+out_free_bitmap:
+	kvfree(pisa_chunk_bitmap);
+	pisa_chunk_bitmap = NULL;
+out_unlock:
+	mutex_unlock(&pisa_meta_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(pisa_meta_init);
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
new file mode 100644
index 0000000000000..c873970f6a670
--- /dev/null
+++ b/drivers/iommu/pisa-priv.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+#ifndef _DRIVERS_IOMMU_PISA_PRIV_H
+#define _DRIVERS_IOMMU_PISA_PRIV_H
+
+#include <linux/pisa.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_PISA
+
+#define PISA_MAX_BLOCKS		512U
+
+#define PISA_BLOCKS(order)	(1U << (PISA_ORDER - (order)))
+
+/**
+ * struct pisa_meta - Metadata for a single PISA page in @pisa_meta_array
+ * @flags:	PISA_ACTIVE while this page is owned by a pisa_alloc
+ */
+struct pisa_meta {
+	u8 flags;
+} __aligned(PISA_META_SIZE);
+
+static_assert(offsetof(struct pisa_meta, flags) == 0);
+static_assert(sizeof(struct pisa_meta) == PISA_META_SIZE);
+
+int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block);
+struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
+unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta);
+
+#endif /* CONFIG_PISA */
+#endif /* _DRIVERS_IOMMU_PISA_PRIV_H */
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
new file mode 100644
index 0000000000000..acf92ced245d8
--- /dev/null
+++ b/include/linux/pisa.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* See Documentation/core-api/pisa.rst for the architecture overview. */
+#ifndef _LINUX_PISA_H
+#define _LINUX_PISA_H
+
+#include <linux/bitops.h>
+#include <linux/jump_label.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_PISA
+
+#define PISA_SHIFT		21U
+#define PISA_SIZE		(1UL << PISA_SHIFT)
+#define PISA_MASK		(~(PISA_SIZE - 1))
+#define PISA_ORDER		(PISA_SHIFT - PAGE_SHIFT)
+
+/*
+ * Each struct pisa_meta entry in pisa_meta_array has size PISA_META_SIZE
+ * (256 B) and starts with a u8 flags byte.
+ */
+#define PISA_META_SHIFT		8
+#define PISA_META_SIZE		(1U << PISA_META_SHIFT)
+#define PISA_CHUNK_ORDER	(PISA_ORDER + PAGE_SHIFT - PISA_META_SHIFT)
+
+enum {
+	PISA_ACTIVE		= BIT(0), /* page is owned by a pisa_alloc */
+};
+
+/* Enabled on first pisa_meta_init() to activate fast-path hooks. */
+DECLARE_STATIC_KEY_FALSE(pisa_key);
+
+struct pisa_meta;
+extern struct pisa_meta *pisa_meta_array;
+extern unsigned long pisa_meta_nframes;
+extern unsigned long *pisa_chunk_bitmap;
+
+int pisa_meta_init(void);
+
+/* fast membership check for pisa pfn/pages */
+static inline bool is_pisa_pfn(unsigned long pfn)
+{
+	unsigned long frame = pfn >> PISA_ORDER;
+	const u8 *flags;
+
+	if (!static_branch_unlikely(&pisa_key))
+		return false;
+	if (unlikely(frame >= pisa_meta_nframes ||
+		     !test_bit_acquire(pfn >> PISA_CHUNK_ORDER, pisa_chunk_bitmap)))
+		return false;
+
+	flags = (const u8 *)pisa_meta_array + (frame << PISA_META_SHIFT);
+	return READ_ONCE(*flags) & PISA_ACTIVE;
+}
+
+#else /* !CONFIG_PISA */
+
+static inline int pisa_meta_init(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool is_pisa_pfn(unsigned long pfn)
+{
+	return false;
+}
+
+#endif /* CONFIG_PISA */
+
+static inline bool is_pisa_phys(phys_addr_t phys)
+{
+	return is_pisa_pfn(phys >> PAGE_SHIFT);
+}
+
+static inline bool is_pisa_page(const struct page *page)
+{
+	return is_pisa_pfn(page_to_pfn(page));
+}
+#endif /* _LINUX_PISA_H */
-- 
2.56.0.542.g3ef89b7020-goog


