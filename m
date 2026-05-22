Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF827CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464536B009D; Fri, 22 May 2026 09:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB236B009E; Fri, 22 May 2026 09:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1589B6B009F; Fri, 22 May 2026 09:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 026056B009D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8C2B8CAC0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:24 +0000 (UTC)
X-FDA: 84795162648.10.7E117D8
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf18.hostedemail.com (Postfix) with ESMTP id B13881C0010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="1 WZTwWO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=fXd3rsOl;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zkzluoKSh1vVnMCrZuyZEWzh9HfyMvX1jib/QCCeO4=;
	b=hZ6QaIcFNdW5YzluxdV8MGbgg+U+6oRYkz78uFjEmt1exepqODMBU1bxqjYAgHi+rBSIw/
	TXW7pni4TObZIUTbyk70rlRwYcyReeLwyz5W00RynzIQOPZ6u7Db6Ci9S/9EajmlqR/tsO
	Up87ouFqMmjEPgRfQzYw3gM8/Nk9x4o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="1 WZTwWO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=fXd3rsOl;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457162; a=rsa-sha256;
	cv=none;
	b=UoBg2nHzh11gZME+RFP23mggT1YJwBtM1N4r0SVj7PAAggoLIxEBT6yWZDWKYosX90bQwM
	92ZDSze6Lj/S+ZA2l0UD3KwY5l/mX+IXq512DJJ2x/04rU3L9som2yit/Y91d1RuV+AutX
	G5YGNODVk5VlfJ37shrC8d0nIr2yBc8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7C37D7A00AA;
	Fri, 22 May 2026 09:39:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 09:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779457161; x=
	1779543561; bh=7zkzluoKSh1vVnMCrZuyZEWzh9HfyMvX1jib/QCCeO4=; b=1
	WZTwWO7mGy1xxI8nRDN7yIJcVVra6RJYq5Dp8G36ax9QJ9kcIj8IQ72r9ITt4Mmv
	WJi3E6rL7/Aoj9af1glY2Pb4UeNox7chpOlIFvBcNxevBZn4/mM6HUaoURMHLl8N
	pbuhPkI7NSK72YwqRV3E7xvRhqVZpjLTmEwqG6WxAmIg5aFNrUOH2UQ96pxysDD/
	xv/u6/2dg+tSSYReNsJnt9VTJCuxFBR9oF1qjCtlJ9uKgYkypD3rNO0GL4wY8144
	VwHG1ZxSlHDMhSDGkRgTJwAEy6MS02ZUT41LeeCkKMcGuLTbsnmlOeInhl20VrHN
	j6BoaG8svhimz0SiHFL9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779457161; x=1779543561; bh=7
	zkzluoKSh1vVnMCrZuyZEWzh9HfyMvX1jib/QCCeO4=; b=fXd3rsOllWvzI46r9
	MKLzyF/BgxU6B0H7YaIx4iE4EPAzA0Xc7JHaX57GyFLl/5Pm3FFxi4gwa3QN2TsW
	6LMlDZPMq3lbo4ix97OEAwh9OyocB8OuV1UQgHPkVX5P1JTgxcPNR+M0nKhnja3a
	6ysd/p8HslOVFkWYJwqP8Zzv4r/Iv1VC+uvA7PqM/nwfIk3fcro57wl4CfGSGSnj
	/YCVo9gZSSxiHDu3bgSqcCy5NOVvVkbiI5FPUfrTMTaWGXqcSzoKCJntGw2jp4K3
	JJAih7TNFRs6e9l7aitzQjECNM+HUKJbtgVnVbG42Yj6HScoKj+UtkYIO2UYZMNm
	2hJJA==
X-ME-Sender: <xms:iVwQasZ1OWP38_xtO8sZVlJBy4WXvIX-Ml1w9XVWsUOz9EVqD_pndg>
    <xme:iVwQaofAfw0s6lYLvlHzRhPVnjo5ydT-r7u0AIJPhm6Axk735QH8CS6ck7vBYE9wC
    ty5mGa9JwWN1o7K_lWOEUR_Of5jKTRbAfqnH0lhasXNxo93kIyGHA>
X-ME-Received: <xmr:iVwQap4YWkvHEGliz_xvYkgKl-76EByuUDNs3uJKukrZOz6ydWEZncManq8YNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeegveehtdfgvdfhudegff
    euuddvgeevjefhveevgefhvdevieevteeivdehjefhjeenucevlhhushhtvghrufhiiigv
    pedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:iVwQakW1_A9d4SWf_ZUPp7PwGL0TTGRM7G9LsQ9AyTkLe8RQRCk2jg>
    <xmx:iVwQagboYemUYQZ1ZqBhpWxh35YpjcddAX2jHSt5IK8vkiYRxKreCA>
    <xmx:iVwQajzH8djE4gTYga_2-MNyutczuEQ0ERcyzluQCGtT7ClZ7LwiBA>
    <xmx:iVwQatIUBnaehM-Lm26NHQDXSVP4nxpZy2MxkY1g_dNR6eyyiwXEoQ>
    <xmx:iVwQauM0S5vTwLcup636jgFibNXSgVDt2xtzQ8U_KO1ShQZ9Sb-uNFFr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:20 -0400 (EDT)
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
Subject: [PATCH v3 04/16] mm: add VM_UFFD_RWP VMA flag
Date: Fri, 22 May 2026 14:38:45 +0100
Message-ID: <20260522133857.552279-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B13881C0010
X-Stat-Signature: sqgi9u3ifwtbf5634p9m6kq3dqpp1yoj
X-HE-Tag: 1779457162-504399
X-HE-Meta: U2FsdGVkX1/dc845sZfvv5ufQ2lAjLsY0j2gRkPjnXcblupu4zpqYbV2FFt+7dSyRiwT+JefHw4N9jqiwRHHRIeuEIEWTzaBrLGaYKSgOv/6+c1EHVNhtHkT/6hLewdk/TwyOmE2xkKJPXUv9sEI4Q/vre784CsuckhmJu9trlDILoZTQszideGztlDmrrKRHJBJvVeuleEBu1OS5qII5dsenO7SkurCfb9qMAHZDWvlDyC+5oie6yy7tsAZlI73t9E4NoQ+fPyswC/nkGcnr/RK740EJE+HRSNQlHpCIhex1r9W4zjVMakiLtSWvWjkNvrtvE8lAIw6HVCNJqtA/Hvo9+TwzKojud04p2opdkKbmPIw9YrIEylacx7QhYvvYdUXr2Xe5kkJfuVi4Rx0byIde6xZvzszAhJwO+VZ0XjNHJ/gaXl3uSzJrNGdObvNk6Sy5vt2fJo9kQVD+YLhDUv2vxPHUrMTX7diQx8E2VPHe14+LpmXcdPhq6F/X92zUgLH0zLMJxN+iAI136DG1icKPUZQk54NfEFZCBIEmbdZpgfT9XWjoEKQejCfXx5O5FC8X67cVJcGLlpF1oR4WpnPw5U1Favt68Vh+qcCCiVO6SHFDjst3oIuAj6YTnDf1wTmbWp4ZBzgeC1eVKMYjciGlclf42VYWBhX1uVn5Q7aQSxNMyrV5H8es5nAGAaX5ZCnOVSkHX6Q6OibkJRVafIpdRqEBq35I3L30LN2iUrxk0HyamSz7uwWD4RzhWZoL9gmCgHDQX5PDtuMHlVaZRTlB0DDFrHxjo5+9ck5kkV+c+70oT0skzZ7gKKfjtaJDHy+I6hT6I/a6p71iqVbVpwffDV+0TMdhCqIsWlvnNhBm+mKc6QzCANY342rVsFXx43Nv/1IhrnPnxZNoO4dC8f0yCMf1uffcYp/GC3yJZGSOAatv0ynVV1FABTryX0LTPJVaU0ZxZpY2lXsQjq
 hYBXOstG
 ypuGN2P+ZErVdLQoM4T3F1LqDFYNDeLeZUlqvd7m8pLWzgmSPInbEWUW9bCLhF/iVNGysH+msBDkLfV2D8t4gfDkIAl/H74QXCEuksLhovzmHtOFT7ZmPGqByYvKk6tNB7ny34WvwBW1F/ji0zisOEMKzhPkOcxqymXXKI0UbAta9D37GDBOCbfMG8QvJ4Qmr5omEd+R1FrpcJqr7GYkogTugzMj3KgVoFRytdPLUXKJx3+CjPWN1r4pgkV/bwvf2dJSmayTO0cGQnPgCuT/UW9dUYn+eqMqwWvNZCDHubqyQ1SfRXOj8yBRi6UJdPxKNV71TpbgSU1Q7Pn9UoIzxB5NBTlQKBcyKHpWv43ZZNAfG1t1pSOEl9zDmuHFTl/ejhDO1nQveBtldIoBeWNVH4CGOtD0qqqZlTKZEySyMFxGZfVtfacNvpxIV9VDadXRZwoVaQVBKOFyszx/cD7V0WNW1PVPzmUP4fGb/T5KPLS8nlWRbGFhNKAOd5A==
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
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 28 ++++++++++++++++---------
 include/linux/userfaultfd_k.h      | 33 ++++++++++++++++++++++++------
 include/trace/events/mmflags.h     |  7 +++++++
 5 files changed, 56 insertions(+), 16 deletions(-)

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
index 98f546e83cd2..889c7b45fec8 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
+			 VM_UFFD_WP | VM_UFFD_RWP)
 
-#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
-				      VMA_UFFD_MINOR_BIT)
+#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_MINOR_BIT, \
+				      VMA_UFFD_WP_BIT, VMA_UFFD_RWP_BIT)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -192,7 +193,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma->vm_flags & (VM_UFFD_MINOR | VM_UFFD_WP | VM_UFFD_RWP);
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
-- 
2.51.2


