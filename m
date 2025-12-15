Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587F4D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F806B009B; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8EF6B009E; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9AF6B00A0; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5792E6B009B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01F4213AA1F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:22 +0000 (UTC)
X-FDA: 84222966366.25.9255764
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4BD0140013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=THIZN9bi;
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdC3DIc0Si/peWz4xeyhSNBKqQKmQYHvnUTtyCRmJl0=;
	b=0CW0l8ibPMXyC6wZjYfKqX9IPkNabZ46M/YmYsDU0I2Qj1+rAzCHDUi8ZpeF0VM4iUyDUT
	1QbV7kpelgncdpR8Qrglel5lTWxPQAmyK7QzikXUTWPFdax9w2fzK5H3H0eg0kAJ+MYfD3
	FIlCAf/d5VjT3hRsS/EnWneQTdlqmqY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=THIZN9bi;
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833441; a=rsa-sha256;
	cv=none;
	b=j6I6FAMk49JSX9NsoA3JRAceVhJ33geJpVsXDctopgVf+axWxNrfXQn7jQiVd6t6gdth4b
	FmfTlym9T099kRGDM2qkecGLAKord41LcLlJeEPbb3ZabtoO0i0SCc9vZ9Ux+30D8jvONq
	jOK1q8AW1RlGqGLFkLMq0B538/4pFp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdC3DIc0Si/peWz4xeyhSNBKqQKmQYHvnUTtyCRmJl0=;
	b=THIZN9biQEmwhd4OdZ00UBWzI2n8W9v6k2MkysWhaonQ/P8UildSv0OMHya4lRhTiXRibe
	r25rJY21qxkwY5ytT8P5oe0Qrt52+kLfZLVAJobWR1ZArQVrz1RYyUPuUhG5nuBLBwK+AQ
	mOrulEfb9V4X//irN6jJ0nCvqR4A4QA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-Q44RIqm_MY-Xjh09sBZr1A-1; Mon,
 15 Dec 2025 16:17:18 -0500
X-MC-Unique: Q44RIqm_MY-Xjh09sBZr1A-1
X-Mimecast-MFC-AGG-ID: Q44RIqm_MY-Xjh09sBZr1A_1765833437
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE1451956071;
	Mon, 15 Dec 2025 21:17:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A2A191956056;
	Mon, 15 Dec 2025 21:17:16 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 09/11] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:51 -0500
Message-ID: <3b2862e9ab3c90e03b4b0ac1a4d0cd4d0b783737.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BD0140013
X-Stat-Signature: 8k1ncbrc6patd68hom9mmshqspmxydhe
X-HE-Tag: 1765833441-24794
X-HE-Meta: U2FsdGVkX1/O4hnN873QHC5Q0I0rVxNpVAasWI4++pKsovX3P7ofY1pXr8sAbWWJQ5ppoPOMLQf6jh0oWNIDXMEAgtszv/yZ7HssTW22NO+ySHfwGWSHvSXPQ3Y3XKJw6e3jFBn1/UVwuyxq+KT9C6ARfha42ime32SqybZ5ZGJ4GjIJ0YauA2Cn62JJQ9IxqSvMCS/7c9n6JhL4WSqrDs12Kt4kEfYytVGvy7jFdNIp63aUNhOdKAaE7Dnb/I/qUKJYwq0xhpuY/MLZajKdFCKXuYb5NVUEdkjDzebt6etiDXiffYSQFPKF48AV93Z0B8v2yU+q80USyaiqPk35R3xCOvw+HWJH1WYbuhX1amYNgBr6OxzNfynge1Q7Bs+n/8cwkjU9bQTISMhehHS3SiERGPioS0F1jxZFYpFth1HAGAkuubj4Nbcm4sKPq1Ge1lo8MnrYbdFQ7UmnJmrq00HSbVKJAoI98p418ek0tZmpRcDHsRa5ZZPD6oc0zaSDOrsXuCPUTOP3C6yXr1p7Nx6UFik1fF4kpHR/oFWdIoQgTMCgjXVU6maM7z5zfWGeUeYpjfTE/YXF0BM6RsoX278/sk/DFepp3l7QqqnTq4kUPXEqhW9awvoeZV0MnLzTJZfBD+GaWeA20N5cBWyzHJsiYG7JuEfcMvZTLANGZOzHlpcvyWaKf55534PDwQHbGyselNf/9N18trsbSGdMP/Pui4aVwpF5Qd1lRcO5f5kC4kdQO84w8euMLCY786TlqsPNF4KOJ+ncpWK+vtWHbrO47JOeSFsEAKiPHb7ORbDj9QVCNemZ7xTadUUCX5ZXz1IpvP7IzjGj0LLrbbU83OT/H6T7LBD2VsBm1gMJF/R/LJuhrYpZQF7MzUj/4teVF44847XoCOQKs0Y11tK9v3Pc53Bg1qOZoqTT10SIBGnNGGCCea77DYZwleea7e5fFfTxFs7CGMTyliQNguX
 pcewUcE8
 waXx7H0mXLosG2Je7B7QVgQYK2yraZm+bBLtLcIOOkLl9gPSK/CIhNwz1pnbo+PlKucYPkYGVOzvuJEuY7qyWhr7QSn5HOtwvWLvoGz+srt/5V03YY6xP0F+c4yFG5oHD+qNwlc8Fi9aM7BRbGbQQIyTXgl66jhv8QNddHBX82JFZzll8osJLJ4K44VmghKwUeJ+FDImCW7TddOa5QmPtwa8nT5UdH3JjWcqkzThBD07KcSizmQziByu6MrgnMe0NKPIUrZYNn88KjwdI/4y4K6J+eIZHTiqOKI4opDVQNKo/YM3EpDX6Uq3h9fo51tJDIEwqRix+KbzvHe2PNgOCNUhbS99sA4sFQDdpmPWueDRbLO0eGizFl4ymiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite its name, thp_disabled_by_hw() only checks whether the
architecture supports PMD-sized pages. It returns true when
TRANSPARENT_HUGEPAGE_UNSUPPORTED is set, which occurs if the
architecture implements arch_has_pmd_leaves() and that function
returns false.

Since pgtable_has_pmd_leaves() provides the same semantics, use it
instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..e291a650b10f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -352,12 +351,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
-static inline bool thp_disabled_by_hw(void)
-{
-	/* If the hardware/firmware marked hugepage support disabled. */
-	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
-}
-
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b80a897b9b6f..1e5ea2e47f79 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -122,7 +122,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -905,10 +905,8 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!arch_has_pmd_leaves()) {
-		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
+	if (!pgtable_has_pmd_leaves())
 		return -EINVAL;
-	}
 
 	/*
 	 * hugepages can't be allocated by the buddy allocator
diff --git a/mm/memory.c b/mm/memory.c
index e816d4b53bc0..c35df4c477c1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5383,7 +5383,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index ad5825667b49..6b350e336f8c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1800,7 +1800,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.52.0


