Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EC2CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A8E6B018F; Fri,  8 May 2026 11:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442B76B0191; Fri,  8 May 2026 11:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331816B0192; Fri,  8 May 2026 11:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21D206B018F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA37FA0172
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:21 +0000 (UTC)
X-FDA: 84744704562.02.70C0374
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DB861C0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spO2TB4E;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgWIDEWzrsNWMlC3HL7nSfUHlfAf+FJ1FQfAQcKYdMc=;
	b=kgjXxPYv00MM/qy+WtnphI+pHfwusewc9yiiuWKxXa3XILeFuaSXoIlD7KzQKYSf7tbeks
	2gXkNdzTzGqgN/YPsJj/4ERT4fnVeMV88ophKIdv3IwBK7NlqNAdzmByKBVHeczlkdzQZY
	8BOoHXQZglcKvm7iEQkwaG87RxWBUcU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spO2TB4E;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255779; a=rsa-sha256;
	cv=none;
	b=IN/nf+iHBUnMUTw77rKqzLpL3jvST+Lwa9mPr8kqQBj9APuzGykXMPAXLjb+r9nNszVOu5
	k4ME43tVIKGCxWjlmCWEfd6namZqjulnf903T3PoJSFeSUyi+/iIhUkKy7zSN0kAx4wv3N
	gpqEqddyTEHGW7X4afY1ykArpS7J6KU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AD366024D;
	Fri,  8 May 2026 15:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794BC4AF0B;
	Fri,  8 May 2026 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255779;
	bh=OaO5KdGYprfYoCimmiLBAan7QLFtf0Mly6uHKJpabdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spO2TB4E7ToM3QxcF8XuZqQiw9AMJz1I87cx+Y0DLiXmB3Yg6F6F0IUL+mQUEejKW
	 +f477hgydOGv0nWjqo72Xny5zqA5YPxta4+bvFO+IaLQJbcNns+49JN+6lO8bFufYL
	 d7meapWd2KCNtohDsn2/aZo+/6uapCuxlJ2FhlF5BwbAViKx1UWY/szHoCmb4HFfEa
	 QgSjef/FCPhcW+An4qucHgErDiHJ5a98dbbM1gm+MiYEN2hNA+3WxMD/M2UPI/eDtA
	 4Tq6NFdg23xK8DZE8J3UQ1woa4u8opHbARlC6L+zL+fPrJzoidLBxOEY9vnEhfdQXM
	 lq76Ic/aVHt/g==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id E5638F4006B;
	Fri,  8 May 2026 11:56:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 08 May 2026 11:56:17 -0400
X-ME-Sender: <xms:oQf-aQjJiuNnOgJTWmatCh_R1bHHj3DLC2_6tAvxSH0eiNfzVewcRw>
    <xme:oQf-aU4I0h4-N0mj-ApeeaiufcAfkphM3ESVsZa9bHpHZE5zeiT6cCV_YKj2H3vju
    U_s4IJxp2IjA4UlZoLLiWxQhXRPv1wS8hcDy2TLen6jMweV6aK0aQ>
X-ME-Received: <xmr:oQf-aQ6up5DvDAzY_Lem1wEhDG4vmP3DLptUJTH2KMCyLC97e-hHUts7r5cBHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdujeefvdegke
    fffedvkeehkeekueevfedtleehgeetlefgfeevveeukefhtdetnecuvehluhhsthgvrhfu
    ihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
    gruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedq
    khgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughi
    rgdrtghomh
X-ME-Proxy: <xmx:oQf-aaECdqVkzKWVCfrck4CV6m4V1T3zt_OTLfxZobqnKMTuFW8IVQ>
    <xmx:oQf-aWzWUINKoxYkUFlPpYJlt-qO2Y2M-6dr2BOYz3CdvKnChuas9g>
    <xmx:oQf-aS16kS014pZCc-fllWxfCOC0GoHlnhaA_rCmD95Bpi86y75SQw>
    <xmx:oQf-aROi0xquCpONBZGm7FJ2qmaVwnQs1Vt4QX9Esmw8s-ipNZB6aQ>
    <xmx:oQf-aWtgh5sB0XhQMwsUmfGJfa7KZnxdjcwna0tHltwaVSou26nWYixe>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:16 -0400 (EDT)
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
Subject: [PATCH v2 04/14] mm: add VM_UFFD_RWP VMA flag
Date: Fri,  8 May 2026 16:55:16 +0100
Message-ID: <b47d8d5681fd8730f6090ebfdb72f219a8edef1e.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB861C0002
X-Stat-Signature: zkop6435gtogc76mb69cdeumz8en4tig
X-HE-Tag: 1778255779-706450
X-HE-Meta: U2FsdGVkX19Lax+oo/0c+sIfF1U4zEziCBtTKQrmfw85QwXG4m8l2GeK8tfy7Z7/HNntoD2kxHeeATDBizSkwAVpHPuJiffPqtfuCyfF1sajlZbqsSrTeEyDEn0x5qZlkJTNz2eD6Lp35g0JHN1kg7/w+GXiMzWfPxDmOZm3olmktSj5vz3wk4Fw9dnRafAaRerD7QVXaKX9FM1lNTasU66/tiGI2KCFTnW9gKyxZTXRE8vFjfGVcYFszAbxgmF6Dy3J2K4TpqmW4pY0RNiKiQkJVWaAhBECNN6ZVU3XE9vIMk8zO07tqaQ6RPvbZ/9vA3JvCno0sxYipS811V2N8ZnzH/N/yDzvZafTiRe/dDOxXScSt6aQviXlmSE6EZYRoFMpnclC56kekOMdMiS0RrATXJifAJ85J/rmawyeHBRerG7pPi5k76eZtcjUVl9yMbKh10bLXj4fkBUiSjuwxbuXJVtdN+2yrvC7OXoK5nmIN8U718cY+39EhCQqW2tTUUqriAM4JGrvlrnARQXmaY5hXL+071kNPG61mNBI0dMUeYu6icarX7xw916K/SWEpEiu0aQm6hi759C40DDmT+yT7YRaPrjGIpzB16V8XKQC9E27+ykkDxAgw+MHgUQLsmZ75YTJs+aPzjrnI3/GHC5PC0U5TCLDXxLvQU4fZug4e/+NJ+ijSQqnSrP9ssUBoRNWjTbJnVZT0ZsnM+BatJVWvGwe8qq+LFzTElka+MJc0oB4Ud/6rmn8lqRf0N71cy9Yk67xKlr/KRiD6WpulRFV5cuHwj5zujh8UOJvGHUw/YV9bvTbqSBHiYH3mtioWgQ6DXWzd5qtjVLQdCApIE0ZYEx4Eu1nbRB9n0l7bVbn5T9C39FGExzvBPB83uYCFcPIDWUOS+44/mBv2PSQH6HxuRNBv9P5OY2MO3Ic0qfzXR5BPlupGBwCDgvrUHGyY9U81NGT65EHkmi3yhT
 THDyoAim
 42GAM7hbvugREUBnlbVJ9jDXVkqXDR8v+XjhL9duFbKRzQa+dYpyCygy3dy26hh7Ga4uPCaSRc6J9OKxPhzPmUDX4QHn8/orLtmlZGRrM+xzvplF+TG7mElnunR1yGEpoeVsTzaihxbJNFgDwT3LxEPVIY6pDInJ9ZLh7oOSdF6I6OjZQAlUTLHCX4BevqObLhoGWzYiMmB0anP1sxThJTO15fO2GomPBWmJQZUs9A8O2WiuuYq3qe4LqQTNm8CNUCRnjcXeH9LA4NmnMLe7IICuYH39yATnE6PvMfM1ivPr1KPnxvA9IOrptt5tGtb/uNxtlqLi5larVXbzVcYhys3rDoQ==
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


