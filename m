Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9100CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A326B00AC; Tue, 26 May 2026 07:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011906B00AE; Tue, 26 May 2026 07:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A416B00AF; Tue, 26 May 2026 07:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFC6D6B00AC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89DE81203AE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:02 +0000 (UTC)
X-FDA: 84809321604.13.1E901F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9DD4180009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PePxMqzV;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRvHDNjzbBPS+rFbmPB2gJALNMuybb/07mdk5EJCKxw=;
	b=ghxdGS8ZLzbQNcm2OEpYtpMY+7jbry27MIrbm2qZ7KlDKSf0L2dlEAG+bgqsmjjiiLEbSX
	wFH7KTmr4H9VzJxhiyhqGesCqIMkEFQqM/daTlfwEjcvu8DPOB6SFgCsJyv0GqoAWujd3F
	zjjp3fRrGooI7tvaLe91xlJRoGXUlbM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PePxMqzV;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794280; a=rsa-sha256;
	cv=none;
	b=uiy4sevo8jpVHpd1CfrXNb8viitgHAPqO/n36yXGEwGLfKHwLmx1/v7tO2zTXYIu0GwR3H
	6yrNpY+ovHNu47Gd2VePJZ9aW3akhfv2p2dEcbZdwsFdsf8fUq/4IF85fisUE4cKoJiQra
	oxbgA842XxdQ4iv+PCESdla0Wkkun3U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E91B4169C;
	Tue, 26 May 2026 04:17:54 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 250563F7D8;
	Tue, 26 May 2026 04:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794280; bh=6UbRYk/YvXUAWtpLYZu6wDPS/Pd5/nUfgqkLWHxrJ7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PePxMqzVehj2UIBIbvm64QPCtnTfHakL0X6eYCYG5J1vb7mX7Z/Psv1CjxGeS/4QO
	 IsEBBZDmeJFpvUK/kTgDkv3PDWQbzu8JWM8A0PpE16sxAkCdbkmo/xXA9mCxO7cLv0
	 DMI3tXJJzIrziKlnKHRV0juOFlczSPj0yPtA3hhg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:01 +0100
Subject: [PATCH RFC v8 12/24] mm: kpkeys: Protect regular page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-12-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=5204;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=6UbRYk/YvXUAWtpLYZu6wDPS/Pd5/nUfgqkLWHxrJ7c=;
 b=AfN7/YEevro//gMjkeXy1J5hlaMTGq9n0DUXKz40Zk4xYFsOdqkZJNxCNaiTUVJj9XCfiB7uO
 IVqsUweiiGOD1AQZhV/Z19fptOVNk7FpYunOkPfOIhc3Pm70S4uyOt0
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9DD4180009
X-Stat-Signature: iotpmdeqp77t8y3ysajihw67egmeahri
X-HE-Tag: 1779794280-577357
X-HE-Meta: U2FsdGVkX19TWCCUYFVxxJEwqyUEiqlF12s036IcToEQ3FSndGxUkgKEk4tM9FSW62mP9lygSogrUavUU2k9XUTIis2UJ+fGyV2WFM151XTrbOZ/vJizcRWH5Uic2yLUTVf3PBA05pDaNl7JjD1GUqUHxiDD/an0NUdUv4x5WWlxgSCTsrnXKhOwhDy25XTl/niYidAJE+dmuD8LjmASlWp/UkKjIUvfpfxoKQZHlzEGNuFMEttR4v2m0twco4O2N6Cpfl93xbB99pbNs3yOvRWaZXfSEwtlDQVtTF1gtTvIK+fjNN2FulNCh2eqzcFHpVwlLNZRsZ+TMpU/xq0RSZq+LFcUIN4VNDtfELjxAmyKu4hjSCaQHTE2KErlkT1SOzLZ9uCq29VRQy36C58s8KxbfMhApjEuGZy6w3u5yA6rEfjp7DRZBX2a2qz+wxaQYSsE0qh441PFrQikbUSxcjmwX5DBFjl6I9mk0CGCzPr8HhohomxvoZzd/Ig+qh3VE1kUI0VRsyiKLNG12x+ns6X31DpxU5LZqHijSFiGmeYWfL+Z8S3KkWNI8mmATbO0jpC8v+ssLjqNuLqjEMC3PfzZwx1niLcPr9uZ6NrrKvmRwhlNt8XwrLX7L1+jvBLE/JYZYSeVA18RC8+dnq09EkU3d+r0atn7t/hugYiAaA3Gq/yuqhIS8nQYb3PzmST87e0XlcyNBgeM2cLPHqevTL3EFR7gcITpaFydEj9z6kglI+8B7KB9NDs3dpNSqfLEvzGiJ1WgbbH592NNy6+Yxt3EWFlcpWHj142uTS3WsammfoNOYZ2I3fEuh3CHAyU6l4hM7u3jjNH+HRZBDWKFEEkjNTcLINFOnArgJ8WgxKSJOobFqu/JdAYMOi+nIhFCh6iG9NUzZRu+I2xI2DTazlGYD2XYsWw2Z13JZIMaq6A/u2btiJoNe5krHP4GdZcd5LRw+gMmpdbvtSHl7nK
 yFcqrxAN
 5JRTDiFJW2hizDapjeyI0KRfdZkxYJi/NYLqteZFToOBTXV29jXbhT6TYmhz4tj/6okYfRhtz0uQbBzzZjXdPIbetrgNnV//rKjOJNlIixyp6MSdh7ABOdL3AHGt16svEVxb+8ex7L4wMNqw4ytfkp9wlsPsF9Xu3dR3ljGRwtfrNIgKWkx0XnUXBdXHBVPvwFx9PTGIn9StVd7J643zVrS3f+sPfMzZTaz70bhZvVxZ4Q3l2P6KR/yZc7NeIUdQ2JsYyd+9HJyZpXxGOLOK9y0t9o+BC0Cbt6BFp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the kpkeys_hardened_pgtables feature is enabled, page table pages
(PTPs) should be protected by modifying the linear mapping to map
them with a privileged pkey (KPKEYS_PKEY_PGTABLES). This patch
introduces a new page allocator for that purpose:

* kpkeys_pgtable_alloc() allocates a new PTP and sets the linear
  mapping to KPKEYS_PKEY_PGTABLES for that page

* kpkeys_pgtable_free() frees such a PTP and restores the linear
  mapping to the default pkey

This interface is then hooked into pagetable_alloc() and
pagetable_free(), protecting all page tables created once the buddy
allocator is available. Early page tables are allocated in other
ways and will be protected in subsequent patches.

This implementation of kpkeys_pgtable_{alloc,free}() is minimal and
relies on the linear map being fully PTE-mapped - otherwise
calling set_memory_pkey() on a single page may result in splitting a
block mapping, which in turn requires allocating a new PTP. A more
elaborate implementation could be added later to handle this
situation.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 10 +++++++++
 include/linux/mm.h            | 14 +++++++++++--
 mm/kpkeys_hardened_pgtables.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index d413a17f8882..c7529f9e9f97 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -135,6 +135,9 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
 	return arch_supports_kpkeys_early();
 }
 
+struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order);
+void kpkeys_pgtable_free(struct page *page, unsigned int order);
+
 /*
  * Should be called from mem_init(): as soon as the buddy allocator becomes
  * available and before any call to pagetable_alloc().
@@ -153,6 +156,13 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
 	return false;
 }
 
+static inline struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
+{
+	return NULL;
+}
+
+static inline void kpkeys_pgtable_free(struct page *page, unsigned int order) {}
+
 static inline void kpkeys_hardened_pgtables_init(void) {}
 
 #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..7b95b2351763 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -37,6 +37,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kpkeys.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -3648,7 +3649,12 @@ static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
  */
 static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 {
-	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
+	struct page *page;
+
+	if (kpkeys_hardened_pgtables_enabled())
+		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
+	else
+		page = alloc_pages_noprof(gfp | __GFP_COMP, order);
 
 	return page_ptdesc(page);
 }
@@ -3657,8 +3663,12 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 static inline void __pagetable_free(struct ptdesc *pt)
 {
 	struct page *page = ptdesc_page(pt);
+	unsigned int order = compound_order(page);
 
-	__free_pages(page, compound_order(page));
+	if (kpkeys_hardened_pgtables_enabled())
+		kpkeys_pgtable_free(page, order);
+	else
+		__free_pages(page, order);
 }
 
 #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 763f267bbfe4..fff7e2a64b64 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -1,12 +1,59 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kpkeys.h>
 #include <linux/mm.h>
+#include <linux/set_memory.h>
 
 #include <kunit/visibility.h>
 
 __ro_after_init DEFINE_STATIC_KEY_FALSE(kpkeys_hardened_pgtables_key);
 EXPORT_SYMBOL_IF_KUNIT(kpkeys_hardened_pgtables_key);
 
+static int set_pkey_pgtable(struct page *page, unsigned int nr_pages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	int ret;
+
+	ret = set_memory_pkey(addr, nr_pages, KPKEYS_PKEY_PGTABLES);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+static int set_pkey_default(struct page *page, unsigned int nr_pages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	int ret;
+
+	ret = set_memory_pkey(addr, nr_pages, KPKEYS_PKEY_DEFAULT);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
+{
+	struct page *page;
+	int ret;
+
+	page = alloc_pages_noprof(gfp, order);
+	if (!page)
+		return page;
+
+	ret = set_pkey_pgtable(page, 1 << order);
+	if (ret) {
+		__free_pages(page, order);
+		return NULL;
+	}
+
+	return page;
+}
+
+void kpkeys_pgtable_free(struct page *page, unsigned int order)
+{
+	set_pkey_default(page, 1 << order);
+	__free_pages(page, order);
+}
+
 void __init kpkeys_hardened_pgtables_init(void)
 {
 	if (!kpkeys_enabled())

-- 
2.51.2


