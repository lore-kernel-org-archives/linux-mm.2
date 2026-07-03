Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44208C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7876B00DA; Fri,  3 Jul 2026 09:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81246B00DC; Fri,  3 Jul 2026 09:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E896B00DD; Fri,  3 Jul 2026 09:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8248E6B00DA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BB1114013A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:48 +0000 (UTC)
X-FDA: 84947565696.18.56D88F8
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf17.hostedemail.com (Postfix) with ESMTP id 025E340004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=Lx5BD+2K;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g 47EdV0";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085806;
	b=mR66hdyPfZ643eYigZ1a25nZnjaXVe+QsysuFTK1VQtVk6g1gF/pQ4fjhim2yH9vjoG8z1
	RzAyxPXmC1YrUyvjUg5zUjsC4JF5MSHZgnG5KRsQmiAx2Q9njaTeQ2KHMeirR7e879uasz
	aVUMwl7ZaGsuJYtqB3mMGaNNhq3wAys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES4mJVldhVi5k=;
	b=0wzvM6ImEgdmkEkZStLd8M4OArI3hjGa9/GBLeTVYSAaOh36JpA1w+M3hY7BvzSAVui5Ht
	5wSDBP15EsHgvAKQLO1/CK+qOxjc9Vkvw0vGikvLlE/B3fIVbr03U0rSqhA2m/yRBxdowJ
	VD97r4COiPgvA55ei/W6Mt1jynNMjyg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=Lx5BD+2K;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g 47EdV0";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id C889B1D00063;
	Fri,  3 Jul 2026 09:36:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 03 Jul 2026 09:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783085804; x=1783172204; bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES
	4mJVldhVi5k=; b=Lx5BD+2KLup///bBEvuKeO74QaTdtKZjmJiSYQZNzDHbeY1k
	RUGKQcYGDu4j1cftAMGtwFC51Xz7XmNvLYvu/oSC2tBku1Oa6k/tYtydyOmTBdWu
	TWj51yGJ3eNBmwkSC2+u06n/3FgrZn6YeABq30z0yUQyEZhfEZ8j5pJXnwN6KNAC
	Y2nYa2/AL+H3VbpdFFWAkGCQWUWjxmKyLvqCRgGf+Mq6PF4QrKR7d+u58Mkvz+FE
	AT740PAvhHzzWIX4JJwt3hY955J4nFGuzy8pXkpeX1LcDMajUNM0lu+7PohRaFS4
	ZDjXyvGUgE9F93TopCcDwGLDN78XKU646WEFXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783085804; x=
	1783172204; bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES4mJVldhVi5k=; b=g
	47EdV005wtLMU93UvZiRU9VP8TPbwGYXr1TWvBg8t//+DrIe05NjCFddckwhzWEm
	lv8fIf/rhM5ajjkI62D0XSgQ+kryUR639ufXHWAxyoRJq5a67obMYvENTkZObT/A
	hleqMWqJXFGX0VuauQ1hnEsld8RUz8yOZy0xjN2Cre5gMPxx+4lRqgtaWMpdIVhX
	LGJ0jjR1+9hJ9q+Wkh5j08XHJburepdet5e0SQ/tGNeTQV6RiW9Dn+Iq86RpILyp
	dRkQWV5yuOzS681keh0/Qy/RoJ1KvyAMZhEWjvP0s9Q/aOwx0MtcYgqlpXCNxzT0
	PDcm/Roh714Ag54hlN3mQ==
X-ME-Sender: <xms:7LpHau9vJuAee1FL_oZnZIaqFC3lIqKBh13S0Tyhd216pWy9A0A9lg>
    <xme:7LpHaiqqbDmyvPMHtnMXuLih-9Pr8mHSSFwVeEl6OyaeiDgif-UnjmFlYfzm39A1f
    GWWUrpLb-2mgATLQ3_N0ykBB-k1e7b609wRYhmALlyKq5AEDg6-Tw>
X-ME-Received: <xmr:7LpHashvm6d9m6cxYse_08G_KJb8TKcCGXpCWB8CUn4ouhZLiIYnkxyQ3Ql7Ag>
X-ME-Proxy-Cause: dmFkZTEvpT7VPI/TDUGEnnIrVlILKwXgeXt+foeC++RMQKPZsPpb69BYeN94A6l/J4m8GR
    j7cxKNSW+PCS7l0cP9ewYlNjp3o4SRzo0q9x8boy+qMv6IPQeEYIg3N09NNUL1YwXh4Yrh
    l/VK9KxOHmvITqsfYi7VnRs0zn+zCS3v2T7VSdeEEdSIb4snV1El6VtdknOa4IcxGosKQh
    b50hZlM8u2LRvSc9TWKyrKm8vDP+A/+u7lOr+AQwZAIydhhZxADZY4tnbcibEwn1oxgg5G
    tZcbEgM6HqFuHN1XrVgTaj9QN8QlhWjwEBL1Bk9WTH3MhpwrPTlQlB4jwdEhPAmIPHL5eo
    deYaqyKiJrfCPrPcNXynfSDCl+6cZzOMEvkj14ePD0XF6GCHT54eszwKQzgOm3vkwJj3y3
    72B7QowrHQr+d5Wu+ggRP9WmMuXtLjAiPbV0WV1oKW3YMriVruC2Q3bOX+/EnILQgIXOIj
    tPKFMTTQwEnLFtTGJlgevc/3vA+1bAZQhUmy3F2HpTS5RckTqyu30x5NDOn9bcery+EEKp
    xVU9s83Pt2lTwv74kzDOBLMp7kcDNInkOjNb1mlsqVgmM4+JmMy7/9ikxGrIC4f6Yibd76
    /wj3OU8dwEb1ZaujIPEaIO81E78wsjJspFyND01x3lj+aWjEMcMuVoqFzg2g
X-ME-Proxy: <xmx:7LpHagBZ2PGFZs8BBT0x8aKTdWh8A0Cjl4dR-6VgOGZqvS_p6cisDw>
    <xmx:7LpHaqs33DPJeBunyFc2_O8SMRlpoxH3jZX47xQdHMO-mbyFAnVrOA>
    <xmx:7LpHaq5ntIlTmoYALj2VUGCBHEjWlJ8uOaFtOC-bePdg14wiS7y1zQ>
    <xmx:7LpHakefT38Jn8Ycjs-gn3jzU3jk4VmJP2f0TGhHYSi2KRnyUcPzdg>
    <xmx:7LpHapf_dKU0sjlmlBHBfgJcfIsAgeX7zzbY0z4WY1A6Clga1HnMYx7e>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:43 -0400 (EDT)
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
Subject: [PATCH v8 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Fri,  3 Jul 2026 14:36:10 +0100
Message-ID: <20260703133615.1039465-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 025E340004
X-Rspam-User: 
X-Stat-Signature: cksymomtewe7r5cact8qdmenyhrtzefo
X-HE-Tag: 1783085805-504689
X-HE-Meta: U2FsdGVkX198LnCZtHpRUzNQkJdYKNRO+Ay9gsGZ1E/+NULV7FHVTvazv6MnRn+lzeEwrBCJappbHO/D3YzuRa7D02eXB1a1MUyO4aTGEucIYCVlLPS4gkieEBLprfa9Ck9+2VfMGPrO4qW2bU+AZWTrwMRpE50B+PvFy2yFxRAjJxNnIaYVK7AEGfMziHeHDbZupmyUaXqCcg18+i0XTfdLzOIxYa62kH2BdRFp9WEfjHg8xQkC0R7NOgxfnpxITUOnXikef0gNvgQibiJy3Wek0bUjdu7e7w6XOKGqNVxmaV/I5Ys5VjtKhfBN2lfiq5u3Fyy6FwCgcTdBf2MFpzsy8oHN0QafrQmLVJYtB1PQMCNN1EBwCXBfdP2XskxsApCNFbON+3bMZHHdYPUCM4FIrqnV3F+trhEuk5fOq8DXtP09L8XEYWWkjBBwxv66MlT0IPRggX0GkW/ZhwCuIO8IVeOvwmNOF8f4+WPRsDZVBfEDW1Sd6fh3CvLgI5YTwMhbtQuh0jRSN7LfEtysQ2WDgSZBaH1NEt4SCVz7bbaCWIshx9E1z3xlIxIE1a8U3Nlyyf/FpvWeyQsOOHPrCcPQRemAE9IF3WIlJxXCZ+VMTAMKPWbD0CqETze/PeDtx645PKSyfM+A5ciEQj4QQPRlrVtfN7oL8GCSEucz+igLTHNeafJ2dmzI0CfEFC4iR5xSlUxuXKmTE2S0OXomCs0KQVeDa8L6VbX69/LfTqHoG23jTfaLgImxD05o050BqefSPsRdDWlNDvwECX0c2xqyEKdIl10YdS9N24Jp/vFyJfRUeGMKTHxWSuc5j5W2bTPhGhf2LDLLGxD6fz+pHDdUiuYs+QvRZ2VhFDvGCTIhPUBqxPk+2x0Ve5NnYMVrHKSkCO6kRf95KtofiBRmBGH2e6pOTlx8nR82fStefgmMVIfrIerbxBq6STZk5uJkmZx+k5VAhYOe4zccySi
 z6iElnUV
 ZYSxuGoXaCxPOyANAGGz8FhtzlYFsj2qzgDr2iTNSPWYzNmoGmhQmi5VS05/7wleqbZAqSLRVRGeSMN9GDDWqkr47/GTPrYHOqsAl13BPVapspxUw8jFor8ijrU3dbPdn56TZXj5alB99XlAb51u51U3tftRit0b8AMe4nM/KzI9D8GHCmyAzNLaTms84LQ4bxmthSsMD3FpbWISAXfO1ey1orVcvmfxcmQ5jPkkcwAE5Rm4h7Pn62Bz8lpfXbceV8cDAYs8kzo2E2t5WsZchncIfKgjRMZ6kEu7iLt8ryNDKxTXqMbKX51hRAaBC7xfbC6mvzjRz04Fuk50a+zQtlxDOqPOgS/L/wcdpHDCokyHCODcGYdG42xfN0uAVzfxG88hOW27hNXT2X+WUeDrvv1rHlgkUliG0RthBGYjz+lxSvY03xtWRPmAO3sKfXRBQa90nE3lVn/cXIl2N2hzUgxZSTdk9as5D2iikW7gRYiwbT2R0rTn0QW0PfZgedfkh/dlcWIDRtpp5Yc/FYNbylfxd5w==
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


