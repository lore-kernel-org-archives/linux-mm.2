Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D44F8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC57A6B008A; Tue, 21 Apr 2026 11:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CE26B008C; Tue, 21 Apr 2026 11:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA046B0092; Tue, 21 Apr 2026 11:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA6796B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:39:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 706CC1B9480
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:39:20 +0000 (UTC)
X-FDA: 84682972080.15.4638088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91F261C0011
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:39:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DolYikg4;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776785958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C/zETneSXdt4Qa99E3e+0wvtKf5m0NGH+avSAJ+gITY=;
	b=q+Qf8jlQ1of8XIfP6CJ2MUv2Bvn69T0qjVqBcMp/1dRPyxxzool6TOYG0kEhcnEn+cfvo+
	K0FxFc+UUicUl59BujmMZfMQvEJaZsc4OlcgZYU3/cA+ATkhKLeVHpb3+Vx1rrrCRU0OuK
	X7W3HztP6tH1flFh2WU9KL2cmXbJH0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776785958; a=rsa-sha256;
	cv=none;
	b=03D4jjGcfywkfClTDnX/T4wgRMABGBTy/+5XxOTiZhQ3QUuCy2xQ3EmIKv52bgSxTn6EFA
	wZaCdLRI2V4ih8vlaDJ1TzAFgVH25T51d8pUXgKwC5IJ3RUjO5dsHlcukIOF2gDT1izxW2
	iI3HZe8m92tccjPtqKuv4XZ7ZBoOmdM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DolYikg4;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 311CF4151B;
	Tue, 21 Apr 2026 15:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74479C2BCB6;
	Tue, 21 Apr 2026 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776785957;
	bh=Ik9BfKVfhf9yZ3LiURODlQpyNGNrs0AnoKj75WR+DEs=;
	h=From:Date:Subject:To:Cc:From;
	b=DolYikg4H+7mnTbsnAlHUOtejFyckSeDJsZa0O/KWPbowntUsHTsFthTt2vYLcUKO
	 n4ibgl7imYZNrM6J0+PbmHuuRWivxHQXAU3aYCe2Qplntj+ueiR3wkzCABpt+oMNGE
	 1hvNlZZFJoZSYSsr3804XezMrmndYGYHDcCXhM57Mx3CyLyFOyCGEd+V0qxFAOm447
	 A5kekRRFZP6GiSY/nwS4uPO2prdRQwW23XzReaDYX1RgrtxB0ifppG3EyoAnVVVJ6I
	 1xuAQapdwHznNrlaASa1C0jaaKzawk8hZK28N0xA3xJ3eUTFbmTNlHuBwXousJEdPr
	 j1/sVa5TeUllA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 21 Apr 2026 17:39:07 +0200
Subject: [PATCH v2] mm/page_alloc: fix initialization of tags of the huge
 zero folio with init_on_free
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
X-B4-Tracking: v=1; b=H4sIABqa52kC/0XMSwrCMBSF4a2UOzaSl6115D6kg7S5pkFJ5KYEt
 WTvxiI4/A+Hb4WE5DHBqVmBMPvkY6ghdw1MswkOmbe1QXLZci069kaKi3GJKa2MajuF4mih3h+
 EV//cqMtQe/ZpifTa5Cy+6w+R/I9kwQRTaKdeYX8YR32+IQW87yM5GEopH77SdXuhAAAA
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Mark Brown <broonie@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: k3mis5icmb8m44z6f1hue3ciib97p4d1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91F261C0011
X-Rspam-User: 
X-HE-Tag: 1776785958-854087
X-HE-Meta: U2FsdGVkX1+NvV0tV0zrkoL1vMrpFSoJfdfiCGQaXsvc/UmRUII75eEcodS9c4/K8Y7cBJPMr6BFQsDkpMHkVYJnX9tdxrTwDo9O2o4s4tnPwVO/qW0XVMbohyvCPXEwkHPoaRxSLQeTfcHaSgPTR7DDzcU+wO1ag1Y1prjWoSTI0AysTnqlaP1nx646bc9dJ7XKT4sU4gm0xn+0Rmtcpzvyu5UrcJIYTNk29YSBq8Lwway68JyfeHb9g4Zh5lBII5Lai911+QWA3hAu/PT7EbMcRZOwiCA1ifoYQLAv3ixEtVGD3SEUCamYutZNGfNHYu2glxExmz7HIaw+7GtoMvfUask5yxFd1xfIKvv3OT3joF9E2pM41f6ejq/bL1mcGdi8oPTJLdftjINevrWHCypwBiu5AEqzvVXKRiTUrIju2zYfZz3aSNtRBigu8cqTKtQ8yfHfg4868HZPDvGhiGJpcn0w7H0X1WWo3Qgu7UK0sKiutIJj7H9jPZkVoDB4rGx2nYTXeKy1+f913IVy6ap+hkwIEnhEB7sfBISOHTxLBmDN592PtXiKFxtBoZz17neqge7G9ERczwok2vtUoXK1zccpmqwEgN+sYLDJFxV2pBGJ8/IiJVJqsBPf5VnfezRH69tkQuRe3qUDoaGZ29GdlwG8tc0LdacVL5Q8LPjMQN55TqlDMUpzoGeMtEwhZm9rW8dWEsBAoBU86bodb/n1oZ+nknBZXUR/l8TCwuWcWA8Yn9Q8rhX+5AmzUfH/QjKEcnREzwFmsD6u+/JkWz7cjxLxHAdWR1qQEtRPrOnDpwFq8mGryjIiMsdXvOdViBfWswI+PMSzWqTDlF9MAM6b5iSu3RFuGIezSRKvuin+cykBexrmueaCRi3p20/YdTryH1/e6LYFvlXQTbrs1jjIX6AbreNhUPSv+KO/N59ER08cIIW+eB/BWxQeM6KUPgTqdLxf+32bRn0er9T
 atuUO33w
 9WRUIrYmjnZ6dLtSLpvZhyBcCW0zLPGw8Gubz0QBICsyEa5HnL7Ryq0Ur5wNZNokwcECqq1zxhR3+xWfZ/0T1+Lw3X9XRxqjQHrhDDI753z6veicu/MWD5V+fZNcJb3JI6myhjg+U5fqIcVS3ppV94CGmYjJCcQ69pH2H2cvCZZ1sbkBwkHp+21yBT9Jr8GMcZptlMm4PrU+AZ0jZjw/2CncGCvXQLOIpW+9CHzz2JSugGad88tMkE/vv4REnNBeTOjLCY5NS28rgfk+0BagAziIF+q+UyAno02rp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.

If we run with init_on_free, we will zero out pages during
__free_pages_prepare(), to skip zeroing on the allocation path.

However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
consequently not only skip clearing page content, but also skip
clearing tag memory.

Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
will get mapped to user space through set_pte_at() later: set_pte_at() and
friends will detect that the tags have not been initialized yet
(PG_mte_tagged not set), and initialize them.

However, for the huge zero folio, which will be mapped through a PMD
marked as special, this initialization will not be performed, ending up
exposing whatever tags were still set for the pages.

The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
that allocation tags are set to 0 when a page is first mapped to user
space. That no longer holds with the huge zero folio when init_on_free
is enabled.

Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
tag_clear_highpages() whether we want to also clear page content.

Invert the meaning of the tag_clear_highpages() return value to have
clearer semantics.

Reproduced with the huge zero folio by modifying the check_buffer_fill
arm64/mte selftest to use a 2 MiB area, after making sure that pages have
a non-0 tag set when freeing (note that, during boot, we will not
actually initialize tags, but only set KASAN_TAG_KERNEL in the page
flags).

	$ ./check_buffer_fill
	1..20
	...
	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
	...

This code needs more cleanups; we'll tackle that next, like
decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN.

Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Drop kasan_hw_tags_enabled() handling, as it missed the case of
  user-space MTE without KASAN.
- Keep letting_clear_highpages() return a bool and re-instantiate
  system_supports_mte() handling in the arm64 variant.
- Rephrase __GFP_ZEROTAGS comment, making it clearer that this is not
  just a performance improvement.
- Retested and more excessively build tested
- Using a new b4 template, hopefully that doesn't mess things up
- Link to v1: https://lore.kernel.org/r/20260420-zerotags-v1-1-3edc93e95bb4@kernel.org
---
 arch/arm64/include/asm/page.h |  2 +-
 arch/arm64/mm/fault.c         | 11 +++++++----
 include/linux/gfp_types.h     | 10 +++++-----
 include/linux/highmem.h       |  7 ++++---
 mm/page_alloc.c               |  8 ++++----
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index e25d0d18f6d7..58200de8a221 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -33,7 +33,7 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 						unsigned long vaddr);
 #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
 
-bool tag_clear_highpages(struct page *to, int numpages);
+bool tag_clear_highpages(struct page *to, int numpages, bool clear_pages);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0f3c5c7ca054..739800835920 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -1018,7 +1018,7 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 	return vma_alloc_folio(flags, 0, vma, vaddr);
 }
 
-bool tag_clear_highpages(struct page *page, int numpages)
+bool tag_clear_highpages(struct page *page, int numpages, bool clear_pages)
 {
 	/*
 	 * Check if MTE is supported and fall back to clear_highpage().
@@ -1026,13 +1026,16 @@ bool tag_clear_highpages(struct page *page, int numpages)
 	 * post_alloc_hook() will invoke tag_clear_highpages().
 	 */
 	if (!system_supports_mte())
-		return false;
+		return clear_pages;
 
 	/* Newly allocated pages, shouldn't have been tagged yet */
 	for (int i = 0; i < numpages; i++, page++) {
 		WARN_ON_ONCE(!try_page_mte_tagging(page));
-		mte_zero_clear_page_tags(page_address(page));
+		if (clear_pages)
+			mte_zero_clear_page_tags(page_address(page));
+		else
+			mte_clear_page_tags(page_address(page));
 		set_page_mte_tagged(page);
 	}
-	return true;
+	return false;
 }
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 6c75df30a281..d79049291b1a 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -273,11 +273,11 @@ enum {
  *
  * %__GFP_ZERO returns a zeroed page on success.
  *
- * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
- * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
- * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
- * memory tags at the same time as zeroing memory has minimal additional
- * performance impact.
+ * %__GFP_ZEROTAGS zeroes memory tags at allocation time. Setting memory tags at
+ * the same time as zeroing memory (e.g., with __GPF_ZERO) has minimal
+ * additional performance impact. However, __GFP_ZEROTAGS also zeroes the tags
+ * even if memory is not getting zeroed at allocation time (e.g.,
+ * with init_on_free).
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..d7aac9de1c8a 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -347,10 +347,11 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
 
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
-/* Return false to let people know we did not initialize the pages */
-static inline bool tag_clear_highpages(struct page *page, int numpages)
+/* Returns true if the caller has to initialize the pages */
+static inline bool tag_clear_highpages(struct page *page, int numpages,
+		bool clear_pages)
 {
-	return false;
+	return clear_pages;
 }
 
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..71859993dd54 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1808,9 +1808,9 @@ static inline bool should_skip_init(gfp_t flags)
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
+	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
 	set_page_private(page, 0);
@@ -1832,11 +1832,11 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	 */
 
 	/*
-	 * If memory tags should be zeroed
-	 * (which happens only when memory should be initialized as well).
+	 * Clearing tags can efficiently clear the memory for us as well, if
+	 * required.
 	 */
 	if (zero_tags)
-		init = !tag_clear_highpages(page, 1 << order);
+		init = tag_clear_highpages(page, 1 << order, /* clear_pages= */init);
 
 	if (!should_skip_kasan_unpoison(gfp_flags) &&
 	    kasan_unpoison_pages(page, order, init)) {

---

base-commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7

change-id: 20260417-zerotags-343a3673e18d

--

Cheers,

David


