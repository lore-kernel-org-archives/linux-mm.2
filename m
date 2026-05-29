Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B49ACD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA28F6B00F0; Fri, 29 May 2026 13:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54156B00F2; Fri, 29 May 2026 13:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43176B00F3; Fri, 29 May 2026 13:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A07F26B00F0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E9C1140175
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:09 +0000 (UTC)
X-FDA: 84821140698.28.D1BF244
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D7E918000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bI/lKOtb";
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FwHn2bRKJaKHPfoXVMI3en/RPbsnRravWt/lCAWGZY=;
	b=L8ZS2DcddSYhNtwoCNcQSx3PoZcmJE1UB/A3WuduOIAWg4P86ahvMd8TtdGpOpDPmI5gyZ
	M34+iww2xoIMORczY+nobAmPRUIyya8bMhJMhCi959LpSvyw0i40wWegkvHRBp0zWV7hZN
	mZ0fg4eiOioAePjUQiSq9vwXq6BvHCo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bI/lKOtb";
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075687; a=rsa-sha256;
	cv=none;
	b=xL1oYOPmnXW4ZkPPvwlg0/0oIBtT2Oe7l/plIviTHG5+WXIentUDbW4vbvZwAimMF4k7s6
	kmMI6ajqsCMVQWspMQmcrzwcicSkW7N1tYzPFhxToyI+//yN0bC2hotj3xi1ZnTOVIixpI
	foxl1+LhqJbGLrZNluZUZ1zjR6pth3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D3B94447A;
	Fri, 29 May 2026 17:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BBF1F00899;
	Fri, 29 May 2026 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075686;
	bh=7FwHn2bRKJaKHPfoXVMI3en/RPbsnRravWt/lCAWGZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI/lKOtbBymmQ86llSP14z3ZJ6gXciiIAG6G8GjkXgPzkLIJqTAYP8cNlP9+6MZ0P
	 ZkyQfDVeY3DrE+z/cKP0FGn8kf48AIyVN2m2lThJD6z1p6VFzMOkAMR1M3t7VtTm9B
	 d0t/sJv2dewu10X2PUi3VznO4X1LwICqTLdLPRwMxvt2DN5rH7ilpnYYG1wzfLZIun
	 jUbEG12n7n8QodkbeQDL+f+Fh/VvtOWZesTOvjwlPiRmxodQ5sxA+Ufs3hcl28qH5l
	 oof7pebojFrwp2WODovrfUMUwjsM3rKCZV57hte3xIzyaoDDoD4sFdAEqHORVvGhno
	 JnKSbXI0G7d4A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id F1CDEF4006F;
	Fri, 29 May 2026 13:28:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 13:28:05 -0400
X-ME-Sender: <xms:pMwZaqkpXmWyhHhZwW3EYAA1kTVpHv9zl5yPYuLvB_ZTEuSuvBkVPA>
    <xme:pMwZalzae4ZgK-3vUyFM3Toq-CGriJZPO8KeGnFrw9qijYF_XWpZoZjYmLGFbXKA8
    aLI7S9zdLS7jAUyOeE63rlJb4joBUhNYi-U__AFgRh8RvXtMj_EA34>
X-ME-Received: <xmr:pMwZahLhd-Z91TuhrI9nrRkE51DPtPGJYvHwhWVOhjSyGKxskjpYsx5SQpj6sA>
X-ME-Proxy-Cause: dmFkZTEHS1Z+n1S80q4BaszFx9bNnHLQ6sgL6J9HpxOFXRfFtKsh6le5cKxaCZzZ/qH/SJ
    zONNCxWzVoPiQhYsD9dliy9AdrB2UY/Bhb82egQk/l96x3r4UUhrX92dr53s7Ptki96Mx4
    DvJi8H/xrcKSa4upwFZAuWyRsvkJtw5DUL41fEdJBQDb5TWXZV3TgknVzb3pm5Cw5eabt3
    ZKinBz9XCIvsS/RAa3Cb6hoIPIA7Rb0ceUklQcqu2F89W2umMVSE8bbF5HocBMl20u4Nxk
    92MelAoY5r8qDI90ESLS21z7KfMewjRnztTxCHQfAtq0f2Qz4D8wiVPs5MI39B39+ARIMl
    7vGlI3BeSZ/LbcxUUUzqd0Q3MmJoqw42mfHQ4uJNv9dJLruJ2+FcaOcFYdA/PGYdncCvJm
    NAsT0ivnUcG82UzbIQXKjCJBkce1l0gVAAL3WBrzEZ8nhtKDwdCfdUcNZW4ZX6rtTB1VpR
    5wexrTcjiHB0QwWwIy7ckY06iH+3NrLTKNb6QSdAcP9seml2MROTMxQ1FoERhXV6sSIagC
    Hu0CHhXEQWU/ffyogkgH6zX/A79BD9K7JUjoDHaM0Elmp+YgJaZmleljAD0ZEeaYoBnAj0
    vqvWj4uQnpamauZkHm7n9ri5/TQlFF0RAQGr89u4giMyd04mwY3ytj59lYRA
X-ME-Proxy: <xmx:pMwZaoIRtV9pQX3LgcMhDVZUMV1M9nxnu0l7Rv4bzr76CBB_9RTO6w>
    <xmx:pMwZagWTcxwPh5fa2JaE8FbmevBzBiTBLJV89iXuekTPFX8bESJhfQ>
    <xmx:pMwZagApMdGXVnnDh2crIbDHeAd2JJh_cxyDZjuaY1Is6NzUHISG2Q>
    <xmx:pMwZajGbtVjVieagXbJUYC--8tlB4e9xrcKKoL_yk85k7a0S0imNpg>
    <xmx:pMwZasdIj9ZkXlTLhPo-B8JLcWPm0fwNLcmX9DytJS7Zv2KeFJshLlsn>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:28:04 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v6 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Fri, 29 May 2026 18:26:40 +0100
Message-ID: <20260529172716.357179-12-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: koemg138sezesatkppn74933n1b8hmh1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D7E918000A
X-HE-Tag: 1780075686-376604
X-HE-Meta: U2FsdGVkX182akyjITE6QOqNnwvMJCkmFJjTUzke2aQPZiOnG95hPNUhPHPRz1HTUNHiPyPLUjZNtskco4gvNzyTftNlavUif800b/NHNAD/QYvMdHu4RSyk/y2MAAkBmWVAMbjKtwXgjSoeG3zJSktdo2xoxgJvIjx/aFxO+00/PA2uvrz+01xumLyUN0MckIaVNZg57WrfNAUQwKbrp0UZwsMWebWPVVjM+7szeGkgrHyG++9kYd6vUiNbYypk/7U6RSghl6Vmcjcp0bvQ47897sDS6H1PELPIvdu9IZ/34p4O3B8V3ylizuuRB14G57APYHxeOPFKAuu/WbjKi0o9XTsLAo17IvRlths8h2OE8hyBitqK1G1g/TCQIlcTb9QoIMpP0IyFhWL270vBb4x6K68i3Amwdr5JzULU1cxgqSoqy3Bn4cgGtvTqUNThwDqyPO8qRH+nOYacvz+d9EWRLAbuAEPZRQ/z3lXZ+Cb69Zr4YSsYGRNGD7jUbLrqyD9HLiZIDe/qDtxMHl+hVY+rF3gVQVK8/gKSUi1t40H6l0RpaE4Z/8mS2yny21ZwEqFeRcyNTXt3MbSZxblX46xMz+jaY60Ww+Lv/l8BqIqnqRrhTZrmQf0bMtdyUlUfIUdMsAos+mvquqXLMxg7ileD1l0w0iJQ+x3Ll+pCjO0lcC6gfsVG3i4N6yWA9J+TpPlDO6jEen6Dipov9XzkLAOfagsnTvtINFhz+i4p7bdr3GuIyAsQuO6xs+Qm/H6Q5BrfpdjBi9XmafLiAqQFdzAAd1QTUdkpXNh+KbIdfIiXP5qUh4xLZd/AdUZWUNNGSXLgElGEyTo1CH/7FLRa94GbXUSJnaS28N/aI4YasqJh3eP/5ot9fDa0Bpkj/Y1k233twXZhQaqJTnSBB+hDH1P8uwghvd39d2Mlsa0lepDdkEEnlVfBa/F4i0r/yiryp1i+yNNA43V1ZKjp78/
 RuxZosIi
 ZKzqMqk8rAdsPyt6cNmzy9cES8k7dNVvmC4W0sPUdAQaw5rAcaBsGxpTz6owdtKfFbuIReV/ybsHCOIxsS93GZxhxFgg38Xj+jtB2mObVyU9qjg5wtIAnC2ZIY3RV33/uSW5iegE/F+lorIeM+AbPanKkWDxqJ10YuqhzGpkJ0TYqgaWbWIclMXu7TdK7ont5Y7eZ0yGOanpR6g7mDeazVwtCsR6lNfoTp/WXx2q7pSPQriyi7HiAjh9VtwsUfkqFh1q11jVFzRdSi7dVQXOfuzVteV2bLiEy+Q2MqRkK5t4TDC2SoS3BmrsVZvzbtaE1aqBjTK0ETAWXvK8r9V8b91WeDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PAGEMAP_SCAN already reports PAGE_IS_WRITTEN from the inverted uffd
PTE bit, targeting the UFFDIO_WRITEPROTECT workflow. UFFDIO_RWPROTECT
reuses the same PTE bit as a marker for read-write protection, but
"has been written" and "has been accessed" are distinct semantic
signals — they happen to share one PTE bit today only because the two
implementations share infrastructure.

Give RWP its own pagemap category so the UAPI does not conflate them:

  PAGE_IS_WRITTEN   reported on VM_UFFD_WP VMAs,  !pte_uffd(pte)
  PAGE_IS_ACCESSED  reported on VM_UFFD_RWP VMAs, !pte_uffd(pte)

Both still read the same PTE bit today, but each is scoped to the VMA
whose registered mode makes the bit meaningful. If a future
implementation moves RWP to a separate PTE bit, only PAGE_IS_ACCESSED
switches over.

This is a UAPI narrowing. Outside VM_UFFD_WP VMAs the uffd bit is
always clear, so PAGEMAP_SCAN used to flag PAGE_IS_WRITTEN on every
present PTE there — a meaningless duplicate of PAGE_IS_PRESENT. Now
PAGE_IS_WRITTEN fires only inside VM_UFFD_WP VMAs.

pagemap_hugetlb_category() now takes the vma like its PTE/PMD peers.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/admin-guide/mm/pagemap.rst | 13 +++--
 fs/proc/task_mmu.c                       | 63 +++++++++++++++++-------
 include/uapi/linux/fs.h                  |  1 +
 tools/include/uapi/linux/fs.h            |  1 +
 4 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index c57e61b5d8aa..ffa690a171c8 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -19,8 +19,11 @@ There are four components to pagemap:
     * Bit  55    pte is soft-dirty (see
       Documentation/admin-guide/mm/soft-dirty.rst)
     * Bit  56    page exclusively mapped (since 4.2)
-    * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
-      Documentation/admin-guide/mm/userfaultfd.rst)
+    * Bit  57    pte is tracked by userfaultfd (since 5.13) — in a
+      ``VM_UFFD_WP`` VMA this indicates a write-protected PTE; in a
+      ``VM_UFFD_RWP`` VMA it indicates an RWP-protected PTE. WP and
+      RWP are mutually exclusive per VMA, so the meaning is
+      unambiguous. See Documentation/admin-guide/mm/userfaultfd.rst.
     * Bit  58    pte is a guard region (since 6.15) (see madvise (2) man page)
     * Bits 59-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
@@ -244,7 +247,8 @@ in this IOCTL:
 Following flags about pages are currently supported:
 
 - ``PAGE_IS_WPALLOWED`` - Page has async-write-protection enabled
-- ``PAGE_IS_WRITTEN`` - Page has been written to from the time it was write protected
+- ``PAGE_IS_WRITTEN`` - Page in a ``UFFDIO_REGISTER_MODE_WP`` VMA has been
+  written to since it was write-protected. Only reported inside such VMAs.
 - ``PAGE_IS_FILE`` - Page is file backed
 - ``PAGE_IS_PRESENT`` - Page is present in the memory
 - ``PAGE_IS_SWAPPED`` - Page is in swapped
@@ -252,6 +256,9 @@ Following flags about pages are currently supported:
 - ``PAGE_IS_HUGE`` - Page is PMD-mapped THP or Hugetlb backed
 - ``PAGE_IS_SOFT_DIRTY`` - Page is soft-dirty
 - ``PAGE_IS_GUARD`` - Page is a part of a guard region
+- ``PAGE_IS_ACCESSED`` - Page in a ``UFFDIO_REGISTER_MODE_RWP`` VMA has been
+  accessed since RWP was applied. Only reported inside such VMAs. See
+  Documentation/admin-guide/mm/userfaultfd.rst for the RWP workflow.
 
 The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ca0f69b347e8..a1683d73b405 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2284,7 +2284,7 @@ static const struct mm_walk_ops pagemap_ops = {
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bit  57    pte is uffd-wp write-protected
+ * Bit  57    pte is tracked by userfaultfd (uffd-wp or RWP)
  * Bit  58    pte is a guard region
  * Bits 59-60 zero
  * Bit  61    page is file-page or shared-anon
@@ -2419,7 +2419,7 @@ static int pagemap_release(struct inode *inode, struct file *file)
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
 				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
-				 PAGE_IS_GUARD)
+				 PAGE_IS_GUARD | PAGE_IS_ACCESSED)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -2444,8 +2444,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
 		categories = PAGE_IS_PRESENT;
 
-		if (!pte_uffd(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pte_uffd(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			page = vm_normal_page(vma, addr, pte);
@@ -2462,8 +2466,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
 		categories = PAGE_IS_SWAPPED;
 
-		if (!pte_swp_uffd_any(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pte_swp_uffd_any(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 
 		entry = softleaf_from_pte(pte);
 		if (softleaf_is_guard_marker(entry))
@@ -2512,8 +2520,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 		struct page *page;
 
 		categories |= PAGE_IS_PRESENT;
-		if (!pmd_uffd(pmd))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pmd_uffd(pmd)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			page = vm_normal_page_pmd(vma, addr, pmd);
@@ -2527,8 +2539,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 			categories |= PAGE_IS_SOFT_DIRTY;
 	} else {
 		categories |= PAGE_IS_SWAPPED;
-		if (!pmd_swp_uffd(pmd))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pmd_swp_uffd(pmd)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 		if (pmd_swp_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;
 
@@ -2561,7 +2577,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HUGETLB_PAGE
-static unsigned long pagemap_hugetlb_category(pte_t pte)
+static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
+					      pte_t pte)
 {
 	unsigned long categories = PAGE_IS_HUGE;
 
@@ -2576,8 +2593,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
 	if (pte_present(pte)) {
 		categories |= PAGE_IS_PRESENT;
 
-		if (!huge_pte_uffd(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!huge_pte_uffd(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 		if (!PageAnon(pte_page(pte)))
 			categories |= PAGE_IS_FILE;
 		if (is_zero_pfn(pte_pfn(pte)))
@@ -2587,8 +2608,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
 	} else {
 		categories |= PAGE_IS_SWAPPED;
 
-		if (!pte_swp_uffd_any(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pte_swp_uffd_any(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 		if (pte_swp_soft_dirty(pte))
 			categories |= PAGE_IS_SOFT_DIRTY;
 	}
@@ -2864,7 +2889,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2939,7 +2965,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2951,7 +2978,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, ptep);
 
 	pte = huge_ptep_get(walk->mm, start, ptep);
-	categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+	categories = p->cur_vma_category | pagemap_hugetlb_category(vma, pte);
 
 	if (!pagemap_scan_is_interesting_page(categories, p))
 		goto out_unlock;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 13f71202845e..c4aeaa0c31c7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -455,6 +455,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
 #define PAGE_IS_GUARD		(1 << 8)
+#define PAGE_IS_ACCESSED	(1 << 9)
 
 /*
  * struct page_region - Page region with flags
diff --git a/tools/include/uapi/linux/fs.h b/tools/include/uapi/linux/fs.h
index 24ddf7bc4f25..f0a26309b6d5 100644
--- a/tools/include/uapi/linux/fs.h
+++ b/tools/include/uapi/linux/fs.h
@@ -364,6 +364,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
 #define PAGE_IS_GUARD		(1 << 8)
+#define PAGE_IS_ACCESSED	(1 << 9)
 
 /*
  * struct page_region - Page region with flags
-- 
2.54.0


