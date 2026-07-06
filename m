Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88508C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C5B6B0115; Mon,  6 Jul 2026 04:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03E76B0117; Mon,  6 Jul 2026 04:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F2E6B0118; Mon,  6 Jul 2026 04:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E01F6B0115
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E10D414031D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:37 +0000 (UTC)
X-FDA: 84957725874.16.ECEAEED
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf11.hostedemail.com (Postfix) with ESMTP id D46E840007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=yEapPVJ0;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y DL0FsC";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES4mJVldhVi5k=;
	b=OrE0DBecXdzFzNYiFMnhZ2m9OUP/GrXn8eH8zSp789+lr1szMe/Qyj33BBi3b0TQbXG7Jx
	6BYvtGvCEwxUl94A+vh6FAkTRI7jI90+ZHgjryWOWeu+FPXsgB5Yj3sJ0EpEIxzQrstB4+
	u9M2SXT8lVOI/9BqH1XMfMlo8OIlyuw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=yEapPVJ0;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y DL0FsC";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327715;
	b=Cf4tI/VtmX+AlO4Lo87IShw/hz7LMs1cdHriH7qxfLclqz6ehL+25nSaH/78uMen6B0uW0
	dq+lR1TJqL40FSyHD6CKY97oO293TtdVAaGu3UJBJVfwIhYBOoPW+5CyUOeS/sB4Z/Io78
	ozqRjtqsir1qu+4lYSTWIBNSF/wBsbQ=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id ACCCA7A010C;
	Mon,  6 Jul 2026 04:48:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 04:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783327714; x=1783414114; bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES
	4mJVldhVi5k=; b=yEapPVJ0jpVEaxsdG1FZfsuxeel/cXAORbKSJm9VtM4HYWXE
	C+pQF5AR1lEyvteUVcQhspUtHmsHYVWbboFcyKTFagrL87vS8yKFT6DqrBJ0DQos
	zsaiMMEmWd9VHLsE70otEwSSW6QKhatgo0U9iXqlM4O15ga7t6g0gYfmDsoxmdz5
	gwntSkFa8Zrc1db4ZNNDzNovsYmyWRpabxO8JUkTUvHiWWn9Qb5XOgLjJ82TX0KG
	la9+0Gew/vOQz41METRkF6uugmG/LCeSA5kUlOZT/7ZN8NYN9b95PWAkGDXEyl3e
	PyxbTAe1D6p/MovjPKPTnZoVQxOwoL0BuN/W3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783327714; x=
	1783414114; bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES4mJVldhVi5k=; b=Y
	DL0FsCVuZpZv3ngZQOxuC1WLWYiLgdC92kYyIYP7gV3n56nNo8UPFBpBSKZsETJr
	AvXswTa9OlMEedA3sNNiQPYeBCYIlb7FJ1yyuqr+y5ORb5WUxXNmYenvfZhUZvrV
	JadA9Kk1U6eiAwOTXDN42GalUXLCcRZ7/vFln2I/Tg5dE4T13ItapQn00FHj5s+T
	8mC3OWncTFK2RxoSMkPOIup/MGFHmdg0vnKH3LfYvsHkmHkxIgMH77eUhwPHdCjq
	fP7sg5QkB2RSGCdLciLiPDYNgMUP/yuz039qGxnY1k0K2rzKfBXoIYGhblSqR6rU
	ihESvBfL+VmPAYXbEXzCA==
X-ME-Sender: <xms:4mtLarHeq6G-ikBD4clyo2aylJaCeUGN61jTZgauBdGWYUogLl22Ig>
    <xme:4mtLasQel9dRMJ0DdMVpyk62U82hPnOrMS9anxzLj9Bb75_n59zFflUSwbBIWSZCL
    JX0GP-8gk0wSr-9elJPnu7m0Xc6Q55mo-wuYW9PX0LbLT3-MyCRVm6z>
X-ME-Received: <xmr:4mtLalpxaS4Qt6TJ0ZH2JUr5aLXZh4qdJs1EeA0utQD-To25gGGHl-_VCNzQ_g>
X-ME-Proxy-Cause: dmFkZTEdicl3dVcL9amANwuNwQ4B/LJ3AGF1IsDGz3aHorST7YhCfwWdaoJhyFHnoWYf2z
    91HVmiSdMMHUBIp4DD88nbW8shxrcjtAZdfXT6m9vc2Tcww7aeCMA9Pb6AAq1YaCWmAxgi
    ArVIEIXgIinNiSvhXTjw+kvcHF73HamoSly6f2up0otjPkEsXMk2c6+qcLC+kg/EfYu9ll
    NC++3n7OIxXkJRlDO8fi1mHoFiMP7TF8KdSUZCebtKSLPWyVmZPfwelqwDaz0Kv1dWgagF
    Ckmrl0e7yag/Y6YlOJb9G2EtlAUAhQvoJLw6xbBcQqHVWMSCgJsGTVd3gdpaGhlRuslVrb
    dYosKGdA0fuAVGpW+6aAVmcw5BiPKvEZ7v8BqW+jpBT6rQw0NN4yWxFzvk0nCill1wu2jy
    2LPb/B0wAVfX4u9Xtn1E5O9SuxrAhMc7KICTOozvnkADq43opKNbN9XUMrDwDasQT4wbUP
    4oFEvU3ewhwXWSfI6ynUR0oMK+mO0WgFv+/qwBlmU52ZOMadZqQCS/RLDwQNH7ctJ0kiNz
    VkBnikeFBlu61Xd+Us2ZnSudbotI4aLz6XCoiitGQA4CNfZJSOaaxJLbdfCs8kCPqbAx3m
    Dyhc3FR8TVqeaGcN0J6WBVE2TN1d4gNQcrOtct3t6hBxiZxODDMhhMcE68GQ
X-ME-Proxy: <xmx:4mtLaiowkHuvo7LLeDjMIuhq90GDCk75_YikV5R-0gAuR9jdI3UaaQ>
    <xmx:4mtLao2QKskmfTv0UWBFzhFjaJdBBmIgRk5cNm7HPsjHoibvzjZM3Q>
    <xmx:4mtLauhLQ2xdNsNiL-Eb6kijDMHRX8E-T-SExqLAKPwk10Gpp9Yc3w>
    <xmx:4mtLavnnqgjOYPxxX7pT69gN7m-Sto-OPodftDBuQQ-R6VgsgR1lLQ>
    <xmx:4mtLaklOjRf6UNjNFsJVsmGe1GjWr-cFKVwuBiNU_JR-eRAl3-YdXVaw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:34 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
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
Subject: [PATCH v9 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Mon,  6 Jul 2026 09:48:00 +0100
Message-ID: <20260706084805.8400-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fn4518jdnne37i9r74171cpr9ts36o5n
X-Rspamd-Queue-Id: D46E840007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783327715-947723
X-HE-Meta: U2FsdGVkX19xkW4H7kJRFqMvieFJYIRok97GZtgyHDmkML3Piy+3Xv2JxfXnb1TkBd04pby4cF12ka8jhy1u4mEB0qPIi2WzxlpWjTtr8Tvo2vSTl/x+LQfaCNXsKy3GE6OEmK//p/tnLLt4fgG9WXWLSVanMkV7vwcCrco8dC5NRoYsfV/Uuk/90uwRdJ0eo8K7QcIfhekHpWaUGHvknIttUzweg2SPp8YQrrS28ZhJKvv+ooctSRd7z1phyugA5B0SSlZgFpnYSkmoCmfoXF6Pf8XYoqE0WUtBLATaeOBBNsnGjD62lLTkJ2Xy9EniT/rKV873AIQKDxjKaf7zGC4CXUTdrXVv2rU0/0tZJ6fsjI8NK7zXTc02VYoYgB4e2mABWZXKxI1tvpmXB1oye44Du066qUVDtvkiAKAiQ6KxGR6hwpoCpw57izB9mqYIa2VxdJMNtN+ydoQjXUCl5KmxcOi6ryH3dpLLfhZT7lRp+TkePLRxCVSf85yOV1jnY3hVyMBnVa+aqQIeF09hXxey41XX8cW1vvFrAhqMebVAUfDJ0rb85Byn2JHDlPiAcitA92P6MKFS9O0dvUjmpw6UP5eKlmaXYkk7vjhpJhWnFRPuky65JlVbDjenARiUBiSXwgUZOgq1pLuvFT7KdFo4mqVxHTV+T88HgDOjM4XTApD+uOeNO1f8sAtis6d7LIWpdxSGj+OfjCbmLCPQgIkPyFXGN3YcJ0e2n0B/0Et2cMtZ9lrQqH3DOdnmllCZ1AnN0gXN0pddKnIwoon5hwjm6e0+x/N5dWSgpNP+wqc8u9npmH/ucTDRfdhLRdHLLZm3JeVm09QZ/7Kmcsk1LHuB4CI0BeZFIqGYylY0XuD0eI9N8ykq2w3tlZMlTrp6uq17HdUp/5GvCUyoHEWaqP2q6Yy9m2FsQZsttZk99pzbB701QEnQTnlH8bgrLqqF4MoVg+TN7NnM1pUs6w3
 ln2h+j3/
 QlEnjj2cU9t8Zt2r/LpQO3L7dKGvyaayIBtH+MYQ7e0FIUGVCHURQ8TmesSsMoJxjGAvHbRiYZox3F59IldcaPwr/L+CiTiHHCHlrV83HGugeTgWMynlVQspovg7hPbSCuE0N6X1JkYlmjLM4qEOSo04G3DLak5tlQQrNo3WEFhdA9tategegCtdJh1+o/YS6NBlpSye+IfHAQSeROGqO1zf5LeqJFMeoiBFLR8RbWrBlsmo3GwsacMge6qfTHaQq5TH8Dr0JXUAWSkRb0a3SPnffLc130VDCozzM8tXaAN3/M9gLM9VLI4eZPQU43/TWmKqM7kk1HJL8tN+RZe5HYu3t/uAJG4I1WTYD7Z87KYkmbugEDpUBTjSBMT3mHZ7nrs9xjcBsiKTTrb1TQdy1XkixIWjmXlhq4jXOzlSOJ0whYqyFwHc8ao381PeCsshck4Xc2jgEoJ+Pubr20P1kwf2b1QZAI4XaP72U4XBjkfbVR/UN7k4l/B6UZ1bo7f7pXuOcXqI7zEy73pk69XXwo42qyulzyV9zhzic3Mhh+Czux38cNQgnSVJpPjnUC2M8op6OTBNvDod9VZfGXweWDgc4jE+W9PH57ckR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
index 5b55c59573a3..2d724156763d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2283,7 +2283,7 @@ static const struct mm_walk_ops pagemap_ops = {
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bit  57    pte is uffd-wp write-protected
+ * Bit  57    pte is tracked by userfaultfd (uffd-wp or RWP)
  * Bit  58    pte is a guard region
  * Bits 59-60 zero
  * Bit  61    page is file-page or shared-anon
@@ -2418,7 +2418,7 @@ static int pagemap_release(struct inode *inode, struct file *file)
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
 				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
-				 PAGE_IS_GUARD)
+				 PAGE_IS_GUARD | PAGE_IS_ACCESSED)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -2443,8 +2443,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
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
@@ -2461,8 +2465,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
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
@@ -2511,8 +2519,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
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
@@ -2526,8 +2538,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
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
 
@@ -2560,7 +2576,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HUGETLB_PAGE
-static unsigned long pagemap_hugetlb_category(pte_t pte)
+static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
+					      pte_t pte)
 {
 	unsigned long categories = PAGE_IS_HUGE;
 
@@ -2575,8 +2592,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
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
@@ -2586,8 +2607,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
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
@@ -2863,7 +2888,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2938,7 +2964,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2950,7 +2977,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, ptep);
 
 	pte = huge_ptep_get(walk->mm, start, ptep);
-	categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+	categories = p->cur_vma_category | pagemap_hugetlb_category(vma, pte);
 
 	if (!pagemap_scan_is_interesting_page(categories, p))
 		goto out_unlock;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index bd87262f2e34..34c6f219462a 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -471,6 +471,7 @@ typedef int __bitwise __kernel_rwf_t;
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


