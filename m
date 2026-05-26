Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10688CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECA96B0095; Tue, 26 May 2026 09:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6236B0098; Tue, 26 May 2026 09:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D776B0099; Tue, 26 May 2026 09:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2C726B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89152160C9A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:58 +0000 (UTC)
X-FDA: 84809593596.13.510818E
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89E15120014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vLST9AFF;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="c 3ogybA";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V7U0e8pmOCDRB+w7Ki4npwjrymHShsCqvi0HnvAdmrM=;
	b=FnGPnHaGRcDniYWOuLBXxaneP5qDy2pGE0/Yvl8aDBksnnGanLrGrPPZuCeIi0UcqR5Mtx
	2ZlqULafoNNy3AkVulUkZslDOrhLIQaGgnpqzpqMPHYcXMviTthDy6Xmvo0Jto+kdh2/U7
	vqtH2Ra+dOOHh2wLmtwo7S82VDgdJz4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vLST9AFF;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="c 3ogybA";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800756; a=rsa-sha256;
	cv=none;
	b=LWwbQUvQGwAb3TfdBDcKSbxoR7PovjDA8WKXMTz5h6usV6uAcsAJ2AdSaGb2zpvouMFBWn
	P+4xSBuXYUHf2AKPvr4JASxkuuEbjuJRyKPhHxiejkV0qo+/pVd5BAKzCwnIGXl8PwQ0Oc
	lNwq3PiMxkrgkljX9uAq6PBcCr1+94k=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 62AE67A019F;
	Tue, 26 May 2026 09:05:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 26 May 2026 09:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779800755; x=1779887155; bh=V7U0e8pmOCDRB+w7Ki4npwjrymHShsCq
	vi0HnvAdmrM=; b=vLST9AFF4jFVcywiNhRXckCFD2nnGmFtYy0JuMVjHLgK7r97
	kdzuZGmNkeTiUMZxYbImCxvrMPhJXtQRm1xLm5ZzP0/jY2Psvle6t20lef/jbM2m
	df6Sv+xyva4ph5cWGglHdEKKcTdqIywRCNH4gas/qTqS/su4O/BpMlCbhQwIHq3+
	cqTi7mn0B/SRe1IZ+cf5bA7GuAMkRauNUvlK908vDx/ecqRV+tch8mdHjBPPhsmc
	UZlZTkgDmt0cJdCyjo1LXD4zogdJtnNM3JMyUdk4QzGUPo3efAqwBbVaGgaquhEJ
	omR1+YsKViRDt1BW24cqnHqtTOoVMgh01yREIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779800755; x=
	1779887155; bh=V7U0e8pmOCDRB+w7Ki4npwjrymHShsCqvi0HnvAdmrM=; b=c
	3ogybA3pWTT7lOT0cKabVoApt9YWbqnqSlvLHgBmfRTUTJNaqrtMZ+aHqwGSSYJy
	/fln4P7yAV+EM7MQbr9fUX3tKrkXBD0adYECZrKbe06Q9g/ruMw03oVxz7Ujmxme
	w0hUgfCpNVGmOLODV4dqLrUAPbgd9TuFXU4iDKOSJwdKSSf9MB29nUIraeSdRbZC
	RdLDKDSWTuQwKEtfhExHjH3tl8wCFbm/GGIfMp1oMCqsZ4p+7Q+Fil+cy3XTzVRY
	y/1OVeOmK5BdfzD+eLc9gK5mjh8X/qczlrNFazCxxcLVt0YCnLsR6WkJw9tsNPQv
	5OyEHXV5AXSR7MGhzjyXw==
X-ME-Sender: <xms:s5oVarkx9odHDZJEPcoe0X885HQDsJxZpZ3dm1mCKsKpBqzz8V-7TQ>
    <xme:s5oVaiypNScmWT85kumELkhKtuf01ySofvvLIWSi-9e3wERx6R-Gtn_aGs9RM6q-O
    LvGcFqlIo5gDTe8PSRFATwBkNDioLC6q4l397b7jnMG4jzzQl7UKiA>
X-ME-Received: <xmr:s5oVaqLPI016m-WIHh3_Rpl1OjpxJKdmQZgmVnaYAhsKBJuTr5_tOr5pCcuUEA>
X-ME-Proxy-Cause: dmFkZTFRxKInQFecwZPuEt+LuNBlOJGP8RsxGpm588gQviVhNq1Pa+AqWD7JQeVUR2Swte
    eyzLZOEYFGJPBoftF7cmhN7hkCk3wRua/o4v8Bw72KaC1CFplNf1sAsIMRN76GRZVrrXJo
    4g3If4FQDoPgtrZ9saDLAexzQgvrfsTwQ3/KP0AGKCFmLiVvQMOmXCsts9ZOCGk1E95eOU
    mgzRkXibxyISOqgf2hZqBdgrV6ktnG5u3x8/zXY22S6cQZP9xSB0eE/pqpJrpVnOId2p4l
    G0binpu+ah/FFZH0esjGo/wTdPAqY9SKUVzl+zWcrHaZzSyBzEWlNRkrUo/n9HkffJzpDJ
    RadNWjUYf05V4NClhmxfTiFz7mqn4CmgNeoF+o5VwMXR+lDZSJhql8M/tys2jB+a0Zeqq1
    bu73w/0D8yuFUdQC97NuG73B8GkWe/dqnrTl4GCqO8Ue7YttD9BD/SzihZRsSPdFVPDk+Y
    jYkL8fugK6WenVTJFiKKh3L9J/loaS7yJvBGhOyt+dZ6EuRO6ZYAZJ586Opw270rs3vBWU
    b4bkzWE1tnalYCButGLiNmmU54wvpEzxJyj6Nby8S3goSjxIN1uptIsFfk+QDMex02FHUl
    wbSVXZ9lU78ZgImB99l6sxpzQWYjerHc08+RgKqGJ4ItmlNzLwaws+P5BPpg
X-ME-Proxy: <xmx:s5oVatIE_1vy3RfJLE3kxMC5eYZRQ9tfZIEHcPX4BytZaAEhcV6Rvg>
    <xmx:s5oVahUMSqYvpgcD-rLJtO16Ec5S01kfJWDlb6tnqWTslILNQ1pFJg>
    <xmx:s5oVatAUB62z91MGv7cNgjC_lkfbj9NOSI_4xmBzX4JzTLNRx2U76g>
    <xmx:s5oVasHiZ-hQZRNH94KXjqER-ajLEGeTe4J_9CbzblOC3VdMQ6x6qA>
    <xmx:s5oVaiBx5Y_IHRIfeVhgmoh29qmFrRNd0r0B7X7QISaXn_QJDDCL4j0->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:54 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 14/18] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Tue, 26 May 2026 14:05:02 +0100
Message-ID: <20260526130509.2748441-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89E15120014
X-Stat-Signature: zkhwfynzsemxahukxb4uj7pg9uegtn3b
X-HE-Tag: 1779800756-219250
X-HE-Meta: U2FsdGVkX185+t0GipZlieUwC7lpI7WtJdvFFNTtRXoa6Kjy3oOp25lN9XFuBNG7TSjeA+2n48o5QSRwrT6pJeVoyaG6RUmIc+FJ+AQwHox8UI+O4lAJPP6c6Q6Wix9NH8koHDGlQubuxIzkxvZulpVwwADRle7mZLLbWKt1e0ZzYliJCD5g7WVxGzpRKZvSH/EDISJhZd2sDh5E3ekKx3Amk8SSQSFxIUs5KkIoMAFZu9C+x29g+Zi/YofNnBuo+rPlebcSAx+IMiCpw0GJTCJtTZaVasEuRVxhQkQ4AhLkmtSWtnBYUDwXmi+6FRaciDIsRwdmqWMzB+Lj8NuAlSKecNnDAoL9V5TbIQ2gvv5ESBSXWNlmmsHVavvoReahJLQHXV2npGPg5ozS5x1386WVX3GCf2+2nA/vmDbEDQARJx7Y6mTRosvgZQrAj8Ait0Ma1FP5/O8z1WB+WcOi9ueNVpJIrC2bXL3dzDVeoR8AjXWVn9WCCIV7yyw3TUv7VLSwgRLmH1m7PMXvBeH/kYShUgeYxBJUo5SzKl2GlUX2pJVwADVE76U9Uobzix9s2Fv/33VBGclAArR+YF0h2oyIsyK6ypUVXsAuGMK1NEArrHufO61jsHHSu1EMCUjMdcnMphC5tAFeAkW2OBWAgkHHhH5WiT2USvltO0aRDQmfWw/VS7b6gKHuY4dzaWj4v/Iuj0N+PuayEfDh90o05rtYMkwwuNmjVHD8Ej85vbPnWCfoncQSDRf79nPoL5uRO3aVqOWZ+1xR8kixtYx79QzCe6tWADmzmCxN37akkZ2JXMWc1+EZAeJG32Tkdj/ioOlsMkyAid5eec2MqcOXzBDZto7BmKvnOuyXJ61w/EnvRHSgq4OZM//AnqtKbCGlp81Y3zb+xtjB4xu0YRObk0cDjioTaZhmehsBr6vEgfPT5VEWdS0eQV2a26wlvpFPwdLQ2tfbMYOLf1a5yr+
 5nLPue0n
 uw/465FXI2h+iJAe7jBh+djKPQzyWhc41pS8Hi/jvfMWw8EocSzMrWRx2kg5olKWQC0w5y2e6v3BNpu6byd00NpEWWEc6QafB8XwQTaRoNbDPT290oh6J5Ya8bAqV1p4Ucfq5GJwYTQVXJINvPlczNgry9SUxPueQe71LabYUZxnJjHJ9QB0CezDhT2s/NLgPkmY5YMy6reKrIlM0hDpUWqkQYQutj7+mIwRCtiKbm9TRreVahG7NKLZEvHSQEs/qlxmu1KTKEbp5hKCgg4yQa0F7+UPIzpEDvQPXAP0Vek69pGibDNfnkzRgB54raSRCRuYya1gWYgsSfvCZW6Ts5iQvgBjUissLeQq/IQHedreSF9U558U4HuY3vPZILNC7VO7xLxXHyfs0nkd3gJpgcMlFAjDOAUgEiUkswFINu3HQdco9pe6B70dNn8odbRqriIcAchOqTRgjN3bgeXtOxZ8rrBs94MFZ3s9RyqWWy9MjhOTbH2LIM6ACPH/pFRBgVpcQpm0GSdr6eL1QXLad7kr91zjojgePEN6MhauSL/5pVqc/xQGgV58hG47u19vpZK6qEnp7jYpTHoxgzeiWfuQ81lIhtlvoRmg1t3rs7+gl8nevtO6d2wD5nwxASaRQfUyHNADQ6KKQah2wL10TvQMIbPwR2m8fsF9OdT3q5bMLF4znxpeH401sw3r7MYoflDFXOUeY1/iT1b0=
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
 fs/proc/task_mmu.c                       | 75 ++++++++++++++++++------
 include/uapi/linux/fs.h                  |  1 +
 tools/include/uapi/linux/fs.h            |  1 +
 4 files changed, 69 insertions(+), 21 deletions(-)

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
index 974c5f4aa533..0db29c3a8639 100644
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
@@ -2677,6 +2702,18 @@ static int pagemap_scan_test_walk(unsigned long start, unsigned long end,
 	bool wp_allowed = userfaultfd_wp_async(vma) &&
 	    userfaultfd_wp_use_markers(vma);
 
+	/*
+	 * PM_SCAN_WP_MATCHING is the atomic read-and-reset flavour of the
+	 * scan and is implemented for the WP marker only. Silently skip
+	 * VM_UFFD_RWP VMAs, matching the convention used below for VMAs
+	 * that lack the WP-async capability. Returning -EINVAL here would
+	 * abort the walk after preceding VMAs had already been mutated,
+	 * destroying the atomic read-and-reset guarantee. Re-arming RWP
+	 * is done with UFFDIO_RWPROTECT(MODE_RWP).
+	 */
+	if (userfaultfd_rwp(vma) && (p->arg.flags & PM_SCAN_WP_MATCHING))
+		return 1;
+
 	if (!wp_allowed) {
 		/* User requested explicit failure over wp-async capability */
 		if (p->arg.flags & PM_SCAN_CHECK_WPASYNC)
@@ -2864,7 +2901,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2939,7 +2977,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2951,7 +2990,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
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


