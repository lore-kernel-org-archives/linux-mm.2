Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66DFC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64366B0106; Mon,  6 Jul 2026 04:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8EF6B0108; Mon,  6 Jul 2026 04:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6086B0109; Mon,  6 Jul 2026 04:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7706E6B0106
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9E311C1F00
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:22 +0000 (UTC)
X-FDA: 84957725244.17.25779A0
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A8A040002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="t USwFyW";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="oMJrD/oL";
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2XHNZYtK7QdCKmCMKMuv5ZOOJXQmj5KCJWaQVkFtmQ=;
	b=4UKi2SMe8THWk6JsSrW7zFuVUSiueVN8R89jgsTKtE4upaKMt40N2L9nCLMY2yRvBmKrX/
	rfd3TLI/gCr3Of6CfuU1zMtBSAImD3kltnkzyFN6UeY13eJsLVbPgxKZWD+7nwhwv1QedR
	5Z6mUe4gyXW+PGrr58R/mZ4t3+2jzFs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="t USwFyW";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="oMJrD/oL";
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327701;
	b=g12M8xD1Lxl1/4CG3pUB9aCNr933PYpmoLd6ZiAgaUZ/qradK5C1eX58/mBQZXa26kSlAO
	+EyRADraBhBJKB07lWVCz3a7BMoN6bB5plR+agCjIgWB4sJFMvgojenR/DVolXa5rvjMKN
	a7Euhr0tGOOnnbv2SXHNYMk7ZW44NOE=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BBA997A00DC;
	Mon,  6 Jul 2026 04:48:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 04:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327699; x=
	1783414099; bh=+2XHNZYtK7QdCKmCMKMuv5ZOOJXQmj5KCJWaQVkFtmQ=; b=t
	USwFyW0a0faqokgZEO0tOU3qlQiWSmbpTh+F9LdYz1rnwJkL/ASnYBzQ5jLmbjRz
	ocfofnhwZwVcs8VpT/rySUW0RlIqj6Zg67xqmN9WPJ86IlD6wZJuBJtsBsZrlUGF
	zEKOpAZN8ZKVf0Kqth3VCCZRdfFPam0+6bqNBDDOLdGUntp1Ka8cXDeuaPiP+FZw
	I5Lfm9Pqbj6dr17xURQrznJs/iM/pPpbyhehEt59VNNYZkVOcGxfkc1H0r0Z9Qiu
	sdnZYzI4SAsKbq6tAEBJ2nxIttyqSOga0ViG3goPFERGUNZxPmjFFwWA6mz1lQbL
	CVIi7BKRIXchpTa2jMwoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327699; x=1783414099; bh=+
	2XHNZYtK7QdCKmCMKMuv5ZOOJXQmj5KCJWaQVkFtmQ=; b=oMJrD/oLjQTfOwbOR
	/CHb0sW4o8FQ8KI4jSKqWP6aEs8oXJGkhzsxdivW6gkt9Gv+1fLLicME2/ERtGie
	Gjj7E0WkMTv3MGrJZdmonHRNO0J0lasbkpGjX2angb8UwwECgcATHQ+rIK6J522g
	mwTumGub8FlC6lj5xU+RooKIuT7mVnwDc1j4gwKA4i+McEX2fVSwZ819nXPyq9Cz
	x3bzgncsD4QB5KcdOD4TnRlogtc+J+16a+W+EhiaOpHsbj1o4rEA9Bfwh8ELh2gO
	oWeG+b/0DDlb6pCjWHZRteT/wjkh3oikEaDLx5aMUVF+WrNEPpVfH4yl5zd6bi2K
	t8QVw==
X-ME-Sender: <xms:02tLai9NqE7nI5GXl6nGkK-Odot_JLIvZaCtSGxvdfgVD0GcIbOKLQ>
    <xme:02tLampef2rfAFRPsa9koMGirllQjQFy8XkCGoyiFacslZtURAnozTArSMHRvoXxZ
    pdabJt05KMoqQAO2a4AluYo9vlZUppjpn7oiro1PQi1B7c1tUBPcNQ>
X-ME-Received: <xmr:02tLagivgwVKe8AQ13bdzt1EQXkWFau0Cz1lSiEJSVKCd7u7z3FZWLzvcthnJA>
X-ME-Proxy-Cause: dmFkZTEh9sC5EqbRgJa03mEIbBAdkgemxEM7AsNqvUe89u1xo7wP1i8ZoqHNfKw6kPRkLf
    Xf4tADC+YIvupyb637xknAtIy18fE0aWt+RuiDkCNxq0a4nV9dRPndmkbzCzUwk/U/C6jN
    1TGT7TeOFmBCUcmVMDJQixlYHRhfwPz0VZ19qBuA6SB1vCH4bdX/JvuCZZdjelLIaAtaap
    Ws6zPQJL22KEWHr/uMLwFQlfcmpdb5QZUOVGBG1XpNpDElgXqzSqrr+Ic+X0qTFnY86FNM
    KWmD1TGbrNh9VSSCCZRc21lPI5/MmzHHZvOAJIoFlP9wwn/2ZZY64HjbSunj3c5lg+UnED
    g3H/Tn/ZmW7sG+Z87z+/R+LYk6QEO/XtsF3PHE11jPST2sRY77++/jMAZNug21n4CknqMV
    IPvcCI+QGg0/LfFOS2dloDFh076Vks+xsqclpFpcy6AxUarXSVuRe3wFtNGKsYAVu6A5hn
    Gsp/VlrCOHUn+tZtYc8zuHZ+wMFJRsLF7ChOIeSVvt4+y4KOaPGzgFwu5WNiTpehzjnCAy
    2azZlPlrB1mcXLNz+otm2EqQ9/opxXMvn5Q73l0PBr/1SlKt2o8Mphpr5XMewRFyrjkjIc
    tJGfOANA2eNrUXiqfOXpUXTrtmPDonxMnZbbfVEZviHWAY3inZJNDhTt+GaA
X-ME-Proxy: <xmx:02tLakDHjmWa2uCJNvqVoSse50Q6kQvorP0VNtx1qvtsHcDgEv_MvA>
    <xmx:02tLauuoloLqirehgyvOqx6WSY4J-JCpaWzd2nXFcHuYkG-WReHJwA>
    <xmx:02tLau4f1nefRdnhRjFf9uKMjHf9xG-6XFfUDsuKVmQXphE8tTmU5Q>
    <xmx:02tLaoeSNIpCbR_tRBlK8T8govEPocPTrwxLylfAiSq3PmXjQqJIHg>
    <xmx:02tLatey6YmkfvC3dQupuV0M1GL8enemNNO01x1mmPmIQ0E3lRFGQZ_2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:19 -0400 (EDT)
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
Subject: [PATCH v9 05/15] mm: add VM_UFFD_RWP VMA flag
Date: Mon,  6 Jul 2026 09:47:54 +0100
Message-ID: <20260706084805.8400-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hj14kkrryqsq37jdi8rsp7n7xrr7yu7w
X-Rspamd-Queue-Id: 0A8A040002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783327700-55452
X-HE-Meta: U2FsdGVkX1/hgyNkLGksQH3tbBjga/J4UJg9nPHfCnQbGhTWc9P8lQ4Ii1yj0fCZsxbiQVGaDqt4CBd1+wutqa9scODXce9ZBLko337DKO+MrFCWlGJOheJqw7yWFHZnjht4YM63FxbXr37vIM/jU3fzrZov9uTnZmpqaVxMfeNboYS1fhRunMPZmYl/NPn3JENa2FgIgMda+Qg+8S0SqgTMwIMIHQ4ktShp2mHtkfh59whJh7MhXHikCrD+AoU2dyjhf+UI5pklZPXgJXsi5yxT1YykCvrixQg3VSI646h/PGh6kyENaKxR9ZfVbyIdY9RKfZolWkqHp9Z76o+kCfKntjzn0WkQ+iu35HLYLiWBPpwhTHpsyYhZv0XusBvSsEhKeXZWMr/uBvogbw7qePdGHvESATqbvafcXMJdIof6n73Xk3tdyrGQg3x4tUx7Mkzdc1YnOx9Po2Oo+zD8Lvrno1LmE8FltQbMENQIkN26Pz1DZOQxuNQ/1nllpma8vAAP6wDuZW/1cIMX+h++9jOw/TpNp0GFJxtOan+lSEWcHanYWEpCzo3jLG6aoYs/qs3sjIScoYwHI2s9WP5pYBkicdgr0LddegIUG5s/hIi+aw/2pIVslNSkquBIrSEMMpU19g39psxIxi4rZ76WXZdBSEpK+zaFtWMcm7rPgATuaivn5Red/4bd7w8PpM/mhdU4MYJpNbIOCNmwKrA6A4zDoTyb+IFxMMLag8cDl8mx38aarDKrmGPPtAIvO/oQxAPcgWmgkgBNmUpfIPm33zzkiwa7QbNYuH3Jg1EnGxi7hs1XBsEd2B4Z03BqeaekhXRWj1PMS4fP7HlEoKI+rQvohagfVzjmn37dpwEb0haF1BhgI+POYngWps0A+iJj+12sIeDCIQznyTZLBv4nKO/zJ0ZbkWFMBxBTlRU7LadAibzU287ohuB/xwLg6ukThLgZetgNWwZjOHWNfU7
 bkMJcAey
 G9wulGsu+j6W2nOqjAEIUznTGssRUMB6q79UsGdV1Gt2ZbVZxGfi1F2ghyj8pmXtzJ2Ho5hKnvkoBzIup+YduKhWjpiT1wEKsFtGPimJVgtCgaCJFjo/XULf33FcAoGFhGeEHe+aYWPSnb8iBDxV4B7zOSc/R0Idq3xgVpjlnTpl1DWGK4mxd4+NFIL9Yvuf67JmpUyhkGUIPZ5/Kr+9lqWXAPGjrild4yXc3D1xykqicG7uO0hL709aYin2UhK/6Myo1+LphLmWSVTFtTuTuPZHL7HTprr4MUCCbUZ1e1xX7Hm4uHkmvNsG+DQ2U1DNO0J8xJn8IZNB6/0yxKXzAMDkaSIJOqCOdtqqvcceGY9Ov+5S0OvjDEP2yIotFJqD/flZxJ/10M2vpICSQ48CnNLMenBqhz6H1elUo6WJVlzer0EHKtuctf9kiS4610WJ+A3x1TykvDtJitGovL4a+7O+XaZvhuF93JbTzWurYkaBUMNtg1wbESI+qR1/nH6eXai/n6lP9dYJBa+cplzM+7ZXUZctP/N41uMI4anG8+yDMNexT4X/2YG8+k257c+WYG9jp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Preparatory patch for userfaultfd read-write protection (RWP). RWP
extends userfaultfd protection from plain write-protection (WP) to
full read-write protection: accesses to an RWP-protected range --
reads as well as writes -- trap through userfaultfd.

Reserve VM_UFFD_RWP, add the userfaultfd_rwp() and
userfaultfd_protected() helpers, and wire up the smaps "ur" entry and
the trace-flag table the rest of the series will use. The flag is
gated on CONFIG_USERFAULTFD_RWP, which is introduced together with the
UAPI in a later patch; until then VM_UFFD_RWP aliases VM_NONE and
every downstream check folds to dead code.

Nothing sets or queries the flag yet.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 ++
 include/linux/mm.h                 | 41 +++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 45 ++++++++++++++++++++++++------
 include/trace/events/mmflags.h     |  7 +++++
 5 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 2ccd5b2dfdd3..27189f6e004e 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -608,6 +608,7 @@ encoded manner. The codes are the following:
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ui    userfaultfd minor fault
+    ur    userfaultfd read-write-protect tracking
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 56deb516b193..5b55c59573a3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1237,6 +1237,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		[ilog2(VM_UFFD_MINOR)]	= "ui",
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
+#ifdef CONFIG_USERFAULTFD_RWP
+		[ilog2(VM_UFFD_RWP)]	= "ur",
+#endif
 #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..5ac31fbadeef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -353,6 +353,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_RWP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -496,12 +497,17 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
+#else
+#define VM_UFFD_RWP		VM_NONE
+#endif
 
 /*
- * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
- * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
- * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
- * bitmap cannot hold it.
+ * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
+ * gated on the same configs as their VM_* flags above -- both of which imply
+ * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
+ * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
 #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
@@ -510,6 +516,11 @@ enum {
 #else
 #define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VMA_UFFD_RWP		mk_vma_flags(VMA_UFFD_RWP_BIT)
+#else
+#define VMA_UFFD_RWP		EMPTY_VMA_FLAGS
+#endif
 
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
@@ -648,22 +659,24 @@ enum {
  * reconsistuted upon page fault, so necessitate page table copying upon fork.
  *
  * Note that these flags should be compared with the DESTINATION VMA not the
- * source, as VM_UFFD_WP may not be propagated to destination, while all other
- * flags will be.
+ * source: VM_UFFD_WP and VM_UFFD_RWP may be cleared on the destination
+ * (dup_userfaultfd() -> userfaultfd_reset_ctx() when the parent context did
+ * not negotiate UFFD_FEATURE_EVENT_FORK), while all other flags propagate.
  *
  * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
  *                           reasonably reconstructed on page fault.
  *
  *              VM_UFFD_WP - Encodes metadata about an installed uffd
- *                           write protect handler, which cannot be
- *                           reconstructed on page fault.
+ *              VM_UFFD_RWP  write- or read-write-protect handler, which
+ *                           cannot be reconstructed on page fault.
  *
- *                           We always copy pgtables when dst_vma has uffd-wp
- *                           enabled even if it's file-backed
- *                           (e.g. shmem). Because when uffd-wp is enabled,
- *                           pgtable contains uffd-wp protection information,
- *                           that's something we can't retrieve from page cache,
- *                           and skip copying will lose those info.
+ *                           We always copy pgtables when dst_vma has the
+ *                           uffd PTE bit in use even if it's file-backed
+ *                           (e.g. shmem). Because when the uffd bit is
+ *                           in use, the pgtable contains the protection
+ *                           information, that's something we can't
+ *                           retrieve from page cache, and skip copying
+ *                           will lose those info.
  *
  *          VM_MAYBE_GUARD - Could contain page guard region markers which
  *                           by design are a property of the page tables
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c4f2cc6dfcf0..6dad14b9abb9 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
+			 VM_UFFD_WP | VM_UFFD_RWP)
 
 #define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
-						 VMA_UFFD_MINOR)
+						 VMA_UFFD_MINOR, VMA_UFFD_RWP)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -168,7 +169,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 /*
  * Never enable huge pmd sharing on some uffd registered vmas:
  *
- * - VM_UFFD_WP VMAs, because write protect information is per pgtable entry.
+ * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
+ *   tracking information is per pgtable entry.
  *
  * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
  *   VMAs which share huge pmds. (If you have two mappings to the same
@@ -179,20 +181,25 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
+					VMA_UFFD_MINOR));
 }
 
 /*
- * Don't do fault around for either WP or MINOR registered uffd range.  For
+ * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
  * MINOR registered range, fault around will be a total disaster and ptes can
  * be installed without notifications; for WP it should mostly be fine as long
  * as the fault around checks for pte_none() before the installation, however
- * to be super safe we just forbid it.
+ * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
+ * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
+ * and pollute the tracked working set, so each page must be populated by its
+ * own fault.
  */
 static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
+					VMA_UFFD_MINOR));
 }
 
 static inline bool userfaultfd_missing(struct vm_area_struct *vma)
@@ -210,6 +217,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return vma_test_single_mask(vma, VMA_UFFD_RWP);
+}
+
+static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+{
+	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -330,6 +347,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return false;
+}
+
+static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -423,8 +450,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 }
 
 /*
- * Returns true if this is a swap pte and was uffd-wp wr-protected in either
- * forms (pte marker or a normal swap pte), false otherwise.
+ * Returns true if this swap pte carries uffd-tracked state in either
+ * form (pte marker or a normal swap pte), false otherwise.
  */
 static inline bool pte_swp_uffd_any(pte_t pte)
 {
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b42..bfface3d0203 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -194,6 +194,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_UFFD_MINOR(flag, name)
 #endif
 
+#ifdef CONFIG_USERFAULTFD_RWP
+# define IF_HAVE_UFFD_RWP(flag, name) {flag, name},
+#else
+# define IF_HAVE_UFFD_RWP(flag, name)
+#endif
+
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
 # define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
 #else
@@ -215,6 +221,7 @@ IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
+IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
 	{VM_SEQ_READ,			"seqread"	},		\
-- 
2.54.0


