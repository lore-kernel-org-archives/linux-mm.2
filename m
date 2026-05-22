Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193CFCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E92D6B00A4; Fri, 22 May 2026 09:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773F56B00A5; Fri, 22 May 2026 09:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F1A6B00A6; Fri, 22 May 2026 09:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46F816B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 103A71C1DD8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:41 +0000 (UTC)
X-FDA: 84795163362.03.E268086
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CE1B1C000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=YllVU1Yy;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="M D6Z8ll";
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDOUEEcfbQnv7HVvJdgg2bx0uztFiJM/ohC1fFTGVAg=;
	b=XXqVD90fswOD2Nlff031NoqH/pG+ZN4OFoQDl7amHzOGwthjH9sQswXOMHU4S4kREwsPXP
	aerGax24lBkvVuQPF05nlvBfem7gUEJmA6/oyTuU3ukPytFNM5CCDQf6UWUFiVtZOm8qsc
	LNXL8hwSRsMDk6AkQGzr+D4W1hJ7ACs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=YllVU1Yy;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="M D6Z8ll";
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457179; a=rsa-sha256;
	cv=none;
	b=ywWtTWAo4HUmQAS06OYAsQFIzf1C8ALkX64Uj5NoqouxYq7OxJp9n1AB3sUryxrZ4W3B60
	8uWGNqjNz5S26IgJX1YjYPrLsBslylVd//XWQCOWYn9XjwUhh67ONUrRT4nF7japSacy8A
	svoB11dH7G0+x4kP5lwpl5rhAFJLFZw=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D31CC7A00D7;
	Fri, 22 May 2026 09:39:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 22 May 2026 09:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779457177; x=1779543577; bh=YDOUEEcfbQnv7HVvJdgg2bx0uztFiJM/
	ohC1fFTGVAg=; b=YllVU1YyoPfST6pMfNTptKkrnTzw92HF1VFZ54d4qXrOwM3n
	LceUsJnP8MmwrmQgo0p9I4210vgdlAGNOTc4lnIp7bF86Ao6qyDNpm6sDntOTxTK
	751+F22BKQcDGVoyAyyLLWsOu2Jv+VkzgnccADTBnzUjtP7CRKAFCcCCrDlJ0Hoc
	uIlFUjeZPlz8xhU1DMBRRZf/3STuGdA/EOjKTLTLcweSVAZk4mA4dBHAr0Tnsgvs
	vMZhoefI4kdvAy3kDM2RgrSCDsiBe+GOYy5pxfQuJxe6Bh5YeEoyF1vx5qIZJljp
	+nX3Inl0P7M+F0zi7kxgSAGs/lneSQGNTm2hXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779457177; x=
	1779543577; bh=YDOUEEcfbQnv7HVvJdgg2bx0uztFiJM/ohC1fFTGVAg=; b=M
	D6Z8llgQjMvKsAlB7OsNxZETijuTeJ1C8U/u7Iz6qePNed07y33Www2KPzMVh7ti
	xzeHWsRMQKKNtFaF8xMcYC+lmTNvqhIvWFiQRNFHM9AuQijSb8WR77a1uh3zfxIE
	ufpeOMYf7SHZES+DUC+11f8sYQAwT8U+NVr24F2eqvi7HOnz5TmntIm3ZAc4+WBN
	euORIZv58TfO0S7YJM2SeSBmhBE3mMcxN5wAcLgGfgpoDoMV2RVhzq20gvCWWoiO
	GRnJPvtyru/dmEOGDX8hu4Y9u5yKK/0U1uITHGdBbDu3SuEY/FOT977ARrAhEbyW
	AkaIO33DoCPeYzcW1Nssg==
X-ME-Sender: <xms:mVwQalR3xVDA3vPCeSnJw3hkyFsgeIbN-EqJn5oKYjZEp0qV3vLgYQ>
    <xme:mVwQaucbQd2tcKwCkhzyEE7GhMPtIEBBoZUYxjPzddkMsnxYBFGlQL6reTCRe7L9Q
    Jp1sUB5lIkrAkyi5ux7m1UAkfhXpLFLzMbp5x978Az2xJmJwA9K5Q>
X-ME-Received: <xmr:mVwQalqxmBELMyV5lauAIYToLKJgXbc6RFR85OOIlEy5hS3DW7P59Tod4xlwAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepteefveejgeffleefff
    egiedtieegiedugeekudehtedvjeetvdegieeikefffeevnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehljhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghho
    ohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:mVwQavcao1ZDIilKD-HQ5jLKO6YNcyxBjrwvCyiKr_3v-4v0x45XLQ>
    <xmx:mVwQatn9pOVxJ72QGQNOeWtciOOY8NiIKfXFS8K9nreh_aizJAxLXA>
    <xmx:mVwQaqtjIWCWyMh386Gfoqa1cikM6YJ-S9G-q3AA8tbwZHiEJozicA>
    <xmx:mVwQaoxDxQqVK2zQOZpl7HCBZ3ynq6eINQ0WnvrOCvGe-F2L7bOVKA>
    <xmx:mVwQan3rivc4K-bgP_GYhWz1P89G6hTEVHPF8gVHqhdsbkyBWcDMl5if>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:36 -0400 (EDT)
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
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 10/16] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Fri, 22 May 2026 14:38:51 +0100
Message-ID: <20260522133857.552279-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CE1B1C000B
X-Rspam-User: 
X-Stat-Signature: 7x513g6hf6rw4fd4ei8pkbn1yp3bbwst
X-HE-Tag: 1779457178-952502
X-HE-Meta: U2FsdGVkX1/iXm+DMBatCRg5b5tk5pTXi5Lnk8Vg7eWVBc5fDcWVHmeZkvFgXe0MmYftj0s0DBmhsiBbXR0lKAnRbeTEgqZUKLxCT/R8PHB26TslvjcgZyv6ZudnYtdPKWRUkGStpBjLIVmxVxn+25UZyporYQ+wtpla1f8Uh3GM1I7/iuJrEYbNYcBZNlFVcdRZ53xOj0uYBZkjSybvVGGOY8Se7g8VvnLXsIoX6c8GSc4A5yvYkJuXYahMcKqElGBe8egCY2HQlblRIuWTux0bJ7aznd6vWRb+3cOSXjDVrAo0NXmKhL2v3iR5dnOGWbnhqrTdFGKkHOsU9mqMXorhjN6PLKTII2OjeqZ+4e66B/dqNqZDRGHyqVwoipoTicBRuFl9ohmYmcFJtrMQWUvF/GF3JSBxo2D4tovu9Eh3R39hPeoDfvD4QNuK8HtNkyjuX7V54V4gax/jJeHj09nyGPolX1gHfiHJ8cPGWUjEyqSD6Unz4wtL+l1gfvAZHawujx937/Z7a4SEOZ8kVLDF4a+BquGtKlS1N0aONkAcPFETn5y2Eb5QMb3ARi544zeKy+/5/+F/4pviq2hDJY0cSX7zz1+bw8NMxkvUxljFPKNfyyjJrIKI7DWdg1kJBvgEZ2eP0/4xWwv+wGmvTPV0lYR/J3HJogVk0yEIOJOwgb1xLHLQp/B7Bem5WA3IMz/UA63xymJMm5y5vFgRNZCL3TFQlcsqS7E3a5Nw5nLHY+1f/8CUrarFS3GPlr+RqhH15uSw4nXIuPxt/0p9NAWbMZU5lTIEbez+x4edNvkqkhin13WzCV4MImL2woiz/NXqri7TfGSDT73QzqZpN2jwNDEc5zQr3eXMJH3z4YQGqqXD5rn4+JxOEPR1Bz8kd/e/hoDypF32zNclFHKm2tjbDKFQOYJi+11nMcRfc//fO+TWLsMp24tW5xVRvkmq4NHfdS8T1TMw2r8yPdW
 9FsdSgxX
 EfVsQVJs+zxZzUA3ohCM22ICjtgNczrehMQ8hV04FFbtTAjMXch03M2inMDjdLUKSy1g1xtYeoVNLNCj2PSdFNfK44CtW3b5mSzOeBWrsj4S0XvYpFDHo6wQ1gGqQGCUs7jmhNACG+PUsAm5foIcxgNjDyIXsIfXr/IYqWl727pUmmwOL0cXVBa1RPgLDPxAEix/lABri3ImmobwgPCOpbN9Qz1nXVWdWstS3BeiZFdyy27VopVpOaq2pj02vol5AdrmmkGLCG+PSmQT/5n1r9PAEFR+UX+SnTSGQSOzGJK6WO8ISl+2HL+BzVtH0j72RJT7DYwTzvFoI/5zL6LtrbaqRacN1dHdF+9CqA6X4p5Qyq/3LUWolLCQsYV+pbv351vgdoEsBLs7AIdxLSBPB5MPfzoPCwWBt7NI+UUno9clGYvWNwKvQXYv/df2UNaqlxrn2SgMiMplqGSKLY+JTvSMXFALeh1ZvALGyNlov/k5xi7noanbSQAygqzKuzVbjPXAEevvYDAsdVYR26fTxtdvxlw==
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


