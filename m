Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D25CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077F26B00A4; Mon, 25 May 2026 07:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FE76B00A6; Mon, 25 May 2026 07:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7906B00A7; Mon, 25 May 2026 07:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAB696B00A4
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A82CC140226
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:15 +0000 (UTC)
X-FDA: 84805746270.23.304E134
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 910AE1C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXR6CT40;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AP1OQJh4VME3VhcFR5nWryP6+e9wX0Pv2VjfuiXGvp4=;
	b=oV/uE+5eK8TbcEyo19sPOCYp3d80K2CIeE5SoaWk4zAd+GQPIP7LbAQsnxZnUr3CbgFQuU
	KU8E8/VSiAkl+DmCX3UhRyNFda05yKeTxc1KZb/5B0yo/s68E5tbE6tr4dmk48zg8cBM19
	GbjGylDOvJT50tO1ijmcUDCfNzbwoNE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709153; a=rsa-sha256;
	cv=none;
	b=koeun8N5OZKjz2ZLZZcpiXpWY9t/EQ6+SBfs+YoFhelQhOkL4NfJGREwGsu8HAWDdz1hwM
	uSvGmeB1Rm67PTClwJjl8VqTr4/yBLpGbTIEVxCh2WNY4McLofAOyUnUgNMDLgaVfqxZ3A
	Xyl4/ppL5FkTeY3GDtYjaHTp+0ArSEM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXR6CT40;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2FBE434C7;
	Mon, 25 May 2026 11:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485311F00A3F;
	Mon, 25 May 2026 11:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709152;
	bh=AP1OQJh4VME3VhcFR5nWryP6+e9wX0Pv2VjfuiXGvp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXR6CT40VpIsFY053F/vGR4yboIPkIpHGuzoswrWEDOQb+vJSTxA08ktcLlaZAst4
	 SF0PryApwmdmV8jBvdUbidhsERsv03vJb1s8C17BzGOqMpY+M3hR+9RG57m2oeSFLT
	 ePfT1gCWSvmNwBBSNqH7+0L0Q5KkvGNupABuKn/Dx11p2XDmC0opFQGcHnA6NiyW+s
	 a5O5iLisIvI8E1Z/YSR9MM59AtCZbSoiqM5J5OI2QOY8YA5f14aRwB2p0ys/d9l4jy
	 Cpqkrj7/oSJb9b7zgLEizlY1tVVd1+Y4LWGxEfuAv8bALe8a7w8azKGLNhoTaIw0QG
	 4wqffPLS2/j/w==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id A5613F40082;
	Mon, 25 May 2026 07:39:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 25 May 2026 07:39:11 -0400
X-ME-Sender: <xms:3zQUauycDbXX1S1OANPWMg0_O9JjULz5U3vOj3VoWygY45HrhP6nXg>
    <xme:3zQUauMfgnF45vl2VtVSQ9BCuP-7Gno2e3-M6bi5CZfkeoBTp8rtQX6GlHfP2XgXr
    uCfvh17xj1YlCK8LbjEaOKn8pfkrfmHXWG7XAr6K5rYGx70TEuAWg>
X-ME-Received: <xmr:3zQUao3FDsVRDJ5LARqZCim5EB7MLAUR76zfpFpKtfpdclXzP2jPSZ6KgFgoIQ>
X-ME-Proxy-Cause: dmFkZTEfoRdVBJYWBUADV7d9kIV+Nxm/pVUcgu2VEqiWnj8eQrxuVRmWJvpc9q3Oqv2JCI
    in3fN4Zd8kb+AIzxXT1aE8XhYzXjllPczHZpsDuave1RqUEJt2aM8NK4F+1xGB1lHbYgSB
    4+lR3LF0kMycZigQtO5w6VfLN0Aex+LApk+NDe4mN/AQtgEH82UY4yLdpanr1nUEhfYRPX
    qXaeB8tr6YycPJO/GKcHBfWh4XfvSwFXkiL84UUAHkAJqW6Bc0LpWOIYef91VRiFvO85Cg
    Xd8jmXx4jYBCkCANHtSsVLhpCbXIiIojLruOFr51QxylDrx8yfg2/g0kqIsUfNxsLFZyOU
    3RrUT5nIDeRZpNvsTWcFpr7rGsBwuIoOQCf2HRU39VtHyP2sFvtytEkvkniYVobYJyQa/W
    WOCpBX7J02APixnIAWiyEVh8PQ0YOVDsZ+/BYFLl0sGUyceYds+vcT5oRhwHSw5N04CBnJ
    Ec0J0YNaB4Uo8ddpNOenTZL3ESheTCHLPulUAvG5Rf93FAF0BRmzNjNRtu+8yjLF70Wl76
    1VzHMXRcbSnv8wQwvVqyINrDUw2lVXeGPoSAOGFSxh2wdB6nF0oYBZStdnnrmf67rpLtk9
    bWtUBzNd70dT3zbA1HDTe9N3NvcMjJp919CXc05ghVOvAf4bNYq2d3Ms/phA
X-ME-Proxy: <xmx:3zQUauHbngLut9OHSczN_h9eoAM0-HqF6yhV9rr206wzkYt9YycOxA>
    <xmx:3zQUangXZHcDj0OweyZ2R8KvLz2YBVi53k1UmUtzwVcXe2tWaDP4pw>
    <xmx:3zQUavffnHR-MKeVMOZ2J21P4nxMBDfC3qbFDu46ImQ9xUl8F17dgQ>
    <xmx:3zQUalxsqJFT7_I07Hw8ONxKdPnPp96VP7i8Pcgi-ZAF2XBmA9murg>
    <xmx:3zQUahb6gluDTFn8ZwZWUu-Rqca_rAG_pGvtYLJygI97lViA0gbErtJC>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:39:09 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v4 10/14] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Mon, 25 May 2026 12:37:24 +0100
Message-ID: <20260525113737.1942478-11-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 910AE1C0007
X-Stat-Signature: k4txoxk5paj7cnekk4erjupb55j93yqo
X-Rspamd-Server: rspam06
X-HE-Tag: 1779709153-130254
X-HE-Meta: U2FsdGVkX1+zKzFeNFemLH1QFST8+cLsiw9SuctKJXVrJjTgp7DgUVSPziurK2UcMX2GrWzJvfPChGW5qOWULrC61fn6yQ0HC9CqRlSMVBJokyGCLq0d37bIQ/EUhHUnr/a079+3xs9inxfXzLfjISI8pkV4tTVxtkTdfAvEiHef/BUW+p5HnekGkKVuglBE6JZpuCegqtYCoL3qjxsbMyZltnP06cBfRTLyG7fQsdxeeybl8IyHA4nPEaTSsJdICKfhERC6LyuOCcLzpqCfdPZ7VHO2sVzUaewabCIW5q7pEAUtq2jZp7mJlJdfSAc24giKmVVN6fPFqZGXJzE2qIByAl4s94ngP27KDSb2wkpQC9GBZdN9FShZwXuN1rlOQaVRbQbUeA3ygScXYDYOPwrv7vSNS/uU4n+sd55Y+DHS/3XZDh+mMyRHrJmo/icneKcYwY/CM1zScmJqhjJtdnWhXWl+Xif30dXSJDPgmIS1OMloaJXkafOFwBYtvwFwkwLIhzLqE1Gy3SqI5d9pNw8UaXdM0yIGdL0CL56yv65XHfttQ4wm8Fq+gVGSX7MCy3h3GL9wm7lm6LGU7BV+Aw+jab9Ukdw5/GS5T1Ujro4mUm5uvDIjBK80/QCOUPTpkxYAPf81yoB6xjPrjW1NIoa1dVuRUfLQXeQKQ5qt8U98Cwx4Ox3wgWZt0GNtoPpSNO348pSG43g69wDEaorpMhAsqz61AwVnBwZ8I6HwUnc5bwbOzrbaDhDgPKsR7713zNt5muNN68k1NMrM76LWEs4vY62LYpTJjZPPQifdFDWrwhNcTc3UxypbzBz71DjUFU34oMjpPrhUCMYsVHM1lMjd8RXCKq6NAyrveyef2fjTm1hjCl9XlVtI1DeVe983tVP5iai1397CE+YeO4cIEk5ujHJUQDcvg4k4gc/rAwHJjnREZ7zKwHZClaWzDZ+NXIZKc/lisJUDa/7PyDr
 BGo2UblW
 UYT+wzOGpjpDoNO+HbXvY4HTYxLOJzn4t8PruU9LvBku1R0SYl1opbYsbyTSC6rxT4FForfopnWiDGKGICJ4s0DH/s8z33o4TCqhAPVdZ89UFTxGOThN+R0UCJ730cNMrIX2YZUWG7B5jLx5AepuMLZSEoxd9brBmbb1zF/6kQuuDMgL51RZgqwyL1fKrjaeCj8u/u/H2ZSu/ikSDimzA2jrNWj5+RD3TtglVIp1f8gIKbUrDmFZYVJYrjJmpXUPGnb2RR64zo7sJ6VHdQAaUAq/eUieQOl1k90d+dBbUsk2nv67A5QTkbKj9YOSVrIAiA/tzZAYUFrg/9ctUGcpQ0GRknA==
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
 Documentation/admin-guide/mm/pagemap.rst | 13 ++++-
 fs/proc/task_mmu.c                       | 73 ++++++++++++++++++------
 include/uapi/linux/fs.h                  |  1 +
 tools/include/uapi/linux/fs.h            |  1 +
 4 files changed, 67 insertions(+), 21 deletions(-)

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
index 5e74dadfb1cb..97fb941871a3 100644
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
@@ -2673,6 +2698,16 @@ static int pagemap_scan_test_walk(unsigned long start, unsigned long end,
 	bool wp_allowed = userfaultfd_wp_async(vma) &&
 	    userfaultfd_wp_use_markers(vma);
 
+	/*
+	 * PM_SCAN_WP_MATCHING is the atomic read-and-reset flavour of the
+	 * scan and is implemented for the WP marker only. Reject it on
+	 * VM_UFFD_RWP VMAs explicitly so userspace gets a clear error
+	 * instead of a silently-skipped range; re-arming is done with
+	 * UFFDIO_RWPROTECT(MODE_RWP).
+	 */
+	if (userfaultfd_rwp(vma) && (p->arg.flags & PM_SCAN_WP_MATCHING))
+		return -EINVAL;
+
 	if (!wp_allowed) {
 		/* User requested explicit failure over wp-async capability */
 		if (p->arg.flags & PM_SCAN_CHECK_WPASYNC)
@@ -2860,7 +2895,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2935,7 +2971,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2947,7 +2984,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
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


