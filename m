Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53C9FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2106B00A3; Mon, 27 Apr 2026 07:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2733A6B00A4; Mon, 27 Apr 2026 07:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189856B00A5; Mon, 27 Apr 2026 07:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 074926B00A3
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:46:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D70AC03E7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:52 +0000 (UTC)
X-FDA: 84704159064.19.FCBA713
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE96580006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJW2KjwB;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgWIDEWzrsNWMlC3HL7nSfUHlfAf+FJ1FQfAQcKYdMc=;
	b=MUxDf04ftSgiGPZV3DC2j5Vncp5EXZAdmL1SiLXnr+IUx5123GYchvmbahjyBAjJVVdFdS
	3OBPZhpTn8jA4JiKH4CNyiaCbLMJSg1bE8J25aVcpf3RgkztrBLF60eU2WMn7KTm1S0VaI
	BJ0Sbwnp4F39W77xThjdRhrUe7OGm3E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJW2KjwB;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290410; a=rsa-sha256;
	cv=none;
	b=cBDfk1riBYFgVBBCZNGqe/RpzO0r9uoqimIxN0UioCSmaRo9fYWUbFF/IWV/7xWHtaMzPo
	9mPJOmoYNHWXZb74Za+PdSDpXuimsk55aj6nsR0KLZzNSUDga4sLzxZb5OlH7RRBQeIZNJ
	HJjNdbxw3od6zH2x+0usdAKg9fP6P0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EEA761141;
	Mon, 27 Apr 2026 11:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90295C2BCB9;
	Mon, 27 Apr 2026 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290409;
	bh=OaO5KdGYprfYoCimmiLBAan7QLFtf0Mly6uHKJpabdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJW2KjwBrkOl8x9aeNLsswKhkOKfZvXCwkMfTfhQge4U7MSIivZUGPVHvJqSmZiZV
	 iVGUhcjrXICYcuTQWTFTPoV+gCjZQm5CWepCJnyLlO067vg3p4HkyzYtGCJSxBsio4
	 m33cdMoooaHfG3VHimYw0l751kbdIOJyd8Lwi9pZGQB8BqqRr59GmPAy3jp0PUQU36
	 WNRCZkFLnLueyOvDXSVo57JjqGoXziCwwC8htSeUtE+Q5Fe0wfh5mI8fEwCb1cxtbr
	 L0b1XLJ9qJQxrhhbGYh7miFR5EYpoVL6oA7bNJmOCx8eXrvm9miCa2FDw/p3X/EMvD
	 V/n2L/7FNDVFg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id AF9C4F4006A;
	Mon, 27 Apr 2026 07:46:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 27 Apr 2026 07:46:47 -0400
X-ME-Sender: <xms:p0zvaUhPkPgCDU1gXNz9F-w-RnAU3MPBZO7lvlSMb1QPxmrZQTxJMA>
    <xme:p0zvaQ-5NtET4OBht3syunOWklsw7WZqtMFt9rJe5YW20PiB5lol0-RIclvf62oIC
    fbdkAys1jMA1q3WLejRgsSXfthzCsDQFv0iFhPIUdFERwPOEpNDfmw>
X-ME-Received: <xmr:p0zvaUmFISPOWj9Cqw-sFEH12MY4D2RReKlaFMEzoWSqAtxB2DCMJPjjNA0Dvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceo
    khgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhudejfedvgeekff
    efvdekheekkeeuveeftdelheegteelgfefveevueekhfdtteenucevlhhushhtvghrufhi
    iigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprg
    huthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhk
    rghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtph
    htthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhn
    uhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhh
    hofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgr
    rdgtohhm
X-ME-Proxy: <xmx:p0zvae1mLbLxu87kAkPCwp2dK53fMt8dAFRlX-dkZ6xDmFg3Yzin-g>
    <xmx:p0zvaZQTEt-g4JCzfkpR6MTq9InYVUDFxB9ptOikeZpQqFau4gSadA>
    <xmx:p0zvaeNfApxljVY8D_Gc_F4NNr2BeVfSEhYfJHAhy-QizaEclGYAFg>
    <xmx:p0zvadjrXR76bTcd-oQ2NVFojZnnL7Yb0S0RoRArlVidwvRQM5I5xA>
    <xmx:p0zvaeKpo2O9DtN-JMgW1EjlZ6nTGGqTa5DDivnVVt2NFPkP8pA-EcoO>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:46:45 -0400 (EDT)
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
Subject: [PATCH 04/14] mm: add VM_UFFD_RWP VMA flag
Date: Mon, 27 Apr 2026 12:45:52 +0100
Message-ID: <20260427114607.4068647-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE96580006
X-Stat-Signature: jefrwoksw9jd41qw89ke118589s39qdh
X-HE-Tag: 1777290410-53311
X-HE-Meta: U2FsdGVkX1+xw8a93TccdylZhO0Fag5ybyiZ4Q+WhVrdoSPayj+JuXgoTMhGX/0TwCssXtwFPIyqssGBfSXZg3GnStoemiheWvRVI1biQ3i/DDkgeIXLXqFSa6J2DjROUrxIVbU1snzafZ5OjZRucM9zeeu1ibK0genSO+0ITzDArVoD2hQCKVvn8cKILJ8yJXuV9PhtL9txz9VUSZKrshNi7C7u/ItE5v4vjGYaXcxUE5DV/dlryZoHu5hCF9pOQMIz0xZr96iVAE3jbI0zJUIHN0ZwgisAR1NIKkl4BA29zK290tqUQYMK2jy4R6PSH7thUpDxcRGFAIpvzxT7u7SpDg5zcJQ5KAO/4+Qc7n8Nm87c/PLjynizX5dz01e9ZhfxZNNRCOPohxo5ug5zD1UHy9V33NN8uIud7ZSciIRnHHOl+hSdICyIO/xKWvVeQWsbsKXZccCf3R7dnt8pDfMGrUbiWq09/Hsxx9xOeCKjMZXzwHe+4rbB/PUf9rWpgtkSiE1Dw5LfRbzgZTq2nNogSDjQU3C4aDLVbAjcaqxcBroOPefxlt5FBanQvEz8BzYPpFldbQl40uptlW5+CPzIzicKsuqMBtr3Lk67zhSW6yU5XLpB8YLsJt44IUuJ2wG8R4nv2jrKTIwvctwaKyrGOmv5Kp2QB1mVX14VtwQfFxXiSDSg0KBknbiTP0bvGJXCurl2GOyQ8nAm64Ujmrnmn3/eM68rQ6vc1lwPvnWBcbqKuERqlw6PgR76tfMv2+5jEbJbS6E8MTdNRt3ayfP6Fqjfq07WHsl6s5MKQ9Ij8DqlNpUFwgUgnpOOZugl2JHt4SqQeKwU4A6yirmBKW4ih0TlBP7/bLM7sJz6SlibK2RkPIa60ZzQpwsEWyRvvOKpxkGxUcsagOu9mykjn2YdPtSBZ+2K8lk+TFVJ0XQuvrMbCgke+JsiGlNKVbOXxJuWKIyIuhwiiW5fnpD
 5QHkzMsB
 RkfM/RHFDkotx1MPTyF1w7pkB4ahbJ1MeSeVI6/h/9NcTbg9420JJHB3xM4G/DpFynCM5bni26BcTnO03Er8peg4XycglZhKxp+Chrp5xODfybgUSjhs2SVwHYzDE1nEifl3VEGOubjz79mmrfootlAgOQEi+gZg8zO8R7j06T2RydjVQ+cmcPFwOXaQuCdlcskDau510irTpTpl2w5gBi9AtiKyPLTpKBGW4B0daaPbH7oJ8l6ZgWKZ4bUuwkM6B677jztjJS7Y8ddvfHX53fSofeTeS7iZmuBydo6jv7+mYJ/mWEZWuJ5G//A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparatory patch for userfaultfd read-write protection (RWP). RWP
extends userfaultfd protection from plain write-protection (WP) to
full read-write protection: accesses to an RWP-protected range --
reads as well as writes -- trap through userfaultfd.

RWP marks ranges by combining PAGE_NONE with the uffd PTE bit, so
the flag is only meaningful when both primitives exist. A new
CONFIG_USERFAULTFD_RWP Kconfig symbol auto-selects when CONFIG_64BIT,
CONFIG_ARCH_HAS_PTE_PROTNONE, and CONFIG_HAVE_ARCH_USERFAULTFD_WP
are all set; call sites that gate on the flag depend on the symbol.
Elsewhere VM_UFFD_RWP aliases VM_NONE and every downstream check
folds to dead code.

Nothing sets the flag yet.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 28 +++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
 include/trace/events/mmflags.h     |  7 +++++++
 mm/Kconfig                         |  9 +++++++++
 6 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index db6167befb7b..db28207c5290 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -607,6 +607,7 @@ encoded manner. The codes are the following:
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ui    userfaultfd minor fault
+    ur    userfaultfd read-write-protect tracking
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5827074962e7..fbaede228201 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1206,6 +1206,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
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
index 0b776907152e..3f53d1e978c0 100644
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
@@ -496,6 +497,11 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
+#else
+#define VM_UFFD_RWP		VM_NONE
+#endif
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -633,22 +639,24 @@ enum {
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
index 98f546e83cd2..fcf308dba311 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR | \
+			 VM_UFFD_RWP)
 
 #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
-				      VMA_UFFD_MINOR_BIT)
+				      VMA_UFFD_MINOR_BIT, VMA_UFFD_RWP_BIT)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -192,7 +193,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR | VM_UFFD_RWP);
 }
 
 /*
@@ -222,6 +223,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_UFFD_MINOR;
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_RWP;
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
@@ -364,6 +375,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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
@@ -457,8 +478,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
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
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..ccf534a8cbc9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1347,6 +1347,15 @@ config HAVE_ARCH_USERFAULTFD_MINOR
 	help
 	  Arch has userfaultfd minor fault support
 
+config USERFAULTFD_RWP
+	def_bool y
+	depends on 64BIT && ARCH_HAS_PTE_PROTNONE && HAVE_ARCH_USERFAULTFD_WP
+	help
+	  Userfaultfd read-write protection (UFFDIO_RWPROTECT) delivers a
+	  userfaultfd notification on every access -- read or write -- to a
+	  protected range, letting userspace observe the working set of a
+	  process.
+
 menuconfig USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	depends on MMU
-- 
2.51.2


