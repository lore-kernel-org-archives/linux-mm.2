Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCB9C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E8D6B00A0; Mon, 29 Jun 2026 08:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38536B00A1; Mon, 29 Jun 2026 08:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2376B00A2; Mon, 29 Jun 2026 08:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A86BB6B00A0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D5D0167BFD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:15 +0000 (UTC)
X-FDA: 84932827350.12.95FAE8F
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf29.hostedemail.com (Postfix) with ESMTP id 24975120005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=FsGdeRPv;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Y NbrsXu";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734893;
	b=vaYrS7vruGIHX/w85mi3EkgXw5MyxWc16SIZulfwA+sJGeNT02z+Y5FkdVRd5aw9P1nhxL
	8zIfP1rVwC0O3j3DcfV2ECQu4Tq/txm/d7YxPWKM7P0nuPDtvizYxDIPRb1MAgwojkI1x6
	oaUcTdVUf9W6l3psNjx6+fCUO++1U6I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES4mJVldhVi5k=;
	b=gBlJAO93ZcUx1h+/Mdm89t097ALsDxML2elAZ/q/v3j9zPOlSa0YHjjC2uye710HfOwRA+
	vptYeY1ELF/JG4JlqSAlwMX++eBBIfbkjbL+Uj978YseWYJpf/rQz7sRitkW7xosH5GlWB
	/mtF7SeWR6ELTjwOXzv3mjq6GzNewuQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=FsGdeRPv;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Y NbrsXu";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ADBA714000FF;
	Mon, 29 Jun 2026 08:08:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 29 Jun 2026 08:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782734892; x=1782821292; bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES
	4mJVldhVi5k=; b=FsGdeRPvLKkDhOdpR/5eeBwv94Xxfn4WjM9WkM9qSibcW+D4
	ndfWjx4m1CDzXBCKI7W62sIiJoVlK/3anB8K6CZR9grXQeFUAN1vEOlh9y/tTini
	bjqnYSwoeSTsu9Z7VVolFxDYcfYGKu6Ew7s8+bdI73wdAXH4jyMR7ZNUZRqB7mRo
	eB5jv1R+jAbKThrLqjvO2eKHd5P5p8L7E96fwa/H1kjHIrorKwgJ0wXg6icDTyTB
	6hbziyFmsdlajrBtuwQClU734SS6/CJJfNmX0+StBxXt6hNBicC2Bm5i4DN7KnyE
	VNvkvXpHQiSBWP1RN60t17pQZ9K9dQB39RpzYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782734892; x=
	1782821292; bh=/owKw67slbmz+kM6pq+eZ3iOuhO9tzES4mJVldhVi5k=; b=Y
	NbrsXu/KF68UEwaBhYEdtVBQMm5N1ceECOiAwjV8xJgCGBsR4Jln7lKPQjFegrKD
	b8nJ/OIdtBxJ2HSRog038SYc6Oy4mzdeJlRsf2r0PlTA+luQH2OIGDw76pToi3o5
	Ny4LQz91DbXGkjpsBosVjmu074n/HZYxV4vpAnA6FUYDHEZYC6F532wJwo5LWvm1
	ZTShX950TSJ0wbA8Al7PLK7Kcotfcmo4LfpyZTcCWlCAlbN4bIsutnwVbEW8E4QC
	YUIh+WExaQ9peRyuzB6GuQMjG1d9erl7XO89CqPRs6KvD473ULJYJN5UV2DyWNYB
	q4xBBHvAeg6HYWqLErVTw==
X-ME-Sender: <xms:LGBCalM9tf3LEmyfpHg9ruQFQPO6gkSXdTYBVIPQZGyr_PEO7wj8ug>
    <xme:LGBCar718Ss1X906I44oPgN2aY_Ez9oxvta1UZjgZuVG-h5zxZl2Olhei5XCLrA6l
    8oFCzdkOY7V15w4cJfUspSuEMimGwxowjX-XJxroF8Xh8SHRMe5pGSs>
X-ME-Received: <xmr:LGBCasyVs7B0FvuByTita9dWzRkSwVo1C35nINMb-hJXxXfvviMgnXUPTwXjUg>
X-ME-Proxy-Cause: dmFkZTEbeJVw6LHQweWhVxV6YsjHAMw/x6M6i2UioCpAmsrJGMnjm7JCfk5Nb4aoCqvKnN
    91tRPzQkxIdfhn03N0ZpwuVqidXzNPJfeGWLvbpIh0Vb/OxkWky2JSYOHrAYJQLLSAB7AL
    toy2cpnq5TVKX0zNbh0LHZsT2sTwF0477WE69g5lswYPot14j81Ea+hOFPxysMYC/MWVnR
    3Dzoy9inuC75prIkon2ncihK+vG72WjpEkuux2GDIB97l3OQISzMRmmuo/8ZARgSjSwpQ+
    UM6vUvaQCbvfx0vplMOYjWf6ufp0BqVYgaIkGB0rpNNA+DKzK1TUU+7BMGyDUwBoGP6vCT
    cbV+7WVs8q4rswKKSiZSLVJwEyAGmV421Qb5ibvjeYAE7LQ+cQYSsfzh9vuQFsuTsKEHpL
    w2btoJ8a3eAIeTiw3p74ljqaNuH3e3dVF5/CwdZcJjlr5D6klXj8GHZBc1HiDL2LnzGvkW
    vvgrb8DNVoTTGBZ7/y+wwiPz1Cq01n4ZaXY/Ax72PujN7f4a4GZZN4y6GQOiIrECuDadzE
    cv5e91E5+GKVpakHf+4oh/pFXoQf70fBwAFeCX3QcqICJxGj3h4e8wkCw8F3VgsXQ4Kwf9
    lOxVkn//XJVV55RSdY1lpVMNvnTblmqvPCMd+X0kVmrXz6ek1fNqNQ3pIGmQ
X-ME-Proxy: <xmx:LGBCarQg-AbTkHsTsOjW20FUrVxtrXNZKSf5Q-mr09E2VvRVli1jiQ>
    <xmx:LGBCak_3v_EgpZ2aihr40NOraDxVsSWAOKVH1NA0fExANno43Ph4hw>
    <xmx:LGBCaoJYCuUS567kX7DTagvPs6h8rd4zGrLcEaTg8a0C2QG8zlVR_g>
    <xmx:LGBCaouhtXTreW9JaHnUJ1ScUU-nsR2ltExDqwDlVjEpxf5u7mW4KA>
    <xmx:LGBCaiKfZe_b7D7Jy9LIPs_apJilDIG-IxIVwWsxEEDxzo_tr_3-lnJ1>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:11 -0400 (EDT)
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
Subject: [PATCH v7 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Mon, 29 Jun 2026 13:07:42 +0100
Message-ID: <20260629120749.566063-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24975120005
X-Rspam-User: 
X-Stat-Signature: uo6arj3y41wjf8mcu8mn161py9z7qmok
X-HE-Tag: 1782734892-20951
X-HE-Meta: U2FsdGVkX19mcNnaY3TbEyOh4LZ0qVb+s4T8/fDWOfL4RLfkjSuVe2faUht04TqONws6WiA6AIx8rhjZvdbJNFImk/pXIlZzgvp327D/HUJ1d75mOmuGddY3eYy9OK9upn1B68qlhBZm0h84+wCSpWkTP7QE8AQUsxMW35wYKAnaS5veOWbfk1IUrhBKNIdXzuDUp5Xvc4ObhKkWaL+Dd3BdThW3FUBX8FoR5AIvV763HF1z0jQzZbmDc+XPg86xAQb95wdSlJLV9jBqrodP2QgOSz0ZbfC0XmdNg08mze6ooi8dgdA/3WE7WPU8nEsedjuVZQ3t0SSayKUZrukpaK1mnayjaZc3Ld4AQbmkdHBq6TMyDiXnnEz90YSJaxQOuTczXesVLTo6dfvtewmgvITYXrQ49PP/NpwJLWDG09j+2e4H+fPFCUW7oxvh2kEtWZDVBBp0XfbtNcF1Pm/+6XkAIxfWHwBufl/b+8sx8D4eTEBMAKXemGh+ZQIQYIaVw3gUawslYXWHTxl44Prl6IdRJZJK2160HM4PUmezBg1I+Chp6ryT6wCYOVui87ENmwh1fIAgNR8JSEM0a7uM3xfqZSjNUY5yYqyL/Cy9S0rc3OyPGk9q745cimA5NtuiUHWu7uaVOoyGXe4e24Cnv9N/Odwr3MNTKQeeKTokUOoxAsc9Mf2WFiYdETtYGNa1OBVSWZAQzkjm3ZGTjj17/ILk2c+78efqOXpLqRYenq9BAXhIBsbnPhCPLqNKjR6FBSt4SeNsxRJ8nAdI7hxe7wIRnmT0gw2RjN3XFmc/dlC6QjgLSbdJBJ0k51hUe/O96XbceLLDuJ7KPcTU/aIADQavbMB6+CfUnAt1OChzuXYYh8pU06UXrW7Ctj0pqnSNCGSj5e+fjl5sivowHPRV+n153XUACzJ2mrVYRR0qF1eE08aqdUrmhI8cK4Kqr1UOH2dPkD1Mcb8b111wdLJ
 hFmCldok
 K/YIgkCf57kgnPf6yyD1NlZZFHp6AAbIIhEgpCiig7hRtpy4O37QVAS9WZjGdnlDCUbSqp5tWsFXTWxh4dXK8ZNyQpka06XN5RQ/c2dAKyG59BXR3jsllp23mg5bfDgU5Px0x0PiZO8Mm7ZSy5jvbHqkG/0UhPh8yf75vjR1dObRJsTyNGOnQHLSYifUrHIVooh5merFuLdBrGYbrN6xL58ih2L1DFbpzZNdp57/k9WoMF+bccEWSvQeAQmRTDsVVXJE4D863eq4Z0dMKpVunMm5vFaxY40xRX98Jp8RhQfwObQ2yRFP5e/QPGve08ALsmvNVaxP3OiZGDjOTIylsZ8cg7TsxW/AdLoyuHQWXhsGHU6L/BBL1qgqZH1mANN0PrXsTjGzuMGA3r2lNsGnv1MBX8bXbb3Yfj2WHmiwt9a7ktEgUS8i33axYcunuzN8vF0qwlpAxAlXMViXrr2skFN0MY4076j9d0e4eMsijWaQw24sEYP5H5kG5jV/pZwSFf+rAS794aSfeDYEgn1aX8TeytA==
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


