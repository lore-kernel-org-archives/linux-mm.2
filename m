Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB6EC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBA56B00A5; Wed,  8 Jul 2026 07:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994446B00A6; Wed,  8 Jul 2026 07:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A94A6B00A7; Wed,  8 Jul 2026 07:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 599276B00A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB2051406F3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:50 +0000 (UTC)
X-FDA: 84965351940.11.2CDCD6E
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf28.hostedemail.com (Postfix) with ESMTP id D806DC0009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="DkdOf/AO";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="i STqBDE";
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVvLifOjKK8L3L+gocnGIFc1qND83AKeV/7X0wghyA0=;
	b=2uFdBMC5HD5vB5QE+xhhV76DKSytV8hRHb14bEcEg8tYcu65eQL5WuRCPf48c8ZmDOchan
	ymb40Cb6GHNZQ3/kW0xYbldH3P5Nx/tcI+Sth+heiulegmf1qT8B9FUFo5JH/0d5F3TXp7
	bmgwA+UvL+Nd8I6796cTxrt33LF/63c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="DkdOf/AO";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="i STqBDE";
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509288;
	b=NayzXAGzJqX+IkdPk/n7Th3+F1IMODlc/LZPWLHAG86Ne1sXteiLmD4j45pnjBoSg+YXiy
	jWgwD2DFFuoUOo+7UP8g3VHnTVkxsX0WGIpBYCicM9kKVl07Km1vo61PvVEr7plruZ5dLU
	68fCn03z0sFI7tN/t6n6JhxwECnlARg=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id B77901D00156;
	Wed,  8 Jul 2026 07:14:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 08 Jul 2026 07:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783509287; x=1783595687; bh=WVvLifOjKK8L3L+gocnGIFc1qND83AKe
	V/7X0wghyA0=; b=DkdOf/AOrtLn7oa7Fc7gswNKOEgtoOU+yxjSrr7J9QpxTDDA
	KJYloSIXlC5pQBeXP9Fl+J+2Chn2AoXx/e8p4EiRSC6qHhwFcpQuO0s+o3pmiML9
	kGwQlTU/J+Ng87RmCVdQgySpHsV5Hf6DSl143qqWyz9gBz0l7jujQYf3jjEUgRn7
	BGV/vS04zOB8gLVVWHpXAUxgf+NIAZlvjp/PQmHJqRoXTVa4gH/x9wCiqmgQ+Qro
	b2QcDFzOIY8vU5I4y47oxRBXM3lEMaUHWIh6RvQCwjUWFDpVfEDsOCQYXjxvus1l
	gA/MmXafCO/fkJBU9nqnj+1wB+mzwKgTdND2Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783509287; x=
	1783595687; bh=WVvLifOjKK8L3L+gocnGIFc1qND83AKeV/7X0wghyA0=; b=i
	STqBDEcBNFNtmbq18a+RNATd9bjFMYZZ9mneHH0m70V9KGrkysXJzz8aYwDu0s9Y
	D1XirELOAJDLbFmSabMT6cs5HrF+2WITEqBWao4pEIwueJ3AcIokjYmEE0g5lKvv
	0uf5xTtJ3qC//fA/ACReSFy6PBft8xHFFR7eOamX4WRia+W+xd0m9o5mq1Ay0PVn
	u1ehxPIzuecjAsMxie7H+TqGD+qo3zyueeweXW1snovfQ5sMWVtstYaPlJdTzxNC
	kUhPYAm+54r/9IvhYyibqvEb0trrmVQjKeCOwfQHXre79J9XG00ySmn6u5amen9t
	Ce0JP7Um8s1EN+5J/RpSw==
X-ME-Sender: <xms:JzFOapoRfSUQ3BTkOrw2wUDBXTWlE5pr5vqlA1JbiLoqskcOJ2bYTw>
    <xme:JzFOavkhM-jrRf4MmDZKq5KRftPi5udPTaY2SXzsyBJfCuD4dH4fZTACRnIHMya8A
    A1YUe2jyZqPehXzBXs-LdLicvKtjNmg7Mm9Tamk3KPotaizl5fzlaAQ>
X-ME-Received: <xmr:JzFOautslFYSC8ocQVr16-L45XNYULn65xnJejaV09bfHOMnvkiQ-geB_fexxg>
X-ME-Proxy-Cause: dmFkZTFUNIYXC0Q5t8iqxsk5x/ZZMsEDxIoZnWAQZPTQe2TvhnM3yGqaiQbzxnqs+7JIiR
    Yq5XhJlRG8HRcn4TzRiv2EKww24qGo2vzTE+dwYEALdjzUu9fkyEySz6S/StK8W84OHvkq
    W9bJFACiywJM+FHRWARKJSxsj/OIv5i/+BUkO9YHMo8DRu+y4pegyGixo+73/KOUD27j6H
    5pOE/wzQGFm6/nPC8g/bDVffg3JUC2YP/n7l/I6zXixgasab/b3ztmwGVl8QyMOBshJvPS
    ED/XZSrmnCYJ6UGjCdjgdYCVYCbIESChWLzOeM4GIrKC6PPK50eSw/FV+ttn4eLfWIUOoC
    40eFPE4ohJyRXn0wJsbb3ZRPS8Sw6rSHR7HnQvpQWNu5whG4zXu60KirhQG5w+ovSrhQY6
    m5PEbYWA/ze5m1RCgNxiJmHjkUZDBhVUojpJ3BHc/24tmkI+JvgsVZD4qUBoUO9pGZLrZ3
    TqS6Y8z294JP5wlw9IqECOsGeKAl+2qrZKuzlnWWzhwFN8FXHcNPc8IRCIzGi/1n0T5vSJ
    KBZEpr244kXnWl/qIKF1qHNpvvvzqjDhp70Jl4Qut/6U3JCOzzJxy3OC1207LJdi8rwC9Z
    6lFvdrLr6B5GivqiB25e6vUJXjqOCM4LodOxPYZ8E5ekLEKz4+vVLl0NnaJQ
X-ME-Proxy: <xmx:JzFOaueSjdv6IcU3I2ZlUv7Dp2fze2G13MuDqGEaK-xiywbRIcvWHw>
    <xmx:JzFOagZp_zolpE6NbS5Qs3LidUYGcSl4pQLs8-76MAySyM2artu7Rw>
    <xmx:JzFOam0t7JvNoK39K82nmyq4fLSd3f0CE3QQfdoyIZ9VrxtFe2W4Gw>
    <xmx:JzFOapprzEpN9wkkOqffBGAR5NIOZfmhzsrRpDvef9WHF03DnPEvLw>
    <xmx:JzFOaoXyzTmNrvWrXxQlaBuxYa3d3xaGdY2mbq8AH7faAoa4mpspytJ0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:46 -0400 (EDT)
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
Subject: [PATCH v10 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Wed,  8 Jul 2026 12:14:12 +0100
Message-ID: <20260708111417.173443-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D806DC0009
X-Stat-Signature: zx84suc7uwh8ww9gi5wcbrxnz3ibqx4h
X-HE-Tag: 1783509288-976181
X-HE-Meta: U2FsdGVkX1+5qyiSlRfXWLmvST4GC7QZgwV1u637ycH7McCPAxU+/oGQ38ZBCjiZb49Z6ft20QH08xSG0ISrmynSspxla5jMSPxnE/Vxb2gQbrD9196MK8/+PeW+rtkPIBD1p2gtI9+zpDTQHGQVHrKq/6cwPkkhkKBqiDWPiCI88qyG3UPTYmMtRoNq27/Ft08NsDtQHpp2mKrKShCDivXoNLKHDiMRZGU4ntue5i9Z4i9dJJDuOG6K6Wfik0WIznSknl7hcD/KmoVoz9SaktqIkLtZG19GlxE2H46GLRqyk9Qr6bpU6w0sbAVAgBRrcn3tKiCgE94cy/TUlu2mrvG36eGqCZyX9CX5es8a7e/iOyYE5lQ3rGbyLhaue0YttrwxE5rvJwgXEuU5arjjZJxsOG9MgZAkkmwcIxuhZWYwhMDvU/J64VDd6VO3exis4+ZoO4uttln3e38A4+6yFhFmmHhQJ4PDJ67gGWun4/4+pskw2eaRFi53tUl/a7r0WEw2xo2WvsiGv6h4Hxb7Lot1xMw7mGmyMgSE58PEJmxGeOLO6JXnXy9Fo+lTBfyBC4ThF1sykzRMH9/lOcrJJAkILA73YeKk/AdE2cDmEu2rN81FgvpzfHx2IKM+3Da+r3hhlGiUi31xUwjDXYeCRlx5cVQOsr9M0p5kV/RjZHT7F2uwmu7N5Fegv8Sgv2f4ynPfHitzCHFAVf9DaMQdi53JRYv5pFHbpJ1WgX9vjk8L4wjYEwSmoAi/tYlFTs2h7tZYeY+pfrax1Z+j6qrJynKCigI8Yz64tvTsxZslY8avb+SyNudJyVeQsaqneRVUVpI1FbSwDrDusyaPeWr8/weuYWuEZU92WZtPP70reysrhdvjKNKFDwZAXIPGOwGe8sfV1OmAnZnynUgyFKAXwqUsdUC66BW0sYMvzheAHPiQ5ayY5qHgLOfgCMcjBuzP8kChrnkJaLi/byuBmw0
 uNPTiwND
 Jj5tvtVJG7DRcsWHPUMzPl7vwv58uEf/MOVZ9vjWNVazwQdqhRgDS4l2YEd6mOKGWsL+1cE5ac0KjdZ/dHoXIn+4w9/rrEB3nRNnG05bbmcBgGbB/zY0Z+UbPp11rtGbsrG3BBm3/GtCuf63XP74p/dIt4AJb5YAh4OQASv1yn3MOiXjpZ4gZONIAKttRB6SqXAHjP6KgG7RBGuFz/tF2BXIS6BIREbtn4ccaeFL9LPQJ5YtYWZIWGXz6X6hO5EViURl2zDXJdUhEAVXtDnW2ULhgq09FQdOMnBZbxDt/mUWQVgLBEddz22fhIRFtW1zMvunn/ezUP5rdThqw/0g96NsHlchTSlijWqLRDOafjLoH8lRut/E5bVJ7wXsYixvuTsvQr8NN87aS+pNMHsvXSnxxULzOUV0veM/jGCwabcbeD6D8FWMr7E31rvleUjXW+Luv0gekoFODRssE3kXSzyU1dg7HVpQczEme2oJTbLNPgtHX8R9nIkqvGoKsXB8xZe4/C7zddtiLOAqg5d/i+LK7xXsnvV/SNBfhjLK6p8evPK5sK/3YffUhC2ZsDIe1BjsHhwy2RPTqdARRf8d79wS1sy8ToifRpdu3
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
 Documentation/admin-guide/mm/pagemap.rst | 13 +++-
 fs/proc/task_mmu.c                       | 81 ++++++++++++++++--------
 include/uapi/linux/fs.h                  |  1 +
 tools/include/uapi/linux/fs.h            |  1 +
 4 files changed, 67 insertions(+), 29 deletions(-)

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
index 5f15dbba66d2..4cd7e1408f86 100644
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
@@ -2438,15 +2438,17 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
 	if (pte_none(pte)) {
 		/*
-		 * An unpopulated pte carries no uffd-wp marker, i.e. it is not
-		 * write-protected, the same condition under which the present
-		 * and swap cases below report PAGE_IS_WRITTEN. Report it here
-		 * too so this generic path agrees with the PAGE_IS_WRITTEN fast
-		 * path in pagemap_scan_pmd_entry(), which reports pte_none as
-		 * written and, under PM_SCAN_WP_MATCHING, arms a marker. The
-		 * fast path applies no VMA test, so neither does this.
+		 * An unpopulated pte carries no uffd bit, i.e. it is not
+		 * write-protected. The PAGE_IS_WRITTEN fast path in
+		 * pagemap_scan_pmd_entry() is now gated on a VM_UFFD_WP VMA;
+		 * gate the pte_none report here the same way so the two paths
+		 * still agree. RWP has no such fast path and an unpopulated
+		 * page is not part of the RWP working set, so it is reported as
+		 * neither.
 		 */
-		return PAGE_IS_WRITTEN;
+		if (userfaultfd_wp(vma))
+			return PAGE_IS_WRITTEN;
+		return 0;
 	}
 
 	if (pte_present(pte)) {
@@ -2454,8 +2456,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
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
@@ -2472,8 +2478,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
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
@@ -2522,8 +2532,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
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
@@ -2537,8 +2551,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
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
 
@@ -2571,7 +2589,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HUGETLB_PAGE
-static unsigned long pagemap_hugetlb_category(pte_t pte)
+static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
+					      pte_t pte)
 {
 	unsigned long categories = PAGE_IS_HUGE;
 
@@ -2586,8 +2605,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
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
@@ -2597,8 +2620,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
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
@@ -2874,7 +2901,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2949,7 +2977,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2961,7 +2990,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
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


