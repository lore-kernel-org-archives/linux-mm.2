Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBB5606A337
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DZGU+qoU
Received: by kanga.kvack.org (Postfix)
	id 0295A6B05C5; Mon,  9 Nov 2026 11:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA64F6B05C6; Mon,  9 Nov 2026 11:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47406B05C7; Mon,  9 Nov 2026 11:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA42B6B05C5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19DEB1206E7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:40 +0000 (UTC)
X-FDA: 85416045960.07.2EF6BF3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E35C2000F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DZGU+qoU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL5Kx3AUeCmxtQnGnnWTgoFnfi9x0Ew1zUUgZ1tmvPk=;
	b=cvgyC5AZPu8q9USsHNjhWtobCiRjRh2DMPFM2RUBWOt+RXn4w3fOIyP/dZMZNpnodl+Lg6
	+Xjrt/mdC8y/GopxrbpzbKOqhzGXR+GUf2DLuHCS9lFFnKJaGnLSJ11XfvBsOhwZcYbPZx
	fR8flpyG+huluD/uWj6eB4GQadFvr7E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DZGU+qoU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240098;
	b=5R3gyPSDTAviA5V1PORJhFWZg9+YhBkGGAaaeXjUDhgbVoQmBLBgEBGfgD7EBCbZ9ip3XH
	LI0GSIVoVyShwPxBAmPBvx6Xq283WRQblAt5U8AHm0b+vvR/7d22Iawa38nOWfOjbtH9iA
	R3LgI0kZqM9iJZQUYumpl5PbtFv16Wg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B0DD14BF;
	Mon,  9 Nov 2026 08:01:34 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F09B3F632;
	Mon,  9 Nov 2026 08:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240097; bh=FJhxPDyYVdBG5bX8IuKyyMgqF3Nmg2Z/S4Ly98Gbm0Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DZGU+qoUNwtnqV/JUKbMv9TCdVdPFTHjn3xhVDCFs2NiQszgkOPYy6MeFaiKAyeGe
	 lALp04xTRVdYeolq1s6qX5/Au3ZOkCX42+T6MbIiJO+7MkuLcT//S4x68+avHavHXc
	 ZTz3NyvO64EuR+p5wp3JjrtAOWyGjM39QNUDdEOM=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:37 +0000
Subject: [PATCH RFC v10 12/22] mm: kpkeys: Protect regular page tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-12-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=5221;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=FJhxPDyYVdBG5bX8IuKyyMgqF3Nmg2Z/S4Ly98Gbm0Q=;
 b=N9Y50oJC035I6cz85GsnRJy64slnDo6TL/8rzblh2yRCsgVCTagovaG2p4NnaC2dSArHieM48
 xMAOSyQE8vHAvSZaisSwZlhfhdYt6qh3ZFAUCA0gbP2XMD4XyHEd7aL
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E35C2000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5qc3c1qb5g6wy661kramiws6c7guxxjy
X-HE-Tag: 1794240098-551608
X-HE-Meta: U2FsdGVkX19+AXsHCa/ajYWexPKWaEqfBRrY2AoJvhm90if8O/7ItxL19ryoPjxM9qXtouVpqWyMJZCb4It/38QXfD+IyCXapsBKLhV6Zr861gfterJs3ODbVLbxMvOfk4cJ+cpWFtZT7pALXDgw9+N3FeSwHXA3iUYU22Q28Bk/cQY3fIZz4aFnHFivb5iAkBijLiKpLjAS8eKPw70RglUwpq97onJl38i07tWqAB4FIb5CduB76iCy1ybITuoX4osOVXiwQaukYNqfRjiZmcJor1QXazmx6Ik5wvByu+s5lSkX0WB8TSSeuou8KyVt+mPw0dikTzwkL6sIs0g54oYPUAJfLgYj8X8ttjkLpNiO3w2j2nBtyR+rFF93AWDoQVDrZiIDI0Q85eWKDthThgB2OzkhIaVMpmy6soS252HU8dZBOXh1mYB/9O05jCBe+PMsMzYksfK2e241824ty2l5p5/JwlopwaWCZUY3Iiod5XTnlvxZ7/4dDl2IwttyRegGKfRgp3ya5R2cM2p/O2TbZPINHbcgwWwjKFaVacV7WU/DbUIrjrZV09NSxvVmIfEadp/7e1JHOkO1MAVgU8tmqAkxgZm3+03MeCvmc4awOAATm2fnuecnEbJG2f8Jgsic1QiRXf8QOc49mQ8fovbIhpMQGwtIoRb2pzN/dTS+Y9lwLu0n0V9fSMPqYNQtcZ9gMSBWkveuY6nI5zyHd6Y5+i3ZLiwssTNn0QiwnlqiCzYxju0JmHp8NNnywIOpFAGE0WegJJtkgMstjXNCDhmLQZLAsAQrDPlwsjK7+p7ElCSvv4/KNYGnaiLZPpcMw5QvclY0qBEAJARp7fJf8s4L7k7Te4MRC9A9s0T3tpNNimW+0Ifq2XEUKTjbz3YBOkNgyZrbUhsBCLk4EY/t5kidL8S0C3wNBIi44bYARQSJLpZ0DUmw0Kvty4OoLMrDwQMIHFoF0xVnz+LT4CO
 crADOF/m
 9dAanW4XIAXhQ2SC4KyhGGk5iLGjkQ2h56jwMadBYkNr4X2oI0gFggIECUHoEpq4cHwSCeJkfKY9YW7WpNpAaZRBHkSkaCt4O8HQMCxhXvvtjNyu5b251EC12jTsGifKcw7+xsI92HfGZRAr0QvTi1uN7e0oWbRzQm22fYlYsq1x91Ca0hO6S79iAqCRdMxJVmVKHAl4bR1E3PfD0Oi9FWI0T9JRu6K+ar1KzlkbUlMmXL9Nwy/qkgYNUpdkJuZi8wIbmtZ9nZcIiIW8CYDHfCMAyx6IQ9RjguzAxo7aXSQiCTmwbfhZkodp9LNxsnJquyJuHPupjB1XSPc9F5b+WwEiBUeiFuS6hCVQN6npLAHHPrh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
calling set_direct_map_pkey() on a single page may result in
splitting a block mapping, which in turn requires allocating a new
PTP. A more elaborate implementation could be added later to handle
this situation.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 10 +++++++++
 include/linux/mm.h            | 14 +++++++++++--
 mm/kpkeys_hardened_pgtables.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index cd3281223778..6c183c86b7d2 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -119,6 +119,9 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
 	return arch_supports_kpkeys_early();
 }
 
+struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order);
+void kpkeys_pgtable_free(struct page *page, unsigned int order);
+
 void kpkeys_hardened_pgtables_init(void);
 
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
@@ -133,6 +136,13 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
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
index 6af3b7008f1a..2af713841035 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -39,6 +39,7 @@
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
 #include <linux/vmemmap-optimization.h>
+#include <linux/kpkeys.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -3950,7 +3951,12 @@ static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
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
@@ -3959,8 +3965,12 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
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
index 4c654e0cf585..2311fd8da6bb 100644
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
+	ret = set_direct_map_pkey(addr, nr_pages, KPKEYS_PKEY_PGTABLES);
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
+	ret = set_direct_map_pkey(addr, nr_pages, 0);
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
 	if (!kpkeys_supported())

-- 
2.56.0


