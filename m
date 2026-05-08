Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32362CD37A7
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE866B019B; Fri,  8 May 2026 11:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3807C6B019D; Fri,  8 May 2026 11:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E8F6B019E; Fri,  8 May 2026 11:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC896B019B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C97561C03A7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:31 +0000 (UTC)
X-FDA: 84744704982.19.D94F55D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7319940009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozyHcAc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255789; a=rsa-sha256;
	cv=none;
	b=VtzkrzaaW8xJPdE6K9VE1yoL0mEuz7QufuofaMT8SwtpE1hBvDO4NKo5KT0E5yshYN8laK
	lU80kNpbnq55IKkVfpeNvyIwJV2QSNynrFz6oelpAEVay3mlN7CkpxZzu2FCvrKqNYYWY/
	MEbMWVBZ/xWMwFysAEnuKSY49+DDf/g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozyHcAc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpkN/FCSsqUpgjbnvXRNbgPvOPX+CSKl/6GKEgt5NI8=;
	b=yTkd992+KNMpk0QTA5lXxtrQcHdz6RhQvWG6RWWualSbWEPUR8wpqMfEOMYfcKlkpbRM+R
	fRbcNQzNLOED68tv0e+8D7eflyF3uplrPze6XztvQ8lYCiJNZBMFm3cOZuC0E3wONStAk2
	yt986pGR2HTygOzDUJX2WxSdi8KdEok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A3AD4452E;
	Fri,  8 May 2026 15:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B2CC2BCB0;
	Fri,  8 May 2026 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255788;
	bh=hVwll2Piy37ovMkLrFz6eFWTIpTaZnxlKrNcN3jx2Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozyHcAc0g1i/h271qoCz/emMQGQf2J/MiF9c6AHxS31aXFMmb8sTVq2R91Qk6iAHj
	 RUh3FlpNgteUoK+R2MB/OMe0kaugXgt25I5NJRrsA/IkM4KiEQaE5CmiKJKS5fx2tH
	 ZxeZrYL9uOgkVhdfRGpoV3KqGrn3alwv6QqmaT0Tu6PPZgtg1zTbsy+cKbT63Cxaw/
	 TCwGaunRMssoTp2SXDc2b6hA1aN9sVrkWFHEDP169dxzmB30YwV5HnoYzx6JpKW0gt
	 CpXv3dZnxPdRoINN9ACz3Z9ZCY6PxV6nhCSUDlC0vlsLfC71czhZf37ehsxLozLXKj
	 rCt1cjLlRGImw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4406BF4006B;
	Fri,  8 May 2026 11:56:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 08 May 2026 11:56:27 -0400
X-ME-Sender: <xms:qwf-aU3Pdn6A5ImeMpG7NM8CH7-emMkUCKqGxj31E6DYz9MM-k0jow>
    <xme:qwf-aTC5-0XQfkt875hSn3CTHXPd_NpTKsUbedxjiWAcUBYGxa7w0fav0yZkmRAVk
    7enevK1u1yKP5TK4zxiiN-m5unyOq5uFA27VvYHA61tIE7XNkuShQ>
X-ME-Received: <xmr:qwf-aVY5jJUm5mStwMka1bGeOj18xVjOo-h0ZlGlXR9a86mlLmo8H0-7ajnx7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddf
    uceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhvdefvdevje
    evhefhhfevudefudejfeduvdekheeludfhiefhhedujeffffeigfenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmth
    hprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdek
    qdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprh
    gtphhtthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihgu
    ihgrrdgtohhm
X-ME-Proxy: <xmx:qwf-aXa-W4ksAxYS4LApXSHK3BGmJw6dT8Y7gyBJEjvwicaA44OOeg>
    <xmx:qwf-aeluvqCrwtOqwDWiE5kGYR4zb10DQZ0vvqG3pMhdQBkm1Acw4Q>
    <xmx:qwf-aRShz9Qek6I7Jp03E10gtl_Ov9Su_Cxn46uLAf8dyHsL83QCBg>
    <xmx:qwf-abWzgE2E0QEkkBk-CgTHYIbiH_XGqUMaXXSz4q8_Cc-CUqP5zQ>
    <xmx:qwf-aftQv5rqkbWB1hZst85Pu623YhYCzF2u10Bg2Pu3CH11Q4cpEnir>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:26 -0400 (EDT)
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
Subject: [PATCH v2 10/14] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Fri,  8 May 2026 16:55:22 +0100
Message-ID: <c076bf8d482e80512b0b1db0e107ef0c822c5ddf.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ijx8ejxztdnaqbcddbdpr48118zji1o
X-Rspam-User: 
X-Rspamd-Queue-Id: 7319940009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778255789-784289
X-HE-Meta: U2FsdGVkX1/XtkNJTxslP90Jc6XddaSShu8IEr4vv5X3lFn9YT4fRvANt61oAJO8GRjsPqKFvvsGW9Ss7S3nt3kC8EhtoS2Q8zIUpS6w2BGgXS8mmSil/h1S2cXhJWhPKxUzM+296SwPWKqxM06b+TrIVmSOyGD8hX+BbECkeD4AFwz1oir94viREJKqDnjlkc8lgtOofT3NIzb3zMACAEjY6OJlYAooQk9tYwELgCZXtmyso9T2qWWSOO0uVWKEuR/veh+3JxVZXRN9Ep3OI7nq3Xw3FWvnE9eeQon1cWXcKV49TMEkPsdS9V+vSdqw0wybULnGM5KDJRiMbVhfdRDBYRMb2yPepbmXkotm87KKkgrPjCJOZkRbKRHWr9EF5vfYDtPsvinnmu1NKgyFYfF0rafZyPc7iUBtHUMLAopdvVohPBqQviYYJiQVNj75qlx8BzX7Lrmrktq03zR5c8jk7Pnss3AyD1c41nuFHih3i/nV1IhnLjsFb5I2n413q+JhH378M5jO5yARRAyHG+N0ZVeto8g3cboDfCj1KQavOlkn3ulME3a6J22A9hLCAcJY2R9Lnro77fNTk355/+LTCGzVunnwnjSNsTGJMcvpPUcZbfn2QyjJwqr1bCkoZA6N3DSPqNy8miq/zUOExoqUrTl1wiDOTZOlsAhvQ8hT5gERi0SyVjqRch6zt5iU/likK3mOlHVH8Tl5WPabMwkP74AXIt58Rg2cMESxHgwSBWKZ3zWlsJeFYtGdR6Zd+RxVE3h6DW6xVcDFCwdnXkzpgG6bmxdhkdZd8nfa3V6jlFQ0h/M/twhi3lAlXr9fYJ1QZBIDB6E2Fl16BLW8tTPVJ37y89R2HfKCOLz7/D+0PQ2OVizz+rMsAp5UkCI9yL4YeWcv8kb9ew3wf7egC46+kViucpsmMNz6SiZUpnkKpdIQInefz2qqAkBkQOztucB4n4E8tI6skt+RPAv
 f8kFzDe2
 RDZNjUPVDSSDiBEXf8L26TjN/XnJ9KPvBfb8I/XoyM/XX6VUcx/WGqkTc2Gi7/HhIAyHT+GwzMeXotwX/en1JaaTNIvIKe6L+vUJyH6vaJxg07xYkltr3NFekMwbe5Xkqo11hSYPi2lacKBsE2czZslcVD/foZnDncLB6AOFCA1CsmBGK/6x9BJUsRnXQEmI09y5yB7a4k+2A+H4aMMh7PoMFMywM5dC/8hVARYQX/8JdFku9HfDXKRsNpLXUR0uqzDbhJajESZKvcJtAoI8lse+AhrY2nRsp3aJVpBftKBGn3S+NCx8CtJcKqrLFC3+AOvdRNp/kLmH0HQbbVHO5veUD3DnwhCE1PKBZ
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
index fbaede228201..4e207b6216b1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2197,7 +2197,7 @@ static const struct mm_walk_ops pagemap_ops = {
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bit  57    pte is uffd-wp write-protected
+ * Bit  57    pte is tracked by userfaultfd (uffd-wp or RWP)
  * Bit  58    pte is a guard region
  * Bits 59-60 zero
  * Bit  61    page is file-page or shared-anon
@@ -2332,7 +2332,7 @@ static int pagemap_release(struct inode *inode, struct file *file)
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
 				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
-				 PAGE_IS_GUARD)
+				 PAGE_IS_GUARD | PAGE_IS_ACCESSED)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -2357,8 +2357,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
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
@@ -2375,8 +2379,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
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
@@ -2425,8 +2433,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
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
@@ -2440,8 +2452,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
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
 
@@ -2474,7 +2490,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HUGETLB_PAGE
-static unsigned long pagemap_hugetlb_category(pte_t pte)
+static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
+					      pte_t pte)
 {
 	unsigned long categories = PAGE_IS_HUGE;
 
@@ -2489,8 +2506,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
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
@@ -2500,8 +2521,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
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
@@ -2586,6 +2611,16 @@ static int pagemap_scan_test_walk(unsigned long start, unsigned long end,
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
@@ -2773,7 +2808,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2848,7 +2884,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2860,7 +2897,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
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
2.51.2


